"""Render the SEM seed report from curated source and suitability records."""
import json,pathlib
R=pathlib.Path(__file__).resolve().parents[1];D=R/'literature/unl-sem'
load=lambda n:json.loads((D/n).read_text())
seed=load('dissertations.json');authors=load('authors.json');works=load('works.json');questions=load('questions.json');screen=load('screening.json')
def esc(s):return str(s).replace('|','\\|').replace('\n',' ')
text='''# Structural equation modeling: UNL dissertation seed and downstream work

Checked October 26, 2026. [Tracking issue](https://github.com/alectionary/vibe-math/issues/5) · [Dissertation CSV](dissertations.csv) · [Author search outcomes](authors.json) · [Formalization suitability](FORMALIZATION.md) · [Shared question index](../OPEN-PROBLEMS.md).

This pass adds **58 doctoral-dissertation metadata records** and searches subsequent publications for every seed author. It verifies **26 selected article/letter records linked to 18 authors**, screens **14 readable article full texts**, and adds **8 source-stated statistical method directions** to the shared inventory. Two pairs of repeated QTL directions are merged. These eight need a precise model and success guarantee before becoming theorem targets; the eligible-target count remains **150**, and no new proof is claimed.

The dissertation registry is a discovery seed, not 58 completed full-text reviews. All dissertation question counts remain **unassessed (null)**. Public archive landing pages were readable through indexed web results, but native access to all 18 original public-copy routes returned HTTP403, as did two actual download links tested through the web tool. The remaining 40 original records link to the ProQuest catalog. A further public-copy record for Evertson was discovered during this pass, bringing located public-copy records to **19**; a public record does not establish successful PDF retrieval. [UNL explains its access arrangements here](https://digitalcommons.unl.edu/dissertations/).

## Scope and counts

| Measure | Result |
| --- | ---: |
| Dissertations dated 2001 onward identified in the original survey | 58 |
| Original seed overlaps with the existing 20-dissertation review catalog | 0 |
| Seed authors with recorded downstream searches | 58 |
| Authors linked to selected verified publication records | 18 |
| Selected article/letter records | 26 |
| Post-dissertation publication records | 25 |
| Same-year publication with ordering unverified | 1 |
| Readable article full texts screened | 14 |
| Selected articles with incomplete full-text access | 12 |
| Dissertation full texts screened | 0 |
| Added statistical method directions | 8 |
| Added precise conjectures / completed proofs | 0 / 0 |

The original survey searched dates from 2001 onward; its located dissertations span 2003–2025. Missing years are not asserted to have zero qualifying dissertations. The original seed has 10 methods-oriented and 48 applied dissertations. This pass records 130 additional discovery/copy/verification queries, including one author/topic query for each seed. Author/coauthor links rely on primary article metadata, topical continuity and affiliations/coauthors; matching names alone is insufficient. Bibliographic leads outside the 26 selected verified works remain in the discovery log, without author attribution or question counts.

This is a bounded first-hop search, not a census of every coauthor's career or a recursive citation crawl. [Queries/results](searches.json), [all discovery result dispositions](discovery-results.json), [retrieval evidence](extra-retrieval-attempts.json), and [service access](service-access.json) preserve its actual coverage. Earlier work recovered during searches is not relabeled post-dissertation progress.

## Mathematical suitability

The included directions concern QTL model discrimination, missing observations, mixed outcomes, residual covariance, nonlinear models, experimental design effects, and dynamic fit-index calibration. Their statements can ultimately involve distributions, estimators, matrices and algorithmic guarantees. They are not claims that any proposed method universally improves power.

The screen excludes intervention effects, attitudes, leadership/satisfaction associations, instrument replication in new populations, clinical effects, stakeholder theories, and ecological observations when answering them requires new data. An SEM equation in a paper does not turn every research question in that paper into a mathematical conjecture. The [suitability worksheet](FORMALIZATION.md) gives the missing assumptions for each retained direction and separates three project-derived formalization starting points from author-posed research questions.

## Downstream results that change interpretation

Peugh and Feldon's 2020 fit-assessment article called for wider testing of equivalence testing. Their own 2024 letter reports unfavorable subsequent simulations and withdraws the recommendation. The 2020 study request is therefore historical context; the separate 2024 dynamic-fit questions are indexed. This is a published methodological correction, not a universal mathematical disproof.

Mi and coauthors' 2011 gene–environment SEM paper is related later development of an agenda discussed in the 2010 QTL papers. Its inspected abstract does not establish complete equivalence to the earlier QTL-mapping/model-design directions. Kmail–Eskridge's 2022 D-optimal design paper and Jeffries–Bovaird's 2026 latent-contrast paper are verified follow-on records; their full-text question screens remain access-limited.

## Newly recorded method directions

'''
for q in questions:
 sources=', '.join(f'[{o["source_id"]}]({o["url"]}) — {o["locator"]}' for o in q['occurrences'])
 text+=f'### {q["id"]}\n\n{q["title"]}\n\nSource: {sources}.\n\nStatement gate: {q["formalization_suitability"]["objects_and_gate"]}\n\n'
