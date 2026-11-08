# Coupling overlapping anchor laws

This is a follow-up formulation, not a C16 conclusion. The source question
remains width16 or18. A feasible local law is not a frame.

## Five variables have a shared meaning

For a four-anchor set A, write y_J=E[product of selected indicators in J].
The empty, singleton and pair moments are fixed by the current p/S/T point.
The remaining four triple moments and one quadruple moment determine all16
pattern probabilities by inclusion-exclusion:

    lambda_A(m) = sum_{J: supp(m) subset J subset A}
                 (-1)^(|J|-|supp(m)|) y_J.

The same triple appearing in two anchor sets must have the same y_J. Under
the verified32 rotation/sector actions, triples or quadruples in the same
physical orbit also have equal moments after averaging a hypothetical frame.
These are linear consistency equations; they assume symmetry of the averaged
distribution, never symmetry of an individual frame.

Each local-box row from `two_basis_structure_zonotope.py` has the form

    h.lambda_A >= sum_v c_v E[monomial_v],

where the right side uses only first/second moments. Substituting the formula
above therefore gives a linear row in shared third/fourth moments, with an
affine first/second-moment right side. All such rows are necessary for any
source frame distribution. They omit shared bucket cardinalities, physical
matroid ranks and unanchored mutual pairing unless explicitly added later.

Intersecting these local rows with common higher moments can be stronger than
testing each anchor set separately: projection does not generally commute
with intersection. A toy obstruction uses three unbiased pairwise-independent
bits. The uniform even-parity and odd-parity distributions have the same first
and pair moments but triple moments0 and1/4. Two local extensions demanding
these distinct triple values are individually feasible and cannot be glued.
This toy is a consistency example, not a constraint inferred for C16.

## Exact acceptance boundary

An overlapping-family feasible certificate must give nonnegative pattern
probabilities for every included quad, reproduce its low moments, and satisfy
every retained row, with shared monomials identified exactly. It proves only
this necessary local model is nonempty.

For an obstruction, let the assembled rows be A q <= b(p,S,T), with each
shared higher moment q in[0,1]. For exact nonnegative multipliers z, put
r=A^T z. Every feasible extension obeys

    sum_j min(0,r_j) <= r.q <= z.b(p,S,T).

Thus z.b < sum_j min(0,r_j) is an exact contradiction at the specified point.
It also defines a valid linear necessary inequality in p/S/T, even without
exact cancellation of q. Numerical dual multipliers merely propose z; all
row provenance, signs, arithmetic and bounds require independent replay.
If the five-coordinate local compiler groups identical statuses by their
strongest target-dependent row, retain the actual maximizing physical vector
and its coefficients. The resulting row, not a floating maximum value, is
the source-valid object used in the global certificate.

## Bounded first gate

Start from the existing physical pair X80/Z186 and a small fixed family of
additional X/Z anchors chosen from their permitted zero-neighbor pools. Use
only quads with all16 local count domains verified feasible in this first
prototype; skipped quads remain explicitly outside its scope. Freeze the
family before solving. Compare separate exact local feasibility with joint
shared-moment feasibility. A timeout or failed rational recovery is UNKNOWN.

Generalizing to excluded patterns requires lambda_m=0 for every independently
proved infeasible pattern; the current all-pattern prototype must not silently
omit those equations or call itself a complete anchor-family screen.
