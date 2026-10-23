# Bounded trajectory-mechanism development

This follow-up is authorized for two hours, beginning 2026-10-23 20:15 UTC.
It keeps the two existing exact [[252,10,10]] codes, their original and merged
representations, p=0.04 one-sector Bernoulli errors, perfect syndrome,
alpha=0.8 integer min-sum, clipping, 100-iteration limit and stopping rule fixed.

Only the previous seed-20261027 experiment is development data. No fresh
holdout noise is generated until the final detector definitions, protocol and
implementation hashes have been frozen. Any later revision requires a new
holdout to support a revised predictive claim; a failed implementation check
invalidates the affected holdout rather than licensing outcome-based tuning.

The bounded candidates are:

1. An exact repeated full incoming-message state, with every intervening
   decision rejected. Equality is checked on all integer coordinates, not a
   hash alone. Period one is a fixed point; longer periods are periodic orbits.
2. A forward-invariant interval box enclosing the last eight input states,
   constructed by at most 32 monotone hull expansions, with a uniformly
   unsatisfied check.
3. A finite-horizon interval certificate, beginning before the iteration limit,
   that guarantees continued rejection under a nonzero perturbation of every
   incoming message. Development explores entry iterations 25, 50, 75 and
   integer radii 1, 1024, 65536. Both a possibly changing rejecting check and a
   single check pinned unsatisfied throughout the remaining horizon are
   distinguished. This is a late-state persistence certificate, not an early
   predictor or a causal explanation of entry into that state.

The first development pilot uses the first 256 syndrome failures and first 32
syndrome successes in each old arm. Larger old-data checks may follow. All
explored candidates, including zero-coverage results, will be reported. A
repeating hard decision without a message-state certificate is diagnostic only.

The fresh evaluation will use exactly 1,000,000 independent errors per code,
shared within each original/merged comparison. The same fresh stream may also
be shared between codes, as in the preceding experiment. Error seeds, counts,
detectors, coverage definitions, numerical checks and example selection will
be fixed before noise generation. Success continues to include the complete
Z-stabilizer span. Mechanism coverage of syndrome failures is distinct from
logical failures and from an isolated absorbing-count effect.

Formalization will prioritize sound deterministic persistence lemmas and actual
message-update certificates. Any external replay or interval-arithmetic bridge
will be explicitly separated from Lean-checked conclusions. No inventory target
or universal performance rule will be marked solved solely on these tests.
