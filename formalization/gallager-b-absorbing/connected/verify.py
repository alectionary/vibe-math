"""Independent matrix, reachable first-step and physical-indecomposability audit.

No imports from search.py or Lean data generators. Literal simplex rows and a
separate list-based message implementation reconstruct every input execution.
"""
from pathlib import Path
from itertools import product
import json,hashlib,collections,argparse
R=Path(__file__).resolve().parent
H=[[int(b) for b in s] for s in ['1010101','0110011','1100110','0001111','1011010','0111100','1101001']]
# Physical order: A1..A7,B1..B7,C. Apply A1->B1 and C->B1 to the base CSS pair.
def Xgate(row,c,t):
 row=row[:];row[t]^=row[c];return row
def Zgate(row,c,t):
 row=row[:];row[c]^=row[t];return row
baseX=[r+[0]*8 for r in H]+[[0]*7+r+[0] for r in H]+[[0]*14+[1]]
baseZ=[r+[0]*8 for r in [H[0],H[1],H[3],[1]*7]]+[[0]*7+r+[0] for r in [H[0],H[1],H[3]]]
X=[Xgate(Xgate(r,0,7),14,7) for r in baseX]
Z=[Zgate(Zgate(r,0,7),14,7) for r in baseZ]
def mask(r):return sum(x<<i for i,x in enumerate(r))
def span(rows):
 result={tuple([0]*15)}
 for r in rows:result|={tuple(a^b for a,b in zip(w,r)) for w in result}
 return result
SX=span(X);SZ=span(Z)
assert len(SX)==len(SZ)==128
assert all(sum(a*b for a,b in zip(x,z))%2==0 for x in X for z in Z)
assert len({tuple(r) for r in X})==15
# Actual graph includes all15 check and all15 variable vertices.
adj=[set() for _ in range(30)]
for c,row in enumerate(X):
 for v,b in enumerate(row):
  if b:adj[v].add(15+c);adj[15+c].add(v)
seen={0};todo=[0]
for u in todo:
 for v in adj[u]-seen:seen.add(v);todo.append(v)
assert len(seen)==30
for v in range(7):
 even=sum(row[v] and sum(row[:7])%2==0 for row in X)
 odd=sum(row[v] and sum(row[:7])%2==1 for row in X)
 assert even>odd and odd==0

def synd(e):return [sum(a*b for a,b in zip(row,e))%2 for row in X]
def majority(bs):return int(2*sum(bs)>len(bs))
records=[]
for small in product((0,1),repeat=7):
 error=list(small)+[0]*8;s=synd(error)
 # At the initial zero variable state every incident check sends its syndrome.
 check=[[s[c] if X[c][v] else 0 for v in range(15)] for c in range(15)]
 hard=[majority([check[c][v] for c in range(15) if X[c][v]]) for v in range(15)]
 outgoing=[[majority([check[d][v] for d in range(15) if X[d][v] and d!=c]) if X[c][v] else 0 for v in range(15)] for c in range(15)]
 edge=[sum(row)%2 for row in outgoing]
 assert synd(hard)==s and edge==s
 terminal=hard if any(s) else [0]*15
 residual=[a^b for a,b in zip(error,terminal)]
 assert tuple(residual) in SZ
 records.append(dict(input=mask(error),syndrome=mask(s),hard=mask(hard),outgoing=[mask(r) for r in outgoing],edge_syndrome=mask(edge),terminal=mask(terminal),residual=mask(residual),iterations=int(any(s))))
# Independently find a spanning tree of actual two-coordinate X/Z overlaps.
possible=[]
for c,x in enumerate(X):
 for d,z in enumerate(Z):
  meet=[v for v in range(15) if x[v] and z[v]]
  if len(meet)==2:possible.append((meet[0],meet[1],c,d))
reached={0};tree=[]
while len(reached)<15:
 edge=next((u,v,c,d) for u,v,c,d in possible if (u in reached)!=(v in reached))
 u,v,c,d=edge;tree.append(dict(u=u,v=v,xrow=c,zrow=d));reached|={u,v}
# Every nontrivial cut separates an actual overlap edge, whose restrictions
# anticommute; no decomposition of the stabilizer space across that cut exists.
for cut in range(1,32767):
 e=next(e for e in tree if ((cut>>e['u'])^(cut>>e['v']))&1)
 x=X[e['xrow']];z=Z[e['zrow']]
 assert sum(x[v]*z[v]*((cut>>v)&1) for v in range(15))%2==1
logicalZ=[(32641>>v)&1 for v in range(15)];logicalX=[(16256>>v)&1 for v in range(15)]
assert all(sum(a*b for a,b in zip(row,logicalZ))%2==0 for row in X)
assert all(sum(a*b for a,b in zip(row,logicalX))%2==0 for row in Z)
assert sum(a*b for a,b in zip(logicalX,logicalZ))%2==1
assert tuple(logicalZ) not in SZ and tuple(logicalX) not in SX
localX=[mask(w) for w in SX if not any(w[7:])];localZ=[mask(w) for w in SZ if not any(w[7:])]
assert len(localX)==4 and len(localZ)==16
candidate=json.loads((R/'candidate15.json').read_text())
assert candidate['HX']==list(map(mask,X)) and candidate['HZ']==list(map(mask,Z))
summary=dict(qubits=15,encoded_qubits=1,selected_variables=7,input_errors=128,initial_acceptances=sum(r['iterations']==0 for r in records),first_iteration_acceptances=sum(r['iterations']==1 for r in records),hard_mismatches=0,edge_mismatches=0,quantum_failures=0,distinct_decoding_checks=15,decoding_graph_vertices=30,connected_vertices=len(seen),nontrivial_physical_cuts=32766,cuts_obstructed=32766,local_stabilizer_rank=6,max_X_row_weight=max(map(sum,X)),max_X_column_weight=max(sum(row[v] for row in X) for v in range(15)),rank_X=7,rank_Z=7)
payload=dict(schema=1,HX=X,HZ=Z,selected_support=list(range(7)),all_inputs=records,overlap_spanning_tree=tree,local_X_words=sorted(localX),local_Z_words=sorted(localZ),logical_X=logicalX,logical_Z=logicalZ,summary=summary)
serialized=json.dumps(payload,indent=2)+'\n'
p=argparse.ArgumentParser();p.add_argument('--check',action='store_true');args=p.parse_args()
if args.check:assert (R/'certificate.json').read_text()==serialized
else:(R/'certificate.json').write_text(serialized)
print(json.dumps(summary,sort_keys=True));print('certificate SHA256',hashlib.sha256(serialized.encode()).hexdigest())
