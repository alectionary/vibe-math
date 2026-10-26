# Unrestricted canonical width of \(C^{\mathrm{LP}}_{16,9}\)

Canonical inventory identifier: `L-F91-c16-unrestricted-width`.

## Follow-up session

This is a follow-up, not a new problem. The 2026-10-26 block recorded an 84-pair partial frame and left \(f\in\{16,18\}\).

- Session: `lf91-c16-answer-20261026T190534Z`
- UTC start: 2026-10-26T19:05:34Z
- Issue: https://github.com/alectionary/vibe-math/issues/3
- Work branch: `cursor/l-f91-c16-unrestricted-width-1697`
- Claim ref: `refs/heads/claims/L-F91-c16-unrestricted-width` (create-only, this commit)
- Authorized by the user to answer Proposition 9. No paper, external post, or `master` push was requested.
- Answer contract: exact value of \(f(C^{\mathrm{LP}}_{16,9})\). Either a checked 128-pair weight-16 canonical basis, or a checked proof that none exists. Mixed Paulis stay in scope through the already recomputed reduction, which still depends on the reproduced weight-17 pool.
- Stopping point: a decisive value of \(f\), or a recorded obstruction that blocks both routes.



Question source: Jong Yeon Lee, arXiv:2610.06820v1, 5 October 2026, Proposition 9, Section IV.4; proof Appendix C.3; construction equation (50) and Appendix D.1.1. HTML https://arxiv.org/html/2610.06820v1, SHA-256 `3e4294e6e8c328eca1de101b04b1ad527e0ddae1fc9bc776e3037328ef22a37f`. Data repository https://github.com/yeon-lee/public-regular-logical-frames at `04ad4795ad15cb89ee47b7868ff925c30b2fc731` (2026-10-06).

## Follow-up obstructions, 2026-10-26

These checks use the saved logical coordinates of the weight-16 pools (720 classes on each side, standard dot product in the width-18 frame basis). They are exact finite computations on that coordinate model. They do not by themselves replace the physical checker, and they do not decide \(f\).

A Z-pool translation orbit can belong to a 128-pair CSS frame only if its 16 translates are independent, the Z-pool vectors orthogonal to the orbit cover the quotient with the orbit, and the X-pool realizes every monomial pairing polynomial against the orbit. Only four orbits pass: the pure monomials on seeds 0, 1, 2, and 3. The other 41 orbits fail the quotient-span test. Seeds 2 and 3 together miss 16 monomial functionals. The joint sets \(\{0,1,2\}\) and \(\{0,1,3\}\) have one and three cyclic partner-orbit choices; every choice leaves a complementary pool whose rank is strictly below the remaining dimension. So no CSS frame contains either of those full triples. Mixed, non-cyclic choices of partner for a single monomial orbit were not all ruled out.

An induced matching of pairs with nonzero \(B\)-components (seeds 4 and 5) is necessary for the block identity \(\sum \beta_j\alpha_j^{\mathsf T}=I_{32}\). OR-Tools CP-SAT 9.15 reports that matching infeasible in three pools: both sides supported only on seeds \(\{4,5,6,7\}\) (2208 candidate pairs); both sides with seed 0 equal to 0 (2576 pairs); both sides with seed 1 equal to 0 (2208 pairs). The same encoder accepts the 16 seed-5 monomials, whose outer products are the seed-5 coordinate projection, so it is not rejecting every partial identity. If every seed-0 monomial is paired with the matching seed-0 plus seed-1 monomial, the remaining carriers cannot realize the \(B\)-identity and the \(C\)-identity together (8352 pairs, infeasible). The global \(B\)-identity instance (43936 pairs) and the global joint \(B\) and \(C\) instance (62112 pairs) returned no decision within 180 seconds.

Inside the quotient seed 0 = seed 1 = 0, the same solver found an induced matching of 56 pairs. Adding the 32 pure monomials on seeds 0 and 1, which commute with that quotient, gives 88 logical pairs with Gram identity. The physical supports are `partial-frame-88.json`. The committed checker reports weight 16, zero syndromes, and Gram identity. This is a larger partial frame than the 84-pair witness. It still does not extend to 128 pairs, and the search did not prove that 56 is the maximum in the quotient.

## Question still open

