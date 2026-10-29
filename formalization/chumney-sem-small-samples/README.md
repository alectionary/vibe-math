# Chumney (2013): structural equation models with small samples

Replication of Frances L. Chumney, *Structural equation models with small
samples: A comparative study of four approaches* (Ph.D. dissertation,
University of Nebraska–Lincoln, 2013). The note is `paper/paper.pdf`.

Commands are run from this directory unless a block says otherwise.
R packages used by the simulation are installed for this machine under
`/tmp/rlib` (`lavaan`, `cSEM`, `gesca`, `mvtnorm`). The dissertation PDF
is not in git. The copy used for the page crops is

`local-extraction/literature/unl-sem/chumney2013.pdf`

(sha256 `1b067efef410ac3ae412e3a26a7b29bf1f8e50e935d219353fbe16ce8a853007`,
146 pages).

## Seeds

Each data condition has a seed `cell_id` in `simulation/replicate.R`.
Replication `r` uses `set.seed(cell_id + r)`. The base is `20130715`,
the date on the dissertation title page. The full grid is 36 conditions,
150 replications, three estimators.

## Standardized population check

```bash
Rscript simulation/check_standardized.R
```

writes `simulation/out/standardized_check.json`.

## Monte Carlo

```bash
R_LIBS_USER=/tmp/rlib Rscript simulation/replicate.R --reps 150
```

writes `simulation/out/reps150-full.rds`. The run that produced the
numbers in the note took 929 seconds.

```bash
R_LIBS_USER=/tmp/rlib Rscript simulation/compare.R simulation/out/reps150-full.rds
```

writes `simulation/out/comparison_i3.csv`, `ours_i3.csv`, and `ours_all.csv`.
The comparison is the three-indicator slice against Tables 1–4.
A cell is a match when the difference of Monte Carlo means is inside a
two-standard-error band and the Holm adjustment within that outcome
does not reject it.

## Bayesian subset

Thirty replications. Two chains, 500 burn-in iterations, 500 retained
draws, potential scale reduction below 1.05. blavaan defaults for the
priors. The cells are the four three-indicator conditions at n = 50 and
n = 1000, plus the seven-indicator correct reflective cells.

```bash
R_LIBS_USER=/tmp/rlib Rscript simulation/bayes_subset.R --reps 30
```

writes `simulation/out/bayes-reps30.rds`. The run that produced the note
took 6731 seconds.

## Formative structural readings

```bash
R_LIBS_USER=/tmp/rlib Rscript simulation/investigate_formative.R
```

writes `simulation/out/formative_readings.txt`.

## GSCA implementations

```bash
R_LIBS_USER=/tmp/rlib Rscript simulation/investigate_gsca.R --reps 40
```

writes `simulation/out/gsca_compare.rds`.

## Page crops

```bash
python3 paper/figures/crop_pages.py \
  --pdf local-extraction/literature/unl-sem/chumney2013.pdf
```

writes 600 dpi crops under `paper/figures/`.

## Paper

```bash
cd paper
pdflatex paper.tex
pdflatex paper.tex
```

The PDF is `paper/paper.pdf`.
