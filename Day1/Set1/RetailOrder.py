import csv
import random
import time
from collections import deque
from copy import deepcopy
from datetime import datetime

# -------------------- CSV LOADING --------------------

def load_orders(filename):
    orders = []
    with open(filename, "r", newline="", encoding="utf-8") as file:
        reader = csv.DictReader(file)
        for row in reader:
            orders.append({
                "orderId": row["orderId"],
                "customerId": row["customerId"],
                "amount": float(row["amount"]),
                "createdAt": datetime.strptime(row["createdAt"], "%Y-%m-%d %H:%M:%S")
            })
    return orders

# -------------------- TASK 1: LINEAR AND BINARY SEARCH --------------------

def linear_search(orders, target_id):
    for order in orders:
        if order["orderId"] == target_id:
            return order
    return None

def binary_search(sorted_orders, target_id):
    low, high = 0, len(sorted_orders) - 1
    while low <= high:
        mid = (low + high) // 2
        current_id = sorted_orders[mid]["orderId"]

        if current_id == target_id:
            return sorted_orders[mid]
        elif current_id < target_id:
            low = mid + 1
        else:
            high = mid - 1
    return None

def benchmark_search(orders):
    target = "O49999"
    sorted_orders = sorted(orders, key=lambda item: item["orderId"])

    start = time.perf_counter()
    linear_result = linear_search(orders, target)
    linear_time = time.perf_counter() - start

    start = time.perf_counter()
    binary_result = binary_search(sorted_orders, target)
    binary_time = time.perf_counter() - start

    print("\nTASK 1 - SEARCH")
    print("Target order:", target)
    print("Linear search result:", linear_result)
    print(f"Linear search time: {linear_time:.8f} seconds")
    print("Binary search result:", binary_result)
    print(f"Binary search time: {binary_time:.8f} seconds")
    print("Note: Binary search requires the data to be sorted by orderId first.")

# -------------------- TASK 2: SORTING --------------------

def selection_sort_descending(orders):
    """O(n^2) selection sort: highest amount is placed first."""
    arr = orders.copy()
    n = len(arr)

    for i in range(n):
        max_index = i
        for j in range(i + 1, n):
            if arr[j]["amount"] > arr[max_index]["amount"]:
                max_index = j
        arr[i], arr[max_index] = arr[max_index], arr[i]

    return arr


def merge_sort_descending(orders):
    """O(n log n) merge sort."""
    if len(orders) <= 1:
        return orders.copy()

    mid = len(orders) // 2
    left = merge_sort_descending(orders[:mid])
    right = merge_sort_descending(orders[mid:])

    merged = []
    i = j = 0

    while i < len(left) and j < len(right):
        if left[i]["amount"] >= right[j]["amount"]:
            merged.append(left[i])
            i += 1
        else:
            merged.append(right[j])
            j += 1

    merged.extend(left[i:])
    merged.extend(right[j:])
    return merged


def benchmark_sorting(orders):
    # 10,000 records as required by the task.
    sample = orders[:10000]

    print("\nTASK 2 - SORTING (10,000 records)")

    start = time.perf_counter()
    selection_result = selection_sort_descending(sample)
    selection_time = time.perf_counter() - start

    start = time.perf_counter()
    merge_result = merge_sort_descending(sample)
    merge_time = time.perf_counter() - start

    start = time.perf_counter()
    builtin_result = sorted(sample, key=lambda item: item["amount"], reverse=True)
    builtin_time = time.perf_counter() - start

    # Check that all three methods produce the same amount order.
    selection_ok = [x["amount"] for x in selection_result] == [x["amount"] for x in builtin_result]
    merge_ok = [x["amount"] for x in merge_result] == [x["amount"] for x in builtin_result]

    print(f"Selection sort (O(n^2)): {selection_time:.6f} seconds")
    print(f"Merge sort (O(n log n)): {merge_time:.6f} seconds")
    print(f"Python built-in sorted(): {builtin_time:.6f} seconds")
    print("Selection sort matches built-in:", selection_ok)
    print("Merge sort matches built-in:", merge_ok)
    print("Top 5 orders by amount:")
    for order in builtin_result[:5]:
        print(order["orderId"], "Rs.", f'{order["amount"]:.2f}')


def show_first_three_passes():
    """Illustrates the first three outer passes of selection sort."""
    values = [450, 120, 700, 300, 900]
    print("\nSELECTION SORT TRACE - DESCENDING")
    print("Initial:", values)

    for i in range(3):
        max_index = i
        for j in range(i + 1, len(values)):
            if values[j] > values[max_index]:
                max_index = j
        values[i], values[max_index] = values[max_index], values[i]
        print(f"After pass {i + 1}:", values)

# -------------------- TASK 3: DUPLICATE DETECTION --------------------

def find_duplicate_orders(orders):
    """
    Same customerId + same amount + same calendar minute.
    A dictionary/set gives average O(1) lookup per order.
    """
    seen = {}
    duplicates = []

    for order in orders:
        minute_key = order["createdAt"].strftime("%Y-%m-%d %H:%M")
        key = (order["customerId"], order["amount"], minute_key)

        if key in seen:
            duplicates.append((seen[key]["orderId"], order["orderId"], key))
        else:
            seen[key] = order

    return duplicates


