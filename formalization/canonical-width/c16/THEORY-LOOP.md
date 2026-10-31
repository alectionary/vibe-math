# C16 symmetry normalized cover reductions

Every full original minimum-pool frame has a simultaneous cyclic translate and
optional sector exchange containing one of **428 listed pairs**. This is 69 fewer
starting representatives than 497, a reduction of about 13.9 percent. The final
cover is **not nested** inside the 497-case list: an exchange restores one
previously omitted class and permits many other representatives to be omitted.
All 428 full completion cases remain unresolved. The unrestricted width remains
16 or 18, the best verified physical partial frame remains 88, and no new Lean
completion is claimed.

The source is Lee, [arXiv:2610.06820v1](https://arxiv.org/html/2610.06820v1),
Proposition 9 and equation 50, canonical target `L-F91-c16-unrestricted-width`.
The [physical-pool bridge](INDEPENDENT-ENUMERATION.md) and preceding
[497-case result](RESIDUAL-IDENTITIES.md) retain their original scope.
The [verified 428-case list](theory-loop-results/final-independent.json)
and its complete proof chain provide the new sufficient cover.

## Normalize the class that a new counterexample must use

For the original sixteen translated source witnesses 608 through 623, each
allowed edge e has signature s(e) in the 16-dimensional binary space. A full
frame has XOR signature 65535. The nonzero-signature support comprises 518
translation-and-exchange classes C. For R contained in C, let P(R) assert
existence of a partial induced matching in R with that XOR. If P(R) is false,
the retained list C minus R is a sufficient starting-case cover.

Suppose P(R) is already false and c is a new class. Any matching satisfying
P(R union {c}) must use c; otherwise it would satisfy P(R). Common translation
and sector exchange act transitively on c, preserve compatibility and class
membership, and preserve the all-one target signature. They therefore move
one selected edge of c to its fixed representative. Consequently it suffices
to refute the matching problem with that representative fixed.

After fixing an anchor, every remaining selected edge must be compatible with
it. The anchor's signature is subtracted from the target. This is a smaller
exact necessity problem. It does not assume that the selected frame itself
has any symmetry. The prior UNSAT premise is essential; without it, an
unanchored solution could live entirely in the old classes.

The first tested extension has 688 unanchored edges but only 378 compatible
free edges after normalization. The earlier unnormalized protocol needed
roughly a minute for its certificate; the normalized proof took less than a
second in the recorded runs. Seventeen normalized extensions reach 480 in
about 12 seconds. These are certificate-construction observations under the
recorded settings, not a measured speedup for the full 128-frame search.

## Exchanges escape a proved deletion barrier

The 480-case cover is inclusion minimal for this particular signature criterion:
each retained class c has a physically checked target-signature partial
matching supported inside R union {c}. Those 480 witnesses show that deleting
any one retained class while keeping the rest fixed cannot give another
UNSAT certificate under this criterion. They do not establish minimum
cardinality among other covers.

For an exchange trial R prime, every solution must use some class of
R prime minus R, since R intersect R prime is contained in the already
impossible set R. Normalize each possible new class in turn. If all anchored
branches are impossible, P(R prime) is false. Classes removed from R have
simply been restored to the retained cover, so no separate impossibility
proof is needed for them.

The first successful exchange restores class (38, 44, 9) and removes two other
representatives. That permits a cascade of further deletions. A global
hitting-set master uses physically checkable partial matchings as constraints;
it prefers fewer restorations but imposes no hard exchange radius. The
verified 428-case chain contains 52 successful exchanges with 53 anchored
proof branches after the 17 earlier normalized extensions.

The main sequence is 480 to 439 using uncompressed edge parities, then 439 to 435
using signature-presence compression, then 435 to 428 while also enforcing at
most one free edge per signature. Unknown proposals remain discovery no-goods;
they cannot support a minimum-cover or complete-neighborhood claim.

## Compression is justified by deletion

For a partial induced matching, remove all free edges of a signature that
occurs evenly, and retain one when it occurs oddly. The XOR is preserved and
deletion preserves compatibility. Conversely, a signature-presence solution
gives an ordinary XOR solution by retaining one free edge per present signature.
Thus presence compression and the optional at-most-one restriction preserve
existence, although they are not pointwise identities on every edge assignment.

The anchor stays outside this operation. Its contribution is subtracted first,
and all original edges relevant to the current signature system are included
before compression. Exhaustive controls cover 1296 small source/eligibility
graphs, all four two-bit targets, four encoding variants and 160000 literal
assignments. They include zero signatures and source cross edges omitted from
the candidate list. Earlier 4096 signed-graph controls are retained as well.

## A proof producing binary span rule

There is a separate algebraic propagation rule. If a target matching contains
free edge i, its remaining signature must lie in the binary span of signatures
still compatible with i. If it contains both i and j, the target minus their
two signatures must lie in the span of their common compatible neighbors.
A separating binary functional proves a node or pair impossible. These rules
can be applied repeatedly because every earlier exclusion is valid for all
solutions of that same target problem.

[affine_signature_closure.py](affine_signature_closure.py) records the separating
functionals. Its independent consumer uses physical pairings and dot products;
it does not rerun Gaussian elimination or import a SAT solver. On a 378-node
control it proves UNSAT after 378 node exclusions and 30471 pair exclusions.
On a harder 1252-node domain it reaches a fixed point after 4816 pair exclusions
and proves no contradiction. All 5184 small literal soundness comparisons pass,
and a corrupted zero functional is rejected. These are conditional signature
domains; the exclusions must not be exported as unconditional source-pool cuts.

## Simultaneous matrix blocks and the remaining full case gap

For independent auxiliary vectors U with an explicit dual V, full inverse-basis
expansion gives every entry of the projected Gram identity, not only diagonal
entries. After fixing an anchor, the residual target matrix H is a sum of one
rank-one matrix per free selected pair. Therefore the number of free pairs is
at least rank H.

The 16- and 32-dimensional blocks have residual ranks 16 and 32. The latter forces
at least 33 total partial pairs at anchor 48/48 and rejects all 21 saved smaller
partial witnesses. Physical reconstruction checks the auxiliary duality, target
ranks and 23722 small rank-sum controls. The 343- and 1111-equation native-XOR
comparisons return UNKNOWN. This is a stronger necessary condition, not an
exclusion of that full completion case.

## Other bounded comparisons

Restricting omitted classes to one-bit signatures turns the parity condition
into one compatible choice per required phase. A further survey changes the
witness-selection objective: source orbit 36 has 737 support classes, but only 83
nonunit classes, compared with 207 among the original 518 support classes.
Forty-nine physical single-class unit witnesses give a 132-class lower bound
within the restricted family that retains every nonunit class. This is not
an achievable-cover claim or a bound for other witnesses. Testing all 605
remaining unit-class candidates in this greedy pass gives a separately verified
687-case sufficient cover, worse than 428. Fifty successful anchored certificates
and 290 saved positive partial matchings replay independently; UNKNOWN trials
remain unresolved.

The new primary comparison is Beame and Sun,
[Extending CDCL to Disjunctions of Parity Equations](https://doi.org/10.4230/LIPIcs.SAT.2026.5),
SAT 2026. Their solver learns general parity clauses; the simulation theorem
does not promise that its heuristics solve these source instances quickly.
The pinned development version compiles and its proof control passes our
strict independent parity kernel, including a required terminal contradiction.
The tested compact domain and unrestricted-source projected block return
UNKNOWN at 30 and 45 seconds. No C16 gain is attributed to that software.

The complete 21-page paper is screened for questions. Its four broad or semantic
research directions are recorded as F158 and remain outside the precise-target
denominator, with present-resolution and Lean checks unassessed. Abstract-only
leads stay separate. Inventory deltas are four canonical directions, zero
eligible targets, one paper/full-text screen and zero completed Lean targets.

## The bounded loop stopped after three rounds without a gain

The loop began at 18:08:48 UTC on 28 October 2026, with a 22:08:48 UTC deadline.
Research stopped at 20:17:24 UTC after three consecutive bounded reduction rounds
failed to improve 428: an old-witness unit-only exchange pass, the alternative
witness 36 greedy pass, and an exchange pass forcing restoration of a nonunit
class. The science phase lasted 2 hours 8 minutes 36 seconds; preservation and
independent replay continued afterward. This stopping rule describes a stall
in these tested approaches and does not establish that no further reduction
is possible. No background research continues after closeout.

## Replay and preservation

[verify_anchored_cover_chain.py](verify_anchored_cover_chain.py) reconstructs
all 518400 physical pairings, checks rank 128 and both group generators, verifies
each new class's orbit, regenerates each CNF byte for byte and checks the DRAT
proofs. The existing 497-case base proof is actually replayed. A literal empty
input clause is checked directly; all other successful cases require the
external proof check. The base empty-proof negative control remains active.

[verify_cover_exchanges.py](verify_cover_exchanges.py) additionally verifies
the exchange case split, every restored and new class, and all saved positive
hitting witnesses. Discovery solvers and numerical libraries are unnecessary
for these consumers. Separate consumers check the matrix blocks, affine rules,
new-witness chains and native-parity proof control.

```sh
python formalization/canonical-width/c16/verify_cover_exchanges.py --chain formalization/canonical-width/c16/theory-loop-results/exchange/chain.json --drat-trim /path/to/drat-trim --output /tmp/c16-cover428.json
python formalization/canonical-width/c16/verify_theory_loop.py --output /tmp/c16-rank-and-minimality.json
python formalization/canonical-width/c16/check_theory_controls.py --output /tmp/c16-controls.json
```

| Deliverable | Status | Evidence |
| --- | --- | --- |
| Improve the 497-case cover | Met | Physically replayed 428-case chain |
| Derive a structural shortcut with a useful consequence | Met | New-class normalization and multi-class exchange lemma |
| Check stronger full inverse-matrix necessities | Met with UNKNOWN solver outcomes | Rank 32 target forces 33 partial pairs; no completed source anchor |
| Test a proof-producing algebraic propagation rule | Met | Conditional affine certificates and literal controls |
| Screen newly consulted research | Met | F158 full-text screen and four non-denominator directions |
| Resolve original width or complete a retained full anchor | Not achieved | Width 16/18; physical 88; all 428 full completions open |
| Integrate to master | Pending | PR 17 requires review; no bypass or auto-merge |

**Question answered:** a complete 428-case sufficient cover is proved by the
checked symmetry-normalized exchange chain. The separate rank and propagation
results have the conditional scopes stated above.

**Question still open:** existence of a full 128-pair frame in the original pools,
equivalently the unrestricted width 16/18 question.

**Next proposed target:** follow-up — seek a checked full-case obstruction at
a retained anchor using stronger inverse-matrix information. Further reductions
of the starting list alone do not complete any of the retained full cases or
provide a finishing-time estimate.
