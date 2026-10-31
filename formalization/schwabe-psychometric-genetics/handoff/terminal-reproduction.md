# Reproducing the terminal Chapter 6 analysis

The complete Chapter 6 evidence is available at immutable repository commit
`a9e7bd4a70cfa3a40f89d3525efd0dd98a5f033a`. Run the following commands from
`formalization/schwabe-psychometric-genetics` in a separate checkout of that
revision. Python requires NumPy and SciPy. The saved aggregate reports are the
analysis inputs; these commands do not start model fits.

```sh
python3 simulation/analyze_production.py \
  --reports production/chapter6-v1/reports \
  --output-dir /tmp/schwabe-analysis-replay \
  --source outputs/source-figure-values.csv \
  --plan production/analysis-plan.json
python3 simulation/build_production_report.py \
  --analysis-dir /tmp/schwabe-analysis-replay \
  --output-dir /tmp/schwabe-report-replay
```

Use new output directories. Numerical CSV outputs should agree with the saved
`production/chapter6-v1/terminal-analysis` outputs; provenance timestamps and
input/output paths are not numerical reproducibility targets. The original
analysis snapshot is
`725ef2ff7f95a4d9967fefec1ea956844680bd09a1419d761bc0c12b662bb585`.
Its component hashes and mapping to 408 source claim IDs are retained in
`handoff/chapter6-result-mapping.json`.

There are 48,000 generated datasets and 96,000 method fits: 36 primary
conditions with 1,000 datasets each and 12 additional 3% missingness sensitivity
conditions with 1,000 datasets each. Each dataset supplies full-information and
deletion fits. The original 1,920 method fits are included once, after exact
guarded replay. All 96,000 fits pass the recorded numerical guards; none is
excluded. Guard validity is not a certificate of a global likelihood maximum.

The frozen analysis separates variance standard errors, exploratory path
standard errors, signed deletion-minus-full precision contrasts, and signed
estimate-minus-truth biases. Source extraction bounds are geometric bounds;
unknown original Monte Carlo uncertainty is not supplied by those bounds.
The source's 2% prose/3% plot ambiguity remains explicit.

Model-fit reproduction additionally requires the pinned R/OpenMx runtime in
`provenance/runtime-packages.json`, the immutable model identities in
`production/protocol.json`, and the recorded runner/supervisor commands and
seed manifest. The existing README documents bootstrap and execution commands.
Use a fresh namespace and preserve the full denominator, including failures.
The completed production supervisor took 25,756.392 seconds on four CPU slots;
this is an observed duration, not a promise for another environment.

This recipe establishes reproducibility of Chapter 6's completed reconstruction.
It does not supply unavailable empirical inputs or complete Chapters 2–5's
Bayesian simulation targets. Their source claims remain in the whole-dissertation
inventory with their actual attempts and limitations.
