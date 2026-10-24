# Expanded open-problem inventory

Checked October 24, 2026. [Searchable inventory](open-problems.html) · [Machine-readable entries](open-problems.json) · [Paper coverage](downstream-paper-coverage.json) · [Prior literature follow-up](README.md) · [Lean difficulty estimates](../planning/LEAN-DIFFICULTY.md).

The inventory now contains **287 canonical entries**: the original 40 dissertation targets and **247 additional article entries**. Of the additions, **104 are specific mathematical questions or tasks suitable for coverage tracking**; the other 143 are research directions, formulation or method requests, and held statements with counterexamples. These categories are kept visible rather than combined into a theorem count.

The [research reconciliation](RESEARCH-RECONCILIATION.md) connects later trajectory work and [80 indexed research sources](RESEARCH-SOURCES.md). The original reconciliation added six source-posed questions/directions from two papers. A separate Beezer final-journal screen now adds one precise conjecture and two broad directions; their current-resolution, Lean discovery and difficulty assessments are explicitly unassessed. The [paper-by-paper absorbing-set screen](RESEARCH-QUESTION-SCREENING.md) additionally records every encountered source, question contribution and access gap. Five project-derived follow-ups remain attached to P34 rather than being counted as additional author-posed problems. The earlier fixed cohort retains 3/108 complete proofs; the current cohort has 5/143 after completion of the existing F16 target. The Beezer cohort and subsequent question-screen extensions retain explicit separate deltas.

## Counts and formalization evidence

| Measure | Count |
| --- | ---: |
| Original dissertation targets, including one held target | 40 |
| Additional article targets in the coverage denominator | 104 |
| Additional directions/formulation/method entries outside the denominator | 143 |
| Combined eligible targets | 143 = 39 + 104 |
| Eligible targets with an identified, verified proof-assistant statement | 5/143 (3.50%) |
| Eligible targets with an identified, verified Lean statement | 5/143 (3.50%) |
| Eligible targets with a complete checked Lean proof | 5/143 (3.50%) |
| Additional targets with checked supporting proofs and a written source bridge | 0/143 |
| Eligible targets with only finite-case proofs (no general supporting proof) | 0/143 |
| Additional identified Lean statements without a build audit | 1/143 |
| Eligible targets with Lean discovery still unassessed in this extension | 35/143 |
| Articles/preprints in scope | 114 |
| Full-text sources screened, including withdrawn history | 101/114 |
| Current-publication full texts screened | 100 |
| Withdrawn historical manuscripts screened | 1 |
| Not fully assessed | 13/114 |

