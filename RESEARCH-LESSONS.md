# Lessons from the dyadic rank support investigation

This investigation produced a general Lean proof, an explicit connection between coding theory and representation theory, and a reproducible paper and source artifact. Its most useful methodological lesson is to search for the same mathematics in different languages. Precise statements, small examples, computation, literature search, and formal proof each contributed different evidence; keeping those roles distinct made the final result easier to assess.

This retrospective records the investigation as of October 21, 2026 and gives a workflow for the next problem. It supports improving the process, not predicting which future conjectures will yield new theorems.

## What we established

For a binary dyadic matrix indexed by vectors in `F₂^ell`, rank equal to half the matrix order forces the sum of its signature's support **index vectors** to be nonzero. The checked theorem covers every positive dimension. It is stronger than the finite cases and sampled searches with which we began. [Statement and verification](formalization/dyadic-rank/README.md)

The explicit source question is Remark 3.4 of Gómez-Fonseca, Matthews, Morris, and Pllaha's preprint, posted May 3, 2026. The conclusion follows from Friedlander–Pevtsova's criterion published in April 2005, approximately 21 years earlier, after translating the objects and hypotheses. The Lean proof uses direct matrix induction; its central descent step specializes their published perturbation principle. The dates illustrate the usefulness of connecting the two formulations, without establishing who first recognized the connection or why the later conjecture was posed. [Chronology and attribution](formalization/dyadic-rank/paper/main.tex) · [Proof comparison](formalization/dyadic-rank/FORMALIZATION-AND-PROOF-COMPARISON.md)

The contribution we can substantiate is a completed implementation, an elementary exposition, and an explicit literature connection. Priority for the theorem, proof method, or first Lean formalization is not established.

## Preserve the source trail and freeze the statement

Following dissertation authors into their related papers led us to the precise question. That trail mattered: the place where a topic was discovered, the publication that actually posed the question, and the source of an older applicable theorem deserve separate credit. Record all three as soon as they become known. The [literature inventory](literature/README.md) and the paper's [claim and citation guide](formalization/dyadic-rank/paper/main.tex) preserve those distinctions.

Before investing heavily in a target, write down the exact objects, coefficient field, quantifiers, hypotheses, conclusion, and source locator. Keep a stable identifier for that mathematical target as it appears in multiple sources. A source describing a question as open is a historical observation; whether it remains open requires its own investigation.

Our concrete warning was the meaning of “support sum.” Here it is a vector sum of indices, not the scalar parity of the signature. Another was directionality: half rank implies nonzero support sum, but the unrestricted reverse implication is false. A signature supported at one nonzero index produces an invertible permutation matrix despite having nonzero support sum. An equivalence needs an additional parity condition. A formal proof of an accidentally strengthened hypothesis or weakened conclusion would answer a different question. [Definitions and scope](formalization/dyadic-rank/README.md)

**Next time:** prepare the informal statement and Lean signature together, then test the empty, singleton, smallest-dimensional, and boundary cases before choosing a proof strategy.

## Translate the question before broadening the search

Searching only for “dyadic rank support” would have missed the most useful published precedent. The productive translation replaced the matrix with multiplication by an element of an elementary abelian group algebra. That made flatness, augmentation ideals, and commuting nilpotent operators relevant search terms. [Translation and primary-source locators](formalization/dyadic-rank/PRIOR-ART.md)

| Original formulation | Equivalent object or condition useful for searching |
| --- | --- |
| Matrix entry `D(x,y) = s(x+y)` | Binary convolution; multiplication by an element of an elementary abelian group algebra |
| Scalar parity of the signature | Constant coefficient in augmentation variables |
| Sum of support index vectors | Vector of linear coefficients in augmentation variables |
| Half rank for a square-zero operator | Image equals kernel; freeness over `k[u]/(u²)` |
| Dyadic triangular descent with commuting square-zero blocks | Projectivity under commuting nilpotent perturbations |

These correspondences need justification. A plausible analogy is a search lead; a written translation must establish the hypotheses and the implication actually being used. In this project, the group-algebra literature connection remains an ordinary mathematical argument, separate from the checked matrix proof.

**Next time:** build this translation table early. Search by operations, invariants, equivalent structures, and obstruction conditions, alongside the source's vocabulary. Follow references backward as well as citations forward. Search authors' manuscripts and books when the original terminology yields little.

