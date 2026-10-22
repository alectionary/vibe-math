# Lean formalization and proof difficulty estimates

The finite graph and binary-matrix questions offer the clearest starting points. Specialized geometry, support varieties, knot theory and nonlinear PDEs require much larger foundations. All **114 inventory entries** have an assessment, but **41 directions or historical/formulation holds** do not yet identify a proof task precise enough to schedule. [Searchable estimates](difficulty.html) · [Per-question data](difficulty-estimates.json) · [Open-problem inventory](../literature/OPEN-PROBLEMS.md).

These are **low-confidence planning estimates**, dated October 21, 2026. They are family-based priors with selected question-specific adjustments, not measurements from implementing each target. A dependency spike can move a target by a full tier or more. Ratings assume one experienced Lean developer who understands the relevant mathematics and can use existing tools; they do not estimate a beginner's learning time or predict the effect of future automation.

These estimates precede the [dyadic rank pilot](../formalization/dyadic-rank/README.md). Its complete general Lean proof is recorded in the current coverage inventory; the estimates below have not been recalibrated from that implementation.

## Three different difficulties

**Writing a faithful statement** includes necessary definitions and an audit of its quantifiers, ambient objects and hypotheses. Merely declaring undefined predicates, assuming the conclusion as an axiom, using `sorry`, or substituting an easier algebraic surrogate does not meet this stage. Proving all supporting mathematical theory is not required merely to state a conjecture.

**Transferring a complete mathematical proof into Lean** includes missing supporting lemmas, a successful build, and review of axioms and the specification. Its estimate assumes that a correct, complete proof resolving the exact target has already been supplied. It is an estimate of additional work after the statement setup; shared foundations must not be charged again for every related question. A short argument invoking deep unavailable theory can be expensive to transfer.

**Discovering a proof or counterexample** is original mathematics. Its time to completion is left **unestimated for every open target**. A problem may be false, already resolved elsewhere, or much harder than its short statement suggests. The relative research-obstacle labels below express where exploration appears feasible; they are not probabilities of success or promises of a solution. The literature audit did not establish current open status for every target.

## Effort scale

The two effort columns use different bands because stating a problem and checking a supplied proof are different tasks. Person-days/weeks/months describe one expert's effort, not an elapsed deadline. The ranges are rough scenarios, not statistical confidence intervals or lower/upper bounds.

| Tier | Label | Faithful statement and definitions | Additional proof transfer given a complete proof |
| --- | --- | --- | --- |
| 1 | small | 1–3 expert person-days | 2–5 expert person-days |
| 2 | manageable | 4–10 expert person-days | 1–4 expert person-weeks |
| 3 | substantial | 2–6 expert person-weeks | 1–4 expert person-months |
| 4 | large | 1–4 expert person-months | 4–12 expert person-months |
| 5 | foundational project | 4–12+ expert person-months | 1–3+ expert person-years |

Research-obstacle level **3** denotes a concrete finite/constructive target where small-instance experiments or a specific missing lemma may help; **4** denotes a substantial specialized theorem, classification or algorithmic improvement; **5** denotes a major analytic or foundational challenge. The numbers are ordinal judgments. No target here is assigned a known short proof merely because finite instances can be checked.

## Distribution across the 74 tracked targets

| Tier | Statement setup | Conditional proof transfer |
| --- | ---: | ---: |
| 1 — small | 0 | 0 |
| 2 — manageable | 13 | 1 |
| 3 — substantial | 29 | 22 |
| 4 — large | 21 | 23 |
| 5 — foundational project | 8 | 25 |
| Needs formulation first | 3 | 3 |

Three targets retained in the earlier coverage denominator need an additional formulation decision for project planning: weighted Horace applicability, Ganger's higher-dimensional relationship, and the scope of Bernstein inequalities. Their audit status and the 74-target denominator are preserved. Ratings change no formalization-coverage count. Method-request entries concerning non-computer-assisted proofs are outside that denominator; a computational Lean certificate alone would not answer those requests.

## Practical starting projects

| Project | First bounded milestone | Rough expert pilot effort | What remains open |
| --- | --- | --- | --- |
| Dyadic rank/support converse, L-P11-rank-converse | Define the binary dyadic matrix and certify small rank/support examples using explicit linear-algebra certificates | 1–3 person-weeks | The universal converse across all permitted dimensions |
| Graph saturation and subgraph counts, including Volk and P27 | Specify saturation and certify a tiny construction or a bounded enumeration, for example up to five vertices | 1–3 person-weeks | The general extremal formula or all-parameter classification |
| Neural-code invariants, including Geraci and P02 | Implement finite code operations and check a few examples on at most three neurons | 2–6 person-weeks | General maxima, code-isomorphism issues and the bridge to polynomial canonical forms |

The pilot bands are separate estimates for these limited milestones, not schedules for solving the corresponding open questions. The dyadic target uses ordinary rank over F_2; the neural-code Boolean-rank question uses Boolean factorization rank. They require different definitions. For the rank converse, boundary dimensions and division by two need explicit treatment before finite tests are meaningful. Subgraph copy counts also need a computable representation before automatic enumeration can certify them.

## Reuse and overlap

Related questions can share binary-matrix indexing and rank lemmas, a graph saturation/counting API, neural-code morphisms/canonical forms, or partition-incidence and measure lemmas. Existing repeated questions retain one canonical estimate. **Do not sum the individual time bands**: setup can be shared, proofs can imply subsidiary results, and research discovery can dominate every estimate. Sharing a PDE vocabulary does not make a result about a different equation or dissipation exponent a proof of the original target.

For the PDE questions, a faithful weak-solution definition is achievable before developing a full nonlinear existence theory; its statement tier is therefore generally lower than its proof tier. Existing Sobolev definitions are useful prerequisites, not evidence that the target's periodic vector-field spaces, nonlinear estimates and uniqueness theorem are already available.

## Library evidence and assumptions

The estimates use the pinned source snapshot already recorded in [audit sources](../audit/sources.json). Source files establish available prerequisites, not complete support for the target. In particular, graph copies, matrix rank, finite powersets, automata, polynomial rings and Sobolev distributions have concrete source files. Weighted projective geometry and support varieties still require object-specific bridges. [Inspected prerequisite files](difficulty-sources.json).

