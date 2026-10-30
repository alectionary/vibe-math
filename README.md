**Connected quantum-decoding follow-up:** A fifteen-qubit asymmetric CSS code has a connected actual Tanner graph and no stabilizer product split across any physical partition, yet all128 Z-errors on a (7,0)-absorbing support recover in at most one Gallager-B iteration under both syndrome tests. This addresses the disconnected-factor weakness of the earlier example. [Paper, exact limits and complete Lean proof](formalization/gallager-b-absorbing/connected/README.md). The equal-space CSS follow-up now has a general odd-support obstruction; its precise even-support existence question remains unresolved. [Parity theorem, paper and remaining question](formalization/gallager-b-absorbing/symmetric/README.md).

**Earlier unrestricted quantum-decoding result.** The unrestricted absorbing-implies-trapping statement in Morris--Pllaha--Kelley, arXiv:2307.14532v2, has an explicit checked counterexample: all128 error supports on a connected (7,0)-absorbing component are accepted at initialization or the first Gallager-B iteration. A separate fourteen-coordinate CSS construction also corrects every supported error in the decoded Z sector modulo the entire opposite stabilizer span. Redundant checks and four-cycles are allowed; its ambient CSS graph has two components. [Paper and complete Lean proof](formalization/gallager-b-absorbing/README.md) · [Tracking issue #2](https://github.com/alectionary/vibe-math/issues/2).

**Useful spectral and incidence replacements are proved.** A fourth-moment criterion gives stopping distance at least gamma+1 on explicit sparse nontrivial QC-GHP families, without the original small-gap or small-branch premise. A separate family has exact stopping/logical distance6, and Gram twins give an unbounded restricted obstruction. The original Proposition5.1 parameter question stays answered negatively. [Paper, complete Lean URLs and evidence](formalization/stopping-bound/stronger/README.txt).

# vibe-math

Original code is licensed under [Apache-2.0](LICENSE), within the [defined code scope and exclusions](LICENSING.md). Papers, data, third-party inputs and other excluded material are not covered by that new grant; see the [rights and provenance inventory](THIRD_PARTY.md).

**Latent-factor replication: Moss (2020).** All20 selected reliability estimates match at three decimals, with all10 selected score-weighting gains preserved. Conditional on the same data and factor models; no population-superiority or validity claim. [Main paper and exact reproduction](formalization/moss-score-reliability/README.md).

Latest bounded distance-preservation theorem: [the strengthened normalized 3x4 cyclic criterion implies dQ≥min(dC,12)](formalization/distance-preservation/truncated12/README.md). Lean checks the actual source matrices, all support cases through weight eleven, both entire stabilizer spans and ordinary Pauli union weight, including literal distance minima and the transpose infinity convention. All 183,312 finite certificates and the complete 269-module research closure pass. The broader equality question remains open. [Exact-source verification](formalization/distance-preservation/truncated12/verification.json).

Truncated-distance research report: [PDF](formalization/distance-preservation/truncated12/paper/main.pdf) · [TeX](formalization/distance-preservation/truncated12/paper/main.tex) · [complete proof guide](formalization/distance-preservation/truncated12/paper/PROOF-GUIDE.html) · [source archive](formalization/distance-preservation/truncated12/paper/truncated-distance-source.zip).

Earlier distance-preservation result: [an infinite girth-eight, RCPC-free counterfamily](formalization/distance-preservation/RESEARCH-NOTE.txt) has dQ≤11<12≤dC≤20 for every positive lift length divisible by11. The fixed classical graph is connected and its transpose code has distance2L. Source-matrix and full stabilizer-span proofs are checked in Lean. This refutes our proposed criterion; the source's broader sufficient-condition question remains open in this project. [Proof audit](formalization/distance-preservation/verification.json).

Distance-preservation report: [PDF](formalization/distance-preservation/paper/main.pdf) · [TeX](formalization/distance-preservation/paper/main.tex) · [complete Lean proof guide](formalization/distance-preservation/paper/PROOF-GUIDE.html) · [source snapshot](formalization/distance-preservation/paper/distance-preservation-source.zip). The manuscript separates the answered diagnostic from the general source question and includes full proof coverage, source chronology and reproducibility records. Local review artifact; no publication is implied.


**Stopping-bound parameter question answered negatively.** A universal Lean-checked theorem proves that no positive-dimensional binary biregular parameter choice in Proposition5.1’s stated scalar-factor QC-GHP model yields a stopping-distance guarantee above two. This is a nonexistence proof, not an unsuccessful search. The raw inequality can hold for dense examples. A stronger incidence replacement is proved in the new follow-up; unrestricted stronger spectral bounds remain a separate direction. [Corrected paper and complete checked proof](formalization/stopping-bound/source-answer/README.txt).

Latest stopping-support classification: all **441** size-six stopping supports of the source B1 matrix are exactly the distinct companion Z-check row supports, in one free Z/7 x Z/63 coordinate-translation orbit. [Paper and checked proofs](formalization/stopping-bound/classification/README.txt). The actual binary matrix bridge and complete classification are checked in Lean. This is supporting progress on L-F16; larger-cover classifications and logical parameters remain outside the claim.

Latest incidence-aware follow-up: [exact stopping distance six for the B1 cyclic-cover check family](formalization/stopping-bound/incidence/RESEARCH-NOTE.txt). At every positive lift length divisible by63, the explicit CSS matrices have bounded degrees3/6 and stopping distance6. Lean checks the source matrices, two-root search, cover bridge, stabilizer witness and CSS commutation. Their actual second squared singular value is at least12, making both Zhu–Chugg two-eigenvalue bounds vacuous whenever their strict gap holds. This is a restricted incidence result; it does not produce parameters meeting Proposition5.1 or establish logical ranks/distances. [Verification](formalization/stopping-bound/incidence/verification.json).

Latest spectral-stopping investigation: [a checked obstruction for the scalar-factor QC-GHP bound](formalization/stopping-bound/RESEARCH-NOTE.txt). For r₁≥2, the actual second squared singular value is at least γ². For r₁=1, the source condition forces density above 3/4 and its large root lies in (1,2], giving only the elementary stopping-distance guarantee two. The exact source-matrix and small-branch bridges are checked in Lean. The new follow-up proves a useful incidence replacement and a restricted Gram obstruction; no additional canonical completion is counted. [Verification](formalization/stopping-bound/verification.json).

A research collection covering 20 doctoral dissertations from 2022–2026: 16 mathematics, 3 statistics and 1 computing (graph theory). The source PDFs total 3,013 pages; exact metadata and SHA-256 hashes are in `source-manifest.json`.

[Publication status and dated audit records](PUBLICATION-STATUS.md).

Latest entry-dynamics follow-up: [where representation-dependent trajectories begin](formalization/cyclic-lifts/ENTRY-DYNAMICS.md). Lean checks the exact initial source-activity criterion, actual-graph message locality, full possible propagation within four updates, and two complete soft-only/delayed-entry examples. A delayed-entry proof checks exactly six sign-reversed outputs at update 2 despite identical incoming states. Another **million fresh paired errors per code** confirms a larger representation penalty on initially active source syndromes, but matching baseline hardness substantially weakens that association. Identical first hard words still contain a descriptive net **451/985** and **571/1,210** extra syndrome failures in this new sample. These are partitions, not new failure certificates: the aggregate explanation remains incomplete. [Current verification manifest](formalization/cyclic-lifts/entry-verification.json).

Latest bounded follow-up: [frozen mechanisms and a fresh million paired errors per code](formalization/cyclic-lifts/LOOP-HOLDOUT.md). Both merger penalties replicate: FER **2.7425%→2.8127%** and **2.6132%→2.7122%**, with both simultaneous 95% intervals above zero. Four finite-horizon interval certificates now pass in Lean. [Two complete mathematical stopping comparisons](formalization/dyadic-rank/CyclicDecoderReachability.lean) start from the fixed prior: originals recover exactly at iterations 65/86, while the merged versions reject through iteration 100. Exact message recurrence and rejecting invariant boxes have zero detected coverage. The stricter persistent-check certificate covers about **13–14%** of syndrome failures, but its certified lost-minus-gained matches are only **1** and **86**, against total syndrome penalties **721** and **986**. This leaves the main structural explanation open.

Latest local mechanism study: [message trajectories and Lean-checked syndrome obstructions](formalization/cyclic-lifts/MERGED-MECHANISM.md). Replaying all **41,181** syndrome-discordant pairs identifies cross-check parity reversal and minimum-magnitude attenuation as the two forms of first message divergence. Lean verifies the exact update identity, both actual matrix-kernel equivalences and four local acceptance obstructions. A split update would accept at a recorded state on **five failed merged trajectories per code**; this establishes a concrete mechanism, with limited coverage of the aggregate penalty. Codes, channel, decoder and noise sample remain fixed.

Latest local experiment: [one million fresh original-versus-merged paired errors](formalization/cyclic-lifts/MERGED-MILLION.md). With the exact code, every variable degree, girth, edges, channel and decoder fixed, merging worsens FER **2.7123%→2.8116%** and **2.5549%→2.6719%**. Both within-code differences exclude zero after a two-contrast adjustment. All two million paired first-step updates and 90 full selected histories are checked. Most net extra failures arise outside initial containment of the gained absorbing supports; check degrees and message routing still prevent a pure count attribution.

Latest local cyclic follow-up: [one million fresh distance-matched paired errors](formalization/cyclic-lifts/MILLION-PAIRED.md). At `p=4%`, the two exact `[[252,10,10]]` codes have failure rates **2.7476% versus 2.5787%**, favoring Minimum 4; the paired difference is **-0.1689 percentage points**, with 95% interval **[-0.2101,-0.1277]**. This supports the fixed-code comparison, without isolating absorbing count as its cause. The [earlier 100,000-pair experiment and exact-distance audit](formalization/cyclic-lifts/DISTANCE-MATCHED.md) remain separately archived.

Mechanism study: [same-code parity-check interventions and trajectories](formalization/cyclic-lifts/REPRESENTATIONS.md). Deleting a redundant check changes absorbing counts while preserving the entire CSS code, channel and decoder algorithm. A fixed 50,000-error pilot finds fewer absorbing supports but worse decoding for both saved codes; six variable degrees also change, so this is a generator-deletion effect rather than an isolated count effect. Exact local-update arithmetic and independently checked trajectories document the distinction.

Latest local feasibility: [degree- and girth-preserving same-code representations](formalization/cyclic-lifts/DEGREE-PRESERVING.md). Merging suitably distant redundant checks preserves every variable degree, girth eight, total edges and the exact CSS code, while changing absorbing counts **2,646→2,764** and **2,520→2,640**. Check count and check degrees change; no new performance experiment is claimed. Keeping 126 nonzero checks as well would force the original representation in these two codes.

## Start here

- **Research lessons:** [what worked and the workflow for the next investigation](RESEARCH-LESSONS.md).
- **Research paper:** [dyadic rank–support formalization (PDF)](formalization/dyadic-rank/paper/output/pdf/dyadic-rank-support.pdf) and [LaTeX source](formalization/dyadic-rank/paper/main.tex).
- **Cyclic lifted-product paper:** [girth-eight characterization and decoding consequences (PDF)](formalization/cyclic-lifts/paper/output/pdf/cyclic-lift-girth-eight.pdf), [results and evidence](formalization/cyclic-lifts/README.md), and [complete Lean proof guide](formalization/cyclic-lifts/paper/LEAN-PROOF-GUIDE.md).

- **Dyadic forbidden-set investigation:** [exact question, prior art, counterchecks and complete Lean checker](formalization/dyadic-forbidden/README.md).
- **Dyadic decoding objectives:** [prior art and prediction studies](formalization/dyadic-performance/README.md), [classical optimization](formalization/dyadic-performance/OPTIMIZATION.md), [literal P11 quantum CSS experiments with stabilizer-aware scoring](formalization/dyadic-performance/QUANTUM.md), and [bounded objective disagreements with exact low-weight ambiguity bounds](formalization/dyadic-performance/TARGETED.md), and [a Lean-checked decoder trajectory obstruction](formalization/dyadic-performance/TRAJECTORIES.md).
- **Dyadic rank theorem:** [complete general Lean proof](formalization/dyadic-rank/README.md).
- **Lean difficulty estimates:** [per-question ratings and assumptions](planning/LEAN-DIFFICULTY.md) and [searchable estimates](planning/difficulty.html).
- **Expanded scholarly search:** [coauthors, citation trails, new questions and counterchecks](literature/SCHOLARLY-EXPANSION.md).
- **Expanded open-problem inventory:** [searchable annotated inventory](literature/open-problems.html) and [method/counts](literature/OPEN-PROBLEMS.md), including the downstream articles; [full-text gap closure](literature/COVERAGE-GAPS.md).
- **Four-variable absorbing counts:** [classical baseline, incidence-corrected complex formulas and a (3,6)-regular matrix-only counterexample](formalization/absorbing-four-zero/RESEARCH-NOTE.txt). [Checked source archive manifest](formalization/absorbing-four-zero/verification.json).
- **Research-to-inventory updates:** [dated results, source-question indexing and remaining project follow-ups](literature/RESEARCH-RECONCILIATION.md), with a [central source index](literature/RESEARCH-SOURCES.md). The current inventory has 287 entries,143 eligible targets and5 complete checked Lean targets. Beezer contributes one conjecture and two broad directions; the existing F16 four-variable count target is completed with the required incidence correction. Earlier cohort snapshots are preserved.
- **Academic literature follow-up:** [author papers and open-problem references](literature/README.md), with a structured [question ledger](literature/problem-links.json).
- **Lean coverage audit:** [counts, scope and evidence](audit/README.md), [searchable ledger](audit/coverage.html), and [structured claims](audit/claims.json).
- Read a paper-specific review using the table below.
- Locally, open `analysis.html` for a searchable overview and `index.html` for the PDF collection.
- `reviews/reviews.json` is the curated structured evidence map.
- `reviews/statement-index.json` is a navigation index of automatically detected numbered headings/mentions.

## Meaning and scope

The AI-assisted reviews map principal mathematical content: definitions and precisely stated results; conventional proofs/derivations; hypotheses and modeling assumptions; prior results used; computational/empirical evidence; unresolved questions/conjectures; and possible first formalization tasks. Each substantive entry cites 1-based PDF viewer pages, including repository cover sheets. They are not a line-by-line verification of every proof or an exhaustive classification of every assertion.

“Proved” reports how a dissertation presents a result, not an independent certification of correctness. “Formalized” as mathematical notation is distinguished from a proof checked by Lean, Coq/Rocq, Isabelle, or another proof assistant. No proof-assistant verification was identified in the PDFs reviewed. The original review did not audit external repositories. A subsequent [bounded external coverage audit](audit/README.md) records selected target-level searches, source revisions, rejected matches, and locally checked background declarations. No exact target match was identified in that search; global absence is not established. Computer algebra, proof-search implementations, exact finite computations, and numerical/statistical experiments are kept separate from kernel-checked formal proofs.

Open-question status is as described in each dissertation. Later papers were not checked to determine whether those questions remain open today. Review-identified proof obligations are explicitly distinguished from author-stated open problems. Introductory restatements and cited background theorems are not all new contributions.

The statement index has 1,170 detected kind/number pairs. It is a search aid: it can include references/restatements and miss unnumbered results. It does not assign individual proof validity or novelty. The manually curated review entries carry the substantive classifications. The separate coverage audit selects 132 eligible named results, 3 derivation groups and 39 open targets; 4 further units need statement clarification. These selected units do not form an exhaustive theorem inventory.

The cyclic paper completes the stated girth-condition criterion and supplies partial decoding-related consequences. A new exhaustive census also finds baseline distance six versus distance at least eight for its three comparison codes. Its fixed-family optimum and one-sector decoding benchmark do not establish a universal objective, causal effect of absorbing counts, or general error-floor law. [Evidence and remaining scope](formalization/cyclic-lifts/README.md#what-is-established-and-what-remains-open).

## Lessons from the cyclic lifted-product investigation

For the next investigation, use the repo-local [Open Question Research skill](.agents/skills/open-question-research/SKILL.md): `Use $open-question-research to tackle <inventory target or source question>.` It applies the lessons below and provides a reusable investigation worksheet. For a continuation, name the existing target and the specific follow-up to keep the scope clear.

When the task is to replicate a published result and write that note, use the [replication paper skill](.agents/skills/replication-paper/SKILL.md).

For GitHub and X research, check available access early using the portable
[research access and setup guide](.agents/skills/open-question-research/references/research-access.md).
GitHub connectors or authenticated `gh` and signed-in browser extensions provide
different routes; verify the needed operation on each machine. Attempt searches
opportunistically while continuing independent work, and account for every required
search at closeout as completed coverage or an explicit access gap. Setup details
and observed locked-screen behavior belong in the access record, not assumptions
about every browser or machine.

This round concerns **coding theory, specifically quantum error-correcting codes**, with graph theory and combinatorics at its mathematical core. Freij-Hollanti, Morris and Šapokaitė's question asks how conditions on an exponent matrix determine girth eight in a cyclic lifted-product Tanner graph, and how the resulting graph structure affects decoding. Absorbing sets and stopping sets connect those graph properties to error correction. The [paper](formalization/cyclic-lifts/paper/main.tex) credits the question and its mathematical predecessors; the [proof guide](formalization/cyclic-lifts/paper/LEAN-PROOF-GUIDE.md) locates the complete formal development.

The following lessons extend the earlier [dyadic rank–support retrospective](RESEARCH-LESSONS.md), as of October 23, 2026:

- **Keep the exact question visible.** Compare each result directly with the source's wording. Proving useful component lemmas does not automatically answer the original question.
- **Separate the main criterion from its consequences.** The girth characterization, absorbing-support bijection, stopping bound, finite optimization and decoding experiment are distinct achievements with different evidence. Record which are general Lean theorems, written proofs or finite computational results.
- **Formalize the connections between representations.** Arithmetic cancellation must produce an actual simple cycle, and the abstract graph must match the expanded parity-check matrix. These bridges are essential parts of the proof.
- **Make definitions explicit.** Nonempty supports, induced check degrees, and counting cycles without duplicating rotations or reversals materially affect the statements.
- **Design fair decoding comparisons.** Preserve code length and dimension, use shared error samples, and count stabilizer-equivalent recovery as success. An absorbing configuration does not automatically cause decoder failure, and improved performance does not by itself isolate its cause.
- **Show the formal work.** A short final theorem invocation hides its supporting development. Include meaningful statements, a dependency diagram and substantive excerpts, with direct links to the complete proofs and an explicit account of remaining informal claims.
- **Preserve reproducibility as the paper evolves.** Pin source links to an immutable revision, bundle the full sources, record dependencies and hashes, and verify the public downloads.
- **Use feedback to improve communication.** Positive reception is encouraging evidence that the work interests readers; correctness and novelty still rest on proofs, source comparisons and review.

### Keeping investigations focused

The October 23 follow-up extended the October 22 answer to the same girth-eight question; it did not resolve a second independent open question. The additional Lean proofs and controlled experiments were substantive, but deeper work on an existing result should not silently substitute for progress on another inventory problem.

- **Name the target before starting.** State the exact source question, what is already answered, and whether the proposed task is a new problem or a follow-up. Make the choice between depth and breadth explicit.
- **Set a stopping condition.** Once the main theorem is complete, give each follow-up a bounded objective and a stopping point. A broad aim such as explaining decoding performance can otherwise expand indefinitely.
- **Measure progress by answered questions.** More Lean declarations, experiments or manuscript pages do not necessarily mean another open question has been resolved. Report completed answers separately from supporting work and partial progress.
- **Separate a mechanism from an aggregate explanation.** A proof explaining particular failed trajectories does not establish the cause of an overall failure-rate difference. A late-state certificate establishes persistence; it does not explain why the decoder entered that state.
- **Control confounds early.** Establish exact distance when comparing different codes. Same-code comparisons improve the controls, but changes to check degrees and message routing still prevent attributing an effect solely to absorbing-set count.
- **Compare complete theorems with prior literature.** Compare hypotheses, conclusions and the translation between constructions, including equivalent results expressed in different terminology. Matching component lemmas alone does not settle whether the complete answer was known.
- **State novelty plainly and proportionately.** Give the strongest supported claim once, with credit to the question's authors and relevant predecessors. Distinguish the earliest complete answer known to us from established ingredients and new formal certificates, without repeatedly burying the result in generic priority qualifications.
- **Separate drafting from external publication.** Internal drafts and GitHub commits do not make a paper "expanded" or make its first external announcement an "update". Present the mathematical argument independently of session history; use version-comparison language only for an established externally announced version or at the user's request.
- **Feed discoveries back into the shared inventory.** Reconcile sources, canonical questions, results, Lean evidence and planning records after each research block. Read new source questions before adding them, deduplicate equivalent ones, and label our proposed follow-ups separately. Regenerate reports with an explicit cohort delta; preserve historical counts and mark unassessed searches or difficulty estimates as unassessed.

End each research block with these three lines:

> **Question answered:** the exact completed claim and its evidence.
>
> **Question still open:** the specific unresolved part and the limit of the current result.
>
> **Next proposed target:** the bounded next task, explicitly labeled as a new problem or a follow-up.

## Reviews

| Year | Dissertation review | Author |
| --- | --- | --- |
| 2026 | [Boolean Rank via Monomial Ideals and Neural Ideals](reviews/2026-Geraci.md) | Juliann Marie Geraci |
| 2026 | [Cohomological Support Varieties Along Ring Maps](reviews/2026-Watson.md) | Ryan Watson |
| 2026 | [Bass Numbers of Veronese Submodules and Lifting the Frobenius Trace](reviews/2026-Murray.md) | Taylor Jeffrey Murray |
| 2026 | [Operator Theoretic Methods for Coupled PDE in General Geometries](reviews/2026-Mu.md) | Yuhao Mu |
| 2025 | [Online Prediction of Streaming Data](reviews/2025-Chanda.md) | Aleena Chanda |
| 2025 | [On Kernels and Antiderivatives of Nonlocal Derivatives](reviews/2025-Heitzman.md) | Alex John Heitzman |
| 2025 | [A Zariski-Nagata Theorem for Smooth Toric Surfaces](reviews/2025-Barrett.md) | Jordan Vincent Barrett |
| 2025 | [Analysis of Graph-based Decoders for Quantum Low Density Parity Check Codes](reviews/2025-Morris.md) | Kirsten Morris |
| 2025 | [Changepoint Detection as Model Selection: A General Framework](reviews/2025-Grantham.md) | Michael A. Grantham |
| 2025 | [Multivariate Mixture Regression Models with Known Group Membership and Informative Priors](reviews/2025-Hasanthika.md) | Pahalapathirage Dona Kalani Hasanthika |
| 2025 | [Interpolation in Weighted Projective Spaces](reviews/2025-Zamir.md) | Shahriyar Roshan Zamir |
| 2024 | [Spreads and Transversals and Their Connection to Geproci Sets](reviews/2024-Ganger.md) | Allison Joan Ganger |
| 2024 | [Making Sandwiches: A Novel Invariant in D-module Theory](reviews/2024-Lieberman.md) | David Lieberman |
| 2024 | [Approximation via Degree Reduction of Nonlinearities with Applications to Turbulent Flows, Flame Fronts, and Magnetohydrodynamics](reviews/2024-Enlow.md) | Matthew Enlow |
| 2024 | [Asteroidal Sets and Dominating Targets in Graphs](reviews/2024-Al.md) | Oleksiy Al-saadi |
| 2023 | [Gordian Distance and Complete Alexander Neighbors](reviews/2023-Wright.md) | Ana Wright |
| 2023 | [Prefix-rewriting: The Falsification by Fellow Traveler Property and Practical Computation](reviews/2023-DeClerk.md) | Ash DeClerk |
| 2023 | [Partitions of R^n with Maximal Seclusion and their Applications to Reproducible Computation](reviews/2023-Vander-Woude.md) | Jason Vander Woude |
| 2023 | [On Dyadic Parity Check Codes and Their Generalizations](reviews/2023-Martinez.md) | Meraiah Martinez |
| 2022 | [Extremal Problems in Graph Saturation and Covering](reviews/2022-Volk.md) | Adam Volk |

## Source documents and reproducibility

PDFs and full-text extracts stay local and are gitignored. This repository tracks original notes and metadata rather than redistributing dissertations. `catalog.json` contains canonical source record/download links. Place downloaded PDFs at the relative filenames shown there; some source PDF downloads require a normal browser session.

```sh
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install -r requirements.txt
python3 scripts/download.py --verify-only
python3 scripts/extract.py
python3 scripts/index_statements.py
python3 scripts/build_reports.py
python3 scripts/validate.py
```

Extraction and heading detection are automated. They do not generate or update the curated mathematical judgments in `reviews/reviews.json`; those require review of the cited source pages. Re-running extraction records current file hashes; compare them with the committed manifest before reviewing changed source files. Formula extraction can lose glyphs/spaces: inspect the PDF for exact notation. Several high-risk statements were also checked visually during the review.

Reviewed October 21, 2026. PDFs remain copyright their respective authors; review text does not imply endorsement by any source institution or dissertation author.


October24 lift-label follow-up: [exact fixed-base counts and a support-free CSS family](formalization/lift-label-elimination/README.txt). Classical cycle-consistency attribution, independent q2 verification and checked Lean versions of every manuscript proof are explicit. This is a project-derived follow-up; the publication cohort had canonical coverage4/112; current inventory counts are linked above.


Lift-label paper: [PDF](papers/lift-label-elimination/main.pdf) · [TeX](papers/lift-label-elimination/main.tex) · [all checked proof files](formalization/lift-label-elimination/PROOFS.md). The manuscript includes the reference chronology and immutable Lean links.

Paper-by-paper source audit: [all encountered absorbing-set papers, extracted questions and access gaps](literature/RESEARCH-QUESTION-SCREENING.md). The screen adds 62 canonical entries from 20 question-contributing papers, including 23 specific mathematical targets; present resolution and Lean discovery remain separately unassessed.

## Structural equation modeling and CFA seed

[89 SEM/CFA/growth/path measurement dissertations plus 10 adjacent IRT/latent-class/exploratory or planned-factor records](literature/unl-sem/README.md) · [CSV](literature/unl-sem/dissertations.csv) · [CFA expansion](literature/unl-sem/CFA-EXPANSION.md) · [Mathematical suitability](literature/unl-sem/FORMALIZATION.md). All 99 authors received downstream searches; 49 selected source works are linked and 30 associated full texts screened. Seven complete dissertations now have question screens; [the retrieval correction](literature/unl-sem/RETRIEVAL-REPAIR.md) distinguishes failed routes from actual access restrictions. Thirteen statistical methods directions are indexed; social theories and empirical-only questions are excluded. Dissertation metadata and the original 20 full reviews remain separate cohorts.
