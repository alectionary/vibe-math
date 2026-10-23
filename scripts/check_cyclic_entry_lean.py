"""Serial kernel build of the early-entry follow-up and its complete examples."""
from pathlib import Path
import hashlib,json,subprocess,sys,time
ROOT=Path(__file__).resolve().parents[1];LEAN=ROOT/'formalization/dyadic-rank';HERE=ROOT/'formalization/cyclic-lifts'
MODULES=[('CyclicDecoderEntry','entry-dynamics-lean.log'),('CyclicDecoderEntryChannel','entry-channel-lean.log'),('CyclicDecoderEntryInitial','entry-initial-lean.log'),('CyclicDecoderEntryWitnesses','entry-witnesses-lean.log'),('CyclicDecoderEntryBridge','entry-bridge-lean.log'),('CyclicDecoderEntryExamples','entry-examples-lean.log'),('CyclicDecoderEntryCone','entry-cone-lean.log'),('CyclicDecoderEntryRepair','entry-repair-lean.log'),('CyclicDecoderEntryBias','entry-bias-lean.log'),('CyclicDecoderEntryDelayed','entry-delayed-lean.log'),('CyclicDecoderEntryAudit','entry-final-axioms.log')]

def run():
 start=time.monotonic();results=[];previous={};dirty='--resume' not in sys.argv
 if not dirty:
  previous={r['module']:r for r in json.loads((HERE/'search/entry-lean-build-results.json').read_text())['modules']}
 for name,filename in MODULES:
  before=time.monotonic();log=HERE/filename;source=LEAN/(name+'.lean')
  digest=hashlib.sha256(source.read_bytes()).hexdigest()
  old=previous.get(name)
  if not dirty and old and old['status']=='passed' and old.get('source_sha256')==digest and old.get('log_sha256')==hashlib.sha256(log.read_bytes()).hexdigest():
   results.append(old);print(name,'reused source-bound kernel check',flush=True)
   continue
  dirty=True
  with log.open('w') as out:
   proc=subprocess.run(['lake','env','lean','-j1','-o','.lake/build/lib/lean/'+name+'.olean',name+'.lean'],cwd=LEAN,stdout=out,stderr=subprocess.STDOUT)
  text=log.read_text();ok=proc.returncode==0 and 'error:' not in text and 'sorryAx' not in text and hashlib.sha256(source.read_bytes()).hexdigest()==digest
  results.append(dict(module=name,status='passed' if ok else 'failed',source=str(source.relative_to(ROOT)),source_sha256=digest,seconds=time.monotonic()-before,log=str(log.relative_to(ROOT)),log_sha256=hashlib.sha256(log.read_bytes()).hexdigest()))
  print(name,results[-1]['status'],round(results[-1]['seconds'],2),'seconds',flush=True)
  (HERE/'search/entry-lean-build-results.json').write_text(json.dumps(dict(status='all_entry_modules_passed' if len(results)==len(MODULES) and all(r['status']=='passed' for r in results) else 'in_progress' if ok else 'failed',modules=results,elapsed_seconds=time.monotonic()-start),indent=2)+'\n')
  if not ok:raise SystemExit(1)
if __name__=='__main__':run()
