from pathlib import Path
import json,numpy as np
W=Path(__file__).resolve().parent
out=[]
for t in range(1,9):
 n=39*t;idx=np.arange(n);A=np.isin((idx[:,None]-idx[None,:])%n,[0,1,4,6]).astype(np.int64);H=np.concatenate([A,A.T],axis=1);B=np.concatenate([A,A],axis=1);Z=np.concatenate([A.T,A.T],axis=1)
 u=(idx%39<13).astype(np.int64);v=((13<=idx%39)&(idx%39<26)).astype(np.int64);x=H.T@u;y=H.T@v
 cert=[int(u@u),int(v@v),int(u@v),int(x@x),int(y@y),int(x@y)];assert cert==[13*t,13*t,0,332*t,332*t,42*t]
 twin=np.zeros(2*n,dtype=np.int64);twin[[0,n]]=1;assert np.all((B@twin)%2==0);assert sum(twin[:n])%2==1;assert np.all(Z[:,:n].sum(axis=1)%2==0)
 out.append(dict(n=n,t=t,certificate=cert,gram_equal=bool(np.array_equal(H@H.T,B@B.T)),bad_css=bool(np.all(B@Z.T%2==0)),bad_logical_parity=1))
powers=[]
for d in range(1,7):
 gamma=2*d;n=3**gamma;S=[3**i for i in range(gamma)];sums=[x+y for i,x in enumerate(S)for y in S[i:]];assert len(set(sums))==len(sums) and max(sums)<n;assert gamma*3**d<=n
 powers.append(dict(d=d,column_weight=gamma,rows=n,variables=2*n,certified_stopping_and_kernel_guarantee=d+1,partition_guarantee=(2*(gamma+1)+2)//3,density_certificate=gamma*3**d<=n))
r=dict(status='passed',spectral_covers=out,powers_growth=powers,numerics_not_a_proof_premise=True)
(W/'phase2-crosscheck.json').write_text(json.dumps(r,indent=2)+'\n');print('8 exact integer cover certificates and6 power-family parameter checks passed.')