- [Mathlib/Algebra/MvPolynomial/Basic.lean](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/Algebra/MvPolynomial/Basic.lean).
- [Mathlib/Algebra/Polynomial/Basic.lean](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/Algebra/Polynomial/Basic.lean).
- [Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean).
- [Mathlib/Analysis/Calculus/FDeriv/Basic.lean](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/Analysis/Calculus/FDeriv/Basic.lean).
- [Mathlib/Analysis/Distribution/Sobolev.lean](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/Analysis/Distribution/Sobolev.lean).
- [Mathlib/Combinatorics/SimpleGraph/Basic.lean](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/Combinatorics/SimpleGraph/Basic.lean).
- [Mathlib/Combinatorics/SimpleGraph/Copy.lean](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/Combinatorics/SimpleGraph/Copy.lean).
- [Mathlib/Computability/DFA.lean](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/Computability/DFA.lean).
- [Mathlib/Computability/Language.lean](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/Computability/Language.lean).
- [Mathlib/Data/Finset/Powerset.lean](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/Data/Finset/Powerset.lean).
- [Mathlib/LinearAlgebra/Matrix/Rank.lean](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/LinearAlgebra/Matrix/Rank.lean).
- [Mathlib/Probability/ProbabilityMassFunction/Basic.lean](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/Probability/ProbabilityMassFunction/Basic.lean).
- [Mathlib/RingTheory/Nullstellensatz.lean](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/RingTheory/Nullstellensatz.lean).
- [Mathlib/Topology/MetricSpace/Basic.lean](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/Mathlib/Topology/MetricSpace/Basic.lean).

## Per-question estimates

“Hold” means define a particular theorem or validate the historical target before scheduling. Research difficulty is assessed separately from implementation effort.

### 2026-Geraci-O01

Size of the Ferrers-cover/biclique-cover gap, with fixed-vertex qualification requiring clarification.

**Formulation or historical hold:** Clarify the fixed-vertex qualification and intended asymptotic family. The shared family setup would be approximately statement tier 4 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Ferrers covers and Boolean rank are finite, but the source’s fixed-vertex/unbounded-gap qualification must be resolved; regularity also needs commutative algebra. Finite code families are concrete, but canonical forms, code isomorphism, morphisms and minimum-neuron number need a coherent representation and bridge lemmas.

First milestone: Encode finite codes and the relevant invariant; test definitions on the paper’s examples.

Reuse cluster: neural codes. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2026-geraci-o01).

### 2026-Geraci-O02

Largest canonical form of an intersection-complete code on n neurons.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

A finite-set canonical-form model is promising, but its correspondence with the paper’s pseudomonomial canonical form must be justified. Finite code families are concrete, but canonical forms, code isomorphism, morphisms and minimum-neuron number need a coherent representation and bridge lemmas.

First milestone: Encode finite codes and the relevant invariant; test definitions on the paper’s examples.

Reuse cluster: neural codes. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2026-geraci-o02).

### 2026-Geraci-O03

Boolean rank equals reduced-code rank plus the count of nonsimple redundancies.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

Needs Boolean semiring factorization rank, not ordinary field rank, plus reduction and nonsimple redundancy. Finite code families are concrete, but canonical forms, code isomorphism, morphisms and minimum-neuron number need a coherent representation and bridge lemmas.

First milestone: Encode finite codes and the relevant invariant; test definitions on the paper’s examples.

Reuse cluster: neural codes. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2026-geraci-o03).

### 2025-Zamir-O01

Uniform boundedness in d of the weighted-plane defect D(X,d).

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Polynomial, ideal and some projective/elliptic foundations help, but weighted grading, interpolation multiplicities, symbolic powers and geometric-to-algebraic bridges remain major tasks.

First milestone: Start with an explicit weighted polynomial ideal and a finite-dimensional evaluation matrix.

Reuse cluster: weighted geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2025-zamir-o01).

### 2025-Zamir-O02

Applicability of Horace or a suitable modification in the specified weighted projective spaces.

**Formulation or historical hold:** Replace “Horace applies” by a specified lemma, hypotheses and interpolation conclusion. The shared family setup would be approximately statement tier 4 and proof-transfer tier 5 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Polynomial, ideal and some projective/elliptic foundations help, but weighted grading, interpolation multiplicities, symbolic powers and geometric-to-algebraic bridges remain major tasks.

First milestone: Start with an explicit weighted polynomial ideal and a finite-dimensional evaluation matrix.

Reuse cluster: weighted geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2025-zamir-o02).

### 2024-Ganger-O01

Extension to higher dimensions of the identified canonical-spread group relationship.

**Formulation or historical hold:** Choose the exact higher-dimensional correspondence and its parameter range. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Finite fields and group actions help, but the exact spread construction and higher-dimensional correspondence must be defined rather than inferred from a summary.

First milestone: Implement the smallest spread/group instance and state its correspondence.

Reuse cluster: finite geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2024-ganger-o01).

### 2024-Lieberman-O01

Scope of Bernstein's inequality for the indicated general algebras and differential-operator modules.

**Formulation or historical hold:** Choose a ring class and a single proposed inequality/classification assertion. The shared family setup would be approximately statement tier 4 and proof-transfer tier 5 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Filtered differential-operator rings, growth dimensions and sandwich identities require specialized algebraic APIs and careful filtrations.

First milestone: Specify a concrete ring and a sandwich functional equation before tackling a class of rings.

Reuse cluster: differential operators. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2024-lieberman-o01).

### 2024-Lieberman-O02

Existence of sandwich functional equations in the indicated generality.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Filtered differential-operator rings, growth dimensions and sandwich identities require specialized algebraic APIs and careful filtrations.

First milestone: Specify a concrete ring and a sandwich functional equation before tackling a class of rings.

Reuse cluster: differential operators. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2024-lieberman-o02).

### 2024-Enlow-O01

Uniqueness of weak solutions in the indicated calmed velocity–vorticity regime.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 5/5; resolution time unestimated; open research not scheduled.

The statement needs exact domains, forcing, divergence constraints, regularity and weak-solution classes. A proof additionally needs nonlinear estimates, approximation, compactness and solution theory.

First milestone: Specify the exact solution class and formalize one energy inequality in an abstract Hilbert-space setting.

Reuse cluster: fluid pde. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2024-enlow-o01).

### 2024-Enlow-O02

Global-attractor existence for the indicated calmed velocity–vorticity regime.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 5/5; resolution time unestimated; open research not scheduled.

Weak-solution nonuniqueness affects the dynamical framework; identify whether the target uses a semigroup, trajectories or a multivalued evolution. The statement needs exact domains, forcing, divergence constraints, regularity and weak-solution classes. A proof additionally needs nonlinear estimates, approximation, compactness and solution theory.

First milestone: Specify the exact solution class and formalize one energy inequality in an abstract Hilbert-space setting.

