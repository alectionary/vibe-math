"""Independent exact checks, cross-language replay, and frozen-payload integrity.
Uses Python>=3.10 and a C++17 compiler; writes only a computation recheck report
and deterministic checker reports, whose frozen hashes are checked afterward.
"""
from pathlib import Path
import tempfile,subprocess,sys,os,json,hashlib,time,datetime,shutil
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 manifest=ROOT/'verification.json';frozen=json.loads(manifest.read_text())['payload_sha256'] if manifest.exists() else {}
 for name,h in frozen.items():assert sha(ROOT/name)==h,name
 records=[]
 def run(args,**kwargs):
  t=time.monotonic();r=subprocess.run(args,cwd=ROOT,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=180,**kwargs);assert r.returncode==0,r.stdout
  records.append(dict(command=[Path(args[0]).name]+[str(x).replace(str(ROOT),'.') for x in args[1:]],exit_code=0,seconds=time.monotonic()-t,stdout_sha256=hashlib.sha256(r.stdout.encode()).hexdigest()));return r.stdout
 for script in ['verify_certificates.py','verify_family_ingredients.py','validate_results.py','check_generators.py']:run([sys.executable,script])
 cxx=shutil.which(os.environ.get('CXX','c++'));assert cxx,'C++17 compiler required'
 compiler=run([cxx,'--version']).splitlines()[0]
 with tempfile.TemporaryDirectory(prefix='lift-label-recheck-') as tmp:
  for source,inp,expected in [('exhaustive.cpp','exhaustive-input.txt','exhaustive-results.jsonl'),('verify_quantum.cpp','quantum280-input.txt','quantum-independent.json')]:
   exe=str(Path(tmp)/Path(source).stem);run([cxx,'-O3','-UNDEBUG','-std=c++17',source,'-o',exe])
   with (ROOT/inp).open() as f:stdout=run([exe],stdin=f)
   got=[json.loads(s) for s in stdout.splitlines()];want=[json.loads(s) for s in (ROOT/expected).read_text().splitlines()];assert got==want,(source,got,want)
 for name,h in frozen.items():assert sha(ROOT/name)==h,('Frozen payload mutated',name)
 # Do not preserve temporary executable paths or user-specific interpreter paths.
 for row in records:row['command']=[x if '/lift-label-recheck-' not in x else '<temporary-executable>' for x in row['command']]
 out=dict(passed=True,compiler=compiler,python=sys.version.split()[0],records=records,frozen_payload_checked=bool(frozen),frozen_payload_preserved=True,finished_utc=datetime.datetime.now(datetime.timezone.utc).isoformat())
 target=ROOT/'.recheck';target.mkdir(exist_ok=True);(target/'computation-recheck.json').write_text(json.dumps(out,indent=2)+'\n');print('PASS: integer certificates, family ingredients, complete C++ gauge enumeration and independent [[280,18,6]] matrices.',flush=True)
if __name__=='__main__':main()
