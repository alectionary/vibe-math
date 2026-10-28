from pathlib import Path
import subprocess,json,hashlib,time,os,concurrent.futures
r=Path('/private/tmp/c16-theory-clean-20261028');dest=Path('/private/tmp/c16-theory-clean-results');dest.mkdir(exist_ok=True);py='/private/tmp/c16-venv/bin/python';b='formalization/canonical-width/c16/';env=dict(os.environ,PYTHONPATH='/private/tmp/c16-theory-exact-guard');start=time.monotonic()
sha=subprocess.check_output(['git','rev-parse','HEAD'],cwd=r,text=True).strip();assert not subprocess.check_output(['git','status','--porcelain'],cwd=r,text=True)
neg=subprocess.run([py,'-c','import pysat'],cwd=r,env=env,capture_output=True,text=True);assert neg.returncode and 'Independent replay forbids' in neg.stderr
manifest=json.loads((r/b/'theory-loop-results/manifest.json').read_text())
for f in manifest['files']:
 raw=(r/f['path']).read_bytes();assert len(raw)==f['bytes'] and hashlib.sha256(raw).hexdigest()==f['sha256']
jobs=[('cover428',[b+'verify_cover_exchanges.py','--chain',b+'theory-loop-results/exchange/chain.json','--drat-trim','/private/tmp/c16-drat-trim/drat-trim']),('rank-minimality',[b+'verify_theory_loop.py']),('encoding-controls',[b+'check_theory_controls.py']),('affine-control',[b+'verify_affine_signature_closure.py','--certificate',b+'theory-loop-results/affine-control.json.gz']),('affine-hard',[b+'verify_affine_signature_closure.py','--certificate',b+'theory-loop-results/affine-hard.json.gz']),('witness36',[b+'verify_unit_witness_cover.py','--chain',b+'theory-loop-results/witness36/chain.json','--drat-trim','/private/tmp/c16-drat-trim/drat-trim']),('native-parity-control',[b+'check_native_parity_proof.py',b+'theory-loop-results/native-toy.xnf',b+'theory-loop-results/native-toy.lrup'])]
def run(job):
 name,args=job;out=dest/(name+'.json');t=time.monotonic();p=subprocess.run([py,*args,'--output',str(out)],cwd=r,env=env,capture_output=True,text=True,timeout=600);(dest/(name+'.log')).write_text(p.stdout+p.stderr);assert p.returncode==0,(name,p.returncode,p.stderr[-1000:]);d=json.loads(out.read_text());assert d['status']=='PASS';print(name,'PASS',round(time.monotonic()-t,2),flush=True);return {'name':name,'status':'PASS','output_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'elapsed_seconds':time.monotonic()-t,'command':[py,*args,'--output',str(out)]}
with concurrent.futures.ThreadPoolExecutor(max_workers=3) as pool:results=list(pool.map(run,jobs))
validators=[]
for name in ['validate_open_problems.py','validate_current_difficulty.py']:
 p=subprocess.run([py,'scripts/'+name],cwd=r,env=env,capture_output=True,text=True,timeout=120);assert p.returncode==0,p.stderr;validators.append({'name':name,'returncode':p.returncode,'output':p.stdout})
p=subprocess.run(['git','diff','--check'],cwd=r,capture_output=True,text=True);assert p.returncode==0
assert not subprocess.check_output(['git','status','--porcelain'],cwd=r,text=True)
receipt={'status':'PASS','scientific_commit':sha,'clean_detached_checkout':str(r),'discovery_dependency_guard':'pysat import rejected; numerical/discovery packages blocked by frozen exact-only-sitecustomize.py','frozen_file_hashes_checked':len(manifest['files']),'checks':results,'validators':validators,'git_diff_check_returncode':0,'clean_at_end':True,'source_C16_answered':False,'verified_cover':428,'elapsed_seconds':time.monotonic()-start}
(dest/'clean-checkout.json').write_text(json.dumps(receipt,indent=2)+'\n');print('ALL PASS',sha,flush=True)
