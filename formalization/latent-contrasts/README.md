# Latent contrasts in Jeffries (2024)

Replication note for Jay B. Jeffries, *Navigating Non-Orthogonality: Exploring Latent Mean Differences in Unbalanced Conditions* (Ph.D. dissertation, University of Nebraska–Lincoln, 2024). The note is `paper/paper.pdf`. The proofs are in `LatentContrasts/Orthogonality.lean`.

The dissertation PDF is not in git. Place it at `local-extraction/literature/unl-sem/retrieval-repair/UNL-SEM-D055.pdf` before regenerating the crops. sha256 `a21df98c20401491e6b4a1d00a21b6f7cee5551a00c04a89fb414ec6cfd469b3`.

## Proofs

```sh
cd formalization/latent-contrasts
lake build
```

Mathlib pin: `v4.22.0` in `lakefile.toml`. The build uses `propext`, `Classical.choice`, and `Quot.sound`. Theorems proved with `native_decide` also use `Lean.ofReduceBool`. There is no `sorry`.

## Monte Carlo

R 4.3.3 and lavaan 0.6.17. The stream is R's L'Ecuyer generator, seed `13131`, not simsem's stream. Outputs:

```sh
cd formalization/latent-contrasts/simulation
Rscript monte_carlo.R 200 100 out
Rscript identification_check.R 200 out
```

`monte_carlo.R` writes `out/monte_carlo.csv`. The first argument is the replicate count at N=240. The second is the count at N=960. `identification_check.R` writes `out/identification_check.csv`. Both commands above are the run recorded in the note: 200 replicates at N=240 and 100 at N=960, with one additional sample of 20,000 per group in the identification script.

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
