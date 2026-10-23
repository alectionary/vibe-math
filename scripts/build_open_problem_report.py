"""Render the curated dissertation/article problem inventory; never infer Lean proof status."""
import collections,html,json,pathlib
R=pathlib.Path(__file__).resolve().parent.parent;D=R/'literature'
load=lambda n:json.loads((D/n).read_text())
rows=load('open-problems.json');coverage=load('downstream-paper-coverage.json');exclusions=load('downstream-exclusions.json');mechanization=load('downstream-mechanization.json')
reconciliation=load('research-reconciliation.json')
research_sources=load('research-source-index.json')['sources']
new=[r for r in rows if r['origin']=='article_inventory_extension'];eligible=[r for r in rows if r['eligible_for_coverage']]
screened=lambda p:p['coverage_status'].endswith('full_text_screened')
new_eligible=sum(r['eligible_for_coverage'] for r in new);new_excluded=len(new)-new_eligible
full_count=sum(screened(p) for p in coverage);historical_count=sum(p['coverage_status']=='historical_withdrawn_full_text_screened' for p in coverage)
article_ids={p['paper_id'] for p in coverage};article_targets=[r for r in rows if any(o['source_id'] in article_ids for o in r['occurrences'])]
statement_count=sum(r['lean_statement_status']=='verified_lean_statement' for r in eligible)
proof_count=sum(r['lean_proof_status']=='verified_complete_lean_proof' for r in eligible)
supporting_count=sum(r['lean_proof_status']=='verified_supporting_lean_proof' for r in eligible)
partial_count=sum(r['lean_proof_status']=='verified_finite_cases_only' for r in eligible)
identified_count=sum(r['lean_statement_status']=='identified_lean_statement_not_build_verified' for r in eligible)
unassessed_count=sum(r['lean_statement_status']=='not_assessed_in_this_extension' for r in eligible)
summary=dict(checked_on='2026-10-23',canonical_inventory_entries=len(rows),legacy_entries=len(rows)-len(new),additional_entries=len(new),additional_eligible_targets=sum(r['eligible_for_coverage'] for r in new),additional_non_denominator_entries=sum(not r['eligible_for_coverage'] for r in new),eligible_targets=len(eligible),eligible_verified_proof_assistant_statements=statement_count,eligible_verified_lean_statements=statement_count,eligible_verified_lean_proofs=proof_count,eligible_targets_with_supporting_lean_proofs=supporting_count,eligible_identified_unverified_lean_statements=identified_count,eligible_lean_discovery_unassessed=unassessed_count,eligible_targets_with_verified_finite_cases=partial_count,article_records=len(coverage),full_text_screened=full_count,current_publication_full_text_screened=full_count-historical_count,historical_withdrawn_full_text_screened=historical_count,not_fully_assessed=len(coverage)-full_count,article_records_with_recorded_targets=sum(bool(p['recorded_target_ids']) for p in coverage),canonical_targets_with_article_occurrences=len(article_targets),legacy_targets_with_article_occurrences=sum(r['origin']=='dissertation_inventory' for r in article_targets),new_entry_kinds=dict(collections.Counter(r['kind'] for r in new)),new_written_math_statuses=dict(collections.Counter(r['written_math_status'] for r in new)),related_author_reported_lean_constructions=len(mechanization))
# Counts are asserted against evidence rather than inferred from prose.
assert all((R/r['verified_artifact']['readme']).exists() for r in eligible if r.get('verified_artifact'))
(D/'open-problem-summary.json').write_text(json.dumps(summary,indent=2)+'\n')
s=f'''# Expanded open-problem inventory

Checked October 23, 2026. [Searchable inventory](open-problems.html) · [Machine-readable entries](open-problems.json) · [Paper coverage](downstream-paper-coverage.json) · [Prior literature follow-up](README.md) · [Lean difficulty estimates](../planning/LEAN-DIFFICULTY.md).

The inventory now contains **{len(rows)} canonical entries**: the original 40 dissertation targets and **{len(new)} additional article entries**. Of the additions, **{new_eligible} are specific mathematical questions or tasks suitable for coverage tracking**; the other {new_excluded} are research directions, formulation or method requests, and held statements with counterexamples. These categories are kept visible rather than combined into a theorem count.

The [research reconciliation](RESEARCH-RECONCILIATION.md) connects later trajectory work and [21 indexed research sources](RESEARCH-SOURCES.md). It adds six source-posed questions/directions from two already identified papers; their current-resolution and Lean searches are unassessed. Five project-derived follow-ups remain attached to P34 rather than being counted as additional author-posed problems. The earlier fixed cohort retains 3/108 complete proofs; the expanded cohort has 3/{len(eligible)}. This is denominator growth, not a loss of verified work.

## Counts and formalization evidence

| Measure | Count |
| --- | ---: |
| Original dissertation targets, including one held target | 40 |
| Additional article targets in the coverage denominator | {new_eligible} |
| Additional directions/formulation/method entries outside the denominator | {new_excluded} |
| Combined eligible targets | {len(eligible)} = 39 + {new_eligible} |
| Eligible targets with an identified, verified proof-assistant statement | {statement_count}/{len(eligible)} ({100*statement_count/len(eligible):.2f}%) |
| Eligible targets with an identified, verified Lean statement | {statement_count}/{len(eligible)} ({100*statement_count/len(eligible):.2f}%) |
| Eligible targets with a complete checked Lean proof | {proof_count}/{len(eligible)} ({100*proof_count/len(eligible):.2f}%) |
| Additional targets with checked supporting proofs and a written source bridge | {supporting_count}/{len(eligible)} |
| Eligible targets with checked finite cases, without a complete proof | {partial_count}/{len(eligible)} |
| Additional identified Lean statements without a build audit | {identified_count}/{len(eligible)} |
| Eligible targets with Lean discovery still unassessed in this extension | {unassessed_count}/{len(eligible)} |
| Articles/preprints in scope | {len(coverage)} |
| Full-text sources screened, including withdrawn history | {full_count}/{len(coverage)} |
| Current-publication full texts screened | {full_count-historical_count} |
| Withdrawn historical manuscripts screened | {historical_count} |
| Not fully assessed | {len(coverage)-full_count}/{len(coverage)} |

**Current artifact coverage includes the [dyadic rank theorem](../formalization/dyadic-rank/README.md), the [general P34 girth-eight characterization](../formalization/cyclic-lifts/README.md), and the [literal P11 forbidden-set completeness proof](../formalization/dyadic-forbidden/APPENDIX-ENUMERATION.md), each with a matching statement, successful build and axiom audit.** Search results without an artifact do not establish global absence. In particular, this is principally a Lean discovery audit; Coq, Isabelle, and other proof assistants were not systematically searched. The original search pass found no exact target artifacts; the later dyadic formalization is recorded separately with build and axiom evidence. L-P11-rank-converse, L-P34-girth-eight and L-P11-forbidden now have complete Lean proofs of their recorded statements, within the explicit artifact scopes. Current mathematical resolution is not independently certified for every other entry: “open” describes how the cited source presents the target.

The historical Leray–Hopf uniqueness entry is held: later primary literature reports nonuniqueness, and the source’s domain/forcing/solution class must be fixed before a current comparison. Its entry links the later report. A related public Lean repository concerns forced smooth breakdown, not weak uniqueness; it was not built here.

A precise mathematical statement in a paper is conventional mathematical formulation, not proof-assistant formalization. A Lean statement can exist without a proof, for example with `sorry` or an axiom. A checked proof requires matching objects, quantifiers, hypotheses, a successful build, and scrutiny of its axioms; an unrelated theorem with the same terminology does not qualify.

**Related Lean report:** F01’s authors report using Lean 4 to verify an explicit multi-scale secluded-partition construction. That is an established construction in the article, **not one of its four remaining open targets**. No matching public artifact was identified, built or axiom-audited here. The report therefore contributes zero verified open-target statements/proofs. [Primary disclosure](https://arxiv.org/html/2609.02880v1) · [Structured mechanization evidence](downstream-mechanization.json).

## What is counted

The unit is a mathematical question, task, or explicitly labeled direction, not every sentence containing “open.” Completed targets remain in the denominator so coverage continues to track the original source-posed problems. Parameterized families count once. Question 6.3 in P04 counts once despite containing two bounds; the two independent parts of P27 Question 2.4 count separately. The union-complete case of P02 Question 7.1 is additional; its intersection-complete case is linked to the dissertation target. Method requests in P15 remain separate from conjectures about unknown truth.

Repeated targets share one canonical ID with multiple source occurrences. Related but different systems, hypotheses, or invariants retain different IDs and explicit related-target links. In particular, P01 changes the invariants in the held Geraci question; calmed rotational NSE is distinct from calmed velocity–vorticity; and two-dimensional Ohmic-heating MHD–Boussinesq is distinct from three-dimensional MHD. Local existence and global well-posedness are distinct obligations and are related in the ledger. No logical independence of the counted problems is claimed.

This article set includes predecessor versions and overlapping publications as well as genuinely later papers. “Additional” means newly inventoried, not newly posed after the dissertation. Dates and author relationships remain in [the bibliography](papers.json). The October 22 expansion adds 21 screened papers and 57 canonical entries, of which 27 enter the denominator; repeated occurrences are merged. The earlier cohort remains 114 entries and 74 targets. See [expanded search findings and limits](SCHOLARLY-EXPANSION.md). A subsequent [Edge Scholar/X pass](BROWSER-SEARCH.md) adds six screened papers, ten canonical entries and seven eligible targets; its seven eligible additions subsequently received bounded Lean discovery in the [coverage assessment](LEAN-COVERAGE.md).

## Source coverage and gaps

A full-text screen searched headings, explicit conjectures/questions, future-work passages and conclusion sections, then read their surrounding context. It is not a line-by-line correctness review or a guarantee that every implicit question was extracted. Full-text counts of zero mean “no additional explicit target recorded in this screen”; unavailable text has a null count, never zero. Two talk records from the earlier follow-up are outside the article denominator.

**Three of the four earlier access gaps are closed.** P28 and F02 were recovered as public full-text transcriptions on ResearchGate; no standalone PDF was obtained for either, and their local hashes identify our transcription snapshots. P20’s historical v3 PDF was recovered and screened. Its current v4 remains withdrawn, so the historical directions are held outside the active coverage denominator. **P10 remains inaccessible** and needs a licensed or author-provided copy. [Gap-closure findings](COVERAGE-GAPS.md) · [Retrieval evidence](coverage-gap-retrievals.json) · [Primary withdrawal notice](https://arxiv.org/abs/2209.00110).

| Record | Full-text screen | Canonical entries occurring in the paper | Note |
| --- | --- | ---: | --- |
'''
for p in coverage:
 s+=f"| [{p['paper_id']}]({p['url']}) | {p['coverage_status'].replace('_',' ')} | {p['target_count'] if p['target_count'] is not None else 'Not assessed'} | {p['note']} |\n"
