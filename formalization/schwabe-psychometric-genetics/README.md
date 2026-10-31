# Schwabe (2016): whole-dissertation replication checkpoint

This study covers **the entire dissertation**, not a selected table. Chapter 6's
planned 96,000 method fits are complete, with zero guard-invalid fits or failed
datasets. The whole-dissertation replication remains incomplete. The terminal
[analysis](production/chapter6-v1/terminal-analysis/summary.json) and
[independent numerical review](provenance/terminal-analysis-independent-review.json)
are separate from the manuscript below, which still describes the earlier
20-repetition analysis and is awaiting replacement and fresh rendered review.
[coverage.csv](coverage.csv)
tracks 41 original empirical, numerical, analytical and software result groups,
with source locators, actual attempts, dependencies and remaining work. The full
996-record source inventory is in
[claim-specification-applicability.json](handoff/claim-specification-applicability.json);
these records include shared components and are not independent replication counts.
No study PR has been created, and no merge is authorized.

The primary manuscript is
[whole_dissertation_replication__schwabe_psychometric_genetics.pdf](paper/whole_dissertation_replication__schwabe_psychometric_genetics.pdf).
Its editable source is [paper.tex](paper/paper.tex), with
[references.bib](paper/references.bib). Repository links to `master` in the PDF
are intended navigation links and await merge. Use the commit-pinned links in
the delivery record for the corresponding artifact revision.

## What is established and what remains open

The full source was read, its PhD metadata checked, all twelve public author
repositories cloned, and the substantive results inventoried. All stated
simulation conditions receive execution attempts, including untabulated results
and the 2%/3% missingness ambiguity. Missing original NTR/Cito and Virginia30K
inputs block empirical refits. Published-summary calculations do not replace
those refits. The curvilinear simulation lacks a recoverable design/driver.

Short JAGS chains are resource and execution diagnostics, **not convergence,
power, or table-replication evidence**. Full-length Chapter2 fits are separate
from the short grid. Chapter 6 now has 1,000 datasets in each of 36 primary
conditions and 12 additional 3% missingness sensitivity conditions, with both
methods fitted to each dataset. Chapters 2–5's full Bayesian targets remain open.
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
- Runnable reviewed baseline replication revision: `69a9ed24224be8e0958074c24ea04777c7d1f9db`.
  Preserved baseline revision: `9c91e89e3f3327dd9dcc3ea96fa47ef84f1e8e4b`.
  This is distinct from the historical baseline. The artifact revision and
  remote-byte checks are recorded in [provenance/delivery.json](provenance/delivery.json).

The following later immutable commits contain the continuation tools; the
baseline revision above does not contain all of them:

- Guarded model/runner and identification audit:
  `59dfd3f69d6ba5ce6d942d63dfff1f367d8f80fc`.
- Frozen production analysis and independent validation:
  `08e0d9747175e924c1f2c7e5dbe5658deb4d1a15`.
- Prepared, independently reviewed JAGS gate:
  `94da8ffb9bdb84fab1e81387dca145d93878779c`.
- Illustration audit: `66a896f2844c1fb5bfb1fed0f4e8e927f5e73e5e`.
- A common runnable checkpoint containing all these tools, the archive saver,
  and dated production evidence:
  `6b4e010302a4c916b46153476df4c1e6c80957e1`.

The terminal Chapter 6 analysis is saved at
`a9e7bd4a70cfa3a40f89d3525efd0dd98a5f033a`; its
[reproduction recipe](handoff/terminal-reproduction.md) and
[remote-byte verification](provenance/terminal-analysis-publication.json) are
available. This is distinct from a passed Bayesian diagnostic or a reviewed new
manuscript. Use a separate checkout when replaying commands that write outputs.
The existing manuscript still describes the preserved baseline.

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

These are historical source-count command interfaces, not claims that full runs were performed. For the active Chapter6 continuation use the guarded supervisor below, rather than starting a second legacy grid. The largest Chapter5 condition alone projects to months of single-worker elapsed
work from an actual timing pilot. No production-completion claim is made.

## Rebuild the baseline report from saved outputs

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

