"""Validate subjective planning records and links; does not validate effort predictions."""
from pathlib import Path
import json,collections,re
from urllib.parse import urlparse
R=Path(__file__).resolve().parent.parent;D=R/'planning'
load=lambda f:json.loads((D/f).read_text())
r=load('current-difficulty-estimates.json');s=load('current-difficulty-summary.json');scale=load('difficulty-scale.json')
claims={c['id']:c for c in json.loads((R/'literature/open-problems.json').read_text())}
assert len(r)==len({x['target_id'] for x in r})==len(claims)==s['entries']==181+s.get('unassessed_added_entries',0)
assert {x['target_id'] for x in r}==set(claims)
extensions=json.loads((R/'literature/research-reconciliation.json').read_text()).get('indexing_extensions',[])
assert sum(x['eligible_for_coverage'] for x in r)==s['eligible_targets']==111+sum(x['added_eligible_targets'] for x in extensions)
assert sum(x['completed'] for x in r)==s['completed_lean_targets']==4
assert sum(bool(x['gate']) for x in r)==s['gated_entries']==76+s.get('unassessed_added_entries',0)
assert sum(bool(x['gate']) and x['eligible_for_coverage'] for x in r)==s['eligible_gated_entries']==6+sum(x['added_eligible_targets'] for x in extensions)
assert s['newly_assessed_entries']==67 and s['historical_priors_retained']==114
for x in r:
 c=claims[x['target_id']]
 for key in ['title','eligible_for_coverage','lean_statement_status','lean_proof_status','current_resolution_status']:assert x[key]==c[key]
 assert x['source_occurrences']==c['occurrences']
 assert x['confidence']=='low' and x['discovery_time_estimate'] is None
 assert x['rationale'] and x['first_milestone'] and x['basis']
 for key,band in [('statement_setup','spec'),('proof_transfer_given_correct_complete_proof','proof')]:
  if x['gate']:assert x[key] is None
  elif x['completed']:assert x[key]['tier']==0 and x['lean_proof_status']=='verified_complete_lean_proof'
  else:assert x[key]['band']==scale[str(x[key]['tier'])][band]
 if not x['eligible_for_coverage']:assert x['gate']
for key,field in [('statement_setup','statement_tiers'),('proof_transfer_given_correct_complete_proof','conditional_proof_tiers')]:
 assert dict(collections.Counter(str(x[key]['tier']) if x[key] else 'hold' for x in r if x['eligible_for_coverage']))==s[field]
assert s['recommendation']=='L-P11-forbidden' and not s['no_new_lean_statements_or_proofs']
assert s['recommendation_status']=='selected_project_completed_for_recorded_cycle_scope'
for file in ['NEXT-PROJECT.md','CURRENT-DIFFICULTY.md']:
 doc=(D/file).read_text()
 for href in re.findall(r'\]\(([^)]+)\)',doc):
  u=urlparse(href)
  if not u.scheme and u.path:assert (D/u.path).exists(),href
report=(D/'CURRENT-DIFFICULTY.md').read_text();page=(D/'current-difficulty.html').read_text()
for x in r:assert f'### {x["target_id"]}\n' in report and x['target_id'] in page
assert 'given a correct complete proof' in (D/'NEXT-PROJECT.md').read_text()
assert sum(x['research_status']=='planning_not_yet_assessed' for x in r)==s['unassessed_added_entries']==6+sum(x['added_entries'] for x in extensions)
print(f'Validated {len(r)} planning records, including {s["unassessed_added_entries"]} explicitly unassessed additions, {s["eligible_targets"]} eligible targets and four completed targets.')