## Use computation to investigate and diagnose

Small cases helped check the statement and the implementation. Larger exact searches provided examples and constraints to examine while the structural argument developed. The Python search used elimination over `F₂`, recorded its seed and tested families, distinguished exhaustive from sampled spaces, and retained independently checked rank witnesses. Its 45,543 tested signatures were conditioned candidates, not every signature through the largest dimension. [Search scope and checks](formalization/dyadic-rank/search/README.md)

The lack of a counterexample did not establish the general theorem. The general proof instead used a dimension descent that reached a contradiction at dimension zero. Keeping the computational search outside that proof's dependency chain made the final claim straightforward to reproduce. [Inductive proof](formalization/dyadic-rank/INDUCTIVE-PROOF.md)

**Next time:** choose searches that could distinguish competing explanations. Save extremal examples and failed constructions, not just a counterexample count. If a counterexample appears, reduce it and verify it independently before treating the conjecture as refuted. If none appears, use the examples to propose a structural lemma and state exactly which cases the search covered.

## Choose a proof with manageable formal prerequisites

The exact-zero-divisor route through Kustin–Şega–Vraciu supplied a useful mathematical perspective, but implementing the general proposition would have required substantially more algebraic infrastructure. The completed Lean proof instead used finite sums, linear maps, rank–nullity, and induction. Its key step constructs a preimage through a triangular block operator using two successive preimages, commutation, and square-zero cancellation. [Alternative route](formalization/dyadic-rank/STRUCTURAL-PROOF.md) · [Checked descent lemma](formalization/dyadic-rank/DyadicRank/Recursive.lean)

The implementation benefits from an abstract helper: `kernelInRange_descends` exposes the preimage property needed by the argument, rather than forcing every intermediate step to carry a rank equation. The dyadic application supplies the additional coordinate identities. This separation produced a useful general lemma and kept the induction close to its mathematical explanation.

**Next time:** compare plausible routes by the missing formal dependencies as well as their informal length. Prove the smallest structural lemma that could settle the strategy early. Build reusable pieces while developing the proof, and maintain an explicit list of what is checked and what remains informal. In this artifact, the general matrix theorem is checked; Kustin–Şega–Vraciu Proposition 1.9 and the group-algebra translation are not additional Lean theorems.

## Investigate novelty alongside the proof

The most consequential improvement is to move the translation-based prior-art search earlier. We completed the formal theorem before the historical comparison was settled. That produced a useful artifact, but left room for premature interpretations of what was mathematically new. A new proof in the current workspace establishes neither a new theorem nor historical priority.

Keep four questions separate:

| Question | Evidence needed |
| --- | --- |
| Is the mathematical conclusion new? | Search equivalent formulations and check earlier results that imply it. |
| Is the proof principle new? | Compare the decisive lemma and mechanism with published arguments. |
| Is this the first formalization? | Search matching proof-assistant statements and dependencies across a documented scope. |
| What does this artifact contribute? | Identify its checked statement, implementation, exposition, reusable lemmas, and reproducibility evidence. |

Our bounded Lean search found no earlier matching statement or complete proof in the searched sources. That supports a report about the search, not a first-formalization claim. A theorem can be hidden under another name, appear as a consequence of a general library lemma, or exist in unindexed work. Failed requests, inaccessible sources, sparse checkouts, and capped results must remain visible. [Search evidence and limitations](formalization/dyadic-rank/FORMALIZATION-AND-PROOF-COMPARISON.md)

**Next time:** update the four answers whenever a significant source or proof route appears. Revisit the literature after deriving a strong lemma: the lemma's vocabulary may retrieve a theorem that the original conjecture's vocabulary did not.

## Check sources and formal proofs at their boundaries

A candidate reference becomes evidence only after reading its relevant statement and hypotheses. For Friedlander–Pevtsova, the erratum and ground-field assumptions mattered to the translation. For Kustin–Şega–Vraciu, it mattered which direction of Proposition 1.9 was used and which assumptions belonged to other nearby results. Exact theorem numbers, versions, and page locators prevented these distinctions from being lost. [Prior-art review](formalization/dyadic-rank/PRIOR-ART.md)

