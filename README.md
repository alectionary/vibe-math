# vibe-math

A research collection covering 20 doctoral dissertations from 2022–2026: 16 mathematics, 3 statistics and 1 computing (graph theory). The source PDFs total 3,013 pages; exact metadata and SHA-256 hashes are in `source-manifest.json`.

[Publication status and dated audit records](PUBLICATION-STATUS.md).

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
