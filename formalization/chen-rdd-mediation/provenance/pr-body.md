**Paper (reviewable now, the reviewed bytes):** [paper folder at commit c9b680b0](https://github.com/alectionary/vibe-math/tree/c9b680b05ffe18578efa0b60cdcf959a30fd923b/formalization/chen-rdd-mediation/paper), file `mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf`
**After merge (live on master):** [paper folder on master](https://github.com/alectionary/vibe-math/tree/master/formalization/chen-rdd-mediation/paper), same file

Closes #88 when merged.

## What this is

A full-design replication of Donna Chen's dissertation, *Statistical Mediation Analysis in Regression Discontinuity Design for Causal Inference* (University of Nebraska-Lincoln, 2021; first adviser James A. Bovaird, second adviser Lorey A. Wheeler), in `formalization/chen-rdd-mediation/`.

## Question

Chen asked how natural direct and indirect effects and the mediated interaction (MINT) behave when mediation analysis is done in a sharp regression discontinuity design. Her simulation (research question 3) concluded that direct-effect estimates are biased, that percentile bootstrap intervals cover the true value far less often than 95% with the truth mostly above the interval, that MINT power is near zero, and, tentatively, that n = 5,000 is the minimum sample size for accurate Type I error and power above .80. She also compared mediation in the Head Start Impact Study's experimental data with synthetic regression-discontinuity samples (research question 2), and integrated the assumptions of the two methods (research question 1).

## What ties together

The design, the data-generating model and the estimation code are Chen's (her Table 3.1 and Appendices A-B). Our part:
- an exact replay of her printed, seeded R code on all 1,280,000 datasets that code generates (#92, #118), checked identical to her literal printed pipeline;
- an independent Python re-implementation for the full simulation with the bootstrap (3,840 of 3,840 condition-cutoff cells, 1,000 replications and 500 resamples each), since her bootstrap is unseeded;
- the digitization of her result Figures 4.12-4.38 (vector figures read exactly; image figures read by colour, with points hidden under other series excluded);
- the comparison with her printed tables, figures and text, and checks of the arithmetic, identities and significance conclusions in her Head Start tables.

No numbers are taken from other papers.

## Findings

- **Not replicated: biased direct effects.** 0.00% of our direct-effect results have |bias| > .10, against 85.42% in our average of her Table 4.8 rows; the largest |bias| of any effect is .016.
- **Not replicated: low coverage.** Mean coverage falls 0.04 percentage points short of 95%, against 43.62 in her Table 4.9; the truth lies above the interval 0.33 rather than 47.07 points more often than below it.
- **Not replicated: near-zero MINT power.** At n = 500, a = .59, h = .34 (cutoffs 2-3, where her figure can be read), her MINT rejection rate is .063, .013 above the nominal .05; ours is .852 (.836 over all cutoffs).
- **Partly replicated: the n = 5,000 recommendation.** At n = 5,000, 86.3% of zero-effect results have Type I error in Bradley's range and 89.2% of nonzero results reach .80 power; effects whose two paths are both zero stay conservative at every n.
- **Why her results differ.** Her printed code, replayed exactly, is unbiased and recovers h, like our run, so the differences arise in unprinted steps. Her Type I and power figures match our rates with h set to 0 at 79-100% of directly read points, and her MINT bias is -1.00·ah, which indicates the data behind her results had no interaction; her coverage falls to the control share at every cutoff, consistent with population values wrong for treated cases. All ten disagreements, with competing explanations and tests, are in `DISAGREEMENTS.yaml` and the paper's Disagreements section: 8 explained, 2 partly explained.
- **Head Start (research question 2).** Her estimates cannot be rerun without restricted-use data. From her printed numbers, all 48 differences and standardized biases recompute (the latter only with the RCT estimate's SE as divisor), all 12 effect identities hold, and her claim that RDD intervals reach opposite significance conclusions to the RCT holds in 10 of 15 comparisons, as her own Chapter 4 reading of the table says.

Uncertainty: each cell has 1,000 replications (Monte Carlo SE about .007 for a rate near .05 or .95; about .005-.02 points for the page-1 coverage means). Chen reports no Monte Carlo error. Page-1 magnitude labels compare point estimates against stated rounding or reading-error tolerances and are not equivalence tests.

## Map of the note

- **Abstract, Table 1, Introduction:** the verdict on each headline, published against ours.
- **What we did, and what we took from others:** the division of credit.
- **Methods:** design, estimators, the exact R replay, the Python engine, figure digitization, comparability.
- **Results:** each headline (H1-H4) and the supporting claims (S1-S9).
- **Comparison of published and replicated values:** every number side by side.
- **Disagreements:** ten sections, one per disagreement: her claim, our result, competing explanations, tests, conclusion.
- **Assumptions, Ambiguities, What remains unresolved, Limitations:** what we supplied, what we resolved and how, what is open, and the seven limits.
- **Availability, Next steps, Appendices:** data availability ledger, reproduction commands and the code revision they run at, compliance ledger, claim and section inventory.

## How to check it

From `formalization/chen-rdd-mediation/`, the [README](https://github.com/alectionary/vibe-math/blob/replication/chen-2021/formalization/chen-rdd-mediation/README.md) and the paper's Appendix A list every command, seed and output; the code and evidence are pinned at commit `1fa61083`. The full Python simulation takes about 13.7 core-hours; the R replay about 3.4 hours (R 4.1.3); every summary, figure comparison and the evidence packet regenerate in seconds. Not in git: the dissertation PDF (openly posted on Digital Commons; its SHA-256 is in the README) and the per-condition simulation files.

## Review record

The paper was written by an isolated writer from the evidence packet (`writer-manifest.json`, `context: fresh`) and checked by independent cold readers. Reviews 10-15 failed and are kept in `notes/` with the fixes each led to (among them: the R replay's scope, E4 defined against its null and measured only on readable points, hidden figure points recognised as filled in, the reproduction revision). Review 16 passed all eleven editorial checks and the final-PDF link review (`notes/editorial-review.json`). `delivery-record.json` binds the review to the PDF and its inputs at commit c9b680b0; `delivery_check.py` and `preflight.py done` pass, and `paper_freshness.py` reports the paper current.

## Follow-ups

- Polish from review 16: shorten abstract sentence 1; give E3 its own above/below shares on page 1 (needs a separate packet finding); say in the Table 1 caption that the E4 cell was chosen after the results; clarify the "first block" wording, a `chen_exact.R` line reference, and the Figure 4.28 page (printed p. 122).
- Appendix A says the pinned commit is "on branch replication/chen-2021"; after merge it is in master's history, so "commit 1fa61083" alone is the durable wording.
- Skill changes made while doing this: #121, #122, #123, #124, #125, #126.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01LzNgoVeSEgK9kNNm7ALtfV
