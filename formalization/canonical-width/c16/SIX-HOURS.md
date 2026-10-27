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
- Verified ownership SHA: `24fecd7b6937ea867448aafa9907e4af91c690a4`.

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

## Outcome and handoff

**Question answered:** no exact-width answer. The new finite structural result
is a certificate that the complete pairing graph has precisely the 16 common
cyclic shifts as sector-preserving automorphisms, and 32 automorphisms when
sector exchange is allowed. The cardinality and augmentation relaxations admit
128-pair flows; these feasible relaxations are not physical frames.

**Question still open:** whether the complete minimum-weight pools contain 128
dual pairs. Consequently the unrestricted canonical width is still 16 or 18.
The best physically checked partial frame remains 88 pairs. There is no new
Lean certificate, complete global UNSAT certificate, or conclusive time estimate.

**Next proposed target — follow-up:** strengthen the small orbit-flow master
with common phase-shape and private-owner allocation conditions, using the
saved exact SAT models and global frontier as independent comparisons. First
measure whether that stronger necessary model can be decided; do not infer a
global answer from another timeout. This follow-up is proposed, not started
after the experiment cutoff.

The resumed exhaustive campaign stopped with 3,451,122,187 recorded nodes
including the original root: 203,266 registered tasks, 182,682 closed tasks,
204 expanded tasks and 20,380 unresolved leaves. Its original 22,939 root
partitions have only 3,013 directly closed roots and 147 expanded roots. Thus
the larger closed-task count is particularly unsuitable as a completion
percentage. The complete task tree and every unresolved leaf are preserved in
`six-hours-results/frontier/campaign.json.gz`, SHA256
`f159c22f71319706aa6f52d2c7979b775698ae2a9757bb276fcf14b8312c8492`.
`verify_frontier_archive.py` passes and exports all 20,380 unresolved tasks.
The native campaign retains the older, valid but weaker, global monomial cap
of 12; the new SAT models use the already justified cap of 11.

Both static Kissat runs ended `s UNKNOWN`, with exit code 0, under their
10,800-second limits. One used the 5,205,418-clause exact private model, and
the other used its 5,339,152-clause cyclic/sector lexicographic reduction.
Their incomplete 8.3 GB and 4.0 GB proof traces are not UNSAT certificates and
are retained only in scratch storage. The reproducible model inputs, builders,
hashes and complete solver logs are preserved in this branch.

The two callback-free selector runs reached their one-hour limits. Their
complete logs retain 59,339 and 105,635 independently checked base cut records,
respectively; cyclic expansions and overlap mean these are not counts of
distinct global cases. The native-cardinality variant also timed out: its
15,263 logged subspace-rank cuts are independently replayed by the final
checker. It found no improvement to the existing physical partial frame.
Last JSON snapshots can lag their complete flushed cut logs by a few seconds;
the final manifest records the actual log counts separately.

The initial common-shape model returned UNKNOWN at its bounded endpoint. A
smaller model uses only 840 exactly verified integer supporting planes across
186 nonzero block-pattern types, instead of expanding all block tables into
Boolean encodings. Its first flow was rejected by 35 common-shape cuts; the
next master solve reached its 60-second limit. No infeasibility is claimed.
Every one of these 35 cuts and all 1,988,028 production zero/private-owner
profile entries pass an independent literal integer-adjacency check. The
lexicographic encoding passes all 10,920 signed string comparisons through
length six. Results are in `six-hours-results/final/verification.json`.

The symmetry certificate uses two color-refinement rounds to fix every one of
the 90 sector/orbit blocks. Monomial circulant blocks are perfect matchings.
Their constraints connect 84 orbit blocks, and an odd-offset cycle forces the
permutation of their phases to commute with a generator of C16, hence to be a
common translation. Each phase in each of the remaining six blocks has a
different neighborhood into those anchored vertices, so their permutations
are forced too. The literal pairing graph is connected, and sector exchange
is checked, giving the stated 32-element full graph symmetry group. This is
an exact finite certificate plus a written implication argument; it is not
a Lean theorem and does not regularize arbitrary dual frames.

### Timing, access and preservation limits

The user deadline is 13:21:54 UTC. A request to terminate this session's
unproductive native-cardinality experiment required sandbox escalation. The
subsequent clock check was at 12:49:16 UTC, following the request around 08:20;
the process had already exited under its own one-hour bound. Interactive work
was stalled during that approval interval, while the timed background searches
continued. No dependent experiment was launched after that wait. The remaining
frontier was stopped at about 12:50, before the 12:55 experiment cutoff, and
closeout work began within the six-hour allowance.

Issue #8 remains open and unchanged, checked again at closeout. No issue comment,
external announcement or new research target was posted. No X connector is
available in this environment; the earlier locked-browser/authentication gap
remains a coverage limitation. The F99/F100 literature reconciliation is still
incomplete, explicitly recorded in the source-screening ledger; no zero-question
screen or current-resolution assessment is inferred. One bounded product-basis
terminology search produced leads, but supplied no applicable theorem for this
finite-field cyclic setting. No new canonical entries or solved targets are
counted: cohort delta 0 entries, 0 eligible targets, 0 complete Lean targets.

This is an unfinished research handoff on the separate work branch, not a claim
that the canonical question or a final publication is complete. The ownership
claim is released only after the final branch checkpoint is preserved and its
remote commit verified, using the expected ownership SHA recorded above.

The current inventory, planning and source-question-screening validators pass:
353 canonical entries, 150 eligible targets and 6 completed Lean targets remain
unchanged. The legacy bibliography validator initially exposed missing schema
fields in the existing F99/F100 follow-up records. Their empty dissertation
associations and explicit category/evidence/coverage-limit fields were supplied,
and the bibliography report was regenerated. That validator now passes too;
this metadata repair adds no paper, canonical question or completed screen.
