# Task 1: Binary and linear search; comparison counts for 100,000 IDs.
def linear_search_ids(a, target):
    count = 0
    for i, value in enumerate(a):
        count += 1
        if value == target:
            return i, count
    return -1, count


def binary_search_ids(a, target):
    low, high, count = 0, len(a) - 1, 0
    while low <= high:
        mid = (low + high) // 2
        count += 1
        if a[mid] == target:
            return mid, count
        if a[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return -1, count


def set2_task1():
    ids = list(range(100_000, 200_000))
    binary_counts = [binary_search_ids(ids, x)[1] for x in ids]
    n = len(ids)
    print("\nSET 2 / TASK 1 - SEARCH")
    print("IDs:", n)
    print("Binary comparisons best/average/worst:",
          min(binary_counts), f"{sum(binary_counts)/n:.2f}", max(binary_counts))
    print("Linear comparisons best/average/worst:", 1, (n + 1) / 2, n)
    for target in (100_000, 150_000, 199_999):
        print(target, "binary:", binary_search_ids(ids, target),
              "linear:", linear_search_ids(ids, target))


# Task 2: Stable insertion sort and merge sort by posting date.
def insertion_sort_statement(rows):
    a = rows.copy()
    for i in range(1, len(a)):
        current, j = a[i], i - 1
        while j >= 0 and a[j]["posted_at"] > current["posted_at"]:
            a[j + 1] = a[j]
            j -= 1
        a[j + 1] = current
    return a


def merge_sort_statement(rows):
    if len(rows) < 2:
        return rows.copy()
    mid = len(rows) // 2
    left, right = merge_sort_statement(rows[:mid]), merge_sort_statement(rows[mid:])
    result, i, j = [], 0, 0
    while i < len(left) and j < len(right):
        if left[i]["posted_at"] <= right[j]["posted_at"]:  # stable tie handling
            result.append(left[i]); i += 1
        else:
            result.append(right[j]); j += 1
    return result + left[i:] + right[j:]


def set2_task2():
    rows = [
        {"transaction_id": "TX-41", "posted_at": datetime(2026, 4, 8, 9, 15), "amount": -18.25},
        {"transaction_id": "TX-42", "posted_at": datetime(2026, 4, 8, 9, 10), "amount": -6.00},
        {"transaction_id": "TX-43", "posted_at": datetime(2026, 4, 8, 9, 15), "amount": 42.00},
        {"transaction_id": "TX-44", "posted_at": datetime(2026, 4, 8, 9, 12), "amount": -12.50},
    ]
    print("\nSET 2 / TASK 2 - STABLE STATEMENT SORT")
    for name, fn in (("Insertion", insertion_sort_statement), ("Merge", merge_sort_statement)):
        result = fn(rows)
        print(name, [(x["transaction_id"], x["posted_at"].strftime("%H:%M")) for x in result])
    print("Stability: TX-41 and TX-43 share a timestamp; stable sorts preserve their input order.")


# Task 3: Same account, amount and merchant within 60 seconds.
def find_duplicate_postings(rows):
    ordered = sorted(rows, key=lambda x: x["posted_at"])
    recent, duplicates = defaultdict(deque), []
    for row in ordered:
        key = (row["account"].strip().casefold(), row["amount"],
               row["merchant"].strip().casefold())
        times = recent[key]
        cutoff = row["posted_at"] - timedelta(seconds=60)
        while times and times[0] < cutoff:
            times.popleft()
        if times:
            duplicates.append(row)
        times.append(row["posted_at"])
    return duplicates


def set2_task3():
    rows = [
        {"id": "P-101", "account": "A-17", "amount": 25.0, "merchant": "Cafe North",
         "posted_at": datetime(2026, 4, 8, 10, 0, 0)},
        {"id": "P-102", "account": "A-17", "amount": 25.0, "merchant": "Cafe North",
         "posted_at": datetime(2026, 4, 8, 10, 0, 45)},
        {"id": "P-103", "account": "A-17", "amount": 25.0, "merchant": "Cafe North",
         "posted_at": datetime(2026, 4, 8, 10, 2, 0)},
        {"id": "P-104", "account": "A-20", "amount": 25.0, "merchant": "Cafe North",
         "posted_at": datetime(2026, 4, 8, 10, 0, 30)},
    ]
    found = find_duplicate_postings(rows)
    print("\nSET 2 / TASK 3 - DUPLICATE POSTINGS")
    print("Duplicates:", [x["id"] for x in found])
    print("Time: O(n log n) including sorting; expected O(1) hash/deque updates per row.")
    print("Space: O(n).")


# Task 4: Own FIFO queue and LIFO stack, then built-in equivalents.
class Node:
    def __init__(self, value):
        self.value, self.next = value, None


class ReviewQueue:
    def __init__(self):
        self.head = self.tail = None

    def enqueue(self, value):
        node = Node(value)
        if self.tail:
            self.tail.next = node
        else:
            self.head = node
        self.tail = node

    def dequeue(self):
        if self.head is None:
            raise IndexError("dequeue from empty queue")
        value = self.head.value
        self.head = self.head.next
        if self.head is None:
            self.tail = None
        return value


class AdjustmentStack:
    def __init__(self):
        self.items = []

    def push(self, value):
        self.items.append(value)

    def pop(self):
        if not self.items:
            raise IndexError("pop from empty stack")
        return self.items.pop()


def set2_task4():
    q = ReviewQueue()
    q.enqueue("CASE-601"); q.enqueue("CASE-602")
    s = AdjustmentStack()
    s.push("TX-81 fee corrected"); s.push("TX-93 merchant label fixed")
    builtin_q = deque(["CASE-601", "CASE-602"])
    builtin_s = ["TX-81 fee corrected", "TX-93 merchant label fixed"]
    print("\nSET 2 / TASK 4 - QUEUE AND STACK")
    print("Custom queue FIFO:", q.dequeue(), "| built-in deque:", builtin_q.popleft())
    print("Custom stack LIFO:", s.pop(), "| built-in list:", builtin_s.pop())


# Task 5: Divide-and-conquer min/max compared with brute-force scan.
def brute_min_max(values):
    if not values:
        raise ValueError("amount list must not be empty")
    low = high = values[0]
    for x in values[1:]:
        if x < low: low = x
        if x > high: high = x
    return low, high


def divide_min_max(values):
    if not values:
        raise ValueError("amount list must not be empty")

    def solve(left, right):
        if left == right:
            return values[left], values[left]
        if right == left + 1:
            return min(values[left], values[right]), max(values[left], values[right])
        mid = (left + right) // 2
        lo1, hi1 = solve(left, mid)
        lo2, hi2 = solve(mid + 1, right)
        return min(lo1, lo2), max(hi1, hi2)

    return solve(0, len(values) - 1)


def set2_task5():
    amounts = [84.50, -12.00, 39.95, 120.00, 7.25, -3.50]
    print("\nSET 2 / TASK 5 - MINIMUM AND MAXIMUM")
    print("Brute force:", brute_min_max(amounts))
    print("Divide and conquer:", divide_min_max(amounts))
    print("Both methods are O(n); recursion uses O(log n) stack space.")
