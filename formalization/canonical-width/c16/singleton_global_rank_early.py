#!/usr/bin/env python3
"""Fresh global singleton conditional rank pilot using the frozen exact solver."""
import os
assert os.getpriority(os.PRIO_PROCESS, 0) == 19
for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS',
            'VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    os.environ[key] = '1'
os.environ['PYTHONDONTWRITEBYTECODE'] = '1'
from pathlib import Path
from fractions import Fraction as Q
import argparse, gzip, hashlib, json, subprocess, sys, time
from verify_projected_profile_moment_rows import point_vector
from full_partner_projection_features import moment_target

ROOT = Path(__file__).resolve().parent
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p); return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def write(p,d):
    p=Path(p); assert not p.exists(); b=(json.dumps(d,indent=2)+'\n').encode()
    p.write_bytes(gzip.compress(b,mtime=0) if p.suffix=='.gz' else b)
def rank(vectors):
    rows={}
    for v in vectors:
        while v:
            k=v.bit_length()-1
            if k in rows:v^=rows[k]
            else:rows[k]=v;break
    return len(rows)

def prepare(a):
    assert 0<=a.orbit<45 and 0<a.seconds<=60
    summary=read(a.point_summary); assert summary['status']=='PASS_LISTED_RELAXATION'
    assert sha(a.point)=='4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f'
    owner=point_vector(a.point); p=owner[a.orbit]; assert 0<p<1
    q=[v/(16*p) for v in moment_target(owner,a.orbit)[55:]]
    X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    assert len(X)==len(Z)==720 and rank(X)==rank(Z)==128
    E=[j for j in range(720) if (X[16*a.orbit]&Z[j]).bit_count()%2==0]
    U=[j for j in range(720) if j not in set(E)]
    assert all(0<=v<=1 for v in q) and sum(q[j] for j in E)==127 and sum(q[j] for j in U)==1
    assert rank(Z[j] for j in E)==127
    tiny=read(a.tiny_receipt)
    assert tiny['status']=='PASS_EXACT_VERSIONED_PUSH_RELABEL_TINY_ENDPOINTS'
    assert tiny['producer']=='exact_matroid_push_relabel_early.py'
    assert tiny['producer_sha256']==sha(ROOT/tiny['producer'])
    assert tiny['consumer_sha256']==sha(ROOT/'two_basis_structure_versioned_push_controls.py')
    tb=a.tiny_receipt.with_name(a.tiny_receipt.name.removesuffix('-independent.json')+'.json.gz')
    assert tiny['bank_sha256']==sha(tb)
    paths=[Path(__file__),ROOT/'verify_singleton_global_rank_early.py',
           ROOT/'exact_matroid_push_relabel_early.py',ROOT/'verify_algebraic_model.py',
           ROOT/'verify_singleton_exchange_terminal.py',ROOT/'verify_full_partner_projection.py',
           ROOT/'verify_projected_profile_moment_rows.py',ROOT/'full_partner_projection_features.py',
           ROOT/'two_basis_structure_versioned_push_controls.py',ROOT/'two_basis_structure_push_relabel_controls.py',
           ROOT/'physical-pool-source.json',ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt',
           ROOT/'verify_weighted_matroid_cuts.py',ROOT/'conditional_matroid_moment_matrix.py',
           a.point,a.point_summary,a.tiny_receipt,tb]
    sources={str(p.resolve().relative_to(ROOT)):sha(p) for p in paths}
    return dict(status='FROZEN_FRESH_GLOBAL_SINGLETON_SELECTED_RANK_PILOT',source_hashes=sources,
                point_path=str(a.point),point_sha256=sha(a.point),anchor_orbit=a.orbit,
                conditional_probability=str(p),conditional_target=list(map(str,q)),
                physical_zero_ground_indices=E,physical_unit_indices=U,
                vectors_hex=[hex(Z[j]) for j in E],seconds=a.seconds,
                maximum_active_bases=5000,solver_maximum_bases_argument=4999,
                tiny_receipt=str(a.tiny_receipt),tiny_receipt_sha256=sha(a.tiny_receipt),
                solver_sha256=sha(ROOT/'exact_matroid_push_relabel_early.py'),
                fresh_target_no_old_membership_transfer=True,source_C16_answered=False)