Reuse cluster: fluid pde. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2024-enlow-o02).

### 2024-Enlow-O03

Global well-posedness for the original three-dimensional MHD system in the discussed regime.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 5/5; resolution time unestimated; open research not scheduled.

Unrestricted original-system global well-posedness is a major analytic research obstacle; a formalization timetable cannot bound discovery time. The statement needs exact domains, forcing, divergence constraints, regularity and weak-solution classes. A proof additionally needs nonlinear estimates, approximation, compactness and solution theory.

First milestone: Specify the exact solution class and formalize one energy inequality in an abstract Hilbert-space setting.

Reuse cluster: fluid pde. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2024-enlow-o03).

### 2024-Enlow-O04

Global well-posedness for the discussed original two-dimensional Kuramoto–Sivashinsky equation.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 5/5; resolution time unestimated; open research not scheduled.

Global two-dimensional KSE well-posedness requires a new analytic argument; local convergence of calmed approximations does not supply it. The statement needs exact domains, forcing, divergence constraints, regularity and weak-solution classes. A proof additionally needs nonlinear estimates, approximation, compactness and solution theory.

First milestone: Specify the exact solution class and formalize one energy inequality in an abstract Hilbert-space setting.

Reuse cluster: fluid pde. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2024-enlow-o04).

### 2024-Al-O01

Polar-target generalization under the specified distant asteroidal dominating-target hypothesis.

**Statement:** tier 2/5, 4–10 expert person-days. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2024-al-o01).

### 2023-Wright-O01

Existence of a complete Alexander neighbor with nontrivial Alexander polynomial.

**Statement:** tier 5/5, 4–12+ expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

A faithful Alexander-neighbor statement needs knots, crossing changes and polynomial invariance together. An algebraic surrogate alone would not establish the topological assertion.

First milestone: Separate a finite algebraic obstruction from the theorem identifying it with the knot-theoretic condition.

Reuse cluster: knots. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-wright-o01).

### 2023-Wright-O02

First stated algebraic-unknotting extension of Alexander-neighbor realizability.

**Statement:** tier 5/5, 4–12+ expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

A faithful Alexander-neighbor statement needs knots, crossing changes and polynomial invariance together. An algebraic surrogate alone would not establish the topological assertion.

First milestone: Separate a finite algebraic obstruction from the theorem identifying it with the knot-theoretic condition.

Reuse cluster: knots. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-wright-o02).

### 2023-Wright-O03

Further stated algebraic-unknotting extension.

**Statement:** tier 5/5, 4–12+ expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

A faithful Alexander-neighbor statement needs knots, crossing changes and polynomial invariance together. An algebraic surrogate alone would not establish the topological assertion.

First milestone: Separate a finite algebraic obstruction from the theorem identifying it with the knot-theoretic condition.

Reuse cluster: knots. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-wright-o03).

### 2023-Wright-O04

Stronger breadth-two exclusion in the stated setting.

**Statement:** tier 5/5, 4–12+ expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

A faithful Alexander-neighbor statement needs knots, crossing changes and polynomial invariance together. An algebraic surrogate alone would not establish the topological assertion.

First milestone: Separate a finite algebraic obstruction from the theorem identifying it with the knot-theoretic condition.

Reuse cluster: knots. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-wright-o04).

### 2023-Wright-O05

Further breadth-two exclusion conjecture.

**Statement:** tier 5/5, 4–12+ expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

A faithful Alexander-neighbor statement needs knots, crossing changes and polynomial invariance together. An algebraic surrogate alone would not establish the topological assertion.

First milestone: Separate a finite algebraic obstruction from the theorem identifying it with the knot-theoretic condition.

Reuse cluster: knots. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-wright-o05).

### 2023-DeClerk-O01

Whether every group with the falsification by fellow traveler property is automatic.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Automata and languages exist, but group words, Cayley geometry, fellow travelling and the precise rewriting/automaticity conventions need integration.

First milestone: Define word evaluation and fellow travelling for one finitely generated group.

Reuse cluster: formal languages. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-declerk-o01).

### 2023-DeClerk-O02

Whether every FFTP group admits a finite convergent rewriting system.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Automata and languages exist, but group words, Cayley geometry, fellow travelling and the precise rewriting/automaticity conventions need integration.

First milestone: Define word evaluation and fellow travelling for one finitely generated group.

Reuse cluster: formal languages. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-declerk-o02).

### 2023-Vander-Woude-O01

Clique behavior for the specified alternative partition construction in dimension at least five.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

An explicit construction/clique problem gives more concrete finite-dimensional structure than a universal partition theorem. Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-vander-woude-o01).

### 2023-Vander-Woude-O02

Exponential bifurcation behavior as epsilon increases.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-vander-woude-o02).

### 2023-Vander-Woude-O03

Exact optimal epsilon for the stated diameter-bounded partition class.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-vander-woude-o03).

### 2023-Vander-Woude-O04

Constant-factor optimal epsilon for k=d+1 in that class.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-vander-woude-o04).

### 2023-Vander-Woude-O05

Order-1/d upper bound for polynomial k in the stated class.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-vander-woude-o05).

### 2023-Vander-Woude-O06

Corresponding bound for the specified outer-measure class.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Outer-measure hypotheses and possibly nonmeasurable cells make both statement fidelity and proof transfer harder. Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-vander-woude-o06).

### 2023-Vander-Woude-O07

Anisotropic rectangular intersection bound.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-vander-woude-o07).

### 2023-Vander-Woude-O08

Improved epsilon for rectangular volume-one partitions.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-vander-woude-o08).

### 2023-Vander-Woude-O09

Extension of the specified cube enclosure to a partition.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Existence of a global partition extending an enclosure is more than a finite point-incidence calculation. Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-vander-woude-o09).

### 2023-Vander-Woude-O10

Converse of the stated cousinly/secluded implication.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

A converse between specified structural predicates may yield a manageable lemma or finite counterexample after definitions are fixed. Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-vander-woude-o10).

### 2023-Vander-Woude-O11

Equivalence involving affine independence of the specified clique.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

An explicit affine-independence/clique equivalence is a plausible shared-library target, although truth and the missing direction remain unverified. Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-vander-woude-o11).

### 2023-Vander-Woude-O12

Randomized-rounding limitation in the specified setting.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Needs a precise probabilistic rounding model and quantifiers over schemes, rather than just deterministic partition geometry. Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-vander-woude-o12).

### 2023-Vander-Woude-O13

Range of the two specified neighborhood-color functions.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2023-vander-woude-o13).

### 2022-Volk-O01

