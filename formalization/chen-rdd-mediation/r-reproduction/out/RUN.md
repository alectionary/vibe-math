# Chen exact R replay

Successful run of `chen_exact.R` at commit `895ab38633d77d3a68897f6dd8ac946f69862566` on branch `grok/chen-r-run`.

## Commands

Snapshot library (set for both install and the run):

```sh
export PATH="/opt/R/4.1.3/bin:$PATH"
export R_LIBS="/home/ubuntu/chen-snapshot-2021-08-02"
export R_LIBS_USER="/home/ubuntu/chen-snapshot-2021-08-02"
export R_LIBS_SITE="/home/ubuntu/chen-snapshot-2021-08-02"
export OPENBLAS_NUM_THREADS=1
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
```

Package install, from the 2021-08-02 snapshot only:

```r
options(repos = c(CRAN = "https://packagemanager.posit.co/cran/2021-08-02"))
options(Ncpus = 4L)
install.packages(c("dplyr", "tidyr", "purrr", "data.table", "stringi", "digest"))
```

Replay:

```sh
cd formalization/chen-rdd-mediation/r-reproduction
mkdir -p out
Rscript chen_exact.R 50 out 2>&1 | tee out/run.log
```

## Wall time

- Start: 2026-11-09T01:21:16Z
- End: 2026-11-09T01:45:14Z
- Elapsed: 1438 seconds (23 minutes 58 seconds), exit 0
- The script's own timer, which starts after the literal check, reported `done: 64000 kept datasets in 23.0 min`

## R, OS, CPU

- R version 4.1.3 (2022-03-10), `/opt/R/4.1.3/bin/Rscript` (Posit r-builds package for Ubuntu 22.04)
- `RNGkind`: Mersenne-Twister, Inversion, Rejection (`out/session.txt`)
- OS: Ubuntu 24.04.5 LTS, Linux 6.12.113+ #1 SMP PREEMPT_DYNAMIC Thu Nov 5 16:04:51 UTC 2026 x86_64
- CPU: 4 vCPU, Intel(R) Xeon(R) Processor (family 6, model 207), KVM
- BLAS/LAPACK: OpenBLAS 0.3.26 (`/usr/lib/x86_64-linux-gnu/openblas-pthread/`), with `OPENBLAS_NUM_THREADS=1`

Packages used, from the snapshot library and `out/session.txt`: dplyr 1.0.7, tidyr 1.1.3, purrr 0.3.4, data.table 1.14.0, stringi 1.7.3, digest 0.6.27. Dependencies installed from the same snapshot include rlang 0.4.11, vctrs 0.3.8, tibble 3.1.3, tidyselect 1.1.1, pillar 1.6.2, cpp11 0.3.1, cli 3.0.1, glue 1.4.2, lifecycle 1.0.0, magrittr 2.0.1.

## Deviations

- This VM had no R. Ubuntu 24.04 has no R 4.1.x package, so R 4.1.3 was installed from the Posit Ubuntu 22.04 build `r-4.1.3_1_amd64.deb`. That binary needs `libicuuc.so.70` and `libtiff.so.5`, which noble does not ship, so jammy `libicu70` 70.1-2ubuntu1 and jammy `libtiff5` 4.3.0-6ubuntu0.13 were installed. The R version is 4.1.3.
- Packages were installed into `/home/ubuntu/chen-snapshot-2021-08-02` and that directory was placed first on `.libPaths()`. The only other library was `/opt/R/4.1.3/lib/R/library`. `install.packages` also set `Ncpus=4`.
- stringi 1.7.3 linked against system ICU 74 (`libicuuc.so.74`). The R 4.1.3 binary itself loads ICU 70.
- `out/` was created before `tee`, because `tee` does not create parent directories.
- Thread caps: `OPENBLAS_NUM_THREADS=1`, `OMP_NUM_THREADS=1`, `MKL_NUM_THREADS=1`.
- An earlier run of the pre-fix script at `3649f58d` stopped in the literal check (`same_kept` FALSE, RNG state TRUE) and was not committed. This run is the rerun at `4e739dc0` requested on issue 92. `estimates.csv` is 38487272 bytes, under 50 MB, so it was not gzipped.
