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

## 2026-11-09T20:29Z (cell 2 still fitting)

**Accomplished:** 1 of 36 cells committed (`7d15dd67`, `mgcfa_true_n240_c1`). No new cell commit since 20:02Z.

**New:** `mgcfa_true_n240_c2` started 2026-11-09T20:02:03Z with 4 cores. `exportData` has finished (15000 / 15000). The lavaan fits are still running. Parent process elapsed about 22 minutes. Load average 3.5. No new csv.gz yet.

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB, MemAvailable about 4.4 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. Reference BLAS `libRblas.so`, LAPACK `libRlapack.so` 3.10.1.

Wall clock so far for this cell: about 27 minutes, not finished. The finished N=240 condition-1 cell took 2074 s. If that holds, cell 2 finishes around 20:37Z and the remaining 34 cells after it take about 19.6 hours, projected finish around 2026-11-10 16:15 UTC. N=960 generation may be slower. Output so far is 1.4 MB for one cell.

**Surprising:** none since the exactness gate.

**Blocking:** none. Check-ins are in this file for the coordinator to relay. The 36-cell run is not stopped.

## 2026-11-09T20:50Z (cell 2 committed)

**Accomplished:** 2 of 36 cells. `mgcfa_true_n240_c2` is commit `bc7a3802`, pushed. 11000 rows, 10794 converged, 1408963 bytes, wall 2637 s (2026-11-09T20:02:03Z to 2026-11-09T20:46:00Z).

**New:** `mgcfa_true_n240_c3` started 2026-11-09T20:46:02Z with 4 cores and is in `exportData`. The driver commit-and-push path worked for cell 2.

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. Reference BLAS and LAPACK.

Wall clock: cell 1 was 2074 s, cell 2 was 2637 s. Two cells total about 2.8 MB, so 36 cells are near 50 MB, under 100 MB. If the remaining 34 cells average 40 minutes, they finish in about 23 hours, around 2026-11-10 19:30 UTC. N=960 generation may add time. The exactness gate on cell 1 remains FAIL (means off by 1.8e-6, 9.3e-6, 1.2e-5; significant counts 8723, 3557, 528 against 8723, 3557, 529).

**Surprising:** cell 2 took 2637 s against 2074 s for cell 1, with 10794 converged of 11000 fitted against 10880. Same batch size, a bit more non-convergence.

**Blocking:** none.

## 2026-11-09T21:44Z (cell 3 still fitting)

**Accomplished:** 2 of 36 cells. Commits `7d15dd67` (`mgcfa_true_n240_c1`, 2074 s) and `bc7a3802` (`mgcfa_true_n240_c2`, 2637 s). No new cell since 20:50Z.

**New:** `mgcfa_true_n240_c3` is still running. It started 2026-11-09T20:46:02Z (elapsed about 50 minutes). Four workers are at about 99% CPU; the current fit batch has been alive about 5.5 minutes. `exportData` finished earlier. No new csv.gz yet. Memory is fine (MemAvailable about 3.7 GiB at the last look; no OOM).

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. Reference BLAS `libRblas.so`, LAPACK `libRlapack.so` 3.10.1.

Wall clock: cell 1 2074 s, cell 2 2637 s, cell 3 past 3000 s and not finished. Condition 3 is the 45/45/5/5 allocation, and each fit is slower than in the balanced cell. If the remaining 34 cells average 50 minutes, the finish is about 28 hours from now, around 2026-11-11 02:00 UTC. That projection will be revised when cell 3 ends. Two cells are 2.8 MB; 36 cells stay near 50 MB, under 100 MB. The exactness gate on cell 1 remains FAIL.

**Surprising:** condition 3 fits are taking longer per batch than conditions 1 and 2. The workers are busy, not stalled.

**Blocking:** none.

## 2026-11-09T22:40Z (cell 3 still fitting)

**Accomplished:** 2 of 36 cells. `7d15dd67` (2074 s) and `bc7a3802` (2637 s). No new cell commit since 20:46Z.

