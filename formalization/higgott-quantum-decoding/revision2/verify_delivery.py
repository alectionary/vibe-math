"""Fetch immutable review artifacts and record hashes; requires network access.

Run after artifact publication. Does not rerender or change scientific outputs.
Usage: python revision2/verify_delivery.py COMMIT [revision2|revision3]
Then run skill scripts/delivery_check.py revision2/delivery_record.json --root .
"""
import hashlib,json,subprocess,sys
from pathlib import Path
root=Path(__file__).resolve().parents[1]
revision=sys.argv[1];assert len(revision)==40 and all(c in '0123456789abcdef' for c in revision)
repo=Path(subprocess.check_output(['git','-C',str(root),'rev-parse','--show-toplevel'],text=True).strip())
prefix=root.relative_to(repo).as_posix();download_root=Path('/tmp/higgott-verified-delivery')/revision;download_root.mkdir(parents=True,exist_ok=True)
def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def entry(path,remote=False):
 p=root/path;out=dict(path=path,sha256=digest(p))
 if remote:
  url=f'https://raw.githubusercontent.com/alectionary/vibe-math/{revision}/{prefix}/{path}';target=download_root/path;target.parent.mkdir(parents=True,exist_ok=True)
  subprocess.run(['curl','--fail','--silent','--show-error','--location',url,'--output',str(target)],check=True)
  assert digest(target)==out['sha256'],path
  out.update(url=url,downloaded_path=str(target))
 return out
stem='paper/sixfold_qubit_savings__a_replication_of_higgott_bolza_codes'
record_dir=root/(sys.argv[2] if len(sys.argv)>2 else 'revision2')
review=json.loads((record_dir/'manuscript_review.json').read_text())
primary=entry(stem+'.pdf',True);primary['role']='manuscript'
evidence=[entry(p.relative_to(root).as_posix(),True) for p in sorted((root/'source-evidence').iterdir()) if p.is_file()]
evidence.extend([entry('paper/references.tex',True),entry('README.md',True)])
if record_dir.name=='revision3':
 evidence.extend(entry('revision3/'+name,True) for name in ['comparison_decisions.json','claim_inventory.json','comparisons.py','tests.log','inventory_check.json','manuscript_review.json'])
template_path='../kupzyk-power-assumptions/paper/report.tex';template=entry(template_path);template['revision']='4775a6e8b86e0c569b428d1d1fd8c1d3755803bd'
record=dict(primary=primary,source=entry(stem+'.tex',True),evidence=evidence,baseline_revision='2fb3afac52accde8c4dc57e8e939c347668eb396',reproduction_revision=revision,artifact_revision=revision,template=template,build_inputs=[entry(p) for p in review['build_inputs']],review=review)
(record_dir/'delivery_record.json').write_text(json.dumps(record,indent=2)+'\n');print('Verified',len(evidence)+2,'remote files; PDF SHA256',primary['sha256'])
