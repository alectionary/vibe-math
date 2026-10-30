#!/usr/bin/env python3
"""Freeze one completed global singleton pilot and its independent receipt."""
from pathlib import Path
import argparse,gzip,hashlib,json,os
ROOT=Path(__file__).resolve().parent

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
    ap=argparse.ArgumentParser();ap.add_argument('--prefix',required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists()
    def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
    def read(p):
        raw=(ROOT/p).read_bytes();return json.loads(gzip.decompress(raw) if str(p).endswith('.gz') else raw)
    f=read(a.prefix+'.frozen.json');c=read(a.prefix+'.json.gz');r=read(a.prefix+'-independent.json');run=read(a.prefix+'.exit.json')
    assert r['certificate_sha256']==sha(a.prefix+'.json.gz') and r['frozen_sha256']==c['frozen_sha256']==sha(a.prefix+'.frozen.json')
    assert run['returncode']==0 and run['endpoint_sha256']==r['certificate_sha256']
    assert r['consumer_sha256']==sha('verify_singleton_global_rank_early.py')
    assert r['source_hashes']==f['source_hashes'] and all(sha(p)==h for p,h in f['source_hashes'].items())
    names={str(p.relative_to(ROOT)) for p in ROOT.glob(a.prefix+'*')}
    names.update([Path(__file__).name,'GLOBAL-RANK-REASSESSMENT.md','singleton_global_rank_early.py','verify_singleton_global_rank_early.py'])
    out=dict(status='PASS_COMPLETED_GLOBAL_SINGLETON_PILOT_INVENTORY',
             files=[dict(path=p,sha256=sha(p),bytes=(ROOT/p).stat().st_size) for p in sorted(names)],
             source_bindings=f['source_hashes'],input_bindings_checked=len(f['source_hashes']),
             anchor_orbit=f['anchor_orbit'],point_sha256=f['point_sha256'],endpoint_status=c['solver_endpoint']['status'],
             independent_status=r['status'],all_rank_membership_proved=r['all_rank_membership_proved'],
             exact_L1_residual=r['exact_L1_residual'],source_rank_cut_proved=r['exact_global_row_violation'] is not None,
             physical_bases=r['zero_bases'],unit_probabilities=r['unit_probabilities'],exact_coordinates=r['exact_coordinates'],
             process_finished=True,automatic_retry=False,source_C16_answered=False,priority=19,
             scope=r['scope'])
    a.output.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n');print(dict(status=out['status'],files=len(names),sha256=sha(a.output),endpoint_status=out['endpoint_status']),flush=True)

if __name__=='__main__':main()
