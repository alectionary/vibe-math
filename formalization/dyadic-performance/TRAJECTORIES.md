# Decoder trajectories: a checked all-iterations obstruction in the 32-qubit codes

We found and proved a concrete obstruction: in an existing optimized 32-qubit P11 instance, error pair **{0,17}** traps the exact normalized min-sum update in seven message classes and three posterior-belief classes. Every resulting hard decision has **zero syndrome**, while the injected error has nonzero syndrome. The decoder therefore cannot match the target at **any iteration**, not merely within its 50-iteration budget. The same coordinate pair is corrected in five iterations by the existing profile-0 representative.

The [Lean proof](../dyadic-rank/DyadicMinSumTrajectory.lean) checks the concrete expanded graph, actual integer update equations, partition preservation and all-iterations failure. The [proof/axiom log](trajectory-lean-check.txt) records its build status. The finite census below also shows that this obstruction alone does **not** explain the entire deterioration: the optimized profile has fewer certified symmetry-obstructed pairs overall, but more other syndrome failures and more logical failures.

## Scope kept fixed

The [protocol](TRAJECTORY-PROTOCOL.md) limits this adaptive follow-up to four **existing** Construction 3.10 CSS pairs: profiles 0 and 2, both representatives, both sectors. All have parameters `[[32,8,4]]`. The channel remains independent X/Z component probability 0.02, perfect syndrome, uniform priors, flooding min-sum normalization 0.8, 50 iterations, integer scale `2^20`, clipping at `±50*scale` and negative-posterior hard decisions. No new candidates, noise samples or decoder modifications were introduced. An observer executable checks its results against the original decoder included unchanged in the same translation unit.

The experiment traces every binary pair in the eight sector-graph instances: **3,968 pair trajectories**. Full integer messages are archived for six illustrative trajectories; all pair hard-decision sequences and static certificate summaries are retained. Coordinate labels are zero-based expanded Tanner variable indices. A same-coordinate comparison between different codes is illustrative, not a graph-isomorphism matching or an isolated causal intervention on one invariant.

## The witness and its exact trajectory

Take profile 2, representative 0, X-error sector, which decodes with `H_Z`. Inject X on variables 0 and 17. Its syndrome is `0xa060`, with checks 5, 6, 13 and 15 unsatisfied. The initial quantized prior is exactly **4,080,869**. The observer and independent Python reference retain every edge message, posterior and clipped next message.

| Iteration | Profile 0 hard-decision support mask | Profile 2 hard-decision support mask |
| --- | --- | --- |
| 1 | `0x21220021` | `0x0` |
| 2 | `0x801` | `0x48828841` |
| 3 | `0x21000` | `0x48828841` |
| 4 | `0x1` | `0x0` |
| 5 | `0x20001` — correct, stops | `0x0` |
| 6 | Already stopped | `0x48828841` |

Profile 2 continues to output only `0x0` and `0x48828841` through iteration 50. Both have zero syndrome. **No repeated full message state was detected for this witness**; recurrence of hard decisions is not proof of a periodic message orbit. The Lean argument uses an invariant, not an assumed two-cycle.

## Why the symmetry is preserved

For a check-to-variable message, the min-sum sign depends on the target syndrome bit and the parity of negative incoming messages. Its magnitude depends on the minimum incoming absolute value. Thus incoming message-class multiplicities affect the sign only modulo two, while magnitude needs the set of classes present. At a variable node, the exact full multiset is needed because messages are added.

Starting from uniform variable messages, we refine outgoing message classes by those check and variable signatures. For this witness the refinement stabilizes at **seven variable-message classes, seven check-message classes and three posterior classes**. This is an algebraic property of the min-sum update; it does not require a graph automorphism or identify all trapping sets with absorbing sets. In particular, replacing five copies of one incoming class and two of another by one copy and six copies leaves sign and minimum unchanged.

The three belief classes are:

