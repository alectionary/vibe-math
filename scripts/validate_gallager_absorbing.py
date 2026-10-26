"""Validate the published counterexample's source-bound evidence and bookkeeping."""
from pathlib import Path
import json,hashlib,re,subprocess,sys
R=Path(__file__).resolve().parents[1];A=R/'formalization/gallager-b-absorbing';D=R/'literature'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
v=json.loads((A/'verification.json').read_text());proof=A/'Counterexample.lean'
assert sha(proof)==v['source_sha256']
assert sha(A/'certificate.json')==v['certificate_sha256']
assert sha(A/'verify.py')==v['verifier_sha256']
assert sha(A/'lean-build.log')==v['build_log_sha256']
assert v['lean_returncode']==0 and v['no_sorry'] and v['no_native_decide']
assert v['imports']==['Std'] and len(v['declarations'])==26
assert not re.search(r'\b(sorry|admit|axiom)\b',proof.read_text())
assert 'sorryAx' not in (A/'lean-build.log').read_text()
for n,d in v['declarations'].items():assert proof.read_text().splitlines()[d['line']-1].startswith('theorem '+n)
subprocess.run([sys.executable,str(A/'verify.py'),'--check'],check=True,capture_output=True)
c=json.loads((A/'certificate.json').read_text());assert c['summary']['errors']==128
assert c['summary']['hard_mismatches']==c['summary']['edge_mismatches']==c['summary']['quantum_failures_first_block']==0
r=next(x for x in json.loads((D/'open-problems.json').read_text()) if x['id']=='L-P09-all-absorbing')
assert r['lean_proof_status']=='verified_complete_lean_proof'
assert r['current_resolution_status']=='refuted_by_lean_checked_unrestricted_counterexample'
assert r['verified_artifact']['immutable_commit']=='2717b0ab2b59c2ccb71f0e369a9f21d80490c191'
s=json.loads((D/'gallager-absorbing-source-screening.json').read_text())
assert s['cohort_delta']==dict(entries=6,eligible_targets=0,paper_records=2,full_text_screens=1,verified_complete_lean_targets=1)
for source in s['screens']:
 if source.get('paper_id')=='F95':assert len(source['target_ids'])==6 and source['status']=='full_text_screened'
 if source.get('paper_id')=='F96':assert not source['zero_question_screen_claimed']
paper=A/'paper/main.pdf';assert paper.is_file() and paper.stat().st_size>20000
log=(A/'paper/main.log').read_text()
assert not any(x in log for x in ['Missing character:','Overfull \\hbox','undefined references','LaTeX Error:'])
listing=(A/'paper/proof-listing.txt').read_text();assert len(listing.splitlines())==len(proof.read_text().splitlines())
assert '2717b0ab2b59c2ccb71f0e369a9f21d80490c191' in (A/'paper/supplement.tex').read_text()
print('PASS: source hashes, all26 theorem locations,128 independent inputs, both syndrome conventions, full CSS-span recovery, canonical status and PDF build.')
