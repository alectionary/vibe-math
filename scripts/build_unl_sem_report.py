"""Render the SEM/CFA seed report, retaining the first-pass cohort separately."""
import csv,json,pathlib
R=pathlib.Path(__file__).resolve().parents[1];D=R/'literature/unl-sem'
load=lambda n:json.loads((D/n).read_text())
seed=load('dissertations.json');authors=load('authors.json');works=load('works.json');questions=load('questions.json');screen=load('screening.json');exp=load('cfa-expansion.json')
def esc(s):return str(s).replace('|','\\|').replace('\n',' ')
adj=sum(s.get('scope_class')=='adjacent_latent_measurement' for s in seed);core=len(seed)-adj
public=sum(bool(s['public_copy_record'] or s.get('located_public_copy_url')) for s in seed)
full=sum(w['screen_status']=='full_text_screened' for w in works)
author_count=sum(bool(a['selected_work_ids']) for a in authors)
seed_full=sum(s['full_text_screen_status']=='full_text_screened' for s in seed)
retrieval=load('retrieval-audit.json')
text=f'''# SEM, CFA and related measurement-model dissertation seed

Checked October 26, 2026. [PR #6](https://github.com/alectionary/vibe-math/pull/6) · [Tracking issue #5](https://github.com/alectionary/vibe-math/issues/5) · [Dissertation CSV](dissertations.csv) · [CFA expansion](CFA-EXPANSION.md) · [Retrieval correction](RETRIEVAL-REPAIR.md) · [Formalization suitability](FORMALIZATION.md) · [Shared questions](../OPEN-PROBLEMS.md).

The expanded seed contains **{core} SEM/CFA, growth/path or latent-measurement dissertations**, plus **{adj} explicitly adjacent IRT/latent-class/exploratory-factor or scale-structure dissertations** ({len(seed)} records total). These are doctoral-dissertation records from 2001 onward; {seed_full} now have complete-text question screens. All {len(authors)} authors have recorded downstream searches. The bibliography contains **{len(works)} selected source works**, with **{full} readable full texts screened** and **{len(questions)} source-stated statistical methods directions** indexed.

The CFA expansion adds 41 dissertations: 31 core records and 10 adjacent records. It corrects the initial literal-SEM search's omission of Daniel H. Abbott's 2010 dissertation. Public and ProQuest catalog copies are merged, not counted twice. [The original 58-record pass](FIRST-PASS.md) is a historical snapshot, not the current total.

## Current counts

| Measure | Count |
| --- | ---: |
| Core SEM/CFA/growth/path/measurement dissertation records | {core} |
| Adjacent IRT/latent-class/exploratory-factor dissertation records | {adj} |
| Total deduplicated dissertation metadata records | {len(seed)} |
| Authors with recorded downstream searches | {len(authors)} |
| Authors linked to verified selected author/coauthor records | {author_count} |
| Selected source works, including earlier background and independent citation followups | {len(works)} |
| Full source texts screened | {full} |
| Selected source works with full-text gaps | {len(works)-full} |
| Located public-copy dissertation records | {public} |
| Completed dissertation full-text screens | {seed_full} |
| Front-matter-only previews, excluded from full screens | 1 |
| Dissertation complete texts not yet recovered | {len(seed)-seed_full} |
| Statistical methods directions indexed | {len(questions)} |
| Added precise theorem targets / completed proofs | 0 / 0 |

**Corrected retrieval scope:** all {len(seed)} archive records and Download controls were revisited. {seed_full} complete dissertations were recovered and screened; one nine-page front-matter preview is excluded. The {len(seed)-seed_full} records lacking a recovered complete text retain null question counts. Direct archive download attempts encountered browser challenges, which do not establish paywalls. Of 94 inspected ProQuest records, two offer open-access downloads and 92 offer a preview plus institutional-access/purchase options; this describes those publisher routes, not availability elsewhere. The {len(works)-full} associated source-work text gaps also retain null counts. [Per-record evidence and recovered dissertation questions](RETRIEVAL-REPAIR.md).

## Search and inclusion criteria

The first pass searched explicit structural-equation terminology. The continuation adds confirmatory factor analysis, measurement models/invariance, latent growth, factor structure, bifactor/factor-mixture models, path analysis and related latent-variable terms. IRT and latent-class models are a separately labeled adjacent cohort. Generic regression, exploratory-factor-only leads without qualifying model evidence, keyword-only matches, master's theses, posters, articles and pre-2001 dissertations do not enter the core dissertation count. One proposed-but-unexecuted CFA with exploratory scale analysis is retained as an adjacent record; it is not counted as completed core CFA.

[Queries and result dispositions](searches.json), [CFA candidate decisions](cfa-discovery-decisions.json), [author outcomes](authors.json), and [source acquisitions](works.json) record the search. Name-only matches do not establish identity. Citation-only followups are distinguished from author/coauthor publications; the Griffin/Marincic name transition and the Hawley/Shaw identity lead are not asserted without a verified primary bridge. Earlier background is not relabeled post-dissertation work. This bounded search is not a publication census or recursive bibliography crawl.

## Mathematical suitability

The retained directions concern QTL methods, model-fit calibration, sampling accuracy and latent interpretation effects. Each has a separate statement gate describing mathematical objects, estimands and guarantees that must be fixed. Source-stated simulation requests are not promoted into universal bounds. Empirical questions about attitudes, leadership, instrument validity in a new population, clinical outcomes, or ecological observations stay outside mathematical target counts. See [the suitability worksheet](FORMALIZATION.md).

Peugh and Feldon's 2024 letter withdraws their 2020 fit-assessment recommendation after subsequent simulations. That historical request is not indexed as a fresh conjecture. The later dynamic-fit questions remain distinct. Mi et al.'s 2011 gene–environment SEM is recorded as related progress on the 2010 agenda, without claiming a full model-equivalence comparison from its abstract.

## Indexed statistical methods directions

'''
for q in questions:
 src='; '.join(f'[{o["source_id"]}]({o["url"]}), {o["locator"]}' for o in q['occurrences'])
 text+=f'### {q["id"]}\n\n{q["title"]}\n\nSource: {src}.\n\nStatement gate: {q["formalization_suitability"]["objects_and_gate"]}\n\n'
