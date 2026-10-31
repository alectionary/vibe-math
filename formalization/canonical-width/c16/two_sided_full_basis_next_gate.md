# Next gate: two full bases with a shared 2X+2Z pattern

**Claim.** The existing 7,211-feature functional has exact support over a stronger relaxation by maximizing over all 16 anchor patterns and, for each pattern, solving two independent signed linear-matroid basis problems with mandatory owner choices. This establishes a possible exact separation oracle, not membership of any current point or completion to a source frame. No new search was run for this note.

The existing quads are X[80,512]/Z[186,433] and X[80,432]/Z[186,514]. Both count-only extensions at witness 12 now have independent exact membership receipts (`two-sided-count-32x27-exact-v4-independent.json` and `two-sided-count-27x32-exact-v2-independent.json`). Those certificates omit physical zero-pool independence. They do not establish the proposed stronger membership, and they do not transfer to later points.

## Exact domains for a fixed pattern

Let the four-bit pattern m specify which designated anchors occur. On each sector separately, let F be its selected anchors, D its absent anchors, and W the selected opposite-sector anchors. Put k=|W| and d=128. Use physical GF(2) pairing coordinates. For a candidate vector v, its signature is the k-bit evaluation on W. A compatible basis contains d−k zero-signature vectors and exactly one vector from every unit-signature bin; all multibit vectors are excluded.

The following conditions and operations define the complete domain for that sector:

1. Reject dependent W. Delete D from every bin. Reject any forced member of F with a multibit signature. In each unit bin, reject two forced members; one forced member fixes the bin, while an unoccupied bin requires a nonempty remaining pool. The requirement is one owner even when all weights are negative.
2. Let F0 be the forced zero-signature vectors. Reject dependent F0. Contract F0 in the restricted zero-pool matroid: initialize binary elimination with F0 and greedily add free zero vectors until the total zero rank is d−k. Reject the domain if the zero pool after deletion, together with F0, has rank less than d−k. This jointly contracts all forced zero anchors; independently handling each anchor can miss a dependency.
3. Include F0's weight as a constant. Choose the maximum signed weight element in each unoccupied unit bin, include each fixed owner, and maximize the remaining contracted zero-basis weight by matroid greedy. Complete the full required rank, retaining negative weights.

These conditions are sufficient for the sector's relaxed basis domain. In any linear dependence among the chosen vectors, evaluation on W first forces every owner coefficient to vanish; independence of the zero basis then forces all remaining coefficients to vanish. Thus the output is a physical rank-128 basis containing every selected same-sector anchor and no absent anchor. Conversely, every basis satisfying the anchor-owner constraints has exactly this decomposition. Run this construction in both directions, swapping physical pools for the X optimization. A pattern is feasible only if both domains are feasible.

## Why the objective separates

Keep the literal layout already used by `two_sided_anchor_count.py`:

`1, P[4], PP[6 lex], U[X720,Z720], P_U[4,1440].ravel(C)`.

For coefficients c and fixed m, define

```
kappa(m) = c[0] + sum_i c[1+i] m_i
                   + sum_{i<j} c[PP(i,j)] m_i m_j
w_m(u) = c[11+u] + sum_i m_i c[1451+1440*i+u].
```

The exact support is

```
H(c) = max_feasible_m { kappa(m) + h_X,m(w_m[0:720])
                                  + h_Z,m(w_m[720:1440]) }.
```

There are no products of two unanchored selection variables in these features. Once m is fixed, every anchor/full-pool product is linear in that pool's selection, so the feasible relaxed choices and their objective separate. Forced anchor weights are included once in the corresponding sector support; the additional P/PP feature terms remain in kappa. Repeated coordinates in the feature map are intentional literal identities. Arbitrary additional unanchored X/Z products would invalidate this decomposition.

## Source bridge and its limit

Every physical dual frame supplies a pattern m and two physical bases in the domains above: each selected anchor has exactly one opposite owner. Thus every source frame obeys `c·feature <= H(c)`. Apply that inequality to each of its 32 rotation/sector images and average. The existing p/S/T map has factor **one** for all 7,211 coordinates, including phase reversal, same-variable identities, and sector exchange. Fixed physical anchors require all 16 patterns; no 291-profile reduction applies.

Conversely, independent choices of the two relaxed bases need not be mutually dual: pairings between unanchored X and unanchored Z vectors remain unrestricted. Even exact membership in this two-basis hull would not give a source frame or decide a cover case. Within each fixed pattern, separate exact basis distributions can be coupled by their product because only anchor/full-pool moments are retained. That product is valid for this relaxation, not generally for the source. A source-case obstruction still needs a necessary case model and an exact infeasibility certificate; averaging does not justify fixing the original four anchor bits to one.

## Bounded implementation and acceptance gate

Use new producer/consumer files. Reuse the layout, target translation, and row compiler ideas from `two_sided_anchor_count.py`; independently rebuild them as in `verify_two_sided_anchor_count.py`. `full_partner_basis_oracle.py` supplies the zero/unit theorem and arbitrary-pool constructor. `full_partner_anchor_basis_oracle.py` supplies one-anchor contraction/deletion controls, but its API handles only one same-sector anchor and is not itself a complete two-anchor implementation. The existing literal physical reader and separate GF(2) rank verifier provide source coordinates and independent elimination.

Before any master run, require: exhaustive tiny two-sector comparisons against all basis pairs for every pattern; dependent forced-zero, forced-owner collision, selected multibit, empty-owner, and deletion-induced rank-deficiency controls; all-negative/tied/fractional weights; zero/one/two forced-zero cases; exact 128-vector rank and anchor-state replay on both sectors; independent signed greedy upper bounds using contraction prefix ranks; and corrupted rank, owner, absent-anchor, bound, and coefficient rejection. Recheck all 7,211 target coordinates under literal 32-action averages, including phase>8 and self-products. Bind the current physical source and a passing symmetry bridge, not only a stale receipt path.

For a candidate cut, retain both physical maximizing bases and exact bound data for every feasible pattern, plus independently certified exclusions for every rejected pattern. Check exact positive target gap, exact integer owner-row translation, and numeric-range guards before any int64 cast. For a membership claim, require an exact nonnegative mixture with every feature equation and both physical basis ranks replayed. A numerical no-cut or small residual remains inconclusive. The immediate next gate is the new 16-pattern oracle and its independent controls; no runtime prediction or solved-source claim follows from this design.
