"""Check deterministic source generation in an isolated directory."""
from pathlib import Path
import tempfile,shutil,subprocess,sys,hashlib,json
P=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
gens=['generate_normal_forms.py','generate_cycle_connections.py','generate_histogram_assembly.py','generate_voltage_data.py','generate_joint_normal_forms.py','generate_joint_connections.py','assemble_certificates.py']
with tempfile.TemporaryDirectory(prefix='lift-generators-') as tmp:
 d=Path(tmp)
 for f in gens+['research.py','results.json','joint-star.json']:
  shutil.copyfile(P/f,d/f)
 for f in gens:
  r=subprocess.run([sys.executable,str(d/f)],cwd=d,capture_output=True,text=True)
  assert r.returncode==0,(f,r.stderr)
 checked=[];diff=[]
 for f in sorted(d.glob('*.lean'))+sorted((d/'certificates').glob('*.lean')):
  reference=P/f.relative_to(d)
  assert reference.exists(),f.name
  if sha(f)!=sha(reference):diff.append(str(f.relative_to(d)))
  else:checked.append(str(f.relative_to(d)))
 if diff:
  print('Mismatched generators:',diff)
  for name in diff:
   r=subprocess.run(['diff','-u',str(P/name),str(d/name)],text=True,capture_output=True)
   print(r.stdout[:4000])
 else:
  out=dict(passed=True,generated_sources=checked,count=len(checked),assembled_module_count=10,component_count=141)
  (P/'generator-verification.json').write_text(json.dumps(out,indent=2)+'\n')
  print('PASS:',len(checked),'generated component source hashes reproduce exactly.')
 assert not diff
