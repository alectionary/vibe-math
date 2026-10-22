"""Render the curated JSON reviews as GitHub Markdown and local HTML."""
import pathlib,json,html,collections
from urllib.parse import quote
ROOT=pathlib.Path(__file__).resolve().parent.parent
SOURCES=json.loads((ROOT/'source-manifest.json').read_text())
REVIEWS=json.loads((ROOT/'reviews'/'reviews.json').read_text())
INDEX=json.loads((ROOT/'reviews'/'statement-index.json').read_text())
CATEGORIES=[('definitions','Mathematical setup and definitions'),('proved_or_derived','Results proved or derived in the dissertation'),('assumptions','Hypotheses and modeling assumptions'),('imported_results','Prior results used'),('computational_or_empirical','Computational and empirical evidence'),('open_questions','Questions, conjectures and remaining work'),('interpretation_notes','Scope and interpretation notes')]
CSS='''body{font:16px/1.6 system-ui,sans-serif;color:#202833;max-width:1100px;margin:40px auto;padding:0 24px}h1{line-height:1.2}h2{margin-top:36px;font-size:23px}a{color:#17569a}small,.muted{color:#5a6472}.notice{padding:16px 20px;background:#edf3f9;border-left:4px solid #34699a}.pill{font-size:13px;border:1px solid #c6d4e2;border-radius:20px;padding:3px 9px}table{width:100%;border-collapse:collapse;margin:20px 0}th,td{text-align:left;padding:12px 10px;border-bottom:1px solid #dbe2ea;vertical-align:top}th{background:#edf2f6}input{font:inherit;width:95%;padding:12px;margin:20px 0;border:1px solid #8b9eb2;border-radius:6px}li{margin-bottom:13px}details{margin-top:30px}footer{margin:40px 0;font-size:14px}code{background:#f3f4f6;padding:2px 4px}'''
def shell(title,body,script=''):
 return f'<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>{html.escape(title)}</title><style>{CSS}</style></head><body>{body}{script}</body></html>'
def page_links(source,pages,local=True):
 base='../'+quote(source['filename']) if local else source['pdf_url']
 return ', '.join(f'<a href="{html.escape(base)}#page={p}">{p}</a>' for p in pages)
rows=[];mdrows=[]
for s in SOURCES:
 key=s['id'];r=REVIEWS[key];e=html.escape
 local_stmts=[i for i in INDEX if i['dissertation_id']==key]
 md=[f"# {s['title']}",f"{s['author']} · {s['year']} · {s['department']}",'',f"[Source record]({s['source_url']}) · [Original PDF]({s['pdf_url']})",'',r['summary'],'',
 '## Review scope','',
 'This is an AI-assisted map of principal mathematical results and their evidence, not an independent correctness audit or an exhaustive classification of every assertion. All page numbers below are 1-based PDF viewer pages, including repository cover sheets. “Proved” reports how the dissertation presents a result. Open status is historical to the dissertation; later literature was not checked.','',
 '## Proof-assistant formalization','',r['mechanization']['status']+'. '+r['mechanization']['scope'],'']
 parts=[f'<p><a href="../analysis.html">← All reviews</a> · <a href="../index.html">PDF collection</a></p><h1>{e(s["title"])}</h1><p>{e(s["author"])} · {s["year"]} · {e(s["department"])}</p><p><a href="{e(s["source_url"])}">Source record</a> · <a href="../{quote(s["filename"])}">Local PDF</a> · <a href="{e(s["pdf_url"])}">Original PDF</a></p><p>{e(r["summary"])}</p>',
 '<div class="notice"><strong>Review scope.</strong> Principal-result and evidence map, not an independent proof-correctness audit or a claim-by-claim complete classification. PDF pages are 1-based viewer pages including cover sheets. Open status is as described in the dissertation, not checked against later literature.</div>',
 '<h2>Proof-assistant formalization</h2><p>'+e(r['mechanization']['status'])+'. '+e(r['mechanization']['scope'])+'</p>']
 for field,title in CATEGORIES:
  md+=['## '+title,''];parts+=['<h2>'+title+'</h2><ul>']
  for entry in r[field]:
   label=(entry['label']+': ') if entry['label'] else ''
   cited=', '.join(f'[{p}]({s["pdf_url"]}#page={p})' for p in entry['pdf_pages'])
   md+=['- '+label+entry['text']+' (PDF pp. '+cited+').','']
   parts+=['<li>'+e(label+entry['text'])+' <small>(PDF pp. '+page_links(s,entry['pdf_pages'])+')</small></li>']
  parts+=['</ul>']
 md+=['## Possible first formalization task','',r['suggested_formalization_target'],'',
 'This is a reviewer suggestion for new work, not an assertion that the dissertation result already has a formal proof.','',
 '## Numbered-statement navigation','',f'The automated index detects {len(local_stmts)} unique kind/number pairs for this PDF. It can include restatements and references or miss unnumbered mathematics. These are navigation candidates, not a count of new or proven results. See [statement-index.json](statement-index.json).','',
 '| Kind | Number | PDF viewer pages |','| --- | --- | --- |']
 parts+=['<h2>Possible first formalization task</h2><p>'+e(r['suggested_formalization_target'])+'</p><p class="muted">A suggestion for new work, not an existing formalization.</p>',
 f'<details><summary>Numbered-statement navigation: {len(local_stmts)} detected kind/number pairs</summary><p>Automatically detected headings or mentions. These may include restatements or references and may omit unnumbered results. Individual proof status and novelty have not been classified by this index.</p><table><thead><tr><th>Kind</th><th>Number</th><th>PDF pages</th></tr></thead><tbody>']
 for entry in local_stmts:
  md.append(f'| {entry["kind"]} | {entry["number"]} | '+', '.join(map(str,entry['pdf_pages']))+' |')
  parts+=['<tr><td>'+e(entry['kind'])+'</td><td>'+e(entry['number'])+'</td><td>'+page_links(s,entry['pdf_pages'])+'</td></tr>']
 parts+=['</tbody></table></details><footer>Reviewed October 21, 2026. Source SHA-256: <code>'+s['sha256']+'</code></footer>']
 (ROOT/'reviews'/f'{key}.md').write_text('\n'.join(md)+'\n')
 (ROOT/'reviews'/f'{key}.html').write_text(shell(s['title'],''.join(parts)))
 rows+=[f'<tr><td>{s["year"]}</td><td><a href="reviews/{key}.html">{e(s["title"])}</a><br><small>{e(s["author"])}</small></td><td>{e(s["topic"])}</td><td>{len(r["proved_or_derived"])}</td><td>{len(r["open_questions"])}</td><td><a href="{quote(s["filename"])}">PDF</a> · <a href="{e(s["source_url"])}">Source</a></td></tr>']
 mdrows+=[f'| {s["year"]} | [{s["title"]}](reviews/{key}.md) | {s["author"]} |']
