---
name: replication-paper
description: "Replicate a published result and write the replication note and pull request. Use for the comparison table, page crops, graded claims, availability audit, the answer-first abstract, the engine preflight, the two-axis numerical check, and a pull request a reader can follow without the paper. When an announcement is requested, use the single-post template. A theorem-only writeup stays with open-question-research."
---

# Replication paper

Use this to replicate a published numerical, simulation, or statistical result
and to write the note and the pull request. When an announcement is
requested, draft it from the template below. A theorem-only paper stays with
[open-question research](../open-question-research/SKILL.md). A replication
that also contains proofs uses both: this skill for the comparison, the crops,
the graded claims, and the pull request; that skill for the proofs, the
chronology, and the Lean appendix.

The worked example is
[formalization/correlated-residuals/](../../../formalization/correlated-residuals/README.md),
merged as pull request 14. Commands below are from the repository root.

## Abstract and opening

The original work's headline result is the answer to its main research
question. Report that result first, whether it matched or not. Supporting
results that matched never lead when the headline missed.

The abstract, and the first paragraph of the introduction, open with our
verdict on that headline. The first sentence is the verdict, one of
replicated, partly replicated, or not replicated, followed by the
published-versus-ours headline numbers. When the headline missed, that
sentence says so. A matching supporting result does not take its place.

The next sentence is what we could not establish, phrased as the limit of
our evidence. Then any reversal of direction, with both sets of numbers.
Supporting detail comes after that. The research question comes after the
verdict, not before it.

State the match tolerance and the direction of each key effect or ordering
on page 1, in the abstract or in the headline table. Use "reported" or
"concluded". Do not write "the author claims".

Put the headline table immediately after the abstract, before the
introduction. Columns: claim, published, ours, same direction?, verdict.
The verdict is one of `match`, `partial`, `close`, `no match`,
`not separated`. Use `not separated` when the direction agrees and the
difference sits inside the tolerance, so a ranking of the two numbers is
not established. The caption or the abstract states the tolerance.

After that opening, order the note as a story: what replicated, then what
gave us trouble and how we fixed it, then what is still open together with
what we tried.

The worked example is the abstract of
[formalization/chumney-sem-small-samples/paper/paper.tex](../../../formalization/chumney-sem-small-samples/paper/paper.tex).
The first sentence is the verdict and the four headline numbers. The second
is the limit of the evidence. The third is the reversal:

> We replicated the headline result of Chumney (2013): on normal data at
> n = 1000, maximum likelihood and Bayesian Markov chain Monte Carlo recover
> measurement loadings far more accurately than partial least squares and
> generalized structured component analysis, with all four published bias
> values matched within two standard errors of the Monte Carlo means
> (maximum likelihood 2.712 versus 2.730, Markov chain Monte Carlo 2.738
> versus 2.902, partial least squares 15.896 versus 15.919, generalized
> structured component analysis 15.918 versus 15.938).
>
> Maximum likelihood is not separated from Markov chain Monte Carlo, so the
> further conclusion that maximum likelihood is the single most robust of the
> four is not established.
>
> The one reversal is the generalized structured component analysis trend at
> seven indicators: Chumney reported a rise from 9.734 at five items to
> 13.667 at seven, and our bias falls from 9.850 to 7.189.

The headline table in that note follows the abstract. Its tolerance is two
standard errors of the Monte Carlo means. Two of its rows:

| Claim | Published | Ours | Same direction? | Verdict |
| --- | --- | --- | --- | --- |
| ML measurement percent bias, n = 1000, three reflective items, correct model | 2.712 | 2.730 | Yes | Match |
| GSCA from five items to seven, n = 1000 | rises, 9.734 to 13.667 | falls, 9.850 to 7.189 | No | No match |

The introduction's first paragraph in that note repeats the same three-part
opening, then states the tolerance again.

- Keep process details out of the abstract and the opening. That includes how
  the note was produced.
- Do not put a language-model authorship statement anywhere in the note, the
  pull request, the README, a figure caption, or an announcement post.
- Omit the manuscript author line unless the user asks for one.

## Prose

- "Remove" means delete the words. Do not move them to another section, an
  appendix, a caption, or a footnote.
- Every section opens with the question it answers and the answer. In the
  abstract and the introduction, the answer comes first.
