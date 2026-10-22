"""Render the curated literature follow-up; does not infer problem resolution from citations."""
import json,pathlib,collections
R=pathlib.Path(__file__).resolve().parent.parent;D=R/'literature'
read=lambda name:json.loads((D/name).read_text())
papers=read('papers.json');followups=read('followups.json');authors=read('authors.json');links=read('problem-links.json')
byid={p['id']:p for p in papers+followups}
summary=dict(checked_on='2026-10-22',authors_searched=len(authors),authors_with_topic_matched_records=sum(bool(a['paper_ids']) for a in authors),article_preprint_records=len(papers),external_article_followups=sum(f['id'].startswith('F') for f in followups),talk_abstracts=len([f for f in followups if f['id'].startswith('T')]),open_targets_traced=len(links),eligible_targets_from_lean_audit=sum(l['eligible_in_previous_audit'] for l in links),full_resolutions_verified=sum(l['full_resolution_verified'] for l in links),findings=dict(collections.Counter(l['finding'] for l in links)))
(D/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
s='''# Academic literature on dissertation open problems

Checked October 22, 2026. The dissertation research has continued to circulate in articles, preprints and conference publications, and several specific questions also appear outside the dissertation text. The clearest later developments are a dyadic-code partial converse, independent work using secluded partitions, and fractional-diffusion extensions of algebraic calming. **No complete resolution of one of the 39 eligible open targets was verified in this bounded search.** This is a finding about the inspected literature, not a claim that all 39 remain open today.

**Expanded inventory:** [Expanded canonical entries and per-entry formalization annotations](OPEN-PROBLEMS.md) · [searchable table](open-problems.html). The earlier 40-target cross-reference snapshot below is preserved; the expanded inventory adds article questions and explicit coverage limits.

**October 22 expansion:** [Coauthor and citation search findings](SCHOLARLY-EXPANSION.md) adds 21 screened papers, 57 canonical entries and 27 eligible targets. Google Scholar access failed; OpenAlex, DBLP, author bibliographies and primary manuscripts supplied the expansion. Repeated conjectures, later restricted answers and source statements with counterexamples are recorded separately.

## Findings that matter for the project

**Dyadic codes have a concrete later extension.** Gómez-Fonseca, Matthews, Morris and Pllaha’s May 2026 preprint cites Martinez, Pllaha and Kelley’s code paper. Remark 3.4 explicitly identifies a new theorem as a partial converse of the earlier Theorem 4.6, then conjectures the full converse. Its walk/cycle section also develops the graph-lift direction identified in the Martinez review. This is substantive follow-up, although the matrix converse was not one of the 39 fixed open targets in the earlier audit. [Theorem 3.1, Remark 3.4 and Section 4.1](https://arxiv.org/html/2605.01942v1).

**Secluded partitions have independent applications beyond the original author group.** A September 2026 preprint by Ghentiyala, Kamath, Kumar and Manurangsi cites the 2022, 2023 and 2024 Vander Woude coauthored works and develops multi-scale partitions for differential privacy. Its authors report Lean 4 checking of a construction, but a public matching artifact and its assumptions were not verified here. This does not change the earlier audit’s verified-proof counts. [Section 1.2, Section 3 and AI Disclosure Statement](https://arxiv.org/html/2609.02880v1).

**The 2024 NeurIPS paper is later publication of overlapping rounding work.** It studies the degree/tolerance tradeoff and neighborhood-color bounds and leaves logarithmic gaps and further questions. The bounds overlap the 2023 thesis and earlier preprints, so publication after graduation does not make every result new post-thesis progress. [Proceedings record](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html).

**The fractional velocity–vorticity comparison is now checked against full text.** Theorems 3.2(a) and 3.3(a) in Le Tran Tinh’s article give weak existence for alpha >= 1, but weak uniqueness only for alpha >= 5/4, with smooth bounded calming and derivative bounds. Thus these theorems do not settle the alpha=1 dissertation weak-uniqueness target. This is a restricted result in a related model, not a same-problem resolution. [Public full text, Theorems 3.2–3.3](https://www.researchgate.net/publication/395935877_Velocity-vorticity_formulation_of_the_three_dimensional_generalized_Navier-Stokes_equations_Effect_of_algebraic_calming_on_well-posedness_convergence_determining_wavenumber_and_regularity_criteria).

**Geraci’s later revision changes the gap question.** The October 2026 paper’s Question 6.1 asks about regularity versus Ferrers cover number. The dissertation Question 5.1 instead names Ferrers versus biclique covering and includes a fixed-vertex qualification. The later version is relevant but cannot be recorded as an exact repetition. Separately, the March 2026 neural-code preprint explicitly contains the canonical-form question and redundancy conjecture, before the dissertation. [Later Question 6.1](https://arxiv.org/html/2509.09570v2), [earlier Question 7.1 and Conjecture 7.3](https://arxiv.org/html/2603.10837v1).

**Exact changepoint optimization now appears in another Grantham framework.** The September/October 2026 GRACE preprint claims global exactness of a dynamic-programming recursion. This is a different algorithm from IRFL. It does not supply the missing general convergence or global-optimality proof for IRFL iterates that our review identified as a proof obligation. [GRACE Sections 3 and 5.2](https://arxiv.org/html/2609.28831), [earlier IRFL manuscript](https://arxiv.org/html/2601.22481).

**The Bernstein question needs a scope correction.** Jeffries and Lieberman explicitly note that Bernstein’s inequality fails for general singularities. Their paper gives sufficient criteria and affirmative classes, including a Segre setting. The broad review question is a program to classify valid rings, not a universal conjecture asserting the inequality for every ring. This is existing context from a 2024 coauthored manuscript, not a newly discovered later disproof. [Introduction and Theorems 1.1–1.4](https://arxiv.org/html/2403.13146v1).

See the [successful Edge Scholar/X continuation](BROWSER-SEARCH.md) for six more primary-paper screens, new open questions, an author’s X announcement, and pending citation leads.

The subsequent [Lean coverage assessment](LEAN-COVERAGE.md) reviews the discovery backlog; one of 108 eligible targets retains a verified Lean proof (0.93%). Related source-level infrastructure is distinguished from exact target coverage.

The [current difficulty assessment](../planning/NEXT-PROJECT.md) covers all 181 inventory entries and now records completion of the selected P34 girth-eight target.

The selected P34 girth target now has a [complete checked characterization](../formalization/cyclic-lifts/README.md): a general simple eight-cycle plus complete rectangle/hexagon exclusion criteria, including the actual expanded binary matrix. Scope is cyclic permutation blocks, at least two rows and columns, and positive finite lift size. Current complete target proof coverage is 2/108; priority claims and other graph properties remain separate.

## Counts and their meaning

'''
s+=f"- All **{len(authors)} authors** received an author/topic search. **{summary['authors_with_topic_matched_records']}** have topic-matched article/preprint records in this bibliography.\n- **{len(papers)} article/preprint records** are included. These include overlapping manuscript and conference versions and a dissertation-derived upload; they are not independent new contributions or uniformly peer-reviewed articles.\n- **{summary['external_article_followups']} related coauthor/external article follow-ups** and **two talk/abstract records** are tracked separately. These papers have coauthor, topic or citation connections as specified individually; they do not all repeat a particular dissertation question.\n- **40 open-looking targets** are cross-referenced: the earlier audit’s **39 eligible targets**, plus Geraci’s held Question 5.1. None is marked fully resolved by this search.\n\n"
s+='''Eight selected questions have a directly corresponding earlier article statement or unresolved-property description: Geraci’s two neural-code targets, Zamir’s two targets, Wright’s existence question, DeClerk’s two questions, and Volk’s path-minimizer question. These are mainly pre-dissertation formulations, so this count establishes circulation beyond the thesis text, not eight later rediscoveries. Wright’s existence question is also explicitly revisited in a 2024 conference abstract. Broader regimes and related theorems receive separate labels in the ledger.

## How references are classified

A citation to an author or article is evidence of research uptake. An exact question repetition requires matching the mathematical objects and quantifiers. A partial result must add an actual theorem for a restricted case or subclaim. A resolution must settle the original target in its stated generality; a different model, a sufficient condition, or a result already present in the dissertation does not qualify. Publication date, first preprint date and revision date are kept distinct where they affect this interpretation.

The search used author names with dissertation topics, problem terminology, article titles, author bibliographies, arXiv texts, publisher pages, and forward-citation discovery. It was not an exhaustive citation census or a proof-correctness review. The OpenAlex results underreport some citations independently located in the primary texts; zero index results must not be interpreted as zero citations. The earlier Semantic Scholar citation requests returned HTTP 429 and supplied no usable citation data. The gap-closure pass obtained limited open-access metadata separately; it did not replace the citation census. The October 22 pass adds six bounded forward-citation queries and 36 OpenAlex lexical discovery queries; lexical author-name hits are not treated as verified authorship. See [expanded methodology](SCHOLARLY-EXPANSION.md), [citation discovery failures](citation-discovery.json), [OpenAlex discovery](openalex-citations.json), and [author search coverage](authors.json).

Four authors have no separately verified topic-matched article in this selected bibliography: Jordan Vincent Barrett, Alex John Heitzman, Allison Joan Ganger and Pahalapathirage Dona Kalani Hasanthika. That does not assert that they have no publications. Ganger’s work is acknowledged in a later seminar; Barrett has conference abstracts. Same-name Barrett graph-theory papers and unrelated Yuhao Mu physics/economics papers were excluded without an identity match.

## Author and coauthor papers

The record IDs below link the machine-readable bibliography to the question ledger. Each entry distinguishes inspected full-text sections from abstract or bibliography discovery. Later papers may cite the article version rather than the dissertation itself.

'''
for p in papers:
 s+=f"### {p['id']} {p['title']}\n\n{'; '.join(p['authors'])}. {p['year']}. [{p['inspection'].replace('_',' ')}]({p['url']}).\n\n{p['relationship']}\n\nLocation: {p['evidence_locator']}.\n\n"
 if p.get('withdrawal_note'):s+='**Withdrawn:** '+p['withdrawal_note']+'\n\n'
 if p.get('journal_metadata_note'):s+=p['journal_metadata_note']+'\n\n'
s+='## Related coauthor and external articles and later talks\n\n'
for f in followups:
 s+=f"### {f['id']} {f['title']}\n\n{'; '.join(f['authors'])}. {f['year']}. [{f['category'].replace('_',' ')}]({f['url']}).\n\n{f['evidence']} {f['limit']}\n\n"
s+='''## Question by question cross references

“Not verified” is a bounded search result. A related paper listed next to a question is not automatically evidence that the question itself was restated. The original page references and hypotheses remain in [the coverage ledger](../audit/claims.json). Research directions outside those 40 targets are described in the paper records, especially the Morris/Martinez and Grantham follow-ups.

| Target | Finding | Article or follow-up records | Interpretation |
| --- | --- | --- | --- |
'''
for x in links:
 refs=', '.join(f"[{p}]({byid[p]['url']})" for p in x['paper_ids']+x['followup_ids']) or 'None verified'
 s+=f"| {x['claim_id']} — {x['label']} | {x['finding'].replace('_',' ')} | {refs} | {x['interpretation']} |\n"
s+='''
## Search gaps worth resolving next

The full-text access gap for Le Tran Tinh’s article is closed: its weak-uniqueness theorem requires alpha >= 5/4 and does not cover alpha=1. The remaining article access gap is P10, the IEEE redundancy paper; it needs a licensed or author-provided copy. See [gap closure evidence](COVERAGE-GAPS.md). For the secluded-partition work, a public Lean repository with declaration names and an axiom report would allow a formalization audit of the claimed construction. The October 22 coauthor and citation expansion is documented in [the new search report](SCHOLARLY-EXPANSION.md); pending candidates and remaining limits are explicit there. The current Lean audit remains a historical snapshot and is not overwritten by author-reported mechanization in a different, related paper.
'''
(D/'README.md').write_text(s)
print(json.dumps(summary,indent=2))
