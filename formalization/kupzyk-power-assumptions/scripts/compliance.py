"""Validate the reviewed compliance ledger and numerical verdicts."""
import json,sys,importlib.util
from pathlib import Path
root=Path(__file__).resolve().parents[3];base=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('checks',root/'.agents/skills/replication-paper/scripts/checks.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
ledger=json.loads((base/'notes/compliance-ledger.json').read_text())
errors=m.validate_ledger(ledger)
(base/'outputs/ledger-validation.json').write_text(json.dumps(errors,indent=2)+'\n')
print(errors)
# The source and reconstruction records state index-specific differences before judgments.
x=json.loads((base/'notes/comparability.json').read_text())
# Empirical power/GLS power are not SEM fit indices; retain full narrative comparability above.
import csv
with (base/'outputs/comparison.csv').open() as f: rows=list(csv.DictReader(f))
for r in rows:r.update(m.two_axis(r['published'],r['ours'],5,'limited'))
with (base/'outputs/numerical-verdicts.csv').open('w') as f:
 w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