- Every paragraph opens with a topic sentence.
- Use plain words. Define a term the first time it appears.
- Write "reported" or "concluded". Do not write "the author claims".
- Do not use internal shorthand. Write "measuring sign positions on the page",
  not "glyph reading". File names stay as paths.

## What we did, and what we took from others

One section states our contribution: the proofs, the simulations, and the
comparison. The original work's contribution is the model, the design, and the
published tables. Each later number is labeled as one of: our calculation or
simulation, an assumption we supplied, or a figure taken from a cited source.

## Links and citations

Every replication note must have in-text scholarly citations and a References
section, not just software hyperlinks or an uncited reading list. Cite the
replicated work at the first substantive attribution and give page, table,
equation, or appendix locators for borrowed numbers, designs, and formulas.
Table captions must identify the source of published values separately from
our calculations. Use one consistent citation style; author--year is a useful
default unless the venue specifies another.

Cite primary methodological literature for estimators, uncertainty calculations,
multiple-testing procedures, and substantive interpretations actually used.
Use official version-specific documentation for software defaults, plus the
package's recommended academic citation where available. A software link and
version do not replace a method citation. Do not add unrelated literature to
inflate the bibliography. Distinguish our derivations and diagnostics from
published results; a related citation does not validate a new assumption.

Verify author, year, title, venue, and DOI or stable URL against the original
publication, publisher, institutional record, or installed package citation
metadata. Read the relevant source passage before attaching it to a claim.
If only a secondary attribution or abstract was available, record that limit;
never imply full-text verification or copy an unverified reference list.

Before delivery, audit claim-to-source coverage and record it in the compliance
ledger. Check that each citation resolves, every reference is used, links and
source locators are correct, and the rendered bibliography is readable. Keep
editable bibliography sources in the reproducible bundle and document the
build command. For ordinary LaTeX cite/citep/citet with bibitem or BibTeX keys,
run `scripts/check_citations.py PAPER --references REFERENCES --log BUILD_LOG`
from this skill directory. This structural check does not establish that a
source supports a claim; the source-reading audit remains mandatory. Other
formats need equivalent checks and a recorded result.

Code and data links in papers point at `master`.

Cite every piece of software used, with its exact version, and link its CRAN
page or repository. This covers R, lavaan, simsem, OpenMx, Lean, and Mathlib.
Say why each tool was chosen. For example, R and lavaan because the original
used them, simsem 0.5.16 because the dissertation names that version, and
OpenMx as an independent check on the optimizer. Use Lean for the algebra, and
R with an SEM package for statistical model fitting.

Deep-link every script, output file, and key function from the text, with line
anchors for theorems and functions. The visible link text must include the
actual filename and extension (for example, `model.R: empirical fits`, not
just `empirical fits`). Prefer a literal filename label, with any description
outside the link: `empirical fits ([model.R](...#L68))`. Preserve underscores
and extensions in rendered text, using an appropriate code/path font.
Verify the final PDF's visible link text and hyperlink annotations, not just
the manuscript source. Deliver a link to the newly built artifact; updating
source alone does not update previously downloaded or separately saved PDFs.

In the artifacts appendix, make each repository file and regeneration script
a clickable `master` link; a plain path or command is not sufficient. Use
`blob/master` for files and `tree/master` for directories. Preserve filename
extensions in visible labels and check function line anchors against the
actual source. Label external or separately delivered artifacts explicitly;
do not invent a repository URL for a file that is not included. Inspect the
rendered PDF to confirm that links remain readable and clickable.

## Engine

Fit the statistical models in R with lavaan. Use OpenMx as the second
optimizer. Before the first fit, run this from the repository root:

```sh
python3 .agents/skills/replication-paper/scripts/preflight.py
```

The script uses the Python standard library. It runs on Linux and on
macOS. It does not call GNU-only commands. It records the operating
system, whether `Rscript` is on the path, and the lavaan and OpenMx
versions.

If `Rscript`, lavaan, or OpenMx is missing, install them when the
machine allows it. Another engine is a departure. It is allowed only
when the preflight record contains a justification and a separate
validation, such as a second optimizer agreeing on a known value. Put
that departure in the compliance ledger. Do not switch to a custom fit
because a package was absent from the path.

## Compliance ledger

