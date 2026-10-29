#!/usr/bin/env python3
"""Retain the completed first call and execute the remaining frozen calls once."""
from pathlib import Path
import hashlib,json,subprocess,sys
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    out=ROOT/'transfer-results';fp=out/'comparison-frozen.json';f=json.loads(fp.read_text())
    amendment=json.loads((out/'measurement-amendment.json').read_text()); results=[]
    assert not (out/'comparison-runs.json').exists()
    for index,t in enumerate(f['trials']):
        for p,h in f['source_hashes'].items():assert sha(ROOT/p)==h,p
        for p,h in f['library_hashes'].items():assert sha(Path(p))==h,p
        for p,h in amendment['repair_source_hashes'].items():assert sha(ROOT/p)==h,p
        if index==0:
            assert sha(out/(t['name']+'.json'))==amendment['retained_first_metadata_sha256']
            timing=amendment['retained_first_timing']
        else:
            assert not (out/(t['name']+'.json')).exists();print('START',t['name'],flush=True)
            r=subprocess.run([sys.executable,str(ROOT/'timed_transfer_command.py'),str(index)],cwd=ROOT,timeout=1050)
            assert r.returncode==0,t['name'];timing=json.loads((out/(t['name']+'-timing.json')).read_text())
        d=json.loads((out/(t['name']+'.json')).read_text());expected=f['initial_inputs'][t['case_index']]['inputs'][t['variant']]['sha256']
        assert d['initial_input_sha256']==expected and d['status']!='RUNNING' and (d['child_returncode']==0 or d['outer_wall_expired'])
        row={'name':t['name'],'variant':t['variant'],'case_index':t['case_index'],**timing,'status':d['status'],'answer':d['answer'],
             'initial_input_sha256':expected,'input_sha256':d['input_sha256'],'clauses':d['clauses'],'records':len(d['records']),
             'new_cuts':len(d['cuts'])-d['seed_cut_count']}
        results.append(row);(out/'comparison-runs.json').write_text(json.dumps({'status':'COMPLETE' if len(results)==6 else 'RUNNING',
             'frozen_sha256':sha(fp),'measurement_amendment_sha256':sha(out/'measurement-amendment.json'),
             'source_C16_answered':False,'results':results},indent=2)+'\n');print('END',json.dumps(row),flush=True)
    print('ALL SIX FROZEN TRIALS COMPLETE',flush=True)
if __name__=='__main__':main()