text+='## Every selected downstream work and its screen outcome\n\n| ID / year | Work | Seed authors | Full-text question outcome |\n| --- | --- | --- | --- |\n'
by={s['id']:s for s in seed}
for w in works:
 count='Unassessed: full-text access gap' if w['question_count'] is None else f'{w["question_count"]} recorded directions' if w['question_count'] else 'No additional suitable explicit mathematical target recorded'
 text+=f'| {w["id"]} / {w["year"]} | [{esc(w["title"])}]({w["url"]}) | {esc("; ".join(by[i]["author"] for i in w["seed_ids"]))} | {count} |\n'
text+='\n## Excluded or historical passages\n\n'
for x in screen['excluded_passages']:text+=f'- **{x["paper_id"]}, {x["locator"]}:** {x["reason"]}\n'
text+='\n## Dissertation seed\n\nAll rows below are archive metadata/abstract records; full-text question harvesting remains access-limited. The separate original 20 full dissertation reviews and their frozen audit denominator are preserved.\n\n| Seed | Year | Author / dissertation | Located public-copy record |\n| --- | --- | --- | --- |\n'
for s in seed:text+=f'| {s["id"]} | {s["year"]} | {esc(s["author"])} — [{esc(s["title"])}]({s["url"]}) | {"Yes" if s["public_copy_record"] or s.get("located_public_copy_url") else "Not located in this search"} |\n'
text+='''
## Inventory integration and reproducibility

The shared inventory grows **363→371 entries**, while precise eligible targets stay **150** and complete Lean targets stay **6**. The shared article/letter bibliography grows **135→161 records** and full-text screens **122→136**. The 58 dissertation metadata seeds are counted separately from article screens and from the earlier 20 complete dissertation reviews.

`works.json` supplies seed links, exact acquisition outcomes, source hashes and version/date notes. `screening.json` records exclusions and requirement evidence. Current-resolution checks and Lean proof discovery for the eight directions remain unassessed; no theorem or historical-priority claim is made. Sources are linked and copyrighted full texts remain in ignored local storage. HTML extraction line numbers belong to the saved copy; PDF viewer pages include publisher cover sheets.

Rebuild reports with `python3 scripts/build_unl_sem_report.py`, `python3 scripts/build_open_problem_report.py`, and `python3 scripts/build_current_difficulty_report.py`. Validate with `python3 scripts/validate_unl_sem_seed.py`, `python3 scripts/validate_open_problems.py`, `python3 scripts/validate_current_difficulty.py`, and `python3 scripts/validate_literature.py`. The new validation checks seed coverage, source/target links, null-versus-zero distinctions, hashes when local copies exist, and the exact cohort delta.

No new social theory was added to the mathematical inventory. No author-stated empirical question was relabeled a conjecture. The three proposed implementation starting points in `FORMALIZATION.md` remain outside the canonical question count.
'''
(D/'README.md').write_text(text)
print('Rendered SEM seed, downstream works and suitability report.')
