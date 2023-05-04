# 动态规划板块参考题解

链接：<https://vjudge.net/contest/556525>，补题请自行 clone。

### LCS
> 求两字符串 $s, t$ 的最长公共子序列。
>
> $|s|, |t| \leq 3000$

注意要求的不只是长度，如果要求长度就直接：

1. 如果 $s_i = t_j$：$f_{i, j} = f_{i - 1, j - 1} + 1$。
2. 否则选其中一个，即 $f_{i, j} = \max\{ f_{i, j - 1}, f_{i - 1, j} \}$。

要得到 dp 转移过程，需要在更新的时候记录来源，这里将三种来源标记为 $0 / 1 / 2$，最后从后往前跑即可。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);
    
    std::string s, t;
    std::cin >> s >> t;
    
    int n = s.size(), m = t.size();
    std::vector f(n + 1, std::vector<int>(m + 1, 0));
    std::vector pre(n + 1, std::vector<int>(m + 1, -1));
    
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= m; j++) {
            if (s[i - 1] == t[j - 1]) {
                f[i][j] = f[i - 1][j - 1] + 1;
                pre[i][j] = 0;
            } else {
                int f1 = f[i - 1][j];
                int f2 = f[i][j - 1];
                if (f1 > f2) {
                    pre[i][j] = 1;
                } else {
                    pre[i][j] = 2;
                }
                f[i][j] = std::max(f1, f2);
            }
        }
    }
    
    int i = n, j = m;
    
    std::string ans;
    while (~i && ~j) {
        if (int p = pre[i][j]; p == 0) {
            ans += s[i - 1];
            i -= 1;
            j -= 1;
        } else if (p == 1) {
            i -= 1;
        } else if (p == 2) {
            j -= 1;
        } else {
            break;
        }
    }
    
    std::reverse(ans.begin(), ans.end());
    std::cout << ans << '\n';
    
    return 0;
}
```

</details>

### Grid 2
> 给出所有障碍点的坐标的方格取数问题。
>
> 障碍点数 $n \leq 10^3; h, w \leq 10^5$。

很容易计算出没有任何障碍点的答案，即从 $(1, 1)$ 到 $(n, m)$ 的答案实际上是二项式系数 $\displaystyle{n - 1 + m - 1 \choose n - 1}$，实现上 $0$-indexed 更容易。

只需要将障碍部分都减去。不用担心减重了，由容斥原理可知许多项实际上被减去、抵消、减去、抵消…… 即用 $f_i$ 表示考虑走过前 $i$ 个障碍的方案数，为了方便可以再加一个障碍 $(h - 1, w - 1)$，这样 $f_{n + 1}$ 即为所求。对于每个 dp 值，都减去其前面的障碍点贡献：

$$
f_i = {x_i + y_i \choose x_i} - \sum_{j < i} [x_j \leq x_i \land y_j \leq y_i] \times f_j \times {(x_i - x_j) + (y_i - y_j) \choose x_i - x_j}
$$

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);
    
    int h, w, n;
    std::cin >> h >> w >> n;
    
    std::vector p(n, std::pair{0, 0});

    for (auto &[x, y] : p) {
        std::cin >> x >> y;
        x -= 1, y -= 1;
    }
    
    p.emplace_back(h - 1, w - 1);
    
    const int N = 200001;
    const int mod = 1000000007;
    std::vector<int> fac(N, 0), inv(N, 0), ifc(N, 0);
    fac[0] = fac[1] = inv[0] = inv[1] = ifc[0] = ifc[1] = 1;
    
    for (int i = 2; i < N; i++) {
        fac[i] = (ll) fac[i - 1] * i % mod;
        inv[i] = ((ll) mod - mod / i) % mod * inv[mod % i] % mod;
        ifc[i] = (ll) ifc[i - 1] * inv[i] % mod;
    }
    
    auto binom = [&](int n, int m) -> ll {
        if (n < m || m < 0) return 0ll;
        return (ll) fac[n] * ifc[m] % mod * ifc[n - m] % mod;
    };
    
    std::vector f(n + 1, 0);
    std::sort(p.begin(), p.end());
    
    for (int i = 0; i < n + 1; i++) {
        auto [x, y] = p[i];
        f[i] = binom(x + y, x);
        for (int j = 0; j < i; j++) {
            auto [nx, ny] = p[j];
            if (x >= nx && y >= ny) {
                f[i] = ((ll) f[i] - (ll) f[j] * binom(x - nx + y - ny, x - nx) % mod + mod) % mod;
            }
        }
    }
    
    std::cout << f[n] << '\n';
    return 0;
}
```
</details>

