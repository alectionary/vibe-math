# Varying absorbing count with code, variable degrees and girth fixed

**Yes.** For each existing `[[252,10,10]]` code, merging a suitable pair
of redundant parity checks changes the absorbing-set count while preserving
the exact labeled CSS code, every variable degree, girth and total edge count.
The channel and decoder algorithm/settings are unchanged. This is a finite
feasibility result, with no fresh decoding-performance experiment.

| Code | Merged original check indices | Original absorbing supports | Modified absorbing supports | Added / lost |
| --- | --- | ---: | ---: | --- |
| previous_best | [0, 75] | 2,646 | 2,764 | +118 / 0 |
| minimum_4 | [42, 119] | 2,520 | 2,640 | +120 / 0 |

The counts increase under merging; reversing the operation decreases them
while preserving the same listed controls. This construction does not find
a count below the original regular representation's count.

## The intervention and its exact controls

Take two original H_X rows with disjoint supports whose check vertices are
at Tanner distance eight. Replace those two rows by their binary XOR, retaining
all other rows. Because the supports are disjoint, this XOR is their union.
H_Z and physical coordinate labels remain unchanged.

| Property | Original | Modified |
| --- | --- | --- |
| Exact labeled CSS code and complete logical spectrum | Same | Same |
| Parameters | `[[252,10,10]]` | `[[252,10,10]]` |
| Binary ranks H_X / H_Z | 121 / 121 | 121 / 121 |
| Every variable degree | 3 | 3 |
| Girth | 8 | 8 |
| Connected Tanner graph | Yes | Yes |
| Total edges | 756 | 756 |
| H_X checks | 126 | 125 |
| Check degree distribution | 126 checks of degree 6 | 124 of degree 6; one of degree 12 |

The same Bernoulli channel at p = 0.04, perfect syndrome, physical labels,
normalized min-sum algorithm, alpha 0.8, maximum 100 iterations, integer
arithmetic, clipping, ties and stopping rule can be used without modification.
The input factor graph changes; the decoder algorithm does not. Stabilizer
scoring uses the unchanged full H_Z span. No performance gain or loss is
inferred from this feasibility check.

## Why the constraints survive

**Code.** Every new row lies in the original H_X span. Conversely, binary
elimination verifies every original row lies in the modified span. Both have
rank 121. In fact, deleting these two rows already leaves rank 121 for the
representatives. The added XOR is redundant. CSS orthogonality is verified
against every H_Z row. Therefore the stabilizer group and all logical spectra
remain identical, rather than merely sharing a minimum distance.

**Variable degrees.** Every variable in the two disjoint supports loses exactly
one old incident check and gains the merged check. Other variables are
untouched. Hence all 252 variable degrees remain three and the edge count
stays 756.

**Girth.** This graph operation identifies the two check vertices. A new
simple cycle through the merged vertex either lifts to a cycle through one
original endpoint or to a path between the two endpoints. Old cycles have
length at least eight, and their distance is eight, so no four- or six-cycle
can appear. A shortest endpoint path becomes an eight-cycle. Thus girth is
exactly eight. BFS and independent cycle traversals verify the finite cases.

**Absorbing class.** Variable degree three and girth eight remain valid, so
the same four-variable absorbing-support/eight-cycle criterion applies. All
counted supports have four odd checks and exactly two even/one odd incident
checks at each selected variable. Unlike the earlier deletion pilot, this
does not compare irregular supports of changing syndrome-weight classes.

## The count increment has an explicit structural explanation

Every original eight-cycle survives the identification: it cannot contain
both merged check vertices, because two vertices on an eight-cycle have
distance at most four, whereas these endpoints have distance eight.

A new eight-cycle must pass through the merged check. If it used two edges
from one original endpoint it would already be an old cycle; otherwise
splitting that vertex yields a shortest length-eight path between the two
original checks. Conversely, each such path becomes a new eight-cycle.

We enumerate the labeled paths and verify that their four-variable supports
are distinct and equal **exactly** to the gained absorbing supports. There
are 118 for Previous best and 120 for Minimum 4. No original support is lost.
This is also checked by direct exhaustive quadruple enumeration, an independent
co-neighbor matching/star enumeration, projected cycle counting, simple-cycle
DFS, and shortest-path dynamic counting.

