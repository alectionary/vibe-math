#!/usr/bin/env python3
"""Exact small-flat screen of a certified pattern count allocation.

Every exported row is a physical linear-matroid rank inequality after joint
contraction of forced zero anchors. Failure rejects this allocation only.
No unrelated source forbidden-pair constraints are used.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import defaultdict,Counter
from itertools import combinations
from math import lcm
import argparse,gzip,hashlib,json,time
from verify_two_sided_full_basis_oracle import physical_source,domains

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_text())
def pivots(vectors):
 rows={}
 for v in vectors:
  while v:
   p=v.bit_length()-1
   if p in rows:v^=rows[p]
   else:rows[p]=v;break
 return rows
def quotient(v,P):
 for p in sorted(P,reverse=True):
  if v>>p&1:v^=P[p]
 return v

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--receipt',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=60);ap.add_argument('--rank3-limit',type=int,default=200000);a=ap.parse_args();assert not a.output.exists() and 0<a.seconds<=60
 start=time.monotonic();deadline=start+a.seconds;bank=read(a.certificate);receipt=read(a.receipt)
 consumer_names={'PASS_EXACT_DIRECT_PATTERN_COUNT_ALLOCATION':'verify_two_basis_direct_allocation.py','PASS_EXACT_DIRECT_PATTERN_COUNT_AND_RANK_ALLOCATION':'verify_two_basis_rank_allocation.py'}
 assert receipt['status'] in consumer_names and receipt['certificate_sha256']==sha(a.certificate)
 assert receipt['consumer_sha256']==sha(ROOT/consumer_names[receipt['status']])
 fp=a.certificate.with_name(a.certificate.name.removesuffix('.json.gz').removesuffix('.json')+'.frozen.json');f=read(fp);assert receipt['frozen_sha256']==sha(fp)
 xx,zz,side=f['X_anchors'],f['Z_anchors'],f['side'];lam=list(map(Q,f['lambda_masses']));y=[list(map(Q,r)) for r in bank['exact_allocations']]
 X,Z,_=physical_source();U=X if side=='X' else Z;dd=[d[side] for d in domains(X,Z,xx,zz)]
 frozen=dict(status='FROZEN_BEFORE_EXACT_SMALL_FLAT_SCREEN',source_C16_answered=False,
  certificate_sha256=sha(a.certificate),receipt_sha256=sha(a.receipt),point_sha256=f['point_sha256'],side=side,X_anchors=xx,Z_anchors=zz,
  producer_sha256=sha(__file__),source_hashes={p:sha(ROOT/p) for p in ['verify_two_sided_full_basis_oracle.py',consumer_names[receipt['status']],'physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']},
  seconds=a.seconds,rank3_flat_limit_per_pattern=a.rank3_limit,
  scope='Exact linear-matroid ranks on one allocation, withforcedzerocontraction. No globaltargetseparation orsourceanswer.')
 ff=a.output.with_suffix('.frozen.json');assert not ff.exists();ff.write_text(json.dumps(frozen,indent=2)+'\n')
 records=[];cuts=[]
 for m,d in enumerate(dd):
  if not lam[m]:continue
  if time.monotonic()>=deadline:break
  fixed=d['zero_forced'];P=pivots(U[j] for j in fixed);assert len(P)==len(fixed)
  groups=defaultdict(list)
  for j in d['zero_free']:groups[quotient(U[j],P)].append(j)
  denominator=lcm(lam[m].denominator,*(y[m][j].denominator for j in d['zero_free']))
  unit=int(lam[m]*denominator);mass={v:sum(int(y[m][j]*denominator) for j in indices) for v,indices in groups.items()}
  zero_mass=mass.get(0,0);values=sorted(v for v in groups if v);counts=Counter();violations=Counter();kept=[];seen=set();complete=True
  def check_flat(vectors,r):
   nonlocal kept
   key=tuple(sorted(set(v for v in vectors if v in groups and v)))
   if key in seen:return
   seen.add(key);counts[r]+=1;lhs=zero_mass+sum(mass[v] for v in key);gap=lhs-r*unit
   if gap<=0:return
   violations[r]+=1;indices=sorted([*groups.get(0,[]),*[j for v in key for j in groups[v]]])
   actual=len(pivots([*[U[j] for j in fixed],*[U[j] for j in indices]]))-len(P);assert actual==r
   cut=dict(mask=m,side=side,forced_zero_indices=fixed,indices=indices,contraction_rank=r,
            physical_span_rank=r+len(P),lambda_mass=str(lam[m]),exact_lhs=str(Q(lhs,denominator)),
            exact_bound=str(r*lam[m]),exact_violation=str(Q(gap,denominator)),
            inequality='sum_{j in indices} allocation[mask,j] <= contraction_rank*lambda[mask]')
   kept.append(cut);kept.sort(key=lambda q:Q(q['exact_violation']),reverse=True);del kept[8:]
  check_flat([],0)
  for v in values:check_flat([v],1)
  pair_sums=defaultdict(list)
  for ia,v in enumerate(values):
   if time.monotonic()>=deadline:complete=False;break
   for w in values[ia+1:]:
    s=v^w;pair_sums[s].append((v,w))
    if w<s and s in groups:check_flat([v,w,s],2)
  rank3_count=0
  if complete:
   for pairs in pair_sums.values():
    if len(pairs)<2:continue
    for (v,w),(u,t) in combinations(pairs,2):
     if rank3_count>=a.rank3_limit or time.monotonic()>=deadline:complete=False;break
     span=[v,w,u,v^w,v^u,w^u,v^w^u]
     assert len(set(span))==7
     before=counts[3];check_flat(span,3);rank3_count+=counts[3]-before
    if not complete:break
  cuts.extend(kept)
  rec=dict(mask=m,lambda_mass=str(lam[m]),forced_zero_count=len(fixed),zero_free_count=len(d['zero_free']),
           quotient_nonzero_classes=len(values),quotient_loop_count=len(groups.get(0,[])),
           flats_checked={str(k):v for k,v in sorted(counts.items())},violated_flats={str(k):v for k,v in sorted(violations.items())},
           retained_cuts=len(kept),screen_completed_within_caps=complete)
  records.append(rec);print(json.dumps(rec),flush=True)
 out=dict(frozen);out.update(status='EXACT_PATTERN_RANK_VIOLATIONS_REQUIRE_REPLAY' if cuts else 'NO_SMALL_FLAT_VIOLATION_FOUND',
  frozen_sha256=sha(ff),patterns_checked=records,cuts=cuts,elapsed_seconds=time.monotonic()-start,
  full_matroid_membership_proved=False,global_target_nonmembership_proved=False)
 assert all(sha(ROOT/p)==h for p,h in frozen['source_hashes'].items());a.output.write_text(json.dumps(out,indent=2)+'\n')
 print(json.dumps({'status':out['status'],'patterns':len(records),'cuts':len(cuts),'seconds':out['elapsed_seconds']}),flush=True)

if __name__=='__main__':main()
