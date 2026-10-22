# Expanded open-problem inventory

Checked October 22, 2026. [Searchable inventory](open-problems.html) · [Machine-readable entries](open-problems.json) · [Paper coverage](downstream-paper-coverage.json) · [Prior literature follow-up](README.md) · [Lean difficulty estimates](../planning/LEAN-DIFFICULTY.md).

The inventory now contains **181 canonical entries**: the original 40 dissertation targets and **141 additional article entries**. Of the additions, **69 are specific mathematical questions or tasks suitable for coverage tracking**; the other 72 are research directions, formulation or method requests, and held statements with counterexamples. These categories are kept visible rather than combined into a theorem count.

## Counts and formalization evidence

| Measure | Count |
| --- | ---: |
| Original dissertation targets, including one held target | 40 |
| Additional article targets in the coverage denominator | 69 |
| Additional directions/formulation/method entries outside the denominator | 72 |
| Combined eligible targets | 108 = 39 + 69 |
| Eligible targets with an identified, verified proof-assistant statement | 2/108 (1.85%) |
| Eligible targets with an identified, verified Lean statement | 2/108 (1.85%) |
| Eligible targets with a complete checked Lean proof | 2/108 (1.85%) |
| Eligible targets with checked finite cases, without a complete proof | 0/108 |
| Additional identified Lean statements without a build audit | 1/108 |
| Eligible targets with Lean discovery still unassessed in this extension | 0/108 |
| Articles/preprints in scope | 58 |
| Full-text sources screened, including withdrawn history | 57/58 |
| Current-publication full texts screened | 56 |
| Withdrawn historical manuscripts screened | 1 |
| Not fully assessed | 1/58 |

