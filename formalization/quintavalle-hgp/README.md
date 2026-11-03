# Finite checks of Quintavalle’s hypergraph-product dissertation

This is an **incomplete whole-dissertation replication attempt**, not a completed replication or proof certification. The selected dissertation is [Armanda Ottaviano Quintavalle (2022), *Hypergraph product codes: a bridge to scalable quantum computers*, University of Sheffield](https://etheses.whiterose.ac.uk/id/eprint/32300/).

The fresh checkout branch is `replication/quintavalle-hgp-20261103`, based on `7f1fcba97d98cca427333304b29fce0a8d595bb5`. The original plan was committed in `37d61d0b` before analysis, with appendix inventory additions in `bde0771d`. No publication or remote delivery is implied.

## Results and limits

- Exact ReShape checks: 1,061 guaranteed-range errors; complete classification of 8,192 planar3 and 256 toric2 error patterns.
- Logical bases: all 256 pairs of binary 2-by-2 seeds checked. All 9 of 9 symmetric-code appendix rows match computed construction parameters; quantum distance is inherited from the source theorem, not independently exhaustively proved.
- Independent tensor construction: all 19 available original Hx/metacheck matrices agree entry for entry.
- Reconstructed toric ReShape experiment: 56 settings, 560,000 trials, Wilson intervals and 56-cell Bonferroni intervals. Source grid and tie conventions were not recovered.
- Original BP+OSD software: eight diagnostic conditions, 80,000 trials. At q=.03, repair reduces failures from 617 to 72 per 10,000 trials at our reconstructed depth N=1. This is not an exact reproduction of source Figure 2.
- **0 of 4** sustainable threshold estimates, **0 of 2** code-capacity analyses, **0 of 2** suppression exponent fits, and **0 of 3** random-product performance analyses reproduced. Toric L11 took 180 seconds for only nine completed pilot trials; projected cost is approximately 55.6 CPU-hours per 10,000-trial point, before full production grids.
- Literal sibling-gate and partition comparisons contain provisional discrepancies. Independent representations check our calculations, but original PDF ink and Pauli-frame/symmetry conventions remain unresolved. They are not established author errors.

Consult [research-notes.md](research-notes.md), [evidence-packet.json](evidence-packet.json), [REPLICATION-PLAN.yaml](REPLICATION-PLAN.yaml), and [availability.md](availability.md) for the complete inventory, source access limits, and stopping basis. The packet’s structural validation does not establish scientific correctness.

## Reproduce

From this study directory, using Python 3.11 or newer, CMake, and a C++ compiler:

```sh
python -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
export OPENBLAS_NUM_THREADS=1
export MPLCONFIGDIR=/tmp/quintavalle-matplotlib
python analysis/verify.py
python analysis/independent_checks.py vendor/single_shot_3D_HGP
python analysis/toric_noise.py
cmake -S vendor/single_shot_3D_HGP -B vendor/single_shot_3D_HGP/build -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build vendor/single_shot_3D_HGP/build -j2
python analysis/upstream_runs.py vendor/single_shot_3D_HGP
python analysis/upstream_runs.py vendor/single_shot_3D_HGP --suite
```

`verify.py` writes `results/exact_checks.json`; `independent_checks.py` writes `results/independent_checks.json`; `toric_noise.py` writes `results/toric_noise.json`, `.pdf` and `.png`. `upstream_runs.py` writes the pilot/grid JSON summaries and every original input, log and output under `results/original/`. The pilot intentionally includes an absent surfaceL11 input and a capped toricL11 run. Timeout-dependent pilot counts and measured timings may vary. “All exact checks passed” in the log means the implementation assertions passed; scientific gate failures remain in the JSON.

Monte Carlo seed is 20261103; original diagnostic seeds are `20261103 + 100*i + repair` for q index i; pilots use `20261103+i`. Exact enumeration has no random seed. Results are overwritten on rerun: preserve the committed outputs before running comparisons. Original-source diagnostics use the original program’s final round, which injects fresh data noise before perfect measurement. The vendored code is unmodified MIT-licensed upstream commit `bdfb437b2abcfa514997f26be97a711b878448cb`, with BP+OSD submodule `74f86d3ef00f04bbb90a043dfef52e92a091f4d3`; see `provenance/upstream.json` and upstream licence files. No network fetch is required for the vendored build.

The thesis extraction is a text-only browser retrieval with page/line markers; it is not a substitute for the source PDF. The scripts use its printed matrix extraction. Do not report source-image validation from these files.

## Manuscript and acceptance

The current manuscript is [hypergraph_product_codes__finite_support_and_unresolved_production_results.pdf](paper/hypergraph_product_codes__finite_support_and_unresolved_production_results.pdf), with [editable source](paper/manuscript.tex) and [bibliography](paper/references.tex). Build from `paper/` with `pdflatex -interaction=nonstopmode -halt-on-error manuscript.tex` twice, then copy `manuscript.pdf` to that descriptive filename and refresh hashes/review. the isolated writer manifest and independent review records record their exact hashes. Build instructions are provided with the manuscript. Local scientific evidence and editorial acceptance are separate from publication. No push, PR, merge, remote-byte verification, or public delivery is authorized in this task.

From the repository root, validate the evidence packet with:

```sh
python .agents/skills/replication-paper/scripts/stage_checks.py packet formalization/quintavalle-hgp/evidence-packet.json --root formalization/quintavalle-hgp
python -m unittest discover -s .agents/skills/replication-paper/tests -v
```

`analysis/gf2.py` is imported by the exact checks; it has no standalone execution target. Reproduction environment versions and the model-specific engine fallback are in `provenance/`. The absence of R SEM libraries is not a missing decoder dependency.
