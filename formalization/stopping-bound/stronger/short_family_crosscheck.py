from pathlib import Path
import json,itertools
import numpy as np
W=Path(__file__).resolve().parent;S={0,1,3,11};T={0,5,12,18};rows=[]
for n in [27,37,39,41,43,45,47,49,51,53,55,57,111]:
 vars=[(b,j)for b in [False,True]for j in range(n)]
 H=np.array([[int(((j-c)%n in T)if b else((c-j)%n in S))for b,j in vars]for c in range(n)],dtype=np.int64)
 Z=np.array([[int(((j-c)%n in S)if b else((c-j)%n in T))for b,j in vars]for c in range(n)],dtype=np.int64)
 Q=H.T@H;np.fill_diagonal(Q,0)
 assert Q.max()==1 and not np.any((H@Z.T)%2)
 assert np.all(H.sum(axis=0)==4)and np.all(H.sum(axis=1)==8)
 assert int(np.sum((H@H.T)**2))==88*n
 # Complete small-instance rank check, diagnostic only.
 B=(H.copy()%2).astype(np.uint8);rank=0
 for j in range(2*n):
  piv=next((i for i in range(rank,n)if B[i,j]),None)
  if piv is None:continue
  B[[rank,piv]]=B[[piv,rank]]
  for i in range(n):
   if i!=rank and B[i,j]:B[i]^=B[rank]
  rank+=1
 rows.append(dict(n=n,N=2*n,css=True,column_degree=4,row_degree=8,max_overlap=1,fourth_moment=88*n,binary_rank_diagnostic=rank,eta_diagnostic=float(np.linalg.eigvalsh(H@H.T)[-2])))
result=dict(status='passed',role='Independent diagnostics, not Lean proof premises',NS=sorted(S),NT=sorted(T),families=rows)
(W/'short-family-crosscheck.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))
