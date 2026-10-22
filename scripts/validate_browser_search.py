"""Check browser-pass bookkeeping/provenance; does not certify published mathematics."""
from pathlib import Path
import hashlib
import json
from urllib.parse import urlparse
import re
R=Path(__file__).resolve().parent.parent
D=R/'literature'
load=lambda n:json.loads((D/n).read_text())
audit=load('browser-search-review.json')
rows={r['id']:r for r in load('open-problems.json')}
manifest={m['paper_id']:m for m in load('downstream-source-manifest.json')}
assert set(audit['baseline']['canonical_ids']).isdisjoint(audit['added_target_ids'])
assert set(audit['baseline']['canonical_ids'])|set(audit['added_target_ids'])==set(rows)
assert len(audit['added_paper_ids'])==6
assert len(audit['added_target_ids'])==audit['added_entries']==10
added=[rows[k] for k in audit['added_target_ids']]
assert sum(r['eligible_for_coverage'] for r in added)==audit['added_eligible_targets']==7
for r in added:
 assert r['lean_statement_status']==r['lean_proof_status']=='not_assessed_in_this_extension'
 assert not r.get('verified_artifact')
 for o in r['occurrences']:
  assert o['source_id'] in audit['added_paper_ids']
  assert o['source_sha256']==manifest[o['source_id']]['sha256']
for pid in audit['added_paper_ids']:
 m=manifest[pid]
 for key,hkey in [('local_file','sha256'),('extracted_text_file','extracted_text_sha256')]:
  p=R/m[key]
  if p.exists():assert hashlib.sha256(p.read_bytes()).hexdigest()==m[hkey]
queries=load('browser-searches.json')['searches']
assert sum(q['service']=='Google Scholar' for q in queries)==14
assert sum(q['service']=='X' for q in queries)==5
assert all(q['access']=='successful_in_Edge' for q in queries)
assert len(audit['pending_candidates'])==9
assert len(rows['L-F24-C1.15']['occurrences'])==2
assert rows['L-F24-C1.15']['current_resolution_status']=='later_weaker_bound_in_primary_literature'
assert any('irsi.ai' in e['url'] for e in rows['L-P32-triangle-bound']['later_evidence'])
for href in re.findall(r'\]\(([^)]+)\)',(D/'BROWSER-SEARCH.md').read_text()):
 u=urlparse(href)
 if not u.scheme and u.path:assert (D/u.path).exists(),href
print('Validated 14 Scholar views, five X queries, six screened papers, ten entries, seven eligible targets and preserved unassessed Lean status.')
