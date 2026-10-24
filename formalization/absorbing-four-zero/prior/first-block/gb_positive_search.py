"""Bounded exact (4,2) search in scalar-frequency GB subfamily."""
from itertools import combinations
from collections import defaultdict
from pathlib import Path
import json,time
from research import check_graph,rooted_counts,direct_counts
ROOT=Path(__file__).resolve().parent

def canonical(s,n):return min(tuple(sorted((x-t)%n for x in s)) for t in s)
def triples(n):
 ans=set()
 for a,b in combinations(range(1,n),2):
  s=(0,a,b);ds=[(x-y)%n for x in s for y in s if x!=y]
  if len(set(ds))==6:ans.add(canonical(s,n))
 return sorted(ans)
def cols(a,b,n):return [frozenset((t+x)%n for x in s) for s in [a,tuple(-x%n for x in b)] for t in range(n)]
def key(s,n):return frozenset((x-y)%n for x in s for y in s if x!=y)
def pgcd(a,b):
 while b:
  while a.bit_length()>=b.bit_length():a ^= b << (a.bit_length()-b.bit_length())
  a,b=b,a
 return a
def logical(a,b,n):
 return 2*(pgcd(pgcd(sum(1<<x for x in a),sum(1<<x for x in b)),(1<<n)|1).bit_length()-1)
def main():
 summary=[];start=time.monotonic()
 for n in range(13,66):
  ts=triples(n);diff={s:key(s,n) for s in ts};buckets=defaultdict(list);valid=0;tested=0
  for i,a in enumerate(ts):
   for b in ts[i:]:
    if diff[a]&diff[b]:continue
    valid+=1;dimension=logical(a,b,n)
    if dimension==0:continue
    k=(dimension,tuple(sorted(diff[a]|diff[b])));previous=buckets[k]
    if previous:
     counts,_,_=rooted_counts(cols(a,b,n));value=counts.get(2,0);tested+=1
     if previous[0]['N42'] is None:
      pa,pb=previous[0]['a'],previous[0]['b'];pc,_,_=rooted_counts(cols(pa,pb,n));previous[0]['N42']=pc.get(2,0)
     if value!=previous[0]['N42']:
      old=previous[0];w=dict(ell=n,common_nonzero_difference_support=k[1],logical_dimension=dimension,A=old,B=dict(a=a,b=b,N42=value),valid_pairs_seen=valid,bounded_search=True)
      for side in ['A','B']:
       q=w[side];C=cols(q['a'],q['b'],n);check_graph(C);dc,_=direct_counts(C);assert dc.get(2,0)==q['N42'];q['direct_counts']=dc
      (ROOT/'gb-positive-matched-witness.json').write_text(json.dumps(w,indent=2)+'\n');print(json.dumps(w),flush=True)
      (ROOT/'gb-positive-search-summary.json').write_text(json.dumps(dict(completed_lengths=summary,found_at=n,seconds=time.monotonic()-start),indent=2)+'\n');return
    previous.append(dict(a=a,b=b,N42=None))
  row=dict(ell=n,triples=len(ts),valid_pairs=valid,Gram_keys=len(buckets),additional_collisions_tested=tested);summary.append(row);print(json.dumps(row),flush=True)
 (ROOT/'gb-positive-search-summary.json').write_text(json.dumps(dict(completed_lengths=summary,seconds=time.monotonic()-start),indent=2)+'\n')
if __name__=='__main__':main()
