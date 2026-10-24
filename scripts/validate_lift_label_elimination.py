"""Validate evidence boundaries and immutable research payload, not novelty claims."""
from pathlib import Path
import json,hashlib,re
R=Path(__file__).resolve().parents[1];A=R/'formalization/lift-label-elimination'
def load(p):return json.loads(p.read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
m=load(A/'verification.json');assert m['project_derived_scope_answered'] and not m['canonical_complete']
assert m['cohort_delta']==dict(canonical_entries=0,eligible_targets=0,complete_canonical_Lean_targets=0)
assert m['new_module_count']==len(m['new_lean_modules'])
assert m['all_manuscript_proofs_have_checked_Lean_versions']
audit=load(A/'axiom-audit.json');assert audit['passed'] and audit['all_named_authored_declarations_audited']
assert audit['module_count']==m['new_module_count'] and audit['declaration_count']>1000
assert load(A/'proof-coverage.json')['status']=='every_manuscript_proof_has_checked_Lean_version'
assert m['prior_dependency_modules']==61 and not m['prior_dependency_rebuild_this_block']
for name,h in m['payload_sha256'].items():assert sha(A/name)==h,name
for row in m['new_lean_modules']:
 assert row['exit_code']==0 and row['unchanged_during_check']
 assert set(row['printed_axioms'])<={'propext','Classical.choice','Quot.sound'}
 assert sha(A/(row['module']+'.lean'))==row['source_sha256']
 log=A/'fresh-logs'/(row['module']+'.log');assert sha(log)==row['log_sha256']
 body=log.read_text();assert 'sorryAx' not in body and 'error:' not in body
 assert not re.search(r'\b(sorry|admit|native_decide)\b',(A/(row['module']+'.lean')).read_text())
f=load(A/'fresh-recheck.json');assert f['fresh_new_module_check'] and len(f['new_modules'])==m['new_module_count'] and len(f['prior_checked_sources'])==61
assert sha(R/'formalization/absorbing-four-zero/verification.json')==m['prior_manifest_sha256']
prior=load(R/'formalization/absorbing-four-zero/verification.json')
prior_names={r['module'] for group in ['base_lean_modules','prior_complex_lean_modules','new_lean_modules'] for r in prior[group]}
new_names={r['module'] for r in m['new_lean_modules']}
for row in m['new_lean_modules']:
 for imp in re.findall(r'^import\s+(\S+)',(A/(row['module']+'.lean')).read_text(),re.M):
  assert imp in new_names|prior_names or imp.startswith(('Mathlib.','Lean.','Std.')),imp

assert load(A/'certificate-verification.json')['all_passed']
assert load(A/'family-ingredient-verification.json')['passed']
v=load(A/'result-validation.json');assert v['passed'] and v['cpp_gauge_assignments']==8746998 and v['code_parameters']==[280,18,6]
q=load(A/'quantum-independent.json');assert q['passed'] and q['quadruples_per_graph']==250654530 and q['augmented_Z_rank']==132
rows=load(R/'literature/open-problems.json');ids={r['id'] for r in rows};assert m['target_id'] not in ids
assert len(rows)==190 and sum(r['eligible_for_coverage'] for r in rows)==112
assert sum(r['eligible_for_coverage'] and r['lean_proof_status']=='verified_complete_lean_proof' for r in rows)==4
rec=load(R/'literature/research-reconciliation.json');task=next(t for t in rec['project_derived_followups'] if t['id']==m['target_id']);assert task['parent_target_id']==m['parent_canonical_target'] and not task['eligible_for_coverage']
assert not task['source_authors_asked_this_exact_question']
block=next(b for b in rec['research_blocks'] if b.get('project_derived_followup_id')==m['target_id']);assert block['complete_canonical_lean_target_delta']==0
sources=load(R/'literature/research-source-index.json')['sources'];assert len(sources)==rec['central_source_records']
assert {'AsvadiBanihashemiAhmadianAttari2010','WangDolecekWesel2011','WangDolecekWesel2012','KelleyWalker2008'}<={s['id'] for s in sources}
chronology=load(A/'reference-chronology.json');assert {r['source_id'] for r in chronology['rows']}<={s['id'] for s in sources}
from datetime import date
revision=date.fromisoformat(chronology['paper_revision_date'])
for r in chronology['rows']:
 lo,hi=map(date.fromisoformat,r['earliest_located_date_or_interval'])
 assert r['delta_days_min']==(revision-hi).days and r['delta_days_max']==(revision-lo).days

prior=load(A/'prior-art.json');assert len(prior['searches']['x_direct']['queries'])==3 and len(prior['searches']['github']['github'])==4
assert prior['searches']['limits'] and prior['remaining_access_gaps']
print(f"PASS:{m['new_module_count']}new checked modules,all manuscript proofs covered,{audit['declaration_count']}audited declarations,61preserved dependencies; X/GitHub limits recorded; canonical coverage unchanged4/112.")