The guarded production implementation below records finite estimates,
Hessian/covariance validity and nonnegative delta-method variances in addition
to optimizer status. Its separate analysis excludes guard-invalid fits from
parameter summaries while retaining their denominators; the old baseline
`pmax(0, ...)` behavior is not used to admit production fits.
No invalid/nonpositive SE was found in the14400 saved baseline parameter rows.
JAGS continuation needs independent chains and bulk/tail convergence checks;
source-length execution alone is not convergence. The active guarded continuation has a fixed wall-time cap.

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
The initial `checkpoint-bundle.tar.gz` includes ignored job directories, run
logs, receipts, identity and frozen inputs. Its hash is recorded in
[recovery-save.json](provenance/recovery-save.json). Later completed invocations
are saved separately in `archives/`, with hashes and counts in
[archive-index.json](production/chapter6-v1/archive-index.json). The initial
bundle alone does not restore the later production progress.

To save a checkpoint without launching fits:

```sh
python3 simulation/save_production_checkpoint.py --namespace production/chapter6-v1
```

This archives completed runner invocations, exports dated reports, and copies
active logs. An active log snapshot may end mid-line; it is not a completed
checkpoint. Active chunks remain local until completed and archived. Neither
archive counts nor log snapshots establish the target has finished.

For recovery, use a fresh checkout of the matching immutable code and pinned
runtime, with no active supervisor and no existing `jobs/` or `runs/`. Verify
both the initial bundle and every indexed archive before extraction:

```sh
python3 - <<'PYVERIFY'
import hashlib, json, pathlib
root = pathlib.Path('production/chapter6-v1')
initial = json.loads(pathlib.Path('provenance/recovery-save.json').read_text())
records = [{'path': initial['bundle_path'], 'sha256': initial['bundle_sha256']}]
records += json.loads((root / 'archive-index.json').read_text())['archives']
for record in records:
    path = pathlib.Path(record['path'])
    assert hashlib.sha256(path.read_bytes()).hexdigest() == record['sha256'], path
print('All recovery archive hashes match')
PYVERIFY
tar -xzf production/chapter6-v1/checkpoint-bundle.tar.gz -C production/chapter6-v1
python3 - <<'PYRESTORE'
import json, pathlib, subprocess
root = pathlib.Path('production/chapter6-v1')
for record in json.loads((root / 'archive-index.json').read_text())['archives']:
    subprocess.run(['tar', '--skip-old-files', '-xzf', record['path'],
                    '-C', str(root)], check=True)
PYRESTORE
python3 simulation/production_status.py --namespace production/chapter6-v1 --export
```

`--skip-old-files` preserves overlap with the initial immutable bundle. The
export validates restored checkpoint identities and output hashes; any mismatch
requires diagnosis before resuming. This procedure is only for a fresh recovery
checkout, never for overwriting active or newer local work. Pending requests and
partial logs without archived completion are not recovered successful fits.
Inspect the dated status and failed requests, then use the bounded supervisor
command above to continue only eligible jobs.

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


## Frozen production analysis, separate from the baseline

[analysis-plan.json](production/analysis-plan.json) was recorded before inspecting
new production effect summaries; baseline results and operational counts were
already known. Independent validation is recorded in
[production-analysis-review.json](provenance/production-analysis-review.json)
and [production-analysis-independent-validation.json](outputs/production-analysis-independent-validation.json).
The 13 checks include exact baseline agreement and adversarial input validation.
Replaying the validation starts no fits:

```sh
python3 simulation/test_production_analysis.py
```

After the supervisor has reached its terminal state (completed target or fixed
cap/failure), export its final checkpoint and analyze into a **new, empty**
directory. A terminal state at the cap is still an incomplete simulation grid.
These commands are the planned terminal analysis, not a statement it has run:

```sh
python3 simulation/production_status.py --namespace production/chapter6-v1 --export
python3 simulation/analyze_production.py \
  --reports production/chapter6-v1/reports \
  --output-dir production/chapter6-v1/terminal-analysis \
  --source outputs/source-figure-values.csv \
  --plan production/analysis-plan.json
```

To generate separate manuscript macros and tables from that saved analysis:

```sh
python3 simulation/build_production_report.py --analysis-dir production/chapter6-v1/terminal-analysis --output-dir paper
```

This creates `production-results.tex` (`\Prod...` macros),
`production-comparison.tex`, `production-reversals.tex`,
`production-bias-example.tex`, `production-denominators.tex` and
`production-notes.tex`. Include the notes with the tables so metric and source
uncertainty limits remain visible. `production-build-provenance.json` records
the exact command, input/output SHA256s, analyzer provenance and representative
unrounded input rows. Display numbers use ten significant digits; this does not
assert that the source has that precision. Existing generated files are refused.
The builder does not edit `paper.tex` or the baseline builder. Replaying
`OPENBLAS_NUM_THREADS=1 python3 simulation/test_production_report.py` uses only
the preserved baseline and temporary outputs, including a temporary LaTeX build.
These commands do not imply that terminal analysis or paper integration is done.

