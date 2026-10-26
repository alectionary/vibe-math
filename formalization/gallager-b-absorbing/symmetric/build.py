"""Clean-build the general theorem, exact question interfaces and consumers."""
from pathlib import Path
import argparse,datetime,hashlib,json,os,re,subprocess,tempfile,time,sys
R=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('--lean',required=True);a=p.parse_args()
modules=['OddSupport','Question','Consumers','Audit'];names={};hashes={}
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for module in modules:
 source=R/(module+'.lean');text=source.read_text()
 assert not re.search(r'\b(sorry|admit|axiom|native_decide|bv_decide)\b',text)
 assert all(x in ['Std']+modules for x in re.findall(r'^import (\S+)',text,re.M))
 hashes[source.name]=sha(source)
 ns={'OddSupport':'CSSOddSupport','Question':'CSSOddSupport.Question','Consumers':'CSSOddSupport.Consumers'}.get(module)
 for m in re.finditer(r'^theorem (\w+)',text,re.M):
  name=ns+'.'+m.group(1);names[name]=dict(source=source.name,line=text[:m.start()].count('\n')+1)
version=subprocess.check_output([a.lean,'--version'],text=True).strip();assert '4.36.0-rc1' in version
started=time.time();logs=[];returns={}
with tempfile.TemporaryDirectory(prefix='css-odd-clean-') as d:
 env=os.environ.copy();env['LEAN_PATH']=d
 for module in modules:
  result=subprocess.run([a.lean,'-j','1','--root='+str(R),'-o',str(Path(d)/(module+'.olean')),str(R/(module+'.lean'))],env=env,capture_output=True,text=True,timeout=600)
  log=result.stdout+result.stderr;logs.append('MODULE '+module+'\n'+log);returns[module]=result.returncode
  (R/'lean-build.log').write_text('\n'.join(logs))
  assert result.returncode==0,log
  assert (Path(d)/(module+'.olean')).is_file()
log='\n'.join(logs)
assert not re.search(r'sorryAx|_native|Lean.ofReduceBool|Lean.trustCompiler|error[:(]',log)
reports={}
for m in re.finditer(r"'([^']+)' (depends on axioms:\s*\[([^]]*)\]|does not depend on any axioms)",log):
 axioms=[x.strip() for x in (m.group(3) or '').split(',') if x.strip()]
 assert set(axioms)<={'propext','Classical.choice','Quot.sound'},(m.group(1),axioms)
 reports[m.group(1)]=axioms
assert set(reports)==set(names),(set(names)-set(reports),set(reports)-set(names))
for n in names:names[n]['axioms']=reports[n]
subprocess.run([sys.executable,str(R/'verify.py'),'--check'],check=True)
record=dict(independent_replay=True,certificate_sha256=sha(R/'certificate.json'),verifier_sha256=sha(R/'verify.py'),verification_inputs_sha256=sha(R/'verification-inputs.json'),schema=1,checked_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),canonical_id='L-P09-all-absorbing',followup_id='RQ-P09-symmetric-css',lean_version=version,lean_build_seconds=time.time()-started,lean_returncode=0,module_returncodes=returns,research_import_closure=[x+'.lean' for x in modules],external_imports=['Std'],source_sha256=hashes,build_log_sha256=sha(R/'lean-build.log'),allowed_axioms=['propext','Classical.choice','Quot.sound'],no_admitted_or_native_oracle_proofs=True,theorem_count=len(names),declarations=names,proof_scope='General arbitrary-length binary CSS odd-support obstruction under equality of stabilizer row spaces; arbitrary syndrome-only recovery maps; exact full and one-step question interfaces; presentation/Pauli-sector reductions; independent small consumers. No even-support existence result.',canonical_completion_delta=0)
(R/'verification.json').write_text(json.dumps(record,indent=2)+'\n')
print('PASS:',len(names),'general/interface/consumer theorems; complete clean closure; standard dependencies only.')
print('Build seconds:',round(record['lean_build_seconds'],2))
