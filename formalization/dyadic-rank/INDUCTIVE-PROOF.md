# General dyadic rank support proof by induction

The unrestricted rank/support converse is proved in Lean in [Recursive.lean](DyadicRank/Recursive.lean). The declarations `rankSupportAt_all` and `rankSupportConjecture_proved` cover every dimension; `dyadic_rank_support_half` provides the source's positive-dimensional statement with ordinary matrix rank equal to `2^ell / 2`.

The proof uses the dyadic block recursion and an elementary exactness argument. It does not use Proposition 1.9, a polynomial-ring presentation, an assumption of the conjecture, or finite enumeration of dimensions. The earlier [commutative algebra route](STRUCTURAL-PROOF.md) remains an alternative argument whose additional machinery has not been formalized here.

The mathematical conclusion also follows from established representation theory: see the [prior-art review](PRIOR-ART.md), especially Friedlander–Pevtsova (2005), Example 2.6. This presentation does not claim priority for the theorem, proof method, or formalization.

## Reduction to exactness

For a signature `s`, write `p` for its coefficient parity and `m` for its support-vector sum. The already checked identity is

$$D^2=pI.$$

Odd parity gives full rank, so a half-rank matrix has `p=0` and hence `D²=0`. Its image is contained in its kernel. Rank–nullity gives

$$2\operatorname{rank}(D)=N
\quad\Longleftrightarrow\quad
\operatorname{image}(D)=\ker(D).$$

Call the right-hand property exactness. For the induction, only the preimage direction is needed: every vector killed by `D` is the image of some vector. This property is `KernelInRange D.mulVecLin` in Lean.

It suffices to prove that an even-parity signature with zero support sum cannot have this property.

## Split one binary coordinate

Write the signature's zero and one slices as `a` and `b`. Then

$$
D=\begin{pmatrix}A&B\\B&A\end{pmatrix},
\qquad A=D_a,\ B=D_b,\ C=A+B=D_{a+b}.
$$

The change of coordinates `(v₀,v₁) ↦ (v₀,v₀+v₁)` turns this into

$$
T=\begin{pmatrix}C&B\\0&C\end{pmatrix}.
$$

Lean checks the coordinate identities directly using `sliceZero`, `sliceOne`, `sum_slices_mulVec`, and `triangular_zero_row`. The signature of `C` is `lowerSignature s`.

Three facts make the induction possible:

- `C` retains the original parity. Its support sum is the tail of the original support sum. Thus zero parity and zero moments pass to `C`.
- The parity of `b` equals the first coordinate of the original support sum. Zero support sum therefore gives `B²=0`.
- `B` and `C` commute because all dyadic convolution operators commute.

These facts are proved in `parity_lower`, `supportSum_lower`, `parity_sliceOne`, and `dyadic_mul_comm`.

## Exactness descends to the smaller operator

Suppose `T` has the preimage property, and let `Cv=0`. The vector `(v,0)` is killed by `T`, so there are `a,b` with

$$Ca+Bb=v,\qquad Cb=0.$$

Apply the property again to `(b,0)`. There are `c,d` with

$$Cc+Bd=b,\qquad Cd=0.$$

Using `B²=0` and `BC=CB`,

$$
Bb=B(Cc+Bd)=BCc,
\qquad
v=Ca+BCc=C(a+Bc).
$$

Thus every vector killed by `C` is an image of `C`: exactness descends one dimension. The general linear-algebra calculation is `kernelInRange_descends`. Its application to the dyadic coordinate split is `kernelInRange_lower`.

In the original coordinates, the cycle `(v,0)` is the duplicated vector `(v,v)`. `duplicate_cycle` proves that the duplication is a cycle for the larger operator, and the slice identities extract the required preimages. No equivalence with a different algebraic problem is assumed.

## Dimension zero gives a contradiction

At dimension zero the index space has one point. Zero parity forces the signature, and hence its one-by-one matrix, to be zero. The vector `1` is killed by this matrix but cannot be an image. Exactness is impossible.

Repeated descent reaches this base case. This proves `not_kernelInRange_zero_moments` in every dimension. Combining it with half-rank exactness proves the unrestricted converse.

## Public Lean statements and verification

```lean
theorem rankSupportAt_all (ell : ℕ) : RankSupportAt ell

theorem rankSupportConjecture_proved : RankSupportConjecture

theorem dyadic_rank_support_half {ell : ℕ} [Fintype (Point ell)]
    (hpos : 0 < ell) (D : Matrix (Point ell) (Point ell) F2)
    (hd : IsDyadic D) (hr : D.rank = 2 ^ ell / 2) :
    supportSum (D 0) ≠ 0
```

The public matrix theorem works with the caller's finite enumeration. [Checks.lean](Checks.lean) verifies symbolic consumer examples with arbitrary dimension, and prints the axioms of every new recursive theorem. The unrestricted proof depends only on `propext`, `Classical.choice`, and `Quot.sound`. [verification.json](verification.json) pins the source hashes and successful commands; [verification.log](verification.log) records their output.

The earlier finite certificates and Python searches remain available as separate evidence. They are not premises of the general induction.
