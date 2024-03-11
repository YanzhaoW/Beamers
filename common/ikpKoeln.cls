% tex file
\NeedsTexFormat{LaTeX2e}
\ProvidesClass{ikpKoeln}[2024/03/07 Beamer template for IKP uni Koeln]

\LoadClass[compress, 13pt, aspectratio=169]{beamer}

\RequirePacakge{siunitx}
\RequirePacakge{physics}
\RequirePacakge{caption}
\RequirePacakge{graphicx}
\RequirePacakge{mhchem}
\RequirePacakge{siunitx}
\RequirePacakge{subfig}
\RequirePacakge{ragged2e}
\RequirePacakge{xcolor}
\RequirePacakge{amsmath, arydshln, array}
\RequirePacakge{tikz}
\RequirePacakge{hyperref}
% \RequirePacakge{setspace}
\RequirePacakge[natbib=true, style=phys, autocite=footnote, articletitle=false, pageranges=false, citestyle=authoryear]{biblatex}
\RequirePacakge{perpage} %the perpage package

\usefonttheme[onlymath]{serif}
\MakePerPage{footnote}
\urlstyle{sf}
\usetheme{Madrid}
\usecolortheme{default}

\newcommand{\srcsize}{\@setfontsize{\srcsize}{5pt}{5pt}}

\newcommand{\slfrac}[2]{\left.#1\middle/#2\right.}

\setbeamercolor{footlinecolor1}{fg=white,bg=black}
\setbeamercolor{footlinecolor2}{fg=black,bg=lightgray}
\setbeamertemplate{navigation symbols}{}
% \setbeamertemplate{frametitle}[default][center]

\setbeamertemplate{frametitle}{%
    \vspace{-0.13cm}
\begin{beamercolorbox}[wd=\paperwidth, ht=0.5cm, dp=0.2cm]{frametitle}
\center\usebeamerfont{frametitle}\insertframetitle
\end{beamercolorbox}
}

\setbeamertemplate{footline}
{
  \leavevmode%
  \hbox{%
  \begin{beamercolorbox}[wd=.5\paperwidth,ht=2.25ex,dp=1ex,center]{footlinecolor1}%
    \usebeamerfont{author in head/foot}\insertshortinstitute\insertshortauthor
  \end{beamercolorbox}%
  \begin{beamercolorbox}[wd=.5\paperwidth,ht=2.25ex,dp=1ex,center]{footlinecolor2}%
    \usebeamerfont{title in head/foot}\insertshorttitle\hspace*{2ex}
 \insertframenumber{} / \inserttotalframenumber\hspace*{2ex}
  \end{beamercolorbox}}%
  \vskip0pt%
}


\renewbibmacro*{name:andothers}{% Based on name:andothers from biblatex.def
  \ifboolexpr{
    test {\ifnumequal{\value{listcount}}{\value{liststop}}}
    and
    test \ifmorenames
  }
    {\ifnumgreater{\value{liststop}}{1}
       {\finalandcomma}
       {}%
     \andothersdelim\bibstring[\emph]{andothers}}
    {}
}