s+='''
## Reproducible evidence and limits

Primary HTML/PDF retrievals and public full-text transcriptions, content hashes and ignored local extraction paths are recorded in [the source manifest](downstream-source-manifest.json). Each occurrence supplies a numbered question/section or PDF page, plus local extracted-text line ranges where available. These line ranges belong to our extraction, not arXiv HTML line numbers. P28/F02 transcription line n corresponds to line L(n-1) of the public web source. The manifest states the hash scope and retains earlier retrieval records. Full source files remain local and are not redistributed in this repository.

The added search ran 44 lexical queries across four previously pinned Lean source trees, respecting the sparse checkout scope recorded in [audit sources](../audit/sources.json), plus eight GitHub indexed-code queries (limit 30 hits each). The dyadic/rank query reached the limit, so its results are explicitly incomplete. Candidate files were inspected for mathematical subject mismatches; no exact new target was established. A file retrieval failure is recorded, not interpreted as absence. Weighted Horace background, dyadic local algebra, topological absorbing sets, and primitive-set saturation games do not match the targets here. [Local searches](downstream-lean-searches.json) · [GitHub searches](downstream-github-searches.json) · [Candidate retrievals](downstream-lean-candidates.json) · [Comparison notes](downstream-search-review.json).

The original 39 targets retain the earlier audit’s search evidence. Earlier article rows use family-level discovery and source-context comparisons, not an exhaustive search over all public declarations or alternate terminology. The recovered texts received eight supplementary pinned-source queries, recorded in [gap-specific Lean discovery](coverage-gap-lean-searches.json); no matching artifact was identified. P20 questions are historical, and a related graph-radius conjecture is not a matching algorithmic result. A public matching Lean artifact would change verified counts only after a semantic and build/axiom audit. The October 22 search identifies a matching `proof_wanted` existence statement for Conway’s 99-graph, recorded as identified but not build-verified. It supplies no proof. The [latest Lean assessment](LEAN-COVERAGE.md) reviews all twelve previously unassessed eligible targets and nine excluded directions; no additional exact target artifact was identified. Related background is recorded separately, and query caps and API failures remain explicit. [Search and candidate review](SCHOLARLY-EXPANSION.md).

## October 22 expansion

[The expanded search](SCHOLARLY-EXPANSION.md) records the earlier web-tool Google Scholar access failures, OpenAlex lookups, author/coauthor discovery, repeated questions and later restricted answers. Two source statements are held after finite Python counterchecks. Those checks are not Lean proofs and do not settle Conway’s strongly regular graph existence problem.

## Exclusions

'''
for x in exclusions:s+=f"- **{x['paper_id']} — {x['locator']}:** {x['reason']}\n"
s+='\n## Canonical inventory\n\nEach entry below distinguishes the written formulation, denominator eligibility, proof-assistant statement search, Lean statement search, and Lean proof search. The original bounded search found no exact artifact; the later verified dyadic pilot is included in the current statuses. The withdrawn historical entries remain historical; later mathematical resolution is not certified.\n\n'
for r in rows:
 s+=f"### {r['id']}\n\n{r['title']}\n\n- Type: {r['kind'].replace('_',' ')}; written formulation: {r['written_math_status'].replace('_',' ')}.\n- Coverage denominator: {'included' if r['eligible_for_coverage'] else 'excluded'}. {r['eligibility_note']}\n- Proof-assistant statement: {r['proof_assistant_statement_status'].replace('_',' ')}. Lean statement: {r['lean_statement_status'].replace('_',' ')}. Lean proof: {r['lean_proof_status'].replace('_',' ')}.\n- Source-described status: {r['status_as_of_source'].replace('_',' ')}; current resolution: {r['current_resolution_status'].replace('_',' ')}.\n"
 if r.get('empirical_followup'):
  a=r['empirical_followup'];s+=f"- Empirical follow-up: [{a['status'].replace('_',' ')}](../{a['writeup']}). {a['conclusion']}\n"
  if a.get('targeted_followup'):
   t=a['targeted_followup'];s+=f"- Bounded follow-up: [objective disagreements, exact ambiguity decomposition and supporting Lean lemmas](../{t['report']}); research direction remains open. {a['lean_proof_scope']}\n"
 if r.get('empirical_followup',{}).get('trajectory_followup'):
  t=r['empirical_followup']['trajectory_followup'];s+=f"- Decoder trajectories: [concrete all-iterations Lean obstruction and fixed-code census](../{t['report']}); partial structural explanation, no completed source target added.\n"
 if r.get('verified_artifact'):
  a=r['verified_artifact'];s+=f"- Verified artifact: [{a['statement_declaration']}](../{a['readme']}); {a['scope']}.\n"
  for key, label in [('structural_note','Checked general proof'),('search_note','Larger counterexample search')]:
   if key in a:s+=f"- [{label}](../{a[key]}).\n"
 if r.get('supporting_lean_artifact'):
  a=r['supporting_lean_artifact'];s+=f"- Supporting Lean artifact (not full target coverage): [checked scope](../{a['readme']}). {a['scope']}\n"
 if r.get('scope_comparison'):s+='- Scope comparison: '+r['scope_comparison']+'\n'
 if r.get('research_source_index'):s+='- Research sources: [central source index](RESEARCH-SOURCES.md).\n'
 for progress in r.get('research_progress',[]):
  s+=f"- Research progress: [{progress['title']}](../{progress['report']}) ({progress['evidence'].replace('_',' ')}). {progress['contribution']}\n"
  for path in progress['lean_sources']:s+=f"  - [Complete Lean source](../{path}).\n"
 for task in r.get('remaining_project_questions',[]):
  s+=f"- Project-derived follow-up, outside the source-target denominator: **{task['id']}** — {task['title']} {task['status']}\n"
 for o in r['occurrences']:
  extra='; PDF pages '+', '.join(map(str,o['pdf_pages'])) if 'pdf_pages' in o else '; extraction lines '+str(o['extracted_text_lines'][0])+'–'+str(o['extracted_text_lines'][1])
  s+=f"- [{o['source_id']}: {o['locator']}]({o['url']}){extra}; {o['relation'].replace('_',' ')}.\n"
 if r['related_target_ids']:s+='- Related, not merged: '+', '.join(r['related_target_ids'])+'.\n'
 if r.get('later_evidence'):
  for x in r['later_evidence']:s+=f"- Later evidence: [{x['locator']}]({x['url']}). {x['finding']}\n"
 if r.get('related_formalization_evidence'):
  for x in r['related_formalization_evidence']:s+=f"- Related formalization: [{x['url']}]({x['url']}). {x['finding']}\n"
 s+='\n'
