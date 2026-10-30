# Portable replay of the two-basis evidence

The final clean-copy smoke passed all 11 checks in 117.58 seconds.
`portable-replay-v4/closure.json` lists the actual 95 source and data files
(45,993,825 bytes) with hashes; `portable-replay-v4/summary.json` records
each command and resulting receipt. The copied root was
`/private/tmp/c16-two-basis-portable-replay-v4-20261030T1700`.
This run was launched from the earlier relocated v3 copy, rather than
from the original worktree, to test that the declared recorded prefix is
independent of the current source root. The earlier v3 smoke also passed
all 11 checks in 83.46 seconds.

Six new `*_portable.py` consumers preserve every mathematical check from
their frozen predecessors. They require `--recorded-root` and replace
only explicitly recorded absolute archive paths by the corresponding
relative path beneath the current source root. Foreign absolute prefixes,
parent traversal and resolution outside the current root are rejected.
No global I/O hook, original JSON rewrite, or fallback to the old worktree
is used. Each adapter also checks the frozen predecessor's source hash.
The exact source transformations are listed in
`two-basis-portable-consumer-source-map.json`.

To rebuild a new copy and rerun the complete smoke from a checked-out C16
directory, with fresh destination paths:

```
OPENBLAS_NUM_THREADS=1 /private/tmp/c16-venv/bin/python -B \
  two_basis_portable_replay_v4.py \
  --recorded-root /private/tmp/c16-two-basis-20261030T1438/formalization/canonical-width/c16 \
  --copy-root /private/tmp/c16-two-basis-replay-new \
  --output-dir two-basis-results/portable-replay-new
```

The orchestrator runs each portable consumer from the copied root and
passes the explicit `--recorded-root` argument as the recorded prefix. Its closure
collector follows explicit metadata paths, local Python imports, literal
filename dependencies and derived frozen/matrix companions. Every copied
byte hash is checked, and source files are checked again after replay.

The first two smoke attempts are preserved. They exposed packaging
omissions: frozen companions, a producer named only by hash, and the
derived IPM matrix filename. Their incomplete inventories are not accepted
portable closures. The final v4 closure includes those files and all 11
physical, exact-arithmetic and negative-endpoint checks pass.

These replays preserve the original scientific scopes. Inconclusive
search endpoints remain inconclusive; positive artificial errors do not
establish membership; affine-repair box failures do not establish target
nonmembership. No source frame or C16 exclusion is claimed.