The analyzer verifies exported hashes and ledger identities, retains all96
condition/method cells, and counts historical guarded replays exactly once.
Requested, completed, guard-valid, guard-invalid, process-failed, pending and
not-yet-requested denominators remain separate. Its720 parameter summaries,
288 signed SE contrasts,504 source comparisons and72 signed MAR bias contrasts
are saved separately from baseline `outputs/`. Variance SE and exploratory path
SE comparisons remain distinct; the2% primary and3% sensitivity conditions are
not pooled. The declared families, two-MCSE intervals, adjusted intervals and
source extraction bounds do not recover unknown source Monte Carlo error.
Interim summaries are descriptive and never a significance-based stopping rule.
Passing numerical guards is not proof of global convergence, and completion of
attempts is distinct from successful whole-dissertation replication. The baseline
report builder does not automatically incorporate these production outputs;
scientific and rendered-PDF review is required before a revised paper is delivered.

## Analytical and source-illustration audits

```sh
python3 simulation/identification_check.py --source-pdf /tmp/schwabe-thesis/thesis_I_Schwabe.pdf
OPENBLAS_NUM_THREADS=1 python3 simulation/illustration_followup.py /tmp/schwabe-thesis/thesis_I_Schwabe.pdf --render-crops
```

The first writes `provenance/identification-check.json` and the attributed p72
crop. Its algebraic covariance checks and likelihood counterexample do not
establish full marginal item-model identification or empirical consequences.
The second writes `provenance/illustration-followup.json` and limited source
crops for Figures1.3 and7.1. It checks source curve/marker geometry with explicit
coordinate bounds. Plot-derived sample moments and plausible generating values
do not recover an original seed, driver, or raw-data simulation. Both audits
preserve the numerical baseline; they require the locally acquired, hash-checked
thesis for source evidence.

## Prepared JAGS convergence gate: no new chains run

[jags-gate-setup.json](provenance/jags-gate-setup.json) and
[jags-gate-independent-review.json](provenance/jags-gate-independent-review.json)
record accepted setup and diagnostic-fixture review. No actual JAGS compilation,
new chain execution, or convergence success is established by those tests.
The separate `posterior`1.6.1 library and exact package hashes are recorded in
[posterior-runtime-packages.json](provenance/posterior-runtime-packages.json);
the shared production R runtime is unchanged. Rebuild that separate library only
in a fresh destination using the permitted archives and bootstrap manifest:

```sh
python3 simulation/bootstrap_posterior_library.py --library /workspace/slot3-posterior-library --cache /tmp/slot3-posterior-debs
R_LIBS_USER=/workspace/slot3-posterior-library Rscript simulation/jags_convergence_gate.R prepare /tmp/schwabe-gate-preparation-final-v4
OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 MKL_NUM_THREADS=1 Rscript simulation/test_jags_gate_setup.R
OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 MKL_NUM_THREADS=1 Rscript simulation/test_jags_gate_independent.R
```

The setup fixture uses the exact temporary preparation path above, which must
be absent or empty; preparation refuses to overwrite an existing namespace.
These fixture scripts also use the pinned `/workspace/slot3-runtime/bin/Rscript`
launcher internally. Skip bootstrap if that verified library already exists.

Only after OpenMx reaches its terminal state and CPU availability is checked,
prepare a new permanent namespace and freeze its exact input/code/runtime hashes:

```sh
R_LIBS_USER=/workspace/slot3-posterior-library Rscript simulation/jags_convergence_gate.R prepare production/jags-gate-v1
```

Preparation generates the fixed seed301 dataset, model, four initial states and
hash manifest without sampling. The reviewed execution interface is
`Rscript simulation/jags_convergence_gate.R run production/jags-gate-v1 CHAIN_ID`
for each of chain IDs1–4. Dispatch must externally enforce1800seconds per chain,
a7200worker-second initial-batch ceiling, full-process-group termination on
timeout and retained logs/exit status; the wrapper does not enforce wall limits.
No replacement chains, automatic extensions, or favorable-result stopping is
permitted. Once all four requested outcomes are preserved, diagnostics run via:

```sh
R_LIBS_USER=/workspace/slot3-posterior-library Rscript simulation/diagnose_jags_gate.R production/jags-gate-v1
```

