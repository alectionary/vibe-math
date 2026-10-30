# Schwabe (2016): whole-dissertation replication checkpoint

This study covers **the entire dissertation**, not a selected table. The current
result is an incomplete replication checkpoint. [coverage.csv](coverage.csv)
tracks 41 original empirical, numerical, analytical and software result groups,
with source locators, actual attempts, dependencies and remaining work. A draft
PR is a review milestone, not completion or approval to merge.

The primary manuscript is
[whole_dissertation_replication__schwabe_psychometric_genetics.pdf](paper/whole_dissertation_replication__schwabe_psychometric_genetics.pdf).
Its editable source is [paper.tex](paper/paper.tex), with
[references.bib](paper/references.bib). Repository links to `master` in the PDF
are intended navigation links and await merge. Use the commit-pinned links in
the PR/delivery record for this draft.

## What is established and what remains open

The full source was read, its PhD metadata checked, all twelve public author
repositories cloned, and the substantive results inventoried. All stated
simulation conditions receive execution attempts, including untabulated results
and the 2%/3% missingness ambiguity. Missing original NTR/Cito and Virginia30K
inputs block empirical refits. Published-summary calculations do not replace
those refits. The curvilinear simulation lacks a recoverable design/driver.

Short JAGS chains are resource and execution diagnostics, **not convergence,
power, or table-replication evidence**. Full-length Chapter2 fits are separate
from the short grid. Chapter6 runs are a smaller Monte Carlo checkpoint than the
original1000 repetitions per condition. Full production targets stay open.
Independent scientific and rendered-manuscript reviews are recorded in
[provenance/review.json](provenance/review.json), including initial findings and
final artifact hashes. Review does not close unfinished replication items.

## Source and immutable provenance

