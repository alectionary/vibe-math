# Three-term quotient obstruction: bounded continuation

Canonical target: `L-F91-c16-unrestricted-width`, existing issue8 (read-only).
Session: `c16-three-term-20261029T1448`.
Work branch: `research/c16-three-term-20261029T1448`.
Prepared at2026-10-29T14:48Z; interrupted before claiming or beginning experiments.
Research resumed at2026-10-29T17:00:28Z.
Baseline:9d9977b2e4134bb4f3a50177f0e0f12545e4150f.

This is a follow-up to the proposed three-term gate in STRATEGY-REASSESSMENT.md.
The source question remains whether the unrestricted canonical width of the
fixed source C16 code is16 or18. The independently checked sufficient cover
has409 selected-pair cases, the physical partial frame has88/128 pairs, and no
full source anchor is solved. The independent source-pool enumeration and
mixed-Pauli reduction are preserved; no source Lean completion is claimed.

Question/source → intended answer → decisive evidence: determine whether the
general short-word lemma at order3 gives source obstructions missed by the
order2 implementation, then test whether those obstructions reduce a frozen
compact necessity model. An algebraic certificate must be checked independently;
any cover removal additionally requires regenerated ordinary CNF/DRAT proof and
the existing cover-domain induction. A128-pair physical construction or complete
global nonexistence proof would answer the original question.

For selected opposite vectors J, let L=span(J). If w+L has no representation
using at most d source vectors, a full dual basis containing J must have at
least d+1 selected detecting vectors outside J. If the complete detecting pool
has at most d vectors, J is impossible. Such an all-negative exclusion survives
deleting pairs. At d=3, exact pair-sum tables test three-term membership by
scanning single labels. The new work must also search detecting supports of
size3; changing the membership test alone cannot strengthen the old size2 gate.

Bounded plan and stopping rule:

1. Implement the size3 detecting-support and quotient-membership test, and check
   it against exhaustive small controls and an independent Python consumer.
2. Freeze a retrospective source cohort and a deterministic generated cohort;
   compare order2 and order3 on the same inputs. Distinguish a stronger source
   predicate from new full-case progress.
3. If the gate produces independently verified new source obstructions, run at
   most three frozen600-second compact refinement tests, each with a bounded
   ordinary proof/replay budget. Otherwise stop the route with its precise
   negative result. Do not launch an unbounded exhaustive full-frame search.
4. Preserve positive controls, unsuccessful trials, source hashes, inventory
   scope, and clean replay. Update PR17 through the existing review process and
   release only this session's exact claim. No issue messages, auto-merge,
   schedules or sub-agents are authorized by this note.

No new paper is needed to state this elementary extension. Previously inspected
literature and its reading limits remain in strategy-results/literature-ledger.json.
Any additional paper consultation must be recorded and screened at its actual
reading scope. The bounded GitHub source/ownership check finds no intervening
PR or master change. Authenticated X coverage remains unperformed.

## Written proof of the obstruction

Let V be a finite-dimensional binary vector space with a nondegenerate pairing.
Let X and Z be the complete permitted pools in the two sectors. A completion is
an ordered pair of bases (x_i), (z_i), with each vector in its corresponding pool
and with <x_i,z_j> = delta_ij. Fix an independent subset J of the Z pool and put
L = span(J). The question is whether the Z basis of a completion can contain J.
For w outside L, define

- D_J(w) = {x in X : <x,z> = 0 for every z in J, and <x,w> = 1};
- ell_J(w) as the least number of permitted Z-pool vectors whose sum belongs to
  w + L (infinity if there is no such sum).

**Obstruction.** If |D_J(w)| < ell_J(w), no completion contains J.

**Proof.** In a purported completion write w = sum_i <x_i,w> z_i. After passing
to V/L, the terms z_i in J disappear. Every remaining x_i is orthogonal to J,
so the number of nonzero remaining terms is at most |D_J(w)|. These remaining
z_i are permitted source vectors representing w + L. This contradicts the
strict inequality. The sector-swapped statement follows identically. The
clause excluding simultaneous selection of J is all negative, so it survives
any subsequent deletion of selected pairs. This is a written argument, not a
Lean-certified source theorem.

The implemented certificate has q = |D_J(w)| <= 3 and checks ell_J(w) > q.
It is important to compare with the **actual** support size q: a singleton
support only requires ruling out one-term representations. It does not require
ruling out two- or three-term representations.

