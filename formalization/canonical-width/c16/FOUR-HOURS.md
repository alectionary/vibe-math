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
