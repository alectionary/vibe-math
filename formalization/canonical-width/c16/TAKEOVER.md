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
- Claim: create-only remote reference pointing at this ownership commit. No prior claim existed at the read-only check.
- User authorized takeover; no additional start permission required.


## Audit finding and repaired exclusions (in progress)

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

The corrected 13-monomial search is running. The prior 13-monomial and
12-monomial claims must currently be read as results on the three-prototype
subfamily, not exhaustive results on the complete pools. In particular, the
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

Verification so far: the 88-pair witness passes; the quotient routine agrees
with independent basis enumeration on 33 positive and 435 negative full-rank
small instances; a synthetic 128-pair example requires and accepts a partner
with an omitted-bit component. A 16-pair CP-SAT positive control also passes
the physical checker. The first compact global 128-pair CP-SAT run returned
UNKNOWN after 300 seconds; no global exclusion follows. A greedy coloring of
all 99,808 candidate pairs used 803 colors and gives no useful width bound.

No exact value of f or Lean certificate has been obtained. No additional
canonical question is introduced. The source/prior-art access accounting is
`takeover-prior-art.json`.
