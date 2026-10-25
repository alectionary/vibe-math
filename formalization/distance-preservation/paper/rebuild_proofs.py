"""Portable isolated rebuild; --check-plan checks hashes/imports without building.

Set up the pinned Lake environment before rebuilding. All output goes to a new
scratch directory; historical sources, build records and manifests stay intact.
"""
from pathlib import Path
import argparse, datetime, hashlib, json, os, re, shutil, subprocess
P=Path(__file__).resolve().parent
W=P.parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--environment',type=Path,default=P/'lean-environment')
    ap.add_argument('--output',type=Path)
    ap.add_argument('--check-plan',action='store_true')
    a=ap.parse_args()
    modules=json.loads((W/'verification.json').read_text())['module_order']
    hashes=json.loads((W/'clean-rebuild.json').read_text())['source_sha256']
    done=set();order=[]
    while len(order)<len(modules):
        ready=[]
        for mod in modules:
            if mod in done:continue
            src=W/(mod+'.lean');assert sha(src)==hashes[mod],mod
            deps=set(re.findall(r'^import ([A-Za-z0-9_]+)\s*$',src.read_text(),re.M))
            local={d for d in deps if (W/(d+'.lean')).exists()}
            assert local<=set(modules),(mod,local-set(modules))
            if local<=done:ready.append(mod)
        assert ready,'Import cycle or missing source'
        for mod in ready:done.add(mod);order.append(mod)
    assert len(order)==50 and order[-1]=='FinalAudit'
    if a.check_plan:
        print(json.dumps({'status':'PASS','scope':'Hashes/import plan only; no new proof rebuild.',
                          'modules':len(order),'last_module':order[-1]}));return
    assert a.output,'Pass --output with a new scratch directory'
    target=a.output.expanduser().resolve();target.mkdir(parents=True,exist_ok=False)
    lake=a.environment.expanduser().resolve()
    lean=subprocess.check_output(['lake','env','which','lean'],cwd=lake,text=True).strip()
    raw=subprocess.check_output(['lake','env','printenv','LEAN_PATH'],cwd=lake,text=True).strip()
    deps=[str((lake/x).resolve()) if not Path(x).is_absolute() else x for x in raw.split(os.pathsep)]
    assert not any(str(W) in x for x in deps),'Exclude original research objects from environment'
    env=dict(os.environ,LEAN_PATH=os.pathsep.join([str(target)]+deps))
    (target/'logs').mkdir()
    for mod in order:shutil.copyfile(W/(mod+'.lean'),target/(mod+'.lean'))
    shutil.copyfile(P/'PaperAudit.lean',target/'PaperAudit.lean')
    records=[]
    for mod in order+['PaperAudit']:
        res=subprocess.run([lean,'-M','6000','-o',str(target/(mod+'.olean')),
                            str(target/(mod+'.lean'))],cwd=target,env=env,
                           text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
        log=target/'logs'/(mod+'.log');log.write_text(res.stdout)
        assert res.returncode==0,(mod,str(log))
        assert not any(x in res.stdout for x in ['sorryAx','_native.','error:']),(mod,str(log))
        for group in re.findall(r'depends on axioms: \[([^]]*)\]',res.stdout):
            assert {x.strip() for x in group.split(',') if x.strip()}<={'propext','Classical.choice','Quot.sound'}
        records.append({'module':mod,'source_sha256':sha(target/(mod+'.lean')),
                        'log_sha256':sha(log),'exit_code':0})
        print(json.dumps(records[-1]),flush=True)
    out={'status':'PASS','finished_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
         'scope':'50main modules plus manuscript declaration audit; cached dependencies reused.',
         'records':records}
    (target/'rebuild.json').write_text(json.dumps(out,indent=2)+'\n')

if __name__=='__main__':main()
