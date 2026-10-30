"""Exact45-orbit-occupancy mixture recovery from archived physical Z bases."""
from pathlib import Path
from fractions import Fraction
import argparse,gzip,hashlib,json,time
import numpy as np
from scipy.optimize import linprog
from recover_full_partner_mixture import exact_recover
from verify_projected_profile_moment_rows import point_vector
from full_partner_basis_oracle import rank
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,obj):
    b=(json.dumps(obj,indent=2)+'\n').encode();Path(p).write_bytes(gzip.compress(b,mtime=0) if str(p).endswith('.gz') else b)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--archive',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();owner=point_vector(a.point);target=[Fraction(1)]+[16*v for v in owner[:45]];assert sum(target[1:])==128
    saved=np.load(a.archive);bases=saved['selected_Z_indices'];assert bases.ndim==2 and bases.shape[1]==128;columns=[];ids=[];seen=set()
    for i,B in enumerate(bases):
        chosen=list(map(int,B));assert len(set(chosen))==128 and all(0<=j<720 for j in chosen);counts=np.bincount(np.array(chosen)//16,minlength=45);key=tuple(map(int,counts))
        if key not in seen:seen.add(key);columns.append([1,*key]);ids.append(i)
    A=np.array(columns,dtype=np.int64).T;paths=['recover_unconditional_basis_mixture.py','recover_full_partner_mixture.py','verify_projected_profile_moment_rows.py','full_partner_basis_oracle.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','moment-resumption-results/symmetry-bridge-independent.json'];hashes={p:sha(ROOT/p) for p in paths};frozen={'status':'FROZEN_BEFORE_UNCONDITIONAL_BASIS_MIXTURE_FIT','source_C16_answered':False,'point_sha256':sha(a.point),'archive_sha256':sha(a.archive),'source_hashes':hashes,'archive':str(a.archive),'source_bases':len(bases),'distinct_orbit_count_columns':len(columns),'target':list(map(str,target)),'seconds':60,'scope':'Onlyconstant1 and45Zorbitcounts; no selectedX/profile/crossmoment conditions.'};fp=a.output.with_name(a.output.name.removesuffix('.json.gz').removesuffix('.json')+'.frozen.json');assert not fp.exists();write(fp,frozen)
    t=time.monotonic();lp=linprog(np.zeros(A.shape[1]),A_eq=A,b_eq=np.array(list(map(float,target))),bounds=(0,None),method='highs',options={'time_limit':60,'primal_feasibility_tolerance':1e-9,'dual_feasibility_tolerance':1e-9});lp_seconds=time.monotonic()-t;result={**frozen,'frozen_sha256':sha(fp),'solver_status':int(lp.status),'solver_message':lp.message,'solver_seconds':lp_seconds}
    if not lp.success:result['status']='NO_NUMERICAL_ARCHIVE_MIXTURE';write(a.output,result);print(result['status'],flush=True);return
    positive=np.flatnonzero(lp.x>0);approx=lp.x[positive];recovery,w=exact_recover(A[:,positive],target,approx);result['exact_recovery']=recovery
    if w is None:result['status']='EXACT_RECOVERY_FAILED';write(a.output,result);print(recovery,flush=True);return
    Z=[int(v,16) for v in (ROOT/'pools/zcoords.txt').read_text().split()];records=[]
    for col,weight in zip(positive,w):
        if weight==0:continue
        sourceid=ids[int(col)];B=list(map(int,bases[sourceid]));assert rank(Z[j] for j in B)==128
        records.append({'archive_column_id':sourceid,'selected_Z_indices':B,'orbit_counts':list(map(int,A[1:,col])),'weight':str(weight)})
    assert sum(Fraction(r['weight']) for r in records)==1 and all(sum(Fraction(r['weight'])*r['orbit_counts'][j] for r in records)==target[j+1] for j in range(45));assert all(sha(ROOT/p)==v for p,v in hashes.items())
    result.update(status='EXACT_UNCONDITIONAL_BASIS_MIXTURE_CANDIDATE',physical_dimension=128,sector='Z',records=records,retained_bases=len(records),elapsed_seconds=time.monotonic()-start,scope='Exactnonnegative mixture of full128-vector physicalZbases matching45orbitoccupancies16p. Uniform16phase rotations then matchall720physicalmarginals. Independentphysical/symmetry replay required; no775membership orsourcecompletion claim.');write(a.output,result);print({k:result[k] for k in ['status','retained_bases','solver_seconds','elapsed_seconds']},flush=True)
if __name__=='__main__':main()
