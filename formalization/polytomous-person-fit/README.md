# Polytomous person-fit in Beck (2023)

Replication note for Mark F. Beck, *The Examination of Nonparametric Person-Fit Statistics as Appropriate Measures of Response Bias in Ordered Polytomous Items* (Ph.D. dissertation, University of Nebraska–Lincoln, 2023). The note is `paper/paper.pdf`.

The dissertation PDF is not in git. Place it at the path passed to `extract_published.py`. The copy used here has sha256 `86c3bb482efadc385cd52f7ea12dc33c50b9b70b4ce6111aedb075a12968f62b`.

## Packages

R 4.3.3. `mirt` 1.36, because the current `mirt` needs `Deriv`, and that `Deriv` needs R 4.5. `Deriv` 4.1.6 is installed from the CRAN archive so that `mirt` 1.36 builds. `mokken` 3.1.2 and `PerFit` 1.4.7 come from CRAN. Versions are written by `session_info.R`.

From `formalization/polytomous-person-fit/simulation`, with those packages on the library path:

```sh
Rscript session_info.R out
python3 extract_published.py /path/to/beck.pdf out
Rscript validate_personfit.R out
Rscript monte_carlo.R out 40 ink 1 4 1
Rscript score_gaps.R out/mc_ink_eps0.5_c1_r40.csv out
Rscript bootstrap_cutoff.R out
```

`monte_carlo.R` arguments are output directory, replications, predictor (`ink` or `standard`), epsilon, cores, and the careless-item fraction. The master seed is `20230511`. Item samples are `out/item_samples.csv`. The recorded run is 40 replications, the printed linear predictor, epsilon 1, and careless replacement of every item.

## Crops

```sh
python3 formalization/polytomous-person-fit/paper/figures/crop_pages.py /path/to/beck.pdf
```

This runs `pdftoppm -png -r 600` and writes the crops next to the script. Full-page renders stay in `paper/figures/render600/`, which is gitignored.

## Note

```sh
cd formalization/polytomous-person-fit/paper
pdflatex -interaction=nonstopmode paper.tex
pdflatex -interaction=nonstopmode paper.tex
```
