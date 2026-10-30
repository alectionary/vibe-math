# Chapter 6 result joining: not adjudication

`map_chapter6_results.py` joins the audited 408 Chapter 6 source IDs to a saved,
immutable output directory from the frozen analyzer. It never reads trial exports
or launches fits. It is prepared for terminal use by root; no terminal result
mapping has yet been run by the implementation agent.

It retains 288 direct source figure values, 108 unique signed variance-SE
contrasts and 72 MAR bias contrasts, plus separate exploratory path-SE results
and 3% sensitivity contrasts. Principal and supporting claims reuse the same
evidence with explicit source links; they are not extra independent replications.
All 336 regression coefficient summaries remain descriptive evidence. Other
untabulated recovery, trend and MNAR E summaries retain complete relevant grids.
No grid average, convenient scalar, recovery tolerance, power experiment or
scientific-success status is invented. Original empirical counts and coefficients
cannot be replaced by latent simulation results; their missing-data reasons remain.
Every uncomputed source contrast remains explicit with its source definition and
reason. Figure source labels, methods, design conditions and source numerical
values are checked against the result rows.

First verify that the supervisor is terminal and no workers remain. Root must
supply a recorded terminal JSON with `state` (`completed`, `wall_time_cap`,
`operational_failure` or `stopped`), `active_processes: 0`, `observed_utc` and
`analysis_snapshot_sha256`. The helper checks the record but does not independently
certify the operating-system state. A wall-time cap is not target completion.
Compute the aggregate snapshot hash over the six named analyzer artifacts:

```sh
PYTHONDONTWRITEBYTECODE=1 python3 - <<'PY'
import sys
sys.path.insert(0, 'handoff')
from map_chapter6_results import snapshot, snapshot_sha
print(snapshot_sha(snapshot('production/chapter6-v1/terminal-analysis')))
PY
```

The canonical hashed JSON object maps `summary.json`, `condition-summary.csv`,
`signed-SE-contrasts.csv`, `source-comparisons.csv`, `signed-bias-contrasts.csv` and
`provenance.json` to SHA256 hashes (sorted keys, compact separators). Supply that
hash in both the actual terminal record and CLI:

```sh
python3 handoff/map_chapter6_results.py \
  --spec handoff/claim-specification.json \
  --analysis-dir production/chapter6-v1/terminal-analysis \
  --analysis-snapshot-sha256 RECORDED_SHA256 \
  --terminal-record provenance/terminal-analysis-state.json \
  --output handoff/chapter6-result-mapping.json
```

The output refuses overwrite and records every row key, filename, value column,
full analysis row/uncertainty/denominators, source specification hash, analysis
file hashes, mapper hash and terminal record. Both before/after snapshot checks
reject changing inputs. The independently reviewed production report builder
(hash pinned in the mapper) validates exact grids, families, denominators and
summary consistency in a temporary directory; no paper files are written.

`--fixture` produces an explicitly fixture-labelled output and bypasses only the
terminal-record requirement. Never use fixture output as production evidence.
`PYTHONDONTWRITEBYTECODE=1 OPENBLAS_NUM_THREADS=1 python3 handoff/test_chapter6_mapping.py`
constructs an analysis from the preserved20-repetition baseline in temporary
files and tests complete joining, metric separation, missing empirical/power
results, snapshot/terminal checks and malformed grids/conditions. No live effects
are inspected. Final scientific status, source-comparability judgment, tolerances,
stopping conclusions and synthesis must be supplied separately by root.

The mapper also pins the reviewed analyzer identity in both local code and the
analysis provenance, and pins the reviewed source-specification hash for actual
terminal operation. Fixture mode permits altered source specifications only to
exercise adversarial guards. Terminal `active_processes` must be integer zero
(not a boolean); `observed_utc` must be an explicit ISO UTC timestamp. A
`completed` state requires the analyzer's complete attempted grid; other terminal
states may remain incomplete. Parent source grids, published units and signed
contrast directions are checked before joining.
