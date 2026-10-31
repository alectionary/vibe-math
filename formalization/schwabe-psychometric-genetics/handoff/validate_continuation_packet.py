"""Validate saved handoff and the pinned proposed packet contract; no analyses."""
import collections,csv,hashlib,importlib.util,json,pathlib,subprocess,tempfile
R=pathlib.Path(__file__).resolve().parents[1]
def load(p):return json.loads((R/p).read_text())
def sha(p):return hashlib.sha256((R/p).read_bytes()).hexdigest()
p=load('handoff/continuation-evidence-packet.json');b=load('handoff/evidence-packet.json');c=p['continuation'];checks={}
assert c['base_packet']['sha256']==sha('handoff/evidence-packet.json')=='41c12d8a490b572f1e5ea66a2e12e0becfad1398962616fdbad79b8f4ab2e554'
checks['original_packet_hash_unchanged']=True
assert p['headline_order']==b['headline_order'] and len(p['headline_order'])==26
assert p['headline_effects']==b['headline_effects'] and sum(len(x.get('component_comparisons',[])) for x in p['headline_effects'])==187
assert p['sections']==b['sections'] and p['inventory_audit']==b['inventory_audit']
assert len(p['claims'])==996
for new,old in zip(p['claims'],b['claims']):
 assert {k:v for k,v in new.items() if k!='current_work'}==old
checks['all_996_claim_adjudications_26_headlines_187_components_preserved']=True
rows=list(csv.DictReader((R/'coverage-v4.csv').open()))
for claim,row,projected in zip(p['claims'],rows,c['current_coverage']):
 assert claim['id']==row['claim_id']==projected['claim_id']
 assert claim['status']==row['scientific_status']
 assert claim['current_work']==projected
 assert all(v==row[k] for k,v in projected.items())
for key,count in c['inventory']['coverage_counts'].items():assert count==dict(collections.Counter(r[key] for r in rows))
checks['coverage_exact_projection_and_counts']=True
precedence=c['current_evidence_precedence']
assert len(precedence['generator_claim_ids'])==9
assert len(precedence['chapter6_completed_descriptive_claim_ids'])==21
assert len(precedence['chapter6_pending_target_ids'])==5
assert not set(precedence['chapter6_completed_descriptive_claim_ids']) & set(precedence['chapter6_pending_target_ids'])
plan=c['scientific_evidence']['remaining-target-method-resource-plan']['count_accounting']
assert plan['core_unique_datasets']==3250 and plan['core_dataset_method_fits']==3450
checks['current_scope_9_generator_21_completed_5_pending_and_plan_counts']=True
for path,digest in c['source_hashes'].items():assert sha(path)==digest,path
checks['continuation_source_hashes_verified']=len(c['source_hashes'])
a=load('handoff/continuation-writer-allowlist.json')
for entry in a['allowed_inputs']:assert sha(entry['path'])==entry['sha256']
assert a['packet_sha256']==sha('handoff/continuation-evidence-packet.json')
checks['writer_allowlist_hashes_verified']=True
commit=c['contract_commit']
with tempfile.TemporaryDirectory() as td:
 for name in ['stage_checks.py','first_page.py']:
  out=subprocess.check_output(['git','show',f'{commit}:.agents/skills/replication-paper/scripts/{name}'],cwd=R)
  pathlib.Path(td,name).write_bytes(out)
 spec=importlib.util.spec_from_file_location('pinned_stage',pathlib.Path(td,'stage_checks.py'));mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
 errors=mod.packet_errors(p,R)
 assert not errors,errors
checks['pinned_stage_packet_errors']=[]
record={'result':'pass','structural_validation_only':True,'independent_scientific_review_required':True,'packet_sha256':sha('handoff/continuation-evidence-packet.json'),'base_packet_sha256':sha('handoff/evidence-packet.json'),'contract_commit':commit,'checks':checks,'recovery_state':c['recovery_evidence_reservation']['state'],'limits':'Validates structure, complete preservation, hash identity and declared coverage. Does not certify source completeness, scientific truth, rendered manuscript fidelity or delivery acceptance.'}
(R/'handoff/continuation-packet-validation.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps(record,indent=2))