Exact cherry-minimizer/star-comparison question; duplicate formulations counted once.

**Statement:** tier 2/5, 4–10 expert person-days. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2022-volk-o01).

### 2022-Volk-O02

Exact path-minimizer split question.

**Statement:** tier 2/5, 4–10 expert person-days. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2022-volk-o02).

### 2022-Volk-O03

Threshold separating the specified matching-covered optimizers.

**Statement:** tier 2/5, 4–10 expert person-days. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2022-volk-o03).

### 2022-Volk-O04

Optimal value of the specified construction-bound constant.

**Statement:** tier 2/5, 4–10 expert person-days. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

Optimizing a specified construction bound is narrower than classifying every saturated graph; parameters and exceptional n must remain explicit. Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2022-volk-o04).

### 2022-Volk-O05

Remaining minimizer-parameter cases beyond the stated partial results.

**Statement:** tier 2/5, 4–10 expert person-days. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2022-volk-o05).

### 2022-Volk-O06

Specified weak generalized-saturation variant.

**Statement:** tier 2/5, 4–10 expert person-days. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2022-volk-o06).

### 2025-Barrett-O01

Which smooth fans satisfy the stated toric Zariski–Nagata equality; the general surface case remains unresolved in the dissertation.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Fans, toric/Cox constructions and the precise symbolic/differential-power comparison need a dedicated interface beyond affine polynomial ideal results.

First milestone: Specify one smooth fan and the associated ideal equality in an explicit algebraic model.

Reuse cluster: algebraic geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#2025-barrett-o01).

### L-P01-Q6.1

Can the gap between regularity and Ferrers cover number in (6.1) be arbitrarily large over bipartite graphs?

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

This compares edge-ideal quotient regularity with Ferrers cover number; encoding only a matrix rank would omit one invariant. Finite code families are concrete, but canonical forms, code isomorphism, morphisms and minimum-neuron number need a coherent representation and bridge lemmas.

First milestone: Encode finite codes and the relevant invariant; test definitions on the paper’s examples.

Reuse cluster: neural codes. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p01-q6.1).

### L-P02-matrix-invariants

Identify matrix properties invariant under the equivalence classes of code morphism representatives.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 3 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Finite code families are concrete, but canonical forms, code isomorphism, morphisms and minimum-neuron number need a coherent representation and bridge lemmas.

First milestone: Encode finite codes and the relevant invariant; test definitions on the paper’s examples.

Reuse cluster: neural codes. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p02-matrix-invariants).

### L-P02-cover-multiplication

Characterize which codes covering a given code arise by matrix multiplication, in an analogue of Theorem 5.19.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

Finite code families are concrete, but canonical forms, code isomorphism, morphisms and minimum-neuron number need a coherent representation and bridge lemmas.

First milestone: Encode finite codes and the relevant invariant; test definitions on the paper’s examples.

Reuse cluster: neural codes. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p02-cover-multiplication).

### L-P02-translated-BMF

Find conditions ensuring that a covering edge between intersection-complete codes has a pre-translation edge that is a Boolean matrix factorization.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 3 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Finite code families are concrete, but canonical forms, code isomorphism, morphisms and minimum-neuron number need a coherent representation and bridge lemmas.

First milestone: Encode finite codes and the relevant invariant; test definitions on the paper’s examples.

Reuse cluster: neural codes. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p02-translated-bmf).

### L-P02-Q7.1-union

Determine the maximum canonical-form size of a union-complete code on n neurons.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

Can share the intersection-complete canonical-form infrastructure; any complement/duality reduction needs its own bridge proof. Finite code families are concrete, but canonical forms, code isomorphism, morphisms and minimum-neuron number need a coherent representation and bridge lemmas.

First milestone: Encode finite codes and the relevant invariant; test definitions on the paper’s examples.

Reuse cluster: neural codes. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p02-q7.1-union).

### L-P02-enumeration

For fixed n and canonical-form size, count codes on n neurons attaining that size.

**Statement:** tier 2/5, 4–10 expert person-days. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

A fixed-neuron finite count is relatively accessible to state. A formula for every n still requires new combinatorics. Finite code families are concrete, but canonical forms, code isomorphism, morphisms and minimum-neuron number need a coherent representation and bridge lemmas.

First milestone: Encode finite codes and the relevant invariant; test definitions on the paper’s examples.

Reuse cluster: neural codes. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p02-enumeration).

### L-P02-Q7.2

Determine max_C {lambda(C^(i)) - lambda(C)} in the paper’s code construction.

**Formulation or historical hold:** The displayed maximum does not explicitly quantify i or fix the input length; preserve the source wording rather than silently impose a finite extremal regime. The shared family setup would be approximately statement tier 3 and proof-transfer tier 3 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Finite code families are concrete, but canonical forms, code isomorphism, morphisms and minimum-neuron number need a coherent representation and bridge lemmas.

First milestone: Encode finite codes and the relevant invariant; test definitions on the paper’s examples.

Reuse cluster: neural codes. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p02-q7.2).

### L-P02-attain-bound

Does a code attain lambda(C^(i)) <= 2 lambda(C) - 2?

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 2/5, 1–4 expert person-weeks. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

If a valid finite witness is found, checking it may be cheaper than a universal extremal theorem. First fix the intended nontrivial parameter regime and minimum-neuron invariant. Finite code families are concrete, but canonical forms, code isomorphism, morphisms and minimum-neuron number need a coherent representation and bridge lemmas.

First milestone: Encode finite codes and the relevant invariant; test definitions on the paper’s examples.

Reuse cluster: neural codes. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p02-attain-bound).

### L-P02-downset

For length ell, determine the largest number of length ell+1 codes in the down-set generated by length ell codes.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

The code order, isomorphism quotient and length conventions add cost beyond simply counting subsets. Finite code families are concrete, but canonical forms, code isomorphism, morphisms and minimum-neuron number need a coherent representation and bridge lemmas.

First milestone: Encode finite codes and the relevant invariant; test definitions on the paper’s examples.

Reuse cluster: neural codes. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p02-downset).

### L-P02-nonsimple

Determine the largest number of nonsimple redundancies as a function of the minimum neuron number.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

Finite code families are concrete, but canonical forms, code isomorphism, morphisms and minimum-neuron number need a coherent representation and bridge lemmas.

First milestone: Encode finite codes and the relevant invariant; test definitions on the paper’s examples.

Reuse cluster: neural codes. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p02-nonsimple).

### L-P03-functors

Relate cohomological support varieties under functors D^f(S) -> D^f(R) beyond the specific functors treated in the paper.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 5 and proof-transfer tier 5 after a concrete target is chosen; these are not completion estimates for the current broad entry.

