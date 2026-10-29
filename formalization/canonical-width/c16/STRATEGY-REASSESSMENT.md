# C16 strategy reassessment and six-hour continuation

Canonical target: `L-F91-c16-unrestricted-width`, issue8 (read-only).
Session: `c16-strategy-20261029T0321`; work branch
`research/c16-strategy-20261029T0321`.
Authorized start:2026-10-29T03:21:21Z; deadline:2026-10-29T09:21:21Z.
Baseline:ffaa9f6f3513e1b91f34aac5741703ad39402d22.
The session was interrupted and explicitly resumed at2026-10-29T10:27Z,
after the original deadline. The continuation completes saved proof checks and
a bounded follow-up on three saved candidates; it is not six hours of claimed
uninterrupted computation.

The original question is whether the fixed source code has unrestricted
canonical width16 or18. A physical128-pair frame in the complete720-vector
minimum pools proves16; a complete justified nonexistence proof proves18.
Evidence at the start: physical88/128, sufficient selected-pair cover418,
zero completed full source anchors. The last rank-cover pilot produced
47 checked mixed-rank obstructions but no smaller cover or acceleration.

Question/source → intended answer → decisive evidence: reassess structural,
literature and existing-code routes to the full128-pair decision; identify
and pursue a decisive restricted lemma or construction test with explicit
source bridges. Exact independent certificates are required for exclusions
or constructions. No time-to-discovery estimate is asserted.

First phase: compare the strongest structural routes with the already tested
relaxations, search primary papers and public code using the resulting precise
translations, and freeze bounded tests before expensive implementation.
Later phases pursue the best-supported route, with explicit stop conditions
and time reserved for independent replay, source/question accounting,
preservation, required-review publication and expected-SHA claim release.

The current independently certified sufficient cover is **411**. This removes
seven of the418 cover cases at the start (1.675%). The physical frame remains
88/128, the width remains16 or18, and zero full source anchors have been solved.
These are separate measures: a smaller sufficient cover does not prove that
its removed classes can never occur in a full frame.

No sub-agents, issue messages, new schedules, master bypass or auto-merge.
Use the existing PR17 for authorized repository publication. Read-only issue
policy persists. New literature must be indexed and full accessible texts
screened for author-stated questions before closeout.

## First checked result

The sufficient selected-pair cover is now **417**, down from418. The source
width remains16 or18; physical partial frame88/128; no full source anchor has
been completed. `strategy-results/cover-417.json` binds the new case manifest.

The frozen class(26,32,15), normalized to physical pool indices416/527, is
removed from the cover. Pure zero-domain rank refinement found a six-pair
partial matching with residual pool ranks122 on both sides. It has167
residual X candidates and205 residual Z candidates. Thus these separate rank
tests alone cannot reject it. Any submatching also passes them: the removed
pairs' private partners complement the original residual span.

Mandatory-pool propagation rejects this witness. In particular, the residual
Z pool has a coloop at102 with no residual X vector giving its unique private
column. More generally the already implemented propagation alternates basis
coloops, zero-domain coloops, mandatory independence, unique partners and pool
filtering. A native implementation discovers clauses; a new independent
low-pivot consumer checks every forced coloop by a physical covector supported
on that pool point alone. This is a new application of the existing propagation
principle, not a new general rank theorem.

The local refinement has101 positive partial models and201 minimized source
clauses before UNSAT. A fresh ordinary CaDiCaL run produces a DRAT proof;
independent physical input regeneration and DRAT replay pass, including an
empty-proof rejection and10214 directly checked coloop covectors. The entire
parent418 proof chain also replays, including63 new anchored proofs and its
recursive base. Both pieces are needed for the cover417 conclusion.

Why this is a cover reduction: a hypothetical full frame avoiding the new
retained list would project to a compatible nonzero-signature matching inside
the old100 omitted classes plus c. Delete zero-XOR subsets until signatures
are linearly independent. The old omitted-set UNSAT premise forces some pair
in c to remain. Translate and exchange sectors to normalize that pair to the
fixed anchor. Universal negative full-basis clauses remain valid after deleting
pairs. The new anchored UNSAT certificate then gives a contradiction. This
does not exclude c from frames which use a different retained class.

## Signature normalization and the next bounded gate