Lean's kernel checks the formal implication from the definitions and premises supplied. It does not certify that those definitions match a sentence in a paper, that a reference is accurate, or that a novelty claim is justified. We therefore need both a source-to-statement comparison and a checked implementation. The pinned toolchain, dependency revisions, source hashes, consumer examples, and axiom reports make the latter inspectable. [Verification record](formalization/dyadic-rank/verification.json)

**Next time:** require an explicit hypothesis-by-hypothesis comparison for every claimed equivalent theorem. Review the public Lean statement as carefully as its proof. Use AI to generate translations, candidate lemmas, and search leads, then verify those outputs against sources and the compiler. Seek independent mathematical review of the informal bridge and historical interpretation before relying on them for a strong publication claim.

## Measure progress using mathematical targets

The inventory distinguishes source occurrences, canonical questions, broad directions, statements, finite cases, and complete proofs. Those distinctions answer different questions. Repeated appearances of one conjecture are not independent unresolved targets; helper lemmas and instances in several dimensions do not count as several source problems solved. A precisely written mathematical statement in a paper is also different from a proof-assistant statement. [Counting rules](literature/OPEN-PROBLEMS.md)

**Next time:** state the denominator and inclusion rule beside every coverage percentage. Track historical source status separately from current resolution status, and retain completed targets in a fixed cohort. Use “not identified in this search” for an unsuccessful artifact search and “not assessed” for unavailable material.

## Workflow for the next investigation

1. **Select a target.** Record its source, exact locator, historical status, and reason it is tractable or valuable. Separate an author-posed question from a reviewer-suggested task.
2. **Freeze its meaning.** Write matching informal and Lean statements. Resolve the coefficient field, quantifiers, boundary cases, and every ambiguous operation.
3. **Map alternative formulations.** Build a short translation table and test the implications. Run an initial prior-art search across those formulations before committing to an expensive implementation.
4. **Check examples and candidate obstructions.** Verify small cases, test plausible counterexamples, and record exact search scope. Use the results to identify a useful structural lemma.
5. **Choose and formalize a route.** Estimate missing dependencies, prove the central lemma, and assemble the general theorem. Keep finite computation and unused literature routes separate from the proof's actual premises.
6. **Repeat the literature comparison.** Search using the final lemma's language, read primary statements and errata, and compare mechanisms. Update the four novelty questions above.
7. **Audit the result.** Check statement fidelity, a clean build, consumer examples, axioms, pinned dependencies, and hashes. Account explicitly for every remaining informal step.
8. **Publish and preserve.** Match each public claim to its evidence; credit the question's source and the prior results. Check the compiled paper and shared URLs, retain a complete source snapshot, and record lessons while the reasoning is fresh.

Publication readiness can be checked early: distribution requirements, attribution, account access, licensing, and the artifact's intended audience can affect how a result is shared. These are separate from proving the mathematics.

## Reusable investigation worksheet

Copy this into the next target's research notes and update it as evidence changes:

```text
Target and source locator:
Source version and date:
Exact objects, field, quantifiers, hypotheses, and conclusion:
Ambiguities and boundary examples:
Lean statement and comparison with the source:

Equivalent formulations and their justified implications:
Search terms, sources, dates, limits, and unresolved access gaps:
Candidate prior theorems and hypothesis comparisons:

Counterexample search scope, exact arithmetic, seed, and saved witnesses:
Candidate proof routes and missing formal dependencies:
Central lemma and current proof obstruction:

Checked statements and proofs:
Remaining informal claims or translations:
Build, dependency revisions, source hashes, and axiom report:

Mathematical novelty:
Proof-method novelty:
Formalization priority:
Concrete contribution supported by the evidence:
Next action that would resolve the most important uncertainty:
```

A successful next investigation might yield a theorem, a counterexample, a reusable formal lemma, a corrected formulation, or a connection to existing theory. Record the achievement in terms of what was actually learned and verified.

## Lessons from the bounded trajectory-mechanism loop

