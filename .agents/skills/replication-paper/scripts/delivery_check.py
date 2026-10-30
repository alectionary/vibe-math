"""Validate delivery evidence, not scientific truth or reviewer honesty.

RECORD: primary/source {path,sha256,url,downloaded_path}; primary role=manuscript;
evidence list of same objects. All remote URLs pin artifact_revision. build_inputs
list {path,sha256} includes the main source and all included tables/figures/bib.
template {path,revision,sha256}; baseline_revision/reproduction_revision are
historical/run-code provenance. Git objects are checked against artifact bytes.
review {reviewer,pdf_sha256,source_sha256,build_inputs:{path:sha256},items:{...}}.
Download remote files separately into distinct paths. This checker cannot prove
that a downloaded copy actually came from the URL or that a reviewer read it.
"""
import argparse,hashlib,json,re,subprocess
from pathlib import Path
import importlib.util
_spec = importlib.util.spec_from_file_location('replication_stages', Path(__file__).with_name('stage_checks.py'))
_stages = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_stages)
_link_spec = importlib.util.spec_from_file_location('replication_pdf_links', Path(__file__).with_name('pdf_links.py'))
_links = importlib.util.module_from_spec(_link_spec)
_link_spec.loader.exec_module(_links)
REVIEW_ITEMS=('layout','headline_and_tolerance','citations','ledgers','links','independence_limits')
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def sha(value):return isinstance(value,str) and bool(re.fullmatch('[0-9a-f]{40}',value))
def check(record,root,legacy_audit=False,details=None):
 root=Path(root).resolve();errors=[]
 if not isinstance(record,dict):return ['record must be an object']
 def obj(value,label):
  if not isinstance(value,dict):errors.append(label+': object required');return {}
  return value
 def seq(value,label):
  if not isinstance(value,list):errors.append(label+': list required');return []
  return value
 def git(*args):return subprocess.check_output(['git','-C',str(root),*args],stderr=subprocess.DEVNULL)
 try:repo=Path(git('rev-parse','--show-toplevel').decode().strip())
 except (OSError,subprocess.CalledProcessError):return ['root must be inside the reproduction Git repository']
 for key in ('baseline_revision','reproduction_revision','artifact_revision'):
  if not sha(record.get(key)):errors.append(key+': full revision required')
  else:
   try:git('cat-file','-e',record[key]+'^{commit}')
   except subprocess.CalledProcessError:errors.append(key+': commit not present')
 revision=record.get('artifact_revision','')
 def artifact(value,label,remote=False,revision_check=None):
  item=obj(value,label)
  try:
   path=item['path'];p=(root/path).resolve();actual=digest(p)
   if actual!=item['sha256']:errors.append(label+': stale local hash')
   if label=='primary' and not p.read_bytes().startswith(b'%PDF-'):errors.append('primary: not PDF bytes')
   if revision_check:
    rel=p.relative_to(repo).as_posix();blob=git('show',revision_check+':'+rel)
    if hashlib.sha256(blob).hexdigest()!=actual:errors.append(label+': bytes differ from recorded Git revision')
   if remote:
    url=item.get('url','');match=re.fullmatch(r'https://(?:raw\.githubusercontent\.com/[^/]+/[^/]+/|github\.com/[^/]+/[^/]+/blob/)([0-9a-f]{40})/(.+)',url) if isinstance(url,str) else None
    if not match or match[1]!=revision or match[2]!=p.relative_to(repo).as_posix():errors.append(label+': URL must pin artifact revision and path')
    if not legacy_audit and isinstance(url,str):
     declared=record.get('repository')
     if not isinstance(declared,str) or not (url.startswith('https://raw.githubusercontent.com/'+declared+'/') or url.startswith('https://github.com/'+declared+'/blob/')):errors.append(label+': delivery URL differs from declared repository')
    download=(root/item['downloaded_path']).resolve()
    if download==p:errors.append(label+': downloaded copy must have distinct path')
    if digest(download)!=actual:errors.append(label+': remote bytes differ')
  except (OSError,KeyError,TypeError,ValueError,subprocess.CalledProcessError) as e:errors.append(label+': artifact verification failed: '+type(e).__name__)
 primary=obj(record.get('primary'),'primary');source=obj(record.get('source'),'source')
 if primary.get('role')!='manuscript':errors.append('primary: main manuscript required')
 artifact(primary,'primary',True,revision if sha(revision) else None);artifact(source,'source',True,revision if sha(revision) else None)
 evidence=seq(record.get('evidence'),'evidence')
 if not evidence:errors.append('linked evidence required')
 for i,item in enumerate(evidence):artifact(item,f'evidence[{i}]',True,revision if sha(revision) else None)
 template=obj(record.get('template'),'template')
 if not sha(template.get('revision')):errors.append('template: full revision required')
 artifact(template,'template',revision_check=template.get('revision') if sha(template.get('revision')) else None)
 inputs=seq(record.get('build_inputs'),'build_inputs');hashes={}
 for i,value in enumerate(inputs):
  item=obj(value,'build input');artifact(item,f'build_inputs[{i}]',revision_check=revision if sha(revision) else None)
  if isinstance(item.get('path'),str):hashes[item['path']]=item.get('sha256')
 if not hashes or source.get('path') not in hashes:errors.append('build inputs must include main source and all included artifacts')
 review=obj(record.get('review'),'review')
 if not isinstance(review.get('reviewer'),str) or not review['reviewer'].strip():errors.append('independent reviewer required')
 for field,item in [('pdf_sha256',primary),('source_sha256',source)]:
  if not review.get(field) or review[field]!=item.get('sha256'):errors.append('review: stale '+field)
 if review.get('build_inputs')!=hashes:errors.append('review: stale build input hashes')
 items=obj(review.get('items'),'review items')
 for key in REVIEW_ITEMS:
  if not isinstance(items.get(key),str) or not items[key].strip():errors.append('manual review missing: '+key)
 if not legacy_audit:
  errors.extend(_stages.stage_errors(record,root))
  link_errors=_links.audit(record,root)
  errors.extend(_links.format_issue(item) for item in link_errors)
  if details is not None:details['pdf_link_failures']=link_errors
  for name in ('packet','writer_manifest','link_inventory'):
   artifact(record.get(name),name,revision_check=revision if sha(revision) else None)
 return errors
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('record');p.add_argument('--root',required=True);p.add_argument('--legacy-audit',action='store_true');a=p.parse_args()
 details={}
 errors=check(json.loads(Path(a.record).read_text()),a.root,legacy_audit=a.legacy_audit,details=details);print(json.dumps({'errors':errors,'pdf_link_failures':details.get('pdf_link_failures',[]),'structural_check_only':True,'current_acceptance':not errors and not a.legacy_audit,'legacy_audit':a.legacy_audit},indent=2));raise SystemExit(bool(errors))
