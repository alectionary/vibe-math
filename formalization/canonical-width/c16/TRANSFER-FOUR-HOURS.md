# Four-hour transfer and full-completion gate

Canonical target: `L-F91-c16-unrestricted-width`, follow-up to issue 8
(https://github.com/alectionary/vibe-math/issues/8; read-only).
Session: `c16-transfer-20261029T1930`.
Work branch: `research/c16-transfer-20261029T1930`.
Baseline: `2e2dd2c6cd7598528e38e52cd4d7be2824de8a27`.
Start: 2026-10-29T19:30:58Z. Deadline: 2026-10-29T23:30:58Z.

The user approved this four-hour continuation. The original source question is
width 16 or 18. The sufficient selected-pair cover has 408 cases; the best
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
