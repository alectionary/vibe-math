# Bounded follow-up: objective disagreement and low-weight quantum failures

We found **two disagreements in the existing Construction 3.10 sample**, and the absorbing objective wins both fixed-code comparisons on fresh noise. We also exactly decomposed low-weight failures into stabilizer-coset ambiguity and decoder excess, and checked the reusable ambiguity inequalities in Lean. These narrow the three research gaps; they do not establish a universal best objective, a complete structural explanation or an adequate general error-floor predictor.

This is an adaptive follow-up to the [quantum experiment](QUANTUM.md), with its own [protocol](TARGETED-PROTOCOL.md) fixed before the new decoding. It uses only existing candidates, the same source constructions, the same dimensions/distances, independent X/Z component probability 0.02, normalization 0.8, 50 min-sum iterations and perfect syndrome measurements. The originating research directions are in Gómez-Fonseca, Matthews, Morris and Pllaha's [Section 7](https://arxiv.org/html/2605.01942v1#S7); this remains a performance research direction rather than a single conjecture with a yes/no answer.

## 1. Objectives can disagree, and one wins these comparisons

The 384 saved candidates per construction have seven observed individual-sector graph/kernel profiles in 3.10 and four in 3.11. Two parameter instances per profile were selected by canonical parameter order, from different original pools, **using no decoding outcomes**. This is 22 existing CSS pairs, not 22 new searches. These profiles are sampled invariant classes, not a classification of all source constructions or an isomorphism test. Both representatives in every profile have identical exact low-weight failure counts and ambiguity masses in this experiment.

The two 3.10 disagreements are profiles 3 versus 0 and 5 versus 0. Profiles 3 and 5 have swapped X/Z invariant profiles with the same aggregate features; these results are not evidence for two independent structural mechanisms. They tie profile 0 on four- and six-cycle totals, at 320 and 3,072. The cycle-first rule prefers their 40,928 eight-cycles over profile 0's 41,344. The absorbing objective prefers profile 0's 736 positive-b four-variable supports over their 928. Both sides have 112 zero-b four-variable supports. Quantum parameters remain `[[32,8,4]]`.

The difference below is cycle-preferred FER minus absorbing-preferred FER; positive favors the absorbing choice. Each representative uses 20,000 fresh frames, shared across profiles within replicate. Intervals use the paired error indicators, stratified over the two representatives. The 97.5% marginal intervals give an approximate Bonferroni 95% family level for the two planned contrasts. They concern these fixed codes and Monte Carlo noise, not uncertainty across a population of code designs.

| Cycle profile versus absorbing profile | FER difference (percentage points) | Paired 97.5% interval (points) |
| --- | ---: | --- |
| 3 versus 0 | +1.5225 | [+1.1671, +1.8779] |
| 5 versus 0 | +1.6300 | [+1.2725, +1.9875] |

The absorbing choice wins these matched disagreements. However, original global objective winner profile 2 still has the worst fresh FER of all seven observed 3.10 profiles. All original objectives prefer profile 2 to profile 0. Thus the local win does not justify an unrestricted absorbing-only recommendation. There are no objective disagreements in the saved 3.11 profiles, and neither family's saved sample contains equal total `(C4,C6,C8)` with different aggregate absorbing features. A complete cycle tuple therefore already identifies the aggregate absorbing vector on this finite sample; this is not a general identity.

## 2. Exact failure contribution and a partial mechanism

Every binary sector error of weight zero, one or two was decoded. The two independent deterministic sector responses were then combined to evaluate **every Pauli error of physical weight at most two**, including mixed X/Z and Y errors. There are 4,561 such patterns per 32-qubit code and 41,329 per 96-qubit code: **394,486 exact pattern evaluations from 89,324 binary-sector responses**. Success means both residuals are stabilizers, including arbitrary products of generators.

All single-qubit Pauli errors succeed at the fixed setting. Leading observed failures therefore have physical weight two. For a pattern with `t=wt(X)+wt(Z)` nonzero binary components, its probability at `p=1/50` is exactly `49^(2n-t)/50^(2n)`. The archive retains integer numerators and a common denominator, not only floating approximations. These masses are unconditional contributions to FER, not failure rates conditioned on a low-weight event. The complete tables retain all profiles and both fresh FER estimates:

### Construction 3.10

| Profile | Total cycles (4,6,8) | Positive-b size-4 absorbing supports | Fresh FER, reps 0 / 1 (%) | Exact low-weight failure mass (%) | Ambiguity bound (%) | Decoder excess (%) |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| 0 | [320, 3072, 41344] | 736 | 13.045 / 13.235 | 4.9505 | 2.6062 | 2.3443 |
| 1 | [352, 3200, 39344] | 896 | 13.500 / 13.355 | 5.1410 | 2.5377 | 2.6033 |
| 2 | [256, 2816, 44512] | 800 | 15.355 / 15.240 | 6.0929 | 2.7435 | 3.3494 |
| 3 | [320, 3072, 40928] | 928 | 14.465 / 14.860 | 5.7123 | 2.6063 | 3.1060 |
| 4 | [352, 3200, 39344] | 896 | 13.350 / 13.530 | 5.1410 | 2.5377 | 2.6033 |
| 5 | [320, 3072, 40928] | 928 | 14.850 / 14.690 | 5.7123 | 2.6063 | 3.1060 |
| 6 | [384, 3328, 37344] | 1056 | 13.960 / 13.815 | 5.3313 | 2.4692 | 2.8621 |

