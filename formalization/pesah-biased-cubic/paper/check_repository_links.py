"""Check this manuscript's navigation/provenance URLs, not external site availability."""
import collections,hashlib,json,re,subprocess
from pathlib import Path
import fitz
ROOT=Path(__file__).resolve().parents[3]
STUDY=ROOT/'formalization/pesah-biased-cubic'
PDF=STUDY/'paper/biased_noise_thresholds_of_cubic_and_rhombic_codes__replication_of_pesah_2021.pdf'
PREFIX='https://github.com/alectionary/vibe-math/'
REPRO='ed52777cee600ce33e24d45a43f8938d8cc5d15d'
def git(*args):return subprocess.check_output(['git','-C',str(ROOT),*args],text=True).strip()
head=git('rev-parse','HEAD');master=git('rev-parse','refs/remotes/origin/master');rows=[];errors=[];nav=set();nann=0
for n,page in enumerate(fitz.open(PDF),1):
 links=page.get_links();nann+=len(links)
 for a in links:
  url=a.get('uri')
  if not url:continue
  role='external citation'
  if url.startswith(PREFIX):
   target=url[len(PREFIX):]
   if target.startswith(('blob/master/','tree/master/')):
    role='repository navigation';path=target.split('/',2)[2].split('#')[0];nav.add(path)
    try:git('cat-file','-e',head+':'+path)
    except subprocess.CalledProcessError:errors.append('Missing branch destination: '+path)
   elif target=='commit/'+REPRO:role='labeled immutable reproduction provenance'
   else:role='INVALID internal target';errors.append(url)
  rows.append(dict(page=n,url=url,role=role))
# Master availability is separate from correct future navigation targets.
master_tree=set(git('ls-tree','-r','--name-only',master).splitlines())
missing=sorted(nav-master_tree)
out=dict(pdf_sha256=hashlib.sha256(PDF.read_bytes()).hexdigest(),checked_branch_revision=head,checked_cached_master_revision=master,annotation_count=nann,uri_annotations=len(rows),roles=dict(collections.Counter(x['role'] for x in rows)),unique_navigation_paths=len(nav),all_navigation_paths_exist_on_branch=not any(x.startswith('Missing') for x in errors),navigation_paths_absent_on_master=missing,availability='Master navigation targets are checked against the PR tree. Paths absent on master await merge; no live-master availability is claimed.',provenance_exception='Explicitly labeled immutable reproduction commit, supported by skill distinction between master navigation and immutable reproduction revision. External source/software version citations are not internal navigation.',links=rows,errors=errors)
(STUDY/'paper/repository-link-audit.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({k:v for k,v in out.items() if k not in ['links','navigation_paths_absent_on_master']},indent=2));print('master paths absent',len(missing));raise SystemExit(bool(errors))
