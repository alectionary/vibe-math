"""Check the bounded generic helper against freshly rebuilt authored dependencies."""
from pathlib import Path
import argparse,datetime,hashlib,json,os,re,subprocess,time
R=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--module',choices=['LowWeightChecks','PermutationFixedColumns'],default='LowWeightChecks');args=ap.parse_args()
    name=args.module;src=R/(name+'.lean');rec=json.loads((R/'logs'/(name+'.json')).read_text())
    assert rec['exit_code']==0 and not rec['unexpected_axiom_or_error'] and rec['source_sha256']==sha(src)
    scratch=Path('/private/tmp/distance-low-weight-clean-20261025' if name=='LowWeightChecks' else '/private/tmp/distance-fixed-columns-clean-20261025');scratch.mkdir(exist_ok=False)
    core=Path('/private/tmp/distance-preservation-clean-20261025')
    deps=['SmallStopping','TannerSix','CoverWeight'] if name=='LowWeightChecks' else ['VoltageCycles']
    for dep in deps:
        assert (core/(dep+'.olean')).exists()
        assert sha(core/(dep+'.lean'))==sha(R/(dep+'.lean'))
    runtime=json.loads((R/'.lean-runtime.json').read_text())
    paths=[p for p in runtime['LEAN_PATH'].split(':') if 'dyadic-rank' not in p and str(R) not in p]
    env=dict(os.environ,LEAN_PATH=':'.join([str(scratch),str(core)]+paths))
    (scratch/src.name).write_bytes(src.read_bytes())
    logdir=R/'auxiliary-logs';logdir.mkdir(exist_ok=True);log=logdir/(name+'.log')
    deadline=datetime.datetime(2026,10,25,5,50,tzinfo=datetime.timezone.utc).timestamp()
    seconds=max(1,min(900,deadline-time.time()));start=time.monotonic()
    with log.open('w') as fd:
        p=subprocess.run([runtime['lean'],'-M','6000','-o',str(scratch/(name+'.olean')),str(scratch/src.name)],cwd=scratch,env=env,stdout=fd,stderr=subprocess.STDOUT,timeout=seconds)
    body=log.read_text();bad=any(s in body for s in ['sorryAx','error:','_native.'])
    for group in re.findall(r'depends on axioms: \[([^]]*)\]',body):
        bad|=not {s.strip() for s in group.split(',') if s.strip()}<={'propext','Classical.choice','Quot.sound'}
    assert sha(src)==sha(scratch/src.name)
    out={'status':'PASS' if p.returncode==0 and not bad else 'FAILED','module':name,'source_sha256':sha(src),
         'exit_code':p.returncode,'unexpected_axiom_or_error':bad,'seconds':time.monotonic()-start,
         'main_build_record':'logs/'+name+'.json','isolated_log':'auxiliary-logs/'+name+'.log','isolated_log_sha256':sha(log),
         'authored_dependency_sources':{d:sha(R/(d+'.lean')) for d in deps},'scratch_path':str(scratch),
         'scope':'Separate generic structural theorem, outside the frozen50-module counterfamily root. Rebuilt against its freshly rebuilt authored dependencies; original research objects excluded. The full weight7 source-classification bridge is not established.',
         'theorems':['LowWeightChecks.four_neighbors_force_twelve','LowWeightChecks.degree_le_three','LowWeightChecks.kernel_check_zero_or_two'] if name=='LowWeightChecks' else ['PermutationFixedColumns.two_torsion_unique','PermutationFixedColumns.two_fixed_columns_impossible'],
         'finished_utc':datetime.datetime.now(datetime.timezone.utc).isoformat()}
    dest='auxiliary-verification.json' if name=='LowWeightChecks' else 'auxiliary-fixed-columns-verification.json'
    (R/dest).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
    assert out['status']=='PASS'
if __name__=='__main__':main()
