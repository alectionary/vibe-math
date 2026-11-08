#!/usr/bin/env python3
"""Independent literal two-sided count supports and factor-one translations."""
from pathlib import Path
from itertools import combinations
from collections import Counter
from fractions import Fraction
import argparse,gzip,hashlib,json,random,time
import numpy as np
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension
from verify_projected_profile_moment_rows import point_vector
ROOT=Path(__file__).resolve().parent;N=7211;PAIRS=list(combinations(range(4),2));LAYOUT='1,P[4],PP[6lex],U[X720,Z720],P_U[4,1440].ravel(C)'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def coord(side,h,i,j):
 h%=16
 if h>8:h,i,j=16-h,j,i
 if h in [0,8] and i>j:i,j=j,i
 return i if side=='S' and h==0 and i==j else 45+(0 if side=='S' else 18225)+2025*h+45*i+j
def columns(xx,zz):
 aa=[(0,i) for i in xx]+[(1,j) for j in zz];assert len(xx)==len(set(xx))==len(zz)==len(set(zz))==2 and all(type(i)is int and 0<=i<720 for s,i in aa)
 def pair(a,b):return coord('S' if a[0]==b[0] else 'T',b[1]-a[1],a[1]//16,b[1]//16)
 full=[(s,j) for s in range(2) for j in range(720)];return [None]+[j//16 for s,j in aa]+[pair(aa[i],aa[j]) for i,j in PAIRS]+[j//16 for s,j in full]+[pair(a,u) for a in aa for u in full]
def feature(m,chosen):
 bits=[m>>i&1 for i in range(4)];selected=set(chosen);u=[int(j in selected) for j in range(1440)];return [1,*bits,*[bits[i]*bits[j] for i,j in PAIRS],*u,*[p*q for p in bits for q in u]]
def domain(X,Z,xx,zz,m):
 selected=[[x for k,x in enumerate(xx) if m>>k&1],[z for k,z in enumerate(zz) if m>>(2+k)&1]];forced=[*selected[0],*[720+j for j in selected[1]]];buckets=[]
 for side in range(2):
  U,V=(X,Z) if side==0 else (Z,X);own=xx if side==0 else zz;opp=selected[1-side];sig={i:tuple(j for j in opp if (U[i]&V[j]).bit_count()%2) for i in range(720)}
  if any(len(sig[i])>1 for i in selected[side]):return None
  pools=[('zero',[i for i in range(720) if not sig[i]],128-len(opp))]+[(j,[i for i in range(720) if sig[i]==(j,)],1) for j in opp]
  for label,pool,capacity in pools:
   fixed=[i for i in selected[side] if i in pool];take=capacity-len(fixed);free=[720*side+i for i in pool if i not in own]
   if take<0 or take>len(free):return None
   if take:buckets.append((take,free))
 return sorted(forced),buckets
def check_support(X,Z,xx,zz,c,records):
 assert len(c)==N and all(type(v)is int for v in c) and [r['mask'] for r in records]==list(range(16));values=[];bucketchecks=0
 for r in records:
  m=r['mask'];d=domain(X,Z,xx,zz,m)
  if d is None:assert r['value'] is None;continue
  fixed,buckets=d;chosen=r['selected'];assert len(chosen)==len(set(chosen))==256 and all(type(j)is int and 0<=j<1440 for j in chosen);assert sum(j<720 for j in chosen)==128 and set(fixed)<=set(chosen);assert all((i in chosen)==bool(m>>k&1) for k,i in enumerate([*xx,*[720+j for j in zz]]))
  weights=[c[11+j]+sum(c[1451+1440*k+j] for k in range(4) if m>>k&1) for j in range(1440)];opt=sum(c[k]*feature(m,fixed)[k] for k in range(11))+sum(weights[j] for j in fixed);union=set(fixed)
  for take,free in buckets:
   pick=set(chosen)&set(free);assert len(pick)==take;expected=sum(sorted((weights[j] for j in free),reverse=True)[:take]);assert sum(weights[j] for j in pick)==expected;opt+=expected;union|=pick;bucketchecks+=1
  assert union==set(chosen);actual=sum(a*b for a,b in zip(c,feature(m,chosen)));assert actual==r['value']==opt;values.append(opt)
  for k,x in enumerate(xx):
   if m>>k&1:assert sum((X[x]&Z[j-720]).bit_count()%2 for j in chosen if j>=720)==1
  for k,z in enumerate(zz):
   if m>>(2+k)&1:assert sum((X[i]&Z[z]).bit_count()%2 for i in chosen if i<720)==1
 return max(values),bucketchecks
def controls(X,Z):
 from two_sided_anchor_count import domains,support,features,target,columns as producer_columns
 rng=random.Random(202610301);literal=prefix=0
 for xx,zz in [([80,512],[186,433]),([80,432],[186,514])]:
  assert columns(xx,zz)==producer_columns(xx,zz);dd=domains(X,Z,xx,zz)
  for density in [0,.2,.5,1]:
   raw=np.array([[[int(rng.random()<density) for h in range(16)] for j in range(45)] for s in range(2)]);tot=np.zeros(N,dtype=np.int64);mom=np.zeros(36495,dtype=np.int64)
   for swap in [0,1]:
    for rot in range(16):
     U=np.roll(raw[swap],rot,axis=1);V=np.roll(raw[1-swap],rot,axis=1);chosen=[j for j in range(720) if U[j//16,j%16]]+[720+j for j in range(720) if V[j//16,j%16]];m=sum(int(j in chosen)<<k for k,j in enumerate([*xx,*[720+j for j in zz]]));f=feature(m,chosen);assert f==features(m,chosen);tot+=f;mom[:45]+=U[:,0]
     for h in range(9):mom[45+2025*h:45+2025*(h+1)]+=np.outer(U[:,0],U[:,h]).ravel();mom[18270+2025*h:18270+2025*(h+1)]+=np.outer(U[:,0],V[:,h]).ravel()
   exact=[Fraction(int(v),32) for v in mom];assert [Fraction(1) if j is None else exact[j] for j in columns(xx,zz)]==[Fraction(int(v),32) for v in tot];literal+=N
  for c in [[0]*N,[0]*11+[-1]*1440+[0]*5760,[rng.randrange(-8,9) for k in range(N)]]:
   bound,recs=support(c,dd);b,n=check_support(X,Z,xx,zz,c,recs);assert b==bound;prefix+=n
 neighbors=[j for j in range(720) if (X[80]&Z[j]).bit_count()%2];assert domain(X,Z,[80,512],neighbors[:2],13) is None
 common=[j for j in range(720) if (X[80]&Z[j]).bit_count()%2 and (X[512]&Z[j]).bit_count()%2];assert common;assert domain(X,Z,[80,512],[common[0],(common[0]+1)%720],7) is None
 return dict(literal_32_action_feature_equalities=literal,exact_signed_count_bucket_checks=prefix,forced_multibit_and_duplicate_owner_controls=2)
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--controls',action='store_true');ap.add_argument('--bank',type=Path);ap.add_argument('--point',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();t=time.monotonic();X,Z,A=physical();assert dimension(X)==dimension(Z)==dimension(x|(z<<128) for x,z in zip(X,Z))==128;assert all((A[i]>>j&1)==(A[j]>>i&1) for i in range(720) for j in range(720))
 if a.controls:out={'status':'PASS_TWO_SIDED_COUNT_CONTROLS','source_C16_answered':False,**controls(X,Z)}
 else:
  b=read(a.bank);assert b['feature_layout']==LAYOUT and b['selection_patterns']==list(range(16));assert all(sha(ROOT/p)==h for p,h in b['source_hashes'].items());assert b['point_sha256']==sha(a.point);xx,zz=b['X_anchors'],b['Z_anchors'];v=point_vector(a.point);tar=[Fraction(1) if j is None else v[j] for j in columns(xx,zz)];results=[]
  for c in b['cuts']:
   bound,n=check_support(X,Z,xx,zz,c['coefficients'],c['support_records']);exact=sum(a*t for a,t in zip(c['coefficients'],tar));gap=exact-bound;assert bound==c['upper_bound'] and str(exact)==c['exact_target_value'] and str(gap)==c['exact_violation'] and gap>0;r=Counter()
   for value,j in zip(c['coefficients'],columns(xx,zz)):
    if j is not None:r[j]+=value
   rhs=bound-c['coefficients'][0];assert sum(value*v[j] for j,value in r.items())-rhs==gap;results.append(dict(exact_violation=str(gap),owner_row_terms=[[j,x] for j,x in sorted(r.items()) if x],rhs=rhs,count_bucket_checks=n))
  out={'status':'PASS_EXACT_TWO_SIDED_COUNT_CUTS' if results else 'NO_ACCEPTED_CUT_NUMERICAL_STATUS_ONLY','source_C16_answered':False,'bank_sha256':sha(a.bank),'point_sha256':sha(a.point),'cuts_checked':len(results),'results':results,'proof_kind':'two_sided_count_only_shared_pattern','numerical_primal_is_not_exact_membership':True}
 out.update(consumer_sha256=sha(__file__),elapsed_seconds=time.monotonic()-t,scope='Exactcount supports overboth fullcardinality sectors withshared2X+2Zpattern; nozeromatroidranks, nofullunanchoredcrosspaircoupling, nosourceframe orcaseexclusion.');a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='results'}),flush=True)
if __name__=='__main__':main()
