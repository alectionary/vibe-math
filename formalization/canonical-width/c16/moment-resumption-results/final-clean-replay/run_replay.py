from pathlib import Path
import subprocess,os,json,time,hashlib,datetime
root=Path('/private/tmp/c16-moment-clean-20261030T0241');cwd=root/'formalization/canonical-width/c16';out=Path('/private/tmp/c16-moment-final-clean-replay');py='/private/tmp/c16-venv/bin/python';r='moment-resumption-results/';point=r+'boolean-rational1.json.gz';env=os.environ.copy();env.update({k:'1' for k in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS']})
steps=[
 ('closed-rank','verify_weighted_matroid_cuts.py',['--certificate',r+'closed-rank-bank-augmented.json']),
 ('closed-dominance','verify_closed_rank_cuts.py',['--certificate',r+'closed-rank-bank-augmented.json']),
 ('final-rank','verify_weighted_matroid_cuts.py',['--certificate',r+'final-point-rank-probe.json']),
 ('unified','verify_unified_moment_point.py',['--certificate',point,'--old-replay',r+'boolean-old-replay1.json','--matroid-cuts',r+'closed-rank-bank-augmented.json','--matroid-replays',str(out/'closed-rank.json'),'--separating-cuts',r+'final-point-rank-probe.json','--separating-replay',str(out/'final-rank.json')]),
 ('global-moments','check_global_conditioned_moments.py',['--point',point,'--global-certificate',r+'global-four-trial.json','--global-replay',r+'global-four-trial-independent.json']),
 ('all-triples','complete_boolean_triples.py',['--point',point]),
 ('triple-distributions','verify_all_triple_distributions.py',['--point',point]),
 ('profile-fixed','verify_common_profile_cut.py',['--point',point,'--bank',r+'common-profile32-all.json']),
 ('profile-projected','verify_common_profile_cut.py',['--point',point,'--bank',r+'common-profile32-free-support.json']),
 ('profile-pruned','verify_common_profile_cut.py',['--point',point,'--bank',r+'common-profile32-projected-pruned.json'])]
assert not subprocess.check_output(['git','status','--porcelain'],cwd=root)
commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip();commands=[[py,'-u',script,*args,'--output',str(out/(name+'.json'))] for name,script,args in steps]
frozen={'status':'FROZEN_BEFORE_CLEAN_REPLAY','commit':commit,'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'commands':commands,'scope':'Final independently callable consumers; global physical/CNF replay is an unchanged dependency already replayed at a423fbe.'};(out/'frozen.json').write_text(json.dumps(frozen,indent=2)+'\n');start=time.monotonic();records=[]
for (name,script,args),cmd in zip(steps,commands):
 t=time.monotonic()
 with (out/(name+'.log')).open('w') as log:result=subprocess.run(cmd,cwd=cwd,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=150)
 receipt=json.loads((out/(name+'.json')).read_text()) if (out/(name+'.json')).exists() else {}
 rec={'stage':name,'returncode':result.returncode,'status':receipt.get('status'),'seconds':time.monotonic()-t,'receipt_sha256':hashlib.sha256((out/(name+'.json')).read_bytes()).hexdigest() if receipt else None};records.append(rec);print(rec,flush=True)
 assert result.returncode==0 and receipt['status']=='PASS',rec
assert not subprocess.check_output(['git','status','--porcelain'],cwd=root)
summary={'status':'PASS','source_C16_answered':False,'commit':commit,'worktree_clean_before_and_after':True,'stages':records,'elapsed_seconds':time.monotonic()-start,'point_sha256':hashlib.sha256((cwd/point).read_bytes()).hexdigest(),'finished_utc':datetime.datetime.now(datetime.timezone.utc).isoformat()};(out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n');print('COMPLETE',summary['elapsed_seconds'],flush=True)
