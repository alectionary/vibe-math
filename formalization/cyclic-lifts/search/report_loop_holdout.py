"""Report frozen development/holdout evidence with explicit proof boundaries."""
from pathlib import Path
import json
HERE=Path(__file__).resolve().parent
LABEL={'previous_best':'Previous best','minimum_4':'Minimum 4'}

def run():
 fresh=json.loads((HERE/'loop-holdout-results.json').read_text());old=json.loads((HERE/'loop-development-full-results.json').read_text())
 lines=['''# Persistence certificates for cyclic lifted-product CSS decoding: frozen mechanisms and a fresh holdout

We developed three candidate mechanisms on the existing trajectories, froze
all detector definitions and scientific inputs, then evaluated **1,000,000
fresh paired errors per code**: 2,000,000 independent patterns and 4,000,000
primary decoder runs. This extends the [message-coupling study](MERGED-MECHANISM.md)
and [preceding experiment](MERGED-MILLION.md), without pooling samples.
The two streams are independent across codes; each
original/merged pair shares its error. Both exact [[252,10,10]] cyclic lifted-product CSS LDPC codes,
p=0.04 one-sector Z channel, perfect syndrome, flooding normalized min-sum decoder, integer arithmetic,
clipping and stopping rule remain fixed.

**The infinite-trap candidates found no certificates. The finite-horizon
candidate certifies a subset of syndrome failures, but does not close the
structural or causal explanation gap.** It starts at iteration 75 and permits
only one integer unit (2^-20 LLR) of independent perturbation per incoming
message. A broader variant certifies rejection with changing checks; that is
late-state verification, not an early failure predictor.

## What was developed and frozen

1. **Exact recurrence:** equality of all 756 incoming integer messages at two
   recorded iterations, plus rejection of every intervening output. Hashes
   are merely an index; full vector equality is checked. A certified fixed
   point or periodic orbit would reject forever under the same mathematical
   update. No such recurrence was detected within the recorded horizon.
2. **Rejecting invariant box:** a hull of the last eight input states, enlarged
   by at most 32 sound interval passes, with one uniformly wrong check. No
   rejecting invariant box was certified by this procedure. This does not
   exclude other invariant regions or cycles with periods exceeding the run.
3. **Remaining-horizon tube:** independent ±1 integer perturbations of the
   iteration-75 input, propagated through updates 75..100. The primary version
   requires one fixed check to be wrong throughout. The broader secondary
   version allows different wrong checks at successive updates. A repeated
   hard-decision suffix alone is not treated as a certificate.

The development pilot explored entry times 25/50/75 and radii 1/1024/65536;
only 75/1 had appreciable certificate coverage. That choice was frozen before
fresh noise. The full old-data audit includes every syndrome failure and every
successful run reaching iteration 75, plus the first 32 successes per arm.
All zero-coverage candidates are retained. The [development protocol](LOOP-DEVELOPMENT-PROTOCOL.md),
[holdout protocol](LOOP-HOLDOUT-PROTOCOL.md) and [frozen hashes](search/loop-holdout-selection.json)
record the boundary; there was no holdout-based detector revision.

## Fresh performance comparison

Success includes the entire unchanged Z-stabilizer span. Syndrome failures and
wrong logical recoveries are scored separately.

| Code | Original FER | Merged FER | Merged − original (percentage points) | Simultaneous 95% interval |
|---|---:|---:|---:|---|
''']
 for name in LABEL:
  arms={r['representation']:r for r in fresh['results'] if r['design']==name};d=next(r for r in fresh['contrasts'] if r['design']==name)['quantum'];a,z=d['bonferroni_simultaneous_95_interval']
  lines.append(f"| {LABEL[name]} | {100*arms['original']['failure_rate']:.4f}% | {100*arms['merged']['failure_rate']:.4f}% | {100*d['difference_merged_minus_original']:+.4f} | [{100*a:+.4f}, {100*z:+.4f}] |\n")
 lines.append('''
These are the two frozen within-code contrasts, with Bonferroni simultaneous
95% intervals. They measure the effect of the original/merged representation;
check degrees and message routing still change together. They do not isolate
absorbing-set count as the cause.

| Code | Original syndrome failures | Merged syndrome failures | Net extra syndrome failures | Original / merged logical failures |
|---|---:|---:|---:|---:|
''')
 for name in LABEL:
  arms={r['representation']:r for r in fresh['results'] if r['design']==name};a,z=arms['original'],arms['merged']
  lines.append(f"| {LABEL[name]} | {a['syndrome_count']:,} | {z['syndrome_count']:,} | {z['syndrome_count']-a['syndrome_count']:+,} | {a['counts']['logical']:,} / {z['counts']['logical']:,} |\n")
 lines.append('''
## Certificate coverage, including unsuccessful hypotheses

The primary certificate is the union of recurrence, rejecting invariant box
and the single-pinned-check tube. Since the first two had zero coverage,
primary and pinned coverage coincide in this experiment.

| Sample | Code | Arm | Syndrome failures | Exact recurrence | Rejecting invariant box | Pinned-check tube | Changing-check tube |
|---|---|---|---:|---:|---:|---:|---:|
''')
 for source,records in [('Development',old['records']),('Fresh holdout',fresh['results'])]:
  for r in records:
   c=r['counts'];den=c['failure'] if source=='Development' else r['syndrome_count'];cycle=c.get('fixed',0)+c.get('periodic',0);box=c.get('box',0);p=c.get('pinned',0);rob=c.get('robust',0)
   lines.append(f"| {source} | {LABEL[r['design']]} | {r['representation']} | {den:,} | {cycle:,} | {box:,} | {p:,} ({100*p/den:.2f}%) | {rob:,} ({100*rob/den:.2f}%) |\n")
 lines.append('''
The broad tube's high coverage should not be mistaken for a general theory.
It uses the actual late state, a tiny perturbation radius, and the remaining
26-step budget. It says that these failures are not reversed by those small
perturbations at that point. It does not explain why the decoder entered the
state, what happens after iteration 100, or how to predict failure before
running the decoder. No certificate is advertised as a trained classifier;
rejecting all enclosed states is part of its mathematical definition.

## How much of the representation penalty has a pinned-check certificate?

Count syndrome-discordant pairs in both directions. A lost match has original
acceptance and merged rejection; a gained match has the reverse. The following
is a descriptive partition, not independent causal contributions.

| Code | Lost matches | Certified lost | Gained matches | Certified gained | Certified lost − certified gained | Uncertified lost − uncertified gained |
|---|---:|---:|---:|---:|---:|---:|
''')
 for r in fresh['cohorts']:
  g=r['groups'];lost=g['lost_syndrome_match'];gained=g['gained_syndrome_match'];lc=lost['merged_primary'];gc=gained['original_primary'];net=lost['cases']-gained['cases']
  lines.append(f"| {LABEL[r['design']]} | {lost['cases']:,} | {lc:,} | {gained['cases']:,} | {gc:,} | {lc-gc:+,} | {net-(lc-gc):+,} |\n")
 lines.append('''
Neither the primary nor broader tube isolates the effect of cross-check
coupling. They also occur in original failures and in the failed arm of
rescued pairs. A full explanation needs conditions governing *entry* into
persistent failure, and must account for recoveries as well as losses.

## Lean results and execution bridges

[General persistence and interval soundness](../dyadic-rank/CyclicDecoderPersistence.lean)
proves:

- A forward-closed rejecting region prevents all subsequent acceptance.
- Fixed points and finite closed collections of rejected states are traps.
- The interval sign/minimum/normalization operation encloses the exact check
  update, including zeros, rounding and clipping.
- Interval propagation encloses the complete variable-node update.
- A uniformly wrong check rejects every state in its box.
- Invariant boxes reject indefinitely; time-dependent tubes reject for their
  stated finite horizon.

The model uses the actual incident-edge lists. Its variable update is proved
identical to posterior minus the edge's own message when those lists are
unique, matching the decoder equations.

Concrete source-linked data and full tube proof links are recorded in the
[Lean witness ledger](search/loop-lean-witnesses.json). The concrete proofs
check every coordinate of each remaining transition and the rejecting parity,
not just the generic theorem. Their compilation status and principal axiom
reports are in the verification manifest.

The independent C++/Python replay supplies reachability of the iteration-75
entry state. The entire C++ program, random sampler and initial 74 iterations
are not thereby Lean verified. Formal statements distinguish the supplied
entry state from its execution bridge. Soundness of the generic certificate
is separate from numerical coverage over millions of errors.

```mermaid
flowchart TD
  A[Exact check-message equations] --> B[Sound interval check update]
  B --> C[Sound interval variable update]
  D[Actual matrix and incident-edge certificates] --> C
  C --> E[Enclosure through updates 75 to 100]
  F[Uniformly incorrect check parity] --> G[No syndrome acceptance in remaining horizon]
  E --> G
  H[Independent decoder replay] --> I[Reached retained iteration-75 input]
  I --> G
```

## What this closes and what remains

**Completed:** the frozen, fresh, distance- and dimension-controlled paired
comparison; an explicit search for exact recurrence and invariant boxes;
quantitative out-of-sample coverage of a fixed persistence certificate; and
Lean soundness results for the certificate mathematics.

**Not completed:** a substantial early structural explanation of the aggregate
syndrome penalty, isolated causation by absorbing counts, a universally better
design objective, or a general error-floor predictor. The narrow neighborhood
and late entry time are material limitations. No additional source question
is marked solved. The paper PDF has not been updated with this follow-up.

## Reproduce and inspect

- [All holdout outcomes, packed detector fields and retained examples](search/loop-holdout-results.json)
- [Full development audit](search/loop-development-full-results.json)
- [Development checks](loop-development-checks.log)
- [Independent holdout checks](loop-holdout-checks.log)
- [General Lean check](loop-persistence-lean-check.log)
- [Verification manifest](loop-holdout-verification.json)
- [Decoder and detector wrapper](search/loop_engine.py)
- [Frozen detector implementation](search/loop_mechanisms.cpp)
- [Independent direct interval equations](search/loop_reference.py)

The holdout runner refuses to overwrite its selection file. Preserve the
published frozen records; reproduce in a separate checkout after explicitly
moving aside the existing result/selection artifacts. Development and holdout
results are kept separate, with no adaptive sample enlargement or pooling.
''')
 text=''.join(lines)
 ledger=json.loads((HERE/'loop-lean-witnesses.json').read_text())
 links='\nConcrete proof modules:\n\n'+''.join('- ['+r['namespace']+' proof](../dyadic-rank/CyclicDecoderTubes/'+r['namespace']+'.lean) · [state data](../dyadic-rank/CyclicDecoderTubeData/'+r['namespace']+'.lean)\n' for r in ledger['records'])
 links+='\n[Actual matrix/edge correspondence](../dyadic-rank/CyclicDecoderTubeGraph.lean) and [shared graph data](../dyadic-rank/CyclicDecoderTubeData.lean). Each proof imports its matching generated state data module.\n'
 text=text.replace('## What this closes and what remains',links+'\n## What this closes and what remains')
 mechanism='''## Local parity behavior in the retained fresh examples

Error indices are zero-based within their code-specific fresh streams.

In the first retained harmed pinned example for Previous best (error index
1804), check 66 has variables {24,65,106,178,193,209} and target parity one.
Across updates 75..100, its local decision alternates between `001001` and
`000000`: variables **106 and 209** flip together. For Minimum 4 (error 2435),
check 27 has variables {27,69,111,139,140,159}; its pattern alternates between
`010010` and `000000`, with **69 and 140** flipping together. The target is
again one. Both patterns always have even parity and therefore never satisfy
their checks. At updates 75/76 the Previous best pair's soft posteriors are
(-5,968,426, -3,385,433) and (+4,627,549, +9,515,745), in integer message units.
Both signs switch together although the two values are unequal. The proof
uses sign and parity inequalities, not equal-belief symmetry. These are finite
local decision oscillations; the full message states do not repeat.

[The parity lemmas](../dyadic-rank/CyclicDecoderParity.lean) prove that even
local changes preserve an incorrect check parity. The concrete fresh modules
verify the entire local alternating pattern uniformly over each interval
box, and hence over every trajectory beginning in the stated neighborhood.
This supplies a precise persistent-check mechanism for these examples, not a
claim that all pinned cases share this pattern or that it explains the net
performance penalty.

'''
 text=text.replace('## Lean results and execution bridges',mechanism+'## Lean results and execution bridges')
 reach=HERE/'loop-reach-lean-build-results.json'
 if reach.exists() and json.loads(reach.read_text()).get('status')=='reach_chain_passed':
  old_bridge='''The independent C++/Python replay supplies reachability of the iteration-75
entry state. The entire C++ program, random sampler and initial 74 iterations
are not thereby Lean verified. Formal statements distinguish the supplied
entry state from its execution bridge. Soundness of the generic certificate
is separate from numerical coverage over millions of errors.'''
  new_bridge='''For both retained fresh examples, the
[complete mathematical decoder comparisons](../dyadic-rank/CyclicDecoderReachability.lean)
remove the entry-state assumption. Lean checks the original prefixes from the
fixed prior: the first syndrome matches are updates **65** (Previous best,
error **1804**) and **86** (Minimum 4, error **2435**), with exact error recovery.
It checks both merged prefixes from the same prior, excludes early acceptance,
reaches each certified iteration-75 state, and combines each prefix with its
tube to prove rejection on **all 100 updates**. The initial zero-estimate
shortcut is separately excluded for all four runs. The complete matching
solution sets of the original/merged matrices are also proved equal.

The two development entry states remain replay bridges. Across the complete
fresh examples, all **351 C++ incoming/check-message states and estimates**
independently match the direct Python equations. This checks the implementation
bridge; Lean verifies the mathematical update equations and supplied finite
data, not the C++ compiler, binary semantics or random sampler. Lean starts
from the frozen integer prior **3,332,431** and checks its clipping identity;
the C++ log/round initialization at p=0.04 is checked through the initial-state
replays rather than a Lean real-logarithm proof. Soundness of the certificate
is separate from numerical coverage over millions of errors.'''
  assert old_bridge in text;text=text.replace(old_bridge,new_bridge)
  text=text.replace('''  H[Independent decoder replay] --> I[Reached retained iteration-75 input]
  I --> G''','''  J[Lean prefixes from fixed prior] --> I[Certified iteration-75 input]
  I --> G
  J --> K[Original first exact recovery at 65 or 86]
  K --> L[Complete finite representation comparison]
  G --> L
  H[Independent C++ and Python replay] --> M[Implementation bridge for 351 states]''')
  text=text.replace('and\nLean soundness results for the certificate mathematics.','and\nLean soundness results for the certificate mathematics, plus two complete\nfrom-prior mathematical original-success/merged-failure comparisons.')
 extra='''## Limits of the simple trapping approach

As an exploratory old-data-only refinement after the frozen holdout, we tried
two alternating interval boxes on the first saved hard-periodic failure in
each old arm. All four closed enclosures lost their rejecting parity; none
was a failure certificate. This did not revise the frozen detector or its
reported holdout coverage. [Refinement record](search/loop-two-phase-development.json).
A further old-data-only corner-based enclosure diagnostic produced no candidate
in 16 one-/two-phase checks on eight saved examples. Its 20,000 sampled enclosure
checks are numerical controls, not a new Lean soundness theorem; it was not
applied as a revised holdout detector. [Diagnostic record](search/loop-sharp-boxes-development.json).

An initial-syndrome graph-symmetry screen also found no candidate in the old
pilot's 1,152 runs or in all **41,181 old syndrome-discordant pairs**, examining
the failing representation of each pair. Stable color refinement distinguished
every variable in every discordant case, so it supplied no variable classes
forcing an incorrect even check parity. This is an old-data computational
screen, not a Lean invariance theorem or a proof excluding other symmetries,
state relations or obstructions. It did not revise the holdout detector.
[Pilot record](search/loop-symmetry-development.json);
[complete discordant screen](search/loop-symmetry-discordant-development.json).

A separate [Lean-checked sensitivity calculation](../dyadic-rank/CyclicDecoderSensitivity.lean)
shows why alpha 0.8 alone supplies no global one-step maximum-norm contraction argument.
For both merged update maps at the retained error syndromes, changing every
incoming message by 1,000 integer units changes one output by **1,600** units.
The decoder prior and update rule remain fixed; the second internal state is
a hypothetical operator input and is not asserted reachable from the channel.
This rules out a global one-step nonexpansiveness claim for those maps. It is a proof-method
limitation, not a mechanism unique to merging; it neither explains the measured
penalty nor excludes more precise invariant regions.

'''
 text=text.replace('## What this closes and what remains',extra+'## What this closes and what remains')
 literature='''## Relationship to existing research

The [dated literature comparison](LOOP-LITERATURE.md) covers both P34's original
girth/decoding-properties question and these follow-ups, with a
[source and access ledger](search/loop-literature-review.json).
Fossorier's QC cycle criteria (2004), Raveendran–Declercq–Vasić's LP eight-cycle
argument (2025), and Okada–Kasai's square-base results (2026) are mathematical
predecessors. The degree-three, girth-eight stopping bound also has a direct
classical predecessor in Kelley–Sridhara–Xu–Rosenthal (2004).

The original seed dissertation by Morris (2025), Chapter 5 Table 5.1, already
separates opposing syndrome/logical effects under Gallager-B: a representation
with fewer failure-inducing absorbing sets can have more syndrome mismatches.
Its Chapter 6 explicitly proposes redundancy studies for lifted products.
This is a direct research-program predecessor, with a different decoder,
count definition and intervention. Our merger study partly investigates that
direction; it does not settle the general question or claim the first
count/performance mismatch.

Representation-dependent quantum decoding is established prior work:
Rigby–Olivier–Jarvis (2019), Miao–Schnerring–Li–Schmalen (2022/2023), and
Rabeti–Mahdavifar (2026) alter check representations. Raveendran–Vasić (2021)
and Morris–Pllaha–Kelley (2023/2024; journal 2026) analyze quantum failure
structures. Butler–Siegel (2014), Zhang–Siegel (2014), and
Tomasoni–Bellini–Ferrari (2014 preprint) supply state-space, quantization,
saturation and min-sum equilibrium/limit-cycle precedents. Their hypotheses
do not automatically apply to our full fixed syndrome decoder.

Our contribution here is the reproducible fixed-code experiment and its
concrete Lean-checked mathematical certificates, not discovery of these general
phenomena. The exact codes/mergers/certificates were not matched in inspected
primary texts; priority is not established. The especially relevant
Morris–Pllaha–Kelley ISTC 2025 redundancy paper is confirmed by the authors'
bibliographies, but its substantive full text was not obtained. The comparison
marks that gap explicitly rather than treating a title as a proof comparison.
The report also credits the published syndrome min-sum equations; no new
decoder is claimed. Nothing here establishes an asymptotic error floor.

The original experiment/Lean verification manifest is a historical snapshot at
commit `888beeb`; this literature revision preserves every scientific input,
result and proof. Run `python3 scripts/verify_cyclic_loop_literature.py` for the
current documentation revision and its comparison against that snapshot.

'''
 text=text.replace('## What this closes and what remains',literature+'## What this closes and what remains')
 text+='''\nTo rebuild the formal chain in the pinned Lean/mathlib environment:\n\n```sh
python3 scripts/check_cyclic_loop_lean.py
```

This serial build includes the generic results, actual graph correspondences,
all four tubes and both complete retained-example comparisons. The scientific
holdout runner is separate and refuses to overwrite the frozen selection.
'''
 (HERE.parent/'LOOP-HOLDOUT.md').write_text(text);print('Holdout report generated',flush=True)
if __name__=='__main__':run()
