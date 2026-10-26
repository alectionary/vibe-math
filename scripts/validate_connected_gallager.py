"""Audit the connected follow-up's proof, independent reconstruction and provenance."""
from pathlib import Path
import hashlib,json,re,subprocess,sys,zipfile
R=Path(__file__).resolve().parents[1];A=R/'formalization/gallager-b-absorbing/connected';D=R/'literature'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
v=json.loads((A/'verification.json').read_text());source=A/'Connected.lean';s=source.read_text();log=(A/'lean-build.log').read_text()
assert v['source_sha256']==sha(source) and v['certificate_sha256']==sha(A/'certificate.json')
assert v['verifier_sha256']==sha(A/'verify.py') and v['build_log_sha256']==sha(A/'lean-build.log')
assert v['lean_returncode']==0 and v['imports']==['Std'] and v['complete_research_import_closure']==['Connected.lean']
assert not re.search(r'\b(sorry|admit|axiom|native_decide|bv_decide)\b',s)
assert not re.search(r'sorryAx|_native|Lean.ofReduceBool|error[:(]',log)
assert set(re.findall(r'^theorem (\w+)',s,re.M))==set(v['declarations'])
for n,d in v['declarations'].items():
 assert s.splitlines()[d['line']-1].startswith('theorem '+n)
 assert 'ConnectedAbsorbing.'+n in log
for line in log.splitlines():
 if 'depends on axioms:' in line:
  actual={x.strip() for x in line.split('[')[1].split(']')[0].split(',') if x.strip()}
  assert actual<={'propext','Classical.choice','Quot.sound'}
subprocess.run([sys.executable,str(A/'verify.py'),'--check'],capture_output=True,check=True)
c=json.loads((A/'certificate.json').read_text());q=c['summary']
assert q['input_errors']==128 and q['initial_acceptances']==16 and q['first_iteration_acceptances']==112
assert q['rank_X']==q['rank_Z']==7 and q['encoded_qubits']==1
assert q['distinct_decoding_checks']==15 and q['decoding_graph_vertices']==q['connected_vertices']==30
assert q['cuts_obstructed']==q['nontrivial_physical_cuts']==32766
assert q['hard_mismatches']==q['edge_mismatches']==q['quantum_failures']==0
screen=json.loads((D/'connected-gallager-source-screening.json').read_text())
assert screen['cohort_delta']==dict(entries=9,eligible_targets=2,paper_records=2,full_text_screens=1,verified_complete_lean_targets=0)
rows=json.loads((D/'open-problems.json').read_text());by={r['id']:r for r in rows}
assert by['L-P09-all-absorbing']['verified_artifact']['immutable_commit']=='2717b0ab2b59c2ccb71f0e369a9f21d80490c191'
assert any(p['report'].endswith('connected/README.md') for p in by['L-P09-all-absorbing']['research_progress'])
for sp in screen['screens']:
 assert sp['target_count']==len(sp['recorded_target_ids'])
 for n in sp['recorded_target_ids']:
  row=by[n];assert row['current_resolution_status']=='not_independently_established'
  assert row['lean_proof_status']=='not_assessed_in_this_extension'
  assert row['occurrences'][0]['source_sha256']==sp['source_sha256']
manifest=json.loads((A/'publication-manifest.json').read_text())
assert manifest['completed_canonical_target_delta']==0
assert manifest['visual_review']['pdf_sha256']==sha(A/'paper/main.pdf')
assert manifest['archive_sha256']==sha(A/'research-source.zip')
for name,h in manifest['files'].items():assert sha(A/name)==h,name
with zipfile.ZipFile(A/'research-source.zip') as z:
 for name,h in manifest['files'].items():assert hashlib.sha256(z.read('connected-gallager/'+name)).hexdigest()==h
assert manifest['proof_commit'] in (A/'paper/supplement.tex').read_text()
pdf_log=(A/'paper/main.log').read_text()
assert not any(t in pdf_log for t in ['Missing character:','Overfull \\hbox','undefined references','LaTeX Error:'])
assert len((A/'paper/proof-listing.txt').read_text().splitlines())==len(s.splitlines())
print('PASS:',len(v['declarations']),'audited Lean theorems;128 independent inputs;32766 physical cuts; source-cohort delta; complete PDF/source archive hashes.')
