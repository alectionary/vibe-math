#!/usr/bin/env python3
"""Run exactly the two frozen sequential discovery calls and retain all results."""
from pathlib import Path
import datetime,hashlib,json,subprocess,time
ROOT=Path(__file__).resolve().parent

def main():
    out=ROOT/'relevant-results';path=out/'comparison-frozen.json';f=json.loads(path.read_text());assert f['workers']==1;results=[]
    for variant,cmd in zip(f['variants'],f['commands']):
        began=time.monotonic();started=datetime.datetime.now(datetime.timezone.utc).isoformat();log=out/f'{variant}.log'
        for name,digest in f['source_hashes'].items():assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==digest,name
        print('TRIAL START',variant,started,flush=True)
        with log.open('w') as stream:
            run=subprocess.run(cmd,cwd=ROOT,stdout=stream,stderr=subprocess.STDOUT,timeout=1260)
        assert run.returncode==0,(variant,str(log));d=json.loads((out/f'{variant}.json').read_text());assert d['initial_input_sha256']==f['initial_inputs'][variant]['sha256'];assert d['status']!='RUNNING'
        result={'variant':variant,'started_utc':started,'elapsed_seconds':time.monotonic()-began,'returncode':run.returncode,'status':d['status'],'answer':d['answer'],'initial_input_sha256':d['initial_input_sha256'],'input_sha256':d['input_sha256'],'clauses':d['clauses'],'records':len(d['records']),'seed_cuts':d['seed_cut_count'],'new_cuts':len(d['cuts'])-d['seed_cut_count']};results.append(result)
        (out/'comparison-runs.json').write_text(json.dumps({'status':'COMPLETE' if len(results)==2 else 'RUNNING','source_C16_answered':False,'frozen_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'results':results},indent=2)+'\n');print('TRIAL END',json.dumps(result),flush=True)
    print('COMPARISON COMPLETE',flush=True)
if __name__=='__main__':main()
