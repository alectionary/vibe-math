#!/usr/bin/env python3
"""All291 representative exact branch-union gate with frozen signed cohorts."""
from pathlib import Path
from fractions import Fraction
import argparse,hashlib,json,time
import numpy as np
from full_partner_native import NativeFullPartnerBatch
from full_partner_basis_oracle import FullPartnerBasisOracle
from verify_full_partner_basis_oracle import rebuild_domain,check_support
from verify_algebraic_model import physical
from verify_full_partner_projection import weights,local_score
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,obj):
 assert not p.exists();p.write_text(json.dumps(obj,indent=2)+'\n')

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic()
 parent=ROOT/'coupling-results/anchor-native-matched-accepted.frozen.json';base=json.loads(parent.read_text());masks=sorted({min(((m<<h)|(m>>(16-h)))&65535 for h in range(16)) for m in base['masks']});assert len(masks)==291
 cohorts=[{'name':r['name'],'coefficients':r['coefficients'][:775]} for r in base['cohorts']];library=ROOT/'coupling-results/anchor-native-accepted.dylib'
 paths=[Path(__file__),ROOT/'full_partner_native.py',ROOT/'full_partner_anchor_native.py',ROOT/'full_partner_anchor_native.cpp',ROOT/'full_partner_anchor_basis_oracle.py',ROOT/'full_partner_basis_oracle.py',ROOT/'verify_full_partner_basis_oracle.py',ROOT/'verify_full_partner_projection.py',ROOT/'verify_algebraic_model.py',ROOT/'verify_partial_frame.py',ROOT/'audit_pools.py',ROOT/'physical-pool-source.json',ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt',ROOT/'coupling-results/anchor-native-matched-accepted.json',parent,library]
 frozen={'status':'FROZEN_BEFORE_UNCONDITIONED_NATIVE_UNION_GATE','orbit':32,'anchor':80,'representatives':masks,'cohorts':cohorts,'source_hashes':{str(p.relative_to(ROOT)):sha(p) for p in paths},'scope':'Exact arbitrary signed objective support on291 representative masks, comparing both-anchor union to the frozen unconditioned Python oracle and independent prefix-rank proof. Rotation-equivariant global support requires separate caller proof.'}
 fp=a.output.with_suffix('.frozen.json');write(fp,frozen)
 t=time.monotonic();batch=NativeFullPartnerBatch(masks,library=library);native_prepare=time.monotonic()-t
 X,Z,_=physical();oracle=FullPartnerBasisOracle(X,Z);prepared=[oracle.prepare(32,m) for m in masks];independent=[rebuild_domain(X,Z,[512+h for h in range(16) if m>>h&1],128) for m in masks]
 stats=[];allvalues=[];allfull=[];allbases=[];prefixes=0;differing_bases=0
 for cohort in cohorts:
  c=cohort['coefficients'];t=time.monotonic();native=batch.price(c);elapsed=time.monotonic()-t;assert native['backend']=='native_int64'
  t=time.monotonic();records=[];ws=[]
  for mask,d in zip(masks,prepared):
   w=weights(mask,c);ws.append(w);records.append(oracle.support(d,w))
  python_seconds=time.monotonic()-t;t=time.monotonic()
  for i,(mask,d,w,r) in enumerate(zip(masks,independent,ws,records)):
   assert native['values'][i]==r['value'] and native['full_values'][i]==r['value']+local_score(mask,c)
   B=list(map(int,native['bases'][i]));k=mask.bit_count();selected=[512+h for h in range(16) if mask>>h&1]
   record={'status':'EXACT_FULL_PARTNER_BASIS_SUPPORT','selected_Z_indices':B,'zero_basis_indices':B[:128-k],'owner_indices':B[128-k:],'value':int(native['values'][i])}
   prefixes+=check_support(Z,selected,128,d,w,record);differing_bases+=B!=list(r['selected_Z_indices'])
  replay_seconds=time.monotonic()-t
  # Repeat native pricing only to estimate the warmed production pass cost.
  timing=[]
  for repeat in range(5):
   t=time.monotonic();again=batch.price(c);timing.append(time.monotonic()-t);assert np.array_equal(again['values'],native['values']) and np.array_equal(again['bases'],native['bases'])
  stat={'cohort':cohort['name'],'native_first_seconds':elapsed,'native_median_seconds':float(np.median(timing)),'python_seconds':python_seconds,'speedup':python_seconds/float(np.median(timing)),'independent_replay_seconds':replay_seconds,'masks_checked':len(masks)};stats.append(stat);print(stat,flush=True)
  allvalues.append(native['values']);allfull.append(native['full_values']);allbases.append(native['bases'])
 # The union also preserves exact fallback and negative full basis rank.
 tiny=NativeFullPartnerBatch([0],library=library);big=[0]*775;big[10:55]=[1<<70]*45;large=tiny.price(big);assert large['backend']=='python_exact_fallback' and large['values'][0]==128*(1<<70)
 rat=[0]*775;rat[10:55]=[Fraction(-1,3)]*45;r=tiny.price(rat);assert r['backend']=='python_exact_fallback' and r['values'][0]==Fraction(-128,3);tiny.close()
 npz=a.output.with_suffix('.npz');assert not npz.exists();np.savez_compressed(npz,values=np.array(allvalues),full_values=np.array(allfull),bases=np.array(allbases));assert all(sha(ROOT/p)==h for p,h in frozen['source_hashes'].items())
 out={'status':'PASS_EXACT_UNCONDITIONED_NATIVE_UNION_GATE','source_C16_answered':False,'source_hashes':frozen['source_hashes'],'frozen_sha256':sha(fp),'arrays_sha256':sha(npz),'native_prepare_seconds':native_prepare,'cohorts':stats,'exact_source_queries':291*4,'independent_prefix_rank_checks':prefixes,'different_but_optimal_basis_orders':differing_bases,'overflow_and_negative_fraction_controls':2,'elapsed_seconds':time.monotonic()-start,'scope':frozen['scope']};write(a.output,out);print({k:v for k,v in out.items() if k not in ('source_hashes','cohorts')},flush=True)

if __name__=='__main__':main()
