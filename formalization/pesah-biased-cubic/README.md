Expanded partial milestone: [biased_noise_thresholds_of_cubic_and_rhombic_codes__replication_of_pesah_2021.pdf](paper/biased_noise_thresholds_of_cubic_and_rhombic_codes__replication_of_pesah_2021.pdf). The whole-dissertation objective remains open; see [coverage.json](coverage.json), the [expanded execution guide](expansion/README.md), and the preserved pure-X milestone below. General proofs, historical production equivalence and frontend rendering are not complete. New master navigation awaits merge.

# Pure-X thresholds of deformed cubic codes

Replication of Arthur Pesah, *Tailoring 3D topological codes and decoders to biased noise* (UCL **Master of Research dissertation**, 1 September 2021; supervisor Dan Browne). This is not the later PhD thesis. Initial screening prioritized doctoral sources; the selected accessible work genuinely bears the requested dissertation designation. The scope is Table 3.1 / Figure 3.5's pure-X cubic BP-OSD comparison, not the whole dissertation.

Main paper: [pure_x_thresholds_of_deformed_cubic_codes__replication_of_pesah_2021.pdf](paper/pure_x_thresholds_of_deformed_cubic_codes__replication_of_pesah_2021.pdf). Editable [manuscript.tex](paper/manuscript.tex), [references.bib](paper/references.bib), [availability.md](availability.md), and [compliance.md](compliance.md). Current numerical results are in [analysis.json](results/analysis.json). Master navigation links in the paper await merge; `reproduction-revision.txt` identifies the immutable runnable code revision.

## Reproduce

Work from this study directory at the immutable reproduction revision. Baseline master was `e2b553c06c872d8008061a26d05831e572e54789`; the baseline does not contain this implementation. Python 3.12.14 was used. Create an environment and install `requirements.txt`. The old reference validator additionally uses qecsim 1.0b9 and NetworkX 2.6.2, already included in that file. Primary code does not execute either package. Poppler (`pdftoppm`), pdfLaTeX and BibTeX are system prerequisites for evidence and manuscript regeneration.

```sh
python -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements.txt
export OPENBLAS_NUM_THREADS=1
export OMP_NUM_THREADS=1
python ../../.agents/skills/replication-paper/scripts/preflight.py --fallback preflight-departure.json > results/preflight.json
python simulation/pilot.py
python simulation/run.py --output results/primary.json
python simulation/run.py --output results/iterations100.json --sizes 4 6 --iterations 100 --sensitivity
python simulation/run.py --output results/diagnostic10.json --sizes 4 6 --sensitivity
python simulation/run.py --output results/stable-ties.json --sizes 4 6 --sensitivity --sort-kind stable
python simulation/analyze.py
python simulation/paper_assets.py
sh paper/build.sh
```

The preflight path above is relative to the study root (`formalization/pesah-biased-cubic`). Production is single-process, limited to 2,400 CPU seconds and 2 GiB virtual address space; pilot costs and actual timings are recorded. Its fixed inventory is both deformation arms, sizes 4/6/8/10, four probability points per arm, and 250 shots from each of two generators (16,000 trials). `run.py` records all seeds and non-convergence/OSD counts; no failed trial is discarded. Seeds are `2026103000 + 100*L + 10*deformed + grid_index`, plus 100000 for the standard-library generator. The fit bootstrap seed is 87531, 400 draws (800 arm fits). Pilot seeds are 20261030 and 93. Validation seed is 73104. Runtime/memory values are machine-specific.

## Original implementation check

Historical third-party source is downloaded separately, not vendored or relicensed. The commit is the latest pre-submission version found, not a verified production commit.

```sh
git clone https://github.com/panqec/panqec.git /tmp/pesah-reference
git -C /tmp/pesah-reference checkout --detach 686560e5d03c2e5d31f6c6260b03756af03a7e93
python simulation/validate.py /tmp/pesah-reference results/validation.json
```

The validator loads only historical code classes and decoder functions, with a compatibility alias for removed `numpy.product`; it avoids unrelated GUI/matching imports. It compares independent incidence matrices and 240 corrections at L=2/3/4. Shared source definitions, error vectors, NumPy and machine limit independence. Two RNGs provide a separate generator diagnostic while sharing the decoding implementation. Source Python 3.8 was absent; no exact historical runtime is claimed.

## Evidence

The complete 66-page PDF remains external. Fetch the distinct 2021 MRes thesis from the author's permitted immutable GitHub source:

```sh
curl --fail --location https://raw.githubusercontent.com/artix41/artix41.github.io/b4f401e0c12b44be4c69318e0015f70d8a3d3f98/assets/pdf/master-thesis-ucl.pdf --output /tmp/pesah-mres-2021.pdf
sha256sum /tmp/pesah-mres-2021.pdf
python simulation/crops.py /tmp/pesah-mres-2021.pdf
```

Expected full-source SHA-256: `f08f3ede0cfbd5411ca20cc223d5bed079fa9aefd1484805ba80cfc1360a4ea0`. The evidence manifest records 600-dpi crop coordinates and hashes. Two attributed excerpts are outside the repository Apache grant; full source and historical code are not redistributed. See `evidence/README.md` and root `THIRD_PARTY.md`.

## Analysis and checks

`analyze.py` uses the source quadratic finite-size-scaling equation and unweighted least squares. It preserves the primary result while reporting binomial-likelihood, leave-one-extreme-size-out, generator and iteration sensitivities. Half-up rounding to 0.1 percentage point is distinct from limited reconstruction scope and conditional uncertainty. Three source comparisons share a Bonferroni family; the 32 generator comparisons are a separate family. Source counts and fit configuration remain unknown. No source ranking or equivalence is inferred from point estimates or overlapping bands.

`paper_assets.py` creates `numbers.tex`, comparison/sensitivity/ledger tables and `figures/crossovers.pdf` from saved results. The ledgers are copied cell-for-cell into the main paper. `paper/build.sh` builds the descriptive main PDF. `delivery.json` records the separate rendered/scientific review, hashes and fetched remote artifacts. Validate it from the study root with:

```sh
python ../../.agents/skills/replication-paper/scripts/delivery_check.py delivery.json --root .
```

The full PDF, raw external reference checkout and Python environment are not in git. All original reconstruction code, model choices, aggregate counts, bootstrap draws, manuscript sources and permitted evidence are included. No merge, author contact or public announcement is part of this delivery.
