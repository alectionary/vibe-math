# Kupzyk (2011): simplifying assumptions in power analysis

This investigation reconstructs the dissertation's 54 final exemplary-data cells and runs a reduced empirical simulation across all 54 initial-stage cells. The report separates numerical agreement from reconstruction scope. This PR provides the research report and reproducible artifacts; exact SAS replay is not claimed.

Start with `paper/simplifying_assumptions_in_power_analysis__a_replication_of_kupzyk_2011.pdf` or its editable LaTeX source `paper/report.tex`. The exact manuscript is generated from saved results by `scripts/build_report.py`. `notes/compliance-ledger.json` records adherence and justified departures from the pinned replication skill. `notes/availability.csv` records what source/code was and was not obtained.

## Environment

Repository base: `dbbdda83d1acce5ddd86e9ab7c27d79f2f300e12`. Skill SHA256: `1fd5e51cda8b58c8bcda00c3c43f521a7b1c791771067f1bb3b2125ea572bde3`.

This execution environment uses R4.5.0, lme4 1.1-37, nlme 3.1-168, Matrix1.7-3, lmerTest3.1-3, pbkrtest0.5.4. Full versions are in `outputs/session-info.txt`, `outputs/tool-versions.txt`, and the Debian archive hashes. Required R dependencies were installed locally through authenticated Debian package downloads and extracted under `/workspace/r-runtime`; system files were not changed. Source `/workspace/r-runtime/env.sh` in this executor. On another machine install these R packages and inspect versions before claiming an identical rerun. Set BLAS/OpenMP to one thread and at most three simulation workers within the four-core budget. SAS/Optimal Design2.0 are not available here.

## Regenerate results

Run every command below from the **repository root**, not this directory. Commands target this investigation only. Existing empirical checkpoints are reused; do not change the model/generator and reuse checkpoints. For a changed analysis use a separate output directory or archive existing checkpoints first. Seeds are embedded in each script and stored in empirical output rows.

```sh
source /workspace/r-runtime/env.sh  # only on this prepared executor
export OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1
python3 .agents/skills/replication-paper/scripts/preflight.py
python3 .agents/skills/replication-paper/scripts/checks.py
python3 -m unittest discover -s .agents/skills/replication-paper/tests -v
Rscript --vanilla formalization/kupzyk-power-assumptions/scripts/pilot.R
Rscript --vanilla formalization/kupzyk-power-assumptions/scripts/run_exemplary.R
Rscript --vanilla formalization/kupzyk-power-assumptions/scripts/run_empirical.R
Rscript --vanilla formalization/kupzyk-power-assumptions/scripts/verify_engines.R
Rscript --vanilla formalization/kupzyk-power-assumptions/scripts/df_diagnostics.R
Rscript --vanilla formalization/kupzyk-power-assumptions/scripts/gap_checks.R
Rscript --vanilla formalization/kupzyk-power-assumptions/scripts/table3_alternatives.R
Rscript --vanilla formalization/kupzyk-power-assumptions/scripts/table3_allocation.R
Rscript --vanilla formalization/kupzyk-power-assumptions/scripts/baseline_diagnostic.R
Rscript --vanilla formalization/kupzyk-power-assumptions/scripts/summarize.R
python3 formalization/kupzyk-power-assumptions/scripts/compliance.py
python3 formalization/kupzyk-power-assumptions/scripts/build_report.py
(cd formalization/kupzyk-power-assumptions/paper && pdflatex -jobname=simplifying_assumptions_in_power_analysis__a_replication_of_kupzyk_2011 -interaction=nonstopmode -halt-on-error report.tex && pdflatex -jobname=simplifying_assumptions_in_power_analysis__a_replication_of_kupzyk_2011 -interaction=nonstopmode -halt-on-error report.tex)
```

