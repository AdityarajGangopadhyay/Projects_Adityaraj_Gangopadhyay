class BinaryHeap:
    def __init__(self):
        self.heap = []

    def parent(self, i):
        return (i - 1) // 2

    def getLeftChild(self, i):
        return 2 * i + 1

    def getRightChild(self, i):
        return 2 * i + 2

    def hasLeftChild(self, i):
        return self.getLeftChild(i) < len(self.heap)

    def hasRightChild(self, i):
        return self.getRightChild(i) < len(self.heap)

    def swap(self, i, j):
        self.heap[i], self.heap[j] = self.heap[j], self.heap[i]

    def heapifyPush(self, i):
        while i != 0 and self.heap[self.parent(i)] > self.heap[i]:
            self.swap(i, self.parent(i))
            i = self.parent(i)

    def heapifyPop(self, i):
        while self.hasLeftChild(i):
            min_child_index = self.getLeftChild(i)
            if self.hasRightChild(i) and self.heap[self.getRightChild(i)] < self.heap[self.getLeftChild(i)]:
                min_child_index = self.getRightChild(i)
            if self.heap[i] < self.heap[min_child_index]:
                break
            else:
                self.swap(i, min_child_index)
            i = min_child_index

    def binaryHeapPush(self, key):
        self.heap.append(key)
        self.heapifyPush(len(self.heap) - 1)

    def binaryHeapPop(self):
        if not self.heap:
            return None
        root = self.heap[0]
        self.heap[0] = self.heap[len(self.heap) - 1]
        self.heap.pop()
        self.heapifyPop(0)
        return root