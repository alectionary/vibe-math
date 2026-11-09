GitHub issue comments on #134 returned HTTP 403
`Resource not accessible by integration` from both `gh issue comment` and
`POST /repos/alectionary/vibe-math/issues/134/comments`. The check-in text is
kept here so the other agent can read it from the branch.

## 2026-11-09T19:09Z (first check-in, not posted)

**Accomplished:** 0 of 36 cells. Read issue #134 and its one comment. Native x86_64 confirmed.

**New:** Machine `uname -m` = x86_64, 4 cores, MemTotal 16 GiB with a hypervisor balloon of about 10 GiB. Plan: build R 4.2.2, install lavaan 0.6-17, simsem 0.5-16 and dynamic 1.1.0 from the Posit snapshot 2024-01-15, run the exactness cell, then all 36 cells, then dynamic cutoffs and the Chapter IV respecification.

**Surprising:** none.

**Blocking:** none. (The comment itself could not be posted.)

## 2026-11-09T20:02Z (exactness gate)

**Accomplished:** 1 of 36 cells. Commit `7d15dd67`. Session record `3c96b753`.

**New:** Exactness gate FAIL. Same code and seeds, not digit-exact. Remaining cells started.

Machine: x86_64, 4 cores, MemTotal 16 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. BLAS libRblas.so, LAPACK libRlapack.so (3.10.1).

Wall clock for mgcfa true N=240 condition 1: 2074 s. File 1416218 bytes. If every cell matches that, the remaining 35 finish in about 20 hours, around 2026-11-10 16:15 UTC. N=960 generation may be slower.

| column | ours | OSF row 1 | difference |
| --- | --- | --- | --- |
| c1_avg_est | -0.404599712458 | -0.404601484966 | 1.772508e-06 |
| c2_avg_est | -0.202670788357 | -0.202680070646 | 9.282289e-06 |
| c3_avg_est | -0.000940180746691 | -0.000951738970219 | 1.155822e-05 |
| c1_n_sig | 8723 | 8723 | 0 |
| c2_n_sig | 3557 | 3557 | 0 |
| c3_n_sig | 528 | 529 | -1 |

**Surprising:** much closer than the ARM pilot, still outside 1e-8 and one significant count.

**Blocking:** issue comments are 403. The 36-cell run is not blocked.
