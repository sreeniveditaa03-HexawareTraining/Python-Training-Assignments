def set2_task1_claim_bst():
    print("\nSET 2 - TASK 1: CLAIM ID BST")
    claim_ids = [508, 302, 701, 205, 410, 610, 805]
    tree = BinarySearchTree()
    for claim_id in claim_ids:
        tree.insert(claim_id)

    print("Inserted claim IDs:", claim_ids)
    print("Search 410:", tree.search(410))
    print("Search 999:", tree.search(999))
    print("Inorder:", tree.inorder())
    print("Preorder:", tree.preorder())
    print("Postorder:", tree.postorder())
    print("Inorder traversal gives sorted claim IDs.")
    print("Empty-tree test - search:", BinarySearchTree().search(1))


# Task 2: Normalize policy/date values to catch case and spacing differences.
def normalize_policy(policy):
    return "".join(policy.split()).casefold()


def find_duplicate_claims(claims):
    seen = {}
    duplicates = []

    for claim in claims:
        key = (normalize_policy(claim["policy"]), claim["incident_date"])
        if key in seen:
            duplicates.append((seen[key], claim))
        else:
            seen[key] = claim
    return duplicates


def set2_task2_claim_hashing():
    print("\nSET 2 - TASK 2: DUPLICATE / NEAR-DUPLICATE CLAIMS")
    claims = [
        {"claim_id": "C101", "policy": "POL 88 A", "incident_date": "2026-04-10"},
        {"claim_id": "C102", "policy": "pol88a", "incident_date": "2026-04-10"},
        {"claim_id": "C103", "policy": "POL-88-A", "incident_date": "2026-04-10"},
        {"claim_id": "C104", "policy": "POL 88 A", "incident_date": "2026-04-11"},
    ]
    # The task says spacing and letter case differ. Hyphens are meaningful here,
    # so C103 is not normalized into the same policy number.
    duplicates = find_duplicate_claims(claims)
    print("Duplicate claim pairs:",
          [(first["claim_id"], second["claim_id"]) for first, second in duplicates])
    print("Empty-input test:", find_duplicate_claims([]))
    print("Hash collisions are handled by Python dictionaries using equality checks")
    print("after hashing; different keys can share a hash without being treated as equal.")
    print("Expected time O(n), space O(n).")


# Task 3: Claim approval graph, BFS shortest path and DFS cycle detection.
def shortest_path_bfs(graph, start, destination):
    if start not in graph or destination not in graph:
        return None
    queue = deque([start])
    parent = {start: None}

    while queue:
        node = queue.popleft()
        if node == destination:
            path = []
            while node is not None:
                path.append(node)
                node = parent[node]
            return list(reversed(path))

        for neighbour in graph.get(node, []):
            if neighbour not in parent:
                parent[neighbour] = node
                queue.append(neighbour)
    return None


def has_cycle_directed(graph):
    return has_directed_cycle(graph)


def set2_task3_claim_graph():
    print("\nSET 2 - TASK 3: CLAIM APPROVAL GRAPH")
    stages = {
        "registration": ["assessment"],
        "assessment": ["surveyor", "settlement"],
        "surveyor": ["settlement"],
        "settlement": [],
    }
    print("Approval graph:", stages)
    print("Shortest path registration -> settlement:",
          shortest_path_bfs(stages, "registration", "settlement"))
    print("Loop detected in approval graph:", has_cycle_directed(stages))

    loop_graph = {
        "registration": ["assessment"],
        "assessment": ["surveyor"],
        "surveyor": ["registration"],
        "settlement": [],
    }
    print("Loop test graph:", loop_graph)
    print("Loop detected in test graph:", has_cycle_directed(loop_graph))
    print("BFS shortest path and DFS cycle detection: O(V + E).")


# Task 4: Longest consecutive run of days with claims > 100.
def longest_run_over_threshold(daily_claims, threshold=100):
    best_length = current_length = 0
    best_start = current_start = None

    for day, count in daily_claims:
        if count > threshold:
            if current_length == 0:
                current_start = day
            current_length += 1
            if current_length > best_length:
                best_length = current_length
                best_start = current_start
        else:
            current_length = 0
            current_start = None

    return best_start, best_length


def set2_task4_sliding_window():
    print("\nSET 2 - TASK 4: LONGEST RUN OF DAYS WITH CLAIMS ABOVE 100")
    daily = [
        ("2026-04-01", 95),
        ("2026-04-02", 112),
        ("2026-04-03", 125),
        ("2026-04-04", 140),
        ("2026-04-05", 98),
        ("2026-04-06", 118),
        ("2026-04-07", 130),
        ("2026-04-08", 145),
        ("2026-04-09", 151),
    ]
    start, length = longest_run_over_threshold(daily, 100)
    print("Daily claim counts:", daily)
    print("Longest run starts:", start)
    print("Number of consecutive days above 100:", length)
    print("Complexity: O(n) time and O(1) extra space.")


# Task 5: Merge two sorted regional lists without sorting again.
def merge_sorted_lists(first, second):
    i = j = 0
    merged = []

    while i < len(first) and j < len(second):
        if first[i] <= second[j]:
            merged.append(first[i])
            i += 1
        else:
            merged.append(second[j])
            j += 1

    merged.extend(first[i:])
    merged.extend(second[j:])
    return merged


def set2_task5_merge_claim_lists():
    print("\nSET 2 - TASK 5: MERGE TWO SORTED REGIONAL CLAIM LISTS")
    north = [101, 104, 108, 115, 120]
    south = [99, 103, 109, 117, 125]
    print("North office:", north)
    print("South office:", south)
    print("Merged sorted list:", merge_sorted_lists(north, south))
    print("Empty-list test:", merge_sorted_lists([], south))
    print("Complexity: O(n + m) time and O(n + m) output space.")


def run_set2():
    print("\n" + "=" * 78 + "\nSET 2 - INSURANCE CLAIMS PROCESSING\n" + "=" * 78)
    set2_task1_claim_bst()
    set2_task2_claim_hashing()
    set2_task3_claim_graph()
    set2_task4_sliding_window()
    set2_task5_merge_claim_lists()

    print("\nSET 2 COMPLEXITY SUMMARY")
    print("- BST insert/search: average O(log n), worst O(n); traversals O(n).")
    print("- Duplicate detection with hash map: expected O(n) time, O(n) space.")
    print("- BFS shortest path / DFS cycle detection: O(V + E).")
    print("- Longest consecutive run: O(n) time, O(1) extra space.")
    print("- Merge two sorted lists: O(n + m) time, O(n + m) output space.")
