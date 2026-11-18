from collections import deque, defaultdict
from time import perf_counter


# ============================================================================
# COMMON DATA STRUCTURE: BINARY SEARCH TREE
# ============================================================================

class BSTNode:
    def __init__(self, key):
        self.key = key
        self.left = None
        self.right = None


class BinarySearchTree:
    def __init__(self):
        self.root = None

    def insert(self, key):
        """Insert a key. Duplicate keys are ignored."""
        if self.root is None:
            self.root = BSTNode(key)
            return

        current = self.root
        while True:
            if key == current.key:
                return
            if key < current.key:
                if current.left is None:
                    current.left = BSTNode(key)
                    return
                current = current.left
            else:
                if current.right is None:
                    current.right = BSTNode(key)
                    return
                current = current.right

    def search(self, key):
        current = self.root
        while current is not None:
            if key == current.key:
                return True
            current = current.left if key < current.key else current.right
        return False

    def inorder(self):
        result = []

        def visit(node):
            if node:
                visit(node.left)
                result.append(node.key)
                visit(node.right)

        visit(self.root)
        return result

    def preorder(self):
        result = []

        def visit(node):
            if node:
                result.append(node.key)
                visit(node.left)
                visit(node.right)

        visit(self.root)
        return result

    def postorder(self):
        result = []

        def visit(node):
            if node:
                visit(node.left)
                visit(node.right)
                result.append(node.key)

        visit(self.root)
        return result

    def height(self):
        """Height measured in number of nodes on the longest root-leaf path."""
        def get_height(node):
            if node is None:
                return 0
            return 1 + max(get_height(node.left), get_height(node.right))

        return get_height(self.root)


# ============================================================================
# SET 1 - E-COMMERCE CATALOGUE AND TRAFFIC ANALYSIS
# ============================================================================

def set1_task1_bst_categories():
    print("\nSET 1 - TASK 1: PRODUCT CATEGORY BST")
    categories = [
        "Electronics", "Fashion", "Books", "Home", "Beauty",
        "Sports", "Toys", "Grocery", "Mobiles", "Laptops",
        "Footwear", "Furniture", "Kitchen", "Watches", "Gaming"
    ]

    tree = BinarySearchTree()
    for category in categories:
        tree.insert(category)

    print("Inserted 15 categories:", categories)
    print("Search 'Mobiles':", tree.search("Mobiles"))
    print("Search 'Automotive':", tree.search("Automotive"))
    print("Inorder (alphabetical):", tree.inorder())
    print("Preorder:", tree.preorder())
    print("Postorder:", tree.postorder())
    print("Height (nodes):", tree.height())
    print("Complexity: average O(log n) insert/search in a balanced BST; worst O(n).")


# Task 2: Chained hash table and built-in dictionary comparison.
class ChainedHashTable:
    def __init__(self, capacity=10):
        self.capacity = capacity
        self.buckets = [[] for _ in range(capacity)]

    def _index(self, key):
        # Deterministic hash function makes the collision demonstration clear.
        return sum(ord(char) for char in str(key)) % self.capacity

    def insert(self, key, value):
        bucket = self.buckets[self._index(key)]
        for index, (stored_key, _) in enumerate(bucket):
            if stored_key == key:
                bucket[index] = (key, value)
                return
        bucket.append((key, value))

    def get(self, key):
        bucket = self.buckets[self._index(key)]
        for stored_key, value in bucket:
            if stored_key == key:
                return value
        return None


def set1_task2_hashing():
    print("\nSET 1 - TASK 2: SKU HASH LOOK-UP")
    table = ChainedHashTable(capacity=5)

    # "AB" and "BA" have the same character sum, so they collide.
    table.insert("AB", "Wireless Mouse")
    table.insert("BA", "USB Keyboard")
    print("Collision example: AB and BA map to bucket:",
          table._index("AB"), table._index("BA"))
    print("Chained bucket:", table.buckets[table._index("AB")])
    print("Custom table lookup AB:", table.get("AB"))
    print("Custom table lookup BA:", table.get("BA"))

    # Compare look-up on 100,000 SKUs using custom chaining and dict.
    count = 100_000
    custom = ChainedHashTable(capacity=200_003)
    builtin = {}
    for number in range(count):
        sku = f"SKU{number:06d}"
        custom.insert(sku, f"Product {number}")
        builtin[sku] = f"Product {number}"

    target = "SKU099999"
    start = perf_counter()
    custom_result = custom.get(target)
    custom_time = perf_counter() - start

    start = perf_counter()
    builtin_result = builtin.get(target)
    builtin_time = perf_counter() - start

    print("Number of SKUs:", count)
    print("Custom chained table result:", custom_result)
    print("Built-in dict result:", builtin_result)
    print(f"Custom hash table lookup: {custom_time:.8f} seconds")
    print(f"Built-in dict lookup:      {builtin_time:.8f} seconds")
    print("Average expected lookup: O(1); worst case with many collisions: O(n).")
    print("The built-in dict is implemented and optimized internally by Python.")


# Task 3: Graph dependencies, BFS/DFS order and cycle detection.
def graph_bfs_order(graph, start):
    visited = {start}
    queue = deque([start])
    order = []

    while queue:
        node = queue.popleft()
        order.append(node)
        for neighbour in graph.get(node, []):
            if neighbour not in visited:
                visited.add(neighbour)
                queue.append(neighbour)
    return order


def graph_dfs_order(graph, start):
    visited, order = set(), []

    def visit(node):
        visited.add(node)
        order.append(node)
        for neighbour in graph.get(node, []):
            if neighbour not in visited:
                visit(neighbour)

    visit(start)
    return order


