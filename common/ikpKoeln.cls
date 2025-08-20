% tex file
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ikpKoeln}[2024/03/07 Beamer template for IKP uni Koeln]

\RequirePackage{xcolor}
\RequirePackage{luacode}
\RequirePackage{luapackageloader}
% \RequirePackage[backend=bibtex, style=phys, autocite=footnote, articletitle=false, pageranges=false, citestyle=authoryear]{biblatex}
\RequirePackage[backend=biber, style=phys, autocite=footnote, articletitle=false, pageranges=false, citestyle=authoryear]{biblatex}


\LoadClass[compress, 10pt, aspectratio=169, noamssymb, serif]{beamer}
\usetheme{Madrid}

\RequirePackage[T1]{fontenc}
\RequirePackage{fourier-otf}

% \usefonttheme[onlymath]{serif}
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

% footline settings:
\setbeamerfont{footline}{size=\scriptsize\selectfont}
\setbeamertemplate{footline}
{
	\leavevmode%
	\hbox{%
		\begin{beamercolorbox}[wd=.5\paperwidth,ht=2.25ex,dp=1ex,center]{footlinecolor1}%
			\usebeamerfont{author in head/foot}\insertshortinstitute\insertshortauthor
		\end{beamercolorbox}%
		\begin{beamercolorbox}[wd=.5\paperwidth,ht=2.25ex,dp=1ex,center]{footlinecolor2}%
			\usebeamerfont{title in head/foot}\insertshorttitle
		\end{beamercolorbox}%
        \setlength{\fboxsep}{0pt}%
        \setlength{\fboxrule}{0pt}%
        \hspace{-3.5em}\framebox{\parbox{3em}{\raggedleft\usebeamerfont{title in head/foot} \insertframenumber{} / \inserttotalframenumber}}
        }
	\vskip0pt%
}

% change the shape of itemize and enumerate
\setbeamertemplate{itemize items}[square]
\setbeamertemplate{enumerate items}[default]

% setup the footnote number in a square bracket
\setbeamerfont{footnote}{size=\scriptsize}
\makeatletter
\renewcommand\thempfootnote{\arabic{mpfootnote}}
\renewcommand\@makefnmark{\hbox{\@textsuperscript{\usebeamercolor[fg]{footnote mark}\usebeamerfont*{footnote mark}[\@thefnmark]}}}
% \renewcommand\@makefntext[1]{\@textsuperscript{\usebeamercolor[fg]{footnote mark}\usebeamerfont*{footnote mark}[\@thefnmark]}\enspace\usebeamerfont*{footnote} #1}
\makeatother

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

\luadirect{
	TitlePage = require("ikpKoeln")
	JabbrConverter = require("jabbrConverter")
}

\newcommand*{\scAffiliation}[2]{\luadirect{
		TitlePage.add_affiliation({
				id = \luastring{#1},
				affiliation = \luastring{#2},
			})
	}}

\newcommand*{\scAuthor}[4]{\luadirect{
		TitlePage.add_author_name({
				is_stared = \luastring{#1},
				first_name = \luastring{#2},
				family_name = \luastring{#3},
				affiliation_number = \luastring{#4}
			})
	}}

\newcommand*{\scTitle}[1]{\luadirect{
		TitlePage.title = \luastring{#1}
	}}

\newcommand*{\scTitleShort}[1]{\luadirect{
		TitlePage.title_short = \luastring{#1}
	}}

\newcommand*{\scEmail}[1]{\luadirect{
		TitlePage.email = \luastring{#1}
	}}

\newcommand*{\scUni}[1]{\luadirect{
		TitlePage.uni = \luastring{#1}
	}}

\newcommand*{\scWG}[1]{\luadirect{
		TitlePage.working_group = \luastring{#1}
	}}

\newcommand*{\useJabbr}[1]{
	\luadirect{
        tex.print(JabbrConverter.convert(\luastring{#1}))
        % texio.write(JabbrConverter.convert(\luastring{#1}))
	}
}

\newcommand*{\titleFrame}{
	\luadirect{
		tex.print(TitlePage.get_names())
		tex.print(TitlePage.get_affiliations())
		tex.print(TitlePage.get_title())
	}

	{
		\usebackgroundtemplate{\includegraphics[width=\paperwidth]{TitleLogo}}
		\begin{frame}
			\fontsize{13}{7.2}\selectfont
			\titlepage
			\vfill
			\flushright{\tiny Email: \textit{\luadirect{tex.print(TitlePage.email)}}}
		\end{frame}
	}
}