The target combines local rings, derived/homological constructions and cohomological support varieties. Polynomial-ring support alone does not provide these objects or comparison theorems.

First milestone: Choose one monomial ideal and specify its support variety with the source presentation conventions.

Reuse cluster: support varieties. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p03-functors).

### L-P04-Q6.1

Classify support varieties of seven- and eight-generated monomial ideals by the paper’s approach, at least computationally.

**Statement:** tier 5/5, 4–12+ expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Seven or eight generators does not bound their exponents or automatically make the classification a finite exhaustive search. Support varieties remain the main prerequisite. The target combines local rings, derived/homological constructions and cohomological support varieties. Polynomial-ring support alone does not provide these objects or comparison theorems.

First milestone: Choose one monomial ideal and specify its support variety with the source presentation conventions.

Reuse cluster: support varieties. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p04-q6.1).

### L-P04-Q6.2

Are edge ideals of (4m+2)-cycles the only monomial ideals whose support variety is not a union of coordinate subspaces?

**Statement:** tier 5/5, 4–12+ expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

The target combines local rings, derived/homological constructions and cohomological support varieties. Polynomial-ring support alone does not provide these objects or comparison theorems.

First milestone: Choose one monomial ideal and specify its support variety with the source presentation conventions.

Reuse cluster: support varieties. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p04-q6.2).

### L-P04-Q6.3

For a monomial ideal with connected GCD graph and n minimal generators, do d <= (n-3)/2 and c <= n/2 hold, where d counts irreducible components and c is support-variety codimension?

**Statement:** tier 5/5, 4–12+ expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

The target combines local rings, derived/homological constructions and cohomological support varieties. Polynomial-ring support alone does not provide these objects or comparison theorems.

First milestone: Choose one monomial ideal and specify its support variety with the source presentation conventions.

Reuse cluster: support varieties. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p04-q6.3).

### L-P07-turnstile

Extend the paper’s cash-register streaming prediction method to the turnstile model.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

A concrete streaming algorithm is specifiable, while M-open modeling language requires an agreed mathematical definition before a theorem can be encoded.

First milestone: Choose a concrete data/algorithm class and a measurable loss or convergence claim.

Reuse cluster: streaming. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p07-turnstile).

### L-P07-complex-data

Determine whether data generators can be too complex to satisfy the usual stochastic modeling assumptions.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

A concrete streaming algorithm is specifiable, while M-open modeling language requires an agreed mathematical definition before a theorem can be encoded.

First milestone: Choose a concrete data/algorithm class and a measurable loss or convergence claim.

Reuse cluster: streaming. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p07-complex-data).

### L-P08-support

Relax boundedness/common bounded support in Theorem 2.2, potentially using the hypotheses of the cited Theorem 2.1.

**Formulation or historical hold:** A proposed route to weaker assumptions, without an exact replacement hypothesis list; excluded until an executable target is specified. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

A concrete streaming algorithm is specifiable, while M-open modeling language requires an agreed mathematical definition before a theorem can be encoded.

First milestone: Choose a concrete data/algorithm class and a measurable loss or convergence claim.

Reuse cluster: streaming. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p08-support).

### L-P08-typical

Characterize typical M-open data and useful subclasses of that data.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

A concrete streaming algorithm is specifiable, while M-open modeling language requires an agreed mathematical definition before a theorem can be encoded.

First milestone: Choose a concrete data/algorithm class and a measurable loss or convergence claim.

Reuse cluster: streaming. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p08-typical).

### L-P08-bias-variance

Determine an appropriate variance–bias tradeoff for M-open data and predictor classes.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

A concrete streaming algorithm is specifiable, while M-open modeling language requires an agreed mathematical definition before a theorem can be encoded.

First milestone: Choose a concrete data/algorithm class and a measurable loss or convergence claim.

Reuse cluster: streaming. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p08-bias-variance).

### L-P09-all-absorbing

Under the paper’s syndrome-based Gallager-B decoder, is every absorbing set a trapping set?

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

A finite decoder state machine allows bounded experiments, but the general absorbing-to-trapping implication needs the exact decoder and quantum degeneracy conventions. Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p09-all-absorbing).

### L-P09-XZ

Understand structural connections between X- and Z-error absorbing sets in hypergraph-product codes.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p09-xz).

### L-P09-structured

Classify absorbing sets in structured QLDPC codes, including hypergraph-product codes with circulant base matrices.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p09-structured).

### L-P09-decoders

Extend graphical failure characterizations to Black-Grey-Flip and belief-propagation decoders, or identify replacement characterizations.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p09-decoders).

### L-P09-nonabsorbing

Characterize failure-inducing sets that are not absorbing sets, including those illustrated by Example 2(c).

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p09-nonabsorbing).

### L-P11-rank-converse

Full converse conjecture: a binary dyadic N-by-N matrix of rank N/2 has nonzero sum of the support vectors of its signature.

**Statement:** tier 2/5, 4–10 expert person-days. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

A particularly compact target: functions on F_2^ell, translation-invariant binary matrices, field rank and an XOR/support-vector sum. A universal proof is still unknown here. Binary vector spaces and matrix rank are available; the dyadic translation rule, support-vector sum and equivalence with the paper’s indexing need careful definitions.

First milestone: Define dyadic matrices over F_2 and certify a small rank calculation.

Reuse cluster: dyadic matrices. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p11-rank-converse).

### L-P11-girth

Find tight achievable-girth bounds and minimum short-cycle multiplicities for dyadic lifts.

**Statement:** tier 2/5, 4–10 expert person-days. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

Fixed-size cycle searches are tractable, but sharp bounds over all lifts/parameters are a separate mathematical problem. Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p11-girth).

### L-P11-invariants

Extend absorbing-set results to general quasi-dyadic ensembles and find dyadic invariants predicting the error floor.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p11-invariants).

### L-P11-forbidden

Are the paper’s forbidden sets complete for length-six and length-eight pathologies?

**Statement:** tier 2/5, 4–10 expert person-days. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

Lengths six and eight permit explicit walk-pattern analysis. Completeness still quantifies over the source ensemble and cannot be inferred from a few tested lifts. Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p11-forbidden).

### L-P11-n-adic

Develop n-adic lifts of irregular protographs to escape the girth-at-most-eight restriction of all-one dyadic lifting.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p11-n-adic).

### L-P11-quantum-scaling

Establish distance/rate scaling for dyadic CSS families and investigate regularity for syndrome extraction and parallel decoding.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p11-quantum-scaling).

