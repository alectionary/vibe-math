# Lean coverage assessment

Checked October 22, 2026. **One of 108 eligible open-problem targets has a complete verified Lean proof: 0.93%.** One other target has an identified Lean statement without a build audit or proof. For the other 106 targets, the recorded bounded searches have not identified an exact Lean statement. This is coverage of the inventoried questions, not the fraction of every theorem or proof step in the dissertations and papers.

| Disjoint target category | Count | Fraction of 108 |
| --- | ---: | ---: |
| Complete checked Lean proof and matching statement | 1 | 0.93% |
| Additional identified Lean statement, without a verified proof or build audit | 1 | 0.93% |
| No exact Lean statement identified in bounded discovery | 106 | 98.15% |
| Discovery still unassessed | 0 | 0% |

The statement-only entry is Conway’s 99-graph existence problem, recorded as Mathlib’s `proof_wanted conway_99`. That is an explicit request for a proof, not a result settling existence or nonexistence. [Pinned source](https://github.com/leanprover-community/mathlib4/blob/0db93bb44438a03c84317df5f033136cdd14c91f/Wanted/Combinatorics/SimpleGraph/StronglyRegular.lean).

The proved entry is **L-P11-rank-converse**, the general dyadic rank/support theorem. I reran `lake env lean Checks.lean` in the existing project: it exited successfully and printed 66 axiom reports using only `propext`, `Classical.choice` and `Quot.sound`. No `sorryAx` appeared. This rechecks the existing contribution; it adds no newly proved target. [Lean project and theorem scope](../formalization/dyadic-rank/README.md), [recheck output](lean-coverage-dyadic-recheck.log), [structured results](lean-coverage-review.json).

## Supporting formalization after this assessment

The subsequent P34 work now has **50 checked Lean theorems**, including source matrix/Tanner comparison, four-cycle and six-walk results, exclusion of six-cycles for arbitrary 2-by-2 matrices, and exact girth eight for the nonzero normalized 2-by-2 family. This is supporting progress: the full girth-eight design criterion remains unproved and is not counted as an additional fully formalized or proved target. Complete proof coverage remains **1/108**. [Exact checked scope, sources and reproducibility](../formalization/cyclic-lifts/README.md).

## The previously unassessed targets

This pass assessed the **12 eligible targets** left unassessed after the two literature expansions, plus **nine excluded directions**. It did not repeat a complete search for every older target. Each of the 21 entries now points to this pass’s evidence. No exact new target statement or proof was identified.

| Target family | Eligible targets reviewed | Finding |
| --- | ---: | --- |
| P33 neighborhood-color interval constancy | 1 | No matching statement identified; reciprocal-coloring and ordinary graph-neighborhood hits concern different problems. |
| F11 assimilation smallness condition | 1 | No matching PDE assimilation statement identified. Most external “assimilation” hits concern phonology or JavaScript Promises. |
| F14 counting-query randomness/accuracy/efficiency | 3 | SampCert provides relevant privacy foundations, but the inspected declarations do not give the requested joint randomness, accuracy and efficiency bounds or randomness lower bound. |
| P34 lifted-product girth-eight conditions | 1 | Lifted-product definitions and CSS orthogonality exist in LeanPool; these do not characterize girth eight. |
| F23 accuracy/margin dependence of list replicability | 3 | No exact list-replicability definitions or target statements identified in the searched sources. |
| F24 list-size and VC-dimension/index bounds | 3 | VC-dimension background exists; no matching list-replicability or Z2-index target identified. |

A target conventionally answered by later literature can still lack an identified Lean formalization. F14’s efficient-mechanism entry illustrates that distinction. Conversely, a Lean file containing an unrelated use of the same words does not increase coverage.

## Useful Lean background found

**Lifted-product code matrices.** LeanPool’s `LiftedProduct.lean` defines `lpHX` and `lpHZ`, and supplies proof bodies for `lp_orthogonal` and `lp2_orthogonal`, expressing CSS compatibility over the binary field. This is relevant infrastructure for P34, but the inspected file contains no characterization of the Tanner graph’s girth-eight conditions. It was inspected as source, not built or axiom-audited here. [Pinned primary code](https://github.com/LeanPool/lean-pool/blob/1a4fed6d89aa7b28fac75a3c29f750a83236a246/LeanPool/QECCertificates/GF2/LiftedProduct.lean).

**Differential privacy.** SampCert defines exact/noised counts and has declarations including `exactCount_1_sensitive`, `privNoisedCount_DP` and `privNoisedQueryPure_DP`. The abstract count theorem depends on its privacy/noise-system assumptions; the concrete pure-DP mechanism addresses sensitivity and privacy. These are useful foundations, but the inspected declarations do not establish F14’s asymptotic expected-randomness/accuracy tradeoffs. SampCert was source-inspected, not built in this pass. [Pinned count properties](https://github.com/leanprover/SampCert/blob/a2c53bb5ff790e729e252958060699b7eff898b9/SampCert/DifferentialPrivacy/Queries/Count/Properties.lean), [pure mechanism properties](https://github.com/leanprover/SampCert/blob/a2c53bb5ff790e729e252958060699b7eff898b9/SampCert/DifferentialPrivacy/Pure/Mechanism/Properties.lean).

**VC dimension, girth and Dickson polynomials.** The pinned Mathlib tree contains `Finset.vcDim`, graph girth definitions and `Polynomial.dickson`. These provide starting points for future formalization; they do not express the inventoried list-replicability conjectures, lifted-code characterization or proposed Dickson-based code family. [VC dimension](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/Combinatorics/SetFamily/Shatter.lean), [girth](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/Combinatorics/SimpleGraph/Girth.lean), [Dickson polynomials](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/RingTheory/Polynomial/Dickson.lean).

## Search scope and limits

The pass ran **32 lexical queries across four pinned source trees**: Mathlib, Formal Conjectures, TauCeti and terracini-lean. TauCeti’s previously recorded sparse scope was retained. Broad hits were inspected by subject; Tannery’s theorem, Dickson’s well-quasi-order lemma, ordinary Sperner-family results and unrelated Borsuk problems are not the targets here. [Local searches and revisions](lean-coverage-local-searches.json).

**Twelve GitHub code queries were attempted; ten succeeded.** The lifted-product and assimilation queries each reached the 20-result cap. Two later queries hit GitHub’s API rate limit and supply no negative evidence. All **57 returned candidate files** were retrieved and compared by subject and declarations. “signRank” returned `CollapsedDesignRank` in panel-regression code; “counting queries” mostly counted cryptographic oracle calls. These were excluded. [Queries, caps and failures](lean-coverage-github-searches.json), [candidate hashes and comparisons](lean-coverage-candidates.json).

Nine supplementary web queries supplied discovery leads. A page labeled “Formalized claims in Lean” displayed only the beginning of a proposition for a different group-extension lifting claim; it did not supply a complete matching buildable artifact in the inspected page. Such a label contributes zero target coverage. [Background-source comparisons](lean-coverage-background.json), [web discovery](lean-coverage-web-searches.json).

Searches can miss alternate definitions, terminology, unindexed code, private artifacts and work outside the pinned snapshots. “No exact statement identified” is therefore an evidence status, **not a claim that no formalization exists**. No new external candidate was built because none matched an inventoried target. Other proof assistants were not systematically assessed. The earlier search evidence remains attached to the older targets.