text+='## Selected source works and their outcomes\n\n| ID/year | Work | Relationship | Full-text outcome |\n| --- | --- | --- | --- |\n'
for w in works:
 count='Unassessed: full-text gap' if w['question_count'] is None else f'{w["question_count"]} method directions' if w['question_count'] else 'No suitable additional explicit mathematical target recorded'
 text+=f'| {w["id"]}/{w["year"]} | [{esc(w["title"])}]({w["url"]}) | {esc(w.get("relationship",w.get("temporal_relation","author/coauthor work")))} | {count} |\n'
text+='\n## Excluded or historical passages\n\n'
for x in screen['excluded_passages']:text+=f'- **{x["paper_id"]}, {x["locator"]}:** {x["reason"]}\n'
text+=f'\n## Dissertation registry\n\n{seed_full} rows now have complete-text question screens, identified in the final column. The original 20 fully reviewed dissertations remain a separate historical cohort.\n\n| Seed/year | Author and dissertation | Model family | Public-copy record | Full-text disposition |\n| --- | --- | --- | --- | --- |\n'
for s in seed:text+=f'| {s["id"]}/{s["year"]} | {esc(s["author"])} — [{esc(s["title"])}]({s["url"]}) | {esc(s.get("family","explicit SEM"))} | {"Located" if s["public_copy_record"] or s.get("located_public_copy_url") else "Not located"} | {"Complete text screened" if s["full_text_screen_status"]=="full_text_screened" else "Front matter only; unscreened" if s["full_text_screen_status"]=="not_screened_partial_preview" else "Retrieval incomplete; unassessed"} |\n'
text+=f'''
## Inventory integration and verification

Across both seed passes the shared inventory grows 363→373 entries, while precise eligible targets stay 150 and complete Lean targets stay 6. Source-work records grow 135→176 and full-text source screens 122→146. {seed_full} recovered dissertation question screens are separate from article/work screen counts and from the original 20 complete dissertation reviews.

Sources have versions, exact locators and hashes. F134's hash identifies a complete author-uploaded web transcription, not original PDF bytes. Copyrighted bodies remain in ignored storage. Current resolution, Lean discovery and implementation difficulty for the added directions remain unassessed; no mathematical result or priority claim is made.

Rebuild with `python3 scripts/build_unl_sem_report.py`, `python3 scripts/build_open_problem_report.py`, and `python3 scripts/build_current_difficulty_report.py`. Validate with `validate_unl_sem_seed.py`, `validate_open_problems.py`, `validate_current_difficulty.py`, `validate_literature.py`, `validate.py`, and `git diff --check`. The original first-pass audit is preserved in `FIRST-PASS.md`; current cohort requirements are in `screening.json` and `cfa-expansion.json`.
'''
(D/'README.md').write_text(text)
newids=set(exp['added_seed_ids']);newworks=set(exp['new_work_ids']);newqs=set(exp['new_target_ids'])
detail=f'''# CFA and measurement-model expansion

Continuation of [issue #5](https://github.com/alectionary/vibe-math/issues/5) and [PR #6](https://github.com/alectionary/vibe-math/pull/6), October 26, 2026.

**41 missed/related dissertations added: 31 core SEM/CFA/growth/path/measurement records and 10 adjacent IRT/latent-class/exploratory-factor records.** All 41 added authors received targeted downstream searches. {exp['new_discovery_queries']} additional discovery/identity/copy queries include {exp['vocabulary_queries']} vocabulary queries. The pass adds 13 source works, 7 complete full-text screens and 2 gated statistical methods directions. It also links new seed author Abdullah Ferdous to the existing F118 coauthored paper without duplicating it.

Abbott's 2010 dissertation is included as UNL-SEM-D067, merging cehsdiss/68 and AAI3402936. Its use of CFA makes it a valid core candidate even though the abstract did not use the literal phrase structural equation modeling. Its body was not recovered during that expansion pass; it was subsequently recovered and screened in the [retrieval correction](RETRIEVAL-REPAIR.md). Two independent later papers explicitly citing it were retrieved and screened. Those are not Abbott-authored publications.

## New source-supported mathematical directions

F132 asks for work on the generalizability and selection sensitivity of reduced-item Angoff passing-score estimates. A mathematical formulation needs the item/judge matrix, sampling/stratification scheme and accuracy criterion. The observed 50% subset result is not a universal guarantee. The inspected 2003 conference source precedes Ferdous's 2005 dissertation; its later 2005 journal version is recorded separately as a version lead.

F134 proposes evaluating latent-model detection of interpretation variability in vague response categories. The formalizable core concerns ordinal/factor-mixture models and detection/identification conditions, with empirical demographic and population questions excluded. It explicitly cites Marincic (2011); a surname alias is not assumed. The full author-uploaded transcription, including references, was retrieved in 12 overlapping views with continuous coverage of web lines 56–1799, and the saved text has its own hash.

Both entries are method directions, not precise theorem claims. They leave the eligible-target denominator unchanged.

## Added dissertations

| ID | Year | Dissertation | Family |
| --- | --- | --- | --- |
'''
for s in seed:
 if s['id'] in newids:detail+=f'| {s["id"]} | {s["year"]} | {esc(s["author"])} — [{esc(s["title"])}]({s["url"]}) | {esc(s["family"])} |\n'
