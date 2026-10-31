#!/usr/bin/env python3
"""Sequential20second matched source-case discovery; no exclusion acceptance."""
from pathlib import Path
import argparse,gzip,hashlib,importlib.metadata,json,os,subprocess,sys,time
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def worker(D,arm):
 from pysat.formula import CNF
 from pysat.solvers import Solver
 raw=gzip.decompress((D/(arm+'.cnf.gz')).read_bytes());cnf=CNF(from_string=raw.decode());s=Solver(name='cadical195',bootstrap_with=cnf.clauses,with_proof=True);s.configure({'seed':20261030});(D/(arm+'-ready.json')).write_text(json.dumps({'status':'SOLVER_READY','worker_sha256':sha(__file__),'input_raw_sha256':hashlib.sha256(raw).hexdigest()})+'\n');t=time.monotonic();answer=s.solve();elapsed=time.monotonic()-t;out={'status':'SAT_NECESSARY_MODEL_ONLY' if answer else 'UNSAT_UNREPLAYED_DISCOVERY','source_C16_answered':False,'answer':answer,'solve_seconds':elapsed,'solver_statistics':s.accum_stats()}
 if answer:
  model=s.get_model();truth={v for v in model if v>0};assert all(any((lit in truth) if lit>0 else (-lit not in truth) for lit in clause) for clause in cnf.clauses);mp=D/(arm+'-model.json.gz');mp.write_bytes(gzip.compress((json.dumps(model)+'\n').encode(),mtime=0));out.update(model_sha256=sha(mp),all_model_clauses_checked=len(cnf.clauses))
 else:
  proof=s.get_proof();pp=D/(arm+'.drat.gz');pp.write_bytes(gzip.compress(('\n'.join(proof)+'\n').encode(),mtime=0));out.update(proof_sha256=sha(pp),proof_lines=len(proof))
 s.delete();(D/(arm+'-trial.json')).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--directory',type=Path,required=True);ap.add_argument('--worker',choices=['baseline','small64']);a=ap.parse_args();D=a.directory.resolve()
 if a.worker:worker(D,a.worker);return
 controls=read(D/'bridge-controls.json');assert controls['status']=='PASS_NEW_BOOLEAN_CNF_BRIDGE_CONTROLS';frozen=read(D/'frozen.json.gz');assert controls['frozen_sha256']==sha(D/'frozen.json.gz');assert all(sha(ROOT/p)==h for p,h in frozen['source_hashes'].items());assert not (D/'trials-frozen.json').exists()
 commands=[[sys.executable,'-u',str(Path(__file__).resolve()),'--directory',str(D),'--worker',arm] for arm in ['baseline','small64']]
 tf={'status':'FROZEN_BEFORE_MATCHED_SOURCE_TRIALS','source_C16_answered':False,'controller_sha256':sha(__file__),'model_frozen_sha256':sha(D/'frozen.json.gz'),'bridge_controls_sha256':sha(D/'bridge-controls.json'),'solver':'cadical195','python_sat_version':importlib.metadata.version('python-sat'),'solver_seed':20261030,'solve_wall_seconds':20,'commands':commands,'difference':'The two inputs share an identical baselineprefix. Augmented adds onlyexactacceptedscale64row0 productdefinitions andPB circuit.'};(D/'trials-frozen.json').write_text(json.dumps(tf,indent=2)+'\n');env=os.environ.copy();env.update({k:'1' for k in ['PYTHONDONTWRITEBYTECODE','OPENBLAS_NUM_THREADS','OMP_NUM_THREADS']});records=[]
 for arm,cmd in zip(['baseline','small64'],commands):
  begin=time.monotonic();ready=None
  with (D/(arm+'-trial.log')).open('w') as log:
   p=subprocess.Popen(cmd,cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT)
   while p.poll() is None:
    if ready is None and (D/(arm+'-ready.json')).exists():ready=time.monotonic()
    if time.monotonic()-(ready if ready is not None else begin)>(20 if ready is not None else 30):p.terminate();p.wait(timeout=5);break
    time.sleep(.02)
  report=D/(arm+'-trial.json')
  if report.exists():r=read(report)
  else:r={'status':'UNKNOWN_OUTER_SOLVE_WALL_LIMIT' if ready else 'FAILED_BEFORE_SOLVER_READY','source_C16_answered':False,'answer':None};report.write_text(json.dumps(r,indent=2)+'\n')
  r.update(arm=arm,worker_returncode=p.returncode,outer_seconds=time.monotonic()-begin,receipt_sha256=sha(report));records.append(r);print(json.dumps(r),flush=True)
 summary={'status':'MATCHED_SOURCE_TRIALS_COMPLETE_NO_SOURCE_EXCLUSION_ACCEPTED','source_C16_answered':False,'trials':records,'input_frozen_sha256':sha(D/'frozen.json.gz'),'trials_frozen_sha256':sha(D/'trials-frozen.json'),'bridge_controls_sha256':sha(D/'bridge-controls.json'),'source_exclusions_accepted':0,'cover_before':405,'cover_after':405,'scope':'SAT would be onlya necessary-model witness. UNKNOWN givesnoexclusion. UNSAT would requirefreshindependentfullsourceCNFandDRATreplay beforeacceptance.'};(D/'trials-summary.json').write_text(json.dumps(summary,indent=2)+'\n')
if __name__=='__main__':main()