These are written structural arguments and checked finite certificates.
The new vertex-identification and counting correspondence have not been
formalized in Lean; the existing Lean absorbing/eight-cycle theorem is not
being presented as a Lean proof of this new transformation. The existing
`absorbing_cycle_equiv` and `absorbing_cycle_count` declarations in
[CyclicStructure.lean](../dyadic-rank/CyclicStructure.lean) require degree
three only on variables, with no restriction on check degrees.

## Search coverage

All 7,875 unordered original check pairs were examined for each code. Each
has fourteen pairs at distance eight and no more distant pair. Every one
of those pairs passes the exact row-span, degree, girth and connectedness
checks. They form one cyclic translation orbit per code. The report stores
two fully enumerated representatives and verifies all fourteen translates
of each representative, including the support translation. These are not
28 independent code families or performance replications.

For disjoint-row mergers, distance four or six would produce a correspondingly
short cycle. Overlapping-row XOR mergers reduce the shared variable degrees.
Thus the distance scan covers the eligible candidates for this particular
two-row merger construction; it is not an exhaustive classification of all
possible same-code generator transformations.

## Can check count also remain 126?

For these two codes, **no nontrivial representation can preserve degree three,
girth eight and 126 nonzero checks simultaneously**:

1. Every nonzero vector in the H_X span has weight at least six. Even row
   weights exclude odd weights. The unchanged H_Z column syndromes are
   nonzero and distinct, and all 31,626 pair syndromes are nonzero and
   distinct, excluding kernel words of weights two and four. All H_X-span
   vectors are in that kernel. Original rows attain weight six.
2. Degree three at 252 variables fixes total row weight at 756. With 126
   nonzero rows of weight at least six, each row must have weight exactly six.
3. The exhaustive weight-six census contains exactly the 126 original rows
   in this span. Girth eight prevents duplicate checks, which would share
   at least two variables and create a four-cycle. Thus those 126 rows are
   forced, up to reordering.

Indeed any nontrivial representation under these code/degree/girth constraints
must have 121–125 nonzero checks: rank requires at least 121; the weight budget
allows at most 126; equality forces the original representation. Zero rows
are excluded as vacuous checks and are not valid inputs to the fixed decoder.
Our merger therefore changes the number of checks by the minimum possible
amount, one. A heavy check is unavoidable whenever fewer nonzero checks carry
the same 756 edges. This is a finite-code rigidity deduction with independent
minimum-weight/census checks, not a new general classification theorem.

## Implication for the controlled study

This meets the requested stronger controls. Compared with deleting one check,
it additionally preserves every variable degree, total edge count and the
(4,4) absorbing-support class. It is a valid candidate for a separately
prespecified paired decoding/trajectory comparison using the existing channel
and decoder.

It still changes check degrees, check number, short-cycle multiplicity and
message routing. Therefore even a future performance difference would be a
total effect of this generator merger, not automatically a causal effect of
absorbing count alone. In this particular code pair, also fixing 126 nonzero
checks would leave no distinct representation to compare. No fresh Monte
Carlo run was started in this stage.

## Reproduce and audit

From repository root:

```sh
python3 formalization/cyclic-lifts/search/degree_preserving.py
python3 scripts/validate_cyclic_degree_preserving.py
python3 formalization/cyclic-lifts/search/report_degree_preserving.py
```

The decoder controls include zero error, all 252 single errors, one nonzero
stabilizer, one known logical operator and twelve fixed two-error patterns:
267 cases per representative, 534 in total. Twenty selected outcomes per
representative also match direct Python message equations. These deterministic
controls establish compatibility and correct logical/stabilizer scoring;
they are not independent channel samples or performance estimates.

[Frozen protocol](DEGREE-PRESERVING-PROTOCOL.md) ·
[Source/input selection](search/degree-preserving-selection.json) ·
[Matrices, support sets, paths and all translated candidates](search/degree-preserving-results.json) ·
[Independent checks](degree-preserving-checks.log) ·
[Run log](degree-preserving-run.log) ·
[Verification manifest](degree-preserving-verification.json).

The preceding representation/deletion study was pushed at commit 8cf355c.
This subsequent degree/girth-preserving feasibility study is local. It adds
no completed inventory target and no new Lean declaration.
