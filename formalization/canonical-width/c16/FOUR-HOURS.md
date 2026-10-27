# Four-hour C16 continuation

- Canonical target: `L-F91-c16-unrestricted-width`; follow-up to issues #3/#8.
- Session: `codex-c16-20261027T012636Z`.
- Start: 2026-10-27T01:26:36Z. Deadline: 2026-10-27T05:26:36Z (2026-10-26 22:26:36 America/Los_Angeles).
- User instruction: continue this research objective for the next four hours.
- Work branch: `research/c16-four-hours-20261027T012636`.
- Prior checkpoint: `497cdca46340d1e98034daa6d21866526983ffb8`.
- Answer contract: determine unrestricted f(C^LP_16,9), including mixed Paulis, by a physically checked 128-pair weight-16 frame plus the distance lower bound, or a complete justified obstruction. Any use of the published 720-class pools retains the source-completeness premise until independently reimplemented.
- Prior results: physical pool mapping and width-18 upper frame checked; corrected complete partner domains exclude listed-pool frames containing at least 13 seed-4 X monomials. Best weight-16 partial frame is 88 pairs. Exact f, twelve-and-fewer monomial cases, independent pool completeness and Lean remain open.
- Scope: complete corrected twelve-monomial searches while pursuing a global compatibility/SAT route and structural obstructions. No other codes. Reserve closing time for verification and an honest handoff.
- Claim: create-only remote reference at this ownership commit, after confirming absence.

## Intermediate checkpoint, 2026-10-27T02:39Z

Independent physical pool completeness is now reproduced: all 68 roots through weight 17, 47,708,679 nodes, exactly 45 normalized weight-16 orbits. The sector exchange and mixed-Pauli bridge are checked separately. See `INDEPENDENT-ENUMERATION.md`; this removes dependence on the author's search implementation, but is not a Lean certificate.

The twelve-monomial replay is continuing with complete corrected partner domains, a stronger prefix-rank bound, and mandatory-basis-member propagation. Completed classes have no caps. A 720-variable global CDCL model now learns directly certified binary-matroid and opposite-pool rank clauses; positive and negative toy controls pass. The global runs have not yet decided the question. Alternating full-basis construction reached Gram energy 176 (128 would be a full canonical frame), and did not improve the checked 88-pair partial frame. These are bounded experiments, not exclusions.

## Intermediate checkpoint, 2026-10-27T03:24Z

The corrected twelve-monomial replay is near completion, with no capped cases so far. One full eleven-monomial class (omitted mask4677) is excluded over all83,980,800 partner assignments,267,742 full quotient cases. An optional exact-monomial-count mode reduces its full quotient count to206,517; that narrower mode is useful only with the separately proved exclusion of larger counts.

The full-pool backtracker is being tested alongside global SAT models, including a two-sector rank oracle. A capped root traversal now exports22,939 unvisited partitions; a bounded parallel campaign resolves tasks while preserving all unresolved descendants. No global decision has yet been obtained. The checkpoint mechanism has exhaustive small controls, and selected source tasks have independent Python replays. Remaining time is reserved for these complete-domain searches, validation and closeout at05:26:36UTC.

## Completed twelve-monomial replay, 2026-10-27T03:29Z

All116 cyclic classes are excluded over the complete corrected partner domains. The run covers54,411,742,864 Cartesian partner assignments, reaches16,203,129 full quotient calls after necessary prefix pruning, and visits115,977,493 quotient nodes, with zero caps. The call count depends on the two recorded prefix engines; it is not a classification count of every assignment whose final quotient alone has full rank. Frozen per-class logs and source provenance are in `four-hours-results/twelve/manifest.json`; `verify_four_hours.py` validates them.

Thus every width16 CSS frame in the complete pools uses at most11 seed4 X monomials. One eleven-monomial class (mask4677) is also excluded, but the other272 classes remain unresolved. The unrestricted width remains16 or18. The continuing global campaigns do not receive an UNSAT label unless all required cases are discharged.

## Final outcome and timing

The exact unrestricted width is still16 or18. No128-pair weight16 witness or complete global obstruction was found. The best independently checked partial frame remains88 pairs. No Lean certificate was produced, and no complete canonical source target is counted.

The global checkpoint archive preserves86,583 registered tasks:65,950 closed,75 expanded and20,558 unresolved. Including its root traversal, it records669,402,203 search nodes. This is an incomplete global search, not an UNSAT certificate. `verify_frontier_archive.py` validates the task tree, hashes and complete preservation of unresolved leaves. A separate100-million-node run also reached its cap. All global SAT formulations, including the compact128-selection model and both-sector rank observers, ended without a decision. Synthetic SAT/UNSAT controls are distinguished from code-instance results in `four-hours-results/experiments/solver-runs.json`.

A related support-rank route was tested: commuting outer products span the16,383-dimensional trace-zero matrix space, leaving only scalar identity endomorphisms in the binary logical factorization. The saved basis is independently checkable. This rules out that narrow deformation route; it does not rule out all weighted support-rank approaches. A six-vector common-pool counterexample also shows that cyclic symmetry plus a symmetric pairing does not generally regularize a dual frame.

**Timing:** the authorized window began2026-10-27T01:26:36Z and ended05:26:36Z. Searches used their recorded node/process limits and the frontier campaign's05:08 cutoff. The pending tool operation returned after the deadline and launched the saved endomorphism calculation before the overrun was noticed. Closeout resumed at07:12:57Z, and validation/publication followed. The handoff is late. This is not a claim of on-time four-hour delivery. No research jobs remain running; no new campaign was launched after discovering the missed deadline.

Two related primary papers were retrieved for preservation after their relevant passages had been consulted. Their candidate questions and incomplete-screen/deadline gaps are explicit in `literature/c16-continuation-source-screening.json`. No zero-question screen or new canonical question is inferred from those incomplete audits. These are follow-up bookkeeping gaps, not reasons to alter the C16 result.

**Question answered:** independently reproduce the complete low-weight physical pools and the mixed-Pauli bridge; exclude every corrected twelve-monomial class, plus the recorded single eleven-monomial class.

**Question still open:** does a complete weight16 canonical frame exist? Equivalently, is the unrestricted width16 or18? Eleven-and-fewer monomial cases remain, aside from the one recorded eleven-monomial class.

**Next proposed target (follow-up):** resume the20,558 saved global frontier leaves, with the verified short rank clauses and compact cardinality model as a complementary route. Export the leaves using `verify_frontier_archive.py ... --export-unresolved ...`; their completed predecessors remain in the archive. No follow-up campaign is started by this closeout.
