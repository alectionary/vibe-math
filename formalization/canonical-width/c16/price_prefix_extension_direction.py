#!/usr/bin/env python3
"""Reprice bounded LP dual snapshots; their solver status is never trusted."""
from pathlib import Path
import argparse,hashlib,json,gzip,time
from fractions import Fraction
import numpy as np
from full_partner_projection_native_wolfe_v2 import local_imports,write,read,LAYOUT
from full_partner_projection import mask_universe
from full_partner_projection_features import moment_target
from full_partner_native import NativeFullPartnerBatch
from verify_projected_profile_moment_rows import point_vector
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--snapshot',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();t=time.monotonic();d=np.load(a.snapshot);raw=np.array(d['ray'] if 'ray' in d else d['row_dual'])[:775];assert len(raw)==775 and np.all(np.isfinite(raw));raw[0]=0;allowed,reps=mask_universe(32);target=moment_target(point_vector(a.point),32)
 paths=set();local_imports(Path(__file__).resolve(),paths);paths.update(ROOT/p for p in ['physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','algebraic-results/orbit-rank-profiles.json.gz','algebraic-results/hulls-16-rank.json.gz','full_partner_anchor_native.cpp','coupling-results/anchor-native-accepted.dylib','coupling-results/native-full-partner-union-accepted.json']);hashes={str(p.relative_to(ROOT)):sha(p) for p in sorted(paths)}
 frozen={'status':'FROZEN_BEFORE_SNAPSHOT_REPRICING','source_C16_answered':False,'point_sha256':sha(a.point),'snapshot_sha256':sha(a.snapshot),'source_hashes':hashes,'orbit':32,'feature_layout':LAYOUT,'allowed_masks':len(allowed),'representatives':reps,'scales':[1,4,16,64,256,4096,65536,16777216],'both_signs':True,'scope':'Numerical dual vector is only a coefficient proposal; exact full support and independent consumer required.'};fp=Path(str(a.output).replace('.json.gz','.frozen.json'));assert not fp.exists();write(fp,frozen);cuts=[];tests=[];seen=set();batch=NativeFullPartnerBatch(reps,library=ROOT/'coupling-results/anchor-native-accepted.dylib')
 if max(abs(raw))>0:
  raw/=max(abs(raw))
  for sign in [1,-1]:
   for scale in frozen['scales']:
    c=[int(np.rint(sign*scale*v)) for v in raw];key=tuple(c)
    if key in seen:continue
    seen.add(key);p=batch.price(c);bound=max(map(int,p['full_values']));value=sum(v*x for v,x in zip(c,target));gap=value-bound;tests.append({'sign':sign,'scale':scale,'exact_gap':str(gap),'scaled_gap':float(gap/scale),'upper_bound':bound,'nonzero_coefficients':sum(v!=0 for v in c)})
    if gap>0:
     records=[]
     for i,m in enumerate(reps):
      B=list(map(int,p['bases'][i]));nz=128-m.bit_count();records.append({'mask':m,'support_value':int(p['values'][i]),'full_value':int(p['full_values'][i]),'selected_Z_indices':B,'zero_basis_indices':B[:nz],'owner_indices':B[nz:]})
     cuts.append({'coefficients':c,'upper_bound':bound,'exact_target_value':str(value),'exact_violation':str(gap),'pricing_scale':scale,'support_records':records})
 batch.close();assert all(sha(ROOT/p)==v for p,v in hashes.items());write(a.output,{**frozen,'status':'EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_EXACT_SEPARATOR_FOUND','frozen_sha256':sha(fp),'cuts':cuts,'tests':tests,'elapsed_seconds':time.monotonic()-t});print({'cuts':len(cuts),'tests':tests},flush=True)
if __name__=='__main__':main()
