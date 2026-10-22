"""Validate subjective planning records and links; does not validate effort predictions."""
from pathlib import Path
import json,collections,re
from urllib.parse import urlparse
R=Path(__file__).resolve().parent.parent;D=R/'planning'
load=lambda f:json.loads((D/f).read_text())
r=load('current-difficulty-estimates.json');s=load('current-difficulty-summary.json');scale=load('difficulty-scale.json')
claims={c['id']:c for c in json.loads((R/'literature/open-problems.json').read_text())}
assert len(r)==len({x['target_id'] for x in r})==len(claims)==s['entries']==181
assert {x['target_id'] for x in r}==set(claims)
assert sum(x['eligible_for_coverage'] for x in r)==s['eligible_targets']==108
assert sum(x['completed'] for x in r)==s['completed_lean_targets']==1
assert sum(bool(x['gate']) for x in r)==s['gated_entries']==76
assert sum(bool(x['gate']) and x['eligible_for_coverage'] for x in r)==s['eligible_gated_entries']==3
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
assert s['recommendation']=='L-P34-girth-eight' and s['no_new_lean_statements_or_proofs']
for file in ['NEXT-PROJECT.md','CURRENT-DIFFICULTY.md']:
 doc=(D/file).read_text()
 for href in re.findall(r'\]\(([^)]+)\)',doc):
  u=urlparse(href)
  if not u.scheme and u.path:assert (D/u.path).exists(),href
report=(D/'CURRENT-DIFFICULTY.md').read_text();page=(D/'current-difficulty.html').read_text()
for x in r:assert f'### {x["target_id"]}\n' in report and x['target_id'] in page
assert 'given a correct complete proof' in (D/'NEXT-PROJECT.md').read_text()
print('Validated 181 current assessments, 67 additions, 108 eligible targets, one completed target, scope gates and unestimated discovery times.')