Every finite binary vector family with a specified XOR sum has an independent
subfamily with the same sum: delete a nonempty zero-XOR dependent subset until
none remains. For the16-bit signature map, at most16 pairs remain. Compatibility
and all negative selected-vector/pair consequences survive deletion. The
normalization can therefore be imposed on compact necessity models, including
source-rank and mandatory-propagation clauses. For an anchored cover-extension
argument the old omitted-set UNSAT premise is essential, as above.

This is an exact reformulation, not a stronger unconditioned signature-cover
criterion. Adding lazily learned zero-XOR signature-circuit clauses merely
enforces this normal form. The old121 packing lower bound is unchanged by this
normalization alone, but does not transfer to the stronger source-closure
criterion. Global pilots of500 rank-only and1000 closure refinements ended at
their round caps without a source decision. A separate1000-round matroid/closure
pilot also remains unresolved. These bounded failures are retained.


## Reassessment after the first controlled full-frame pilots

The first full anchor48/48 comparison ended UNKNOWN in both900-second variants.
The conditional engine supplied20,000 source-valid clauses (12,654 span and7,346
private-coset); their complete independent replay passes. Its last periodic
checkpoint understated the final clause count because the cap stopped further
updates. The frozen20,000-row file and receipt give the final count.

The direct-owner matching model is an implementation continuation of the earlier
endpoint and private-neighbor formulations in FINITE-MODELS.md and
frame_cpsat.py; it is not a newly discovered equivalence. Learning its exact
matching constraints dynamically was unsuccessful: both900-second variants
ended UNKNOWN and generated millions of clauses. All matching and theory clauses
are independently replayed, with lossless compressed logs. This route is retired
at this bounded endpoint. Fewer initial variables alone did not establish a gain.

A static binary partner-label encoding avoids that clause flood. It uses8,158
variables and625,709 clauses for the same full source anchor, with unconditioned
phase cuts and201 source-closure seeds. For comparison, the older full-anchor
input uses223,723 variables and821,022 clauses, but also has different redundant
conditioned cuts. This size comparison is not a runtime speedup claim. A new
30-minute comparison uses identical static input and observed owner variables;
the baseline callback only observes, while the theory variant adds checked rules.

One-sided static matching argument: letS andT be the selected distinct pool
vectors. Each row of the Gram matrix onS byT has exactly one1 and every column
is used. Its binary rank is therefore |T|. If |T|>=128, ambient rank gives
|T|=128, andT is a basis. Evaluation on that basis is injective onS. The only
possible rows are the128 distinct unit rows, each already required to occur,
so |S|=128 and the Gram matrix is a permutation matrix. A binary count bit7
implies |T|>=128; the rank argument supplies the upper bound. Conditional binary
labels encode row uniqueness with no edge variables. Exact small controls and
an independent physical/CNF reconstruction check this implementation.

## Conditional short-word lemma

LetJ be selected Z vectors andL=span(J). For w outsideL, write its expansion
in a hypothetical full allowed Z basis. The coefficients outsideJ are exactly
the pairings beta(x,w) on selected X vectors orthogonal toJ. If w+L contains
neither an allowed Z point nor a sum of two allowed Z points, at least three
such selected X vectors are required. Consequently, for any setT of at most
two possible X points in that detecting setS, the clause

    OR(j in J) not q_j  OR  OR(i in S minus T) p_i

is necessary. This is a full-basis positive clause; it must not be imported into
a deleted-pair projection model. Quotient labels of the720 allowed Z vectors
check the absence of one- and two-term representations with a hash-set lookup,
without enumerating basis completions. The first200,000 source clauses include
108,208 instances of this new type, and their independent RREF consumer passes.
This validates the clauses, not their performance or a source-case completion.

Controls exercise801 new-rule clauses on all840 possible X bases of a tiny
asymmetric pool with a known unique full frame. A separate600-state quotient
control exercises758 new clauses,446 with nonemptyJ, and checks all short sums
literally. Fifty128-dimensional controls enlarge the source pools by unit
vectors:200 new clauses retain the known identity frame. The enlargement is a
mathematical positive control, not a minimum-weight source frame.

A general companion bound: forU of dimensionu, W=U-perp, and
L_d=span(W intersect {sums of at mostd allowed Z vectors}), if
L_d is a proper subspace ofW then a full allowed frame selects at mostu-d
X vectors inU. Indeed evaluation embedsW as a binary code of dimension128-u
on the selected X coordinates outsideU. A code of lengthm and dimensionr has
a basis of words of weight at mostm-r+1: put a parity-check matrix into systematic
form and use its fundamental circuits. If m-r<d, those words would spanW using
allowed sums of length at mostd, a contradiction. The d=1 case is the earlier
strict flat-saturation lemma. A first d=2 orbit screen gives some stronger bounds
than that single lemma, but they are already dominated by the complete local
phase tables. No extra pruning is claimed from this local screen.

