from pathlib import Path
import itertools,json
import numpy as np
W=Path(__file__).resolve().parent;n=27;S={0,1,3,11};T={0,5,12,18};vars=[(b,j)for b in [False,True]for j in range(n)]
H=np.array([[int(((j-c)%n in T)if b else((c-j)%n in S))for b,j in vars]for c in range(n)],dtype=np.int64)
Z=np.array([[int(((j-c)%n in S)if b else((c-j)%n in T))for b,j in vars]for c in range(n)],dtype=np.int64)
assert not np.any((H@Z.T)%2);assert np.all(H.sum(axis=0)==4)and np.all(H.sum(axis=1)==8)
G=H.T@H;assert np.max(G-np.diag(np.diag(G)))==1
M4=int(np.sum((H@H.T)**2));assert M4==2376
witness=None;tested=0
for root in [0,27]:
 neighbors=[j for j in range(54)if j!=root and G[root,j]==1]
 for four in itertools.combinations(neighbors,4):
  if any(G[a,b]!=1 for a,b in itertools.combinations(four,2)):continue
  tested+=1;U=[root,*four];counts=H[:,U].sum(axis=1)
  if np.all((counts==0)|(counts==2)):
   witness=U;break
 if witness is not None:break
r=dict(status='passed',n=n,N=54,S=sorted(S),T=sorted(T),fourth_moment=M4,eta_diagnostic=float(np.linalg.eigvalsh(H@H.T)[-2]),search_scope='First found rooted five-clique with all selected check degrees0/2; not exhaustive absence.',cliques_tested=tested,weight_five_witness=None if witness is None else[vars[i]for i in witness])
(W/'practical27-crosscheck.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r))
