# SoPlex exact setup and bounded first trial

Setup began at 2026-10-30 18:43:04 UTC and completed within the authorized ten-minute gate. Machine: arm64, macOS 27.0.1 (26A434). No compilation, Homebrew ownership change, credential change or GitHub Actions run occurred.

The first sandbox `nice` preflight printed `setpriority: Operation not permitted`; its read-only Homebrew listing then failed while creating its cache. The escalated replacement explicitly checked priority19 before invoking Homebrew. Homebrew still failed because `/opt/homebrew/var/homebrew/locks/packages.arm64_golden_gate.jws.json.download.lock` was not writable. No ownership repair or sudo install was attempted. Subsequent setup and computation used verified nice19 and, for numerical processes, one-thread environment settings.

Instead, `acquire_bottles.py` fetched fresh official Homebrew metadata and the matching Golden Gate arm64 bottles into `/private/tmp/c16-soplex-8.1.0-20261030`. It verified each bottle SHA256 before safe archive extraction. Only SoPlex8.1.0 (5,234,290 bytes) and MPFR4.2.2 (1,067,942 bytes) were downloaded. GMP6.3.0 was already present. The binary has no dynamic Boost dependency, so no Boost package was installed. The earlier remote-web cache's8.0.3 discrepancy is superseded for this setup by the preserved fresh8.1.0 metadata; the old evidence remains intact.

Executable:

`/private/tmp/c16-soplex-8.1.0-20261030/soplex/8.1.0/bin/soplex`

SHA256: `fa62759749a44617b1e1f2c38fbcfe5dc0cd658045f95c4d2f851f9577813732`.

It reports SoPlex8.1.0, GitHash `a0061053`, rational GMP6.3.0, Boost1.92.0, MPFR4.2.2 and no PaPILO. `version.txt` preserves the actual version output. Runtime library hashes and this environment are frozen in `setup-ready.json`:

`DYLD_LIBRARY_PATH=/opt/homebrew/opt/gmp/lib:/private/tmp/c16-soplex-8.1.0-20261030/mpfr/4.2.2/lib`.

This is an isolated, checksum-pinned runtime, not a registered Homebrew installation. Run the executable directly from a non-system launcher that passes the environment. The priority guard must abort unless `os.getpriority(os.PRIO_PROCESS,0)==19`; bare `nice` can fail while still launching its child in the restricted sandbox.

Seven tiny endpoint/format checks passed: two ordinary feasible systems, two infeasible systems including a gap below1e-16, a saved-basis reuse, a100-bit fractional coefficient, and an all-zero sparse primal. The independent checker verifies literal rational equations or the signed Farkas contradiction. Nine malformed-output/certificate controls were rejected. Receipts: `tiny-independent.json` and `setup-ready.json`.

The LP reader accepts exact slash fractions with `--readmode=1`. Exact solving used `--solvemode=2 --int:syncmode=1 --int:checkmode=2 -f0 -o0 -s0`. The `-X` rational primal output is sparse and explicitly states that other entries are zero. The `-Y` infeasible output has a `Dual ray` section, positive multipliers on lower-bound rows and negative multipliers on upper-bound rows in the tested examples. Its trailing `No dual (rational) solution available.` refers to an ordinary dual solution, not to the preceding Farkas ray. The reader in `read_soplex_exact_output.py` only parses values; mathematical acceptance requires independent semantic replay.

Two format failures are deliberately preserved. `--help` is not a valid option and returns an error message despite exit0; the help listing was inspected, and `--version` was run separately. More importantly, `--writefile` emits rounded real coefficients even when the input is read rationally. That output is explicitly rejected as an exact LP roundtrip. Root's independent fraction exporter instead compared all original semantic rows to its generated fraction text.

After all gates passed, root authorized one real trial on `joint-fixed-star-fraction-input-point22.lp`, with7,943 variables,35,918 rows and no artificial margin. `run_soplex_bounded.py` bound the manifest, semantic data, executable/libraries and tiny receipts; verified parent/child priority19; set one-thread numerical environment; and imposed120seconds internal,150seconds external and a sampled2GB RSS stop. It ran once and exited. No retry occurred.

The frozen result prefix is `two-basis-results/joint-fixed-star-soplex0-point22`. SoPlex reported exact optimality after rational factorization. Measured wall time was1.5271635seconds and maximum sampled RSS143,671,296bytes (three samples, not an exact instantaneous peak). The sparse rational primal and final basis are retained. This is a solver candidate until root's separate original-row/allocation consumer accepts it. A feasible endpoint would concern only this fixed lambda and the listed necessary constraints, not full matroid membership, a global target conclusion or a C16 source frame.

All acquisition/setup scripts, metadata, tiny LPs, outputs, corruption fixtures, failure observations and logs are preserved here. Official bottle archives and extracted runtime live outside the repository; their public URLs and checksums are in `bottle-manifest.json`.
