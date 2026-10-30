from pathlib import Path
import hashlib,json,os,subprocess,time
C=Path('/private/tmp/c16-coupling-clean-0957/formalization/canonical-width/c16');O=Path(__file__).resolve().parent;PY='/private/tmp/c16-venv/bin/python'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
commands=[[PY,'-u','verify_joint_anchor_profile_bound.py','--certificate',f'coupling-results/joint-anchor-{kind}-exact.json','--parent','moment-resumption-results/common-profile32-projected-pruned.json','--point','moment-resumption-results/boolean-rational1.json.gz','--output',str(O/f'joint-{kind}-source.json')] for kind in ['matched','conditional']]
(O/'joint-extra-frozen.json').write_text(json.dumps({'commands':commands,'controller_sha256':sha(__file__),'input_and_source_hashes':{q:sha(C/q) for q in ['verify_joint_anchor_profile_bound.py','coupling-results/joint-anchor-producer-v2.py','joint_anchor_profile_bound.py','moment-resumption-results/boolean-rational1.json.gz']}},indent=2)+'\n')
env=os.environ.copy();env.update({k:'1' for k in ['PYTHONDONTWRITEBYTECODE','OPENBLAS_NUM_THREADS','OMP_NUM_THREADS']});rows=[]
for name,cmd in zip(['matched','conditional'],commands):
 t=time.monotonic()
 with (O/f'joint-{name}-source.log').open('w') as log:rc=subprocess.run(cmd,cwd=C,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=60).returncode
 p=O/f'joint-{name}-source.json';d=json.loads(p.read_text()) if p.exists() else {};rows.append(dict(stage=name,returncode=rc,status=d.get('status'),seconds=time.monotonic()-t,receipt_sha256=sha(p) if p.exists() else None))
out=dict(status='PASS_EXTRA_JOINT_SOURCE_PROOFS' if all(x['returncode']==0 and x['status']=='PASS' for x in rows) else 'FAILURE_PRESERVED',records=rows);(O/'joint-extra-summary.json').write_text(json.dumps(out,indent=2)+'\n');print(out)
