# Relevant small source clauses and a408-case sufficient cover

The verified sufficient cover shrinks409 to408. A frozen bank of256 source
patterns uses only two or three required vectors. In the matched comparison,
seeded discovery takes about92 seconds versus175 for baseline; both methods
solve the same compact case. The original width16/18 question remains open.

Canonical target: `L-F91-c16-unrestricted-width`; source issue8 is read-only.
Session/work branch: `c16-relevant-20261029T1807` /
`research/c16-relevant-20261029T1807`.
Baseline: `dc04b0c0b395be8066eb2b45bbd866f4011851f7`.
Started 2026-10-29T18:07:49Z. First decision gate: 18:52:49Z.
Overall deadline: 20:07:49Z. This is the user's approved two-hour follow-up.

At the start of this block, the source question remained whether the fixed C16
code has unrestricted width16 or18 and the sufficient cover had409 cases. The best physical
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

A post-comparison diagnostic, without changing the frozen bank, replayed both
existing propagation methods on each selected required subset. **All256 are
accepted by unrestricted propagation and by propagation on the exact110-class
pair domain.** The new small source restrictions therefore add information
missed by both propagation checks on those subsets. This does not say that
propagation accepts the larger saved matchings: it rejected those earlier,
using additional requirements. The diagnostic checked1,620 physical forced-coloop
covectors and is saved in `relevant-results/propagation-overlap.json`.

## Solver outcomes and cost accounting

Both frozen calls report UNSAT for the same compact cover case. The baseline
used174.86 seconds and528 partial-match refinements; the seeded call used91.56
seconds and267 refinements. The seeded call added527 dynamic cuts, versus1,039
for baseline. These are single-instance observations, not a general performance
estimate. Both calls finish well before the1,200-second limit.

The baseline also reaches UNSAT, so the cover removal cannot be attributed
solely to the new bank. The additional clauses improve this measured discovery
run; they are not necessary to obtain a contradiction from the retained
baseline after further refinement. Mining and the first independent gate replay
took roughly563 seconds together, exceeding the approximately83 seconds saved
in this one solver comparison. No net end-to-end speedup is established for a
single case. Reuse of the source-valid bank across other cases is plausible but
needs a separate fixed-bank comparison.

Fresh ordinary CaDiCaL proofs were generated for both final CNFs. The seeded
proof is259,758,654 uncompressed bytes (53,267,589 gzip bytes); the baseline
proof is396,419,797 uncompressed bytes (79,439,475 gzip bytes). The frozen
solver results remain distinct from the independent source/CNF/DRAT receipts.
The cover count changes only after the checks and cover-domain induction below pass.

## Verified cover and remaining gap

Both source/CNF/ordinary-DRAT replays pass from clean detached revision
`1d7648b`; each rejects an empty proof. The seeded leaf checks22,387 source cuts
and267 physical partial records, while the baseline leaf checks22,643 source
cuts and528 records. The exact initial prefixes and the additional negative
clauses are checked too. The fresh source gate from clean revision `ee2aa2d`
reproduces the canonical results and the byte-identical selected bank.

The independently checked domain-inclusion induction removes selected-pair
class (26,32,3) from the prior sufficient cover: **409 -> 408**. The new avoidance
domain is exactly the110-class domain used by the proof. The cover manifest
uses the seeded proof; the separately checked baseline proof is an alternative
proof for the same removal. The complete previous cover archive and its earlier
clean replays remain unchanged. This block adds the new leaf and checks the
cover induction; it does not claim to rerun the entire older archive.

The original source question remains **width16 or18**. The best checked physical
partial frame is still88/128 pairs and zero full source anchors are solved.
A sufficient-cover removal does not say that the removed pair class cannot
appear in any full frame. No new Lean completion is claimed.

| Requirement | Evidence | Limit |
|---|---|---|
| Relevant smaller source clauses |256 checked patterns from the actual1688-model cohort |Training-cohort coverage; not a search-space fraction |
| Strength beyond existing methods |All256 pass both propagation checks;120 also pass complete order2 |Local required subsets, not completed source anchors |
| Controlled practical comparison |Identical mechanisms; only initial clauses differ; both outcomes have ordinary proofs |One case, baseline also solves, preprocessing cost not recovered |
| Cover reduction |Clean seeded source/CNF/DRAT proof plus exact avoidance-domain inclusion |408 remaining sufficient starting cases |
| Reproducibility |Frozen inputs, all candidates and outcomes, clean replays, hashes |Older proof archive inherited unchanged |
| Inventory |Same canonical target; reports and lessons reconciled |No new papers, source targets or Lean completions |
| Publication |Existing PR17 and preserved work branch |Master integration requires review |

The next bounded target should test reuse of the **unchanged**256-core source
bank on a small frozen set of other cover cases. Choose those cases before
running either variant. A new cover avoidance domain can be wider, so existing
conditional propagation cuts must be independently revalidated or omitted;
the new source-only clauses themselves are universal. This tests whether the
initial mining investment has value beyond its training case. Repeated proof
progress or a consistent measured benefit would justify enlarging the bank.
A complete full-source anchor obstruction or a physical128-pair frame remains
the decisive milestone for the original problem. No finishing-time bound is
inferred from this one comparison.

The block uses no new paper or math-library theorem. The shared inventory
remains424 canonical entries,160 eligible targets,204 paper records,165
full-text screens and six completed Lean targets. Existing literature and
access limitations, including unperformed authenticated X coverage, remain
recorded. Exactly two frozen discovery calls were made; subsequent solver calls
only regenerated ordinary proofs of their fixed final CNFs.

## Independent reproduction

From `formalization/canonical-width/c16`, use the Python environment and ordinary
DRAT checker recorded in the manifests. Create a fresh output directory; the
following commands preserve the canonical receipts:

```sh
mkdir -p /tmp/c16-relevant-fresh
python verify_relevant_sparse_clauses.py --directory relevant-results --output /tmp/c16-relevant-fresh/gate.json --max-seeds 256
python replay_relevant_comparison.py --output-directory /tmp/c16-relevant-fresh/proofs --drat-trim /path/to/drat-trim
python verify_strategy_cover_union.py --cover relevant-results/cover-408.json --output /tmp/c16-relevant-fresh/cover.json
```

The independent gate and proof consumers do not invoke the native discovery
oracle. Both new ordinary proof archives are checked in as `.drat.gz` files;
no hydration step is needed for these two leaves. Older split proof archives
retain their existing hydration instructions if the full ancestor chain is
replayed. The publication record separately verifies the uploaded artifact
hashes and records the required-review state.
