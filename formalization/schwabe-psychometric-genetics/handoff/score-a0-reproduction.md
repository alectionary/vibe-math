# Reproducing the bounded score-model outcome

Immutable scientific artifact revision: `7ddf23f40124239a8f245de7c71540b0c80216bf`. Work from `formalization/schwabe-psychometric-genetics` in a separate checkout. This revision includes the exact dispatcher, fixed inputs, all four incomplete chains, saved sampler states and terminal resource records. Earlier completed results use the recipe in `handoff/current-reproduction.md`; do not pool dependent draws.

The following read-only audit verifies published file hashes without running R or sampling:

```sh
python - <<'PYCODE'
import json,hashlib
from pathlib import Path
r=json.loads(Path('provenance/score-a0-terminal-outcome.json').read_text())
for name,digest in r['evidence'].items():
    assert hashlib.sha256(Path(name).read_bytes()).hexdigest()==digest,name
print(r['completed_fixed_28000_chains'],r['summed_chain_seconds'],r['elapsed_seconds'])
PYCODE
```

Expected output is zero completed fixed-length chains, 6419.751313023 summed chain/cleanup seconds and1606.104005898 elapsed seconds. `production/score-a0-v1/terminal-checkpoints.csv` records16000 retained rows per chain. The read-only extractor `simulation/audit_score_a0_outcome.py` requires the recorded R runtime and refuses to overwrite published audit files; in a disposable checkout its two generated audit outputs must first be moved to a separate comparison directory before regeneration. No diagnostic or chain needs to be rerun to verify hashes.

The historical launch command and cleanup policy are in `SCORE_A0_DISPATCH.md`; executing it again is a new run and is not authorized by this reproduction recipe. The existing namespace is intentionally refused. Exact source priors, input/runtime identities and starts are in `provenance/score-a0-dispatch-manifest.json`. There is no automatic retry, larger-case run or source-count production.

The main manuscript is a later rendering of this immutable evidence. Master links are filename navigation pending merge; this commit is the reproducible scientific snapshot.
