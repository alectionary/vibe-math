# Academic literature on dissertation open problems

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

- All **20 authors** received an author/topic search. **16** have topic-matched article/preprint records in this bibliography.
- **34 article/preprint records** are included. These include overlapping manuscript and conference versions and a dissertation-derived upload; they are not independent new contributions or uniformly peer-reviewed articles.
- **24 related coauthor/external article follow-ups** and **two talk/abstract records** are tracked separately. These papers have coauthor, topic or citation connections as specified individually; they do not all repeat a particular dissertation question.
- **40 open-looking targets** are cross-referenced: the earlier audit’s **39 eligible targets**, plus Geraci’s held Question 5.1. None is marked fully resolved by this search.

Eight selected questions have a directly corresponding earlier article statement or unresolved-property description: Geraci’s two neural-code targets, Zamir’s two targets, Wright’s existence question, DeClerk’s two questions, and Volk’s path-minimizer question. These are mainly pre-dissertation formulations, so this count establishes circulation beyond the thesis text, not eight later rediscoveries. Wright’s existence question is also explicitly revisited in a 2024 conference abstract. Broader regimes and related theorems receive separate labels in the ledger.

## How references are classified

A citation to an author or article is evidence of research uptake. An exact question repetition requires matching the mathematical objects and quantifiers. A partial result must add an actual theorem for a restricted case or subclaim. A resolution must settle the original target in its stated generality; a different model, a sufficient condition, or a result already present in the dissertation does not qualify. Publication date, first preprint date and revision date are kept distinct where they affect this interpretation.

The search used author names with dissertation topics, problem terminology, article titles, author bibliographies, arXiv texts, publisher pages, and forward-citation discovery. It was not an exhaustive citation census or a proof-correctness review. The OpenAlex results underreport some citations independently located in the primary texts; zero index results must not be interpreted as zero citations. The earlier Semantic Scholar citation requests returned HTTP 429 and supplied no usable citation data. The gap-closure pass obtained limited open-access metadata separately; it did not replace the citation census. The October 22 pass adds six bounded forward-citation queries and 36 OpenAlex lexical discovery queries; lexical author-name hits are not treated as verified authorship. See [expanded methodology](SCHOLARLY-EXPANSION.md), [citation discovery failures](citation-discovery.json), [OpenAlex discovery](openalex-citations.json), and [author search coverage](authors.json).

Four authors have no separately verified topic-matched article in this selected bibliography: Jordan Vincent Barrett, Alex John Heitzman, Allison Joan Ganger and Pahalapathirage Dona Kalani Hasanthika. That does not assert that they have no publications. Ganger’s work is acknowledged in a later seminar; Barrett has conference abstracts. Same-name Barrett graph-theory papers and unrelated Yuhao Mu physics/economics papers were excluded without an identity match.

## Author and coauthor papers

The record IDs below link the machine-readable bibliography to the question ledger. Each entry distinguishes inspected full-text sections from abstract or bibliography discovery. Later papers may cite the article version rather than the dissertation itself.

### P01 Boolean Matrix Rank via Monomial Ideals

