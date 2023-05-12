# 数学板块参考题解

链接：<https://vjudge.net/contest/557632>，补题请自行 clone。

### 最小和
> 给一个数组 $\{A\}$，求其与任意数组 $\{X\}$ 与其点乘后的最小正整数值。
>
> $1 \leq n \leq 20$，$|A_i| \leq 10^5$，且 $A$ 序列不全为 $0$。

裴蜀定理模板题。

式子 $ax + by$ 的最小值是 $\gcd(a, b)$。换句话说，方程 $ax + by = k\gcd(a, b)$ 必定有解。可以使用 exgcd 来求出一组特解，随后容易求出通解。

多元的情况自然也成立，因而本题答案即为 $|a_i|$ 之 $\gcd$。

<details><summary>展开代码 </summary>

```cpp
#include <bits/stdc++.h>

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);

    int n;
    std::cin >> n;
    std::vector<int> a(n);
    for (auto &i : a) std::cin >> i;

    int ans = 0;
    for (int i = 0; i < n; ++i) {
        ans = std::gcd(ans, std::abs(a[i]));
    }

    std::cout << ans << "\n";
    return 0;
}
```

</details>

### 来点 $\lcm$ 笑话
> 三个不大于 $n$ 的数做 $\lcm$ 最大可能是多少？
>
> $1 \leq n \leq 10^6$

虽然说不需要相同，但能不相同肯定尽量不同，除非 $n \leq 2$。

否则，自然会考虑 $n \times (n - 1) \times (n - 2)$ 这样的答案至少是 $\dfrac{n \times (n - 1) \times (n - 2)}{2}$。因为任意连续 $k$ 个数必定有一个数是 $k$ 的倍数。因此需要对 $2 \nmid n$ 和 $3 \nmid n$ 分开讨论：

1. $2 \nmid n$ 即 $n$ 是奇数，那么答案就是 $n \times (n - 1) \times (n - 2)$。

2. $3 \nmid n$，这样求 $\lcm$ 也会少一半，因此不如 $n \times (n - 1) \times (n - 3)$。

否则直接 $(n - 1) \times (n - 2) \times (n - 3)$。

<details><summary>展开代码 </summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;
using exll = __int128;

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);

    int n;
    std::cin >> n;
    std::vector<int> a(n);

    auto ans = (exll)n * (n - 1) * (n - 2) * (n - 3);

    if (n <= 2) {
        std::cout << n << '\n';
    } else if (n % 2) {
        std::cout << (ll)(ans / (n - 3)) << '\n';
    } else if (n % 3) {
        std::cout << (ll)(ans / (n - 2)) << '\n';
    } else {
        std::cout << (ll)(ans / n) << '\n';
    }

    return 0;
}
```

</details>

### 完全平方数
> 给定 $a$，求 $ax$ 为完全平方数的最小 $x$。
>
> $1 \leq n \leq 10^{12}$，保证答案亦然。

依算术基本定理，使得每一个素因子出现次数为偶数即可。

<details><summary>展开代码 </summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);

    ll a, ans = 1;
    std::cin >> a;

    for (ll i = 2; i * i <= a; i++) {
        if (int cnt = 0; a % i == 0) {
            while (a % i == 0) cnt++, a /= i;
            if (cnt & 1) ans *= i;
        }
    }

    std::cout << ans * a << '\n';

    return 0;
}
```

</details>

### 余数求和
> 求 $\displaystyle\sum\limits_{i = 1}^n k \bmod i$。
>
> $1 \leq n, k \leq 10^9$

考虑 $n \bmod i = n - i \times \left\lfloor \dfrac{n}{i} \right\rfloor$，于是问题转变为整除分块模板题。

注意整除分块需要尽量减少除法使用次数，`n / (n / l)` 有时候会被卡。

<details><summary>展开代码 </summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);

    ll n, k;
    std::cin >> n >> k;

    ll ans = n * k;
    for (int l = 1, r = 0; l <= n; l = r + 1) {
        ll t = k / l;
        r = t ? std::min(n, k / t) : n;
        ans -= t * (r - l + 1) * (l + r) / 2;
    }

    std::cout << ans << '\n';

    return 0;
}
```

</details>

### 路径计数
> 有向图上求长度为 $k$ 的路径数量。多次经过一条边的那些路径需要计入。
>
> $n \leq 50; k \leq 10^{18}$，无自环。

离散数学题，用 $f_k$ 表示答案则必有 $f_k = f_1^k$，因此使用矩阵快速幂加速。

<details><summary>展开代码 </summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;

const int N = 50;
const int mod = 1000000007;

using matrix = std::array<std::array<int, N>, N>;

int n;

matrix operator *(const matrix &lhs, const matrix &rhs) {
    matrix res{};
    for (int i = 0; i < n; i++) {
        for (int k = 0; k < n; k++) {
            for (int j = 0; j < n; j++) {
                res[i][j] = ((ll) res[i][j] + (ll) lhs[i][k] * rhs[k][j] % mod) % mod;
            }
        }
    }
    return res;
}

matrix power(matrix x, ll k) {
    matrix res{};
    for (int i = 0; i < n; i++) res[i][i] = 1;
    for (; k; k /= 2, x = x * x)
        if (k & 1) res = res * x;
    return res;
}

int main() {
    std::cin.tie(nullptr)->sync_with_stdio(false);
    
    ll k;
    std::cin >> n >> k;
    
    matrix x{};
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            std::cin >> x[i][j];
        }
    }

    matrix ans = power(x, k);
    
    int res{};
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            res = ((ll) res + ans[i][j]) % mod;
        }
    }

    std::cout << res << '\n';
    
    return 0;
}
```

</details>