# Exact mixture-and-cut certificate for a global rank defect

Reasoning-only addendum to
`two-basis-results/weighted-rank-ratio-descent-independent-review.md`.
The earlier note is retained unchanged. No computation, oracle or solver ran.

Let f be a normalized submodular rank sum and let an exact verified colored
mixture provide x in B(f). For every subset S,

    g(S)-f(S) <= g(S)-x(S)
              <= D = sum_j max(g_j-x_j,0).

The first inequality is the base-polytope inequality x(S)<=f(S). The second
is the coordinatewise positive-part bound for a sum over any subset. Neither
step depends on the label algorithm or on searching other subsets.

Consequently, if a reported subset S has exact gap g(S)-f(S)=D, it attains
the global maximum defect. A consumer can verify this using the physical
bases and exact masses of the colored mixture, the exact marginal vector x,
and a direct rank calculation for S in each color. The full exponential family
of subsets need not be enumerated to check this certificate.

For the local ratio-descent problem, use

    f_a=(lambda-a)*r0+a*r1,  g=z.

The two color masses are nonnegative. Independently verified bases in their
respective domain matroids give x in B(f_a); zero-mass colors contribute zero.
The equality certificate above proves S is an exact global minimizer of
F_a=f_a-z, with minimum -D. It therefore supplies precisely the oracle guarantee
needed by the strict integer-slope descent lemma, if such a certificate is
actually obtained at each call.

The upper-bound lemma does not require g(E)=f(E). Interpreting zero maximum
defect as base-polytope membership does require that total equality in addition.
In the ratio application it holds. When D=0 and the totals agree, g=x exactly,
so the mixture itself proves membership. The empty set can certify zero gap.

An early positive cut with gap strictly below D remains only a valid violation;
it is not a maximum-defect certificate. Numerical closeness of gap and D is
insufficient. This addendum makes no runtime, termination or complexity claim
for obtaining the colored mixture or the matching subset.
