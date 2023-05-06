# 杂项板块参考题解

链接：<https://vjudge.net/contest/557055>，补题请自行 clone。

### 武器大师

> 不断换武器来打怪兽，问杀死怪兽的最小步数。
>
> $2 \leq n \leq 10^3, 1 \leq H \leq 10^9, 1 \leq a_i \leq 10^9$

明显使用最大值和次大值来操作。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);

    int tt;
    std::cin >> tt;
    void solve();
    while (tt--) {
        solve();
    }

    return 0;
}

void solve() {
    int n, hp;
    std::cin >> n >> hp;

    std::vector<int> a(n);
    for (int i = 0; i < n; ++i) {
        std::cin >> a[i];
    }

    std::nth_element(a.begin(), a.begin() + 1, a.end(), std::greater{});

    int x = a[0], y = a[1], m = hp % (x + y);

    std::cout << (hp) / (x + y) * 2 + (m > x ? 2 : m > 0 ? 1 : 0) << "\n";
}
```

</details>

### 慢速排序

> 给定一个排列，一次操作可以抽出至多 $k$ 个数字，将他们排好序插到数组末尾，问最少多少次操作可以将数组升序排序。
>
> $2 \leq n \leq 10^5, 1 \leq k \leq n$

保留 $1, 2, 3, \cdots$ 的最长上升子序列，其他的不断操作即可。若上述 LIS 长度为 $x$，则操作次数为 $\left \lceil \dfrac{n - x}{k} \right \rceil$。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);

    int tt;
    std::cin >> tt;
    void solve();
    while (tt--) {
        solve();
    }

    return 0;
}

void solve() {
    int n, k, cur = 1;
    std::cin >> n >> k;
    for (int i = 0; i < n; i++) {
        int x;
        std::cin >> x;
        if (cur == x) {
            cur += 1;
        }
    }
    std::cout << (n - --cur + k - 1) / k << "\n";
}
```

</details>

### 四次方的差

> 按照矩阵 $a$ 构造矩阵 $b$，使得 $a_{i, j} \mid b_{i, j}$，$1 \leq b_{i, j} \leq \color{red}{10 ^ 6}$ 且 $b$ 中两相邻元素差为 $k^4$($k \geq 1$)。
>
> $2 \leq n, m \leq 500; 1 \leq a_{i, j} \leq \color{red}{16}$。

数据范围决定了此题的做法。

我们需要一个数，使得其是 $1-16$ 所有数的倍数，容易想到阶乘 $16! = 20922789888000 \gt 10^6$，这时候再想想 $\lcm$（最小公倍数），发现 $\lcm(1, 2, 3, \cdots, 16) = 720720$。这就很好了，因为 $720720 + 16^4 \lt 10^6$，这样我们就做完了。

构造上，黑白染色即可。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);

    int magic = 1;
    for (int i = 1; i <= 16; i++) {
        magic = std::lcm(magic, i);
    }

    int n, m;
    std::cin >> n >> m;
    std::vector g(n, std::vector(m, 0));
    for (auto &i : g)
        for (auto &j : i) std::cin >> j;

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            if ((i ^ j) & 1) {
                std::cout << magic + g[i][j] * g[i][j] * g[i][j] * g[i][j];
            } else {
                std::cout << magic;
            }
            std::cout << " \n"[j + 1 == m];
        }
    }

    return 0;
}
```

</details>

### 三元运算律

> 给定一个数组，每次可以选择三个不同的下标，将他们连成环交换顺序（$i \to j \to k \to i$）。判断是否能用这样的方式将数组非递减排序。
>
> $1 \leq n \leq 5 \times 10^5; a_i \leq n$

很有意思、很经典的一道题。近期 abc 上还出过 <https://atcoder.jp/contests/abc296/tasks/abc296_f>。

首先如果不是一个排列（即有重复元素），那么借着这（至少）两个重复元素可以随意安排序列顺序，证明略。

否则如果是排列，观察到 $i \to j \to k \to i$ 这个过程只会使得逆序对数改变偶数，这样我们只需要判断初始的逆序对数是否是偶数即可。求逆序对数想用树状数组或者归并排序都无所谓。

> 下面的算法能够线性判定排列逆序对数的奇偶性，涉及另一个重要结论：<b>两个排列之间连边，必成若干环</b>。许多题目只需要从 $1, 2, 3, \cdots, n$ 向 $p_1, p_2, p_3, \cdots, p_n$ 连边即可解决（原理：数都只出现一次，因此入度和出度均为 $1$）。结论性地说，排列逆序对数的奇偶性与（$n - $ 环数）的奇偶性一致。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);

    int tests;
    std::cin >> tests;
    void solve();
    while (tests--) solve();

    return 0;
}

void solve() {
    int n;
    std::cin >> n;

    std::vector<int> a(n), counter(n);

    bool f = false;
    for (int i = 0; i < n; i++) {
        std::cin >> a[i];
        a[i] -= 1;
        if (++counter[a[i]] == 2) {
            f = true;
        }
    }

    if (f) {
        std::cout << "yes\n";
        return;
    }

    bool parity = ~n & 1;
    for (int i : a)
        if (~i) {
            for (int j = i; ~j;) {
                std::tie(j, a[j]) = std::tuple{a[j], -1};
            }
            parity ^= 1;
        }

    std::cout << (parity ? "YES" : "NO") << '\n';
}
```

</details>

### 这把匕首可是涂满了剧毒呢（舔） 

> 打怪兽，只能用持续时间为 $k$ 的毒药，可以发动 $n$ 次施毒，攻击的开始节点为 $a_i$。后来的毒不会叠加，只会刷新。问击杀怪兽的最少施毒次数。
>
> $1 \leq n \leq 100; 1 \leq h \leq 10^{18};1 \leq a_i \leq 10^9$ $a$ 严格升序。

就 「是否能杀死怪兽」，施毒的多少对其影响为 $0, 0, 0, 1, 1, 1$。于是考虑二分，问题转变为判定能否杀死怪兽。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);

    int tt;
    std::cin >> tt;
    void solve();
    while (tt--) {
        solve();
    }

    return 0;
}

void solve() {
    ll n, h;
    std::cin >> n >> h;
    std::vector<ll> a(n);
    for (auto &i : a) {
        std::cin >> i;
    }

    ll l = 1, r = h;
    while (l < r) {
        ll m = (l + r) / 2;
        ll ans = m;
        for (int i = 0; i < n - 1; i++) {
            ans += std::min(m, a[i + 1] - a[i]);
        }
        if (ans >= h) {
            r = m;
        } else {
            l = m + 1;
        }
    }

    std::cout << l << '\n';
}
```

</details>
