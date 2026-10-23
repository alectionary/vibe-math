# Independent population without weight two codewords

Fixed October 23, 2026 after examining the first pilot and its diagnostics, before generating the follow-up outcomes. This is a prospective follow-up motivated by those findings, not the original predeclared analysis or an externally registered study.

Select the first 32 connected, normalized `3 × 6` dyadic arrays over `F₂³` of binary rank 20 with no duplicate expanded binary columns, using construction seed 20261025. Duplicate binary columns are exactly weight-two codeword supports here; each column has weight three, so weight-one codewords are also impossible. Record every rejection. Count the same cycle and absorbing spectra. Record weight-four codeword counts; do not select the population on those counts or on decoding outcomes.

Reuse all predictor features, transformations, penalty, group-held-out evaluation, decoder settings and error probabilities from the original protocol. Generate 3,000 fresh shared error samples per probability with seed 20261026. Run both normalizations, for 576,000 new Monte Carlo decodes. Independently compare each decoder against its Python reference on four low-weight errors in each of two new graphs. Preserve original results unchanged.

Report all six model comparisons without selecting the most favorable condition. This tests whether the initial absorbing-feature advantage survives prospective exclusion of weight-two codewords. It remains a small classical-family experiment; it does not measure quantum logical error rates, causal optimization gains or rare-event error floors.
