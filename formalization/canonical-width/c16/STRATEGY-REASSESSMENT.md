# C16 strategy reassessment and six-hour continuation

Canonical target: `L-F91-c16-unrestricted-width`, issue8 (read-only).
Session: `c16-strategy-20261029T0321`; work branch
`research/c16-strategy-20261029T0321`.
Authorized start:2026-10-29T03:21:21Z; deadline:2026-10-29T09:21:21Z.
Baseline:ffaa9f6f3513e1b91f34aac5741703ad39402d22.

The original question is whether the fixed source code has unrestricted
canonical width16 or18. A physical128-pair frame in the complete720-vector
minimum pools proves16; a complete justified nonexistence proof proves18.
Current evidence: physical88/128, sufficient selected-pair cover418,
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
negative source consequences. Direct subset-clause subsumption against276,174
old expanded patterns retains783 incremental cores. That is a syntactic
non-subsumption result, not logical independence or a new source answer.

The paired30-minute static full-anchor baseline/span trials both ended UNKNOWN,
as did the separate30-minute short-word trial and the15-minute global96-pair
projection. All their learned theory clauses pass independent consumers. A
separate frozen15-minute Kissat4.0.4 trial retains419,890 distinct universal
clauses from the completed trials in an8,158-variable,1,045,599-clause exact
full-anchor input. Its result is pending at this checkpoint. Reusing these
clauses avoids discarding completed theory work; no speedup is inferred from
the clause count.