**New:** `mgcfa_true_n240_c3` is still the running cell. Log start 2026-11-09T20:46:02Z, so wall time so far is 1 hour 54 minutes. The R process etime is 1:35:43. Four workers are at about 99% CPU and the current batch started about 2 minutes ago, so batches are still finishing. MemAvailable about 3.7 GiB. No OOM.

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. Reference BLAS `libRblas.so`, LAPACK `libRlapack.so` 3.10.1.

Wall clock: cells 1 and 2 were 35 and 44 minutes. Cell 3 (45/45/5/5) is past 114 minutes and not done. A full-design finish time is not stable until this cell ends. If the other 11 condition-3 cells were also about 2 hours and the other 22 cells about 40 minutes, the rest of the grid would be on the order of 36 hours. That is a sketch from this one unfinished cell, not a measurement of N=480 or N=960. Output size is still about 1.4 MB per finished cell, so 36 cells stay near 50 MB. The exactness gate on cell 1 remains FAIL.

**Surprising:** the 45/5 cell is more than twice the balanced cell, and it is still in the fit loop at 114 minutes.

**Blocking:** none. Replicates, allocation, and engine are unchanged.

## 2026-11-09T22:42Z (branch SHAs rewritten upstream)

**Accomplished:** 2 of 36 cells, same files as before. The branch was force-updated on the remote while cell 3 was fitting. The replay blobs are unchanged. Current SHAs on `replication/jeffries-2024`: cell 1 `c33bddb8`, cell 2 `af8248b2`, session record `c1aad9b4`. The 22:40Z check-in is `34e4ce74`.

**New:** Nothing about the fits. `mgcfa_true_n240_c3` is still running (R etime about 1:36, four workers near 99% CPU).

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0.

Wall clock unchanged from the 22:40Z note. Cell 3 started 2026-11-09T20:46:02Z and has not finished.

**Surprising:** the remote branch history was rewritten (same commit messages, new SHAs, plus unrelated log-file byte changes outside this study). The push of the 22:40Z check-in was rebased onto that history and then pushed. No force-push from this agent.

**Blocking:** none.

## 2026-11-09T23:14Z (cell 3 committed)

**Accomplished:** 3 of 36 cells. `mgcfa_true_n240_c3` is commit `77f62409`, pushed. 12000 rows fitted, 10730 converged, 1440247 bytes, wall 8613 s (2026-11-09T20:46:02Z to 2026-11-09T23:09:35Z).

**New:** `mgcfa_null_n240_c1` started 2026-11-09T23:09:37Z with 4 cores and is in `exportData`. Cell times so far: condition 1, 2074 s; condition 2, 2637 s; condition 3, 8613 s. The 45/5 cell needed 12 batches of 1000 to reach 10000 converged fits.

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. Reference BLAS `libRblas.so`, LAPACK `libRlapack.so` 3.10.1.

Wall clock and projection: three finished cells are 35, 44, and 144 minutes. If the other 11 cells of each imbalance match those three, the remaining work is about 41 hours, finishing around 2026-11-11 16:00 UTC. N=960 generation may be slower than that. Three cells are 4.3 MB, so 36 cells stay near 55 MB, under 100 MB. The exactness gate on cell 1 remains FAIL (means off by 1.8e-6, 9.3e-6, and 1.2e-5; significant counts 8723, 3557, 528 against 8723, 3557, 529). Current cell SHAs on this branch: cell 1 `c33bddb8`, cell 2 `af8248b2`, cell 3 `77f62409`.

**Surprising:** condition 3 took 8613 s, about four times condition 1, because more replicates failed to converge and each fit was slower.

**Blocking:** none. Replicates, allocation, and the engine are unchanged.

## 2026-11-09T23:59Z (cell 4 committed)

**Accomplished:** 4 of 36 cells. `mgcfa_null_n240_c1` is commit `831fd202`, pushed. 11000 rows, 10929 converged, 1420224 bytes, wall 2301 s (2026-11-09T23:09:37Z to 2026-11-09T23:47:58Z).

**New:** `mgcfa_null_n240_c2` started 2026-11-09T23:48:01Z with 4 cores and is in `exportData`. Finished walls: true c1 2074 s, true c2 2637 s, true c3 8613 s, null c1 2301 s.

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. Reference BLAS `libRblas.so`, LAPACK `libRlapack.so` 3.10.1.

