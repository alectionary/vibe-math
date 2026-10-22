"""Render coverage counts from the curated ledger; does not make mathematical judgments."""
import pathlib,json,collections,html
R=pathlib.Path(__file__).resolve().parent.parent;A=R/'audit'
claims=json.loads((A/'claims.json').read_text());sources=json.loads((A/'sources.json').read_text());candidates=json.loads((A/'candidates.json').read_text())
manifest={s['id']:s for s in json.loads((R/'source-manifest.json').read_text())}
selected=[c for c in claims if c['in_denominator']];held=[c for c in claims if not c['in_denominator']]
units=collections.Counter(c['unit'] for c in selected)
queries=json.loads((A/'github-code-search.json').read_text())['searches']
search_ok=sum(s.get('retry',s)['exit_code']==0 for s in queries)
summary=dict(date='2026-10-21',dissertations=len(manifest),ledger_units=len(claims),selected_units=len(selected),held_for_clarification=len(held),units=dict(units),exact_statements_identified=0,exact_proofs_verified=0,partial_target_proofs_verified=0,background_declarations_checked=sum(c['locally_checked'] for c in candidates),github_queries_succeeded=search_ok,github_queries_failed=len(queries)-search_ok,interpretation='Identified coverage within a selected audit set; global absence and total-proof coverage remain unknown.')
(A/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
text='''# Lean coverage audit — dissertation collection

Audited October 21, 2026. **No exact Lean statement or verified proof was identified for the selected dissertation targets in the sources searched.** This is a bounded negative search finding, not proof that no formalization exists. Global coverage remains unknown.

The audit covers 20 dissertations and 178 ledger units: 138 selected proved results/derivation groups and 40 selected open-problem targets. Four are held for statement clarification. The denominator is an explicit, purposive selection of principal results and specific unresolved targets, not every proof in 3,013 pages. It is not a representative statistical sample, and claims receive equal weight regardless of proof length or difficulty.

## Counts and fractions

| Eligible audit units | Count | Exact Lean statements identified | Exact proofs verified | Verified partial proofs of the same target |
| --- | ---: | ---: | ---: | ---: |
'''
for name,unit in [('Named proved results','named_result'),('Located derivation groups','derivation_group'),('Open-problem targets as described in the dissertations','open_problem')]:
 n=units[unit];text+=f'| {name} | {n} | 0/{n} (0%) | 0/{n} (0%) | 0/{n} (0%) |\n'
text+='''
Thus **identified exact-proof coverage is 0/135 (0%) for the selected proved results/derivation groups**, and **identified exact-statement coverage is 0/39 (0%) for the selected open targets**. The 135 combines 132 named results and three derivation groups; use the separate rows when granularity matters. A theorem's several conclusions are one unit; the three derivation groups each contain several formulas. This is a count of result units, not distinct proof terms or individual proof steps.

All 174 eligible units retain an unresolved external-coverage status: no exact match was found in the bounded search. **“174 not found” does not mean “174 proved unformalized.”** The ledger does not measure what fraction of the complete dissertations has been formalized. No nonzero lower bound or less-than-100% global upper bound follows from these searches. No new dissertation theorem proofs were written during this audit.

Five relevant background declarations were successfully checked locally. These are useful evidence that foundations exist, but are excluded from the dissertation-target numerator and denominator. They were selected as positive controls, not an inventory of all available background mathematics. The earlier Boolean OR/XOR exercise is also outside this dissertation corpus.

## What counts as coverage

- **Exact statement:** a Lean proposition with corresponding objects, quantifiers, hypotheses and conclusion; definitions or keyword hits alone do not qualify. A declaration ending in `sorry` can establish statement availability, but cannot establish proof coverage.
- **Exact verified proof:** an exact statement with a proof accepted by Lean and an inspected axiom report excluding `sorryAx` and unproved domain-specific axioms. Standard `propext`, `Classical.choice` and `Quot.sound` are allowed.
- **Verified partial target proof:** a justified restricted case or subclaim of that same target, with the extra assumptions and missing bridge stated explicitly. Mere related infrastructure receives no percentage credit.
- **Background/foundations:** relevant independently formalized mathematics; tracked separately. Source-only candidates remain candidates until locally checked and semantically matched.
- **No match found:** an epistemic search result, not a declaration that the mathematics is unformalized or false.

## Per-dissertation audit set

A zero open-target count means this audit did not admit a sufficiently fixed target from that dissertation; it does not assert that the work contains no open mathematics. Counts below exclude held units. Every row's exact statement/proof count is zero in the searched sources.

| Dissertation | Named results | Derivation groups | Open targets | Held |
| --- | ---: | ---: | ---: | ---: |
'''
for key in manifest:
 cc=[c for c in claims if c['dissertation_id']==key];ct=collections.Counter(c['unit'] for c in cc if c['in_denominator'])
 text+=f"| [{key}](../reviews/{key}.md) | {ct['named_result']} | {ct['derivation_group']} | {ct['open_problem']} | {sum(not c['in_denominator'] for c in cc)} |\n"
text+='''
## Verified background and inspected candidates

For all five checked mathlib declarations, Lean reported only `propext`, `Classical.choice`, and `Quot.sound`. The check file imports existing theorems; it does not encode or prove the dissertation targets. Compiler version: Lean 4.36.0-rc1. See [Checks.lean](Checks.lean) and [the actual output](lean-checks.log).

'''
for c in candidates:
 if 'url' not in c:continue
 text+=f"- **{c['id']} — {c['relationship']}**: [`{c['declaration']}`]({c['url']}). {c['comparison']} {'Locally checked.' if c['locally_checked'] else 'Source inspected; not locally built.'}\n"
text+='''
Additional rejected discovery matches are recorded with their public commit links in [the GitHub query log](github-code-search.json). “Boolean rank” referred to equipment selection bits and tensor rank guards; Koszul “support” referred to coefficient quotient equations, not the cohomological support variety in Watson. CountMin benchmark files count occurrences of a list minimum and contain `sorry`; they are not frequency-sketch proofs. A Bernstein–Sato identity is explicitly assumed in the Jordan-invariants candidate, while its checked theorems concern arithmetic of invariants. ThinkingTrees documents preservation of an encoded Markov-path change count; this does not prove statistical estimation, IRFL convergence, or the AR(1) BIC derivation. Broad mixture/regression hits were not treated as model-specific matches.

## Statement issues held out

'''
for c in held:text+=f"- **{c['id']}, {c['label']}**, PDF {', '.join(map(str,c['pdf_pages']))}: {c['comparison']}\n"
text+='''
The probability-event discrepancy in Chanda Theorems 3–4 was checked against rendered PDF pages 68–69, rather than relying only on extracted glyphs.

These are alignment issues, not findings that the dissertations are incorrect. In particular, a strong-solution uniqueness theorem must not be silently promoted to weak-solution uniqueness, and a transcription issue in a probability inequality must not be repaired without checking the source proof.

## Open-question triage and exclusions

All 42 numbered Question/Conjecture/Problem kind-number pairs from the existing navigation index have a disposition in [numbered-question-triage.json](numbered-question-triage.json). This includes linked targets, merged restatements, motivating programs, answered questions, and problem definitions. The 42 are index candidates, not 42 unresolved conjectures. The open ledger also admits selected unnumbered author-stated questions, so its denominator is not obtained by simply subtracting exclusions from 42.

- Murray's Question 1 is answered under the stated hypotheses by the dissertation's Bass-number results.
- Geraci Problem 2.2 defines Boolean matrix factorization. Question 2.17 motivates the subsequent regularity results.
- Zamir Problem 3.26 defines interpolation. Problem 3.21 and Chapter 9 tasks asking for generators, resolutions, or formulation of an SHGH analogue are constructive research programs without a fixed proposition in this audit. The precise bounded-defect and weighted-Horace questions are retained.
- Vander Woude's early motivating questions are substantially answered later; Problems 10.3.1 and 10.3.7 define estimation problems. Later specific conjectures are counted separately.
- Volk Questions 1 and 5 are merged as two formulations of the same minimization issue. Lieberman Questions 3.27 and 4.5 are merged as the same general inequality issue. Introductory restatements of proved results are not counted twice.
- General future-work directions in Watson, Mu, Morris, Chanda, Hasanthika and Martinez, and review-proposed IRFL proof obligations in Grantham, are preserved in the existing reviews and [the open-review crosswalk](open-review-crosswalk.json), but do not automatically become fixed conjecture targets.

“Open” means unresolved in the source's stated setting at the dissertation date. This audit does not establish current mathematical open status. An answered special case does not resolve a general question. Conversely, a formal theorem with a hypothesis equivalent to the desired conclusion earns no proof coverage.

## Search scope and reproducibility

Pinned primary-source trees:

'''
for s in sources:text+=f"- [{s['id']}]({s['url'].removesuffix('.git')}/tree/{s['revision']}), revision `{s['revision']}`; {s['scope']}; `{s['lean_toolchain']}`. {s['verification']}.\n"
text+=f'''
The audit ran 100 domain-specific local filename searches (20 dissertation families across five source directories) and inspected candidate declarations and definitions. [local-source-searches.json](local-source-searches.json) records every regex, searched directory, exit code and matching filename. TauCeti was a sparse checkout; directories outside its recorded scope were not searched. Equivalent statements expressed with different terminology, unpublished/private sources, other proof assistants, and files absent from search indexes may be missed.

GitHub indexed-code discovery completed {search_ok}/{len(queries)} queries after retries; {len(queries)-search_ok} remain rate-limited/uncompleted. Results are capped at 30 per query and can include substring and cross-token false positives. A failed request is not zero hits. The log preserves original failures and retry results. Supplementary web discovery located candidate repositories but is not counted as a theorem check. The project README and theorem name alone were never accepted as proof evidence.

The target roster is curated in [claims.json](claims.json). It stores a stable ID, source PDF hash, viewer pages, Source record, statement summary, disposition, search-family comparison, and whether it enters the denominator. Summaries are navigation aids; the complete hypotheses remain in the cited source statements. The search-family comparison is shared by related claims where no target-specific candidate was found. The external candidate source hashes are recorded in [candidates.json](candidates.json), without redistributing their source or the dissertations.

To reproduce the positive Lean checks, use the mathlib revision in [sources.json](sources.json), install its toolchain, obtain the selected imports' cache, then run from that checkout:

```sh
lake env lean /absolute/path/to/this/repository/audit/Checks.lean
```

To rerun local discovery against the pinned clones, arrange the four checkout directories under one source root and run:

```sh
python3 scripts/search_coverage.py /absolute/path/to/source-root
python3 scripts/build_coverage_report.py
python3 scripts/validate_coverage.py
```

## Work remaining

This completes a bounded discovery and claim-alignment audit, not an exhaustive formalization census or a proof-correctness review of the dissertations. A full corpus percentage still needs an exhaustive, deduplicated theorem/derivation inventory and deeper target-specific searches. The 1,170-item navigation index cannot supply that denominator: it includes definitions and mentions. Its 789 theorem/lemma/proposition/corollary pairs also include cited background and restatements.

The most concrete next formalization pilots are the finite Boolean-matrix/biclique correspondence, a dyadic-matrix identity over F2, or a precisely scoped finite graph construction. These would first require definitions and representation bridges; they are proposed work, not completed coverage. For open targets, first fix an exact Lean statement with all hypotheses; writing it is a separate achievement from proving it.

## Complete selected ledger

The same records can be searched in [coverage.html](coverage.html).

| ID | Source statement | Unit | Pages | Disposition |
| --- | --- | --- | --- | --- |
'''
for c in claims:text+=f"| {c['id']} | [{c['label']}]({c['full_statement_reference']}) — {c['statement_summary']} | {c['unit']} | {', '.join(map(str,c['pdf_pages']))} | {c['classification']} |\n"
(A/'README.md').write_text(text)
# Lightweight self-contained searchable reading view, preserving links to detailed evidence.
rows=''
for c in claims:
 h=html.escape
 rows+=f"<tr data-kind='{c['unit']}'><td>{h(c['id'])}</td><td><a href='{h(c['full_statement_reference'],quote=True)}'>{h(c['label'])}</a><p>{h(c['statement_summary'])}</p></td><td>{h(c['unit'])}</td><td>{', '.join(map(str,c['pdf_pages']))}</td><td>{h(c['classification'])}<p>{h(c['comparison'])}</p></td></tr>"
page='''<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width"><title>vibe-math | Lean coverage audit</title><style>body{font:16px/1.5 system-ui;max-width:1500px;margin:35px auto;padding:0 24px;color:#18283b}h1{font-size:30px}a{color:#0759a5}table{border-collapse:collapse;width:100%}th,td{text-align:left;vertical-align:top;padding:12px;border-bottom:1px solid #cbd5df}th{background:#eef3f8}td:first-child{white-space:nowrap;font-size:13px}td p{margin:.4em 0;font-size:14px}input,select{font:inherit;padding:9px;margin:10px 12px 20px 0}input{width:45%}.notice{background:#fff3d8;padding:18px;border-left:5px solid #ba7400}.stats{font-size:20px;font-weight:600}caption{text-align:left;margin-bottom:12px}</style><h1>Lean coverage audit</h1><p>20 dissertations · October 21, 2026 · <a href="README.md">Full method, sources, qualifications and counts</a> · <a href="claims.json">Claim ledger JSON</a> · <a href="../analysis.html">Earlier reviews</a></p><p class="stats">Exact proofs identified: 0/132 named results · 0/3 derivation groups<br>Exact statements identified: 0/39 open targets · 4 units held for clarification</p><p class="notice">These are identified-coverage counts for a selected audit set. No exact match found does not establish absence. Global dissertation coverage remains unknown. Five background declarations passed local Lean checks and are counted separately.</p><label>Search <input id="q" placeholder="Author, theorem, topic or comparison"></label><label>Unit <select id="unit"><option value="">All</option><option>named_result</option><option>derivation_group</option><option>open_problem</option></select></label><p id="count" aria-live="polite"></p><table><caption>Selected claims, including held units. Page links require the locally downloaded PDFs.</caption><thead><tr><th>ID</th><th>Statement</th><th>Unit</th><th>PDF pages</th><th>Finding and comparison</th></tr></thead><tbody>'''+rows+'''</tbody></table><script>const q=document.querySelector('#q'),u=document.querySelector('#unit'),rows=[...document.querySelectorAll('tbody tr')];function filter(){let n=0;for(const r of rows){const show=r.textContent.toLowerCase().includes(q.value.toLowerCase())&&(!u.value||r.dataset.kind===u.value);r.hidden=!show;if(show)n++}document.querySelector('#count').textContent=n+' of '+rows.length+' ledger units shown'}q.addEventListener('input',filter);u.addEventListener('change',filter);filter();</script></html>'''
(A/'coverage.html').write_text(page)
print(json.dumps(summary,indent=2))
