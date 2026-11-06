@echo off
chcp 936 >nul
setlocal EnableExtensions
REM ============================================================================
REM  一键编译（Windows / TeX Live 2026）
REM
REM    build.bat          三遍 xelatex，生成 main.pdf
REM
REM  本工程默认走「构建期 Pygments 预着色」路线（book/ccs.tex 里
REM  \mintedcodefalse），代码块在 .tex 里已经是 \PYG{...} 序列，
REM  所以不需要 -shell-escape，也不需要 latexminted。
REM  若改成 \mintedcodetrue，请自行在下面的命令里加 -shell-escape。
REM
REM  改路径只需改这两个变量：
REM    TEXBIN = TeX Live 的 bin 目录
REM    PYTHON = 装有 Pygments 的 Python（重新着色 work/tools/colorize.py 时才用到）
REM
REM  注意：本文件必须保存为 GBK 编码 + CRLF 换行。存成 UTF-8（尤其是 LF
REM  换行）时，cmd 会按 GBK 解码并错切行，报一堆「不是内部或外部命令」。
REM ============================================================================
set "TEXBIN=D:\ProgramData\texlive\2026\bin\windows"
set "PYTHON=D:\anaconda3"
set "PATH=%PYTHON%;%PYTHON%\Scripts;%TEXBIN%;%PATH%"
set "PYTHONPATH="
for %%A in ("%~dp0.") do set "TEXMF_OUTPUT_DIRECTORY=%%~fA"
set "TEXMFOUTPUT=%TEXMF_OUTPUT_DIRECTORY%"
cd /d "%~dp0."

where xelatex >nul 2>nul
if errorlevel 1 (
  echo.
  echo [错误] 找不到 xelatex，请检查本文件里的 TEXBIN 变量：
  echo        %TEXBIN%
  goto :err
)

set "N=0"
:pass
set /a N+=1
echo.
echo === 第 %N% 遍 xelatex ===
xelatex -interaction=nonstopmode -synctex=1 main.tex
if errorlevel 1 goto :err
if %N% lss 3 goto :pass

echo.
echo 编译完成，输出：main.pdf
pause
goto :done

:err
echo.
echo 编译失败，详见 main.log
pause

:done
endlocal
