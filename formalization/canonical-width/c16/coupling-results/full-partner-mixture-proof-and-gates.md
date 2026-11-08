# Exact local projected membership gate

This gate concerns the convex hull of integer feature columns associated with an
allowed orbit32 phase mask `P` and a compatible full128 physical Z basis `B`.
Its775 coordinates are `(1,k,C1..C8,n[45],d[45,16])`, with
`d[j,h] = sum_t 1_P(t) 1_B(16*j+(t+h)%16)`.

A full source frame produces such a column after retaining its orbit32 X
selection and its entire Z basis. Averaging all16 rotations and both sector
orientations gives the moment target
`(1,16*p32,16*S_h[32,32],16*p[j],16*T_h[32,j])`.
Consequently, an exact nonnegative mixture of valid local columns matching this
target certifies membership in this necessary convex relaxation. It does not
certify that a column extends to a full physical X frame, that the target is a
mixture of full source frames, or that the source C16 question is resolved.

## Recovery

`recover_full_partner_mixture.py` reads a hash-bound projection report and its
NPZ archive. It selects positive numerical weights, normalizes their mass, and
opens exact recovery only when the maximum feature residual is at most `1e-7`
by default. This numerical condition is only a gate.

FLINT computes the exact rank of the selected775-by-k integer feature matrix.
Numerical pivoted QR proposes an exact square submatrix of that size. Free
weights are rounded to dyadics of denominator2^42; an exact rational solve
corrects the pivot weights. Every one of the775 equations is then checked
exactly, as is nonnegativity. An invertible pivot submatrix of exact full column
rank and a remaining inconsistent row prove that the target is outside this
selected column span. A recovered negative weight rejects only this particular
recovery; it does not prove nonmembership in the convex hull.

Successful producer output remains a candidate until independent replay. It
contains only positive weights and embeds each physical mask,128 Z indices, and
integer feature vector. Neither successful producer output nor a small
floating residual is itself accepted membership.

## Independent consumer

`verify_full_partner_mixture.py` does not import producer recovery or feature
routines for acceptance. It reconstructs the physical pools, checks their rank,
sector/rotation linear maps and pairing identities, and replays all2848 saved
orbit32 profile obstructions. Each positive column must have an allowed mask,
128 distinct independent physical Z vectors, the full-rank zero pool, and
exactly one Z vector in each selected X owner's unit-signature bin. Literal
features are recomputed. Rational weights must be strictly positive, sum to1,
and match all775 exact target coordinates independently read from the compact
point. Existing independent literal32-action controls check normalization.

The accepted status is `PASS_EXACT_LOCAL_PROJECTED_MEMBERSHIP`; both
`source_C16_answered` and `physical_full_frame` remain false.

## Recorded validation

- The active-master archive fails the numerical recovery gate with maximum
  feature residual `0.052943017938706954`. No FLINT recovery was attempted.
- A known rational mixture of three actual physical archive columns passes
  exact recovery and independent physical/all775-equation replay. Its target
  is synthetic and is explicitly not witness2.
- A dependent four-column version exercises the free-weight correction path.
- An inconsistent target is rejected as outside the selected column span.
- A target whose unique recovered weights include a negative entry is rejected.
- Ten malformed acceptance inputs are rejected: negative weight, wrong mass,
  forged feature, duplicate Z index, forbidden mask, changed target equation,
  distinct full-rank Z basis with wrong unit owners,128 distinct rank127 Z
  vectors, wrong point binding, and wrong saved target normalization.

## Commands

```sh
python recover_full_partner_mixture.py \
  --report coupling-results/full-partner-projection-wolfe-witness2.json \
  --point coupling-results/witness2-rational.json.gz \
  --output coupling-results/full-partner-mixture-wolfe.json
```

Only a successful exact candidate proceeds to:

```sh
python verify_full_partner_mixture.py \
  --certificate coupling-results/full-partner-mixture-wolfe.json \
  --point coupling-results/witness2-rational.json.gz \
  --output coupling-results/full-partner-mixture-wolfe-independent.json
```

The final Wolfe report/archive must be closed and stable before recovery.
