"""Validate actual run ledger with the pinned skill's unmodified validator."""
import json,sys,importlib.util
from pathlib import Path
root=Path(__file__).resolve().parents[3];base=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('checks',root/'.agents/skills/replication-paper/scripts/checks.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
rows=[
('Pinned skill and immutable historical work','followed','Master dbbdda83d1acce5ddd86e9ab7c27d79f2f300e12; isolated worktree; skill SHA256 1fd5e51cda8b58c8bcda00c3c43f521a7b1c791771067f1bb3b2125ea572bde3. No edits to skill or C16.'),
('Preflight and regression suite','followed','run-preparation/preflight.json accepted;19 tests passed.'),
('R lavaan fits and OpenMx second optimizer','departed','R mixed-model REML with lme4 and nlme; fixed-covariance power via two independent GLS implementations.','The source uses nested mixed models with variance components, not a CFA; lme4/nlme are appropriate established engines. Both packages locally installed;60 same-data cross-engine fits and54 dense/block checks validate translation. lavaan/OpenMx are installed; departure is applicability, not missing packages.'),
('Source PDF local hash and page crops','departed','Library full-text6713 indexed lines obtained; parent verifies PDF hash143pages and source-page pixels. Local byte helper failed.','A supported transfer was attempted and failed; parent source review supplies visual verification and crops. This executor claims no local PDF hash or pixel inspection.'),
('All headline arms','followed','All54 final exemplary and54 initial empirical conditions; original OD/BW formula arms; threshold and oversampling checks. Empirical budget reduced and explicit.'),
('Runtime estimate and checkpoints','followed','54-cell pilot;notes/budget.md;100-draw checkpoints.'),
('Independent generators and optimizers','followed','Component and dense Gaussian generators; dense/block GLS; lme4 bobyqa/nloptwrap and nlme REML.'),
('Exact original software versions','departed','SAS and Optimal Design2.0 not installed; official SAS methods reviewed; source exact SAS version/seeds not recorded.','No licensed source runtime supplied. R translations are explicitly limited-scope; original executable replay is not claimed.'),
('Availability searches before reconstruction','followed','notes/availability.csv records printed source and searches across official page, GitHub,OSF,GitLab,Zenodo.'),
('Clone every author GitHub repository','departed','No verified author account found through domain/name search.','Cannot identify repositories to clone without inventing account ownership. Search limitation recorded; no blanket unavailability claim.'),
('Numerical and scope columns','followed','comparison.csv and numerical-verdicts.csv; all reconstructed cells limited scope; five-decimal rounding independent of mask compatibility.'),
('Gap checks and uncertainty','followed','Source reading, model/scaling, rounding, failure policy, covariance formula, seeds, optimizer and df alternatives recorded. Dropout SD is predictive variation, not a confidence interval.'),
('Master links for artifacts','departed','Local relative deliverable links plus pinned source repository commit.','Publication is expressly unauthorized, so new master links would be nonexistent. Local reproducible bundle is authoritative until publication is authorized.'),
('Lean algebra formalization','not applicable','No theorem or formal proof claimed; numerical matrix identities independently checked.'),
('PR and announcement','not applicable','No publication or contact authorized; none performed.')]
ledger=[]
for row in rows:
 d=dict(zip(['requirement','status','evidence','justification'],row));ledger.append(d)
errors=m.validate_ledger(ledger)
(base/'notes/compliance-ledger.json').write_text(json.dumps(ledger,indent=2)+'\n')
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
