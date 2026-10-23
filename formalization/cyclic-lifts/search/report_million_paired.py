"""Generate the separately archived follow-up report from saved outcomes."""
from pathlib import Path
import json
import math

HERE = Path(__file__).resolve().parent
d = json.loads((HERE/'million-paired-results.json').read_text())
a,z = (next(r for r in d['results'] if r['design']==name)
       for name in ('previous_best','minimum_4'))
c = d['paired_comparison']
lo,hi = c['paired_normal_95_interval']
delta = c['failure_rate_difference']
n = d['independent_noise_patterns']
half = (hi-lo)/2
q = (c['reference_failed_design_succeeded']+c['reference_succeeded_design_failed'])/n
v = q-delta**2
required = math.ceil((1.959963984540054+.8416212335729143)**2*v/delta**2) if delta else None
verdict = ('The interval excludes zero in favor of Minimum 4.' if hi<0 else
           'The interval excludes zero in favor of Previous best.' if lo>0 else
           'The interval includes zero; this replication does not establish a winner.')
relative = (a['failure_rate']-z['failure_rate'])/a['failure_rate']*100
text = f'''# One million fresh distance-matched paired errors

At the fixed primary p = 4%, Previous best failed on **{a['failure_count']:,}/1,000,000
({100*a['failure_rate']:.4f}%)** and Minimum 4 failed on
**{z['failure_count']:,}/1,000,000 ({100*z['failure_rate']:.4f}%)**.
Minimum 4 minus Previous best is **{100*delta:+.4f} percentage points**, with
paired 95% interval **[{100*lo:+.4f}, {100*hi:+.4f}] points**.
{verdict}

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
| Total failures | {a['failure_count']:,} | {z['failure_count']:,} |
| Failure rate | {100*a['failure_rate']:.4f}% | {100*z['failure_rate']:.4f}% |
| Marginal Wilson 95% interval | [{100*a['wilson_95_interval'][0]:.4f}, {100*a['wilson_95_interval'][1]:.4f}]% | [{100*z['wilson_95_interval'][0]:.4f}, {100*z['wilson_95_interval'][1]:.4f}]% |
| Syndrome failures | {a['syndrome_failure']:,} | {z['syndrome_failure']:,} |
| Syndrome-matched logical failures | {a['matched_logical_failure']:,} | {z['matched_logical_failure']:,} |
| Exact recoveries | {a['exact_recovery']:,} | {z['exact_recovery']:,} |
| Successful nonzero stabilizer residuals | {a['stabilizer_equivalent_success']:,} | {z['stabilizer_equivalent_success']:,} |
| Mean iterations | {a['mean_iterations']:.5f} | {z['mean_iterations']:.5f} |

Paired discordances: **{c['reference_failed_design_succeeded']:,}** errors failed only
on Previous best, and **{c['reference_succeeded_design_failed']:,}** failed only on
Minimum 4. Both failed on {a['failure_count']-c['reference_failed_design_succeeded']:,}.
The difference interval uses these paired outcomes, not an independence
assumption between the two codes. Relative failure reduction is {relative:.2f}%.

## Did one million help, and is a larger sample necessary?

The earlier independent p = 0.04 estimate was -0.0220 percentage points,
with interval [-0.1532, +0.1092]. It did not establish a winner. Its small
point estimate was uncertain; it was not a reliable forecast of this run's
effect size. Both results remain available rather than replacing the pilot.

The new interval has half-width **{100*half:.4f} percentage points**. At the old
discordance estimate, the anticipated half-width was 0.0415 points, about
3.16 times narrower than the earlier interval. If the true effect were only
the old estimate of 0.022 points, roughly 7.27 million pairs would be needed
for 80% power in an approximate two-sided 5% test. That planning scenario
does not imply we must collect that many after observing this replication.

For context, plugging the new effect and discordance estimates into that
same planning approximation gives about {required:,} pairs for 80% power.
This is a hypothetical future-study calculation, not retrospective power
evidence or a guarantee. For tighter precision, a chosen interval half-width
of 0.02 percentage points would require about
{math.ceil(1.959963984540054**2*v/(.0002**2)):,} pairs at the new variance estimate.
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
'''
(HERE.parent/'MILLION-PAIRED.md').write_text(text)
