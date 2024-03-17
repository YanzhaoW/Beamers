% tex file
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ikpKoeln}[2024/03/07 Beamer template for IKP uni Koeln]

\RequirePackage{xcolor}
\RequirePackage{luacode}
\RequirePackage[backend=bibtex, style=phys, autocite=footnote, articletitle=false, pageranges=false, citestyle=authoryear]{biblatex}


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

\begin{luacode*}
    author_names = {}
    main_author_name = ""
    affiliations = {}
    title = ""
    title_short = ""
    
    function add_author_names(input)
        table.insert(author_names, {is_stared = input.is_stared, full_name = input.first_name .. " " .. input.family_name, affiliation_number = input.affiliation_number})

        if input.is_stared == "*" then
            main_author_name = input.first_name .." ".. input.family_name
        end
    end

    function add_affiliations(input)
        table.insert(affiliations, input)
    end

    function get_title()
        tex.print(string.format([[\title[%s]{%s}]], title_short, title ))
        texio.write(string.format("\n" .. [[\title[%s]{%s}]], title_short, title ))
    end

    function get_names()
        local name_strings = {}
        for _, author_name in ipairs(author_names) do
            local name_string = author_name.full_name.. [[\inst{]]..author_name.affiliation_number.. [[}]]
            table.insert(name_strings, name_string)
        end
        local full_string = [[{ ]] .. table.concat(name_strings, ", ").. [[ }]]
        full_string = [[\author[ ]] .. main_author_name .. [[ ] ]] .. full_string
        tex.print(full_string)
        texio.write("\n" .. full_string)
    end

    function get_affiliations()
        local strings = {}
        for _, affiliation in ipairs(affiliations) do
            table.insert(strings, [[ \inst{ ]] .. affiliation.id .. [[ } ]] .. affiliation.affiliation)
        end
        local full_string = [[{ ]] .. table.concat(strings, [[\\]]) .. [[ }]]
        full_string =[[\institute[University of Cologne $\vert$ AG Zilges $\vert$ ] ]] .. full_string 
        tex.print(full_string)
        texio.write("\n" .. full_string)
    end
\end{luacode*}

\newcommand*{\scAffiliation}[2]{\luadirect{
    add_affiliations(
        {
            id = \luastring{#1},
            affiliation = \luastring{#2},
        }
    )
}}

\newcommand*{\scAuthor}[4]{\luadirect{
    add_author_names(
        {
            is_stared = \luastring{#1},
            first_name = \luastring{#2},
            family_name = \luastring{#3},
            affiliation_number = \luastring{#4}
        }
    )
}}
\newcommand*{\scTitle}[1]{\luadirect{
    title = \luastring{#1}
}}

\newcommand*{\scTitleShort}[1]{\luadirect{
    title_short = \luastring{#1}
}}

\AtBeginDocument{
    \luadirect{
    get_names()
    get_affiliations()
    get_title()
    }
	\usebackgroundtemplate{\includegraphics[width=\paperwidth]{TitleLogo}}
	\begin{frame}
		\titlepage
		\flushright\vfill{\tiny Email: \textit{ywang@ikp.uni-koeln.de}}
	\end{frame}
}
