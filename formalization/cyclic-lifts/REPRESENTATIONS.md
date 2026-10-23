# Same code, different parity-check representations

**Yes, absorbing-set counts can vary while the exact labeled CSS code,
channel and decoder algorithm stay fixed. But the tested interventions also
change graph degrees or short cycles.** We found no pure count intervention.
In fact, the existing exhaustive census rules out an alternative using 126
distinct weight-six H_X checks for either of the two saved codes.

The first bounded deletion pilot found **lower counts and worse decoding**
in both codes. This is evidence about deleting a redundant generator, not
evidence that absorbing sets are beneficial or that lower count caused the
earlier cross-code improvement.

## What stays exactly the same

H_Z and physical coordinate labels are unchanged. Each modified H_X has
exactly the original binary row span, verified in both directions with two
pivot conventions. Thus the stabilizer group, encoded space, full labeled
logical structure and logical weight spectra are identical. The existing
exact `[[252,10,10]]` parameters transfer without another distance search.
Every modified row commutes with H_Z, and both ranks remain 121.

Deletion removes an individually redundant row. A saved explicit XOR
relation expresses that row through retained rows. Consequently an estimate
matches the remaining perfect syndrome if and only if it matches the full
original syndrome: deletion cannot manufacture a false syndrome acceptance.
It changes the factor graph and its messages, rather than the set of valid
parity constraints. No claim is made for noisy syndrome measurements.

## Feasibility counts, before new decoding

The [feasibility protocol](REPRESENTATION-PROTOCOL.md) deterministically tests
six representations of each code. All counts below are complete four-variable
absorbing-support counts: every selected variable has strictly more even
than odd incident checks. The former regular-graph eight-cycle shortcut is
not used on modified graphs.

| Code | Representation | Absorbing supports | Checks | Edges | Girth |
| --- | --- | ---: | ---: | ---: | ---: |
| previous_best | original | 2,646 | 126 | 756 | 8 |
| previous_best | row_order_control | 2,646 | 126 | 756 | 8 |
| previous_best | delete_one | 2,559 | 125 | 750 | 8 |
| previous_best | independent_basis | 2,303 | 121 | 726 | 8 |
| previous_best | xor_overlap_1 | 2,542 | 126 | 760 | 4 |
| previous_best | xor_overlap_0 | 2,564 | 126 | 762 | 4 |
| minimum_4 | original | 2,520 | 126 | 756 | 8 |
| minimum_4 | row_order_control | 2,520 | 126 | 756 | 8 |
| minimum_4 | delete_one | 2,442 | 125 | 750 | 8 |
| minimum_4 | independent_basis | 2,148 | 121 | 726 | 8 |
| minimum_4 | xor_overlap_1 | 2,408 | 126 | 760 | 4 |
| minimum_4 | xor_overlap_0 | 2,442 | 126 | 762 | 4 |

Reversing row order is a relabeling control. Deleting row zero preserves
girth eight and keeps every remaining row at weight six, but changes six
variable degrees from three to two. Retaining an independent basis changes
more degrees, including some to one. Row-XOR replacements retain 126 checks
but introduce a weight-ten or weight-twelve row and four-cycles. All examined
graphs are connected.

The census contains exactly 126 weight-six vectors in each original H_X
span, and these are precisely its original distinct rows. Any representation
with 126 distinct weight-six rows and that same span must therefore use that
same row set. This is a written finite rigidity deduction from the independently
verified exhaustive census, not a new Lean theorem or a search over every
possible generator weight. It does not rule out other interventions after
relaxing these constraints.

Modified graphs are irregular. Their surviving size-four absorbing supports
include syndrome weights three and, for bases, two. Thus lower totals do not
mean an otherwise identical collection with some equally harmful sets removed.
These representations also lie outside the original normalized regular
lifted-product search family; counts below 2,520 do not contradict its minimum.

## Fixed deletion pilot

The [separate pilot protocol](REPRESENTATION-TRAJECTORY-PROTOCOL.md) was frozen
after feasibility and before decoding. It uses 50,000 new shared Bernoulli
Z-error patterns, p = 0.04, seed 20261026, across six representations: original,
row-order control and deletion for each code. There are 300,000 decoder
executions, not 300,000 independent errors. The old million-pair experiment
is not pooled. Alpha 0.8, 100 iterations, integer arithmetic, clipping,
rounding, ties and stopping rule are unchanged. Stabilizer-equivalent recovery
counts as success using the same full H_Z span.

| Code | Original FER | Delete-one FER | Change (percentage points) | Pointwise paired 95% interval |
| --- | ---: | ---: | ---: | --- |
| previous_best | 1,305/50,000 = 2.610% | 1,487/50,000 = 2.974% | +0.364 | [+0.233, +0.495] |
| minimum_4 | 1,274/50,000 = 2.548% | 1,398/50,000 = 2.796% | +0.248 | [+0.120, +0.376] |

These are exploratory pointwise intervals for two predefined contrasts,
without a multiple-testing correction. The sample size was fixed, and no
representations were selected or tuned using these outcomes. Row reversal
matches the original estimate, stopping iteration and syndrome status on
all 100,000 within-code comparisons, not merely in aggregate.

| Code | Rescued by deletion | Harmed by deletion | Extra syndrome failures | Extra logical failures |
| --- | ---: | ---: | ---: | ---: |
| previous_best | 472 | 654 | +175 | +7 |
| minimum_4 | 470 | 594 | +124 | +0 |