### L-P11-group-rings

Extend the framework to other group-ring lift families beyond characteristic two.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p11-group-rings).

### L-P13-relaxations

Develop tight, inexpensive boundary-sensitive lower bounds and effective relaxations for GRACE transition dictionaries.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Finite dynamic programming is accessible, but boundary conditions, real-valued optimization and the intended tightness/runtime guarantees need specification.

First milestone: Verify a restricted recurrence and an admissible lower bound on a fixed model class.

Reuse cluster: changepoint. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p13-relaxations).

### L-P14-generators

Find explicit generators for the defining ideal of a general point in weighted projective n-space, n >= 3, allowing restrictions on the weights.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Polynomial, ideal and some projective/elliptic foundations help, but weighted grading, interpolation multiplicities, symbolic powers and geometric-to-algebraic bridges remain major tasks.

First milestone: Start with an explicit weighted polynomial ideal and a finite-dimensional evaluation matrix.

Reuse cluster: weighted geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p14-generators).

### L-P14-Veronese

Compute minimal free resolutions of the defining ideal of the weighted Veronese variety for the degrees specified in Section 8(3).

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Polynomial, ideal and some projective/elliptic foundations help, but weighted grading, interpolation multiplicities, symbolic powers and geometric-to-algebraic bridges remain major tasks.

First milestone: Start with an explicit weighted polynomial ideal and a finite-dimensional evaluation matrix.

Reuse cluster: weighted geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p14-veronese).

### L-P14-SHGH

Formulate a weighted-projective-plane analogue of SHGH for mixed point multiplicities in P(1,b,c).

**Formulation or historical hold:** Excluded from the coverage denominator: a direction or a formulation/method request, not a fixed unresolved proposition or specified mathematical task. The shared family setup would be approximately statement tier 4 and proof-transfer tier 5 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Polynomial, ideal and some projective/elliptic foundations help, but weighted grading, interpolation multiplicities, symbolic powers and geometric-to-algebraic bridges remain major tasks.

First milestone: Start with an explicit weighted polynomial ideal and a finite-dimensional evaluation matrix.

Reuse cluster: weighted geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p14-shgh).

### L-P15-C5.1

For 6 dividing n and any plane elliptic curve, the triple-point ideal of the elliptified Boroczky construction on E[n] fails I^(3) subset I^2.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

The conjecture ranges over all allowed torsion sizes and plane elliptic curves. Checking a single computed configuration will not prove that quantification. Polynomial, ideal and some projective/elliptic foundations help, but weighted grading, interpolation multiplicities, symbolic powers and geometric-to-algebraic bridges remain major tasks.

First milestone: Start with an explicit weighted polynomial ideal and a finite-dimensional evaluation matrix.

Reuse cluster: weighted geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p15-c5.1).

### L-P15-hand-proof

Give a fully non-computer-assisted proof of I_n^(3) not subset I_n^2 for the configuration family.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** unestimated; different proof method requested.

The task requests a non-computer-assisted mathematical argument; a Lean proof using heavy computation would not meet that methodological request by itself. Polynomial, ideal and some projective/elliptic foundations help, but weighted grading, interpolation multiplicities, symbolic powers and geometric-to-algebraic bridges remain major tasks.

First milestone: Start with an explicit weighted polynomial ideal and a finite-dimensional evaluation matrix.

Reuse cluster: weighted geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p15-hand-proof).

### L-P15-arrangements

Can the Boroczky or elliptified Boroczky configuration be realized as a hyperplane arrangement with ordinary lines only?

**Formulation or historical hold:** The ambient realization requirements require specification before translating this geometric question; excluded from the fixed-target denominator. The shared family setup would be approximately statement tier 4 and proof-transfer tier 5 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Polynomial, ideal and some projective/elliptic foundations help, but weighted grading, interpolation multiplicities, symbolic powers and geometric-to-algebraic bridges remain major tasks.

First milestone: Start with an explicit weighted polynomial ideal and a finite-dimensional evaluation matrix.

Reuse cluster: weighted geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p15-arrangements).

### L-P15-higher-dim

Do analogous constructions on elliptic curves in higher-dimensional projective spaces produce ideals violating symbolic/ordinary power containment?

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 4 and proof-transfer tier 5 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Polynomial, ideal and some projective/elliptic foundations help, but weighted grading, interpolation multiplicities, symbolic powers and geometric-to-algebraic bridges remain major tasks.

First milestone: Start with an explicit weighted polynomial ideal and a finite-dimensional evaluation matrix.

Reuse cluster: weighted geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p15-higher-dim).

### L-P15-table-proof

Give a non-computer-assisted justification for the data in Table 1.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** unestimated; different proof method requested.

A finite table may admit a short certificate, but the source asks for a non-computer-assisted justification, which is a separate constraint. Polynomial, ideal and some projective/elliptic foundations help, but weighted grading, interpolation multiplicities, symbolic powers and geometric-to-algebraic bridges remain major tasks.

First milestone: Start with an explicit weighted polynomial ideal and a finite-dimensional evaluation matrix.

Reuse cluster: weighted geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p15-table-proof).

### L-P16-linear-simplicity

Are differential-operator rings of all graded direct summands of polynomial rings linearly simple for Bernstein filtrations, in the paper’s characteristic-zero setting?

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Filtered differential-operator rings, growth dimensions and sandwich identities require specialized algebraic APIs and careful filtrations.

First milestone: Specify a concrete ring and a sandwich functional equation before tackling a class of rings.

Reuse cluster: differential operators. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p16-linear-simplicity).

### L-P17-weak-unique

Are weak solutions of the calmed rotational Navier–Stokes system (1.7) unique in the paper’s weak solution class?

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 5/5; resolution time unestimated; open research not scheduled.

The statement needs exact domains, forcing, divergence constraints, regularity and weak-solution classes. A proof additionally needs nonlinear estimates, approximation, compactness and solution theory.

First milestone: Specify the exact solution class and formalize one energy inequality in an abstract Hilbert-space setting.

Reuse cluster: fluid pde. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p17-weak-unique).

### L-P17-Leray-Hopf

Are Leray–Hopf weak solutions of the three-dimensional NSE unique in the setting discussed by Remark 7.1?

**Formulation or historical hold:** Historical background question whose domain, forcing and solution class need pinning down before a current coverage comparison. Later primary literature reports nonuniqueness, so it is not counted as a presently unresolved fixed target. The shared family setup would be approximately statement tier 4 and proof-transfer tier 5 after a concrete target is chosen; these are not completion estimates for the current broad entry.