(D/'OPEN-PROBLEMS.md').write_text(s.rstrip()+'\n')
e=html.escape
cards=[]
for r in rows:
 sources='; '.join(f'<a href="{e(o["url"],quote=True)}">{e(o["source_id"])}: {e(o["locator"])}</a>' for o in r['occurrences'])
 if r.get('empirical_followup'):
  a=r['empirical_followup'];sources+=f'<p><a href="../{e(a["writeup"],quote=True)}">Empirical follow-up; direction remains open</a></p>'
  if a.get('targeted_followup'):
   t=a['targeted_followup'];sources+=f'<p><a href="../{e(t["report"],quote=True)}">Bounded objective comparisons and supporting ambiguity lemmas</a></p>'
 if r.get('empirical_followup',{}).get('trajectory_followup'):
  t=r['empirical_followup']['trajectory_followup'];sources+=f'<p><a href="../{e(t["report"],quote=True)}">Lean-checked decoder obstruction and fixed-code trajectory census</a></p>'
 if r.get('verified_artifact'):
  a=r['verified_artifact'];sources+=f'<p><a href="../{e(a["readme"],quote=True)}">Verified Lean artifact</a></p>'
  for key, label in [('structural_note','Checked general proof'),('search_note','Larger counterexample search')]:
   if key in a:sources+=f'<p><a href="../{e(a[key],quote=True)}">{label}</a></p>'
 if r.get('supporting_lean_artifact'):
  a=r['supporting_lean_artifact'];sources+=f'<p><a href="../{e(a["readme"],quote=True)}">Checked supporting artifact; see source-comparison scope</a></p>'
 for progress in r.get('research_progress',[]):
  sources+=f'<p><a href="../{e(progress["report"],quote=True)}">{e(progress["title"])}</a>: {e(progress["contribution"])}</p>'
  for path in progress['lean_sources']:sources+=f'<a href="../{e(path,quote=True)}">{e(path.rsplit("/",1)[-1])}</a> '
 for task in r.get('remaining_project_questions',[]):
  sources+=f'<p><strong>Project follow-up {e(task["id"])}</strong>: {e(task["title"])} {e(task["status"])}</p>'
 if r.get('research_source_index'):sources+='<p><a href="RESEARCH-SOURCES.md">Linked research bibliography and access levels</a></p>'
 for evidence in r.get('related_formalization_evidence',[]):
  sources+=f'<p><a href="{e(evidence["url"],quote=True)}">Related Lean source (see audit status)</a></p>'
 text=' '.join([r['id'],r['title'],r['kind'],r['written_math_status']]+[o['source_id'] for o in r['occurrences']])
 text+=' '+' '.join(' '.join([p['title']]+p['authors']) for p in research_sources if r['id'] in p['related_target_ids'])
 text+=' '+' '.join(t['title'] for t in r.get('remaining_project_questions',[]))
 cards.append(f'<tr data-search="{e(text.lower(),quote=True)}" data-eligible="{str(r["eligible_for_coverage"]).lower()}" data-origin="{r["origin"]}"><td><strong>{e(r["id"])}</strong><p>{e(r["title"])}</p><small>{e(r["eligibility_note"])}</small><p>Current resolution: {e(r["current_resolution_status"].replace("_"," "))}</p></td><td>{e(r["written_math_status"].replace("_"," "))}<p>{e(r["kind"].replace("_"," "))}</p><strong>{"Included" if r["eligible_for_coverage"] else "Excluded"}</strong></td><td>{e(r["proof_assistant_statement_status"].replace("_"," "))}<small>Other assistants not systematically searched</small></td><td>{e(r["lean_statement_status"].replace("_"," "))}</td><td>{e(r["lean_proof_status"].replace("_"," "))}</td><td>{sources}</td></tr>')
