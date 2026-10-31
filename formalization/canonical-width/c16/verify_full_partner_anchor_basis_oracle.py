#!/usr/bin/env python3
"""Independent low-pivot contraction bounds and exhaustive anchored-basis tests."""
from pathlib import Path
from fractions import Fraction
from itertools import combinations
from collections import Counter
import argparse,copy,hashlib,json,random,time
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import rebuild_domain,dimension,extend
from verify_full_partner_projection import weights,coord
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def domain(X,Z,selected,anchor,state,n):
 d=rebuild_domain(X,Z,selected,n);d.update(anchor=anchor,state=state,fixed=[])
 if d['status']!='FULL_PARTNER_BASIS_DOMAIN':return d
 sig=d['signatures'][anchor];d['anchor_signature']=sig
 if state:
  if sig.bit_count()>1:d['status']='EXCLUDED_SELECTED_MULTIBIT_ANCHOR';return d
  if sig==0:
   if Z[anchor]==0:d['status']='EXCLUDED_SELECTED_ZERO_VECTOR';return d
   d['fixed']=[anchor];d['zero']=[j for j in d['zero'] if j!=anchor]
  else:d['bins'][sig.bit_length()-1]=[anchor]
 else:d['zero']=[j for j in d['zero'] if j!=anchor];d['bins']=[[j for j in b if j!=anchor] for b in d['bins']]
 if dimension(Z[j] for j in d['fixed']+d['zero'])!=n-len(selected):d['status']='EXCLUDED_ANCHOR_DEFICIENT_ZERO_POOL'
 elif any(not b for b in d['bins']):d['status']='EXCLUDED_ANCHOR_EMPTY_OWNER_BIN'
 else:d['status']='ANCHORED_FULL_PARTNER_BASIS_DOMAIN'
 return d

def check(Z,selected,d,w,r,n):
 if d['status']!='ANCHORED_FULL_PARTNER_BASIS_DOMAIN':
  assert r['status']==d['status'] and r['value'] is None and not r['selected_Z_indices'];return 0
 assert r['status']=='EXACT_ANCHORED_FULL_PARTNER_BASIS_SUPPORT';B=list(r['selected_Z_indices']);zero=list(r['zero_basis_indices']);owners=list(r['owner_indices'])
 assert len(B)==len(set(B))==n and dimension(Z[j] for j in B)==n
 assert B==zero+owners and len(zero)==n-len(selected) and len(owners)==len(selected)
 assert set(d['fixed'])<=set(zero)<=set(d['fixed']+d['zero']) and all(j in b for j,b in zip(owners,d['bins']))
 assert (d['anchor'] in B)==d['state'];value=Fraction(r['value']);assert value==sum(w[j] for j in B)
 piv={}
 for j in d['fixed']:assert extend(piv,Z[j])
 fixedrank=len(piv);ordered=sorted(d['zero'],key=lambda j:(-w[j],j));prefix=[]
 for j in ordered:extend(piv,Z[j]);prefix.append(len(piv)-fixedrank)
 residual=n-len(selected)-fixedrank;assert len(piv)-fixedrank==residual
 upper=sum(w[j] for j in d['fixed'])
 if ordered:upper+=w[ordered[-1]]*residual+sum((w[ordered[t]]-w[ordered[t+1]])*prefix[t] for t in range(len(ordered)-1))
 else:assert residual==0
 upper+=sum(max(w[j] for j in b) for b in d['bins']);assert value==upper
 return len(ordered)

def small_controls():
 from full_partner_anchor_basis_oracle import FullPartnerAnchorBasisOracle
 X=list(range(1,8));pools=[list(range(1,8)),[1,2,4],[2,4,6],[0,1,1,2,4]];cases=negative=0;statuses=Counter();unconditioned_splits=0
 for Z in pools:
  oracle=FullPartnerAnchorBasisOracle(X,Z,3);bases=[B for B in combinations(range(len(Z)),3) if dimension(Z[j] for j in B)==3]
  W=[[0]*len(Z),[-1-j for j in range(len(Z))],[(j*7+2)%11-5 for j in range(len(Z))],[Fraction((-1)**j*(j+1),3) for j in range(len(Z))]]
  for size in range(4):
   for selected in combinations(range(7),size):
    compatible=[]
    for B in bases:
     gram=[[(X[i]&Z[j]).bit_count()%2 for j in B] for i in selected]
     if all(sum(row)==1 for row in gram) and all(sum(row[j] for row in gram)<=1 for j in range(3)):compatible.append(B)
    for anchor in range(len(Z)):
     for state in (False,True):
      prepared=oracle.prepare_selected(selected,anchor,state);independent=domain(X,Z,selected,anchor,state,3);assert prepared['status']==independent['status'];statuses[independent['status']]+=1
      possible=[B for B in compatible if (anchor in B)==state]
      for w in W:
       got=oracle.support(prepared,w);wanted=max((sum(w[j] for j in B) for B in possible),default=None);assert got['value']==wanted;check(Z,selected,independent,w,got,3);cases+=1;negative+=wanted is not None and wanted<0 and all(a<0 for a in w)
     for w in W:
      branches=[oracle.support(oracle.prepare_selected(selected,anchor,s),w)['value'] for s in (False,True)];actual=max((v for v in branches if v is not None),default=None);assert actual==oracle.base.support(oracle.base.prepare_selected(selected),w)['value'];unconditioned_splits+=1
 assert negative>0
 for required in ['EXCLUDED_SELECTED_MULTIBIT_ANCHOR','EXCLUDED_SELECTED_ZERO_VECTOR','EXCLUDED_ANCHOR_DEFICIENT_ZERO_POOL','EXCLUDED_ANCHOR_EMPTY_OWNER_BIN']:assert statuses[required]>0
 try:oracle.support(oracle.prepare_selected([],0,False),[0.1]*len(Z))
 except TypeError:pass
 else:raise AssertionError('float accepted')
 return dict(literal_exhaustive_cases=cases,strictly_negative_full_basis_cases=negative,selected_absent_max_equals_unconditioned=unconditioned_splits,statuses=dict(statuses),float_rejected=True)

