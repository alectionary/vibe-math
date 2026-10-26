"""Build against pinned Mathlib; isolate objects and record exact source/log hashes.

Child PIDs are recorded so cancelled/limited runs can clean up their own Lean
process without relying on unrestricted process-list access.
"""
from pathlib import Path
import argparse,datetime,hashlib,json,os,subprocess,time
R=Path(__file__).resolve().parent
P=R.parent
PIN='5f7b4198d22a9c82e1c698a379334fe128095c82'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def write_json(p,value):p.write_text(json.dumps(value,indent=2)+'\n')

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--mathlib',required=True,type=Path)
    ap.add_argument('--lean-bin',required=True,type=Path)
    ap.add_argument('--build-dir',required=True,type=Path)
    ap.add_argument('--timeout',type=int,default=900)
    ap.add_argument('--memory',type=int,default=2000)
    ap.add_argument('--threads',type=int,default=2)
    ap.add_argument('--deadline');ap.add_argument('modules',nargs='+');a=ap.parse_args()
    deadline=datetime.datetime.fromisoformat(a.deadline.replace('Z','+00:00')) if a.deadline else None
    assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=a.mathlib,text=True).strip()==PIN
    env=dict(os.environ);env['PATH']=str(a.lean_bin)+os.pathsep+env['PATH']
    version=subprocess.check_output([str(a.lean_bin/'lean'),'--version'],text=True)
    assert '4.36.0-rc1' in version
    paths=subprocess.check_output([str(a.lean_bin/'lake'),'env','printenv','LEAN_PATH'],cwd=a.mathlib,env=env,text=True).strip()
    a.build_dir.mkdir(parents=True,exist_ok=True);logs=R/'round-logs';logs.mkdir(exist_ok=True)
    env['LEAN_PATH']=os.pathsep.join([str(a.build_dir),str(R),str(R/'catalog-chunks'),str(P),paths])
    for mod in a.modules:
        remaining=(deadline-datetime.datetime.now(datetime.timezone.utc)).total_seconds() if deadline else a.timeout
        if remaining<=0:
            print('Global build deadline reached; remaining modules were not checked.',flush=True);return 2
        src=next(p for p in [R/(mod+'.lean'),R/'catalog-chunks'/(mod+'.lean'),P/(mod+'.lean')] if p.exists())
        log=logs/(mod+'.log');start=time.monotonic();source_hash=sha(src)
        active=a.build_dir/(mod+'.active.json');limited=False;interrupted=False
        with log.open('w') as f:
            proc=subprocess.Popen([str(a.lean_bin/'lean'),'-j',str(a.threads),'-M',str(a.memory),'-o',str(a.build_dir/(mod+'.olean')),str(src)],cwd=src.parent,env=env,stdout=f,stderr=subprocess.STDOUT)
            write_json(active,dict(pid=proc.pid,module=mod,source=str(src),started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat()))
            try:
                code=proc.wait(timeout=min(a.timeout,remaining))
            except subprocess.TimeoutExpired:
                limited=True;proc.kill();code=proc.wait()
            except KeyboardInterrupt:
                interrupted=True;proc.kill();code=proc.wait()
            finally:
                if proc.poll() is None:proc.kill();proc.wait()
                active.unlink(missing_ok=True)
        body=log.read_text();changed=sha(src)!=source_hash
        bad=limited or interrupted or changed or any(x in body for x in ['sorryAx','._native.','error:'])
        rec=dict(module=mod,source_sha256=source_hash,source_changed_during_build=changed,exit_code=code,seconds=time.monotonic()-start,log_sha256=sha(log),unexpected_axiom_or_error=bad,lean=version.strip(),mathlib=PIN,finished_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),time_limited=limited,interrupted=interrupted,threads=a.threads,memory_limit_mb=a.memory)
        write_json(logs/(mod+'.json'),rec);print(json.dumps(rec),flush=True)
        if code or bad:
            print(body[-6000:]);return 1
    return 0
if __name__=='__main__':raise SystemExit(main())