The unrestricted canonical width \(f(C^{\mathrm{LP}}_{16,9})\) is still either 16 or 18. This block does not decide it. There is no Lean certificate.

A pure CSS width-16 canonical basis would be an admissible unrestricted basis, so it would prove \(f\le 16\). No such 128-pair basis was found. Failure of the searches below is not a proof that none exists. Ruling out only CSS representatives does not prove \(f=18\) unless the mixed-Pauli reduction is accepted.

## Definition used

Frame width, Lee equation (5): the minimum, over physical representatives of complete canonical logical Pauli bases, of the maximum operator weight. A canonical basis is \(2k\) operators in \(k\) anticommuting pairs, with distinct pairs commuting. Mixed Paulis are allowed. No group action is required. Weight is the number of occupied qubits after the binary trace expansion. For this code, \(k=128\), so a canonical basis has 128 pairs. Unrestricted means that a cyclic or other group action is not part of the minimum.

The source hierarchy is \(d\le f_{\mathrm{span}}\le f\le f_{\mathrm{reg}}\le f_{\mathrm{rep}}\). The source states \(f_{\mathrm{span}}=16\) and \(f_{\mathrm{reg}}=18\) for the 16-element cyclic action, and that width 17 reduces to width 16. Those source statements are not re-proved here except for the numerical pieces listed below.

## Code that was rebuilt

\(C^{\mathrm{LP}}_{16,9}\) is the self-adjoint lifted product of the \(3\times 5\) matrix over \(\mathbb F_4[C_{16}]\) in equation (50), with \(P=16\). The coefficient array is \(C=((1,1,1,1,1),(1,1,\omega,0,\omega^2),(1,\omega^2,1,\omega,0))\) and the exponent array is \(E=((0,0,0,0,0),(0,6,12,9,3),(0,12,6,2,14))\). Binary trace uses \(\rho(1)=I\), \(\rho(\omega)=\begin{pmatrix}0&1\\1&1\end{pmatrix}\), \(\rho(\omega^2)=\begin{pmatrix}1&1\\1&0\end{pmatrix}\). Qubit \((2b+t)P+p\) is trace component \(t\) of quaternary block \(b\) at cyclic position \(p\).

`verify_partial_frame.py` rebuilds the balanced checks from those arrays: three binary trace rows per quaternary check, keep the two lightest, tie-break by index, then all 16 translates. It checks 480 rows on each side, maximum check weight 9, rank 480 on each side, \(k=1088-480-480=128\), and CSS commutation. This checker does not import the data repository.

## Checked partial frame

`partial-frame-88.json` is an explicit 88-pair pure-X / pure-Z frame: 32 monomial pairs on seeds 0 and 1, plus a 56-pair induced matching in the complementary quotient. `partial-frame-84.json` is an earlier 84-pair frame. The committed checker reports, for each witness:

- each operator has weight 16 and distinct qubits in \(0,\ldots,1087\);
- every X operator has syndrome 0 against the rebuilt Z checks, and every Z operator has syndrome 0 against the rebuilt X checks;
- the symplectic Gram matrix is the identity;
- the X operators are distinct and the Z operators are distinct.

The 88-pair witness SHA-256 is `814fa6d137f3429b7a2cf34e28c254c0684c1f4441aa0701dc63a2edb68cc987`. The 84-pair witness SHA-256 is `7823c6f7987daa8c35dc96a8f5ec381ead428531df6c129ba5788d63f6cce949`. Checker SHA-256 `169b253e660ebc4111a7afdec2efd6a666f7811269816ac5cf2832e76f91e16f`.

Evidence label: **exact finite computation** on these finite witnesses and the rebuilt checks.

The 88-pair frame improves the 84-pair frame, which improved an earlier 80-pair frame made from the logical monomials on seeds \(\{0,1,3,5,7\}\). It is still a partial frame. It does not answer Proposition 9.

A separate exact computation on the saved logical coordinates of the weight-16 pools, rerun from `/tmp/lf91/best-11.txt`, inverts the 128-column X basis and finds 84 dual vectors in the Z pool and 44 outside it. No Z-pool vector is orthogonal to all 84 of the corresponding X columns, so this particular 84-pair frame does not extend by one more pool pair. That non-extension check is not part of the committed checker. It does not say that every 84-pair partial frame, or some other 128-pair basis, fails.

