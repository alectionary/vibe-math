#!/usr/bin/env python3
"""Independent finite controls for the local basis-exchange repair lemma.

The reference uses literal rank tests for every possible exchange. No global
termination claim is tested or inferred: each sampled state gets one certified
step, a directly replayed rank cut, or is already matched.
"""
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations,product
from collections import Counter,deque
import argparse,hashlib,json,time,io,contextlib
from singleton_basis_exchange_repair import ExactRepair
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def rank(vectors):
 rows={}
 for v in vectors:
  while v:
   p=v&-v
   if p in rows:v^=rows[p]
   else:rows[p]=v;break
 return len(rows)
def marginal(E,w):return {j:sum(m for B,m in w.items() if j in B) for j in E}
def graph(V,E,w,r):
 edges={}
 for B,m in w.items():
  assert m>0
  for i in B:
   for j in E:
    if j not in B and rank(V[k] for k in set(B)-{i}|{j})==r:edges.setdefault((i,j),[]).append(B)
 return edges
def reachable(E,edges,S):
 R=set(S);queue=deque(S)
 while queue:
  i=queue.popleft()
  for j in E:
   if (i,j) in edges and j not in R:R.add(j);queue.append(j)
 return R
def validate_step(V,E,w,q,r):
 obj=ExactRepair(V,E,q,w,r);x=marginal(E,w);assert obj.x==x;S={j for j in E if x[j]>q[j]};D={j for j in E if x[j]<q[j]}
 if not S:assert not D;return 'matched',0
 edges=graph(V,E,w,r);R=reachable(E,edges,S);ordered=sorted(w);path,failure=obj.direct(sorted(S),sorted(D),ordered,float('inf'));assert failure is None
 if path is None:path,gotR,failure=obj.path(sorted(S),sorted(D),ordered,float('inf'));assert failure is None
 if path is None:
  assert gotR==R and not(R&D);C=set(E)-R;bound=rank(V[j] for j in C);assert all(len(set(B)&C)==bound for B in w);assert sum(x[j] for j in C)==bound<sum(q[j] for j in C)
  return 'rank_cut',len(edges)
 assert R&D
 for i,j,B in path:assert B in edges[i,j]
 count=Counter(B for i,j,B in path);delta=min(x[path[0][0]]-q[path[0][0]],q[path[-1][1]]-x[path[-1][1]],*(w[B]/m for B,m in count.items()));assert delta>0
 expected=Counter(w)
 for B,m in count.items():expected[B]-=m*delta
 for i,j,B in path:expected[tuple(sorted(set(B)-{i}|{j}))]+=delta
 expected={B:m for B,m in expected.items() if m};got,multiplicity=obj.update(path);assert got==delta and multiplicity==max(count.values()) and obj.w==expected;assert all(m>0 and rank(V[j] for j in B)==r for B,m in obj.w.items()) and sum(obj.w.values())==1
 y=marginal(E,expected);assert obj.x==y;change={j:y[j]-x[j] for j in E if y[j]!=x[j]};assert change=={path[0][0]:-delta,path[-1][1]:delta};assert sum(abs(y[j]-q[j]) for j in E)==sum(abs(x[j]-q[j]) for j in E)-2*delta
 return 'path_step',len(edges)

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();cases=Counter();edges=0
 for V in ([1,2,3],[1,3,2,3],[0,1,2,3],[1,2,4,3,5,6,7]):
  E=list(range(len(V)));r=rank(V);bases=[tuple(B) for B in combinations(E,r) if rank(V[j] for j in B)==r]
  if len(V)<=4:
   mixtures=[{B:Q(1)} for B in bases]+[{B:Q(1,2),C:Q(1,2)} for B,C in combinations(bases,2)]+[{B:Q(1,len(bases)) for B in bases}];targets=[dict(zip(E,map(lambda x:Q(x,4),v))) for v in product(range(5),repeat=len(E)) if sum(v)==4*r]
  else:
   mixtures=[{B:Q(1)} for B in bases[:8]]+[{bases[i]:Q(1,3),bases[i+1]:Q(2,3)} for i in range(8)]+[{B:Q(1,len(bases)) for B in bases}];targets=[{j:Q(j in B) for j in E} for B in combinations(E,r)]+[marginal(E,w) for w in mixtures]
  for w in mixtures:
   for q in targets:
    status,n=validate_step(V,E,w,q,r);cases[status]+=1;edges+=n
 # Repeated original basis: the total outgoing allocation must be divided by
 # multiplicity even when one generated basis coincides with an old basis.
 V=[1,3,2,3];E=list(range(4));B=(0,2);C=(0,1);w={B:Q(1,3),C:Q(2,3)};x=marginal(E,w);q=dict(x);q[0]-=Q(1,4);q[3]+=Q(1,4);obj=ExactRepair(V,E,q,w,2);path=[(0,1,B),(1,2,C),(2,3,B)];delta,m=obj.update(path);assert delta==Q(1,6) and m==2 and obj.x==marginal(E,obj.w);unsafe=Q(1,4);assert w[B]-2*unsafe<0
 # Literal closed reachability gives the parallel-class rank cut.
 w={(0,1):Q(1,2),(2,3):Q(1,2)};q={0:Q(1,4),1:Q(3,4),2:Q(1,4),3:Q(3,4)};obj=ExactRepair(V,E,q,w,2)
 with contextlib.redirect_stdout(io.StringIO()):reason,_=obj.run(seconds=10,max_iterations=1)
 assert reason=='EXACT_REACHABILITY_RANK_CUT' and obj.cut['indices']==[1,3] and obj.cut['bound']==1 and Q(obj.cut['conditional_violation'])==Q(1,2)
 # Omitting all edges would manufacture a false reachability obstruction in
 # this feasible state; direct rank replay rejects that proposed cut.
 w={(0,2):Q(1)};q={0:Q(0),1:Q(1),2:Q(1),3:Q(0)};x=marginal(E,w);fakeR={0};complement=set(E)-fakeR;assert sum(q[j] for j in complement)>sum(x[j] for j in complement) and sum(q[j] for j in complement)<=rank(V[j] for j in complement)
 out=dict(status='PASS_LOCAL_EXCHANGE_REPAIR_LEMMA_CONTROLS',source_C16_answered=False,producer_sha256=sha(ROOT/'singleton_basis_exchange_repair.py'),consumer_sha256=sha(Path(__file__)),state_results=dict(cases),total_states=sum(cases.values()),literal_exchange_edges_checked=edges,repeated_basis_multiplicity_control={'path_length':3,'maximum_multiplicity':2,'safe_delta':'1/6','unsafe_delta_without_multiplicity':'1/4','unsafe_old_basis_weight':'-1/6'},closed_reachability_control={'complement':[1,3],'physical_rank':1,'exact_target_mass':'3/2'},incomplete_graph_false_cut_rejected_by_direct_rank=True,elapsed_seconds=time.monotonic()-start,scope='One-step validity and closed-set rank certificate only. Complete exchange reachability, exact positive basis weights and equal totalmasses are required. Strict L1decrease gives no finite orpolynomial globaltermination claim.')
 a.output.write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