page='''<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Expanded open-problem inventory</title><style>body{font:16px/1.55 system-ui,sans-serif;margin:2rem;color:#172b3a;background:#fafbfc}h1{max-width:950px;line-height:1.15}p{max-width:1100px}a{color:#075e9e}table{border-collapse:collapse;width:100%;background:white}td,th{border:1px solid #d7dfe5;padding:.8rem;text-align:left;vertical-align:top}th{background:#eaf1f5}td:first-child{min-width:300px}td:last-child{min-width:200px}td p{margin:.4rem 0}small{display:block;color:#52616d}input,select{font:inherit;padding:.5rem;margin:.3rem}.scroll{overflow:auto}.notice{border-left:4px solid #b5790f;padding:.8rem;background:#fff6e3;max-width:1100px}</style><h1>Open problems across the dissertations and related papers</h1>'''
page+=f'<p><strong>{len(rows)} entries · {len(eligible)} eligible targets · {len(new)} article additions · {full_count}/{len(coverage)} full-text screens</strong></p><p><a href="OPEN-PROBLEMS.md">Method, counts and complete notes</a> · <a href="open-problems.json">Structured inventory</a> · <a href="README.md">Literature follow-up</a> · <a href="../planning/difficulty.html">Lean difficulty estimates</a></p>'
page+=f'''<p class="notice">Verified matching statements: {statement_count}/{len(eligible)}; complete Lean proofs: {proof_count}/{len(eligible)}; targets with checked finite cases: {partial_count}/{len(eligible)}. Identified statements without a build audit: {identified_count}; eligible targets with discovery unassessed: {unassessed_count}. Counts include the checked dyadic theorem and bounded discovery searches. <a href="SCHOLARLY-EXPANSION.md">October 22 expansion and counterchecks</a>. Other formalizations may exist. “Open” is source-described; the dyadic target now has a complete Lean proof. F01 reports Lean verification of an established construction, not its remaining open problems.</p>'''+'''<label>Search <input id="query" type="search" placeholder="Author, source ID, topic or problem"></label><label>Coverage <select id="eligible"><option value="all">All entries</option><option value="true">Included targets</option><option value="false">Directions / held / method requests</option></select></label><label>Origin <select id="origin"><option value="all">All sources</option><option value="article_inventory_extension">Article additions</option><option value="dissertation_inventory">Original dissertation entries</option></select></label><p id="count" aria-live="polite"></p><div class="scroll"><table><thead><tr><th>Canonical target</th><th>Written formulation and coverage</th><th>Proof-assistant statement</th><th>Lean statement</th><th>Lean proof</th><th>Source occurrences</th></tr></thead><tbody>'''+''.join(cards)+'''</tbody></table></div><script>const q=document.querySelector('#query'),eligible=document.querySelector('#eligible'),origin=document.querySelector('#origin'),rows=[...document.querySelectorAll('tbody tr')];function filter(){let n=0;for(const r of rows){const ok=r.dataset.search.includes(q.value.toLowerCase())&&(eligible.value==='all'||r.dataset.eligible===eligible.value)&&(origin.value==='all'||r.dataset.origin===origin.value);r.hidden=!ok;if(ok)n++;}document.querySelector('#count').textContent=n+' of '+rows.length+' entries shown';}for(const c of[q,eligible,origin])c.addEventListener('input',filter);filter();</script></html>'''
(D/'open-problems.html').write_text(page)
print(json.dumps(summary,indent=2))