## Complete discovery through support size three

Let U = span(X intersect J-perp). If dim(U) < dim(V)-|J|, choose
w in U-perp outside L. Then D_J(w) is empty and the obstruction already holds.
Otherwise U = J-perp. Choose a basis b_1,...,b_r from the eligible X pool, with
r = dim(V)-|J|, and dual representatives w_i satisfying <b_j,w_i> = delta_ij.
Modulo L, these representatives parameterize every functional on U.

Express each nonbasis eligible source vector in the b_i basis. Let s_i be the
binary column recording its i-th coefficient across all these nonbasis vectors.
For a subset T of basis indices, the detecting support of sum_{i in T} w_i has
size

    |T| + weight(XOR_{i in T} s_i).

Thus every possible support of size at most three is found by checking:

- one index i with weight(s_i) <= 2;
- two indices i,j with weight(s_i XOR s_j) <= 1;
- three indices i,j,k with s_i XOR s_j = s_k.

The final condition uses a hash table of the columns and O(r^2) lookups, plus
emitted matches and quotient-membership checks. It does not enumerate all
possible source bases. In particular, checking only individual dual rows of one
chosen basis is incomplete even at order two. The new routine checks all three
forms and uses the actual support size for each quotient test.

For the opposite quotient labels S = {0} union {z+L : z in Z}, a target t has
length at most two exactly when t is in S+S. It has length at most three exactly
when (t+S) intersects S+S. The native implementation forms a pair-sum table
lazily. The independent certificate consumer instead checks that the translated
pair-sum set t+(S+S) is disjoint from S. Both permit repetitions; over F2 this
is equivalent to permitting a smaller number of distinct terms. Including zero
accounts for all lengths below the bound.

These arguments establish completeness **for this obstruction criterion at
orders at most three**, for a fixed J. Failure to find an obstruction is not a
completion theorem.

## Controls and frozen source gate

The small controls passed 2,019 native-versus-literal existence comparisons and
544 independently checked certificates. Each sampled small-pool query exhausts
all binary witness vectors. Known identity dual frames remain accepted. Four
explicit examples distinguish order three from complete order two, including
nonempty J and a direct-sum extension. Adding the missing unit vectors restores
a known completion. This prevents a vacuous test that rejects every pool.

The source cohort was frozen before the matched comparison. It consists of
2,561 saved partial candidates and 512 deterministically generated compatible
partial matchings (seed 202610291700, target sizes two through nine).

| Frozen cohort | Old fundamental-row gate | Complete order two | Complete order three |
|---|---:|---:|---:|
| Saved candidates, 2,561 | 2,561 rejected | 2,561 rejected | 2,561 rejected |
| Generated candidates, 512 | 237 rejected | 243 rejected | 262 rejected |

The 19 strict three-term improvements were independently verified, including the
absence of any order-two obstruction for those same partial matchings. The
independent gate reconstructed every one of the 3,073 physical matchings using
a different residual basis order and low-pivot elimination, and checked 27
emitted new certificates. Its receipt is `three-term-results/sparse-gate-independent.json`.
The six improvements over the old implementation are not all attributed to a
single mechanism: complete enumeration, use of the actual support size, and the
old output cap can all matter.

This is a stronger source obstruction, not 19 removed cover classes. No
probabilistic population estimate or general solver-speedup claim is made from
this deterministic cohort.

A post-gate overlap diagnostic checked exactly those 19 strict improvements
against the existing unrestricted mandatory-vector propagation, without changing
the frozen cohort. **All 19 pass both individual-sector propagation and joint
propagation.** Thus the new certificates add information beyond both the complete
two-term criterion and the existing unrestricted closure. This remains a local
nonextendibility result. The diagnostic is independently replayed in
`three-term-results/sparse-propagation-overlap.json` (412 physical forced-coloop
covectors checked). Its required subsets have four, five or six selected pairs.

For a faithful future Lean interface, the lemma quantifies over a finite binary
vector space, a nondegenerate bilinear pairing, two finite source pools, an
independent subset J of the opposite pool and a vector w outside its span.
The conclusion is absence of **any** pair of source-pool dual bases containing J
when the full eligible detecting support is smaller than the minimum quotient
word length. The source-pool completeness bridge and the 128-dimensional C16
application remain separate obligations. Neither this interface nor the full
source question is claimed as completed Lean work in this block.