## Checked trajectories and a precise local mechanism

We retain the first three errors in each joint outcome category for each
code: both succeed, rescued, harmed, both fail. This yields 24 error examples
and 48 full hard-decision trajectories. Trace instrumentation only emits
decisions from an otherwise unchanged copy of the C++ decoder. Each complete
history agrees with direct Python message equations, and every final outcome
is replayed with the original uninstrumented C++ decoder. Per iteration we
record full-original-code residual syndrome weight, stabilizer membership
and changed variables. These are hard-decision histories, not archived full
edge-message histories.

The fixed-point prior at p = 0.04 is `L = 3332431` and the initial incoming
check-message magnitude is `M = 2665945`, in units of 2^-20. Hence
`0 < M < L < 2M`. On iteration one all variable-to-check messages have the
positive magnitude L, so a check's message sign is its syndrome sign.

For an affected original degree-three variable, the posterior is
`L + M(s0 + s1 + s2)`, where each s is +1 for syndrome zero and -1 for one.
It is negative exactly when all three syndrome bits are one: with only two
negative signs the posterior is `L-M > 0`. After deleting check zero, the
posterior is `L + M(s1+s2)`, negative exactly when both retained bits are one,
because `L-2M < 0`. Thus a deleted check with syndrome zero can previously
have prevented an incorrect flip. All eight syndrome-bit cases are checked.
This algebra is a written local-update proof with exact arithmetic checks;
it is not Lean formalized and does not predict eventual failure.

Two deterministic two-error witnesses make that mechanism explicit. Indices
are zero-based, with physical coordinate labels unchanged:

| Code | True error support | Affected variable | Incident syndrome bits (deleted, retained, retained) | Original / deletion recovery iteration |
| --- | --- | ---: | --- | --- |
| previous_best | [53, 55] | 0 | [0, 1, 1] | 1 / 2 |
| minimum_4 | [50, 55] | 0 | [0, 1, 1] | 1 / 2 |

Variable zero is not in either true error. The original representation keeps
it zero on iteration one; deletion incorrectly flips it. Both representations
eventually recover exactly. These witnesses prove an update/delay mechanism,
not a failure mechanism for all harmed errors.

In the predefined sampled trajectories, hard decisions first diverge between
iterations 1 and 11 when a divergence occurs. For example, Previous best's
first harmed sample (index 6) converges in 36 iterations originally but fails
the syndrome criterion after 100 with deletion; Minimum 4's first harmed
sample (index 155) converges in 27 versus a 100-iteration syndrome failure.
All 24 selected true errors contain none of the absorbing supports lost by
deletion. That observation is restricted to these examples and to direct
containment; it does not exclude later trapping on a support or contributions
from other error patterns. The local update proof and examples do not explain
the full aggregate deterioration.

## What this establishes and what it does not

We have demonstrated a same-code, same-channel, same-decoder generator
intervention that changes absorbing count. Under that specific intervention,
the pilot measures worse performance despite a smaller count. Matching the
entire code removes logical-spectrum differences, but deletion also changes
variable degrees and the message redundancy. The identified first-update
mechanism provides a concrete alternative explanation to count alone.

This does not establish the cause of the earlier cross-code improvement,
prove that fewer absorbing sets are generally harmful, refute the original
regular-family optimization result, or resolve the general prediction program.
The next focused mechanism question is how often the changed messages lead
to the rescued/harmed trajectories, including cases with later hard-decision
divergence. No larger simulation, new code population, new noise level or
decoder modification is needed merely to state this feasibility result.

## Reproduce and audit

From the repository root:

```sh
python3 formalization/cyclic-lifts/search/representation_feasibility.py
python3 scripts/validate_cyclic_representation.py
python3 formalization/cyclic-lifts/search/representation_trajectory.py
python3 scripts/validate_cyclic_representation_trajectory.py
python3 formalization/cyclic-lifts/search/report_representation.py
```

Two complete enumeration algorithms agree on all twelve representations:
all quadruples using syndrome bitsets, and a co-neighbor graph cover using
direct row incidences. Completeness of the second follows because every
variable in an absorbing support has an even incident check and thus a
co-neighbor within the support. A four-vertex graph with no isolated vertex
either has a perfect matching or is a three-leaf star. Enumerating all
disjoint co-neighbor edge pairs and all such stars therefore covers every
possible support. Both methods also agree with exhaustive direct Python on
56 irregular toy graphs. The original weight-six census was independently
rechecked in all eight saved sectors; original decoder compatibility checks
cover 180 deterministic representation/error cases. The pilot validator
regenerates every noise pattern and reconstructs all contrasts, outcome
categories, trace-selection indices and per-iteration annotations.

[Feasibility results, rows and supports](search/representation-results.json) ·
[Pilot outcomes and full hard-decision trajectories](search/representation-trajectory-results.json) ·
[Explicit row relations and two-error witnesses](search/representation-analytic.json) ·
[Feasibility checks](representation-checks.log) ·
[Pilot checks](representation-trajectory-checks.log) ·
[Verification manifest](representation-verification.json).

The million-pair results were published at commit e39a457. This subsequent
feasibility and trajectory study is local. No new Lean declarations or
completed inventory targets are asserted.
