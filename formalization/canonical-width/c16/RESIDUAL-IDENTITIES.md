# C16 residual matrix identities and compact cover proofs

Every full original minimum-pool frame has a simultaneous cyclic translate and
optional sector exchange containing one of **497 listed pairs**. This is a proper
subcover of the earlier505-case cover, removing eight further representatives
with an independently checked proof. The gain is8/505, about1.6percent. Stronger
matrix identities at one fixed anchor are a separate result: they reject known
partial solutions but do not supply the smaller-cover proof.
The source width remains16 or18, with no completed retained anchor and no new
Lean completion. The best verified physical partial frame remains88 pairs.

The canonical target is `L-F91-c16-unrestricted-width`, Lee,
[arXiv:2610.06820v1](https://arxiv.org/html/2610.06820v1), Proposition9 and
equation50. The original-pool bridge is in
[INDEPENDENT-ENUMERATION.md](INDEPENDENT-ENUMERATION.md). The preceding
[505-case theorem](NONLINEAR-COVER.md) and
[518-case linear obstruction](JOINT-COVER.md) remain valid.

The final [497-case list](residual-identity-results/cover-497-independent.json)
contains physical-pool indices and unresolved completion statuses. Eight
additional removed tuples, using the preceding report's convention, are

```text
(3,26,9) (4,26,1) (5,26,1) (5,32,5)
(6,32,1) (22,32,5) (28,32,14) (32,34,5)
```

## Residuals supply independent necessary equations

Write a dual frame as columns of matrices X and Z. For128 pairs,
X transpose times Z equals the128-dimensional identity, so both matrices are
invertible and X times Z transpose also equals the identity. Thus every full
frame satisfies every entry equation

\[
 \sum_i x_{i,a}z_{i,b}=\delta_{ab}\quad\text{in }\mathbb F_2.
\]

Off-diagonal equations have target zero and were absent from the original
sixteen-signature model. More generally, auxiliary vectors u,v give

\[
 \sum_i (x_i\cdot v)(u\cdot z_i)=u\cdot v.
\]

For a partial dual frame with m pairs, let S be the outer-product sum. Its
Gram identity gives S squared equals S and rank S equals m. Consequently
R equals I minus S is a projector of rank128 minus m. A nonzero entry R[a,b]
selects a valid full-frame equation violated by this particular partial frame.
Since that frame satisfies the preceding equations, the selected functional
cannot lie in their span: each adaptive addition increases the span rank.
This bounds independent refinement rounds by16384; it gives no bound on the
cost of solving any round.

The fixed anchor is `X03-Z03-h00`, original indices48/48. Its compatible free
graph contains **53511 actual source edges**. The initial comparison adds the
sixteen translated source705/705 identities to the original sixteen, followed
by the zero-target entry equation at row0,column2. Further equations come from
the residual of the latest partial solution.

The strongest saved system has **87 independent functionals**. Compatible
partial matchings exist for every tested prefix through86 equations; the
87-equation solve returns UNKNOWN at its15-second native limit. All positive
witnesses and separating residuals are independently checked in physical
coordinates. No anchor is excluded by these comparisons.

## Compact models retain all relevant original edges

[adaptive_matrix_identities.py](adaptive_matrix_identities.py) first keeps the
entire53511-edge free graph while incrementally adding equations. Its61- and
66-equation comparisons reach UNKNOWN at3- and20-second native limits.
[compact_matrix_identities.py](compact_matrix_identities.py) rebuilds the model
from that entire original graph at every round. Under the66 saved equations,
19197 free edges have nonzero signatures, realizing2928 distinct signatures.
A fresh compact model finds a partial solution there, then reaches86 equations.
These are controlled necessity-model observations, not full-frame speedups.

An edge with zero current signature can be deleted from a partial matching
without changing any current equation. For a nonzero signature, even
multiplicity can be deleted entirely and odd multiplicity reduced to one edge.
Conversely, a signature-presence solution supplies an actual parity solution
by retaining one edge per present signature. Deletion preserves compatibility.
The fixed anchor is kept outside this compression, and its contribution is
subtracted from every target. Newly active source edges are recomputed after
every added equation; an old active-edge list is never reused as a restriction.

## Global cover proposals and dedicated proofs

For the original sixteen signatures, let C be the518-class support and D a
retained subcover candidate. Every full frame avoiding D would give a partial
induced matching inside C minus D whose XOR signature is65535. UNSAT for that
partial-matching problem therefore proves D sufficient, while a SAT matching
supplies a hitting constraint for later proposals.

[global_signature_cover.py](global_signature_cover.py) removes the previous
radius-three exchange restriction. The unrestricted-size master makes1192
SAT proposals without improving505. A second comparison proposes exactly
fourteen removed classes:278 calls give18 SAT answers and260 UNKNOWN answers.
Neither the master bounds nor its discovery no-goods establish optimality.

[certify_cover_candidates.py](certify_cover_candidates.py) reconstructs each
candidate using only its actual removed-class edges, with uncompressed parity
chains. The first UNKNOWN proposal gives a checked504-case cover; the next
compact extension gives503. The subsequent bounded extension reaches497.
Its final uncompressed proof uses656 actual removed-class edges,3318 variables
and27270 clauses, with1320363 DRAT lines including deletions. Exact hashes are in
[cover-497.json](residual-identity-results/cover-497.json); the bounded trajectory
is in [compact-extension.json](residual-identity-results/compact-extension.json).

A fresh greedy comparison tests419 further classes. It returns379 explicit
SAT partial witnesses and40 UNKNOWN answers, with no discovery UNSAT.
Those379 witnesses stay valid as more classes are removed: the allowed
partial-matching domain only grows. The proof extension therefore retries
only UNKNOWN classes. Each accepted extension has a DRAT-checked compact
proof; the final cover additionally requires independent physical CNF
regeneration by [verify_signature_cover.py](verify_signature_cover.py).

Removed classes remain allowed in full frames. A smaller sufficient cover
means fewer normalized starting representatives; it does not exclude those
classes from every frame or settle any retained completion.

## A method-specific lower bound

The checked partial witnesses also constrain what the original sixteen-signature
cover criterion can achieve. A sufficient cover certified solely by its UNSAT
test must intersect the class support of every compatible partial matching
with XOR65535. Pairwise disjoint such supports require distinct retained classes.

[method-cover-packing.json](residual-identity-results/method-cover-packing.json)
contains109 disjoint supports, including the earlier85 singleton supports.
Their original-pool matchings and disjointness are independently checked.
Thus this particular proof criterion requires at least109 retained classes.
This is neither a lower bound for arbitrary covers nor evidence that any full
frame exists. Packing optimality is not claimed.

## Independent replay and limits

[verify_residual_identities.py](verify_residual_identities.py) reconstructs all
518400 physical pairings and canonical coordinates, then checks every saved
positive partial matching, residual projector, separating equation, global
hitting witness and disjoint packing support. Small full-basis controls check
the residual construction through dimension three. It imports neither the
discovery encoders nor SAT or optimization libraries.

The separate cover consumer regenerates the final uncompressed CNF byte for
byte from physical pairings, checks its DRAT proof and rejects an empty proof.
Its4096 small signed-graph controls compare literal induced-match semantics
with both parity encodings, totaling235298 Boolean assignment controls.
No numerical optimization status is promoted to an exact result.

```sh
python formalization/canonical-width/c16/verify_residual_identities.py --output /tmp/c16-residual-check.json
python formalization/canonical-width/c16/verify_signature_cover.py --certificate formalization/canonical-width/c16/residual-identity-results/cover-best.json --drat-trim /path/to/drat-trim --output /tmp/c16-cover-check.json
```

No new paper is acquired or counted in this follow-up. Existing source screens
and historical scientific manifests stay pinned to their original revisions.
Canonical-entry, eligible-target and complete-Lean-target deltas are all zero.
Integration to master follows PR17's required review; the review is not bypassed.

| Deliverable | Status | Evidence |
| --- | --- | --- |
| Run the residual-selected second source orbit and zero-target identities | Met | Physical replay of87 independent equations; partial witnesses through86 |
| Complete a retained source anchor | Not achieved | Last necessity-model call UNKNOWN; no128-pair completion |
| Test global cover proposals beyond local exchanges | Met |1192 SAT proposals and278 fixed-size proposals |
| Check the497-case cover independently | Met | Physical CNF regeneration, DRAT replay and empty-proof rejection |
| Prove a limit for the old cover criterion | Met |109 disjoint witnessed supports |
| Preserve source status and source inventory | Met | Width16/18; physical88; cohort deltas zero |
| Integrate to master | Pending | PR17 requires review |

**Question answered:** a complete497-case proper subcover exists, with independent
physical CNF regeneration and a checked proof. Residual-guided equations give87
independent constraints at the chosen anchor;109 disjoint partial-witness supports
lower-bound covers certified by the original sixteen-signature criterion.

**Question still open:** whether any full128-pair original-pool frame exists,
equivalently whether the unrestricted width is16 or18.

**Next proposed target:** follow-up — use the frozen stronger anchor model or
a globally different cover proposal, with a checked obstruction or a physical
full frame as the acceptance gate. A timeout or an additional separated partial
configuration is not a completed source case.

## Later symmetry and exchange followup

The [subsequent bounded loop](THEORY-LOOP.md) proves a428-case sufficient cover,
net69 fewer than497. It restores one old omitted class and is not a proper
subcover of this dated497 list. The new-class normalization lemma and exchange
case split have independent physical certificate replay. Every428 full
completion remains open; the unrestricted width remains16 or18.