body='''<h1>Mathematical evidence in 20 dissertations</h1><p>2022–2026 · Reviewed October 21, 2026 · <a href="index.html">PDF collection</a> · <a href="reviews/reviews.json">Structured reviews</a> · <a href="reviews/statement-index.json">Numbered-statement index</a></p><div class="notice"><strong>What is classified:</strong> principal results/derivations, explicit hypotheses, imported results, computational evidence, conjectures/questions, and scope limits. <strong>Mechanization:</strong> no proof-assistant verification was identified in the reviewed PDFs; that is not a claim that external formalizations do not exist. The accompanying index is automatic navigation, not an exhaustive proof-status audit. “Open” means open or proposed in the dissertation; later literature was not checked.</div><h2>Reading the classifications</h2><p><strong>Precisely stated</strong> means expressed as mathematical definitions, equations or theorems. <strong>Conventionally proved</strong> means the dissertation supplies or cites a mathematical argument. <strong>Machine checked</strong> requires a proof-assistant artifact; ordinary computer algebra, exhaustive search, numerical solutions and empirical comparisons do not establish this status. An assumption is not a failed theorem, and a conditional theorem is a valid theorem with restricted scope.</p><p>The counts below are grouped review entries, not numbers of theorems or independent open problems. Each review links its claims to the local PDF and lists detected numbered statements separately.</p><label for="q">Filter by author, title, year or subject</label><input id="q" type="search" placeholder="Try: coding, geometry, Chanda, 2024"><p id="count">20 dissertations</p><table><thead><tr><th>Year</th><th>Review / author</th><th>Subject</th><th>Result groups</th><th>Question/direction groups</th><th>Source</th></tr></thead><tbody>'''+''.join(rows)+'''</tbody></table><footer>All 20 source PDFs remain local. Repository content consists of original review notes, metadata, hashes and scripts. The source documents retain their authors’ copyrights.</footer>'''
script='''<script>const q=document.querySelector('#q');const rows=[...document.querySelectorAll('tbody tr')];q.addEventListener('input',()=>{let n=0;for(const r of rows){r.hidden=!r.textContent.toLowerCase().includes(q.value.toLowerCase());if(!r.hidden)n++;}document.querySelector('#count').textContent=n+' dissertations';});</script>'''
body='<p><a href="literature/open-problems.html">Expanded open-problem inventory</a> · <a href="literature/README.md">Academic literature follow-up</a> · <a href="audit/coverage.html">Lean coverage audit: counts and claim ledger</a> · <a href="audit/README.md">Method and limitations</a></p>'+body
(ROOT/'analysis.html').write_text(shell('vibe-math | Mathematical reviews',body,script))
readme='''# vibe-math

A research collection covering 20 doctoral dissertations from 2022–2026: 16 mathematics, 3 statistics and 1 computing (graph theory). The source PDFs total 3,xxx pages; exact metadata and SHA-256 hashes are in `source-manifest.json`.

## Start here

- **Dyadic rank theorem:** [complete general Lean proof](formalization/dyadic-rank/README.md).
- **Lean difficulty estimates:** [per-question ratings and assumptions](planning/LEAN-DIFFICULTY.md) and [searchable estimates](planning/difficulty.html).
- **Expanded open-problem inventory:** [searchable annotated inventory](literature/open-problems.html) and [method/counts](literature/OPEN-PROBLEMS.md), including the downstream articles; [full-text gap closure](literature/COVERAGE-GAPS.md).
- **Academic literature follow-up:** [author papers and open-problem references](literature/README.md), with a structured [question ledger](literature/problem-links.json).
- **Lean coverage audit:** [counts, scope and evidence](audit/README.md), [searchable ledger](audit/coverage.html), and [structured claims](audit/claims.json).
- Read a paper-specific review using the table below.
- Locally, open `analysis.html` for a searchable overview and `index.html` for the PDF collection.
- `reviews/reviews.json` is the curated structured evidence map.
- `reviews/statement-index.json` is a navigation index of automatically detected numbered headings/mentions.

## Meaning and scope

The AI-assisted reviews map principal mathematical content: definitions and precisely stated results; conventional proofs/derivations; hypotheses and modeling assumptions; prior results used; computational/empirical evidence; unresolved questions/conjectures; and possible first formalization tasks. Each substantive entry cites 1-based PDF viewer pages, including repository cover sheets. They are not a line-by-line verification of every proof or an exhaustive classification of every assertion.

“Proved” reports how a dissertation presents a result, not an independent certification of correctness. “Formalized” as mathematical notation is distinguished from a proof checked by Lean, Coq/Rocq, Isabelle, or another proof assistant. No proof-assistant verification was identified in the PDFs reviewed. The original review did not audit external repositories. A subsequent [bounded external coverage audit](audit/README.md) records selected target-level searches, source revisions, rejected matches, and locally checked background declarations. No exact target match was identified in that search; global absence is not established. Computer algebra, proof-search implementations, exact finite computations, and numerical/statistical experiments are kept separate from kernel-checked formal proofs.

Open-question status is as described in each dissertation. Later papers were not checked to determine whether those questions remain open today. Review-identified proof obligations are explicitly distinguished from author-stated open problems. Introductory restatements and cited background theorems are not all new contributions.

The statement index has 1,170 detected kind/number pairs. It is a search aid: it can include references/restatements and miss unnumbered results. It does not assign individual proof validity or novelty. The manually curated review entries carry the substantive classifications. The separate coverage audit selects 132 eligible named results, 3 derivation groups and 39 open targets; 4 further units need statement clarification. These selected units do not form an exhaustive theorem inventory.

## Reviews

| Year | Dissertation review | Author |
| --- | --- | --- |
'''+ '\n'.join(mdrows)+'''

## Source documents and reproducibility

PDFs and full-text extracts stay local and are gitignored. This repository tracks original notes and metadata rather than redistributing dissertations. `catalog.json` contains canonical source record/download links. Place downloaded PDFs at the relative filenames shown there; some source PDF downloads require a normal browser session.

```sh
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install -r requirements.txt
python3 scripts/download.py --verify-only
python3 scripts/extract.py
python3 scripts/index_statements.py
python3 scripts/build_reports.py
python3 scripts/validate.py
```

Extraction and heading detection are automated. They do not generate or update the curated mathematical judgments in `reviews/reviews.json`; those require review of the cited source pages. Re-running extraction records current file hashes; compare them with the committed manifest before reviewing changed source files. Formula extraction can lose glyphs/spaces: inspect the PDF for exact notation. Several high-risk statements were also checked visually during the review.

Reviewed October 21, 2026. PDFs remain copyright their respective authors; review text does not imply endorsement by any source institution or dissertation author.
'''
readme=readme.replace('3,xxx',f"{sum(s['pages'] for s in SOURCES):,}")
(ROOT/'README.md').write_text(readme)
# Preserve the existing collection index, adding a link into the analysis.
p=ROOT/'index.html';s=p.read_text()
if 'analysis.html' not in s:s=s.replace('<h1>', '<p><a href="analysis.html">Open mathematical reviews for all 20 dissertations</a></p><h1>',1)
p.write_text(s)
print('Rendered 20 Markdown reviews, 20 HTML reviews, dashboard, and README.')