The statement needs exact domains, forcing, divergence constraints, regularity and weak-solution classes. A proof additionally needs nonlinear estimates, approximation, compactness and solution theory.

First milestone: Specify the exact solution class and formalize one energy inequality in an abstract Hilbert-space setting.

Reuse cluster: fluid pde. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p17-leray-hopf).

### L-P17-suitable

Develop suitable-weak-solution analogues and a local energy inequality for calmed rotational NSE under Definition 1.2(4).

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 4 and proof-transfer tier 5 after a concrete target is chosen; these are not completion estimates for the current broad entry.

The statement needs exact domains, forcing, divergence constraints, regularity and weak-solution classes. A proof additionally needs nonlinear estimates, approximation, compactness and solution theory.

First milestone: Specify the exact solution class and formalize one energy inequality in an abstract Hilbert-space setting.

Reuse cluster: fluid pde. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p17-suitable).

### L-P19-local-original

Prove short-time existence and uniqueness for the original Ohmic-heating MHD–Boussinesq system (1.5) in Assumption 2.1’s strong solution class.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Local well-posedness is a narrower research target than global existence, but the Ohmic nonlinearity and temperature estimates are still substantial. The statement needs exact domains, forcing, divergence constraints, regularity and weak-solution classes. A proof additionally needs nonlinear estimates, approximation, compactness and solution theory.

First milestone: Specify the exact solution class and formalize one energy inequality in an abstract Hilbert-space setting.

Reuse cluster: fluid pde. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p19-local-original).

### L-P19-global-original

Establish global well-posedness of the original two-dimensional MHD–Boussinesq system with Ohmic heating (1.5).

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 5/5; resolution time unestimated; open research not scheduled.

A global theorem must rule out loss of regularity; it cannot be obtained by merely formalizing the conditional approximation theorem. The statement needs exact domains, forcing, divergence constraints, regularity and weak-solution classes. A proof additionally needs nonlinear estimates, approximation, compactness and solution theory.

First milestone: Specify the exact solution class and formalize one energy inequality in an abstract Hilbert-space setting.

Reuse cluster: fluid pde. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p19-global-original).

### L-P19-weak-initial

Prove global existence for the calmed system (1.1) from initial data in H x H x L^2 rather than V x V x L^2.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Lower initial regularity removes estimates used in the existing strong-data construction, so discovery requires new bounds as well as formalization. The statement needs exact domains, forcing, divergence constraints, regularity and weak-solution classes. A proof additionally needs nonlinear estimates, approximation, compactness and solution theory.

First milestone: Specify the exact solution class and formalize one energy inequality in an abstract Hilbert-space setting.

Reuse cluster: fluid pde. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p19-weak-initial).

### L-P19-three-D

Extend Ohmic-heating calming to three dimensions with additional regularization of the fluid nonlinearity.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 4 and proof-transfer tier 5 after a concrete target is chosen; these are not completion estimates for the current broad entry.

The statement needs exact domains, forcing, divergence constraints, regularity and weak-solution classes. A proof additionally needs nonlinear estimates, approximation, compactness and solution theory.

First milestone: Specify the exact solution class and formalize one energy inequality in an abstract Hilbert-space setting.

Reuse cluster: fluid pde. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p19-three-d).

### L-P19-softplus

Analyze the alternative soft-plus Ohmic-heating regularization and improved temperature smoothness.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 4 and proof-transfer tier 5 after a concrete target is chosen; these are not completion estimates for the current broad entry.

The statement needs exact domains, forcing, divergence constraints, regularity and weak-solution classes. A proof additionally needs nonlinear estimates, approximation, compactness and solution theory.

First milestone: Specify the exact solution class and formalize one energy inequality in an abstract Hilbert-space setting.

Reuse cluster: fluid pde. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p19-softplus).

### L-P24-C9.17

Does countable, rather than finite, cube intersection suffice for the Third Optimality Theorem, yielding a point incident with at least d+1 partition closures?

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

The countable/finite distinction brings genuine topology; the known one-dimensional case can serve as a smaller proof-transfer pilot. Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p24-c9.17).

### L-P24-dissection

Do hypercube dissection and triangulation numbers agree in every dimension?

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Finite combinatorial triangulation representations may state the equality, but equivalence with geometric dissections needs proof and general-dimensional equality remains unestimated research. Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p24-dissection).

### L-P26-other-norms

Construct near-optimal secluded partitions for norms beyond ell-infinity, especially ell-p norms, approaching the Appendix A.8 bounds.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p26-other-norms).

### L-P26-sample-lower

Establish generic sample-complexity lower bounds for list-replicable learning, beyond algorithms using secluded partitions.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p26-sample-lower).

### L-P26-neighborhood-KKM

Improve the neighborhood Sperner/KKM color bound so it also recovers the classical d+1 bound for arbitrarily small epsilon.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Requires a uniform quantitative topological/combinatorial theorem, not just evaluating the color bound at small epsilon. Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p26-neighborhood-kkm).

### L-P26-KKM-applications

Find applications of the neighborhood Sperner/KKM lemma.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Euclidean sets, topology and measures help; partition incidence, closures, diameter and secluded-neighborhood conventions still need a faithful API.

First milestone: Check an explicit low-dimensional partition or an incidence lemma before universal bounds.

Reuse cluster: partition geometry. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p26-kkm-applications).

### L-P27-Q2.4-existence

For fixed r,t >= 3, classify n admitting S_t-saturated K_(r+1)-free graphs.

**Statement:** tier 2/5, 4–10 expert person-days. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

A finite-graph existence predicate is straightforward relative to other families; the all-n classification can still demand new extremal arguments. Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p27-q2.4-existence).

### L-P27-Q2.4-counts

For fixed r,t >= 3 and n, determine possible numbers of K_r copies in S_t-saturated n-vertex graphs.

**Statement:** tier 2/5, 4–10 expert person-days. **Proof transfer if a complete proof is supplied:** tier 3/5, 1–4 expert person-months. **Mathematical discovery:** relative obstacle 3/5; resolution time unestimated; open research not scheduled.

Subgraph counts are supported, but realizing the complete set of counts is an open classification problem. Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p27-q2.4-counts).

### L-F01-random-bits

Extend the Omega(log d) randomness lower bound for privately answering d linear queries beyond the epsilon <= 1/d regime.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Probability foundations help, but privacy, utility, random-bit cost and computational efficiency are distinct obligations. Expected and worst-case randomness must stay separate.

First milestone: Formalize one finite mechanism and its privacy inequality before its bit-cost/utility tradeoff.

