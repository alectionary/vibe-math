# C16 takeover for an expert council — 31 October 2026

## Target and current answer

Determine the unrestricted canonical frame width
`f(C^LP_(16,9))`, known here to lie in **{16,18}**. Canonical identifier:
`L-F91-c16-unrestricted-width`. Source: Jong Yeon Lee,
arXiv:2610.06820v1, Proposition 9, Section IV.4, equation (50),
Appendices C.3 and D.1.1. This is a continuation of
[issue 8](https://github.com/alectionary/vibe-math/issues/8), not a new question.

The equivalent finite question is whether the complete 720-vector X and Z
pools contain 128 dual pairs. In logical coordinates over F2, find an invertible
128-by-128 matrix U with columns in the X pool such that U^(-T) has columns in
the Z pool. The physical operators, not just an abstract matrix analogy, must
meet the source's weight and syndrome conditions.

| Quantity | Verified status |
|---|---|
| Original width | 16 or 18, unresolved |
| Best verified physical partial frame | 88 of 128 pairs; not proved optimal |
| Sufficient selected-pair cover | 405 cases |
| Complete source anchors excluded | 0 |
| Latest exact global necessary-model point | Point 22; remains feasible |
| Shared phase-I master | Built and checked; exact optimum/membership not obtained |
| Latest exact projected inequality | Valid but nonseparating, gap about -12,146.42 |
| Lean completion of this source question | None |

The **405-case cover is sufficient**, not a list of 405 independently excluded
or feasible source cases. Removing a class from the sufficient cover does not
forbid that class from every frame. Local allocation obstructions also do not
exclude a complete source anchor.

## What would conclusively answer the question

- **Width 16:** a full 128-pair physical frame, with all representatives of
  weight 16, zero syndromes against independently reconstructed checks, and
  cross-Gram identity. Together with the established distance lower bound,
  this determines the width. Independently check every returned witness.
- **Width 18:** a complete nonexistence argument for the full weight-at-most-17
  source domain, retaining the pool-completeness and mixed-Pauli reduction and
  every symmetry/cover bridge. A complete certified obstruction over a proved
  sufficient cover can suffice; a timeout or restricted case cannot.

A positive exact phase-I optimum for a finite column archive alone does not
rule out missing full-domain columns. A zero-error master mixture alone does
not construct a physical frame: unanchored mutual X/Z pairing remains relaxed.
A separating inequality against one fractional point is useful progress, but
still does not settle the original source question.

## Read these first

1. [Independent enumeration](INDEPENDENT-ENUMERATION.md): the complete pools,
   lower bound, both-sector transfer and mixed-Pauli bridge.
2. [Latest shared-master result](SHARED-MASTER-TWO-HOURS-RESULT.md): exact
   evidence, failed bounded runs, and what the negative projection means.
3. [Earlier two-basis result](TWO-BASIS-EIGHT-HOURS-FINAL.md): point 22,
   conditional laws, shared owner constraints and remaining coupling gaps.
4. [Reproduction and machine recovery](COUNCIL-REPRODUCIBILITY.md).
5. The lane-specific notes below, followed by their linked consumers and receipts.

Scientific publication checkpoint: `e264f4775a73365ebdb5d73f502a518d02de3540`.
The five-stage isolated replay used the earlier scientific checkpoint
`3129963fcac399fe3422429aeed7247dbc2c9dd1`. These are distinct checkpoints;
the final publication additionally preserves the replay outputs and reports.

## Established work and limits

**Source domain.** The independent enumerator processed all 68 roots and
47,708,679 nodes. Its written completeness argument and finite checks establish
the 720 representatives per sector through weight 17. The minimum nontrivial
X/Z support union is 26, supporting the mixed-to-pure reduction.
This is reproducible finite computation and a written argument, not Lean.

**Global relaxation.** Point 22 passes seven screens, including 54 partner,
990 integer-form and 308 rank rows, older families and complete Boolean triples.
Its saved exact witness is
`coupling-results/two-basis-integer-witness22-rational.json.gz`, SHA-256
`4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f`.
Separately feasible conditional laws do not establish one compatible global
frame. Orbit 40's physical basis law and the orbit 15 improvement have their
stated local scope; see the two-basis report.

**Shared master.** One immutable model contains 1,642 physical basis columns,
70,235 variables and 169,657 rows. It retains all 32 sector/pattern domains,
including blocks with zero mass in the saved seed, and removes the five
higher-moment pins. Its exact artificial feasible start is not membership.
Two capped SoPlex attempts supplied no exact endpoint; a subsequent HiGHS
candidate supplied numerical suggestions, not an optimality certificate.

**Executed projection.** Source-proved bounds cover all 22,508 non-tau parent
variables; all five higher-moment residuals are retained. All 32 full physical
prices and the tiny exact quadratic-minorant LP passed independent acceptance.
The final inequality has negative target gap and 109-bit primitive coefficients.
It excludes no current point or source case and was not inserted into the
signed-64-bit row bank. This is the best minorant for that fixed corrected
pattern-cost vector, not an impossibility result for other source combinations
or stronger joint residual bounds.

**Next optimizer initialization.** The [dual-start note](SHARED-MASTER-DUAL-START.md)
proves a unimodular, exactly dual-feasible starting basis with lower bound zero.
Its basic primal is generally infeasible. Two algebra reviews agreed, but no
solver run has used this basis and no speedup is established.

## Historical traps to avoid

- Older issue sections and `INVESTIGATION.md` predate independent pool
  enumeration. Their statements that it was missing are superseded by
  `INDEPENDENT-ENUMERATION.md`.
- The old three-partner monomial domains were incomplete when monomials were
  omitted. [TAKEOVER.md](TAKEOVER.md) explains the repair. The old exclusions
  of 33 twelve-monomial orbits were unsupported; do not resume those logs as
  certified full-domain work. Corrected 13-or-more monomial exclusions have
  their own coverage records.
- Aggregate residue descent was refuted for enlarged pools, even with relevant
  module properties retained. Such enlarged-pool frames are not source frames.
  Exact thick scalar representatives still matter. A common-matroid-base
  theorem alone omits the inverse/cross-Gram requirement.
- Numerical objective 64.93, finite-vector availability flags, negative
  provisional column costs and incomplete bases are not certificates. The first
  SoPlex `.bas` is incomplete; the old HiGHS runners have expired deadlines.
- Keep fixed-law pins, zero-face reductions, selected allocations and actual
  global source hypotheses distinct. Preserve failed attempts and exact input
  hashes. Version any new consumer rather than editing frozen science.

## Proposed expert council

These are review lanes, not a claim that new research has started. The council
should independently assess alternatives before adopting the last optimizer plan.

| Lane | Start from | Concrete useful output |
|---|---|---|
| Source algebra and matrix inversion | [INVERSION.md](INVERSION.md), [INVERSE-FOUR-HOURS.md](INVERSE-FOUR-HOURS.md) | A necessary condition retaining exact source scalar data, or an explicit counterexample to a proposed condition; test against saved enlarged-pool counterexamples |
| Joint compatibility and polyhedral reasoning | [Fixed-neighbor rank](OWNER-FLOW-FIXED-NEIGHBOR-RANK.md), [conditional pair law](OWNER-K22-CONDITIONAL-PAIR-LAW.md), two-basis report | Identify one missing joint condition and establish whether it excludes point 22, merely its chosen allocation, or neither |
| Optimization and exact certificates | [Dual start](SHARED-MASTER-DUAL-START.md), [solver diagnosis](SHARED-MASTER-SOLVER-DIAGNOSIS.md) | Check an exported basis; one freshly bounded dual-simplex trial on the unchanged master; exact endpoint or full-domain source-valid projection acceptance |
| Construction or global obstruction | [Finite models](FINITE-MODELS.md), [transfer report](TRANSFER-FOUR-HOURS.md), [cover 405](transfer-results/cover-405.json) | A physically verified frame, or a certified full source-case obstruction with explicit coverage |
| Independent skeptic | Source bridges, independent consumers and replay inventories | Challenge quantifiers, omitted domains, signs, arithmetic and the claimed consequence for the original question |

For the initial council round, ask each expert for: the precise claim they would
try to prove/refute; the missing lemma; the existing evidence against the idea;
one discriminating bounded test; its acceptance criterion and stop rule. Then
have the skeptic compare the proposals. Do not equate agreement among agents
with mathematical evidence. A shared coordinator should own the canonical
claim and integrate changes; experts can read in parallel with explicit,
nonoverlapping write responsibilities.

No new literature search was performed for this documentation handoff. Existing
source/access records remain in [the literature note](LITERATURE-TECHNIQUES.md)
and the canonical `literature/` and `planning/` ledgers. A future search should
start from a precise missing theorem, compare full hypotheses, and preserve
the prior paper screens rather than repeat generic keyword searches.

## Coordination and takeover state

The October 31 work only prepares this handoff and checks artifact integrity.
It does not launch the council, reserve a new research block, or run a solver.
The prior claim `refs/heads/claims/L-F91-c16-unrestricted-width` was released;
remote absence was checked again during handoff. Before new research, a new
coordinator should read the repository research skill, inspect current issue
and claim state, and obtain a fresh create-only claim for the authorized scope.
Do not reuse the prior ownership lease.

Use `research/c16-shared-master-20261030T2207`; the same handoff is published to
PR17's head `research/c16-structural-20261027T173245`. The issue gives the exact
handoff commit. Master remains `e89a439b057e9d5e76abc6af66f7b978471af3c6` at this
check, with one approving review required and no recorded approval. The handoff
is branch delivery, as requested; it does not bypass review or imply a merge.

The user prefers lower-priority computation; previous scientific runs used
niceness 19 and one thread per numeric runtime. The earlier temporary Mac
resource restriction was lifted. Future
experiments still need a fresh explicit bounded contract; old runtime caps are
historical, not an active authorization or an end-to-end time estimate.