### Vacation

> 小明在接下来的 $n$ 天，可以选择三种事件并获得 $a_i / b_i / c_i$ 的快乐值，但是他不能连续两天及以上做同样的事。问最大的欢乐值是多少？
>
> $n \leq 10^5; a_i, b_i, c_i \leq 10^4$。

换句话说就是每天做的事情都不一样。用 $f_{i, j}$ 表示第 $i$ 天做 $j$ 事件所得到的最大快乐值，枚举今天和明天做的事件，即：

$$
f_{i + 1, j} = \max\{ f_{i + 1, j}, f_{i, k} + \{a, b, c\}_k \}, j \ne k
$$

当然空间可以优化掉一维。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);
    
    int n;
    std::cin >> n;
    
    std::array<int, 3> f{};
    
    for (int i = 0; i < n; i++) {
        std::array<int, 3> c{};
        for (int &i : c) std::cin >> i;
        std::array<int, 3> nf{};
        for (int j = 0; j < 3; j++) {
            for (int k = 0; k < 3; k++) if (j != k) {
                nf[j] = std::max(nf[j], f[k] + c[j]);
            }
        }
        f = nf;
    }
    
    std::cout << *std::max_element(f.begin(), f.end()) << '\n';
    
    return 0;
}
```

</details>


### Grouping
> 将物品分组，如果 $i, j$ 在一组将会得到 $a_{i, j}$ 的分。问所有分组情况下最大得分。
>
> $n \leq 16; |a_{i, j}| \leq 10^9$。

分成若干组包含一个子问题：分成两组。

状压，$f_i$ 表示其中一组的分组情况为 $i$ 的情况下的最大得分。则按照上面的划分，只需考虑其被分为 $f_j, f_{i \setminus j}, \,(i \in j)$ 的方案。即：

$$
f_i = \max\{f_j + f_{i \setminus j}\}
$$

<details><summary>💡 如何枚举非空子集</summary>

> ```cpp
> for (int j = i; j; --j &= i) { }
> ```
>
> 当然，本题需要非空、真子集，因此初始 `int j = i & (i - 1)` （抹去最后一个 $0$）。

</details>

复杂度为 $\mathcal O(n^2 2^n + 3^n)$。

> 依二项式定理，$\displaystyle\sum\limits_{k = 0}^{n} {n \choose k} 2^k = \sum_{k=0}^n { n \choose k } (1)^{n-k} (2)^k = (1 + 2) ^ n$ [^1]
> [^1]: <https://math.stackexchange.com/questions/525266/prove-sum-binomnk2k-3n-using-the-binomial-theorem>

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);

    int n;
    std::cin >> n;

    std::vector g(n, std::vector(n, 0));
    for (auto &i : g) for (auto &j : i) std::cin >> j;

    std::vector f(1 << n, -1LL);
    f[0] = 0;
    std::cout << [&, dp{[&](auto &&self, int i) -> ll {
        if (~f[i]) return f[i];
        f[i] = 0;
        for (int j = 0; j < n; j++) if (i >> j & 1) {
            for (int k = j + 1; k < n; k++) if (i >> k & 1) {
                f[i] += g[j][k];
            }
        }
        for (int j = i & (i - 1); j; --j &= i) {
            f[i] = std::max(f[i], self(self, j) + self(self, i ^ j));
        }
        return f[i];
    }}]{
        return dp(dp, (1 << n) - 1);
    }();

    return 0;
}
```

</details>

### Longest Path
> DAG 求最长路。
>
> $n \leq 10^5; m \leq 10^5$。

按拓扑排序更新。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);
    
    int n, m;
    std::cin >> n >> m;
    std::vector<std::vector<int>> g(n + 1);
    std::vector<int> deg(n + 1);
    
    for (int i = 0; i < m; i++) {
        int x, y;
        std::cin >> x >> y;
        g[x].push_back(y);
        deg[y] += 1;
    }
    
    std::queue<int> q;
    std::vector<int> f(n + 1, 0);
    
    for (int i = 1; i <= n; i++) if (!deg[i]) q.push(i);
    while (!q.empty()) {
        int u = q.front(); q.pop();
        for (auto &v : g[u]) {
            f[v] = f[u] + 1;
            if (!--deg[v]) q.push(v);
        }
    }
    
    std::cout << *std::max_element(f.begin(), f.end()) << '\n';
    
    return 0;
}
```

</details>
