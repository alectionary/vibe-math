# Four-hour transfer and full-completion gate

**Paused at the user's request on 2026-10-29. Research processes are stopped.**
The original width question remains16 or18. The verified sufficient cover is
now405; physical88/128 and zero full source anchors solved are unchanged.
[Resume instructions](TRANSFER-RESUME.md) ·
[Verification and explicit gaps](transfer-results/verification.json).

## Results at the pause

The unchanged256-pattern source bank transferred successfully to all three
preselected held-out cases. Both variants in every pair proved UNSAT, with
independent physical source/CNF/ordinary DRAT replay and empty-proof rejection
from clean revision56024d4. The common113-class domain supports the checked
cover induction408→407→406→405; this does not exclude those three pair classes
from every full source frame.

| Selected class | Baseline seconds | Seeded seconds | Baseline refinements | Seeded refinements |
| --- | ---: | ---: | ---: | ---: |
| (6,28,13) |241.74|112.39|1668|763|
| (8,26,1) |93.45|44.67|553|215|
| (32,32,3) |452.38|162.39|3029|1292|

Summed discovery time falls from787.57s to319.46s, a468.12s saving on this
deliberately selected three-case cohort. This is evidence of reuse on the
tested cases, not a population speedup estimate. The roughly563s cost of
original mining and initial checking remains material; no net end-to-end
research-program speedup is claimed. Proof generation and replay are separate
costs. The first baseline completed despite macOS rejecting `time -l`'s memory
query; its original241.74s measurement is retained, memory is unknown, and it
was not rerun. The other five calls use fresh-process resource accounting.
[Frozen comparison](transfer-results/comparison-frozen.json),
[summary](transfer-results/comparison-summary.json),
[clean proof replay](transfer-results/clean-comparison-replay/manifest.json),
[cover induction](transfer-results/cover-bindings.json).

The50-minute unrestricted full-frame trial at anchor(48,48) is UNKNOWN. The
30-minute global necessity model is also UNKNOWN, after3351 partial models.
Its13701 source cuts,331 signature circuits,518400 physical pairings and
final926436-clause CNF replay independently. Neither timeout excludes a full
anchor or settles the source question. The full-anchor input has an independent
new-clause scan and clean scan; its large old theory dependencies retain their
earlier checks rather than claiming a fresh replay of every old record.
[Full trial](transfer-results/full-anchor-trial.json),
[global replay](transfer-results/global-independent.json).

## A strict fourth-order source obstruction

The capacity-child implication below produced no new exclusion on384 canonical
one-deletion subsets. Independent complete support enumeration through4 finds
only eight small supports: two of size3 and six of size4. None contains a child
from the fixed256 bank, or from all1620 previously retained patterns of size≤4.
The other376 subsets have no nonzero detecting support of size≤4. This records
why that bounded composition attempt failed, rather than counting it as a win.

The same analysis exposed a successful direct word-length obstruction. Let
J={Z416,Z512}, L=span(J), and

    w = 0x1040144000000000208004c0.

Among all permitted X vectors annihilating J, the complete set pairing oddly
with w is D={X422,X423,X428,X716}. Literal enumeration of the four elements
of L and257351 distinct pair-sum cosets proves that w modulo L has no
representation by four or fewer permitted Z vectors. A hypothetical full
dual frame containing J expands w modulo L using exactly its selected vectors
from D, hence at most four terms. Contradiction. Therefore J cannot occur in
any full permitted dual frame. Physical pairing symmetry gives16 cyclic
translations and their sector exchanges,32 source clauses.

This subset passes complete order3 and the old unrestricted propagation test.
Independent reversed-basis enumeration replays the entire384-query screen:
exactly this one new exclusion, with explicit short representations for the
other seven small supports. Tiny literal controls check155 full-rank queries,
preserve134 extendible queries, exercise a true support-four obstruction, and
reject172 corrupted certificates. Rank-deficient tiny inputs are separately
excluded and intentionally delegated to the earlier rank oracle.
[Independent screen](transfer-results/four-term-independent.json),
[controls](transfer-results/four-term-controls.json).

