# Academic title page

Use this title page for new research manuscripts and for manuscript revisions
that adopt the series layout. The reference is the earlier Kupzyk replication
in `formalization/kupzyk-power-assumptions/paper/`. Use the 11 pt article class,
US Letter, and Computer Modern or Latin Modern roman. Keep the article's
standard title mechanism and paragraph typography. The shared title input
reproduces the space before the inset Abstract.

Declare the title and release date explicitly. A short second title line can
use `\\` within the title at the same size. Omit the author line unless the
user requests it. Put the date in day–month–year or month–day–year form,
spelling out the month. A recorded release date gives repeatable builds.

```tex
\title{A mathematical result\\A descriptive second line}
\date{9 November 2026}
\begin{document}
\input{../handoff/academic-title.tex}
\begin{abstract}
...
\end{abstract}
```

Input the [approved title asset](../assets/academic-title.tex) directly or
keep an exact copy among the manuscript's build inputs. The same title file
works with the replication preamble and a proof manuscript's article
preamble. Study-specific tables, theorem environments and proof appendices
stay in the manuscript. Give a longer abstract or comparison table enough
room to stay legible. Follow the applicable skill's first-page requirements.

Run the gate on the exact compiled manuscript:

```sh
python3 scripts/release/title_page.py --paper paper/main.tex --pdf paper/main.pdf
```

With no PDF argument, the checker accepts the same-stem companion only.
Replication preflight uses that companion and delivery uses the source and
primary PDF named in its delivery record. The check measures the first
title baseline, title line spacing, date presence, type sizes and centering,
and the gaps from the last title line to the date and from the date to the
Abstract. It allows a small range for standard article title blocks with
different author fields. Record any project-approved layout departure in
the release notes and review the exact rendered first page against the
reference, including the table or introductory text.
