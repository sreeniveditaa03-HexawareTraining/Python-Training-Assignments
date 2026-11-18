# Task 1: Search 20,000 patient records; time 1,000 lookups.
def linear_patient_search(rows, target):
    for row in rows:
        if row["patient_id"] == target:
            return row
    return None


def binary_patient_search(rows, target):
    low, high = 0, len(rows) - 1
    while low <= high:
        mid = (low + high) // 2
        value = rows[mid]["patient_id"]
        if value == target: return rows[mid]
        if value < target: low = mid + 1
        else: high = mid - 1
    return None


def average_ms(fn, rows, target, repeats=1000):
    start = perf_counter()
    for _ in range(repeats):
        fn(rows, target)
    return (perf_counter() - start) * 1000 / repeats


def set3_task1():
    patients = [{"patient_id": f"P{i:05d}", "name": f"Patient {i}"} for i in range(20_000)]
    target = patients[-1]["patient_id"]
    print("\nSET 3 / TASK 1 - PATIENT SEARCH")
    print("Records:", len(patients), "| lookups per method: 1000 | target:", target)
    print("Results agree:",
          linear_patient_search(patients, target) == binary_patient_search(patients, target))
    print(f"Linear average: {average_ms(linear_patient_search, patients, target):.6f} ms")
    print(f"Binary average: {average_ms(binary_patient_search, patients, target):.6f} ms")
    print("Timings vary by computer and Python environment.")


# Task 2: Selection sort and quick sort by urgency then arrival; count swaps.
def appt_key(item):
    return item["urgency"], item["arrival"]  # lower urgency number is higher priority


def selection_sort_appointments(rows):
    a, swaps = rows.copy(), 0
    for i in range(len(a) - 1):
        best = i
        for j in range(i + 1, len(a)):
            if appt_key(a[j]) < appt_key(a[best]):
                best = j
        if best != i:
            a[i], a[best] = a[best], a[i]
            swaps += 1
    return a, swaps


def quick_sort_appointments(rows):
    a, swaps = rows.copy(), 0

    def partition(low, high):
        nonlocal swaps
        pivot, boundary = appt_key(a[high]), low
        for scan in range(low, high):
            if appt_key(a[scan]) <= pivot:
                if boundary != scan:
                    a[boundary], a[scan] = a[scan], a[boundary]
                    swaps += 1
                boundary += 1
        if boundary != high:
            a[boundary], a[high] = a[high], a[boundary]
            swaps += 1
        return boundary

    def sort(low, high):
        if low < high:
            p = partition(low, high)
            sort(low, p - 1)
            sort(p + 1, high)

    sort(0, len(a) - 1)
    return a, swaps


def set3_task2():
    rows = [
        {"patient": "Mira", "urgency": 2, "arrival": datetime(2026, 5, 4, 9, 10)},
        {"patient": "Dev", "urgency": 1, "arrival": datetime(2026, 5, 4, 9, 25)},
        {"patient": "Ira", "urgency": 1, "arrival": datetime(2026, 5, 4, 9, 5)},
        {"patient": "Noah", "urgency": 3, "arrival": datetime(2026, 5, 4, 9, 0)},
    ]
    print("\nSET 3 / TASK 2 - APPOINTMENT SORT")
    for name, fn in (("Selection", selection_sort_appointments), ("Quick", quick_sort_appointments)):
        start = perf_counter()
        ordered, swaps = fn(rows)
        elapsed = perf_counter() - start
        print(name, "order:",
              [(x["patient"], x["urgency"], x["arrival"].strftime("%H:%M")) for x in ordered])
        print(name, "swaps:", swaps, "| time:", f"{elapsed:.8f} seconds")


# Task 3: Hash set detects repeated patient + slot combinations.
def find_double_bookings(rows):
    seen, conflicts = set(), []
    for row in rows:
        key = (row["patient_id"].strip().casefold(), row["slot"].strip().casefold())
        if key in seen:
            conflicts.append(row)
        else:
            seen.add(key)
    return conflicts