def worker(fp,output):
    f=read(fp); assert all(sha(ROOT/p)==h for p,h in f['source_hashes'].items())
    from exact_matroid_push_relabel_early import solve
    E=f['physical_zero_ground_indices'];q=list(map(Q,f['conditional_target']))
    result=solve([int(v,16) for v in f['vectors_hex']],[q[j] for j in E],
                 seconds=f['seconds'],maximum_bases=f['solver_maximum_bases_argument'])
    D=int(result['denominator']); assert D>0 and result['rank']==127 and result['maximum_active_bases']<=5000
    bases=[dict(indices=sorted(E[j] for j in b['indices']),weight=str(Q(int(b['weight_numerator']),D))) for b in result['bases']]
    out=dict(status='GLOBAL_SINGLETON_EXACT_ORACLE_ENDPOINT_REQUIRES_REPLAY',frozen_sha256=sha(fp),
             source_hashes=f['source_hashes'],point_sha256=f['point_sha256'],anchor_orbit=f['anchor_orbit'],
             conditional_probability=f['conditional_probability'],conditional_target=f['conditional_target'],
             zero_bases=bases,unit_probabilities=[dict(index=j,probability=str(q[j])) for j in f['physical_unit_indices'] if q[j]],
             solver_endpoint=result,source_C16_answered=False,physical_full_frame=False)
    if result['status']=='EXACT_RANK_VIOLATION':
        A=sorted(E[j] for j in result['violated_rank']['indices']);r=result['violated_rank']['rank']
        p=Q(f['conditional_probability']); gap=p*(sum(q[j] for j in A)-r);assert gap>0
        out['cut']=dict(sector='T',anchor_orbit=f['anchor_orbit'],mandatory_index=None,
                        indices=A,bound=r,exact_violation=str(gap))
    assert all(sha(ROOT/p)==h for p,h in f['source_hashes'].items());write(output,out)
    print(json.dumps(dict(status=result['status'],bases=len(bases),steps=result['steps'],seconds=result['seconds'])),flush=True)

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path);ap.add_argument('--point-summary',type=Path)
    ap.add_argument('--orbit',type=int,default=40);ap.add_argument('--seconds',type=float,default=60)
    ap.add_argument('--tiny-receipt',type=Path);ap.add_argument('--output-prefix',type=Path)
    ap.add_argument('--worker',type=Path);ap.add_argument('--worker-output',type=Path);a=ap.parse_args()
    if a.worker:worker(a.worker,a.worker_output);return
    start=time.monotonic();f=prepare(a);fp=Path(str(a.output_prefix)+'.frozen.json');write(fp,f)
    out=Path(str(a.output_prefix)+'.json.gz');log=Path(str(a.output_prefix)+'.worker.log');assert not log.exists()
    with log.open('w') as stream:
        try:
            r=subprocess.run([sys.executable,'-B',str(Path(__file__).resolve()),'--worker',str(fp),'--worker-output',str(out)],
                             env=os.environ,cwd=ROOT,stdout=stream,stderr=subprocess.STDOUT,timeout=90)
            code=r.returncode
        except subprocess.TimeoutExpired:code='EXTERNAL_TIME_LIMIT_90'
    record=dict(returncode=code,seconds=time.monotonic()-start,nice=19,threads=1,
                frozen_sha256=sha(fp),endpoint_sha256=sha(out) if out.exists() else None,
                worker_log_sha256=sha(log),source_C16_answered=False)
    write(Path(str(a.output_prefix)+'.exit.json'),record);print(json.dumps(record),flush=True)
    if code!=0:sys.exit(1)
if __name__=='__main__':main()
