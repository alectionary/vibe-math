#!/usr/bin/env python3
"""Regenerate ordinary proofs of the six fixed final CNFs, with bounded calls."""
from pathlib import Path
import json,subprocess,sys,time
ROOT=Path(__file__).resolve().parent
if __name__=='__main__':
    out=ROOT/'transfer-results';f=json.loads((out/'comparison-frozen.json').read_text());results=[]
    for t in f['trials']:
        path=out/(t['name']+'.json');d=json.loads(path.read_text())
        if d['answer'] is not False:continue
        assert 'fresh_proof' not in d;began=time.monotonic();log=out/(t['name']+'-proof.log');print('PROOF START',t['name'],flush=True)
        with log.open('w') as stream:
            r=subprocess.run([sys.executable,str(ROOT/'fresh_strategy_proof.py'),'--certificate',str(path),'--seconds','600'],
                cwd=ROOT,stdout=stream,stderr=subprocess.STDOUT,timeout=750)
        final=json.loads(path.read_text());row={'name':t['name'],'returncode':r.returncode,'elapsed_seconds':time.monotonic()-began,
            'proof_generated':r.returncode==0 and 'fresh_proof' in final,'fresh_proof':final.get('fresh_proof')}
        results.append(row);(out/'proof-generation.json').write_text(json.dumps({'results':results},indent=2)+'\n');print('PROOF END',json.dumps(row),flush=True)
