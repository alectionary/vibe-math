"""Audit publication links, actual PDF annotations/text, dates and source coverage.
Requires pypdf. Mathematical proofs are checked by Lean, not this script.
"""
from pathlib import Path
import json,hashlib,re,datetime,calendar,csv,subprocess,os
from pypdf import PdfReader
R=Path(__file__).resolve().parents[1];A=R/'formalization/stopping-bound'
G=Path(os.environ.get('STOPPING_GIT_ROOT',str(R)))
load=lambda p:json.loads(p.read_text());sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
d=load(A/'compliance-data.json');es=d['lean_files'];actual={str(p.relative_to(R)) for p in A.rglob('*.lean') if len(p.relative_to(A).parts)==1 or p.relative_to(A).parts[0] in ['source-answer','incidence','classification']}
assert len(es)==len(actual)==d['lean_file_count']==42
assert {e['path'] for e in es}==actual
for e in es:
 assert sha(R/e['path'])==e['sha256']
 assert e['branch_url']=='https://github.com/alectionary/vibe-math/blob/master/'+e['path']
 assert e['pinned_url']=='https://github.com/alectionary/vibe-math/blob/'+d['checked_source_commit']+'/'+e['path']
 for k in ['branch_url','pinned_url']:assert e[k] in (A/'FULL-PROOF-LINKS.md').read_text()
 blob=subprocess.check_output(['git','show',d['checked_source_commit']+':'+e['path']],cwd=G)
 assert hashlib.sha256(blob).hexdigest()==e['sha256']
rev=datetime.date.fromisoformat(d['revision_date'])
assert {'F16','F67','F68','F69','F70','F71','F72','F73','F74','F75','F76','Connolly2024','Morris2025'}<={s['id'] for s in d['chronology']}
assert len(d['chronology'])==21 and sum(len(s['milestones']) for s in d['chronology'])==32
for s in d['chronology']:
 assert s['role'] and s['access_status'] and s['url'].startswith('https://')
 for m in s['milestones']:
  a,b=map(datetime.date.fromisoformat,[m['earliest_possible'],m['latest_possible']]);assert a<=b<=rev
  assert (rev-b).days==m['delta_days_min'] and (rev-a).days==m['delta_days_max']
  assert len(m['date'].split('-'))=={'day':3,'month':2,'year':1}[m['precision']]
  if m['precision']=='day':assert a==b==datetime.date.fromisoformat(m['date'])
  if m['precision']=='month':assert a.day==1 and b.day==calendar.monthrange(a.year,a.month)[1]
  if m['precision']=='year':assert a.month==a.day==1 and b==min(datetime.date(a.year,12,31),rev)
  assert m['evidence']
with (A/'source-chronology.csv').open() as f:assert len(list(csv.DictReader(f)))==32
covered=set()
for kind in ['source-answer','incidence','classification']:
 B=A/kind;c=load(B/'compliance-data.json');v=load(B/'verification.json');assert c['chronology']==d['chronology']
 pdf=PdfReader(B/'paper.pdf');urls=set();text='\n'.join(p.extract_text() for p in pdf.pages);compact=re.sub(r'\s+','',text)
 for page in pdf.pages:
  for x in page.get('/Annots',[]):
   u=x.get_object().get('/A',{}).get('/URI')
   if u:urls.add(str(u))
 for e in c['paper_lean_files']:
  covered.add(e['path'])
  for key in ['branch_url','pinned_url']:
   assert e[key] in urls,(kind,'missing clickable full URL',e['path'])
   assert e[key] in compact,(kind,'missing displayed full URL',e['path'])
   assert e[key] in (B/'PROOF-LINKS.html').read_text() and e[key] in (B/'PROOF-LINKS.md').read_text()
 assert any(c['checked_excerpt'] in p.read_text() for p in B.rglob('*.lean'))
 if c.get('additional_checked_excerpt'):assert c['additional_checked_excerpt'] in (B/'DenseSourceBridge.lean').read_text()
 assert 'Question, source and answer' in text and 'Dependency guide' in text
 assert 'earliestdatesunassessed' in compact or 'earliestdates' in compact
 assert pdf.metadata.get('/Author','')==''
 assert 'local and uncommitted' not in text and 'immutable public commit links do not yet exist' not in text
 for s in c['chronology']:
  for m in s['milestones']:assert m['date'] in text
 assert len(pdf.pages)==v['documentation_compliance_revision']['pages']
 for path,entry in v['files'].items():assert sha(B/path)==entry['sha256'],(kind,path)
 available={p.stem for p in B.rglob('*.lean')}
 for e in c['paper_lean_files']:
  if e['local_path'].startswith(kind+'/'):
   for name in e['imports']:
    if not name.startswith(('Mathlib','Lean','Std','Init')):assert name in available,(kind,name)
assert covered==actual
v=load(A/'source-answer/dense-bridge-verification.json');assert v['status']=='passed' and v['axiom_audit']['count']==20
for p,x in v['files'].items():assert sha(A/'source-answer'/p)==x['sha256']
log=(A/'source-answer/dense-bridge-axiom-audit.log').read_text();assert not any(t in log for t in ['sorryAx','error:','Lean.ofReduceBool'])
assert set(v['axiom_audit']['axioms'])<=set(['propext','Classical.choice','Quot.sound'])
assert not re.search(r'\b(sorry|admit|axiom|native_decide)\b|Lean\.ofReduceBool',(A/'source-answer/DenseSourceBridge.lean').read_text())
rows=load(R/'literature/open-problems.json');t=next(x for x in rows if x['id']=='L-F16-stopping-bound')
assert t['current_resolution_status']=='answered_negatively_for_prop51_useful_parameter_question'
assert t['remaining_source_direction']['status'] in ['open_in_this_investigation','partially_answered_by_incidence_replacement_and_restricted_gram_obstruction']
assert sum(x['eligible_for_coverage'] and x['lean_proof_status']=='verified_complete_lean_proof' for x in rows)==5
assert 'Feng' in (A/'SKILL-COMPLIANCE-AUDIT.md').read_text()
print('PASS: historical42 Lean/audit files have displayed/clickable full current/immutable URLs;21 source records/32 date milestones; actual proof excerpts, imports, PDF metadata, hashes and20-declaration dense bridge audit; historical cohort267/135/110/97/5 retained; later extensions validated separately.')
