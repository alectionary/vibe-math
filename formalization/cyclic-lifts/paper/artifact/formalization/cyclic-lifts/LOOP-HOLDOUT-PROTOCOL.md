# Frozen one-million-pair-per-code persistence holdout

## Scope and fixed sample

Development uses only the preceding seed-20261027 sample. The development
pilot and full audit, including unsuccessful candidates, are retained. This
protocol and the detector/runner/source hashes are frozen before generating
any holdout noise or decoding outcomes.

For each of Previous best and Minimum 4, draw exactly 1,000,000 fresh 252-bit
Bernoulli(p=0.04) Z-error patterns. Use independent Python Random streams
90316268011 and 90316268012 respectively. Within each code, original and merged
representations receive identical errors. Total: 2,000,000 independent patterns
and 4,000,000 primary decodes. Do not pool with development or enlarge the
sample in response to significance or mechanism coverage.

Keep the exact [[252,10,10]] codes, original H_Z spans, original/merged H_X
rows, perfect syndrome, alpha=0.8, 20-bit integer scale, +/-50 clipping,
100-iteration limit and first-syndrome-match stop unchanged. Read-only hooks
record incoming q states and decisions; they do not change decoder updates or
stop on detected certificates. Validate terminal outputs against the original
unmodified C++ decoder and selected full states against direct Python equations.

## Three frozen candidate mechanisms

1. **Exact state recurrence:** find the first pair of equal full incoming q
   arrays within iterations 1..100, checking equality beyond the hash. The
   intervening decisions must reject. Period one and longer cycles are reported
   separately. This certifies infinite persistence under the fixed autonomous
   update, conditional on reaching the supplied state.
2. **Invariant interval box:** enclose the last eight available incoming q
   arrays of a failed run. Apply at most 32 monotone hull-expansion passes.
   Certify only if the box is forward invariant and at least one actual check
   has a fixed incorrect syndrome for every enclosed state. The computation is
   skipped on an accepting run, whose final q is necessarily not in such a
   rejecting box. This is a terminal certificate, not an early predictor.
3. **Finite-horizon interval tube:** enter at the incoming state for iteration
   75, with every coordinate independently perturbed by at most **one integer
   unit** (2^-20 LLR), clipped to the existing bounds. Propagate sound intervals
   for the 26 updates 75..100. The primary variant requires one and the same
   actual check to be uniformly wrong throughout. A broader secondary variant
   permits a different uniformly wrong check at each update. Record the first
   failed enclosure step, and do not widen the radius or change the entry time
   after viewing holdout data. This certifies only the remaining horizon and
   a very small neighborhood. It is not a basin-of-attraction or causal claim.

The primary certificate is the union of exact recurrence, invariant box and
single-pinned-check tube. The changing-check tube and repeated hard-decision
suffix are reported separately. The latter has no persistence claim. The
25/50/75 entry by 1/1024/65536 radius grid was development only; the chosen
75/1 rule is the only tube rule used on the holdout.

## Outcomes and reporting

Score success by membership of error XOR estimate in the **full Z-stabilizer
span**, including degenerate recoveries. Separate exact, stabilizer-equivalent,
syndrome and logical outcomes. Primary performance contrasts are merged minus
original FER within each code; give paired 95% intervals and simultaneous
Bonferroni 95% intervals for the two contrasts. Syndrome contrasts and all
mechanism coverage are secondary descriptive results.

Report all certificate rates among syndrome failures, absolute counts, and
Wilson intervals. For syndrome-discordant pairs, report certified lost matches
and certified gained matches separately; their difference is a descriptive
partition of the syndrome penalty. Also report both-failed pairs where only
one arm certifies. Do not interpret certificate counts as isolated causal
contributions, or treat soundness-by-definition as measured predictive accuracy.

Retain packed per-error outcomes, iterations and detector fields. Retain the
first example for each pair of transition class (both succeed, harmed, rescued,
both fail) and failed arm/certificate type, plus the first example of each
nonzero mechanism per arm. Selection is by increasing within-code index.
Independently replay all retained examples; select the first pinned harmed
merged example per code for prospective concrete Lean certificates if feasible.
Failures of a frozen implementation check invalidate the affected run; do not
silently tune a detector on holdout outcomes.

## Formal scope

Lean work will target deterministic persistence, sound interval propagation,
and concrete state certificates. Full C++ extraction and reachability of the
entry state remain external replay bridges unless separately proved. A lack
of useful exact cycles or boxes is a reportable negative result. No general
error-floor predictor, isolated absorbing-count effect or newly completed
source target follows solely from this holdout.
