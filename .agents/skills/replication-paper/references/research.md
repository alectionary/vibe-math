# Research reference

- [Headline, direction and uncertainty inventory](#headline-direction-and-uncertainty-inventory)
- [Engine](#engine)
- [Recovering a printed number is not the procedure](#recovering-a-printed-number-is-not-the-procedure)
- [What a diagnostic is](#what-a-diagnostic-is)
- [Page crops](#page-crops)
- [Check our side first](#check-our-side-first)
- [Probability claims](#probability-claims)
- [Availability ledger](#availability-ledger)

Read only for the corresponding stage in [SKILL.md](../SKILL.md).

## Headline, direction and uncertainty inventory

Before drafting, list every scientific claim as headline or supporting. Split a
composite headline into its components (for example resource savings and error
performance); a matching code parameter or secondary experiment cannot replace
a missed performance component. Record a signed scientific contrast once, with
units, subtraction order and the meaning of positive. Keep ours-minus-source
reproduction deviations in a different column. Never mix those meanings under
"direction" or use unexplained Higher/Lower labels.

Declare the expected analysis/condition inventory, including preserved baseline
points, and check coverage with `validate_contrast_coverage`. Compute source and
replicated contrasts at every reported condition; detect
point-estimate sign reversals and disclose consequential reversals in the opening
after the headline and evidence limit. A preserved ordering at one point is not
a grid-wide claim. Missing source uncertainty means a source point ordering,
not an established source ranking.

Keep three decisions separate: numerical agreement at stated precision,
reconstruction scope, and uncertainty compatibility. Reserve `close` for the
rounding criterion below; call other results `inside/outside conditional band`
or `within exploratory margin`, with a named criterion. Display rounding of a
figure-derived estimate is not original measurement precision. Do not relabel a
rounding mismatch as a numerical match because its interval overlaps.

Declare each multiplicity family, its size, alpha and correction before computing
bands. Save unadjusted and adjusted endpoints/statuses and the count of tests in
each family. Separate our Monte Carlo error, bounded extraction uncertainty and
unknown original Monte Carlo error. Explain approximation assumptions; use
appropriate binomial intervals or withhold inference for rare-event supporting
rows. Bonferroni controls a specified family under those assumptions; it does not
recover missing source counts, correct systematic differences or prove equivalence.
Use [contrast_checks.py](../scripts/contrast_checks.py) for signed contrast, conditional
bands and inventory validation; its regression fixtures include reversal and
inconsistent-label cases. Manual review must still decide which results are
headline, whether contrasts are meaningful, and whether the uncertainty model fits.

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
[checks.py](../scripts/checks.py) computes both and does not call the
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
  [measure_glyphs.py](../../../../formalization/correlated-residuals/simulation/measure_glyphs.py)
  and
  [crop_equation7.py](../../../../formalization/correlated-residuals/paper/figures/crop_equation7.py).
  The second script runs `pdftoppm -png -r 600` and crops the equation.

Symbol-font equations from Word Equation Editor or MathType store operators as
Private Use Area codes. The retrieval skill records the codes and the
out-of-order text layer under
[equations in the text layer](../../document-retrieval-worker/SKILL.md#equations-in-the-text-layer).

## Check our side first

Account for every headline arm and plausible explanation before handoff.
Run feasible checks; explicitly justify blocked or resource-limited checks with
a stopping record. Such records permit an honest incomplete result, not success. A headline arm is every
estimator, condition, or model the original conclusion rests on.

If compute limits force a subset, run that subset, size it to the budget,
and document the subset in the note. Keep the arm in the inventory even if no feasible run is possible; record the blocker and withhold its verdict. Estimate run time
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
([printed_probability.py](../../../../formalization/correlated-residuals/simulation/printed_probability.py)).
The figure does not say how the printed numbers were obtained.

## Availability ledger

Look for the original code before rebuilding it. Check the OSF project, the
author's GitHub account, GitLab, and Zenodo. Clone every repository on that
GitHub account, because code search misses files.

That search is the attempt, required under Check our side first, to obtain
or run the original software or data. Before calling code or a supplement
unavailable, fill the dated ledger in
[document acquisition](../../document-acquisition-queue/SKILL.md#code-and-supplementary-material-ledger).
Record each place checked, the UTC date, and the result. "Not available" is that
ledger, not a recollection. The note's availability section copies the rows.
