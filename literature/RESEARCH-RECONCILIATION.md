# October 23 research-to-inventory reconciliation

The main girth result and earlier distance work were already indexed, but the
canonical entries stopped before the later representation, persistence and entry
studies. Several inspected sources remained only in the paper's literature notes.
This update joins that knowledge to the shared inventory without treating
supporting Lean lemmas as additional solved open questions.

[Source bibliography](RESEARCH-SOURCES.md) · [Structured update record](research-reconciliation.json) · [Searchable inventory](open-problems.html)

## Historical October23 change

- The earlier reconciliation indexed 21 sources used in the investigation, preserving full-text, abstract-only,
  inaccessible-paper and software-lead distinctions. Some already had central records;
  this is not 21 newly discovered papers.
- Linked six later research milestones and their Lean sources under the existing
  P34 decoding/design targets. The full girth target remains completed; the broader
  decoding targets are marked partially addressed.
- Added two previously identified primary papers to the main bibliography and
  recorded six source-posed questions/directions from their inspected passages.
- Retained the three existing F16 spectral questions without duplicating them.
  The subsequent (4,2) block partially addresses one of these targets, as recorded below.
- Recorded five project-derived follow-ups separately from author-posed questions.

## Newly indexed source questions

| Canonical ID | Source question or direction | Coverage | Source locator |
|---|---|---|---|
| [L-F25-distance-preservation](OPEN-PROBLEMS.md#l-f25-distance-preservation) | Find sufficient base-matrix constraints ensuring equality of the quantum and classical minimum distances in the stated type-I LP construction. | Specific target | [F25: Section VI, next-step and structured-code distance-preservation directions](https://arxiv.org/html/2503.07567v1) |
| [L-F25-general-protographs](OPEN-PROBLEMS.md#l-f25-general-protographs) | Extend the type-I LP distance and problematic-structure analysis to more general protographs. | Broad direction | [F25: Section II-A and Section VI](https://arxiv.org/html/2503.07567v1) |
| [L-F25-hardware-entries](OPEN-PROBLEMS.md#l-f25-hardware-entries) | Investigate circulant-entry choices that ease hardware constraints. | Broad direction | [F25: Section VI, final future-work sentence](https://arxiv.org/html/2503.07567v1) |
| [L-F26-exact-distance](OPEN-PROBLEMS.md#l-f26-exact-distance) | Determine the exact X/Z quantum distances of the fixed randomized P=64 lift of B15, currently certified between 18 and 192 in the source. | Specific target | [F26: Section 7 limitations and Section 8](https://arxiv.org/html/2604.27817v3) |
| [L-F26-logical-qubit-lifts](OPEN-PROBLEMS.md#l-f26-logical-qubit-lifts) | Construct connected CSS-preserving CPM lifts with additional nonconstant left-kernel vectors that increase logical-qubit count while retaining the targeted short-cycle constraints. | Specific target | [F26: Section 8, final future-work direction](https://arxiv.org/html/2604.27817v3) |
| [L-F26-replicated-comparisons](OPEN-PROBLEMS.md#l-f26-replicated-comparisons) | Extend repair/decoder comparisons and replicated statistics across multiple lifted instances. | Broad direction | [F26: Section 7 limitations and Section 8](https://arxiv.org/html/2604.27817v3) |

These are newly inventoried, not newly posed today. Their source-described open
status is historical; no new current-resolution or matching Lean search was
performed here. Relevant sections were screened, not every line of either paper.

The October23 inventory grew from **181 to 187 canonical entries** and from **108 to 111
eligible targets**. Complete checked targets remain **3**: the historical cohort
is still **3/108 (2.78%)**, while the expanded cohort is **3/111 (2.70%)**.
The two new sources make **60** article/preprint records; the **57** full-text
screens remain unchanged, with two additional relevant-section screens. New
planning records are explicitly unassessed rather than assigned invented estimates.

## Our remaining follow-ups, not extra source questions

- **RQ-P34-aggregate-entry:** Explain the remaining net representation-dependent decoding deterioration through early, reachable message mechanisms. Status: partial; exact examples and onset/propagation proofs exist, aggregate mechanism remains incomplete.
- **RQ-P34-count-causality:** Isolate the effect of absorbing-set count from check degrees, routing and logical structure. Status: open; existing interventions identify representation effects, not count alone.
- **RQ-P34-early-predictor:** Find an early failure predictor with independent holdout performance beyond baseline error hardness. Status: partial; initial-activity associations weaken under hardness controls; late tubes certify persistence.
- **RQ-P34-objective-ranking:** Identify when cycle-only, absorbing-only or joint objectives predict superior decoding. Status: open; no universally superior objective established.
- **RQ-P34-error-floor:** Derive a quantitative error-floor predictor for the stated model from structural and dynamical properties. Status: open; finite inventories and experiments do not supply a general law.
- **RQ-F16-lift-label-elimination:** Classify labels eliminating Pasch supports in the two fixed cyclic covers and explain the full QC-GHP implication. Status: Answered in the recorded fixed-base scope; every manuscript proof has a checked Lean version. Optimization/performance and priority are outside scope.
- **RQ-F16-incidence-six:** Certify a useful incidence-aware stopping bound for the source B1 matrix and its cyclic covers. Status: completed_for_the_explicit_positive_63_multiple_lift_family
- **RQ-F16-minimum-support-classification:** Classify all size-six stopping supports of the source B1 matrix. Status: completed_for_the_exact_882_column_source_matrix
- **RQ-F16-incidence-replacement:** Give an incidence-conditioned stopping bound exceeding two on sparse nontrivial QC-GHP families beyond B1. Status: answered_positively_by_reusable_partition_bound_and_explicit_infinite_families
- **RQ-F16-spectral-replacement-existence:** Give a useful spectral stopping replacement above two on an explicit infinite sparse QC-GHP family without the original small-gap premise. Status: proved_by_fourth_moment_criterion_and_joint_sidon_family
- **RQ-F25-girth-RCPC-criterion:** Do classical girth>=8 and RCPC absence imply source LP quantum/classical distance equality for normalized3x4 monomial bases? Status: refuted_by_infinite_lean_counterfamily
- **RQ-F25-exclude-mixed-patterns:** Prove or refute the strengthened condition excluding three-column partial row pairing and lighter transpose codes. Status: open_after_bounded_fresh_diagnostic
- **RQ-F25-weight7-RCPC-converse:** Audit and formalize the source recipe’s claimed exclusion of stabilizer-weight7 logicals in the normalized3x4 girth8 case. Status: source_claim_verification_followup_not_new_open_math
- **RQ-F25-truncated-distance-12:** For normalized fully populated source3x4 cyclic bases satisfying the strengthened entry tests and dTranspose>=dC, prove or refute dQ>=min(dC,12). Status: open_truncated_lower_bound_with_partial_generic_lean_and_finite_evidence

These remain attached to their recorded parent targets and outside the coverage denominator.
Their wording is ours; it is not attributed as an exact question from the source authors.
Negative recurrence/invariant-box searches and the limited net explanatory coverage
remain visible in the linked records.

## Keeping the knowledge connected next time

After a bounded investigation, reconcile the central bibliography, canonical
occurrences, resolution/Lean evidence, derived follow-ups and planning records.
Deduplicate by mathematical content, not title. Add source-authored questions only
after reading their passages, and keep research leads and our proposed next steps
distinct. Regenerate the reports and validate the explicit cohort delta.
Historical experiment manifests continue to refer to their original publication
revisions; this documentation update does not rewrite frozen scientific inputs.

## Subsequent block: absorbing-four-two-2026-10-23

[L-F16-other-absorbing](OPEN-PROBLEMS.md#l-f16-other-absorbing): (4,2) incidence formula and M_j-only obstruction. Remaining at that dated checkpoint: (4,0). [Report](../formalization/absorbing-four-two/RESEARCH-NOTE.txt) · [Verification](../formalization/absorbing-four-two/verification.json) · [Prior art](../formalization/absorbing-four-two/prior-art.json).

Canonical entry delta **0**, eligible-target delta **0**, completed canonical Lean-target delta **0**. Consult this dated artifact for its exact source and proof scope.

## Subsequent block: absorbing-complex-2026-10-24

[L-F16-other-absorbing](OPEN-PROBLEMS.md#l-f16-other-absorbing): Standard-complex character/DFT/matrix/norm/count bridge for (4,2), including the actual 49/35 source witnesses; classical scope and access reconciliation. Remaining at that dated checkpoint: general (4,0). [Report](../formalization/absorbing-four-two/followup-complex/RESEARCH-UPDATE.txt) · [Verification](../formalization/absorbing-four-two/followup-complex/verification.json) · [Prior art](../formalization/absorbing-four-two/followup-complex/literature-followup.json).

Canonical entry delta **0**, eligible-target delta **0**, completed canonical Lean-target delta **0**. Consult this dated artifact for its exact source and proof scope.

## Subsequent block: absorbing-four-zero-2026-10-24

[L-F16-other-absorbing](OPEN-PROBLEMS.md#l-f16-other-absorbing): Both incidence-corrected four-variable count formulas and the full273-variable (4,0) source-matrix/M_j-only obstruction are Lean checked; stronger(3,6)-regular140-variable full-M-equal pair with77/105alsoLeanchecked. Remaining at that dated checkpoint: mathematical/formalization priority; named inaccessible final texts; standalone Lean MacWilliams transform. [Report](../formalization/absorbing-four-zero/RESEARCH-NOTE.txt) · [Verification](../formalization/absorbing-four-zero/verification.json) · [Prior art](../formalization/absorbing-four-zero/prior-art.json).

Canonical entry delta **0**, eligible-target delta **0**, completed canonical Lean-target delta **1**. Consult this dated artifact for its exact source and proof scope.

## Subsequent block: lift-label-elimination-2026-10-24

[L-F16-other-absorbing](OPEN-PROBLEMS.md#l-f16-other-absorbing): General voltage-cycle elimination is classical. Exact all-N raw-label and slice histograms, physical incidence/counting bridges, integer-certificate soundness, full scalar-right counts and the [[140q,18,6]] family for every q>=2 now have checked Lean versions for every manuscript proof. The all-declaration axiom audit and independent exact q2 checks are recorded. No priority, decoder-performance, general gauge-orbit or canonical coverage increment is claimed.. Remaining at that dated checkpoint: Decoder optimization/performance, general switching-orbit classification, and global priority claim.. [Report](../formalization/lift-label-elimination/RESEARCH-NOTE.txt) · [Verification](../formalization/lift-label-elimination/verification.json) · [Prior art](../formalization/lift-label-elimination/prior-art.json).

Canonical entry delta **0**, eligible-target delta **0**, completed canonical Lean-target delta **0**. Consult this dated artifact for its exact source and proof scope.

## Subsequent block: stopping-bound-2026-10-24

[L-F16-stopping-bound](OPEN-PROBLEMS.md#l-f16-stopping-bound): Checked for the exact r₂=n₂=1 scalar-factor QC-GHP form with positive integral column weight and positive base dimensions: r₁≥2 cannot satisfy σ₂²<γ/2; r₁=1 can satisfy it only at row/column density>3/4, and then 1<a+≤2 while a−<2. The exact source-matrix and stopping-set bridges are checked. Dense raw-condition examples exist. Stronger spectral bounds and general two-factor/nonabelian constructions are outside this result.. Remaining at that dated checkpoint: A stronger parameter-aware/multi-eigenvalue bound; full general lifted products with both base factors matrix-valued; global priority.. [Report](../formalization/stopping-bound/RESEARCH-NOTE.txt) · [Verification](../formalization/stopping-bound/verification.json) · [Prior art](../formalization/stopping-bound/prior-art.json).

Canonical entry delta **0**, eligible-target delta **0**, completed canonical Lean-target delta **0**. Consult this dated artifact for its exact source and proof scope.

## Subsequent block: incidence-stopping-2026-10-24

[L-F16-stopping-bound](OPEN-PROBLEMS.md#l-f16-stopping-bound): Incidence-aware restricted follow-up: exact stopping distance six for A=x^27 I_7+S_7+x^54 S_7^2 and b=1+x+x^6 at every positive lift length divisible by63. Includes generic extension-search soundness, two-root certificate, both cyclic symmetries, cover projection/local-injectivity, source-matrix and CSS bridges. No quantum logical-distance or rate claim; no parameters satisfying Proposition5.1 are produced. Exact expanded-matrix sigma_2 squared is at least12; both Zhu–Chugg formula values are negative whenever their strict gap holds.. Remaining at that dated checkpoint: General incidence-conditioned spectral theorem, minimum-stopping-set classification, logical ranks/distances and full higher-rank lifted products.. [Report](../formalization/stopping-bound/incidence/RESEARCH-NOTE.txt) · [Verification](../formalization/stopping-bound/incidence/verification.json) · [Prior art](../formalization/stopping-bound/incidence/prior-art.json).

Canonical entry delta **0**, eligible-target delta **0**, completed canonical Lean-target delta **0**. Consult this dated artifact for its exact source and proof scope.

## Subsequent block: b1-stopping-classification-2026-10-24

[L-F16-stopping-bound](OPEN-PROBLEMS.md#l-f16-stopping-bound): Complete base-B1 minimum-support classification: all size-six stopping supports of the exact 882-column source H_X are precisely the 441 distinct companion H_Z row supports, in a single free Z/7 x Z/63 coordinate-translation orbit. Includes exhaustive-search soundness, kernel certificate, unique center, count and actual binary source bridge. No classification for larger covers or logical-distance claim.. Remaining at that dated checkpoint: Minimum-support classification of larger cyclic covers, least non-companion stopping support, logical ranks/distances and general QC-GHP design theorem.. [Report](../formalization/stopping-bound/classification/RESEARCH-NOTE.txt) · [Verification](../formalization/stopping-bound/classification/verification.json) · [Prior art](../formalization/stopping-bound/classification/prior-art.json).

Canonical entry delta **0**, eligible-target delta **0**, completed canonical Lean-target delta **0**. Consult this dated artifact for its exact source and proof scope.

## Subsequent block: stopping-source-parameter-answer-2026-10-24

[L-F16-stopping-bound](OPEN-PROBLEMS.md#l-f16-stopping-bound): No positive-dimensional binary biregular scalar-factor parameter choice gives a source large root above two under the strict spectral inequality.. Remaining at that dated checkpoint: Separate stronger/replacement-bound direction; not an unhandled parameter case of the current proposition.. [Report](../formalization/stopping-bound/source-answer/RESEARCH-NOTE.txt) · [Verification](../formalization/stopping-bound/source-answer/verification.json) · [Prior art](../formalization/stopping-bound/source-answer/source-ledgers/parent-prior-art.json).

Canonical entry delta **0**, eligible-target delta **0**, completed canonical Lean-target delta **0**. Consult this dated artifact for its exact source and proof scope.

## Subsequent block: stopping-parameter-publication-reconciliation-2026-10-24

[L-F16-stopping-bound](OPEN-PROBLEMS.md#l-f16-stopping-bound): Original Proposition5.1 useful-parameter question answered negatively by existing checked universal theorem.. Remaining at that dated checkpoint: Distinct stronger/replacement-bound direction.. [Report](../formalization/stopping-bound/source-answer/PUBLICATION.txt) · [Verification](../formalization/stopping-bound/source-answer/verification.json) · [Prior art](../formalization/stopping-bound/source-answer/source-ledgers/parent-prior-art.json).

Canonical entry delta **0**, eligible-target delta **0**, completed canonical Lean-target delta **1**. Consult this dated artifact for its exact source and proof scope.

## Subsequent block: stopping-publication-compliance-2026-10-24

[L-F16-stopping-bound](OPEN-PROBLEMS.md#l-f16-stopping-bound): Publication/skill audit and missing dense source bridge completed. All3 paper source/answer tables, full proof links and complete source-date deltas repaired.. Remaining at that dated checkpoint: Named literature/access gaps, original dates for secondary mirrors, independent peer review and a stronger replacement bound remain outside this correction.. [Report](../formalization/stopping-bound/SKILL-COMPLIANCE-AUDIT.md) · [Verification](../formalization/stopping-bound/source-answer/dense-bridge-verification.json) · [Prior art](../formalization/stopping-bound/prior-art.json).

Canonical entry delta **0**, eligible-target delta **0**, completed canonical Lean-target delta **0**. Consult this dated artifact for its exact source and proof scope.

## Subsequent block: stronger-stopping-2026-10-24

Useful spectral replacement existence and incidence replacement existence answered positively; exact6 nontrivial family, actual Zhu-Chugg certificates and unbounded restricted Gram obstruction. Original parameter answer stays negative.. [Report](../formalization/stopping-bound/stronger/RESEARCH-NOTE.txt) · [Verification](../formalization/stopping-bound/stronger/verification.json).

Canonical entry delta **0**, eligible-target delta **0**, completed canonical Lean-target delta **0**. Consult this dated artifact for its exact source and proof scope.

## Subsequent block: stronger-stopping-short-parameters-2026-10-24

[L-F16-stopping-bound](OPEN-PROBLEMS.md#l-f16-stopping-bound): Useful spectral/incidence existence positive; explicit fixed-degree4/8 family for odd n>=37 plus54-variable certificate, with actual matrix/moment/kernel/logical bridges. Original parameter answer stays negative.. [Report](../formalization/stopping-bound/stronger/RESEARCH-NOTE.txt) · [Verification](../formalization/stopping-bound/stronger/verification.json).

Canonical entry delta **0**, eligible-target delta **0**, completed canonical Lean-target delta **0**. Consult this dated artifact for its exact source and proof scope.

## Subsequent block: distance-preservation-four-hour-2026-10-24

[L-F25-distance-preservation](OPEN-PROBLEMS.md#l-f25-distance-preservation): Our girth/RCPC sufficient criterion is refuted by an infinite source-matched family; the broader source question remains open in this project.. [Report](../formalization/distance-preservation/RESEARCH-NOTE.txt) · [Verification](../formalization/distance-preservation/verification.json).

Canonical entry delta **0**, eligible-target delta **0**, completed canonical Lean-target delta **0**. Consult this dated artifact for its exact source and proof scope.

## Subsequent block: truncated-distance12-four-hour-2026-10-25

[L-F25-distance-preservation](OPEN-PROBLEMS.md#l-f25-distance-preservation): For the strengthened normalized 3x4 criterion, a certificate-assisted written argument gives dQ>=min(dC,12). Lean checks the actual-source mixed count-profile classification through weight11, induced K2,3 equality case, singleton support/label reduction, normalization, full-span, actual matching-row, constant-row cancellation and interpreted obstruction bridges. Independent integer replay checks all183312 pattern certificates. The complete min(D,12) source-level distance theorem is not assembled; no qualifying counterexample and no canonical source completion is claimed. A complete intermediate Lean theorem proves the actual Pauli bound min(D,10) under both classical lower-bound predicates and the exact normalized girth/entry tests.. [Report](../formalization/distance-preservation/truncated12/RESEARCH-NOTE.txt) · [Verification](../formalization/distance-preservation/truncated12/round1-verification.json).

Canonical entry delta **0**, eligible-target delta **0**, completed canonical Lean-target delta **0**. Consult this dated artifact for its exact source and proof scope.

## Subsequent block: truncated-distance12-four-hour-round2-2026-10-25

[L-F25-distance-preservation](OPEN-PROBLEMS.md#l-f25-distance-preservation): Second authorized block develops actual weight-ten/eleven source support encodings and quantified finite coverage toward min(D,12); the exact main theorem remains incomplete. The previous complete min(D,10) theorem is preserved. Current exact admission and remaining obligations are in the verification manifest. The broader source sufficient-condition question for dQ=dC is not marked solved; no canonical completion is credited.. [Report](../formalization/distance-preservation/truncated12/ROUND2.txt) · [Verification](../formalization/distance-preservation/truncated12/verification.json).

Canonical entry delta **0**, eligible-target delta **0**, completed canonical Lean-target delta **0**. Consult this dated artifact for its exact source and proof scope.

## Separate indexing extension: beezer-final-journal-2026-10-24

Beezer's final journal was fully read. One precise conjecture and two broad directions were added. The cohort after this screen was 190 entries, 112 eligible targets, 61 paper records and 58 full-text screens.

[Screen report](../formalization/absorbing-four-zero/BEEZER-REVIEW.txt). Added **3 entries**, **1 eligible targets**, **1 paper records**, **1 full-text screens** and **0 completed proofs**.

- [L-F27-generator-basis](OPEN-PROBLEMS.md#l-f27-generator-basis): For fixed t and k, prove that all generators on at most m blocks form a minimal generating set for m-line configurations in general t-(v,k,lambda) designs.
- [L-F27-minimal-girth-designs](OPEN-PROBLEMS.md#l-f27-minimal-girth-designs): Determine minimum-order designs of fixed generator girth and investigate their structure.
- [L-F27-constant-configurations](OPEN-PROBLEMS.md#l-f27-constant-configurations): Extend the configuration equations and classification of constant configurations to larger numbers of blocks.

## Separate indexing extension: absorbing-source-question-screen-2026-10-24

Version-specific screening of every paper encountered in the four-variable absorbing-set and lift-label investigation, plus direct primary resolution checks. Known solved/refuted statements and duplicate occurrences are recorded separately.

[Screen report](../literature/RESEARCH-QUESTION-SCREENING.md). Added **62 entries**, **23 eligible targets**, **39 paper records**, **32 full-text screens** and **0 completed proofs**.

- [L-F29-ensemble-distributions](OPEN-PROBLEMS.md#l-f29-ensemble-distributions): Determine asymptotic average distributions of absorbing and fully absorbing sets in LDPC ensembles.
- [L-F30-ccm-other-structures](OPEN-PROBLEMS.md#l-f30-ccm-other-structures): Extend the cycle-consistency-matrix method to other graphical structures, including trapping sets.
- [L-F38-extra-cycle-information](OPEN-PROBLEMS.md#l-f38-extra-cycle-information): Determine what additional information beyond spectrum and degree sequences permits counting cycles of length at least twice the girth.
- [L-F38-switching-trapping-sets](OPEN-PROBLEMS.md#l-f38-switching-trapping-sets): Determine how Godsil–McKay switching changes trapping-set distributions and whether it can reduce harmful trapping-set multiplicities.
- [L-F34-asymptotic-statistical-extension](OPEN-PROBLEMS.md#l-f34-asymptotic-statistical-extension): Extend the WidthWall theory beyond fixed-size noiseless hypergraphs, including asymptotic regimes, sample complexity and noisy or evolving inputs.
- [L-F34-approximation-gap](OPEN-PROBLEMS.md#l-f34-approximation-gap): Characterize the approximation gap of finite-template Sinkhorn models in terms of template budget J, temperature tau and target-invariant hypertree width.
- [L-F34-sinkhorn-gap-bound](OPEN-PROBLEMS.md#l-f34-sinkhorn-gap-bound): Conjecture K.3: for k-uniform templates P on v vertices and ||A||_F <= B_A, bound gap_SK(P;A) by C_k (delta(P)-1) v^(k-2) B_A, with C_k depending only on k.
- [L-F34-gap-versus-width](OPEN-PROBLEMS.md#l-f34-gap-versus-width): Question K.4: is sup_{||A||_F<=1} gap_SK(P;A) bounded by a function only of generalized hypertree width; does width one imply exactness, and can large width force positive gaps?
- [L-F34-hodge-width-threshold](OPEN-PROBLEMS.md#l-f34-hodge-width-threshold): Conjecture K.6: determine the minimum pattern-width level needed to approximate the Hodge spectral gap, including the proposed width-two bounded-degree threshold and accuracy dependence.
- [L-F34-sts13-hodge-test](OPEN-PROBLEMS.md#l-f34-sts13-hodge-test): Do the two STS(13) examples in Appendix F.1 have different smallest nonzero Hodge 1-Laplacian eigenvalues, so that they separate the proposed Hodge-gap invariant?
- [L-F35-sliding-window-harmful-objects](OPEN-PROBLEMS.md#l-f35-sliding-window-harmful-objects): Analyze the high-SNR harmful structures specific to sliding-window decoding of QC-SC codes, including error propagation, and tailor MIHAO to them.
- [L-F35-alternative-base-performance](OPEN-PROBLEMS.md#l-f35-alternative-base-performance): Analyze the performance of optimized QC-SC codes obtained from the alternative girth-eight QC-LDPC base constructions identified by the authors.
- [L-F39-ub-distance](OPEN-PROBLEMS.md#l-f39-ub-distance): Obtain tighter minimum-distance analysis for the proposed univariate bicycle code construction.
- [L-F39-beyond-divisor](OPEN-PROBLEMS.md#l-f39-beyond-divisor): Extend the univariate bicycle construction beyond the divisor setting used in the paper.
- [L-F39-ub-decoding](OPEN-PROBLEMS.md#l-f39-ub-decoding): Develop improved decoding methods tailored to univariate bicycle codes.
- [L-F39-ub-logical-gates](OPEN-PROBLEMS.md#l-f39-ub-logical-gates): Use the explicit logical structure of univariate bicycle codes for systematic logical-gate constructions and hardware-aware design.
- [L-F40-maxi-pasch](OPEN-PROBLEMS.md#l-f40-maxi-pasch): For admissible v not of the form 2^n-1, determine the maximum number of Pasch configurations in an STS(v) and construct systems attaining it.
- [L-F40-maximal-partial-bases](OPEN-PROBLEMS.md#l-f40-maximal-partial-bases): Develop configuration-counting relations for maximal partial Steiner triple systems and compare them with the complete-STS relations.
- [L-F40-lambda-triple-bases](OPEN-PROBLEMS.md#l-f40-lambda-triple-bases): Extend the configuration-counting basis investigation to triple systems TS(v,lambda) of general index.
- [L-F41-constant-sts-configurations](OPEN-PROBLEMS.md#l-f41-constant-sts-configurations): Give a complete characterization of configurations whose number of occurrences in an STS(v) depends only on v.
- [L-F41-strict-full-basis](OPEN-PROBLEMS.md#l-f41-strict-full-basis): For every n, are all full m-line configurations with m<=n necessary for determining all n-line STS configuration counts, as in Theorem 4?
- [L-F52-general-even-freeness-bounds](OPEN-PROBLEMS.md#l-f52-general-even-freeness-bounds): Find nontrivial upper bounds and existence results for high even-freeness of Steiner 2-designs S(2,mu,v) for general large block size mu.
- [L-F52-new-even-free-constructions](OPEN-PROBLEMS.md#l-f52-new-even-free-constructions): Find constructions of highly even-free Steiner 2-designs beyond the finite-geometric and recursive constructions described in the survey.
- [L-F49-relative-substructure-harm](OPEN-PROBLEMS.md#l-f49-relative-substructure-harm): Determine the relative harmfulness of parity-check substructures for sum-product decoding over a binary symmetric channel.
- [L-F49-auxiliary-budget](OPEN-PROBLEMS.md#l-f49-auxiliary-budget): Determine appropriate auxiliary-qubit or ebit budgets and the break-even point against alternative coding schemes as auxiliary-qubit reliability and cost vary.
- [L-F49-small-weight-degeneracy](OPEN-PROBLEMS.md#l-f49-small-weight-degeneracy): Do all sufficiently small-weight classical codewords in the quantum LDPC constructions considered correspond to undetectable nontrivial logical errors?
- [L-F28-quantum-trapping-enumeration](OPEN-PROBLEMS.md#l-f28-quantum-trapping-enumeration): Adapt expansion–contraction methods to quantum trapping sets, determine parent–child structure and relative harmfulness, and account for Tanner-neighborhood effects.
- [L-F28-symmetric-stabilizer-enumeration](OPEN-PROBLEMS.md#l-f28-symmetric-stabilizer-enumeration): Enumerate symmetric stabilizers in QLDPC codes to exploit degeneracy in decoding.
- [L-F28-correlated-noncss-trapping](OPEN-PROBLEMS.md#l-f28-correlated-noncss-trapping): Extend quantum trapping-set definitions to correlated X/Z errors and general non-CSS stabilizer codes.
- [L-F28-degeneracy-low-complexity-decoding](OPEN-PROBLEMS.md#l-f28-degeneracy-low-complexity-decoding): Develop message-passing algorithms of lower complexity than BP that systematically exploit quantum-code degeneracy.
- [L-F28-beyond-sqrt-distance-performance](OPEN-PROBLEMS.md#l-f28-beyond-sqrt-distance-performance): Analyze finite-length performance of QLDPC codes exceeding square-root distance scaling using their quantum trapping-set enumeration.
- [L-F42-ai-decoder-structures](OPEN-PROBLEMS.md#l-f42-ai-decoder-structures): Characterize harmful trapping structures for AI-based quantum decoders.
- [L-F42-larger-dem-search](OPEN-PROBLEMS.md#l-f42-larger-dem-search): Determine whether small-LETS error-floor estimation remains sufficient and feasible for larger-distance circuit-level codes, and find structural subclasses enabling deeper search.
- [L-F42-dem-aware-decoding](OPEN-PROBLEMS.md#l-f42-dem-aware-decoding): Use the harmful-LETS catalog to design circuit-level decoders that suppress or escape the observed low-weight failure mechanisms.
- [L-F48-haemers-spectrum](OPEN-PROBLEMS.md#l-f48-haemers-spectrum): Are almost all finite simple graphs determined up to isomorphism by their adjacency spectrum?
- [L-F55-moore-degree57](OPEN-PROBLEMS.md#l-f55-moore-degree57): Does a Moore graph of degree 57 (equivalently SRG(3250,57,0,1)) exist?
- [L-F55-partial-geometry-664](OPEN-PROBLEMS.md#l-f55-partial-geometry-664): Does a partial geometry pg(6,6,4) exist?
- [L-F62-grid-free-sts](OPEN-PROBLEMS.md#l-f62-grid-free-sts): Does there exist a Steiner triple system STS(v), with v>=9, containing no grid configuration?
- [L-F61-generator-girth7-sts](OPEN-PROBLEMS.md#l-f61-generator-girth7-sts): Does there exist a Steiner triple system of generator girth exactly 7 in the sense of Definition 5.2?
- [L-F61-other-design-girth5](OPEN-PROBLEMS.md#l-f61-other-design-girth5): Does any nontrivial design other than a regular graph or a Steiner triple system have generator girth at least 5?
- [L-F61-design-to-graph-cages](OPEN-PROBLEMS.md#l-f61-design-to-graph-cages): Use design-cage methods to improve the construction or search for cages among regular graphs.
- [L-F61-moore-designs](OPEN-PROBLEMS.md#l-f61-moore-designs): Develop a design-cage analogue of the Moore lower bound, recovering the graph bound, and investigate designs attaining it.
- [L-F61-more-fundamental-generators](OPEN-PROBLEMS.md#l-f61-more-fundamental-generators): Find more fundamental configuration building blocks than generators, accounting for the shared cores obtained by removing degree-one vertices.
- [L-F61-asymptotic-generator-avoidance](OPEN-PROBLEMS.md#l-f61-asymptotic-generator-avoidance): For fixed t,k,lambda,r, does a threshold exist above which every admissible order has a design avoiding all nontrivial generators with at most r blocks?
- [L-F53-counting-upper-bound](OPEN-PROBLEMS.md#l-f53-counting-upper-bound): Is the lower bound of Theorem 1.3 for the number of labeled STSs of girth greater than g asymptotically sharp, with a matching leading exponential constant?
- [L-F53-maximal-sts-girth](OPEN-PROBLEMS.md#l-f53-maximal-sts-girth): Determine the optimal asymptotic maximum density girth of an STS of order N, equivalently the optimal dependence of N_1.1(g) on g.
- [L-F53-pseudorandom-decomposition](OPEN-PROBLEMS.md#l-f53-pseudorandom-decomposition): Establish high-girth triangle decompositions in sufficiently dense pseudorandom graphs satisfying the required divisibility conditions.
- [L-F53-high-girth-factorizations](OPEN-PROBLEMS.md#l-f53-high-girth-factorizations): Extend the high-girth construction program to 1-factorizations, as suggested in the discussion of Linial’s proposals.
- [L-F50-systematic-weight-distributions](OPEN-PROBLEMS.md#l-f50-systematic-weight-distributions): Develop systematic computer investigations of weight distributions using structural information about codes and their duals.
- [L-F65-minimum-degree-threshold](OPEN-PROBLEMS.md#l-f65-minimum-degree-threshold): Determine the optimal minimum-degree threshold for high-girth K_q^r-decompositions in Theorem 8.1; for r=2, can it match ordinary K_q-decomposition bounds?
- [L-F65-random-high-girth-designs](OPEN-PROBLEMS.md#l-f65-random-high-girth-designs): Determine thresholds for high-girth Steiner systems in random graphs and random uniform hypergraphs, extending the referenced refined-absorption threshold results.
- [L-F66-latin-enumeration](OPEN-PROBLEMS.md#l-f66-latin-enumeration): Close the gap between upper and lower bounds on the number of Latin squares of order n.
- [L-F66-uniform-sampling](OPEN-PROBLEMS.md#l-f66-uniform-sampling): Find a provably efficient method for generating a uniformly random Latin square of order n.
- [L-F66-intercalate-lower-tail](OPEN-PROBLEMS.md#l-f66-intercalate-lower-tail): Conjecture 1.6: for each fixed 0<delta<=1, does the intercalate count N in a random Latin square satisfy Pr[N<=(1-delta)EN]=exp(-(delta+(1-delta)log(1-delta)+o(1))EN)?
- [L-F66-intercalate-upper-tail](OPEN-PROBLEMS.md#l-f66-intercalate-upper-tail): Conjecture 1.7: for fixed delta>0, is Pr[N>=(1+delta)n^2/4]=exp(-(1+o(1))Phi(delta EN) log n), where Phi is the partial-Latin-square intercalate extremal function?
- [L-F66-partial-latin-extremal](OPEN-PROBLEMS.md#l-f66-partial-latin-extremal): Determine the asymptotic value of Phi(N), the least number of nonempty cells in a partial Latin square with at least N intercalates.
- [L-F66-maximum-intercalates](OPEN-PROBLEMS.md#l-f66-maximum-intercalates): Determine the asymptotic maximum number of intercalates in a Latin square of order n.
- [L-F66-hilton-no-subsquares](OPEN-PROBLEMS.md#l-f66-hilton-no-subsquares): For all sufficiently large orders n=2^a 3^b with a>=1 and b>=0, does an order-n Latin square with no proper nontrivial Latin subsquare exist (the remaining Hilton N_infinity cases stated in the source)?
- [L-F66-poisson-three-subsquares](OPEN-PROBLEMS.md#l-f66-poisson-three-subsquares): Establish the proposed asymptotic Poisson law with bounded mean for the number of 3x3 subsquares in a uniformly random Latin square.
- [L-F66-no-large-subsquares](OPEN-PROBLEMS.md#l-f66-no-large-subsquares): Does the probability that a uniformly random order-n Latin square has no proper Latin subsquare of order at least four tend to one as n grows?
- [L-F66-minimum-cuboctahedra](OPEN-PROBLEMS.md#l-f66-minimum-cuboctahedra): Determine the asymptotic minimum number of cuboctahedra in an order-n Latin square; in particular, can the count be below (4-Omega(1))n^4?
- [L-F52-seven-even-free-sts](OPEN-PROBLEMS.md#l-f52-seven-even-free-sts): Does a nontrivial Steiner triple system exist that simultaneously avoids the Pasch, grid and double-triangle even configurations, and hence is seven-even-free?

## Separate indexing extension: stopping-bound-source-screen-2026-10-24

Four new complete primary-text screens add ten broad historical directions, with two named classical full-text/archival gaps. The F16 tightening component remains attached to its existing canonical target. No precise-target or completion increment.

[Screen report](../literature/stopping-bound-source-screening.json). Added **10 entries**, **0 eligible targets**, **6 paper records**, **4 full-text screens** and **0 completed proofs**.

- [L-F67-redundant-check-design](OPEN-PROBLEMS.md#l-f67-redundant-check-design): Develop a principled way to add redundant parity checks that improves iterative decoding beyond the difference-set examples.
- [L-F68-integer-tightening](OPEN-PROBLEMS.md#l-f68-integer-tightening): Improve the graph-analysis distance bound by enforcing integer relation-distribution vectors.
- [L-F68-degree-stratification](OPEN-PROBLEMS.md#l-f68-degree-stratification): Refine the graph-analysis bound by separating active checks according to their induced degrees.
- [L-F68-decoder-quality](OPEN-PROBLEMS.md#l-f68-decoder-quality): Test whether the graph-analysis bound predicts the quality of a graph for iterative decoding.
- [L-F69-general-distance](OPEN-PROBLEMS.md#l-f69-general-distance): Find nontrivial general minimum-distance lower bounds for the proposed QC generalized hypergraph-product codes.
- [L-F70-efficient-decoding](OPEN-PROBLEMS.md#l-f70-efficient-decoding): Devise an efficient decoder for quantum Tanner codes.
- [L-F70-generator-weight](OPEN-PROBLEMS.md#l-f70-generator-weight): Reduce the constant generator weights in the quantum Tanner construction.
- [L-F70-other-complexes](OPEN-PROBLEMS.md#l-f70-other-complexes): Find complexes beyond left-right Cayley complexes on which the Tanner construction gives good quantum LDPC families.
- [L-F70-explicit-components](OPEN-PROBLEMS.md#l-f70-explicit-components): Make the required component-code and quantum Tanner constructions completely explicit.
- [L-F70-robustness-exponent](OPEN-PROBLEMS.md#l-f70-robustness-exponent): Improve component dual-tensor robustness beyond the Delta-to-the-three-halves scale and strengthen the distance dependence.

## Separate indexing extension: incidence-stopping-source-screen-2026-10-24

Three primary full-text screens add five broad historical directions; one 2026 HGP access gap. A project-derived exact incidence family certificate remains supporting evidence under L-F16, without another canonical completion.

[Screen report](../literature/incidence-stopping-source-screening.json). Added **5 entries**, **0 eligible targets**, **4 paper records**, **3 full-text screens** and **0 completed proofs**.

- [L-F73-residual-erasure-techniques](OPEN-PROBLEMS.md#l-f73-residual-erasure-techniques): Develop other techniques to handle the small residual errors left after peeling quantum expander codes.
- [L-F74-socket-partition-design](OPEN-PROBLEMS.md#l-f74-socket-partition-design): Improve socket selection and partitioning events in composite branch-and-bound stopping-set searches.
- [L-F74-faster-implementation](OPEN-PROBLEMS.md#l-f74-faster-implementation): Extend exhaustive small stopping/trapping-set search to longer codes through better data structures, software or hardware.
- [L-F74-direct-trapping-search](OPEN-PROBLEMS.md#l-f74-direct-trapping-search): Design direct exhaustive trapping-set algorithms that improve on reduction to stopping-set enumeration.
- [L-F75-pruned-cluster-combination](OPEN-PROBLEMS.md#l-f75-pruned-cluster-combination): Study pruned peeling combined with cluster decomposition more comprehensively.

## Separate indexing extension: stronger-stopping-source-screen-2026-10-24

Source-question indexing extension.

[Screen report](../formalization/stopping-bound/stronger/RESEARCH-NOTE.txt). Added **20 entries**, **8 eligible targets**, **4 paper records**, **4 full-text screens** and **0 completed proofs**.

- [L-F77-polynomial-redundancy](OPEN-PROBLEMS.md#l-f77-polynomial-redundancy): Does an asymptotically good binary linear code family have stopping redundancy polynomial in its length?
- [L-F77-Golay34](OPEN-PROBLEMS.md#l-f77-golay34): Is the stopping redundancy of the extended binary Golay code G24 equal to34?
- [L-F77-MDS-invariance](OPEN-PROBLEMS.md#l-f77-mds-invariance): Do all finite-field [n,k] MDS codes have stopping redundancy depending only on n and k?
- [L-F77-locally-thin-three](OPEN-PROBLEMS.md#l-f77-locally-thin-three): Is t(3)<1, where t(k)=limsup_{rho->infinity} log2(M(rho,k))/rho for k-locally-thin families?
- [L-F77-locally-thin-monotone](OPEN-PROBLEMS.md#l-f77-locally-thin-monotone): Is t(k) nonincreasing for integers k>=2 in the same locally-thin-family definition?
- [L-F77-general-lower-bounds](OPEN-PROBLEMS.md#l-f77-general-lower-bounds): Improve general lower bounds for stopping redundancy.
- [L-F77-nonbinary-constructions](OPEN-PROBLEMS.md#l-f77-nonbinary-constructions): Study stopping redundancy under nonbinary concatenated and multilevel constructions.
- [L-F77-MDS-exact](OPEN-PROBLEMS.md#l-f77-mds-exact): Determine exact MDS stopping redundancy as a function of the code parameters.
- [L-F77-other-channels](OPEN-PROBLEMS.md#l-f77-other-channels): Determine the relevance of stopping redundancy for channels beyond the BEC and LP decoding.
- [L-F77-locally-thin-sequence](OPEN-PROBLEMS.md#l-f77-locally-thin-sequence): Determine the sequence t(k) for locally-thin families.
- [L-F78-cyclic-good](OPEN-PROBLEMS.md#l-f78-cyclic-good): Do asymptotically good linear cyclic codes exist over a fixed finite field?
- [L-F78-Artin](OPEN-PROBLEMS.md#l-f78-artin): For each positive nonsquare integer q>1, do primes with ord_p(q)=p-1 have positive density?
- [L-F78-GB-scaling](OPEN-PROBLEMS.md#l-f78-gb-scaling): Determine optimal distance scaling of generalized bicycle codes at bounded generator weight.
- [L-F78-higher-k-fault-tolerance](OPEN-PROBLEMS.md#l-f78-higher-k-fault-tolerance): Study parameters and fault-tolerant performance of generalized bicycle codes encoding more than two qubits.
- [L-F78-local-above-square-root](OPEN-PROBLEMS.md#l-f78-local-above-square-root): Can quantum codes local in a fixed dimension D>2 have polynomial distance exponent strictly above1/2?
- [L-F78-other-commuting-matrices](OPEN-PROBLEMS.md#l-f78-other-commuting-matrices): Find better LDPC parameters from other commuting-square-matrix CSS constructions.
- [L-F78-measurement-tradeoff](OPEN-PROBLEMS.md#l-f78-measurement-tradeoff): Determine whether larger bicycle-code distances offset higher-weight measurement complexity.
- [L-F79-minsum-erasure](OPEN-PROBLEMS.md#l-f79-minsum-erasure): Study min-sum variants of the proposed soft BP decoders for quantum erasures.
- [L-F79-circuit-erasure](OPEN-PROBLEMS.md#l-f79-circuit-erasure): Develop the detailed circuit-level erasure treatment, including conversion circuits, left outside this paper.
- [L-F80-design-enumerators](OPEN-PROBLEMS.md#l-f80-design-enumerators): Determine stopping-set weight enumerators for general designs and their associated codes.

## Separate indexing extension: xia-fu-stopping-source-screen-2026-10-24

Source-question indexing extension.

[Screen report](../literature/xia-fu-stopping-source-screening.json). Added **3 entries**, **1 eligible targets**, **1 paper records**, **1 full-text screens** and **0 completed proofs**.

- [L-F81-optimal-LP-existence](OPEN-PROBLEMS.md#l-f81-optimal-lp-existence): Does every binary linear code admit a finite parity-check matrix H whose minimum AWGN pseudo-weight equals its minimum Hamming distance and whose number of minimum edges equals its number of minimum codewords?
- [L-F81-optimal-LP-minimum-rows](OPEN-PROBLEMS.md#l-f81-optimal-lp-minimum-rows): Construct an asymptotically LP-optimal parity-check representation with the minimum number of rows for a binary LDPC code.
- [L-F81-TypeII-l4-distance](OPEN-PROBLEMS.md#l-f81-typeii-l4-distance): For the binary Type-II tree construction with l=4 of Sridhara-Kelley-Rosenthal, is d=d_L?

## Separate indexing extension: postlemma-stopping-source-screen-2026-10-24

Source-question indexing extension.

[Screen report](../literature/postlemma-stopping-source-screening.json). Added **5 entries**, **0 eligible targets**, **4 paper records**, **4 full-text screens** and **0 completed proofs**.

- [L-F82-higher-column-DM](OPEN-PROBLEMS.md#l-f82-higher-column-dm): Determine existence of higher-column difference matrices DM(k;a) for admissible orders beyond the treated k=3 case.
- [L-F82-general-DCA](OPEN-PROBLEMS.md#l-f82-general-dca): Develop the general-k theory and constructions of difference covering arrays beyond the treated three-column case.
- [L-F82-improved-minimum-distance](OPEN-PROBLEMS.md#l-f82-improved-minimum-distance): Improve the proposed difference-matrix LDPC constructions to obtain higher minimum distance.
- [L-F82-larger-stopping-sets](OPEN-PROBLEMS.md#l-f82-larger-stopping-sets): Investigate larger stopping sets by discarding selected rows of the underlying DM or DCA, as in Construction2.
- [L-F83-optimal-index](OPEN-PROBLEMS.md#l-f83-optimal-index): Determine or construct the optimal index rho(n,m) for partitioned cyclic difference packings with prescribed n and m.

## Separate indexing extension: quantum-next-selection-2026-10-24

Selected L-F25-distance-preservation as the next new quantum coding problem. Compared F26 rank/distance, F39 distance and F49 degeneracy; no theorem solved. Upgraded two existing paper question screens without adding entries.

[Screen report](../literature/quantum-next-selection-2026-10-24.json). Added **0 entries**, **0 eligible targets**, **0 paper records**, **2 full-text screens** and **0 completed proofs**.


## Separate indexing extension: distance-preservation-sources-2026-10-24

Four accessible primary papers screened during the F25 investigation; 24 broad directions harvested. No new eligible mathematical target or canonical completion.

[Screen report](../literature/distance-preservation-source-screening.json). Added **24 entries**, **0 eligible targets**, **4 paper records**, **4 full-text screens** and **0 completed proofs**.

- [L-F86-surgery-cost](OPEN-PROBLEMS.md#l-f86-surgery-cost): Reduce the spacetime cost of mitten-code surgery gadgets.
- [L-F86-structured-decoding](OPEN-PROBLEMS.md#l-f86-structured-decoding): Develop faster and more effective decoders exploiting mitten-code structure.
- [L-F86-superconducting-routing](OPEN-PROBLEMS.md#l-f86-superconducting-routing): Improve superconducting on-chip routing for mitten-code syndrome extraction and logical operations.
- [L-F86-atom-movement](OPEN-PROBLEMS.md#l-f86-atom-movement): Improve atom-array movement and syndrome-extraction strategies, including moving data, GHZ ancillas or different transport.
- [L-F86-experimental-processors](OPEN-PROBLEMS.md#l-f86-experimental-processors): Demonstrate high-rate qLDPC processors experimentally using the proposed small-block codes.
- [L-F86-teraquop-certification](OPEN-PROBLEMS.md#l-f86-teraquop-certification): Assess and certify teraquop-scale processing capacity for higher-distance mitten codes.
- [L-F86-beam-decoder-comparison](OPEN-PROBLEMS.md#l-f86-beam-decoder-comparison): Compare the telescoping and beam-search decoders on the same detector error models.
- [L-F86-atom-loss](OPEN-PROBLEMS.md#l-f86-atom-loss): Determine achievable qLDPC performance with loss-aware decoding under realistic atom loss.
- [L-F87-qdistevol-refinement](OPEN-PROBLEMS.md#l-f87-qdistevol-refinement): Refine QDistEvol and implement it in C using asymptotically optimal Gaussian elimination.
- [L-F87-faster-bposd](OPEN-PROBLEMS.md#l-f87-faster-bposd): Develop a faster BP-OSD implementation and assess its competitiveness with random information-set distance searches.
- [L-F88-solver-scaling](OPEN-PROBLEMS.md#l-f88-solver-scaling): Extend distance-certificate scaling through decomposition and solvers specialized to linear codes.
- [L-F88-non-css](OPEN-PROBLEMS.md#l-f88-non-css): Extend the verified distance framework to general non-CSS stabilizer codes.
- [L-F88-subsystem](OPEN-PROBLEMS.md#l-f88-subsystem): Extend the formalization to subsystem codes and the broader stabilizer formalism.
- [L-F88-verified-row-reduction](OPEN-PROBLEMS.md#l-f88-verified-row-reduction): Implement verified row reduction for kernel-basis computation in the Lean-QEC preprocessing pipeline.
- [L-F88-circuit-integration](OPEN-PROBLEMS.md#l-f88-circuit-integration): Connect the QEC layer to verified circuit compilers such as SQIR.
- [L-F88-gate-calculus](OPEN-PROBLEMS.md#l-f88-gate-calculus): Develop a richer verified gate-level quantum-circuit calculus.
- [L-F89-inherited-logicals](OPEN-PROBLEMS.md#l-f89-inherited-logicals): Describe inherited and newly created logical degrees of freedom under lifts, including even-index lifts.
- [L-F89-gadget-distance](OPEN-PROBLEMS.md#l-f89-gadget-distance): Determine how inherited logical-operation gadgets preserve distance under lifting.
- [L-F89-operation-transfer](OPEN-PROBLEMS.md#l-f89-operation-transfer): Determine when transversal gates, homomorphic CNOTs and measurements, or code switching transfer to lifts.
- [L-F89-thermodynamic-branches](OPEN-PROBLEMS.md#l-f89-thermodynamic-branches): Find geometric and homological conditions selecting lift branches with common thermodynamic behavior.
- [L-F89-decoder-transfer](OPEN-PROBLEMS.md#l-f89-decoder-transfer): Determine whether useful decoders transfer from a base LP code to its lifts.
- [L-F89-hardware-transfer](OPEN-PROBLEMS.md#l-f89-hardware-transfer): Determine whether hardware-efficient implementations transfer from base codes to lifts.
- [L-F89-other-code-families](OPEN-PROBLEMS.md#l-f89-other-code-families): Extend the lifting construction to other high-rate group-algebra codes and quantum Tanner codes.
- [L-F89-general-nontransversal-surgery](OPEN-PROBLEMS.md#l-f89-general-nontransversal-surgery): Develop systematic nontransversal surgery constructions for general qLDPC codes without an underlying lifted structure.

## Separate indexing extension: distance-preservation-classical-source-2026-10-24

Added the already indexed Kelley et al. classical predecessor to paper coverage after reading its complete one-page proceedings text. No new target or canonical completion.

[Screen report](../literature/distance-preservation-source-screening.json). Added **0 entries**, **0 eligible targets**, **1 paper records**, **1 full-text screens** and **0 completed proofs**.


## Separate indexing extension: truncated-distance12-sources-2026-10-25

One new primary paper screened; three fixed mathematical questions and three broad directions harvested. No canonical target completion.

[Screen report](../literature/truncated-distance12-source-screening.json). Added **6 entries**, **3 eligible targets**, **1 paper records**, **1 full-text screens** and **0 completed proofs**.

- [L-F91-c16-unrestricted-width](OPEN-PROBLEMS.md#l-f91-c16-unrestricted-width): Determine whether the unrestricted canonical frame width of the fixed LP code C16,9 is 16 or 18.
- [L-F91-c20-unrestricted-width](OPEN-PROBLEMS.md#l-f91-c20-unrestricted-width): Determine the unrestricted canonical frame width of the fixed LP code C20,10.
- [L-F91-pp1024-joint-parameters](OPEN-PROBLEMS.md#l-f91-pp1024-joint-parameters): Does the specified 1024-qubit PP family contain a code simultaneously attaining d=24, check weight w=10 and unrestricted frame width f=25?
- [L-F91-nonabelian-common-action](OPEN-PROBLEMS.md#l-f91-nonabelian-common-action): Extend the non-Abelian constructions to full regular canonical frames with one physical group action preserving both CSS sectors.
- [L-F91-rate-distance-frame-design](OPEN-PROBLEMS.md#l-f91-rate-distance-frame-design): Optimize distance and canonical frame width as the matrix dimensions and encoding rate vary.
- [L-F91-measurement-interfaces](OPEN-PROBLEMS.md#l-f91-measurement-interfaces): Develop distance-preserving logical-measurement interfaces for the translated frames and assess their ancilla and circuit costs.

## Separate indexing extension: truncated-distance12-postlemma-sources-2026-10-25

Three post-lemma primary papers screened; one speculative square-root conjecture, seven broad directions and five held formulations harvested. No canonical completion.

[Screen report](../literature/truncated-distance12-source-screening.json). Added **13 entries**, **1 eligible targets**, **3 paper records**, **3 full-text screens** and **0 completed proofs**.

- [L-F92-distance-scaling](OPEN-PROBLEMS.md#l-f92-distance-scaling): Determine asymptotic distance scaling of fixed-check-weight two-block group-algebra codes.
- [L-F92-ambient-search-bound](OPEN-PROBLEMS.md#l-f92-ambient-search-bound): Find a finite ambient-group search bound, up to the relevant equivalence, for fixed-length double-coset subcodes.
- [L-F93-weight5-square-root](OPEN-PROBLEMS.md#l-f93-weight5-square-root): Does a universal square-root distance upper bound hold for binary weight-five two-block group-algebra codes?
- [L-F93-complete-equivalence](OPEN-PROBLEMS.md#l-f93-complete-equivalence): Find a complete set of equivalence moves for two-block group-algebra codes.
- [L-F93-distance-preserving-circuits](OPEN-PROBLEMS.md#l-f93-distance-preserving-circuits): Design distance-preserving syndrome-extraction circuits for the highlighted [[102,20,10]] and [[120,24,10]] codes.
- [L-F93-covers-versus-primitive](OPEN-PROBLEMS.md#l-f93-covers-versus-primitive): Explain when covers or primitive two-block codes produce better distance and code parameters.
- [L-F93-group-distance-mechanism](OPEN-PROBLEMS.md#l-f93-group-distance-mechanism): Explain the group structures that concentrate high-distance two-block codes.
- [L-F93-logical-gadgets](OPEN-PROBLEMS.md#l-f93-logical-gadgets): Co-design and assess logical gadgets for the highlighted two-block codes under neutral-atom device constraints.
- [L-F93-distance-252-16](OPEN-PROBLEMS.md#l-f93-distance-252-16): Determine the exact distance of the fixed Aydin–Tamo–Barg [[252,16]] code reported with lower bound19.
- [L-F93-distance-306-22](OPEN-PROBLEMS.md#l-f93-distance-306-22): Determine the exact distance of the fixed Aydin–Tamo–Barg [[306,22]] code reported with lower bound23.
- [L-F93-distance-288-20](OPEN-PROBLEMS.md#l-f93-distance-288-20): Determine the exact distance of the fixed Symons-et-al. [[288,20]] code reported with lower bound20.
- [L-F93-distance-288-14](OPEN-PROBLEMS.md#l-f93-distance-288-14): Determine the exact distance of the fixed Symons-et-al. [[288,14]] code reported with lower bound20.
- [L-F94-nonaffine-lifts](OPEN-PROBLEMS.md#l-f94-nonaffine-lifts): Explore non-affine CPM shift functions for the fixed two-branch F19 base to avoid its forced affine weight18 logical mode.

Current cohort: **338 canonical entries,148 eligible targets,128 paper records,117 full-text screens**; **5/148 complete checked Lean targets**. New source questions have unassessed present resolution, Lean discovery and planning difficulty.

The current source index has **98** records, with actual access levels retained.
