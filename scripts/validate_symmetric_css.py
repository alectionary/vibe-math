"""Audit general proof closure, exact question scope and symmetric-CSS publication."""
from pathlib import Path
from datetime import date
import hashlib,json,re,subprocess,sys,zipfile
R=Path(__file__).resolve().parents[1];A=R/'formalization/gallager-b-absorbing/symmetric';D=R/'literature'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
v=json.loads((A/'verification.json').read_text());assert v['theorem_count']==76 and v['lean_returncode']==0
assert v['external_imports']==['Std'] and v['canonical_completion_delta']==0
assert v['research_import_closure']==['OddSupport.lean','Question.lean','Consumers.lean','Audit.lean']
assert v['build_log_sha256']==sha(A/'lean-build.log')
assert v['certificate_sha256']==sha(A/'certificate.json') and v['verifier_sha256']==sha(A/'verify.py')
assert v['verification_inputs_sha256']==sha(A/'verification-inputs.json')
log=(A/'lean-build.log').read_text();assert not re.search(r'sorryAx|_native|Lean.ofReduceBool|Lean.trustCompiler|error[:(]',log)
for file,h in v['source_sha256'].items():
 p=A/file;assert sha(p)==h
 s=p.read_text();assert not re.search(r'\b(sorry|admit|axiom|native_decide|bv_decide)\b',s)
 assert all(x in ['Std','OddSupport','Question','Consumers'] for x in re.findall(r'^import (\S+)',s,re.M))
for name,d in v['declarations'].items():
 assert (A/d['source']).read_text().splitlines()[d['line']-1].startswith('theorem '+name.split('.')[-1])
 assert set(d['axioms'])<={'propext','Classical.choice','Quot.sound'} and "'"+name+"'" in log
subprocess.run([sys.executable,str(A/'verify.py'),'--check'],check=True,capture_output=True)
c=json.loads((A/'certificate.json').read_text());assert not c['even_support_construction_search_performed']
assert c['summary']['families']==9 and c['summary']['odd_zero_syndrome_cases']==13
q=(A/'Question.lean').read_text()
for n in ['FullQuestion','EvenFullQuestion','OneStepQuestion']:assert 'def '+n+' : Prop' in q
assert 'theorem full_question_iff_even' in q and 'theorem benchmark_implies_full' in q
screen=json.loads((D/'symmetric-css-source-screening.json').read_text());assert screen['cohort_delta']==dict(entries=7,eligible_targets=0,paper_records=2,full_text_screens=2,verified_complete_lean_targets=0)
rows=json.loads((D/'open-problems.json').read_text());by={r['id']:r for r in rows}
assert len(rows)==screen['baseline']['canonical_entries']+7
assert sum(r['eligible_for_coverage'] for r in rows)==150
assert sum(r['eligible_for_coverage'] and r['lean_proof_status']=='verified_complete_lean_proof' for r in rows)==6
assert by['L-P09-all-absorbing']['verified_artifact']['immutable_commit']=='2717b0ab2b59c2ccb71f0e369a9f21d80490c191'
for p in screen['screens']:
 assert p['status']=='full_text_screened' and p['target_count']==len(p['recorded_target_ids'])
 for f,h in [('source_local_file','source_sha256'),('extracted_text_file','extracted_text_sha256')]:
  if (R/p[f]).exists():assert sha(R/p[f])==p[h]
 for ident in p['recorded_target_ids']:
  r=by[ident];assert not r['eligible_for_coverage']
  assert r['current_resolution_status']=='not_independently_established' and r['lean_proof_status']=='not_assessed_in_this_extension'
  assert r['occurrences'][0]['source_sha256']==p['source_sha256']
  lo,hi=r['occurrences'][0]['extracted_text_lines'];assert 0<lo<=hi<=p['extracted_lines']
for row in json.loads((A/'paper/chronology.json').read_text()):assert row['elapsed_days']==(date.fromisoformat(row['manuscript_date'])-date.fromisoformat(row['earliest_preprint'])).days
sup=(A/'paper/supplement.tex').read_text();main=(A/'paper/main.tex').read_text()
assert '\\author{}' in main and '\\input{supplement.tex}' in main
for module in ['OddSupport','Question','Consumers']:
 assert len((A/'paper'/(module+'-listing.txt')).read_text().splitlines())==len((A/(module+'.lean')).read_text().splitlines())
 assert module+'-listing.txt' in sup
for line in sup.splitlines():
 if line.startswith('\\noindent\\texttt{'):
  name=line.split('{')[1].split('}')[0].replace('\\_','_');decl=next(d for n,d in v['declarations'].items() if n.endswith('.'+name));assert '#L'+str(decl['line']) in line
manifest=json.loads((A/'publication-manifest.json').read_text());assert manifest['completed_canonical_target_delta']==0
assert not manifest['even_support_construction_search_performed'] and manifest['time_budget_seconds'] is None
assert manifest['proof_commit'] in sup and manifest['visual_review']['pdf_sha256']==sha(A/'paper/main.pdf')
assert manifest['archive_sha256']==sha(A/'research-source.zip')
assert manifest['visual_review']['pages_reviewed']==list(range(1,manifest['paper_pages']+1))
for name,h in manifest['files'].items():assert sha(A/name)==h,name
with zipfile.ZipFile(A/'research-source.zip') as z:
 for name,h in manifest['files'].items():assert hashlib.sha256(z.read('symmetric-css/'+name)).hexdigest()==h
assert not any(t in (A/'paper/main.log').read_text() for t in ['Missing character:','Overfull \\hbox','undefined references','LaTeX Error:'])
assert (A/'source-screening.json').read_bytes()==(D/'symmetric-css-source-screening.json').read_bytes()
print('PASS:76 general/interface/consumer theorems;9 fixed families;exact unresolved full/benchmark interfaces;7 harvested directions;PDF/archive hashes;no even-support search.')
