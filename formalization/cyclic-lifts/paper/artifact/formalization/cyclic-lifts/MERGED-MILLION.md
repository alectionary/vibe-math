# One million fresh paired errors: original versus merged checks

This fixed experiment compares each original code to its verified merged
representation on **1,000,000 fresh shared errors at p = 4%**. All four arms
receive the same patterns: **4,000,000 decoder executions**, not four million
independent samples. Matrices, physical labels, H_Z, channel and decoder were
frozen before noise generation. Previous experiments are not pooled.

Both representations of each code have the identical labeled CSS code,
exact `[[252,10,10]]` parameters, full logical spectrum, variable degree three,
girth eight, connectedness and 756 edges. The merger changes 126 checks to
125 and creates one degree-twelve check in place of two degree-six checks.
The absorbing counts change 2,646 to 2,764 and 2,520 to 2,640, respectively.

## Paired performance results

Differences below are merged minus original, in percentage points. The
simultaneous intervals use a Bonferroni adjustment for the two predefined
contrasts: each marginal interval has nominal coverage 97.5%. These and the
pointwise intervals use the paired normal approximation.

| Code | Original FER | Merged FER | Difference (points) | Paired 95% interval | Simultaneous 95% interval |
| --- | ---: | ---: | ---: | --- | --- |
| previous_best | 2.7123% | 2.8116% | +0.0993 | [+0.0712, +0.1274] | [+0.0671, +0.1315] |
| minimum_4 | 2.5549% | 2.6719% | +0.1170 | [+0.0890, +0.1450] | [+0.0850, +0.1490] |

previous_best: The adjusted interval favors the original representation.
minimum_4: The adjusted interval favors the original representation.

| Code / representation | Failures | Syndrome failures | Matched logical failures | Successful nonzero stabilizer residuals | Mean iterations |
| --- | ---: | ---: | ---: | ---: | ---: |
| previous_best / original | 27,123 | 26,707 | 416 | 58,336 | 9.01474 |
| previous_best / merged | 28,116 | 27,716 | 400 | 58,004 | 9.16247 |
| minimum_4 / original | 25,549 | 25,257 | 292 | 58,958 | 8.84984 |
| minimum_4 / merged | 26,719 | 26,433 | 286 | 58,646 | 9.00882 |

previous_best: +1,009 syndrome failures and -16 logical failures, totaling +993 extra failures. The net deterioration is in syndrome convergence; measured logical failures decrease slightly.
minimum_4: +1,176 syndrome failures and -6 logical failures, totaling +1,170 extra failures. The net deterioration is in syndrome convergence; measured logical failures decrease slightly.

Stabilizer-equivalent recovery is success even if the returned estimate
differs from the true error. Every outcome is checked against the full original
syndrome as well as the unchanged complete H_Z span. Same-code row-span
equality means a match to merged constraints is equivalent to a match to
the original constraints; merging cannot hide an unsatisfied original check.

| Code | Original failed, merged succeeded (rescued) | Original succeeded, merged failed (harmed) | Net extra merged failures |
| --- | ---: | ---: | ---: |
| previous_best | 9,818 | 10,811 | +993 |
| minimum_4 | 9,638 | 10,808 | +1,170 |

## Where hard-decision trajectories diverge across the full cohort

Every original/merged pair was traced internally, not just the saved examples.
The table reports the first differing hard-decision vector while both decoders
are still running. It distinguishes those histories from edge-message histories,
which are not archived here. Messages may differ before a hard decision changes.

| Code | Joint outcome | Patterns | First hard divergence at iteration 1 | First hard divergence later | No hard divergence | Median first divergence when present |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| previous_best | both_succeed | 962,066 | 87,693 | 220,520 | 653,853 | 2.0 |
| previous_best | rescued | 9,818 | 1,457 | 8,361 | 0 | 4.0 |
| previous_best | harmed | 10,811 | 1,822 | 8,989 | 0 | 4.0 |
| previous_best | both_fail | 17,305 | 2,277 | 14,725 | 303 | 4.0 |
| minimum_4 | both_succeed | 963,643 | 87,953 | 220,572 | 655,118 | 2.0 |
| minimum_4 | rescued | 9,638 | 1,368 | 8,270 | 0 | 4.0 |
| minimum_4 | harmed | 10,808 | 1,805 | 9,003 | 0 | 4.0 |
| minimum_4 | both_fail | 15,911 | 2,158 | 13,465 | 288 | 4.0 |

