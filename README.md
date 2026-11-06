# Modern C++ 编程实战（Modern C++ Programming Cookbook，第 1 版）中文版

Marius Bancila 著，Packt Publishing 2017 年出版的《Modern C++ Programming Cookbook》第一版
（C++11/14/17，100 余个案例）的完整中文译本。正文由 XeLaTeX 排版，共 11 章、553 页。

- `main.pdf` —— 成品
- `main.tex` —— 入口，`\subfile{book/index.tex}`
- `book/` —— 版式与正文源文件
  - `ccs.tex` —— 导言区：字体、页面几何、标题样式、代码块、提示框、表格宏
  - `index.tex` —— 章节装配（前置页 → 11 章 → 参考文献）
  - `content/` —— 正文：`front/`、`main/chapter01–11`、`back/90-bibliography`
  - `cpp-pygments.tex` —— Pygments atom-one-light 配色导出的 `\PYG` 宏
- `images/` —— 原书 6 张插图、原书封面（`cover-src.png` 原图 / `cover-orig.png` 补齐版）、
  两种提示框图标
- `work/` —— 抽取与翻译流水线的中间产物（见下）
- `build.bat` —— 三遍 xelatex 一键编译

## 编译

```bat
build.bat
```

需要 TeX Live 2025/2026（xelatex + ctex + fontspec + fvextra + tcolorbox + xltabular）
与中文字体 Source Han Serif SC、Microsoft YaHei，西文 Cambria、Arial Narrow、Consolas。

代码高亮走「构建期预着色」路线（`book/ccs.tex` 里 `\mintedcodefalse`）：代码块在 `.tex`
中已是 `\PYG{...}` 序列，编译只是 `Verbatim`，**不需要 `-shell-escape`**。
切到 `\mintedcodetrue` 则改用 minted，需 `-shell-escape` 与 Pygments。

## 排版要点

版式对齐原书（Packt 版心 360×530bp、章首右对齐、代码 8.5bp 浅灰底、页脚「节号 节名 | 页码」），
字体的商用替代方案：Minion Pro → Cambria，MyriadPro-SemiboldCond → Arial Narrow，
UbuntuMono → Consolas，正文中文用 Source Han Serif SC。

行距取 14.7bp（`book/ccs.tex` 的 `\linespread{1.1667}`，基线 10.5×1.2=12.6bp），
比原书的 13.2bp 略松，正文约 36 行/页。想回到原书密度改成 `1.0476` 即可，
页数会从 553 掉到 507（改完记得重新跑三遍，目录页码才会稳定）。

成品规模：11 章、24 张表、964 段代码、69 个提示框（`i` 号 NOTE 与灯泡 TIP 两种图标）、6 张插图。

封面直接用原书封面（`images/cover-src.png`，从源 PDF 首页按 300dpi 导出）。原图比例
2256:2775 = 0.813，本工程页面 504:661.5 = 0.762，铺满整页要么裁边（会切掉右下角 Packt
的 “>”）要么留白。`work/tools/cover_orig.py` 的做法是按边缘平坦底色延展：上边补纯蓝
（61,94,171），下边复制最后一行像素（左蓝右橙的竖直接缝原样延续），得到 2256×2961 的
`cover-orig.png`，再由 `book/content/front/00-cover.tex` 以 `\paperwidth`×`\paperheight`
整页出血放置——**不裁切、不缩放变形**。

## 翻译流水线（`work/`）

```
PDF ──extract.py──► src/book.json ──build_en.py──► en/*.tex（带 %%ID 标记的分批骨架）
                                                        │
                                          并行子代理按 AGENT_TASK.md 翻译
                                                        ▼
                                    zh/*.tex ──assemble.py──► book/content/**/*.tex
                                                        │
                                                   三遍 xelatex
```

- `work/TRANSLATION_GUIDE.md` —— 术语表（约 80 条）、11 章 100 余个案例标题定译、
  Introduction/Getting ready/How to do it… 等固定小节名的统一译法、LaTeX 禁区
- `work/AGENT_TASK.md` —— 译员须知：哪些东西一个字都不能改（单元标记、环境名、
  代码块、转义）、中文与 `\texttt{}`／英文／数字之间不留空格
- `work/src/book.json` —— 4708 个翻译单元（p / li / code / h2 / h3 / table / note / img）
- `work/en/`、`work/zh/` —— 英文骨架与译文分片（按 ~20k 字符切批，便于并行）

`assemble.py` 负责合并分片并做统一的排版修补：

- `tight()`：中文与 `\texttt{}`／英文／数字之间去空格（代码块内原样保留）
- `soft_breaks()`：在 `:: / . - _ ( ) < >` 后注入 `\allowbreak`，长标识符与长 URL
  停在语义分隔处，而不是被劈成 `directory_iterat / or`，也避免整段溢出
- `table_tt()`：表格单元格里的 `\texttt` 换成可断版本 `\myttbr`（列太窄，锁死会撑破表）
- 版权页与「制作人员」分页、章首「本章包含以下案例」列表按实际节标题重写

`work/tools/` 下另有若干诊断脚本（`diag_env.py` 环境配平、`overfull.py` 溢出明细、
`overflow_scan.py` 扫描真正越界的行、`note_kind.py` 判定提示框图标类型等），
排查问题时才需要，正常出书用不到。

## 已知细节

- 参考文献条目保留原文书目信息（作者、年份、标题、URL），只译必要的说明词
- 全书正文不做断字（`\hyphenpenalty=10000`）：短标识符整串锁进 `\mbox` 不拆，
  长表达式 / URL 在 `:: / . - _ ( )` 处换行，因此不会出现 `directory_iterat / or`
  这种劈词；仍有 1 行因不可分的长串越出版心约 16bp，其余越界行均为全角标点悬挂（≤5bp）
- 原书正文中的「提示」有两种图标，已按源页位置逐条判定，未判定的 4 条按 `i` 号处理
- 目录页与正文页的页脚统一为「章名 | 页码」/「页码 | 章名」，靠外侧对齐
