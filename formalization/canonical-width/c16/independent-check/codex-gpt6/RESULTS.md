# Independent checker terminal results

As of 2026-11-03 03:06 UTC: implementation and bounded experiments are complete; all required known-answer tests passed. **Real A/B/C are INCOMPLETE and unresolved.** C ended at its fixed **2026-11-03 03:05:38 UTC** deadline with cooperative shutdown overhead below one second. No negative decision follows from an incomplete run. Both experiment drivers exited successfully; the original search processes no longer exist.

| Required test | Outcome |
|---|---|
| Planted A, B, C | Each found a 128-pair frame; every witness directly checked |
| Real quarter-turn | COMPLETE, zero frames; 2.936 seconds in final gate |
| Real coordinates 0–31 | COMPLETE, exact count 43,046,721; witness checked |
| Real coordinates 32–63 | COMPLETE, zero 32-pair frames |

The six-test gate passed before real runs. The weighted B/C backend separately revalidated the gate and passed planted B/C. Generated small-instance oracles passed 346 unweighted and 2,047 weighted comparisons.

| Real class | Status | Recorded elapsed | Evidence |
|---|---|---:|---|
| A | INCOMPLETE | 7,200.333 s | `final-outputs/real-A.json` |
| B, weighted | INCOMPLETE | 6,699.480 s, remaining original B window | `bundle-outputs/real-B.json` |
| B, redundant SAT | INCOMPLETE | 7,217.276 s including pause and interrupt acknowledgement | `final-outputs/real-B.json` |
| C, weighted | INCOMPLETE | 7,200.395 s | `bundle-outputs/real-C.json` |
| C, SAT | INCOMPLETE | 7,200.165 s | `final-outputs/real-C.json` |

All experiments share CPU affinity 0–1. A/B's original deadline was 01:05:37.870 UTC; no restart or extension occurred. C used its original 7,200-second budget; neither search was restarted or extended. Cooperative interruption can add acknowledgement overhead; actual elapsed times are retained. Earlier failed/interrupted tests and capped attempts remain in the diagnostic folders and logs. No failed gate authorized a real run.

This is procedural clean-room independence from the specified repository research, not a claim of algorithmic novelty or independence from pretrained knowledge. Only SPEC.md and its four listed inputs supplied scientific data. Shared trusted dependencies include Python, compiler/runtime, PySAT/Glucose4.1, and OR-Tools for the diagnostic backend. A separate internal reviewer used the same allowlist and reviewed the new code; this is not an independent formal certificate. Witnesses are directly checked; negative decisions rely on executed counting/search code. No separately verified UNSAT certificate was produced.

Source inputs are pinned to `872a3a9467947f65a30df636a38a7556abd00a52`; full hashes, tool versions, read allowlist and limitations are in `provenance.json`. Runtime identifies the author as Codex based on GPT-6; exact model/version is unavailable. Full build, reproduction and verification commands and mathematical correctness arguments are in `README.md`. Recorded commands were `/workspace/c16-venv/bin/python -u run_integrated_suite.py > final-suite.log 2>&1` and `/workspace/c16-venv/bin/python -u run_bundle_real.py > bundle-suite.log 2>&1` from this implementation directory. Use `run_all.py` for a clean rerun.

The dedicated branch contains only additions under this new model directory. Compiled binaries, caches, and reproducible derived `.matrix` files are omitted from Git; source, raw result JSON, logs, and all diagnostic outcomes are retained. Canonical collected outputs are in `results/`; `results/index.json` identifies raw sources and additional runs. Every saved witness was rechecked from the allowed input vectors. Current-source small-instance tests again passed after terminal collection. `GIT-MANIFEST.json` records full hashes for published files; local reproduction archives additionally preserve compiled binaries and derived matrices.
