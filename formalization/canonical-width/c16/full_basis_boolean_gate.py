#!/usr/bin/env python3
"""Exact Boolean bridge and bounded completion lower-bound gate; no SAT search."""
from pathlib import Path
from collections import Counter
import gzip,hashlib,json,math,time,random
import numpy as np
from verify_algebraic_model import physical
from full_partner_projection_features import column_features
from anchor_partner_projection_features import column_features as anchor_features
from verify_partial_frame import mask,shift
from audit_pools import exchange
ROOT=Path(__file__).resolve().parent
OUT=ROOT/'coupling-results/full-basis-boolean-gate.json'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def polynomial(c,anchor=80):
 # x0..x719, z720..z1439; sorted monomials, with Boolean diagonals reduced.
 L=Counter();Q=Counter()
 def add(a,b,w):
  if a==b:L[a]+=int(w)
  else:Q[tuple(sorted((a,b)))]+=int(w)
 for t in range(16):L[512+t]+=int(c[1])
 for h in range(1,9):
  for t in range(16):add(512+t,512+(t+h)%16,c[h+1])
 for j in range(45):
  for b in range(16):
   L[720+16*j+b]+=int(c[10+j])
   for t in range(16):add(512+t,720+16*j+b,c[55+16*j+(b-t)%16])
 if len(c)==1512:
  L[720+anchor]+=int(c[775])
  for t in range(16):add(720+anchor,512+t,c[776+t])
  for j in range(720):add(720+anchor,720+j,c[792+j])
 return int(c[0]),{a:w for a,w in sorted(L.items()) if w},{ab:w for ab,w in sorted(Q.items()) if w}
def balanced_adder_cost(weights,bound):
 # No output CNF is generated. Literal copies cost zero; each 2-XOR=4clauses,
 # 2-AND/OR=3clauses. Conservative counts deliberately skip no equal literals.
 variables=clauses=0
 def gate(kind,*args):
  nonlocal variables,clauses
  if kind=='xor':
   if args[0]==0:return args[1]
   if args[1]==0:return args[0]
  if kind=='and':
   if 0 in args:return 0
  if kind=='or':
   if args[0]==0:return args[1]
   if args[1]==0:return args[0]
  variables+=1;clauses+=4 if kind=='xor' else 3;return variables+2000000
 words=[[i+1 if w>>b&1 else 0 for b in range(w.bit_length())] for i,w in enumerate(weights)]
 while len(words)>1:
  nxt=[]
  for i in range(0,len(words),2):
   if i+1==len(words):nxt.append(words[i]);continue
   a,b=words[i:i+2];carry=0;out=[]
   for k in range(max(len(a),len(b))):
    x=a[k] if k<len(a) else 0;y=b[k] if k<len(b) else 0
    xy=gate('xor',x,y);out.append(gate('xor',xy,carry));carry=gate('or',gate('and',x,y),gate('and',xy,carry))
   if carry:out.append(carry)
   nxt.append(out)
  words=nxt
 width=len(words[0]) if words else 0
 # Comparator clauses: for each zero bit ofbound, that sum bit must be0 if
 # every more-significant bit equalsbound; no new auxiliary is required.
 return dict(adder_auxiliary_variables=variables,adder_clauses=clauses,sum_width=width,comparator_clauses=sum(not(bound>>b&1) for b in range(width)))
