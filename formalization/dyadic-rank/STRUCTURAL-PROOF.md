# Alternative general argument using exact zero divisors

The full converse is now proved in Lean by the [direct induction](INDUCTIVE-PROOF.md), which does not use the algebraic route below. This alternative argument uses Proposition 1.9 of Kustin, Şega and Vraciu, [Minimal quasi-complete intersection ideals, arXiv:1309.1186v2](https://arxiv.org/pdf/1309.1186v2), printed page 6. The Lean project checks the matrix reductions and the elementary ideal-squaring step below. The complete argument, including the change of algebraic model and the published proposition, is not yet checked in Lean.

## Matrix reductions checked in Lean

Write `p = coefficientParity s` and `m = supportSum s`. The new declarations in [Structural.lean](DyadicRank/Structural.lean) prove, for every dimension:

- `coefficientParity_eq_card`: `p` is the support cardinality reduced modulo two.
- `supportSum_apply`: `m i = ∑ x, s x * x i` for each coordinate `i`.
- `dyadic_square`: `D * D = p • I`. Its off-diagonal proof pairs terms by the fixed-point-free involution `z ↦ x + y + z`.
- `dyadic_rank_of_parity_one` and `parity_zero_of_half_rank`: odd parity gives full rank, so any half-rank candidate has even parity.
- `dyadic_twice_rank_le`: even parity gives `2 * rank D ≤ 2^ell`.
- `mulVec_coordinate`: the action on the coordinate function `y ↦ y i` is `x ↦ m i + p * x i`.
- `affine_mem_kernel`: if `p = 0` and `m = 0`, all affine linear functions are in the kernel.
- `half_rank_iff_range_eq_kernel`: for a square-zero matrix, half rank is equivalent to equality of its image and kernel.
- `rankSupportAt_iff_kernel_obstruction`: the conjecture is equivalent to strict image/kernel containment whenever both parity and support sum vanish.

The affine functions can already belong to the image. Their presence in the kernel alone does not prove the strict containment needed in larger dimensions.

## Proposed argument in the dyadic algebra

Let `ell ≥ 1`, `G = F₂^ell`, and `N = 2^ell`. Identify the group algebra with

$$
 A=\mathbb F_2[G]\cong
 \mathbb F_2[t_1,\ldots,t_\ell]/(t_1^2,\ldots,t_\ell^2),
 \qquad t_i=g_i+1,
$$

where `g_i` is the group element for the `i`th unit vector. Both algebras have dimension `N`, and the squarefree monomials in the `t_i` form a basis. The relations follow from `g_i²=1` in characteristic two; conversely `g_i=1+t_i` supplies the inverse presentation.

Associate the signature to

$$
 f=\sum_{x\in G}s(x)g^x
   =\sum_{x\in G}s(x)\prod_{i:x_i=1}(1+t_i).
$$

Multiplication by `f` has matrix `D` in the group basis: its `(x,y)` entry is `s(x+y)`, because every group element is its own inverse. Its constant coefficient in the squarefree basis is `p`; its coefficient of `t_i` is `m_i`. Consequently `p=0` and `m=0` imply `f ∈ 𝔪²`, where `𝔪=(t_1,…,t_ell)` is the maximal ideal of `A`.

Suppose, for contradiction, that such a signature has rank `N/2`. Since `f²=0`, the principal ideal `(f)` is contained in the annihilator `ann(f)`. Rank–nullity makes their dimensions equal, hence

$$
 \operatorname{ann}_A(f)=(f).
$$

The rank hypothesis ensures `f≠0`; the element lies in the maximal ideal and is not a unit. Thus `(f,f)` is an exact pair of zero divisors.

Now use the regular local presentation

$$
 Q=\mathbb F_2[[t_1,\ldots,t_\ell]],\quad
 \mathfrak n=(t_1,\ldots,t_\ell),\quad
 J=(t_1^2,\ldots,t_\ell^2),\quad A\cong Q/J.
$$

Choose a lift `F ∈ 𝔫²` of `f`, for example its squarefree polynomial representative. **Proposition 1.9** says that if the images of two lifts form an exact pair in `Q/J`, their product is not in `𝔫J`. Applied to `(F,F)`, it gives `F² ∉ 𝔫J`. This necessary direction assumes that `Q` is regular local and `J ⊆ 𝔫²`; it has no restriction excluding characteristic two. The characteristic restriction in that paper's later Theorem 5.1 is not being used.

But in characteristic two, every element of `𝔫` squares into `J`, and every element of `𝔫²` squares into `𝔫J`. One can see the latter by writing `F` as a finite sum of products of elements of `𝔫`, squaring term by term, and using ideal closure. Therefore `F² ∈ 𝔫J`, a contradiction.

This proposed application of Proposition 1.9 rules out half rank when parity and support sum both vanish. Odd parity already gives full rank. Together these yield the conjectured converse in every positive dimension.

## Elementary ideal step checked in Lean

[FrobeniusObstruction.lean](DyadicRank/FrobeniusObstruction.lean) proves the following in any commutative ring of characteristic two, with arbitrary generators `g`:

$$
 F\in(\operatorname{span}(g))^2
 \quad\Longrightarrow\quad
 F^2\in\operatorname{span}(g)\,
       \operatorname{span}(g_i^2).
$$

The final declaration is `square_mem_generator_product`. It follows from `square_mem_span_squares` and `square_mem_product_of_mem_square`. This is an actual general theorem with all hypotheses in its statement; it does not assume the dyadic conjecture or the external proposition.

## Remaining Lean obligations for this alternative route

A full Lean proof still needs the group-algebra/truncated-polynomial equivalence and its compatibility with the dyadic matrix; the constant/linear coefficient bridge to maximal-ideal-square membership; a suitable regular local presentation; and Proposition 1.9 or a replacement proof specialized to this ring. The published proposition is not inserted as a custom axiom. The complete Lean proof of the target uses the separate direct induction, so these obligations are no longer needed to prove the conjecture.

The argument above is a proposed application of the older theorem, rather than a claim that the older paper explicitly discusses this dyadic conjecture. The source describes its own mathematical problem as conjectural; independent review of this proposed application remains useful before treating it as a research resolution.