A subsequent producer screen completed all16200 cyclic/sector classes of
distinct source pairs in1006.32s. Its four positive word classes independently
replay: (368,589), (368,622), (400,496), (416,512), with orders3,3,3,4.
The already known pair(336,438) is separately rank deficient. The negative
decisions of this larger catalog have not had an independent complete replay;
no extendibility claim follows from non-rejection.
[Positive replay](transfer-results/pair-four-positive-independent.json).

The global trial also supplies a different hard configuration: its first
closure-passing11-pair model has eight sparse certificates, but only two
distinct starting sector sets. Two greedy deletion orders per sector give
four source clauses of sizes8,6,8,6. Independent replay checks the physical
trial binding, every certificate, and28 single deletions. All four smaller
sets pass existing unrestricted propagation and are not syntactically subsumed
by the previous6576-pattern bank. They are not proved globally shortest or
logically independent. [Replay](transfer-results/global-small-independent.json).

## Moment constraints and unfinished work

The new pair forces the averaged moment S0[26,32]=0, whereas the old rational
point has4448187205/137438953472 there. The preceding round's forbidden pair
also separates that point, at S0[25,31]. Separating one point does not prove
the strengthened relaxation infeasible.

More generally, a forbidden m-set J implies, for each a in J,

    sum over b in J\{a} of E[x_a x_b] <= (m-2) E[x_a].

Proof: when x_a=0 both sides vanish; when x_a=1 at most m-2 other members may
be selected. Averaging preserves the inequality. The existing6576 source
patterns plus the new pair give31408 distinct conditioned moment rows. Exact
screening finds47 violations of the old point; the sparse matrix agrees with
the independent rational calculation, and1509 literal Boolean controls check
the implication. [Exact screen](transfer-results/old-point-forbidden-moments.json),
[matrix controls](transfer-results/forbidden-matrix-controls.json).

Two numerical pilots using only the added pair zero faces remain inconclusive.
The first exposed a strict-margin mask issue for symmetric zero entries; the
corrected producer preserves both mirrored zero entries. The corrected
numerical candidate still fails the exact consumer because a local profile
weight is negative. `moment-pair-exact.json.gz` is a rejected candidate, not
a feasible point. Neither numerical status nor failed recovery proves
infeasibility. Both attempts and the correction are retained.

`profile_moment_forbidden.py` is prepared for all conditioned pattern rows but
has never been run. The order-four global producer/consumer are likewise
prepared, with zero-round source/CNF validation still pending. The user paused
before either new campaign. The recommended resumption is a bounded stronger
moment pilot with exact verification, or a frozen global continuation after
validating its new producer/consumer. No automatic resumption is scheduled.

All six cover proofs were clean-replayed. New source-theory and global checks
were separate independent processes; their additional clean-checkout replay
remains pending. No new papers, source questions or Lean completions are
counted. Inventory counts stay424/160/204/165/6; earlier literature/access gaps
remain. The small-control rank-scope correction and a path-normalization fix
affected test/report plumbing, not frozen source results.

## Original answer contract and working argument

