# C16,9 takeover

- Canonical target: `L-F91-c16-unrestricted-width` (follow-up).
- Session: `codex-c16-20261027T000402Z`.
- Start: 2026-10-27T00:04:02Z.
- Issue: https://github.com/alectionary/vibe-math/issues/8 (parent #3).
- Work branch: `research/c16-takeover-20261027`.
- Prior head: `593511c306339f994e7d0dd8cd52708e7e0ce5a9`.
- Scope: audit existing exclusions and pursue a global obstruction or a checked 128-pair weight-16 frame.
- Answer contract: Lee arXiv:2610.06820v1 Proposition 9 asks for unrestricted width, including mixed Pauli representatives. A complete answer needs a physical 128-pair witness plus lower bound, or an exhaustive obstruction with a justified mixed reduction.
- Existing result: checked 88-pair partial CSS frame, conditional mixed reduction, reported exclusions for 13–16 seed-4 monomials; width remains 16 or 18.
- First bounded milestone: audit the forced partner list and quotient search, then test a global algebraic obstruction. Stop this block after a decisive result or a documented assessment of these routes. No expansion to other codes.
- Research claim: create-only `refs/heads/claims/L-F91-c16-unrestricted-width`, acquired at ownership commit `e20b1db521bee1945f7d0bcadc2d3e7551dd7022`. No prior claim existed. Closeout releases only that exact SHA after verifying the pushed checkpoint.
- User authorized takeover; no additional start permission required.
- Research checkpoint: 2026-10-27T00:50:33Z, about 46.5 minutes after the recorded research start. The unrestricted question is not answered; this is a work-branch handoff.


## Audit finding and repaired exclusions

The old search incorrectly treated the three partners with seed-4 block exactly
`e_p` as the complete partner list after omitting monomials. For kept mask K,
the actual condition is `(z_seed4 & K) == e_p`; omitted coordinates are free.
With bit 0 omitted and bit 3 retained, Z indices 263, 547 and 560 are the old
list, but index 576 also qualifies. Its seed-4 block is `0x9`. The physical
weight-16 zero-syndrome witness is in `partner-domain-counterexample.json`.
This refutes the asserted completeness of that domain, not the final width.

`seed4_exact.cpp` constructs the complete domains directly from all 720 Z
vectors. A partial partner choice can be discarded as soon as the rank of the
surviving X pool is below `128-m`: adding more partners only removes X vectors.
Every discarded prefix accounts for the product of its remaining domain sizes.
For a full-rank leaf, the existing quotient search checks all complementary
pairs. The saved domain lists and total coverage are independently checked by
`replay_seed4.py`.

Repaired exact finite computations:

| Kept monomials | Rotation orbits | Complete-domain assignments | Full-rank quotients | Outcome |
|---|---:|---:|---:|---|
| 15 | 1 | 70,858,800 | 9 | All dead |
| 14 | 8 | 1,117,382,040 | 6,897 | All dead |
| 13 | 35 | 9,340,813,224 | 449,904 | All dead |

The corrected 13-monomial search is complete: all 35 classes exhaust, with
no capped trees or frames. This repairs the prior 13-monomial exclusion. The
old 12-monomial claims still concern only the three-prototype subfamily. In particular, the
claimed exclusions of 33 twelve-monomial orbits are unsupported by those logs.
The complete 12-monomial domains contain 54,411,742,864 assignments across 116
rotation classes, rather than 61,647,156. Rank pruning can avoid enumerating
many leaves, so this is a domain-size correction, not a runtime estimate.

`audit_pools.py` reconstructs the checks independently from equation (50),
verifies a physical 128-pair width-18 frame, checks all listed weight-16 pool
operators and every physical pairing against the saved coordinates, and
recomputes the minimum X/Z support union 26. It uses copied source data and
local arithmetic, with no import from Lee's implementation. It does not prove
pool completeness. The conditional mixed reduction and distance lower bound
retain their earlier enumerator dependence.

Verification: the 88-pair witness passes; the quotient routine agrees
with independent basis enumeration on 33 positive and 435 negative full-rank
small instances; a synthetic 128-pair example requires and accepts a partner
with an omitted-bit component. A 16-pair CP-SAT positive control also passes
the physical checker. The first compact global 128-pair CP-SAT run returned
UNKNOWN after 300 seconds; no global exclusion follows. A greedy coloring of
all 99,808 candidate pairs used 803 colors and gives no useful width bound.

No exact value of f or Lean certificate has been obtained. No additional
canonical question is introduced. The source/prior-art access accounting is
`takeover-prior-art.json`.


## Why the corrected search is exhaustive in a prescribed monomial case

