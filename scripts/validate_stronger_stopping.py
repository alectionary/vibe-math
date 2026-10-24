"""Validate research publication/provenance; Lean alone checks the mathematical proofs."""
from pathlib import Path
import json,hashlib,re,datetime,subprocess,os,zipfile
from pypdf import PdfReader
R=Path(__file__).resolve().parents[1];A=R/'formalization/stopping-bound/stronger';D=R/'literature';G=Path(os.environ.get('STOPPING_GIT_ROOT',str(R)))
load=lambda p:json.loads(p.read_text());sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
v=load(A/'verification.json');c=load(A/'compliance-data.json');assert v['status']=='passed'
assert v['build']['exit_code']==v['axiom_audit']['exit_code']==0
assert v['new_source_modules']==19 and v['declarations_audited']==178
assert v['new_named_declarations']==161 and v['inherited_named_declarations']==17
assert v['canonical_completion_delta']==0
for p,m in v['files'].items():assert sha(A/p)==m['sha256'],p
names=load(A/'audit-declarations.json');log=(A/'axiom-audit.log').read_text();assert len(names)==len(set(names))==178
assert not any(x in log for x in ['error:','sorryAx','Lean.ofReduceBool'])
assert all(n in log for n in names)
assert set(v['axiom_audit']['axioms'])<= {'propext','Classical.choice','Quot.sound'}
es=c['paper_lean_files'];actual={str(p.relative_to(A))for p in A.rglob('*.lean')}
assert len(actual)==len(es)==c['lean_file_count']==23
assert {e['local_path']for e in es}==actual
for e in es:
 assert sha(A/e['local_path'])==e['sha256']
 blob=subprocess.check_output(['git','show',c['checked_source_commit']+':'+e['path']],cwd=G)
 assert hashlib.sha256(blob).hexdigest()==e['sha256']
 assert e['branch_url']=='https://github.com/alectionary/vibe-math/blob/master/'+e['path']
 assert e['pinned_url']=='https://github.com/alectionary/vibe-math/blob/'+c['checked_source_commit']+'/'+e['path']
 for name in e['imports']:
  if not name.startswith(('Mathlib','Lean','Init','Std')):assert name+'.lean'in actual or 'dependencies/'+name+'.lean'in actual,name
for e in c['excerpts']:assert e['code']in(A/e['file']).read_text()
rev=datetime.date.fromisoformat(c['revision_date'])
for src in c['chronology']:
 assert src['role']and src['access_status']
 for m in src['milestones']:
  lo,hi=map(datetime.date.fromisoformat,[m['earliest_possible'],m['latest_possible']]);assert lo<=hi<=rev
  assert m['delta_days_min']==(rev-hi).days and m['delta_days_max']==(rev-lo).days
pdf=PdfReader(A/'stronger-stopping-paper.pdf');urls=set();text='\n'.join(p.extract_text()for p in pdf.pages);compact=re.sub(r'\s+','',text)
for page in pdf.pages:
 for a in page.get('/Annots',[]):
  u=a.get_object().get('/A',{}).get('/URI')
  if u:urls.add(str(u))
for e in es:
 for key in ['branch_url','pinned_url']:assert e[key]in urls and e[key]in compact,e[key]
for src in c['chronology']:
 for m in src['milestones']:assert m['date']in text
assert pdf.metadata.get('/Author','')==''
assert len(pdf.pages)==v['paper']['pages']
for stem in ['PartitionBound','PowersFamily','KernelStopping','SidonBad']:assert stem+'.lean'in text
s=load(D/'stronger-stopping-source-screening.json');assert load(A/'source-screening.json')==s
rows=load(D/'open-problems.json');by={r['id']:r for r in rows};rec=load(D/'research-reconciliation.json')
e=next(e for e in rec['indexing_extensions']if e['id']==s['id']);later=rec['indexing_extensions'][rec['indexing_extensions'].index(e)+1:]
assert len(rows)==287+sum(x['added_entries']for x in later)
assert sum(r['eligible_for_coverage']for r in rows)==143+sum(x['added_eligible_targets']for x in later)
assert s['added_entries']==len(s['added_target_ids'])==20 and s['added_eligible_targets']==8
assert s['full_text_screens_added']==s['new_paper_records']==len(s['papers'])==4
assert s['completed_targets_added']==0
for p in s['papers']:
 assert p['target_count']==len(p['recorded_target_ids'])
 for i in p['new_target_ids']:
  r=by[i];assert r['lean_statement_status']==r['lean_proof_status']=='not_assessed_in_this_extension'
  assert r['current_resolution_status']=='not_independently_established'
  assert any(o['source_sha256']==p['source_sha256']and o['source_id']==p['paper_id']for o in r['occurrences'])
 for name,key in [('source_local_file','source_sha256'),('extracted_text_file','extracted_text_sha256')]:
  f=R/p[name]
  if f.exists():assert sha(f)==p[key]
t=by['L-F16-stopping-bound'];assert t['current_resolution_status']=='answered_negatively_for_prop51_useful_parameter_question'
assert t['stronger_bound_followup']['status']=='incidence_conditioned_existence_answered_positively_and_gram_only_obstruction_proved'
assert t['remaining_source_direction']['incidence_replacement_status']=='answered_positively'
assert sum(r['eligible_for_coverage']and r['lean_proof_status']=='verified_complete_lean_proof'for r in rows)==5
cc=load(A/'crosscheck.json');assert cc['status']=='passed'and len(cc['families'])==8
assert all(r['gram_equal']and r['css']and r['bad_css']and r['six_stopping']and r['six_kernel']for r in cc['families'])
if(A/'stronger-stopping-source.zip').exists():
 z=A/'stronger-stopping-source.zip';assert sha(z)in(A/'SHA256SUMS').read_text()
 with zipfile.ZipFile(z)as f:assert f.testzip()is None
print('PASS: two-block/Sidon criterion, nontrivial infinite CSS families, exact6, Gram bad twins;178-declaration audit;23 full current/pinned Lean URLs; chronology,20/8/4 inventory delta and unchanged original negative answer.')
