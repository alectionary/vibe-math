# Autobiographical specificity: replication package

This directory recomputes the behavioral tests in Sorenson (2015),
*Overgeneral autobiographical memory in major depressive disorder is
associated with abnormal neural activity during retrieval*, from the
printed means, standard deviations, and sample sizes. The note is
`paper/paper.tex`. Commands are run from the repository root.

There is no random seed. The calculations are tail probabilities and
integer-score checks.

The dissertation PDF is not in git. The copy used for the crops is

`local-extraction/literature/sorenson-2015/Sorenson_Dissertation_To_Submit-augmented.pdf`

sha256 `4debc9f5551d51ae00a5b6987c3c572a9c7221f6ab631928558c8c1f6b8414d6`.
The public file is

`https://stacks.stanford.edu/file/cv880bv1650/Sorenson_Dissertation_To_Submit-augmented.pdf`

## Tests

R 4.3.3, base packages, plus jsonlite 1.8.8 to write JSON.

```bash
Rscript formalization/overgeneral-memory/simulation/recompute.R
```

writes

- `formalization/overgeneral-memory/simulation/out/claims.json`
- `formalization/overgeneral-memory/simulation/out/claims.csv`
- `formalization/overgeneral-memory/simulation/out/grim.json`
- `formalization/overgeneral-memory/simulation/out/derived.json`
- `formalization/overgeneral-memory/simulation/out/sessionInfo.txt`

An optional first argument replaces the output directory.

## Page crops

Poppler 24.02.0 (`pdftoppm`) and Pillow 10.2.0. The rasters are 600 dpi.

```bash
python3 formalization/overgeneral-memory/paper/figures/crop_pages.py \
  --pdf local-extraction/literature/sorenson-2015/Sorenson_Dissertation_To_Submit-augmented.pdf
```

writes the PNG files in `formalization/overgeneral-memory/paper/figures/`.

## Note

```bash
cd formalization/overgeneral-memory/paper
pdflatex paper.tex
pdflatex paper.tex
```

The availability ledger is the table in the note's availability section.
