"""Original bounded exact-arithmetic checks; no fitting or copied upstream code."""
from fractions import Fraction as F
from pathlib import Path
import json, hashlib
ROOT=Path(__file__).resolve().parents[1]
def matmul(a,b): return [[sum((x*y for x,y in zip(row,col)),F(0)) for col in zip(*b)] for row in a]
def transpose(a): return list(map(list,zip(*a)))
def inverse(a):
 n=len(a); a=[list(row)+[F(i==j) for j in range(n)] for i,row in enumerate(a)]
 for k in range(n):
  assert a[k][k]!=0
  v=a[k][k];a[k]=[z/v for z in a[k]]
  for i in range(n):
   if i!=k:
    v=a[i][k]; a[i]=[z-v*w for z,w in zip(a[i],a[k])]
 return [row[n:] for row in a]
def condvar(S,i,obs):
 if not obs:return S[i][i]
 c=[[S[i][j] for j in obs]];v=[[S[j][k] for k in obs] for j in obs]
 return S[i][i]-matmul(matmul(c,inverse(v)),transpose(c))[0][0]
checks=[]
for q in range(1,6):
 for rho in [F(1),F(1,2)]:
  W=[[F(1) if i==j else F(1,10) for j in range(q)]for i in range(q)]
  B=[[F(1) if i==j else F(1,2) for j in range(q)]for i in range(q)]
  S=[[W[i][j]+B[i][j] for j in range(q)]for i in range(q)]
  X=[[S[i%q][j%q] if i//q==j//q else B[i%q][j%q] for j in range(2*q)]for i in range(2*q)]
  beta=[F(j+1,q+2) for j in range(q)]
  ace=F(1);ac=rho*F(1,2)+F(3,10)
  base=[[F(0) for j in range(2+2*q)]for i in range(2+2*q)]
  base[0][0]=base[1][1]=ace;base[0][1]=base[1][0]=ac
  for i in range(2*q):
   for j in range(2*q):base[i+2][j+2]=X[i][j]
  L=[[F(i==j) for j in range(2+2*q)]for i in range(2+2*q)]
  for j in range(q):L[0][2+j]=L[1][2+q+j]=beta[j]
  generated=matmul(matmul(L,base),transpose(L))
  sb=matmul(S,[[x]for x in beta]);bb=matmul(B,[[x]for x in beta])
  v=ace+sum(beta[j]*sb[j][0]for j in range(q));k=ac+sum(beta[j]*bb[j][0]for j in range(q))
  expected=[[v,k]+[z[0]for z in sb]+[z[0]for z in bb],[k,v]+[z[0]for z in bb]+[z[0]for z in sb]]
  expected += [[sb[i][0],bb[i][0]]+S[i]+B[i]for i in range(q)]
  expected += [[bb[i][0],sb[i][0]]+B[i]+S[i]for i in range(q)]
  assert generated==expected
  checks.append({'q':q,'rho':str(rho),'exact_block_identity':True})
# Scalar-covariate example with beta=1/2, W=B=1 and DZ residual K=11/20.
S=[[F(3,2),F(4,5),F(1),F(1,2)], [F(4,5),F(3,2),F(1,2),F(1)], [F(1),F(1,2),F(2),F(1)], [F(1,2),F(1),F(1),F(2)]]
vs=[condvar(S,2,o)for o in [[],[3],[3,0],[3,0,1]]]
assert all(a>b for a,b in zip(vs,vs[1:]))
e=F(1,1000);p=F(1,2);assert e+(1-2*e)*p==p
r={'covariance_exact_tests':checks,'borrowing_example':{'order':['prior','co-twin covariate','plus own phenotype','plus co-twin phenotype'],'conditional_variances':[str(v)for v in vs],'strict_reduction':True},'binary_link':{'epsilon':str(e),'P_X1_given_liability_below_threshold':str(e),'P_X1_given_liability_at_or_above_threshold':str(1-e),'symmetric_gaussian_marginal_probability':str(e+(1-2*e)*p),'threshold_covariance_multiplier':str((1-2*e)**2),'conditional_Bernoulli_variance':str(e*(1-e))},'continuous_link':{'precision':100,'added_variance':str(F(1,100)),'residual_SD':'1/10'},'method':'Exact rational arithmetic; ten covariance designs and one conditional-variance example; no random samples, numerical integration, model fitting or chain execution','script_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
(ROOT/'outputs/chapter6-analytical-checks.json').write_text(json.dumps(r,indent=2)+'\n')
print(json.dumps(r))
