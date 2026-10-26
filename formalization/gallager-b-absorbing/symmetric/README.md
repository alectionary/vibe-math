# Odd-support obstruction and the remaining symmetric-CSS question

The odd-support restriction is impossible: when the entire binary X- and Z-stabilizer row spaces agree, every odd-weight zero-syndrome word is a nontrivial logical operator. No deterministic syndrome-only decoder can correct both it and the identity. Consequently it cannot correct every error on an odd-cardinality (a,0) absorbing support.

This completes steps (1) and (2): the general proof and paper, and a precise screened formulation of the remaining question. **Even-support existence is unresolved. No even-support construction search was performed.**

- [Paper PDF](paper/main.pdf), [LaTeX](paper/main.tex), [complete proof appendix](paper/supplement.tex).
- [General proof](OddSupport.lean), [exact questions and first stopping](Question.lean), [fixed controls](Consumers.lean), [all-declaration axiom audit](Audit.lean).
- [Immutable checked proof](https://github.com/alectionary/vibe-math/blob/d4c02e802f12e3583309d6b38f6e818524b4333c/formalization/gallager-b-absorbing/symmetric/OddSupport.lean).
- [Build/dependency manifest](verification.json), [independent replay](verify.py), [literal inputs](verification-inputs.json), [certificate](certificate.json).
- [Primary-source comparison and search limits](prior-art.json), [question harvest](../../../literature/symmetric-css-source-screening.json).
- [Tracking issue #2](https://github.com/alectionary/vibe-math/issues/2); canonical parent L-P09-all-absorbing, project-derived follow-up RQ-P09-symmetric-css.

## Exact theorem and boundaries

Finite binary physical coordinates and arbitrary finite actual check lists are used. CSS means every X row is orthogonal to every Z row. Equality means equality of the **full row spaces**, not merely a coordinate permutation exchanging them. Every stabilizer in the common space has even weight because w·w = weight(w) modulo two. Thus an odd zero-syndrome word is outside the stabilizer space. Both it and identity have the same syndrome, so any shared correction fails on at least one.

The proof bridges actual induced check degree to dot parity, b=0 to zero syndrome, and success to membership in the entire actual opposite stabilizer space. It needs no connectivity, degree, dimension or strict-majority absorption premise beyond zero syndrome and oddness. It proves quantum logical failure, not persistent dynamical trapping.

The six-coordinate permutation-only consumer and the two-coordinate even stabilizer guard show why the two hypotheses matter. The seven-coordinate common-matrix simplex is a logical-failure control. Equal spaces may have different actual generating lists; replacing the opposite list by the existing decoding list preserves the stabilizer space and chosen Z decoder. Common-matrix component recovery implies Pauli recovery when the same rule is applied separately to the two components; a previously different opposite-sector decoder is not asserted unchanged.

## Frozen remaining question

`Question.FullQuestion` asks for a finite common check list H with HHᵀ=0 and a nonempty proper (a,0) support A. Actual check rows must be distinct (linear redundancy allowed), the full Tanner graph connected, a pair of logical words must anticommute, and every nontrivial physical cut must violate closure of the binary stabilizer space under coordinate restriction. There is no prescribed girth, minimum degree, distance or asymptotic LDPC family condition.

Decoder: zero-initialized variable-to-check messages, syndrome XOR other incoming messages at checks, strict majority at variables (zero on ties), extrinsic variable updates excluding the recipient check. Hard output uses all incoming check messages. Stop at initialization for zero syndrome; otherwise return the hard output at the first hard-syndrome match, or at the first outgoing-edge-parity match, in two separately stopped runs. **Every supported error must stop finitely and succeed modulo the entire common span under each run.**

`FullQuestion ↔ EvenFullQuestion` is proved. Any supported zero-syndrome word must be a stabilizer; this is a stronger necessary filter than the parity of A alone. `OneStepQuestion` is the additional benchmark requiring initialization/one-iteration success under both tests. Only `OneStepQuestion → FullQuestion` is proved. Failure to find a benchmark witness would not settle the full question.

Both-sector recovery with the common decoder follows componentwise; it need not be treated as an independent construction search. Permutation-only CSS symmetry and the source's graph-partition “symmetric stabilizers” are different questions.

## Evidence and source comparison

Lean 4.36.0-rc1 cleanly checks all **76 theorems** in the entire four-module research import closure, importing only Std. All declaration dependencies are among propext, Classical.choice and Quot.sound. The independent verifier examines nine fixed semantic families, 167 words in seven equal-space controls, 13 odd zero-syndrome cases and all 1,058 possible shared outputs for those cases. It does not search code constructions.

The parity argument is an ordinary self-orthogonality consequence. Bravyi–Leemhuis–Terhal (2010), Section3, defines the same equal-space CSS class. Their general code conversion controls parameters/locality; preservation of the selected support and exact Gallager-B recovery remains an unestablished bridge here. Haah–Hastings–Poulin–Wecker (2017), Section3, supplies the classical quotient-form setting; its normal/hyperbolic classes do not concern support-cardinality parity. P09 v2 Theorem5 already distinguishes logical/degenerate zero-syndrome errors in an induced code. Our success criterion uses the full opposite ambient stabilizer space, which cannot silently be replaced by that induced row space.

The accessible P09 v2 and public final-journal introduction were checked; final full text still requires subscription/login/payment. Authenticated X search was unavailable. Public-code searches had caps and false positives. Bounded comparisons do not establish historical priority or global current openness. Two full primary papers contribute seven historical directions/held formulations, all excluded from the precise-target denominator with modern resolution and Lean discovery unassessed. No additional completed canonical source target is counted.

The [original counterexample](../README.md) and [connected asymmetric construction](../connected/README.md) remain complete and their frozen sources/manifests are preserved.

## Reproduce

Use Python ≥3.10 and the pinned Lean toolchain:

```sh
python3 verify.py --check
python3 build.py --lean /path/to/lean
python3 paper/make_paper.py --tectonic /path/to/tectonic
```

`build.py` builds every module in a fresh temporary directory and checks every theorem's dependency report. The publication manifest hashes the PDF, complete source archive, proof files and records. The paper appendix prints every new proof module, with current and immutable declaration links. No downloaded third-party full text is redistributed.

**Question answered:** odd-cardinality zero-syndrome supports cannot have universal syndrome-only quantum recovery in equal-space binary CSS codes.

**Question still open:** existence or nonexistence of the precise even-support connected/coupled example, with both separately stopped tests.

**Next proposed target (follow-up):** apply the supported-zero-syndrome stabilizer filter, then undertake a bounded even-support construction campaign if separately authorized.
