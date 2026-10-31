#!/usr/bin/env python3
"""Freeze a bounded inverse-membership screen of the saved Wolfe basis archive."""
from pathlib import Path
import argparse, datetime, hashlib, json, os, struct, subprocess, tempfile, time
import numpy as np

ROOT=Path(__file__).resolve().parent
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--archive',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--limit',type=int,default=0);ap.add_argument('--seconds',type=float,default=180);a=ap.parse_args()
    assert not a.output.exists() and a.limit>=0
    archive=np.load(a.archive);bases=archive['selected_Z_indices'];assert bases.shape[1]==128 and bases.dtype==np.uint16
    sources=['screen_projected_basis_inverses.cpp','search/climb_steep.cpp','run_projected_basis_inverse_screen.py','pools/xcoords.txt','pools/zcoords.txt']
    frozen={'status':'FROZEN_BEFORE_SAVED_BASIS_SCREEN','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_C16_answered':False,'archive_sha256':sha(a.archive),'archive':str(a.archive),'source_hashes':{p:sha(ROOT/p) for p in sources},'input_rows':len(bases),'limit':a.limit,'outer_seconds':a.seconds,'numpy_version':np.__version__,'scope':'Saved opposite bases only; no exhaustion of all pool bases is claimed.'}
    a.output.with_suffix('.frozen.json').write_text(json.dumps(frozen,indent=2)+'\n')
    with tempfile.TemporaryDirectory(prefix='c16-basis-inverse-') as folder:
        folder=Path(folder);binary=folder/'screen';data=folder/'basis.bin'
        with data.open('wb') as file:file.write(struct.pack('<Q',len(bases)));file.write(bases.astype('<u2').tobytes())
        subprocess.run(['c++','-std=c++17','-O3',str(ROOT/sources[0]),'-o',str(binary)],check=True)
        cmd=[str(binary),str(ROOT/'pools/xcoords.txt'),str(ROOT/'pools/zcoords.txt'),str(data),str(a.output.with_suffix('.scores.bin')),str(a.output),str(a.limit)]
        start=time.monotonic()
        with a.output.with_suffix('.log').open('w') as log:
            try:r=subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT,timeout=a.seconds);exitcode=r.returncode;timeout=False
            except subprocess.TimeoutExpired:exitcode=None;timeout=True
        exitreport={'returncode':exitcode,'timeout':timeout,'seconds':time.monotonic()-start,'compiler_version':subprocess.check_output(['c++','--version'],text=True),'binary_sha256':sha(binary),'input_binary_sha256':sha(data),'source_hashes_unchanged':all(sha(ROOT/p)==d for p,d in frozen['source_hashes'].items()),'scores_sha256':sha(a.output.with_suffix('.scores.bin')),'result_sha256':sha(a.output) if a.output.exists() else None}
        a.output.with_suffix('.exit.json').write_text(json.dumps(exitreport,indent=2)+'\n');print(exitreport)
        assert exitreport['source_hashes_unchanged']

if __name__=='__main__':main()
