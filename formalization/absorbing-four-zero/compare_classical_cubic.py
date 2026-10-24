"""Find explicit incidence isomorphisms to the author's public classical data."""
from pathlib import Path
import json,itertools,hashlib
P=Path(__file__).resolve().parent
own=json.loads((P/'source140-columns.json').read_text())
raw=P/'classical-cubic-data.txt';published=json.loads(raw.read_text())
published=[[frozenset(c-1 for c in s) for s in rows] for rows in published]
def iso(A,B):
 A=list(map(frozenset,A));B=set(B)
 adjA=lambda u,v:any(u in s and v in s for s in A)
 adjB=lambda u,v:any(u in s and v in s for s in B)
 def dfs(mapping):
  if len(mapping)==10:return dict(mapping)
  rem=set(range(10))-mapping.keys();u=max(rem,key=lambda u:sum(adjA(u,v) for v in mapping))
  for w in set(range(10))-set(mapping.values()):
   if any(adjA(u,v)!=adjB(w,z) for v,z in mapping.items()):continue
   mapping[u]=w
   if all(frozenset(mapping[x] for x in s) in B for s in A if s<=mapping.keys()):
    hit=dfs(mapping)
    if hit:return hit
   del mapping[u]
  return None
 return dfs({})
records=[]
for item in own:
 hits=[]
 for i,ref in enumerate(published):
  m=iso(item['base'],ref)
  if m is not None:
   assert {frozenset(m[x] for x in s) for s in item['base']}==set(ref)
   hits.append(dict(author_configuration_index=i+1,point_map_to_author_1based=[m[x]+1 for x in range(10)],verified_mapped_block_set_equality=True))
 assert len(hits)==1
 records.append(dict(our_label=item['label'],matches=hits))
r=dict(evidence='exact_finite_incidence_isomorphism',source_url='https://web.math.pmf.unizg.hr/~krcko/results/srconf/10-3-3-4.txt',source_sha256=hashlib.sha256(raw.read_bytes()).hexdigest(),primary_paper='Abreu–Funk–Krčadinac–Labbate,arXiv2104.04880v2(2021),publishedDCC90(2022)1881–1897',records=records,conclusion='Both smaller base configurations are explicitly isomorphic to already published author data. No novelty is claimed for the bases or their Pasch counts. The cyclic source-count/M_j bridge is the checked deliverable.')
(P/'classical-cubic-comparison.json').write_text(json.dumps(r,indent=2,ensure_ascii=False)+'\n');print(json.dumps(r,indent=2),flush=True)