| Class | Variable indices |
| --- | --- |
| A | 1, 7, 10, 14, 16, 22, 26, 31 |
| B | 2, 3, 4, 5, 8, 9, 12, 13, 18, 19, 20, 21, 24, 25, 28, 29 |
| C | 0, 6, 11, 15, 17, 23, 27, 30 |

Each Tanner check meets each class in an even number of variables. For example, check 5 contains six variables from B and two from C. Any class-constant hard decision therefore gives parity `6b+2c=0` at that check, but the target there is one. All sixteen check parities are zero for every class-constant decision. Consequently the decoder cannot satisfy the target, even though the injected pair itself is a valid solution to the syndrome equation. This is a limitation of this symmetric message update, beyond the existence of a decoding solution.

## What Lean proves

The model retains exact integer arithmetic, normalization numerator 800, rounding offset 500, divisor 1000, clipping and the strict-negative hard decision. It uses the actual frozen `4×8` XOR-label array and expands it to 16 checks, 32 variables and 128 edges.

- `graph_bridge` checks every edge variable, excluded-edge check neighborhood and variable neighborhood against that concrete expansion.
- `check_factors` proves all 128 actual check updates factor through the seven message classes, for arbitrary integer class values. Sign cancellation and minimum identities are proved, not assumed from observed equality.
- `variable_factors` and `posterior_factors` prove the exact variable sums and posterior sums factor through their respective classes.
- `step_factors` combines the two updates; `state_factors` proves preservation for **every natural-number iteration count** from uniform initialization.
- `row_class_bridge` and `belief_class_zero_syndrome` check the actual parity constraint on the three posterior classes.
- `all_iterations_zero_syndrome`, `target_is_pair`, `target_nonzero` and `pair_0_17_never_matches` give the concrete obstruction.

There are **12 audited theorem declarations**. Kernel-evaluated finite certificates identify graph and syndrome data; the unbounded iteration result is an induction proof. No admitted proofs, custom axioms or native-evaluation axioms are used. The prior is arbitrary in the theorem; its experiment instantiation is 4,080,869. In the model, `hardDecision prior n` is the decision from update `n+1`. The zero initial estimate also cannot match the nonzero target before the first update.

This is a Lean model of the update equations, not a proof of the C++ compiler or a Lean-extracted decoder. The frozen C++ implementation remains unchanged. All 3,968 final responses are replayed against it; six complete traces are checked independently with the Python message definition. At the fixed prior, clipping bounds messages by 52,428,800 and posterior magnitude by 213,796,069, so the C++ 64-bit arithmetic does not overflow. The historical CSS source-layout correspondence and stabilizer scoring retain their existing computational audits. The all-iterations theorem concerns this witness; the census certificates for other errors are finite computational certificates, not thousands of additional Lean theorems.

## How much of the deterioration this explains

The local partition signatures yield a finite test: form the support indicator of each posterior class, apply the parity-check matrix to those indicators, and ask whether the target syndrome lies in their span. If it does not, no class-constant hard decision can match it. This is a sufficient obstruction. Failure of this test to certify an obstruction does not imply that decoding succeeds.

The following totals sum both sectors for one code; **both representatives give the same totals**. Each row accounts for 992 binary-pair inputs. “Other syndrome” means not certified by this particular partition test; it does not mean that no other symmetry or obstruction exists.

| Profile | Successful pairs | Symmetry-forced syndrome failures | Other syndrome failures | Logical failures |
| --- | ---: | ---: | ---: | ---: |
| 0 | 576 | 256 | 64 | 96 |
| 2 | 480 | 224 | 128 | 160 |

Profile 2 has **96 more failed binary-pair inputs** than profile 0: symmetry-forced failures decrease by 32, other syndrome failures increase by 64 and logical failures increase by 64. The witness identifies a real new barrier for that particular pair, but counting more such barriers is not the explanation of the aggregate deterioration.