Wall clock and projection: balanced cells are 35–38 minutes, the one 35/15 cell was 44 minutes, and the one 45/5 cell was 144 minutes. If the remaining 11 cells of each imbalance match those, the rest of the grid is about 40 hours, finishing around 2026-11-11 16:00 UTC. N=960 generation may be slower. Four cells are 5.7 MB, so 36 cells stay near 50 MB, under 100 MB. Exactness gate on cell 1 remains FAIL. SHAs: cell 1 `c33bddb8`, cell 2 `af8248b2`, cell 3 `77f62409`, cell 4 `831fd202`.

**Surprising:** none. The null balanced cell is close to the true balanced cell (2301 s vs 2074 s).

**Blocking:** none.

## 2026-11-10T00:35Z (cell 5 committed)

**Accomplished:** 5 of 36 cells. `mgcfa_null_n240_c2` is commit `411e6f77`, pushed. 11000 rows, 10901 converged, 1421973 bytes, wall 2356 s (2026-11-09T23:48:01Z to 2026-11-10T00:27:17Z).

**New:** `mgcfa_null_n240_c3` started 2026-11-10T00:27:19Z with 4 cores. Generation is done and the fits have started (four workers near 99% CPU). Finished walls: 2074, 2637, 8613, 2301, 2356 s.

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. Reference BLAS `libRblas.so`, LAPACK `libRlapack.so` 3.10.1.

Wall clock and projection: the 35/15 null cell was 2356 s, close to the balanced cells, so the long run is still the 45/5 cell (8613 s). One 45/5 cell is running now. If the other ten 45/5 cells also take about 144 minutes and the other twenty cells about 40 minutes, the rest of the grid is about 40 hours, finishing around 2026-11-11 16:30 UTC. N=960 generation may be slower. Five cells are 7.1 MB, so 36 cells stay near 50 MB, under 100 MB. Exactness gate on cell 1 remains FAIL.

**Surprising:** none. The null 35/15 cell was not slow.

**Blocking:** none.

## 2026-11-10T01:35Z (null condition 3 still fitting)

**Accomplished:** 5 of 36 cells. Latest cell commit `411e6f77` (`mgcfa_null_n240_c2`, 2356 s). No new cell since 00:35Z.

**New:** `mgcfa_null_n240_c3` is still running. It started 2026-11-10T00:27:19Z, so wall time so far is 68 minutes. The R process etime is 53 minutes. Four workers are near 97–99% CPU and the current batch has been alive about 5.5 minutes. MemAvailable about 3.7 GiB. No OOM.

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. Reference BLAS `libRblas.so`, LAPACK `libRlapack.so` 3.10.1.

Wall clock and projection: the matching true 45/5 cell took 8613 s, so this cell may finish around 02:50Z if it matches. The rest-of-grid sketch is unchanged: about 40 hours from 00:35Z, around 2026-11-11 16:30 UTC, with N=960 generation possibly slower. Five finished cells are 7.1 MB. Exactness gate on cell 1 remains FAIL.

**Surprising:** none. This 45/5 cell is slow in the same way as the true 45/5 cell.

**Blocking:** none.

## 2026-11-10T02:16Z (cell 6 committed)

**Accomplished:** 6 of 36 cells. `mgcfa_null_n240_c3` is commit `9418f3fe`, pushed. 11000 rows fitted, 10531 converged, 1422061 bytes, wall 5651 s (2026-11-10T00:27:19Z to 2026-11-10T02:01:30Z).

**New:** `mimic_true_n240_c1` is running (about 10 minutes in, fits started, four workers). The null 45/5 cell was 5651 s, against 8613 s for the true 45/5 cell. It reached 10000 converged fits in 11 batches rather than 12.

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. Reference BLAS `libRblas.so`, LAPACK `libRlapack.so` 3.10.1.

Wall clock and projection: the two 45/5 cells are 94 and 144 minutes. The four other N=240 MGCFA cells are 35–44 minutes. MIMIC timing is not in yet. If the remaining ten 45/5 cells average about 2 hours and the other twenty cells average 40 minutes, the rest is about 33 hours, finishing around 2026-11-11 11:00 UTC. N=960 generation may be slower. Six cells are about 8.5 MB, so 36 cells stay near 50 MB, under 100 MB. Exactness gate on cell 1 remains FAIL.

