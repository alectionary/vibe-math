#!/usr/bin/env python3
"""Run only the six predeclared sequential held-out discovery calls."""
from pathlib import Path
import datetime, hashlib, json, re, subprocess, time
ROOT=Path(__file__).resolve().parent
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    out=ROOT/'transfer-results'; path=out/'comparison-frozen.json';f=json.loads(path.read_text()); assert f['workers']==1
    assert not (out/'comparison-runs.json').exists(); results=[]
    for trial in f['trials']:
        for p,h in f['source_hashes'].items(): assert sha(ROOT/p)==h,p
        for p,h in f['library_hashes'].items(): assert sha(Path(p))==h,p
        began=time.monotonic(); started=datetime.datetime.now(datetime.timezone.utc).isoformat(); name=trial['name'];log=out/f'{name}.log'
        print('START',name,started,flush=True)
        with log.open('w') as stream:
            r=subprocess.run(['/usr/bin/time','-l',*trial['command']],cwd=ROOT,stdout=stream,stderr=subprocess.STDOUT,timeout=1020)
        assert r.returncode==0,(name,str(log)); d=json.loads((out/f'{name}.json').read_text())
        expected=f['initial_inputs'][trial['case_index']]['inputs'][trial['variant']]['sha256']
        assert d['initial_input_sha256']==expected and d['status']!='RUNNING'
        rss=re.search(r'(\d+)\s+maximum resident set size',log.read_text())
        row={'name':name,'variant':trial['variant'],'case_index':trial['case_index'],'started_utc':started,
             'elapsed_seconds':time.monotonic()-began,'status':d['status'],'answer':d['answer'],
             'maximum_resident_set_size_bytes':int(rss.group(1)) if rss else None,
             'initial_input_sha256':expected,'input_sha256':d['input_sha256'],'clauses':d['clauses'],
             'records':len(d['records']),'new_cuts':len(d['cuts'])-d['seed_cut_count']}
        results.append(row); (out/'comparison-runs.json').write_text(json.dumps({'status':'COMPLETE' if len(results)==6 else 'RUNNING',
            'frozen_sha256':sha(path),'source_C16_answered':False,'results':results},indent=2)+'\n')
        print('END',json.dumps(row),flush=True)
    print('ALL SIX FROZEN TRIALS COMPLETE',flush=True)
if __name__=='__main__':main()
