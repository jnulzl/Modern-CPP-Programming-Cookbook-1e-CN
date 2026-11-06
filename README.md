# 《Modern C++ Programming Cookbook（第 1 版）》中文版 · LaTeX 工程

由 Packt 英文原版 PDF（*Modern C++ Programming Cookbook*, Marius Bancila, 2017，583 页、
100 余个案例）逐句翻译并重排，正文由 XeLaTeX 排版，共 **11 章、545 页**。

---

## 1. 目录结构

```
Modern-C++-Programming-Cookbook/
├── main.tex                  编译入口（10 行，只做 \input + subfile）
├── build.bat                 一键编译（三遍 xelatex + 失败即停）
├── README.md                 本文件
├── main.pdf                  产物（545 页 / 3.0 MB）
├── book/
│   ├── ccs.tex               导言区：页面/字体/标题/代码/表格/提示框/页脚/章节命令
│   ├── cpp-pygments.tex      代码高亮宏（Pygments atom-one-light 导出的 \PYG）
│   ├── index.tex             装配清单：封面 → 版权 → 目录 → 贡献者 → 前言 → 11 章 → 参考文献
│   └── content/
│       ├── front/            00-cover / 00-title / 00-copyright /
│       │                     01-contributors / 02-preface
│       ├── main/             chapter01 … chapter11（约 2.0 MB TeX 源码）
│       └── back/             90-bibliography
├── images/                   原书封面（cover-src / cover-orig）、ch00·ch02·ch08/（插图）、
│                             提示框图标 icon-note / icon-tip
└── work/                     抽取、翻译、排版流水线（见第 4 节），出书时不需要
```

---

## 2. 怎么编

```bat
build.bat
```

或手动（同样三遍）：

```bat
xelatex -interaction=nonstopmode main.tex     :: 需要跑三遍
```

依赖 **TeX Live 2026 + XeLaTeX**，字体如下（三种商用字体均已用系统字体替代）：

| 用途 | 本项目 | 原书 |
|---|---|---|
| 中文正文 | Source Han Serif SC | — |
| 中文标题 / 表头 / 代码内中文 | Microsoft YaHei | — |
| 西文正文 | Cambria | Minion Pro（商用） |
| 西文标题 | Arial Narrow | MyriadPro-SemiboldCond（商用） |
| 代码 | Consolas | UbuntuMono（商用） |

选型理由写在 `book/ccs.tex` 顶部：Cambria 数字等高、x 高度接近 Minion；Arial Narrow 的字宽
密度最接近压缩无衬线；Consolas 自带全套框线字符，代码里的目录树 `─├└│` 可直接显示。

**默认路线不需要 `-shell-escape`**：代码块由 `work/tools/colorize.py` 用 Pygments 预着色，
`.tex` 里已是 `\PYG{...}` 序列，编译时只是普通 `Verbatim`。只有把 `book/ccs.tex` 里的
`\mintedcodefalse` 改成 `\mintedcodetrue` 走 minted 时，才需要 `-shell-escape`。

三遍不是可选项：第一遍写 `.toc` / `.aux`（此时目录还是空的），第二遍目录才有页码、书签才
成形，第三遍收敛分页与页脚章名。只跑一遍得到的 PDF 页码是错的。

> ⚠ `build.bat` 必须保存为 **GBK + CRLF、无 BOM**。Edit/Write 工具产出的是 UTF-8 + LF，
> cmd 会按系统 ANSI 代码页（936）解码并错切行，报一串 `'rr' 不是内部或外部命令`。
> 改完脚本跑一次 `work/tools/to_gbk.py` 即可。

---

> 如果环境配置遇到问题或者编译失败可以直接到[releases](https://github.com/jnulzl/Modern-CPP-Programming-Cookbook-1e-CN/releases)下载最新的pdf文件

## 3. 表格样式

表格全部是**全网格**（外框 + 纵线 + 每行横线），表头黑底白字，与原书一致：

- 列规格由 `work/tools/assemble.py` 的 `grid_tables()` 统一加 `|` 与 `\hline`，
  翻译稿里只写普通的 `xltabular`，不必手工画线。
- 原列规格用 `@{}` 把左右内边距归零（为与正文左缘齐平），加纵线后文字会贴住线条，
  因此 `grid_tables()` 顺手去掉 `@{}`，改由 `ccs.tex` 的 `myTableBegin` 里
  `\tabcolsep=4bp` 提供内边距。
- 跨页长表由 `xltabular` 自动重复表头；原 PDF 被分页切开的表在抽取时会出现
  「首行被误当表头」的续片，这类续片已并回主表（`%%C020440`、`%%C070398`、
  `%%C080344`、`%%C090107`、`%%C110207` 五处，原单元留空并注明）。

## 官方代码

[Modern-CPP-Programming-Cookbook](https://github.com/PacktPublishing/Modern-CPP-Programming-Cookbook) —— 书中示例代码
