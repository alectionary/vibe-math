# Latent contrasts in Jeffries (2024)

Replication note for Jay B. Jeffries, *Navigating Non-Orthogonality: Exploring Latent Mean Differences in Unbalanced Conditions* (Ph.D. dissertation, University of Nebraska–Lincoln, 2024). The note is `paper/paper.pdf`. The code identities are in `LatentContrasts/Orthogonality.lean`. The model fits are lavaan 0.6.17.

The dissertation PDF is not in git. Place it at `local-extraction/literature/unl-sem/retrieval-repair/UNL-SEM-D055.pdf` before regenerating the crops. sha256 `a21df98c20401491e6b4a1d00a21b6f7cee5551a00c04a89fb414ec6cfd469b3`.

The public analysis scripts are in `osf/`, from <https://osf.io/q9yu8/>, retrieved 2026-10-27. simsem is used to parse the generation string. OpenMx and Mplus are not installed. `simulation/mgcfa_osf.inp` is an unexecuted mirror of the multigroup string.

## Proofs

```sh
cd formalization/latent-contrasts
lake build
```

Mathlib pin: `v4.22.0` in `lakefile.toml`. The build uses `propext`, `Classical.choice`, and `Quot.sound`. Theorems proved with `native_decide` also use `Lean.ofReduceBool`. There is no `sorry`. These proofs are the code identities. They are not the identification check.

## lavaan

R 4.3.3, lavaan 0.6.17, simsem 0.5.17. Versions are written by `session_info.R`. From `formalization/latent-contrasts/simulation`:

```sh
Rscript session_info.R out
Rscript candidate_readings.R out
Rscript mimic_large.R out
Rscript validate_gaps.R 400 out
Rscript score_gaps.R out/validate_gaps.csv out/gap_scores.csv
```

`candidate_readings.R` fits each identification to the population moments. Its simulated samples use seed `13131`. `mimic_large.R` uses seed `7` and 100000 observations per group. `validate_gaps.R` sets `RNGkind("L'Ecuyer-CMRG")`, calls `set.seed(13131)`, and draws one seed per cell. The recorded Monte Carlo is 400 replicates. `score_gaps.R` classifies each gap against two combined standard errors at the printed count of 10000.

`monte_carlo.R` is the earlier equal-loading reading, every loading generated at 0.7. It is not the generation string. The recorded command is `Rscript monte_carlo.R 200 100 out`. `identification_check.R` is the same population: `Rscript identification_check.R 200 out`.

## Crops

```sh
python3 formalization/latent-contrasts/paper/figures/crop_pages.py
```

This runs `pdftoppm -png -r 600` and writes the crops next to the script. Pages with `/Rotate 90` are turned clockwise into reading order before the crop. Full-page renders stay in `paper/figures/render600/`, which is gitignored.

## Note

```sh
cd formalization/latent-contrasts/paper
pdflatex -interaction=nonstopmode paper.tex
pdflatex -interaction=nonstopmode paper.tex
```
