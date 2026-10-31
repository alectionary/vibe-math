"""Bounded fixed-column union gate; no additional exchange or support search."""
from pathlib import Path
from fractions import Fraction as Q
import argparse, hashlib, json, time
import numpy as np
from scipy.optimize import linprog
from scipy.sparse import csc_matrix
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension
from verify_full_partner_projection import point_data

ROOT = Path(__file__).resolve().parent
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p): return json.loads(Path(p).read_text())
def write(p, value):
    assert not p.exists()
    p.write_text(json.dumps(value, indent=2)+'\n')

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--recover',action='store_true'); a=ap.parse_args()
    out=a.output; fp=out.with_suffix('.frozen.json'); numeric=out.with_suffix('.numeric.json'); archive=out.with_suffix('.npz')
    point=ROOT/'coupling-results/anchor-witness12-rational.json.gz'
    names=['singleton-exchange-witness12-o17','singleton-exchange-lazy-witness12-o17']
    paths=[ROOT/'coupling-results'/(n+'.json') for n in names]
    banks=[read(p) for p in paths]; X,Z,A=physical(); owner,target=point_data(point,17)
    p=owner[17]; q=[v/(16*p) for v in target[55:]]
    assert all(b['point_sha256']==sha(point) and b['anchor_orbit']==17 and list(map(Q,b['conditional_target']))==q for b in banks)
    columns=sorted({tuple(r['indices']) for b in banks for r in b['zero_bases']})
    zero=[j for j in range(720) if not(A[272]>>j&1)]; ground=[j for j in zero if q[j]>0]
    assert sum(q[j] for j in zero)==127
    for B in columns:
        assert len(B)==len(set(B))==127 and set(B)<=set(ground) and dimension(Z[j] for j in B)==127
    M=np.array([[1]*len(columns)]+[[int(j in B) for B in columns] for j in ground],dtype=np.int64)
    rhs=[Q(1)]+[q[j] for j in ground]
    if not a.recover:
        dependencies=['singleton_exchange_union17_gate.py','recover_full_partner_mixture.py','verify_algebraic_model.py','verify_full_partner_projection.py','verify_full_partner_basis_oracle.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']
        frozen={'status':'FROZEN_FIXED_COLUMN_UNION_FEASIBILITY_GATE','source_C16_answered':False,'point_sha256':sha(point),'input_states':{str(z.relative_to(ROOT)):sha(z) for z in paths},'source_hashes':{s:sha(ROOT/s) for s in dependencies},'columns':list(map(list,columns)),'ground_indices':ground,'exact_rhs':list(map(str,rhs)),'numeric_seconds_cap':90,'presolve':False,'scope':'Only the finite union of saved zero-basis columns. No global nonmembership follows from failure.'}
        write(fp,frozen); started=time.monotonic()
        result=linprog(np.zeros(len(columns)),A_eq=csc_matrix(M),b_eq=np.array(list(map(float,rhs))),bounds=(0,None),method='highs-ds',options={'presolve':False,'time_limit':90,'primal_feasibility_tolerance':1e-9,'dual_feasibility_tolerance':1e-9})
        r={'status':'NUMERICAL_FIXED_COLUMN_FEASIBLE_REQUIRES_EXACT_RECOVERY' if result.success else 'FIXED_COLUMN_NUMERICAL_FAILURE_NO_GLOBAL_CONCLUSION','solver_status':int(result.status),'message':result.message,'columns':len(columns),'equalities':len(rhs),'seconds':time.monotonic()-started,'frozen_sha256':sha(fp),'source_C16_answered':False}
        if result.x is not None:
            r.update(max_numeric_residual=float(np.max(np.abs(M@result.x-np.array(list(map(float,rhs)))))),min_numeric_weight=float(np.min(result.x)),positive_numeric_weights=int(np.sum(result.x>0)))
            np.savez_compressed(archive,weights=result.x);r['archive_sha256']=sha(archive)
        write(numeric,r)
        if not result.success:write(out,r)
        print(json.dumps(r),flush=True);return
    frozen=read(fp); nr=read(numeric);assert nr['status']=='NUMERICAL_FIXED_COLUMN_FEASIBLE_REQUIRES_EXACT_RECOVERY' and nr['max_numeric_residual']<=1e-7
    assert nr['frozen_sha256']==sha(fp) and nr['archive_sha256']==sha(archive)
    assert all(sha(ROOT/s)==h for s,h in frozen['source_hashes'].items())
    assert frozen['columns']==list(map(list,columns)) and frozen['exact_rhs']==list(map(str,rhs))
    weights=np.load(archive)['weights']; ids=np.flatnonzero(weights>0)
    from recover_full_partner_mixture import exact_recover
    started=time.monotonic(); recovery,exact=exact_recover(M[:,ids],rhs,weights[ids])
    b={'status':'EXACT_RECOVERY_FAILED_NO_MEMBERSHIP_CLAIM','source_C16_answered':False,'physical_full_frame':False,'point_sha256':sha(point),'anchor_orbit':17,'conditional_probability':str(p),'conditional_target':list(map(str,q)),'ground_indices':ground,'frozen_sha256':sha(fp),'source_hashes':frozen['source_hashes'],'numeric_report_sha256':sha(numeric),'recovery':recovery,'recovery_seconds':time.monotonic()-started}
    if exact is not None:
        kept=[(columns[i],w) for i,w in zip(ids,exact) if w>0]
        b.update(status='EXACT_SINGLETON_CONDITIONAL_BASIS_MIXTURE_CANDIDATE',zero_bases=[{'indices':list(B),'weight':str(w)} for B,w in kept],unit_probabilities=[{'index':j,'probability':str(q[j])} for j in range(720) if A[272]>>j&1 and q[j]>0],active_bases=len(kept),final_positive_error='0')
    write(out,b); print(json.dumps({k:v for k,v in b.items() if k not in ['zero_bases','unit_probabilities','conditional_target','source_hashes','ground_indices']}),flush=True)

if __name__=='__main__':main()
