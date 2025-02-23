% tex file
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ikpKoeln}[2024/03/07 Beamer template for IKP uni Koeln]

\RequirePackage{xcolor}
\RequirePackage{luacode}
\RequirePackage{luapackageloader}
\RequirePackage[backend=bibtex, style=phys, autocite=footnote, articletitle=false, pageranges=false, citestyle=authoryear]{biblatex}
% \RequirePackage[backend=biber, style=numeric, autocite=footnote, citestyle=authoryear, maxcitenames = 1, defernumbers=true]{biblatex}


\LoadClass[compress, 13pt, aspectratio=169]{beamer}
\usetheme{Madrid}

\usefonttheme[onlymath]{serif}
% \MakePerPage{footnote}
\urlstyle{sf}
\newcommand{\srcsize}{\@setfontsize{\srcsize}{5pt}{5pt}}
\newcommand{\slfrac}[2]{\left.#1\middle/#2\right.}

\usecolortheme{default}

\setbeamercolor{footlinecolor1}{fg=white,bg=black}
\setbeamercolor{footlinecolor2}{fg=black,bg=lightgray}

\setbeamertemplate{blocks}[rounded][shadow]
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

\luadirect{TitlePage = require("ikpKoeln")}

\newcommand*{\scAffiliation}[2]{\luadirect{
		TitlePage.add_affiliation(
		{
				id = \luastring{#1},
				affiliation = \luastring{#2},
			}
		)
	}}

\newcommand*{\scAuthor}[4]{\luadirect{
		TitlePage.add_author_name(
		{
				is_stared = \luastring{#1},
				first_name = \luastring{#2},
				family_name = \luastring{#3},
				affiliation_number = \luastring{#4}
			}
		)
	}}

\newcommand*{\scTitle}[1]{\luadirect{
		TitlePage.title = \luastring{#1}
	}}

\newcommand*{\scTitleShort}[1]{\luadirect{
		TitlePage.title_short = \luastring{#1}
	}}

\AtBeginDocument{
	\luadirect{
		tex.print(TitlePage.get_names())
		tex.print(TitlePage.get_affiliations())
		tex.print(TitlePage.get_title())
	}

	{
		\usebackgroundtemplate{\includegraphics[width=\paperwidth]{TitleLogo}}
		\begin{frame}
			\titlepage
			\flushright\vfill{\tiny Email: \textit{ywang@ikp.uni-koeln.de}}
		\end{frame}
	}
}
