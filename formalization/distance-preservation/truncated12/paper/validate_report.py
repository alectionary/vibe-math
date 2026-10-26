"""Validate manuscript coverage, exact listings, PDF links and packaged hashes."""
from pathlib import Path
import datetime,hashlib,json,re,zipfile
from pypdf import PdfReader
P=Path(__file__).resolve().parent;R=P.parent;ROOT=R.parents[2]
def sha(data):return hashlib.sha256(data).hexdigest()
def main():
 x=json.loads((P/('report-audit.json' if (P/'report-audit.json').exists() else 'archive-metadata.json')).read_text());v=json.loads((R/'verification.json').read_text());c=json.loads((P/'proof-coverage.json').read_text());a=json.loads((P/'declaration-audit.json').read_text());tex=(P/'main.tex').read_text()
 assert v['main_source_distance_theorem_completed'] and not v['remaining_formal_gaps'];assert x['research_imports']==len(c['sources'])==269
 assert x['finite_cases']==sum(y['admitted_patterns'] for y in v['kernel_cases'].values())==183312
 assert len(c['listings'])==x['complete_listings'] and len({y['qualified'] for row in c['proofs'] for y in row['declarations']})<=a['audited_declarations']
 assert a['status']=='PASS' and sha((P/'ReportAudit.lean').read_bytes())==a['source_sha256'] and sha((P/'ReportAudit.log').read_bytes())==a['log_sha256']
 assert set(a['axioms'])<={'propext','Classical.choice','Quot.sound'}
 assert set(re.findall(r'\\label\{((?:thm|lem|prop):[^}]+)\}',tex))=={row['manuscript_label'] for row in c['proofs']}
 for row in c['proofs']:
  assert r'\label{'+row['manuscript_label']+'}' in tex,row['manuscript_label']
  for d in row['declarations']:assert v['modules'][d['module']]['status']=='PASS'
 paths={d['module']:ROOT/d['path'] for d in c['sources']}
 for d in c['sources']:assert sha(paths[d['module']].read_bytes())==d['source_sha256']
 for d in c['listings']:
  raw='\n'.join(paths[d['module']].read_text().splitlines()[d['line']-1:d['last_line']])+'\n'
  assert d['complete_declaration'] and sha(raw.encode())==d['raw_sha256'],d['name']
  assert sha((P/'listings'/d['listing']).read_bytes())==d['listing_sha256']
  assert '#L'+str(d['line'])+'-L'+str(d['last_line']) in d['url']
 chronology=json.loads((P/'reference-chronology.json').read_text());date=datetime.date.fromisoformat(chronology['manuscript_date'])
 for d in chronology['references']:
  assert (date-datetime.date.fromisoformat(d['earliest_date'])).days==d['earliest_age_days']
  assert (date-datetime.date.fromisoformat(d['inspected_version_date'])).days==d['version_age_days']
 lock=json.loads((P/'dependency-lock.json').read_text());manifest=json.loads((P/'mathlib-lake-manifest.json').read_text())
 assert lock['manifest_matches_mathlib_commit'] and sha((P/'mathlib-lake-manifest.json').read_bytes())==lock['committed_lake_manifest_sha256']
 assert {d['name']:d['rev'] for d in manifest['packages']}=={d['name']:d['revision'] for d in lock['actual_dependency_revisions_checked']}
 reader=PdfReader(P/'main.pdf');assert len(reader.pages)>=25;assert not reader.metadata.get('/Author');assert 'truncated distance' in reader.metadata.get('/Title','').lower()
 text='\n'.join(p.extract_text() or '' for p in reader.pages);assert not any(s in text for s in ['??','TODO','PLACEHOLDER','REPLACE_ME'])
 for marker in ['Truncated source distance','Implications and remaining question','Proof coverage and reproducibility','Complete research-source link index','source_distance_bound_twelve']:assert marker in text,marker
 assert r'\author{}' in tex and r'\date{25 October 2026}' in tex
 assert not re.search(r'\b(?:revised|expanded version|updated paper)\b',tex,re.I)
 uris=[]
 for page in reader.pages:
  for ref in page.get('/Annots',[]):
   annot=ref.get_object();action=annot.get('/A',{});uri=action.get('/URI')
   if uri:uris.append(str(uri));rect=annot.get('/Rect');assert rect is None or (0<=float(rect[0])<float(page.mediabox.width)+1 and float(rect[2])<=float(page.mediabox.width)+1)
 assert not any('\\#' in u or 'proof@' in u or 'None' in u for u in uris)
 links=set(uris)
 for d in c['sources']:assert d['url'] in links and d['current_url'] in links,d['module']
 for d in c['listings']:assert d['url'] in links,d['name']
 log=(P/'main.log').read_text();assert not any(s in log for s in ['Overfull \\hbox','Overfull \\vbox','Missing character','Undefined control sequence','There were undefined references'])
 assert sha((P/'main.pdf').read_bytes())==x['pdf_sha256']
 archive=P/'truncated-distance-source.zip'
 if archive.exists():
  assert sha(archive.read_bytes())==x['archive_sha256']
  with zipfile.ZipFile(archive) as z:
   assert z.testzip() is None;members=set(z.namelist());sums=z.read('SHA256SUMS.txt').decode()
   if 'sha256_manifest_sha256' in x:assert sha(sums.encode())==x['sha256_manifest_sha256']
   expected={}
   for line in sums.splitlines():digest,name=line.split('  ',1);expected[name]=digest
   assert members==set(expected)|{'SHA256SUMS.txt'}
   for name,digest in expected.items():assert sha(z.read(name))==digest,name
 else:
  sums=(ROOT/'SHA256SUMS.txt').read_text();expected={}
  for line in sums.splitlines():digest,name=line.split('  ',1);expected[name]=digest
  members=set(expected)|{'SHA256SUMS.txt'}
  for name,digest in expected.items():assert sha((ROOT/name).read_bytes())==digest,name
 assert not any(n.endswith(('.olean','.pyc')) or '/.venv/' in n or '/runtime/' in n or '/.git/' in n for n in members)
 for d in c['sources']:assert d['path'] in members
 x.update(status='PASS',validated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),pdf_pages=len(reader.pages),pdf_external_links=len(uris),archive_integrity='PASS',complete_listing_integrity='PASS',reference_date_arithmetic='PASS',source_and_axiom_audit='PASS')
 (P/'report-audit.json').write_text(json.dumps(x,indent=2)+'\n');print(json.dumps(x,indent=2))
if __name__=='__main__':main()
