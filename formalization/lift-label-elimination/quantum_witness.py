"""Definition-based exact CSS/rank/support verification of lifted ten-point bases."""
from pathlib import Path
import json,itertools,collections,hashlib,math
from research import BASES,pasches,cycle_rows,balanced,count,edges
P=Path(__file__).resolve().parent
def rank(rows):
 basis={}
 for x in rows:
  while x:
   i=x.bit_length()-1
   if i in basis:x^=basis[i]
   else:basis[i]=x;break
 return len(basis)
def basis_rows(rows):
 basis={}
 for x in rows:
  while x:
   i=x.bit_length()-1
   if i in basis:x^=basis[i]
   else:basis[i]=x;break
 return basis
def reduce_word(x,basis):
 for i in sorted(basis,reverse=True):
  if x>>i&1:x^=basis[i]
 return x
def transpose(cols,m):return [sum(1<<v for v,c in enumerate(cols) if r in c) for r in range(m)]
def matrices(base,z,N):
 n=len(base);es=edges(base);idx={e:i for i,e in enumerate(es)}
 # X=[A(x)|I tensor B*], Z=[I tensor B|A(x)*]. Column indexing:
 # left(v,t),right(c,t); check indices X(c,a), Z(v,a).
 X=[{c*N+(t+z[idx[v,c]])%N for c in base[v]} for v in range(n) for t in range(N)]
 X += [{c*N+(t-e)%N for e in [0,1,3]} for c in range(n) for t in range(N)]
 Z=[{v*N+(t+e)%N for e in [0,1,3]} for v in range(n) for t in range(N)]
 Z += [{v*N+(t-z[idx[v,c]])%N for v in range(n) if c in base[v]} for c in range(n) for t in range(N)]
 return X,Z
def analyze(N,z):
 base=BASES['star'];X,Z=matrices(base,z,N);m=10*N;n=len(X)
 for cols in [X,Z]:
  assert all(len(c)==3 for c in cols);assert all(sum(r in c for c in cols)==6 for r in range(m))
  assert all(len(c&d)<=1 for c,d in itertools.combinations(cols,2))
 rx,rz=transpose(X,m),transpose(Z,m)
 assert all((x&z).bit_count()%2==0 for x in rx for z in rz)
 ranks=rank(rx),rank(rz);cx,cz=count(X),count(Z)
 right=[{(t-e)%N for e in [0,1,3]} for t in range(N)];cb=count(right)
 leftz=count(X[:m]);assert cx==leftz+10*cb
 dual=[{v for v in range(10) if c in base[v]} for c in range(10)]
 dualz=[-z[edges(base).index((v,c))] for c in range(10) for v in sorted(dual[c])]
 jx=sum(balanced(cycle_rows(base,s),z,N) for s in pasches(base));jz=sum(balanced(cycle_rows(dual,s),dualz,N) for s in pasches(dual))
 assert cx==N*jx+10*cb and cz==N*jz+10*cb
 logical=[]
 if N==14:
  for sector,checks,stab in [('Xkernel',rx,rz),('Zkernel',rz,rx)]:
   basis=basis_rows(stab);hit=None
   for t in range(N):
    for vs in itertools.combinations(range(10),6):
     support=[v*N+t for v in vs];word=sum(1<<v for v in support)
     if all((r&word).bit_count()%2==0 for r in checks) and reduce_word(word,basis):hit=support;break
    if hit:break
   if hit:logical.append(dict(kernel=sector,weight=6,support=hit,zero_syndrome=True,outside_opposite_row_span=True))
 return dict(N=N,variables=n,X_checks=m,Z_checks=m,rank_X=ranks[0],rank_Z=ranks[1],logical_qubits=n-sum(ranks),column_weight=3,row_weight=6,no_Tanner_four_cycles=True,CSS_commutation_all_row_pairs=True,N40_X=cx,N40_Z=cz,right_block_N40=cb,left_balanced_Pasches=jx,dual_balanced_Pasches=jz,weight_six_logicals=logical,nonzero_labels=[dict(variable=v,check=c,shift=z[i]) for i,(v,c) in enumerate(edges(base)) if z[i]%N],columns_X=[sorted(c) for c in X],columns_Z=[sorted(c) for c in Z])
def main():
 records=[]
 for N,chosen in [(7,[]),(8,[(0,0,1),(4,6,1)]),(14,[(0,0,7),(4,6,7)])]:
  z=[0]*30
  for v,c,t in chosen:z[edges(BASES['star']).index((v,c))]=t
  r=analyze(N,z);records.append(r)
 assert records[-1]['logical_qubits']==18 and records[-1]['N40_X']==records[-1]['N40_Z']==0
 assert records[1]['logical_qubits']==0
 out=dict(evidence='exact_finite_binary_matrix_certificate',conclusion='The N=14 CSS model is [[280,18,6]] and has no elementary (4,0) support in either Tanner graph. The independent C++ verifier checks the matrix definitions, ranks, commutation, every four-subset, and a weight-six logical. Cubicity excludes odd kernel weights and linearity excludes weight two. No decoder-performance claim.',records=records,script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest())
 (P/'quantum-witness.json').write_text(json.dumps(out,indent=2)+'\n')
 print(json.dumps({k:v for k,v in out.items() if k!='records'}));print(json.dumps([{k:v for k,v in r.items() if not k.startswith('columns')} for r in records]),flush=True)
 with (P/'quantum280-input.txt').open('w') as f:
  for cols in [records[-1]['columns_X'],records[-1]['columns_Z']]:
   f.write('280 140\n');f.write('\n'.join(' '.join(map(str,c)) for c in cols)+'\n')
if __name__=='__main__':main()
