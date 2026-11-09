# Re-run Kupzyk (2011)

Run these commands from the repository root with R 4.5.3, Rcpp, lme4, nlme,
lmerTest and pbkrtest, and Python 3 with NumPy, SciPy, PyYAML and PyMuPDF.
Use one BLAS thread per process. The study's approved R fallback is documented
in `notes/rerun-engine.json`. Historical analysis inputs are kept in
`outputs/`; current simulation files go to a different directory.

```sh
export OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 VECLIB_MAXIMUM_THREADS=1
study=formalization/kupzyk-power-assumptions
run_dir=/tmp/kupzyk-reproduction
mkdir -p "$run_dir"
Rscript --vanilla "$study/rerun/validate_profile.R" "$run_dir/validation.csv"
Rscript --vanilla "$study/rerun/full_grid.R" "$run_dir/checkpoints" 4
python3 "$study/rerun/aggregate_grid.py" "$run_dir/checkpoints" "$run_dir/empirical.csv"
Rscript --vanilla "$study/rerun/exemplary_v2.R" "$run_dir/exemplary"
Rscript --vanilla "$study/rerun/appendix_d.R" "$run_dir/appendix-d-validation.csv"
Rscript --vanilla "$study/rerun/appendix_d_grid.R" "$run_dir/appendix-d"
python3 "$study/rerun/compare.py" "$study" "$run_dir/empirical.csv" "$run_dir/exemplary/exemplary-v2.csv" "$run_dir/comparison"
```

The main run schedules 128 batches of 200 draws per setting, plus the 50,000
baseline follow-up and both null cases. It can resume from its own completed
batches. Use a new checkpoint directory for any scientific change to the
engine, generator, settings, source inputs, seed schedule or software versions.
The aggregate records attempted and successful fits separately. The comparison
tool refuses an incomplete grid unless explicitly invoked with `--provisional`.
Any such results are interim.

For the source audit, download the specific archived PDF from
`provenance/source-acquisition.json` and verify its recorded SHA-256. Do not
commit the PDF. Recreate the layout text with Poppler and run
`read_source_tables.py`, `digitize_power.py`, `figure4_and_design.py`, and
`check_source.py`. The three occluded open markers are deliberately left blank.
