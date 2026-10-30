#!/usr/bin/env python3
"""Independent physical acceptance of orbit-cap/pair Lagrange support rows.

No price producer, support producer, or producer feature helper is imported.
Signed full-basis support is reconstructed by low-pivot prefix ranks. All
nonnegative prices use literal source capacities and checked forbidden pairs.
"""
from pathlib import Path
from fractions import Fraction
from itertools import combinations
import argparse,copy,hashlib,json,math,time
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import rebuild_domain,check_support,dimension
from verify_full_partner_pair_lagrange import source_edges,verify_price_rotation
from verify_full_partner_projection import weights,local_score,prefix_bound,point_data,compile_row,move,turn
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(Path(p).read_text())

def verify_record(Z,domain,selected,w,caps,edges,r):
 lam=list(map(Fraction,r['orbit_prices']));mu=list(map(Fraction,r['pair_prices']));assert len(lam)==45 and len(mu)==len(edges) and all(p>=0 for p in lam+mu)
 adjusted=[Fraction(a)-lam[j//16] for j,a in enumerate(w)]
 for (i,j),p in zip(edges,mu):adjusted[i]-=p;adjusted[j]-=p
 B=r['greedy_basis'];assert len(B)==len(set(B))==128
 zero=[j for j in B if domain['signatures'][j]==0];owners=[]
 for k in range(len(selected)):
  choices=[j for j in B if domain['signatures'][j]==1<<k];assert len(choices)==1;owners.append(choices[0])
 assert set(zero+owners)==set(B)
 adapted=dict(status='EXACT_FULL_PARTNER_BASIS_SUPPORT',value=r['greedy_adjusted_value'],selected_Z_indices=zero+owners,zero_basis_indices=zero,owner_indices=owners)
 prefixes=check_support(Z,selected,128,domain,adjusted,adapted)
 exact=prefix_bound(Z,domain,adjusted);penalty=sum(p*c for p,c in zip(lam,caps))+sum(mu);upper=exact+penalty;baseline=prefix_bound(Z,domain,w)
 assert Fraction(r['penalty'])==penalty and Fraction(r['upper'])==upper and Fraction(r['unrestricted_upper'])==baseline
 assert Fraction(r['improvement'])==baseline-upper>=0
 counts=[sum(j//16==o for j in B) for o in range(45)]+[int(i in B)+int(j in B) for i,j in edges];assert counts==r['greedy_counts']
 return upper,dict(prefix_rank_checks=prefixes,nonzero_orbit_prices=sum(p>0 for p in lam),nonzero_pair_prices=sum(p>0 for p in mu),exact_improvement=str(baseline-upper),greedy_cap_violations=sum(counts[o]>caps[o] for o in range(45)),greedy_pair_violations=sum(v>1 for v in counts[45:]))

def small_controls():
 # Source-like full-basis domain in3D, enumerated rather than greedily priced.
 V=list(range(1,8));bases=[B for B in combinations(range(7),3) if dimension(V[j] for j in B)==3];groups=[{0,1,2},{3,4,5,6}];edges=[(0,1),(3,4)];cases=inequalities=strict=0
 for caps in [(1,2),(2,2),(3,3)]:
  feasible=[B for B in bases if all(len(set(B)&g)<=cap for g,cap in zip(groups,caps)) and all(not(i in B and j in B) for i,j in edges)]
  for w in [[0]*7,[-j-1 for j in range(7)],[7,-2,5,-4,3,1,-6]]:
   baseline=max(sum(w[j] for j in B) for B in bases)
   for lam in [(Fraction(0),Fraction(0)),(Fraction(3,2),Fraction(2,3)),(Fraction(8),Fraction(1))]:
    for mu in [(Fraction(0),Fraction(0)),(Fraction(5),Fraction(2))]:
     adjusted=[Fraction(w[j])-sum(p for p,g in zip(lam,groups) if j in g)-sum(p for p,e in zip(mu,edges) if j in e) for j in range(7)]
     upper=max(sum(adjusted[j] for j in B) for B in bases)+sum(p*c for p,c in zip(lam,caps))+sum(mu)
     for B in feasible:assert sum(w[j] for j in B)<=upper;inequalities+=1
     strict+=upper<baseline;cases+=1
 assert strict>0 and inequalities>0
 return dict(literal_signed_price_cases=cases,literal_feasible_basis_inequalities=inequalities,strict_improvements=strict)

def matrix(banks,replays):
 from scipy.sparse import coo_matrix
 import numpy as np
 ii=[];jj=[];vv=[];rhs=[];metadata=[]
 assert len(banks)==len(replays)
 for path,rp in zip(banks,replays):
  b=read(path);fpath=Path(path).with_suffix('.frozen.json');f=read(fpath);r=read(rp)
  assert r['status']=='PASS' and r['bank_sha256']==sha(path) and r['frozen_sha256']==sha(fpath)==b['frozen_sha256'] and r['all_representatives_checked']==291
  assert all(sha(ROOT/p)==h for p,h in f['source_hashes'].items())
  assert r['source_hashes']==f['source_hashes']
  assert all(sha(ROOT/p)==h for p,h in r['dependencies'].items())
  assert sha(ROOT/r['profile_replay_path'])==r['profile_replay_sha256']
  assert r['upper_bound']==b['upper_bound'] and Fraction(r['exact_violation'])>0
  row,bound=compile_row(f['coefficients'],Fraction(b['upper_bound']),32);scale=math.lcm(bound.denominator,*(v.denominator for v in row.values()))
  assert r['compiled_owner_row']==[[j,str(v)] for j,v in row.items()] and Fraction(r['owner_rhs'])==bound
  assert scale<1<<40
  for col,v in row.items():q=int(scale*v);assert abs(q)<1<<53;ii.append(len(rhs));jj.append(col);vv.append(q)
  q=int(scale*bound);assert abs(q)<1<<53;rhs.append(q);metadata.append(dict(bank_sha256=sha(path),replay_sha256=sha(rp),integer_scaling=scale,source_necessary=True,priced_support=True))
 return coo_matrix((np.array(vv,dtype=np.int64),(ii,jj)),shape=(len(rhs),36495),dtype=np.int64).tocsr(),np.array(rhs,dtype=np.int64),metadata

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path,required=True);ap.add_argument('--profile-replay',type=Path,default=ROOT/'coupling-results/orbit-cap-price-source-profiles-independent.json');ap.add_argument('--point',type=Path,default=ROOT/'coupling-results/witness2-rational.json.gz');ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();bank=read(a.bank);fp=a.bank.with_suffix('.frozen.json');f=read(fp);assert bank['frozen_sha256']==sha(fp);assert all(sha(ROOT/p)==h for p,h in f['source_hashes'].items());assert f['orbit']==32
 parent=read(ROOT/f['parent_path']);parent_cut=parent['cuts'][f['parent_cut']];assert f['coefficients']==parent_cut['coefficients'];c=f['coefficients'];assert len(c)==775 and all(type(v)==int for v in c)
 X,Z,A=physical();assert all(pool==[int(v,16) for v in (ROOT/f'pools/{side}coords.txt').read_text().split()] for side,pool in [('x',X),('z',Z)])
 # Fresh separately executed physical45-orbit replay is bound here. It proves
 # every excluded profile and all65536 masks per orbit from physical vectors.
 source_path=ROOT/'algebraic-results/orbit-rank-profiles.json';profiles=read(source_path);receipt=read(a.profile_replay);assert receipt['status']=='PASS' and receipt['certificate_sha256']==sha(source_path)
 assert receipt['orbits_checked']==45 and receipt['phase_masks_per_orbit']==65536 and receipt['effective_dimension']==128
 assert all(receipt[k] is None for k in ['conditioned_on_anchor','conditioned_on_X_index','conditioned_on_X_absent'])
 caps=[r['full_frame_count_upper_bound'] for r in receipt['records']];assert caps==f['caps'] and [r['orbit'] for r in receipt['records']]==list(range(45))
 for p,r in zip(profiles['records'],receipt['records']):assert p['orbit']==r['orbit'] and p['maximum_surviving_count']==r['full_frame_count_upper_bound'] and p['survivors_by_weight']==r['survivors_by_weight']
 edges,edge_receipt=source_edges(X,Z,A);assert not f['edges'] or f['edges']==list(map(list,edges));edges=[tuple(e) for e in f['edges']]
 r32=next(r for r in profiles['records'] if r['orbit']==32);bad=bytearray(65536)
 for cert in r32['minimal_bad_certificates']:bad[cert['mask']]=1
 for mask in range(65536):
  if not bad[mask]:
   left=mask
   while left:
    bit=left&-left;left-=bit
    if bad[mask^bit]:bad[mask]=1;break
 allowed=[m for m in range(65536) if not bad[m]];representatives=sorted({min(turn(m,r) for r in range(16)) for m in allowed});assert len(allowed)==4597 and len(representatives)==291 and representatives==parent['representatives']
 assert f['masks']==representatives and [r['mask'] for r in bank['records']]==representatives and bank['all_parent_representatives_covered']
 maximum=None;records=[];rotation_checks=0;first_context=None
 for number,r in enumerate(bank['records']):
  mask=r['mask'];selected=[512+h for h in range(16) if mask>>h&1];domain=rebuild_domain(X,Z,selected,128);w=weights(mask,c);upper,result=verify_record(Z,domain,selected,w,caps,edges,r);full=upper+local_score(mask,c);assert r['mask_score']==local_score(mask,c) and Fraction(r['full_upper'])==full;maximum=full if maximum is None else max(maximum,full);result.update(mask=mask,full_upper=str(full));records.append(result)
  if first_context is None:first_context=domain,selected,w,r
  # Pair-price transport checks every rotated weight and degree. Orbit prices
  # stay fixed because rotation preserves j//16; explicitly check that fact.
  rotation_checks+=verify_price_rotation(mask,c,edges,r['pair_prices'])
  lam=list(map(Fraction,r['orbit_prices']))
  for shift in range(16):assert all(lam[move(j,shift)//16]==lam[j//16] for j in range(720))
  if number%50==0:print('CAP REPLAY',number,round(time.monotonic()-start,2),flush=True)
 assert maximum==Fraction(bank['upper_bound']) and Fraction(bank['parent_upper_bound'])==parent_cut['upper_bound']
 assert Fraction(bank['global_improvement'])==Fraction(parent_cut['upper_bound'])-maximum>0
 owner,target=point_data(a.point,32);exact_target=sum(Fraction(k)*v for k,v in zip(c,target));violation=exact_target-maximum;assert exact_target==Fraction(bank['exact_target_value']) and violation==Fraction(bank['exact_violation'])>0 and parent['point_sha256']==sha(a.point)
 row,rhs=compile_row(c,maximum,32);assert sum(v*owner[j] for j,v in row.items())-rhs==violation
 domain,selected,w,r=first_context;negative=0
 for kind in ('negative_price','false_upper','false_penalty'):
  corrupted=copy.deepcopy(r)
  if kind=='negative_price':corrupted['orbit_prices'][0]='-1'
  elif kind=='false_upper':corrupted['upper']=str(Fraction(r['upper'])-1)
  else:corrupted['penalty']=str(Fraction(r['penalty'])-1)
  try:verify_record(Z,domain,selected,w,caps,edges,corrupted)
  except AssertionError:negative+=1
  else:raise AssertionError('corruption accepted: '+kind)
 controls=small_controls();dependencies={p:sha(ROOT/p) for p in ['verify_full_partner_basis_oracle.py','verify_full_partner_projection.py','verify_full_partner_pair_lagrange.py','verify_orbit_rank_profiles.py','verify_algebraic_model.py','verify_partial_frame.py','audit_pools.py']}
 out=dict(status='PASS',source_C16_answered=False,bank_sha256=sha(a.bank),frozen_sha256=sha(fp),consumer_sha256=sha(Path(__file__)),source_hashes=f['source_hashes'],dependencies=dependencies,profile_replay_path=str(a.profile_replay.resolve().relative_to(ROOT)),profile_replay_sha256=sha(a.profile_replay),source_pair_replay=edge_receipt,point_sha256=sha(a.point),all_representatives_checked=291,allowed_masks_checked=4597,records=records,coefficients=c,upper_bound=str(maximum),parent_upper_bound=str(parent_cut['upper_bound']),global_improvement=str(Fraction(parent_cut['upper_bound'])-maximum),exact_target_value=str(exact_target),exact_violation=str(violation),owner_rhs=str(rhs),compiled_owner_row=[[j,str(v)] for j,v in row.items()],rotation_weight_and_price_checks=rotation_checks,corrupt_price_upper_penalty_controls_rejected=negative,small_controls=controls,elapsed_seconds=time.monotonic()-start,
          scope='Exact source-necessary projected inequality using full128-basis signed support plus nonnegative orbit-cap and pair prices over every allowed phase class. No claim of optimal prices, constrained-basis attainability, full frame, or source infeasibility.')
 a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['records','source_hashes','dependencies','compiled_owner_row','source_pair_replay']},flush=True)
if __name__=='__main__':main()
