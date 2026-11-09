#!/bin/sh
# Run from the vibe-math repository root. Use a new directory for new inputs.
set -eu
study=formalization/kupzyk-power-assumptions
run_dir=${1:?Usage: sh rerun/reproduce.sh RUN_DIRECTORY}
workers=${2:-4}
export OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 VECLIB_MAXIMUM_THREADS=1
mkdir -p "$run_dir"
Rscript --vanilla "$study/rerun/validate_generator.R"
Rscript --vanilla "$study/rerun/validate_profile.R" "$run_dir/engine-comparison.csv"
Rscript --vanilla "$study/rerun/full_grid.R" "$run_dir/grid" "$workers"
python3 "$study/rerun/aggregate_grid.py" "$run_dir/grid" "$run_dir/empirical.csv"
Rscript --vanilla "$study/rerun/exemplary_v2.R" "$run_dir/exemplary-v2"
Rscript --vanilla "$study/rerun/formulaic.R" "$run_dir/formulaic.csv"
python3 "$study/rerun/precision_demo.py" "$run_dir"
Rscript --vanilla "$study/rerun/appendix_d.R" "$run_dir/appendix-d-validation.csv"
Rscript --vanilla "$study/rerun/appendix_d_grid.R" "$run_dir/appendix-d-grid"
Rscript --vanilla "$study/rerun/kenward_roger.R" "$run_dir/kr-validation.csv"
Rscript --vanilla "$study/rerun/kenward_roger_grid.R" "$run_dir/kr-grid"
Rscript --vanilla "$study/rerun/diagnose_disagreements.R" "$run_dir/comparisons"
python3 "$study/rerun/compare.py" "$study" "$run_dir/empirical.csv" \
    "$run_dir/exemplary-v2/exemplary-v2.csv" "$run_dir/comparisons"
python3 "$study/rerun/summarize_support.py" "$study" "$run_dir" "$run_dir/comparisons"
python3 "$study/rerun/check_oversampling.py" "$study" "$run_dir/exemplary-v2" "$run_dir/comparisons"