Keep a short ledger. Each row is one requirement, the status
`followed`, `departed`, or `not applicable`, and the evidence. A
departure needs a justification. The engine row comes from the
preflight. Copy the ledger into the note. `validate_ledger` in
[checks.py](scripts/checks.py) rejects a departure that has no
justification.

## Comparison table

The headline table immediately after the abstract is specified above.
The comparison table later in the note does not replace it. The later
table has these columns: claim, published, ours, precision, numerical,
scope. It may repeat the same-direction column. The numerical and scope
labels are defined below. Give each row one sentence that states the
reason. Put that sentence in the row when it fits, or in the paragraph
under the table that names the row.

Name any remaining gap by the cell, the value, and the band. Judge Monte Carlo
agreement against a band of two standard errors, then apply Bonferroni or Holm.

Keep small differences, such as typos, rounding, and boundary cases, in their
own list, and say plainly whether they are replication failures.

Give tables readable row spacing, for example `\arraystretch` 1.3 with
booktabs, and keep the layout consistent with earlier papers.

Numerical agreement and reconstruction scope are different columns.
The headline table above is unchanged. These columns are for each
published number.

Numerical is `match`, `close`, or `mismatch`, at a stated precision.
`match` means our value rounds half up to the printed value. At two
decimal places, .8602 and .86 are a match. `close` means it does not
round to the printed value, and the absolute gap is at most one unit
in the last printed place, unless the row states another band.
`mismatch` means the gap is larger than that.

Scope is `exact`, `limited`, or `unavailable`. `exact` means the same
data, estimator, and procedure the source used. `limited` means a
reconstruction, such as a fit to rounded summary statistics.
`unavailable` means the input for that number was not obtained.
Limited scope does not change a numerical match. Do not write
`partial` in the numerical column. `partial` remains available in the
headline table for a mixed headline claim, and only after these two
columns are filled.

Before either verdict, fill one comparability record for each side:
estimator, missingness, \(N\), whether the fit function is multiplied
by \(N\) or by \(N-1\), mean structure, observed-variable set, degrees
of freedom, baseline model, robust correction, and the definition of
the fit index. The checker withholds a numerical verdict when the
sides differ in a way that changes the index. A core-model index
against an auxiliary-model index is withheld. A plain
maximum-likelihood chi-square, comparative fit index, Tucker–Lewis
index, or root mean square error of approximation against the robust
version of that index is withheld. The standardized root mean square
residual may be compared across plain and robust fits when the
variable sets match and the record says the index comes from the
correlation residuals.

If the headline comparison is withheld, the opening sentence says the
indices are not comparable. It does not call that pair a match or a
mismatch.

```sh
python3 .agents/skills/replication-paper/scripts/checks.py
python3 -m unittest discover -s .agents/skills/replication-paper/tests -v
```

## Recovering a printed number is not the procedure

An expression that returns a printed number shows that the number is
that function of the printed inputs. It does not show that the
expression is the procedure the source names. Cite the formula.
Compute it. If a second expression also returns the printed number,
report that recovery on its own row. Do not give it the procedure's
verdict.