## A global projection route

The new96-pair input has no fixed anchor. It has12,636 variables and1,236,818
clauses, with exact96 counts in both sectors and one-sided partner uniqueness.
Equal counts make the resulting surjection a bijection, without a full-basis
assumption. It imports425,244 negative source clauses from6,683 checked seed
certificates and the complete unconditioned phase tables. No full-basis positive
clauses or signature-independence constraints are used. The independent physical,
source-certificate, symmetry-generator, adder and CNF reconstruction passes.

Every128-pair frame contains a96-pair subframe. Deleting pairs preserves all
imported all-negative source restrictions. Thus a checked global UNSAT here
would exclude every full128-frame. A SAT result would instead be a physically
checkable96-pair partial construction, with no claim of extension. The frozen
first trial has a900-second wall limit. Either UNKNOWN or a partial SAT leaves
the source question open.

## Literature accounting and route gates

F164 (Glasgow Subgraph Solver,2020) andF165 (IPASIR-UP,2023) were fully read and
screened. Sixteen historical broad directions/method requests were reconciled
into the shared inventory, outside its precise-target denominator. Seven other
metadata/selected-passage leads retain null question counts. Current-resolution
and matching Lean assessments for those new directions remain unperformed.
The shared cohort is424 entries,160 eligible targets,204 paper records and165
full-text screens, with the six completed Lean targets unchanged.

The requested OpenAI-library revisit pins the same7ef5c0cc commit as the earlier
audit. TensorApproximation requires characteristic zero; CommonBasesFPRAS omits
the identity cross-Gram requirement. No theorem import, complete manuscript screen
or transitive Lean build was performed. The author C16 repository still has the
same04ad4795 head, and the inspected latest arXiv source is stillv1.
A nonseparating-cocircuit lead passes its initial source requirement everywhere:
all45 representative allowed cocircuits are nonseparating. That requirement
therefore removes none; 3-connectivity and the full theorem were not asserted.


## Accepted domain-aware cover416

The sufficient cover is now416. The new removed class is(26,32,0), normalized
to416/512. Restricting the complete full-frame pair domain to the102 omitted
nonzero-signature classes plus all83,504 zero-signature source pairs leaves
86,736 allowed pairs. The new propagation retains the physical pairing graph
for commutation/rank tests, but uses this allowed graph for private partners.
A mandatory pair through a forbidden edge is impossible, and a candidate that
could only pair to a forbidden mandatory neighbor is removed. Rank and coloop
steps are unchanged. All4,096 tiny domain/mandatory-set combinations retain the
721 combinations admitting a full completion;512 native queries independently replay.

The first anchored version yields UNSAT after431 partial models and860 learned
domain nogoods. Its fresh static proof and75-second independent replay pass.
A stronger statement was then checked with a simpler projection bridge: preserve
the designated anchor and delete zero-XOR subsets of the free pairs only. At most
16 independent free signatures remain, for at most17 pairs total. This permits
an anchor signature to occur once more among the free pairs; it imposes no
independence condition involving the fixed anchor. The kept-anchor input is
UNSAT using the same860 independently replayed domain nogoods, with no further
refinement. Its fresh131,378,633-byte DRAT proof and83-second independent
physical/domain/CNF/DRAT replay pass. `cover-416-bindings.json` checks the nested
manifest and its parent417 fingerprints. The full source question remains open.

For an arbitrary proposed batchB, use one common domainR containing all previously
omitted classes and every member ofB, as well as all zero-signature source pairs.
If a full frame avoids the proposed retained cover, the parent cover forces a
pair in a removed class. Preserve that actual pair while projecting the free
signatures. A proved kept-anchor UNSAT for that class in the common wider domain
contradicts the projection. Thus any subset of successful anchors from this same
batch may be removed together; failed candidates can remain retained. Independent
proofs made in different narrower domains cannot be combined by simply deleting
all their classes.

