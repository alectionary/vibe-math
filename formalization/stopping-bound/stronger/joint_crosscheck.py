from pathlib import Path
import numpy as np,json,collections
W=Path(__file__).resolve().parent;out=[]
for gamma in [2,4,6,8]:
 for t in [0,1,2]:
  n=3**(2*gamma)*(2*t+1);S=[3**i for i in range(gamma)];T=[3**(gamma+i)for i in range(gamma)];g=collections.Counter((a-b)%n for U in[S,T]for a in U for b in U)
  assert g[0]==2*gamma and max(v for k,v in g.items()if k)!=0
  assert all(v==1 for k,v in g.items()if k)
  moment=n*sum(x*x for x in g.values());assert moment==2*n*gamma*(3*gamma-1)
  row=dict(gamma=gamma,n=n,t=t,row_weight=2*gamma,variables=2*n,stopping_guarantee=gamma+1,fourth_moment=moment,off_diagonal_check_overlap_max=1)
  if gamma==2 and t==0:
   i=np.arange(n);A=np.isin((i[:,None]-i[None,:])%n,S).astype(np.int64);B=np.isin((i[:,None]-i[None,:])%n,T).astype(np.int64);H=np.c_[A,B.T];Z=np.c_[B,A.T];assert np.all(H@Z.T%2==0)
   u=(i<40).astype(np.int64);v=((40<=i)&(i<80)).astype(np.int64);x=H.T@u;y=H.T@v;cert=[int(u@u),int(v@v),int(u@v),int(x@x),int(y@y),int(x@y)];assert cert==[40,40,0,280,280,38];eta=float(np.linalg.eigvalsh(H@H.T)[-2]);row.update(two_plane_certificate=cert,eta_diagnostic=eta,zhu_diagnostic=[162*(4-eta)/(8-eta),324*(6-eta)/(4*(8-eta))],css_exact=True)
  out.append(row)
(W/'joint-crosscheck.json').write_text(json.dumps(dict(status='passed',families=out,numerics_not_proof_premises=True),indent=2)+'\n');print('12 exact sparse moment/family checks passed; actual n81 binary CSS and two-plane certificate independently reconstructed.')
