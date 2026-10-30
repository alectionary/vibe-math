"""Fetch immutable public artifact bytes and write a hash-bound delivery receipt."""
import argparse,hashlib,json,subprocess
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('revision');p.add_argument('--download-dir',required=True);p.add_argument('--record-output');a=p.parse_args()
root=Path('formalization/moss-score-reliability').resolve();repo=root.parents[1]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
name='score_weighting_and_reliability__a_replication_of_moss_2020'
files=['paper/'+name+'.pdf','paper/'+name+'.tex','paper/references.tex','outputs/comparison.json','outputs/contrasts.json','outputs/independent.csv','outputs/validation.json','source-evidence/table_3.png','provenance/source-review.json','provenance/numerical-review.json','provenance/manuscript-review.json','provenance/availability.json','scripts/replicate.R','inputs/bfi.rda','README.md']
out=Path(a.download_dir).resolve();out.mkdir(parents=True,exist_ok=True)
items=[]
for f in files:
 rel=(root/f).relative_to(repo).as_posix()
 raw=f'https://raw.githubusercontent.com/alectionary/vibe-math/{a.revision}/{rel}'
 dest=out/f;dest.parent.mkdir(parents=True,exist_ok=True)
 subprocess.run(['curl','--fail','--location','--silent','--show-error',raw,'-o',str(dest)],check=True)
 assert sha(dest)==sha(root/f),f+' remote hash differs'
 items.append(dict(path=f,sha256=sha(root/f),url=f'https://github.com/alectionary/vibe-math/blob/{a.revision}/{rel}',downloaded_from=raw,downloaded_path=str(dest)))
inputs=['paper/'+name+'.tex']+['paper/'+x+'.tex' for x in ['preamble','references','revision','headline','comparison','availability','compliance']]
review=json.loads((root/'provenance/manuscript-review.json').read_text())
assert review.get('pass') is True
# Preserve the independent review artifact; normalize its evidence fields for the delivery schema.
review['items']={k:(v['evidence'] if isinstance(v,dict) and v.get('pass') is True else v) for k,v in review['items'].items()}
record=dict(baseline_revision='69a290d2fadef4df1337d6ae93c31e0f784475a4',reproduction_revision='13e7922599d1677520e3082a5311ec174c9e0164',artifact_revision=a.revision,primary=dict(items[0],role='manuscript'),source=items[1],evidence=items[2:],build_inputs=[dict(path=x,sha256=sha(root/x)) for x in inputs],template=dict(path='../../.agents/skills/replication-paper/assets/approved-preamble.tex',revision='69a290d2fadef4df1337d6ae93c31e0f784475a4',sha256=sha(repo/'.agents/skills/replication-paper/assets/approved-preamble.tex')),review=review)
(Path(a.record_output) if a.record_output else root/'provenance/delivery-record.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps(dict(verified_files=len(items),artifact_revision=a.revision,primary_sha256=items[0]['sha256'])))