Canonical target: `L-F91-c16-unrestricted-width`, follow-up to issue 8
(https://github.com/alectionary/vibe-math/issues/8; read-only).
Session: `c16-transfer-20261029T1930`.
Work branch: `research/c16-transfer-20261029T1930`.
Baseline: `2e2dd2c6cd7598528e38e52cd4d7be2824de8a27`.
Start: 2026-10-29T19:30:58Z. Deadline: 2026-10-29T23:30:58Z.

The user approved this four-hour continuation. At the start, the original source question was
width 16 or 18. The sufficient selected-pair cover had 408 cases; the best
verified physical partial frame has 88/128 pairs; zero full source anchors
are excluded. Cover removals are not full-source anchor exclusions.

Answer contract: the 256 universal small source obstructions discovered in
RELEVANT-CLAUSES.md -> test reuse on three frozen, structurally different
remaining cover cases -> matched inputs, capped baseline/seeded comparisons,
independent source/CNF/proof checks. Repeated benefit justifies a bounded
full-completion trial for one preselected anchor. Otherwise inspect a surviving
configuration for one stronger structural obstruction. A solver timeout is
UNKNOWN. Two UNKNOWN calls do not establish a speedup.

Schedule: first 30 minutes prepare/freeze; next 90 minutes six sequential
discovery calls capped at 900 seconds each; next 60 minutes full-completion or
structural gate; final 60 minutes independent verification and publication.
Earlier completion of a gate advances the next gate without expanding scope.
Do not spend unused time on an unbounded cover-reduction sweep.

Keep the new 256-pattern bank byte-identical. Freeze the cohort before discovery.
Revalidate or omit conditional cuts when the avoidance domain widens. Use a
common domain containing the avoidance domain of any combined proposed cover.
The baseline and seeded variants use identical dynamic separators; their sole
input difference is the new universal bank. Record preprocessing and replay
costs separately from discovery and do not infer a finishing-time bound.

This is a continuation, not a new source target or Lean completion. No broad
literature search, new paper screen, implementation rewrite, issue message,
schedule or sub-agent is planned. Source/library records from previous blocks
remain applicable. Publish through PR 17; required review must not be bypassed.
Acquire a fresh create-only claim before substantial research, and release only
this session's exact expected claim SHA at closeout.

Decisive source endpoints remain a checked physical 128-pair construction or a
complete global nonexistence certificate. A first full-anchor exclusion would
be a stronger milestone than another sufficient-cover removal.

Remote claim confirmed at ownership commit
`5819f0d68c9dcce31657e3c1552521013194cb5c`.
The frozen comparison is commit `424934e`; discovery began at 19:34:25Z.
The common domain has 113 nonzero-signature classes, plus every physical
zero-signature pair. The cohort is (6,28,13), (8,26,1), (32,32,3), selected by
the least individual compatible edge count in three disjoint structural strata.
This is a held-out, deliberately selected cohort, not a random sample. No old
conditional domain cut is imported. Each variant starts with the same 7,474
universal baseline certificate records; only the strengthened variant imports
the unchanged 256-pattern bank. The preselected full-source anchor is (48,48).

## Structural fallback: combine restrictions on detecting vectors

This is a written implication considered while the frozen comparisons run;
its strictness and usefulness on the source remain untested at this stage.

Use the notation of THREE-TERM-CONTINUATION.md: J is a mandatory subset of
the permitted Z basis, L=span(J), D_J(w) is the complete eligible X detecting
pool for w outside L, and ell_J(w) is the least source Z word length modulo L.
Let H be any family of certified forbidden simultaneous-use subsets of X.
Let alpha_H(D) be the largest cardinality of a subset of D containing no
member of H. Then

    ell_J(w) > alpha_H(D_J(w))

implies that no permitted full dual frame can contain J.

Proof: expand w in a hypothetical permitted dual basis and pass to V/L.
The remaining terms correspond exactly to selected X vectors in D_J(w).
Their number is at least ell_J(w), but their set contains no certified
forbidden subset, so its cardinality is at most alpha_H(D_J(w)). Contradiction.
The sector-swapped statement is identical. Its conclusion is an all-negative
source clause, preserved when pairs are deleted. Children in H must already
have independent certificates; a cyclic chain of assumed exclusions proves
nothing. A saved derivation should form a finite directed acyclic graph.

For example, if D has three vectors and a certified forbidden pair or triple,
at most two can be selected. Absence of a two-term representation modulo L
would therefore exclude J even if a three-term representation exists. The
old cardinality-only criterion would accept that particular witness. This is
a conditional example, not yet a source instance or a claim that the complete
old predicate accepts J using every possible witness.

The bounded fallback gate is to find a source certificate of this type that
passes the complete old order-three test and existing propagation. A larger
bank or a restatement of an already detected exclusion would not meet that
strictness gate. No mathematical library import is needed for this implication.