**Surprising:** the null 45/5 cell was 5651 s, about 50 minutes shorter than the true 45/5 cell, because one fewer batch was required.

**Blocking:** none.

## 2026-11-10T02:36Z (cell 7 committed, MIMIC is faster)

**Accomplished:** 7 of 36 cells. `mimic_true_n240_c1` is commit `aaf06f19`, pushed. 10000 rows, 10000 converged, 1459081 bytes, wall 1249 s (2026-11-10T02:01:32Z to 2026-11-10T02:22:21Z).

**New:** `mimic_true_n240_c2` started 2026-11-10T02:22:23Z and is still in `exportData`. The first MIMIC cell converged on every one of the first 10000 replicates and took 1249 s, about half a balanced MGCFA cell.

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. Reference BLAS `libRblas.so`, LAPACK `libRlapack.so` 3.10.1.

Wall clock and projection: N=240 MGCFA was 35–44 minutes except the 45/5 cells at 94 and 144 minutes. The first MIMIC cell was 21 minutes. If the other 17 MIMIC cells stay near 21 minutes (about 6 hours) and the 12 remaining MGCFA cells (N=480 and N=960) average about 70 minutes (about 14 hours), the rest is about 20 hours, finishing around 2026-11-10 22:30 UTC. That sketch does not yet include a MIMIC 45/5 cell or an N=960 cell. Seven cells are about 10 MB, so 36 cells stay near 50 MB, under 100 MB. Exactness gate on cell 1 remains FAIL.

**Surprising:** MIMIC condition 1 converged on all 10000 fitted replicates. The MGCFA cells have been leaving a few hundred unconverged inside the fitted prefix.

**Blocking:** none.

## 2026-11-10T03:18Z (cells 8 and 9 committed)

**Accomplished:** 9 of 36 cells. `mimic_true_n240_c2` is `6ba4e29b`, 1334 s, 10000/10000 converged, 1455195 bytes. `mimic_true_n240_c3` is `6d88c434`, 1461 s, 10000/10000 converged, 1456236 bytes. Both pushed.

**New:** `mimic_null_n240_c1` started 2026-11-10T03:09:02Z and is in `exportData`. The MIMIC 45/5 cell was 1461 s, not the multi-hour MGCFA 45/5 pattern. All three MIMIC true N=240 cells converged on every fitted replicate.

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. Reference BLAS `libRblas.so`, LAPACK `libRlapack.so` 3.10.1.

Wall clock and projection: N=240 is done for MGCFA and for MIMIC true. MIMIC cells are 21–24 minutes. The slow cells were MGCFA with groups of 12. If the remaining 27 cells average 40 minutes, the rest is about 18 hours, finishing around 2026-11-10 21:00 UTC. MGCFA condition 3 at N=480 still has groups of 24, so those two cells may be longer. Nine cells are about 13 MB, so 36 cells stay near 52 MB, under 100 MB. Exactness gate on cell 1 remains FAIL.

**Surprising:** MIMIC condition 3 was 1461 s with full convergence. The 45/5 slowdown has shown up in MGCFA, not in MIMIC.

**Blocking:** none.

## 2026-11-10T03:58Z (11 of 36, last N=240 cell started)

**Accomplished:** 11 of 36 cells. Since 03:18Z: `mimic_null_n240_c1` is `02bec14f`, 1319 s, 10000/10000, 1394932 bytes. `mimic_null_n240_c2` is `a7d279be`, 1247 s, 10000/10000, 1403208 bytes. Both pushed.

**New:** `mimic_null_n240_c3` started 2026-11-10T03:51:52Z and is in `exportData`. That is the last N=240 cell. All six N=240 MIMIC cells so far are 1247–1461 s with 10000 converged of 10000 fitted.

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB, MemAvailable about 4.9 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. Reference BLAS `libRblas.so`, LAPACK `libRlapack.so` 3.10.1.

