# Six-hour C16 continuation

- Canonical target: `L-F91-c16-unrestricted-width`, continuing issues #3/#8.
- Session: `codex-c16-20261027T072154Z`.
- Start:2026-10-27T07:21:54Z. Deadline:2026-10-27T13:21:54Z (06:21:54 America/Los_Angeles).
- User authorization: “Please continue for another six hours.”
- Work branch: `research/c16-six-hours-20261027T072154`.
- Prior artifact checkpoint: `9211ad87c41db765d224eebec0385c634f524e35`.
- Answer contract: Lee arXiv:2610.06820v1, Proposition9 / equation50 → determine unrestricted f(C^LP_16,9), including mixed Paulis → a physically checked128-pair weight16 frame, or a complete justified global obstruction giving width18.
- Prior evidence: independently reproduced complete low-weight physical pools,720 representatives per sector; mixed support-union minimum26; checked width18 frame; checked88-pair weight16 partial frame; all116 twelve-monomial classes excluded without caps, hence at most11 seed4 X monomials in a full weight16 frame. Exact width and Lean certificate remain open.
- Saved global search:65,950 closed tasks,75 expanded tasks and20,558 unresolved leaves;669,402,203 recorded nodes including root. These counts are workload, not a completion percentage.
- Scope: resume and strengthen the global search, and test faster certified SAT/model-refinement routes. Do not substitute another monomial count for the unrestricted question.
- Timing discipline: experiment cutoffs no later than12:55Z; reserve the final27 minutes for validation, preservation and release. All future network-dependent operations must have explicit time bounds; recheck the clock before launching dependent work after approval waits.
- Claim: acquire create-only remote `refs/heads/claims/L-F91-c16-unrestricted-width` at this ownership commit after confirming no current owner. No new campaign until server read-back confirms ownership.

## Intermediate checkpoint: new exact and structural routes

No answer to the unrestricted question is claimed at this checkpoint. The best
physical partial frame remains88 pairs, and the width remains16 or18.

`frame_cegar.py` replaces the earlier native SAT callback route by complete
selector models followed by independently checked necessary cuts. A selected
128-set either has all128 private pool partners, or is rejected by an XOR
dependence, a zero/eligible-pool hyperplane, or mandatory-pool propagation.
Every cut is checked by `rank_cut_check.py` before insertion. Cyclic translates
are justified by a checked orthogonal action on the complete pools. Parent
process limits use termination rather than an interrupt inside native callbacks.
An UNSAT response remains `UNSAT_PENDING_CERTIFICATE` until the final static CNF
has an independently checked proof. Production runs are still active.

Positive and negative controls use a synthetic720-vector pool of rank128. The
positive identity frame is recovered. The negative control fixes an independent
X basis whose required duals are absent; one checked cut refutes it. Kissat and
DRAT-trim independently verify the resulting static CNF. These are controls of
the method, not evidence that the C16 instance is unsatisfiable.

`build_cegar_static.py` freezes the cut logs and inserts the necessary cuts on
both sectors of an exact private-neighbor model. The sector exchange is the
orthogonal involution swapping logical coordinate blocks2,3 with4,5; it sends
each X-pool index to the same Z-pool index. The first static snapshot has251662
variables and5205418 clauses, including143390 unique cyclic cut classes before
expansion. It is running under Kissat with a separate proof trace. A timeout is
not an exclusion.

The new orbit models retain the exact16-by16 circulant pairing blocks. For an
X phase subset I, let k0 count opposite vertices with degree zero and u count
X vertices having at least one degree-one opposite neighbor. Exactly the triples
(|I|,n+z0,n), where0<=n<=u and0<=z0<=k0, occur as max-degree-one selected
submatrices: choose n distinct owners and one private neighbor of each, then
z0 zero-degree vertices. `orbit_block_tables.cpp` enumerates these triples.
Affinely equivalent phase labels preserve the cardinality table.

`orbit_flow_relaxation.py` uses these exact pairwise tables with global pair
flow conservation, source-orbit caps and subspace rank bounds. It admits a
128-pair cardinality flow; this is not a physical frame. The stronger
`orbit_shape_relaxation.py` keeps one common phase-subset shape per orbit across
all its opposite blocks. Rotation alone preserves its zero/private-owner
profiles; arbitrary affine relabeling is not used independently on shared
shapes. Relative offsets between distinct orbits are still relaxed.

`orbit_augmentation.py` supplies an additional written necessary identity. Let
A sum the16 positions in each of the eight logical coordinate blocks, and let
J repeat each of eight coordinates16 times. Then AJ=0 over F2. A full dual
frame satisfies sum_i x_i z_i^T=I, hence
sum_i A(x_i) A(z_i)^T=0. Augmentation ignores cyclic phases, so these64 parity
equations apply directly to the orbit-pair flow counts. They do not apply to
an arbitrary partial frame. The augmented cardinality model is being tested.

`test_orbit_relaxations.py` exhausts every block pattern at orders3,4,5 against
literal I,J enumeration, checks all4116 length16 binary necklaces, and compares
3864 production-profile samples with explicit adjacency sets and their shifts.
All controls pass. No production-model infeasibility certificate is claimed.

Frozen controls, structural tables, static-CNF inputs and cut snapshots are in
`six-hours-results/checkpoint-1/`. The old four-hour manifests remain immutable.
The phrase “weight-six checks” in `INDEPENDENT-ENUMERATION.md` was corrected to
“binary checks”; the balanced physical row weights are7,8,9. Enumeration inputs,
source and recorded outputs were unchanged.
