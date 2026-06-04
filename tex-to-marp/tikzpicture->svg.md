# tikzpicture -> svg
- `to-convert-i.tex` 文件中的 tikzpicture 结构
  ```tex
  \begin{figure}

			\tikzset{every picture/.style={line width=0.75pt}} %set default line width to 0.75pt

			\begin{tikzpicture}[x=0.75pt,y=0.75pt,yscale=-1,xscale=1, ...]
			  ...
			\end{tikzpicture}

  \end{figure}
  ```
- 识别其中的内容部分
  ```tex
  \tikzset{every picture/.style={line width=0.75pt}} %set default line width to 0.75pt

  \begin{tikzpicture}[x=0.75pt,y=0.75pt,yscale=-1,xscale=1, ...]
    {{more tex code}}
  \end{tikzpicture}
  ```
- 保存内容到独立的 `.tex` file under the folder `images/`，添加合适的 preamble，赋予与内容相符合的文件名
  ```tex
  \documentclass{standalone}
  \usepackage{latexsym,amsmath,amsfonts,amssymb}
  \usepackage[dvipsnames]{xcolor} % To use rich set of colors
  \usepackage{tikz}
  \begin{document}

  \tikzset{every picture/.style={line width=0.75pt}} %set default line width to 0.75pt

  \begin{tikzpicture}[x=0.75pt,y=0.75pt,yscale=-1,xscale=1, ...]
    {{more tex code}}
  \end{tikzpicture}

  \end{document}
  ```
- Compile the `.tex` file
- 将生成的 pdf 文件转换为 svg 文件，使用 `inkscape` 命令行工具
  ```bash
  inkscape --without-gui --file="tikzpicture.pdf" --export-plain-svg --export-filename="tikzpicture.svg";
  ```
- Reference the svg file in the .md file
  ```markdown
  ![width:YYpx](path-to-svg)
  ```
