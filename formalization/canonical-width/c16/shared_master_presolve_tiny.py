#!/usr/bin/env python3
"""One exact positive phase-I control for internal presolve and postsolve."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    assert os.environ.get(key)=='1'
from pathlib import Path
import argparse,hashlib,json,signal,subprocess,time
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,obj):
    p=Path(p);assert not p.exists();p.parent.mkdir(parents=True,exist_ok=True)
    p.write_text(obj if isinstance(obj,str) else json.dumps(obj,indent=2)+'\n')
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--prefix',required=True);a=ap.parse_args()
    prefix=Path(a.prefix).resolve();setup_path=ROOT/'two-basis-results/soplex-setup/setup-ready.json'
    setup=json.loads(setup_path.read_text());assert setup['status']=='PASS_SOPLEX_SETUP_AND_SUPPLEMENTAL_EXACT_CONTROLS'
    assert all(sha(p)==h for p,h in setup['runtime_files'].items())
    lp=Path(str(prefix)+'.lp');manifest=Path(str(prefix)+'.json');out=Path(str(prefix)+'-solve')
    text='''Minimize
 obj: + 1 x2 + 1 x3
Subject To
 parent: + 1 x0 = 1/2
 mass: + 1 x1 = 1
 link: - 1 x0 + 1 x1 + 1 x2 - 1 x3 = 0
 n1: - 1 x1 <= 0
 n2: - 1 x2 <= 0
 n3: - 1 x3 <= 0
Bounds
 x0 free
 x1 free
 x2 free
 x3 free
End
'''
    write(lp,text)
    sources={str(Path(__file__).relative_to(ROOT)):sha(__file__),str(setup_path.relative_to(ROOT)):sha(setup_path)}
    write(manifest,dict(status='EXACT_SHARED_MASTER_PRESOLVE_ONE_TINY_REQUIRES_REPLAY',lp=str(lp),lp_sha256=sha(lp),
        variable_count=4,row_count=6,source_hashes=sources,expected_objective='1/2',
        scope='Synthetic positive artificial-error optimum, no physical C16 conclusion.'))
    command=[setup['binary'],'--readmode=1','--solvemode=2','--int:syncmode=1','--int:checkmode=2',
             '-f0','-o0','-s1','-t10',f'-X={out}.primal',f'-Y={out}.dual',
             f'-x={out}.float.primal',f'-y={out}.float.dual',str(lp)]
    frozen=dict(status='FROZEN_SHARED_MASTER_PRESOLVE_ONE_TINY_CONTROL',command=command,
        input_manifest=str(manifest),input_manifest_sha256=sha(manifest),input_lp_sha256=sha(lp),
        source_hashes=sources,setup_sha256=sha(setup_path),runtime_files=setup['runtime_files'],
        priority=19,threads=1,presolve=1,internal_seconds=10,external_seconds=15,
        rational_outputs_only_are_proofs=True)
    write(str(out)+'.frozen.json',frozen);env=os.environ.copy();env['DYLD_LIBRARY_PATH']=setup['environment']['DYLD_LIBRARY_PATH']
    start=time.monotonic();stop=None
    with Path(str(out)+'.log').open('w') as stream:
        p=subprocess.Popen(command,cwd=ROOT,env=env,stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
        assert os.getpriority(os.PRIO_PROCESS,p.pid)==19
        try:p.wait(timeout=15)
        except subprocess.TimeoutExpired:
            stop='EXTERNAL_WALL_LIMIT';os.killpg(p.pid,signal.SIGKILL);p.wait()
    suffixes=['.primal','.dual','.float.primal','.float.dual','.log','.frozen.json']
    result=dict(status='SHARED_MASTER_PRESOLVE_TINY_ENDPOINT_REQUIRES_INDEPENDENT_REPLAY',
        returncode=p.returncode,external_stop=stop,seconds=time.monotonic()-start,
        outputs={s:dict(path=str(out)+s,sha256=sha(str(out)+s)) for s in suffixes if Path(str(out)+s).exists()})
    write(str(out)+'.json',result);print(json.dumps(result),flush=True)
if __name__=='__main__':main()
