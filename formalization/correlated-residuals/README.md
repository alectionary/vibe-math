# Correlated residuals: replication package

This directory is the Lean formalization and the seeded simulations for the
note in `paper/`. Commands are run from the repository root unless a block
says otherwise. Python dependencies used by the simulations are `numpy` and
`scipy`. The glyph check also needs `pymupdf`. Lean is 4.22.0 with Mathlib
v4.22.0, pinned by `lean-toolchain`.

The JSON files under `simulation/out/` are the runs cited in the note.
A short `--reps` invocation writes a different file over those paths.
Use it only in a copy of the tree.

## Lean

```bash
cd formalization/correlated-residuals
lake build
```

The development uses no `sorry`. `#print axioms` on the theorems listed in
`paper/paper.tex` reports `propext`, `Classical.choice`, and `Quot.sound`.

## Identification checks

These three write next to themselves, not under `simulation/out/`.

```bash
cd formalization/correlated-residuals
python3 check_witness.py
python3 delta_method.py
python3 fit_bow.py
```

`check_witness.py` checks the identification algebra at the earlier reading
`B = -M` with unsigned `G`. It writes `witnesses.json`. The glyph reading,
which is the one compared with Table 2, is `table2_totals.py` below.
`delta_method.py` writes `delta_check.json`. `fit_bow.py` writes
`fit_bow.json`.

## Equation (7) and Table 2

The SAGMB PDF is not in git. The copy used for the glyph measurement is
`local-extraction/literature/unl-sem/mi-qtl2010.pdf`.

```bash
python3 formalization/correlated-residuals/simulation/measure_glyphs.py \
  --pdf local-extraction/literature/unl-sem/mi-qtl2010.pdf \
  --check formalization/correlated-residuals/simulation/out/qtl1/glyphs.json
```

```bash
python3 formalization/correlated-residuals/simulation/table2_totals.py
```

writes `formalization/correlated-residuals/simulation/out/table2_totals.json`.
The `(1,3)` total is `3/4`.

```bash
python3 formalization/correlated-residuals/simulation/printed_probability.py
```

reads `simulation/out/assumptions/baseline.json` and writes
`simulation/out/printed_probability.json`.

## Simulation studies

From `formalization/correlated-residuals/simulation`:

```bash
python3 studies.py --reps 100 --bow-reps 400 --studies 1,2,3
```

writes `out/study1.json`, `out/study2.json`, and `out/study3.json`.
Study 1 is the earlier reading of equation (7). Seeds are `20101027`,
`20101028`, `20101029`, and `20101030`.

```bash
python3 gaps.py
```

writes `out/gaps.json` and `out/gaps_table.csv`. There is no flag. The grid
uses 100 replicates for the one-at-a-time runs and 1000 for the last two.
Seeds run from `20101027` through `20101042`.

```bash
python3 assumptions.py --configs baseline --reps 1000
```

writes `out/assumptions/baseline.json`. Other config names are the first
argument of each `add(...)` call in `assumptions.py`: `seed_b`,
`coding_half`, `f2`, `backcross`, `ril_infinite`, `kosambi`,
`markers_shifted`, `markers_interior`, `qtl_on_markers`, `expect_nodouble`,
`expect_f2_on_ril`, `oracle`, `cof_none`, `cof_20`, `cof_all`,
`psi_identity`, `psi_as_sd`, `psi_sqrt`, `standardize`, `step2`, `step5`,
`n250`, `n300`. Several of those names are also present as JSON files.

```bash
python3 assumptions.py --analytic
```

writes `out/assumptions/analytic.json` for `n` of 150, 250, and 300 and
does not run the Monte Carlo.

```bash
python3 qtl1_search.py --configs qtl1_24_n250 --reps 1000
```

writes `out/qtl1/qtl1_24_n250.json`. `--configs` is required. The catalog
names are `g11_flip`, `g21_half`, `g_transpose`, `psi_y2_heavy`, `qtl1_25`,
`qtl1_32`, `qtl1_25_n200`, `qtl1_23_n250`, `qtl1_24_n250`, `qtl1_25_n250`,
`gap_qtl1`, `gap_n250`, `distort_p03`, `het15`, `linemean_r2`,
`qtl1_on_marker`, `stepwise`, and `twostage`. Pass several names separated
by commas.

`out/qtl1/glyphs.json` is the PDF measurement, not a catalog entry.
`out/qtl1/baseline_rules.json` is the rule summary taken from the baseline
scan; regenerating the powers uses `assumptions.py --configs baseline`.

## Paper

```bash
cd formalization/correlated-residuals/paper
pdflatex paper.tex
pdflatex paper.tex
```

The PDF is `paper/paper.pdf`.
