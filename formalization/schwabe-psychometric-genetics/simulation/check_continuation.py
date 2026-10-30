"""Test aggregation plumbing with explicitly synthetic copies, never fit evidence."""
import csv,json,pathlib,subprocess,sys,tempfile,shutil
study=pathlib.Path('.').resolve()
with tempfile.TemporaryDirectory(prefix='schwabe-continuation-fixture-')as tmp:
 root=pathlib.Path(tmp);out=root/'outputs';out.mkdir()
 for p in (study/'outputs').glob('pilot-c6-*.csv'): (out/p.name).symlink_to(p)
 for name in ['source-figure-values.csv','timing-c5-largest-timing.csv']: (out/name).symlink_to(study/'outputs'/name)
 (root/'coverage.csv').symlink_to(study/'coverage.csv')
 def run(dest):
  subprocess.run([sys.executable,str(study/'simulation/summarize.py'),'--include-full','--output-dir',str(root/dest)],cwd=root,check=True,stdout=subprocess.DEVNULL)
  return json.load(open(root/dest/'summary.json'))
 for method in ['full','deletion']:
  shutil.copyfile(out/f'pilot-c6-MCAR-q2-m0.02-r0-{method}.csv',out/f'full-c6-MCAR-q2-m0.02-r0-{method}.csv')
 duplicate=run('dedup');assert duplicate['trial_fits']==1920
 # Fixture-only distinct seed/replicate tests selection, not scientific evidence.
 for method in ['full','deletion']:
  path=out/f'full-c6-MCAR-q2-m0.02-r20-{method}.csv'
  rows=list(csv.DictReader(open(out/f'pilot-c6-MCAR-q2-m0.02-r0-{method}.csv')))
  for r in rows:r['seed']='999999'
  with open(path,'w')as f:w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
 continuation=run('continued');assert continuation['trial_fits']==1922 and continuation['max_replicates']==21
result={'status':'passed','baseline_fit_count':1920,'duplicate_full_fixture_count':duplicate['trial_fits'],'distinct_seed_fixture_count':continuation['trial_fits'],'scope':'Temporary copied-input fixture tests aggregation only; no new scientific fits, all fixture outputs deleted.'}
pathlib.Path('outputs/continuation-check.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))
