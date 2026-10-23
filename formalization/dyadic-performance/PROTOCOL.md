# Dyadic decoding predictor pilot

Protocol fixed October 23, 2026 before running the pilot. This is a first experiment toward P11 Section 7's performance-objective question, separate from the completed forbidden-set theorem. The prior-art review is in [PRIOR-ART.md](PRIOR-ART.md).

## Population and outcomes

Generate 32 connected, distinct, normalized `3 × 6` arrays of permutation labels in `F₂³`, with full block support. The first row and column are zero; the other labels are independent uniform values from 0 through 7, generated with seed 20261023. Select the first 32 having the same binary matrix rank as the first connected sample. Record all rejected samples. This fixes 48 variables, 24 checks, variable degree three, check degree six, length, dimension and connectedness. It is a classical quasi-dyadic subfamily, not P11's quantum CSS construction or an ensemble of PEG-optimized codes.

Use syndrome-based flooding normalized min-sum, 50 iterations, normalizations 0.8 and 1.0, fixed-point messages and saturation at ±50. Reuse the existing C++ engine, independently checked against its slow extrinsic-message reference on a tree and on the new dyadic graphs. Use perfect syndrome measurements and independent binary errors at probabilities 0.02, 0.05 and 0.08. Each condition has 3,000 shared error vectors across all codes and both decoders. Estimate classical frame error rate: success requires the estimated error to equal the injected error. A matching syndrome alone is not success. Separate nonconvergence from convergence to a wrong error. Quantum stabilizer equivalence is not applicable to this classical pilot.

Also decode every support of weight zero, one and two at probability 0.05, separately from Monte Carlo, to obtain exact low-weight failure counts for each fixed decoder. These are not a complete error-floor estimate.

## Candidate predictors

Count simple cycles of lengths four, six and eight, quotienting rotations and reversals. Enumerate every support of size two through four and classify absorbing sets using strict even-neighbor majority at each variable. Retain the complete `(a,b)` spectrum, elementary versus non-elementary status, and connectedness. Separate `b=0` supports (codeword supports in the classical model) from positive-syndrome absorbing sets. Size-one sets are impossible here because variable degree is three.

Compare fixed ridge models with penalty one: intercept only; three cycle counts; absorbing-set counts (positive `b` and zero `b` at each size); both families together. Use `log(1+count)` features and the smoothed logit of the observed frame error fraction. Standardize features using training codes only; do not penalize the intercept. Hold out whole groups with identical cycle and full absorbing-spectrum fingerprints. Isomorphic Tanner graphs have the same fingerprint and therefore cannot cross this split, although the grouping may merge non-isomorphic graphs. Report leave-one-group-out root mean squared logit error against the intercept baseline. Report marginal Spearman associations separately; a correlation is not a causal optimization gain.

Do not tune features, penalties, populations, probability points or decoder settings after observing the outcomes. Record constant or dependent predictors rather than deleting inconvenient comparisons. Use Wilson intervals for individual Monte Carlo fractions. Rankings are pilot evidence only; modest code counts and shared noise prevent a universal winner claim. Larger-family held-out validation, a second lift size, independently optimized populations, and source CSS experiments remain subsequent stages.

## Checks and next-stage decision

Check the XOR graph against independently expanded binary matrix entries, exact binary rank, connectedness, degree distributions, direct syndrome scoring, cycle-count identities on small graphs, and absorbing-set definitions on complete bipartite boundary cases covered by P11. Check the C++ decoder against the Python reference, including all tree error patterns. Record hashes, seeds, code arrays, raw paired failure bitmaps, feature spectra and predictions.

The most useful initial result may be failure to distinguish these predictors. In particular, regular degree-three graphs can make small absorbing counts algebraically dependent on cycle counts. Any such dependency must be reported before interpreting model performance. A later intervention should preserve rank, support and connectedness, and compare cycle-only optimization with absorbing-only and joint optimization on fresh noise, rather than selecting winners on this pilot's test frames.
