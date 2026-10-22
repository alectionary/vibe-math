# Lean formalization search and comparison of proofs

Checked October 21, 2026. **No earlier matching Lean statement or complete proof was identified in this bounded search. Our induction is an elementary matrix presentation of a special case of an established perturbation principle.** Neither first formalization nor a new proof principle is established.

## Search for existing Lean artifacts

The [search record](formalization-priority-search.json) includes public GitHub code queries, their returned file paths and pinned URLs, local searches at recorded repository revisions, and semantic comparisons of selected candidates. Exact names were supplemented by equivalent formulations: binary convolution rank, elementary abelian group algebras, augmentation ideals, flatness, exact zero divisors, and commuting nilpotent perturbations.

Local searches covered 16,263 Lean files in the existing pinned checkouts of mathlib4, formal-conjectures, TauCeti and terracini-lean. Mathlib4, formal-conjectures and terracini-lean have complete source scopes; TauCeti retains the sparse scope documented in [audit sources](../../audit/sources.json). Indexed GitHub searches also supplied newer TauCeti and formal-conjectures snapshots and files from other repositories. Twenty-three candidate files were retrieved at their indexed commits and compared with the target. These unrelated files were not built or audited as proofs.

The inspected candidates include:

| Candidate | What it establishes or represents | Comparison with our target |
| --- | --- | --- |
| TauCeti `FiniteBilinearModule/Dyadic/RankTwo/Basic` | Quadratic modules over Z/2^k | Different meaning of dyadic and rank |
| TauCeti `CompletedGroupAlgebra/DyadicCoordinate` and `Padics/GroupAlgebra/CyclicTwo` | Completed group algebras and 2-adic coefficient rings | Different rings and conclusions |
| TauCeti `Algebra/Algebra/SquareZeroPair` | Vanishing of products of square-zero elements | No exactness, half-rank, or linear-term criterion |
| `gq2-lean/RegularSummand/Freeness` | Freeness of cyclic 2-group modules from a counting bound | Relevant background; no characterization of multiplication by an arbitrary element of an elementary abelian group algebra |
| TauCeti `LinearAlgebra/End/LocallyNilpotent` | Invertibility of one plus a locally nilpotent endomorphism | No matching flatness or rank/support conclusion |
| TauCeti `Contraction/Perturbation/Filtered` | Perturbations of filtered contractions | General background with contraction and filtration hypotheses; no identified statement of the target or Friedlander–Pevtsova criterion |
| formal-conjectures `FiniteGenerationOfCohomology` | Statements about finite generation of Hopf-algebra cohomology | Different theorem; the research declarations inspected use `sorry` |
| Four indexed `dyadicMatrix` matches | Numerical containers, real matrices, or martingale norm estimates | Not the binary convolution matrix in our statement |

The source searches did not identify our result under the alternative formulations either. This supports **“no prior matching Lean artifact found in the searched sources,”** not “first Lean formalization.” GitHub searches cover indexed default branches, some broad queries hit the 100-file cap, and initial rate-limit failures are recorded separately from successful retries. Private, unindexed, deleted, historical-branch and differently named artifacts can be missed. A general library lemma may support a new derivation without already formalizing this result.

## Exact relation to the published perturbation theorem

[Friedlander–Pevtsova, Proposition 2.2, manuscript pages 8–9](https://sites.math.washington.edu/~julia/Preprints/ppt/ppt.pdf#page=8), compares projectivity for commuting nilpotent operators alpha and alpha + beta gamma. It applies in characteristic p, with alpha and beta p-nilpotent and gamma p^r-nilpotent. Its proof uses the kernel/image quotient, nilpotence on that quotient, and two applications of the preimage property.

Here is our explicit specialization, rather than just an analogy. In the application of our descent lemma, C and B commute and satisfy C²=B²=0. On V direct sum V set

$$
\alpha=\begin{pmatrix}C&0\\0&C\end{pmatrix},\quad
\beta=\begin{pmatrix}B&0\\0&B\end{pmatrix},\quad
\gamma=\begin{pmatrix}0&I\\0&0\end{pmatrix}.
$$

These operators commute pairwise and square to zero. Moreover

$$\alpha+\beta\gamma=\begin{pmatrix}C&B\\0&C\end{pmatrix}=T.$$

For p=2, projectivity for the action of u is equivalent to image equaling kernel. Thus Proposition 2.2 gives exactness of T if and only if exactness of diag(C,C), and the latter is equivalent to exactness of C. The implication from T to C is exactly the implication used in our dyadic induction. Our abstract Lean helper has a weaker, preimage-only interface without assuming C²=0; the dyadic application does satisfy C²=0.

Our concrete witness calculation is

$$Ca+Bb=v,\ Cb=0,\qquad Cc+Bd=b,\ Cd=0,
\qquad v=C(a+Bc).$$

It uses two preimages, B²=0 and BC=CB. This exposes the same nilpotent cancellation mechanism as the published argument. The source uses a homology quotient and proves a more general equivalence; ours directly constructs the required preimage and repeats the reduction on one fewer binary coordinate. The block recursion and bookkeeping of parity and support moments are specific to the dyadic presentation.

Consequently the difference is meaningful in prerequisites and implementation: the Lean proof stays with finite sums, linear maps, rank–nullity and induction, without formalizing group algebras, flatness or cohomology. The comparison does **not** support calling the central argument a fundamentally new proof. It also does not show that the precise matrix exposition appeared previously.

## Comparison with the exact zero divisor route

[Kustin–Şega–Vraciu, Proposition 1.9, page 6](https://arxiv.org/pdf/1309.1186v2#page=6), uses a regular local presentation and a restriction on products of lifts of exact zero divisors. Its necessary direction invokes Theorem 1.8, whose proof uses an exact sequence of homotopy invariants and counts minimal generators. The alternative argument in [STRUCTURAL-PROOF.md](STRUCTURAL-PROOF.md) combines it with characteristic-two squaring to obtain a contradiction.

Our matrix induction is substantially different from that route: it descends exactness through a triangular block matrix rather than lifting an annihilator condition to a regular local ring. However, its close specialization of the earlier Friedlander–Pevtsova principle is the stronger comparison for assessing originality. Benson's book states the equivalent flatness criterion but the excerpt previously inspected does not supply a separate proof to compare.

## Claims supported by the evidence

- The repository contains a completed Lean proof of the recorded general dyadic theorem, with the verification and axiom audit already recorded.
- No prior matching Lean statement or complete proof was identified in the searched sources.
- The induction offers an elementary matrix presentation and avoids the dependencies of the exact-zero-divisor route.
- Its central descent mechanism is a specialization of a published perturbation principle. Priority of the particular exposition and formalization remains unestablished.

## arXiv follow up

Three native arXiv API metadata queries returned 24 records in total, supplemented by twenty arxiv.org-restricted indexed web queries. Title and abstract screening identified no matching formalization. The closer results concerned local epsilon factors over dyadic local fields and Rogers–Ramanujan identities associated with commuting nilpotent matrices, rather than the binary dyadic rank/support criterion. The [arXiv search record](arxiv-formalization-search.json) preserves queries, record identifiers and comparison notes. This extends discovery beyond GitHub; it is not a full-text or linked-code audit of every arXiv paper and does not establish first-formalization priority.
