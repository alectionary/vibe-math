# Exact R reproduction of Chen's seeded datasets

Chen's Appendix A seeds both the design table (`set.seed(18374788)`) and the data
(`set.seed(95409)`). `chen_exact.R` runs her own `gendata()` in her own order and
fits her own Appendix B `lm()` models, so the kept datasets and point estimates are
hers, not a re-implementation. Datasets not kept are skipped by drawing the same
number of normals (7 × n per dataset); the script checks that skipping leaves the
data and the RNG state identical to her literal `group_walk`/`pmap_dfr` pipeline on
the first block and stops if not.

The bootstrap intervals are not reproduced: Appendix B sets no seed for them.

## Environment

- R 4.0.x or 4.1.x (Chen pinned packages with `checkpoint::use_checkpoint("2021-08-02")`;
  R 4.1.0 was current then). Any R >= 3.6 uses the same default RNG
  (Mersenne-Twister, Inversion, Rejection), but record the version used.
- Packages from the dated snapshot, so `stri_rand_strings` and `sample` consume the
  RNG as hers did:

```r
options(repos = c(CRAN = "https://packagemanager.posit.co/cran/2021-08-02"))
install.packages(c("dplyr", "tidyr", "purrr", "data.table", "stringi", "digest"))
```

## Run

```sh
Rscript chen_exact.R 50 out       # 50 of 1,000 replications per condition (64,000 datasets)
```

The full pass replays all 1,280,000 datasets in Chen's order (about 3.4e10 normal
draws); expect roughly 30-90 minutes on one core. `KEEP_REPS` only changes how many
are rebuilt and fitted. `1000` rebuilds every dataset and takes many hours.

## Full run (all 1,000 replications)

```sh
Rscript chen_exact.R 1000 out-full summary 2>&1 | tee out-full/run.log
```

`summary` mode keeps every dataset (her exact data for every replication) but
writes `condition_summary.csv`: for each of the 1,280 conditions, the number
of replications and the mean and SD of every estimate (a, b, c', h, i0M and
the five effects, at each cutoff). Expect several hours on one core: the 50-
replication run took 23 minutes, most of it the replay.

## Return

Commit the whole `out/` folder (`session.txt`, `data_iter_sha256.txt`,
`literal_check.txt`, `first_dataset.csv`, `first_dataset_sha256.txt`,
`estimates.csv`) back to this folder as `r-reproduction/out/`, with the exact
command and the wall time in `out/RUN.md`. Do not edit the script; if it fails,
return the error output unchanged.

## What it is compared with

`estimates.csv` gives Chen's own point estimates for the kept replications. Their
mean bias per condition is compared with her Table 4.8 and with her plotted mean
bias in Figures 4.12-4.16 (`results/digitized_bias.csv`), and with our Python run
(`results/cells.csv`), which uses a different RNG and so agrees only in
distribution.
