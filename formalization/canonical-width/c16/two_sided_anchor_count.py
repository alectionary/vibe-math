#!/usr/bin/env python3
"""Finite2X+2Zshared-pattern count hull; no unanchored cross-pair or rank claim."""
from pathlib import Path
from itertools import combinations
from collections import Counter
from fractions import Fraction
import argparse,gzip,hashlib,json,time
import numpy as np
from scipy.sparse import coo_matrix,save_npz
from verify_algebraic_model import physical
from verify_projected_profile_moment_rows import point_vector
from projected_profile_moment_matrix import owner_coordinate
ROOT=Path(__file__).resolve().parent
N=7211;PAIRS=list(combinations(range(4),2));LAYOUT='1,P[4],PP[6lex],U[X720,Z720],P_U[4,1440].ravel(C)'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def anchors(Xa,Za):
 assert len(Xa)==len(Za)==2 and len(set(Xa))==len(set(Za))==2 and all(type(i)is int and 0<=i<720 for i in [*Xa,*Za]);return [(0,i) for i in Xa]+[(1,j) for j in Za]
def columns(Xa,Za):
 aa=anchors(Xa,Za);uu=[(s,j) for s in range(2) for j in range(720)]
 def pair(a,b):return owner_coordinate('S' if a[0]==b[0] else 'T',(b[1]-a[1])%16,a[1]//16,b[1]//16)
 return [None]+[i//16 for s,i in aa]+[pair(aa[i],aa[j]) for i,j in PAIRS]+[j//16 for s,j in uu]+[pair(a,u) for a in aa for u in uu]
def target(point,Xa,Za):
 v=point_vector(point);return [Fraction(1) if j is None else v[j] for j in columns(Xa,Za)]
def features(mask,selected):
 p=[mask>>i&1 for i in range(4)];chosen=set(selected);u=[int(j in chosen) for j in range(1440)];return [1,*p,*[p[i]*p[j] for i,j in PAIRS],*u,*[bit*v for bit in p for v in u]]
def domains(X,Z,Xa,Za):
 aa=anchors(Xa,Za);out=[]
 for m in range(16):
  fixed=[[i for k,i in enumerate(Xa) if m>>k&1],[j for k,j in enumerate(Za) if m>>(2+k)&1]];blocks=[];allfixed=[];bad=None
  for side,(U,V,fset,aset,other) in enumerate([(X,Z,fixed[0],Xa,fixed[1]),(Z,X,fixed[1],Za,fixed[0])]):
   signatures=[sum(((u&V[j]).bit_count()%2)<<k for k,j in enumerate(other)) for u in U];k=len(other);buckets=[[] for q in range(k+1)]
   for j,s in enumerate(signatures):
    if not s:buckets[0].append(j)
    elif not s&(s-1):buckets[s.bit_length()].append(j)
   eligible=set().union(*map(set,buckets))
   if not set(fset)<=eligible:bad='FORCED_MULTIBIT';break
   for b,pool in enumerate(buckets):
    forced=sorted(set(fset)&set(pool));remaining=(128-k if b==0 else 1)-len(forced);free=sorted(set(pool)-set(aset))
    if remaining<0:bad='FORCED_OWNER_COLLISION';break
    if len(free)<remaining:bad='INSUFFICIENT_COUNT';break
    if remaining:blocks.append({'side':side,'bucket':b,'take':remaining,'free':[720*side+j for j in free]})
   if bad:break
   allfixed.extend(720*side+j for j in fset)
  out.append({'mask':m,'status':bad or 'COUNT_DOMAIN','forced':sorted(allfixed) if not bad else [],'buckets':blocks if not bad else []})
 return out
def support(c,dd):
 assert len(c)==N and all(type(v)is int for v in c);records=[]
 for d in dd:
  m=d['mask']
  if d['status']!='COUNT_DOMAIN':records.append({'mask':m,'status':d['status'],'value':None});continue
  p=[m>>i&1 for i in range(4)];w=[c[11+j]+sum(c[1451+1440*i+j] for i in range(4) if p[i]) for j in range(1440)];chosen=list(d['forced']);parts=[]
  for b in d['buckets']:
   pick=sorted(b['free'],key=lambda j:(-w[j],j))[:b['take']];assert len(pick)==b['take'];chosen+=pick;parts.append(pick)
  assert len(chosen)==256 and len(set(chosen))==256 and sum(j<720 for j in chosen)==128
  value=sum(a*b for a,b in zip(c,features(m,chosen)));records.append({'mask':m,'status':'EXACT_TWO_SIDED_COUNT_SUPPORT','selected':sorted(chosen),'bucket_selections':parts,'value':value})
 return max(r['value'] for r in records if r['value'] is not None),records
def compile_row(c,bound,Xa,Za):
 r=Counter()
 for a,j in zip(c,columns(Xa,Za)):
  if j is not None:r[j]+=a
 return dict(sorted((j,v) for j,v in r.items() if v)),bound-c[0]
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--X',type=int,nargs=2,required=True);ap.add_argument('--Z',type=int,nargs=2,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--prefix',type=Path,required=True);a=ap.parse_args();out=Path(str(a.prefix)+'.json');assert not out.exists();t0=time.monotonic();X,Z,A=physical();dd=domains(X,Z,a.X,a.Z);tar=target(a.point,a.X,a.Z);rows=[];cols=[];values=[];ur=[];uc=[];uv=[];rhs=list(tar);variables=[['lambda',m,-1] for m in range(16)];caps=[1.0 if d['status']=='COUNT_DOMAIN' else 0.0 for d in dd]
 for d in dd:
  m=d['mask'];f=features(m,d['forced'])
  if d['status']!='COUNT_DOMAIN':continue
  for k,v in enumerate(f):
   if v:rows.append(k);cols.append(m);values.append(v)
  for bucket in d['buckets']:
   br=len(rhs);rhs.append(Fraction(0));rows.append(br);cols.append(m);values.append(-bucket['take'])
   for j in bucket['free']:
    v=len(variables);variables.append(['y',m,j]);caps.append(1.0);rr=[11+j,br]+[1451+1440*i+j for i in range(4) if m>>i&1];rows.extend(rr);cols.extend([v]*len(rr));values.extend([1]*len(rr));u=len(ur)//2;ur.extend([u,u]);uc.extend([v,m]);uv.extend([1,-1])
 E=coo_matrix((np.array(values,dtype=np.int64),(rows,cols)),shape=(len(rhs),len(variables))).tocsr();U=coo_matrix((np.array(uv,dtype=np.int64),(ur,uc)),shape=(len(ur)//2,len(variables))).tocsr();bb=np.array(list(map(float,rhs)))
 paths=['two_sided_anchor_count.py','verify_two_sided_anchor_count.py','verify_algebraic_model.py','verify_projected_profile_moment_rows.py','projected_profile_moment_matrix.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','moment-resumption-results/symmetry-bridge-independent.json'];frozen={'status':'FROZEN_BEFORE_TWO_SIDED_COUNT_LP','source_C16_answered':False,'X_anchors':a.X,'Z_anchors':a.Z,'point_sha256':sha(a.point),'point_c16_path':str(a.point.resolve().relative_to(ROOT)),'feature_layout':LAYOUT,'selection_patterns':list(range(16)),'domains':dd,'source_hashes':{p:sha(ROOT/p) for p in paths},'variables':len(variables),'equalities':len(rhs),'inequalities':U.shape[0],'LP_seconds':60,'presolve':'off','scope':'Twofullcardinalitycountselections withsharedfour-anchorpattern, fixedselected/deletedabsentanchors, oppositezero/uniteligibility andoneperowner. Nozero-matroidranks orunanchoredX/Zpaircoupling.'};fp=Path(str(a.prefix)+'.frozen.json');assert not fp.exists();fp.write_text(json.dumps(frozen,indent=2)+'\n')
 import highspy
 H=highspy.Highs()
 for name,value in [('output_flag',False),('threads',1),('solver','simplex'),('presolve','off'),('time_limit',60.0),('primal_feasibility_tolerance',1e-9),('dual_feasibility_tolerance',1e-9)]:assert H.setOptionValue(name,value)==highspy.HighsStatus.kOk
 assert H.addVars(len(variables),np.zeros(len(variables)),np.array(caps))==highspy.HighsStatus.kOk
 for M,lo,hi in [(E,bb,bb),(U,np.full(U.shape[0],-highspy.kHighsInf),np.zeros(U.shape[0]))]:assert H.addRows(M.shape[0],lo,hi,M.nnz,M.indptr.astype(np.int32),M.indices.astype(np.int32),M.data.astype(float))==highspy.HighsStatus.kOk
 solve=time.monotonic();H.run();status=H.getModelStatus();solver_seconds=time.monotonic()-solve;result={**frozen,'frozen_sha256':sha(fp),'solver_model_status':str(status),'solver_seconds':solver_seconds,'cuts':[],'ray_tests':[]}
 if status==highspy.HighsModelStatus.kOptimal:
  sol=np.array(H.getSolution().col_value);result.update(status='NUMERICAL_TWO_SIDED_COUNT_EXTENSION_FEASIBLE',maximum_equality_residual=float(max(abs(E@sol-bb))),maximum_upper_violation=float(max(0,max(U@sol))),minimum_variable=float(min(sol)),positive_variables=int(sum(sol>0)))
  np.savez_compressed(str(a.prefix)+'.npz',x=sol,variables=np.array(variables,dtype=str),rhs=np.array(list(map(str,rhs))),lambda_masses=sol[:16]);save_npz(str(a.prefix)+'.equalities.npz',E);save_npz(str(a.prefix)+'.inequalities.npz',U)
 elif status==highspy.HighsModelStatus.kInfeasible:
  rs,exists,ray=H.getDualRay();result.update(status='NUMERICAL_INFEASIBILITY_REQUIRES_EXACT_SEPARATOR',dual_ray_available=bool(exists))
  if exists:
   ray=np.array(ray);np.savez_compressed(str(a.prefix)+'.ray.npz',ray=ray);seen=set()
   for sign in [1,-1]:
    v=sign*ray[:N].copy();v[0]=0
    if not max(abs(v)):continue
    v/=max(abs(v))
    for scale in [1,4,16,64,256,4096,65536]:
     c=[int(np.rint(t*scale)) for t in v]
     if tuple(c) in seen:continue
     seen.add(tuple(c));bound,records=support(c,dd);value=sum(Fraction(x)*t for x,t in zip(c,tar));gap=value-bound;result['ray_tests'].append({'sign':sign,'scale':scale,'bound':bound,'value':str(value),'gap':str(gap)})
     if gap>0:result['cuts'].append({'coefficients':c,'upper_bound':bound,'exact_target_value':str(value),'exact_violation':str(gap),'support_records':records})
   if result['cuts']:result['status']='EXACT_COUNT_SUPPORT_CUT_CANDIDATE'
 else:result['status']='BOUNDED_COUNT_LP_INCONCLUSIVE'
 assert all(sha(ROOT/p)==h for p,h in frozen['source_hashes'].items());result['elapsed_seconds']=time.monotonic()-t0;out.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k not in ['source_hashes','domains','cuts','ray_tests']}),flush=True)
if __name__=='__main__':main()
