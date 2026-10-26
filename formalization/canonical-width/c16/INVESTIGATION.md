# Unrestricted canonical width of \(C^{\mathrm{LP}}_{16,9}\)

Canonical inventory identifier: `L-F91-c16-unrestricted-width`.

## Follow-up session

This is a follow-up, not a new problem. The 2026-10-26 block recorded an 84-pair partial frame and left \(f\in\{16,18\}\).

- Session: `lf91-c16-answer-20261026T190534Z`
- UTC start: 2026-10-26T19:05:34Z
- Issue: https://github.com/alectionary/vibe-math/issues/3
- Help request, opened at closeout: https://github.com/alectionary/vibe-math/issues/8
- Work branch: `cursor/l-f91-c16-unrestricted-width-1697`
- Claim ref: `refs/heads/claims/L-F91-c16-unrestricted-width` (create-only, this commit)
- Authorized by the user to answer Proposition 9. No paper, external post, or `master` push was requested.
- Answer contract: exact value of \(f(C^{\mathrm{LP}}_{16,9})\). Either a checked 128-pair weight-16 canonical basis, or a checked proof that none exists. Mixed Paulis stay in scope through the already recomputed reduction, which still depends on the reproduced weight-17 pool.
- Stopping point: the user ended this block on 2026-10-26 before a decisive value of \(f\). The handoff is below. Do not treat the unfinished 12-monomial search as a non-existence proof.



Question source: Jong Yeon Lee, arXiv:2610.06820v1, 5 October 2026, Proposition 9, Section IV.4; proof Appendix C.3; construction equation (50) and Appendix D.1.1. HTML https://arxiv.org/html/2610.06820v1, SHA-256 `3e4294e6e8c328eca1de101b04b1ad527e0ddae1fc9bc776e3037328ef22a37f`. Data repository https://github.com/yeon-lee/public-regular-logical-frames at `04ad4795ad15cb89ee47b7868ff925c30b2fc731` (2026-10-06).

## Follow-up obstructions, 2026-10-26

These checks use the saved logical coordinates of the weight-16 pools (720 classes on each side, standard dot product in the width-18 frame basis). They are exact finite computations on that coordinate model. They do not by themselves replace the physical checker, and they do not decide \(f\).

A Z-pool translation orbit can belong to a 128-pair CSS frame only if its 16 translates are independent, the Z-pool vectors orthogonal to the orbit cover the quotient with the orbit, and the X-pool realizes every monomial pairing polynomial against the orbit. Only four orbits pass: the pure monomials on seeds 0, 1, 2, and 3. The other 41 orbits fail the quotient-span test. Seeds 2 and 3 together miss 16 monomial functionals. The joint sets \(\{0,1,2\}\) and \(\{0,1,3\}\) have one and three cyclic partner-orbit choices; every choice leaves a complementary pool whose rank is strictly below the remaining dimension. So no CSS frame contains either of those full triples. Mixed, non-cyclic choices of partner for a single monomial orbit were not all ruled out.

An induced matching of pairs with nonzero \(B\)-components (seeds 4 and 5) is necessary for the block identity \(\sum \beta_j\alpha_j^{\mathsf T}=I_{32}\). OR-Tools CP-SAT 9.15 reports that matching infeasible in three pools: both sides supported only on seeds \(\{4,5,6,7\}\) (2208 candidate pairs); both sides with seed 0 equal to 0 (2576 pairs); both sides with seed 1 equal to 0 (2208 pairs). The same encoder accepts the 16 seed-5 monomials, whose outer products are the seed-5 coordinate projection, so it is not rejecting every partial identity. If every seed-0 monomial is paired with the matching seed-0 plus seed-1 monomial, the remaining carriers cannot realize the \(B\)-identity and the \(C\)-identity together (8352 pairs, infeasible). The global \(B\)-identity instance (43936 pairs) and the global joint \(B\) and \(C\) instance (62112 pairs) returned no decision within 180 seconds.