Juliann Geraci; Alexander B. Kunin; Alexandra Seceleanu. 2026. [full text relevant sections](https://arxiv.org/html/2509.09570v2).

Revised after the dissertation. Question 6.1 asks about the regularity–Ferrers-cover gap. The dissertation Question 5.1 instead names the Ferrers/biclique gap and adds a fixed-vertex phrase. Treat this as a changed question, not an exact repetition or a resolution.

Location: v2, 1 October 2026; Section 6, Equation 6.1 and Question 6.1.

### P02 Adjoints of Morphisms of Neural Codes

Juliann Geraci; Alexander B. Kunin; Alexandra Seceleanu. 2026. [full text relevant sections](https://arxiv.org/html/2603.10837v1).

Question 7.1 repeats and extends the canonical-form extremal problem to union-complete codes; Conjecture 7.3 gives the same redundancy/rank equality. Predates the dissertation.

Location: v1, 11 March 2026; Sections 7.1 and 7.3, Question 7.1 and Conjecture 7.3.

### P03 Cohomological support varieties under local homomorphisms

Ryan Watson. 2025. [abstract and metadata](https://arxiv.org/abs/2506.10757).

Dissertation-related restriction-of-scalars and finite-flat-dimension results. No resolution of the proposed nonflat derived extension established by this search.

Location: Abstract; arXiv v1, 12 June 2025.

### P04 Cohomological support varieties for monomial ideals

Kara Fagerstrom; Julianne Faur; Benjamin Katz; Kesavan Mohana Sundaram; Stephen Stern; Ryan Watson. 2026. [abstract and metadata](https://arxiv.org/abs/2605.29103).

Extends a monomial-ideal classification and reports answering a Gintz question. That named question is not the nonflat-extension direction in our Watson review.

Location: Abstract; 27 May 2026.

### P05 Graded-Injective Modules and Bass Numbers of Veronese Submodules

Taylor Murray. 2024. [abstract and metadata](https://arxiv.org/abs/2407.17656).

An article version of the Bass-number work, not evidence that the answered dissertation Question 1 remains open.

Location: Abstract; v1, 24 July 2024.

### P06 A Revisiting of the Pressure Elimination for a Fluid-Structure PDE Interaction and Its Implications

George Avalos; Yuhao Mu. 2025. [abstract and metadata](https://arxiv.org/abs/2511.06615).

Linear Stokes/elasticity result and FEM consequences. Does not claim global well-posedness of the full untruncated nonlinear FSI problem.

Location: Abstract; first posted 10 November 2025, revised 23 January 2026.

### P07 Point Prediction for Streaming Data

Aleena Chanda; N. V. Vinodchandran; Bertrand Clarke. 2024. [abstract and metadata](https://arxiv.org/abs/2408.01318).

Core streaming-prediction work. Consistency is under IID hypotheses; this is not model-free consistency for every M-open stream.

Location: Abstract; first posted 2 August 2024.

### P08 Online Prediction for Streaming Observational Data

Bertrand Clarke; Aleena Chanda. 2025. [abstract and metadata](https://arxiv.org/abs/2507.21308).

Survey of prediction methods for observational/M-open streams. Relevant continuing research; no specific turnstile-extension theorem verified here.

Location: Abstract; 28 July 2025.

### P09 Absorbing sets in quantum LDPC codes

Kirsten D. Morris; Tefjol Pllaha; Christine A. Kelley. 2026. [publisher abstract and history](https://www.aimsciences.org/article/doi/10.3934/amc.2026023).

Peer-reviewed publication of absorbing-set/decoder research; received April 2025 and revised January 2026. Publication after the thesis is not by itself new progress on its future-work questions.

Location: Publisher abstract and history; early access 3 March 2026; volume 23, 234–254.

### P10 Effect of redundancy on syndrome-based decoding for QLDPC codes

Kirsten D. Morris; Tefjol Pllaha; Christine A. Kelley. 2025. [author bibliography and doi](https://doi.org/10.1109/ISTC65386.2025.11154620).

Topic-matched conference paper listed by the author. Full theorem comparison was not available from the accessible IEEE landing page.

Location: Author publication list; ISTC 2025 DOI.

### P11 Combinatorial Analysis of Dyadic and Quasi-Dyadic Codes

Anthony Gómez-Fonseca; Gretchen L. Matthews; Kirsten D. Morris; Tefjol Pllaha. 2026. [full text relevant sections](https://arxiv.org/html/2605.01942).

Cites Martinez–Pllaha–Kelley as reference 22. Remark 3.4 explicitly describes Theorem 3.1 as a partial converse of that paper’s Theorem 4.6 and conjectures the full converse. Sections 4.1 and 4.3 develop walk/cycle correspondences and girth extensions. This is concrete later progress on the research family, not a verified resolution of every graph-lift direction.

Location: v1, 3 May 2026; Theorem 3.1, Remark 3.4, Section 4.1, Theorem 4.19, Remark 4.2, reference 22.

### P12 Changepoint Detection As Model Selection: A General Framework

Michael Grantham; Bertrand Clarke; Xueheng Shi. 2026. [full text relevant sections](https://arxiv.org/html/2601.22481).

Dissertation-derived IRFL manuscript. Distinguish empirical support from general optimization or consistency guarantees.

Location: Sections 4.1–4.3 and Appendix 6.6; arXiv first posted January 2026.

### P13 GRACE: A General, Exact Changepoint Calculus

Michael A. Grantham. 2026. [full text relevant sections](https://arxiv.org/html/2609.28831).

Later preprint claims exact dynamic programming for a different changepoint framework. Its exactness theorem is not a proof of convergence or global optimality of the older IRFL iterates.

Location: v2, 12 October 2026; Sections 3 and 5.2, Discussion 8; IRFL not identified in the inspected HTML.

### P14 Interpolation in Weighted Projective Spaces

Shahriyar Roshan-Zamir. 2024. [full text relevant sections](https://arxiv.org/html/2406.08602v2).

Section 8 repeats both the bounded-defect question and the weighted-Horace conjecture. Same author and manuscript predating the thesis; a later journal listing does not prove later progress.

Location: v2, 11 August 2024; Section 8 items 2 and 5.

2026 JPAA publication discovered through the author CV/MaRDI; publisher DOI inaccessible during this search, so journal text was not compared.

### P15 On the algebraic properties of the Böröczky configuration

Jake Kettinger; Shahriyar Roshan-Zamir. 2025. [full text relevant sections](https://arxiv.org/html/2510.17029).

Later weighted-projective-plane application to ideal generators and symbolic-power containment. Does not establish uniform boundedness of the general defect or weighted Horace.

Location: v1, 19 October 2025; Introduction, Corollary 4.6 and Section 6.

### P16 Sandwich Bernstein-Sato Polynomials and Bernstein’s Inequality

Jack Jeffries; David Lieberman. 2024. [full text relevant sections](https://arxiv.org/html/2403.13146v1).

Gives a criterion for Bernstein’s inequality and sandwich-equation existence in specified settings, with a Segre application. The introduction expressly notes failure for general singularities. The audit’s broad question must be read as a classification of valid settings, not a conjecture affirming every ring.

Location: Introduction, Theorems 1.1–1.4; posted 19 March 2024.

### P17 Calmed 3D Navier-Stokes Equations: Global Well-Posedness, Energy Identities, Global Attractors, and Convergence

Matthew Enlow; Adam Larios; Jiahong Wu. 2024. [abstract and published version front matter](https://arxiv.org/abs/2312.17371).

Published calmed-NSE work; a global attractor for a rotational calmed NSE is a different target from the calmed velocity–vorticity attractor question.

Location: Abstract; Journal of Nonlinear Science 34 (2024), 112; DOI 10.1007/s00332-024-10093-9.

### P18 Algebraic calming for the 2D Kuramoto-Sivashinsky equations

Matthew Enlow; Adam Larios; Jiahong Wu. 2024. [abstract and published version front matter](https://arxiv.org/abs/2304.10493).

Global well-posedness of the calmed approximation and convergence on the original solution’s existence interval; not global well-posedness of the original 2D equation.

Location: Abstract; Nonlinearity 37 (2024), 115019; DOI 10.1088/1361-6544/ad792e.

### P19 Calmed Ohmic Heating for the 2D Magnetohydrodynamic-Boussinesq System: Global Well-posedness and Convergence

Matthew Enlow; Adam Larios; Yuan Pei. 2024. [abstract and metadata](https://arxiv.org/abs/2410.04357).

Post-thesis application of calming to 2D MHD-B with Ohmic heating. Different dimension/equations from the original 3D MHD target; convergence assumes original solutions exist.

Location: Abstract; first posted 6 October 2024.

### P20 Complexity of diameter on AT-free graphs is linear

Oleksiy Al-saadi; Jitender Deogun. 2022. [historical withdrawn full text](https://arxiv.org/abs/2209.00110).

Withdrawn pre-dissertation AT-free/polar-pair preprint. It does not establish the arbitrary-k polar-target conjecture.

Location: Historical v3 Section 8, PDF p. 16; current v4 withdrawal retained.

**Withdrawn:** arXiv v4 is withdrawn: problems with certain cases when determining diameter at low diameter. Current version has no PDF; earlier abstract claims are not accepted as verified results.

### P21 Diameter Constraints in 2-distance Graphs

Oleksiy Al-saadi; Joseph Natal. 2025. [abstract and metadata](https://arxiv.org/abs/2501.01575).

Later article in graph-distance research; different target from distant asteroidal polar-target existence.

Location: Abstract; 2 January 2025.

### P22 Gordian Distance and Complete Alexander Neighbors

Ana Wright. 2022. [full text relevant sections](https://arxiv.org/html/2210.07728v1).

Question 1.2 is the same existence question as dissertation Question 3.2. This is an earlier formulation, and the inspected article has no matching numbered conjectures for all later thesis refinements.

Location: v1, 14 October 2022; Question 1.2.

### P23 The falsification by fellow traveler property implies geodesic autostackability

Ash DeClerk. 2022. [abstract and metadata](https://arxiv.org/abs/2209.11912).

Explicitly states that automaticity and finite convergent rewriting were not known; proves the weaker geodesic-autostackability conclusion. Predates the thesis.

Location: Abstract; 24 September 2022.

### P24 Geometry of Rounding

Jason Vander Woude; Peter Dixon; A. Pavan; Jamie Radcliffe; N. V. Vinodchandran. 2022. [abstract and metadata](https://arxiv.org/abs/2211.02694).

Earlier introduction of the secluded-partition problem, construction and parameter tradeoffs.

Location: Abstract; 4 November 2022.

### P25 Geometry of Rounding: Near Optimal Bounds and a New Neighborhood Sperner’s Lemma

Jason Vander Woude; Peter Dixon; A. Pavan; Jamie Radcliffe; N. V. Vinodchandran. 2023. [abstract and metadata](https://arxiv.org/abs/2304.04837).

Earlier manuscript establishing logarithmic-factor bounds; overlaps dissertation results, so it is not all later progress.

Location: Abstract; 10 April 2023.

### P26 Replicability in Learning: Geometric Partitions and KKM-Sperner Lemma

Jason Vander Woude; Peter Dixon; A. Pavan; Jamie Radcliffe; N. V. Vinodchandran. 2024. [full text relevant sections](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html).

Later peer-reviewed presentation of overlapping work. Its bounds leave a logarithmic gap and its conclusion poses further norm/sample-complexity/color-bound questions; this is not an exact solution of the stronger thesis bounds.

Location: NeurIPS 2024; paper Sections 3 and 6, PDF viewer pages 9–10; DOI 10.52202/079017-2508.

### P27 Generalized saturation problems for cliques, paths, and stars

Jamie Radcliffe; Adam Volk. 2021. [full text relevant sections](https://arxiv.org/html/2101.04213v4).

Question 5.3 repeats the eventual split-graph path-minimizer question; concluding remarks retain cherry minimization and even-star/minimizer regimes. Predates the thesis. The generated HTML date conflicts with the arXiv version banner; use submission history, not a rendered build date, for chronology.

Location: v4 banner: 17 August 2021; Question 5.3 and Section 7.

### P28 Codes based on dyadic matrices and their generalizations

Meraiah Martinez; Tefjol Pllaha; Christine A. Kelley. 2025. [public full text transcription](https://www.aimsciences.org/article/id/675c0e92d0b64a5d1d3497e9).

Journal version of the dyadic/n-adic code research, subsequently cited and extended by P11.

Location: Public manuscript Section 8, pp. 22–23; DOI/title/author identity matches publisher.

### P29 On the Periodicity of k-distance Graphs

Gregory Demo; David Lund; Oleksiy Al-saadi. 2026. [full text screened](https://arxiv.org/html/2606.25493v1).

Later distance-graph work by the dissertation author; cites P21 in reference [1].

Location: Conjecture 1; Section 4.

### P30 Tri-plane diagrams for simple surfaces in S^4

Wolfgang Allred; Manuel Aragón; Zack Dooley; Alexander Goldman; Yucong Lei; Isaiah Martinez; Nicholas Meyer; Devon Peters; Scott Warrander; Ana Wright; Alexander Zupan. 2023. [full text screened](https://arxiv.org/html/2302.08431v1).

Additional coauthored surface-topology paper listed on Wright’s scholarship page; not an answer to the Alexander-neighbor knot question.

Location: Section 6, Questions 6.1–6.5.

### P31 List and Certificate Complexities in Replicable Learning

Peter Dixon; A. Pavan; Jason Vander Woude; N. V. Vinodchandran. 2023. [full text screened](https://arxiv.org/html/2304.02240v1).

Missing author-paper backfill; later bandit and RL papers explicitly build on its list-replicability framework.

Location: Section 6; cited by F04 and F05.

### P32 Towards a Sum-of-Squares Proof for the Nonexistence of Conway’s 99-graph

Joseph Natal; Oleksiy Al-saadi. 2026. [full text screened](https://arxiv.org/html/2610.16266v1).

Later coauthored preprint. Its relaxed triangle bound fails an exact finite check; its abstract’s nonexistence conclusion is not accepted here.

Location: Section 1; Conjecture 5; final paragraph of Section 3.2.

### P33 Neighborhood Variants of the KKM Lemma, Lebesgue Covering Theorem, and Sperner’s Lemma on the Cube

Jason Vander Woude; Peter Dixon; A. Pavan; Jamie Radcliffe; N. V. Vinodchandran. 2023. [full text screened](https://arxiv.org/html/2306.12593v1).

Missing overlapping author-paper version; Question 4.1 repeats the dissertation’s neighborhood-color range target.

Location: Section 4, Question 4.1 and conclusion.

### P34 Graphical Analysis of Lifted Product Code Constructions

Ragnar Freij-Hollanti; Kirsten D. Morris; Patricija Šapokaitė. 2026. [full text relevant sections](https://arxiv.org/html/2606.11987v1).

Scholar author search and P09 cited-by results. Reference [12] cites Morris–Pllaha–Kelley. Sections 3–4 give connectivity and minimal-absorbing-set results for the specified single-base-matrix lifted-product family; Section 5 leaves sufficient girth-eight conditions and decoding-oriented design questions.

Location: Section 5 after Theorem 5.1 and conclusion.

## Related coauthor and external articles and later talks

### F01 Overcoming the Randomness-Utility Trade-off in Answering Differentially Private Linear Queries

Surendra Ghentiyala; Pritish Kamath; Ravi Kumar; Pasin Manurangsi. 2026. [independent citation and related extension](https://arxiv.org/html/2609.02880v1).

Section 1.2 and references WDP+22/23/24 explicitly cite P24/P25/P26; Section 3 develops multi-scale secluded partitions. The AI Disclosure Statement reports Lean4 checking of a construction. No public matching Lean artifact was verified in this follow-up, and no exact thesis conjecture resolution is credited. The new paper’s privacy parameter epsilon is not automatically the thesis partition tolerance.

### F02 Velocity-vorticity formulation of the three dimensional generalized Navier-Stokes equations: Effect of algebraic calming on well-posedness, convergence, determining wavenumber and regularity criteria

Le Tran Tinh. 2026. [independent citation and restricted result](https://www.aimsciences.org/article/doi/10.3934/dcdsb.2025153).

Full public text recovered. Theorems 3.2(a) and 3.3(a) state weak existence for alpha >= 1 and uniqueness for alpha >= 5/4, assuming the specified smooth bounded calming function and derivative bound. References 17–19 cite the Enlow article family. The higher-dissipation uniqueness theorem does not cover the alpha=1 dissertation regime; damping and calming hypotheses must also be preserved. No matching proof-assistant artifact identified or built.

### F03 Generalized saturation game

Balázs Patkós; Miloš Stojaković; Jelena Stratijev; Máté Vizer. 2025. [independent citation related problem](https://arxiv.org/html/2404.02288v2).

Introduction cites generalized saturation research; reference 15 is Radcliffe–Volk P27. The later paper studies a game variant and states its own unresolved exact-score questions. Journal DOI 10.1016/j.dam.2025.05.014. A game saturation number is not the static extremal minimum. No resolution of the six selected Volk questions is credited; preprint first posted 2024.

### T01 The Alexander Polynomial and Gordian Distance

Ana Wright. 2024. [later conference abstract exact question](https://pages.charlotte.edu/stdc2024/wp-content/uploads/sites/1340/2024/03/STDC_2024_Book_of_Abstracts.pdf).

STDC 2024 abstract, printed page 45, says the nontrivial-Alexander complete-neighbor existence question is unknown and discusses unresolved cases. A conference abstract is evidence of later discussion, not an additional journal article or proof.

### T02 Groupoids of Configurations of Lines

Jake Kettinger. 2025. [later seminar mentions research](https://math.tulane.edu/~kmincheva/seminarAC_F25.html).

12 November 2025 seminar abstract credits Brian Harbourne and Allison Ganger for investigating groupoids motivated by geproci sets. This verifies later acknowledgment of the research family, not a reference to or answer to Remark 6.4. No topic-matched Ganger article was verified in this search.

### F04 List Replicable Reinforcement Learning

Bohan Zhang; Michael Chen; A. Pavan; N. V. Vinodchandran; Lin F. Yang; Ruosong Wang. 2025. [coauthor or citation expansion](https://arxiv.org/html/2512.00553v1).

Later work by coauthors Pavan and Vinodchandran; explicitly cites P31 and F05. PAC policies and policy traces differ from secluded-partition extremizers. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F05 Regret-Optimal List Replicable Bandit Learning: Matching Upper and Lower Bounds

Michael Chen; A. Pavan; N. V. Vinodchandran; Ruosong Wang; Lin Yang. 2025. [coauthor or citation expansion](https://proceedings.iclr.cc/paper_files/paper/2025/file/0faa0019b0a8fcab8e6476bc43078e2e-Paper-Conference.pdf).

Later coauthor work; cites P31 and extends list replicability to multi-armed and linear bandits. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F06 On a Partial Voigt Regularization of the 3D Magnetohydrodynamic Equations in Velocity-Vorticity Form

Adam Larios; Yuan Pei. 2026. [coauthor or citation expansion](https://arxiv.org/html/2605.05139v1).

Later work by Enlow’s coauthors Larios and Pei. Voigt regularization differs from algebraic calming. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F07 Oriented Matroids and Combinatorial Neural Codes

Alexander Kunin; Caitlin Lienkaemper; Zvi Rosen. 2020. [coauthor or citation expansion](https://arxiv.org/html/2002.03542v2).

Earlier paper by Geraci’s coauthor Kunin, recovered through the expanded search; its convex-polytope conjecture is explicitly restated by F08. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F08 Covering Relations in the Poset of Combinatorial Neural Codes

R. Amzi Jeffs; Trong-Thuc Trang. 2025. [coauthor or citation expansion](https://arxiv.org/html/2512.04241v1).

Independent downstream paper citing F07. Conjecture 1.3 restates F07 Question 6.3; covering-relation progress does not settle the convex-polytope conjecture. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F09 Nonlocal Boundary Conditions for Truncated-Fractional Differential Equations Posed on Bounded Domains

Mikil Foss; Adam Larios; Michael Pieper. 2026. [coauthor or citation expansion](https://arxiv.org/html/2609.27002v1).

Related nonlocal-operator work by Heitzman’s advisor and Enlow’s coauthor. This is a topic/advisor connection, not a verified citation to Heitzman’s dissertation. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F10 Fractional Voigt-regularization of the 3D Navier–Stokes and Euler equations: Global well-posedness and limiting behavior

Zdzisław Brzeźniak; Adam Larios; Isabel Safarik. 2024. [coauthor or citation expansion](https://arxiv.org/html/2410.23492v1).

Work by coauthor Larios on a different regularization; published in 2025. It does not resolve weak uniqueness for calmed velocity–vorticity. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F11 Data Assimilation in Large Eddy Simulation: Addressing Model-Observation Mismatch from Navier-Stokes Data

Adam Larios; Ali Pakzad; Nicholas White. 2025. [coauthor or citation expansion](https://arxiv.org/html/2508.07492v1).

Later coauthor work; conjectures removal of a smallness condition for its own assimilation system. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F12 Replicable Composition

Kiarash Banihashem; MohammadHossein Bateni; Hossein Esfandiari; Samira Goudarzi; MohammadTaghi Hajiaghayi. 2026. [coauthor or citation expansion](https://arxiv.org/html/2604.10423v1).

Independent topic follow-up citing Dixon et al.; proves a non-adaptive composition theorem, a different target from neighborhood-color bounds. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F13 Neural codes via homological invariants of polarized neural ideals

Selvi Kara; Ellie Lew. 2026. [coauthor or citation expansion](https://arxiv.org/html/2602.16993v1).

Independent neural-ideal paper citing the Kunin-related polar-complex literature. Its polarized-ideal invariants differ from Geraci’s Boolean-rank invariants. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F14 The Randomness Complexity of Differential Privacy

Clément L. Canonne; Francis E. Su; Salil P. Vadhan. 2025. [coauthor or citation expansion](https://drops.dagstuhl.de/storage/00lipics/lipics-vol325-itcs2025/LIPIcs.ITCS.2025.27/LIPIcs.ITCS.2025.27.pdf).

Independent downstream use of deterministic rounding schemes, explicitly crediting Vander Woude et al.; later algorithmic progress is in F18. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F15 Quantum CSS LDPC Codes based on Dyadic Matrices for Belief Propagation-based Decoding

Alessio Baldelli; Massimo Battaglioni; Jonathan Mandelbaum; Sisi Miao; Laurent Schmalen. 2026. [coauthor or citation expansion](https://arxiv.org/html/2601.08636v1).

Independent downstream code constructions; references [15] and [16] cite Martinez’s 2022 and 2025 code papers. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F16 Spectral and Additive Combinatorial Methods for Cycles and Absorbing Sets in Lifted-Product Quantum LDPC Codes

Aida Abiad; Nichola Castriota. 2026. [coauthor or citation expansion](https://arxiv.org/html/2607.13666v1).

Independent downstream article explicitly cites Morris–Pllaha–Kelley, claims a restricted (3,3) absorbing-set enumeration, and acknowledges Morris. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F17 High-Rate Quasi-Dyadic Quantum LDPC Codes

Alessio Baldelli; Sisi Miao; Laurent Schmalen; Massimo Battaglioni; Marco Baldi. 2026. [coauthor or citation expansion](https://arxiv.org/html/2609.24201v1).

Independent downstream paper citing Martinez–Kelley [13] and P11 [16]; construction progress is not an exact rank/support-conjecture repetition. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F18 Efficient derandomization of differentially private counting queries

Surendra Ghentiyala. 2025. [coauthor or citation expansion](https://arxiv.org/html/2510.16959v1).

Later answer to F14’s request for an efficient construction, with a closely related parameter tradeoff; first preprint 2025, SOSA publication 2026. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F19 Low-Density Parity-Check Codes of High Girth from Permutation Polynomials

Tasawwar Hussain; Anthony Gómez-Fonseca; Tefjol Pllaha. 2026. [coauthor or citation expansion](https://arxiv.org/html/2610.03341v1).

Later work by P11 coauthors Gómez-Fonseca and Pllaha; noncommuting polynomial lifts differ from dyadic signatures. Relation and source-posed questions were checked; no complete resolution of an original dissertation target is certified by this record.

### F20 Betti numbers of inductively pierced codes

Hugh Geller; Rebecca R.G.; Alexandra Seceleanu; Nora Youngs. 2026. [browser discovered related paper](https://arxiv.org/html/2605.24181v1).

Scholar coauthor lead through Seceleanu. The acknowledgment names Juliann Geraci. Theorem 4.9 gives a bidegree Betti formula for inductively pierced codes. This is restricted related progress toward F13 Question 10.3, not a formula for arbitrary codes or their full fine multigrading. No explicit remaining target was identified in the full-text screen. Primary text screened for explicit targets and scope; published proofs not independently certified and no Lean artifact built.

### F21 From neural codes to homological invariants: regularity and projective dimension of polarized neural ideals

Trung Chau. 2025. [browser discovered related paper](https://arxiv.org/html/2511.19043v1).

Discovered through an X arXiv announcement. Related algebraic precursor; references shared neural-ideal sources. The introduction explicitly uses a broader class of squarefree monomial ideals with no generator divisible by x_i y_i. Its separate ranges of projective dimension and regularity do not settle F13 Question 10.2 about achievable pairs for actual neural codes. No new explicit open target was identified. Primary text screened for explicit targets and scope; published proofs not independently certified and no Lean artifact built.

### F22 A polylogarithmic bound for list replicability

Ari Blondal; Hamed Hatami; Pooya Hatami; Chavdar Lalov; Sivan Tretiak. 2026. [browser discovered related paper](https://arxiv.org/html/2610.20657v1).

Scholar P31 cited-by results, sorted by date; author announcement on X independently located. Theorem 1.1 proves the O(log^2 M log N) list-size bound; it gives no quantitative sample-complexity or efficiency guarantee. This improves toward, but does not prove, F24 Conjecture 1.15. The manuscript credits Zhang’s earlier announcement and says it contains no new results. Primary text screened for explicit targets and scope; published proofs not independently certified and no Lean artifact built.

### F23 Tight list replicability bounds via a novel sphere covering theorem

Ari Blondal; Hamed Hatami; Pooya Hatami; Chavdar Lalov; Sivan Tretiak. 2026. [browser discovered related paper](https://arxiv.org/html/2606.06148v1).

Scholar P31 cited-by results. Explicitly cites Dixon–Pavan–Vander Woude–Vinodchandran and related geometric/topological work. New bounds and open Questions 2.4–2.6 concern list size, accuracy and margin regimes, not the P31 sample/certificate gap. Primary text screened for explicit targets and scope; published proofs not independently certified and no Lean artifact built.

### F24 Sign-Rank, Index, and List Replicability: Connections and Separations

Ari Blondal; Hamed Hatami; Pooya Hatami; Chavdar Lalov; Sivan Tretiak. 2026. [browser discovered related paper](https://arxiv.org/html/2606.18236v1).

Scholar P31 cited-by results and X announcement. References the P31 framework. Section 1.3 poses a logarithmic product bound and VC-dimension questions. Later F22 gives a weaker logarithmic bound; arbitrary VC-dimension-only bounds are not settled by that cardinality-dependent theorem. Primary text screened for explicit targets and scope; published proofs not independently certified and no Lean artifact built.

## Question by question cross references

“Not verified” is a bounded search result. A related paper listed next to a question is not automatically evidence that the question itself was restated. The original page references and hypotheses remain in [the coverage ledger](../audit/claims.json). Research directions outside those 40 targets are described in the paper records, especially the Morris/Martinez and Grantham follow-ups.

| Target | Finding | Article or follow-up records | Interpretation |
| --- | --- | --- | --- |
| 2026-Geraci-O01 — Question 5.1 | changed question later revision | [P01](https://arxiv.org/html/2509.09570v2) | Later Question 6.1 is regularity versus Ferrers cover, whereas the thesis names Ferrers versus biclique cover. The fixed-vertex issue is not silently repaired. |
| 2026-Geraci-O02 — Question 5.2 | same question pre dissertation | [P02](https://arxiv.org/html/2603.10837v1) | Exact conceptual counterpart in Question 7.1 (canonical form) or Conjecture 7.3 (redundancy equality). |
| 2026-Geraci-O03 — Section 5.4 conjectural equality | same question pre dissertation | [P02](https://arxiv.org/html/2603.10837v1) | Exact conceptual counterpart in Question 7.1 (canonical form) or Conjecture 7.3 (redundancy equality). |
| 2025-Zamir-O01 — Chapter 9 problem 2 / Problem 8.3 | same question pre dissertation | [P14](https://arxiv.org/html/2406.08602v2), [P15](https://arxiv.org/html/2510.17029) | P14 Section 8 items 2 and 5 repeat the selected problems; P15 is a later application in related weighted geometry, not a verified solution. |
| 2025-Zamir-O02 — Chapter 9 problem 5 | same question pre dissertation | [P14](https://arxiv.org/html/2406.08602v2), [P15](https://arxiv.org/html/2510.17029) | P14 Section 8 items 2 and 5 repeat the selected problems; P15 is a later application in related weighted geometry, not a verified solution. |
| 2024-Ganger-O01 — Remark 6.4 | no exact reappearance verified | None verified | Searches of the author/topic and selected citing literature did not verify a repetition or resolution of this particular target. This is not evidence of absence. |
| 2024-Lieberman-O01 — Questions 3.27 and 4.5 | related criteria and scope clarification | [P16](https://arxiv.org/html/2403.13146v1) | General Bernstein inequality is false without restrictions. The coauthored paper gives valid classes and sufficient criteria, rather than a universal affirmative answer or a later resolution. |
| 2024-Lieberman-O02 — Question 6.2 | related criteria and scope clarification | [P16](https://arxiv.org/html/2403.13146v1) | General Bernstein inequality is false without restrictions. The coauthored paper gives valid classes and sufficient criteria, rather than a universal affirmative answer or a later resolution. |
| 2024-Enlow-O01 — Calmed velocity–vorticity weak uniqueness | later related model higher dissipation only | [P17](https://arxiv.org/abs/2312.17371), [P18](https://arxiv.org/abs/2304.10493), [P19](https://arxiv.org/abs/2410.04357), [F02](https://www.aimsciences.org/article/doi/10.3934/dcdsb.2025153) | Full text now inspected: Theorems 3.2–3.3 establish weak existence for alpha >= 1 but uniqueness only for alpha >= 5/4, under smooth bounded calming/derivative assumptions. Thus the alpha=1 dissertation weak-uniqueness question is not resolved by these theorems. |
| 2024-Enlow-O02 — Calmed velocity–vorticity attractor | no exact reappearance verified | [P17](https://arxiv.org/abs/2312.17371), [P18](https://arxiv.org/abs/2304.10493), [P19](https://arxiv.org/abs/2410.04357) | Calmed NSE attractors, calmed KSE global solutions, and 2D MHD-B are different targets from these VV/original-equation questions. |
| 2024-Enlow-O03 — Original MHD global well-posedness | no exact reappearance verified | [P17](https://arxiv.org/abs/2312.17371), [P18](https://arxiv.org/abs/2304.10493), [P19](https://arxiv.org/abs/2410.04357) | Calmed NSE attractors, calmed KSE global solutions, and 2D MHD-B are different targets from these VV/original-equation questions. |
| 2024-Enlow-O04 — Original two-dimensional KSE global well-posedness | no exact reappearance verified | [P17](https://arxiv.org/abs/2312.17371), [P18](https://arxiv.org/abs/2304.10493), [P19](https://arxiv.org/abs/2410.04357) | Calmed NSE attractors, calmed KSE global solutions, and 2D MHD-B are different targets from these VV/original-equation questions. |
| 2024-Al-O01 — Conjecture 57.1 | no exact reappearance verified | [P20](https://arxiv.org/abs/2209.00110), [P21](https://arxiv.org/abs/2501.01575) | Polar-pair/AT-free and later 2-distance-graph articles do not verify the arbitrary-k polar-target conjecture. |
| 2023-Wright-O01 — Question 3.2 | same question pre dissertation and later talk | [P22](https://arxiv.org/html/2210.07728v1), [T01](https://pages.charlotte.edu/stdc2024/wp-content/uploads/sites/1340/2024/03/STDC_2024_Book_of_Abstracts.pdf) | P22 Question 1.2 is the same existence question; a 2024 conference abstract explicitly revisits it as unresolved. |
| 2023-Wright-O02 — Conjecture 3.8 | no exact reappearance verified | [P22](https://arxiv.org/html/2210.07728v1) | The inspected 2022 article does not establish repetition or resolution of these later thesis conjectures. Existence of related exclusions does not settle them. |
| 2023-Wright-O03 — Conjecture 3.9 | no exact reappearance verified | [P22](https://arxiv.org/html/2210.07728v1) | The inspected 2022 article does not establish repetition or resolution of these later thesis conjectures. Existence of related exclusions does not settle them. |
| 2023-Wright-O04 — Conjecture 3.10 | no exact reappearance verified | [P22](https://arxiv.org/html/2210.07728v1) | The inspected 2022 article does not establish repetition or resolution of these later thesis conjectures. Existence of related exclusions does not settle them. |
| 2023-Wright-O05 — Conjecture 3.12 | no exact reappearance verified | [P22](https://arxiv.org/html/2210.07728v1) | The inspected 2022 article does not establish repetition or resolution of these later thesis conjectures. Existence of related exclusions does not settle them. |
| 2023-DeClerk-O01 — FFTP automaticity question | same question pre dissertation | [P23](https://arxiv.org/abs/2209.11912) | Both unresolved properties are explicitly mentioned in the abstract; geodesic autostackability is a weaker conclusion. |
| 2023-DeClerk-O02 — FFTP finite convergent rewriting question | same question pre dissertation | [P23](https://arxiv.org/abs/2209.11912) | Both unresolved properties are explicitly mentioned in the abstract; geodesic autostackability is a weaker conclusion. |
| 2023-Vander-Woude-O01 — Conjecture 4.3.1 | no exact reappearance verified | [P24](https://arxiv.org/abs/2211.02694), [P25](https://arxiv.org/abs/2304.04837), [P26](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html), [F01](https://arxiv.org/html/2609.02880v1) | The later publication and independent citation verify research-family uptake, not a verified reference to or resolution of this exact conjecture. |
| 2023-Vander-Woude-O02 — Conjecture 4.4.1 | no exact reappearance verified | [P24](https://arxiv.org/abs/2211.02694), [P25](https://arxiv.org/abs/2304.04837), [P26](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html), [F01](https://arxiv.org/html/2609.02880v1) | The later publication and independent citation verify research-family uptake, not a verified reference to or resolution of this exact conjecture. |
| 2023-Vander-Woude-O03 — Conjecture 7.3.1 | later related bounds and applications | [P24](https://arxiv.org/abs/2211.02694), [P25](https://arxiv.org/abs/2304.04837), [P26](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html), [F01](https://arxiv.org/html/2609.02880v1) | Later NeurIPS publication studies the same tolerance/degree or neighborhood-color program; bounds retain gaps. F01 explicitly cites the article family and extends the machinery, not a verified exact conjecture solution. |
| 2023-Vander-Woude-O04 — Conjecture 7.3.2 | later related bounds and applications | [P24](https://arxiv.org/abs/2211.02694), [P25](https://arxiv.org/abs/2304.04837), [P26](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html), [F01](https://arxiv.org/html/2609.02880v1) | Later NeurIPS publication studies the same tolerance/degree or neighborhood-color program; bounds retain gaps. F01 explicitly cites the article family and extends the machinery, not a verified exact conjecture solution. |
| 2023-Vander-Woude-O05 — Conjecture 7.3.3 | later related bounds and applications | [P24](https://arxiv.org/abs/2211.02694), [P25](https://arxiv.org/abs/2304.04837), [P26](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html), [F01](https://arxiv.org/html/2609.02880v1) | Later NeurIPS publication studies the same tolerance/degree or neighborhood-color program; bounds retain gaps. F01 explicitly cites the article family and extends the machinery, not a verified exact conjecture solution. |
| 2023-Vander-Woude-O06 — Conjecture 7.3.4 | later related bounds and applications | [P24](https://arxiv.org/abs/2211.02694), [P25](https://arxiv.org/abs/2304.04837), [P26](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html), [F01](https://arxiv.org/html/2609.02880v1) | Later NeurIPS publication studies the same tolerance/degree or neighborhood-color program; bounds retain gaps. F01 explicitly cites the article family and extends the machinery, not a verified exact conjecture solution. |
| 2023-Vander-Woude-O07 — Conjecture 7.3.5 | no exact reappearance verified | [P24](https://arxiv.org/abs/2211.02694), [P25](https://arxiv.org/abs/2304.04837), [P26](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html), [F01](https://arxiv.org/html/2609.02880v1) | The later publication and independent citation verify research-family uptake, not a verified reference to or resolution of this exact conjecture. |
| 2023-Vander-Woude-O08 — Conjecture 7.3.6 | no exact reappearance verified | [P24](https://arxiv.org/abs/2211.02694), [P25](https://arxiv.org/abs/2304.04837), [P26](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html), [F01](https://arxiv.org/html/2609.02880v1) | The later publication and independent citation verify research-family uptake, not a verified reference to or resolution of this exact conjecture. |
| 2023-Vander-Woude-O09 — Conjecture 9.2.13 | no exact reappearance verified | [P24](https://arxiv.org/abs/2211.02694), [P25](https://arxiv.org/abs/2304.04837), [P26](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html), [F01](https://arxiv.org/html/2609.02880v1) | The later publication and independent citation verify research-family uptake, not a verified reference to or resolution of this exact conjecture. |
| 2023-Vander-Woude-O10 — Conjecture 9.6.7 | no exact reappearance verified | [P24](https://arxiv.org/abs/2211.02694), [P25](https://arxiv.org/abs/2304.04837), [P26](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html), [F01](https://arxiv.org/html/2609.02880v1) | The later publication and independent citation verify research-family uptake, not a verified reference to or resolution of this exact conjecture. |
| 2023-Vander-Woude-O11 — Conjecture 9.7.9 | no exact reappearance verified | [P24](https://arxiv.org/abs/2211.02694), [P25](https://arxiv.org/abs/2304.04837), [P26](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html), [F01](https://arxiv.org/html/2609.02880v1) | The later publication and independent citation verify research-family uptake, not a verified reference to or resolution of this exact conjecture. |
| 2023-Vander-Woude-O12 — Conjecture 10.2.17 | no exact reappearance verified | [P24](https://arxiv.org/abs/2211.02694), [P25](https://arxiv.org/abs/2304.04837), [P26](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html), [F01](https://arxiv.org/html/2609.02880v1) | The later publication and independent citation verify research-family uptake, not a verified reference to or resolution of this exact conjecture. |
| 2023-Vander-Woude-O13 — Question 8.3.2 | later related bounds and applications | [P24](https://arxiv.org/abs/2211.02694), [P25](https://arxiv.org/abs/2304.04837), [P26](https://papers.neurips.cc/paper_files/paper/2024/hash/8ff87c96935244b63503f542472462b3-Abstract-Conference.html), [F01](https://arxiv.org/html/2609.02880v1) | Later NeurIPS publication studies the same tolerance/degree or neighborhood-color program; bounds retain gaps. F01 explicitly cites the article family and extends the machinery, not a verified exact conjecture solution. |
| 2022-Volk-O01 — Questions 1 and 5 | related open regime pre dissertation | [P27](https://arxiv.org/html/2101.04213v4), [F03](https://arxiv.org/html/2404.02288v2) | P27 Section 7 discusses cherry minimization, construction thresholds, or even-star/minimizer regimes. This is related earlier problem discussion, not an exact later resolution. |
| 2022-Volk-O02 — Question 2 | same question pre dissertation | [P27](https://arxiv.org/html/2101.04213v4), [F03](https://arxiv.org/html/2404.02288v2) | P27 Question 5.3 is the split-graph path-minimization question. F03 cites that work but studies a different game parameter. |
| 2022-Volk-O03 — Conjecture 1 | no exact reappearance verified | [P27](https://arxiv.org/html/2101.04213v4), [F03](https://arxiv.org/html/2404.02288v2) | Searches of the author/topic and selected citing literature did not verify a repetition or resolution of this particular target. This is not evidence of absence. |
| 2022-Volk-O04 — Question 3 | related open regime pre dissertation | [P27](https://arxiv.org/html/2101.04213v4), [F03](https://arxiv.org/html/2404.02288v2) | P27 Section 7 discusses cherry minimization, construction thresholds, or even-star/minimizer regimes. This is related earlier problem discussion, not an exact later resolution. |
| 2022-Volk-O05 — Question 4 | related open regime pre dissertation | [P27](https://arxiv.org/html/2101.04213v4), [F03](https://arxiv.org/html/2404.02288v2) | P27 Section 7 discusses cherry minimization, construction thresholds, or even-star/minimizer regimes. This is related earlier problem discussion, not an exact later resolution. |
| 2022-Volk-O06 — Question 6 | no exact reappearance verified | [P27](https://arxiv.org/html/2101.04213v4), [F03](https://arxiv.org/html/2404.02288v2) | Searches of the author/topic and selected citing literature did not verify a repetition or resolution of this particular target. This is not evidence of absence. |
| 2025-Barrett-O01 — Question 1 / universality discussion | no exact reappearance verified | None verified | Searches of the author/topic and selected citing literature did not verify a repetition or resolution of this particular target. This is not evidence of absence. |

## Search gaps worth resolving next

The full-text access gap for Le Tran Tinh’s article is closed: its weak-uniqueness theorem requires alpha >= 5/4 and does not cover alpha=1. The remaining article access gap is P10, the IEEE redundancy paper; it needs a licensed or author-provided copy. See [gap closure evidence](COVERAGE-GAPS.md). For the secluded-partition work, a public Lean repository with declaration names and an axiom report would allow a formalization audit of the claimed construction. The October 22 coauthor and citation expansion is documented in [the new search report](SCHOLARLY-EXPANSION.md); pending candidates and remaining limits are explicit there. The current Lean audit remains a historical snapshot and is not overwritten by author-reported mechanization in a different, related paper.
