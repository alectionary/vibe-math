"""Validate the editorial revision without changing or re-proving mathematics."""
from pathlib import Path
from pypdf import PdfReader
import datetime,hashlib,json,re
R=Path(__file__).resolve().parents[1]
A=R/'formalization/stopping-bound/stronger'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text())
c=load(A/'compliance-data.json');v=load(A/'verification.json');p=load(A/'PRESENTATION-REVISION.json')
assert p['scope']=='presentation_and_research_skill_only'
assert p['canonical_inventory_delta']==p['new_mathematical_proofs']==0
assert p['checked_proof_source_commit']==c['checked_source_commit']
for e in c['paper_lean_files']:
 assert sha(A/e['local_path'])==e['sha256']
for name,digest in p['source_hashes'].items():assert sha(A/name)==digest
assert sha(R/'.agents/skills/open-question-research/SKILL.md')==p['skill_sha256']
r=PdfReader(A/'stronger-stopping-paper.pdf');pages=[q.extract_text()for q in r.pages];text='\n'.join(pages);flat=re.sub(r'\s+','',text)
assert len(pages)==v['paper']['pages']==p['paper_pages']
assert not r.metadata.get('/Author')
assert 'Abiad' in pages[0] and 'Proposition' in pages[0] and '5.1' in pages[0]
assert 'Parameter obstruction' in '\n'.join(pages[:2])
assert not re.search(r'expanded follow.up|presentation revised|second checkpoint|research time versus manuscript', text, re.I)
assert 'RESEARCH-PROVENANCE.txt' in p['internal_history_record']
assert 'Elapsed days' in pages[p['central_chronology_page']-1]
assert p['central_chronology_page']<=4
assert '101' in pages[p['central_chronology_page']-1]
assert len(p['visual_review']['reviewed_pages'])==len(pages)
assert p['visual_review']['rendered_pdf_sha256']==sha(A/'stronger-stopping-paper.pdf')
uris=set()
for q in r.pages:
 for a in q.get('/Annots',[]):
  uri=a.get_object().get('/A',{}).get('/URI')
  if uri:uris.add(str(uri))
for e in c['paper_lean_files']+c['cited_prior_proofs']:
 for key in ['branch_url','pinned_url']:assert e[key] in uris and e[key] in flat
assert len(c['chronology'])==p['source_chronology_records']
assert p['complete_chronology_records']==len(c['chronology'])-len(p['reproducibility_only_chronology_ids'])
revision=datetime.date.fromisoformat(c['revision_date'])
for s in c['chronology']:
 for m in s['milestones']:
  assert m['date'] in text
  lo=datetime.date.fromisoformat(m['earliest_possible']);hi=datetime.date.fromisoformat(m['latest_possible'])
  assert m['delta_days_min']==(revision-hi).days and m['delta_days_max']==(revision-lo).days
log=(A/'latex-build.log').read_text()
assert not any(x in log for x in ['Missing character:','Overfull \\hbox','undefined references'])
assert 'LaTeX' in log
assert p['style_baselines']==['formalization/dyadic-rank/paper/main.tex','formalization/cyclic-lifts/paper/main.tex']
assert all(x in text for x in ['Theorem 1','Theorem 2','Theorem 3','Theorem 4','Theorem 5'])
assert len(uris)==p['unique_uri_annotations']
print('PASS: established LaTeX format; original question/negative answer upfront; visible central chronology; complete date arithmetic and 194 Lean URLs; unchanged checked proofs; all rendered pages reviewed; updated skill.')