- Dissertation: Inga Schwabe, *Nature, Nurture and Item Response Theory: A
  Psychometric Approach to Behaviour Genetics*. University of Twente PhD,
  defended24March2016; final published version,154numbered pages/164PDF pages.
  DOI[10.3990/1.9789036540735](https://doi.org/10.3990/1.9789036540735).
- Local original source repository revision:
  `6c2c48901209fc76ba932bb094c61abba5ef160d`.
- PDF SHA256:
  `67dd29d98bc440b96a197a1ef1771dd3611823bceba428a1f66829ca099d7d28`.
- Current BayesTwin:
  `656afd72d45ecd13f54b72c9400cceface8d423f`; pre-defense version:
  `a8e5d6b5ee6a8c76bdd0234a00fbcc809712ac08`.
- Historical repository baseline and approved layout:
  `e2b553c06c872d8008061a26d05831e572e54789`.
- Runnable reviewed replication revision: `69a9ed24224be8e0958074c24ea04777c7d1f9db`.
  Preserved baseline revision: `9c91e89e3f3327dd9dcc3ea96fa47ef84f1e8e4b`.
  This is distinct from the historical baseline. The artifact revision and
  remote-byte checks are recorded in [provenance/delivery.json](provenance/delivery.json).

## Prerequisites and local runtime

Run every command below from `formalization/schwabe-psychometric-genetics/` in
the immutable replication checkout. Python3 needs NumPy, SciPy, Matplotlib and
PyMuPDF; LaTeX needs pdflatex/BibTeX and the packages in the approved preamble.
R4.5.0, lavaan0.6.19, OpenMx2.21.13, JAGS4.3.2, rjags4-16, coda0.19-4.1,
MASS7.3-65, matrixStats and foreign were used. Exact Debian package versions
and SHA256s are in [runtime-packages.json](provenance/runtime-packages.json).

The tested R launcher is `/workspace/slot3-runtime/bin/Rscript`. It starts the
real Debian R executable with relocated library paths; it is not an R emulator.
System installation was unavailable to this account. Public Debian packages
were downloaded and extracted into the workspace. To relocate the same runtime
elsewhere, acquire the exact `.deb` archives listed in the manifest through a
permitted Debian package source, then run:

```sh
python3 simulation/bootstrap_runtime.py /tmp/slot3-apt/cache/archives /workspace/slot3-runtime
export PATH=/workspace/slot3-runtime/bin:$PATH
export RSCRIPT=/workspace/slot3-runtime/bin/Rscript
export JAGS_MODULE_PATH=/workspace/slot3-runtime/usr/lib/x86_64-linux-gnu/JAGS/modules-4
export MPLCONFIGDIR=/tmp/mpl-slot3
```

A stock installation of the pinned engines can instead set `RSCRIPT` to its
actual executable and `JAGS_MODULE_PATH` to its JAGS modules directory. Before
fitting, run the repository preflight from the repository root:

```sh
PATH=/workspace/slot3-runtime/bin:$PATH python3 .agents/skills/replication-paper/scripts/preflight.py
```

The original thesis, unlicensed model files and complete third-party source
are **not bundled**. Acquire them locally at the pinned revisions:

```sh
git clone https://github.com/ingaschwabe/Nature-Nurture-and-Item-Response-Theory.git /tmp/schwabe-thesis
git -C /tmp/schwabe-thesis checkout 6c2c48901209fc76ba932bb094c61abba5ef160d
git clone https://github.com/ingaschwabe/BayesTwin.git /tmp/schwabe-author/BayesTwin
git -C /tmp/schwabe-author/BayesTwin checkout 656afd72d45ecd13f54b72c9400cceface8d423f
git -C /tmp/schwabe-author/BayesTwin worktree add --detach /tmp/bayestwin-2016 a8e5d6b5ee6a8c76bdd0234a00fbcc809712ac08
pdftotext -layout /tmp/schwabe-thesis/thesis_I_Schwabe.pdf /tmp/schwabe.txt
```

If any source or transfer is denied, stop that operation. Do not bypass source
or network controls. This study does not authorize contacting the author.

## Re-extract source targets and replay software

```sh
python3 simulation/extract_tables.py /tmp/schwabe.txt
python3 simulation/extract_figures.py /tmp/schwabe-thesis/thesis_I_Schwabe.pdf
python3 simulation/render_source_evidence.py /tmp/schwabe-thesis/thesis_I_Schwabe.pdf
python3 simulation/extract_appendix_g.py /tmp/schwabe.txt
Rscript simulation/original_programs.R
Rscript simulation/appendix_g_check.R
Rscript simulation/bayestwin_check.R
Rscript simulation/historical_bayestwin.R
Rscript simulation/engine_checks.R
python3 simulation/analytic_checks.py
```

These regenerate source-target CSVs, scalar checks, illustrative plots, and
software execution reports under `outputs/`. AppendixG extraction is local
only; whitespace and page-label normalization is documented. Original failures
and narrowly repaired attempts are both retained. No synthetic software smoke
test is labelled an empirical reproduction.

## Rerun simulations and resume checkpoints

The pilot commands retain all conditions. The JAGS grid has25jobs: twelve
sample-size/effect cells, floor/ceiling/symmetric item and sumscore arms, and all
seven Chapter5 sample-size/item-count cells. The OpenMx grid has48conditions:
three missingness mechanisms, four covariate counts, and2%,3%,6%,10% missingness.

```sh
python3 simulation/run_grid.py --engine jags --workers 2
python3 simulation/run_grid.py --engine openmx --replicates 20 --workers 2
```

Every successful process writes a checkpoint with the exact arguments and seed.
Re-running skips completed checkpoints. Inspect output errors and convergence
codes: process completion alone does not establish a valid fit. Per-trial
OpenMx inputs regenerate from seeds and are excluded from git. Per-trial CSVs
are consolidated into [trial-records.csv](outputs/trial-records.csv); local
checkpoint files are retained for continuation. Two initial process-start parse
failures were retried at the identical seeds after the working source was frozen;
[execution-retries.json](outputs/execution-retries.json) preserves both attempts.
All 1,920 final method-by-dataset fits have optimizer status 0.

Full-length Chapter2 confirmation on one shared generated dataset:

```sh
Rscript simulation/jags_replication.R 2 500 60 0 1 301 1000 7000 12000 confirmation-c2-floor
Rscript simulation/original_confirmation.R 2 500 60 0 1 301 1000 7000 12000 unused
Rscript simulation/compare_posteriors.R
Rscript simulation/jags_replication.R 2 500 60 0 1 301 1000 7000 12000 confirmation-c2-floor-sums .5 sums
Rscript simulation/jags_replication.R 2 500 60 0 -1 301 1000 7000 12000 confirmation-c2-ceiling-sums .5 sums
Rscript simulation/jags_replication.R 2 500 60 0 0 301 1000 7000 12000 confirmation-c2-symmetric-sums .5 sums
Rscript simulation/jags_replication.R 5 8000 60 0 0 33021 10 10 10 timing-c5-largest
```

Sensitivity and optimizer checks:

```sh
OPENMX_OPTIMIZER=CSOLNP Rscript simulation/openmx_replication.R 2 .02 MCAR 3001 check-c6-CSOLNP
Rscript simulation/openmx_replication.R 5 .1 MAR 34444 sensitivity-c6-equal 1000 equal
Rscript simulation/openmx_replication.R 5 .1 MAR 34444 sensitivity-c6-unequal 1000 unequal
MEAN_MODE=shared Rscript simulation/openmx_replication.R 5 .1 MAR 34444 sensitivity-c6-sharedmeans
```

Production targets remain100repetitions for Chapter2,250for Chapter5,
and1000for Chapter6. The grid runner's `--mode full` sets the source chain
lengths. The source-count continuation commands are:

```sh
python3 simulation/run_grid.py --engine jags --chapter 2 --mode full --replicates 100 --workers 2
python3 simulation/run_grid.py --engine jags --chapter 5 --mode full --replicates 250 --workers 2
python3 simulation/run_grid.py --engine openmx --mode full --replicates 1000 --workers 2
```

These are unfinished production targets, not claims that the full runs were performed. The largest Chapter5 condition alone projects to months of single-worker elapsed
work from an actual timing pilot. No production-completion claim is made.

## Rebuild the report from saved outputs

The following does not refit any model or recover unavailable empirical inputs:

```sh
python3 simulation/summarize.py
python3 simulation/validate_evidence.py
python3 simulation/build_report.py
cd paper
pdflatex -interaction=nonstopmode -halt-on-error paper.tex
bibtex paper
pdflatex -interaction=nonstopmode -halt-on-error paper.tex
pdflatex -interaction=nonstopmode -halt-on-error paper.tex
cp paper.pdf whole_dissertation_replication__schwabe_psychometric_genetics.pdf
```

`summary.json`, `condition-summary.csv`, `signed-contrasts.csv`, and
`source-comparisons.csv` retain the expected condition inventory and separate
scientific contrasts from ours-minus-source deviations. Figure-derived values
have extraction bounds, not invented original decimal precision. Path-coefficient
SE comparisons are exploratory and not the same estimand as labelled variance
SEs. Our Monte Carlo error does not recover the missing source Monte Carlo error.

## Rights and outstanding review

The full dissertation and unlicensed original programs remain local. Limited
attributed crops support specific scholarly comparisons; their copyright remains
with the source. BayesTwin's GPL source is fetched separately. No third-party
package code or private empirical data is included. Root [LICENSING.md](../../LICENSING.md)
excludes R files, prose, results and source evidence from its original-code grant.
No new content license is asserted here.

Independent reviewers found missing signed bias contrasts and continuation defects.
The revisions preserve the original numerical baseline and record all 72 bias
contrasts, including 23 inconclusive point-sign reversals. Whole-dissertation
replication remains incomplete after review; see
[unfinished-work.json](provenance/unfinished-work.json).

## Reviewed continuation and bounded resource plan

The baseline20-replicate outputs remain unchanged. The default summarizer still
recreates that baseline. Continuation outputs must go to a separate directory;
identical seed/condition duplicates are not counted as new data. Failed or
incomplete checkpoints now stop rather than silently count as successful resumes.
The full-mode item/sum arms now share generated-data seeds within each condition;
the historical pilot-grid arms did not and cannot support paired contrasts.
The saved full-length confirmation already used a shared dataset.

```sh
python3 simulation/bias_contrasts.py
python3 simulation/resource_plan.py
python3 simulation/check_continuation.py
Rscript simulation/openmx_batch.R outputs/batch-validation.tsv
python3 simulation/run_grid.py --engine openmx --mode full --replicates 1000 --start-replicate 20 --max-jobs 48 --dry-run
python3 simulation/summarize.py --include-full --output-dir outputs/continuation-summary
```

The batch wrapper refuses to overwrite existing outputs. For replay, use a clean
worktree or preserve/remove only the already recorded batch-validation outputs
before running. Its12 existing datasets/24fits matched recorded estimates, SEs
and likelihoods exactly; this is execution equivalence on shared inputs, not an
independent scientific replication. The batch validation does not add datasets
to the1920-fit baseline. Source-count Chapter6 continuation projects25.7fit-worker
hours or45.5process-worker hours from the saved timings; ideal4-worker division
is not measured scaling. Chapter2/5 total-pilot extrapolations include startup
and are rough; the separate largest-Chapter5 sampling benchmark remains primary.

Before production, record finite estimates, Hessian/covariance validity and
nonnegative delta-method variances in addition to optimizerstatus. The old
`pmax(0, ...)` code must not conceal invalid variances in a production analysis.
No invalid/nonpositive SE was found in the14400 saved baseline parameter rows.
JAGS continuation needs independent chains and bulk/tail convergence checks;
source-length execution alone is not convergence. No unbounded job was launched.

## Guarded Chapter 6 production continuation

The original paper and 20-replicate numerical baseline remain preserved. New
production is separate under `production/chapter6-v1/`. The protocol targets
48,000 unique datasets / 96,000 method fits. Historical replicates 0–19 are
replayed for the new guards but never count as additional unique datasets.
The fixed model/runner revision is
`59dfd3f69d6ba5ce6d942d63dfff1f367d8f80fc`.

[production-guard-review.json](provenance/production-guard-review.json) records
30 numerical and 21 runner fixtures plus six exact same-data fit checks.
[production-supervisor-review.json](provenance/production-supervisor-review.json)
records independent review of bounded continuation, reporting and failure
preservation. Guard validity is numerical admissibility, not proof of global
convergence, correct missingness assumptions, or whole-dissertation success.

```sh
# From the study root, with the pinned relocated R runtime available:
python3 simulation/production_status.py --export
python3 simulation/production_supervisor.py --namespace production/chapter6-v1 --hours 12 --max-batches 110 --batch-jobs 480
```

The supervisor permits at most four one-thread workers, 480 datasets per batch,
30 minutes per runner invocation and 12 hours total. It stops on operational
failures or fixed limits, never on favorable significance. Every requested,
completed, invalid, failed and in-flight method remains separately counted.
Resume checks code/protocol/runtime and output hashes; failed attempts require
explicit diagnosis rather than silent replacement. Before running, inspect
active processes to avoid duplicating an existing supervisor.

`production/chapter6-v1/reports/progress.json` is the dated progress snapshot.
`guarded-trials.csv.gz` retains valid and invalid parameter rows, and
`checkpoint-ledger.jsonl.gz` retains exact commands/conditions and hashes.
The raw `checkpoint-bundle.tar.gz` includes ignored job directories, run logs,
receipts, identity and frozen inputs. Extract it into `production/chapter6-v1/`
to restore exact completed-job resume state in a fresh checkout. Check its hash
against [recovery-save.json](provenance/recovery-save.json) first. Never overwrite
an active or newer job directory with an older bundle.

The separate analytical check is
[identification-check.json](provenance/identification-check.json), regenerated by
`python3 simulation/identification_check.py`; its source crop can be regenerated
with `--source-pdf /tmp/schwabe-thesis/thesis_I_Schwabe.pdf`. Covariance
identifiability does not imply a unique finite-sample maximum. Full marginal
item-model identification and empirical consequences remain unresolved.
[bayesian-convergence-plan.json](provenance/bayesian-convergence-plan.json)
records a fixed four-chain diagnostic gate; no new Bayesian run has been started.

Validation replay commands are listed in the independent review records:
`Rscript simulation/validate_production_guards.R`,
`python3 simulation/test_production_runner.py`,
`python3 simulation/test_production_reporting.py`, and
`Rscript simulation/validate_guarded_replays.R /tmp/schwabe-independent-guard-check`.
The latter requires the separately generated validation fits identified in the
review; do not replace them with production estimates.
