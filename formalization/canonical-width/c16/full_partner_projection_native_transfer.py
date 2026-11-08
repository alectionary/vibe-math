#!/usr/bin/env python3
"""Frozen literal cross-orbit transfer; fresh exact supports, no symmetry assumed.

The entire44-orbit cohort is frozen. Orbits24,27,31 form an early stop gate:
if both normals have normalized gaps<=-1/20 on allthree, remaining targets are
explicitly unpriced. Orbit32 is a positive raw-normal control. Every priced
support is compared with the original Python oracle and independent low-pivot
prefix ranks. Positive cuts still require the generic source consumer.
"""
from pathlib import Path
from fractions import Fraction
import argparse,gzip,hashlib,json,time
from full_partner_native import NativeFullPartnerBatch
from full_partner_basis_oracle import FullPartnerBasisOracle
from full_partner_projection import mask_universe
from full_partner_projection_features import moment_target
from verify_projected_profile_moment_rows import point_vector
from verify_full_partner_projection import weights,local_score,literal_features,FEATURE_LAYOUT
from verify_full_partner_basis_oracle import rebuild_domain,check_support
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
PILOT=(24,27,31)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 raw=Path(p).read_bytes();return json.loads(gzip.decompress(raw) if str(p).endswith('.gz') else raw)
def write(p,x):
 assert not p.exists();raw=(json.dumps(x,indent=2)+'\n').encode();p.write_bytes(gzip.compress(raw,mtime=0) if str(p).endswith('.gz') else raw)

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic()
 entries=[('small64','coupling-results/native775-witness9-gauge-rounded.json.gz','coupling-results/native775-witness9-gauge-rounded-independent.json',7),('latest_raw','coupling-results/native775-witness10.json.gz','coupling-results/native775-witness10-independent.json',0)];directions=[];sources=[]
 for name,bp,rp,index in entries:
  bank=read(ROOT/bp);receipt=read(ROOT/rp);assert receipt['status']=='PASS' and receipt['bank_sha256']==sha(ROOT/bp);cut=bank['cuts'][index];directions.append(dict(name=name,source_bank=bp,source_bank_sha256=sha(ROOT/bp),source_receipt_sha256=sha(ROOT/rp),source_cut_index=index,coefficients=cut['coefficients'],pricing_scale=cut['pricing_scale']));sources.extend([bp,rp])
 for orbit in PILOT:
  p=f'coupling-results/native775-transfer-orbit{orbit}-source-controls.json';r=read(ROOT/p);assert r['status']=='PASS' and r['orbit']==orbit and r['consumer_sha256']==sha(ROOT/'verify_full_partner_projection_multi_orbit.py');assert all(sha(ROOT/s)==h for s,h in r['source_hashes'].items());sources.append(p)
 sources+=['full_partner_projection_native_transfer.py','full_partner_native.py','full_partner_anchor_native.py','full_partner_anchor_native.cpp','full_partner_anchor_basis_oracle.py','full_partner_basis_oracle.py','full_partner_projection.py','full_partner_projection_features.py','verify_projected_profile_moment_rows.py','verify_full_partner_projection.py','verify_full_partner_projection_multi_orbit.py','verify_full_partner_basis_oracle.py','verify_algebraic_model.py','verify_partial_frame.py','audit_pools.py','audit_pool_symmetry.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','algebraic-results/orbit-rank-profiles.json.gz','algebraic-results/hulls-16-rank.json.gz','coupling-results/full-partner-all-orbit-profile-inventory.json','coupling-results/native775-transfer-symmetry-replay.json','coupling-results/native-full-partner-union-accepted.json','coupling-results/anchor-native-accepted.dylib'];hashes={p:sha(ROOT/p) for p in sorted(set(sources))};orbits=[o for o in range(45) if o!=12]
 frozen=dict(status='FROZEN_BEFORE_NATIVE_CROSS_ORBIT_TRANSFER',source_C16_answered=False,point_sha256=sha(a.point),source_hashes=hashes,orbits=orbits,pilot_orbits=list(PILOT),control_orbit=32,directions=directions,early_stop='Stop after pilot if every pilot normal has exact normalizedgap<=-1/20; remainingcohort explicitlyunpriced.',orbit12_excluded='Its mask enumeration needs an extra cap11 source proof not wired to the generic consumer.',symmetry='Existing complete pairing-graph symmetry proof fixes everyorbit setwise. Only literal coefficient transfer is attempted; no invented Zorbit permutation.',scope='Fixed-normal transfer screen. Negative gaps reject only these normals, not membership or other separating directions; no fullsource-frame claim.')
 fp=a.output.with_suffix('.frozen.json');write(fp,frozen);owner=point_vector(a.point);X,Z,_=physical();oracle=FullPartnerBasisOracle(X,Z);results=[];gaps={};support_queries=0;prefix_checks=0
 order=[32,*PILOT]+[o for o in orbits if o not in (32,*PILOT)];stop=False
 for orbit in order:
  if orbit not in (32,*PILOT) and all(g<=Fraction(-1,20) for o in PILOT for g in gaps[o]):stop=True;break
  allowed,reps=mask_universe(orbit);target=moment_target(owner,orbit);domains=[oracle.prepare(orbit,m) for m in reps];independent=[rebuild_domain(X,Z,[16*orbit+h for h in range(16) if m>>h&1],128) for m in reps];assert all(d['status']=='FULL_PARTNER_BASIS_DOMAIN' for d in domains+independent);batch=NativeFullPartnerBatch(reps,orbit=orbit);proposals=[];cuts=[];gaps[orbit]=[]
  for direction in directions:
   t=time.monotonic();c=direction['coefficients'];native=batch.price(c);native_seconds=time.monotonic()-t;t=time.monotonic();records=[];prefixes=0
   for i,(m,d,q) in enumerate(zip(reps,domains,independent)):
    w=weights(m,c);old=oracle.support(d,w);assert int(native['values'][i])==old['value'];B=list(map(int,native['bases'][i]));nz=128-m.bit_count();record=dict(mask=m,support_value=int(native['values'][i]),full_value=int(native['full_values'][i]),selected_Z_indices=B,zero_basis_indices=B[:nz],owner_indices=B[nz:]);adapted={**record,'status':'EXACT_FULL_PARTNER_BASIS_SUPPORT','value':record['support_value']};prefixes+=check_support(Z,[16*orbit+h for h in range(16) if m>>h&1],128,q,w,adapted);assert record['full_value']==local_score(m,c)+record['support_value']==sum(v*f for v,f in zip(c,literal_features(m,B)));records.append(record)
   upper=max(r['full_value'] for r in records);exact=sum(x*y for x,y in zip(c,target));gap=exact-upper;gaps[orbit].append(gap/direction['pricing_scale']);proposal={**direction,'upper_bound':upper,'exact_target_value':str(exact),'exact_violation':str(gap),'normalized_gap':float(gap/direction['pricing_scale']),'support_records':records,'native_seconds':native_seconds,'python_and_independent_seconds':time.monotonic()-t,'independent_prefix_rank_checks':prefixes};proposals.append(proposal);support_queries+=len(reps);prefix_checks+=prefixes
   if gap>0:cuts.append(proposal)
   print(json.dumps({k:proposal[k] for k in ('name','upper_bound','exact_target_value','exact_violation','normalized_gap','native_seconds','python_and_independent_seconds')}|dict(orbit=orbit,representatives=len(reps))),flush=True)
  cuts.sort(key=lambda c:Fraction(c['exact_violation'])/c['pricing_scale'],reverse=True);cuts=cuts[:1] if orbit!=32 else []
  report={**frozen,'status':'EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_FIXED_FUNCTIONAL_SEPARATOR','frozen_sha256':sha(fp),'orbit':orbit,'feature_layout':FEATURE_LAYOUT,'allowed_masks':len(allowed),'representatives':reps,'allowed_mask_list_sha256':hashlib.sha256(json.dumps(allowed,separators=(',',':')).encode()).hexdigest(),'proposals':proposals,'cuts':cuts};path=a.output.with_name(a.output.stem+f'-orbit{orbit}.json.gz');write(path,report);results.append(dict(orbit=orbit,bank=str(path),bank_sha256=sha(path),representatives=len(reps),positive_cut_count=len(cuts),queries=[{k:r[k] for k in ('name','upper_bound','exact_target_value','exact_violation','normalized_gap','native_seconds','python_and_independent_seconds','independent_prefix_rank_checks')} for r in proposals]));batch.close()
 assert all(sha(ROOT/p)==h for p,h in hashes.items());tested=[r['orbit'] for r in results];out={**frozen,'status':'PASS_EXACT_BOUNDED_LITERAL_TRANSFER_SCREEN','frozen_sha256':sha(fp),'results':results,'tested_orbits':tested,'unpriced_orbits':[o for o in orbits if o not in tested],'early_stopped':stop,'positive_new_orbits':[r['orbit'] for r in results if r['positive_cut_count']],'exact_support_queries_compared_with_python':support_queries,'independent_prefix_rank_checks':prefix_checks,'elapsed_seconds':time.monotonic()-start};write(a.output,out);print({k:out[k] for k in ('status','tested_orbits','unpriced_orbits','early_stopped','positive_new_orbits','exact_support_queries_compared_with_python','elapsed_seconds')},flush=True)

if __name__=='__main__':main()