Inside the quotient seed 0 = seed 1 = 0, the same solver found an induced matching of 56 pairs. Adding the 32 pure monomials on seeds 0 and 1, which commute with that quotient, gives 88 logical pairs with Gram identity. The physical supports are `partial-frame-88.json`. The committed checker reports weight 16, zero syndromes, and Gram identity. This is a larger partial frame than the 84-pair witness. It still does not extend to 128 pairs, and the search did not prove that 56 is the maximum in the quotient.

## Seed-4 monomials cannot all lie in a CSS frame

Logical coordinates are 128-bit vectors in the width-18 frame basis, eight seeds of 16 bits, saved in `pools/xcoords.txt` and `pools/zcoords.txt`. Seed 4 is bits 64 through 79. The X pool contains exactly one pure monomial on each of those 16 coordinates. The Z pool contains none. For each seed-4 bit there are exactly three Z-pool vectors whose seed-4 block is that monomial and which anticommute with the matching X monomial. Up to translation they are the three normalized partners

- seeds 4 and 5 only, with seed-5 polynomial \(t^{13}\);
- monomials on seeds 0, 1, 4, and 5;
- the weight-20 vector supported on all eight seeds.

Any CSS canonical frame that contains all 16 seed-4 X monomials must pair them with one of these three partners per bit: the full Gram identity forces the partner's seed-4 block to be exactly that monomial. Those 16 partners are linearly independent because their Gram matrix against the monomials is \(I_{16}\), so their common orthogonal has dimension 112. The other 112 basis vectors would have to be chosen from the X pool inside that orthogonal. `monomial_rank.cpp` evaluates the rank of that pool for every one of the \(3^{16}=43046721\) partner assignments. The visit count equals \(3^{16}\). The maximum rank is 109, which is less than 112. Therefore no width-16 CSS canonical frame contains every seed-4 X monomial.

Evidence label: **exact finite computation**. An independent Python rank on the three uniform assignments returns \((80,61)\), \((224,96)\), and \((272,96)\) for (pool count, rank), and the hill-climbed assignment \((2,1,2,2,1,2,2,1,2,1,1,2,1,2,2,1)\) returns rank 109. The C++ scan starts at the all-type-0 assignment with rank 61 and never exceeds 109. The same three uniform frames that do extend to a 32-pair block-\(B\) dual basis, by pairing the complementary seed-5 monomials with X vectors of seed-5 block a single bit, still leave an orthogonal X pool of rank 80.

## Thirteen, fourteen, or fifteen seed-4 monomials also fail

The same partner list is forced for any subset of the monomials. If a frame contains \(m\) of them, those partners are independent, the complementary X pool has to span a space of dimension \(128-m\), and the Z pool orthogonal to those monomials has to supply a dual basis of that space. Translation preserves the pools and the dot product, because it rotates every 16-bit seed by the same amount. So it is enough to omit one fixed bit when \(m=15\), and to omit a pair at cyclic distance \(1,\ldots,8\) when \(m=14\).

For \(m=15\), `seed4_fifteen.cpp` visits all \(3^{15}=14348907\) partner assignments with bit 0 omitted. The visit count matches. The maximum orthogonal X rank is 113, equal to the required dimension, and exactly nine assignments attain it:

`*212022112122120`, `*212122112122120`, `*212212122102121`, `*102112122022121`, `*102112122122121`, `*202112122122121`, `*202212122122121`, `*112122122220102`, `*202112021112122`.

A star is the omitted bit and a digit is the partner type in pool order. For each of the nine, the quotient search exhausts with no dual basis. An independent Python transcription of that search reproduces the nine node counts \(203,128,1208,292,766,124,124,146,178\) and also finds no basis.

For \(m=14\), the same program visits \(3^{14}=4782969\) assignments in each of the eight distance classes. Every visit count matches. The classes, written as the omitted-bit mask, and the number of assignments whose orthogonal X rank equals 114, are:

