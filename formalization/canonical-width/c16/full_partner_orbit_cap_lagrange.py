#!/usr/bin/env python3
"""Exact full-partner upper bounds from nonnegative orbit and pair prices.

For a source basis B, n_o(B)<=cap_o and |B intersect e|<=1. Hence
w(B)<=h_basis(w-lambda_orbit-degree(mu))+sum_o lambda_o cap_o+sum_e mu_e.
Prices are numerical discovery only; every retained bound is evaluated exactly.
"""
from pathlib import Path
from fractions import Fraction
import argparse,hashlib,json,time
import numpy as np
from scipy.optimize import linprog
from full_partner_basis_oracle import FullPartnerBasisOracle
from full_partner_pair_lagrange import forbidden_edges
from full_partner_projection_features import candidate_weights,mask_score
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def capacities():
 path=ROOT/'algebraic-results/orbit-rank-profiles-independent.json';r=json.loads(path.read_text());source=ROOT/'algebraic-results/orbit-rank-profiles.json'
 assert r['status']=='PASS' and r['certificate_sha256']==sha(source)
 assert not any(r.get(k) for k in ['conditioned_on_anchor','conditioned_on_X_index','conditioned_on_X_absent'])
 assert [x['orbit'] for x in r['records']]==list(range(45))
 return [x['full_frame_count_upper_bound'] for x in r['records']]

