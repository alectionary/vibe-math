#!/usr/bin/env python3
"""Consolidate saved runs without upgrading any timeout or discarding raw evidence."""
import hashlib,json,pathlib,shutil,time
from solve import BASE,read,check
HERE=pathlib.Path(__file__).resolve().parent
OUT=HERE/'results'
expected={'test-real-blocks01':43046721,'test-real-blocks23':0,'test-planted1-A':1,'test-planted1-B':1,'test-planted1-C':1,'test-real-quarter':0}

def validate(r):
    assert r['status'] in ('COMPLETE','INCOMPLETE')
    if r['frame'] is not None:
        x,z=read(r['pools']);check(x,z,r['frame'],r['class'],32 if r['class'].startswith('blocks') else 128)

def main():
    import os
    if hasattr(os,'sched_getaffinity'):os.sched_setaffinity(0,sorted(os.sched_getaffinity(0))[:2])
    p=json.loads((HERE/'provenance.json').read_text())
    for name,digest in p['sha256'].items():assert hashlib.sha256((BASE/name).read_bytes()).hexdigest()==digest
    OUT.mkdir(exist_ok=True);index={}
    for name,n in expected.items():
        source=HERE/('bundle-outputs' if name in ('test-planted1-B','test-planted1-C') else 'final-outputs')/(name+'.json')
        r=json.loads(source.read_text());validate(r);assert r['status']=='COMPLETE' and r['frames_found']==n
        shutil.copyfile(source,OUT/(name+'.json'));index[name]={'selected_source':str(source.relative_to(HERE)),'sha256':hashlib.sha256(source.read_bytes()).hexdigest()}
    for kind in ('A','B','C'):
        candidates=[]
        for directory in ('bundle-outputs','final-outputs'):
            source=HERE/directory/f'real-{kind}.json'
            if source.exists():
                r=json.loads(source.read_text());validate(r);candidates.append((source,r))
        assert candidates,f'No completed output (even INCOMPLETE) for real {kind}'
        decisions=[(p,r) for p,r in candidates if r['status']=='COMPLETE']
        if decisions:assert len({r['frames_found']>0 for p,r in decisions})==1,'Conflicting complete results require investigation'
        source,r=(decisions or candidates)[0]
        shutil.copyfile(source,OUT/f'real-{kind}.json')
        index[f'real-{kind}']={'selected_source':str(source.relative_to(HERE)),'sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'all_runs':[{'source':str(p.relative_to(HERE)),'status':r['status'],'frames_found':r['frames_found'],'seconds':r['seconds']} for p,r in candidates]}
    (OUT/'tests-passed.json').write_text(json.dumps({'all_passed':True,'consolidated_at_unix':time.time(),'recorded_gates':['../final-outputs/tests-passed.json','../bundle-outputs/tests-passed.json'],'notes':'Consolidation of recorded runs, not a new experiment.'},indent=2)+'\n')
    (OUT/'index.json').write_text(json.dumps(index,indent=2)+'\n')
    table=['| Pools | Class | Status | Frames found | Seconds |','|---|---|---|---:|---:|']
    for name in list(expected)+['real-A','real-B','real-C']:
        r=json.loads((OUT/(name+'.json')).read_text());table.append(f"| {r['pools']} | {r['class']} | {r['status']} | {r['frames_found']:,} | {r['seconds']:.3f} |")
    result='\n'.join(table)+'\n\nFor block tests, frames found is the exact count; otherwise it is returned witnesses.\nINCOMPLETE is not a nonexistence decision. Sources and additional raw runs are\nlisted in `results/index.json`.\n'
    readme=HERE/'README.md';text=readme.read_text();head=text.split('## Final result table')[0];readme.write_text(head+'## Final result table\n\n'+result)
    print(result)

if __name__=='__main__':main()
