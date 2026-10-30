# Comparison protocol

Recorded after preparation pilots and source convention diagnostics, before the full curve-comparison summary. This is an exploratory replication, not a preregistered experiment. No original simulation sample sizes were recovered.

Exact resource claim: require equality of the integer qubit counts and their ratio. Code parameters: independently compute the logical dimension and embedded minimum distance, then separately check circuit graphlike distance.

Numerical curve comparison: report pointwise differences, our binomial Monte Carlo standard errors, and figure extraction bounds separately. Give the two-standard-error band and a Bonferroni familywise band for 32 Figure 7.14a point comparisons. These bands quantify our simulation uncertainty only; an exceedance does not establish an error in the source because its shot counts are unknown.

Practical similarity of code performance: use an exploratory margin of 0.02 absolute block-failure probability across the primary 16-point grid. State whether all differences, with simultaneous uncertainty from our simulations, lie inside that margin. Do not describe this operational margin as a tolerance specified by the dissertation. Report failure of this margin and all directional reversals without changing the margin.

Primary aligned model: 48 subrounds and planar EM3_v3, justified by thesis round definitions and the comparator repository's plotting label mappings. Retain 96-subround and EM3_v2 boundary models as diagnostics. Inspect every primary curve point with a large conditional gap using the historical package version and source-input alternatives.

Second size: independently reconstruct 64-qubit Bolza EM3 circuits, include all three planar distances (2,3,4), and report both durations at five noise strengths. Without quantitative extraction of Figure 7.14b, these are supporting new simulations and parameter replications, not numerical recovery of that panel.
