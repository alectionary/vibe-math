# Fixed pilot: delete a redundant generator of the same CSS code

Frozen after feasibility counts and before new decoding. The intervention is
deletion of the first individually redundant H_X row, not an intervention on
absorbing count alone. Apply it to both existing exact `[[252,10,10]]` codes,
`previous_best` and `minimum_4`. Neither is selected using pilot performance.
Each code has three representations: original, row-order reversal control,
and delete-one. H_Z and physical labels remain fixed. No new codes are searched.

- Exactly 50,000 new independent Bernoulli Z-error patterns at p = 0.04,
  seed 20261026, shared across all six representations. Each pattern consumes
  252 Python Random draws. This gives 300,000 decoder evaluations, not
  300,000 independent errors. Prior experiments are not pooled.
- Unchanged minsum.cpp: flooding, alpha 0.8, maximum 100 iterations, twenty
  fractional bits, original clipping/rounding/ties and first-match stopping.
  Perfect syndrome only; no measurement-noise or generator-cost claim.
- Score every residual against the unchanged complete H_Z span. Verify
  syndrome matching against the original H_X as well as the representation.
- Report both within-code deletion contrasts, including per-error discordances,
  syndrome/logical failures and pointwise paired 95% intervals. They are
  exploratory intervals, not multiplicity-adjusted confirmatory tests.
  Stop at 50,000 regardless of outcome; no tuning or adaptive enlargement.
- Check row-order reversal against original on every error: final estimate,
  stopping iteration and match status must be identical, not just aggregate FER.
- Trace the first three errors in each of four joint outcome categories:
  both succeed, original fails only, deletion fails only, both fail, for each
  code (at most 24 patterns and 48 representation trajectories). No selection
  by how compelling a trajectory looks. Categories include stabilizer success.
- Instrument an otherwise byte-identical copy of minsum.cpp by emitting the
  hard decision after initialization and each iteration. For every selected
  trajectory, compare its final output to the original engine and its complete
  hard-decision history to direct Python message equations.
- Record first divergence, full-code residual syndrome weights, residual
  stabilizer membership, iteration-to-iteration changes, and whether the true
  error contains an absorbing support lost by deletion. Containment is a
  descriptive annotation, not proof that the support caused failure.
- Derive and check the exact first-iteration effect of deleting a degree-three
  variable's check: at p = 0.04, the original hard decision is one only if all
  three incident syndrome bits are one; after deletion it is one if both
  remaining bits are one. Thus new first-iteration flips can occur even when
  the deleted check's syndrome bit is zero. This concerns the local decoder
  update, not eventual failure or the aggregate absorbing-count hypothesis.

This is a mechanism pilot under a precisely defined generator intervention.
It cannot establish that count itself caused the older cross-code improvement.
