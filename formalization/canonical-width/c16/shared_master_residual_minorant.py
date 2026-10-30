"""Export and optionally run the bounded exact16-atom residual-bound pattern-cost projection.

This file is a producer/runner only. The separate projection consumer checks
the complete LP text, rational primal/dual and the resulting owner row.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse
import hashlib
import gzip
import json
import os
import signal
import subprocess
import time

ROOT=Path(__file__).resolve().parent
LOW=(0,1,2,4,8,3,5,9,6,10,12)
EXE=Path('/private/tmp/c16-soplex-8.1.0-20261030/soplex/8.1.0/bin/soplex')
EXE_SHA='fa62759749a44617b1e1f2c38fbcfe5dc0cd658045f95c4d2f851f9577813732'
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);data=p.read_bytes()
    return json.loads(gzip.decompress(data) if p.suffix=='.gz' else data)
def expression(values):
    parts=[]
    for i,v in enumerate(values):
        v=Q(v)
        if v:parts.append(('+' if v>0 else '-')+' '+str(abs(v))+' x'+str(i))
    return ' '.join(parts) or '+ 0 x0'

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--pricing',type=Path,required=True)
    ap.add_argument('--receipt',type=Path,required=True);ap.add_argument('--prefix',type=Path,required=True)
    ap.add_argument('--run',action='store_true');a=ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    assert all(os.environ.get(k)=='1' for k in THREADS)
    a.prefix=a.prefix.resolve();assert a.prefix.is_relative_to(ROOT)
    suffixes=['.lp','.json','.frozen.json','.log','.run.json','.primal','.dual','.bas']
    paths={s:Path(str(a.prefix)+s) for s in suffixes}
    assert all(not p.exists() for p in paths.values())
    pricing,receipt=read(a.pricing),read(a.receipt)
    assert receipt['status']=='PASS_EXACT_SHARED_MASTER_RESIDUAL_FULL_DOMAIN_PRICING'
    assert receipt['pricing_sha256']==sha(a.pricing)
    assert receipt['consumer_sha256']==sha(ROOT/'verify_shared_master_residual_projection.py')
    costs=list(map(Q,pricing['pattern_costs']));q=list(map(Q,pricing['low_moment_targets']))
    assert len(costs)==16 and len(q)==11 and q[0]==1
    law=list(map(Q,pricing['feasible_pattern_law']))
    assert len(law)==16 and min(law)>=0
    assert all(sum(law[m] for m in range(16) if m&h==h)==q[i] for i,h in enumerate(LOW))
    lines=['Minimize',' obj: '+expression(costs),'Subject To']
    for i,h in enumerate(LOW):
        lines.append(' f'+str(i)+': '+expression([int(m&h==h) for m in range(16)])+' = '+str(q[i]))
    lines += [' n'+str(m)+': - 1 x'+str(m)+' <= 0' for m in range(16)]
    lines += ['Bounds']+[' x'+str(m)+' free' for m in range(16)]+['End']
    paths['.lp'].write_text('\n'.join(lines)+'\n')
    manifest=dict(status='EXACT_SHARED_MASTER_RESIDUAL_PATTERN_COST_LP_REQUIRES_REPLAY',
                  pricing=str(a.pricing.resolve()),pricing_sha256=sha(a.pricing),
                  pricing_receipt=str(a.receipt.resolve()),pricing_receipt_sha256=sha(a.receipt),
                  lp=str(paths['.lp']),lp_sha256=sha(paths['.lp']),variable_count=16,row_count=27,
                  low_masks=list(LOW),pattern_costs=list(map(str,costs)),low_moment_targets=list(map(str,q)),
                  explicit_feasible_law=list(map(str,law)),point_sha256=pricing['point_sha256'],
                  source_hashes={'shared_master_residual_minorant.py':sha(__file__),
                                 'verify_shared_master_residual_projection.py':sha(ROOT/'verify_shared_master_residual_projection.py')},
                  bounds_certificate=pricing['bounds_certificate'],bounds_certificate_sha256=pricing['bounds_certificate_sha256'],
                  bounds_receipt=pricing['bounds_receipt'],bounds_receipt_sha256=pricing['bounds_receipt_sha256'],
                  exact_restricted_optimum_claimed=False,
                  scope='Exact tiny residual-bound pattern-law projection; no additional shared-master solve or exact restricted-optimum claim.')
    paths['.json'].write_text(json.dumps(manifest,indent=2)+'\n')
    if not a.run:
        print(json.dumps(dict(status=manifest['status'],manifest=str(paths['.json']),sha256=sha(paths['.json']))));return
    assert sha(EXE)==EXE_SHA
    env=dict(os.environ)
    env['DYLD_LIBRARY_PATH']='/opt/homebrew/opt/gmp/lib:/private/tmp/c16-soplex-8.1.0-20261030/mpfr/4.2.2/lib'
    command=[str(EXE),'--readmode=1','--solvemode=2','--int:syncmode=1','--int:checkmode=2',
             '-f0','-o0','-s0','-t10','-X='+str(paths['.primal']),'-Y='+str(paths['.dual']),
             '--writebas='+str(paths['.bas']),str(paths['.lp'])]
    frozen=dict(input_manifest=str(paths['.json']),input_manifest_sha256=sha(paths['.json']),
                input_lp_sha256=sha(paths['.lp']),executable=str(EXE),executable_sha256=EXE_SHA,
                command=command,internal_seconds=10,external_seconds=20,rss_soft_limit_bytes=536870912,
                nice=19,threads={k:env[k] for k in THREADS},dynamic_library_path=env['DYLD_LIBRARY_PATH'],
                producer_sha256=sha(__file__))
    paths['.frozen.json'].write_text(json.dumps(frozen,indent=2)+'\n')
    start=time.monotonic();samples=[];termination=None
    with paths['.log'].open('w') as log:
        p=subprocess.Popen(command,cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        assert os.getpriority(os.PRIO_PROCESS,p.pid)==19
        while p.poll() is None:
            age=time.monotonic()-start
            if age>20:termination='EXTERNAL_TIME_LIMIT'
            try:
                rss_text=subprocess.check_output(['/bin/ps','-o','rss=','-p',str(p.pid)],text=True).strip()
                if rss_text:
                    rss=int(rss_text)*1024;samples.append(dict(seconds=age,rss_bytes=rss))
                    if rss>536870912:termination='RSS_SOFT_LIMIT'
            except (subprocess.CalledProcessError,ValueError):pass
            if termination:
                os.killpg(p.pid,signal.SIGTERM)
                try:p.wait(timeout=1)
                except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
                break
            time.sleep(.1)
        code=p.wait()
    result=dict(status='TINY_PATTERN_COST_SOLVER_OUTPUT_REQUIRES_EXACT_REPLAY',returncode=code,
                termination=termination,elapsed_seconds=time.monotonic()-start,
                max_sampled_rss_bytes=max((r['rss_bytes'] for r in samples),default=None),rss_samples=samples,
                sampled_rss_is_not_peak=True,frozen=str(paths['.frozen.json']),frozen_sha256=sha(paths['.frozen.json']),
                output_hashes={str(p):sha(p) for s,p in paths.items() if s in ('.log','.primal','.dual','.bas') and p.exists()},
                no_exact_optimum_or_source_claim=True)
    paths['.run.json'].write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ('rss_samples','output_hashes')}))

if __name__=='__main__':main()