| Omitted bits | Mask | Full-rank assignments |
|---|---|---|
| \(\{0,1\}\) | 3 | 346 |
| \(\{0,2\}\) | 5 | 589 |
| \(\{0,3\}\) | 9 | 108 |
| \(\{0,4\}\) | 17 | 193 |
| \(\{0,5\}\) | 33 | 880 |
| \(\{0,6\}\) | 65 | 107 |
| \(\{0,7\}\) | 129 | 138 |
| \(\{0,8\}\) | 257 | 569 |

That is 2930 full-rank assignments. Each quotient search exhausts. Most trees die within \(10^5\) nodes on the X-rank test alone. Thirty-six trees were rerun with the additional Z-rank test; the largest of those used 17623 nodes. None returns a dual basis. Python reproduces the node counts on the trees of sizes 26, 171, 50, 1649, and 302.

For \(m=13\) there are 35 rotation orbits of omitted triples. Each orbit has \(3^{13}=1594323\) partner assignments, and every visit count matches. Every orbit attains orthogonal rank 115. Together they contain 96807 full-rank assignments, between 399 and 6760 in an orbit. The quotient search finds no dual basis. One assignment, `*1*212112112*211`, uses 318114 nodes; the other 96806 finish under 200000. Python reproduces the node counts 2 and 49 on two of those trees.

Therefore no width-16 CSS canonical frame contains 13, 14, 15, or 16 of the seed-4 X monomials. Frames that use 12 or fewer of them are not settled by this count. The C++ sources under `search/` are the earlier sampled climbers. They read the same pool files and do not decide \(f\).

## Twelve seed-4 monomials, stopped unfinished

There are 116 rotation orbits of 4-subsets of the 16 seed-4 bits. With a zero node cap, `seed4_fifteen.cpp` ranked every orbit. Each orbit has \(3^{12}=531441\) partner assignments, and every visit count matches. Every orbit attains orthogonal X rank 116, the dimension a 12-monomial frame needs, so rank is not an obstruction. There are 1008952 full-rank assignments, from 1035 to 17143 in an orbit.

The quotient search used the binary `complete_z` built at 2026-10-26T21:45:34Z, before the closeout edit of the same source, with a cap of 300000 nodes on four cores. It was killed at 2026-10-26T23:40:28Z. A finished orbit is one whose DEAD, CAPPED, and FOUND lines add up to its full-rank count and whose process exit is 2 or 3. Exit 143 is a killed process. The accounting is `seed4-twelve-partial.json`.

- 33 orbits, containing 319061 full-rank assignments, exhaust with no dual basis.
- 48 further orbits were searched to the end of their assignment lists and contain 98 assignments that hit the cap, plus 545321 that died under it.
- 7 orbits were interrupted, including 2 assignments that had already hit the cap. Rerun those orbits. Their partial logs are not a finished proof.
- 28 orbits, containing 102838 full-rank assignments, were not started.
- The logs contain no FOUND line. The 100 capped type strings are `seed4-twelve-capped.txt`.

Evidence label: the rank scan, and the exhaustion of those 33 orbits, are **exact finite computation**. The capped, interrupted, and unstarted orbits are **not established**. Together they do not prove that every 12-monomial frame fails, and they do not exhibit a frame.

Rank-log mtimes run from 2026-10-26T21:57:37Z through 2026-10-26T22:02:35Z. The four quotient sessions were created at 2026-10-26T22:05:35Z and killed at 2026-10-26T23:40:28Z, about 95 minutes of wall time.

The closeout source rejects a branch when the pairs already chosen and the surviving pool cannot span the quotient, and it stores 1024 indices instead of 512. The filtered 12-monomial pools have at most 338 X vectors and 378 Z vectors, so the older 512-bit sets were large enough for the run above. The new binary was not used for those counts. Its self-test passed. On three trees the older search had called dead, it also returns dead, in 2, 49, and 108 nodes. The third tree is the 15-monomial assignment `*212022112122120`, which took 203 nodes under the weaker pool-rank prune.

