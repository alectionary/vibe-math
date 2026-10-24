"""Render the shared research-source index and its explicit inventory delta."""
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]
D = ROOT / 'literature'


def load(name):
    return json.loads((D / name).read_text())


def target_link(identifier):
    return f'[{identifier}](OPEN-PROBLEMS.md#{identifier.lower()})'


sources = load('research-source-index.json')['sources']
review = load('research-reconciliation.json')
rows = {r['id']: r for r in load('open-problems.json')}
text = '''# Research sources used in the coding investigations

Initial index checked October 23, 2026; subsequent follow-up records retain their own dates.
This central index joins the paper bibliography and
later trajectory literature to the [canonical questions](OPEN-PROBLEMS.md).
It preserves each source's actual access level and comparison limit. A source
can contribute an established method without posing a new inventory question.
Software sources retain their individual inspection/build status and are not counted as new academic papers or verified target artifacts.

[Structured index](research-source-index.json) · [Reconciliation and new questions](RESEARCH-RECONCILIATION.md)

'''
for s in sources:
    text += f"## {s['id']} — {s['title']}\n\n"
    text += f"{'; '.join(s['authors'])}. {s['date_or_version']}. [Primary source]({s['url']}).\n\n"
    text += f"- Record type: {s['record_kind'].replace('_', ' ')}; access: {s['access'].replace('_', ' ')}.\n"
    text += f"- Inspected locator: {s['locator']}.\n- Contribution: {s['relationship']}\n"
    text += f"- Comparison limit: {s['comparison_limit']}\n"
    text += '- Related canonical targets: ' + ', '.join(target_link(t) for t in s['related_target_ids']) + '.\n'
    text += f"- Provenance: [source review ledger](../{s['provenance_ledger']}).\n\n"
    if s.get('followup_provenance_ledger'):
        text += f"- Follow-up comparison: [dated source review](../{s['followup_provenance_ledger']}).\n\n"
(D / 'RESEARCH-SOURCES.md').write_text(text.rstrip() + '\n')

text = '''# October 23 research-to-inventory reconciliation

The main girth result and earlier distance work were already indexed, but the
canonical entries stopped before the later representation, persistence and entry
studies. Several inspected sources remained only in the paper's literature notes.
This update joins that knowledge to the shared inventory without treating
supporting Lean lemmas as additional solved open questions.

[Source bibliography](RESEARCH-SOURCES.md) · [Structured update record](research-reconciliation.json) · [Searchable inventory](open-problems.html)

## Historical October23 change

- The earlier reconciliation indexed 21 sources used in the investigation, preserving full-text, abstract-only,
  inaccessible-paper and software-lead distinctions. Some already had central records;
  this is not 21 newly discovered papers.
- Linked six later research milestones and their Lean sources under the existing
  P34 decoding/design targets. The full girth target remains completed; the broader
  decoding targets are marked partially addressed.
- Added two previously identified primary papers to the main bibliography and
  recorded six source-posed questions/directions from their inspected passages.
- Retained the three existing F16 spectral questions without duplicating them.
  The subsequent (4,2) block partially addresses one of these targets, as recorded below.
- Recorded five project-derived follow-ups separately from author-posed questions.

## Newly indexed source questions

| Canonical ID | Source question or direction | Coverage | Source locator |
|---|---|---|---|
'''
for identifier in review['added_target_ids']:
    r = rows[identifier]
    o = r['occurrences'][0]
    text += f"| {target_link(identifier)} | {r['title']} | {'Specific target' if r['eligible_for_coverage'] else 'Broad direction'} | [{o['source_id']}: {o['locator']}]({o['url']}) |\n"
text += '''
These are newly inventoried, not newly posed today. Their source-described open
status is historical; no new current-resolution or matching Lean search was
performed here. Relevant sections were screened, not every line of either paper.

The October23 inventory grew from **181 to 187 canonical entries** and from **108 to 111
eligible targets**. Complete checked targets remain **3**: the historical cohort
is still **3/108 (2.78%)**, while the expanded cohort is **3/111 (2.70%)**.
The two new sources make **60** article/preprint records; the **57** full-text
screens remain unchanged, with two additional relevant-section screens. New
planning records are explicitly unassessed rather than assigned invented estimates.

## Our remaining follow-ups, not extra source questions

'''
for task in review['project_derived_followups']:
    text += f"- **{task['id']}:** {task['title']} Status: {task['status']}\n"
text += '''
These remain attached to their recorded parent targets and outside the coverage denominator.
Their wording is ours; it is not attributed as an exact question from the source authors.
Negative recurrence/invariant-box searches and the limited net explanatory coverage
remain visible in the linked records.

## Keeping the knowledge connected next time

After a bounded investigation, reconcile the central bibliography, canonical
occurrences, resolution/Lean evidence, derived follow-ups and planning records.
Deduplicate by mathematical content, not title. Add source-authored questions only
after reading their passages, and keep research leads and our proposed next steps
distinct. Regenerate the reports and validate the explicit cohort delta.
Historical experiment manifests continue to refer to their original publication
revisions; this documentation update does not rewrite frozen scientific inputs.
'''
for block in review.get('research_blocks', []):
    text += f"\n## Subsequent block: {block['id']}\n\n"
    text += f"[{block['canonical_target_id']}](OPEN-PROBLEMS.md#{block['canonical_target_id'].lower()}): {block['component_answered']}. "
    text += f"Remaining at that dated checkpoint: {block['component_not_attempted']}. "
    text += f"[Report](../{block['report']}) · [Verification](../{block['verification']}) · [Prior art](../{block['prior_art']}).\n\n"
    text += f"Canonical entry delta **{block['canonical_entry_delta']}**, eligible-target delta **{block['eligible_target_delta']}**, completed canonical Lean-target delta **{block['complete_canonical_lean_target_delta']}**. Consult this dated artifact for its exact source and proof scope.\n"
for extension in review.get('indexing_extensions', []):
    text += f"\n## Separate indexing extension: {extension['id']}\n\n"
    text += "Beezer's final journal was fully read. The precise minimal-basis conjecture and two broad directions are inventoried separately from the (4,0) research follow-up.\n\n"
    for identifier in extension['added_target_ids']:
        text += f"- {target_link(identifier)}: {rows[identifier]['title']}\n"
    text += "\nCurrent cohort: **190 canonical entries,112 eligible targets,61 paper records,58 full-text screens**. Complete checked canonical Lean targets are now **4/112 (3.57%)** after finishing the existing F16 target; new Beezer questions remain unassessed. New planning records are unassessed. The original six-entry expansion and dated research blocks above are preserved.\n"
text += f"\nThe current source index has **{len(sources)}** records, with actual access levels retained.\n"
(D / 'RESEARCH-RECONCILIATION.md').write_text(text)
print(f'Rendered {len(sources)} linked sources and {len(review["added_target_ids"])} new source questions/directions.')
