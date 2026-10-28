---
name: replication-paper
description: "Replicate a published result and write the replication note and pull request. Use for the comparison table, page crops, graded claims, availability audit, and a pull request a reader can follow without the paper. A theorem-only writeup stays with open-question-research."
---

# Replication paper

Use this to replicate a published numerical, simulation, or statistical result
and to write the note and the pull request. A theorem-only paper stays with
[open-question research](../open-question-research/SKILL.md). A replication
that also contains proofs uses both: this skill for the comparison, the crops,
the graded claims, and the pull request; that skill for the proofs, the
chronology, and the Lean appendix.

The worked example is
[formalization/correlated-residuals/](../../../formalization/correlated-residuals/README.md),
merged as pull request 14. Commands below are from the repository root.

## Abstract and opening

The abstract and the first paragraph answer four things, in this order: the
research question, what the original work claims, what we did, and what we
found.

Order the note as a story. Start with the research question and the headline
findings, then what replicated, then what gave us trouble and how we fixed it,
then what is still open together with what we tried.

- Keep process details out of the abstract and the opening. That includes how
  the note was produced.
- Do not put a language-model authorship statement anywhere in the note, the
  pull request, the README, or a figure caption.
- Omit the manuscript author line unless the user asks for one.

## Prose

- "Remove" means delete the words. Do not move them to another section, an
  appendix, a caption, or a footnote.
- Every section opens with the question it answers and the answer.
- Every paragraph opens with a topic sentence.
- Use plain words. Define a term the first time it appears.
- Do not use internal shorthand. Write "measuring sign positions on the page",
  not "glyph reading". File names stay as paths.

## What we did, and what we took from others

One section states our contribution: the proofs, the simulations, and the
comparison. The original work's contribution is the model, the design, and the
published tables. Each later number is labeled as one of: our calculation or
simulation, an assumption we supplied, or a figure taken from a cited source.

## Links and citations

Code and data links in papers point at `master`.

Cite every piece of software used, with its exact version, and link its CRAN
page or repository. This covers R, lavaan, simsem, OpenMx, Lean, and Mathlib.
Say why each tool was chosen. For example, R and lavaan because the original
used them, simsem 0.5.16 because the dissertation names that version, and
OpenMx as an independent check on the optimizer. Use Lean for the algebra, and
R with an SEM package for statistical model fitting.

Deep-link every script, output file, and key function from the text, with line
anchors for theorems and functions.

## Comparison table

Include a table with these columns: claim, published, ours, verdict. The
verdict is one of `match`, `partial`, `close`, `no match`. Each row gives the
original value, our value, and that verdict. Give each row one sentence that
states the reason. Put that sentence in the row when it fits, or in the
paragraph under the table that names the row.

Name any remaining gap by the cell, the value, and the band. Judge Monte Carlo
agreement against a band of two standard errors, then apply Bonferroni or Holm.

Keep small differences, such as typos, rounding, and boundary cases, in their
own list, and say plainly whether they are replication failures.

Give tables readable row spacing, for example `\arraystretch` 1.3 with
booktabs, and keep the layout consistent with earlier papers.

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

## Required sections

Each item is its own section. Each assumption and each resolved ambiguity is
its own subsection.

- [ ] What we did ourselves, and what we took from others.
- [ ] Assumptions. One subsection per assumption we supplied. A choice the
      source states is not an assumption.
- [ ] Ambiguities that were resolved. Each subsection names the artifact, the
      script, the output file, the commit, and the command that regenerates
      the output.
- [ ] What remains unresolved, including the attempts that did not close it.
- [ ] Code and source availability. Point at the dated ledger below.
- [ ] Next steps: the missing document, dataset, or proof, and the check that
      would use it.
- [ ] An artifacts appendix. Each row is one claim, the file that holds it,
      and the command that regenerates it.
- [ ] A README that runs every script, with the seeds and the output paths.

## Check our side first

A gap between a printed number and our number is the start of an investigation.
It is not yet a discrepancy. Check these, in order.

1. How we read the source. Render the page and compare the ink with the text
   layer. If they disagree, the extraction was wrong. Say so, and do not
   attribute the difference to the authors. Also check how a model string is
   parsed: lavaan reads `NA*i1 + 0.7*i1` as a first loading of 1.
2. What we assumed. List the assumptions we supplied. Turn them off one at a
   time. Record which gaps each change closes and which it leaves.
3. The formulas we used.
4. The software versions. Match the original's versions where possible.
5. The optimizer. Try a second estimator or optimizer before blaming the data.
6. Only after those checks, write "discrepancy" and "under our reading".
7. Do not assert that the authors made an error. A discrepancy is consistent
   with more than one cause. Name the causes still open, and point to what
   would settle the question, such as the `.dat` files or a sessionInfo record.

Estimate run time before a long simulation, and stay inside the research time
budget.

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

Before calling code or a supplement unavailable, fill the dated ledger in
[document acquisition](../document-acquisition-queue/SKILL.md#code-and-supplementary-material-ledger).
Each place checked, the UTC date, and the result. "Not available" is that
ledger, not a recollection. The note's availability section copies the rows.

## Pull request

Write the description for a reader who has not read the paper. Use the same
prose rules as the note. No language-model authorship statement, and no
opening about how the files were produced.

```markdown
## What this is

One sentence on the paper being replicated and where the note lives.

## Question

The research question, then the original claim, in plain words.

## What ties together

Which part is the original work, which part is ours, and which numbers are
taken from other papers.

## Findings

The comparison verdicts, in plain words. One sentence per headline result.
Name any probability caveat, including an independence assumption.

## Map of the note

One sentence per section, in the note's order: the question that section
answers and its answer.

## How to check it

The README commands that regenerate the table, the crops, and the proofs.
Say which inputs are not in git.

## Open issues and next steps

What is still unresolved, what was tried, and the next check. Link the
acquisition or help issue when one is open.
```

## Before opening the pull request

- [ ] The abstract leads with the question, the original claim, our work, and
      the findings.
- [ ] "Remove" was a deletion. Nothing that was removed was relocated.
- [ ] The comparison table has claim, published, ours, and verdict, plus one
      reason per row. A remaining gap names the cell, the value, and the band.
      Monte Carlo agreement uses a two-standard-error band, then Bonferroni or
      Holm. Typos, rounding, and boundary cases are listed on their own.
- [ ] Tables use readable row spacing, in the layout of the earlier papers.
- [ ] Every piece of software is cited with its exact version and a CRAN or
      repository link, and the note says why that tool was chosen.
- [ ] Every script, output file, and key function is deep-linked from the text,
      with line anchors for theorems and functions.
- [ ] A gap was checked in order: the reading of the source, our assumptions,
      the formulas, the software versions, and the optimizer.
- [ ] The original code was sought on OSF, the author's GitHub account (every
      repository cloned), GitLab, and Zenodo before it was rebuilt.
- [ ] Run time was estimated before any long simulation.
- [ ] Every disputed number and equation has a 600 dpi crop.
- [ ] Each resolved ambiguity has an artifact, a script, an output, a commit,
      and a command.
- [ ] The availability ledger has a date and a result for every place checked.
- [ ] The README runs every script.
- [ ] The pull request can be followed without opening the PDF.
- [ ] No language-model authorship statement appears in the note or the pull
      request.

When editing this skill, validate its frontmatter with the `skill-creator`
skill's `scripts/quick_validate.py`, using a Python that has PyYAML.