## Question still open

The unrestricted canonical width \(f(C^{\mathrm{LP}}_{16,9})\) is still either 16 or 18. No width-16 CSS frame contains 13 or more of the seed-4 X monomials. Thirty-three orbits of the 12-monomial case are impossible, and the other 12-monomial orbits are unfinished. Frames using fewer than 12 monomials, the global matching, and the conditional mixed-Pauli reduction remain open. There is no Lean certificate.

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
| No width-16 CSS frame contains 16 seed-4 X monomials | Exact finite computation |
| No width-16 CSS frame contains 15 seed-4 X monomials | Exact finite computation |
| No width-16 CSS frame contains 14 seed-4 X monomials | Exact finite computation |
| No width-16 CSS frame contains 13 seed-4 X monomials | Exact finite computation |
| Every 12-monomial orbit attains orthogonal rank 116; 1008952 full-rank assignments | Exact finite computation |
| 33 of 116 twelve-monomial orbits have no quotient dual basis | Exact finite computation |
| The other 83 twelve-monomial orbits | Not established |
| No width-16 canonical basis exists | Not established |
| \(f=16\) or \(f=18\) | Not established |
| Lean certificate | None |

## Coordination and searches

- Issue: https://github.com/alectionary/vibe-math/issues/3
- Help request: https://github.com/alectionary/vibe-math/issues/8
- Work branch: `cursor/l-f91-c16-unrestricted-width-1697`
- Claim ref: `refs/heads/claims/L-F91-c16-unrestricted-width` was created at `d417d1c9f811523120aa70caff10d517ed2af491` and released at the first closeout. This follow-up recreated it at `773fe8976c8c90345c81148fe33d1abdc15fac1d`. Closeout read that SHA back, deleted the ref with `--force-with-lease` on it, and a following read-back was empty. The work branch remains at `20dc4d0a261403e22317fdee7934b5fb91b06941`.
- Issue comment on #3 returned HTTP 403, `Resource not accessible by integration`, both in the first closeout and at this handoff. The result text is in this note and in pull request #4.
- Session: `lf91-c16-20261026T174815Z-f4663e80`. Authorized start 2026-10-26T17:47:00Z. Deadline 2026-10-26T21:47:00Z.
- X public search, `search_posts_all`, no posts written. Known-positive query `lifted product` returned posts. Query `"canonical width" OR "unrestricted canonical" OR C16,9 OR "1088,128,16"` returned result count 0. Query `2610.06820 OR "public-regular-logical-frames" OR "canonical frame width"` returned result count 0. A zero count is not a global absence.
- GitHub issues before this block: #1 (`L-F25`, open) and #2 (`L-P09`, closed). No earlier claim ref for this target.
- GitHub issue search for `L-F91-c16-unrestricted-width` in `alectionary/vibe-math` returns only issue #3.
- GitHub code search for `canonical frame width` at 18:51:36Z returned graphics and layout files (pixel frame width). None concern this code or Proposition 9.
- GitHub code search for `LPQ6` at 18:52:38Z returned the author's `VERIFYING.md` replay command and unrelated string matches. The returned page does not contain an independent determination of \(f\).
- GitHub code search for `unrestricted canonical width` still returned HTTP 429 at 18:51:26Z (retry-after about 737 seconds), and `public-regular-logical-frames` returned HTTP 429 at 18:52:38Z. Those two queries are unassessed, not empty. An earlier `C16,9` code search also returned HTTP 429.

## Next proposed target

The user ended this block. The next useful piece is still the same question, not a new problem: finish the 12-monomial quotient, including the 100 capped assignments at a higher node cap, and then either continue to fewer monomials or replace the ladder with an argument that covers them. Do not move on to \(C_{20,10}\) or the 1024-qubit PP family while \(f\) is still open. This session does not hold the claim after closeout.
