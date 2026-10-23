# Exact-distance and matched-decoding follow-up

This continues the existing cyclic lifted-product benchmark, not the P11 dyadic study. An exploratory syndrome-guided search found no weight-eight logical witness in any of the three comparison codes, weight-ten witnesses in `previous_best` and `minimum_4`, and a weight-twelve witness in `minimum_2`. These observations guide the distance audit and must not be described as prespecified discoveries.

## Exact distance scope

Retain the same three saved 252-qubit, dimension-ten cyclic codes, lift fourteen. Use both Pauli sectors. The earlier independent exhaustive census already excludes nontrivial logical supports below eight. Search bounded kernel completions with exact syndrome and full stabilizer-span scoring. Certify translation symmetry before anchoring a variable at fiber zero of its smallest occupied block. Record every completed/budget-limited search and verify explicit witnesses independently.

Independently validate lower bounds by a cycle-seeded search with a separate traversal. For supports of size at most ten, girth-eight and variable degree three imply every occupied check has degree two: four selected variables at one check would require eight distinct additional selected variables via their other neighbors, by four-/six-cycle exclusion, giving at least twelve variables. Contracted support graphs are simple cubic and triangle-free. A cubic graph on at most ten vertices contains a four- or five-cycle: absence of cycles up to length five gives at least fourteen vertices by the edge-rooted Moore argument. Thus a kernel support of size at most ten contains a Tanner cycle of length eight or ten. Enumerating all such cycle supports and all bounded completions is an independent complete lower-bound check. These are computational certificates with written completeness arguments, not Lean-certified exhaustive searches.

Stop at the first independently verified upper witness matching the lower bound; do not launch larger code populations or unbounded distance optimization.

## Fresh distance-matched comparison

If the audits confirm distance ten for both `previous_best` and `minimum_4`, retain both, irrespective of previous decoding outcomes. Exclude `minimum_2` from this distance-matched contrast if its distance is twelve. No new matrices or objective weights are introduced.

Freeze the paper's one-sector independent Bernoulli channel, perfect syndrome, normalized min-sum flooding, normalization 0.8, 100 iterations, twenty fractional bits, clipping at +/-50 and stabilizer-equivalent scoring. Use 100,000 new shared errors per probability 0.01, 0.02 and 0.04, generated with a new seed 20261024 and the paper's sampling routine. This is 300,000 independent channel patterns and 600,000 code-decoder evaluations. Selection and all settings are fixed before these outcomes exist.

The single primary comparison is `minimum_4` minus `previous_best` recovery failure probability at p=0.04. Report a paired normal 95% interval, both marginal Wilson intervals and all raw counts. The other probabilities are secondary. Do not proclaim a winner if the interval includes zero. Retain syndrome/logical/stabilizer decompositions, iteration counts, paired bitmaps and sample hashes. Matching minimum distance does not match the entire logical spectrum or isolate absorbing count causally.

## Stop condition

Complete the exact-distance audit and this one fixed distance-matched comparison. Report whether the earlier confound has been removed, and what uncertainty remains. No new decoder, channel, matrix size, candidate population or moderate-noise-to-error-floor extrapolation is part of this step.