def feature_controls():
 # Extra737 features have no16 factor: q_a, q_a P_t, q_a Q_j,b.
 rng=random.Random(20261030);checks=0
 for a in (5,17):
  for probability in (0.,.2,.6,1.):
   pools=[[[int(rng.random()<probability) for t in range(16)] for j in range(45)] for s in (0,1)];extra=[0]*737
   for side in (0,1):
    primary,opposite=pools[side],pools[1-side]
    for rotation in range(16):
     qa=opposite[a][(-rotation)%16];P=[primary[32][(t-rotation)%16] for t in range(16)];Q=[opposite[j][(b-rotation)%16] for j in range(45) for b in range(16)];features=[qa,*[qa*p for p in P],*[qa*q for q in Q]];extra=[x+y for x,y in zip(extra,features)]
   def pair(relation,h,i,j):return Fraction(sum(pools[s][i][t]*pools[s^(relation=='T')][j][(t+h)%16] for s in (0,1) for t in range(16)),32)
   target=[Fraction(sum(pools[s][a][t] for s in (0,1) for t in range(16)),32),*[pair('T',t,a,32) for t in range(16)],*[pair('S',b,a,j) for j in range(45) for b in range(16)]]
   assert list(map(lambda x:Fraction(x,32),extra))==target;checks+=737
 return dict(literal32_action_extra_feature_equalities=checks,extra_features=737,total_with_old_features=1512,extra_feature_normalization='p_a; T_t[a,32]; S_b[a,j], without16 multiplier')

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();bank=json.loads(a.bank.read_text());fp=a.bank.with_suffix('.frozen.json');f=json.loads(fp.read_text());assert bank['frozen_sha256']==sha(fp) and all(sha(ROOT/p)==h for p,h in f['source_hashes'].items());X,Z,_=physical()
 assert X==[int(x,16) for x in (ROOT/'pools/xcoords.txt').read_text().split()] and Z==[int(z,16) for z in (ROOT/'pools/zcoords.txt').read_text().split()]
 expected={(anchor,mask,state) for anchor,mask in f['queries'] for state in (False,True)};seen=set();prefix=negative=feasible=0;statuses=Counter();corrupt=0
 for r in bank['records']:
  anchor,mask,state=r['anchor'],r['mask'],r['selected'];key=anchor,mask,state;assert key in expected and key not in seen;seen.add(key);selected=[512+h for h in range(16) if mask>>h&1];d=domain(X,Z,selected,anchor,state,128);assert r['domain_status']==d['status'] and r['anchor_signature']==d.get('anchor_signature');statuses[d['status']]+=1;ordinary=weights(mask,f['coefficients'])
  for sr in r['supports']:
   name=sr['weight'];w=[0]*720 if name=='zero' else [-1-j%13 for j in range(720)] if name=='negative' else [v+int(state)*((7*j+3)%19-9) for j,v in enumerate(ordinary)];prefix+=check(Z,selected,d,w,sr,128)
   if sr['value'] is not None:feasible+=1;negative+=name=='negative' and Fraction(sr['value'])<0
   if not corrupt and sr['value'] is not None and state:
    for how in ('omit_anchor','wrong_objective'):
     broken=copy.deepcopy(sr)
     if how=='omit_anchor':broken['selected_Z_indices']=[j for j in sr['selected_Z_indices'] if j!=anchor]
     else:broken['value']=str(Fraction(sr['value'])+1)
     try:check(Z,selected,d,w,broken,128)
     except AssertionError:corrupt+=1
     else:raise AssertionError('corrupt accepted')
 assert seen==expected and dict(statuses)==bank['domain_status_counts'];controls=small_controls();features=feature_controls()
 out=dict(status='PASS',source_C16_answered=False,bank_sha256=sha(a.bank),frozen_sha256=sha(fp),consumer_sha256=sha(Path(__file__)),source_hashes=f['source_hashes'],dependencies={p:sha(ROOT/p) for p in ['verify_algebraic_model.py','verify_partial_frame.py','audit_pools.py','verify_full_partner_basis_oracle.py','verify_full_partner_projection.py']},source_branch_domains_checked=len(seen),source_exact_support_queries_checked=sum(len(r['supports']) for r in bank['records']),feasible_support_queries=feasible,strictly_negative_source_full128_basis_controls=negative,prefix_rank_checks=prefix,corrupt_controls_rejected=corrupt,domain_status_counts=dict(statuses),tiny_controls=controls,feature_controls=features,elapsed_seconds=time.monotonic()-start,
          proof='Conditioning selected zero anchors contracts their physical vector into the zero matroid. Prefix-rank increments rank(F+prefix)-rank(F) bound the remaining full rank, including signed final weight. Selected unit anchors fix their owner bin; absent anchors delete. Unit evaluation vectors prove independence from the zero basis.',
          scope='Exact one-sided fullbasis support for the frozen source queries and literal small examples. Fixed phase anchor breaks291 representative reduction; no4597-mask support cut or projection solve is claimed.')
 a.output.write_text(json.dumps(out,indent=2)+'\n');print(out)
if __name__=='__main__':main()
