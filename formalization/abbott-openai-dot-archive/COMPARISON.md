# Report-quality comparison: OpenAI Dot's perspective

29 October 2026. This is **OpenAI Dot's opinion** about its own report compared with the **Grokbot** report in [PR #47](https://github.com/alectionary/vibe-math/pull/47). The Grokbot identity is the user's explicit clarification, not an inference from a commit footer. This is one perspective to be combined later with Grokbot's independent conclusions, not an authoritative ranking of systems.

## Bottom line

In my opinion, Grokbot produced the superior report for the reader: a focused question, a clear account of what came back, and a mature SEM-tool workflow. My report made qualifications too prominent and used "partial" too broadly. The underlying shared numerical results are close. Most differences reflect execution and communication under the same skill, rather than entirely missing instructions.

Both runs used the skill at repository commit `055e3308bf142c9b1e7ab300298712f09acf61d1`, skill blob `db47095f56283493981114209e72e20b9151ccec`. Grokbot's reviewed head is `bc88de30c57945ed17bac438e17282103dcb7cbd`; PR #47 merged at `f96d1ea2f03c9447539fc0a1017a6fff1f30f71a`. Both used the same official dissertation PDF hash and the same 37-by-37 correlation values. Neither recovered original participant-level MLR/FIML data or reran the interview phase.

## Quality and workflow gaps

| Dimension | OpenAI Dot | Grokbot PR #47 | My assessment |
|---|---|---|---|
| Reader-facing verdict | Blanket partial-reconstruction language obscures individual numerical successes | Granular comparison table, explicit match/close/no-match outcomes | Prefer Grokbot's findings-first structure, but define tolerances in advance |
| SEM engine | Custom SciPy normal-theory ML; two optimizers and independent RAM/numerical-gradient checks | R 4.3.3, lavaan 0.6.17 and OpenMx 2.21.11 | Grokbot more closely follows the skill's R/SEM workflow and uses genuinely separate established engines |
| Comparable targets | Plain-ML versus printed robust results with extensive caveats | Prominent comparisons to unscaled targets implied by printed scaling factors | Grokbot makes the attainable comparison easier to understand |
| Model coverage | Eight core fits plus auxiliary-profile identity | Nine direct fits, including revised plus saturated auxiliaries | This is a representation/verification gap, not one omitted substantive hypothesis |
| Diagnostics | Broader source/arithmetic/bounded-SD checks and 200 successful exploratory perturbations | Narrower, more focused factor-model account; three rounding attempts did not converge | Retain Dot's useful breadth without burying the main answer; failed rounding draws are not evidence of stability |

### Numerical agreement is not replication fidelity

The user's objection was right: `.8602` rounds to `.86`; it is a **numerical match at the published precision**. It remains a **limited matrix reconstruction**, because the rounded complete-case matrix is not the original missing-data MLR/FIML analysis. Those are two separate dimensions. A future template should report both, not downgrade the numeric verdict because the scope is partial.

After converting Dot's N multiplier to PR #47's N−1 convention, all eight shared chi-square fits agree within .014 points. Examples (Dot adjusted; Grokbot): refined 450.690013; 450.690326, expanded 678.855471; 678.856467, implied structure 715.125845; 715.133418. The all-indicator AIC advantage is approximately 234.132 versus 234.115. Expanded CTSE–CPSE correlations .8614 and .861509 both round to .86. This supports an execution/reporting explanation for much of the apparent disagreement.

A future comparability record should specify estimator, missingness, N, N versus N−1 normalization, mean structure, variable set, baseline model, robust scaling, and index definition. Dot's core-only CFI/SRMR cannot be equated with full-variable auxiliary-model indices. The profile identity supports discrepancy, degrees of freedom and AIC, not every fit index. Adding 21 saturated zero mean residuals to 231 covariance moments changes Dot's SRMR .060420 to about .057848, close to Grokbot's .057810; this strongly suggests a convention effect but is not a complete proof of equivalence.

## Important qualification: recovering arithmetic is not validating a test

The [official Mplus scaled-difference guidance](https://www.statmodel.com/chidiff.shtml) defines, for scaled statistics T and factors c:

```
cd = (d0*c0 - d1*c1)/(d0-d1)
TRd = (T0*c0 - T1*c1)/cd
```

PR #47's narrative instead applies `(T0-T1)/cd` while calling T scaled. That arithmetic recovers the printed 52.457, but does not establish that it is the correct scaled difference test. Crucially, [Grokbot's code](https://github.com/alectionary/vibe-math/blob/bc88de30c57945ed17bac438e17282103dcb7cbd/formalization/abbott-ctse/simulation/fit_models.R#L415-L431) and [CSV](https://github.com/alectionary/vibe-math/blob/bc88de30c57945ed17bac438e17282103dcb7cbd/formalization/abbott-ctse/simulation/out/satorra_printed.csv) contain **both** calculations; the unresolved difference is primarily interpretation in the prose.

| Comparison | Diagnostic `(T0-T1)/cd` | Official expression using printed inputs |
|---|---:|---:|
| Initial versus refined | 52.456758488 | 74.388894619 |
| General versus refined | 4.023408555 | 7.231236612 |

The latter degrees-of-freedom difference is one, not the printed two. Interpretation remains conditional on the printed factors being the relevant correction factors; full Mplus output is unavailable. The correlation-at-one restriction also needs boundary/reference-distribution caution. Dot's [original arithmetic report](report/published_checks.md) already distinguishes diagnostic arithmetic recovery from a valid test and does not infer the author's calculation process.

Thus "Grokbot's report is superior" is not a concession that Dot's official-formula arithmetic is wrong or that all Grokbot conclusions are stronger. Preserve this disagreement for review rather than resolving it by platform preference. Likewise, the conditional SD bound identifies incompatibility if the 0–100 range was enforced; it does not identify misconduct or the cause of a discrepancy.

## Candidate improvements after both perspectives are collected

1. Two-axis verdicts: numerical agreement with a stated rounding/tolerance rule, separately from replication scope and missing evidence.
2. Require a short skill-step compliance/departure ledger; establish the preferred SEM engine before a custom fallback, and label environment constraints.
3. A machine-readable comparability contract and explicit formula definitions before interpreting discrepancies.
4. A concise claim/result/evidence table leading the report; move long limitations and diagnostics to appendices without concealing them.
5. Separate "reproduces printed arithmetic" from "validates the statistical method", with a cited authoritative formula and independent computation.
6. Preserve successful diagnostics and unsuccessful attempts, including perturbation convergence counts and the fact that exploratory draws are not confidence bounds.
7. Use this paired archive as a regression case for both Dot and Grokbot, and incorporate Grokbot's separate assessment before changing the skill.

These are proposals, not implemented changes. A joint evaluation should distinguish runner-specific departures, skill ambiguity and genuine statistical uncertainty, rather than treating a better-looking paper as proof that every analysis choice is correct.