### Construction 3.11

| Profile | Total cycles (4,6,8) | Positive-b size-4 absorbing supports | Fresh FER, reps 0 / 1 (%) | Exact low-weight failure mass (%) | Ambiguity bound (%) | Decoder excess (%) |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| 0 | [960, 10752, 258624] | 5376 | 28.320 / 28.280 | 0.6023 | 0.4340 | 0.1683 |
| 1 | [1216, 13824, 273792] | 6976 | 33.050 / 32.010 | 1.1473 | 0.5167 | 0.6306 |
| 2 | [1472, 16896, 280256] | 8448 | 32.575 / 32.470 | 1.0039 | 0.5994 | 0.4045 |
| 3 | [1728, 19968, 290304] | 14400 | 36.735 / 36.490 | 1.2047 | 0.6821 | 0.5226 |


For the 3.10 contrast of original objective winner profile 2 with profile 0, exact low-weight failure mass increases by **1.1424 percentage points**. The ambiguity bound increases by only **0.1373 points**, while decoder excess increases by **1.0051 points**. This is an exact finite decomposition: most of this low-weight difference is not forced by the best possible class choice on the truncated ensemble. It does not show what a globally optimal decoder would do on the full channel.

At binary component weight two, profile 0 has 96 logical and 320 syndrome failures across both sectors; profile 2 has 160 and 352. The two cycle-preferred disagreement profiles have 96 and 384. Low-weight logical degeneracy and failure to satisfy a syndrome are different mechanisms and must not be combined into a raw absorbing count.

The following support-level diagnostic concerns **binary pairs**, summing both sectors, for one representative per profile. Each code has 992 sector/pair inputs. A degree-four pair is absorbing exactly when its two variables share more than two checks; the cases here have three shared checks.

| Profile | Shared checks | Successful pairs | Logical failures | Syndrome failures |
| --- | ---: | ---: | ---: | ---: |
| 0 | 0 | 288 | 32 | 64 |
| 0 | 1 | 256 | 64 | 32 |
| 0 | 2 | 32 | 0 | 192 |
| 0 | 3 | 0 | 0 | 32 |
| 2 | 0 | 224 | 32 | 64 |
| 2 | 1 | 256 | 128 | 96 |
| 2 | 2 | 0 | 0 | 160 |
| 2 | 3 | 0 | 0 | 32 |

Every profile has exactly 32 absorbing sector/pairs, all failing by syndrome mismatch. Their constant count cannot explain the performance variation. Most failed pairs are not absorbing themselves. Furthermore, **all 992 sector/pair inputs in every tested 32-qubit representative, including every successful pair, are contained in a four-variable absorbing support**. This particular containment test has no specificity in this sample. It is not an explanation of failure, and counting overlapping supersets as independent harmful events would be wrong. Four-variable containment was not assessed for 96-qubit representatives; empty archive fields there mean not assessed.

These results give a partial mechanism and disqualify two simple explanations. They do not yet provide a dynamical/topological theorem explaining why a specific min-sum trajectory converges, stalls or chooses a logical class. The exact decomposition is stronger than labeling failures alone, but weaker than such a theorem.

## 3. A general finite ambiguity bound, with a precise formal scope

Let E be any finite set of Pauli errors modulo phase, S the stabilizer subgroup, s(e) the full syndrome, and [e] the class modulo S. Set

\[
m_{y,c}=\sum_{e\in E:\ s(e)=y,\ [e]=c}P(e),\qquad
L_E=\sum_y\left(\sum_c m_{y,c}-\max_c m_{y,c}\right).
\]

Then every deterministic syndrome decoder D satisfies

\[
L_E\le P(e\in E\text{ and }D\text{ fails on }e)\le P(D\text{ fails}).
\]

Proof: D selects one recovery class for each syndrome. It can recover no more than the largest class mass in that syndrome's E-bucket. Subtracting this from the bucket total gives the first inequality after summing. The second follows by inclusion and nonnegative probabilities. The largest class can be chosen independently in each bucket, so the lower bound is attainable for the truncated ensemble by an unrestricted syndrome decoder. It need not be attained by the min-sum decoder or by the full-channel optimal decoder.

Algebraically, if e and f have the same syndrome and a single recovery r corrects both, then `(r-f)-(r-e)=e-f` is a stabilizer. If their difference is logical and nontrivial, at least one must fail. Consequently, partitioning a weight-four logical support into two pairs exhibits same-syndrome, inequivalent weight-two errors. Partitioning a weight-four stabilizer gives equivalent errors instead. This explains why zero-b support counts need a stabilizer/logical distinction; raw kernel counts merge benign degeneracy with unavoidable competition.

