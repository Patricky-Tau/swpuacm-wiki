原子操作
---

### 添加节点

任务：在节点 $p$ 后添加一个值为 $x$ 的元素。

```cpp
void push_back(ListNode *p, int x) {
    p->next = new ListNode(x, p->next);
}
```

练习：

- [leetcode 206. 反转链表](https://leetcode.cn/problems/reverse-linked-list/)
- [leetcode 1669. 合并两个链表](https://leetcode.cn/problems/merge-in-between-linked-lists/)

### 删除节点

- [leetcode 面试题 02.03. 删除中间节点](https://leetcode.cn/problems/delete-middle-node-lcci/)

任务：删除给定节点，以指针方式给出，**保证删除节点非首尾节点**。

```cpp
void erase(ListNode *p) {
    p->val  = p->next->val;
    p->next = p->next->next; 
}
```

技巧性发生在，直接删除当前节点的下一个节点只需要后一句，将数据复制后就巧妙地完成了任务。

练习：

- [leetcode 83. 删除排序链表中的重复元素](https://leetcode.cn/problems/remove-duplicates-from-sorted-list/)

- [leetcode 203. 移除链表元素](https://leetcode.cn/problems/remove-linked-list-elements/)
- [leetcode 面试题 02.01. 移除重复节点](https://leetcode.cn/problems/remove-duplicate-node-lcci/)

Floyd 快慢指针追逐
---

在 [Pollard Rho 算法](https://oi-wiki.org/math/number-theory/pollard-rho/) 中，我们早已见识过此方法，因而正确性此处从略。

除了找环之外，还可以找到数组中间的位置，调整快慢指针之间的速度倍率还可以找到更多的位置。

### 找环

以 [leetcode 142. 环形链表 II](https://leetcode.cn/problems/linked-list-cycle-ii/) 为例，题目要求找出环入口。当快慢指针重合之后，由于是单向链表，因而只能继续一直走完整个环：

```cpp
ListNode *detectCycle(ListNode *head) {
    auto slow = head, fast = head;
    while (fast && fast->next && fast->next->next) {
        slow = slow->next;
        fast = fast->next->next;
        if (slow == fast) {
            while (slow != head) {
                slow = slow->next;
                head = head->next;
            }
            return slow;
        }
    }
    return nullptr;
}
```

练习：

- [leetcode 876. 链表的中间结点](https://leetcode.cn/problems/middle-of-the-linked-list/)

- [leetcode 234. 回文链表](https://leetcode.cn/problems/palindrome-linked-list/)

----

其他
---

### [leetcode 21. 合并两个有序链表](https://leetcode.cn/problems/merge-two-sorted-lists/)

#### 迭代

```cpp
ListNode* mergeTwoLists(ListNode* l1, ListNode* l2) {
    auto dat = ListNode{0, nullptr};
    auto ret = & dat;

    while (l1 && l2) {
        if (l1->val > l2->val) { std::swap(l1, l2); }
        ret = ret->next = std::exchange(l1, l1->next);
    }

    ret->next = l1 ? l1 : l2;
    return dat.next;
}
```

#### 递归

合并 $\verb!l1, l2!$ 相当于定好其中较小的元素 $x$ 后合并 $\verb!l1\x, l2\x!$。

```cpp
ListNode* mergeTwoLists(ListNode* l1, ListNode* l2) {
    if (!l1) { return l2; }
    if (!l2) { return l1; }

    if (l1->val > l2->val) { std::swap(l1, l2); }

    l1->next = mergeTwoLists(l1->next, l2);
    return l1;
}
```

### [剑指 Offer 22. 链表中倒数第k个节点](https://leetcode.cn/problems/lian-biao-zhong-dao-shu-di-kge-jie-dian-lcof/)

这题挺有趣的。

维护两个同一起点指针，一个先走 $k$ 步；随后同时走，前面的走到 `nullptr`时，后者就到了目的地。

