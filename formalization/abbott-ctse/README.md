# Creative self-efficacy measurement models in Abbott (2010)

Replication note for Daniel H. Abbott, *Constructing a Creative
Self-Efficacy Inventory: A Mixed Methods Inquiry* (Ph.D. dissertation,
University of Nebraska–Lincoln, 2010). The note is `paper/paper.pdf`.
The fits are lavaan 0.6.17 and OpenMx 2.21.11 on the correlation matrix
in Table 3.2. The interview phase is not refit.

The note and the fit outputs are unchanged. A correction dated 29
October 2026, on the scaled-difference formula, is
`paper/CORRECTIONS.md`. Grokbot's assessment of the paired reports is
`GROKBOT-ASSESSMENT.md`.

The dissertation PDF is not in git. Place it at
`local-extraction/literature/unl-sem/abbott-2010-unl.pdf` before
regenerating the matrix or the crops. The copy used for this note has
sha256
`a3c381d6f6295e917806834364b7f55fc35684b3db53174a53c3564feab4d70a`.

Commands are from the repository root unless a block says otherwise.

## Matrix

```sh
python3 formalization/abbott-ctse/simulation/parse_table32.py \
  --pdf local-extraction/literature/unl-sem/abbott-2010-unl.pdf
```

This checks the text layer against `simulation/table32.csv`. Add
`--write` to replace the CSV. The committed CSV is the input of the fits.

## Fits

R 4.3.3, lavaan 0.6.17, OpenMx 2.21.11. From
`formalization/abbott-ctse/simulation`:

```sh
Rscript fit_models.R out
```

There is no random seed in the fits. The sample size is 296 and the
likelihood is Wishart. The outputs are:

- `out/comparison.csv`, the printed targets against the lavaan fits
- `out/lavaan_fits.csv`, nlminb and BFGS
- `out/openmx_fits.csv`, SLSQP and CSOLNP
- `out/n_likelihood_grid.csv`, sample sizes 296, 297, and 308
- `out/satorra_printed.csv`, the scaled-difference algebra
- `out/ml_differences.csv`
- `out/table41_gaps.csv`
- `out/composite_validity.csv`
- `out/matrix_checks.csv`
- `out/general_second_order_loadings.csv`
- `out/sessionInfo.txt`
- `out/code_search.md`, the availability ledger

## Crops

```sh
python3 formalization/abbott-ctse/paper/figures/crop_pages.py
```

This runs `pdftoppm -png -r 600` and writes the crops next to the
script. Full-page renders stay in `/tmp/abbott/render600`.

## Note

```sh
cd formalization/abbott-ctse/paper
pdflatex -interaction=nonstopmode paper.tex
pdflatex -interaction=nonstopmode paper.tex
```