Domain nogoods are conditional, so wideningR requires replay before reuse.
All860 learned cores survive the planned110-class batch domain. In the completely
unrestricted physical pair graph, only788 survive;72 do not transfer. Ordinary
source mandatory propagation independently confirms those788 as universal
negative source consequences. Incremental subset-clause screening starts with
276,174 old expanded patterns and adds rotations of each retained new core.
It retains783 cores: five rows duplicate a cyclic translate of another new
core, and none is subsumed by the old library alone. That is a syntactic
non-subsumption result, not logical independence or a new source answer.

The paired30-minute static full-anchor baseline/span trials both ended UNKNOWN,
as did the separate30-minute short-word trial and the15-minute global96-pair
projection. All their learned theory clauses pass independent consumers. A
separate frozen15-minute Kissat4.0.4 trial retains419,890 distinct universal
clauses from the completed trials in an8,158-variable,1,045,599-clause exact
full-anchor input. This trial also ended UNKNOWN at900 seconds. Reusing these
clauses avoids discarding completed theory work; no speedup is inferred from
the clause count.

## Common-domain proofs and the411-case cover

The eight-case110-class-domain batch finds five independently certified anchored
UNSATs: (26,32,1), (5,32,3), (8,26,13), (5,26,7), and (8,26,7).
Two first proof checks exceed their180-second checking budgets; subsequent
600-second checks pass. Both the original timeouts and the later successes
are retained. Three other cases produce compatible partial signature matchings
with five, five, and six pairs. These are not full-frame witnesses.

The five successful proofs compose with cover416 to give cover411. The actual
avoidance domain has107 nonzero-signature classes and is contained in each
proof's110-class domain. Each proof preserves its designated anchor, allowing
up to16 independent free signatures. The comparison of domains is essential:
separately valid proofs under narrower, different avoidance domains cannot
simply be unioned. `verify_strategy_cover_union.py` checks this induction and
the exact hashes. `replay_strategy_cover.py` additionally reconstructs every
source/CNF dependency and reruns every recursive ordinary SAT proof in a fresh
checkout; it does not treat the hash-binding receipt as a proof checker.

A separate narrower-domain proof had already given cover415. A matched
CryptoMiniSat5.17 discovery trial on that same case and initial input took
173.67 seconds and104 partial models, versus79.39 seconds and110 models in
the ordinary solver run. Its independently checked ordinary-CNF proof is also
preserved. This one fixed comparison establishes no general performance ranking
and offers no observed reason to replace the ordinary solver here.

## A short-word obstruction beyond the propagation fixed point

All three saved fixed-point candidates fail full completion immediately when
the conditional short-word rule is enabled. Each failure uses a single
all-negative clause. The quotient labels and the physical detecting support
are independently reconstructed, and fresh ordinary proofs of the augmented
full-completion inputs pass. The full-source base and domain augmentation
also replay separately.

These particular clauses are stronger than conditional subproblem failures:
they are universal source-pool nogoods. If J is a proposed selected Z subset,
w+span(J) has no source representative or sum of two source representatives,
but only two or fewer source X vectors orthogonal to J detect w, then no full
dual basis can contain J. In a full basis the number of outside-J terms in w's
expansion equals the number of selected detecting X vectors. It would have to
be both at least three and at most two. Interchanging sectors gives the same
argument. The saved obstructions use mandatory subsets of sizes five, five,
and six; the short-word certificates are in `universal-short-word-seeds.json`.

Because every literal of these clauses is negative, deleting pairs preserves
them. They can therefore be imported into the compact necessity model. The
mixed-sign short-word clauses used by the full solver generally cannot.
`word_kept_anchor_domain_signature.py` probes each closure fixed point and
imports only these independently checked all-negative instances. A frozen
three-case follow-up uses the same110-class domain,600 seconds per discovery,
300 seconds for ordinary proof generation, and explicit independent replay.
Its final outcomes are recorded separately in `word-followup.json`.

## Route to a decisive answer

The source bridge is already bounded and exact: the independent weight-at-most17
pool enumeration and mixed-Pauli reduction in `INDEPENDENT-ENUMERATION.md`
reduce the remaining width question to a128-pair frame in the720-vector pools.
This is written mathematics plus independent finite computation, not a Lean
proof of the source question.

There are two decisive endpoints. A physical128-pair construction, checked in
the original code, proves width16. A global nonexistence certificate, or checked
full-completion exclusions for every representative of a sufficient cover,
proves width18. No source case has yet reached either endpoint. A complete
global96-pair UNSAT would also imply nonexistence of a128-pair frame, but its
bounded pilot is UNKNOWN.

