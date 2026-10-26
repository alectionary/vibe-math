# Unrestricted canonical width of \(C^{\mathrm{LP}}_{16,9}\)

Canonical inventory identifier: `L-F91-c16-unrestricted-width`
Note location: `formalization/canonical-width/c16/INVESTIGATION.md`
New problem. Nothing in this repository answers it. The 2026-10-25 harvest recorded the source question only. No earlier proposal, finite search, partial proof, or completed result exists here.

Discovery source and question source are the same paper: Jong Yeon Lee, arXiv:2610.06820v1, 5 October 2026, Proposition 9, Section IV.4; proof Appendix C.3; construction equation (50), Appendix D.1.1. HTML: https://arxiv.org/html/2610.06820v1

## Answer contract

Proposition 9 question → exact value of the unrestricted canonical width \(f(C^{\mathrm{LP}}_{16,9})\) → either

(a) an explicit 128-pair canonical basis with all weights \(\le 16\), zero syndromes, symplectic pairing equal to the identity, and full quotient rank, independently checked and Lean-certified; or

(b) an independently checked proof that no weight-\(\le 16\) canonical basis exists covering a full set of representatives modulo the stabilizer group.

Why it matters: the source leaves a two-point gap for a fixed code that already has \(f_{\mathrm{span}}=16\) and \(f_{\mathrm{reg}}=18\). The exact unrestricted width is the missing invariant.

## Scope

- Session: `lf91-c16-20261026T174815Z-f4663e80`
- UTC start: 2026-10-26T17:47:00Z
- Hard deadline: 2026-10-26T21:47:00Z
- Issue: https://github.com/alectionary/vibe-math/issues/3
- Work branch: `cursor/l-f91-c16-unrestricted-width-1697`
- Claim ref: `refs/heads/claims/L-F91-c16-unrestricted-width` (pending create-only acquisition at this commit)
- Isolated checkout: this cloud agent uses the workspace checkout of the work branch. No second investigator checkout is present.
- Study authorized: yes. The user authorized this research block.
- Project board: not requested.
- Publication authorized: work branch and pull request. No `master` push, paper, or external post.
- Out of scope: \(C_{20,10}\), the 1024-qubit PP family, and frame-design theory.

Intended next action: freeze the source definition of unrestricted canonical width, then search or obstruct a weight-16 canonical frame.

## Issue, claim and Project

- Canonical issue: https://github.com/alectionary/vibe-math/issues/3
- Bounded follow-up ID: none. The whole canonical target is reserved.
- Project: skipped, not requested.
- Claim acquisition: not yet confirmed in this file. The ownership commit is this reservation. The claim ref is created only after this commit is on the server, and only by a create-only reference operation.