- **Freeze before fresh noise.** Preserve the old exploratory grid, unsuccessful candidates, detector definitions, seeds and hashes. A revised mechanism needs a new independent validation claim; do not quietly reinterpret the original holdout.
- **Distinguish states from decisions.** Two hard decisions can alternate while the full integer messages never repeat. Exact recurrence, a proved invariant region and a finite-horizon parity certificate have different conclusions.
- **Count rescues as well as losses.** On the fresh comparison, the primary certificate marks 825 lost versus 824 gained syndrome matches for one code, and 821 versus 735 for the other. Thousands of certified failures do not by themselves explain a net penalty.
- **Do not sell late verification as prediction.** A tube starting at iteration 75 with ±1 integer unit can certify nearly every remaining rejection when different checks are allowed. That does not explain entry into failure, establish an infinite trap, or validate an error-floor predictor.
- **Link numerical certificates to the actual model.** Check the matrix/edge correspondence, rounding, clipping, every transition and the stopping horizon. Keep mathematical update proofs, implementation replay and Monte Carlo counts separate.
- **Close a manageable execution bridge.** For two fixed fresh errors, checking the prefixes from the integer prior turns a conditional late-state certificate into a complete mathematical first-match comparison. That verifies those examples; it does not supply a compact condition explaining the population penalty.
- **Make large certificates checkable.** Balanced lookup tables, serial Lean builds, independent data round trips and byte-for-byte regeneration checks kept the numerical proofs practical without a native-decision shortcut.
- **Retain negative results and stop weak routes.** No exact recurrence or rejecting invariant box was found under the frozen rules. A small old-data-only two-phase refinement also found no rejecting certificate; it did not change the holdout rules.

The [full study](formalization/cyclic-lifts/LOOP-HOLDOUT.md) preserves the numerical outcomes, formal scope and remaining gaps.

### Validate social and code searches before interpreting zero results

A GitHub search qualifier can yield false zero results without a useful error.
Check a known-positive control, retain effective query text and caps, inspect
public matches, and exclude invalid searches from prior-art conclusions. Record
X access restrictions and available date/order filters. Neither service substitutes
for reading the applicable classical theorem and its hypotheses.

### Audit negative searches with a full-word oracle

The distance-preservation search had an "at most two more variables" shortcut
that checked pairs but omitted singles. Positive logical witnesses and the
independent Lean counterfamily proof remained valid, but every negative search
claim had to be withdrawn. The repaired search reproduced those outcomes only
after a failing-old/passing-new regression and 1,235 comparisons against complete
binary-word enumeration on small periodic CSS inputs.

Test every smaller completion allowed by a search budget, including degenerate
and zero-quotient cases. Preserve old outputs as superseded history, replay the
same frozen matrices and bounds, and bind results to the actual implementation
and input hashes. Include node caps in conflicting input filenames. A repaired
external exclusion still needs its own faithful bridge before it becomes a Lean
lower-bound certificate. [Repair and replay evidence](formalization/distance-preservation/search-repair.json).

### Browser extensions and CLI access can avoid a desktop dependency

During the 25 October 2026 access checks, the installed GitHub CLI successfully
verified an existing authenticated login when network access was available. The
initial restricted-network check had reported an invalid token; that message did
not establish that the credentials required replacement.

The Edge browser-extension connection also successfully opened and read a public
page. In a subsequent test, after the user reported locking the Mac and a requested
ten-second delay elapsed, it opened X search, used the existing signed-in session,
and returned readable results for `lifted product codes` with Latest selected.
These were extension operations, not native desktop-control operations. The lock
status was user-reported, not independently verified. No sleep test was performed.

Earlier native desktop access had failed while the Mac was locked. Together these
observations support checking the available control method before treating an
unlocked desktop as a prerequisite. They do not establish behavior for every
machine, future connection, site operation or sleeping computer.

For future research, discover available routes early and verify actual operations.
Use an applicable GitHub connector or authenticated CLI where sufficient, and a
supported signed-in browser extension for X when needed. Attempt service searches
opportunistically, continue independent research when blocked, and retry at useful
checkpoints or after meaningful access changes. Each required search must be
completed with stated scope or left as an explicit access gap at closeout.
The [portable access guide](.agents/skills/open-question-research/references/research-access.md)
describes setup on another machine and keeps installation, authentication and
permission changes separate from routine research.

### Certify the strength of a relaxation before extending its search

The October27 C16 comparison produced an exact rational feasible point for the
basic degree-two cyclic moment SDP, with independent source-pool equation replay
and interval-checked positive semidefiniteness. This proves that this particular
relaxation cannot exclude a128-pair frame. It does not construct such a frame.
Separately, a checked UNSAT proof excluded quarter-turn invariant full frames;
no theorem lets us impose that invariance on every possible frame.