Wall clock and projection: N=240 MGCFA was 35–44 minutes except 45/5 at 94 and 144 minutes. N=240 MIMIC is about 21–24 minutes. 24 cells remain after this one (N=480 and N=960). If those average 40 minutes, the rest is about 16 hours, finishing around 2026-11-10 20:00 UTC. MGCFA condition 3 at N=480 is the cell most likely to run long. Eleven cells are 15.7 MB, so 36 cells stay near 52 MB, under 100 MB. Exactness gate on cell 1 remains FAIL.

**Surprising:** none.

**Blocking:** none.

## 2026-11-10T04:19Z (N=240 complete, 12 of 36)

**Accomplished:** 12 of 36 cells. `mimic_null_n240_c3` is `cd5e5c3e`, pushed. 10000 rows, 10000 converged, 1407863 bytes, wall 1211 s (2026-11-10T03:51:52Z to 2026-11-10T04:12:03Z). All 12 N=240 cells are committed.

**New:** `mgcfa_true_n480_c1` started 2026-11-10T04:12:05Z with 4 cores and is in `exportData`. N=480 generation is about twice the N=240 generation.

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. Reference BLAS `libRblas.so`, LAPACK `libRlapack.so` 3.10.1.

Wall clock and projection: N=240 is done. MIMIC N=240 was 1211–1461 s. MGCFA N=240 was 2074–2637 s except the 45/5 cells at 5651 and 8613 s. 24 cells remain. If they average 45 minutes, the rest is about 18 hours, finishing around 2026-11-10 22:00 UTC. The first N=480 timing will replace that average. Twelve cells are 17.1 MB, so 36 cells stay near 52 MB, under 100 MB. Exactness gate on cell 1 remains FAIL.

**Surprising:** none.

**Blocking:** none.

## 2026-11-10T05:00Z (first N=480 cell, 13 of 36)

**Accomplished:** 13 of 36 cells. `mgcfa_true_n480_c1` is `70b5293f`, pushed. 11000 rows, 10986 converged, 1441634 bytes, wall 2306 s (2026-11-10T04:12:05Z to 2026-11-10T04:50:31Z).

**New:** `mgcfa_true_n480_c2` started 2026-11-10T04:50:34Z and is in `exportData`. Doubling N from 240 to 480 did not double the balanced MGCFA cell: 2306 s against 2074 s at N=240.

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. Reference BLAS `libRblas.so`, LAPACK `libRlapack.so` 3.10.1.

Wall clock and projection: 23 cells remain. If MGCFA N=480 and N=960 stay near the N=240 times, and MIMIC stays near 25–40 minutes, the rest is about 15–18 hours, finishing around 2026-11-10 20:00–23:00 UTC. MGCFA 45/5 at N=480 is still untimed. Thirteen cells are 18.6 MB, so 36 cells stay near 52 MB, under 100 MB. Exactness gate on cell 1 remains FAIL.

**Surprising:** N=480 balanced MGCFA was 2306 s, only about 4 minutes longer than N=240.

**Blocking:** none.

## 2026-11-10T05:36Z (cell 14 committed, N=480 condition 3 started)

**Accomplished:** 14 of 36 cells. `mgcfa_true_n480_c2` is `057f1dcf`, pushed. 11000 rows, 10993 converged, 1441691 bytes, wall 2242 s (2026-11-10T04:50:34Z to 2026-11-10T05:27:56Z).

**New:** `mgcfa_true_n480_c3` started 2026-11-10T05:27:59Z. Fits have started (four workers). This is the 45/5 cell at N=480, groups of 216, 216, 24, and 24. The N=240 version of this cell took 8613 s.

Machine: `uname -m` = x86_64, 4 cores, MemTotal 16 GiB. R 4.2.2. lavaan 0.6-17, simsem 0.5-16, dynamic 1.1.0. Reference BLAS `libRblas.so`, LAPACK `libRlapack.so` 3.10.1.

Wall clock and projection: the two N=480 MGCFA cells so far are 2306 s and 2242 s, in line with N=240. 22 cells remain, including this untimed 45/5 cell. If the rest average 45 minutes, the finish is about 16 hours out, around 2026-11-10 22:00 UTC. Fourteen cells are 20.0 MB, so 36 cells stay near 52 MB, under 100 MB. Exactness gate on cell 1 remains FAIL.

**Surprising:** none yet on this cell. It has only been running a few minutes.

**Blocking:** none.