Budget: 38,000 empirical fits, 1000 masks per final nonzero-attrition cell, 500 masks per initial nonzero-attrition cell, 200 masks per threshold, plus documented gap diagnostics. A 54-cell pilot estimated roughly61 CPU minutes for the empirical run, or20 elapsed minutes with three workers before contention/retries. Expected precision and stopping policy are in `notes/budget.md`. All original headline arms run at documented reduced scale. The full original empirical study is not reproduced.

`model.R` supplies source-faithful design construction, two Gaussian generators, two covariance calculations, and established mixed-model fits. `run_exemplary.R` writes `exemplary.csv`, mask draws, independent GLS checks, thresholds, initial-stage exemplary values, formulaic OD/BW power, and oversampling results. `run_empirical.R` saves one CSV per100-draw batch in `outputs/checkpoints/` and assembles `empirical-draws.csv`. `summarize.R` writes headline comparisons and convergence counts and renders `paper/comparison-plot.pdf`. The empirical summary includes power among converged draws plus unconditional lower/upper bounds for failed fits.

## Source provenance and input extraction

Official source: https://digitalcommons.unl.edu/cehsdiss/106/. Kevin A. Kupzyk, *The Effects of Simplifying Assumptions in Power Analysis* (2011), adviser James A. Bovaird. Parent source-review contribution verifies a143-page PDF, SHA256 `c3b7af14877156cf6506e1c3c4ea57b23bcba6ce2139cf82bdce8417c451a1d1`. This executor obtained all6713 indexed lines through Library through its resolved Library reference. Local PDF download and materialization failed; no local PDF hash/pixel claim is made. Parent performs independent source-image review and prepares600-dpi crops.

The complete source text is outside this deliverable, at `source/kupzyk-library-text.txt` in this worktree. Original PDF and full dissertation text are not required to rerun calculations because the extracted frequency arrays and54 targets are retained in `outputs/`. To audit extraction after obtaining authorized source text through Library:

```sh
python3 formalization/kupzyk-power-assumptions/scripts/extract_source.py
```

The parser validates all29 normal/skew frequency rows against their intended cluster counts and extracts Table1/Table5 targets directly from the text. It does not read the independent audit as data. Source masks, original seeds, exact SAS outputs, and source-era runtime are not in the deliverable. No private participant dataset is used.

## Limits

The source BW extension to missing/unequal observations is derived as M-J-2, not verified by a matching SAS output fixture. Alternative df rules and original J-2 are computed explicitly. Statistical models use R mixed-model packages rather than forcing the source model into lavaan. For exemplary cells, dropout SD measures variation between designs, not confidence in our mean; original single-mask uncertainty is not divided by our mask count. All cells have limited reconstruction scope even when numbers match exactly.

The computational run made no skill changes. A later user-authorized editorial revision strengthened citation requirements and added the scholarly references. The user subsequently authorized a PR containing the research and citation revisions. No author contact, merge, or C16 work occurred.

## Source-evidence companion

`kupzyk-source-evidence-appendix.pdf` is a separate9-page companion prepared and visually reviewed by the parent source reviewer, containing16 crops rendered at600 dpi. It includes the title/adviser page, source tables and code, and Table3 (.88187). It accompanies this report but is not embedded in this executor bundle; no blocked transfer was retried.

## Citation revision

`paper/references.tex` is the editable author–year bibliography, included by the generated manuscript. `notes/citation-audit.md` documents the gap, claim coverage, and source verification limits. All numerical output hashes were compared before and after this editorial change. The existing two-pass LaTeX build resolves citations without BibTeX. After building, run:

```sh
python3 .agents/skills/replication-paper/scripts/check_citations.py formalization/kupzyk-power-assumptions/paper/report.tex --references formalization/kupzyk-power-assumptions/paper/references.tex --log formalization/kupzyk-power-assumptions/paper/simplifying_assumptions_in_power_analysis__a_replication_of_kupzyk_2011.log
```

The published PDF uses the descriptive filename `simplifying_assumptions_in_power_analysis__a_replication_of_kupzyk_2011.pdf`. The former generic `report.pdf` is superseded. Inline code links display literal filenames with extensions, and Appendix C links repository files and scripts to master.