All first-iteration differences are confined to the twelve source-check
variables. Later divergence can involve variables outside those neighborhoods.
The complete per-pattern first-divergence index, changed-variable counts,
inside-neighborhood counts and number of differing common iterations are
stored in compressed streams and independently reconstructed in the audit.

previous_best: the first differing hard-decision vector includes variables outside the two source checks on 180,715 patterns.
minimum_4: the first differing hard-decision vector includes variables outside the two source checks on 179,109 patterns.


## A precise first-iteration message change

Let s_A and s_B be the original syndrome bits of the two checks. Their merged
syndrome is s_A XOR s_B. Initially all variable-to-check messages have the
same positive prior L = 3,332,431; the normalized check-message magnitude is
M = 2,665,945, in fixed-point units of 2^-20. This initial magnitude is the
same for degree-six and degree-twelve checks because the incoming magnitudes
are all L.

Thus each source-A variable originally receives message sign (-1)^s_A from
that check and instead receives (-1)^(s_A XOR s_B); the analogous statement
holds for B. All other first-iteration messages are unchanged. With variable
degree three and 0 < M < L < 2M, a first-iteration decision is one exactly
when all three incident syndrome bits are one. This proves the local update
rule used to check saved histories.

- 00: all first-iteration messages and decisions agree. Later message magnitudes
  or signs can still diverge because the merged minimum uses eleven other
  incoming edges rather than five.
- 01: messages on A change from positive to negative; B's initial signs agree.
- 10: messages on B change from positive to negative; A's initial signs agree.
- 11: the merged message is positive instead of negative on both source sets.

This is an exact local calculation, not a proof of eventual failure or a
complete explanation of the aggregate FER change. In particular, it makes
the graph intervention's message coupling explicit without attributing the
effect solely to the new absorbing supports.

A separate audit regenerates the same noise stream and checks this local
rule on all 2,000,000 code/error pairs. For a variable on A, a first-iteration
decision differs exactly when s_B = 1 and both other incident check syndromes
are one; the symmetric rule holds on B. The audit predicts the presence,
number and confinement of every first-iteration hard-decision divergence.
It performs no additional decoder executions and is not a Lean formalization.

The following strata are descriptive, conditional on the initial source-check
syndromes. They are not extra confirmatory tests:

| Code | Initial source bits | Patterns | Original failures | Merged failures | Net extra merged failures |
| --- | --- | ---: | ---: | ---: | ---: |
| previous_best | 00 | 644,980 | 16,055 | 16,349 | +294 |
| previous_best | 01 | 157,937 | 4,863 | 5,163 | +300 |
| previous_best | 10 | 158,501 | 4,833 | 5,010 | +177 |
| previous_best | 11 | 38,582 | 1,372 | 1,594 | +222 |
| minimum_4 | 00 | 645,321 | 14,965 | 15,368 | +403 |
| minimum_4 | 01 | 157,766 | 4,499 | 4,829 | +330 |
| minimum_4 | 10 | 158,033 | 4,680 | 4,831 | +151 |
| minimum_4 | 11 | 38,880 | 1,405 | 1,691 | +286 |

## Direct containment of newly gained absorbing supports

We check every initial error for containment of any of the 118 or 120 newly
gained four-variable supports. Containment does not assert that the decoder
is trapped on that support. Conversely, an error that initially contains none
can later develop a residual containing one.

| Code | Initial error contains a gained support | Patterns | Rescued | Harmed | Net extra merged failures |
| --- | --- | ---: | ---: | ---: | ---: |
| previous_best | No | 999,719 | 9,812 | 10,783 | +971 |
| previous_best | Yes | 281 | 6 | 28 | +22 |
| minimum_4 | No | 999,675 | 9,630 | 10,779 | +1,149 |
| minimum_4 | Yes | 325 | 8 | 29 | +21 |

This exact finite decomposition separates initially contained patterns from
the rest. It does not classify all dynamic trapping events. Only the selected
complete histories below have per-iteration residual-support annotations;
do not extrapolate their proportions to the entire million-error cohort.

previous_best: +971 net extra failures occur among initially non-containing errors, versus +22 among containing errors. Direct initial containment alone does not account for most of the observed net penalty. This does not exclude later dynamic interaction with gained supports.
minimum_4: +1,149 net extra failures occur among initially non-containing errors, versus +21 among containing errors. Direct initial containment alone does not account for most of the observed net penalty. This does not exclude later dynamic interaction with gained supports.


