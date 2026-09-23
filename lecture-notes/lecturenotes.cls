% lecturenotes.cls --- a document class for self-contained, first-principles
% lecture notes. The formatting rules this class implements, and the reasons
% for each, are in docs/formatting-guide.md; template.tex exercises
% every element.
%
% Layout: A4, 11 pt, 2.4 cm margins; Palatino text and mathematics; navy
% headings; a centred title page; contents on its own page; every Part
% opening on a fresh page under a ruled heading; one shared counter for all
% numbered statements; boxed summaries and algorithms; figures whose
% captions carry the interpretation; thin-ruled tables; clickable
% cross-references; page-x-of-y footers.
%
% Compile with pdflatex, twice (contents, LastPage and cross-references all
% need the second pass).

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lecturenotes}[2026/09/23 v1.0 First-principles lecture notes]

% Page geometry and body size are part of the design, not options.
\LoadClass[11pt,a4paper]{article}
\RequirePackage[margin=2.4cm]{geometry}

% ---------------------------------------------------------------------------
% Fonts. amsmath and amsthm must precede newpxmath (newpx documentation).
% amssymb is deliberately not loaded: newpxmath supplies its symbols and the
% two clash.
% ---------------------------------------------------------------------------
\RequirePackage[T1]{fontenc}
\RequirePackage{amsmath}
\RequirePackage{amsthm}
\RequirePackage{newpxtext}
\RequirePackage{newpxmath}
\RequirePackage{microtype}

% ---------------------------------------------------------------------------
% Colours. notenavy is a deep step of matplotlib's default #1f77b4 blue, so
% headings harmonise with figures drawn in default colours.
% ---------------------------------------------------------------------------
\RequirePackage{xcolor}
\definecolor{notenavy}{HTML}{14507E}
\definecolor{summarybar}{HTML}{5B87AC}
\definecolor{summarybg}{HTML}{F3F7FA}

% ---------------------------------------------------------------------------
% Paragraphs: unindented, separated by a small stretchable skip.
% ---------------------------------------------------------------------------
\setlength{\parindent}{0pt}
\setlength{\parskip}{6pt plus 2pt minus 1pt}

% ---------------------------------------------------------------------------
% Page-break hygiene: no widows or orphans, and a slightly loose line is
% preferred to an overfull one.
% ---------------------------------------------------------------------------
\clubpenalty=10000
\widowpenalty=10000
\displaywidowpenalty=10000
\emergencystretch=1.5em

