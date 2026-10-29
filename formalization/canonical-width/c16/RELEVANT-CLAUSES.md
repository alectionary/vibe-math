# Relevant short obstruction clauses: two-hour continuation

Canonical target: `L-F91-c16-unrestricted-width`; source issue8 is read-only.
Session/work branch: `c16-relevant-20261029T1807` /
`research/c16-relevant-20261029T1807`.
Baseline: `dc04b0c0b395be8066eb2b45bbd866f4011851f7`.
Started 2026-10-29T18:07:49Z. First decision gate: 18:52:49Z.
Overall deadline: 20:07:49Z. This is the user's approved two-hour follow-up.

The source question remains whether the fixed C16 code has unrestricted width
16 or18. The sufficient selected-pair cover has409 cases; the best physical
partial frame has88/128 pairs; zero full source anchors are solved. The preceding
complete sparse quotient criterion has19 checked local gains over order2 and
joint mandatory propagation, but its generated patterns hit no visited matching
in the prior hard-case trials.

Answer contract: actual hard anchor (416,515), class (26,32,3) -> smaller verified
source obstruction clauses relevant to its saved partial matchings -> a frozen
matched seeded-versus-baseline comparison with independent source/CNF replay
and, for any cover removal, ordinary static proof plus cover-domain induction.
A larger clause count alone does not answer the bounded practical question.
The original question still needs a physical128-pair frame or complete global
nonexistence proof.

Budget and stopping rule:

1. By18:52:49Z, search the1688 shared saved partial matchings, shrink any source
   obstruction by deleting required vectors and rechecking the complete order3
   criterion, independently verify certificates, and reject patterns already
   syntactically subsumed by the baseline's initial CNF. Use the preceding
   `matched-order-2.json` (the longest checked prefix) as the fixed baseline seed
   bank. Relevant clauses must occur on actual saved matchings. Do not equate a
   syntactic non-subsumption check with a proof of logical independence.
2. Stop discovery early if this gate yields no smaller verified relevant clauses
   adding a non-subsumed pattern. Otherwise freeze two matched1200-second calls,
   sequentially, with identical mechanisms and initial clauses except for the
   new seed bank. Reserve at most45 minutes for this comparison.
3. Reserve the final30 minutes for independent replay, any bounded ordinary
   proof regeneration and cover composition, reporting and publication. Do not
   accept an unchecked solver answer as a proof. Stop within the overall budget.

The source-pool obstruction and complete sparse discovery argument are inherited
from THREE-TERM-CONTINUATION.md. Removing a required vector can change its
certificate; every successful deletion must be rechecked. Greedy shrinking is
not a guarantee of globally shortest clauses. All domain assumptions remain
explicit; a universal clause uses the unrestricted physical pools.

No new paper or library is required for this first gate. No new target, paper
screen or Lean completion is planned. Existing source and X-access limits remain.
Publish through PR17 under required review; no auto-merge, issue messages,
schedules or sub-agents. Acquire a fresh create-only remote claim before research,
and release only its expected owner SHA when the block ends.

Before either matched solver trial, cap its additional seed bank at256 cores.
Select the first accepted cores in increasing cardinality and canonical-orbit
order that strictly shrink their recorded starting set. Independently replay all
final mined certificates and clause-subsumption checks, and replay every single
remaining deletion for these selected comparison cores. This cap bounds proof
replay and initial-input growth within the two-hour budget. The selection uses
no solver-trial outcome. The precise minimality claim is single-deletion
irreducibility for the order3 criterion, not inclusion minimality for arbitrary
nonexistence or a globally shortest clause.

## Source-clause gate

The gate completed before its45-minute endpoint. It processed all1,688 shared
hard-case matchings in400.63 seconds, making65,925 exact sparse queries with
97,464 cache hits. Starting sets were the selected vectors in each sector and
the associated saved propagation cores. A bounded one-deletion neighborhood
was available when these starting sets gave no certificate. This was not an
enumeration of full frames or of every source subset.

The miner found6,921 distinct required-set orbits under the checked cyclic and
sector symmetries. All final source certificates independently replayed. Of
these,6,576 passed the sequential syntactic-subsumption filter. This is not a
claim that all retained clauses are logically independent, globally minimal,
or pairwise irredundant after every later addition.

The frozen comparison uses only256 of these orbits: one two-vector pattern and
255 three-vector patterns. Their recorded starting sets had four to ten vectors.
All256 strictly shrink their starting set. Independent complete-predicate replay
checks all767 single-vector deletions and finds none still rejected by the
order3 criterion. Among the256 certificates,20 have detecting support1,115
have support2 and121 have support3. Of the selected patterns,120 are strictly
missed by the complete order2 criterion; one of the support3 certificates also
has a different order2 witness. Thus the gain must not all be attributed to
raising the order from two to three.

The independent gate reconstructed every physical source matching, every final
certificate, the exact cyclic/sector clause expansions, and the sequential
subsumption decisions. It used808 independent complete-predicate queries for
the selected cores and their single deletions, in addition to the direct
certificate checks. The full gate replay took162.60 seconds. See
`relevant-results/independent-gate.json`.

### A two-vector restriction

Using zero-based indices in the original source pools, let
J = {z_411,z_507} and
w = 0x408249940900c810012008201100100.
The complete set of X-pool vectors orthogonal to J and pairing to1 with w is
{x_325,x_425,x_709}. The independently checked quotient computation proves that
w + span(J) has no representation using at most three Z-pool vectors.

Suppose a full source dual frame contained both required Z vectors. Expand w
in its Z basis and pass to the quotient by span(J). At least four outside-J
basis terms would be required. Their four corresponding X basis vectors would
all have to belong to the three-element detecting set, a contradiction.
Therefore no full source dual frame contains both z_411 and z_507.

Checked cyclic symmetry translates this to every pair
{z_(400+h),z_(496+h)}, h=0,...,15. Checked sector exchange gives the same
restriction on the X side. This excludes simultaneous use within a dual frame;
it does not assert that the two vectors cannot extend to a one-sided source
basis. The certificate was shrunk from {411,501,507,515,517}, associated with
saved hard-case record486. Neither single-vector requirement is rejected by
the complete order3 criterion.

### Frozen practical comparison

The additional256 patterns reject898 of the1,688 saved partial matchings before
propagation. These matchings supplied the candidate clauses, so this is
retrospective training-cohort coverage, not a holdout success rate or a measured
reduction in the remaining global search space.

The baseline has7,845 variables and136,063 clauses, exactly the final checked
CNF of the preceding longest trial. Adding all applicable instances of the
selected patterns introduces2,896 unique clauses and leaves the variable count
unchanged. The strengthened initial input has138,959 clauses. Some introduced
clauses are already syntactically subsumed;2,620 newly uncovered clauses were
counted at the selected cores' acceptance steps in the larger mining order.
That latter count is not an irredundant-clause count for the final256-core bank.

Both calls use the same existing dynamic propagation and fundamental-row word
separator (`sparse-order0`). The sole model change is the initial source-clause
bank. The calls are sequential, baseline first, each with a1,200-second discovery
limit and a10,000-round ceiling. Their input hashes, source hashes, commands and
budgets were frozen before either call in `relevant-results/comparison-frozen.json`.
The comparison starts at2026-10-29T18:31:31Z, leaving time for proof replay and
publication inside the approved overall deadline.
