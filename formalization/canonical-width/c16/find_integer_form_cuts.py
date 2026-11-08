from pathlib import Path
import sys,json,time,random
import numpy as np
from flint import fmpz_mat
ROOT=Path(__file__).parent
sys.path.insert(0,str(ROOT))
from block_moment_dual import layout
from moment_integer_form_cuts import coefficients
import argparse
ap=argparse.ArgumentParser();ap.add_argument('moments',type=Path);ap.add_argument('--seed-cuts',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();data=np.load(a.moments);p=data['first'];C={h:data[f'C{h}'] for h in range(9)};C.update({h:C[16-h].T for h in range(9,16)});N=len(p);P=16;V=N*P;M=np.empty((V,V))
for i in range(V):
 for h in range(P):M[i,h::P]=C[(h-i%P)%P][i//P,:]
pfull=np.repeat(p,16);cov=M-pfull[:,None]*pfull[None,:];pentagons=json.load(open(a.seed_cuts))['cuts'];rng=np.random.default_rng(20261027);pi,Ci,_=layout(N,16);seen=set();cuts=[];trials=0;maximum=0;start=time.monotonic();D=1<<24
for trial in range(500):
 seed=pentagons[trial%len(pentagons)]['events'] if pentagons and trial<400 else list(map(int,rng.choice(V,5,replace=False)))
 neighborhood=np.max(abs(cov[seed,:]),axis=0);order=np.argsort(neighborhood)[::-1];extra=list(map(int,order[:80]));rng.shuffle(extra);events=list(dict.fromkeys(seed+extra))[:18]
 g=np.block([[np.ones((1,1)),pfull[events][None,:]],[pfull[events][:,None],M[np.ix_(events,events)]]]);g=(g+g.T)/2;emin=np.linalg.eigvalsh(g)[0];L=np.linalg.cholesky(g+max(1e-7,-emin+1e-7)*np.eye(len(g)));B=[[round(float(v)*D) for v in row] for row in L];d=len(B)
 for alpha in [D//4,D//16,D//64]:
  E=fmpz_mat([[2*v for v in row]+[0] for row in B]+[B[0]+[alpha]]);reduced,U=E.lll(transform=True);assert U*E==reduced;trials+=1
  for r in range(d+1):
   k=int(U[r,d])
   if k%2==0:continue
   const=int(U[r,0])+(k+1)//2;weights=[int(U[r,j]) for j in range(1,d)];support=[(v,b) for v,b in zip(events,weights) if b]
   if not support or len(support)>12 or max(abs(b) for v,b in support)>3 or sum(abs(b) for v,b in support)>12 or abs(const)>6:continue
   ev=[v for v,b in support];bb=[b for v,b in support];value=const*(const-1)/2+sum((const*b+b*(b-1)/2)*pfull[v] for v,b in support)+sum(b*bb[j]*M[v,ev[j]] for i,(v,b) in enumerate(support) for j in range(i));violation=-float(value);maximum=max(maximum,violation)
   if violation<=2e-5:continue
   cut={'events':ev,'weights':bb,'constant':const,'violation':violation,'discovery':'FLINT LLL on an integer closest-vector embedding of a moment principal submatrix'};key=coefficients(cut,pi,Ci)
   if key not in seen:seen.add(key);cuts.append(cut)
 if time.monotonic()-start>45:break
cuts.sort(key=lambda c:c['violation'],reverse=True);result={'status':'BOUNDED_VALID_INEQUALITY_DISCOVERY','seed':20261027,'LLL_reductions':trials,'integer_transformation_checks':trials,'maximum_violation':maximum,'distinct_cuts':len(cuts),'seconds':time.monotonic()-start,'source_C16_answered':False,'cuts':cuts};a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k!='cuts'}),flush=True)
