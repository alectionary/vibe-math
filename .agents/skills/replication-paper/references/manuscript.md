# Manuscript reference

- [Abstract and opening](#abstract-and-opening)
- [Prose](#prose)
- [Explain findings before execution details](#explain-findings-before-execution-details)
- [What we did, and what we took from others](#what-we-did-and-what-we-took-from-others)
- [Links and citations](#links-and-citations)
- [Compliance ledger](#compliance-ledger)
- [Comparison table](#comparison-table)
- [Deliverable filenames](#deliverable-filenames)
- [Required sections](#required-sections)

Read only for the corresponding stage in [SKILL.md](../SKILL.md).

## Abstract and opening

The original work's headline result is the answer to its main research
question. Report that result first, whether it matched or not. Supporting
results that matched never lead when the headline missed.

The abstract, and the first paragraph of the introduction, open with our
verdict on that headline. The first sentence is the verdict, one of
replicated, partly replicated, not replicated, or not established (including
blocked comparisons), followed by the
published-versus-ours headline numbers. Identify and cite the replicated work
and state its original headline finding in the abstract opening; combine this
with the verdict in one readable sentence. Verify the source metadata rather
than inventing it. Apply the [first-page contract](first-page-contract.md).
When the headline missed, that
sentence says so. A matching supporting result does not take its place.

The next sentence is what we could not establish, phrased as the limit of
our evidence. Then any reversal of direction, with both sets of numbers.
Supporting detail comes after that. The research question comes after the
verdict, not before it.

State the match tolerance and the direction of each key effect or ordering
on page 1, in the abstract or in the headline table. Use "reported" or
"concluded". Do not write "the author claims".

Put the headline table immediately after the abstract, before the
introduction. Columns: scientific estimand/claim, published signed effect, ours,
Effect magnitude, direction, scientific verdict. Magnitude is smaller/same/larger
at the declared rounding-aware or prespecified tolerance, or not established
for unresolved/unstable estimates. Keep reversals explicit even when absolute
magnitudes agree. These are descriptive point estimates, not equivalence; keep
uncertainty-supported inferences separate. See the first-page contract for the
structured fields and rendered checks.
The verdict is one of `match`, `partial`, `close`, `no match`,
`not separated`. Use `not separated` when a ranking is not established under
the stated uncertainty analysis; a descriptive magnitude label of `same` does
not establish that result or equivalence. The caption or abstract states the
comparison tolerance and distinguishes it from sampling uncertainty.

After that opening, organize by scientific questions, findings, methods, and
evidence limits. Explain diagnostics only when they affect interpretation;
do not narrate the drafting or delivery process.

The worked example is the abstract of
[formalization/chumney-sem-small-samples/paper/paper.tex](../../../../formalization/chumney-sem-small-samples/paper/paper.tex).
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

## Explain findings before execution details

Write the main paper for a reader who has not seen the working conversation.
State what was checked, what the check found, and why it matters; link the
supporting filename. Do not replace a result with "evaluated in the outputs"
or direct readers to "the manifest", "recorded below", or "per README"
without an exact filename or section link. Use scientific roles such as
"independent source reviewer", not internal roles such as "parent" or
"executor". Retain consequential access limits and verification boundaries;
omit operational chatter that does not affect interpretation.

Keep three distinct records:
- Main text: scientific claim, method, finding, implication, and evidence link.
- Reproduction appendix/README: prerequisites (including unavailable inputs),
  exact command and working directory, expected output, checkpoint behavior,
  and a revision that actually contains the required code and inputs.
- Provenance: the starting repository revision and original workflow version,
  labeled as historical context rather than runnable reproduction targets.

A link to master is a navigation aid, not an immutable reproduction version.
Verify the stated reproduction revision contains the files before giving it.
Name a specific README subsection when the complete recipe lives there.
Separate rebuilding a report from saved outputs, rerunning simulations, and
re-extracting source data. Do not imply a missing source file is bundled.
Before delivery, read the rendered paper for vague destinations, unexplained
internal terms, and execution instructions misplaced in scientific prose.

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

Code and data links in papers point at `master`. An immutable reproduction
revision is separate provenance, not a substitute for file navigation. Follow
the narrow labeled commit-link rules in the
[final-PDF link audit](pdf-link-review.md).

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
outside the link: `empirical fits ([model.R](../...#L68))`. Preserve underscores
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

## Compliance ledger

Keep a short ledger. Each row is one requirement, the status
`followed`, `departed`, or `not applicable`, and the evidence. A
departure needs a justification. The engine row comes from the
preflight. Copy the ledger into the note. `validate_ledger` in
[checks.py](../scripts/checks.py) rejects a departure that has no
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
Use the headline table specified above. These columns are for each
published number.

Numerical is `match`, `close`, or `mismatch`, at a stated precision.
`match` means our value rounds half up to the printed value. At two
decimal places, .8602 and .86 are a match. `close` means it does not
round to the printed value, and the absolute gap is at most one unit
in the last printed place, Other bands must be named as separate uncertainty or sensitivity decisions; they do not reuse the numerical `close` label.
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
- [ ] Ambiguities that were resolved. Each subsection explains the ambiguity,
      the check, the finding, and its implication, with links to named evidence.
      Put the complete execution recipe in the artifacts appendix or README.
- [ ] What remains unresolved. For each open gap, the stopping statement from
      [Check our side first](research.md#check-our-side-first): the candidates, what each
      attempt gave, the rank of the remaining causes, and the artifact that
      would settle the largest one.
- [ ] Code and source availability. Point at the dated ledger below.
- [ ] Next steps: the artifact named in that stopping statement, and the check
      that would use it.
- [ ] An artifacts appendix. Each row is one claim, the file that holds it,
      and the command that regenerates it.
- [ ] A README that runs every script, with the seeds and the output paths.

Code and data links in papers point at master, never at a working branch.