Reuse cluster: privacy. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-f01-random-bits).

### L-F01-efficient-utility

Remove the extra log d utility factor from the efficient ell-infinity mechanism while retaining its low-randomness guarantees.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Requires both geometric utility bounds and a formal computational-efficiency/random-bit model; privacy alone is insufficient. Probability foundations help, but privacy, utility, random-bit cost and computational efficiency are distinct obligations. Expected and worst-case randomness must stay separate.

First milestone: Formalize one finite mechanism and its privacy inequality before its bit-cost/utility tradeoff.

Reuse cluster: privacy. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-f01-efficient-utility).

### L-F01-K-norms

Obtain efficient low-randomness mechanisms for all K-norm sensitivity bodies, or at least all ell-p norms.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 5/5, 1–3+ expert person-years. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Uniform convex-body/norm geometry plus algorithmic efficiency is a larger bridge than a single finite mechanism. Probability foundations help, but privacy, utility, random-bit cost and computational efficiency are distinct obligations. Expected and worst-case randomness must stay separate.

First milestone: Formalize one finite mechanism and its privacy inequality before its bit-cost/utility tradeoff.

Reuse cluster: privacy. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-f01-k-norms).

### L-F01-approximate-DP

Determine the utility achievable by approximate-DP linear-query mechanisms with worst-case polylog(d) random bits, closing the stated utility gap.

**Statement:** tier 4/5, 1–4 expert person-months. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

The worst-case polylogarithmic bit budget and approximate privacy/error parameters must be modeled jointly. Probability foundations help, but privacy, utility, random-bit cost and computational efficiency are distinct obligations. Expected and worst-case randomness must stay separate.

First milestone: Formalize one finite mechanism and its privacy inequality before its bit-cost/utility tradeoff.

Reuse cluster: privacy. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-f01-approximate-dp).

### L-F03-scores

Determine exact generalized saturation-game scores in the (H,F) cases where the paper’s upper and lower bounds differ.

**Statement:** tier 3/5, 2–6 expert person-weeks. **Proof transfer if a complete proof is supplied:** tier 4/5, 4–12 expert person-months. **Mathematical discovery:** relative obstacle 4/5; resolution time unestimated; open research not scheduled.

Game positions and legal moves are finite, but proving optimal minimax strategies uniformly needs more than enumerating small games. Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-f03-scores).

### L-F03-Turan-relation

Determine further generalized saturation-game scores and their relation to corresponding generalized Turan numbers.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 2 and proof-transfer tier 3 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-f03-turan-relation).

### L-F03-spanning

Extend saturation games to spanning graph structures, such as spanning trees or Hamilton cycles, instead of fixed forbidden/scored graphs.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 2 and proof-transfer tier 3 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-f03-spanning).

### L-P28-general-arrays

Extend structural, girth and cycle results to general j-by-k quasi-dyadic or quasi-n-adic arrays with varying block weights.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p28-general-arrays).

### L-P28-algebraic-families

Construct algebraic quasi-n-adic code families with provable parameters, extending the quasi-triadic example.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p28-algebraic-families).

### L-P28-distance-bounds

Develop minimum-distance bounds for quasi-n-adic codes with n >= 3.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p28-distance-bounds).

### L-P28-QC-comparison

Compare Theorem 6.3’s minimum-distance bound with the cited quasi-cyclic bounds and compare quasi-dyadic with quasi-cyclic code families.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p28-qc-comparison).

### L-P28-signature-dimension

Determine how signature support controls the dimension beyond the characterized self-dual dyadic case.

**Formulation or historical hold:** Select one theorem, explicit quantitative bound, construction guarantee or benchmark from this research direction before estimating its completion. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Tanner graphs are finite, but decoder transitions, stopping/cycle behavior, quantum error equivalence and absorbing/trapping terminology add substantial bespoke machinery.

First milestone: Define one exact decoder and verify its finite-state transition rule on a small graph.

Reuse cluster: quantum decoding. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p28-signature-dimension).

### L-F02-original-VV

Establish global well-posedness for the original three-dimensional velocity–vorticity system (2).

**Formulation or historical hold:** The source labels global well-posedness of (2) open but does not fix a solution class and boundary-condition regime in that sentence. Keep it as a background formulation request, not a claim that every generalized model remains untreated. The shared family setup would be approximately statement tier 4 and proof-transfer tier 5 after a concrete target is chosen; these are not completion estimates for the current broad entry.

The statement needs exact domains, forcing, divergence constraints, regularity and weak-solution classes. A proof additionally needs nonlinear estimates, approximation, compactness and solution theory.

First milestone: Specify the exact solution class and formalize one energy inequality in an abstract Hilbert-space setting.

Reuse cluster: fluid pde. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-f02-original-vv).

### L-P20-polar-pairs

Extend maximal-polar-pair methods to graphs with asteroidal triples, potentially covering dominating-pair graphs.

**Formulation or historical hold:** Historical withdrawn source: clarify a standalone valid target and check later literature before any proof project. The shared family setup would be approximately statement tier 2 and proof-transfer tier 3 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p20-polar-pairs).

### L-P20-linear-reduction

Does a linear-time reduction exist from finding a simplicial vertex in a general graph to finding the diameter of an AT-free graph?

**Formulation or historical hold:** Historical withdrawn source: clarify a standalone valid target and check later literature before any proof project. The shared family setup would be approximately statement tier 3 and proof-transfer tier 4 after a concrete target is chosen; these are not completion estimates for the current broad entry.

An algorithmic reduction needs explicit encodings and a cost model; its source is withdrawn, so this is a historical planning estimate only. Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p20-linear-reduction).

### L-P20-all-diametral

Find an efficient method to recover all diametral vertices of an AT-free graph, beyond finding one diametral pair.

**Formulation or historical hold:** Historical withdrawn source: clarify a standalone valid target and check later literature before any proof project. The shared family setup would be approximately statement tier 2 and proof-transfer tier 3 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p20-all-diametral).

### L-P20-Hamilton-color

Investigate the Hamiltonicity and coloring problems mentioned for AT-free graphs.

**Formulation or historical hold:** Historical withdrawn source: clarify a standalone valid target and check later literature before any proof project. The shared family setup would be approximately statement tier 2 and proof-transfer tier 3 after a concrete target is chosen; these are not completion estimates for the current broad entry.

Finite graphs and subgraph counts have usable foundations; saturation predicates, extremal functions and the target’s exact counting convention still need definitions.

First milestone: Define saturation and unlabelled copy counts, then certify a small construction.

Reuse cluster: finite graphs. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#l-p20-hamilton-color).
