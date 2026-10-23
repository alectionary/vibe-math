# One-million-pair independent follow-up

Frozen before generating follow-up outcomes. This is a local follow-up to the
100,000-pair-per-probability distance-matched experiment; that experiment and
its hash manifests remain unchanged.

- Compare only `previous_best` and `minimum_4`, both exact `[[252,10,10]]`.
- Primary and only probability: independent Bernoulli Z errors at p = 0.04,
  with perfect syndrome measurements. Score recovery modulo Z stabilizers.
- Generate exactly 1,000,000 fresh shared patterns with Python Random seed
  20261025, consuming 252 random draws per pattern in coordinate order.
  This seed differs from every stream in the earlier matched experiment.
- Hold matrices, coordinate labels, flooding normalized min-sum decoder,
  alpha = 0.8, 100-iteration limit, fixed-point arithmetic, clipping,
  stopping rule, and tie conventions fixed. Use the original minsum.cpp.
- Process 20,000 patterns per batch for bounded memory; give the same batch
  to both codes. No adaptive stopping, tuning, selection, or enlargement.
- Primary contrast: failure probability of minimum_4 minus previous_best.
  Report paired normal 95% interval and discordant outcomes; also report
  per-code Wilson intervals and syndrome/logical failure decomposition.
- Treat this sample as a separate replication. Do not pool it with the old
  sample as the primary analysis. No claim about other channels or decoders.

Planning from the old p = 0.04 sample: discordance probability estimate
0.04484 and absolute difference estimate 0.00022. At one million pairs,
anticipated 95% half-width is 0.00041503 (0.041503 percentage points).
The approximate two-sided 5% test, 80% power detectable effect is 0.00059325
(0.059325 percentage points). At an assumed true effect of 0.00022,
approximately 7,271,558 pairs would give 80% power under a normal approximation.
These are planning scenarios from uncertain pilot estimates, not promises
of an effect or of significance at any sample size.

The runner freezes source/input hashes in `search/million-paired-selection.json`
before decoding. It stores compressed per-pattern failure flags, batch hashes,
full-stream hash, reference decoder checks, and results separately from the
original experiment. Reproduce with `python3 search/million_paired.py` from
this directory (a C++17 compiler is required).