**Current artifact coverage includes the [dyadic rank theorem](../formalization/dyadic-rank/README.md), the [general P34 girth-eight characterization](../formalization/cyclic-lifts/README.md), the [literal P11 forbidden-set completeness proof](../formalization/dyadic-forbidden/APPENDIX-ENUMERATION.md), and the [incidence-corrected F16 four-variable counts and source obstruction](../formalization/absorbing-four-zero/README.txt), each with a matching statement, successful build and axiom audit.** Search results without an artifact do not establish global absence. In particular, this is principally a Lean discovery audit; Coq, Isabelle, and other proof assistants were not systematically searched. The original search pass found no exact target artifacts; the later dyadic formalization is recorded separately with build and axiom evidence. L-P11-rank-converse, L-P34-girth-eight, L-P11-forbidden and L-F16-other-absorbing now have complete Lean proofs of their recorded statements, within the explicit artifact scopes. Current mathematical resolution is not independently certified for every other entry: “open” describes how the cited source presents the target.

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
| [F25](https://arxiv.org/html/2503.07567v1) | relevant sections screened | 3 | Related external work reached through the P34 investigation, not seed-author coauthorship. Relevant sections screened; no exhaustive full-paper question extraction or current-resolution/Lean search for the new questions is claimed. |
| [F26](https://arxiv.org/html/2604.27817v3) | relevant sections screened | 3 | Related external work reached through the P34 investigation, not seed-author coauthorship. Relevant sections screened; no exhaustive full-paper question extraction or current-resolution/Lean search for the new questions is claimed. |
| [F27](https://doi.org/10.1006/jcta.2001.3185) | current publication full text screened | 3 | Full final17-page journal read. One conjecture and two broad directions indexed; historical Erdos question is resolved and is not added as currently open. Regular-graph subcase shares the conjecture ID. |
| [F28](https://arxiv.org/html/2012.15297v2) | current publication full text screened | 5 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F29](https://people.eecs.berkeley.edu/~bora/Journals/2010/IT-10.pdf) | current publication full text screened | 1 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F30](https://arxiv.org/html/1208.6094v2) | current publication full text screened | 1 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F31](https://arxiv.org/html/1308.1259v1) | current publication full text screened | 0 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F32](https://arxiv.org/html/1510.04954v1) | current publication full text screened | 0 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F33](https://publica.fraunhofer.de/entities/publication/888e2ff4-57e9-467a-a9c6-c7db59f38de4) | full text unavailable | Not assessed | Question screen of the explicitly identified accessible version; later-version limits are in the audit. Failed/empty responses and abstract-only pages do not count as screened full texts. Earlier acquisition routes remain in the frozen source-comparison ledgers. |
| [F34](https://arxiv.org/html/2605.13690v1) | current publication full text screened | 6 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F35](https://doi.org/10.1186/s13638-023-02273-0) | current publication full text screened | 2 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F36](https://ietresearch.onlinelibrary.wiley.com/doi/pdf/10.1049/cmu2.12762) | full text unavailable | Not assessed | Question screen of the explicitly identified accessible version; later-version limits are in the audit. Failed/empty responses and abstract-only pages do not count as screened full texts. Earlier acquisition routes remain in the frozen source-comparison ledgers. |
| [F37](https://perso.etis-lab.fr/declercq/PDF/ConferencePapers/Shadi_2010_ITA.pdf) | current publication full text screened | 0 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F38](https://arxiv.org/html/1905.13228v1) | current publication full text screened | 2 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F39](https://arxiv.org/html/2605.14173v1) | current publication full text screened | 4 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F40](https://grannell.net/Papers/smallbasis.pdf) | current publication full text screened | 3 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F41](https://onlinelibrary.wiley.com/doi/10.1002/jcd.21839) | current publication full text screened | 2 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F42](https://arxiv.org/html/2608.11516v1) | current publication full text screened | 3 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F43](https://arxiv.org/html/2008.01322v1) | current publication full text screened | 0 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F44](https://arxiv.org/html/1803.08141v1) | current publication full text screened | 0 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F45](https://arxiv.org/html/2307.02737v1) | current publication full text screened | 0 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F46](https://arxiv.org/html/2503.01341v1) | current publication full text screened | 0 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F47](https://arxiv.org/html/2604.12332v1) | current publication full text screened | 0 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F48](https://arxiv.org/html/2609.20030v1) | current publication full text screened | 1 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F49](https://arxiv.org/pdf/1309.5587v2) | current publication full text screened | 6 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F50](https://doi.org/10.1002/j.1538-7305.1963.tb04003.x) | current publication full text screened | 1 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F51](https://userpages.cs.umbc.edu/lomonaco/f06/653/handouts/MacWilliams-Pless-Identities.pdf) | current publication full text screened | 0 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F52](https://www.kurims.kyoto-u.ac.jp/~kyodo/kokyuroku/contents/pdf/1889-05.pdf) | current publication full text screened | 3 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F53](https://annals.math.princeton.edu/2024/200-3/p04) | current publication full text screened | 4 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F54](https://doi.org/10.1007/s00373-016-1681-3) | current publication full text screened | 0 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. Both the full publisher HTML and the 2014 arXiv preprint were available. Introductory configuration questions are addressed by the paper, not new future-work targets. |
| [F55](https://arxiv.org/abs/2104.04880v2) | current publication full text screened | 2 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F56](https://arxiv.org/abs/1002.4311) | current publication full text screened | 0 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F57](https://www.seas.ucla.edu/csl/files/publications/JiadongWang_ITA2011.pdf) | current publication full text screened | 0 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F58](https://digitalcommons.unl.edu/mathfacpub/171/) | full text unavailable | Not assessed | Question screen of the explicitly identified accessible version; later-version limits are in the audit. Failed/empty responses and abstract-only pages do not count as screened full texts. Earlier acquisition routes remain in the frozen source-comparison ledgers. |
| [F59](https://www.vde-verlag.de/proceedings-en/442947110.html) | full text unavailable | Not assessed | Question screen of the explicitly identified accessible version; later-version limits are in the audit. Failed/empty responses and abstract-only pages do not count as screened full texts. Earlier acquisition routes remain in the frozen source-comparison ledgers. |
| [F60](https://experts.arizona.edu/en/publications/quasicyclic-low-density-parity-check-codes/) | full text unavailable | Not assessed | Question screen of the explicitly identified accessible version; later-version limits are in the audit. Failed/empty responses and abstract-only pages do not count as screened full texts. Earlier acquisition routes remain in the frozen source-comparison ledgers. |
| [F61](https://combinatorialpress.com/jcmcc-articles/volume-040/the-girth-of-a-design/) | current publication full text screened | 7 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. Image-only 17-page journal PDF recovered. OCR searched; printed p111/PDF15 visually checked. Generator girth is distinct from density girth. |
| [F62](https://doi.org/10.26493/2590-9770.1564.2b8) | current publication full text screened | 1 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F63](https://doi.org/10.1109/TIT.2004.828066) | full text unavailable | Not assessed | Question screen of the explicitly identified accessible version; later-version limits are in the audit. Failed/empty responses and abstract-only pages do not count as screened full texts. Earlier acquisition routes remain in the frozen source-comparison ledgers. |
| [F64](https://doi.org/10.1145/3821162.3821166) | full text unavailable | Not assessed | Question screen of the explicitly identified accessible version; later-version limits are in the audit. Failed/empty responses and abstract-only pages do not count as screened full texts. Earlier acquisition routes remain in the frozen source-comparison ledgers. |
| [F65](https://arxiv.org/abs/2402.17856v1) | current publication full text screened | 2 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F66](https://arxiv.org/abs/2202.05088v4) | current publication full text screened | 10 | Question screen of the explicitly identified accessible version; later-version limits are in the audit. The inspected preprint is not a completed audit of every later journal revision. |
| [F67](https://hal.usc.edu/chugg/docs/pubs/zhu2007bounds.pdf) | current publication full text screened | 1 | December 2007 journal version; DOI 10.1109/TIT.2007.909127; current question resolution is not inferred from historical wording. |
| [F68](https://citeseerx.ist.psu.edu/document?doi=b467ba3c3d8d22c34667c1006a7e09e71cfe1bbf&repid=rep1&type=pdf) | current publication full text screened | 3 | Inspected manuscript dated July 26, 2000; 2001 journal version not inspected; current question resolution is not inferred from historical wording. |
| [F69](https://arxiv.org/abs/1904.02703v3) | current publication full text screened | 1 | arXiv:1904.02703v3, November 12, 2021; Quantum 5,585; current question resolution is not inferred from historical wording. |
| [F70](https://arxiv.org/abs/2202.13641v3) | current publication full text screened | 5 | arXiv:2202.13641v3, September 16, 2022; PDF dated September 19; current question resolution is not inferred from historical wording. |
| [F71](https://doi.org/10.1006/jnth.1996.0109) | not fully assessed | Not assessed | Publisher abstract available through web; direct HTML is an anti-bot response. No readable full original was recovered. The source paper attributes the asymptotic biregular lower bound to this work; its full hypotheses and question screen remain a gap. |
| [F72](https://doi.org/10.1006/eujc.1996.0040) | not fully assessed | Not assessed | Author-uploaded paper body is web-indexed. Inspected introduction, Section4 and keyword hits restricted to the paper body; no additional explicit target found there. Original PDF download and complete local original snapshot failed, so the archival full-text screen and total question count remain unassessed. The normalized snapshot hash is not a PDF hash. |
| [F73](https://arxiv.org/abs/2504.21845v2) | current publication full text screened | 1 | arXiv:2504.21845v2,29May2025; first preprint30April2025; historical directions do not establish current-open status. |
| [F74](https://swh.princeton.edu/~kulkarni/Papers/Journals/j069_2009_WangKulPoo_TranIT.pdf) | current publication full text screened | 3 | IEEE TIT55(5),1976–1999,May2009; current version22April2009; DOI10.1109/TIT.2009.2015993; historical directions do not establish current-open status. |
| [F75](https://arxiv.org/abs/2412.08817v1) | current publication full text screened | 1 | arXiv:2412.08817v1,11December2024; historical directions do not establish current-open status. |
| [F76](https://doi.org/10.1109/ISIT62367.2026.11654127) | not fully assessed | Not assessed | Author conference page confirms the ISIT2026 title/authors. DOI full text was inaccessible; a secondary abstract describes stabilizer and horizontal/vertical stopping probabilities for ordinary HGP codes. Full theorem hypotheses and question screen remain unassessed; no zero-question or exact B1 claim. |
| [F77](https://www.ece.mcmaster.ca/~schwam10/publications/MSjrnl6.pdf) | full text screened | 10 | March2006 journal, pp.922-932; received17March2005, revised9December2005; preprint23March2005; full accessible main text screened, including later same-paper answers; named supplementary/version gaps retained in dedicated ledger. |
| [F78](https://arxiv.org/abs/2203.17216v1) | full text screened | 7 | v1 submitted31March2022; PDF internally dated1April2022; full accessible main text screened, including later same-paper answers; named supplementary/version gaps retained in dedicated ledger. |
| [F79](https://doi.org/10.1038/s41534-026-01212-3) | full text screened | 2 | Article-in-press main PDF; accepted23February2026; published13March2026; version-of-record29April2026 metadata; first preprint20November2024; full accessible main text screened, including later same-paper answers; named supplementary/version gaps retained in dedicated ledger. |
| [F80](https://ece.iisc.ac.in/~nkashyap/Papers/stopsets.pdf) | full text screened | 1 | Author manuscript reports original compositionSeptember2003 and ISIT2003 presentation; inspected undated revised web PDF; full accessible main text screened, including later same-paper answers; named supplementary/version gaps retained in dedicated ledger. |

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
- **F40 — Discussion, preprint p11, Added in Proof:** The proposed five-line mitre/mia basis is explicitly confirmed in the same paper’s addendum; not an open addition.
- **F40 — Discussion, preprint p12; Beezer2002 Section3, printed p101:** The proposed Erdos-configuration-only generating set is explicitly reported false in Beezer2002. It is not the full-generator minimality conjecture.
- **F61 — Question1.1 and Section2 (density-girth and anti-Pasch spectrum):** Historical Erdos density-girth existence question is resolved by Kwan–Sah–Sawhney–Simkin Theorem1.1. The anti-Pasch spectrum was resolved in2000, as recorded by Fujiwara2014 Theorem3.10. Neither resolution settles Section7 Question1 about generator girth7.
- **F53 — Section1.3, higher-uniformity suggestion:** Delcourt–Postle2024 Theorem1.6 proves the stated high-girth Steiner-system existence generalization. Recorded as later resolved, not added as currently open.
- **F53 — Section1.3, Latin-square suggestion:** Kwan–Sah–Sawhney–Simkin arXiv2202.05088v4 Theorem1.4 proves arbitrarily high-girth Latin-square existence. Their other enumerative conjectures are indexed separately.
- **F65 — Conjectures1.1,1.3,1.5 and Theorems1.2,1.4,1.6:** The named existence conjectures are explicitly proved or cited as proved in this paper; only its Section8 remaining questions are added.
- **F50 — Introduction and final paragraph:** The introductory spectrum/dual-spectrum questions motivate the identity proved in the paper. Only the explicitly proposed broader computer-study program is retained, outside the coverage denominator.
- **F54 — Introduction and principal complete-graph representation/count theorems:** Introductory questions describe the problem answered in the article; no additional explicit unresolved target was identified in the screened publisher HTML and preprint.
- **F34 — AppendixK.2 and K.7:** TheoremK.2 is presented as a conditional theorem. Its own hypotheses are not silently dropped or promoted into an extra open integrality conjecture. The broader ConjectureK.3 is indexed with the scope warning.

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
- Related, not merged: L-F28-correlated-noncss-trapping.

### L-P09-structured

Classify absorbing sets in structured QLDPC codes, including hypergraph-product codes with circulant base matrices.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Statement must be read with the definitions and hypotheses at the source locator.
- Proof-assistant statement: no exact statement identified in bounded search. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open or proposed in source; current resolution: not independently established.
- [P09: Section VI](https://arxiv.org/html/2307.14532); extraction lines 505–505; explicit open problem.
- Related, not merged: L-F28-quantum-trapping-enumeration.
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
- Empirical follow-up: [fixed code all iterations min sum obstruction proved with bounded trajectory census](../formalization/dyadic-performance/README.md). Forbidden-set completeness remains a separate completed target. Objective comparisons give conditional gains. The fixed-code trajectory follow-up proves an all-iterations integer min-sum obstruction for pair {0,17} in an optimized [[32,8,4]] instance. Across the two representative profiles, symmetry-forced pair failures decrease while other syndrome and logical failures increase, so this is a partial structural explanation rather than a complete performance theory.
- Bounded follow-up: [objective disagreements, exact ambiguity decomposition and supporting Lean lemmas](../formalization/dyadic-performance/TARGETED.md); research direction remains open. Five general ambiguity lemmas and twelve concrete decoder-trajectory lemmas, including all-iterations failure for one frozen P11 instance; not completion of the full source research direction.
- Decoder trajectories: [concrete all-iterations Lean obstruction and fixed-code census](../formalization/dyadic-performance/TRAJECTORIES.md); partial structural explanation, no completed source target added.
- [P11: Section 7](https://arxiv.org/html/2605.01942); extraction lines 554–554; explicit open problem.

### L-P11-forbidden

Are the paper’s forbidden sets complete for length-six and length-eight pathologies?

- Type: conjecture or question; written formulation: precise math in source.
- Coverage denominator: included. Recorded scope is Definition 4.20 cumulative cycle/girth completeness at thresholds six/eight, with missing blocks omitted as in Remark 4.21. The literal ordered appendix-pattern enumeration, its half-sum arithmetic and its correspondence to the native expanded Tanner graph are now checked in Lean. This does not assert author-software identity, exact-count coefficients or elimination of all decoding pathologies.
- Proof-assistant statement: verified lean statement. Lean statement: verified lean statement. Lean proof: verified complete lean proof.
- Source-described status: open or proposed in source; current resolution: proved in lean for recorded cycle contract.
- Verified artifact: [DyadicForbidden.Appendix.appendixForbiddenCheck_spec](../formalization/dyadic-forbidden/README.md); Complete source-specific cumulative cycle-forbidden criterion at thresholds six/eight (also four): single dyadic permutation per occupied cell, arbitrary finite row/column dimensions and every nonnegative bit-vector fiber dimension. Literal printed 21 eight-step classes and all 42 half-path sums, one rectangle/hexagon class, ordered embeddings on used row names, missing blocks and preexisting cycles. Equality to the original checker and the actual expanded binary Tanner graph. No minimum-four-row or lower-girth hypothesis; no exact-count or decoder/PEG optimality claim..
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
- Scope comparison: Our cyclic single-input LP degree-three structural proofs do not resolve this distinct QC-GHP/GB Fourier-count or spectral-bound target.
- Research sources: [central source index](RESEARCH-SOURCES.md).
- [F16: Section 6](https://arxiv.org/html/2607.13666v1); extraction lines 467–469; explicit question.
- Related, not merged: L-P09-structured, L-P34-decoding-effects.

### L-F16-stopping-bound

Find QC-GHP parameters for which the paper’s spectral stopping-set bound is nonvacuous.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: verified lean statement. Lean proof: verified complete lean proof.
- Source-described status: open as stated in source; current resolution: answered negatively for prop51 useful parameter question.
- **Parameter question: answered negatively by universal checked nonexistence proof.** The original useful-parameter question is answered negatively for every positive-dimensional binary biregular choice in Proposition5.1 stated scalar-factor model. A useful incidence-conditioned replacement is now proved. The broader spectral-refinement direction has a proved same-Gram obstruction on explicit families and remains unassessed outside that scope; no universal disproof is claimed. Raw spectral-gap feasibility alone has dense positive examples.
- **Incidence replacement answered positively:** [reusable two-block bound, sparse nontrivial CSS families and a restricted Gram obstruction](../formalization/stopping-bound/stronger/RESEARCH-NOTE.txt). The motivating spectral-refinement direction is broad. A useful incidence replacement now exists; an unrestricted claim that all stronger spectral bounds are impossible is not made.
- Verified artifact: [StoppingSpectral.no_parameters_give_source_improvement](../formalization/stopping-bound/source-answer/README.txt); Universal negative answer to the original useful-parameter question in the source model; all positive row-block counts, actual expanded binary matrices and original roots. Separate stronger replacement bound remains open..
- Supporting Lean artifact (not full target coverage): [checked scope](../formalization/stopping-bound/RESEARCH-NOTE.txt). Checked for the exact r₂=n₂=1 scalar-factor QC-GHP form with positive integral column weight and positive base dimensions: r₁≥2 cannot satisfy σ₂²<γ/2; r₁=1 can satisfy it only at row/column density>3/4, and then 1<a+≤2 while a−<2. The exact source-matrix and stopping-set bridges are checked. Dense raw-condition examples exist. Stronger spectral bounds and general two-factor/nonabelian constructions are outside this result.
- Scope comparison: Universal negative answer for the useful-parameter question of Proposition5.1 in its stated positive-dimensional binary biregular scalar-factor model: no choice can simultaneously satisfy sigma2^2<gamma/2 and source large root>2. Section3.2 explicitly uses r2=n2=1 throughout, and Proposition5.1 refers to the corresponding Theorem4.1 Fourier matrices. All positive row-block counts are covered. For r>=2 the gap is impossible; for r=1 it forces density>3/4, roots1<a+<=2 and a-<2. Every stopping support has cardinality>=2, so the small branch is excluded but the large-root guarantee is redundant. Dense raw-gap examples exist. A stronger replacement bound remains open as a separate component. Completed project-derived follow-ups establish exact stopping distance six for the positive63-multiple B1 cover family and classify all441 size-six base supports as unique companion Z-check rows; these are distinct incidence results, not the negative parameter proof. No logical-distance claim.
- Research sources: [central source index](RESEARCH-SOURCES.md).
- Research progress: [Finite scalar-factor spectral obstruction and stopping-root non-improvement](../formalization/stopping-bound/RESEARCH-NOTE.txt) (general lean proof). Checked for the exact r₂=n₂=1 scalar-factor QC-GHP form with positive integral column weight and positive base dimensions: r₁≥2 cannot satisfy σ₂²<γ/2; r₁=1 can satisfy it only at row/column density>3/4, and then 1<a+≤2 while a−<2. The exact source-matrix and stopping-set bridges are checked. Dense raw-condition examples exist. Stronger spectral bounds and general two-factor/nonabelian constructions are outside this result.
  - [Complete Lean source](../formalization/stopping-bound/Spectral.lean).
  - [Complete Lean source](../formalization/stopping-bound/Audit.lean).
- Research progress: [Exact incidence-aware stopping distance six in the positive63-multiple B1 check family](../formalization/stopping-bound/incidence/RESEARCH-NOTE.txt) (checked lean proof). Incidence-aware restricted follow-up: exact stopping distance six for A=x^27 I_7+S_7+x^54 S_7^2 and b=1+x+x^6 at every positive lift length divisible by63. Includes generic extension-search soundness, two-root certificate, both cyclic symmetries, cover projection/local-injectivity, source-matrix and CSS bridges. No quantum logical-distance or rate claim; no parameters satisfying Proposition5.1 are produced.
  - [Complete Lean source](../formalization/stopping-bound/incidence/IncidenceFamily.lean).
  - [Complete Lean source](../formalization/stopping-bound/incidence/IncidenceSpectral.lean).
- Research progress: [Complete classification of all441 minimum stopping supports of source B1](../formalization/stopping-bound/classification/RESEARCH-NOTE.txt) (checked lean proof). Complete base-B1 minimum-support classification: all size-six stopping supports of the exact 882-column source H_X are precisely the 441 distinct companion H_Z row supports, in a single free Z/7 x Z/63 coordinate-translation orbit. Includes exhaustive-search soundness, kernel certificate, unique center, count and actual binary source bridge. No classification for larger covers or logical-distance claim.
  - [Complete Lean source](../formalization/stopping-bound/classification/Classification.lean).
  - [Complete Lean source](../formalization/stopping-bound/classification/ClassificationCertificate.lean).
- Research progress: [Universal negative answer to the Proposition5.1 useful-parameter question](../formalization/stopping-bound/source-answer/RESEARCH-NOTE.txt) (checked lean proof). No positive-dimensional binary biregular scalar-factor parameter choice gives a source large root above two under the strict spectral inequality. All-cases theorem also checks every stopping support and the separate small-branch exclusion; source scope corrected directly against §3.2.
  - [Complete Lean source](../formalization/stopping-bound/source-answer/SourceQuestionAnswer.lean).
  - [Complete Lean source](../formalization/stopping-bound/source-answer/dependencies/Spectral.lean).
- Research progress: [Publication compliance audit and explicit dense source-construction bridge](../formalization/stopping-bound/SKILL-COMPLIANCE-AUDIT.md) (checked lean proof and documentary audit). Corrected all3 papers with complete full branch/immutable URLs for42 Lean/audit files,32 exact/range chronology milestones, actual proof excerpts and dependency guides; checked the previously prose-only source-circulant/reindexing bridge for the dense example (20 declarations). No new source question or canonical completion.
  - [Complete Lean source](../formalization/stopping-bound/source-answer/DenseSourceBridge.lean).
  - [Complete Lean source](../formalization/stopping-bound/source-answer/AuditDenseSourceBridge.lean).
- [F16: Section 6](https://arxiv.org/html/2607.13666v1); extraction lines 470–471; explicit question.
- Related, not merged: L-P09-structured, L-P34-decoding-effects.

### L-F16-other-absorbing

Derive explicit (4,2) and (4,0) elementary absorbing-set counts in the stated QC-GHP setting.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed target; retained in the source cohort if later answered.
- Proof-assistant statement: verified lean statement. Lean statement: verified lean statement. Lean proof: verified complete lean proof.
- Source-described status: open as stated in source; current resolution: proved in lean for incidence corrected counts and spectral only obstruction.
- Verified artifact: [AbsorbingFourCounts.explicit_cubic_cyclic_four_counts](../formalization/absorbing-four-zero/README.txt); For every positive cyclic lift size, cubic binary socket incidence with no Tanner four-cycles has explicit general standard-complex formulas for both (4,2) and (4,0), over actual unordered supports. Both classifications, absorbing conditions, local root incidence corrections, multiplicities4/24, cyclic normalization, full rectangular evaluated matrices, exponent sign and Euclidean norm/Parseval bridges are checked in Lean. The same-spectral-data-only interpretation is refuted: fully checked273-variable QC-GHP source models have equal full complex M_j at every frequency but (4,0) counts182/147. The earlier checked168-variable (4,2) obstruction is preserved. The full-incidence baseline also follows classically from weight-four kernel enumeration and MacWilliams identities; the MacWilliams transform itself is not newly formalized. Beezer generator reductions leave Pasch as an input. No mathematical or formalization-priority claim is established; named unavailable final/full texts remain comparison limits. Additional checked strengthening: actual140-variable(3,6)-regularQC-GHP incidence models have equal full complex M_j at every frequency but(4,0)counts77/105, via classical10_3Pasch extensions. The larger273-variablecheck-degree9pair remains a second consumer..
- Scope comparison: For every positive cyclic lift size, cubic binary socket incidence with no Tanner four-cycles has explicit general standard-complex formulas for both (4,2) and (4,0), over actual unordered supports. Both classifications, absorbing conditions, local root incidence corrections, multiplicities4/24, cyclic normalization, full rectangular evaluated matrices, exponent sign and Euclidean norm/Parseval bridges are checked in Lean. The same-spectral-data-only interpretation is refuted: fully checked273-variable QC-GHP source models have equal full complex M_j at every frequency but (4,0) counts182/147. The earlier checked168-variable (4,2) obstruction is preserved. The full-incidence baseline also follows classically from weight-four kernel enumeration and MacWilliams identities; the MacWilliams transform itself is not newly formalized. Beezer generator reductions leave Pasch as an input. No mathematical or formalization-priority claim is established; named unavailable final/full texts remain comparison limits. Additional checked strengthening: actual140-variable(3,6)-regularQC-GHP incidence models have equal full complex M_j at every frequency but(4,0)counts77/105, via classical10_3Pasch extensions. The larger273-variablecheck-degree9pair remains a second consumer.
- Research sources: [central source index](RESEARCH-SOURCES.md).
- Historical first-block snapshot (2026-10-23). Its standard-complex gap was closed by the follow-up below; the dated report and manifest are preserved. Historical snapshot: its unaddressed (4,0) component and Beezer access limit are updated by the subsequent (4,0) block; original files remain frozen.
- Research progress: [Incidence-corrected (4,2) formula and obstruction to M_j-only counts](../formalization/absorbing-four-two/RESEARCH-NOTE.txt) (general lean incidence cyclic and finite character fourier with written complex specialization and exact cases). The (4,2) component has an exact incidence-corrected general counting theorem with checked general Lean incidence, cyclic and finite-character Fourier proofs (the standard complex-exponential/norm specialization remains written). Identical M_j do not determine this count: matched connected [[168,6]] QC-GHP examples have 49 versus 35. The counts (including their source/literal index transfer), Gram and evaluated-frequency obstruction, modular completion model, and CSS commutation have checked Lean proofs; ranks and connectedness remain exact external computations. A smaller generalized-bicycle pair on 48 qubits with k=4 has equal scalar M_j but counts 192 versus 72; its shifted-reflection frequency identity is Lean checked, with exact independent subset counts. The companion (4,0) task is unaddressed, so the combined canonical target is not a complete Lean target. No earlier full-target answer was found in the recorded bounded search; priority remains unestablished.
  - [Complete Lean source](../formalization/absorbing-four-two/FourColumnClassification.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/GlobalCounting.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/OrderedRoots.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/PairEnergy.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/PairFormulaCore.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/FourCompletions.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/PairRootBridge.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/CyclicNormalization.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/FiniteFourier.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/SocketFourier.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/SocketIncidence.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/CyclicFourierCount.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/GramCounterexample12.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/FanoBlock.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/ProjectionObstruction.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/QuantumConstruction.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/HGPIncidence.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/HGPPatterns.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/HGPCounts.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/HGPGramObstruction.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/HGPCSS.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/HGPSpectral.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/SocketCompletion.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/CompletionBridge.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/IncidenceEquivalence.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/QuantumReindex.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/GBReflection.lean).
-  Historical snapshot: its unaddressed (4,0) component and Beezer access limit are updated by the subsequent (4,0) block; original files remain frozen.
- Research progress: [Standard complex-character bridge and classical literature reconciliation](../formalization/absorbing-four-two/followup-complex/RESEARCH-UPDATE.txt) (general lean standard complex fourier and concrete source matrix bridge with classical hypothesis audit). The (4,2) component now has general Lean proofs of the incidence correction, cyclic normalization and literal standard-complex Fourier formula, including character injectivity, exponent sign, ordinary rectangular matrix-vector multiplication and Euclidean norm. The hypotheses are column degree three and no four-cycles, for every positive lift size, including even/composite sizes and N=1. The actual 168-column source/literal matrices and complex evaluated M_j are connected to the same sockets: equal full M_j give counts 49 versus 35. Concrete ranks/connectivity retain their exact external-computation status. The complete STS special case was already counted in 1995, and modular shared-cycle avoidance and general ETS enumeration are prior work. Named inaccessible final/full texts remain unresolved comparisons, so priority is unestablished. The general (4,0) component is outside this block; the combined canonical target remains partial.
  - [Complete Lean source](../formalization/absorbing-four-two/followup-complex/ClassicalConfiguration.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/followup-complex/ClassicalDecomposability.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/followup-complex/ComplexCharacter.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/followup-complex/ComplexDFT.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/followup-complex/ComplexCyclicCount.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/followup-complex/ComplexMatrixCount.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/followup-complex/ComplexRootFormula.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/followup-complex/ComplexConsumer.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/followup-complex/ComplexQuantumSockets.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/followup-complex/ComplexQuantumWitness.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/followup-complex/ComplexQuantumFormula.lean).
  - [Complete Lean source](../formalization/absorbing-four-two/followup-complex/AbsorbingComplex.lean).
- Research progress: [Pasch/kernel translation, classical counting baseline and cyclic root-energy (4,0) follow-up](../formalization/absorbing-four-zero/RESEARCH-NOTE.txt) (general lean complete recorded counts and concrete source counterexample). For every positive cyclic lift size, cubic binary socket incidence with no Tanner four-cycles has explicit general standard-complex formulas for both (4,2) and (4,0), over actual unordered supports. Both classifications, absorbing conditions, local root incidence corrections, multiplicities4/24, cyclic normalization, full rectangular evaluated matrices, exponent sign and Euclidean norm/Parseval bridges are checked in Lean. The same-spectral-data-only interpretation is refuted: fully checked273-variable QC-GHP source models have equal full complex M_j at every frequency but (4,0) counts182/147. The earlier checked168-variable (4,2) obstruction is preserved. The full-incidence baseline also follows classically from weight-four kernel enumeration and MacWilliams identities; the MacWilliams transform itself is not newly formalized. Beezer generator reductions leave Pasch as an input. No mathematical or formalization-priority claim is established; named unavailable final/full texts remain comparison limits. Additional checked strengthening: actual140-variable(3,6)-regularQC-GHP incidence models have equal full complex M_j at every frequency but(4,0)counts77/105, via classical10_3Pasch extensions. The larger273-variablecheck-degree9pair remains a second consumer.
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschAbsorbingBridge.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschBeezerBridge.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschClassification.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschComplexCount.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschConsumers.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschCyclicCount.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschDesignData.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschGlobalCount.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschHGPCount.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschKernelCount.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschQuantumBridge.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschQuantumWitness40.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschReindex40.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschRootClassification.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschRootEnergy.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschSTS13.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschSTS13Counts.lean).
  - [Complete Lean source](../formalization/absorbing-four-zero/PaschCubicTrade.lean).
- Research progress: [Project-derived lift-label elimination, exact fixed-base assignment counts and CSS family](../formalization/lift-label-elimination/RESEARCH-NOTE.txt) (every manuscript proof has checked Lean version and independent exact finite checks). General voltage-cycle elimination is classical. Exact all-N raw-label and slice histograms, physical incidence/counting bridges, integer-certificate soundness, full scalar-right counts and the [[140q,18,6]] family for every q>=2 now have checked Lean versions for every manuscript proof. The all-declaration axiom audit and independent exact q2 checks are recorded. No priority, decoder-performance, general gauge-orbit or canonical coverage increment is claimed.
  - [Complete Lean source](../formalization/lift-label-elimination/BinaryDistance.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/BinarySupportEquiv.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/ConcreteElimination.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/CountRepresentatives.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/CoverCounting.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/CycleData.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/CycleKernelBridge.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/CyclicCSSCommute.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/CyclicRecurrence.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/EventHistogram.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/FamilyGraphs.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/FamilyLogical.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/FamilyPauliDistance.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/FamilyRank.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/FamilyTheorem.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/FanoCarryCertificate.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/FanoObstruction.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/FiniteEventArithmetic.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/FinitePaschRepresentatives.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/FullGraphCounts.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/GraphMatrices.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/HistogramPolynomials.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/IntegerKernel.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/JointCertificates.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/JointCycleData.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/JointElimination.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/JointLabelCount.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/KernelFourBridge.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/LabelEncoding.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/LabelHistograms.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/LiteralLabelCounts.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/LogicalWitness.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/NormalFormCount.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/OrientedKernel.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/PaschLiftCriterion.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/PaschLiftProjection.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/PaschReindex.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/PaschVoltage.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/PositiveLabelCounts.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/QCRegularity.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/QCSectorElimination.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/QCSupportCount.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/RankFromKernel.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/ScalarIncidence.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/ScalarTranspose.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/ScalarWeight.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/SparseCSS.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/SparseCSSMatrices.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/SparseRowDegrees.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/SparseTranspose.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/StarCertificates.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/StarCheckKernel.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/StarDuality.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/StarElimination.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/StarKernelCertificate.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/StarVoltageData.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/StructuredKernel.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/SumCounting.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/SupportVoltageCount.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/TriangleGaugeCertificates0.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/TriangleGaugeCertificates1.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/TriangleGaugeCertificates2.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/TriangleGaugeCertificates3.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/TriangleRawCertificates0.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/TriangleRawCertificates1.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/TriangleRawCertificates2.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/TriangleRawCertificates3.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/TriangleVoltageData.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/UnorderedSections.lean).
  - [Complete Lean source](../formalization/lift-label-elimination/VoltageQCIncidence.lean).
- [F16: Section 6](https://arxiv.org/html/2607.13666v1); extraction lines 472–473; explicit question.
- Related, not merged: L-P09-structured, L-P34-decoding-effects.
- Related formalization: [https://github.com/pefch-k/lean-coding-theory-macwilliams-identity/tree/8848ddeeff36408d9b6f13f229a82d568c006424](https://github.com/pefch-k/lean-coding-theory-macwilliams-identity/tree/8848ddeeff36408d9b6f13f229a82d568c006424). Related binary MacWilliams weight-enumerator theorem found in a two-file public Lean source tree. Both files statically inspected; not built/axiom-audited here. No absorbing/Pasch/cyclic-source translation in that tree. See formalization/absorbing-four-zero/social-prior-art.json for exact scope.

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
- Research sources: [central source index](RESEARCH-SOURCES.md).
- [P34: Section 5 after Theorem 5.1](https://arxiv.org/html/2606.11987v1); extraction lines 331–332; explicit question.
- Related, not merged: L-P09-structured.
- Later evidence: [Fossorier (2004), Equations (3)-(5), Theorem 2.1](https://doi.org/10.1109/TIT.2004.831841). Classical short-cycle criterion; notation translation checked in the comparison consumer.
- Later evidence: [Raveendran-Declercq-Vasic (2025), Section III-B, p.5, after Equation (20)](https://arxiv.org/html/2503.07567v1). Direct predecessor for the LP eight-cycle cancellation; also origin paper reference [9].
- Later evidence: [Okada-Kasai (2026), Lemma 3 and Theorem 5](https://arxiv.org/html/2604.27817v1). Matching support argument and projected cycle, with different binary-base/CSS-lift hypotheses.
- Later evidence: [Revised manuscript Section 2 and the exact-equivalence audit](https://github.com/alectionary/vibe-math/blob/f0e967b/formalization/cyclic-lifts/paper/main.tex). Full theorem compared rather than components alone; later trajectory milestones have separate contributions and pinned Lean links.
- Related formalization: [https://github.com/LeanPool/lean-pool/blob/1a4fed6d89aa7b28fac75a3c29f750a83236a246/LeanPool/QECCertificates/GF2/LiftedProduct.lean](https://github.com/LeanPool/lean-pool/blob/1a4fed6d89aa7b28fac75a3c29f750a83236a246/LeanPool/QECCertificates/GF2/LiftedProduct.lean). Related lifted-product matrix definitions and CSS orthogonality (lp_orthogonal, lp2_orthogonal). No Tanner-girth-eight characterization or absorbing-set classification in this file. Source inspected; not built or axiom-audited.
- Related formalization: [https://github.com/alectionary/vibe-math/blob/master/formalization/dyadic-rank/CyclicLift/GirthCharacterization.lean](https://github.com/alectionary/vibe-math/blob/master/formalization/dyadic-rank/CyclicLift/GirthCharacterization.lean). This project proves a general simple eight-cycle and exact native girth-eight iff nonzero rectangle/hexagon sums, including a 2x2-rectangle-only formulation and the expanded binary-matrix theorem. Scope: X construction, at least two rows and columns, all permutation blocks; positive modulus for the source finite model.

### L-P34-decoding-effects

Analyze how girth-eight conditions affect other graph properties relevant for decoding.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction lacks a fixed criterion or complete theorem statement; excluded from the denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: partially addressed by project.
- Empirical follow-up: [exact distances and fresh distance matched comparison completed for saved codes](../formalization/cyclic-lifts/DISTANCE-MATCHED.md). Exact distances of the four saved codes are 6,10,12,10. The two [[252,10,10]] codes have fresh primary FER 2.731% versus 2.709%; paired 95% interval includes zero. Exact minimum-distance matching is achieved for this comparison, not a causal isolation of absorbing count or universal objective ranking.
- Supporting Lean artifact (not full target coverage): [checked scope](../formalization/cyclic-lifts/LOW-WEIGHT-LOGICALS.md). Concrete same-local-topology/different-logical-role theorem, including full companion-span nonmembership. Does not complete the broader research direction.
- Research sources: [central source index](RESEARCH-SOURCES.md).
- Research progress: [Exact-distance matched replication](../formalization/cyclic-lifts/MILLION-PAIRED.md) (sampled experiment). One million fresh paired errors distinguish two exact [[252,10,10]] codes under the fixed decoder; no isolated absorbing-count cause.
- Research progress: [Same-code degree/girth-preserving intervention](../formalization/cyclic-lifts/DEGREE-PRESERVING.md) (written proof and exact finite computation). Merging disjoint checks changes absorbing counts while retaining the code, variable degrees and girth; check degrees and routing change.
- Research progress: [Fresh same-code performance comparison](../formalization/cyclic-lifts/MERGED-MILLION.md) (sampled experiment). One million fresh paired errors per code show deterioration under the fixed merger; losses and rescues are separately recorded.
- Research progress: [Local message obstruction](../formalization/cyclic-lifts/MERGED-MECHANISM.md) (general lean lemmas and concrete certificates). Checked merger identity, sign/attenuation classification, matrix-kernel equality and local acceptance obstructions.
  - [Complete Lean source](../formalization/dyadic-rank/CyclicMergedMessages.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicMergedWitnesses.lean).
- Research progress: [Frozen persistence holdout and complete stopping comparisons](../formalization/cyclic-lifts/LOOP-HOLDOUT.md) (general lean lemmas concrete trajectories and independent holdout). Finite persistence certificates plus two full from-prior comparisons; pinned-check net explanatory contributions are 1/721 and 86/986, so aggregate explanation remains partial.
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderPersistence.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderParity.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderReachability.lean).
- Research progress: [Entry and propagation continuation](../formalization/cyclic-lifts/ENTRY-DYNAMICS.md) (general lean lemmas concrete trajectories and independent holdout). Exact onset, possible-influence cones, soft-only/delayed examples and channel moments; new confirmation partitions 451/985 and 571/1210 descriptively, not causally.
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderEntryInitial.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderEntryCone.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderEntryExamples.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderEntryDelayed.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderEntryChannel.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderEntryBias.lean).
- Project-derived follow-up, outside the source-target denominator: **RQ-P34-aggregate-entry** — Explain the remaining net representation-dependent decoding deterioration through early, reachable message mechanisms. partial; exact examples and onset/propagation proofs exist, aggregate mechanism remains incomplete.
- Project-derived follow-up, outside the source-target denominator: **RQ-P34-count-causality** — Isolate the effect of absorbing-set count from check degrees, routing and logical structure. open; existing interventions identify representation effects, not count alone.
- Project-derived follow-up, outside the source-target denominator: **RQ-P34-early-predictor** — Find an early failure predictor with independent holdout performance beyond baseline error hardness. partial; initial-activity associations weaken under hardness controls; late tubes certify persistence.
- Project-derived follow-up, outside the source-target denominator: **RQ-P34-objective-ranking** — Identify when cycle-only, absorbing-only or joint objectives predict superior decoding. open; no universally superior objective established.
- Project-derived follow-up, outside the source-target denominator: **RQ-P34-error-floor** — Derive a quantitative error-floor predictor for the stated model from structural and dynamical properties. open; finite inventories and experiments do not supply a general law.
- [P34: Section 5 concluding question](https://arxiv.org/html/2606.11987v1); extraction lines 332–332; concluding direction.
- Related, not merged: L-F26-replicated-comparisons.
- Related formalization: [https://github.com/LeanPool/lean-pool/blob/1a4fed6d89aa7b28fac75a3c29f750a83236a246/LeanPool/QECCertificates/GF2/LiftedProduct.lean](https://github.com/LeanPool/lean-pool/blob/1a4fed6d89aa7b28fac75a3c29f750a83236a246/LeanPool/QECCertificates/GF2/LiftedProduct.lean). Related lifted-product matrix definitions and CSS orthogonality (lp_orthogonal, lp2_orthogonal). No Tanner-girth-eight characterization or absorbing-set classification in this file. Source inspected; not built or axiom-audited.

### L-P34-logical-partitions

Translate the cited row/column partition conditions for low-weight logical operators into Tanner-graph properties.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction lacks a fixed criterion or complete theorem statement; excluded from the denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: partially addressed by project.
- Empirical follow-up: [exact distances and fresh distance matched comparison completed for saved codes](../formalization/cyclic-lifts/DISTANCE-MATCHED.md). Exact distances of the four saved codes are 6,10,12,10. The two [[252,10,10]] codes have fresh primary FER 2.731% versus 2.709%; paired 95% interval includes zero. Exact minimum-distance matching is achieved for this comparison, not a causal isolation of absorbing count or universal objective ranking.
- Supporting Lean artifact (not full target coverage): [checked scope](../formalization/cyclic-lifts/LOW-WEIGHT-LOGICALS.md). Concrete same-local-topology/different-logical-role theorem, including full companion-span nonmembership. Does not complete the broader research direction.
- Research sources: [central source index](RESEARCH-SOURCES.md).
- Research progress: [Exact-distance matched replication](../formalization/cyclic-lifts/MILLION-PAIRED.md) (sampled experiment). One million fresh paired errors distinguish two exact [[252,10,10]] codes under the fixed decoder; no isolated absorbing-count cause.
- [P34: Conclusion](https://arxiv.org/html/2606.11987v1); extraction lines 334–334; concluding direction.
- Related, not merged: L-F25-distance-preservation, L-F26-exact-distance.
- Related formalization: [https://github.com/LeanPool/lean-pool/blob/1a4fed6d89aa7b28fac75a3c29f750a83236a246/LeanPool/QECCertificates/GF2/LiftedProduct.lean](https://github.com/LeanPool/lean-pool/blob/1a4fed6d89aa7b28fac75a3c29f750a83236a246/LeanPool/QECCertificates/GF2/LiftedProduct.lean). Related lifted-product matrix definitions and CSS orthogonality (lp_orthogonal, lp2_orthogonal). No Tanner-girth-eight characterization or absorbing-set classification in this file. Source inspected; not built or axiom-audited.

### L-P34-base-design

Choose base-matrix entries to optimize Tanner-graph properties for iterative decoding.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Direction lacks a fixed criterion or complete theorem statement; excluded from the denominator.
- Proof-assistant statement: not systematically searched beyond lean. Lean statement: no exact statement identified. Lean proof: no exact proof identified.
- Source-described status: open as stated in source; current resolution: partially addressed by project.
- Empirical follow-up: [exact distances and fresh distance matched comparison completed for saved codes](../formalization/cyclic-lifts/DISTANCE-MATCHED.md). Exact distances of the four saved codes are 6,10,12,10. The two [[252,10,10]] codes have fresh primary FER 2.731% versus 2.709%; paired 95% interval includes zero. Exact minimum-distance matching is achieved for this comparison, not a causal isolation of absorbing count or universal objective ranking.
- Supporting Lean artifact (not full target coverage): [checked scope](../formalization/cyclic-lifts/LOW-WEIGHT-LOGICALS.md). Concrete same-local-topology/different-logical-role theorem, including full companion-span nonmembership. Does not complete the broader research direction.
- Research sources: [central source index](RESEARCH-SOURCES.md).
- Research progress: [Exact-distance matched replication](../formalization/cyclic-lifts/MILLION-PAIRED.md) (sampled experiment). One million fresh paired errors distinguish two exact [[252,10,10]] codes under the fixed decoder; no isolated absorbing-count cause.
- Research progress: [Same-code degree/girth-preserving intervention](../formalization/cyclic-lifts/DEGREE-PRESERVING.md) (written proof and exact finite computation). Merging disjoint checks changes absorbing counts while retaining the code, variable degrees and girth; check degrees and routing change.
- Research progress: [Fresh same-code performance comparison](../formalization/cyclic-lifts/MERGED-MILLION.md) (sampled experiment). One million fresh paired errors per code show deterioration under the fixed merger; losses and rescues are separately recorded.
- Research progress: [Local message obstruction](../formalization/cyclic-lifts/MERGED-MECHANISM.md) (general lean lemmas and concrete certificates). Checked merger identity, sign/attenuation classification, matrix-kernel equality and local acceptance obstructions.
  - [Complete Lean source](../formalization/dyadic-rank/CyclicMergedMessages.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicMergedWitnesses.lean).
- Research progress: [Frozen persistence holdout and complete stopping comparisons](../formalization/cyclic-lifts/LOOP-HOLDOUT.md) (general lean lemmas concrete trajectories and independent holdout). Finite persistence certificates plus two full from-prior comparisons; pinned-check net explanatory contributions are 1/721 and 86/986, so aggregate explanation remains partial.
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderPersistence.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderParity.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderReachability.lean).
- Research progress: [Entry and propagation continuation](../formalization/cyclic-lifts/ENTRY-DYNAMICS.md) (general lean lemmas concrete trajectories and independent holdout). Exact onset, possible-influence cones, soft-only/delayed examples and channel moments; new confirmation partitions 451/985 and 571/1210 descriptively, not causally.
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderEntryInitial.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderEntryCone.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderEntryExamples.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderEntryDelayed.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderEntryChannel.lean).
  - [Complete Lean source](../formalization/dyadic-rank/CyclicDecoderEntryBias.lean).
- Project-derived follow-up, outside the source-target denominator: **RQ-P34-aggregate-entry** — Explain the remaining net representation-dependent decoding deterioration through early, reachable message mechanisms. partial; exact examples and onset/propagation proofs exist, aggregate mechanism remains incomplete.
- Project-derived follow-up, outside the source-target denominator: **RQ-P34-count-causality** — Isolate the effect of absorbing-set count from check degrees, routing and logical structure. open; existing interventions identify representation effects, not count alone.
- Project-derived follow-up, outside the source-target denominator: **RQ-P34-early-predictor** — Find an early failure predictor with independent holdout performance beyond baseline error hardness. partial; initial-activity associations weaken under hardness controls; late tubes certify persistence.
- Project-derived follow-up, outside the source-target denominator: **RQ-P34-objective-ranking** — Identify when cycle-only, absorbing-only or joint objectives predict superior decoding. open; no universally superior objective established.
- Project-derived follow-up, outside the source-target denominator: **RQ-P34-error-floor** — Derive a quantitative error-floor predictor for the stated model from structural and dynamical properties. open; finite inventories and experiments do not supply a general law.
- [P34: Conclusion](https://arxiv.org/html/2606.11987v1); extraction lines 334–334; concluding direction.
- Related, not merged: L-F25-distance-preservation, L-F25-general-protographs, L-F25-hardware-entries, L-F26-logical-qubit-lifts.
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

### L-F25-distance-preservation

Find sufficient base-matrix constraints ensuring equality of the quantum and classical minimum distances in the stated type-I LP construction.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed distance or construction target; retain the model and fixed-instance definitions at the cited locator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F25: Section VI, next-step and structured-code distance-preservation directions](https://arxiv.org/html/2503.07567v1); extraction lines 6829–6838; explicit future work target.
- Related, not merged: L-P34-logical-partitions, L-P34-base-design.

### L-F25-general-protographs

Extend the type-I LP distance and problematic-structure analysis to more general protographs.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad source-posed research direction; no fixed complete theorem or experiment is specified, so excluded from the denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F25: Section II-A and Section VI](https://arxiv.org/html/2503.07567v1); extraction lines 6838–6838; explicit future work target.
- Related, not merged: L-P34-base-design.

### L-F25-hardware-entries

Investigate circulant-entry choices that ease hardware constraints.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad source-posed research direction; no fixed complete theorem or experiment is specified, so excluded from the denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F25: Section VI, final future-work sentence](https://arxiv.org/html/2503.07567v1); extraction lines 6838–6838; explicit future work target.
- Related, not merged: L-P34-base-design.

### L-F26-exact-distance

Determine the exact X/Z quantum distances of the fixed randomized P=64 lift of B15, currently certified between 18 and 192 in the source.

- Type: specific distance problem; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed distance or construction target; retain the model and fixed-instance definitions at the cited locator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F26: Section 7 limitations and Section 8](https://arxiv.org/html/2604.27817v3); extraction lines 5286–5286; explicit future work target.
- Related, not merged: L-P34-logical-partitions.

### L-F26-logical-qubit-lifts

Construct connected CSS-preserving CPM lifts with additional nonconstant left-kernel vectors that increase logical-qubit count while retaining the targeted short-cycle constraints.

- Type: classification or construction; written formulation: precise math in source.
- Coverage denominator: included. Specific source-posed distance or construction target; retain the model and fixed-instance definitions at the cited locator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F26: Section 8, final future-work direction](https://arxiv.org/html/2604.27817v3); extraction lines 5358–5380; explicit future work target.
- Related, not merged: L-P34-base-design.

### L-F26-replicated-comparisons

Extend repair/decoder comparisons and replicated statistics across multiple lifted instances.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad source-posed research direction; no fixed complete theorem or experiment is specified, so excluded from the denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F26: Section 7 limitations and Section 8](https://arxiv.org/html/2604.27817v3); extraction lines 5358–5380; explicit future work target.
- Related, not merged: L-P34-decoding-effects.

### L-F27-generator-basis

For fixed t and k, prove that all generators on at most m blocks form a minimal generating set for m-line configurations in general t-(v,k,lambda) designs.

- Type: conjecture; written formulation: precise math in source.
- Coverage denominator: included. Precise source conjecture; current resolution and matching Lean discovery not yet assessed.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F27: Conjecture4.1 and following regular-graph special-case proposal, p351/PDF11](https://doi.org/10.1006/jcta.2001.3185); extraction lines 377–382; explicit conjecture.
- Related, not merged: L-F41-strict-full-basis.
- Later evidence: [Heinlein–Ostergard2022 Section2.2,Theorem7 and proof](https://onlinelibrary.wiley.com/doi/full/10.1002/jcd.21839). Restricted later progress: minimality of full-configuration counts for complete Steiner triple systems through eight lines, via a rank180 computation on623STS25. Not an all-t,k,m solution; exact current-resolution and Lean discovery for the full conjecture remain unassessed.

### L-F27-minimal-girth-designs

Determine minimum-order designs of fixed generator girth and investigate their structure.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad source direction requiring a bounded parameterized target; excluded from the theorem denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F27: Section7, Definition7.1 and design-cage direction, pp356–357/PDF16–17](https://doi.org/10.1006/jcta.2001.3185); extraction lines 617–635; explicit research direction.
- [F61: Section7, Question3, printed p111/PDF15; Definitions5.2–5.3](https://combinatorialpress.com/jcmcc-articles/volume-040/the-girth-of-a-design/); PDF pages 15; equivalent research direction.
- Related, not merged: L-F61-generator-girth7-sts, L-F61-asymptotic-generator-avoidance.

### L-F27-constant-configurations

Extend the configuration equations and classification of constant configurations to larger numbers of blocks.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad source direction requiring a bounded parameterized target; excluded from the theorem denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F27: Section6 concluding paragraph, p355/PDF15](https://doi.org/10.1006/jcta.2001.3185); extraction lines 549–575; explicit research direction.
- Related, not merged: L-F41-constant-sts-configurations.

### L-F29-ensemble-distributions

Determine asymptotic average distributions of absorbing and fully absorbing sets in LDPC ensembles.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F29: Section IV, conclusion, printed p195 / PDF15](https://people.eecs.berkeley.edu/~bora/Journals/2010/IT-10.pdf); PDF pages 15; explicit research direction.

### L-F30-ccm-other-structures

Extend the cycle-consistency-matrix method to other graphical structures, including trapping sets.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F30: Conclusion, PDF21](https://arxiv.org/html/1208.6094v2); PDF pages 21; explicit research direction.

### L-F38-extra-cycle-information

Determine what additional information beyond spectrum and degree sequences permits counting cycles of length at least twice the girth.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F38: Section VI, concluding remarks](https://arxiv.org/html/1905.13228v1); PDF pages 21; explicit research direction.

### L-F38-switching-trapping-sets

Determine how Godsil–McKay switching changes trapping-set distributions and whether it can reduce harmful trapping-set multiplicities.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F38: Section VI, concluding remarks](https://arxiv.org/html/1905.13228v1); PDF pages 21; explicit research direction.

### L-F34-asymptotic-statistical-extension

Extend the WidthWall theory beyond fixed-size noiseless hypergraphs, including asymptotic regimes, sample complexity and noisy or evolving inputs.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F34: Sections 6–7, conclusion and limitations](https://arxiv.org/html/2605.13690v1); PDF pages 9, 10; explicit research direction.

### L-F34-approximation-gap

Characterize the approximation gap of finite-template Sinkhorn models in terms of template budget J, temperature tau and target-invariant hypertree width.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F34: Appendix G, final paragraph / PDF27](https://arxiv.org/html/2605.13690v1); PDF pages 26, 27; explicit research direction.

### L-F34-sinkhorn-gap-bound

Conjecture K.3: for k-uniform templates P on v vertices and ||A||_F <= B_A, bound gap_SK(P;A) by C_k (delta(P)-1) v^(k-2) B_A, with C_k depending only on k.

- Type: conjecture; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F34: Appendix K.3, Conjecture K.3 / PDF31](https://arxiv.org/html/2605.13690v1); PDF pages 31; explicit conjecture.

### L-F34-gap-versus-width

Question K.4: is sup_{||A||_F<=1} gap_SK(P;A) bounded by a function only of generalized hypertree width; does width one imply exactness, and can large width force positive gaps?

- Type: specific question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F34: Appendix K.3, Question K.4 / PDF31](https://arxiv.org/html/2605.13690v1); PDF pages 31; explicit question.

### L-F34-hodge-width-threshold

Conjecture K.6: determine the minimum pattern-width level needed to approximate the Hodge spectral gap, including the proposed width-two bounded-degree threshold and accuracy dependence.

- Type: conjecture; written formulation: formulation requires scope check.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F34: Appendix K.6, Conjecture K.6 / PDF32](https://arxiv.org/html/2605.13690v1); PDF pages 32; explicit conjecture.

### L-F34-sts13-hodge-test

Do the two STS(13) examples in Appendix F.1 have different smallest nonzero Hodge 1-Laplacian eigenvalues, so that they separate the proposed Hodge-gap invariant?

- Type: specific question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F34: Appendix K.7, stress test 4 / PDF33](https://arxiv.org/html/2605.13690v1); PDF pages 33; explicit question.

### L-F35-sliding-window-harmful-objects

Analyze the high-SNR harmful structures specific to sliding-window decoding of QC-SC codes, including error propagation, and tailor MIHAO to them.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F35: Section 4.2, discussion of Figure 1](https://doi.org/10.1186/s13638-023-02273-0); extraction lines 260–260; explicit research direction.

### L-F35-alternative-base-performance

Analyze the performance of optimized QC-SC codes obtained from the alternative girth-eight QC-LDPC base constructions identified by the authors.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F35: Section 4.2, final paragraph](https://doi.org/10.1186/s13638-023-02273-0); extraction lines 275–275; explicit research direction.

### L-F39-ub-distance

Obtain tighter minimum-distance analysis for the proposed univariate bicycle code construction.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F39: Conclusion, PDF5](https://arxiv.org/html/2605.14173v1); PDF pages 5; explicit research direction.

### L-F39-beyond-divisor

Extend the univariate bicycle construction beyond the divisor setting used in the paper.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F39: Conclusion, PDF5](https://arxiv.org/html/2605.14173v1); PDF pages 5; explicit research direction.

### L-F39-ub-decoding

Develop improved decoding methods tailored to univariate bicycle codes.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F39: Conclusion, PDF5](https://arxiv.org/html/2605.14173v1); PDF pages 5; explicit research direction.

### L-F39-ub-logical-gates

Use the explicit logical structure of univariate bicycle codes for systematic logical-gate constructions and hardware-aware design.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F39: Conclusion, PDF5](https://arxiv.org/html/2605.14173v1); PDF pages 5; explicit research direction.

### L-F40-maxi-pasch

For admissible v not of the form 2^n-1, determine the maximum number of Pasch configurations in an STS(v) and construct systems attaining it.

- Type: specific question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F40: Discussion, preprint p10](https://grannell.net/Papers/smallbasis.pdf); PDF pages 10; explicit question.

### L-F40-maximal-partial-bases

Develop configuration-counting relations for maximal partial Steiner triple systems and compare them with the complete-STS relations.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F40: Discussion, preprint pp10–11](https://grannell.net/Papers/smallbasis.pdf); PDF pages 10, 11; explicit research direction.

### L-F40-lambda-triple-bases

Extend the configuration-counting basis investigation to triple systems TS(v,lambda) of general index.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F40: Discussion, preprint p11](https://grannell.net/Papers/smallbasis.pdf); PDF pages 11; explicit research direction.

### L-F41-constant-sts-configurations

Give a complete characterization of configurations whose number of occurrences in an STS(v) depends only on v.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F41: Section 2.1, printed p529](https://onlinelibrary.wiley.com/doi/10.1002/jcd.21839); PDF pages 4; explicit research direction.
- Related, not merged: L-F27-constant-configurations.

### L-F41-strict-full-basis

For every n, are all full m-line configurations with m<=n necessary for determining all n-line STS configuration counts, as in Theorem 4?

- Type: conjecture; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F41: Section 2.2, strictness discussion following Theorem 6, printed p532](https://onlinelibrary.wiley.com/doi/10.1002/jcd.21839); PDF pages 7, 8; explicit conjecture.
- Related, not merged: L-F27-generator-basis.

### L-F52-general-even-freeness-bounds

Find nontrivial upper bounds and existence results for high even-freeness of Steiner 2-designs S(2,mu,v) for general large block size mu.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F52: Section 3, discussion preceding Theorem 3.11 / printed p38](https://www.kurims.kyoto-u.ac.jp/~kyodo/kokyuroku/contents/pdf/1889-05.pdf); PDF pages 6, 7; explicit research direction.
- [F49: SectionIII-B, discussion before Theorem3.11 / PDF8](https://arxiv.org/pdf/1309.5587v2); PDF pages 8; same research direction.

### L-F52-new-even-free-constructions

Find constructions of highly even-free Steiner 2-designs beyond the finite-geometric and recursive constructions described in the survey.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F52: Section 3, paragraph following Theorem 3.13 / printed p39](https://www.kurims.kyoto-u.ac.jp/~kyodo/kokyuroku/contents/pdf/1889-05.pdf); PDF pages 7; explicit research direction.
- [F49: SectionIII-B, discussion after the finite-geometric constructions / PDF9](https://arxiv.org/pdf/1309.5587v2); PDF pages 9; same source question.

### L-F49-relative-substructure-harm

Determine the relative harmfulness of parity-check substructures for sum-product decoding over a binary symmetric channel.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F49: Section III-B, structural-design discussion / PDF6](https://arxiv.org/pdf/1309.5587v2); PDF pages 6; explicit research direction.

### L-F49-auxiliary-budget

Determine appropriate auxiliary-qubit or ebit budgets and the break-even point against alternative coding schemes as auxiliary-qubit reliability and cost vary.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F49: Section IV, final discussion / PDF15](https://arxiv.org/pdf/1309.5587v2); PDF pages 15; explicit research direction.

### L-F49-small-weight-degeneracy

Do all sufficiently small-weight classical codewords in the quantum LDPC constructions considered correspond to undetectable nontrivial logical errors?

- Type: conjecture; written formulation: formulation requires scope check.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F49: Section V, unnumbered conjecture before Theorem 5.1 / PDF16](https://arxiv.org/pdf/1309.5587v2); PDF pages 16; explicit conjecture.

### L-F28-quantum-trapping-enumeration

Adapt expansion–contraction methods to quantum trapping sets, determine parent–child structure and relative harmfulness, and account for Tanner-neighborhood effects.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F28: Section 6, concluding discussion / PDF16](https://arxiv.org/html/2012.15297v2); PDF pages 16; explicit research direction.
- Related, not merged: L-P09-structured.

### L-F28-symmetric-stabilizer-enumeration

Enumerate symmetric stabilizers in QLDPC codes to exploit degeneracy in decoding.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F28: Section 6 / PDF16](https://arxiv.org/html/2012.15297v2); PDF pages 16; explicit research direction.

### L-F28-correlated-noncss-trapping

Extend quantum trapping-set definitions to correlated X/Z errors and general non-CSS stabilizer codes.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F28: Section 6 / PDF16](https://arxiv.org/html/2012.15297v2); PDF pages 16; explicit research direction.
- Related, not merged: L-P09-XZ.

### L-F28-degeneracy-low-complexity-decoding

Develop message-passing algorithms of lower complexity than BP that systematically exploit quantum-code degeneracy.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F28: Section 5, paragraph preceding Remark 5 / PDF15](https://arxiv.org/html/2012.15297v2); PDF pages 15; explicit research direction.

### L-F28-beyond-sqrt-distance-performance

Analyze finite-length performance of QLDPC codes exceeding square-root distance scaling using their quantum trapping-set enumeration.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F28: Section 6, final paragraph / PDF16](https://arxiv.org/html/2012.15297v2); PDF pages 16; explicit research direction.

### L-F42-ai-decoder-structures

Characterize harmful trapping structures for AI-based quantum decoders.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F42: Introduction / PDF2](https://arxiv.org/html/2608.11516v1); PDF pages 2; explicit research direction.

### L-F42-larger-dem-search

Determine whether small-LETS error-floor estimation remains sufficient and feasible for larger-distance circuit-level codes, and find structural subclasses enabling deeper search.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F42: Section VI, conclusions / PDFs14–15](https://arxiv.org/html/2608.11516v1); PDF pages 14, 15; explicit research direction.

### L-F42-dem-aware-decoding

Use the harmful-LETS catalog to design circuit-level decoders that suppress or escape the observed low-weight failure mechanisms.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F42: Section VI, final paragraph / PDF15](https://arxiv.org/html/2608.11516v1); PDF pages 15; explicit research direction.

### L-F48-haemers-spectrum

Are almost all finite simple graphs determined up to isomorphism by their adjacency spectrum?

- Type: conjecture; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F48: Introduction / PDF1, cited Haemers conjecture [26]](https://arxiv.org/html/2609.20030v1); PDF pages 1; cited conjecture.

### L-F55-moore-degree57

Does a Moore graph of degree 57 (equivalently SRG(3250,57,0,1)) exist?

- Type: specific question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F55: Section 3, Moore-graph construction](https://arxiv.org/abs/2104.04880v2); PDF pages 8; cited conjecture.

### L-F55-partial-geometry-664

Does a partial geometry pg(6,6,4) exist?

- Type: specific question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F55: Section 4, feasible-parameter discussion](https://arxiv.org/abs/2104.04880v2); PDF pages 16, 17; cited conjecture.

### L-F62-grid-free-sts

Does there exist a Steiner triple system STS(v), with v>=9, containing no grid configuration?

- Type: specific question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F62: Introduction, paragraph on six-line full configurations / PDF3](https://doi.org/10.26493/2590-9770.1564.2b8); PDF pages 3; explicit question.

### L-F61-generator-girth7-sts

Does there exist a Steiner triple system of generator girth exactly 7 in the sense of Definition 5.2?

- Type: specific question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F61: Section 7, Question 1, printed p111 / PDF15](https://combinatorialpress.com/jcmcc-articles/volume-040/the-girth-of-a-design/); PDF pages 15; explicit question.
- Related, not merged: L-F27-minimal-girth-designs.

### L-F61-other-design-girth5

Does any nontrivial design other than a regular graph or a Steiner triple system have generator girth at least 5?

- Type: specific question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F61: Section 7, Question 2, printed p111 / PDF15](https://combinatorialpress.com/jcmcc-articles/volume-040/the-girth-of-a-design/); PDF pages 15; explicit question.

### L-F61-design-to-graph-cages

Use design-cage methods to improve the construction or search for cages among regular graphs.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F61: Section 7, direction 4, printed p111 / PDF15](https://combinatorialpress.com/jcmcc-articles/volume-040/the-girth-of-a-design/); PDF pages 15; explicit research direction.

### L-F61-moore-designs

Develop a design-cage analogue of the Moore lower bound, recovering the graph bound, and investigate designs attaining it.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F61: Section 7, Question 5, printed p111 / PDF15](https://combinatorialpress.com/jcmcc-articles/volume-040/the-girth-of-a-design/); PDF pages 15; explicit research direction.

### L-F61-more-fundamental-generators

Find more fundamental configuration building blocks than generators, accounting for the shared cores obtained by removing degree-one vertices.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F61: Section 7, Question 6, printed p111 / PDF15](https://combinatorialpress.com/jcmcc-articles/volume-040/the-girth-of-a-design/); PDF pages 15; explicit research direction.

### L-F61-asymptotic-generator-avoidance

For fixed t,k,lambda,r, does a threshold exist above which every admissible order has a design avoiding all nontrivial generators with at most r blocks?

- Type: specific question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F61: Section 5, final paragraph, printed p104 / PDF8](https://combinatorialpress.com/jcmcc-articles/volume-040/the-girth-of-a-design/); PDF pages 8; explicit question.
- Related, not merged: L-F27-minimal-girth-designs.

### L-F53-counting-upper-bound

Is the lower bound of Theorem 1.3 for the number of labeled STSs of girth greater than g asymptotically sharp, with a matching leading exponential constant?

- Type: conjecture; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F53: Section 1.3, after Theorem 1.3 / PDF5](https://annals.math.princeton.edu/2024/200-3/p04); PDF pages 5; explicit conjecture.

### L-F53-maximal-sts-girth

Determine the optimal asymptotic maximum density girth of an STS of order N, equivalently the optimal dependence of N_1.1(g) on g.

- Type: specific question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F53: Section 1.3 / PDF5](https://annals.math.princeton.edu/2024/200-3/p04); PDF pages 5; explicit question.

### L-F53-pseudorandom-decomposition

Establish high-girth triangle decompositions in sufficiently dense pseudorandom graphs satisfying the required divisibility conditions.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F53: Section 1.3 / PDF5](https://annals.math.princeton.edu/2024/200-3/p04); PDF pages 5; explicit research direction.

### L-F53-high-girth-factorizations

Extend the high-girth construction program to 1-factorizations, as suggested in the discussion of Linial’s proposals.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F53: Section 1.3 / PDF5](https://annals.math.princeton.edu/2024/200-3/p04); PDF pages 5; explicit research direction.

### L-F50-systematic-weight-distributions

Develop systematic computer investigations of weight distributions using structural information about codes and their duals.

- Type: method request; written formulation: method request.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F50: Final discussion, printed p94 / PDF16](https://doi.org/10.1002/j.1538-7305.1963.tb04003.x); PDF pages 16; explicit research direction.

### L-F65-minimum-degree-threshold

Determine the optimal minimum-degree threshold for high-girth K_q^r-decompositions in Theorem 8.1; for r=2, can it match ordinary K_q-decomposition bounds?

- Type: specific question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F65: Section 8, after Theorem 8.1 / PDF54](https://arxiv.org/abs/2402.17856v1); PDF pages 54; explicit question.

### L-F65-random-high-girth-designs

Determine thresholds for high-girth Steiner systems in random graphs and random uniform hypergraphs, extending the referenced refined-absorption threshold results.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F65: Section 8, final paragraph / PDF54](https://arxiv.org/abs/2402.17856v1); PDF pages 54; explicit research direction.

### L-F66-latin-enumeration

Close the gap between upper and lower bounds on the number of Latin squares of order n.

- Type: research direction; written formulation: research direction.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F66: Introduction / PDF1](https://arxiv.org/abs/2202.05088v4); PDF pages 1; explicit research direction.

### L-F66-uniform-sampling

Find a provably efficient method for generating a uniformly random Latin square of order n.

- Type: method request; written formulation: method request.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F66: Introduction and footnote 2 / PDF1](https://arxiv.org/abs/2202.05088v4); PDF pages 1; explicit research direction.

### L-F66-intercalate-lower-tail

Conjecture 1.6: for each fixed 0<delta<=1, does the intercalate count N in a random Latin square satisfy Pr[N<=(1-delta)EN]=exp(-(delta+(1-delta)log(1-delta)+o(1))EN)?

- Type: conjecture; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F66: Section 1.4, Conjecture 1.6 / PDF4](https://arxiv.org/abs/2202.05088v4); PDF pages 4; explicit conjecture.

### L-F66-intercalate-upper-tail

Conjecture 1.7: for fixed delta>0, is Pr[N>=(1+delta)n^2/4]=exp(-(1+o(1))Phi(delta EN) log n), where Phi is the partial-Latin-square intercalate extremal function?

- Type: conjecture; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F66: Section 1.4, Conjecture 1.7 / PDF4](https://arxiv.org/abs/2202.05088v4); PDF pages 4; explicit conjecture.

### L-F66-partial-latin-extremal

Determine the asymptotic value of Phi(N), the least number of nonempty cells in a partial Latin square with at least N intercalates.

- Type: specific question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F66: Section 1.4 and discussion before Theorem 2.3 / PDFs4–5](https://arxiv.org/abs/2202.05088v4); PDF pages 4; explicit question.

### L-F66-maximum-intercalates

Determine the asymptotic maximum number of intercalates in a Latin square of order n.

- Type: specific question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F66: Section 1.4 / PDF4](https://arxiv.org/abs/2202.05088v4); PDF pages 4; explicit question.

### L-F66-hilton-no-subsquares

For all sufficiently large orders n=2^a 3^b with a>=1 and b>=0, does an order-n Latin square with no proper nontrivial Latin subsquare exist (the remaining Hilton N_infinity cases stated in the source)?

- Type: conjecture; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F66: Section 1.4, cited Hilton conjecture / PDF4](https://arxiv.org/abs/2202.05088v4); PDF pages 4; cited conjecture.

### L-F66-poisson-three-subsquares

Establish the proposed asymptotic Poisson law with bounded mean for the number of 3x3 subsquares in a uniformly random Latin square.

- Type: conjecture; written formulation: formulation requires scope check.
- Coverage denominator: excluded. Broad direction or source statement requiring a bounded formal formulation; excluded from the theorem-coverage denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F66: Section 1.4, cited Kwan–Sah–Sawhney conjecture / PDF4](https://arxiv.org/abs/2202.05088v4); PDF pages 4; cited conjecture.

### L-F66-no-large-subsquares

Does the probability that a uniformly random order-n Latin square has no proper Latin subsquare of order at least four tend to one as n grows?

- Type: conjecture; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F66: Section 1.4, cited subsquare conjecture / PDF4](https://arxiv.org/abs/2202.05088v4); PDF pages 4; cited conjecture.

### L-F66-minimum-cuboctahedra

Determine the asymptotic minimum number of cuboctahedra in an order-n Latin square; in particular, can the count be below (4-Omega(1))n^4?

- Type: specific question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F66: Section 1.3 and final paragraph of Section 1.4 / PDFs3–4](https://arxiv.org/abs/2202.05088v4); PDF pages 3, 4; explicit question.

### L-F52-seven-even-free-sts

Does a nontrivial Steiner triple system exist that simultaneously avoids the Pasch, grid and double-triangle even configurations, and hence is seven-even-free?

- Type: specific question; written formulation: precise math in source.
- Coverage denominator: included. Specific source-stated mathematical question; current resolution, matching Lean discovery and difficulty assessment pending.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open as stated in source; current resolution: not independently established.
- [F52: Section3, discussion after Theorem3.10 / printed pp37–38](https://www.kurims.kyoto-u.ac.jp/~kyodo/kokyuroku/contents/pdf/1889-05.pdf); PDF pages 6; explicit question.
- [F49: SectionIII-B, even-freeness discussion / PDF8](https://arxiv.org/pdf/1309.5587v2); PDF pages 8; same source question.

### L-F67-redundant-check-design

Develop a principled way to add redundant parity checks that improves iterative decoding beyond the difference-set examples.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Author-stated method or research direction; no frozen single mathematical theorem interface. Outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open direction as stated in inspected version; current resolution: not independently established.
- [F67: Section V, printed p.4840 / PDF p.7](https://hal.usc.edu/chugg/docs/pubs/zhu2007bounds.pdf); extraction lines 1050–1058; explicit direction.
- Related, not merged: L-F16-stopping-bound.

### L-F68-integer-tightening

Improve the graph-analysis distance bound by enforcing integer relation-distribution vectors.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Author-stated method or research direction; no frozen single mathematical theorem interface. Outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open direction as stated in inspected version; current resolution: not independently established.
- [F68: Section 7 / manuscript PDF p.19](https://citeseerx.ist.psu.edu/document?doi=b467ba3c3d8d22c34667c1006a7e09e71cfe1bbf&repid=rep1&type=pdf); extraction lines 962–967; explicit direction.
- Related, not merged: L-F16-stopping-bound.

### L-F68-degree-stratification

Refine the graph-analysis bound by separating active checks according to their induced degrees.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Author-stated method or research direction; no frozen single mathematical theorem interface. Outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open direction as stated in inspected version; current resolution: not independently established.
- [F68: Section 7 / manuscript PDF p.19](https://citeseerx.ist.psu.edu/document?doi=b467ba3c3d8d22c34667c1006a7e09e71cfe1bbf&repid=rep1&type=pdf); extraction lines 967–974; explicit direction.
- Related, not merged: L-F16-stopping-bound.

### L-F68-decoder-quality

Test whether the graph-analysis bound predicts the quality of a graph for iterative decoding.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Author-stated method or research direction; no frozen single mathematical theorem interface. Outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open direction as stated in inspected version; current resolution: not independently established.
- [F68: Section 7 / manuscript PDF p.19](https://citeseerx.ist.psu.edu/document?doi=b467ba3c3d8d22c34667c1006a7e09e71cfe1bbf&repid=rep1&type=pdf); extraction lines 975–987; explicit direction.
- Related, not merged: L-F16-stopping-bound.

### L-F69-general-distance

Find nontrivial general minimum-distance lower bounds for the proposed QC generalized hypergraph-product codes.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Author-stated method or research direction; no frozen single mathematical theorem interface. Outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open direction as stated in inspected version; current resolution: not independently established.
- [F69: Section 6, including footnote 19 / PDF p.17](https://arxiv.org/abs/1904.02703v3); extraction lines 1843–1863; explicit direction.
- Related, not merged: L-F16-stopping-bound.

### L-F70-efficient-decoding

Devise an efficient decoder for quantum Tanner codes.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Author-stated method or research direction; no frozen single mathematical theorem interface. Outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open direction as stated in inspected version; current resolution: not independently established.
- [F70: Comments and open problems / PDF p.10](https://arxiv.org/abs/2202.13641v3); extraction lines 502–507; explicit direction.
- Related, not merged: L-F16-stopping-bound.

### L-F70-generator-weight

Reduce the constant generator weights in the quantum Tanner construction.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Author-stated method or research direction; no frozen single mathematical theorem interface. Outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open direction as stated in inspected version; current resolution: not independently established.
- [F70: Comments and open problems / PDF p.10](https://arxiv.org/abs/2202.13641v3); extraction lines 508–513; explicit direction.
- Related, not merged: L-F16-stopping-bound.

### L-F70-other-complexes

Find complexes beyond left-right Cayley complexes on which the Tanner construction gives good quantum LDPC families.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Author-stated method or research direction; no frozen single mathematical theorem interface. Outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open direction as stated in inspected version; current resolution: not independently established.
- [F70: Comments and open problems / PDF p.10](https://arxiv.org/abs/2202.13641v3); extraction lines 514–516; explicit direction.
- Related, not merged: L-F16-stopping-bound.

### L-F70-explicit-components

Make the required component-code and quantum Tanner constructions completely explicit.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Author-stated method or research direction; no frozen single mathematical theorem interface. Outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open direction as stated in inspected version; current resolution: not independently established.
- [F70: Comments and open problems / PDF p.10](https://arxiv.org/abs/2202.13641v3); extraction lines 517–522; explicit direction.
- Related, not merged: L-F16-stopping-bound.

### L-F70-robustness-exponent

Improve component dual-tensor robustness beyond the Delta-to-the-three-halves scale and strengthen the distance dependence.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Author-stated method or research direction; no frozen single mathematical theorem interface. Outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open direction as stated in inspected version; current resolution: not independently established.
- [F70: Comments and open problems / PDF p.10](https://arxiv.org/abs/2202.13641v3); extraction lines 522–529; explicit direction.
- Related, not merged: L-F16-stopping-bound.

### L-F73-residual-erasure-techniques

Develop other techniques to handle the small residual errors left after peeling quantum expander codes.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Author-stated method or research direction; no frozen single mathematical theorem interface. Outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open direction as stated in inspected version; current resolution: not independently established.
- [F73: Section VII / PDF p.19](https://arxiv.org/abs/2504.21845v2); extraction lines 709–718; explicit direction.
- Related, not merged: L-F16-stopping-bound.

### L-F74-socket-partition-design

Improve socket selection and partitioning events in composite branch-and-bound stopping-set searches.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Author-stated method or research direction; no frozen single mathematical theorem interface. Outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open direction as stated in inspected version; current resolution: not independently established.
- [F74: Section VIII / printed p.1995](https://swh.princeton.edu/~kulkarni/Papers/Journals/j069_2009_WangKulPoo_TranIT.pdf); extraction lines 2703–2715; explicit direction.
- Related, not merged: L-F16-stopping-bound.

### L-F74-faster-implementation

Extend exhaustive small stopping/trapping-set search to longer codes through better data structures, software or hardware.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Author-stated method or research direction; no frozen single mathematical theorem interface. Outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open direction as stated in inspected version; current resolution: not independently established.
- [F74: Section VIII / printed p.1995](https://swh.princeton.edu/~kulkarni/Papers/Journals/j069_2009_WangKulPoo_TranIT.pdf); extraction lines 2715–2722; explicit direction.
- Related, not merged: L-F16-stopping-bound.

### L-F74-direct-trapping-search

Design direct exhaustive trapping-set algorithms that improve on reduction to stopping-set enumeration.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Author-stated method or research direction; no frozen single mathematical theorem interface. Outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open direction as stated in inspected version; current resolution: not independently established.
- [F74: Section VIII / printed p.1995](https://swh.princeton.edu/~kulkarni/Papers/Journals/j069_2009_WangKulPoo_TranIT.pdf); extraction lines 2722–2740; explicit direction.
- Related, not merged: L-F16-stopping-bound.

### L-F75-pruned-cluster-combination

Study pruned peeling combined with cluster decomposition more comprehensively.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Author-stated method or research direction; no frozen single mathematical theorem interface. Outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open direction as stated in inspected version; current resolution: not independently established.
- [F75: Section III / PDF p.5](https://arxiv.org/abs/2412.08817v1); extraction lines 551–567; explicit direction.
- Related, not merged: L-F16-stopping-bound.

### L-F77-polynomial-redundancy

Does an asymptotically good binary linear code family have stopping redundancy polynomial in its length?

- Type: open question; written formulation: precise math in source.
- Coverage denominator: included. Precise historical mathematical target; current resolution, Lean discovery and difficulty unassessed.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F77: SectionVII, PDF p.10](https://www.ece.mcmaster.ca/~schwam10/publications/MSjrnl6.pdf); extraction lines 1397–1567; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F77-Golay34

Is the stopping redundancy of the extended binary Golay code G24 equal to34?

- Type: conjecture; written formulation: precise math in source.
- Coverage denominator: included. Precise historical mathematical target; current resolution, Lean discovery and difficulty unassessed.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F77: SectionVII, PDF p.10](https://www.ece.mcmaster.ca/~schwam10/publications/MSjrnl6.pdf); extraction lines 1397–1567; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F77-MDS-invariance

Do all finite-field [n,k] MDS codes have stopping redundancy depending only on n and k?

- Type: conjecture; written formulation: precise math in source.
- Coverage denominator: included. Precise historical mathematical target; current resolution, Lean discovery and difficulty unassessed.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F77: SectionVII, PDF p.10](https://www.ece.mcmaster.ca/~schwam10/publications/MSjrnl6.pdf); extraction lines 1397–1567; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F77-locally-thin-three

Is t(3)<1, where t(k)=limsup_{rho->infinity} log2(M(rho,k))/rho for k-locally-thin families?

- Type: open question; written formulation: precise math in source.
- Coverage denominator: included. Precise historical mathematical target; current resolution, Lean discovery and difficulty unassessed.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F77: SectionVII, Eq.27, PDF pp.9-10](https://www.ece.mcmaster.ca/~schwam10/publications/MSjrnl6.pdf); extraction lines 1397–1567; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F77-locally-thin-monotone

Is t(k) nonincreasing for integers k>=2 in the same locally-thin-family definition?

- Type: open question; written formulation: precise math in source.
- Coverage denominator: included. Precise historical mathematical target; current resolution, Lean discovery and difficulty unassessed.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F77: SectionVII, PDF p.10](https://www.ece.mcmaster.ca/~schwam10/publications/MSjrnl6.pdf); extraction lines 1397–1567; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F77-general-lower-bounds

Improve general lower bounds for stopping redundancy.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Broad author-stated direction; outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F77: SectionVII, PDF p.10](https://www.ece.mcmaster.ca/~schwam10/publications/MSjrnl6.pdf); extraction lines 1397–1567; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F77-nonbinary-constructions

Study stopping redundancy under nonbinary concatenated and multilevel constructions.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Broad author-stated direction; outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F77: SectionVII, PDF p.10](https://www.ece.mcmaster.ca/~schwam10/publications/MSjrnl6.pdf); extraction lines 1397–1567; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F77-MDS-exact

Determine exact MDS stopping redundancy as a function of the code parameters.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Broad author-stated direction; outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F77: SectionVI-VII, PDF pp.9-10](https://www.ece.mcmaster.ca/~schwam10/publications/MSjrnl6.pdf); extraction lines 1397–1567; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F77-other-channels

Determine the relevance of stopping redundancy for channels beyond the BEC and LP decoding.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Broad author-stated direction; outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F77: SectionVII, PDF p.9](https://www.ece.mcmaster.ca/~schwam10/publications/MSjrnl6.pdf); extraction lines 1397–1567; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F77-locally-thin-sequence

Determine the sequence t(k) for locally-thin families.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Broad author-stated direction; outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F77: SectionVII, Eq.27, PDF p.9](https://www.ece.mcmaster.ca/~schwam10/publications/MSjrnl6.pdf); extraction lines 1397–1567; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F78-cyclic-good

Do asymptotically good linear cyclic codes exist over a fixed finite field?

- Type: open question; written formulation: precise math in source.
- Coverage denominator: included. Precise historical mathematical target; current resolution, Lean discovery and difficulty unassessed.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F78: SectionsIII.B-III.C, PDF pp.4,6](https://arxiv.org/abs/2203.17216v1); extraction lines 380–510; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F78-Artin

For each positive nonsquare integer q>1, do primes with ord_p(q)=p-1 have positive density?

- Type: conjecture; written formulation: precise math in source.
- Coverage denominator: included. Precise historical mathematical target; current resolution, Lean discovery and difficulty unassessed.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F78: Example8, PDF p.4](https://arxiv.org/abs/2203.17216v1); extraction lines 380–510; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F78-GB-scaling

Determine optimal distance scaling of generalized bicycle codes at bounded generator weight.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Broad author-stated direction; outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F78: SectionV, PDF p.9](https://arxiv.org/abs/2203.17216v1); extraction lines 1083–1253; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F78-higher-k-fault-tolerance

Study parameters and fault-tolerant performance of generalized bicycle codes encoding more than two qubits.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Broad author-stated direction; outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F78: SectionV, PDF p.9](https://arxiv.org/abs/2203.17216v1); extraction lines 1083–1253; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F78-local-above-square-root

Can quantum codes local in a fixed dimension D>2 have polynomial distance exponent strictly above1/2?

- Type: open question; written formulation: precise math in source.
- Coverage denominator: included. Precise historical mathematical target; current resolution, Lean discovery and difficulty unassessed.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F78: SectionV, PDF p.9](https://arxiv.org/abs/2203.17216v1); extraction lines 1083–1253; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F78-other-commuting-matrices

Find better LDPC parameters from other commuting-square-matrix CSS constructions.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Broad author-stated direction; outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F78: SectionV, PDF p.9](https://arxiv.org/abs/2203.17216v1); extraction lines 1083–1253; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F78-measurement-tradeoff

Determine whether larger bicycle-code distances offset higher-weight measurement complexity.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Broad author-stated direction; outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F78: SectionV, PDF p.9](https://arxiv.org/abs/2203.17216v1); extraction lines 1083–1253; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F79-minsum-erasure

Study min-sum variants of the proposed soft BP decoders for quantum erasures.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Broad author-stated direction; outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F79: Discussion, PDF p.9](https://doi.org/10.1038/s41534-026-01212-3); extraction lines 1152–1322; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F79-circuit-erasure

Develop the detailed circuit-level erasure treatment, including conversion circuits, left outside this paper.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Broad author-stated direction; outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F79: Discussion, PDF p.10](https://doi.org/10.1038/s41534-026-01212-3); extraction lines 1152–1322; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.

### L-F80-design-enumerators

Determine stopping-set weight enumerators for general designs and their associated codes.

- Type: research direction; written formulation: broad direction.
- Coverage denominator: excluded. Broad author-stated direction; outside the precise-target denominator.
- Proof-assistant statement: not assessed in this extension. Lean statement: not assessed in this extension. Lean proof: not assessed in this extension.
- Source-described status: open or proposed in inspected source; current resolution: not independently established.
- [F80: Enumerating Stopping Sets, PDF pp.9-12](https://ece.iisc.ac.in/~nkashyap/Papers/stopsets.pdf); extraction lines 616–786; explicit question or direction.
- Related, not merged: L-F16-stopping-bound.
