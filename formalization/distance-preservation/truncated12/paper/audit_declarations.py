"""Check every declaration used in the report against the admitted proof objects."""
from pathlib import Path
import argparse,datetime,hashlib,json,os,re,subprocess
P=Path(__file__).resolve().parent
PIN='5f7b4198d22a9c82e1c698a379334fe128095c82'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--mathlib',type=Path,required=True);ap.add_argument('--lean-bin',type=Path,required=True);ap.add_argument('--build-dir',type=Path,required=True);a=ap.parse_args()
 assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=a.mathlib,text=True).strip()==PIN
 env=dict(os.environ);env['PATH']=str(a.lean_bin)+os.pathsep+env['PATH'];version=subprocess.check_output([str(a.lean_bin/'lean'),'--version'],text=True).strip();assert '4.36.0-rc1' in version
 paths=subprocess.check_output([str(a.lean_bin/'lake'),'env','printenv','LEAN_PATH'],cwd=a.mathlib,env=env,text=True).strip();env['LEAN_PATH']=os.pathsep.join([str(a.build_dir),paths])
 source=P/'ReportAudit.lean';before=sha(source);log=P/'ReportAudit.log';start=datetime.datetime.now(datetime.timezone.utc)
 with log.open('w') as f:x=subprocess.run([str(a.lean_bin/'lean'),'-j','2','-M','2400',str(source)],cwd=P,env=env,stdout=f,stderr=subprocess.STDOUT,timeout=600)
 body=log.read_text();axioms=set()
 for names in re.findall(r'depends on axioms: \[([^\]]*)\]',body):axioms.update(n.strip() for n in names.split(',') if n.strip())
 count=len(re.findall(r'^#check ',source.read_text(),re.M));assert x.returncode==0 and before==sha(source) and axioms<={'propext','Classical.choice','Quot.sound'} and not any(s in body for s in ['sorryAx','._native.','error:'])
 record=dict(status='PASS',exit_code=x.returncode,started_utc=start.isoformat(),finished_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),source_sha256=before,log_sha256=sha(log),audited_declarations=count,axioms=sorted(axioms),proof_commit='3ae21c0719cedbd928f4f7882f9b9e266567605e',mathlib=PIN,lean=version)
 (P/'declaration-audit.json').write_text(json.dumps(record,indent=2)+'\n');print(json.dumps(record,indent=2))
if __name__=='__main__':main()
