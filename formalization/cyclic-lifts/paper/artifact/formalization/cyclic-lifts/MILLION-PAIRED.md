# One million fresh distance-matched paired errors

At the fixed primary p = 4%, Previous best failed on **27,476/1,000,000
(2.7476%)** and Minimum 4 failed on
**25,787/1,000,000 (2.5787%)**.
Minimum 4 minus Previous best is **-0.1689 percentage points**, with
paired 95% interval **[-0.2101, -0.1277] points**.
The interval excludes zero in favor of Minimum 4.

## Fixed comparison and independent sample

This is the [prespecified one-million-pair follow-up](MILLION-PAIRED-PROTOCOL.md)
to the [earlier exact-distance audit and 100,000-pair comparison](DISTANCE-MATCHED.md).
Both codes have exact parameters `[[252,10,10]]`, girth eight and connected
Tanner graphs. Previous best has 2,646 four-variable absorbing supports;
Minimum 4 has 2,520. No matrix, coordinate labeling, decoder setting, channel,
or scoring rule changed.

The new seed is 20261025. One million independent Bernoulli error patterns
were shared across the codes: **two million decoder evaluations**, rather
than two million independent errors. Only p = 0.04 was tested. The old sample
was used for planning and is not pooled into this primary estimate. The run
stopped at the fixed sample size, with no tuning or extension based on results.

The unchanged decoder is flooding normalized min-sum, alpha 0.8, at most
100 iterations, twenty fractional bits and absolute LLR clipping at 50.
This is one Pauli sector with perfect syndrome, and recovery modulo the full
companion stabilizer span counts as success.

## Measured outcomes

| Quantity | Previous best | Minimum 4 |
| --- | ---: | ---: |
| Total failures | 27,476 | 25,787 |
| Failure rate | 2.7476% | 2.5787% |
| Marginal Wilson 95% interval | [2.7157, 2.7798]% | [2.5478, 2.6099]% |
| Syndrome failures | 27,020 | 25,458 |
| Syndrome-matched logical failures | 456 | 329 |
| Exact recoveries | 913,854 | 914,861 |
| Successful nonzero stabilizer residuals | 58,670 | 59,352 |
| Mean iterations | 9.04305 | 8.89973 |

Paired discordances: **22,923** errors failed only
on Previous best, and **21,234** failed only on
Minimum 4. Both failed on 4,553.
The difference interval uses these paired outcomes, not an independence
assumption between the two codes. Relative failure reduction is 6.15%.

## Did one million help, and is a larger sample necessary?

The earlier independent p = 0.04 estimate was -0.0220 percentage points,
with interval [-0.1532, +0.1092]. It did not establish a winner. Its small
point estimate was uncertain; it was not a reliable forecast of this run's
effect size. Both results remain available rather than replacing the pilot.

The new interval has half-width **0.0412 percentage points**. At the old
discordance estimate, the anticipated half-width was 0.0415 points, about
3.16 times narrower than the earlier interval. If the true effect were only
the old estimate of 0.022 points, roughly 7.27 million pairs would be needed
for 80% power in an approximate two-sided 5% test. That planning scenario
does not imply we must collect that many after observing this replication.

For context, plugging the new effect and discordance estimates into that
same planning approximation gives about 121,485 pairs for 80% power.
This is a hypothetical future-study calculation, not retrospective power
evidence or a guarantee. For tighter precision, a chosen interval half-width
of 0.02 percentage points would require about
4,240,409 pairs at the new variance estimate.
No larger run has been started.

This finite result compares two codes at one noise level under one fixed
decoder. Matching length, dimension and minimum distance removes those
confounds, but does not match logical multiplicities, weight spectra, or
message dynamics. It therefore does not isolate absorbing count as the
cause, establish a universally superior optimization objective, or complete
the source's general decoding-performance program. No new Lean theorem
is asserted by this Monte Carlo experiment.

## Reproduce and audit

From the repository root:

```sh
python3 formalization/cyclic-lifts/search/million_paired.py
python3 scripts/validate_cyclic_million_paired.py
python3 formalization/cyclic-lifts/search/report_million_paired.py
```

The runner uses batches of 20,000 for bounded memory. A separate check
compares split and unsplit decoding on 24 code/frame cases. The decoder's
128 direct message-equation reference cases and 638 total checks pass;
12 actual new-stream outcomes at batch boundaries are also checked against
the direct Python decoder. Every full-run syndrome-match flag is verified
from the residual, and every recovery is scored using full stabilizer-span
membership. The independent validator regenerates all one million errors,
checks batch and full-stream hashes, decompresses both failure streams,
and reconstructs counts, paired intervals, Wilson intervals and reference
replays. Frozen source and original-experiment hashes are checked unchanged.

[Frozen selection](search/million-paired-selection.json) ·
[Full results and compressed outcome streams](search/million-paired-results.json) ·
[Progress log](million-paired-run.log) ·
[Validation log](million-paired-checks.log) ·
[Verification manifest](million-paired-verification.json).

This follow-up is local; publication of it is a separate action.
