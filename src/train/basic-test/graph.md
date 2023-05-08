# 图论板块参考题解

链接：<https://vjudge.net/contest/557372>，补题请自行 clone。

### 公路修建问题
> $n$ 个点 $m$ 条边，两种边权 $w_1, w_2\,(w_1 \geq w_2)$ 分别表示修建一级公路和二级公路的花费，要求至少修 $k$ 条一级公路，问最小花费下，花费最大的那条公路最小是多少，以及总共要修建的 $n - 1$ 条公路是哪些。
> 
> $n \leq 10^4; m \leq 2 \cdot 10^4$

在同两个点之间，修建一级公路的花费总是大于修建二级公路的花费，于是考虑首先选 $k$ 条一级公路，再选 $n - 1 - k$ 条二级公路即可。要使得 「花费最大的那条公路」 尽可能小，则联想到最小生成树的性质：一定包含[最小瓶颈路](https://oi.wiki/graph/mst/#%E6%9C%80%E5%B0%8F%E7%93%B6%E9%A2%88%E8%B7%AF)。因此求两次最小生成树就好啦~

实现上需要注意两个点之间只能修一条路。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;

const int N = 100010;
int n, m, k;

struct edge {
    int u, v, w1, w2, used, id;
    bool operator< (const edge &_) const {
        return w1 != _.w1 ? w1 < _.w1 : w2 < _.w2;
    }
} edges[N];

bool cmp(const edge &a, const edge &b) {
    return a.w2 < b.w2;
}

std::map<int, int> ans;

int p[N];
int find(int x) {
    return p[x] = p[x] == x ? p[x] : find(p[x]);
}

int main() {
    scanf("%d%d%d", &n, &k, &m);
    m -= 1;
    
    for (int i = 1; i <= m; i++) {
        int u, v, w1, w2;
        scanf("%d%d%d%d", &u, &v, &w1, &w2);
        edges[i] = { u, v, w1, w2, false, i };
    }
    
    std::sort(edges + 1, edges + m + 1);
    std::iota(p, p + n + 1, 0);
    
    int res = 0;
    int tot = 0;
    for (int i = 1; i <= m; i++) {
        int u = edges[i].u, v = edges[i].v;
        int w1 = edges[i].w1;
        int id = edges[i].id;
        int &used = edges[i].used;
        int fu = find(u), fv = find(v);
        if (fu != fv) {
            p[fv] = fu;
            used = true;
            res = std::max(res, w1);
            tot += 1;
            ans[id] = 1;
        }
        if (tot == k) break;
    }

    std::sort(edges + 1, edges + m + 1, cmp);
    for (int i = 1; i <= m; i++) {
        int u = edges[i].u, v = edges[i].v;
        int w2 = edges[i].w2;
        int id = edges[i].id;
        int &used = edges[i].used;
        int fu = find(u), fv = find(v);
        if (!used) {
            if (fu != fv) {
                p[fv] = fu;
                used = true;
                res = std::max(res, w2);
                tot += 1;
                ans[id] = 2;
            }
            if (tot == n - 1) break;
        }
    }
    
    printf("%d\n", res);
    for (auto [k, v] : ans) {
        std::cout << k << " " << v << '\n';
    }
    
    return 0;
}
```

</details>

### 最小瓶颈路
> 多次询问两点间最大边权的最小值。
> 
> $n \leq 10^3; m \leq 10^5; k \leq 10^3; w \leq 10^7$，可能有重边。

和[「NOIP2013」货车运输](https://loj.ac/p/2610)（最小边权的最大值）是刚好相反的，不过做法相同。询问并不多（加强版请见 <https://loj.ac/p/137>），依然考虑最小生成树，求出来最小生成森林之后直接用倍增 $lca$ 的方式暴力爬更新答案即可。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;

const int N = 10010, M = 100010;

int n, m;

int h[N], _cnt = 0, minx[N], f[N][15], dep[N];

struct edge {
    int f, w, t;
    bool operator< (const edge &_) const {
        return w < _.w;
    }
};

edge edges[M];
edge graph[N << 1];

void link(int u, int v, int w) {
    graph[++_cnt] = { v, w, h[u] }, h[u] = _cnt;
}

int t;

int w[N][20];

void dfs(int u) {
    for (int i = h[u]; i; i = graph[i].t) {
        int v = graph[i].f;
        if (!dep[v]) {
            dep[v] = dep[u] + 1;
            f[v][0] = u;
            w[v][0] = graph[i].w;
            dfs(v);
        }
    }
}

int lca(int x, int y) {
    int ans = 0;
    if (dep[x] < dep[y]) std::swap(x, y);
    for (int i = t; ~i; i--) {
        if (dep[f[x][i]] >= dep[y]) {
            ans = std::max(ans, w[x][i]);
            x = f[x][i];
        }
    }
    if (x == y) return ans;
    for (int i = t; ~i; i--) {
        if (f[x][i] != f[y][i]) {
            ans = std::max({ ans, w[x][i], w[y][i] });
            x = f[x][i];
            y = f[y][i];
        }
    }
    return std::max({ans, w[x][0], w[y][0]});
}

int p[N];

int find(int x) {
    return p[x] = p[x] == x ? p[x] : find(p[x]);
}

int main() {
    int q;
    scanf("%d%d%d", &n, &m, &q);
    
    t = std::__lg(n) + 1;
    for (int i = 1; i <= n; i++)
        for (int j = 0; j <= t; j++)
            w[i][j] = 0;
    
    for (int i = 1; i <= n; i++)
        p[i] = i;
    
    for (int i = 0; i < m; i++) {
        int u, v, w;
        scanf("%d%d%d", &u, &v, &w);
        edges[i + 1] = {u, w, v};
    }
    
    std::sort(edges + 1, edges + m + 1);
    
    for (int i = 1; i <= m; i++) {
        int f = edges[i].f;
        int w = edges[i].w;
        int t = edges[i].t;
        
        int x = find(f), y = find(t);
        if (x != y) {
            p[x] = y;
            link(x, y, w);
            link(y, x, w);
        }
    }
    
    for (int i = 1; i <= n; i++) {
        if (!dep[i]) {
            dep[i] = 1;
            dfs(i);
            f[i][0] = i;
            w[i][0] = 0;
        }
    }
    
    for (int j = 1; j <= t; j++) {
        for (int i = 1; i <= n; i++) {
            f[i][j] = f[f[i][j - 1]][j - 1];
            w[i][j] = std::max(w[i][j - 1], w[f[i][j - 1]][j - 1]);
        }
    }
    
    while (q --) {
        int u, v;
        scanf("%d%d", &u, &v);
        
        int ans = 0;
        if (find(u) != find(v))
            ans = -1;
        else
            ans = lca(u, v);
        
        printf("%d\n", ans);
    }
    
    return 0;
}
```

</details>


<details><summary>加强版做法：Kruskal 重构树</summary>

> 根据[克鲁斯卡尔重构树](https://oi.wiki/graph/mst/#kruskal-%E9%87%8D%E6%9E%84%E6%A0%91)的性质：最小瓶颈路就是克鲁斯卡尔重构树两点之间的 $lca$ 的点权，加强版只需要更快的求 $lca$，离线（tarjan 求 $lca$ 或者欧拉序上建 RMQ）跑的都很快。
>
> 建立 Kruskal 重构树就是在做 Kruskal 的过程中，原本要合并 $u$ 和 $v$，现在改为新建一个点 $t$，连边 $u \leftarrow t \rightarrow v$，$t$ 的点权设为 $u, v$ 的边权。
>
> *这方法对最大生成树两点间最小边权也适用。*
>
> ```cpp
> void Kruskal() {
>     sort(edge + 1, edge + 1 + m, cmp);
>     for (int i = 1; i <= n; ++i) ff[i] = i;
>     for (int i = 1; i <= m; ++i) {
>         int fu = find(edge[i].u), fv = find(edge[i].v);
>         if (fu != fv) {
>             val[++cnt] = edge[i].dis;
>             ff[cnt] = ff[fu] = ff[fv] = cnt;
>             add(fu, cnt), add(cnt, fu);
>             add(fv, cnt), add(cnt, fv);
>         }
>     }
> }
> ```

</details>

### 【模板】无向图三元环计数
> 如题。
> 
> $n \leq 10^5; m \leq 2 \cdot 10^5$ 无重边无自环，但不一定联通。

模板，也十分推荐写一写 [HDU6184 双三元环](https://acm.hdu.edu.cn/showproblem.php?pid=6184)。按照度数根号分治，即可达到 $\o(m \sqrt m)$。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

using ll = long long;

const ll maxn = 100000;
inline ll con(int x, int y) {
    return (ll) x * maxn + y;
}

int main() {
    int n, m;
    std::cin.tie(nullptr)->sync_with_stdio(false);

    while (std::cin >> n >> m) {
        std::vector<std::vector<int>> g(n);
        std::vector<int> dep(n), pre(n, -1), vis(n);
        std::vector<int> in(m), out(m);

        for (int i = 0; i < m; i++) {
            int u, v;
            std::cin >> u >> v;
            dep[in[i] = u - 1] += 1;
            dep[out[i] = v - 1] += 1;
        }

        ll ans{};

        for (int i = m - 1; ~i; i--) {
            int u = in[i], v = out[i];
            if (dep[u] > dep[v] || (dep[u] == dep[v] && u > v)) {
                std::swap(u, v);
            }
            g[u].push_back(v);
        }

        for (int i = 0; i < n; i++) {
            vis[i] = 1;
            for (int u : g[i]) {
                pre[u] = i;
            }
            for (int u : g[i]) {
                for (int v : g[u]) {
                    ans += pre[v] == i;
                }
            }
        }

        std::cout << ans << "\n";
    }

    return 0;
}
```

</details>

### 巡逻
> 在给定的树上修建 $1 - 2$ 条路，使得遍历所有点的花费最小（一条边花费为 $1$）。**必须经过新修建的路恰好一次**。
> 
> $3 \leq n \leq 10^5$。

这是一道很不错的「树的直径」题目。

如果 $k = 1$，则必联通直径，若直径长度为 $x$，则花费为 $2(n - 1) - (x - 1)$。

关键是 $k = 2$，这也分情况：

1. 第二条路与第一条路无交，第二条路一定是次大最长路 $y$，花费为 $2(n - 1) - (x - 1) - (y - 1)$。
2. 有交，由题目要求，**必须经过新修建的路恰好一次**，因此这一段交只会经过一次，即被抵消了。代数上我们可以认为 $(- t) - (- t) = 0$，因此可以将直径的边权置为 $-1$，再求一次直径。注意这样做与情形一不冲突。

由于要知道直径上的点，第一次可以使用 $dfs$/$bfs$，第二次由于边权有负数，只能 $dp$ 求了。这里直接用蓝书上的 $dp$ 方式了，大家也需要掌握维护最大值和次大值的写法。

<details><summary>展开代码</summary>

```cpp
#include <bits/stdc++.h>

int main() {
    int n, k;
    std::cin >> n >> k;

    std::vector g(n + 1, std::vector(0, std::pair{0, 0}));
    for (int i = 1; i < n; i++) {
        int u, v;
        std::cin >> u >> v;
        g[u].emplace_back(v, 1);
        g[v].emplace_back(u, 1);
    }

    int diameter = -1, id = -1, getPath = false;
    std::vector parent(n + 1, 0);
    [&, dfs{[&](auto &&self, int u, int p, int weight) -> void {
        if (diameter <= weight) diameter = weight, id = u;
        if (getPath) parent[u] = p;
        for (auto [v, w] : g[u])
            if (v != p) self(self, v, u, weight + 1);
    }}] {
        dfs(dfs, 1, 0, 0);
        getPath = true;
        dfs(dfs, id, 0, 0);
    }();

    if (k == 1) {
        std::cout << 2 * (n - 1) - (diameter - 1) << '\n';
        return 0;
    }

    std::vector tag(n + 1, false);
    for (int i = id; i; i = parent[i]) {
        tag[i] = true;
    }

    int se_diameter = 0;
    std::vector f(n + 1, 0);
    [&, dfs{[&](auto &&self, int u, int p) -> void {
        for (auto &[v, w] : g[u]) if (v != p) {
            if (tag[u] && tag[v]) w = -1;
            self(self, v, u);
            se_diameter = std::max(se_diameter, f[u] + f[v] + w);
            f[u] = std::max(f[u], f[v] + w);
        }
    }}] { dfs(dfs, 1, 0); }();

    std::cout << 2 * (n - 1) - (diameter - 1) - (se_diameter - 1) << '\n';

    return 0;
}
```

</details>

### 路径统计
> 求最短路的条数。
> 
> $n \leq 2000; e \leq n \times (n - 1)$ 边权 $\leq 10$。

在 Dijkstra 的过程中在 $dist_v = dist_u + w$ 的时候更新答案。但这题要处理掉重边，题目说的不是很清楚：

> 两个不同的最短路方案要求：路径长度相同（均为最短路长度）且最短路经过的点的编号序列不同。

实现同 [天梯赛 L2001](https://pintia.cn/problem-sets/994805046380707840/exam/problems/994805073643683840)，代码略。
