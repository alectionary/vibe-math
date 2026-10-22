"""Validate audit bookkeeping and evidence consistency; not mathematical correctness."""
import pathlib,json,collections,re,hashlib
from html.parser import HTMLParser
from urllib.parse import urlparse,unquote
R=pathlib.Path(__file__).resolve().parent.parent;A=R/'audit'
load=lambda p:json.loads((R/p).read_text())
claims=load('audit/claims.json');sources={s['id']:s for s in load('source-manifest.json')};summary=load('audit/summary.json')
assert len({c['id'] for c in claims})==len(claims)
assert {c['dissertation_id'] for c in claims}==set(sources)
for c in claims:
 s=sources[c['dissertation_id']]
 assert c['source_sha256']==s['sha256']
 assert c['pdf_pages'] and all(1<=p<=s['pages'] for p in c['pdf_pages'])
 assert c['comparison'] and c['statement_summary'] and c['unl_record']==s['source_url']
 assert c['in_denominator']==(c['classification']!='statement_clarification_needed')
 assert c['lean_statement_status']=='no_exact_statement_identified'
 assert c['lean_proof_status']=='no_exact_proof_identified'
 if c['kind']=='proved_result' and c['label'].startswith(('Theorem ','Lemma ','Corollary ','Proposition ')):
  extraction=R/'local-extraction'/(c['dissertation_id']+'.json')
  if extraction.exists():
   pages=json.loads(extraction.read_text());text=' '.join(pages[i-1]['text'] for i in c['pdf_pages'])
   assert re.search(r'\s*'.join(map(re.escape,c['label'].split())),text),c['id']
assert summary['ledger_units']==len(claims)==178
assert summary['selected_units']==sum(c['in_denominator'] for c in claims)==174
assert summary['units']==dict(collections.Counter(c['unit'] for c in claims if c['in_denominator']))
assert summary['held_for_clarification']==sum(not c['in_denominator'] for c in claims)==4
triage=load('audit/numbered-question-triage.json');index=load('reviews/statement-index.json')
identity=lambda x:(x['dissertation_id'],x['kind'],x['number'])
assert set(map(identity,triage))=={identity(x) for x in index if x['kind'] in ('Question','Conjecture','Problem')}
assert len(triage)==42
ids={c['id'] for c in claims}
for t in triage:
 assert t['status']!='REVIEW_REQUIRED'
 assert set(t['claim_ids'])<=ids
 if t['status']=='linked_to_claim_ledger':assert t['claim_ids']
search=load('audit/local-source-searches.json');assert len(search)==100
assert {x['dissertation_id'] for x in search}==set(sources)
assert all(x['exit_code'] in (0,1) for x in search)
for x in search:assert bool(x['matching_files'])==(x['exit_code']==0)
candidates=load('audit/candidates.json');checked=[c for c in candidates if c['locally_checked']]
assert len(checked)==summary['background_declarations_checked']==5
log=(A/'lean-checks.log').read_text();assert 'error:' not in log and 'sorryAx' not in log
for c in checked:
 assert f"'{c['declaration']}' depends on axioms: [propext, Classical.choice, Quot.sound]" in log
assert log.count('depends on axioms:')==5
class Links(HTMLParser):
 def handle_starttag(self,tag,attrs):
  if tag!='a':return
  for k,v in attrs:
   if k!='href':continue
   u=urlparse(v)
   if u.scheme or not u.path:continue
   p=(A/unquote(u.path)).resolve();assert p.is_relative_to(R)
   if p.suffix!='.pdf':assert p.exists(),p
Links().feed((A/'coverage.html').read_text())
print('Validated 178 ledger units, 174 eligible targets, 42 numbered-question dispositions, 100 local searches, and 5 Lean axiom reports. Named-result page labels and local report links checked.')