For a Satorra–Bentler scaled difference, Satorra and Bentler (2001)
put the normal-theory chi-square difference in the numerator and
divide by \(c_d=(d_0 c_0-d_1 c_1)/(d_0-d_1)\). The Mplus hand
calculation,
[Chi-square difference testing](https://www.statmodel.com/chidiff.shtml),
writes the same quantity as \((T_0 c_0-T_1 c_1)/c_d\) when \(T\) is
the scaled chi-square and \(c\) is the scaling correction, because
that product is the normal-theory chi-square. The quotient
\((T_0-T_1)/c_d\), using those scaled values, is a different
expression. `scaled_chi_square_difference` in
[checks.py](scripts/checks.py) computes both and does not call the
second one the procedure.

## What a diagnostic is

Report how many perturbation draws were requested, how many
converged, and how many failed. Those draws are exploratory. They are
not a confidence interval and not a standard error. A draw that does
not converge is a failed attempt. It is not evidence that a band is
wide, and it is not evidence that the estimate is unstable. A check
that a standard deviation cannot arise from a stated response range
is conditional on that range. Put the draws and the range check in a
supporting section. They do not lead the note.

## Page crops

A crop is evidence of what a human reader sees. That can differ from what an
automated text extractor returns.

- Render the source page with `pdftoppm -png -r 600`.
- Crop every disputed number and every disputed equation into a figure.
- For an equation whose signs matter, attach each operator by its position on
  the page. Do not stop at `pdftotext`.
- The checks in the worked example are
  [measure_glyphs.py](../../../formalization/correlated-residuals/simulation/measure_glyphs.py)
  and
  [crop_equation7.py](../../../formalization/correlated-residuals/paper/figures/crop_equation7.py).
  The second script runs `pdftoppm -png -r 600` and crops the equation.

Symbol-font equations from Word Equation Editor or MathType store operators as
Private Use Area codes. The retrieval skill records the codes and the
out-of-order text layer under
[equations in the text layer](../document-retrieval-worker/SKILL.md#equations-in-the-text-layer).

## Deliverable filenames

Name the final PDF descriptively from the paper title and subject, for example
`simplifying_assumptions_in_power_analysis__a_replication_of_kupzyk_2011.pdf`,
not `report.pdf` or `paper.pdf`. Use a stable, filesystem-safe name with the
`.pdf` extension. Update build commands, artifact tables, README, and PR links
when renaming it; keep one clearly identified current published PDF. Verify
that the linked or uploaded bytes are the newly rendered document. Preserve
historical copies separately and do not present an older download as current.

## Required sections

Each item is its own section. Each assumption and each resolved ambiguity is
its own subsection.

- [ ] What we did ourselves, and what we took from others.
- [ ] Assumptions. One subsection per assumption we supplied. A choice the
      source states is not an assumption.
- [ ] Ambiguities that were resolved. Each subsection names the artifact, the
      script, the output file, the commit, and the command that regenerates
      the output.
- [ ] What remains unresolved. For each open gap, the stopping statement from
      [Check our side first](#check-our-side-first): the candidates, what each
      attempt gave, the rank of the remaining causes, and the artifact that
      would settle the largest one.
- [ ] Code and source availability. Point at the dated ledger below.
- [ ] Next steps: the artifact named in that stopping statement, and the check
      that would use it.
- [ ] An artifacts appendix. Each row is one claim, the file that holds it,
      and the command that regenerates it.
- [ ] A README that runs every script, with the seeds and the output paths.

Code and data links in papers point at master, never at a working branch.

## Check our side first

A replication is not ready to hand off while any headline arm is unrun or
any gap has an untested plausible explanation. A headline arm is every
estimator, condition, or model the original conclusion rests on.

If compute limits force a subset, run that subset, size it to the budget,
and document the subset in the note. Do not skip the arm. Estimate run time
before a long simulation, and stay inside the research time budget.

A gap between a printed number and our number is the start of an
investigation. It is not yet a discrepancy. For each gap, write the
plausible explanations first, then rerun. Include every item below that
could apply. If an item cannot apply, name it and say why.

1. How we read the source. Render the page and compare the ink with the text
   layer. If they disagree, the extraction was wrong. Say so, and do not
   attribute the difference to the authors. Also check how a model string is
   parsed: lavaan reads `NA*i1 + 0.7*i1` as a first loading of 1.
2. Identification or scaling.
3. The metric, such as a signed error versus an absolute error.
4. The handling of non-converged or improper solutions. Report the
   counts. A failed draw is not a band. See
   [What a diagnostic is](#what-a-diagnostic-is).
5. What we assumed. List the assumptions we supplied. Turn them off one at a
   time. Record which gaps each change closes and which it leaves.
6. The formulas we used. Cite the formula the source names, and compute
   that formula. An expression that recovers a printed number is not,
   by that recovery, the procedure. Use the check in
   [Recovering a printed number is not the procedure](#recovering-a-printed-number-is-not-the-procedure).
7. Software defaults, versions, priors, and seeds. Match the original's
   versions where possible.
8. The optimizer or estimator. Try a second estimator or optimizer before
   blaming the data.
9. For a Monte Carlo or a scored instrument, run these in the same first
   pass: an independent second data generator; the package versions current
   on the source's date; Monte Carlo noise, judged with the
   two-standard-error band and then Bonferroni or Holm; the scoring code
   checked against the reference package; and a sweep over each unstated
   constant.

Rerun under each candidate that could apply. Report every result, including
the ones that do not close the gap.

Where software could be the cause, add a second independent implementation
and report it beside the first. Try to obtain or run the original software
or data, and record that attempt in the availability ledger.

Only after those attempts, write "discrepancy" and "under our reading".

Do not assert that the authors made an error. A discrepancy is consistent
with more than one cause. Name the causes still open.

End each open gap with a stopping statement: what was tried, what each
attempt gave, and what would be needed to close it. Rank the open causes by
how far each one moves the cells that miss. Name the single artifact, such
as the `.dat` files or a sessionInfo record, that would settle the largest
one. The unresolved section is that statement. It includes the attempts
that did not close the gap.

## Probability claims

State the sampling model and every extra assumption. If a product of
probabilities treats several counts as independent, say that they are not
independent when they come from the same replicates, and call the figure an
order of magnitude under that assumption. In the worked example the product
for the printed powers 64, 77, and 96 is on the order of \(10^{-12}\) only
under that independence assumption
([printed_probability.py](../../../formalization/correlated-residuals/simulation/printed_probability.py)).
The figure does not say how the printed numbers were obtained.

## Availability ledger

Look for the original code before rebuilding it. Check the OSF project, the
author's GitHub account, GitLab, and Zenodo. Clone every repository on that
GitHub account, because code search misses files.

That search is the attempt, required under Check our side first, to obtain
or run the original software or data. Before calling code or a supplement
unavailable, fill the dated ledger in
[document acquisition](../document-acquisition-queue/SKILL.md#code-and-supplementary-material-ledger).
Record each place checked, the UTC date, and the result. "Not available" is that
ledger, not a recollection. The note's availability section copies the rows.

## Pull request

Write the description for a reader who has not read the paper. Use the same
prose rules as the note. No language-model authorship statement, and no
opening about how the files were produced.

```markdown
## What this is

One sentence on the paper being replicated and where the note lives.

## Question

The research question, in plain words, and what the original work reported
or concluded. Do not write "the author claims".

## What ties together

Which part is the original work, which part is ours, and which numbers are
taken from other papers.

## Findings

Our verdict on the headline first, with the published-versus-ours numbers,
then what our evidence does not establish, then any reversal with both sets
of numbers. One sentence per headline result. Name any probability caveat,
including an independence assumption.

## Map of the note

One sentence per section, in the note's order: the question that section
answers and its answer.

## How to check it

The README commands that regenerate the table, the crops, and the proofs.
Say which inputs are not in git.

## Open issues and next steps

The stopping statement for what is still unresolved: what was tried, what
each attempt gave, and the next check. Link the acquisition or help issue
when one is open.
```

## Announcement post

When an announcement is requested, draft one post. Not a thread. Specific
to the paper. No hype. Drafting the post does not authorize posting it.

The post has four parts, in this order:

1. The work: author, year, institution, adviser, and full title.
2. Our verdict on the headline, with the published-versus-ours numbers.
3. What we could not establish, and any reversal, with numbers, and how we
   interpret it.
4. A master-branch link to the paper, code, and data.

The Chumney note is the example:

```text
Frances L. Chumney, Structural equation models with small samples: A comparative study of four approaches (Ph.D. dissertation, University of Nebraska–Lincoln, 2013; adviser James Bovaird).

We replicated the headline. On normal data at n = 1000, maximum likelihood and Bayesian Markov chain Monte Carlo recover measurement loadings far more accurately than partial least squares and generalized structured component analysis. Published versus ours, within two standard errors: maximum likelihood 2.712 versus 2.730, Markov chain Monte Carlo 2.738 versus 2.902, partial least squares 15.896 versus 15.919, generalized structured component analysis 15.918 versus 15.938.

Maximum likelihood is not separated from Markov chain Monte Carlo, so the further conclusion that maximum likelihood is the single most robust of the four is not established. The one reversal is generalized structured component analysis from five indicators to seven: Chumney reported a rise from 9.734 to 13.667, and our bias falls from 9.850 to 7.189. gesca and cSEM's GSCA both fall, and the 2013 GeSCA program could not be run on these draws, so the difference is a dependence on software we cannot execute here.

Paper, code, and data: https://github.com/alectionary/vibe-math/blob/master/formalization/chumney-sem-small-samples
```

## Before reporting the replication done

Run this list before reporting the replication done, and before opening the
pull request.

- [ ] A reader can tell from the first sentence of the abstract whether the
      headline replicated. That sentence is our verdict, with the
      published-versus-ours headline numbers. The original work's headline
      result, the answer to its main research question, is reported first,
      matched or not. Supporting results that matched do not lead when the
      headline missed.
- [ ] The headline numbers, the tolerance, and the direction are on page 1.
      The headline table (claim, published, ours, same direction?, verdict)
      sits immediately after the abstract. The introduction's first paragraph
      uses the same order: verdict, the limit of our evidence, any reversal.
- [ ] The note says "reported" or "concluded". It does not say "the author
      claims". It does not assert that the authors made an error.
- [ ] Every open gap has an enumerated list of candidates, a rerun under each
      one that could apply, every result including those that did not close
      it, a second implementation where software could be the cause, an
      attempt to obtain or run the original software or data, and a stopping
      statement.
- [ ] Every headline arm is run. A compute-limited subset is sized, run, and
      documented. The arm is not skipped.
- [ ] Links point at master. Every piece of software is cited with its exact
      version, a CRAN or repository link, and why it was chosen. Every
      script, output file, and key function is deep-linked from the text,
      with line anchors for theorems and functions. The visible link text must include the
actual filename and extension (for example, `model.R: empirical fits`, not
just `empirical fits`). Prefer a literal filename label, with any description
outside the link: `empirical fits ([model.R](...#L68))`. Preserve underscores
and extensions in rendered text, using an appropriate code/path font.
Verify the final PDF's visible link text and hyperlink annotations, not just
the manuscript source. Deliver a link to the newly built artifact; updating
source alone does not update previously downloaded or separately saved PDFs.

In the artifacts appendix, make each repository file and regeneration script
a clickable `master` link; a plain path or command is not sufficient. Use
`blob/master` for files and `tree/master` for directories. Preserve filename
extensions in visible labels and check function line anchors against the
actual source. Label external or separately delivered artifacts explicitly;
do not invent a repository URL for a file that is not included. Inspect the
rendered PDF to confirm that links remain readable and clickable.
- [ ] "Remove" was a deletion. Nothing that was removed was relocated.
- [ ] The comparison table has claim, published, ours, precision,
      numerical, and scope, plus one reason per row. A remaining gap names
      the cell, the value, and the band. Monte Carlo agreement uses a
      two-standard-error band, then Bonferroni or Holm. Typos, rounding,
      and boundary cases are listed on their own.
- [ ] Tables use readable row spacing, in the layout of the earlier papers.
- [ ] The original code was sought on OSF, the author's GitHub account (every
      repository cloned), GitLab, and Zenodo before it was rebuilt, and that
      attempt is in the dated ledger.
- [ ] Run time was estimated before any long simulation.
- [ ] Every disputed number and equation has a 600 dpi crop.
- [ ] Each resolved ambiguity has an artifact, a script, an output, a commit,
      and a command.
- [ ] The README runs every script.
- [ ] The pull request can be followed without opening the PDF. Its findings
      open with the headline verdict.
- [ ] No language-model authorship statement appears in the note, the pull
      request, or the announcement post.
- [ ] If an announcement was requested, it is the single post in the template
      above: the work, the verdict with numbers, the limit or reversal with
      the interpretation, and the master link. No hype. No thread. It has
      not been posted unless posting was requested.
- [ ] The engine preflight was run. The fits use lavaan and OpenMx, or
      the compliance ledger records a departure with a justification and
      a separate validation.
- [ ] Each published number has a stated precision, a numerical verdict,
      and a separate scope. A value that rounds to the printed value is
      a numerical match. `partial` is not used in place of either column.
- [ ] A comparability record was filled before the verdicts. A core-model
      index against an auxiliary-model index, and a plain maximum-likelihood
      chi-square, comparative fit index, Tucker–Lewis index, or root mean
      square error of approximation against its robust counterpart, are
      flagged and have no numerical verdict.
- [ ] A printed number recovered from an expression is not given the
      procedure's verdict unless that expression is the cited formula.
- [ ] Perturbation draws report how many were requested, how many
      converged, and how many failed. Exploratory draws are not described
      as confidence bounds. A conditional range check states the range it
      assumes.

When editing this skill, validate its frontmatter with the `skill-creator`
skill's `scripts/quick_validate.py`, using a Python that has PyYAML.
