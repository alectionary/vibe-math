#!/usr/bin/env python3
"""One exact local-hull pilot after deleting an absent opposite-pool vector."""
from pathlib import Path
import argparse,gzip,hashlib,json,time,warnings
import numpy as np
from scipy.optimize import linprog,OptimizeWarning
from scipy.linalg import qr
from flint import fmpq,fmpq_mat
from certify_profile_moment_point import layout
from conditional_profile_hull_witness import allowed,check
warnings.filterwarnings('ignore',message='Unrecognized options detected.*',category=OptimizeWarning)
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--profile',type=Path,required=True);ap.add_argument('--hulls',type=Path,required=True);ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--verify-only',action='store_true');ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();d=json.loads(gzip.decompress(a.profile.read_bytes()));assert d['selected_quotient_sector']=='Z' and d['conditioned_on_X_absent']%16==0;i=d['conditioned_on_X_absent']//16;hulls=json.loads(gzip.decompress(a.hulls.read_bytes()));_,ix,m=layout(hulls);v=list(map(fmpq,json.loads(gzip.decompress(a.point.read_bytes()))['values']));inputs={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [a.point,a.profile,a.hulls]};frozen=json.loads(gzip.decompress(a.certificate.read_bytes())) if a.verify_only else None;out=[]
 if frozen:assert frozen['inputs']==inputs
 for row in d['records']:
  o=row['orbit'];masks=allowed(row,-1,'Z');q=[(v[ix['p',o]]-v[m('T',h,i,o)])/(1-v[ix['p',i]]) for h in range(16)]
  if frozen:r=next(r for r in frozen['records'] if r['orbit']==o);chosen=r['masks'];weights=list(map(fmpq,r['weights']))
  else:
   B=np.vstack([np.ones(len(masks)),*[((masks>>h)&1).astype(float) for h in range(16)]]);b=[fmpq(1)]+q;run=linprog(np.zeros(len(masks)),A_eq=B,b_eq=np.array(list(map(float,b))),bounds=(0,None),method='highs-ds',options={'threads':1,'time_limit':20,'primal_feasibility_tolerance':1e-9});assert run.success,(o,run.message);support=np.flatnonzero(run.x>1e-11);chosen=list(map(int,masks[support]));A=B[:,support];k=len(support);_,R,rr=qr(A.T,pivoting=True,mode='economic');rr=rr[:k];assert abs(R[k-1,k-1])>1e-8;weights=list(fmpq_mat(A[rr,:].astype(np.int64).tolist()).solve(fmpq_mat([[b[j]] for j in rr])))
  check(weights,chosen,q,set(map(int,masks)));out.append({'orbit':o,'masks':chosen,'weights':list(map(str,weights))})
 assert len(out)==45 and {r['orbit'] for r in out}==set(range(45))
 if not frozen:a.certificate.write_bytes(gzip.compress(json.dumps({'status':'CANDIDATE_EXACT_DELETED_POOL_LOCAL_DECOMPOSITIONS','inputs':inputs,'records':out},separators=(',',':')).encode(),mtime=0))
 report={'status':'PASS','source_C16_answered':False,'fixed_absent_X_index':16*i,'local_Z_orbit_decompositions_checked':45,'all16_first_moments_exact':True,'nonnegative_convex_weights_exact':True,'inputs':inputs,'certificate_sha256':hashlib.sha256(a.certificate.read_bytes()).hexdigest(),'elapsed_seconds':time.monotonic()-start,'scope':'One deleted-vector absence pilot. The saved rational point survives all45 local Z polytopes for X336 absent; the other44 normalized deleted-X dictionaries are not tested.'};a.output.write_text(json.dumps(report,indent=2)+'\n');print(report,flush=True)
if __name__=='__main__':main()
