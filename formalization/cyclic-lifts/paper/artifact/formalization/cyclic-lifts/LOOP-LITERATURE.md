# Literature comparison for the source question and decoding follow-ups

Checked October 23, 2026. This supplements the [earlier girth comparison](PRIOR-ART-AND-PROOF-COMPARISON.md)
and the [frozen-mechanism holdout report](LOOP-HOLDOUT.md). The primary question
here is **P34's cyclic lifted-product question**, not the separate P11 dyadic
forbidden-set question. We followed the source authors' publications, backward
references and topical searches in scholarly web results, arXiv and author or
institutional repositories. The [source ledger](search/loop-literature-review.json)
records locators, access levels and the exact-match search targets.

## The original question and its mathematical predecessors

Ragnar Freij-Hollanti, Kirsten D. Morris and Patricija Šapokaitė,
[*Graphical Analysis of Lifted Product Code Constructions*](https://arxiv.org/html/2606.11987v1#S5),
June 10, 2026, Section 5 after Theorem 5.1, explicitly describe it as
“an open question to analyze these $2\times 2$ submatrices”. The rest of the
sentence asks for sufficient conditions for maximum girth eight and their
effects on other graph properties relevant to decoding. Its
[arXiv history](https://arxiv.org/abs/2606.11987) still lists v1 in this check.
This is an open research question; the source does not formulate a named
conjecture asserting a particular iff theorem.

| Predecessor | Inspected result | Relation to our answer |
|---|---|---|
| Marc P. C. Fossorier, [*Quasi-Cyclic Low-Density Parity-Check Codes From Circulant Permutation Matrices*](https://www.josephboutros.org/ldpc_vs_turbo/ldpc_Fossorier_ITaug04.pdf), IEEE TIT 50(8), 1788–1793 (2004), Theorem 2.1 and equations (3)–(5) | Alternating exponent-sum conditions for short cycles in QC matrices. | Supplies the classical short-cycle tests. Our LP graph reduction, distinctness arguments and final iff assembly are separate steps. |
| Nithin Raveendran, David Declercq and Bane Vasić, [*On the Minimum Distances of Finite-Length Lifted Product Quantum LDPC Codes*](https://arxiv.org/html/2503.07567v1), March 10, 2025, Section III-B after (20) | Unavoidable LP eight-cycles via exponent cancellation. | Direct predecessor of our upper bound, already cited by P34. The inspected passage does not state the complete input-matrix iff. |
| Koki Okada and Kenta Kasai, [*High-Girth Regular Quantum LDPC Codes from Square-Base Hypergraph Products via CPM Lifts*](https://arxiv.org/html/2604.27817v3), Lemma 3, Theorem 5 and Corollary 6 | Short-cycle exclusion and eight-cycle results for square binary HGP inputs and constrained CPM lifts. | Closely related sufficient conditions and support arguments. Its hypotheses cannot be substituted for arbitrary fully populated rectangular exponent matrices. |

Our checked answer is that, for the stated monomial cyclic LP model with at
least two rows and columns, girth is eight exactly when all eligible rectangle
and hexagon sums are nonzero, equivalently with the recorded rectangle-pair
conditions. The prior comparison also examines Zhang's 2024 thesis,
Smarandache–Mitchell's matrix-product approach and other QC quantum families.
This follow-up found no additional inspected text giving the exact full
characterization. The defensible attribution remains a **Lean-verified answer
assembled from established cycle methods**, without an established priority claim.

Measured by publication year, Fossorier precedes P34 by 22 years, the 2025 LP
paper by one year, and the 2026 square-base work is from the same calendar year.
These are dates of related results under different hypotheses, not elapsed
durations for which the exact question is proved to have remained unsolved.

## Structural consequences, absorbing sets and design objectives

Emily McMillon, Allison Beemer and Christine A. Kelley,
[*Extremal absorbing sets in low-density parity-check codes*](https://doi.org/10.3934/amc.2021003),
AMC 17(2), 465–483 (2023 issue), supplies established bounds and extremal
absorbing-set context, already credited in our earlier structural analysis.
The publisher and institutional abstract were rechecked; this pass did not
obtain a new full-text copy. Our construction-specific bijection should not
be described as discovery of general girth-based absorbing-set bounds.

Christine Kelley, Deepak Sridhara, Jun Xu and Joachim Rosenthal,
[*Pseudocodeword Weights and Stopping Sets*](https://user.math.uzh.ch/kelley/isit2004_Chicago.pdf),
ISIT 2004, Theorem III.1 and its following note, give a girth/degree lower bound
also applying to stopping distance. At degree three and girth eight this is
$1+3+2=6$. Thus our Lean stopping-set bound has a direct classical numerical
predecessor; it is not a new bound or a soft-decoder guarantee.

Kirsten D. Morris, Tefjol Pllaha and Christine A. Kelley,
[*Absorbing Sets in Quantum LDPC Codes*](https://arxiv.org/html/2307.14532v2),
first posted July 26, 2023, revised May 10, 2024, later
[published in 2026](https://doi.org/10.3934/amc.2026023), Sections II-B, IV and V,
already distinguish syndrome failure from logical failure, analyze failure-inducing
sets and extend the symmetric-stabilizer framework. Its explicit algorithm is
Gallager-B syndrome decoding. Those results are important predecessors, but are
not automatic theorems about our integer normalized min-sum implementation.
Our even-flip parity lemma is elementary binary algebra; we do not claim that
parity preservation itself is new or that the two late oscillations are new
classes of absorbing sets.

Raveendran–Declercq–Vasić's 2025 paper, Section IV-D and Section V-A, equation
(92), compares LP designs with the same length, base dimensions and girth but
different quantum distances. It is a direct predecessor for design/performance
comparisons and a reason to control distance. Our latest intervention instead
holds the complete code fixed. Neither that distinction nor our paired sampling
isolates absorbing-set count: the merger changes check degrees and routing.
No universally superior objective or general error-floor predictor follows.

## Same code, different parity-check representation

| Primary source | Precedent | Difference from our experiment |
|---|---|---|
| Alex Rigby, J. C. Olivier and Peter Jarvis, [*Modified belief propagation decoders for quantum low-density parity-check codes*](https://arxiv.org/html/1903.07404v2), [Phys. Rev. A 100, 012330 (2019)](https://doi.org/10.1103/PhysRevA.100.012330), Section III.2.2, (58)–(61) | Reattempt BP on augmented matrices with duplicated checks; explains changed influence and feedback. | We replace two disjoint checks with their sum using the audited dependency, preserve the kernel and variable degrees, and keep a single fixed min-sum decoder. We do not propose augmentation or a retry decoder. |
| Sisi Miao, Alexander Schnerring, Haizheng Li and Laurent Schmalen, [*Neural Belief Propagation Decoding of Quantum LDPC Codes Using Overcomplete Check Matrices*](https://arxiv.org/html/2212.10245v2), first posted December 20, 2022; inspected March 21, 2023 revision, Section III | Adds low-weight linear combinations of checks; maps the syndrome linearly and gives an explicit original/overcomplete decoding example before the neural extension. | Representation-dependent quantum decoding, and a concrete same-code example, are already present. Our fixed-rule merger benchmark and Lean trajectory proofs are different artifacts. |
| Sheida Rabeti and Hessam Mahdavifar, [*Multiple-Bases Belief Propagation List Decoding for Quantum LDPC Codes*](https://arxiv.org/html/2605.14170v1), May 13, 2026, Sections II-C and III | Structured redundant representations, parallel BP trajectories and list selection. | A close quantum precedent for representation diversity. Our experiment compares two predetermined representations without list selection or changing the decoder. |

An especially relevant source-author lead is Morris, Pllaha and Kelley,
[*Effect of redundancy on syndrome-based decoding for QLDPC codes*](https://doi.org/10.1109/ISTC65386.2025.11154620),
ISTC 2025, pp. 1–5. Both
[Morris's publication list](https://kirstendmorris.github.io/publications/) and
[Pllaha's author bibliography](https://pllahat.github.io/) confirm it. The publisher
did not expose readable substantive text here and the author pages did not
provide an accessible manuscript. We credit this directly relevant earlier
study, but **do not assert what its specific theorem, transformation or numerical
result was**, or exclude an equivalent intervention on the basis of its title.
It is the first full-text acquisition target before a priority claim about our
merger experiment. No author was contacted.

There is, however, an accessible substantive source in our **original seed
collection**: Kirsten Morris,
[*Analysis of Graph-based Decoders for Quantum Low Density Parity Check Codes*](https://digitalcommons.unl.edu/dissunl/339/),
August 2025 dissertation. Chapter 5, Section 5.2, Table 5.1 (printed p.69;
[PDF p.81](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=81)),
already separates opposing syndrome and logical effects under Gallager-B:
one added-check representation has 8 failure-inducing absorbing sets rather
than 14, but 112 syndrome mismatches rather than 48, and 8 logical errors
rather than 40. These are its finite enumerated counts, not our FERs. Its
absorbing-set count is restricted to failure-inducing sets; ours counts all
four-variable absorbing sets. The two quantities are not interchangeable.
Chapter 6, printed p.74 ([PDF p.86](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=86)),
explicitly proposes extending redundancy studies to lifted and balanced
products. This directly connects the follow-up to the seed author's agenda.
It does not substitute for the unavailable conference text. Our LP merger
experiment partly investigates representation effects in that direction;
it does not settle the general redundancy question or disprove a theorem
that absorbing counts universally order min-sum performance.

Thus the general fact that algebraically equivalent representations can have
different iterative-decoding performance is prior art. The exact two codes,
mergers, error indices and reported counts were not matched to a prior inspected
source; that bounded observation does not establish their originality.

## Trajectories, symmetry, saturation and persistence

The update rule itself is credited to Nithin Raveendran, Javier Valls,
Asit Kumar Pradhan, Narayanan Rengaswamy, Francisco Garcia-Herrero and Bane Vasić,
[*Soft syndrome iterative decoding of quantum LDPC codes and hardware architectures*](https://link.springer.com/article/10.1140/epjqt/s40507-023-00201-1),
2023, Section 2.4, equations (2)–(4) and halting criterion. We use its
perfect-syndrome formulation with our frozen normalization and arithmetic,
not its proposed noisy-syndrome extension. Its simulations use normalization
0.75, whereas ours remains 0.8; the numerical results are not replications.

Nithin Raveendran and Bane Vasić,
[*Trapping Sets of Quantum LDPC Codes*](https://arxiv.org/html/2012.15297v2),
[Quantum 5, 562 (2021)](https://quantum-journal.org/papers/q-2021-10-14-562/),
Section 3.1, Definition 5 and Lemmas 1–2, already connect symmetric stabilizers,
symmetric parallel updates and decoder failure. Section 3.2 treats harmfulness
as decoder-dependent. This is the closest quantum conceptual predecessor for
symmetry-based trajectory obstructions. Our retained late pairs have unequal
soft values and synchronized sign changes, certified for a finite interval;
they are not established examples of that paper's equal-message symmetry.
The unsuccessful color-refinement screen does not refute its results.

Brian K. Butler and Paul H. Siegel,
[*Error Floor Approximation for LDPC Codes in the AWGN Channel*](https://cmrr-star.ucsd.edu/static/pubs/error_floor_approximation_ldpc_awgn.pdf),
IEEE TIT 60(12), 7416–7441 (2014), especially Sections II-C and III, use a linear
state-space trapping-set model with saturation and external-message input.
It is a direct predecessor for dynamical rather than purely combinatorial
analysis. Our interval enclosure proves finite rejection for the exact supplied
integer update model; it is not their probabilistic SPA/AWGN error-floor model
and does not inherit its predictions.

Xiaojie Zhang and Paul H. Siegel,
[*Quantized Iterative Message Passing Decoders with Low Error Floor for LDPC Codes*](https://cmrr-star.ucsd.edu/static/pubs/quantized_mp_ldpc.pdf),
IEEE Transactions on Communications 62(1), 1–14 (2014), Sections III–V, analyze
an idealized trapping-set setting and introduce quasi-uniform quantization.
This supplies prior credit for quantization and dynamic-range effects. Our
fixed integer arithmetic is not a new decoding method; keeping it fixed is a
control, and our certificates include its rounding and clipping.

Alessandro Tomasoni, Sandro Bellini and Marco Ferrari,
[*Thresholds of absorbing sets in Low-Density-Parity-Check codes*](https://arxiv.org/html/1401.8168v1),
January 31, 2014 preprint, Sections II, V and VI (Theorem VI.1), study a simplified
saturated elementary-absorbing-set min-sum model, including equilibria and limit
cycles, with conditions guaranteeing eventual escape. This is a particularly
close predecessor for the trapping approach. We do not instantiate its model
or threshold assumptions for our full syndrome graph; our 26-output tubes
establish finite rejection, not an infinite trap or a threshold theorem.

Marco Ferrari, Ramon Marenzi and Luca Barletta,
[*Message Flow Analysis in Practical LDPC Decoders for the Interpretation of Absorbing Set Thresholds*](https://re.public.polimi.it/handle/11311/1183661),
ISIT 2020, is an additional relevant lead. Its institutional abstract connects
thresholds to positive-feedback loops in the absorbing-set digraph. The full
text is restricted, so this is an **abstract-level comparison**, not a checked
proof match. The scaled-min-sum extension by Ferrari, Tomasoni, Marenzi and
Bellini, *Thresholds of Absorbing Sets Under Scaled Min-Sum LDPC Decoding*,
IEEE TCOM 67(10), 6643–6651 (2019), is also verified in the
[publisher's contents](https://www.comsoc.org/system/files/2019-11/Publications_Contents_Digest_2019_Oct.pdf).
Its full theorem text was not obtained; it remains a specific comparison gap.

These sources guide the next step: investigate external-message inequalities
and feedback paths governing entry and escape. That is a proposed direction,
not a result transferred to our setting. Our max-norm expansion witness rules
out one global one-step contraction argument, not these more specific models.

## What we can claim after this review

- **Source question:** a checked sufficient-and-necessary girth criterion for the
  stated LP model, with established cycle methods credited. Broader decoding
  consequences remain partly answered.
- **Follow-ups:** a fixed-code paired experiment, exact merger identities,
  sound interval propagation and two complete Lean-checked finite stopping
  comparisons. Representation effects, trapping dynamics, symmetry mechanisms
  and saturation sensitivity already have substantial prior literature.
- **Scope:** no first discovery of those general phenomena, no isolated causal
  effect of absorbing counts, no universal design objective, and no proof of
  an asymptotic error floor. A failure probability at one channel parameter
  and a 100-iteration cutoff does not establish such a floor.
- **Formalization:** no claim to the first Lean quantum-decoding artifact. A
  discovered [qldpc-cert package record](https://pypi.org/project/qldpc-cert/0.1.0/)
  describes Lean-checked syndrome/logical-outcome certificates for BB codes.
  Its linked repository was inaccessible here; no proof audit or academic
  publication status is inferred from the package's description.

No inspected primary text was identified as containing our exact two
from-prior comparisons or this exact interval certificate implementation.
The full-text gaps above prevent a definitive priority conclusion. They do
not alter the kernel-checked proofs or the measured experiment.

The research snapshot and its original hash manifest remain at
[`888beeb`](https://github.com/alectionary/vibe-math/commit/888beebab4153230f65a03970a5a51bcd68da51d).
This literature-only revision changes attribution and documentation, not the
frozen detectors, input codes, decoder, samples, numerical results or Lean proofs.