def exact_bound(oracle,domain,weights,caps,edges,orbit_prices,pair_prices):
 lam=list(map(Fraction,orbit_prices));mu=list(map(Fraction,pair_prices));assert len(lam)==len(caps)==45 and len(mu)==len(edges);assert all(x>=0 for x in lam+mu)
 adjusted=[Fraction(w)-lam[j//16] for j,w in enumerate(weights)]
 for (i,j),p in zip(edges,mu):adjusted[i]-=p;adjusted[j]-=p
 support=oracle.support(domain,adjusted);assert support['status']=='EXACT_FULL_PARTNER_BASIS_SUPPORT';B=set(support['selected_Z_indices'])
 counts=[sum(j//16==o for j in B) for o in range(45)]+[int(i in B)+int(j in B) for i,j in edges]
 penalty=sum(p*c for p,c in zip(lam,caps))+sum(mu)
 return dict(upper=support['value']+penalty,support=support,orbit_prices=lam,pair_prices=mu,counts=counts,raw_weight=sum(Fraction(weights[j]) for j in B),penalty=penalty)

def optimize_bound(oracle,domain,weights,caps,edges=(),rounds=60,denominator=1024):
 start=time.monotonic();first=exact_bound(oracle,domain,weights,caps,edges,[0]*45,[0]*len(edges));best=proposed=first;history=[];rows=[];rhs=[];seen=set();limits=list(caps)+[1]*len(edges)
 scale=max(1,max(weights)-min(weights));price_cap=2.;last_lp=None
 for iteration in range(rounds):
  key=tuple(proposed['counts']),proposed['raw_weight']
  if key not in seen:
   seen.add(key);rows.append([-n for n in proposed['counts']]+[-1]);rhs.append(-float(proposed['raw_weight']/scale))
  lp=linprog([*limits,1],A_ub=np.array(rows,dtype=float),b_ub=np.array(rhs),bounds=[(0,price_cap)]*len(limits)+[(None,None)],method='highs')
  if not lp.success:history.append(dict(iteration=iteration,LP_status=int(lp.status),message=lp.message));break
  prices=[Fraction(max(0,round(float(v)*scale*denominator)),denominator) for v in lp.x[:-1]]
  proposed=exact_bound(oracle,domain,weights,caps,edges,prices[:45],prices[45:])
  if proposed['upper']<best['upper']:best=proposed
  last_lp=float(lp.fun)*scale;history.append(dict(iteration=iteration,restricted_LP_lower_approximation=last_lp,exact_upper=str(proposed['upper']),best_exact_upper=str(best['upper'])))
  if float(best['upper'])-last_lp<=1e-5:break
 return dict(status='EXACT_CAP_PAIR_LAGRANGE_UPPER_CANDIDATE',upper=str(best['upper']),unrestricted_upper=str(first['upper']),improvement=str(first['upper']-best['upper']),orbit_prices=list(map(str,best['orbit_prices'])),pair_prices=list(map(str,best['pair_prices'])),greedy_basis=list(best['support']['selected_Z_indices']),greedy_adjusted_value=str(best['support']['value']),penalty=str(best['penalty']),greedy_counts=best['counts'],rounds=len(history),history=history,seconds=time.monotonic()-start,
             scope='Valid upper bound after independent replay; no price optimality or constrained basis existence claim.')

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--parent',type=Path,default=ROOT/'coupling-results/full-partner-projection-wolfe-witness2.json');ap.add_argument('--parent-replay',type=Path,default=ROOT/'coupling-results/full-partner-projection-wolfe-witness2-independent.json');ap.add_argument('--cut',type=int,default=0);ap.add_argument('--rounds',type=int,default=60);ap.add_argument('--masks',type=int,default=291);ap.add_argument('--pair-prices',action='store_true');ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();assert not args.output.exists() and not args.output.with_suffix('.frozen.json').exists();start=time.monotonic()
 parent=json.loads(args.parent.read_text());receipt=json.loads(args.parent_replay.read_text());assert receipt['status']=='PASS';assert receipt['bank_sha256']==sha(args.parent)
 cut=parent['cuts'][args.cut];coefficients=cut['coefficients'];masks=parent['representatives'][:args.masks];caps=capacities();edges=forbidden_edges() if args.pair_prices else []
 paths=[args.parent,args.parent_replay,Path(__file__),ROOT/'full_partner_basis_oracle.py',ROOT/'full_partner_pair_lagrange.py',ROOT/'full_partner_projection_features.py',ROOT/'algebraic-results/orbit-rank-profiles.json',ROOT/'algebraic-results/orbit-rank-profiles-independent.json',ROOT/'moment-resumption-results/all-pair-word-cuts.json',ROOT/'moment-resumption-results/all-pair-moment-faces.json',ROOT/'physical-pool-source.json',ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt']
 frozen=dict(status='FROZEN_BEFORE_CAP_PAIR_PRICING',parent_path=str(args.parent.resolve().relative_to(ROOT)),parent_cut=args.cut,coefficients=coefficients,masks=masks,orbit=32,caps=caps,edges=edges,rounds=args.rounds,price_denominator=1024,price_search_cap_in_weight_range_units=2,source_hashes={str(p.resolve().relative_to(ROOT)):sha(p) for p in paths},scope='Numerical price proposal with exact retained bounds. No claim of price optimality.')
 fp=args.output.with_suffix('.frozen.json');fp.write_text(json.dumps(frozen,indent=2)+'\n');oracle=FullPartnerBasisOracle();records=[]
 for number,mask in enumerate(masks):
  w=candidate_weights(mask,coefficients);r=optimize_bound(oracle,oracle.prepare(32,mask),w,caps,edges,args.rounds);r.update(mask=mask,mask_score=mask_score(mask,coefficients),full_upper=str(Fraction(r['upper'])+mask_score(mask,coefficients)));records.append(r)
  if number%25==0:print('CAP PRICE',number,mask,r['improvement'],r['rounds'],round(time.monotonic()-start,2),flush=True)
 upper=max(Fraction(r['full_upper']) for r in records);target=Fraction(cut['exact_target_value']);out=dict(status='EXACT_PRICED_SUPPORT_CANDIDATE',source_C16_answered=False,frozen_sha256=sha(fp),records=records,all_parent_representatives_covered=masks==parent['representatives'],improved_mask_bounds=sum(Fraction(r['improvement'])>0 for r in records),upper_bound=str(upper),parent_upper_bound=str(cut['upper_bound']),global_improvement=str(Fraction(cut['upper_bound'])-upper),exact_target_value=str(target),exact_violation=str(target-upper),elapsed_seconds=time.monotonic()-start,
               scope='For complete representative coverage, candidate stronger source projected row with unchanged coefficients. Consumer must replay capacities, prices, support and rotation transport before acceptance. Incomplete cohorts are diagnostics only.')
 args.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='records'},flush=True)
if __name__=='__main__':main()
