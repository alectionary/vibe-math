"""Check cyclic-lift artifact provenance and scope; Lean commands perform proof verification."""
from pathlib import Path
import hashlib,importlib.util,json,re
from urllib.parse import urlparse
R=Path(__file__).resolve().parent.parent;P=R/'formalization/cyclic-lifts';L=R/'formalization/dyadic-rank'
v=json.loads((P/'verification.json').read_text())
assert v['build_exit_code']==v['consumer_exit_code']==0
assert not v['full_target_statement_formalized'] and not v['general_girth_eight_problem_proved']
assert v['theorem_count']==len(v['declaration_axioms'])==36
assert all(set(a)<={'propext','Classical.choice','Quot.sound'} for a in v['declaration_axioms'].values())
assert hashlib.sha256((P/'verification.log').read_bytes()).hexdigest()==v['log_sha256']
for name,sha in v['sha256'].items():assert hashlib.sha256((R/name).read_bytes()).hexdigest()==sha,name
for path in list((L/'CyclicLift').glob('*.lean'))+[L/'CyclicLift.lean',L/'CyclicChecks.lean']:
 t=path.read_text()
 assert not re.search(r'\b(sorry|admit|native_decide|sorryAx)\b',t),path
 assert not re.search(r'^\s*(axiom|unsafe)\b',t,re.M),path
# Original proof source/configuration hashes remain unchanged.
original=json.loads((L/'verification.json').read_text())
for name,sha in original['sha256'].items():assert hashlib.sha256((L/name).read_bytes()).hexdigest()==sha,name
results=json.loads((P/'search/results.json').read_text());assert results['case_count']==len(results['cases'])==v['python_case_count']==432
assert results['girth_histogram']=={'4':351,'8':67,'6':14}
# Independently reconstruct the particular formalized witness using the finite checker.
spec=importlib.util.spec_from_file_location('cyclic_scan',P/'search/scan.py');scan=importlib.util.module_from_spec(spec);spec.loader.exec_module(scan)
B=[[0,0,0],[0,1,2],[0,2,1]];g=scan.matrix_graph(B,3)
assert g==scan.voltage_graph(B,3) and scan.direct_counts(g)==(0,108)
assert scan.voltage_six_count(B,3)==108
cycle=[('c',0,0,0),('l',0,0,0),('c',1,0,0),('l',1,0,2),('c',2,0,1),('l',2,0,0)]
assert len(set(cycle))==6 and all(b in g[a] for a,b in zip(cycle,cycle[1:]+cycle[:1]))
row=next(r for r in json.loads((R/'literature/open-problems.json').read_text()) if r['id']==v['target_id'])
assert not row['supporting_lean_artifact']['changes_exact_target_coverage']
assert row['lean_proof_status']=='no_exact_proof_identified'
summary=json.loads((R/'literature/open-problem-summary.json').read_text())
assert summary['eligible_verified_lean_proofs']==1 and summary['eligible_targets']==108
for href in re.findall(r'\]\(([^)]+)\)',(P/'README.md').read_text()):
 u=urlparse(href)
 if not u.scheme and u.path:assert (P/u.path).exists(),href
print('Validated 36 checked supporting theorems, source hashes, unchanged dyadic artifact, 432 finite cases and the explicit no-four/six-cycle obstruction. General girth-eight target remains unproved.')
