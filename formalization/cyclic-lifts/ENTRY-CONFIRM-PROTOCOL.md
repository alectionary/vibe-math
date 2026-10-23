# Fresh confirmation of an initial-state representation-effect hypothesis

This protocol follows old trajectories and the already inspected first holdout.
The proposed source-active interaction is exploratory in those samples. Freeze
this protocol and implementation before generating the independent streams below.
No sample pooling, adaptive enlargement or changes to codes/channel/decoder.

- Two existing [[252,10,10]] codes and the same two predetermined mergers.
- Bernoulli Z errors p=0.04; perfect syndrome; identical flooding normalized
  min-sum, alpha 0.8, 20 fractional bits, clip +/-50, first match or 100 updates.
- Exactly 1,000,000 new paired errors per code; seeds 90316268021 and 90316268022.
  Independent streams across codes; shared error within each original/merged pair.
- Score quantum success by the full unchanged Z-stabilizer span. Separate
  syndrome and logical failures. First-round diagnostic is measured in the
  original 126 check coordinates in both arms, avoiding a check-count artifact.
- The baseline covariate is computed from the error before decoding: source
  active means s_A OR s_B = 1 for the two original checks being merged. Source
  inactive means both are zero. Their supports are disjoint and size six.

## Two primary estimands

For each code separately, let D be merged minus original syndrome-failure
indicator. Estimate E[D | active] - E[D | inactive]. The predicted sign is
positive. Report two-sided Bonferroni simultaneous 95% intervals for the two
interactions, using the paired sample variance inside each disjoint stratum.
An interval containing zero does not establish this prediction.

## Secondary and mechanistic checks

Retain all four initial syndrome classes (00,01,10,11), all losses and gains,
and quantum outcomes. Report conditional effects and the additive net-count
partition without calling it causal mediation. The conditional interaction is
heterogeneity of the representation intervention, not an isolated effect of
absorbing count or proof that the first update mediates the whole final effect.

Record first-round residual syndrome weight in every run. Compare its paired
mean gap, overall and by the four classes, with the separately computed exact
Bernoulli expectation. Validate the finite expectation by an independent
physical-bit convolution, not just the Walsh implementation. Keep its
computational proof status distinct from Lean theorems.

Use unmodified stock-decoder controls, independently reconstruct all result
flags/stratum counts, and regenerate the full error streams to check hashes.
The prior early-score and trapping searches, including unsuccessful ones,
remain part of the record. A replicated interaction narrows the aggregate
explanation but does not prove an entry-to-failure theorem for all errors.