def main():
 assert not OUT.exists();start=time.monotonic();rng=random.Random(20261030)
 specs=[('full-partner-projection-wolfe-witness2.json','full-partner-projection-wolfe-witness2-independent.json'),('full-partner-projection-wolfe-strengthen-witness2.json','full-partner-projection-wolfe-strengthen-witness2-independent.json'),('anchor-projection-witness8-old775-only.json.gz','anchor-projection-witness8-old775-only-independent.json'),('anchor-projection-witness8.json.gz','anchor-projection-witness8-independent.json')]
 paths=[Path(__file__),ROOT/'verify_algebraic_model.py',ROOT/'full_partner_projection_features.py',ROOT/'anchor_partner_projection_features.py',ROOT/'signature_cover.py',ROOT/'global_four_signature.py',ROOT/'word_kept_anchor_domain_signature.py',ROOT/'physical-pool-source.json',ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt',ROOT/'transfer-results/global-trial.json',ROOT/'moment-resumption-results/global-four-trial.json',ROOT/'transfer-results/cover-405.json',ROOT/'partial-frame-88.json',ROOT/'algebraic-results/orbit-rank-profiles.json.gz']
 cuts=[]
 for bankname,receiptname in specs:
  bp,rp=[ROOT/'coupling-results'/n for n in (bankname,receiptname)];paths.extend([bp,rp]);bank,receipt=read(bp),read(rp);assert receipt['status']=='PASS' and receipt['bank_sha256']==sha(bp)
  for k,row in enumerate(bank['cuts']):cuts.append(dict(bank=bankname,index=k,c=row['coefficients'],bound=row['upper_bound'],anchor=bank.get('anchor',80)))
 frozen={'status':'FROZEN_BEFORE_BOOLEAN_GATE','source_hashes':{str(p.relative_to(ROOT)):sha(p) for p in paths},'source_C16_answered':False,'cohort':'all6908savedglobalpartialmatchings for direct endpoint diagnostic; deterministic first/last32 ofeachrun plusphysical88 for exactcountcompletion lowerbound; first3cuts bounded initially','solver_calls':0}
 OUT.with_suffix('.frozen.json').write_text(json.dumps(frozen,indent=2)+'\n')
 X,Z,A=physical();AM=np.array([[(r>>j)&1 for j in range(720)] for r in A],dtype=np.int8);assert np.array_equal(AM,AM.T)
 groups=[];instances=[]
 for name in ['transfer-results/global-trial.json','moment-resumption-results/global-four-trial.json']:
  records=read(ROOT/name)['records'];groups.append((name,records))
  for k in sorted(set(list(range(min(32,len(records))))+list(range(max(0,len(records)-32),len(records))))):instances.append((name,k,records[k]['pairs']))
 source=read(ROOT/'physical-pool-source.json');zp=[shift(mask(s),h) for s in source['Z_orbit_representatives'] for h in range(16)];xp=list(map(exchange,zp));lookup=[{v:i for i,v in enumerate(U)} for U in (xp,zp)]
 pairs=[tuple(lookup[s][mask(r[side])] for s,side in enumerate(('X','Z'))) for r in read(ROOT/'partial-frame-88.json')['pairs']];instances.append(('partial-frame-88.json',0,pairs))
 profile=next(r for r in read(ROOT/'algebraic-results/orbit-rank-profiles.json.gz')['records'] if r['orbit']==32);bad=[c['mask'] for c in profile['minimal_bad_certificates']];allowed=np.array([m for m in range(65536) if not any(m&b==b for b in bad)],dtype=np.int64);assert len(allowed)==4597
 P=((allowed[:,None]>>np.arange(16))&1).astype(np.int64);C=np.stack([P.sum(axis=1),*[np.sum(P*np.roll(P,h,axis=1),axis=1) for h in range(1,9)]],axis=1)
 prepared=[]
 for name,number,pairs in instances:
  sx=[x for x,z in pairs];sz=[z for x,z in pairs];assert len(set(sx))==len(sx)==len(set(sz)) and np.array_equal(AM[np.ix_(sx,sz)],np.eye(len(sx),dtype=np.int8))
  ax=~np.any(AM[:,sz],axis=1);az=~np.any(AM[sx,:],axis=0);ax[sx]=True;az[sz]=True
  must=sum(1<<(x-512) for x in sx if 512<=x<528);permit=sum(int(ax[512+t])<<t for t in range(16));idx=np.flatnonzero(((allowed&must)==must)&((allowed&~permit)==0))
  prepared.append(dict(name=name,record=number,sx=sx,sz=sz,ax=ax,az=az,mask_indices=idx))
 allq=set();encoding=[];controls=0;direct=[]
 for cut in cuts:
  c=cut['c'];const,L,Q=polynomial(c,cut['anchor']);allq.update(Q)
  weights=[abs(v) for v in [*L.values(),*Q.values()]];rhs=int(cut['bound'])-const+sum(-v for v in [*L.values(),*Q.values()] if v<0);g=math.gcd(*weights);weights=[w//g for w in weights];rhs//=g
  cost=balanced_adder_cost(weights,rhs);encoding.append(dict(bank=cut['bank'],cut=cut['index'],features=len(c),linear_terms=len(L),quadratic_products=len(Q),product_clauses=3*len(Q),maximum_coefficient=max(weights),coefficient_gcd=g,complemented_positive_rhs=rhs,**cost))
  for _ in range(8):
   chosen={i for i in range(1440) if rng.random()<.15};m=sum(1<<t for t in range(16) if 512+t in chosen);zz=[i for i in range(720) if 720+i in chosen];f=anchor_features(m,zz,cut['anchor']) if len(c)==1512 else column_features(m,zz)
   value=const+sum(w for i,w in L.items() if i in chosen)+sum(w for (i,j),w in Q.items() if i in chosen and j in chosen);assert value==sum(a*b for a,b in zip(c,f));controls+=1
  for name,records in groups:
   vals=[]
   for row in records:
    xx={x for x,z in row['pairs']};zz=[z for x,z in row['pairs']];m=sum(1<<t for t in range(16) if 512+t in xx);f=anchor_features(m,zz,cut['anchor']) if len(c)==1512 else column_features(m,zz);vals.append(sum(a*b for a,b in zip(c,f))-cut['bound'])
   direct.append(dict(bank=cut['bank'],cut=cut['index'],source=name,records=len(vals),endpoint_only_violations=sum(v>0 for v in vals),maximum_endpoint_only_excess=max(vals),minimum_endpoint_only_excess=min(vals),source_valid_pruning=False))
 # Exact count-completion lowerbound: only necessary constraints are used.
 # P-mask fixed; opposite720 weights exact; choose128 distinct allowedZ,
 # retaining every mandatoryZ. Conditionalanchor branches fixq_a aswell.
 lower=[];deadline=time.monotonic()+120
 selected_cuts=[cuts[0],cuts[-2],cuts[-1]]
 for cut in selected_cuts:
  c=np.array(cut['c'],dtype=np.int64);W=c[55:775].reshape(45,16);rolled=np.stack([np.roll(P,b,axis=1)[:,::-1] for b in range(16)],axis=1) if False else None
  weights=np.zeros((len(allowed),720),dtype=np.int64)
  for j in range(45):
   for b in range(16):weights[:,16*j+b]=c[10+j]+P@W[j,(b-np.arange(16))%16]
  local=int(c[0])+C@c[1:10]
  for d in prepared:
   if time.monotonic()>deadline:break
   ids=d['mask_indices'];best=None;branch_tests=0;feasible_branches=0
   states=[0,1] if len(c)==1512 else [None]
   for state in states:
    fixed=list(d['sz']);az=d['az'].copy()
    if state is not None:
     a=cut['anchor']
     if state==0:
      if a in fixed:continue
      az[a]=False
     else:
      if not az[a]:continue
      if a not in fixed:fixed.append(a)
    free=np.flatnonzero(az);free=free[~np.isin(free,fixed)];need=128-len(fixed)
    if need<0 or len(free)<need:continue
    if not len(ids):continue
    ww=weights[ids].copy();ll=local[ids].copy()
    if state:
     ww+=c[792:][None,:];ll+=c[775]+P[ids]@c[776:792]
    vals=ll+ww[:,fixed].sum(axis=1)
    if need:vals+=np.partition(ww[:,free],need-1,axis=1)[:,:need].sum(axis=1)
    v=int(vals.min());best=v if best is None else min(best,v);branch_tests+=len(ids);feasible_branches+=len(ids)
   lower.append(dict(bank=cut['bank'],cut=cut['index'],source=d['name'],record=d['record'],partial_size=len(d['sx']),possible_P_masks=len(ids),possible_Z_count=int(d['az'].sum()),tested_branches=branch_tests,count_completion_lower_bound=best,bound=cut['bound'],pruned_by_bound=best is not None and best>cut['bound'],already_count_or_profile_infeasible=best is None))
 # Literal AND definition and complemented weighted-PB identity controls.
 for x in (0,1):
  for y in (0,1):
   for z in (0,1):assert all([not z or x,not z or y,not x or not y or z])==(z==x*y)
 for _ in range(256):
  cs=[rng.randrange(-19,20) for i in range(8)];xs=[rng.randrange(2) for i in cs];b=rng.randrange(-20,21)
  assert (sum(c*x for c,x in zip(cs,xs))<=b)==(sum(abs(c)*(x if c>=0 else 1-x) for c,x in zip(cs,xs))<=b+sum(-c for c in cs if c<0))
 assert all(sha(ROOT/p)==h for p,h in frozen['source_hashes'].items())
 out={'status':'PASS_BOOLEAN_TRANSLATION_AND_BOUNDED_COMPLETION_GATE','source_C16_answered':False,'frozen_sha256':sha(OUT.with_suffix('.frozen.json')),'solver_calls':0,'feature_polynomial_controls':controls,'and_truth_table_controls':8,'signed_PB_controls':256,'encoding':encoding,'shared_quadratic_products':len(allq),'shared_product_definition_clauses':3*len(allq),'direct_endpoint_diagnostics':direct,'completion_lower_bounds':lower,'completion_tests':len(lower),'completion_bound_prunings':sum(r['pruned_by_bound'] for r in lower),'count_or_profile_infeasible':sum(r['already_count_or_profile_infeasible'] for r in lower),'physical88_results':[r for r in lower if r['source']=='partial-frame-88.json'],'elapsed_seconds':time.monotonic()-start,'scope':'Accepted bounds remain unchanged. Direct evaluation on compact partial endpoints is diagnostic only. Completion lowerbounds minimize over a larger domain than any physical source completion; they omit linear rank and further ownership and therefore give only sufficient pruning. NoSATorDRATrun or source-case exclusion.'}
 OUT.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ['encoding','direct_endpoint_diagnostics','completion_lower_bounds','physical88_results']}),flush=True)
if __name__=='__main__':main()
