<h3 align="center">
	Algorithm Wiki for SWPUACM the Team
</h3>

## 动机与目标

记录集训队训练日常。

To make SWPUACM great.

## 看这本书需要什么知识储备？

会读中文/英文，喜爱动手编程并勇于尝试。

## 如何参与其中？

😀 首先，欢迎、感谢您的贡献！本项目使用 [rust-lang/mdBook](https://github.com/rust-lang/mdBook)，支持您仅通过极为简洁的 Markdown 语法便可进行编写。

### 使用 [Issues](https://github.com/Patricky-Tau/swpuacm-wiki/issues) 提供建议与需求

我们已为您准备默认模板，请您按需填写，力求简洁、清晰。

### 使用 [Pull requests](https://github.com/Patricky-Tau/swpuacm-wiki/pulls) 直接编写！

在您对项目进行 [fork](https://github.com/Patricky-Tau/swpuacm-wiki/fork) 之后，需要做的是：
1. 在 [./src](./src) 中对应专项文件夹中添加、修改文件。
2. 在 [./src/SUMMARY.md](./src/SUMMARY.md) 中标注文章地址。
3. 部署：按照格式填写[这几行](https://github.com/Patricky-Tau/swpuacm-wiki/blob/master/book.toml#L26-L28)对应内容后提交至自己的仓库后，你需要配置项目的 [ACTIONS\_DEPLOY\_KEY](https://github.com/peaceiris/actions-gh-pages#%EF%B8%8F-create-ssh-deploy-key)，这样提交后将会自动触发 Github Actions
  - 或者，执行[这个脚本](https://github.com/Patricky-Tau/swpuacm-wiki/blob/master/scripts/build.sh) 后运行 `mdbook serve --open` 验证无问题后即可撰写 Pull Requests。

经过认定为有必要添加/修改的内容将会被合并入主分支。

## 阅读与编写指南

1. 学习[Markdown 基本语法](https://markdown.com.cn/basic-syntax/)。
2. 在 Markdown 中，你还可以凭借 [$\KaTeX$](https://katex.org/) / [Mathjax](https://www.mathjax.org/) 编写公式。在本站你可凭借前者阅读、编写精美的数学公式，详见 <https://katex.org/docs/supported.html> 指出的若干支持语法进行编写。
   在文件<a target="_blank" src="https://github.com/Patricky-Tau/swpuacm-wiki/blob/master/src/_static/macros.txt">./_static/macros.txt</a>中定义了若干宏便于调用，例如 `\o = \mathcal O` $\o(n \log n)$。
   除此之外，为了整齐，强烈建议：
     - 对于嵌套括号使用 $\verb!\left, \right!$ 包裹。
     - 对于较大的分式，使用 $\verb!\dfrac!$。
     - 如果公式包含上下限，使用 $\verb!\limits!$。 如 $\verb!\max\limits_{i=l}^r f(a_i)! \Rightarrow\max\limits_{i=l}^r f(a_i)$