def topological_sort(graph):
    """Kahn's algorithm; returns None when a directed cycle exists."""
    indegree = {node: 0 for node in graph}
    for neighbours in graph.values():
        for neighbour in neighbours:
            indegree.setdefault(neighbour, 0)
            indegree[neighbour] += 1

    queue = deque(node for node, degree in indegree.items() if degree == 0)
    order = []

    while queue:
        node = queue.popleft()
        order.append(node)
        for neighbour in graph.get(node, []):
            indegree[neighbour] -= 1
            if indegree[neighbour] == 0:
                queue.append(neighbour)

    return order if len(order) == len(indegree) else None


def has_directed_cycle(graph):
    state = {}  # 0/unset = unseen, 1 = visiting, 2 = finished

    def visit(node):
        state[node] = 1
        for neighbour in graph.get(node, []):
            if state.get(neighbour, 0) == 1:
                return True
            if state.get(neighbour, 0) == 0 and visit(neighbour):
                return True
        state[node] = 2
        return False

    all_nodes = set(graph)
    for neighbours in graph.values():
        all_nodes.update(neighbours)
    return any(state.get(node, 0) == 0 and visit(node) for node in all_nodes)


def set1_task3_graph():
    print("\nSET 1 - TASK 3: MICROSERVICE DEPENDENCY GRAPH")
    dependencies = {
        "cart": ["pricing"],
        "pricing": ["inventory"],
        "inventory": ["payment"],
        "payment": ["notification"],
        "notification": [],
        "catalogue": ["pricing"],
    }
    print("Adjacency list:", dependencies)
    print("BFS from cart:", graph_bfs_order(dependencies, "cart"))
    print("DFS from cart:", graph_dfs_order(dependencies, "cart"))
    print("Valid deployment order:", topological_sort(dependencies))

    circular = {
        "cart": ["pricing"],
        "pricing": ["inventory"],
        "inventory": ["cart"],
    }
    print("Circular test graph:", circular)
    print("Circular dependency detected:", has_directed_cycle(circular))
    print("Complexity: BFS/DFS/topological sort O(V + E).")


# Task 4: Sliding window, busiest continuous 3-hour period.
def max_sum_window(values, window_size):
    if window_size <= 0 or window_size > len(values):
        raise ValueError("Invalid window size")

    current_sum = sum(values[:window_size])
    best_sum = current_sum
    best_start = 0

    for end in range(window_size, len(values)):
        current_sum += values[end] - values[end - window_size]
        if current_sum > best_sum:
            best_sum = current_sum
            best_start = end - window_size + 1

    return best_start, best_start + window_size - 1, best_sum


def set1_task4_sliding_window():
    print("\nSET 1 - TASK 4: BUSIEST 3-HOUR WINDOW")
    # Requests per hour for 24 hours.
    requests = [
        120, 135, 110, 95, 100, 150, 180, 210,
        260, 300, 340, 320, 290, 275, 250, 240,
        230, 220, 200, 190, 170, 160, 140, 130
    ]
    start, end, total = max_sum_window(requests, 3)
    print("Hourly requests:", requests)
    print(f"Busiest window: hours {start:02d}:00 to {end + 1:02d}:00")
    print("Requests in 3-hour window:", total)
    print("Average requests per hour:", total / 3)
    print("Complexity: O(n) time and O(1) extra space.")


# Task 5: Two pointers for all pairs summing to gift-card value.
def two_sum_all_pairs(sorted_values, target):
    left, right = 0, len(sorted_values) - 1
    pairs = []

    while left < right:
        total = sorted_values[left] + sorted_values[right]
        if total == target:
            pairs.append((sorted_values[left], sorted_values[right]))
            left_value, right_value = sorted_values[left], sorted_values[right]
            while left < right and sorted_values[left] == left_value:
                left += 1
            while left < right and sorted_values[right] == right_value:
                right -= 1
        elif total < target:
            left += 1
        else:
            right -= 1

    return pairs


def set1_task5_two_pointers():
    print("\nSET 1 - TASK 5: GIFT-CARD PAIRS")
    order_values = [10, 20, 20, 30, 40, 50, 60, 70, 80]
    gift_card_value = 90
    print("Sorted order values:", order_values)
    print("Gift-card value:", gift_card_value)
    print("Matching unique value pairs:", two_sum_all_pairs(order_values, gift_card_value))
    print("Complexity: O(n) time and O(1) auxiliary space, excluding output.")


def run_set1():
    print("\n" + "=" * 78 + "\nSET 1 - E-COMMERCE CATALOGUE AND TRAFFIC ANALYSIS\n" + "=" * 78)
    set1_task1_bst_categories()
    set1_task2_hashing()
    set1_task3_graph()
    set1_task4_sliding_window()
    set1_task5_two_pointers()

    print("\nSET 1 DECISION TABLE")
    rows = [
        ("Category browsing", "Binary Search Tree", "Organized insert/search and ordered traversals"),
        ("SKU lookup", "Hash table / dictionary", "Fast average O(1) key lookup"),
        ("Deployment dependencies", "Directed graph + BFS/DFS", "Represents dependencies and detects cycles"),
        ("Peak traffic", "Sliding window", "Finds best fixed-length continuous period in O(n)"),
        ("Gift-card pairs", "Two pointers", "Uses sorted input to find pairs in O(n)"),
    ]
    for problem, structure, reason in rows:
        print(f"- {problem}: {structure} - {reason}")
