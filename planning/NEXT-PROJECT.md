**October 26 connected follow-up:** The project-derived connected/coupled strengthening of L-P09-all-absorbing is complete for an explicit fifteen-qubit asymmetric CSS pair: all128 supported Z-errors recover under both syndrome tests, the actual decoding graph is connected, and no physical partition gives a product stabilizer space. [Paper and exact scope](../formalization/gallager-b-absorbing/connected/README.md). Do not repeat this completed construction. The symmetric-CSS/same-matrix variant must be precisely formulated and its current status checked before another campaign; it is not started here. Two newly inventoried entanglement questions have unassessed modern resolution and are not recommendations yet.

**October 26: L-P09-all-absorbing is answered negatively for the unrestricted v2 source question.** A connected seven-variable (7,0)-absorbing component accepts all128 supported inputs at initialization or after one Gallager-B iteration. A separate actual fourteen-coordinate CSS pair corrects every first-component Z-error modulo the full opposite stabilizer span and retains a nontrivial logical on its other component. [Paper, full scope and checked proof](../formalization/gallager-b-absorbing/README.md) · [Issue #2](https://github.com/alectionary/vibe-math/issues/2). Do not select this completed unrestricted question again. The connected-ambient follow-up is addressed in the later record above. High-girth and degree restrictions still require precise formulation and a current-status check. A nontrivial decoded-sector logical entirely on the selected support is incompatible with correcting all supported errors. Six historical Steane directions have been inventoried without presenting them as current open questions.

**Historical selection, October 25: RQ-F25-truncated-distance-12 (follow-up to L-F25-distance-preservation).** Prove or refute `dQ >= min(dC,12)` under the strengthened normalized 3-by-4 cyclic-base tests. The old girth/no-RCPC diagnostic has already been refuted; checked generic low-weight lemmas and corrected finite diagnostics motivate this bounded next step. [Candidate comparison, exact hypotheses, evidence limits and stopping condition](QUANTUM-NEXT-PROBLEM-2026-10-25.txt). [Canonical issue #1](https://github.com/alectionary/vibe-math/issues/1) records the reservation and next action. Projects are skipped at the user's request. No proof campaign or new theorem is claimed.

**Historical selection, October 24: L-F25-distance-preservation (new problem at that time).** Find sufficient base constraints preserving classical distance in symmetric type-I quantum lifted-product codes. [Original candidate comparison and diagnostic protocol](QUANTUM-NEXT-PROBLEM-2026-10-24.txt). That diagnostic now has recorded counterfamily results. The historical recommendations below remain provenance.

# Current difficulty assessment and next project

**October 23 inventory reconciliation:** the inventory now has 187 entries and 111 eligible targets. Six new source questions/directions are recorded as planning-unassessed in [the current table](CURRENT-DIFFICULTY.md); the earlier numerical rankings and selected-project recommendation below are historical, not a recommendation to repeat an already completed investigation. [Reconciliation](../literature/RESEARCH-RECONCILIATION.md).

Checked October 23, 2026. **The selected P11 forbidden-set completeness project is complete for its recorded cumulative cycle/girth scope.** The literal optimized appendix enumeration, including all printed half sums and ordered row/column constraints, now has a full Lean proof and an executable checker matching native cycles in the expanded binary matrix. [Full checked correspondence](../formalization/dyadic-forbidden/APPENDIX-ENUMERATION.md). The earlier P34 girth-eight project is also complete for its recorded scope; its original planning rationale is retained below.


**October 23: P11 source-specific formalization completed.** There are 90 audited library declarations and two separately audited kernel-evaluated execution checks. The literal appendix enumeration bridge is now part of the formal proof, so the complete-target count rises from two to three. The source's exact cycle-count coefficients, PEG/decoder optimization and unpublished author software remain outside the recorded criterion.

All **181 inventory entries** now have current planning assessments, including the **67 additions** missing from the historical report. The cohort contains **108 eligible targets**: three completed Lean targets, three with formulation decisions still needed for planning, and 102 other targets with effort tiers. The other 73 entries are directions, method requests or held statements outside the coverage denominator. Their scope must be fixed before scheduling a general proof. The [original 114-entry assessment](LEAN-DIFFICULTY.md) remains a historical snapshot.

[Every current assessment](CURRENT-DIFFICULTY.md) · [Searchable table](current-difficulty.html) · [Structured estimates](current-difficulty-estimates.json) · [Current summary](current-difficulty-summary.json) · [Lean coverage evidence](../literature/LEAN-COVERAGE.md).

## Progress after starting the project

The cyclic-lift library has 75 audited Lean theorems, including the arbitrary-exponent eight-cycle and full entrywise girth-eight characterization. The inventory now records three complete Lean targets out of 108, including P11. Earlier small families and the 432-case Python scan remain regression evidence. [Implementation, exact scope and verification](../formalization/cyclic-lifts/README.md). The original P34 effort estimates are retained in its structured planning record; completed setup/proof work is now tier zero.

## What the ratings mean

There are three separate tasks: build a faithful statement and its definitions; discover a correct mathematical proof or counterexample; and transfer a supplied complete proof into checked Lean. **Discovery completion time is unestimated for every open target.** The proof-transfer bands below assume that discovery is already complete. They are additional effort after statement setup, with one experienced Lean developer and domain knowledge. Do not add bands across related targets, which can share foundations.

| Tier | Statement and definitions | Additional Lean proof transfer, given a correct complete proof |
| --- | --- | --- |
| 1 | 1–3 expert person-days | 2–5 expert person-days |
| 2 | 4–10 expert person-days | 1–4 expert person-weeks |
| 3 | 2–6 expert person-weeks | 1–4 expert person-months |
| 4 | 1–4 expert person-months | 4–12 expert person-months |
| 5 | 4–12+ expert person-months | 1–3+ expert person-years |

These are low-confidence scenarios, not measured implementation times, deadlines or confidence intervals. The first 114 entries mostly retain their earlier priors, with completion, eligibility and scope checked against the current inventory. The 67 additions use source-specific wording and family priors informed by the recent Lean search. The leading coding candidates received another read of their relevant primary sections. Most entries have not received an implementation spike or a full dependency audit. A missing API can move a rating substantially.

The dyadic rank/support target has zero remaining statement/proof work for its recorded scope because it is already verified. Its success demonstrates that a compact algebraic route can change a project's prospects; it does not calibrate the time needed to solve unrelated open questions. P34 now also has zero remaining work for its recorded girth statement; its implementation is separately reflected in the current coverage count.

## Shortlist

| Priority and target | Statement tier | Conditional full proof-transfer tier | Mathematical obstacle and first useful result |
| --- | ---: | ---: | --- |
| **Completed: P34 girth-eight conditions** | **0** | **0** | General simple eight-cycle and exact rectangle/hexagon criterion now verified; published-priority comparison and other graph properties are separate. |
| **Completed: P11 forbidden-set completeness at lengths six/eight** | **0** | **0** | Literal optimized appendix enumeration, printed half sums and native expanded-matrix correspondence now checked in Lean. |
| **3. P27 star-saturated, clique-free graph existence** | **2** | **3** | Good finite search and certificate route. Start with one fixed parameter pair and small orders, while preserving saturation under every missing-edge addition. The general all-parameter classification remains a larger mathematical task. |
| F16 explicit (4,2)/(4,0) absorbing-set counts | 3 | 3 | A bounded four-variable pattern is approachable, but induced-subgraph corrections and the spectral/Fourier bridge add work. First certify the combinatorial count on tiny Tanner graphs. |
| F23 accuracy/margin dependence of list replicability | 3 | 4 | A short question needs substantial learner/distribution semantics. First specify one finite concept class faithfully; this has less immediate reuse from our completed project. |
| F24 optimal logarithmic list-size bound | 3 | 4 | The later O(log² M log N) theorem is weaker than the conjectured O(log M log N). Improving that logarithm is a research problem, not a routine Lean exercise. |
| Conway's 99-graph existence | 1 | 3, highly proof-dependent | Statement infrastructure is present, but discovery is exceptionally difficult. A supplied finite adjacency-matrix witness could make verification much cheaper; a nonexistence argument might require tier 4–5 infrastructure. |
| General PDE well-posedness and surface-topology targets | Usually 4–5 | Usually 5 | Large missing analytic/topological foundations and difficult research. The compact wording of an invariant or PDE question understates its dependencies. |

The shortlist ranks suitability for our next project, not probabilities of solving the questions. F16's original stopping-set parameter question is now answered negatively, and useful spectral/incidence replacement existence is answered positively; those completed targets supersede the former parameter-search recommendation. F14's efficient low-randomness mechanism has a later parameterized mathematical answer and could be a substantial proof-transfer project; it should not be advertised as new mathematical discovery. [P11 concluding questions](https://arxiv.org/html/2605.01942v1), [P27 Question 2.4](../literature/OPEN-PROBLEMS.md#l-p27-q24-existence), [F16 Sections 5–6](https://arxiv.org/html/2607.13666v1), [F24 progress](https://arxiv.org/html/2610.20657v1).

The two counterchecked graph statements are not open targets to prove as written. The earlier triangle-bound counterexamples must retain credit, and the small-order periodicity defect needs a repaired formulation. Formalizing those counterexamples would be a useful short verification exercise, but it would not solve another currently open problem.

## Original P34 first-stage plan (completed)

Allow roughly **2–4 expert person-weeks for the first stage**, as a planning scenario rather than a promise:

1. Define a cyclically labeled bipartite base graph and its lift, then connect that graph to the paper's particular lifted-product matrix. Keep ordinary cyclic lifts and dyadic lifts distinct.
2. Prove that a lifted walk's final fiber coordinate is its initial coordinate plus the oriented label sum in Z/rZ. Prove the closure equivalence. This is established voltage-graph groundwork, with credit to the paper's cited graph-lift background.
3. Prove the four-cycle exclusion criterion with distinct row/column hypotheses and audit it on small matrices.
4. Enumerate projected closed walks of length six and compare their lifted simple cycles with direct finite graph enumeration. Record missing or redundant conditions before attempting a general proof.

A closed lifted walk need not be a simple cycle. Partial returns and repeated vertices must be accounted for; a zero total label sum alone is not a simple-cycle theorem. Also, excluding four- and six-cycles yields **girth at least eight** in the bipartite setting. Claiming **girth exactly eight** requires an eight-cycle witness or a valid upper-bound theorem with its hypotheses checked. Test both connected and disconnected boundary cases, as appropriate to the chosen statement.

The first-stage success condition is a built, axiom-audited walk/closure lemma and four-cycle criterion, a faithful matrix-to-graph comparison, and reproducible small-instance tests. A general sufficient-condition theorem or a counterexample to a proposed simplification would be a later milestone. An exhaustive restatement of “there are no short cycles” is not by itself the useful entrywise design criterion sought by the paper.

## Why this choice

P34 offers a short route from a finite definition to useful symbolic lemmas, a direct comparison between computation and proof, and shared infrastructure with the P11 and F16 questions. Mathlib already supplies finite graphs and girth; a public LeanPool file supplies related lifted-product matrices and CSS-orthogonality proofs. That file was source-inspected but not built or semantically identified with P34's graph here, so reuse is a candidate rather than a ready-made solution. [Available background and audit limits](../literature/LEAN-COVERAGE.md).

No novelty claim follows from selecting this problem. Before presenting a general result as new, compare the exact criterion with classical cyclic-lift cycle conditions, the paper's cited sources and later work. A new Lean verification can still be useful when the underlying mathematics is already known, provided both contributions are described accurately.


Dated October24 research update: the current inventory has **190 canonical entries,112 eligible targets and4/112 complete checked Lean targets**. The existing F16 four-variable counting target is completed in its incidence-corrected/source-obstruction scope. Beezer contributes one separately indexed conjecture and two broad directions, with current-resolution/Lean/difficulty assessment pending. Earlier counts and recommendations in this document are historical snapshots. See [current reconciliation](../literature/RESEARCH-RECONCILIATION.md).


October24 lift-label follow-up is complete for the two fixed bases: [report](../formalization/lift-label-elimination/RESEARCH-NOTE.txt). The [[140q,18,6]] family has independently checked q2 data and a checked Lean version of every manuscript proof, including mixed-Pauli distance. General decoder optimization remains outside this study. No new source question or effort estimate was added.


## Current stronger-bound continuation -24October2026

The requested incidence-conditioned existence target is now answered positively; B1 classification is already complete. See [the stronger-bound checkpoint](../formalization/stopping-bound/stronger/README.txt). For the remaining authorized research time, compare two bounded steps: a rigorous expanded-spectrum comparison with Zhu-Chugg (high explanatory payoff, reusable finite linear-algebra/cover infrastructure), and tightening the Sidon criterion (larger mathematical payoff, but additive-consistency and sharpness are not yet settled). Prioritize a direct spectral certificate, then test a sharper incidence statement against finite counterexamples. No source question is marked unresolved merely because these follow-ups remain.

The source screen adds20 planning records with no invented effort estimates. The fixed canonical completion count stays five.


## Updated bounded follow-up after the spectral existence answer

The exact fourth-moment criterion, actual joint-Sidon family and two-sector kernel bridges answer useful spectral replacement existence positively. The original parameter question stays negative. These are completed existence answers, not an optimal universal-bound theorem. The quantitative nonzero-excess criterion is now checked in MomentExcess. The next target is to construct or obstruct a sparse scalar QC family in its informative nonzero-excess regime, or determine sharp powers-family stopping distances. The independent base81 exact-eight certificate is a held computation and is excluded from published theorem claims unless its entire chain finishes. Complete canonical count remains five.

Final bounded follow-up: the short4/8 family and54-variable moment5 certificate are proved; useful replacement existence is complete. Next compare constructing/obstructing an informative nonzero-excess scalar QC family (a precise feasibility question for MomentExcess) with determining sharp stopping distances of the short family (finite-certificate and cover cost). Exact-eight work was stopped without a completed kernel certificate and is excluded from theorem claims. Canonical completed count stays five; current inventory295/144, with114added planning entries explicitly unassessed.


## Distance-preservation research —24 October2026

The new F25 investigation refutes the proposed girth/RCPC sufficient criterion with source-matched infinite counterfamilies. The fixed specialization is connected, has classical girth8 and no RCPC, but dQ<=11<12<=dC<=20; its transpose classical distance is2L. See [the result and limits](../formalization/distance-preservation/RESEARCH-NOTE.txt) and [verification](../formalization/distance-preservation/verification.json). The original positive sufficient-condition target remains open in this project.

Preferred next bounded **follow-up**: prove or refute **dQ≥min(dC,12)** for normalized, fully populated3×4 cyclic bases with classical girth≥8, no fullRCPC, no three-column partial row pairing, and transpose classical distance≥dC. The new generic zero-or-two check-degree theorem applies exactly to potential counterexamples through weight11. All actual source supports, both sectors and the full stabilizer quotient must be controlled; the corrected104-base diagnostic does not prove the bound. See [the exact route and limits](../formalization/distance-preservation/STRUCTURAL-ROUTE.txt).

The weight-seven pattern work is supporting verification: sourceSectionV-B already asserts that its RCPC recipe excludes stabilizer-weight logicals. Two generic structural modules pass isolated Lean rebuilds, and a restricted144-pattern integer catalog is independently checked. Its full support/source bridges remain incomplete. Do not relabel this source-claimed case as a newly open mathematical problem.

The explicit L13 quantum-distance14 certificate remains a deferred finite alternative. Its upper witness and classical minimum14 are independently checked, and the corrected C++ exclusion through13 completes; a separate900-second SAT attempt returned UNKNOWN. The [search repair](../formalization/distance-preservation/search-repair.json) preserves the old outputs, regression tests and unchanged replays. No numerical discovery-time or proof-transfer estimate is inferred from either route.

Current cohort after source harvesting:319 entries,144 eligible targets,124 papers,113 full-text screens and five completed canonical Lean targets. The24 newly indexed directions are outside the precise-target denominator. Earlier recommendations above are historical snapshots.