The next structural follow-up is to strengthen the now effective quotient-word
obstruction. For any d, absence of a representation with at most d source terms
in the quotient, together with at most d possible detecting vectors, gives the
same contradiction. The next bounded gate should test d=3 on saved surviving
candidates, using exact pair-sum tables and an independent consumer. A pair-sum
table has at most259,561 entries for720 labels; three-term membership is a
single-label scan against that table. This is a specific algebraic test, not a
proposal to enumerate every basis. Its payoff is untested, and finding suitable
detecting vectors remains part of the work.

Only after such a gate produces a new certificate should its clauses be fed
back into the compact proof or full-completion models. More C++ can reduce
table and elimination overhead; it does not supply the missing theorem or
establish a completion-time bound. Broad literature expansion and solver
switching are lower priority than this source-specific obstruction test.

## Reproduction and deliverable accounting

From a clean checkout, with Python3.12, python-sat1.9.dev17 and DRAT-trim at
the pinned version recorded in the manifest, the cover replay is:

```sh
python formalization/canonical-width/c16/replay_strategy_cover.py \
  --drat-trim /path/to/drat-trim \
  --output-directory /tmp/c16-fresh-cover-replay --workers 2
```

The output directory must not already exist. Immutable original receipts are
not overwritten: fresh results compare source, input, proof and certificate
counts with the canonical records. `strategy-results/clean-cover-replay/manifest.json`
records a complete replay of cover411 from detached commit a5d8bd2. This includes
the entire parent418 proof chain and all seven subsequent removal proofs.

The large static theory logs are stored losslessly. Restore them before replaying
the full-frame model consumers:

```sh
python formalization/canonical-width/c16/hydrate_strategy_logs.py \
  --manifest formalization/canonical-width/c16/strategy-results/static-owner-log-archives.json
```

The fresh model replays check the200,000-clause span log, the200,000-clause
word log, the full unanchored base, the merged full-anchor input and all three
completion augmentations. Their results are in `clean-model-replay/manifest.json`.
For each theory log, run `verify_binary_owner_frame_model.py` or
`verify_word_owner_frame.py` with `--instance strategy-results/binary-owner-instance.json`,
the appropriate `--theory-log`, and a new `--output` path, resolving these paths
relative to the C16 directory.

Both native engines are rebuilt from the checked-in C++ source with
`clang++ -std=c++20 -O3 -DNDEBUG -shared -fPIC`. The fresh controls in
`clean-native-controls` check all4096 tiny domain/mandatory-set combinations,
840 tiny full frames, the801 new-rule clauses,600 quotient states and50
enlarged128-dimensional positive controls. These enlarged pools are controls,
not source-frame constructions. `control_short_sum_flat.py` independently
reproduces225,120 small short-sum-bound checks. `cocircuit_connectivity_gate.py`
and `verify_strategy_rescoped_cuts.py` reproduce the retired method gate and
the788/783 universal-core accounting.

| Requirement | Status | Evidence and limit |
|---|---|---|
| Decide the original width16/18 question | Partial | Cover reduction and source obstructions; no128-pair construction or global nonexistence proof. |
| Reassess mathematical and implementation routes | Met | Conditional short-word lemma, explicit anchor-preserving projection, domain composition, bounded solver comparisons above. |
| Inspect specific papers and public code | Met, bounded | `literature-ledger.json` pins inspected versions and actual reading/build scope; OpenAI tensor/common-basis results do not transfer to this target. |
| Harvest encountered full-text questions | Met | Two completed screens,16 historical broad directions indexed; seven unprioritized full-text leads retain null question counts. |
| Authenticated X research-post coverage | Access-limited | No X connector was exposed; no authenticated browser search was performed. Indexed web results are not counted as X coverage. |
| Independent proof and source checks | Met for accepted results | Recursive clean cover replay, source/CNF/DRAT consumers, fresh model replays and native controls. Solver timeouts are retained as UNKNOWN. |
| Lean proof of the source answer | Not completed | No change to the six completed Lean targets in the shared inventory. |
| Repository publication | Pending required review | Work is preserved through PR17; protected master review is not bypassed. |

The new literature ledger totals424 canonical entries,160 eligible targets,
204 paper records,165 full-text screens and six complete Lean targets. The16
added broad directions do not change the precise-target denominator. No source
problem is declared solved by these auxiliary results.
