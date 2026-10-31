# Read-only review of the colored matroid draft

Reviewed `exact_colored_matroid_push_relabel_draft.py` without importing,
executing or testing it. No frozen implementation was modified. This review
does not replace independent tiny controls or a physical endpoint consumer.

No apparent mathematical bookkeeping error was found in the following paths.

- Positive color masses sum exactly to one, and their full ranks must agree.
  Nonnegative target mass must equal that common rank. A zero-mass color may
  have a different rank and cannot acquire positive basis weight.
- Warm records are validated against their own color's rank and vectors.
  Their weights must sum to each prescribed color mass separately. Duplicate
  `(color,basis)` records are combined, and zero-weight records are discarded
  only after validation. The common denominator includes target entries,
  color masses and every warm weight, preserving exact integer arithmetic.
- Both active mixtures and echelon caches are keyed by `(color,bits)`, so
  identical index subsets in different matroids cannot collide. Fundamental
  circuits use the vectors of the selected color. The cached exchange update
  is the previously reviewed GF(2) coefficient transformation in that color.
- Every push replaces B by B-t+s within the same color. Splitting by
  `min(deficit,old_weight)` preserves nonnegativity and each color's mass.
  Only the two endpoint marginals change, by opposite exact amounts.
- The empty-level candidate is accepted only after direct subset ranks in
  every color give a strictly positive exact weighted-rank gap. Consequently
  that cut's validity does not depend on the label invariants being trusted.
  A nondeficient endpoint equals the target because both total marginals
  equal the common rank. A consumer must still reconstruct all marginals
  from the actual colored bases rather than trust the saved x array.

## Input normalization and physical representation

This API uses unit total color mass. For a positive-mass pattern with raw
weights a and lambda-a, pass `a/lambda`, `(lambda-a)/lambda`, and `z/lambda`.
Multiply a resulting normalized rank gap by lambda to recover the raw
allocation inequality. A zero-mass pattern is handled separately.

Each vector array must represent the **auxiliary domain matroid**, including
forced coloops, contracted zero vectors, effective owner bins and forbidden
loops. Reusing unmodified physical vectors for every color would not represent
these domain ranks. Empty selected domains must be handled explicitly; a
zero-weight placeholder does not turn an empty domain into a feasible one.

## Boundedness and acceptance scope

Two resource details merit explicit controls when execution is authorized:

1. An oversized initial mixture can reach the success or literal-cut check
   before the active-basis cap check. Thus a strict maximum on returned support
   requires rejecting an oversized warm start before the loop, or an explicit
   wrapper guard. This is a resource convention, not an invalid rank proof.
2. The time check follows optional invariant replay and the empty-level rank
   scan. The internal seconds parameter is not a hard wall-clock guarantee;
   retain an external cap for a future bounded run.

The draft correctly reports no maximum-defect or runtime guarantee. The
separate exact mixture-and-cut criterion can certify maximum defect only when
the reported gap equals the exact total positive marginal deficit. Otherwise
an early positive cut remains a valid violation, not an optimality certificate.
No cross-pattern owner-lift or full-frame conclusion follows from this draft.
