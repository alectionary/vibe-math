#!/usr/bin/env python3
"""Lossless terminal-mixture handoff to the previously frozen direct consumer."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):os.environ[k]='1'
from pathlib import Path
import argparse,gzip,hashlib,json
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def write(p,d):
    p=Path(p);assert not p.exists();p.write_text(json.dumps(d,indent=2)+'\n')
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--receipt',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    r=read(a.receipt);assert r['status']=='PASS_EXACT_GLOBAL_SINGLETON_ARCHIVE_BASIS_MEMBERSHIP'
    assert r['consumer_sha256']==sha(ROOT/'verify_singleton_archive_cg.py') and r['exact_L1_residual']=='0' and r['exact_coordinates_checked']==720
    m=read(r['manifest']);assert sha(r['manifest'])==r['manifest_sha256'] and sha(m['semantic'])==r['semantic_sha256']==m['semantic_sha256']
    s=read(m['semantic']);assert s['point_sha256']==r['point_sha256'] and s['conditional_target']==r['conditional_target']
    sources=dict(r['source_hashes'])
    for p in [a.receipt,Path(r['manifest']),Path(m['semantic']),Path(r['primal']),Path(r['solver_frozen']),Path(__file__),ROOT/'verify_singleton_archive_cg.py',ROOT/'verify_singleton_exchange_terminal.py']:
        sources[str(p.resolve().relative_to(ROOT))]=sha(p)
    assert all(sha(ROOT/p)==h for p,h in sources.items())
    fp=a.output.with_suffix('.frozen.json')
    frozen=dict(status='FROZEN_LOSSLESS_GLOBAL_SINGLETON_TERMINAL_HANDOFF',source_hashes=sources,
                parent_membership_receipt=str(a.receipt),parent_membership_receipt_sha256=sha(a.receipt),
                point_sha256=r['point_sha256'],anchor_orbit=r['anchor_orbit'],rounding_performed=False)
    write(fp,frozen)
    out=dict(status='EXACT_SINGLETON_CONDITIONAL_BASIS_MIXTURE_CANDIDATE',frozen_sha256=sha(fp),source_hashes=sources,
             point_sha256=r['point_sha256'],anchor_orbit=r['anchor_orbit'],conditional_probability=s['conditional_probability'],
             conditional_target=r['conditional_target'],zero_bases=r['zero_bases'],unit_probabilities=r['unit_probabilities'],
             parent_membership_receipt=str(a.receipt),parent_membership_receipt_sha256=sha(a.receipt),
             source_C16_answered=False,physical_full_frame=False)
    write(a.output,out);print(json.dumps(dict(output=str(a.output),sha256=sha(a.output),zero_bases=len(out['zero_bases']),unit_probabilities=len(out['unit_probabilities']))))
if __name__=='__main__':main()