Combining sector responses gives the exact contribution from every Pauli error of physical weight at most two, including Y errors. The following are unconditional probability masses, in percentage points, at the fixed channel. Each pattern has exact numerator `49^(64-t)` over `50^64`, with `t=wt(X)+wt(Z)`. Unioning failures avoids double-counting a pattern whose two sectors both fail.

| Failure category on physical weight ≤2 | Profile 0 (%) | Profile 2 (%) | Change (points) |
| --- | ---: | ---: | ---: |
| symmetry forced syndrome | 3.0468 | 2.6657 | -0.3811 |
| other syndrome | 0.7616 | 1.5233 | +0.7617 |
| logical | 1.1421 | 1.9039 | +0.7617 |

The net increase is **1.1424 percentage points**. A decreasing symmetry-forced contribution is outweighed by increasing other-syndrome and logical contributions. These categories differ from the earlier decoder-independent coset-ambiguity/excess decomposition: a symmetry-limited decoder can fail even when unrestricted syndrome decoding can succeed. They must not be added together as independent lower bounds.

The fresh fixed-representative FER means from the previous experiment are 13.1400% for profile 0 and 15.2975% for profile 2, a difference of 2.1575 points. The exact low-weight contribution difference is approximately 53% of that estimated contrast. This is a descriptive ratio, not a causal attribution or confidence interval. It compares these profiles, not the original random-baseline-versus-optimizer pool average. Higher-weight failures and the full moderate-noise policy deterioration remain incompletely explained.

Separately, full-message repeats of periods four and ten are observed for some other failed pair trajectories before the 50-iteration stop. These are recorded as exact state repeats; they are not used to infer a period for the selected witness or to prove the Lean obstruction.

## Prior-art relationship

Symmetry-induced iterative quantum-decoder failures are established prior art. Raveendran and Vasić's [Trapping Sets of Quantum LDPC Codes](https://arxiv.org/html/2012.15297v2), especially Section 3.1.2, studies symmetric stabilizer trapping sets and symmetry-breaking decoder schedules. Morris, Pllaha and Kelley's [Absorbing Sets in Quantum LDPC Codes](https://arxiv.org/html/2307.14532v2), especially its introduction and Section V, relates that phenomenon to a broader absorbing-set framework and distinguishes logical from syndrome failures. Their results motivate this investigation and receive credit; the general symmetry mechanism is not claimed new.

Here the concrete result is an exact, all-iterations, Lean-checked min-sum obstruction for an existing P11 instance, with a finite census that also exposes the limit of that explanation. We do not claim a first formalization or identify this complete code with a particular named symmetric-stabilizer configuration from those papers. P11's authors supplied the code construction and the performance-objective research direction. Their [Section 7](https://arxiv.org/html/2605.01942v1#S7), the [prior-art review](PRIOR-ART.md) and [source mapping](QUANTUM-SOURCE-COMPARISON.md) retain that provenance.

## Reproduction and stop condition

```sh
# Repository root; Python 3 and a C++17 compiler
python3 formalization/dyadic-performance/search/trajectory.py
python3 formalization/dyadic-performance/search/generate_trajectory_lean.py
python3 scripts/validate_dyadic_trajectories.py
python3 formalization/dyadic-performance/search/report_trajectory.py
cd formalization/dyadic-rank
lake -f lakefile-forbidden.toml env lean DyadicMinSumTrajectory.lean
```

The pinned Lean/mathlib environment is unchanged. [Response and trace archive](search/trajectory-results.json) · [Exact probability decomposition](search/trajectory-analysis.json) · [Validation log](trajectory-checks.log) · [Verification manifest](trajectory-verification.json).

The bounded follow-up is complete: four existing CSS pairs, no new noise samples, no altered decoder, and no move to larger matrices or additional channels. This step supplies a proved structural mechanism for a specific failure and a quantified partial explanation; the broad P11 performance and error-floor directions remain open. No completed source-target count is added. Artifacts remain local; nothing has been committed or pushed.
