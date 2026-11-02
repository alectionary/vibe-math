# Koziol (2015) weighted multilevel replication

Normal random-intercept Monte Carlo for Natalie A. Koziol's 2015 dissertation.
The other 200 settings (Bernoulli outcomes and the random-coefficient model) are not rerun.

## Prerequisites

R 4.3.3 or later, with `survey`, `lme4`, `WeMix`, and `numDeriv` on the library path.
Set `R_LIBS_USER` if those packages are not in the site library.
Set `OMP_NUM_THREADS=1` so forked replications do not oversubscribe BLAS.

## Reproduce the Monte Carlo

From `formalization/koziol-weighted-multilevel/simulation`:

```sh
export R_LIBS_USER=/home/ubuntu/R/library
export OMP_NUM_THREADS=1
export SIM_DIR="$PWD"
export SIM_REPS=1000
export SIM_CORES=3
Rscript run_main.R
Rscript summarize.R
```

Seeds are `1000 * cell_id + replication`. Cell definitions are written to `results/cells.csv`.
Each cell requests 1,000 replications. A replication is dropped from every estimator when any estimator fails to converge.
`results/summary.csv` is the Monte Carlo summary.
`results/cell_01.csv` through `results/cell_08.csv` are the replicate-level estimates.

The recorded run used R 4.3.3, survey 4.2.1, lme4 1.1.35.1, WeMix 4.0.3, and numDeriv 2016.8-1.1.
Versions are in `simulation/results/versions.txt` and `simulation/results/RUN.txt`.

## Generator check

```sh
Rscript check_generators.R /tmp/koziol-genchk
python3 - << 'PY'
import csv, numpy as np, sys
sys.path.insert(0, ".")
from generate_py import draw_sample
def load(path):
    with open(path) as f:
        rows = list(csv.DictReader(f))
    return {k: np.array([float(r[k]) for r in rows]) for k in rows[0]}
L2, L1 = load("/tmp/koziol-genchk/level2.csv"), load("/tmp/koziol-genchk/level1.csv")
ref = load("/tmp/koziol-genchk/r_reference.csv")
out = draw_sample(L2["wj"], L2["u0"], L2["delta"], L1["rij"], L1["x"], L2["u_noise"], L1["r_noise"], L2["unif_j"], L1["unif_i"], 0.05, 5, "informative")
assert out["n"] == int(ref["n"][0]) and out["m"] == int(ref["m"][0])
print("generator check ok", out["n"], out["m"])
PY
```

The check uses a population of 400 clusters. The production generator uses 48,450.

## Paper

From `formalization/koziol-weighted-multilevel/paper`:

```sh
pdflatex weighted_single_level_versus_multilevel__a_replication_of_koziol_2015.tex
bibtex weighted_single_level_versus_multilevel__a_replication_of_koziol_2015
pdflatex weighted_single_level_versus_multilevel__a_replication_of_koziol_2015.tex
pdflatex weighted_single_level_versus_multilevel__a_replication_of_koziol_2015.tex
```

The dissertation PDF in `source/` is the Internet Archive copy described in `notes/availability.md`.
It is not produced by these commands.
