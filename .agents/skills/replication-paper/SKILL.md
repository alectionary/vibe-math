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

- Do not open with how the note was produced.
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

## Comparison table

Include a table with these columns: claim, published, ours, verdict. The
verdict is one of `match`, `partial`, `close`, `no match`. Give each row one
sentence that states the reason. Put that sentence in the row when it fits, or
in the paragraph under the table that names the row.

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

Code and data links in papers point at master, never at a working branch.

## Check our side first

A difference between a printed number and our number is not yet a discrepancy.

1. Render the page and compare the ink with the text layer. If they disagree,
   the extraction was wrong. Say so, and do not attribute the difference to
   the authors.
2. List the assumptions we supplied. Turn them off one at a time. Record which
   gaps each change closes and which it leaves.
3. Only after both checks, write "discrepancy" and "under our reading".
4. Do not assert that the authors made an error. A discrepancy is consistent
   with more than one cause. Name the causes still open.

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
      reason per row.
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