Let M be the span of m retained seed-4 X monomials. A partner for bit p must
restrict to e_p on the retained positions; this is exactly the new domain test.
Choosing one partner per retained bit gives a Z-space W of dimension m, since
the Gram matrix between M and those partners is I_m. The remaining X basis
must lie in W-perp and the remaining Z basis in M-perp. Both spaces have
dimension 128-m, and their pairing is nondegenerate: W intersects M-perp only
in zero. Thus their surviving pool vectors must span those whole spaces.
Adding a partner can only shrink the surviving X pool. If its rank is already
less than 128-m, every assignment extending that prefix is impossible. The
product of the as-yet-unassigned domain sizes counts exactly the skipped leaves.

At a full-rank leaf, the quotient routine maintains pairwise cross-orthogonality
against all chosen pairs. Its rank check requires chosen vectors together with
survivors to span the target on both sides. Any completion must use a survivor
carrying any coordinate that is nonzero on the survivor span. Branching over
every such X vector for the rarest coordinate, and every surviving Z partner
anticommuting with it, therefore covers every completion. Removing cross-
anticommuting vectors cannot remove a member of a completion of that pair.
These are written soundness/completeness arguments, backed by small exhaustive
regression comparisons; they are not a Lean certificate.

The physical translation rotates all eight logical-coordinate blocks together,
preserves the pool and dot product, and carries retained-bit sets to their cyclic
rotates. The mask lists are the minimum integer representatives under all 16
rotations, computed directly from all subsets of the required size. No assumption
of a regular or cyclic frame is made. Excluding frames containing m prescribed
monomials also excludes any frame containing more than m of them, since any
m-member subset would have been covered.

## Global routes tested

The direct CP-SAT model uses 720 X-selection and 720 Z-selection variables.
Exactly 128 of each are selected, and every selected vertex has exactly one
anticommuting selected neighbor. This is equivalent to a 128-by-128 permutation
submatrix of the pairing matrix, hence to a CSS canonical frame in the listed
pools. Full-rank domination constraints, coordinate-subspace rank cuts and small
linear-dependency circuit cuts are redundant necessary conditions. A checked
monomial exclusion can also bound how many of its monomials a full frame uses.
Two 300-second runs returned UNKNOWN, including a run with the repaired
14-monomial exclusion. A separate 300-second optimization run accepted the
88-pair hint but kept best value 88 and upper bound 128. It did not prove 88
optimal. Returned candidate pairings are checked independently of the solver's
constraints before output.

A full 128-by-128 outer-product span test, using every anticommuting pool pair,
has rank 16,384, the entire matrix space. In particular I_128 is in that span.
Consequently a linear functional vanishing on each individually allowed pair's
outer product cannot separate I_128. This rules out that proposed linear
obstruction, not a frame: the mutual compatibility of selected pairs is absent
from the span relaxation. Greedy coloring similarly produced 803 colors, above
the 128 needed for an exclusion. These failed routes are saved so they need not
be rediscovered as untried ideas.


## Twelve-monomial probe

A bounded corrected-domain probe used omitted bits {0,3,8,11} (mask 2313),
whose full domain has 94,478,400 assignments. It was stopped by an outer
180-second process limit, with three quotient trees at the 200,000-node cap
and no frame found. It did not finish the orbit and excludes no whole orbit.
The logs and actual partner-index assignments are saved in
`takeover-results/twelve-probe.json` and adjacent files. The old type-digit
batch interface cannot represent all these corrected partners.

## Reproduce and interpret the result

```sh
python3 formalization/canonical-width/c16/verify_takeover.py
clang++ -O3 -std=c++17 formalization/canonical-width/c16/seed4_exact.cpp -o /tmp/seed4_exact
python3 formalization/canonical-width/c16/replay_seed4.py --binary /tmp/seed4_exact --omitted 3 --cap 1000000 --workers 4 --output /tmp/c16-replay13
clang++ -O3 -std=c++17 formalization/canonical-width/c16/search/test_quotient.cpp -o /tmp/test_quotient
/tmp/test_quotient
```

The combined verifier checks saved domains, coverage totals and hashes; the
replay command reruns the complete finite search. No timing estimate for the
full twelve-monomial case is inferred from the incomplete old domains. The
unrestricted source question remains open in this work. Physical low-weight
exclusions still use the source's pool-completeness premise; its enumeration
has not been independently reimplemented here. A physical 128-pair witness would independently prove
f <= 16; equality would additionally require the distance lower bound.

**Question answered:** corrected partner-domain completeness and the exact
listed-pool exclusions for frames containing at least 13 seed-4 X monomials.

**Question still open:** the unrestricted width, complete twelve-and-fewer
monomial cases, independent pool completeness, and Lean certification.

**Next proposed target (follow-up):** decide the complete twelve-monomial case
or derive a compatibility obstruction covering the whole 720-by-720 pool.
