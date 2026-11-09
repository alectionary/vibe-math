**Paper (reviewable now, the reviewed bytes):** [paper folder at commit 2aa873df](https://github.com/alectionary/vibe-math/tree/2aa873df4b6b43b6d80a1a7ef887f9c5da90d715/formalization/chen-rdd-mediation/paper), file `mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf`
**After merge (live on master):** [paper folder on master](https://github.com/alectionary/vibe-math/tree/master/formalization/chen-rdd-mediation/paper), same file

Closes #88 when merged.

## What this is

A full-design replication of Donna Chen's dissertation, *Statistical Mediation Analysis in Regression Discontinuity Design for Causal Inference* (University of Nebraska-Lincoln, 2021; first adviser James A. Bovaird, second adviser Lorey A. Wheeler), in `formalization/chen-rdd-mediation/`.

## Question

Chen asked how natural direct and indirect effects and the mediated interaction (MINT) behave when mediation analysis is done in a sharp regression discontinuity design. Her simulation (research question 3) concluded that direct-effect estimates are biased, that percentile bootstrap intervals cover the true value far less often than 95% with the truth mostly above the interval, that MINT power is near zero, and, tentatively, that n = 5,000 is the minimum sample size for accurate Type I error and power above .80. She also compared mediation in the Head Start Impact Study's experimental data with synthetic regression-discontinuity samples (research question 2), and integrated the assumptions of the two methods (research question 1).

## What ties together

The design, the data-generating model and the estimation code are Chen's (her Table 3.1 and Appendices A-B). Our part is an independent Python re-implementation of that code, the full simulation (all 1,280 conditions at three cutoffs, 3,840 of 3,840 cells, 1,000 replications and 500 bootstrap resamples each), the comparison with her printed tables and text, and a recomputation of the arithmetic in her Tables 4.6-4.7. No numbers are taken from other papers.

## Findings

- **Not replicated: biased direct effects.** 0.00% of our direct-effect results have |bias| > .10, against 85.42% in our average of her Table 4.8 rows; the largest |bias| of any effect is .016.
- **Not replicated: low coverage.** Mean coverage falls 0.04 percentage points short of 95%, against 43.62 in her Table 4.9; the truth lies above the interval 0.33 rather than 47.07 points more often than below it.
- **Not replicated: near-zero MINT power.** MINT power is 0.836 at n = 500 for the largest interaction (a = .59, h = .34) and at least .97 for ah >= .13 from n = 1,000.
- **Partly replicated: the n = 5,000 recommendation.** At n = 5,000, 86.3% of zero-effect results have Type I error in Bradley's range and 89.2% of nonzero results reach .80 power, similar at each cutoff; effects whose two paths are both zero stay conservative at every n.
- **Not established: why her results differ.** Her printed estimation code matches ours, and the step that compared her estimates with population values is not printed. Of 46 Type I and power statements in her text, 29 agree with our run (31 if each threshold is relaxed by .01). Read on our cells with the treatment-by-mediator interaction h set to 0, 39 would hold, and her text defines PNDE as c' + h where the population value is c'. These are consistency observations, not a diagnosis.
- **Not established: the Head Start comparison.** The restricted-use data were not available; all 24 printed differences and standardized biases in her Tables 4.6-4.7 were recomputed (the standardized biases match only with the RCT estimate's standard error as divisor, not the outcome SD of her equation 3.12).

Uncertainty: each cell has 1,000 replications, so a coverage or rejection rate near .95 or .05 has a Monte Carlo standard error of about .007; Chen reports no Monte Carlo error. Magnitude labels on page 1 compare point estimates at the printed rounding tolerance and are not equivalence tests.

## Map of the note

The paper's sections answer, in order:

- **Abstract, Table 1, Section 1 (Introduction):** what Chen reported and our verdict on each headline.
- **Section 2:** what is ours and what is hers.
- **Section 3 (Methods):** the design, the estimators, the Python engine and how comparable the two simulations are.
- **Section 4:** each headline (H1-H4) in turn: Chen's direct effects are not biased in our run, coverage is near nominal, MINT power is not near zero, and n = 5,000 holds for most but not all cells.
- **Section 5:** the supporting claims, including all 46 testable Type I and power statements (29 agree) and the Head Start, assumption and power-analysis parts.
- **Section 6:** every published number against ours, with numerical and scope labels.
- **Sections 7-8:** the assumptions we supplied and the ambiguities we resolved (cutoff labels, the standardized-bias divisor, the R-to-Python engine fallback).
- **Section 9:** the seven limits of the evidence.
- **Section 10:** what remains unresolved, ranked, with the evidence that would settle it.
- **Sections 11-12:** code and source availability, and next steps.
- **Appendices A-C:** artifacts and reproduction commands, the compliance ledger, and the inventory of every claim and dissertation section.

## How to check it

From `formalization/chen-rdd-mediation/`, the [README](https://github.com/alectionary/vibe-math/blob/replication/chen-2021/formalization/chen-rdd-mediation/README.md) lists every command, seed and output. The full simulation takes about 13.7 core-hours (`simulation/chen_sim.py run`); `simulation/aggregate.py`, `simulation/statement_checks.py` and `build_packet.py` regenerate the committed results and evidence packet in seconds. Not in git: the dissertation PDF (openly posted on Digital Commons; its SHA-256 is in the README) and the 1,280 per-condition files of the simulation.

## Open issues and next steps

The cause of Chen's bias, coverage and MINT results is unresolved; her result files, or her h estimates and intervals for one condition, would settle whether h was attenuated in her runs or her population values differed. The Head Start comparison needs the restricted-use ICPSR file.

## Review record

The paper was written by an isolated writer from the frozen evidence packet and reviewed by independent cold readers; reviews 1-7 failed and are kept in `notes/` with the fixes each led to, and the accepted review is `notes/editorial-review.json`. The delivery record is `delivery-record.json`.

## Follow-ups (not done, to keep the reviewed PDF unchanged)

The accepted review (`notes/editorial-review.json`) passed every check and listed polish only:
- the abstract could say what the 46 statements are, and that the unprinted population-value step cannot by itself explain the MINT power difference;
- for E4, Chen's Figure 4.28 plots MINT power near zero; the figure was not digitized, so the paper's "no printed number" is accurate but terse;
- the Monte Carlo error in the Table 1 note (about 0.7 percentage points) is for rates near .05 or .95; near .84 it is about 1.2;
- Table 1 uses plain-text ">=", "c'" and hyphen ranges where the body uses typeset symbols;
- the p. 99 sentence "The same pattern was observed for all three cutoff scores" is carried by statement 2 but not named;
- S4 could also mention Chen's RQ2 finding that RDD and RCT intervals gave different significance conclusions (also blocked);
- `notes/availability.md` row 2 (what the ICPSR page offers) reads as if public data files exist; row 3 records that the actual download has none.

## Skill changes found while doing this

- `replication-paper`: a part run in full that disagrees with the source is a result, not a limit; `run_complete: true` lets a `mismatch` or `partly` part pass the done check without a `limit_kind` (separate commit, with tests).
- Not changed, for follow-up: the pre-merge link gate reads URLs literally from the LaTeX source, so links built by a macro are never checked; and the delivery checks need PyMuPDF, which cannot be installed from PyPI in this environment (installed here from the pinned wheel).

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01LzNgoVeSEgK9kNNm7ALtfV
