#!/usr/bin/env python3
"""Bounded trial of conditional short-word rules on a frozen static owner CNF."""
from pathlib import Path
import argparse,gzip,hashlib,json,subprocess,sys,time
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def solve(a):
    from pysat.formula import CNF
    from pysat.solvers import Solver
    from conditional_word_oracle import WordSpanOracle
    X,Z,A=physical();meta=json.loads(a.instance.read_text());raw=gzip.decompress((a.instance.parent/meta['input_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==meta['input_sha256'];cnf=CNF(from_string=raw.decode());start=time.monotonic();d={'status':'RUNNING','answer':None,'source_C16_answered':False,'full_source_model':True,'anchor':meta['anchor'],'instance_c16_path':str(a.instance.resolve().relative_to(ROOT)),'input_sha256':meta['input_sha256'],'span_enabled':a.variant=='span','outer_wall_seconds':a.seconds,'span_clause_limit':a.clause_limit}
    def progress(stats):
        d.update(oracle_statistics=stats,elapsed_solve_seconds=time.monotonic()-start);temp=a.output.with_suffix('.checkpoint.tmp');temp.write_text(json.dumps(d,indent=2)+'\n');temp.replace(a.output)
    oracle=None;progress({})
    from pysat.engines import Propagator
    class ObserveOnly(Propagator):
        def __init__(self):super().__init__();self.assignments=0;self.last=0
        def on_assignment(self,lit,fixed=False):
            self.assignments+=1
            if self.assignments%10000==0:
                now=time.monotonic()
                if now-self.last>=5:progress({'observed_assignments':self.assignments,'extra_clauses':0});self.last=now
        def on_new_level(self):pass
        def on_backtrack(self,to):pass
        def propagate(self):return []
        def has_clause(self):return False
        def check_model(self,model):return True
        def decide(self):return 0
    observer=None
    with Solver(name='cadical195',bootstrap_with=cnf.clauses) as solver:
        if a.variant=='span':
            assert a.native_library;d['native_library_sha256']=sha(a.native_library);oracle=WordSpanOracle(X,Z,a.native_library,a.output.with_suffix('.lemmas.jsonl'),progress=progress,limit=a.clause_limit);solver.connect_propagator(oracle)
        else:
            observer=ObserveOnly();solver.connect_propagator(observer)
        for v in range(1,1441):solver.observe(v)
        answer=solver.solve();d.update(answer=answer,status='SAT_REQUIRES_PHYSICAL_REPLAY' if answer else 'UNSAT_REQUIRES_FRESH_ORDINARY_PROOF',solver_statistics=solver.accum_stats());progress(oracle.stats.copy() if oracle else {'observed_assignments':observer.assignments,'extra_clauses':0})
        if answer:
            model=solver.get_model();truth=set(model);assert all(any(v in truth for v in c) for c in cnf.clauses);xi=[i for i in range(720) if i+1 in truth];zj=[j for j in range(720) if j+721 in truth];assert len(xi)==len(zj)==128;pairs=[]
            for i in xi:
                partners=[j for j in zj if A[i]>>j&1];assert len(partners)==1;pairs.append([i,partners[0]])
            assert len({j for i,j in pairs})==128
            for k,(i,j) in enumerate(pairs):
                for l,(ii,jj) in enumerate(pairs):assert bool(A[i]>>jj&1)==(k==l)
            d.update(pool_pairs=pairs,model=model)
    if oracle:oracle.close()
    a.output.write_text(json.dumps(d,indent=2)+'\n');print('STATIC BINARY END',d['status'],flush=True)
def main():
    p=argparse.ArgumentParser();p.add_argument('--mode',choices=['solve'],required=True);p.add_argument('--anchor',type=int,nargs=2);p.add_argument('--seed-cuts',type=Path,nargs='*',default=[]);p.add_argument('--phase-profiles',type=Path);p.add_argument('--instance',type=Path);p.add_argument('--native-library',type=Path);p.add_argument('--variant',choices=['baseline','span'],default='span');p.add_argument('--clause-limit',type=int,default=200000);p.add_argument('--seconds',type=float,default=900);p.add_argument('--output',type=Path,required=True);p.add_argument('--child',action='store_true');a=p.parse_args()
    if a.child:solve(a);return
    start=time.monotonic();child=subprocess.Popen([sys.executable,str(Path(__file__).resolve()),*sys.argv[1:],'--child']);expired=False
    try:child.wait(timeout=a.seconds)
    except subprocess.TimeoutExpired:expired=True;child.terminate();child.wait(timeout=10)
    d=json.loads(a.output.read_text()) if a.output.exists() else {'status':'ERROR_BEFORE_CHECKPOINT'}
    if expired:d.update(status='UNKNOWN_OUTER_WALL_LIMIT',answer=None)
    d.update(child_returncode=child.returncode,outer_wall_expired=expired,total_wall_seconds=time.monotonic()-start);lp=a.output.with_suffix('.lemmas.jsonl')
    if lp.exists():d.update(lemma_file=lp.name,lemma_file_sha256=sha(lp))
    a.output.write_text(json.dumps(d,indent=2)+'\n');print('STATIC BINARY PARENT',d['status'],flush=True)
if __name__=='__main__':main()