The [Lean file](../dyadic-rank/QuantumSyndromeAmbiguity.lean) checks five reusable statements:

- `recoverable_same_syndrome`: the subgroup calculation above for any additive commutative group, arbitrary syndrome map and decoder.
- `collision_forces_failure`: the inequivalent-collision consequence.
- `bucket_mass_bound`: total bucket weight ≤ a bound on chosen-class weight plus failure weight.
- `finite_error_mass_bound`: sum this over an explicit finite syndrome partition and finite error set.
- `failure_mass_monotone`: passing to a larger error set cannot decrease nonnegative failure mass.

The weighted inequalities use natural-number weights, which exactly represent this experiment's common-denominator probabilities; divide by the positive denominator for the displayed probabilistic bound. The finite theorem assumes `M(y)` bounds the chosen class mass; setting it to the maximum class mass supplies this bound. The definitions of experiment-specific CSS classes, their correspondence to concrete binary matrices, and the decoder executable are independently checked computations, **not Lean formalizations in this file**. Likewise, the weight-four partition application is a written corollary here. No claim is made that Lean has checked the statistical experiment or a general absorbing-set classification. [Build and axiom audit](ambiguity-lean-check.txt): no `sorry`, admitted axioms or `native_decide`; only standard Lean foundational axioms are reported.

This is the standard stabilizer-coset decoding principle, credited to Iyer and Poulin, [Hardness of decoding quantum stabilizer codes](https://arxiv.org/html/1310.3235), rather than a priority claim for a new general theorem. Poulin and Chung's [On the iterative decoding of sparse quantum codes](https://arxiv.org/abs/0801.1241v2) already distinguish the effects of loops and degeneracy on iterative quantum decoding. The earlier [prior-art review](PRIOR-ART.md) covers trapping-set and decoder-conditioned error-floor predecessors. Our contribution in this step is the finite application, objective contrasts, exact decomposition and small checked algebraic/weighted lemmas for these saved P11 instances.

## How far the three requested paths advanced

| Path | What this step establishes | Remaining gap |
| --- | --- | --- |
| Superior objective | Absorbing objective wins both existing 3.10 disagreements on fresh fixed-code samples; 3.11 still has no disagreements | No population-level or universal winner; the global absorbing minimum is still worse than alternatives |
| Why optimization helps or hurts | Exact ambiguity/excess decomposition; low-weight logical/syndrome breakdown; two simple absorbing predictors fail | No complete decoder-trajectory explanation, particularly for the larger codes |
| General theory / error-floor predictor | General coset lower bound with reusable Lean lemmas, plus exact finite low-weight spectra | No general absorbing-set classification or validated asymptotic/full-channel error-floor predictor |

Exact low-weight failure masses divided by the fresh FER estimates are about **37.7–39.8% in 3.10** and **2.1–3.5% in 3.11**. These ratios compare an exact contribution with a Monte Carlo estimate; they are not fitted prediction scores or independent confidence intervals. In the 96-qubit setting, failures of physical weight above two dominate at this noise level. Extrapolating the present low-weight table to an error floor would be unjustified. The decoder prior is fixed here; changing noise probability with a matched prior can also change its deterministic responses.

## Reproduction, audit and stopping point

From the repository root:

```sh
python3 formalization/dyadic-performance/search/targeted.py
python3 scripts/validate_dyadic_targeted.py --lean
python3 formalization/dyadic-performance/search/report_targeted.py
cd formalization/dyadic-rank
lake -f lakefile-forbidden.toml env lean QuantumSyndromeAmbiguity.lean
```

The existing pinned toolchain is Lean `v4.36.0-rc1` with mathlib revision `5f7b4198d22a9c82e1c698a379334fe128095c82`. No existing proof file or frozen selection manifest was changed. [Geometry-only selection](search/targeted-selection.json), [full response archive](search/targeted-results.json), [validation output](targeted-checks.log) and [verification record](targeted-verification.json) retain source hashes, exact numerators, syndrome collision witnesses, every low-weight response and paired fresh failure bitmaps. An independent lowest-pivot stabilizer reduction checks all archived classes and ambiguity sums; 352 C++/Python decoder comparisons include fresh-noise and low-weight inputs. These are computational audits distinct from the five Lean lemmas.

The fresh study uses **80,000 independent quantum noise frames**, shared across profiles, **440,000 representative-frame evaluations** and **880,000 sector decoder executions**. The exhaustive study adds 89,324 sector responses. The 394,486 Pauli patterns are evaluations assembled from those sector responses, not extra decoder runs. Reference checks are separate audit work.

The predeclared cap of 22 existing pairs is reached. We stop here: no larger matrices, new candidate populations, extra channels, altered decoder or new optimization weights were introduced. The P11 research direction remains open, and the count of completed source targets is unchanged. All new artifacts are local; no commit or push was made.