Inspect every trace/rank page and interval-endpoint sensitivity, retain failed or
incomplete-chain outcomes, and obtain independent scientific outcome review.
Even acceptable diagnostics on this one dataset would not establish100-dataset
Chapter2 power/recovery, Chapter5 production, or whole-dissertation success.

### Bounded JAGS dispatcher (awaiting independent dispatcher review)

The study-specific dispatcher keeps the frozen gate wrappers unchanged. It must
be independently reviewed before use. The following are future execution commands,
not evidence of a started gate. Run from this study directory:

```sh
python3 simulation/dispatch_jags_gate.py check --namespace production/jags-gate-v1
python3 simulation/dispatch_jags_gate.py dispatch --namespace production/jags-gate-v1
# Only after all four outcomes have been recorded:
python3 simulation/dispatch_jags_gate.py diagnose --namespace production/jags-gate-v1
```

`check` is read-only and refuses active OpenMx supervisor/runner/batch or JAGS
processes. `dispatch` requires at least four CPU slots under both affinity and cgroup quotas, and an empty/new
namespace. It requires1GiB initial/serial cgroup memory headroom; this allocation floor
is operational policy, not a measured requirement or sufficient-memory guarantee. It records current and ancestor memory
limits/usage, takes a separate study dispatcher lock, checks pinned code/runtime
identities, and prepares its inputs inside `production/jags-gate-v1/prepared`.
Do not use the earlier manual preparation command on the dispatcher namespace.
The dispatcher records exact commands, environment overrides, full installed
runtime/library file hashes and prepared identities, rechecking these runtime bytes
and dispatcher/protocol hashes at phase boundaries, before launching the prescribed chain1 alone. The dispatcher samples its
process-tree RSS every0.2seconds through initialization/adaptation, then considers
launching prescribed chains2–4. Readiness uses only existence of `adaptation.rds`,
never adaptation success or posterior effects. Parallel release requires a positive
RSS sample and headroom for every remaining chain at `max(2 * measured peak RSS,
1 GiB)` each. This safety factor is policy; sampled RSS is not a peak guarantee and
can double-count shared pages. Otherwise the remaining chains run serially, with
headroom checked again before each launch. No extra model or replacement chain is
used to measure resources. All chains remain single-threaded. Each has a1800-second wall allowance
(including startup), totaling7200 planned worker-seconds. A timeout sends TERM
to the whole process group, then KILL after five seconds; cleanup overhead is
recorded separately from the allocation. The batch has a7220-second wall ceiling
with five seconds reserved for cleanup (subject to0.05-second polling precision);
if that bound or resources prevent launch, requested chains remain explicitly
`not_launched`. Actual maximum concurrency and release decisions are recorded. No retries, extensions or replacements
are performed. Logs, wrapper requests and all four requested outcomes survive
failure or interruption. An uncatchable OS kill/power loss can leave a running
ledger; inspect processes and preserved files manually before taking any action.
Process scans prevent dispatch alongside observed OpenMx jobs and abort if one
appears later; they cannot prevent an independently started external process
between scans. Do not start another workload during this gate.

`diagnose` is a separate bounded command and preserves its own exit status/log;
it does not certify convergence. Read the actual diagnostic artifacts and retain
all incomplete-chain denominators. Manual interval precision review and independent
scientific review remain required. The dispatch protocol is
[jags-dispatch-protocol.json](provenance/jags-dispatch-protocol.json). Harmless
process-only fixtures (no R/model/sampling) can be replayed with:

```sh
python3 simulation/test_jags_dispatch.py
```


## Calibrated item identification arguments

The independently reviewed ordinary argument in
[provenance/joint-item-identification-check.json](provenance/joint-item-identification-check.json)
uses one item marginal and a within-person two-item joint probability. It
conditionally covers known finite positive unequal item slopes; identical
calibrations require distinct conditionally independent item observations. The
empirical observation/calibration/support assumptions remain unverified, and
Lean formalization is absent. This is not a finite-sample maximum or convergence
claim. The independent review is
[provenance/joint-item-identification-independent-review.json](provenance/joint-item-identification-independent-review.json).

The preserved known-Rasch marginal-probability argument is in
[provenance/marginal-identification-check.json](provenance/marginal-identification-check.json).
Re-execute the symbolic identities with Python 3.12 and SymPy 1.14.0:

```sh
python3 simulation/marginal_identification_check.py
python3 simulation/joint_item_identification_check.py
```

These start no model fits or simulations. They regenerate dated argument
records; historical independent-review hashes identify the saved reviewed
records, not newly timestamped regenerations. The likelihood counterexample
and covariance/path identities remain in the separate identification audit.
