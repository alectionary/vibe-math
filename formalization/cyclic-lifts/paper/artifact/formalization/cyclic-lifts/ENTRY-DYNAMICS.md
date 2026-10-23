# Entry into representation-dependent decoding trajectories

October 23, 2026. Follow-up to the [bounded persistence study](LOOP-HOLDOUT.md).

The originating research program is Ragnar Freij-Hollanti, Kirsten D. Morris
and Patricija Šapokaitė's [*Graphical Analysis of Lifted Product Code
Constructions*](https://arxiv.org/html/2606.11987v1#S5), 2026, Section 5. Its
open question asks for conditions on the input submatrices giving girth eight
and consequences for decoding-related graph properties. Our checked girth
answer and this still-partial decoding follow-up are distinct parts of that
program; the source did not state a named conjecture asserting a particular
decoder-performance ordering.

**The aggregate failure gap is still not fully explained.** This continuation
does identify the onset and propagation of the representation perturbation,
proves two complete examples in Lean, and tests an initial-state hypothesis on
another million fresh paired errors per code. The strongest statistical finding
weakens after controlling baseline error hardness. It is evidence about where
to look next, not a certificate explaining every additional failure.

The codes, channel and decoder are unchanged: the two labeled
`[[252,10,10]]` CSS codes, the predetermined degree/girth-preserving check
mergers, independent Bernoulli Z errors at `p=0.04`, perfect syndrome,
flooding normalized min-sum with normalization `0.8`, 20 fractional bits,
clipping at ±50, and first syndrome match or 100 updates. A recovery is quantum
successful exactly when its residual lies in the full unchanged Z-stabilizer
span. The change in parity-check representation remains the intervention;
absorbing-set count is not independently manipulated.

## What changed relative to the previous gap

The preceding independent sample had **721 and 986 net additional syndrome
failures**. The frozen pinned-check certificate's descriptive net counts were
only **1 and 86**. Exact recurrence and the prescribed rejecting invariant-box
search produced no certificates. The broader finite tube starts late and
certifies persistence, not entry. All of those findings remain in the record.

This continuation changes the question from “what late state persists?” to
“when and how do the two representations begin to generate different soft
states?” Three distinctions matter:

1. Immediate internal-message divergence has an exact initial-syndrome criterion.
2. Internal divergence can exist while the entire first hard-decision word agrees.
3. Immediate divergence is neither necessary nor sufficient for eventual extra
   syndrome failure.

The new confirmation sample has **985 and 1,210 net additional syndrome
failures**. These are different error streams, not revisions of 721 and 986.
Samples are not pooled and the earlier certificates are not retrained.

## Exact onset and possible propagation

Let `A,B` be the two disjoint weight-six source checks replaced by their sum,
and `s_A,s_B` their original target-syndrome bits. At the uniform prior the first
check-to-variable message has magnitude **2,665,945 integer units**. Under the
physical-edge correspondence:

- all first messages agree if and only if `(s_A OR s_B) = 0`;
- one odd source bit reverses six source-edge messages; two odd bits reverse
  twelve;
- the associated first extrinsic perturbation has magnitude **5,331,890** on
  the affected off-source coordinates;
- when both bits are zero, the entire first extrinsic state also agrees.

With these fixed magnitudes, a first hard bit is one exactly when **all three
incident target-syndrome bits are odd**. Replacing a source bit by `s_A XOR s_B`
can change that decision only when the other two incident check bits are odd.
Even when they are not, the changed source message still changes internal
extrinsic values sent onward. This is the concrete route into a different soft
state while the hard word remains unchanged.

For arbitrary incoming messages, the original and mapped merged update maps
can differ directly on only **24 of 756 extrinsic coordinates**. The rest of
the difference must be inherited from incoming states. This statement compares
the two maps at the *same* incoming state; actual trajectories generally have
different states after entry.

Lean checks this locality statement for both actual graph operators, and a
generic induction confines trajectory differences to the resulting dependency
cone. It also checks these concrete cone sizes:

| Update | Previous best | Minimum 4 |
|---|---:|---:|
| 1 | 24 | 24 |
| 2 | 264 | 264 |
| 3 | 729 | 734 |
| 4 | 756 | 756 |

Thus a local representation change has possible influence across the full
message graph after four updates. These are **possible-influence bounds**, not
claims that all those messages actually differ or that their differences cause
failure. Locality alone becomes uninformative about failure once the cone fills.

## A calculable first-step disadvantage

Compare residual syndrome weights in the **same original 126 check coordinates**
in both arms. This avoids confusing 125 versus 126 checks with better decoding.
An exact rational calculation under independent Bernoulli errors gives, for
either code,

`E[first residual syndrome weight: merged − original] = 0.18781543220550587`.

| Initial source bits | Probability | Conditional expected weight difference |
|---|---:|---:|
| 00 | 0.6450940976 | 0 |
| 01 | 0.1580834031 | +0.2092138113 |
| 10 | 0.1580834031 | +0.2092138113 |
| 11 | 0.0387390962 | +3.1407281397 |

The calculation expands Boolean functions into parity characters and uses
`E[(-1)^(parity on S)] = (1−2p)^|S|`. An independent implementation convolves
physical-bit contributions directly over at most 15 joint syndrome coordinates.
It reproduces all **208 affected-check/stratum expectations** exactly. This
whole syndrome-weight calculation is independently checked finite computation,
**not a fully Lean-formalized expectation theorem**.

Lean does prove the finite Bernoulli parity law, the correlated triple-odd
formula, and its instantiation at each of the twelve actual first-decision
gates per code. The XOR-support sizes are 6,6,6; 12,12,10; and 16. Each gate's
exact probability is

`253967631598958030208 / 23283064365386962890625 ≈ 0.01090782672`.

Their sum is **0.1308939206 expected changed first hard bits**. Linearity of
expectation does not require the twelve events to be independent. The
probability library here is an explicit finite weighted sum, linked to the
actual row geometry and the checked first-decision rule; it is not a verified
random-number generator or a proof about eventual decoder failure.

There is also an exact **raw bit-error** disadvantage. At a source vertex, the
change in its first-decision error indicator is

`(−1)^(physical bit XOR own-source syndrome) × 1[opposite-source syndrome and both common-check syndromes are odd]`.

Removing that physical bit from the own-source parity leaves five independent
error bits whose support is disjoint from all three gate rows. Consequently the
expected signed change per gate is its probability times `(23/25)^5`, namely
**0.007189147049**, giving **0.086269764590 expected additional wrong bits**
across twelve vertices. Conditional on a gate changing its bit, its probability
of making the bit worse is **0.8295407616**, rather than one. An independent
physical-bit convolution checks all 24 source-vertex calculations in
[the exact bit-bias record](search/entry-bit-bias.json).

Lean checks the scalar decision/error identity, a general signed-gate moment
formula, and the eight actual XOR-support sizes for every source vertex: 5,
11,11,11,17,17,15,21. It then proves the exact signed rational moment. The
full decoder-decision-to-character-expectation bridge remains a written and
computational bridge; the signed-moment theorem alone should not be advertised
as a fully formalized decoder FER theorem. Raw bit errors are also distinct
from quantum recovery modulo stabilizers.

## New independent confirmation

The [protocol](ENTRY-CONFIRM-PROTOCOL.md) and
[implementation hashes](search/entry-confirm-selection.json) were frozen before
generating **1,000,000 new paired errors per code**, with independent streams
between codes and the same error within each representation pair. Seeds are
`90316268021` and `90316268022`: two million new physical errors and four
million primary decodes. The preceding samples informed the hypothesis and
are development evidence for this test.

Write `D = merged syndrome-failure indicator − original indicator`. The two
primary estimands were `E[D | source active] − E[D | source inactive]`, where
active means at least one source bit is odd. Both predictions replicate:

| Code | Active effect | Inactive effect | Interaction | Simultaneous 95% interval |
|---|---:|---:|---:|---:|
| Previous best | +0.2152 pp | +0.0344 pp | **+0.1808 pp** | [+0.1093, +0.2523] pp |
| Minimum 4 | +0.2668 pp | +0.0406 pp | **+0.2262 pp** | [+0.1550, +0.2973] pp |

Intervals use the paired variance within disjoint strata and a Bonferroni
correction for the two prespecified interactions. They are normal-approximation
simultaneous intervals. Source activity is a baseline covariate, not a randomized
intervention; this is heterogeneity of the representation effect.

A secondary robustness check uses Maurer and Pontil's
[*Empirical Bernstein Bounds and Sample Variance Penalization*](https://www.learningtheory.org/colt2009/papers/012.pdf),
2009, Theorem 4. Applying it to `(D+1)/2`, with a union bound over the eight
code/stratum/tail events, gives finite-sample simultaneous 95% interaction
intervals **[+0.0199,+0.3418] pp** and **[+0.0661,+0.3862] pp**. This avoids a
normal approximation for the raw interactions. The [calculation](search/entry-bernstein.json)
uses the same fixed data and estimands; it is a secondary check, not an
additional experiment, a Lean probability proof or a remedy for baseline
hardness differences.

| Code | Original / merged syndrome failures | Net syndrome change | Original / merged logical failures | Original / merged total quantum failures |
|---|---:|---:|---:|---:|
| Previous best | 27,096 / 28,081 | +985 | 443 / 436 | 27,539 / 28,517 |
| Minimum 4 | 25,516 / 26,726 | +1,210 | 320 / 308 | 25,836 / 27,034 |

The complete four-stratum counts, paired losses and gains, first-step means,
and packed outcomes are in [the results](search/entry-confirm-results.json).
Observed overall first-weight gaps are **0.186054 and 0.187275**, consistent
with the exact expectation. The expectation is for an early diagnostic, not
for these final failure counts.

## Baseline hardness limits the explanation

An exploratory secondary analysis standardizes the activity contrast within
cells of total physical-error weight and original initial syndrome weight.
It retains error weights 5 through 16 and cells containing at least 100 errors
of each activity class, about **94.5%** of each sample. The weights are empirical;
nominal intervals condition on those weights and cells. This is neither a
prespecified mediation analysis nor exhaustive adjustment for error geometry.

| Sample | Code | Standardized activity interaction | Nominal conditional 95% interval |
|---|---|---:|---:|
| Old development | Previous best | +0.0281 pp | [−0.0304, +0.0867] pp |
| Old development | Minimum 4 | +0.0230 pp | [−0.0356, +0.0815] pp |
| New confirmation | Previous best | **+0.0579 pp** | **[−0.0013, +0.1171] pp** |
| New confirmation | Minimum 4 | **+0.0836 pp** | **[+0.0249, +0.1424] pp** |

The raw interaction attenuates substantially, and the adjusted interval for
Previous best includes zero. Initial source activity helps locate message
entry; these data do not establish that it explains the final penalty beyond
baseline hardness. No claim of “closing the aggregate explanation” follows.

## Soft-state entry accounts for a substantial descriptive partition

Partition the new sample using initial source activity, equality of the entire
first hard word, and (if different) the first residual syndrome-weight ordering.
A lost syndrome match contributes +1 and a gained match contributes −1.

| First-step category | Previous best losses / gains | Net | Minimum 4 losses / gains | Net |
|---|---:|---:|---:|---:|
| Inactive: complete first extrinsic state agrees | 6,003 / 5,781 | +222 | 5,862 / 5,600 | +262 |
| **Active, but complete first hard word agrees** | **3,210 / 2,759** | **+451** | **3,279 / 2,708** | **+571** |
| Hard words differ; merged first syndrome weight worse | 1,309 / 958 | +351 | 1,350 / 977 | +373 |
| Hard words differ; merged first syndrome weight better | 392 / 472 | −80 | 384 / 414 | −30 |
| Hard words differ; first syndrome weights equal | 87 / 46 | +41 | 81 / 47 | +34 |
| **Total** | **11,001 / 10,016** | **+985** | **10,956 / 9,746** | **+1,210** |

The soft-only category contains **451/985 (45.8%)** and **571/1,210 (47.2%)** of
the net excess descriptively. These exhaustive categories do not overlap; they
are not additive causal pathways. In particular, the 451 and 571 are **not new
failure certificates** and do not replace the pinned-check coverage numbers.
The classifier measures a post-intervention state, so conditioning on it is
not an independently controlled intervention on soft messages.

This category shows why looking only at the first hard errors or syndrome
weight misses much of the representation effect. Its precise aggregate
mechanism is still unresolved.

A further **post hoc** check compares soft-only with inactive errors within
the same physical-error-weight/initial-syndrome-weight cells. In the new sample,
the standardized contrasts are **+0.0630 pp [−0.0004,+0.1265]** for Previous best
and **+0.1120 pp [+0.0487,+0.1753]** for Minimum 4. Both old-development intervals
include zero. Each calculation retains about 859,000 pairs, applies the same
100-per-category cell minimum and weight-5-through-16 restriction, and uses
nominal conditional plug-in intervals. The [complete control record](search/entry-soft-controls.json)
is independently reconstructed from all four million feature rows, with exact
rational arithmetic for the conditional mean and variance checks. This
post-update, data-selected comparison has no confirmatory or causal-mediation
interpretation. It reinforces the mixed baseline-control evidence rather than
turning the 451/571 net counts into an aggregate explanation.

## Two complete Lean examples distinguish entry from persistence

The first is existing retained error **1804** for Previous best. The source is
active; every first hard decision agrees, but a first extrinsic coordinate
differs. An off-source posterior later crosses zero through inherited message
differences. The original recovers the exact error for the first time at update
**65**, while the merged decoder fails to match the syndrome through update
**100**. The theorem
`CyclicDecoderEntryExamples.Previous.soft_only_entry_to_fixed_budget_failure`
joins the initial soft-only difference to the complete checked stopping result.

The second is retained error **2435** for Minimum 4. Both initial source bits
are zero and the entire first extrinsic state agrees. Nevertheless, the
original first recovers the exact error at **86** and the merged decoder rejects
through **100**. The theorem
`CyclicDecoderEntryExamples.Minimum.delayed_entry_to_fixed_budget_failure`
therefore disproves necessity of immediate source activity for such a loss.

For error 2435 we can explain **the first delayed activation itself**, rather
than only show that activation eventually occurs. After the first update, the
extrinsic message from physical vertex **196** toward source check **42** is
**−1,999,459**. The second update of original check **119**, toward vertex **35**,
sees five positive inputs with minimum **3,332,431**, giving **+2,665,945**.
The merged check sees eleven inputs, including that one negative foreign input;
its sign reverses and its smaller minimum gives **−1,599,567**. The incoming
states still agree under the physical-edge map. Thus the rule change, not an
already different incoming state, causes this second-update message difference.

[CyclicDecoderEntryDelayed](../dyadic-rank/CyclicDecoderEntryDelayed.lean) checks
the foreign message's location, its membership only in the merged witness's
input list, both full excluded-edge input lists, both resulting signed outputs,
equality of the second hard words, and that **exactly the six outputs of
original check 119 differ at update 2**. It joins this local pathway to the same
complete 86-versus-100 stopping comparison. The [prefix record](search/entry-delayed-entry.json)
additionally measures the first hard divergence at update **5**; that onset is
a computational check, not an additional universal Lean theorem. This is a concrete early
cross-half sign contamination mechanism, consistent with the previously proved
[merger identity](MERGED-MECHANISM.md), not a new general class of traps or proof that this single
message mediates the final failure.

These extend the already proved full-from-prior comparisons. They prove that
these entry patterns and final outcomes coexist in the *same actual errors*;
they do not prove that the selected early coordinate alone causes the later
failure. The off-source sign-crossing examples locally improve the raw bit in
the merged trajectory, so even a propagated crossing cannot automatically be
labeled harmful. Decoder behavior depends on the coupled state.
The two full stopping examples have physical-error weights **18 and 19**,
outside the 5–16 range used in the secondary baseline controls. They establish
possibility and exact mechanisms in selected heavier errors; they are not
representative proofs for the bulk of the channel distribution.

## Negative and limiting results

- A rule selected on old trajectories uses the sign of the paired syndrome-weight
  gap at update 10. On the earlier independent holdout it has only **54.11% and
  54.16% balanced direction concordance**, counting ties as half-correct, among
  syndrome-discordant pairs with both trajectories still active after update
  10. This was a secondary analysis of a previously inspected holdout, not an
  untouched confirmatory test. It is not accuracy on the full population or a
  strong explanation.
- At that checkpoint, inherited message-difference L1 norms are roughly
  **20–21 times** the direct same-incoming-state forcing norms, in both loss
  and gain groups. This supports studying feedback, but the norms are not
  additive causal effects and do not distinguish failure well.
- Exhaustively testing the **36** supports with one error in each source check,
  and the **8,640** supports with one error per source plus a third outside
  their union, gives **success in both arms for every support, for both codes**.
  These are 17,352 small-support test inputs and 34,704 decodes, not Bernoulli
  trials or an enumeration of every weight-three support. Even an immediate
  first-step disadvantage can repair within two or three updates. Initial
  activation is not sufficient for failure.

The last limitation now also has two complete Lean checks. For the crossing
supports **{0,33}** (Previous best) and **{0,35}** (Minimum 4), both source bits
are odd. The original first recovers the exact error at update **1**; the merged
decoder rejects at update 1 and first recovers it at **2**. The two
`CyclicDecoderEntryRepair.*.repaired_despite_immediate_pulse` theorems use the
actual graph updates and the same first-match semantics. This is a formal
counterexample to treating the immediate pulse as sufficient for failure,
not a disproof of the source paper's open research question.

## Prior research and relation to the source program

The [dated literature comparison](LOOP-LITERATURE.md) remains the main source
ledger. A targeted follow-up search for transient min-sum dynamics,
source-author redundancy work and absorbing-set message flow did not add an
inspected exact match to these two examples. Relevant substantive predecessors
include:

- Raveendran, Valls, Pradhan, Rengaswamy, Garcia-Herrero and Vasić,
  [*Soft syndrome iterative decoding of quantum LDPC codes and hardware architectures*](https://link.springer.com/article/10.1140/epjqt/s40507-023-00201-1),
  2023, Section 2.4: the published syndrome min-sum equations and stopping rule.
  Our frozen normalization and integer arithmetic are controls, not a new decoder.

- Rigby, Olivier and Jarvis, [*Modified belief propagation decoders for quantum
  low-density parity-check codes*](https://arxiv.org/html/1903.07404v2), 2019,
  Section III.2.2: changing check representation changes influence and feedback.
- Raveendran and Vasić, [*Trapping Sets of Quantum LDPC Codes*](https://quantum-journal.org/papers/q-2021-10-14-562/),
  2021: decoder-dependent harmfulness and symmetric message-passing failures.
- Butler and Siegel, [*Error Floor Approximation for LDPC Codes in the AWGN
  Channel*](https://cmrr-star.ucsd.edu/static/pubs/error_floor_approximation_ldpc_awgn.pdf),
  2014, Sections II-C and III: external-message input and dynamical feedback in
  trapping-set models.
- Tomasoni, Bellini and Ferrari, [*Thresholds of absorbing sets in Low-Density-
  Parity-Check codes*](https://arxiv.org/html/1401.8168v1), 2014: entry/escape,
  equilibria and limit cycles in a simplified saturated min-sum model.
- Ferrari, Marenzi and Barletta, [*Message Flow Analysis in Practical LDPC
  Decoders for the Interpretation of Absorbing Set Thresholds*](https://re.public.polimi.it/handle/11311/1183661),
  2020: the accessible institutional abstract explicitly relates thresholds to
  positive-feedback message loops. This remains an **abstract-level** comparison.
- Kirsten Morris, [*Analysis of Graph-based Decoders for Quantum Low Density
  Parity Check Codes*](https://digitalcommons.unl.edu/dissunl/339/), 2025,
  Chapters 5–6: redundancy, opposing syndrome/logical effects and extension to
  lifted products. Morris, Pllaha and Kelley's 2025 conference paper on redundancy
  remains a credited full-text acquisition target, not an assumed proof match.

Representation effects and feedback analysis are established research themes.
The contribution here is the fixed-code controlled evidence, exact onset and
probability calculations, and checked construction-specific examples. This
does not change the status of the original P34 question: the girth conditions
are answered for the stated model; the decoding-consequence program remains
partly answered. This follow-up completes **no additional inventory target**.

## Proof and verification guide

| Lean module | Main checked content |
|---|---|
| [CyclicDecoderEntry](../dyadic-rank/CyclicDecoderEntry.lean) | Generic locality induction, direct/inherited posterior decomposition, margin tests, first-pulse arithmetic and decoder-local dependence |
| [CyclicDecoderEntryBridge](../dyadic-rank/CyclicDecoderEntryBridge.lean) | Both actual graphs: initial divergence iff source activity, inactive first-state equality, same-state forcing support, trajectory confinement |
| [CyclicDecoderEntryCone](../dyadic-rank/CyclicDecoderEntryCone.lean) | Actual dependency-cone recurrences and counts through full reach at update 4 |
| [CyclicDecoderEntryChannel](../dyadic-rank/CyclicDecoderEntryChannel.lean) | Finite Bernoulli parity and correlated triple-odd laws |
| [CyclicDecoderEntryInitial](../dyadic-rank/CyclicDecoderEntryInitial.lean) | Actual twelve-gate row geometry per code and exact gate probabilities |
| [CyclicDecoderEntryWitnesses](../dyadic-rank/CyclicDecoderEntryWitnesses.lean) | Physical-edge maps and inherited off-source posterior crossings |
| [CyclicDecoderEntryExamples](../dyadic-rank/CyclicDecoderEntryExamples.lean) | Soft-only and delayed-entry examples joined to complete 100-update stopping comparisons |
| [CyclicDecoderEntryRepair](../dyadic-rank/CyclicDecoderEntryRepair.lean) | Two double-odd source errors correct in 1 versus 2 updates; initial perturbation is not sufficient for failure |
| [CyclicDecoderEntryBias](../dyadic-rank/CyclicDecoderEntryBias.lean) | Scalar raw-error gate identity, generic signed-gate moment and actual row-support instantiations |
| [CyclicDecoderEntryDelayed](../dyadic-rank/CyclicDecoderEntryDelayed.lean) | Exact second-update cross-half sign reversal, despite identical incoming states and second hard words, joined to the complete failure example |
| [CyclicDecoderEntryAudit](../dyadic-rank/CyclicDecoderEntryAudit.lean) | Principal theorem axiom audit |

The dependency path is generic dynamics → actual graph bridge → cone and full
examples; the independent probability path is finite parity laws → actual row
geometry → gate probabilities. The full examples reuse the existing checked
prefixes and finite rejection tubes. Source tables and edge maps are explicit
and independently round-tripped. Proofs use kernel reduction, without admitted
lemmas, additional axioms or native-decision shortcuts. The printed axiom audit
contains only Lean's standard logical axioms.

The trusted mathematical specification is distinct from C++ execution and
sampling. Lean starts from the fixed integer prior **3,332,431**; its connection
to the channel log-likelihood and rounding is computationally checked, rather
than proved using real logarithms in Lean. All two million new errors are
regenerated and hashed; all four million primary outcome classes and stopping
iterations are additionally replayed with the unmodified stock decoder and an
independently implemented stabilizer-span scorer. Forty-eight
retained complete histories are independently replayed with direct Python
message equations and the stock decoder. The analytical first-syndrome weights
are checked against every newly instrumented run; complete first-word controls
are checked on retained examples, rather than independently replaying every
first hard word. Four million old/new feature
rows are joined to their original endpoint records. No new random data are
needed for these validators.

Useful evidence and commands from the repository root:

```sh
python3 -B scripts/validate_cyclic_entry_dynamics.py
python3 -B scripts/validate_cyclic_entry_expectation.py
python3 -B scripts/validate_cyclic_entry_confirm.py
python3 -B scripts/validate_cyclic_entry_progress.py
python3 -B scripts/replay_cyclic_entry_stock.py
python3 -B formalization/cyclic-lifts/search/entry_delayed_entry.py --verify
python3 -B scripts/check_cyclic_entry_lean.py
python3 -B scripts/verify_cyclic_entry_artifacts.py
```

The [fresh experiment runner](search/entry_confirm.py) refuses to overwrite
its existing frozen selection. Its protocol, seeds, packed results and hashes
preserve the original run. The stock replay and validators reproduce the
checks, not a new holdout selection.

- [Exact first-round calculation](search/entry-first-round.json) and
  [independent convolution validation](search/entry-expectation-validation.json)
- [Exact first-bit error calculation](search/entry-bit-bias.json) and
  [physical-bit convolution implementation](search/entry_bit_bias.py)
- [New confirmation](search/entry-confirm-results.json) and
  [independent sample/trajectory checks](search/entry-confirm-validation.json)
- [Secondary controls and exhaustive partition](search/entry-progress-results.json)
  and [independent validation](search/entry-progress-validation.json)
- [Small-support counterchecks](search/entry-small-supports.json)
- [Dependency-cone ledger](search/entry-dependency-cones.json)
- [Full stock-decoder replay](search/entry-stock-replay-validation.json)
- [Lean build results](search/entry-lean-build-results.json) and
  [principal axiom report](entry-final-axioms.log)
- [Artifact verification manifest](entry-verification.json)

## What remains and the next bounded question

We can now explain exactly why the first internal states diverge, how that
perturbation can propagate, and how two actual errors proceed from the prior to
different final outcomes. We cannot yet derive the aggregate excess from those
entry conditions. The soft-only partition locates much of the descriptive net
effect, while baseline controls show why a simple source-activity explanation
is inadequate.

The next focused question is whether a small **relational soft-message state**
can distinguish escape from rejection in the soft-only cohort, after matching
baseline hardness, and be certified from an early update. It should be developed
on existing data, frozen, and tested before another large sample. Counting late
persistence certificates or merely increasing sample size would not resolve
this missing entry-to-failure implication.
