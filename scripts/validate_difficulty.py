"""Validate planning bookkeeping; it does not validate subjective effort predictions."""
import pathlib,json,collections,hashlib,re
from urllib.parse import urlparse
R=pathlib.Path(__file__).resolve().parent.parent;D=R/'planning';load=lambda n:json.loads((D/n).read_text())
rows=load('difficulty-estimates.json');scale=load('difficulty-scale.json');summary=load('difficulty-summary.json');sources=load('difficulty-sources.json')
claims={r['id']:r for r in json.loads((R/'literature/open-problems.json').read_text())}
assert len(rows)==len(claims)==len({r['claim_id'] for r in rows})==114
assert {r['claim_id'] for r in rows}==set(claims)
for r in rows:
 c=claims[r['claim_id']]
 assert r['title']==c['title'] and r['source_occurrences']==c['occurrences']
 assert r['eligible_in_coverage_inventory']==c['eligible_for_coverage']
 assert r['related_target_ids']==c['related_target_ids']
 assert r['estimate_confidence']=='low' and not r['actual_formalization_status_changed']
 assert r['mathematical_research']['time_to_resolution'] is None
 assert r['rationale'] and r['first_milestone'] and r['evidence_files']
 for key,band in [('specification','spec'),('proof_transfer_given_complete_proof','proof')]:
  v=r[key]
  if r['gate']:assert v is None
  else:assert 1<=v['score']<=5 and v['effort_band']==scale[str(v['score'])][band]
 if c['status_as_of_source']=='withdrawn_historical_only':assert r['gate']
 for p in r['evidence_files']:assert any(s['path']=='Mathlib/'+p for s in sources)
for source in sources:
 p=pathlib.Path('/private/tmp/unl-lean-audit/mathlib4')/source['path']
 if p.exists():assert hashlib.sha256(p.read_bytes()).hexdigest()==source['sha256']
assert summary['eligible_targets']==sum(r['eligible_in_coverage_inventory'] for r in rows)==74
assert summary['formulation_or_historical_holds']==sum(r['gate'] is not None for r in rows)==41
for key,field in [('specification','eligible_specification_tiers'),('proof_transfer_given_complete_proof','eligible_conditional_proof_tiers')]:
 actual=dict(collections.Counter(str(r[key]['score']) if r[key] else 'formulation_required' for r in rows if r['eligible_in_coverage_inventory']))
 assert summary[field]==actual
assert summary['research_resolution_time_estimates_provided']==0
assert summary['new_lean_statements_created']==summary['new_lean_proofs_created']==0
report=(D/'LEAN-DIFFICULTY.md').read_text();page=(D/'difficulty.html').read_text()
for r in rows:assert f"### {r['claim_id']}\n" in report and r['claim_id'] in page
for href in re.findall(r'\]\(([^)]+)\)',report):
 u=urlparse(href)
 if not u.scheme and u.path:assert (D/u.path).exists(),href
assert 'given a complete proof' in report and 'low-confidence' in report
print('Validated 114 difficulty assessments, 74 tracked targets, 41 formulation/historical holds and prerequisite-file hashes. These are historical planning estimates; no research-resolution ETA is supplied.')
