"""Validate literature bookkeeping and cross-references, not the correctness of papers."""
import pathlib,json,collections,re
from urllib.parse import urlparse
R=pathlib.Path(__file__).resolve().parent.parent;D=R/'literature'
load=lambda n:json.loads((D/n).read_text())
papers=load('papers.json');fs=load('followups.json');authors=load('authors.json');links=load('problem-links.json');summary=load('summary.json')
source_ids={s['id'] for s in json.loads((R/'source-manifest.json').read_text())}
assert len(authors)==20 and {a['dissertation_id'] for a in authors}==source_ids
assert len({p['id'] for p in papers+fs})==len(papers+fs)
ids={p['id'] for p in papers+fs};pids={p['id'] for p in papers};fids={f['id'] for f in fs}
for p in papers+fs:
 assert set(p['dissertation_ids'])<=source_ids
 assert p['title'] and p['authors'] and urlparse(p['url']).scheme=='https'
 assert p['year']<=2026
for a in authors:
 assert set(a['paper_ids'])<=pids and set(a['followup_ids'])<=fids
 assert a['search_status']=='searched'
 for pid in a['paper_ids']:assert a['dissertation_id'] in next(p for p in papers if p['id']==pid)['dissertation_ids']
cs={c['id']:c for c in json.loads((R/'audit/claims.json').read_text()) if c['kind']=='open_question'}
assert len(links)==len(cs)==40 and {l['claim_id'] for l in links}==set(cs)
for l in links:
 c=cs[l['claim_id']]
 assert l['eligible_in_previous_audit']==c['in_denominator']
 assert l['source_pdf_pages']==c['pdf_pages'] and l['dissertation_id']==c['dissertation_id']
 assert set(l['paper_ids'])<=pids and set(l['followup_ids'])<=fids
 assert not l['full_resolution_verified']
 if l['finding']!='no_exact_reappearance_verified':assert l['paper_ids'] or l['followup_ids']
assert summary['article_preprint_records']==len(papers)==33
assert summary['authors_with_topic_matched_records']==sum(bool(a['paper_ids']) for a in authors)==16
assert summary['eligible_targets_from_lean_audit']==sum(l['eligible_in_previous_audit'] for l in links)==39
assert summary['findings']==dict(collections.Counter(l['finding'] for l in links))
report=(D/'README.md').read_text()
for p in papers+fs:assert p['url'] in report
for l in links:assert l['claim_id'] in report
# Relative documentation links, excluding external URLs and heading-only links.
for href in re.findall(r'\]\(([^)]+)\)',report):
 u=urlparse(href)
 if u.scheme or not u.path:continue
 assert (D/u.path).exists(),href
assert summary['full_resolutions_verified']==0
print(f'Validated {len(authors)} author records, {len(papers)} author-paper records, {len(fs)} related-paper/talk records, and the preserved 40-question dissertation cross-reference snapshot.')