Average moments over a symmetry group when the necessary constraints allow it;
keep the distinction from requiring a symmetric combinatorial solution. Use
small literal controls and a known physical witness to check new constraints.
If a numerical relaxation appears feasible, attempt exact reconstruction before
calling its weakness established. Here, retaining the full matrix scaling while
projecting out forced cardinality null directions changed a stalled numerical
run into a quickly certifiable point. Local Hall pruning removed15.6% of phase
choices in a conditional benchmark, but did not establish a global search speedup.
These are bounded method results, while the original width question stays open.
[Models, certificates and comparison scope](formalization/canonical-width/c16/STRUCTURAL-COMPARISON.md).


### Establish pool-preserving coordinate bridges before using module reductions

The October27 C16 inversion study found an exact rank-one Cartesian description
of both source pools over a finite local ring. Checking the adjoint coordinate
map, every pool vector and every cross-pairing made the tensor interpretation
usable for arbitrary binary bases. The thin-factor congruence then gave a
written dimension formula and necessary type-spanning constraints without
another global exhaustive search.

A quotient's small maximum frame is not automatically a bound on the original
frame. An explicit primitive free-cyclic counterexample has a full frame but no
full residue frame. A separate trace-dual product basis refutes a generic
half-basis-in-one-factor-line argument. Keep the source's joint hypotheses in
the proposed lifting lemma, and test each claimed implication on small literal
examples before transferring a reduced UNSAT certificate. Here the original
question remains open, and no global solver speedup or Lean library reuse was
established. [Proofs, counterexamples and scope](formalization/canonical-width/c16/INVERSION.md).


### Retain finite scalar representatives and certify the actual restriction

The four-hour C16 inverse-pool continuation preserves the exact thin-factor
orbits, residues, projective directions, thin modules and transpose exchange
in an enlarged pool that admits a full frame. Those aggregate invariants do
not justify residue descent. The finite thick scalar representatives matter.
Keeping them gives checked original-pool restrictions: at least three thin
families per sector and three excluded triple supports. The unrestricted
question remains open. [Proof and counterexample](formalization/canonical-width/c16/INVERSE-FOUR-HOURS.md).

A numerical dual need not have exact stationarity to yield a proof. Compute
its residual exactly and bound it using the known0..1 moment box. Here this
produces strict rational contradictions. Integer periodic-difference bases
and rational congruence preconditioners also replace transcendental PSD
checks by exact integer diagonal-dominance checks. Identity, indefinite and
corrupted-certificate controls accompany the replay.

FLINT LLL finds valid integer-affine-form inequalities violated by tested
fractional moments; it does not by itself find a frame or prove nonexistence.
Private-partner ownership supplies another source-specific moment restriction,
checked against every source common-neighbor set and the physical88-pair frame.
Keep these separation results distinct from end-to-end progress: the original
width stays16 or18, the new family condition removes zero frozen unresolved
leaves, and no global runtime gain is demonstrated. Positive numerical margin
objectives and `optimal_inaccurate` statuses still require independent checks;
one such margin trial fails the full-PSD check.

### Test what a literature reduction preserves, then certify finite obstructions

The overnight C16 literature comparison proves that the actual pool matrix has
half-induced matching number, asymptotic induced matching number and binary
support rank all exactly128. A triangular128 minor already lies in a restricted
case that has no128-frame. Thus these asymptotic parameters lose the finite
distinction needed here. A representative row basis also preserves existence of
a compatible entry in a column, while a three-row example shows it can destroy
simultaneous private partners. Apply representative-set results to their actual
completion-compatibility interface, not directly to the pool matrix.

A verified sector-exchange action separates cyclic moment PSD blocks into
even and odd sector parts. Averaging moments does not impose symmetry on a
selected frame. This reduction enabled a new exact exclusion of the joint
thin-support034/034 case. Independent source-row regeneration, exact residual
correction and integer PSD checks certify the result; no critical-monomial
enumeration cap is needed. This is a restricted obstruction, not an answer to
the unrestricted width question or evidence of a global runtime gain. The
selected third-moment pilot produced no certified improvement and was closed
at its stated gate. [Argument, certificate and limits](formalization/canonical-width/c16/OVERNIGHT-RESEARCH.md).
