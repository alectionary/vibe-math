# Polytomous person-fit in Beck (2023)

Replication note for Mark F. Beck, *The Examination of Nonparametric Person-Fit Statistics as Appropriate Measures of Response Bias in Ordered Polytomous Items* (Ph.D. dissertation, University of Nebraska–Lincoln, 2023). The note is `paper/paper.pdf`.

Beck's headline result is the sensitivity of U3, normed Guttman errors, and H^T for each bias type. None of the 18 grand sensitivities fall inside a two-standard-error band, before or after Holm. Careless responding comes out between 0.44 and 0.50, against the printed 0.29. The nearest misses, at an extreme-response constant of 0.5, are normed Guttman errors for midpoint responding, 0.0035 against 0.00, and for extreme responding, 0.284 against 0.27.

The likely causes are unpublished inputs: the `ltm` thresholds and the missing seven-option boundary row, the boundary draw and its seed, the extreme-response constant, and the careless-item fraction. A second generator, the package versions current in May 2023, Monte Carlo noise, and the person-fit implementations do not account for the misses.

The 504 partial omega squared values agree with the printed F statistics at N = 32,000, to within 0.005. Specificity, negative predictive value, and positive predictive value largely follow from flagging 5 percent of respondents. Specificity and negative predictive value sit within 0.006 of that identity, and positive predictive value sits within 0.02.

The dissertation PDF is not in git. Place it at the path passed to `extract_published.py`. The copy used here has sha256 `86c3bb482efadc385cd52f7ea12dc33c50b9b70b4ce6111aedb075a12968f62b`.

## Packages

R 4.3.3. `mirt` 1.36, because the current `mirt` needs `Deriv`, and that `Deriv` needs R 4.5. `Deriv` 4.1.6 is installed from the CRAN archive so that `mirt` 1.36 builds. `mokken` 3.1.2 and `PerFit` 1.4.7 come from CRAN. The May 2023 check uses the CRAN archive copies PerFit 1.4.6 (15 October 2021) and mokken 3.0.6 (8 March 2021), installed under a separate library. `mirt` 1.39 (29 May 2023, Pacific) is compared from the archive source. Versions are written by `session_info.R`.

From `formalization/polytomous-person-fit/simulation`, with those packages on the library path:

```sh
Rscript session_info.R out
python3 extract_published.py /path/to/beck.pdf out
Rscript validate_personfit.R out
Rscript monte_carlo.R out 40 ink 0.5 2 1
Rscript score_gaps.R out/mc_ink_eps0.5_c1_r40.csv out sens comparison_eps05.csv
Rscript bootstrap_cutoff.R out
Rscript check_generator.R out
Rscript monte_carlo.R out 40 ink 0.5 2 1 tablea1 tablea3 hand
Rscript score_gaps.R out/mc_hand_ink_tablea1_tablea3_eps0.5_c1_r40.csv out all comparison_hand_all.csv
Rscript compare_generators.R out/mc_ink_eps0.5_c1_r40.csv out/mc_hand_ink_tablea1_tablea3_eps0.5_c1_r40.csv out
Rscript version_check.R out
```

`monte_carlo.R` arguments are output directory, replications, predictor (`ink` or `standard`), epsilon, cores, careless-item fraction, moments (`tablea1`, `thesis_scale`, or `thesis_corr`), discriminations (`tablea3` or `thesis_cfa`), and generator (`mirt` or `hand`). The master seed is `20230511`. Item samples are `out/item_samples.csv`. The recorded headline run is 40 replications, the printed linear predictor, epsilon 0.5, and careless replacement of every item. The file from that run, before the generator token was added to the name, is `out/mc_ink_eps0.5_c1_r40.csv`. `version_check.R` expects PerFit 1.4.6 and mokken 3.0.6 on the library path ahead of the later releases.

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