% ---------------------------------------------------------------------------
% Title-page metadata: \title, \author and \date as usual, plus
%   \subtitle{...}      the question the note answers (title page);
%   \series{...}        right-hand running header, e.g. "Course --- lecture notes";
%   \runningtitle{...}  left-hand running header (defaults to \title).
% ---------------------------------------------------------------------------
\def\ln@subtitle{}
\def\ln@series{Lecture notes}
\def\ln@runningtitle{}
\newcommand{\subtitle}[1]{\def\ln@subtitle{#1}}
\newcommand{\series}[1]{\def\ln@series{#1}}
\newcommand{\runningtitle}[1]{\def\ln@runningtitle{#1}}

% Default date is "Month Year": a set of notes is revised, not dated to the day.
\newcommand{\ln@monthname}{\ifcase\month\or January\or February\or March\or
  April\or May\or June\or July\or August\or September\or October\or
  November\or December\fi}
\date{\ln@monthname\ \number\year}

\renewcommand{\maketitle}{%
  \begin{titlepage}
    \vspace*{\fill}
    \begin{center}
      {\LARGE\bfseries\color{notenavy}\@title\par
       \ifx\ln@subtitle\@empty\else
         \vskip 0.4em{\large\ln@subtitle\par}\fi}
      \vskip 3em
      {\large\@author\par}
      \vskip 1.5em
      {\large\@date\par}
    \end{center}
    \vspace*{\fill}
  \end{titlepage}
  \setcounter{page}{2}% the title page is page 1; numbering resumes after it
}

% ---------------------------------------------------------------------------
% Headings.
%   \part       "Part I --- Foundations": navy, ruled, always on a fresh page.
%               Numbered 0, I, II, ...: Part 0 is the notation and vocabulary.
%   \section    "3. Title": navy. Numbered from 0, continuously across Parts.
%   \subsection "3.1 Title": bold black.
%   \subsubsection unnumbered bold; \paragraph a bold run-in lead.
% A heading is never stranded at the foot of a page (nobottomtitles*).
% ---------------------------------------------------------------------------
\RequirePackage[nobottomtitles*]{titlesec}
\RequirePackage{titletoc}

\setcounter{part}{-1}
\setcounter{section}{-1}
\renewcommand{\thepart}{\ifnum\value{part}=0 0\else\Roman{part}\fi}
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{1}

% \part is defined directly rather than through titlesec: titlesec leaves
% article's contents writer in place for \part, which omits \numberline and
% so defeats the "Part 0 --- Title" contents format below.
\renewcommand{\part}[1]{%
  \clearpage
  \refstepcounter{part}%
  \addcontentsline{toc}{part}{\protect\numberline{\thepart}#1}%
  {\LARGE\bfseries\color{notenavy}Part \thepart\ --- #1\par}%
  \vspace{2pt}{\color{notenavy}\hrule height 0.6pt}\vspace{14pt}%
  \@afterheading}

\titleformat{\section}
  {\large\bfseries\color{notenavy}}{\thesection.}{0.5em}{}
\titleformat{\subsection}
  {\normalsize\bfseries}{\thesubsection}{0.6em}{}
\titleformat{\subsubsection}
  {\normalsize\bfseries}{}{0pt}{}
\titleformat{\paragraph}[runin]
  {\normalsize\bfseries}{}{0pt}{}
\titlespacing*{\section}{0pt}{16pt plus 4pt minus 2pt}{7pt}
\titlespacing*{\subsection}{0pt}{12pt plus 3pt minus 2pt}{5pt}
\titlespacing*{\subsubsection}{0pt}{12pt plus 3pt minus 2pt}{5pt}
\titlespacing*{\paragraph}{0pt}{6pt plus 2pt}{0.5em}

% Contents: Parts bold with space above; sections indented with dotted
% leaders; entries black (they are links, but a navy contents page is loud).
% The contents sit on their own page.
\titlecontents{part}[0pt]{\addvspace{10pt}\bfseries}
  {Part \thecontentslabel\ --- }{}{\hfill\contentspage}[\addvspace{2pt}]
\titlecontents{section}[1.2em]{}
  {\thecontentslabel.\ }{}{\titlerule*[0.6pc]{.}\contentspage}
\let\ln@oldtoc\tableofcontents
\renewcommand{\tableofcontents}{{\hypersetup{linkcolor=black}\ln@oldtoc}\clearpage}

% \appendix: sections become "Appendix A: Title", in the text and contents.
\g@addto@macro\appendix{%
  \titleformat{\section}
    {\large\bfseries\color{notenavy}}{Appendix \thesection:}{0.5em}{}%
  \titlecontents{section}[1.2em]{}
    {Appendix \thecontentslabel:\ }{}{\titlerule*[0.6pc]{.}\contentspage}}

% A thematic break: a short grey rule, e.g. between the front-matter
% paragraphs and the reading map.
\newcommand{\separator}{\par\nopagebreak\vspace{4pt}\noindent\hfil
  \textcolor{black!40}{\rule[0.5ex]{0.35\linewidth}{0.5pt}}\hfil\par\vspace{4pt}}

% ---------------------------------------------------------------------------
% Running headers and footers: note title left, series right, "x of y" below.
% plain is redefined to match, so pages opened by \part or the contents keep
% the header.
% ---------------------------------------------------------------------------
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\setlength{\headheight}{14pt}
\newcommand{\ln@headfoot}{%
  \fancyhf{}%
  \fancyhead[L]{\small\itshape
    \ifx\ln@runningtitle\@empty\@title\else\ln@runningtitle\fi}%
  \fancyhead[R]{\small\itshape\ln@series}%
  \fancyfoot[C]{\small\thepage\ of \pageref{LastPage}}%
  \renewcommand{\headrulewidth}{0.4pt}}
\fancypagestyle{plain}{\ln@headfoot}
\pagestyle{fancy}
\ln@headfoot

% ---------------------------------------------------------------------------
% Boxes.
%   summary    plain-language restatement after a derivation: a navy bar over
%              a pale blue wash, small type, no label.
%   algorithm  a numbered Algorithm statement inside the same box. The
%              optional argument is the name: \begin{algorithm}[Newton step].
%              (Clashes with the algorithm package; do not load both.)
%   \keyresult{...}  frame the final result of a derivation, in display math.
% ---------------------------------------------------------------------------
\RequirePackage{framed}
\newenvironment{summary}
  {\def\FrameCommand{{\color{summarybar}\vrule width 2.5pt}\hspace{0pt}%
     \fboxsep=7pt\colorbox{summarybg}}%
   \MakeFramed{\advance\hsize-\width\FrameRestore}\small}
  {\endMakeFramed}
% \leavevmode sets the heading on a line of its own: an amsthm body that
% opens with a list would otherwise run the first item into the heading.
\newenvironment{algorithm}[1][]
  {\begin{summary}%
   \if\relax\detokenize{#1}\relax\begin{ln@algorithm}%
   \else\begin{ln@algorithm}[#1]\fi
   \leavevmode}
  {\end{ln@algorithm}\end{summary}}
\newcommand{\keyresult}[1]{\boxed{\thickspace#1\thickspace}}

% ---------------------------------------------------------------------------
% Figures: full text width by default, placed here or at a page top or
% bottom, never deferred to a float page of their own ('p' is omitted). Where
% a \clearpage still forces a float-only page, figures sit at its top rather
% than centred. The caption *is* the interpretation; end it with
% \figcredit{<generating script>}.
% ---------------------------------------------------------------------------
\RequirePackage{graphicx}
\setkeys{Gin}{width=\linewidth}
\def\fps@figure{htb}
\setlength{\@fptop}{0pt}
\setlength{\@fpbot}{0pt plus 1fil}
\RequirePackage{caption}
\captionsetup{font=small, labelfont=bf, skip=7pt}
\newcommand{\figcredit}[1]{\textit{Generated by \nolinkurl{#1}.}}

% ---------------------------------------------------------------------------
% Tables: booktabs rules, extra row height, and \rowrule for the thin grey
% line between body rows (a \noalign'd hairline; colortbl is avoided because
% some distributions ship a version incompatible with array.sty).
%   verification  Appendix A's table: Claim | § | Check | Result.
% ---------------------------------------------------------------------------
\RequirePackage{array}
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\renewcommand{\arraystretch}{1.2}
\newcommand{\rowrule}{\noalign{\vskip 1.5pt
  {\color{black!20}\hrule height 0.4pt}\vskip 1.5pt}}
\newcolumntype{L}{>{\raggedright\arraybackslash}X}
\newenvironment{verification}
  {\par\noindent\tabularx{\linewidth}
     {@{}L l L >{\raggedright\arraybackslash}p{0.2\linewidth}@{}}
   \toprule Claim & \S & Check & Result \\ \midrule}
  {\bottomrule\endtabularx\par}

% ---------------------------------------------------------------------------
% References: the bibliography is listed in the contents like a section,
% with its own link target.
% ---------------------------------------------------------------------------
\let\ln@oldthebibliography\thebibliography
\renewcommand{\thebibliography}[1]{%
  \phantomsection\addcontentsline{toc}{section}{\refname}%
  \ln@oldthebibliography{#1}}

% ---------------------------------------------------------------------------
% Links and cross-references. hyperref and cleveref load after every other
% package (both require it); only the statement declarations follow them.
% \cref{lem:jensen} -> "Lemma 0.5"; \cref{sec:x} -> "§4.3";
% \cref{app:checks} -> "Appendix A". The kind is read from the label's
% environment, so a lemma can never be cited as a theorem.
% ---------------------------------------------------------------------------
\RequirePackage[pdfusetitle,bookmarksnumbered]{hyperref}
\hypersetup{colorlinks=true, linkcolor=notenavy, urlcolor=notenavy,
            citecolor=notenavy}
\renewcommand{\theHpart}{\arabic{part}}
\RequirePackage[capitalise,noabbrev]{cleveref}
\crefname{part}{Part}{Parts}
\crefname{appendix}{Appendix}{Appendices}
\crefname{equation}{Eq.}{Eqs.}
% Sections cite as "§4.3". The capitalised (\Cref) forms must be set
% explicitly: cleveref would otherwise derive them by upper-casing the first
% token, which here is the link argument, not a letter.
\newcommand{\ln@sectionrefs}[1]{%
  \crefformat{#1}{##2\S##1##3}%
  \Crefformat{#1}{##2\S##1##3}%
  \crefrangeformat{#1}{\S\S##3##1##4--##5##2##6}%
  \Crefrangeformat{#1}{\S\S##3##1##4--##5##2##6}%
  \crefmultiformat{#1}{\S\S##2##1##3}{ and~##2##1##3}{, ##2##1##3}{ and~##2##1##3}%
  \Crefmultiformat{#1}{\S\S##2##1##3}{ and~##2##1##3}{, ##2##1##3}{ and~##2##1##3}}
\ln@sectionrefs{section}
\ln@sectionrefs{subsection}

% ---------------------------------------------------------------------------
% Numbered statements. One counter, numbered within section (Lemma 0.5 is
% followed by Definition 0.6), so a number alone locates any statement.
% Head, number and optional name are all bold; the body is upright.
% Declared after cleveref deliberately: only then does cleveref record each
% environment's own kind for counter-sharing theorems (otherwise every label
% would cite as "Theorem").
%   theorem, lemma, proposition, corollary  --- proved in the text
%   definition                              --- introduces a term
%   fact                                    --- used without proof, on trust
%   algorithm                               --- a procedure, set in a box
% ---------------------------------------------------------------------------
\newtheoremstyle{lecturenote}
  {6pt}{6pt}{\upshape}{0pt}{\bfseries}{.}{0.5em}
  {\thmname{#1}\thmnumber{ #2}\thmnote{ (#3)}}
\theoremstyle{lecturenote}
\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{definition}[theorem]{Definition}
\newtheorem{fact}[theorem]{Fact}
\newtheorem{ln@algorithm}[theorem]{Algorithm}

% Proofs end with a filled square.
\renewcommand{\qedsymbol}{\ensuremath{\blacksquare}}

% Equations are unnumbered by default (\[ \]); number only those referenced.
\numberwithin{equation}{section}
\crefname{theorem}{Theorem}{Theorems}
\crefname{lemma}{Lemma}{Lemmas}
\crefname{proposition}{Proposition}{Propositions}
\crefname{corollary}{Corollary}{Corollaries}
\crefname{definition}{Definition}{Definitions}
\crefname{fact}{Fact}{Facts}
\crefname{ln@algorithm}{Algorithm}{Algorithms}

\endinput