def run_duplicate_detection(orders):
    duplicates = find_duplicate_orders(orders)
    print("\nTASK 3 - DUPLICATE DETECTION")
    print("Duplicate pairs found:", len(duplicates))
    for first_id, second_id, key in duplicates[:10]:
        print(f"{first_id} and {second_id} -> customer={key[0]}, amount=Rs.{key[1]:.2f}, minute={key[2]}")
    print("Average time complexity: O(n)")
    print("Space complexity: O(n)")


# -------------------- TASK 4: CUSTOM STACK AND QUEUE --------------------

class CustomStack:
    def __init__(self):
        self.items = []

    def push(self, item):
        self.items.append(item)

    def pop(self):
        if not self.items:
            return None
        return self.items.pop()

    def is_empty(self):
        return len(self.items) == 0


class CustomQueue:
    def __init__(self):
        self.items = []

    def enqueue(self, item):
        self.items.append(item)

    def dequeue(self):
        if not self.items:
            return None
        return self.items.pop(0)

    def is_empty(self):
        return len(self.items) == 0


def run_stack_queue_demo(orders):
    print("\nTASK 4 - STACK AND QUEUE")

    # Stack: save edits so the latest edit can be undone first.
    custom_stack = CustomStack()
    custom_stack.push({"orderId": "O00010", "old_amount": 500, "new_amount": 600})
    custom_stack.push({"orderId": "O00011", "old_amount": 750, "new_amount": 800})
    print("Custom stack - undo last edit:", custom_stack.pop())

    builtin_stack = []
    builtin_stack.append("Edit O00010")
    builtin_stack.append("Edit O00011")
    print("Built-in list stack - undo last edit:", builtin_stack.pop())

    # Queue: first order added is dispatched first (FIFO).
    custom_queue = CustomQueue()
    for order_id in ["O00001", "O00002", "O00003"]:
        custom_queue.enqueue(order_id)
    print("Custom queue - next dispatch:", custom_queue.dequeue())

    builtin_queue = deque(["O00001", "O00002", "O00003"])
    print("Built-in deque - next dispatch:", builtin_queue.popleft())

    print("Comparison: list append/pop is suitable for a stack (O(1) amortized).")
    print("For a queue, deque append/popleft is O(1); list pop(0) is O(n).")


# -------------------- TASK 5: GREEDY AND DYNAMIC PROGRAMMING --------------------

def greedy_change(amount, denominations):
    """Returns a greedy choice; denominations should be in descending order."""
    remaining = amount
    result = []

    for coin in sorted(denominations, reverse=True):
        count = remaining // coin
        if count:
            result.extend([coin] * count)
            remaining -= coin * count

    if remaining != 0:
        return None  # Exact amount cannot be formed with these denominations.
    return result


def dp_change(amount, denominations):
    """Minimum-coin change using bottom-up dynamic programming."""
    infinity = amount + 1
    dp = [infinity] * (amount + 1)
    previous_coin = [None] * (amount + 1)
    dp[0] = 0

    for value in range(1, amount + 1):
        for coin in denominations:
            if coin <= value and dp[value - coin] + 1 < dp[value]:
                dp[value] = dp[value - coin] + 1
                previous_coin[value] = coin

    if dp[amount] == infinity:
        return None

    result = []
    current = amount
    while current > 0:
        coin = previous_coin[current]
        result.append(coin)
        current -= coin

    return result


def run_change_demo():
    print("\nTASK 5 - REFUND CHANGE")

    # Example where greedy works for common Indian denominations.
    refund = 289
    indian_denominations = [200, 100, 50, 20, 10, 5, 2, 1]
    greedy_result = greedy_change(refund, indian_denominations)
    print(f"Refund Rs.{refund}: greedy coins/notes =", greedy_result)
    print("Number of notes/coins:", len(greedy_result))

    # Counterexample: greedy fails for denominations [4, 3, 1] and amount 6.
    denominations = [4, 3, 1]
    amount = 6
    greedy_result = greedy_change(amount, denominations)
    optimal_result = dp_change(amount, denominations)

    print("\nGreedy failure example:")
    print("Denominations:", denominations, "Amount:", amount)
    print("Greedy result:", greedy_result, "Count:", len(greedy_result))
    print("DP optimal result:", optimal_result, "Count:", len(optimal_result))


# -------------------- MAIN --------------------

def main():
    filename = "orders.csv"
    try:
        orders = load_orders(filename)
    except FileNotFoundError:
        print(f"Error: {filename} not found. Keep it in the same folder as this Python file.")
        return

    print("RETAIL ORDER DESK")
    print("Total orders loaded:", len(orders))

    benchmark_search(orders)
    show_first_three_passes()
    benchmark_sorting(orders)
    run_duplicate_detection(orders)
    run_stack_queue_demo(orders)
    run_change_demo()


if __name__ == "__main__":
    main()
