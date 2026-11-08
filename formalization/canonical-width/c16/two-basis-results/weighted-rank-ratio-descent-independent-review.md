# Exact ratio descent for the local selected-mass threshold

Reasoning-only review. No computation, import, oracle query or solver was run.

Assume two nonempty domain base polytopes of the same rank R, with B1 contained
in B0; lambda>=0; and **exactly** z in lambda*B0. Define

    c(S) = lambda*r0(S) - z(S) >= 0,
    d(S) = r0(S) - r1(S) in {0,...,R}.

For 0<=a<=lambda, local weighted-rank elimination gives feasibility precisely
when c(S)-a*d(S)>=0 for every subset S. Hence

    a_max = min(lambda, min_{S:d(S)>0} c(S)/d(S)),

with the minimum over an empty family interpreted as +infinity. This proves
the feasible interval [0,a_max], including its endpoints.

## Descent and strict slope decrease

Initialize a=lambda. Let S be an **exact global minimizer** of
F_a(T)=c(T)-a*d(T). If its value is negative, c>=0 implies d(S)>0. Set

    b = c(S)/d(S).

Then 0<=b<a and F_b(S)=0. Suppose T has F_b(T)<0. Writing Delta=a-b>0 gives

    F_a(S) = -Delta*d(S),
    F_a(T) = F_b(T)-Delta*d(T).

If d(T)>=d(S), the second quantity is strictly smaller than the first,
contradicting S's global minimality at a. Therefore every negative set at b,
and in particular its next exact minimizer, has d(T)<d(S).

This proof allows arbitrary ties among the exact minimizers. Equal or larger
slopes can tie at zero at the new parameter, but cannot be negative there.
Every negative update consequently uses a strictly decreasing positive
integer slope. There are at most R negative updates, followed by at most one
terminal oracle call. Here R=128.

At a nonnegative oracle minimum, all subset inequalities hold. The minimum
is in fact zero because the empty set has value zero. If an update has occurred,
the previous selected set has ratio equal to the current parameter, which is
therefore both a feasible value and an upper bound on a_max. If no update has
occurred, feasibility at lambda proves a_max=lambda. Starting instead at an
already feasible value below a_max would not determine the maximum.

## Edge cases and scope

- lambda=0 and z in lambda*B0 imply z=0 and a_max=0; no oracle is needed.
- If B1 is empty, impose a=0 separately. A rank-R r1 must not be fabricated
  for an empty domain. If B0 is empty, positive lambda is already impossible;
  handle the zero-mass pattern separately.
- If d is identically zero, B1=B0 and a_max=lambda. Sets with d=0 cannot have
  negative F_a under the exact original-membership prerequisite.
- A ratio equal to zero is legitimate and terminates at a_max=0. The known
  original membership already certifies F_0>=0.
- Finite listed-rank feasibility, approximate membership or a numerical
  minimizer is insufficient for this guarantee. Without exact z in lambda*B0,
  a negative set may have d=0 or produce a negative ratio.

For parameters in [0,lambda], F_a is a nonnegative weighted sum of two matroid
rank functions minus a modular function, so it is submodular. The result above
bounds calls to an exact **global minimization** oracle for this weighted
two-rank function. It does not provide that oracle or bound its runtime by
128 rank evaluations. The fast early-exit single-matroid routine certifies
positive violations, not the global minimum required here; it cannot be used
to claim this iteration bound. Even a maximum-defect oracle for one matroid
would need a justified extension to the weighted two-rank function.

The lemma is accepted as stated with these prerequisites. It concerns one
pattern's local selected-mass split, not the prescribed cross-pattern T
equations, a complete owner lift, or the original full-frame problem.
