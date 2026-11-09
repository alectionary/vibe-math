# Chen exact R replay, all 1,000 replications

Successful summary-mode run of `chen_exact.R` on branch `grok/chen-r-full`, started from commit `6aaa23a1501f943510ba7742c00356ff6b6bc357`.

## Commands

The snapshot library from issue 92 was already installed and was reused:

```sh
export PATH="/opt/R/4.1.3/bin:$PATH"
export R_LIBS="/home/ubuntu/chen-snapshot-2021-08-02"
export R_LIBS_USER="/home/ubuntu/chen-snapshot-2021-08-02"
export R_LIBS_SITE="/home/ubuntu/chen-snapshot-2021-08-02"
export OPENBLAS_NUM_THREADS=1
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
```

`Rscript` on `PATH` was `/opt/R/4.1.3/bin/Rscript`. The run command was:

```sh
cd formalization/chen-rdd-mediation/r-reproduction && mkdir -p out-full && Rscript chen_exact.R 1000 out-full summary 2>&1 | tee out-full/run.log
```

It ran in tmux session `chen-r-full`.

## Wall time

- Start: 2026-11-09T04:05:50Z
- End: 2026-11-09T07:30:45Z
- Elapsed: 12295 seconds (3 hours 24 minutes 55 seconds), exit 0
- The script's own timer, which starts after the literal check, reported `done: 1280000 kept datasets in 203.8 min`

## R, OS, CPU

- R version 4.1.3 (2022-03-10), `/opt/R/4.1.3/bin/Rscript`
- `RNGkind`: Mersenne-Twister, Inversion, Rejection (`out-full/session.txt`)
- OS: Ubuntu 24.04.5 LTS, Linux 6.12.113+ #1 SMP PREEMPT_DYNAMIC Thu Nov 5 16:04:51 UTC 2026 x86_64
- CPU: 4 vCPU, Intel(R) Xeon(R) Processor, KVM
- BLAS/LAPACK: OpenBLAS, with `OPENBLAS_NUM_THREADS=1`
- Snapshot library `/home/ubuntu/chen-snapshot-2021-08-02`: dplyr 1.0.7, tidyr 1.1.3, purrr 0.3.4, data.table 1.14.0, stringi 1.7.3, digest 0.6.27

## Deviations

- R and the 2021-08-02 snapshot library were the ones already on this VM from issue 92. Nothing was reinstalled.
- `R_LIBS`, `R_LIBS_USER`, and `R_LIBS_SITE` pointed at that library so the snapshot packages were the ones loaded.
- Thread caps: `OPENBLAS_NUM_THREADS=1`, `OMP_NUM_THREADS=1`, `MKL_NUM_THREADS=1`.
- stringi 1.7.3 is linked to system ICU 74, while the R 4.1.3 binary loads ICU 70. That linkage was already true for the issue 92 run.
- `formalization/chen-rdd-mediation/.gitignore` ignores `*.log`, so `out-full/run.log` was added with `git add -f`.
- `out-full/run.log` was committed about every 30 minutes while the pass ran. `out-full/first_dataset.csv` was left untracked.
