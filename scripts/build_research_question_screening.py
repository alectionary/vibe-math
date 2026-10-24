"""Render a version-specific source-question screen without inferring current resolution."""
from pathlib import Path
import json
R=Path(__file__).resolve().parents[1];D=R/'literature'
a=json.loads((D/'research-question-screening.json').read_text());by={r['id']:r for r in json.loads((D/'open-problems.json').read_text())};sources={s['id']:s for s in json.loads((D/'research-source-index.json').read_text())['sources']}
def esc(x):return str(x).replace('|','\\|').replace('\n',' ')
def link(i):return f'[{i}](OPEN-PROBLEMS.md#{i.lower()})'
s=f'''# Open-question screen of the absorbing-set research sources

Checked {a['checked_on']}. [Structured audit](research-question-screening.json) · [Canonical inventory](OPEN-PROBLEMS.md) · [Research bibliography](RESEARCH-SOURCES.md).

The earlier research read many papers for a specific counting/elimination comparison, but only Beezer received systematic question extraction. This pass accounts for every academic source in those research ledgers, the additional named leads, and two direct primary papers used to check historical resolutions. It does not recursively expand every bibliography.

## Outcome

| Measure | Count |
|---|---:|
| Verified paper works accounted for | {a['paper_works_reviewed']} |
| Full-text works screened for questions | {a['full_text_paper_works_screened']} |
| Paper works with full-text access gaps | {a['paper_works_with_access_gaps']} |
| Additional unavailable later journal versions | {a['additional_later_version_gaps']} |
| Unverified bibliographic leads, outside paper totals | {a['unverified_leads']} |
| Non-paper/software records excluded from paper totals | {a['non_paper_records_excluded']} |
| Full-text papers with question occurrences linked | {a['all_question_contributing_papers']} |
| Papers contributing newly inventoried entries | {a['new_question_contributing_papers']} |
| Fully screened papers without an additional explicit target | {a['full_text_papers_without_additional_questions']} |
| Additional canonical entries | {a['added_entries']} |
| Additional specific eligible mathematical targets | {a['added_eligible_targets']} |
| Additional directions, held formulations or method requests | {a['added_entries']-a['added_eligible_targets']} |
| New paper records in the shared bibliography | {a['new_paper_records']} |
| New full-text screens in the shared coverage ledger | {a['full_text_screens_added']} |
| New completed proofs claimed | {a['completed_targets_added']} |

At this dated screen the inventory grew from **190 to 252 entries**, **112 to 135 eligible targets**, **61 to 100 paper records** and **58 to 90 full-text screens**. The four previously completed Lean targets are unchanged. New entries have unassessed present resolution, Lean discovery and planning difficulty; a source calling a question open is recorded as a dated source claim.

## How the screen was performed

We searched complete readable texts for numbered conjectures/questions, unknown existence cases and future-work language, and read introductions, conclusions and candidate passages in context. We checked whether motivating questions were answered within the same paper, confirmed in an addendum, refuted by a cited predecessor, or repeated in another source. The screen extracts explicit questions; it is not a correctness audit or a guarantee of every implicit research opportunity.

PDF/HTML snapshots and extracted text remain local under ignored `local-extraction/literature/research-question-screening/`. The structured audit and source manifest retain exact versions, hashes, page/line locations and acquisition outcomes. Copyrighted full texts are not committed. Beezer2002 was an image-only 17-page scan: OCR supplied the text and its numbered-question page was visually checked. Empty HTTP-success pages were rejected as full text.

## Every paper and its outcome

| Paper | Inspected version | Outcome | Linked canonical targets |
|---|---|---|---|
'''
for p in a['papers']:
 s+=f"| [{p['paper_id']} — {esc(p['title'])}]({p['url']}) | {esc(p['inspected_version'])} | {esc(p['outcome'].replace('_',' '))} | {', '.join(link(i) for i in p['recorded_target_ids']) if p['target_count'] is not None else 'Not assessed: access gap'} |\n"
s+='\n## Newly indexed questions, conjectures and directions\n\n'
for p in a['papers']:
 if not p['new_target_ids']:continue
 src=sources[p['source_index_id']]
 s+=f"### {p['paper_id']} — {p['title']}\n\n{'; '.join(src['authors'])}. {p['inspected_version']}. [Source]({p['url']}).\n\n"
 for i in p['new_target_ids']:
  r=by[i];o=next(o for o in r['occurrences'] if o['source_id']==p['paper_id']);label='Specific mathematical target' if r['eligible_for_coverage'] else 'Held conjecture: formulation pending' if r['kind']=='conjecture' else 'Method request' if r['kind']=='method_request' else 'Broad research direction'
  s+=f"- **{link(i)} — {label}.** {r['title']} Source: {o['locator']}; extracted lines{o['extracted_text_lines'][0]}–{o['extracted_text_lines'][1]}."
  if r.get('screening_note'):s+=' '+r['screening_note']
  s+='\n'
 s+='\n'
s+='## Repeated occurrences and related formulations\n\n'
for m in a['merged_occurrences']:s+=f"- **{m['source_index_id']} → {link(m['target_id'])}:** {m['reason']}\n"
for m in a.get('related_passages',[]):s+=f"- **{m['source_index_id']} → {link(m['related_target_id'])}:** {m['note']}\n"
s+='\nHeinlein–Östergård’s complete-STS strictness conjecture is linked to Beezer’s general-design generator-basis conjecture as a restricted related statement, without asserting equivalence. Broad agendas are kept outside the theorem denominator. The two latent meanings of girth are also kept separate: Beezer generator girth is not Erdős density girth.\n\n## Passages excluded as already answered, refuted or not additional questions\n\n'
for x in a['excluded_or_resolved_passages']:s+=f"- **{x['source_index_id']}, {x['locator']}:** {x['reason']}\n"
s+='\n## Access and verification gaps\n\n'
for p in a['papers']:
 if p['status']!='full_text_screened':
  failures='; '.join(x.get('error','metadata/partial text only') for x in p['acquisition_attempts'])
  s+=f"- **{p['paper_id']} — [{p['title']}]({p['url']}):** {failures}. Full-text question count remains null. Earlier failed primary/author routes are retained in the frozen research ledgers.\n"
for p in a['later_version_gaps']:s+=f"- **[{p['source_index_id']}]({p['url']}):** {p['note']}\n"
for p in a['unverified_paper_leads']:s+=f"- **[{p['title']}]({p['url']}):** {p['note']}\n"
s+='\nThese gaps require a readable public, licensed or author-provided full text before a complete question screen can be claimed. They are not zero-question papers. The two software/report records are explicitly listed in the structured audit and excluded from academic-paper totals.\n\n## Workflow and checks\n\nThe research skill now requires this paper-by-paper harvest automatically during investigations, including papers read only for prior art. Every encountered paper/version must have an inventory outcome or an explicit gap before closeout. `validate_research_question_screening.py` checks cohort coverage, source hashes and locators, question links, null-versus-zero handling, duplicate merges and the exact inventory delta. Existing inventory, planning and prior proof-artifact validators retain their historical checks.\n'
(D/'RESEARCH-QUESTION-SCREENING.md').write_text(s)
print('Rendered paper-by-paper audit:',a['paper_works_reviewed'],'works;',a['added_entries'],'new entries.')