## Full, predefined trajectory examples

For each code we retain the union of the first three errors in every joint
success/failure category and the first error in every ordered transition
between exact success, stabilizer success, syndrome failure and logical
failure. Indices are zero-based in the fixed noise stream. The selection
is deterministic and was frozen before outcomes; it is not a random sample
of trajectories. Each complete hard-decision history matches independent
Python message equations and the original uninstrumented C++ terminal output.

The first harmed and rescued examples per code are:

| Code | Example | Error index | First hard divergence | Differing variable indices | Original / merged iterations | Terminal transition | Initial gained-support containment |
| --- | --- | ---: | ---: | --- | --- | --- | --- |
| previous_best | harmed | 167 | 1 | [173] | 97 / 100 | exact->syndrome | False |
| previous_best | rescued | 158 | 2 | [90, 156] | 100 / 16 | syndrome->stabilizer | False |
| minimum_4 | harmed | 0 | 3 | [5, 58] | 10 / 100 | exact->syndrome | False |
| minimum_4 | rescued | 90 | 18 | [14, 24, 26, 30, 45, 52, 71, 96, 145, 168, 177, 180, 196, 220, 235] | 100 / 29 | syndrome->exact | False |

previous_best: 22 saved error pairs, 44 complete histories.
minimum_4: 23 saved error pairs, 46 complete histories.

In previous_best's first harmed example, first hard divergence is at iteration 1 on variables [173]. The original recovers at iteration 97; merged decoding still fails at its limit. The merged residual first contains a gained support at iteration 58. This is an observed intermediate event, not proof of a permanent trap.
In minimum_4's first harmed example, first hard divergence is at iteration 3 on variables [5, 58]. The original recovers at iteration 10; merged decoding still fails at its limit. The merged residual first contains a gained support at iteration 16. This is an observed intermediate event, not proof of a permanent trap.

Full decisions, iteration-to-iteration changed variables, full-original residual
syndrome weights, residual stabilizer membership and gained-support containment
are linked below. The first-divergence summaries cover all million pairs per
code; the detailed residual annotations cover only the selected histories.

## Interpretation and scope

This estimates the total effect of the specified redundant-check merger on
each fixed code under the fixed decoder and channel. Code, full logical
spectrum, every variable degree, girth and edge count are controlled. Check
degree, check count, cycle multiplicity and message routing change together.
Therefore the results do not isolate absorbing count as the causal variable
or establish a universal design objective. The local XOR-sign mechanism and
the finite trajectory decompositions are more specific than an aggregate
correlation, but are not a complete structural explanation of all failures.

The [earlier feasibility result](DEGREE-PRESERVING.md) also shows that retaining
126 nonzero checks alongside these code/degree/girth constraints would force
the original row set in these codes. No new candidate population, noise
level, decoder change, Lean declaration or completed inventory target is
asserted by this experiment.

## Reproduction and audit

[Frozen protocol](MERGED-MILLION-PROTOCOL.md) ·
[Frozen source/input hashes](search/merged-million-selection.json) ·
[Full outcomes, cohort streams and selected histories](search/merged-million-results.json) ·
[Descriptive summaries](search/merged-million-analysis.json) ·
[Run log](merged-million-run.log) ·
[Independent audit](merged-million-checks.log) ·
[All-pair first-step audit](merged-first-step-checks.log) ·
[First-step validation data](search/merged-first-step-validation.json) ·
[Verification manifest](merged-million-verification.json).

```sh
# From repository root
python3 formalization/cyclic-lifts/search/merged_million.py
python3 scripts/validate_cyclic_merged_million.py
python3 scripts/validate_cyclic_merged_first_step.py
python3 formalization/cyclic-lifts/search/report_merged_million.py
```

The unchanged stock decoder passes 128 direct reference cases and 1,148
total controls on the four arms. Before the fresh run, 128 wrapper terminal
outcomes agree with stock, and 64 paired cases verify batch independence.
The independent audit regenerates every noise pattern and batch/full hash,
checks all gained-support containment and source-syndrome annotations,
reconstructs all outcome/divergence histograms and both adjusted contrasts,
and replays the predefined full histories with C++ and direct Python.

The degree-preserving constructions were published at commit 7d58083.
This new million-error experiment and report remain local.