detail+='\n## Source works recovered through the added authors\n\n| ID | Work | Relationship | Screen |\n| --- | --- | --- | --- |\n'
for w in works:
 if w['id'] in newworks:detail+=f'| {w["id"]} | [{esc(w["title"])}]({w["url"]}) | {esc(w["relationship"])} | {w["screen_status"]} |\n'
detail+='''
## Scope checks, exclusions and remaining access

The candidate ledger records rejected document types, pre-2001 dates, duplicate aliases, exploratory-only leads, proposed-but-unexecuted CFA and unrelated physical-science/regression keyword hits. These are not hidden zero-question papers. The 10 adjacent records remain labeled separately from the 89 core records.

At the expansion snapshot, no dissertation body had been recovered: all 41 added primary routes returned403; Abbott's CORE routes, Frohn's indexed PDF copy and Bentz's CiteSeer copy also failed. Public-copy records and readable PDF access remain distinct. At that snapshot six added source works had full-text gaps; F139 was subsequently recovered and screened. Current dissertation and article dispositions supersede these historical route failures in [the retrieval correction](RETRIEVAL-REPAIR.md). Native publisher metadata pages were not counted as full texts solely because they contained references or many characters.

The new full-text screens excluded empirical scale validation, race/ethnicity DIF in observed student samples, developmental/sociocultural questions, clinical causal ordering and fertility-attitude associations. No such question is relabeled a mathematical conjecture.

The repository's source records, shared inventory, planning gates and generated reports are updated together. The dated first-pass baseline is preserved. PR review and merge remain with the user.
'''
(D/'CFA-EXPANSION.md').write_text(detail)
print('Rendered current SEM/CFA registry and CFA expansion report.')

# Keep the CSV's current dispositions aligned with the JSON registry.
fields=['id','year','author','title','category','scope_class','family','public_copy_record','located_public_copy_url','url','alternate_urls','full_text_screen_status','question_count','retrieval_status','notes']
with (D/'dissertations.csv').open('w',newline='') as f:
 writer=csv.DictWriter(f,fieldnames=fields,extrasaction='ignore',lineterminator='\n');writer.writeheader();writer.writerows(seed)
