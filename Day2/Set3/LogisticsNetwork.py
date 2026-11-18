def set3_task1_hub_bst():
    print("\nSET 3 - TASK 1: HUB CODE BST AND TREE HEIGHT")
    insertion_order = ["H50", "H30", "H70", "H20", "H40", "H60", "H80"]
    tree = BinarySearchTree()
    for hub in insertion_order:
        tree.insert(hub)

    print("Insertion order:", insertion_order)
    print("Search H60:", tree.search("H60"))
    print("Search H99:", tree.search("H99"))
    print("Inorder:", tree.inorder())
    print("Tree height (nodes):", tree.height())

    sorted_tree = BinarySearchTree()
    sorted_input = ["H10", "H20", "H30", "H40", "H50", "H60", "H70"]
    for hub in sorted_input:
        sorted_tree.insert(hub)
    print("Height after sorted insertion:", sorted_tree.height())
    print("Sorted input creates a skewed tree; height can become n,")
    print("making insert/search O(n) instead of O(log n).")


# Task 2: Tracking lookup and duplicate scan at the same hub.
def find_same_hub_rescans(scans):
    seen = set()
    duplicates = []
    for scan in scans:
        key = (scan["tracking_number"], scan["hub"])
        if key in seen:
            duplicates.append(scan)
        else:
            seen.add(key)
    return duplicates


def set3_task2_tracking_hashmap():
    print("\nSET 3 - TASK 2: PARCEL TRACKING HASH MAP")
    parcels = {
        "TRK1001": {"destination": "Chennai", "status": "In Transit"},
        "TRK1002": {"destination": "Mumbai", "status": "At Hub"},
        "TRK1003": {"destination": "Delhi", "status": "Out for Delivery"},
    }
    print("Tracking lookup TRK1002:", parcels.get("TRK1002"))
    print("Unknown tracking number:", parcels.get("TRK9999"))

    scans = [
        {"tracking_number": "TRK1001", "hub": "H01", "time": "09:00"},
        {"tracking_number": "TRK1002", "hub": "H01", "time": "09:05"},
        {"tracking_number": "TRK1001", "hub": "H01", "time": "09:12"},
        {"tracking_number": "TRK1001", "hub": "H02", "time": "10:00"},
    ]
    print("Repeated scans at same hub:", find_same_hub_rescans(scans))
    print("Expected lookup/detection time O(1) per operation; O(n) total, O(n) space.")


# Task 3: Ten hubs, adjacency list, BFS fewest hops, DFS reachability.
def bfs_shortest_hub_route(graph, start, destination):
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


def dfs_reachable(graph, start):
    visited, order = set(), []

    def visit(node):
        visited.add(node)
        order.append(node)
        for neighbour in graph.get(node, []):
            if neighbour not in visited:
                visit(neighbour)

    if start in graph:
        visit(start)
    return order


def set3_task3_logistics_graph():
    print("\nSET 3 - TASK 3: TEN-HUB LOGISTICS NETWORK")
    routes = {
        "H01": ["H02", "H03"],
        "H02": ["H01", "H04", "H05"],
        "H03": ["H01", "H06"],
        "H04": ["H02", "H07"],
        "H05": ["H02", "H08"],
        "H06": ["H03", "H09"],
        "H07": ["H04", "H10"],
        "H08": ["H05", "H10"],
        "H09": ["H06", "H10"],
        "H10": ["H07", "H08", "H09"],
    }
    print("Adjacency list:")
    for hub, neighbours in routes.items():
        print(f"  {hub}: {neighbours}")
    print("Fewest-hop route H01 -> H10:", bfs_shortest_hub_route(routes, "H01", "H10"))
    print("Hubs reachable from central depot H01 (DFS):", dfs_reachable(routes, "H01"))
    print("Complexity: O(V + E) for BFS and DFS.")


# Task 4: Sliding window highest average for four consecutive hours.
def highest_average_window(values, window_size):
    start, end, total = max_sum_window(values, window_size)
    return start, end, total / window_size, total


def set3_task4_parcel_window():
    print("\nSET 3 - TASK 4: HIGHEST-AVERAGE FOUR-HOUR WINDOW")
    hourly_parcels = [
        40, 45, 50, 55, 60, 75, 90, 110,
        130, 150, 145, 140, 135, 125, 115, 105,
        95, 85, 80, 70, 65, 60, 55, 50
    ]
    start, end, average, total = highest_average_window(hourly_parcels, 4)
    print("Hourly parcel counts:", hourly_parcels)
    print(f"Best window: hour {start:02d}:00 to {end + 1:02d}:00")
    print("Total parcels:", total)
    print("Average parcels per hour:", average)
    print("Complexity: O(n) time and O(1) extra space.")


# Task 5: Palindrome route description, ignoring case and separators.
def is_hub_route_palindrome(route):
    # Treat each hub code as one token; ignore arrows, spaces and punctuation.
    import re
    hubs = [token.casefold() for token in re.findall(r"[A-Za-z0-9]+", route)]
    left, right = 0, len(hubs) - 1

    while left < right:
        if hubs[left] != hubs[right]:
            return False
        left += 1
        right -= 1
    return True


def set3_task5_route_palindrome():
    print("\nSET 3 - TASK 5: PALINDROME DELIVERY ROUTE")
    route1 = "H01 -> H02 -> H01"
    route2 = "H01 -> H02 -> H03"
    print("Route:", route1, "| palindrome:", is_hub_route_palindrome(route1))
    print("Route:", route2, "| palindrome:", is_hub_route_palindrome(route2))
    print("Comparison ignores case and separators; O(n) time, O(n) space for normalization.")


def run_set3():
    print("\n" + "=" * 78 + "\nSET 3 - LOGISTICS NETWORK AND DELIVERY WINDOWS\n" + "=" * 78)
    set3_task1_hub_bst()
    set3_task2_tracking_hashmap()
    set3_task3_logistics_graph()
    set3_task4_parcel_window()
    set3_task5_route_palindrome()

    print("\nSET 3 ALGORITHM SUMMARY")
    print("- Hub BST: average O(log n), worst O(n); height depends on insertion order.")
    print("- Tracking hash map / scan set: expected O(1) per lookup, O(n) space.")
    print("- BFS shortest route and DFS reachability: O(V + E).")
    print("- Four-hour sliding window: O(n) time, O(1) extra space.")
    print("- Two-pointer palindrome check: O(n) time.")