**Current artifact coverage includes the [dyadic rank theorem](../formalization/dyadic-rank/README.md) and the [general P34 girth-eight characterization](../formalization/cyclic-lifts/README.md), each with a matching statement, successful build and axiom audit.** Search results without an artifact do not establish global absence. In particular, this is principally a Lean discovery audit; Coq, Isabelle, and other proof assistants were not systematically searched. The original search pass found no exact target artifacts; the later dyadic formalization is recorded separately with build and axiom evidence. L-P11-rank-converse and L-P34-girth-eight now have complete Lean proofs of their recorded statements, within the explicit artifact scopes. Current mathematical resolution is not independently certified for every other entry: “open” describes how the cited source presents the target.

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
| [P01](https://arxiv.org/html/2509.09570v2) | full text screened | 1 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P02](https://arxiv.org/html/2603.10837v1) | full text screened | 11 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P03](https://arxiv.org/abs/2506.10757) | full text screened | 1 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P04](https://arxiv.org/abs/2605.29103) | full text screened | 3 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P05](https://arxiv.org/abs/2407.17656) | full text screened | 0 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P06](https://arxiv.org/abs/2511.06615) | full text screened | 0 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P07](https://arxiv.org/abs/2408.01318) | full text screened | 2 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P08](https://arxiv.org/abs/2507.21308) | full text screened | 3 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P09](https://www.aimsciences.org/article/doi/10.3934/amc.2026023) | full text screened | 5 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P10](https://doi.org/10.1109/ISTC65386.2025.11154620) | abstract or metadata only | Not assessed | Still inaccessible: IEEE landing content empty, normal PDF request failed; authors link only DOI; OpenAlex lists closed access with no repository copy; ResearchGate explicitly reports no full text. A licensed or author-provided copy is needed. |
| [P11](https://arxiv.org/html/2605.01942) | full text screened | 7 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P12](https://arxiv.org/html/2601.22481) | full text screened | 0 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P13](https://arxiv.org/html/2609.28831) | full text screened | 1 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P14](https://arxiv.org/html/2406.08602v2) | full text screened | 5 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P15](https://arxiv.org/html/2510.17029) | full text screened | 5 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P16](https://arxiv.org/html/2403.13146v1) | full text screened | 1 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P17](https://arxiv.org/abs/2312.17371) | full text screened | 3 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P18](https://arxiv.org/abs/2304.10493) | full text screened | 1 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P19](https://arxiv.org/abs/2410.04357) | full text screened | 5 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P20](https://arxiv.org/abs/2209.00110) | historical withdrawn full text screened | 4 | Historical v3 (17 PDF pages) recovered and screened; v1 (9 pages) retained for provenance. Current v4 is withdrawn. Historical questions are recorded but excluded from eligible-target coverage; no theorem is accepted as verified. |
| [P21](https://arxiv.org/abs/2501.01575) | full text screened | 0 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P22](https://arxiv.org/html/2210.07728v1) | full text screened | 1 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P23](https://arxiv.org/abs/2209.11912) | full text screened | 2 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P24](https://arxiv.org/abs/2211.02694) | full text screened | 4 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P25](https://arxiv.org/abs/2304.04837) | full text screened | 0 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P26](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html) | full text screened | 4 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P27](https://arxiv.org/html/2101.04213v4) | full text screened | 5 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P28](https://www.aimsciences.org/article/id/675c0e92d0b64a5d1d3497e9) | full text screened | 6 | Public 24-page manuscript transcription screened, especially Section 8. Publisher PDF requires access; ResearchGate public full text supplied the article body and references. Five additional broad directions recorded; quantum-distance direction linked to P11. No matching Lean artifact identified in bounded discovery. |
| [F01](https://arxiv.org/html/2609.02880v1) | full text screened | 4 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [F02](https://www.aimsciences.org/article/doi/10.3934/dcdsb.2025153) | full text screened | 2 | Public 52-page full-text transcription screened, including all main theorems and references. One background open formulation recorded. Theorems 3.2–3.3 give weak uniqueness only for alpha >= 5/4, not the original alpha=1 target. |
| [F03](https://arxiv.org/html/2404.02288v2) | full text screened | 3 | Full retrieved text screened for explicit questions/conjectures, concluding directions and their local context. Not a line-by-line correctness review or a guarantee of exhaustive extraction. |
| [P29](https://arxiv.org/html/2606.25493v1) | full text screened | 1 | Later distance-graph work by the dissertation author; cites P21 in reference [1]. |
| [P30](https://arxiv.org/html/2302.08431v1) | full text screened | 7 | Additional coauthored surface-topology paper listed on Wright’s scholarship page; not an answer to the Alexander-neighbor knot question. |
| [P31](https://arxiv.org/html/2304.02240v1) | full text screened | 3 | Missing author-paper backfill; later bandit and RL papers explicitly build on its list-replicability framework. |
| [P32](https://arxiv.org/html/2610.16266v1) | full text screened | 3 | Later coauthored preprint. Its relaxed triangle bound fails an exact finite check; its abstract’s nonexistence conclusion is not accepted here. |
| [P33](https://arxiv.org/html/2306.12593v1) | full text screened | 4 | Missing overlapping author-paper version; Question 4.1 repeats the dissertation’s neighborhood-color range target. |
| [F04](https://arxiv.org/html/2512.00553v1) | full text screened | 3 | Later work by coauthors Pavan and Vinodchandran; explicitly cites P31 and F05. PAC policies and policy traces differ from secluded-partition extremizers. |
| [F05](https://proceedings.iclr.cc/paper_files/paper/2025/file/0faa0019b0a8fcab8e6476bc43078e2e-Paper-Conference.pdf) | full text screened | 3 | Later coauthor work; cites P31 and extends list replicability to multi-armed and linear bandits. |
| [F06](https://arxiv.org/html/2605.05139v1) | full text screened | 2 | Later work by Enlow’s coauthors Larios and Pei. Voigt regularization differs from algebraic calming. |
| [F07](https://arxiv.org/html/2002.03542v2) | full text screened | 14 | Earlier paper by Geraci’s coauthor Kunin, recovered through the expanded search; its convex-polytope conjecture is explicitly restated by F08. |
| [F08](https://arxiv.org/html/2512.04241v1) | full text screened | 2 | Independent downstream paper citing F07. Conjecture 1.3 restates F07 Question 6.3; covering-relation progress does not settle the convex-polytope conjecture. |
| [F09](https://arxiv.org/html/2609.27002v1) | full text screened | 0 | Related nonlocal-operator work by Heitzman’s advisor and Enlow’s coauthor. This is a topic/advisor connection, not a verified citation to Heitzman’s dissertation. |
| [F10](https://arxiv.org/html/2410.23492v1) | full text screened | 2 | Work by coauthor Larios on a different regularization; published in 2025. It does not resolve weak uniqueness for calmed velocity–vorticity. |
| [F11](https://arxiv.org/html/2508.07492v1) | full text screened | 1 | Later coauthor work; conjectures removal of a smallness condition for its own assimilation system. |
| [F12](https://arxiv.org/html/2604.10423v1) | full text screened | 0 | Independent topic follow-up citing Dixon et al.; proves a non-adaptive composition theorem, a different target from neighborhood-color bounds. |
| [F13](https://arxiv.org/html/2602.16993v1) | full text screened | 5 | Independent neural-ideal paper citing the Kunin-related polar-complex literature. Its polarized-ideal invariants differ from Geraci’s Boolean-rank invariants. |
| [F14](https://drops.dagstuhl.de/storage/00lipics/lipics-vol325-itcs2025/LIPIcs.ITCS.2025.27/LIPIcs.ITCS.2025.27.pdf) | full text screened | 5 | Independent downstream use of deterministic rounding schemes, explicitly crediting Vander Woude et al.; later algorithmic progress is in F18. |
| [F15](https://arxiv.org/html/2601.08636v1) | full text screened | 0 | Independent downstream code constructions; references [15] and [16] cite Martinez’s 2022 and 2025 code papers. |
| [F16](https://arxiv.org/html/2607.13666v1) | full text screened | 3 | Independent downstream article explicitly cites Morris–Pllaha–Kelley, claims a restricted (3,3) absorbing-set enumeration, and acknowledges Morris. |
| [F17](https://arxiv.org/html/2609.24201v1) | full text screened | 0 | Independent downstream paper citing Martinez–Kelley [13] and P11 [16]; construction progress is not an exact rank/support-conjecture repetition. |
| [F18](https://arxiv.org/html/2510.16959v1) | full text screened | 1 | Later answer to F14’s request for an efficient construction, with a closely related parameter tradeoff; first preprint 2025, SOSA publication 2026. |
| [F19](https://arxiv.org/html/2610.03341v1) | full text screened | 3 | Later work by P11 coauthors Gómez-Fonseca and Pllaha; noncommuting polynomial lifts differ from dyadic signatures. |
| [P34](https://arxiv.org/html/2606.11987v1) | full text screened | 4 | Primary full text screened for explicit questions, conjectures, future work and surrounding scope. Not a proof-correctness audit. No explicit remaining target found is a bounded screen result, not a guarantee of absence. |
| [F20](https://arxiv.org/html/2605.24181v1) | full text screened | 0 | Primary full text screened for explicit questions, conjectures, future work and surrounding scope. Not a proof-correctness audit. No explicit remaining target found is a bounded screen result, not a guarantee of absence. |
| [F21](https://arxiv.org/html/2511.19043v1) | full text screened | 0 | Primary full text screened for explicit questions, conjectures, future work and surrounding scope. Not a proof-correctness audit. No explicit remaining target found is a bounded screen result, not a guarantee of absence. |
| [F22](https://arxiv.org/html/2610.20657v1) | full text screened | 1 | Primary full text screened for explicit questions, conjectures, future work and surrounding scope. Not a proof-correctness audit. No explicit remaining target found is a bounded screen result, not a guarantee of absence. |
| [F23](https://arxiv.org/html/2606.06148v1) | full text screened | 3 | Primary full text screened for explicit questions, conjectures, future work and surrounding scope. Not a proof-correctness audit. No explicit remaining target found is a bounded screen result, not a guarantee of absence. |
| [F24](https://arxiv.org/html/2606.18236v1) | full text screened | 3 | Primary full text screened for explicit questions, conjectures, future work and surrounding scope. Not a proof-correctness audit. No explicit remaining target found is a bounded screen result, not a guarantee of absence. |

## Reproducible evidence and limits

Primary HTML/PDF retrievals and public full-text transcriptions, content hashes and ignored local extraction paths are recorded in [the source manifest](downstream-source-manifest.json). Each occurrence supplies a numbered question/section or PDF page, plus local extracted-text line ranges where available. These line ranges belong to our extraction, not arXiv HTML line numbers. P28/F02 transcription line n corresponds to line L(n-1) of the public web source. The manifest states the hash scope and retains earlier retrieval records. Full source files remain local and are not redistributed in this repository.

The added search ran 44 lexical queries across four previously pinned Lean source trees, respecting the sparse checkout scope recorded in [audit sources](../audit/sources.json), plus eight GitHub indexed-code queries (limit 30 hits each). The dyadic/rank query reached the limit, so its results are explicitly incomplete. Candidate files were inspected for mathematical subject mismatches; no exact new target was established. A file retrieval failure is recorded, not interpreted as absence. Weighted Horace background, dyadic local algebra, topological absorbing sets, and primitive-set saturation games do not match the targets here. [Local searches](downstream-lean-searches.json) · [GitHub searches](downstream-github-searches.json) · [Candidate retrievals](downstream-lean-candidates.json) · [Comparison notes](downstream-search-review.json).

The original 39 targets retain the earlier audit’s search evidence. Earlier article rows use family-level discovery and source-context comparisons, not an exhaustive search over all public declarations or alternate terminology. The recovered texts received eight supplementary pinned-source queries, recorded in [gap-specific Lean discovery](coverage-gap-lean-searches.json); no matching artifact was identified. P20 questions are historical, and a related graph-radius conjecture is not a matching algorithmic result. A public matching Lean artifact would change verified counts only after a semantic and build/axiom audit. The October 22 search identifies a matching `proof_wanted` existence statement for Conway’s 99-graph, recorded as identified but not build-verified. It supplies no proof. The [latest Lean assessment](LEAN-COVERAGE.md) reviews all twelve previously unassessed eligible targets and nine excluded directions; no additional exact target artifact was identified. Related background is recorded separately, and query caps and API failures remain explicit. [Search and candidate review](SCHOLARLY-EXPANSION.md).

## October 22 expansion

[The expanded search](SCHOLARLY-EXPANSION.md) records the earlier web-tool Google Scholar access failures, OpenAlex lookups, author/coauthor discovery, repeated questions and later restricted answers. Two source statements are held after finite Python counterchecks. Those checks are not Lean proofs and do not settle Conway’s strongly regular graph existence problem.

## Exclusions

- **P01 — Problem 2.2 / Question 3.2:** Problem definition / motivating question answered by the paper, not an additional remaining open target.
- **P04 — Introduction, Question 1 / Theorem A:** Motivating cycle-support question answered in the paper; Section 6 questions are the remaining targets.
- **P05 — Question 1.1 / following main theorem:** Bass-number question is answered by the paper; not retained as open.
- **P12 — Methodological proof obligations:** Reviewer-identified obligations are not author-stated open problems.
- **P21 — Diameter conjecture:** Paper presents a proof for its stated connected-graph setting; do not count that settled case as open.
- **P24 — Historical conjectures in related-work discussion:** Minkowski/Keller/Furtwangler/Fuglede history includes settled or disproved claims. A mention of conjecture does not establish an open target.
- **P25 — Technical suspicion concerning nonmeasurable partitions:** The paper treats generality using outer measure; not retained as an additional unresolved conjecture.
- **P26 — NeurIPS author checklist:** Checklist items labeled Question are administrative, not mathematical open questions.
- **F01 — AI Disclosure Statement:** Lean report concerns the established MSSP construction, not any Section 6 open target.
- **P20 — arXiv v4 withdrawal notice:** Withdrawn claim; no active mathematical conclusion is accepted from the abstract.

## Canonical inventory

Each entry below distinguishes the written formulation, denominator eligibility, proof-assistant statement search, Lean statement search, and Lean proof search. The original bounded search found no exact artifact; the later verified dyadic pilot is included in the current statuses. The withdrawn historical entries remain historical; later mathematical resolution is not certified.

### 2026-Geraci-O01

Size of the Ferrers-cover/biclique-cover gap, with fixed-vertex qualification requiring clarification.

- Type: legacy open target; written formulation: qualification requires clarification.
- Coverage denominator: excluded. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2026-Geraci: Question 5.1](https://digitalcommons.unl.edu/dissunl/474/); PDF pages 93; original inventory source.

### 2026-Geraci-O02

Largest canonical form of an intersection-complete code on n neurons.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2026-Geraci: Question 5.2](https://digitalcommons.unl.edu/dissunl/474/); PDF pages 94; original inventory source.
- [P02: Question 7.1, intersection-complete case](https://arxiv.org/html/2603.10837v1); extraction lines 740–746; same target additional occurrence.

### 2026-Geraci-O03

Boolean rank equals reduced-code rank plus the count of nonsimple redundancies.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2026-Geraci: Section 5.4 conjectural equality](https://digitalcommons.unl.edu/dissunl/474/); PDF pages 94; original inventory source.
- [P02: Conjecture 7.3](https://arxiv.org/html/2603.10837v1); extraction lines 754–763; same target additional occurrence.

### 2025-Zamir-O01

Uniform boundedness in d of the weighted-plane defect D(X,d).

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2025-Zamir: Chapter 9 problem 2 / Problem 8.3](https://digitalcommons.unl.edu/dissunl/320/); PDF pages 79, 95; original inventory source.
- [P14: Section 8, item 2](https://arxiv.org/html/2406.08602v2); extraction lines 795–796; same target additional occurrence.

### 2025-Zamir-O02

Applicability of Horace or a suitable modification in the specified weighted projective spaces.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2025-Zamir: Chapter 9 problem 5](https://digitalcommons.unl.edu/dissunl/320/); PDF pages 95, 96; original inventory source.
- [P14: Section 8, item 5](https://arxiv.org/html/2406.08602v2); extraction lines 801–802; same target additional occurrence.

### 2024-Ganger-O01

Extension to higher dimensions of the identified canonical-spread group relationship.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2024-Ganger: Remark 6.4](https://digitalcommons.unl.edu/dissunl/143/); PDF pages 42; original inventory source.

### 2024-Lieberman-O01

Scope of Bernstein's inequality for the indicated general algebras and differential-operator modules.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2024-Lieberman: Questions 3.27 and 4.5](https://digitalcommons.unl.edu/mathstudent/124/); PDF pages 51, 56; original inventory source.

### 2024-Lieberman-O02

Existence of sandwich functional equations in the indicated generality.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2024-Lieberman: Question 6.2](https://digitalcommons.unl.edu/mathstudent/124/); PDF pages 78; original inventory source.

### 2024-Enlow-O01

Uniqueness of weak solutions in the indicated calmed velocity–vorticity regime.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2024-Enlow: Calmed velocity–vorticity weak uniqueness](https://digitalcommons.unl.edu/dissunl/106/); PDF pages 83; original inventory source.
- [F02: Theorems 3.2(a) and 3.3(a), calming conditions (1)–(3); manuscript pp. 6, 11–12](https://www.researchgate.net/publication/395935877_Velocity-vorticity_formulation_of_the_three_dimensional_generalized_Navier-Stokes_equations_Effect_of_algebraic_calming_on_well-posedness_convergence_determining_wavenumber_and_regularity_criteria); extraction lines 1283–1354; related higher dissipation result.

### 2024-Enlow-O02

Global-attractor existence for the indicated calmed velocity–vorticity regime.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2024-Enlow: Calmed velocity–vorticity attractor](https://digitalcommons.unl.edu/dissunl/106/); PDF pages 83; original inventory source.

### 2024-Enlow-O03

Global well-posedness for the original three-dimensional MHD system in the discussed regime.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2024-Enlow: Original MHD global well-posedness](https://digitalcommons.unl.edu/dissunl/106/); PDF pages 84, 85; original inventory source.

### 2024-Enlow-O04

Global well-posedness for the discussed original two-dimensional Kuramoto–Sivashinsky equation.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2024-Enlow: Original two-dimensional KSE global well-posedness](https://digitalcommons.unl.edu/dissunl/106/); PDF pages 112; original inventory source.
- [P18: Introduction, original two-dimensional KSE](https://arxiv.org/html/2304.10493); extraction lines 55–55; same target additional occurrence.

### 2024-Al-O01

Polar-target generalization under the specified distant asteroidal dominating-target hypothesis.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2024-Al: Conjecture 57.1](https://digitalcommons.unl.edu/computerscidiss/239/); PDF pages 67; original inventory source.

### 2023-Wright-O01

Existence of a complete Alexander neighbor with nontrivial Alexander polynomial.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Wright: Question 3.2](https://digitalcommons.unl.edu/mathstudent/116/); PDF pages 26; original inventory source.
- [P22: Question 1.2](https://arxiv.org/html/2210.07728v1); extraction lines 38–40; same target additional occurrence.

### 2023-Wright-O02

First stated algebraic-unknotting extension of Alexander-neighbor realizability.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Wright: Conjecture 3.8](https://digitalcommons.unl.edu/mathstudent/116/); PDF pages 37; original inventory source.

### 2023-Wright-O03

Further stated algebraic-unknotting extension.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Wright: Conjecture 3.9](https://digitalcommons.unl.edu/mathstudent/116/); PDF pages 37; original inventory source.

### 2023-Wright-O04

Stronger breadth-two exclusion in the stated setting.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Wright: Conjecture 3.10](https://digitalcommons.unl.edu/mathstudent/116/); PDF pages 37; original inventory source.

### 2023-Wright-O05

Further breadth-two exclusion conjecture.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Wright: Conjecture 3.12](https://digitalcommons.unl.edu/mathstudent/116/); PDF pages 38; original inventory source.

### 2023-DeClerk-O01

Whether every group with the falsification by fellow traveler property is automatic.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-DeClerk: FFTP automaticity question](https://digitalcommons.unl.edu/mathstudent/115/); PDF pages 2; original inventory source.
- [P23: Abstract](https://arxiv.org/html/2209.11912); extraction lines 36–36; same target additional occurrence.

### 2023-DeClerk-O02

Whether every FFTP group admits a finite convergent rewriting system.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-DeClerk: FFTP finite convergent rewriting question](https://digitalcommons.unl.edu/mathstudent/115/); PDF pages 2; original inventory source.
- [P23: Abstract](https://arxiv.org/html/2209.11912); extraction lines 36–36; same target additional occurrence.

### 2023-Vander-Woude-O01

Clique behavior for the specified alternative partition construction in dimension at least five.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Vander-Woude: Conjecture 4.3.1](https://digitalcommons.unl.edu/mathstudent/117/); PDF pages 107; original inventory source.
- [P24: Conjecture 8.1](https://arxiv.org/html/2211.02694); extraction lines 1046–1050; same target additional occurrence.

### 2023-Vander-Woude-O02

Exponential bifurcation behavior as epsilon increases.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Vander-Woude: Conjecture 4.4.1](https://digitalcommons.unl.edu/mathstudent/117/); PDF pages 110; original inventory source.

### 2023-Vander-Woude-O03

Exact optimal epsilon for the stated diameter-bounded partition class.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Vander-Woude: Conjecture 7.3.1](https://digitalcommons.unl.edu/mathstudent/117/); PDF pages 216; original inventory source.

### 2023-Vander-Woude-O04

Constant-factor optimal epsilon for k=d+1 in that class.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Vander-Woude: Conjecture 7.3.2](https://digitalcommons.unl.edu/mathstudent/117/); PDF pages 216; original inventory source.
- [P24: Conjecture 10.7](https://arxiv.org/html/2211.02694); extraction lines 1447–1450; same target additional occurrence.

### 2023-Vander-Woude-O05

Order-1/d upper bound for polynomial k in the stated class.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Vander-Woude: Conjecture 7.3.3](https://digitalcommons.unl.edu/mathstudent/117/); PDF pages 217; original inventory source.

### 2023-Vander-Woude-O06

Corresponding bound for the specified outer-measure class.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Vander-Woude: Conjecture 7.3.4](https://digitalcommons.unl.edu/mathstudent/117/); PDF pages 217; original inventory source.

### 2023-Vander-Woude-O07

Anisotropic rectangular intersection bound.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Vander-Woude: Conjecture 7.3.5](https://digitalcommons.unl.edu/mathstudent/117/); PDF pages 218; original inventory source.

### 2023-Vander-Woude-O08

Improved epsilon for rectangular volume-one partitions.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Vander-Woude: Conjecture 7.3.6](https://digitalcommons.unl.edu/mathstudent/117/); PDF pages 219; original inventory source.

### 2023-Vander-Woude-O09

Extension of the specified cube enclosure to a partition.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Vander-Woude: Conjecture 9.2.13](https://digitalcommons.unl.edu/mathstudent/117/); PDF pages 266; original inventory source.

### 2023-Vander-Woude-O10

Converse of the stated cousinly/secluded implication.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Vander-Woude: Conjecture 9.6.7](https://digitalcommons.unl.edu/mathstudent/117/); PDF pages 320; original inventory source.

### 2023-Vander-Woude-O11

Equivalence involving affine independence of the specified clique.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Vander-Woude: Conjecture 9.7.9](https://digitalcommons.unl.edu/mathstudent/117/); PDF pages 324; original inventory source.

### 2023-Vander-Woude-O12

Randomized-rounding limitation in the specified setting.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Vander-Woude: Conjecture 10.2.17](https://digitalcommons.unl.edu/mathstudent/117/); PDF pages 360; original inventory source.

### 2023-Vander-Woude-O13

Range of the two specified neighborhood-color functions.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2023-Vander-Woude: Question 8.3.2](https://digitalcommons.unl.edu/mathstudent/117/); PDF pages 248; original inventory source.
- [P33: Section 4, Question 4.1](https://arxiv.org/html/2306.12593v1); extraction lines 417–422; earlier or later restatement.

### 2022-Volk-O01

Exact cherry-minimizer/star-comparison question; duplicate formulations counted once.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2022-Volk: Questions 1 and 5](https://digitalcommons.unl.edu/mathstudent/112/); PDF pages 47, 114; original inventory source.
- [P27: Concluding remarks: cherries in triangle-saturated graphs](https://arxiv.org/html/2101.04213v4); extraction lines 392–392; same target additional occurrence.

### 2022-Volk-O02

Exact path-minimizer split question.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2022-Volk: Question 2](https://digitalcommons.unl.edu/mathstudent/112/); PDF pages 68; original inventory source.
- [P27: Question 5.3](https://arxiv.org/html/2101.04213v4); extraction lines 351–354; same target additional occurrence.

### 2022-Volk-O03

Threshold separating the specified matching-covered optimizers.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2022-Volk: Conjecture 1](https://digitalcommons.unl.edu/mathstudent/112/); PDF pages 112; original inventory source.

### 2022-Volk-O04

Optimal value of the specified construction-bound constant.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2022-Volk: Question 3](https://digitalcommons.unl.edu/mathstudent/112/); PDF pages 113; original inventory source.

### 2022-Volk-O05

Remaining minimizer-parameter cases beyond the stated partial results.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2022-Volk: Question 4](https://digitalcommons.unl.edu/mathstudent/112/); PDF pages 113; original inventory source.
- [P27: Concluding remarks: even-star parameter cases](https://arxiv.org/html/2101.04213v4); extraction lines 393–393; same target additional occurrence.

### 2022-Volk-O06

Specified weak generalized-saturation variant.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2022-Volk: Question 6](https://digitalcommons.unl.edu/mathstudent/112/); PDF pages 114; original inventory source.

### 2025-Barrett-O01

Which smooth fans satisfy the stated toric Zariski–Nagata equality; the general surface case remains unresolved in the dissertation.

- Type: legacy open target; written formulation: source stated target.
- Coverage denominator: included. Preserves the previous audit denominator; see audit/claims.json for hypotheses and exclusions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [2025-Barrett: Question 1 / universality discussion](https://digitalcommons.unl.edu/dissunl/294/); PDF pages 40, 64; original inventory source.

### L-P01-Q6.1

Can the gap between regularity and Ferrers cover number in (6.1) be arbitrarily large over bipartite graphs?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Changed invariants from the held dissertation question; counted separately, without repairing its fixed-vertex qualification.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P01: Question 6.1 / equation (6.1)](https://arxiv.org/html/2509.09570v2); extraction lines 530–539; explicit open problem.
- Related, not merged: 2026-Geraci-O01.

### L-P02-matrix-invariants

Identify matrix properties invariant under the equivalence classes of code morphism representatives.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P02: Section 7 introductory discussion](https://arxiv.org/html/2603.10837v1); extraction lines 729–732; explicit open problem.

### L-P02-cover-multiplication

Characterize which codes covering a given code arise by matrix multiplication, in an analogue of Theorem 5.19.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P02: Section 7 introductory discussion](https://arxiv.org/html/2603.10837v1); extraction lines 733–736; explicit open problem.

### L-P02-translated-BMF

Find conditions ensuring that a covering edge between intersection-complete codes has a pre-translation edge that is a Boolean matrix factorization.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P02: Section 7 introductory discussion](https://arxiv.org/html/2603.10837v1); extraction lines 734–736; explicit open problem.

### L-P02-Q7.1-union

Determine the maximum canonical-form size of a union-complete code on n neurons.

- Type: extremal or classification; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P02: Question 7.1, union-complete case](https://arxiv.org/html/2603.10837v1); extraction lines 743–746; explicit open problem.
- Related, not merged: 2026-Geraci-O02.

### L-P02-enumeration

For fixed n and canonical-form size, count codes on n neurons attaining that size.

- Type: extremal or classification; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P02: Discussion after Question 7.1](https://arxiv.org/html/2603.10837v1); extraction lines 746–746; explicit open problem.

### L-P02-Q7.2

Determine max_C {lambda(C^(i)) - lambda(C)} in the paper’s code construction.

- Type: conjecture or question; written formulation: formulation needs clarification.
- Coverage denominator: excluded. The displayed maximum does not explicitly quantify i or fix the input length; preserve the source wording rather than silently impose a finite extremal regime.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P02: Question 7.2](https://arxiv.org/html/2603.10837v1); extraction lines 747–753; explicit open problem.

### L-P02-attain-bound

Does a code attain lambda(C^(i)) <= 2 lambda(C) - 2?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P02: Question following Question 7.2](https://arxiv.org/html/2603.10837v1); extraction lines 753–753; explicit open problem.

### L-P02-downset

For length ell, determine the largest number of length ell+1 codes in the down-set generated by length ell codes.

- Type: extremal or classification; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P02: Discussion after Question 7.2](https://arxiv.org/html/2603.10837v1); extraction lines 753–753; explicit open problem.

### L-P02-nonsimple

Determine the largest number of nonsimple redundancies as a function of the minimum neuron number.

- Type: extremal or classification; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P02: Section 7.3 after Conjecture 7.3](https://arxiv.org/html/2603.10837v1); extraction lines 763–763; explicit open problem.
- Related, not merged: 2026-Geraci-O03.

### L-P03-functors

Relate cohomological support varieties under functors D^f(S) -> D^f(R) beyond the specific functors treated in the paper.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Theorems A and B answer specified local-map cases; the arbitrary-functor motivation is not counted as an unanswered fixed theorem.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P03: Question 1 and the scope discussion](https://arxiv.org/html/2506.10757); extraction lines 45–59; explicit open problem.

### L-P04-Q6.1

Classify support varieties of seven- and eight-generated monomial ideals by the paper’s approach, at least computationally.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P04: Question 6.1](https://arxiv.org/html/2605.29103); extraction lines 1124–1125; explicit open problem.

### L-P04-Q6.2

Are edge ideals of (4m+2)-cycles the only monomial ideals whose support variety is not a union of coordinate subspaces?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P04: Question 6.2](https://arxiv.org/html/2605.29103); extraction lines 1126–1127; explicit open problem.

### L-P04-Q6.3

For a monomial ideal with connected GCD graph and n minimal generators, do d <= (n-3)/2 and c <= n/2 hold, where d counts irreducible components and c is support-variety codimension?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. One numbered question with two asserted bounds; counted once. All ideal/presentation conventions are inherited from the paper.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P04: Question 6.3](https://arxiv.org/html/2605.29103); extraction lines 1128–1129; explicit open problem.

### L-P07-turnstile

Extend the paper’s cash-register streaming prediction method to the turnstile model.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P07: Remark after the cash-register model](https://arxiv.org/html/2408.01318); extraction lines 445–446; explicit open problem.

### L-P07-complex-data

Determine whether data generators can be too complex to satisfy the usual stochastic modeling assumptions.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P07: Final discussion](https://arxiv.org/html/2408.01318); extraction lines 1578–1606; explicit open problem.

### L-P08-support

Relax boundedness/common bounded support in Theorem 2.2, potentially using the hypotheses of the cited Theorem 2.1.

- Type: research direction; written formulation: formulation needs clarification.
- Coverage denominator: excluded. A proposed route to weaker assumptions, without an exact replacement hypothesis list; excluded until an executable target is specified.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P08: Theorem 2.2, Remark 1; PDF pp. 12–13](https://arxiv.org/pdf/2507.21308); extraction lines 587–610; explicit open problem.

### L-P08-typical

Characterize typical M-open data and useful subclasses of that data.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P08: Introduction and Section 7; PDF pp. 5 and 50](https://arxiv.org/pdf/2507.21308); extraction lines 218–235; explicit open problem.
- [P08: Section 7, PDF p. 50](https://arxiv.org/pdf/2507.21308); extraction lines 2805–2814; explicit open problem.
- Related, not merged: L-P07-complex-data.

### L-P08-bias-variance

Determine an appropriate variance–bias tradeoff for M-open data and predictor classes.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. The source explicitly says M-open is not precisely defined and cautions that this tradeoff is not readily formalized.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P08: Section 5 discussion; PDF p. 45](https://arxiv.org/pdf/2507.21308); extraction lines 2603–2617; explicit open problem.

### L-P09-all-absorbing

Under the paper’s syndrome-based Gallager-B decoder, is every absorbing set a trapping set?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P09: Section VI, Concluding Observations](https://arxiv.org/html/2307.14532); extraction lines 500–501; explicit open problem.

### L-P09-XZ

Understand structural connections between X- and Z-error absorbing sets in hypergraph-product codes.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P09: Section VI](https://arxiv.org/html/2307.14532); extraction lines 503–504; explicit open problem.

### L-P09-structured

Classify absorbing sets in structured QLDPC codes, including hypergraph-product codes with circulant base matrices.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P09: Section VI](https://arxiv.org/html/2307.14532); extraction lines 505–505; explicit open problem.
- Later evidence: [Section 4.4, Proposition 4.17; reference [34]](https://arxiv.org/html/2607.13666v1). Explicitly cites Morris–Pllaha–Kelley and gives a restricted (3,3) elementary absorbing-set enumeration for column-weight-3, girth-at-least-6 QC-GHP codes. This is related progress, not a complete classification of structured QLDPC absorbing sets.
- Later evidence: [Sections 3–4, Theorem 4.4 and Corollary 4.5; reference [12]](https://arxiv.org/html/2606.11987v1). Restricted single-base-matrix lifted-product family: connectivity, minimal absorbing sets and lift behavior. Not a complete classification of structured QLDPC codes.

### L-P09-decoders

Extend graphical failure characterizations to Black-Grey-Flip and belief-propagation decoders, or identify replacement characterizations.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P09: Section VI](https://arxiv.org/html/2307.14532); extraction lines 506–506; explicit open problem.

### L-P09-nonabsorbing

Characterize failure-inducing sets that are not absorbing sets, including those illustrated by Example 2(c).

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P09: Section VI final sentence](https://arxiv.org/html/2307.14532); extraction lines 506–506; explicit open problem.

### L-P11-rank-converse

Full converse conjecture: a binary dyadic N-by-N matrix of rank N/2 has nonzero sum of the support vectors of its signature.

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Paraphrases the full converse explicitly conjectured in Remark 3.4. Supports are subsets of F_2^ell and N=2^ell; no equivalence with arbitrary binary-matrix rank is asserted.
- Proof-assistant statement: verified lean statement. Lean statement: verified lean statement. Lean proof: verified complete lean proof.
- Source-described status: open or proposed in source; current resolution: proved in lean for recorded statement.
- Verified artifact: [DyadicRank.RankSupportConjecture](../formalization/dyadic-rank/README.md); Unrestricted conjecture proved by direct induction in every dimension; public ordinary-matrix theorem proves the positive-dimensional rank N/2 form; no Proposition 1.9 or polynomial-model assumption.
- [Checked general proof](../formalization/dyadic-rank/INDUCTIVE-PROOF.md).
- [Larger counterexample search](../formalization/dyadic-rank/search/README.md).
- [P11: Remark 3.4, read with Section 2 and Theorem 3.1](https://arxiv.org/html/2605.01942); extraction lines 182–186; explicit open problem.
- Later evidence: [Friedlander–Pevtsova (2005), Example 2.6, author manuscript page 11; Proposition 2.2, pages 8–9](https://sites.math.washington.edu/~julia/Preprints/ppt/ppt.pdf#page=11). Earlier flatness iff nonzero linear term criterion implies the recorded dyadic converse after the group-algebra translation documented in formalization/dyadic-rank/PRIOR-ART.md. The dyadic formulation is our inference; no claim of a new mathematical theorem. This earlier source was identified in the later follow-up audit.
- Later evidence: [Benson, Representations of Elementary Abelian p-Groups and Vector Bundles (print 2016, online 2017), Section 1.4, page 6](https://assets.cambridge.org/97811071/74177/excerpt/9781107174177_excerpt.pdf#page=6). Explicitly restates flatness iff the image of t lies in the augmentation ideal outside its square. Confirms that the equivalent result is established background; priority of our direct induction or Lean implementation is not established.

### L-P11-girth

Find tight achievable-girth bounds and minimum short-cycle multiplicities for dyadic lifts.

- Type: extremal or classification; written formulation: precise math in source.
- Coverage denominator: included. One related extremal family, not one count for every cycle length or protograph. Fix the ensemble parameters as in Sections 4–6.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P11: Section 7](https://arxiv.org/html/2605.01942); extraction lines 554–554; explicit open problem.

### L-P11-invariants

Extend absorbing-set results to general quasi-dyadic ensembles and find dyadic invariants predicting the error floor.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P11: Section 7](https://arxiv.org/html/2605.01942); extraction lines 554–554; explicit open problem.

### L-P11-forbidden

Are the paper’s forbidden sets complete for length-six and length-eight pathologies?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P11: Section 7](https://arxiv.org/html/2605.01942); extraction lines 555–555; explicit open problem.

### L-P11-n-adic

Develop n-adic lifts of irregular protographs to escape the girth-at-most-eight restriction of all-one dyadic lifting.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Preliminary high-girth examples are already reported; this entry records the wider program, not the claim that no such examples exist.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P11: Section 7](https://arxiv.org/html/2605.01942); extraction lines 556–557; explicit open problem.

### L-P11-quantum-scaling

Establish distance/rate scaling for dyadic CSS families and investigate regularity for syndrome extraction and parallel decoding.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P11: Section 7](https://arxiv.org/html/2605.01942); extraction lines 558–558; explicit open problem.
- [P28: Section 8: improve quantum distance through lifts and quasi-dyadic constructions](https://www.researchgate.net/publication/387080373_Codes_based_on_dyadic_matrices_and_their_generalizations); extraction lines 3131–3142; overlapping quantum distance direction.

### L-P11-group-rings

Extend the framework to other group-ring lift families beyond characteristic two.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P11: Section 7](https://arxiv.org/html/2605.01942); extraction lines 558–558; explicit open problem.

### L-P13-relaxations

Develop tight, inexpensive boundary-sensitive lower bounds and effective relaxations for GRACE transition dictionaries.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P13: Section 6.2](https://arxiv.org/html/2609.28831); extraction lines 465–465; explicit open problem.

### L-P14-generators

Find explicit generators for the defining ideal of a general point in weighted projective n-space, n >= 3, allowing restrictions on the weights.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P14: Section 8, item 1](https://arxiv.org/html/2406.08602v2); extraction lines 793–794; explicit open problem.

### L-P14-Veronese

Compute minimal free resolutions of the defining ideal of the weighted Veronese variety for the degrees specified in Section 8(3).

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Source specifies P(1,a_1,...,a_n), g=lcm(a_i), and g dividing d. Embedding hypotheses must be checked before formalization; do not import a different thesis degree qualification silently.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P14: Section 8, item 3 / Definition 7.4](https://arxiv.org/html/2406.08602v2); extraction lines 797–798; explicit open problem.

### L-P14-SHGH

Formulate a weighted-projective-plane analogue of SHGH for mixed point multiplicities in P(1,b,c).

- Type: research direction; written formulation: formulation needs clarification.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P14: Section 8, item 4](https://arxiv.org/html/2406.08602v2); extraction lines 799–800; explicit open problem.

### L-P15-C5.1

For 6 dividing n and any plane elliptic curve, the triple-point ideal of the elliptified Boroczky construction on E[n] fails I^(3) subset I^2.

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Retains the paper’s ambient field and construction conventions; this is not a claim for every field or arbitrary elliptic embedding.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P15: Conjecture 5.1](https://arxiv.org/html/2510.17029); extraction lines 405–406; explicit open problem.
- [P15: Section 6, item 3: larger-n investigation](https://arxiv.org/html/2510.17029); extraction lines 413–414; supporting research direction.

### L-P15-hand-proof

Give a fully non-computer-assisted proof of I_n^(3) not subset I_n^2 for the configuration family.

- Type: proof method request; written formulation: proof method request.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: proof method requested for computed results; current resolution: not independently established.
- [P15: Section 6, item 1](https://arxiv.org/html/2510.17029); extraction lines 409–410; explicit open problem.

### L-P15-arrangements

Can the Boroczky or elliptified Boroczky configuration be realized as a hyperplane arrangement with ordinary lines only?

- Type: conjecture or question; written formulation: formulation needs clarification.
- Coverage denominator: excluded. The ambient realization requirements require specification before translating this geometric question; excluded from the fixed-target denominator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P15: Section 6, item 2](https://arxiv.org/html/2510.17029); extraction lines 411–412; explicit open problem.

### L-P15-higher-dim

Do analogous constructions on elliptic curves in higher-dimensional projective spaces produce ideals violating symbolic/ordinary power containment?

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P15: Section 6, item 4](https://arxiv.org/html/2510.17029); extraction lines 415–416; explicit open problem.

### L-P15-table-proof

Give a non-computer-assisted justification for the data in Table 1.

- Type: proof method request; written formulation: proof method request.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: proof method requested for computed results; current resolution: not independently established.
- [P15: Section 6, item 5](https://arxiv.org/html/2510.17029); extraction lines 417–418; explicit open problem.

### L-P16-linear-simplicity

Are differential-operator rings of all graded direct summands of polynomial rings linearly simple for Bernstein filtrations, in the paper’s characteristic-zero setting?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P16: Introduction, paragraph before Theorem 1.3](https://arxiv.org/html/2403.13146v1); extraction lines 63–63; explicit open problem.
- Related, not merged: 2024-Lieberman-O01.

### L-P17-weak-unique

Are weak solutions of the calmed rotational Navier–Stokes system (1.7) unique in the paper’s weak solution class?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. The calmed rotational NSE is a different system from the calmed velocity–vorticity target in the thesis; do not merge their uniqueness questions.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P17: Remark 7.1 and introduction](https://arxiv.org/html/2312.17371); extraction lines 715–717; explicit open problem.
- Related, not merged: 2024-Enlow-O01.

### L-P17-Leray-Hopf

Are Leray–Hopf weak solutions of the three-dimensional NSE unique in the setting discussed by Remark 7.1?

- Type: conjecture or question; written formulation: formulation needs clarification.
- Coverage denominator: excluded. Historical background question whose domain, forcing and solution class need pinning down before a current coverage comparison. Later primary literature reports nonuniqueness, so it is not counted as a presently unresolved fixed target.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: later nonuniqueness report scope comparison required.
- [P17: Remark 7.1, referenced background problem](https://arxiv.org/html/2312.17371); extraction lines 715–717; explicit open problem.
- Later evidence: [Abstract; revised 19 March 2026](https://arxiv.org/abs/2509.25116v2). Authors report a rigorous computer-assisted nonuniqueness result for the unforced three-dimensional equations; exact match with P17’s background question was not established. Computer-assisted does not by itself mean Lean-checked.
- Related formalization: [https://github.com/openai/NavierStokesAndEuler](https://github.com/openai/NavierStokesAndEuler). Repository describes formalized forced finite-time breakdown/global smooth nonexistence, not the weak-solution uniqueness question or a calmed-system theorem. Not built in this audit.

### L-P17-suitable

Develop suitable-weak-solution analogues and a local energy inequality for calmed rotational NSE under Definition 1.2(4).

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P17: Remark 7.2](https://arxiv.org/html/2312.17371); extraction lines 718–719; explicit open problem.

### L-P19-local-original

Prove short-time existence and uniqueness for the original Ohmic-heating MHD–Boussinesq system (1.5) in Assumption 2.1’s strong solution class.

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. A local existence/uniqueness obligation, distinct from the stronger global question below. Article convergence is conditional on this assumption.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P19: Assumption 2.1 and discussion](https://arxiv.org/html/2410.04357); extraction lines 279–297; explicit open problem.
- Related, not merged: L-P19-global-original.

### L-P19-global-original

Establish global well-posedness of the original two-dimensional MHD–Boussinesq system with Ohmic heating (1.5).

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. The original two-dimensional Ohmic-heating system is distinct from the earlier thesis target described as three-dimensional MHD.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P19: Introduction and Concluding Remarks](https://arxiv.org/html/2410.04357); extraction lines 62–78; explicit open problem.
- [P19: Concluding Remarks](https://arxiv.org/html/2410.04357); extraction lines 740–741; explicit open problem.
- Related, not merged: 2024-Enlow-O03, L-P19-local-original.

### L-P19-weak-initial

Prove global existence for the calmed system (1.1) from initial data in H x H x L^2 rather than V x V x L^2.

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P19: Discussion after estimate (3.11)](https://arxiv.org/html/2410.04357); extraction lines 431–431; explicit open problem.

### L-P19-three-D

Extend Ohmic-heating calming to three dimensions with additional regularization of the fluid nonlinearity.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P19: Concluding Remarks](https://arxiv.org/html/2410.04357); extraction lines 742–742; explicit open problem.

### L-P19-softplus

Analyze the alternative soft-plus Ohmic-heating regularization and improved temperature smoothness.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P19: Concluding Remarks](https://arxiv.org/html/2410.04357); extraction lines 743–745; explicit open problem.

### L-P24-C9.17

Does countable, rather than finite, cube intersection suffice for the Third Optimality Theorem, yielding a point incident with at least d+1 partition closures?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Retains strict pairwise diameter bound D and a translated closed D-cube intersecting countably many cells. The source proves the d=1 case only.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P24: Conjecture 9.17](https://arxiv.org/html/2211.02694); extraction lines 1303–1308; explicit open problem.

### L-P24-dissection

Do hypercube dissection and triangulation numbers agree in every dimension?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Referenced background open question; not attributed as a new conjecture of the paper’s authors.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P24: Discussion of Sperner numbers](https://arxiv.org/html/2211.02694); extraction lines 1380–1380; explicit open problem.

### L-P26-other-norms

Construct near-optimal secluded partitions for norms beyond ell-infinity, especially ell-p norms, approaching the Appendix A.8 bounds.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P26: Section 6; PDF p. 9](https://papers.neurips.cc/paper_files/paper/2024/file/8ff87c96935244b63503f542472462b3-Paper-Conference.pdf); extraction lines 651–655; explicit open problem.

### L-P26-sample-lower

Establish generic sample-complexity lower bounds for list-replicable learning, beyond algorithms using secluded partitions.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P26: Section 6; PDF p. 9](https://papers.neurips.cc/paper_files/paper/2024/file/8ff87c96935244b63503f542472462b3-Paper-Conference.pdf); extraction lines 656–659; explicit open problem.

### L-P26-neighborhood-KKM

Improve the neighborhood Sperner/KKM color bound so it also recovers the classical d+1 bound for arbitrarily small epsilon.

- Type: extremal or classification; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P26: Section 6; PDF p. 10](https://papers.neurips.cc/paper_files/paper/2024/file/8ff87c96935244b63503f542472462b3-Paper-Conference.pdf); extraction lines 662–666; explicit open problem.
- [P33: Section 4 conclusion: improve neighborhood-color bounds](https://arxiv.org/html/2306.12593v1); extraction lines 441–446; earlier related formulation.

### L-P26-KKM-applications

Find applications of the neighborhood Sperner/KKM lemma.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P26: Section 6; PDF p. 10](https://papers.neurips.cc/paper_files/paper/2024/file/8ff87c96935244b63503f542472462b3-Paper-Conference.pdf); extraction lines 667–668; explicit open problem.

### L-P27-Q2.4-existence

For fixed r,t >= 3, classify n admitting S_t-saturated K_(r+1)-free graphs.

- Type: extremal or classification; written formulation: precise math in source.
- Coverage denominator: included. Theorem 2.5 supplies sufficient large-n ranges, not a full existence classification. Distinct from optimizing a particular construction bound.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P27: Question 2.4, first part](https://arxiv.org/html/2101.04213v4); extraction lines 105–111; explicit open problem.
- [P27: Concluding remarks: refine n bounds](https://arxiv.org/html/2101.04213v4); extraction lines 394–394; explicit open problem.
- Related, not merged: 2022-Volk-O04.

### L-P27-Q2.4-counts

For fixed r,t >= 3 and n, determine possible numbers of K_r copies in S_t-saturated n-vertex graphs.

- Type: extremal or classification; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P27: Question 2.4, second part](https://arxiv.org/html/2101.04213v4); extraction lines 106–107; explicit open problem.

### L-F01-random-bits

Extend the Omega(log d) randomness lower bound for privately answering d linear queries beyond the epsilon <= 1/d regime.

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [F01: Section 6, first bullet; Section 1.1](https://arxiv.org/html/2609.02880v1); extraction lines 719–720; explicit open problem.

### L-F01-efficient-utility

Remove the extra log d utility factor from the efficient ell-infinity mechanism while retaining its low-randomness guarantees.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Targets the efficient mechanism’s O(d log d / epsilon) versus optimal O(d / epsilon) error, with the paper’s privacy/sensitivity/error and randomness conventions. Related MSSP construction gap is linked as an occurrence, not double-counted.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [F01: Section 6, first bullet; Section 1.2 MSSP gap](https://arxiv.org/html/2609.02880v1); extraction lines 719–720; explicit open problem.
- [F01: Section 1.2, MSSP parameter gap](https://arxiv.org/html/2609.02880v1); extraction lines 179–179; related construction gap.

### L-F01-K-norms

Obtain efficient low-randomness mechanisms for all K-norm sensitivity bodies, or at least all ell-p norms.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [F01: Section 6, second bullet](https://arxiv.org/html/2609.02880v1); extraction lines 721–722; explicit open problem.

### L-F01-approximate-DP

Determine the utility achievable by approximate-DP linear-query mechanisms with worst-case polylog(d) random bits, closing the stated utility gap.

- Type: extremal or classification; written formulation: precise math in source.
- Coverage denominator: included. Retains (epsilon,delta)-DP and worst-case, rather than expected, random-bit constraint; compare the paper’s O(d/epsilon) error with its unconstrained benchmark.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [F01: Section 6, third bullet](https://arxiv.org/html/2609.02880v1); extraction lines 723–724; explicit open problem.

### L-F03-scores

Determine exact generalized saturation-game scores in the (H,F) cases where the paper’s upper and lower bounds differ.

- Type: extremal or classification; written formulation: precise math in source.
- Coverage denominator: included. One parameterized family of the paper’s unresolved cases, not one target per n or unenumerated graph pair.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [F03: Section 6](https://arxiv.org/html/2404.02288v2); extraction lines 556–557; explicit open problem.

### L-F03-Turan-relation

Determine further generalized saturation-game scores and their relation to corresponding generalized Turan numbers.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [F03: Section 6](https://arxiv.org/html/2404.02288v2); extraction lines 558–558; explicit open problem.

### L-F03-spanning

Extend saturation games to spanning graph structures, such as spanning trees or Hamilton cycles, instead of fixed forbidden/scored graphs.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [F03: Section 6](https://arxiv.org/html/2404.02288v2); extraction lines 559–559; explicit open problem.

### L-P28-general-arrays

Extend structural, girth and cycle results to general j-by-k quasi-dyadic or quasi-n-adic arrays with varying block weights.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad research direction without a fixed proposed bound or fully specified theorem; excluded from the fixed-target denominator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P28: Section 8, item (1), manuscript pp. 22–23](https://www.researchgate.net/publication/387080373_Codes_based_on_dyadic_matrices_and_their_generalizations); extraction lines 3091–3100; explicit research direction.
- Related, not merged: L-P11-invariants.

### L-P28-algebraic-families

Construct algebraic quasi-n-adic code families with provable parameters, extending the quasi-triadic example.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad research direction without a fixed proposed bound or fully specified theorem; excluded from the fixed-target denominator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P28: Section 8, item (2)](https://www.researchgate.net/publication/387080373_Codes_based_on_dyadic_matrices_and_their_generalizations); extraction lines 3096–3103; explicit research direction.
- Related, not merged: L-P11-n-adic.

### L-P28-distance-bounds

Develop minimum-distance bounds for quasi-n-adic codes with n >= 3.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad research direction without a fixed proposed bound or fully specified theorem; excluded from the fixed-target denominator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P28: Section 8, item (3)](https://www.researchgate.net/publication/387080373_Codes_based_on_dyadic_matrices_and_their_generalizations); extraction lines 3102–3111; explicit research direction.

### L-P28-QC-comparison

Compare Theorem 6.3’s minimum-distance bound with the cited quasi-cyclic bounds and compare quasi-dyadic with quasi-cyclic code families.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad research direction without a fixed proposed bound or fully specified theorem; excluded from the fixed-target denominator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P28: Section 8, comparison paragraph](https://www.researchgate.net/publication/387080373_Codes_based_on_dyadic_matrices_and_their_generalizations); extraction lines 3112–3116; explicit research direction.

### L-P28-signature-dimension

Determine how signature support controls the dimension beyond the characterized self-dual dyadic case.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. A broad signature/dimension program. P11 Theorem 3.1 gives a later affine-support rank formula and Remark 3.4 a particular full-converse conjecture; neither settles the entire general support/dimension program.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P28: Section 8, final paragraph](https://www.researchgate.net/publication/387080373_Codes_based_on_dyadic_matrices_and_their_generalizations); extraction lines 3118–3131; explicit research direction.
- Related, not merged: L-P11-rank-converse.

### L-F02-original-VV

Establish global well-posedness for the original three-dimensional velocity–vorticity system (2).

- Type: conjecture or question; written formulation: formulation needs clarification.
- Coverage denominator: excluded. The source labels global well-posedness of (2) open but does not fix a solution class and boundary-condition regime in that sentence. Keep it as a background formulation request, not a claim that every generalized model remains untreated.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [F02: Introduction, equation (2) and following paragraph; manuscript p. 2](https://www.researchgate.net/publication/395935877_Velocity-vorticity_formulation_of_the_three_dimensional_generalized_Navier-Stokes_equations_Effect_of_algebraic_calming_on_well-posedness_convergence_determining_wavenumber_and_regularity_criteria); extraction lines 149–184; explicit research direction.
- Related, not merged: 2024-Enlow-O01.

### L-P20-polar-pairs

Extend maximal-polar-pair methods to graphs with asteroidal triples, potentially covering dominating-pair graphs.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Historical direction from a withdrawn manuscript; excluded from active coverage and no claimed linear-time theorem is endorsed.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: withdrawn historical only; current resolution: not independently established.
- [P20: Historical v3 Section 8, PDF p. 16](https://arxiv.org/pdf/2209.00110v3); extraction lines 654–656; explicit research direction.

### L-P20-linear-reduction

Does a linear-time reduction exist from finding a simplicial vertex in a general graph to finding the diameter of an AT-free graph?

- Type: algorithmic question; written formulation: precise math in source.
- Coverage denominator: excluded. A precise historical algorithmic question, held out because its source was withdrawn. Its claimed consequences rely on the disputed diameter algorithm.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: withdrawn historical only; current resolution: not independently established.
- [P20: Historical v3 Section 8, PDF p. 16](https://arxiv.org/pdf/2209.00110v3); extraction lines 656–658; explicit research direction.

### L-P20-all-diametral

Find an efficient method to recover all diametral vertices of an AT-free graph, beyond finding one diametral pair.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. The withdrawn source does not provide a validated algorithm or settle this direction; do not inherit its claimed consequences as proved.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: withdrawn historical only; current resolution: not independently established.
- [P20: Historical v3 discussion before Section 8 and conclusion; PDF p. 16](https://arxiv.org/pdf/2209.00110v3); extraction lines 644–664; explicit research direction.

### L-P20-Hamilton-color

Investigate the Hamiltonicity and coloring problems mentioned for AT-free graphs.

- Type: research direction; written formulation: formulation needs clarification.
- Coverage denominator: excluded. Historical background mentions lack a precise input restriction, coloring variant or target complexity; excluded and not asserted currently open.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: withdrawn historical only; current resolution: not independently established.
- [P20: Historical v3 Section 8 final sentence; PDF p. 16](https://arxiv.org/pdf/2209.00110v3); extraction lines 663–664; explicit research direction.

### L-P29-period-bound

Determine a valid order-restricted version of rho^2(G) <= |V|-3 for connected graphs.

- Type: conjecture or question; written formulation: formulation needs clarification.
- Coverage denominator: excluded. The source says every connected graph. K2 has rho^2=0 but |V|-3=-1; a lower-order restriction is missing. No repaired conjecture is silently substituted.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: literal statement has small counterexample.
- [P29: Conjecture 1; Definition 1](https://arxiv.org/html/2606.25493v1); extraction lines 150–152; explicit question.

### L-P30-crossing-additive

Is crossing number additive under connected sum of orientable surfaces in S^4?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P30: Section 6, Questions 6.1–6.5](https://arxiv.org/html/2302.08431v1); extraction lines 484–487; explicit question.

### L-P30-bridge-additive

Is bridge number minus one additive under connected sum of orientable surfaces in S^4?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P30: Section 6, Questions 6.1–6.5](https://arxiv.org/html/2302.08431v1); extraction lines 484–487; explicit question.

### L-P30-concentrated-gap

Can a surface have smaller crossing number than its concentrated crossing number?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P30: Section 6, Questions 6.1–6.5](https://arxiv.org/html/2302.08431v1); extraction lines 488–490; explicit question.

### L-P30-concentrated-max-gap

How large can the concentrated crossing-number gap be?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P30: Section 6, Questions 6.1–6.5](https://arxiv.org/html/2302.08431v1); extraction lines 488–490; explicit question.

### L-P30-joint-minimum

Can bridge number and crossing number fail to be attained by one tri-plane diagram?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P30: Section 6, Questions 6.1–6.5](https://arxiv.org/html/2302.08431v1); extraction lines 491–493; explicit question.

### L-P30-bridge-exceeds-crossing

Can bridge number exceed crossing number without adding unknotted connected-sum factors?

- Type: conjecture or question; written formulation: formulation needs clarification.
- Coverage denominator: excluded. The excluded connected-sum constructions need a precise restriction before denominator inclusion.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P30: Section 6, Questions 6.1–6.5](https://arxiv.org/html/2302.08431v1); extraction lines 494–496; explicit question.

### L-P30-nonzero-euler-min

Minimize crossing number for a surface with nonzero normal Euler number and no projective-plane summand.

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P30: Section 6, Questions 6.1–6.5](https://arxiv.org/html/2302.08431v1); extraction lines 497–499; explicit question.

### L-P31-sample-gap

Is the sample-complexity gap between list and certificate replicability necessary at comparable parameters?

- Type: conjecture or question; written formulation: formulation needs clarification.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P31: Section 6](https://arxiv.org/html/2304.02240v1); extraction lines 430–431; explicit question.

### L-P31-adaptive-gap

Is the exponential replicability-parameter gap between adaptive and non-adaptive statistical queries necessary?

- Type: conjecture or question; written formulation: formulation needs clarification.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P31: Section 6](https://arxiv.org/html/2304.02240v1); extraction lines 430–431; explicit question.

### L-P31-tradeoffs

Determine tradeoffs among sampling, list size, certificates and adaptivity.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P31: Section 6](https://arxiv.org/html/2304.02240v1); extraction lines 430–431; explicit question.

### L-P32-Conway-existence

Does a strongly regular graph with parameters (99,14,1,2) exist?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: identified lean statement not build verified. Lean statement: identified lean statement not build verified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not resolved by the checked relaxed bound.
- [P32: Section 1, opening existence question](https://arxiv.org/html/2610.16266v1); extraction lines 32–36; explicit question.
- Later evidence: [Conjecture 5 and final paragraph](https://arxiv.org/html/2610.16266v1). The relaxed 55-triangle bound is contradicted by scripts/check_expansion_graphs.py; no conclusion about existence of the strongly regular graph follows from this check.
- Related formalization: [https://github.com/leanprover-community/mathlib4/blob/0db93bb44438a03c84317df5f033136cdd14c91f/Wanted/Combinatorics/SimpleGraph/StronglyRegular.lean](https://github.com/leanprover-community/mathlib4/blob/0db93bb44438a03c84317df5f033136cdd14c91f/Wanted/Combinatorics/SimpleGraph/StronglyRegular.lean). SimpleGraph.conway_99 is a proof_wanted existence statement, not a proof. Also present in the pinned mathlib checkout; no build/axiom audit of this wanted item was performed.

### L-P32-triangle-bound

Is the stated maximum of 55 triangles valid on 99 vertices under the diamond/K2,3 exclusions?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: excluded. Held outside active coverage: an exact Python check gives a connected 99-vertex diamond-free, K2,3-free graph with 66 triangles. This graph is not strongly regular.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: counterexample checked in python not lean.
- [P32: Conjecture 5](https://arxiv.org/html/2610.16266v1); extraction lines 76–134; explicit question.
- Later evidence: [AI-authored public note, dated October 20, 2026](https://irsi.ai/notes/frontiermath-open/). Earlier public counterexamples report 169 and 120 triangles. Not peer reviewed; no priority claim for our later 66-triangle construction. Our preceding check independently reconstructed the ER(9) example; the 169-triangle example has not been independently reconstructed here.

### L-P32-SOS-certificate

Produce an exact checkable certificate for a corrected sum-of-squares relaxation.

- Type: proof method request; written formulation: proof method request.
- Coverage denominator: excluded. The source requests formalization of its certificate; the stated relaxed bound first needs correction. This is not a verified Lean artifact.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P32: Final paragraph, Section 3.2](https://arxiv.org/html/2610.16266v1); extraction lines 132–134; explicit question.

### L-P33-interval-constancy

Are the open and closed neighborhood-color functions constant on the displayed reciprocal intervals?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P33: Section 4, paragraph after Question 4.1](https://arxiv.org/html/2306.12593v1); extraction lines 420–422; explicit question.

### L-P33-unified-method

Find one proof technique recovering both small-radius and larger-radius color bounds.

- Type: proof method request; written formulation: proof method request.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P33: Section 4 conclusion](https://arxiv.org/html/2306.12593v1); extraction lines 444–446; explicit question.

### L-F04-practical-definition

Develop replicable reinforcement learning under other practical replicability definitions.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F04: Section 8](https://arxiv.org/html/2512.00553v1); extraction lines 424–426; explicit question.

### L-F04-function-approximation

Extend list-replicable reinforcement learning beyond tabular models using function approximation.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F04: Section 8](https://arxiv.org/html/2512.00553v1); extraction lines 424–426; explicit question.

### L-F04-continuous-actions

Extend the robust planner to continuous action spaces.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F04: Section 8](https://arxiv.org/html/2512.00553v1); extraction lines 424–426; explicit question.

### L-F05-list-lower

For the Theorem 5.4 regret regime and delta=1/k, is an Omega(k^2) list size necessary?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Fix the regret guarantee of Theorem 5.4; the paper already gives a k-list algorithm with a different regret rate.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F05: Section 8, PDF page 10](https://proceedings.iclr.cc/paper_files/paper/2025/file/0faa0019b0a8fcab8e6476bc43078e2e-Paper-Conference.pdf); extraction lines 716–724; explicit question.

### L-F05-tradeoff

Determine the full list-complexity versus regret tradeoff for bandits.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F05: Section 8, PDF page 10](https://proceedings.iclr.cc/paper_files/paper/2025/file/0faa0019b0a8fcab8e6476bc43078e2e-Paper-Conference.pdf); extraction lines 720–724; explicit question.

### L-F05-UCB

Modify UCB to guarantee list replicability with list size independent of the horizon.

- Type: conjecture or question; written formulation: formulation needs clarification.
- Coverage denominator: excluded. The source does not specify the regret and list-size guarantees for the requested UCB modification.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F05: Section 8, PDF page 10](https://proceedings.iclr.cc/paper_files/paper/2025/file/0faa0019b0a8fcab8e6476bc43078e2e-Paper-Conference.pdf); extraction lines 725–733; explicit question.

### L-F06-zero-resistivity

Prove well-posedness after adding magnetic Voigt regularization and setting eta=0, nu>0.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. A concrete PDE direction, but the target solution class and full theorem hypotheses are not fixed in this passage.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F06: Section 1.1](https://arxiv.org/html/2605.05139v1); extraction lines 110–111; explicit question.

### L-F06-thermal

Add thermal coupling to the velocity-vorticity-Voigt MHD model.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F06: Section 1.1](https://arxiv.org/html/2605.05139v1); extraction lines 112–112; explicit question.

### L-F07-Q6.1

Axiomatize neural codes below oriented matroids.

- Type: conjecture or question; written formulation: formulation needs clarification.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F07: Section 6, Question 6.1](https://arxiv.org/html/2002.03542v2); extraction lines 1104–1115; explicit question.

### L-F07-Q6.2

Choose a combinatorial language and characterize convexity in it.

- Type: conjecture or question; written formulation: formulation needs clarification.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F07: Section 6, Question 6.2](https://arxiv.org/html/2002.03542v2); extraction lines 1121–1126; explicit question.

### L-F07-Q6.3

Can every convex neural code be realized by convex polytopes?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F07: Section 6, Question 6.3](https://arxiv.org/html/2002.03542v2); extraction lines 1134–1147; explicit question.
- [F08: Introduction, Conjecture 1.3](https://arxiv.org/html/2512.04241v1); extraction lines 56–61; explicit later restatement.
- Later evidence: [Introduction and Section 3](https://arxiv.org/html/2512.04241v1). The conjecture is explicitly restated; the source reports a planar affirmative case and proves covering-relation results. Higher-dimensional validity is not established here.

### L-F07-Q6.4-finite

Are there finitely many minor-minimal oriented matroids above a given code?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F07: Section 6, Question 6.4](https://arxiv.org/html/2002.03542v2); extraction lines 1148–1149; explicit question.

### L-F07-Q6.4-enumerate

Efficiently enumerate the minor-minimal oriented matroids above a code.

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F07: Section 6, Question 6.4](https://arxiv.org/html/2002.03542v2); extraction lines 1148–1152; explicit question.
- Later evidence: [Introduction and Section 3](https://arxiv.org/html/2512.04241v1). Covering-relation characterization supplies a related step toward climbing the code poset, not a proof of finite or efficiently enumerable minimal oriented matroids.

### L-F07-Q6.5-growth

Determine growth of the source-defined matroid ground-set bounds M(n) and H(n).

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F07: Section 6, Question 6.5](https://arxiv.org/html/2002.03542v2); extraction lines 1161–1174; explicit question.

### L-F07-Q6.5-equal

Are the source-defined functions M(n) and H(n) equal?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F07: Section 6, Question 6.5](https://arxiv.org/html/2002.03542v2); extraction lines 1161–1174; explicit question.

### L-F07-Q6.6

Formulate an oriented-matroid version of the neural-code sunflower theorem.

- Type: conjecture or question; written formulation: formulation needs clarification.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F07: Section 6, Question 6.6](https://arxiv.org/html/2002.03542v2); extraction lines 1177–1180; explicit question.

### L-F07-Q6.7-collapse

Are the specified missing-codeword links of oriented-matroid codes collapsible?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F07: Section 6, Question 6.7](https://arxiv.org/html/2002.03542v2); extraction lines 1181–1197; explicit question.

### L-F07-Q6.7-classify

Classify simplicial complexes occurring as those missing-codeword links.

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F07: Section 6, Question 6.7](https://arxiv.org/html/2002.03542v2); extraction lines 1194–1197; explicit question.

### L-F07-Q6.8

Interpret chirotopes, rank and convex closure through neural-code functors.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F07: Section 6, Question 6.8](https://arxiv.org/html/2002.03542v2); extraction lines 1199–1206; explicit question.

### L-F07-Q6.9

Extend the categorical embeddings to affine oriented matroids and COMs.

- Type: conjecture or question; written formulation: formulation needs clarification.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F07: Section 6, Question 6.9](https://arxiv.org/html/2002.03542v2); extraction lines 1207–1220; explicit question.

### L-F07-Q6.10

Embed oriented matroids with weak maps into the code category.

- Type: conjecture or question; written formulation: formulation needs clarification.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F07: Section 6, Question 6.10](https://arxiv.org/html/2002.03542v2); extraction lines 1221–1223; explicit question.

### L-F07-convex-decision

Is convexity of a finite neural code algorithmically decidable?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F07: Section 6.2 opening discussion](https://arxiv.org/html/2002.03542v2); extraction lines 1127–1133; explicit question.
- [F08: Introduction: convexity decision problem](https://arxiv.org/html/2512.04241v1); extraction lines 39–61; related later discussion.

### L-F10-boundary

Extend fractional Voigt analysis to domains with physical boundaries.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F10: Section 7](https://arxiv.org/html/2410.23492v1); extraction lines 692–693; explicit question.

### L-F10-computations

Investigate turbulent statistics and blow-up criteria numerically for fractional Voigt models.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F10: Section 7](https://arxiv.org/html/2410.23492v1); extraction lines 692–693; explicit question.

### L-F11-smallness

Can the condition c0*mu*h^2 <= nu be removed from the assimilation well-posedness argument?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Question refers to this paper’s assimilation system and its remaining well-posedness hypotheses, not to general Navier–Stokes well-posedness.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F11: Section 3, after estimates (3.1)](https://arxiv.org/html/2508.07492v1); extraction lines 239–240; explicit question.

### L-F13-Q5.8

Classify neural codes attaining polarized-ideal projective dimension 2n-3.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F13: Question 5.8](https://arxiv.org/html/2602.16993v1); extraction lines 578–580; explicit question.

### L-F13-Q10.1

Explain the achievable homological-invariant region through cube geometry.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F13: Question 10.1](https://arxiv.org/html/2602.16993v1); extraction lines 1163–1167; explicit question.

### L-F13-Q10.2

Determine all achievable (projective dimension, regularity) pairs for n-neuron polarized neural ideals.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F13: Question 10.2](https://arxiv.org/html/2602.16993v1); extraction lines 1168–1170; explicit question.

### L-F13-Q10.3

Describe multigraded Betti numbers of polarized neural ideals combinatorially.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F13: Question 10.3](https://arxiv.org/html/2602.16993v1); extraction lines 1171–1173; explicit question.
- Later evidence: [Theorem 4.9](https://arxiv.org/html/2605.24181v1). Bidegree Betti formula for inductively pierced codes. Restricted related progress, not a solution for arbitrary codes or a full fine-multigraded formula.

### L-F13-Q10.4

Determine achievable invariant pairs under convex or stable-hyperplane code restrictions.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F13: Question 10.4](https://arxiv.org/html/2602.16993v1); extraction lines 1174–1177; explicit question.

### L-F14-accuracy

Achieve near-optimal counting-query accuracy with logarithmic expected randomness, or prove that more randomness is necessary.

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F14: Directions for Future Work, PDF page 8](https://drops.dagstuhl.de/storage/00lipics/lipics-vol325-itcs2025/LIPIcs.ITCS.2025.27/LIPIcs.ITCS.2025.27.pdf); extraction lines 336–341; explicit question.
- Later evidence: [Main theorem, extraction lines 93–100](https://arxiv.org/html/2510.16959v1). The logarithmic-randomness specialization has a displayed d^2/epsilon-type error term up to logarithms; it is not the requested near-optimal d/epsilon accuracy.
- Related formalization: [https://github.com/leanprover/SampCert/blob/a2c53bb5ff790e729e252958060699b7eff898b9/SampCert/DifferentialPrivacy/Queries/Count/Properties.lean](https://github.com/leanprover/SampCert/blob/a2c53bb5ff790e729e252958060699b7eff898b9/SampCert/DifferentialPrivacy/Queries/Count/Properties.lean). Private count/noised-query privacy under sensitivity and noise-system assumptions. No identified theorem supplies the F14 joint accuracy/expected-randomness/efficiency guarantees or randomness lower bound.

### L-F14-constant-parameters

Determine whether the logarithmic randomness lower bound persists at constant privacy/failure parameters.

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F14: Directions for Future Work, PDF page 8](https://drops.dagstuhl.de/storage/00lipics/lipics-vol325-itcs2025/LIPIcs.ITCS.2025.27/LIPIcs.ITCS.2025.27.pdf); extraction lines 341–344; explicit question.
- Related formalization: [https://github.com/leanprover/SampCert/blob/a2c53bb5ff790e729e252958060699b7eff898b9/SampCert/DifferentialPrivacy/Queries/Count/Properties.lean](https://github.com/leanprover/SampCert/blob/a2c53bb5ff790e729e252958060699b7eff898b9/SampCert/DifferentialPrivacy/Queries/Count/Properties.lean). Private count/noised-query privacy under sensitivity and noise-system assumptions. No identified theorem supplies the F14 joint accuracy/expected-randomness/efficiency guarantees or randomness lower bound.

### L-F14-efficient

Construct polynomial-time low-randomness mechanisms for private counting queries.

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: later parameterized answer in primary literature.
- [F14: Directions for Future Work, PDF page 8](https://drops.dagstuhl.de/storage/00lipics/lipics-vol325-itcs2025/LIPIcs.ITCS.2025.27/LIPIcs.ITCS.2025.27.pdf); extraction lines 345–352; explicit question.
- [F18: Introduction: efficient-construction question and parameterized answer](https://arxiv.org/html/2510.16959v1); extraction lines 55–100; later parameterized answer.
- Later evidence: [Introduction; main theorem (extraction lines 55–100)](https://arxiv.org/html/2510.16959v1). Provides polynomial-time mechanisms with a closely related randomness/accuracy tradeoff, including O(log d + log polylog(d/epsilon)) expected bits in the displayed regime. This is progress on efficiency; it does not supply logarithmic randomness at near-optimal accuracy for every parameter.
- Related formalization: [https://github.com/leanprover/SampCert/blob/a2c53bb5ff790e729e252958060699b7eff898b9/SampCert/DifferentialPrivacy/Queries/Count/Properties.lean](https://github.com/leanprover/SampCert/blob/a2c53bb5ff790e729e252958060699b7eff898b9/SampCert/DifferentialPrivacy/Queries/Count/Properties.lean). Private count/noised-query privacy under sensitivity and noise-system assumptions. No identified theorem supplies the F14 joint accuracy/expected-randomness/efficiency guarantees or randomness lower bound.

### L-F14-other-releases

Extend randomness-complexity analysis to other statistical releases.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F14: Directions for Future Work, PDF page 8](https://drops.dagstuhl.de/storage/00lipics/lipics-vol325-itcs2025/LIPIcs.ITCS.2025.27/LIPIcs.ITCS.2025.27.pdf); extraction lines 353–356; explicit question.
- Related formalization: [https://github.com/leanprover/SampCert/blob/a2c53bb5ff790e729e252958060699b7eff898b9/SampCert/DifferentialPrivacy/Queries/Count/Properties.lean](https://github.com/leanprover/SampCert/blob/a2c53bb5ff790e729e252958060699b7eff898b9/SampCert/DifferentialPrivacy/Queries/Count/Properties.lean). Private count/noised-query privacy under sensitivity and noise-system assumptions. No identified theorem supplies the F14 joint accuracy/expected-randomness/efficiency guarantees or randomness lower bound.

### L-F14-replicability-links

Develop connections between privacy randomness and replicable algorithms.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F14: Directions for Future Work, PDF page 8](https://drops.dagstuhl.de/storage/00lipics/lipics-vol325-itcs2025/LIPIcs.ITCS.2025.27/LIPIcs.ITCS.2025.27.pdf); extraction lines 357–358; explicit question.
- Related formalization: [https://github.com/leanprover/SampCert/blob/a2c53bb5ff790e729e252958060699b7eff898b9/SampCert/DifferentialPrivacy/Queries/Count/Properties.lean](https://github.com/leanprover/SampCert/blob/a2c53bb5ff790e729e252958060699b7eff898b9/SampCert/DifferentialPrivacy/Queries/Count/Properties.lean). Private count/noised-query privacy under sensitivity and noise-system assumptions. No identified theorem supplies the F14 joint accuracy/expected-randomness/efficiency guarantees or randomness lower bound.

### L-F16-higher-counts

Extend Fourier/additive-energy formulas to higher cycles and absorbing sets.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F16: Section 6](https://arxiv.org/html/2607.13666v1); extraction lines 467–469; explicit question.
- Related, not merged: L-P09-structured.

### L-F16-stopping-bound

Find QC-GHP parameters for which the paper’s spectral stopping-set bound is nonvacuous.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F16: Section 6](https://arxiv.org/html/2607.13666v1); extraction lines 470–471; explicit question.
- Related, not merged: L-P09-structured.

### L-F16-other-absorbing

Derive explicit (4,2) and (4,0) elementary absorbing-set counts in the stated QC-GHP setting.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F16: Section 6](https://arxiv.org/html/2607.13666v1); extraction lines 472–473; explicit question.
- Related, not merged: L-P09-structured.

### L-F19-distance

Determine useful minimum-distance upper bounds for the noncommuting polynomial-lift family.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F19: End of Section III.B / Section V](https://arxiv.org/html/2610.03341v1); extraction lines 215–216; explicit question.

### L-F19-Dickson

Explore closed families of permutation polynomials such as Dickson polynomials.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F19: End of Section III.B / Section V](https://arxiv.org/html/2610.03341v1); extraction lines 307–308; explicit question.

### L-F19-quantum

Extend the permutation-polynomial construction to quantum LDPC codes.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction or formulation request; outside the mathematical-target denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F19: End of Section III.B / Section V](https://arxiv.org/html/2610.03341v1); extraction lines 309–309; explicit question.

### L-P34-girth-eight

Characterize sufficient base-matrix conditions ensuring girth eight for the specified lifted-product Tanner graphs.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retain definitions and regimes at the cited locator.
- Proof-assistant statement: verified lean statement. Lean statement: verified lean statement. Lean proof: verified complete lean proof.
- Source-described status: open as stated in source; current resolution: proved in lean for recorded statement.
- Verified artifact: [CyclicLift.matrixTanner_hX_girth_characterization](../formalization/cyclic-lifts/README.md); Complete necessary-and-sufficient girth-eight criterion for the P34 X Tanner graph with at least two rows and columns, all entries circulant permutation blocks, and positive finite lift size. Arbitrary exponents; no normalization or connectedness assumption. Every distinct rectangle voltage must be nonzero, and every distinct-row/column hexagon voltage must be nonzero; equivalently a compatibility condition on pairs of 2x2 rectangles. General simple eight-cycle supplies the upper bound. Other graph-property/decoding optimization targets remain separate..
- [P34: Section 5 after Theorem 5.1](https://arxiv.org/html/2606.11987v1); extraction lines 331–332; explicit question.
- Related, not merged: L-P09-structured.
- Related formalization: [https://github.com/LeanPool/lean-pool/blob/1a4fed6d89aa7b28fac75a3c29f750a83236a246/LeanPool/QECCertificates/GF2/LiftedProduct.lean](https://github.com/LeanPool/lean-pool/blob/1a4fed6d89aa7b28fac75a3c29f750a83236a246/LeanPool/QECCertificates/GF2/LiftedProduct.lean). Related lifted-product matrix definitions and CSS orthogonality (lp_orthogonal, lp2_orthogonal). No Tanner-girth-eight characterization or absorbing-set classification in this file. Source inspected; not built or axiom-audited.
- Related formalization: [https://github.com/alectionary/vibe-math/blob/master/formalization/dyadic-rank/CyclicLift/GirthCharacterization.lean](https://github.com/alectionary/vibe-math/blob/master/formalization/dyadic-rank/CyclicLift/GirthCharacterization.lean). This project proves a general simple eight-cycle and exact native girth-eight iff nonzero rectangle/hexagon sums, including a 2x2-rectangle-only formulation and the expanded binary-matrix theorem. Scope: X construction, at least two rows and columns, all permutation blocks; positive modulus for the source finite model.

### L-P34-decoding-effects

Analyze how girth-eight conditions affect other graph properties relevant for decoding.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction lacks a fixed criterion or complete theorem statement; excluded from the denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P34: Section 5 concluding question](https://arxiv.org/html/2606.11987v1); extraction lines 332–332; concluding direction.
- Related formalization: [https://github.com/LeanPool/lean-pool/blob/1a4fed6d89aa7b28fac75a3c29f750a83236a246/LeanPool/QECCertificates/GF2/LiftedProduct.lean](https://github.com/LeanPool/lean-pool/blob/1a4fed6d89aa7b28fac75a3c29f750a83236a246/LeanPool/QECCertificates/GF2/LiftedProduct.lean). Related lifted-product matrix definitions and CSS orthogonality (lp_orthogonal, lp2_orthogonal). No Tanner-girth-eight characterization or absorbing-set classification in this file. Source inspected; not built or axiom-audited.

### L-P34-logical-partitions

Translate the cited row/column partition conditions for low-weight logical operators into Tanner-graph properties.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction lacks a fixed criterion or complete theorem statement; excluded from the denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P34: Conclusion](https://arxiv.org/html/2606.11987v1); extraction lines 334–334; concluding direction.
- Related formalization: [https://github.com/LeanPool/lean-pool/blob/1a4fed6d89aa7b28fac75a3c29f750a83236a246/LeanPool/QECCertificates/GF2/LiftedProduct.lean](https://github.com/LeanPool/lean-pool/blob/1a4fed6d89aa7b28fac75a3c29f750a83236a246/LeanPool/QECCertificates/GF2/LiftedProduct.lean). Related lifted-product matrix definitions and CSS orthogonality (lp_orthogonal, lp2_orthogonal). No Tanner-girth-eight characterization or absorbing-set classification in this file. Source inspected; not built or axiom-audited.

### L-P34-base-design

Choose base-matrix entries to optimize Tanner-graph properties for iterative decoding.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction lacks a fixed criterion or complete theorem statement; excluded from the denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [P34: Conclusion](https://arxiv.org/html/2606.11987v1); extraction lines 334–334; concluding direction.
- Related formalization: [https://github.com/LeanPool/lean-pool/blob/1a4fed6d89aa7b28fac75a3c29f750a83236a246/LeanPool/QECCertificates/GF2/LiftedProduct.lean](https://github.com/LeanPool/lean-pool/blob/1a4fed6d89aa7b28fac75a3c29f750a83236a246/LeanPool/QECCertificates/GF2/LiftedProduct.lean). Related lifted-product matrix definitions and CSS orthogonality (lp_orthogonal, lp2_orthogonal). No Tanner-girth-eight characterization or absorbing-set classification in this file. Source inspected; not built or axiom-audited.

### L-F23-Q2.4

Does some total or partial concept class have strictly different list-replicability numbers at two accuracies 0 < epsilon1 < epsilon2 < 1/2?

- Type: mathematical question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retain definitions and regimes at the cited locator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F23: Question 2.4](https://arxiv.org/html/2606.06148v1); extraction lines 191–193; explicit question.

### L-F23-Q2.5

Determine the margin/accuracy parameter regimes for which the list-replicability number of d-dimensional large-margin halfspaces equals d.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retain definitions and regimes at the cited locator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F23: Question 2.5](https://arxiv.org/html/2606.06148v1); extraction lines 194–197; explicit question.

### L-F23-Q2.6

For the dimension d in the source setting, can varying margin and accuracy realize every integer list size from ceil(d/2)+1 through d?

- Type: mathematical question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retain definitions and regimes at the cited locator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F23: Question 2.6](https://arxiv.org/html/2606.06148v1); extraction lines 198–199; explicit question.

### L-F24-C1.15

Every finite N-by-M sign matrix has list-replicability number O(log N log M), with a universal implicit constant.

- Type: conjecture; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retain definitions and regimes at the cited locator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: later weaker bound in primary literature.
- [F24: Conjecture 1.15](https://arxiv.org/html/2606.18236v1); extraction lines 328–331; explicit question.
- [F22: Introduction, discussion before Theorem 1.1](https://arxiv.org/html/2610.20657v1); extraction lines 49–59; conjecture recalled with weaker bound.
- Later evidence: [Theorem 1.1 and following paragraph](https://arxiv.org/html/2610.20657v1). O(log^2 M log N) upper bound; tighter O(log M log N) conjecture remains open. No quantitative sample bound or computational efficiency guarantee.

### L-F24-P1.16-LR

Is list replicability of arbitrary finite concept classes bounded by a function of VC dimension alone?

- Type: mathematical question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retain definitions and regimes at the cited locator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F24: Problem 1.16, list-replicability part](https://arxiv.org/html/2606.18236v1); extraction lines 332–337; explicit question.

### L-F24-P1.16-index

Is the Z2-index of arbitrary finite concept classes bounded by a function of VC dimension alone?

- Type: mathematical question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retain definitions and regimes at the cited locator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F24: Problem 1.16, index part](https://arxiv.org/html/2606.18236v1); extraction lines 332–337; explicit question.