## Conditional mixed-Pauli reduction

On the rebuilt checks, the released LPQ6 pool has 720 distinct weight-16 pure-Z logical classes and 720 distinct weight-16 pure-X logical classes, each side spanning \(\mathbb F_2^{128}\). The minimum union of one pool-X support and one pool-Z support, over the 45 translation orbits and 16 relative shifts, is \(\mu_{XZ}=26\).

Lee's Appendix C.3 argument then says: a mixed Pauli of weight at most 17 has both CSS component supports inside its own support. Two nontrivial logical components would be pool vectors of weight 16 whose union has size at least 26, which cannot fit in 17 qubits. So at most one component is a nontrivial logical, and multiplying by a stabilizer representative removes the other without raising weight or changing pairings. Every remaining nontrivial pure representative through weight 17 has weight 16. A width-16 or width-17 unrestricted frame would therefore reduce to a pure CSS frame of width 16.

Evidence labels: the counts, syndromes, ranks, and \(\mu_{XZ}=26\) are **exact finite computation**. The reduction itself is a **written proof** from the source, not Lean-checked. It applies to mixed operators only if every logical class of weight at most 17 appears in that pool.

The pool list was reproduced by executing the released enumerator, not by an independent enumerator. Fresh run: `ENUMERATION_COMPLETE W=17 roots=[0,68) children=[0,1073741824) mod(D=-1,M=1,r=0) nodes=56921793 t=54.8`, 45 normalized orbits, `matches_released_pool` true, stabilizer-overlap pruning off. Input SHA-256 `a00f1dac2385856c0fab25f28c04d57729cd1ac79f745ff18e37d03b432137d2`, source SHA-256 `b9f0b5be8e26195af5c37fb45f33c29956653ee028212e58646489caa0b74a8c`, binary SHA-256 `2dcb140e0a388557b7d89b2d3d5ce20de09291485e312872507b6b8b45516ab8`. Completeness still rests on that execution plus the source's Appendix A branching argument. The distance lower bound \(d\ge 16\), and therefore \(f\ge 16\), has the same dependence. A future 128-pair weight-16 frame would give \(f\le 16\) after the same physical checks, without that completeness argument; equality would still need a matching lower bound.

The source's width-18 regular frame was also recomputed from the eight canonical seeds and their 16 translates: Gram identity, zero syndromes, maximum weight 18. That is an exact finite computation of an upper bound \(f\le 18\), including mixed Paulis, because a CSS frame is allowed in the unrestricted minimum.

## Searches that did not decide the question

These are **sampled experiments**. They are not existence proofs and not non-existence proofs.

- Reduced 96-dimensional slice that keeps every seed-0 and seed-1 monomial: a variant-B basis meets its dual pool in 48 of 96 coordinates. A strict local search ran \(4.174\times 10^7\) steps (about 70 seconds) and stayed at 48.
- Full 128-dimensional Sherman–Morrison walks from the monomial-type start, seeds 2 and 3: each reached 84 and not higher, then continued to about \(1.50\times 10^8\) steps (about 388 seconds) with best score 84.
- Steepest sampled ascent, seed 11: reached 84 at step \(3\,047\,964\) and was still at 84 after \(7.9\times 10^7\) steps.
- Iterated local search from that 84-hit basis, kicked back to the incumbent each round: kick size 6, seed 21, about 22,240 kicks; kick size 10, seed 22, about 10,660 kicks; kick size 16, seed 23, about 8,320 kicks. Wall time about four minutes. Best remained 84. Scores after the local climb from a kick were lower, roughly 15–72. The 1500-second caps were not run out; the jobs were stopped for closeout.
- Greedy coloring of the reduced compatibility graph (9600 vertices, one per pool pair with symplectic product 1) used 158 colors. Maximum degree 8354. Since \(158>96\), the coloring does not obstruct a 96-clique.

Block-diagonal comparisons on seeds \(\{2,3\}\), \(\{4,5\}\), and \(\{6,7\}\) miss a phase-3 pair family or the pure seed-6 monomials. Those comparisons obstruct only block-diagonal frames. Cross-support vectors are present in the pools, and the 84-pair frame already uses some of them.

