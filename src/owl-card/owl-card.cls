\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{owl-card}[%
    2025/09/01 v0.0-dev A LaTeX Class for Busines cards.%
]

% Compare with:
% [Is there a good document template for making business cards?](https://tex.stackexchange.com/questions/4693)

% ---

% Not strictly necessary … rather a warning.
% expl3 – Wrapper package for experimental LaTeX3.
\RequirePackage{expl3}

% ---

% Class Options

\ExplSyntaxOn

\prop_new:N \g__oc_doc_style_prop

\keys_define:nn { oc/doc-style }
{
    accentcolor .code:n = { \prop_put:Nnn \g__oc_doc_style_prop { accentcolor } {#1} },
    accentcolor .initial:n = red,
    bgcolor .code:n = { \prop_put:Nnn \g__oc_doc_style_prop { bgcolor } {#1} },,
    bgcolor .initial:n = black,
    fgcolor .code:n = { \prop_put:Nnn \g__oc_doc_style_prop { fgcolor } {#1} },
    fgcolor .initial:n = white,
}

\ProcessKeyOptions[oc/doc-style]

\clist_new:N \l__oc_doc_style_keys_clist
\clist_set:Nn \l__oc_doc_style_keys_clist {
    % Colo(u)rs
    bgcolor,fgcolor,accentcolor
}
\clist_map_inline:Nn \l__oc_doc_style_keys_clist {
    \prop_get:NnN \g__oc_doc_style_prop { #1 } \l_tmpa_tl
    \tl_set:Nx \l_tmpb_tl { \tl_upper_case:n { \tl_head:n {#1} } \tl_tail:n {#1} }
    \tl_set:cx { ocds\l_tmpb_tl } { \tl_to_str:N \l_tmpa_tl }
}

\ExplSyntaxOff

% ---

% Class and Packages Loading

% Loads skeleton with options.
\LoadClass[%
    parskip={half},%
    fontsize={11pt},%
    % visualise,%
]{scrartcl}

% geometry - Flexible and complete interface to document dimensions.
\RequirePackage{geometry}
\geometry{
    % TODO: Insert note on DIN size
    paperwidth={85mm},
    paperheight={55mm},
    inner={7.5mm},
    outer={7.5mm},
    top={16mm},
    bottom={16mm},
}

% fontspec – Advanced font selection in XeLaTeX and LuaLaTeX.
\usepackage{fontspec}

% Sets default fonts.
% \setmainfont{Libertinus Serif}
\setsansfont{Libertinus Sans}[
    Numbers={OldStyle,Proportional}
]
% \setmonofont{Libertinus Mono}

% Select sans serif font as default.
\renewcommand*{\familydefault}{\sfdefault}

% microtype – Subliminal refinements towards typographical perfection.
\RequirePackage{microtype}

% graphbox - Extend graphicx to improve placement of graphics.
\RequirePackage{graphbox}

% xcolor - Driver-independent color extensions for LaTeX and pdfLaTeX.
\RequirePackage{xcolor}

\AtBeginDocument{%
    \colorlet{bgcolor}{\ocdsBgcolor}
    \colorlet{fgcolor}{\ocdsFgcolor}
    \colorlet{accentcolor}{\ocdsAccentcolor}
}

% tikz - Create PDF graphics in TeX.
\RequirePackage{tikz}
\usetikzlibrary{shapes.misc}

% qrcode – Generate QR codes in LaTeX.
\RequirePackage{qrcode}

% ---

% Document Information

\ExplSyntaxOn

% Creates a global property list to hold document information.
\prop_new:N \g__oc_doc_info_property

% Global property list to hold document info.
\prop_new:N \g__oc_doc_info_prop

% Key definitions with initial placeholders.
\keys_define:nn { oc/doc-info }
{
    givenname .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { givenname } {#1} },
    givenname .initial:n = { <VAR>givenname</VAR> },
    lastname .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { lastname } {#1} },
    lastname .initial:n = { <VAR>lastname</VAR> },
    additionalnames .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { additionalnames } {#1} },
    additionalnames .initial:n = { <VAR>additionalnames</VAR> },
    honoricprefix .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { honoricprefix } {#1} },
    honoricprefix .initial:n = { <VAR>honoricprefix</VAR> },
    honoricsuffix .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { honoricsuffix } {#1} },
    honoricsuffix .initial:n = { <VAR>honoricsuffix</VAR> },
    birthday .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { birthday } {#1} },
    birthday .initial:n = { <VAR>birthday</VAR> },
    street .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { street } {#1} },
    street .initial:n = { <VAR>street</VAR> },
    locality .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { locality } {#1} },
    locality .initial:n = { <VAR>locality</VAR> },
    region .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { region } {#1} },
    region .initial:n = { <VAR>region</VAR> },
    postalcode .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { postalcode } {#1} },
    postalcode .initial:n = { <VAR>postalcode</VAR> },
    country .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { country } {#1} },
    country .initial:n = { <VAR>country</VAR> },
    email .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { email } {#1} },
    email .initial:n = { <VAR>email</VAR> },
    phone .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { phone } {#1} },
    phone .initial:n = { <VAR>phone</VAR> },
    web .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { web } {#1} },
    web .initial:n = { <VAR>web</VAR> },
    github .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { github } {#1} },
    github .initial:n = { <VAR>github</VAR> },
    linkedin .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { linkedin } {#1} },
    linkedin .initial:n = { <VAR>linkedin</VAR> },
    pgpkey .code:n = { \prop_put:Nnn \g__oc_doc_info_prop { pgpkey } { \detokenize{#1} } },
    pgpkey .initial:n = { \detokenize{<VAR>pgpkey</VAR>} },
}

\AtBeginDocument{
    \clist_new:N \l__oc_doc_info_keys_clist
    \clist_set:Nn \l__oc_doc_info_keys_clist {
        givenname,lastname,additionalnames,honoricprefix,honoricsuffix,birthday,street,locality,region,postalcode,country,email,phone,web,github,linkedin,pgpkey
    }
    \clist_map_inline:Nn \l__oc_doc_info_keys_clist {
        \prop_get:NnN \g__oc_doc_info_prop { #1 } \l_tmpa_tl
        \tl_set:Nx \l_tmpb_tl { \tl_upper_case:n { \tl_head:n {#1} } \tl_tail:n {#1} }
        \tl_set:cx { ocdi\l_tmpb_tl } { \tl_to_str:N \l_tmpa_tl }
    }
}

% User macro for setting values of oc/doc-info.
\NewDocumentCommand \ocDocInfo { m }
{ \keys_set:nn { oc/doc-info } { #1 } }

\ExplSyntaxOff

% ---

\pagestyle{empty}

\newcommand*{\vcard}{%
    BEGIN:VCARD^^J%
    VERSION:4.0^^J%
    N:\ocdiLastname;\ocdiGivenname;\ocdiAdditionalnames;\ocdiHonoricprefix;\ocdiHonoricsuffix^^J%
    FN:\ocdiHonoricprefix{ }\ocdiGivenname{ }\ocdiAdditionalnames{ }\ocdiLastname{ }\ocdiHonoricsuffix^^J%
    BDAY:\ocdiBirthday^^J%
    ADR:;;\ocdiStreet;\ocdiLocality;\ocdiRegion;\ocdiPostalcode;\ocdiCountry^^J%
    TEL:\ocdiPhone^^J%
    EMAIL:\ocdiEmail^^J%
    % % ENIGMA Are MATRIX entries really declared this way?
    % MATRIX:\ocdiMatrix^^J%
    URL:https://\ocdiWeb^^J%
    URL:https://www.linkedin.com/\ocdiLinkedin^^J%
    URL:https://github.com/\ocdiGithub^^J%
    % KEY:\ocdiPGPkey^^J%
    END:VCARD^^J%
}

\newcommand*{\MakeFront}{%
    \begin{tikzpicture}[remember picture, overlay]
        \fill[bgcolor] (current page.south west) rectangle (current page.north east);

        \coordinate (C) at (current page.center);

        \node[anchor=center]
        at ([yshift={0.33\paperheight}] C){%
            {\huge\color{fgcolor}{\bfseries\scshape{\color{accentcolor}\ocdiGivenname}~\ocdiLastname}}
        };

        \def\radius{0.16\paperheight}

        \fill[white]
        ([shift={(-\radius,-\radius)}]C) rectangle ([shift={(\radius,\radius)}]C);

        \node[anchor=center]
        at ([yshift={0\paperheight}] C){%
            \color{bgcolor}\qrcode[height={0.32\paperheight}]{\vcard}
        };

        \node[anchor=center]
        at ([yshift={-0.30\paperheight}] C){%
            {\color{fgcolor}{\bfseries\scshape{\color{accentcolor}Mailto:}~\ocdiEmail}}
        };

        \node[anchor=center]
        at ([yshift={-0.40\paperheight}] C){%
            {\color{fgcolor}{\bfseries\scshape{\color{accentcolor}Tel:}~\ocdiPhone}}
        };
    \end{tikzpicture}
}

\newlength{\dotdistx}
\setlength{\dotdistx}{5.0mm}
\newlength{\dotdisty}
\setlength{\dotdisty}{5.0mm}

\pgfmathtruncatemacro{\dotnumx}{7}
\pgfmathtruncatemacro{\dotnumy}{4}

\tikzset{%
    cross/.style={%
            cross out,%
            % minimum size={2 * (#1 - \pgflinewidth)},%
            draw={accentcolor},%
            inner sep={0mm},%
            outer sep={0mm},%
            outer sep={0mm},%
            line width={0.05mm},%
        },%
    % cross/.default={0.5 pt},%
}

\newcommand*{\CreateGrid}{
    \begin{tikzpicture}[remember picture, overlay]
        \foreach \x in {- \dotnumx, ..., \dotnumx}{
                \foreach \y in {- \dotnumy, ..., \dotnumy}{
                        \pgfmathtruncatemacro{\absval}{%
                            70 + 5 * max(\x * \dotnumy, -\x * \dotnumy, \y * \dotnumx, -\y * \dotnumx)%
                        }
                        \definecolor{tmpcolor}{RGB}{\absval,\absval,\absval}
                        \draw ({\x * \dotdistx}, {\y * \dotdisty}) node[cross = 2 mm, rotate = 45, color = tmpcolor] {};
                        % \fill[accentcolor] ( { \x * 5.0 mm }, { \y * 5.0 mm } ) circle[radius = 0.1 mm];
                    }
            }
    \end{tikzpicture}
}

\newcommand*{\MakeBack}{%
    \begin{tikzpicture}[remember picture, overlay]
        \fill[bgcolor] (current page.south west) rectangle (current page.north east);
        \node[
            xshift=0,
            yshift=0,
            anchor=center,
        ] at (current page.center){%
            \CreateGrid%
        };
    \end{tikzpicture}
}

\newcommand{\MakeCard}{%
    \clearpage\par\MakeFront%
    \clearpage\par\MakeBack%
}
