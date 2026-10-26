"""Rebuild the complete standalone Lean proof and independent certificate."""
from pathlib import Path
import argparse,hashlib,json,re,subprocess,tempfile,time,datetime
R=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('--lean',required=True);a=p.parse_args()
source=R/'Counterexample.lean'
text=source.read_text()
assert not re.search(r'\b(sorry|admit|axiom)\b',text)
assert 'by native_decide' not in text
version=subprocess.check_output([a.lean,'--version'],text=True).strip()
assert '4.36.0-rc1' in version,version
start=time.time()
with tempfile.TemporaryDirectory(prefix='gallager-clean-') as d:
 result=subprocess.run([a.lean,'-o',str(Path(d)/'Counterexample.olean'),str(source)],capture_output=True,text=True,timeout=3600)
 log=result.stdout+result.stderr
 (R/'lean-build.log').write_text(log)
 assert result.returncode==0,log
 assert not re.search(r'sorryAx|error:|declaration uses',log),log
 assert (Path(d)/'Counterexample.olean').is_file()
lean_seconds=time.time()-start
cert=subprocess.run([__import__('sys').executable,str(R/'verify.py'),'--check'],capture_output=True,text=True,check=True)
(R/'independent-verification.log').write_text(cert.stdout+cert.stderr)
sha=lambda path:hashlib.sha256(path.read_bytes()).hexdigest()
declarations=re.findall(r'^theorem (\w+)',text,re.M)
coverage={name:dict(source='Counterexample.lean',line=text[:text.index('theorem '+name)].count('\n')+1) for name in declarations}
record=dict(schema=1,checked_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
 canonical_id='L-P09-all-absorbing',lean_version=version,imports=['Std'],
 lean_build_seconds=lean_seconds,lean_returncode=result.returncode,
 proof_method='kernel-evaluated decide for the complete finite domain; structural stopped-execution proof',
 allowed_axioms=['propext','Classical.choice','Quot.sound'],
 no_sorry=True,no_native_decide=True,complete_research_import_closure=['Counterexample.lean'],
 claim_scope='explicit unrestricted counterexample, including all 128 supported binary errors; disconnected ambient fourteen-coordinate CSS embedding; no girth or distance claim',
 declarations=coverage,source_sha256=sha(source),certificate_sha256=sha(R/'certificate.json'),
 verifier_sha256=sha(R/'verify.py'),build_log_sha256=sha(R/'lean-build.log'),
 issue='https://github.com/alectionary/vibe-math/issues/2')
(R/'verification.json').write_text(json.dumps(record,indent=2)+'\n')
print('All',len(declarations),'theorems checked; independent 128-error certificate replay passed.')
print('Clean Lean build seconds:',round(lean_seconds,2))
