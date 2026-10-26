"""Rebuild the complete standalone Lean proof and independent certificate."""
from pathlib import Path
import argparse,hashlib,json,re,subprocess,tempfile,time,datetime
R=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('--lean',required=True);a=p.parse_args()
source=R/'Connected.lean'
text=source.read_text()
assert not re.search(r'\b(sorry|admit|axiom)\b',text)
assert not re.search(r'\b(native_decide|bv_decide)\b', text)
version=subprocess.check_output([a.lean,'--version'],text=True).strip()
assert '4.36.0-rc1' in version,version
start=time.time()
with tempfile.TemporaryDirectory(prefix='gallager-clean-') as d:
 with (R/'lean-build.log').open('w') as output, (R/'lean-profile.log').open('w') as profile:
  result=subprocess.run([a.lean,'-j','1','--profile','-o',str(Path(d)/'Connected.olean'),str(source)],stdout=output,stderr=profile,text=True,timeout=2400)
 log=(R/'lean-build.log').read_text()
 assert result.returncode==0,log
 assert not re.search(r'sorryAx|error:|declaration uses',log),log
 assert (Path(d)/'Connected.olean').is_file()
 assert not re.search(r'_native|Lean.ofReduceBool|Lean.trustCompiler',log),log
 declarations=re.findall(r'^theorem (\w+)',text,re.M)
 for name in declarations:
  assert "ConnectedAbsorbing."+name in log,name
 for line in log.splitlines():
  if 'depends on axioms:' in line:
   actual={x.strip() for x in line.split('[')[1].split(']')[0].split(',') if x.strip()}
   assert actual <= {'propext','Classical.choice','Quot.sound'},actual
lean_seconds=time.time()-start
cert=subprocess.run([__import__('sys').executable,str(R/'verify.py'),'--check'],capture_output=True,text=True,check=True)
(R/'independent-verification.log').write_text(cert.stdout+cert.stderr)
sha=lambda path:hashlib.sha256(path.read_bytes()).hexdigest()
declarations=re.findall(r'^theorem (\w+)',text,re.M)
coverage={name:dict(source='Connected.lean',line=text[:text.index('theorem '+name)].count('\n')+1) for name in declarations}
record=dict(schema=1,checked_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
 canonical_id='L-P09-all-absorbing',lean_version=version,imports=['Std'],
 lean_build_seconds=lean_seconds,lean_returncode=result.returncode,
 proof_method='kernel-evaluated decide for finite domains; structural graph walks, Boolean spanning-tree and stopped-execution proofs; bv_normalize proof-producing simplification only',
 allowed_axioms=['propext','Classical.choice','Quot.sound'],
 no_sorry=True,no_native_decide=True,complete_research_import_closure=['Connected.lean'],
 claim_scope='15-coordinate CSS example; connected actual decoding graph; all 128 supported Z-errors recovered under both syndrome tests; no physical product cut; asymmetric CSS and four-cycles allowed; no both-sector result',
 declarations=coverage,source_sha256=sha(source),certificate_sha256=sha(R/'certificate.json'),
 verifier_sha256=sha(R/'verify.py'),build_log_sha256=sha(R/'lean-build.log'),profile_log_sha256=sha(R/'lean-profile.log'),lean_workers=1,diagnostic_streams='stdout and profiling stderr captured separately',
 issue='https://github.com/alectionary/vibe-math/issues/2')
(R/'verification.json').write_text(json.dumps(record,indent=2)+'\n')
print('All',len(declarations),'theorems checked; independent 128-error certificate replay passed.')
print('Clean Lean build seconds:',round(lean_seconds,2))
