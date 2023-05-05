# 数据结构板块参考题解

链接：<https://vjudge.net/contest/556784>，补题请自行 clone。

### 最大异或对

$n$ 个数里面选 $2$ 个，求最大异或和。

> $1 \leq n \leq 10^5, 0 \leq a_i \leq 2^{31}$

字典树模板题，在字典树上不断走与当前位相反的比特即可。

> 选任意个/$k$大子集异或和怎么做？线性基模板题。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);

    int n;
    std::cin >> n;
    std::vector<int> a(n);
    for (int &i : a) std::cin >> i;

    std::vector<std::array<int, 2>> tr(n * 30 + 1);
    int cnt = 0;

    int ans = 0;
    for (int x : a) {
        // query
        int res = 0;
        for (int i = 30, p = 0; ~i; i--) {
            int y = x >> i & 1;
            if (tr[p][!y])
                p = tr[p][!y], res = 2 * res + 1;
            else
                p = tr[p][y], res = 2 * res;
        }
        ans = std::max(ans, res);

        // insert
        for (int i = 30, p = 0; ~i; i--) {
            int y = x >> i & 1;
            if (!tr[p][y]) tr[p][y] = ++cnt;
            p = tr[p][y];
        }
    }

    std::cout << ans << '\n';
}
```

</details>

### 逆天顺序对
> 求满足 $i \lt a_i \lt j \lt a_j$ 的 $(i, j)$ 对子数量。
>
> $n \leq 2 \cdot 10^5, 0 \leq a_i \leq 10^9$

树状数组模板题，拆成三个条件 $a_i \gt i, a_j \gt j, a_i \lt a_j$。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

using ll = long long; // <+>

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
  int n;
  std::cin >> n;

  std::vector<int> a(n);
  for (int &i : a) {
    std::cin >> i;
  }

  std::vector<int> tree(n + 1, 0);

  ll ans = 0;
  for (int i = n - 1; ~i; --i) {
    if (a[i] < i + 1) {
      // query
      for (int j = i + 2; j <= n; j += j & -j) {
        ans += tree[j];
      }
      // modify
      for (int j = a[i]; j; j -= j & -j) {
        tree[j] += 1;
      }
    }
  }

  std::cout << ans << "\n";
}
```

</details>

### K 倍区间
> 求区间和是 $K$ 的倍数的区间数量。
>
> $1 \leq N, K, a_i \leq 10^5$

典中典，只需考虑 $\bmod K$ 的结果，随后对于 $a_i$，数前缀和为 $a_i$（这样区间和就是 $0$）的数量。实现上可以使用一个 `std::map`。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);

    int n, k;
    std::cin >> n >> k;

    ll ans = 0, s = 0;
    std::map<ll, ll> cnt {{0, 1}};

    for (int i = 0, x; i < n; i++) {
        std::cin >> x;
        ++cnt[(s += x %= k) %= k];
    }

    for (int i = 0; i < k; i++) {
        ans += cnt[i] * (cnt[i] - 1) / 2;
    }

    std::cout << ans << '\n';

    return 0;
}
```

</details>

### 新秩序
> 给 $a_2 - a_n$ 重新标号，如果 $a_i$ 在 $a_1 - a_{i - 1}$ 出现过，就不断加 $1$ 直到没有出现。求重新标号后的数组。
>
> $1 \leq n \leq 10^5, 1 \leq a_i \leq 10 ^ 6$。

做法很多，但核心都是要快速完成「不断加 $1$」直到没有出现这一点，可以使用 `std::set` 先把所有数都插进去然后出现就抹掉，要找的答案就是 `lower_bound` 一下的结果。也可以使用并查集，不断将 $res$ 和 $res + 1$ 合并。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);

    int n;
    std::cin >> n;
    std::vector a(n, 0);

    static const int N = 1000010;
    std::vector p(N, 0);
    std::iota(p.begin(), p.end(), 0);
    std::function<int(int)> find = [&find, &p](int x) -> int {
        return p[x] = p[x] == x ? x : find(p[x]);
    };

    for (int i = 0; i < n; i++) {
        std::cin >> a[i];
        a[i] = find(a[i]);
        p[a[i]] = a[i] + 1;
        std::cout << a[i] << " \n"[i + 1 == n];
    }

    return 0;
}
```

</details>

### 区间异或
> 实现支持区间异或 $x$，查询区间和的数据结构。
>
> $1 \leq n \leq 10^5, 0 \leq a_i \leq 10^6, 1 \leq q \leq 5 \cdot 10^4$

线段树模板题，直接拆位做。

代码略。