No linear, affine, augmentation, or \(\varepsilon\)-adic obstruction was found. Those negative searches are **search leads / unresolved**.

## Re-screen

The same HTML text was read again on 2026-10-26. The author-posed questions and directions already inventoried from this source remain the six targets harvested on 2026-10-25: unrestricted widths of \(C_{16,9}\) and \(C_{20,10}\), the 1024-qubit PP joint parameters, a non-Abelian common action, rate-distance-frame design, and measurement interfaces. No additional author-posed question was found. Cohort delta of this block: 0 canonical entries, 0 eligible targets, 0 completed Lean targets. \(C_{20,10}\), the PP family, and frame-design theory were not investigated.

Our follow-up `RQ-F91-c16-css-frame` is a project-derived search task. It is not an author-posed question and is outside the coverage denominator.

## Evidence

| Claim | Label |
|---|---|
| Rebuilt checks: 480 rows, weight at most 9, rank 480, \(k=128\), CSS commutation | Exact finite computation |
| 88-pair witness: weight 16, zero syndromes, Gram identity | Exact finite computation |
| 84-pair witness: weight 16, zero syndromes, Gram identity | Exact finite computation |
| That 84-pair frame has no extending Z vector in the saved pool | Exact finite computation (scratch coordinates; not the committed checker) |
| Pool sizes, span rank 128, \(\mu_{XZ}=26\), width-18 translate frame | Exact finite computation |
| Released enumerator reproduces 45 orbits through weight 17 | Exact finite computation of that program, not an independent enumerator |
| Mixed width \(\le 17\) reduces to CSS width 16 | Written proof (source Appendix C.3), numerical hypotheses recomputed; not Lean |
| Local search and 158-coloring | Sampled experiment |
| No width-16 canonical basis exists | Not established |
| \(f=16\) or \(f=18\) | Not established |
| Lean certificate | None |

## Coordination and searches

- Issue: https://github.com/alectionary/vibe-math/issues/3
- Work branch: `cursor/l-f91-c16-unrestricted-width-1697`
- Claim ref: `refs/heads/claims/L-F91-c16-unrestricted-width` was created at `d417d1c9f811523120aa70caff10d517ed2af491`. Closeout read that SHA back and deleted the ref with `--force-with-lease` on that expected SHA. A following read-back was empty. The work branch remains.
- Issue comment on #3 is pending. `gh issue comment` and the issues comments API returned HTTP 403, `Resource not accessible by integration`. The result text is in this note and in pull request #4.
- Session: `lf91-c16-20261026T174815Z-f4663e80`. Authorized start 2026-10-26T17:47:00Z. Deadline 2026-10-26T21:47:00Z.
- X public search, `search_posts_all`, no posts written. Known-positive query `lifted product` returned posts. Query `"canonical width" OR "unrestricted canonical" OR C16,9 OR "1088,128,16"` returned result count 0. Query `2610.06820 OR "public-regular-logical-frames" OR "canonical frame width"` returned result count 0. A zero count is not a global absence.
- GitHub issues before this block: #1 (`L-F25`, open) and #2 (`L-P09`, closed). No earlier claim ref for this target.
- GitHub issue search for `L-F91-c16-unrestricted-width` in `alectionary/vibe-math` returns only issue #3.
- GitHub code search for `canonical frame width` at 18:51:36Z returned graphics and layout files (pixel frame width). None concern this code or Proposition 9.
- GitHub code search for `LPQ6` at 18:52:38Z returned the author's `VERIFYING.md` replay command and unrelated string matches. The returned page does not contain an independent determination of \(f\).
- GitHub code search for `unrestricted canonical width` still returned HTTP 429 at 18:51:26Z (retry-after about 737 seconds), and `public-regular-logical-frames` returned HTTP 429 at 18:52:38Z. Those two queries are unassessed, not empty. An earlier `C16,9` code search also returned HTTP 429.

## Next proposed target

Follow-up, not a new problem: decide whether the 720-class weight-16 CSS pools contain a 128-pair canonical frame, by an exact search that is not confined to the 84-pair basin or by a proof that every dual basis meets a forbidden family. Do not move on to \(C_{20,10}\) or the 1024-qubit PP family while this gap is open.