def set3_task3():
    rows = [
        {"patient_id": "PT-204", "slot": "2026-05-04 10:30 Dr Lee"},
        {"patient_id": "PT-981", "slot": "2026-05-04 10:30 Dr Lee"},
        {"patient_id": "PT-204", "slot": "2026-05-04 10:30 Dr Lee"},
        {"patient_id": "PT-204", "slot": "2026-05-04 11:00 Dr Lee"},
    ]
    print("\nSET 3 / TASK 3 - DOUBLE BOOKINGS")
    print("Conflicts:", find_double_bookings(rows))
    print("Hash-set expected time O(n), space O(n); list scanning can take O(n^2).")


# Task 4: From-scratch linked FIFO queue and LIFO stack.
class WalkInQueue:
    def __init__(self):
        self.head = self.tail = None

    def enqueue(self, value):
        node = Node(value)
        if self.tail: self.tail.next = node
        else: self.head = node
        self.tail = node

    def dequeue(self):
        if self.head is None: raise IndexError("queue is empty")
        value = self.head.value
        self.head = self.head.next
        if self.head is None: self.tail = None
        return value


class ViewedPatientStack:
    def __init__(self):
        self.top = None

    def push(self, value):
        node = Node(value)
        node.next = self.top
        self.top = node

    def pop(self):
        if self.top is None: raise IndexError("stack is empty")
        value = self.top.value
        self.top = self.top.next
        return value


def set3_task4():
    q = WalkInQueue()
    q.enqueue("TOKEN-31"); q.enqueue("TOKEN-32")
    s = ViewedPatientStack()
    s.push("PATIENT-204"); s.push("PATIENT-981")
    print("\nSET 3 / TASK 4 - WALK-IN QUEUE AND VIEWED STACK")
    print("Next walk-in token (FIFO):", q.dequeue())
    print("Most recently viewed patient (LIFO):", s.pop())


# Task 5: DP maximum non-overlapping appointments vs shortest-duration greedy.
def maximum_appointments_dp(items):
    jobs = sorted(items, key=lambda x: x["end"])
    ends = [x["end"] for x in jobs]
    previous = [bisect_right(ends, job["start"], 0, i) for i, job in enumerate(jobs)]
    dp = [0] * (len(jobs) + 1)

    for i, job in enumerate(jobs, start=1):
        include = 1 + dp[previous[i - 1]]
        exclude = dp[i - 1]
        dp[i] = max(include, exclude)

    chosen, i = [], len(jobs)
    while i > 0:
        j = i - 1
        if 1 + dp[previous[j]] > dp[i - 1]:
            chosen.append(jobs[j])
            i = previous[j]
        else:
            i -= 1
    return list(reversed(chosen))


def greedy_shortest_duration(items):
    chosen, end_time = [], float("-inf")
    for job in sorted(items, key=lambda x: (x["end"] - x["start"], x["end"])):
        if job["start"] >= end_time:
            chosen.append(job)
            end_time = job["end"]
    return chosen


def set3_task5():
    jobs = [
        {"id": "A", "start": 0, "end": 4},
        {"id": "B", "start": 3, "end": 5},
        {"id": "C", "start": 4, "end": 7},
        {"id": "D", "start": 5, "end": 9},
        {"id": "E", "start": 7, "end": 10},
    ]
    dp_result = maximum_appointments_dp(jobs)
    greedy_result = greedy_shortest_duration(jobs)
    print("\nSET 3 / TASK 5 - SHIFT PLANNING")
    print("DP schedule:", [x["id"] for x in dp_result], "count:", len(dp_result))
    print("Shortest-first greedy:", [x["id"] for x in greedy_result],
          "count:", len(greedy_result))
    print("DP time: O(n log n); space: O(n). DP guarantees the maximum count.")


def main():
    print("=" * 65, "\nDAY 1 - COMBINED SET 2 AND SET 3 SOLUTIONS\n", "=" * 65)
    set2_task1()
    set2_task2()
    set2_task3()
    set2_task4()
    set2_task5()
    print("\n" + "=" * 65 + "\nSET 3\n" + "=" * 65)
    set3_task1()
    set3_task2()
    set3_task3()
    set3_task4()
    set3_task5()
    print("\nAll Set 2 and Set 3 tasks executed successfully.")


if __name__ == "__main__":
    main()
