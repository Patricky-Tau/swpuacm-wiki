链表是一种线性容器，元素相邻排布。但与数组不同的是，内存上不一定连续，这意味着要访问链表第 $k$ 个元素，只能通过 $\o(k)$ 遍历。但不连续也带来一些优点：其插入、删除复杂度均为 $\o(1)$。

竞赛中，我们常常使用链式前向星存图：

```cpp
struct edge {
    int to, next;
} edges[maxn << 1];

int head[maxn];

// 遍历方式
for (int i = head[u]; i; i = edges[i].next) {
	int v = edges[i].to; // u -> v 边
}
```

而面试中的链表往往是如下的单向链表：

```cpp
struct ListNode {
    int val;
    ListNode *next;
    ListNode() : val(0), next(nullptr) {}
    ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode *next) : val(x), next(next) {}
};

// 遍历方式
for (auto it = head; it; it = it->next) { }
```

----

练习：

- [leetcode 1290. 二进制链表转整数](https://leetcode.cn/problems/convert-binary-number-in-a-linked-list-to-integer/)
- [leetcode 160. 相交链表](https://leetcode.cn/problems/intersection-of-two-linked-lists/)
- [剑指 Offer 06. 从尾到头打印链表](https://leetcode.cn/problems/cong-wei-dao-tou-da-yin-lian-biao-lcof/)

