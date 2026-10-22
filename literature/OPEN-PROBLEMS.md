# Expanded open-problem inventory

Checked October 21, 2026. [Searchable inventory](open-problems.html) · [Machine-readable entries](open-problems.json) · [Paper coverage](downstream-paper-coverage.json) · [Prior literature follow-up](README.md) · [Lean difficulty estimates](../planning/LEAN-DIFFICULTY.md).

The inventory now contains **114 canonical entries**: the original 40 dissertation targets and **74 additional article entries**. Of the additions, **35 are specific mathematical questions or tasks suitable for coverage tracking**; the other 39 are research directions, formulation requests, or requests for different proof methods. These categories are kept visible rather than combined into a theorem count.

## Counts and formalization evidence

| Measure | Count |
| --- | ---: |
| Original dissertation targets, including one held target | 40 |
| Additional article targets in the coverage denominator | 35 |
| Additional directions/formulation/method entries outside the denominator | 39 |
| Combined eligible targets | 74 = 39 + 35 |
| Eligible targets with an identified, verified proof-assistant statement | 1/74 (1.35%) |
| Eligible targets with an identified, verified Lean statement | 1/74 (1.35%) |
| Eligible targets with a complete checked Lean proof | 1/74 (1.35%) |
| Eligible targets with checked finite cases, without a complete proof | 0/74 |
| Articles/preprints in scope | 31 |
| Full-text sources screened, including withdrawn history | 30/31 |
| Current-publication full texts screened | 29 |
| Withdrawn historical manuscripts screened | 1 |
| Not fully assessed | 1/31 |

**Current artifact coverage includes our [dyadic rank theorem](../formalization/dyadic-rank/README.md): a general Lean statement and a complete checked proof of that target by direct induction.** Search results without an artifact do not establish global absence. In particular, this is principally a Lean discovery audit; Coq, Isabelle, and other proof assistants were not systematically searched. The original search pass found no exact target artifacts; the later dyadic formalization is recorded separately with build and axiom evidence. L-P11-rank-converse now has a complete Lean proof of the recorded statement. Current mathematical resolution is not independently certified for every other entry: “open” describes how the cited source presents the target.

The historical Leray–Hopf uniqueness entry is held: later primary literature reports nonuniqueness, and the source’s domain/forcing/solution class must be fixed before a current comparison. Its entry links the later report. A related public Lean repository concerns forced smooth breakdown, not weak uniqueness; it was not built here.

A precise mathematical statement in a paper is conventional mathematical formulation, not proof-assistant formalization. A Lean statement can exist without a proof, for example with `sorry` or an axiom. A checked proof requires matching objects, quantifiers, hypotheses, a successful build, and scrutiny of its axioms; an unrelated theorem with the same terminology does not qualify.

**Related Lean report:** F01’s authors report using Lean 4 to verify an explicit multi-scale secluded-partition construction. That is an established construction in the article, **not one of its four remaining open targets**. No matching public artifact was identified, built or axiom-audited here. The report therefore contributes zero verified open-target statements/proofs. [Primary disclosure](https://arxiv.org/html/2609.02880v1) · [Structured mechanization evidence](downstream-mechanization.json).

## What is counted

The unit is a mathematical question, task, or explicitly labeled direction, not every sentence containing “open.” Completed targets remain in the denominator so coverage continues to track the original source-posed problems. Parameterized families count once. Question 6.3 in P04 counts once despite containing two bounds; the two independent parts of P27 Question 2.4 count separately. The union-complete case of P02 Question 7.1 is additional; its intersection-complete case is linked to the dissertation target. Method requests in P15 remain separate from conjectures about unknown truth.

Repeated targets share one canonical ID with multiple source occurrences. Related but different systems, hypotheses, or invariants retain different IDs and explicit related-target links. In particular, P01 changes the invariants in the held Geraci question; calmed rotational NSE is distinct from calmed velocity–vorticity; and two-dimensional Ohmic-heating MHD–Boussinesq is distinct from three-dimensional MHD. Local existence and global well-posedness are distinct obligations and are related in the ledger. No logical independence of the counted problems is claimed.

This article set includes predecessor versions and overlapping publications as well as genuinely later papers. “Additional” means newly inventoried, not newly posed after the dissertation. Dates and author relationships remain in [the bibliography](papers.json). No new exhaustive forward-citation census is claimed by this extension.

## Source coverage and gaps

A full-text screen searched headings, explicit conjectures/questions, future-work passages and conclusion sections, then read their surrounding context. It is not a line-by-line correctness review or a guarantee that every implicit question was extracted. Full-text counts of zero mean “no additional explicit target recorded in this screen”; unavailable text has a null count, never zero. Two talk records from the earlier follow-up are outside the 31-article denominator.

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

## Reproducible evidence and limits

Primary HTML/PDF retrievals and public full-text transcriptions, content hashes and ignored local extraction paths are recorded in [the source manifest](downstream-source-manifest.json). Each occurrence supplies a numbered question/section or PDF page, plus local extracted-text line ranges where available. These line ranges belong to our extraction, not arXiv HTML line numbers. P28/F02 transcription line n corresponds to line L(n-1) of the public web source. The manifest states the hash scope and retains earlier retrieval records. Full source files remain local and are not redistributed in this repository.

The added search ran 44 lexical queries across four previously pinned Lean source trees, respecting the sparse checkout scope recorded in [audit sources](../audit/sources.json), plus eight GitHub indexed-code queries (limit 30 hits each). The dyadic/rank query reached the limit, so its results are explicitly incomplete. Candidate files were inspected for mathematical subject mismatches; no exact new target was established. A file retrieval failure is recorded, not interpreted as absence. Weighted Horace background, dyadic local algebra, topological absorbing sets, and primitive-set saturation games do not match the targets here. [Local searches](downstream-lean-searches.json) · [GitHub searches](downstream-github-searches.json) · [Candidate retrievals](downstream-lean-candidates.json) · [Comparison notes](downstream-search-review.json).

The original 39 targets retain the earlier audit’s search evidence. New rows use family-level discovery and source-context comparisons, not an exhaustive search over all public declarations or alternate terminology. The recovered texts received eight supplementary pinned-source queries, recorded in [gap-specific Lean discovery](coverage-gap-lean-searches.json); no matching artifact was identified. P20 questions are historical, and a related graph-radius conjecture is not a matching algorithmic result. A public matching Lean artifact would change the corresponding status only after a semantic and build/axiom audit.

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
