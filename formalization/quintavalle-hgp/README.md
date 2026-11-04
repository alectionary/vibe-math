# Finite checks of Quintavalle’s hypergraph-product dissertation

This is an **incomplete whole-dissertation replication attempt**, not a completed replication or proof certification. The selected dissertation is [Armanda Ottaviano Quintavalle (2022), *Hypergraph product codes: a bridge to scalable quantum computers*, University of Sheffield](https://etheses.whiterose.ac.uk/id/eprint/32300/).

The fresh checkout branch is `replication/quintavalle-hgp-20261103`, based on `7f1fcba97d98cca427333304b29fce0a8d595bb5`. The original plan was committed in `37d61d0b` before analysis, with appendix inventory additions in `bde0771d`. No publication or remote delivery is implied.

## Results and limits

- Exact ReShape checks: 1,061 guaranteed-range errors; complete classification of 8,192 planar3 and 256 toric2 error patterns.
- Logical bases: all 256 pairs of binary 2-by-2 seeds checked. All 9 of 9 symmetric-code appendix rows match computed construction parameters; quantum distance is inherited from the source theorem, not independently exhaustively proved.
- Independent tensor construction: all 19 available original Hx/metacheck matrices agree entry for entry.
- Reconstructed toric ReShape experiment: 56 settings, 560,000 trials, Wilson intervals and 56-cell Bonferroni intervals. Source grid and tie conventions were not recovered.
- Original BP+OSD software: 1,050,000 production trials and 80,000 earlier diagnostic trials. Code capacity finished for toric L=5, 7, 9, 11 and surface L=5, 7, 9. Toric L=9 and L=11 cross between p=.21 and p=.215, beside the reported 21.55(1)%. No critical-exponent fit was computed. Surface L=3 aborts in the pinned binary. Surface L=11 matrices are absent.
- Sustainable N=8 curves at L=5 and L=7 finished. Toric sizes cross between p=.025 and p=.03; surface sizes cross between p=.03 and p=.035, beside the reported 2.78% to 3.08% region. The N=8 grids at L=9 and L=11 were declined for this project's compute limit, about 54 CPU-hours per toric L=11 point. MWPM is not in the archive. **0 of 4** sustainable threshold estimates, **0 of 2** code-capacity fits, **0 of 2** suppression exponent fits, and **0 of 3** random-product performance analyses were reproduced.
- At toric L=5, p=.1 and depth N=1, repair gives 114 versus 9 failures at q=.02 and 6731 versus 5574 at q=.1, per 10,000 trials. The source figure does not list that q grid or the depth.
- Literal sibling-gate and partition comparisons contain provisional discrepancies. Independent representations check our calculations. The thesis PDF was read and the Chapter 4 figures were inspected; Pauli-frame and symmetry conventions remain unresolved. They are not established source errors.

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

`sources/browser-extraction.txt` is a text extraction with page and line markers. The thesis PDF was later read in full, and the rendered headline pages were inspected; see `availability.md`. The scripts still use the extracted matrices. Do not treat a text line as a substitute for a figure that was not in the inspected set.

## Manuscript and acceptance

The current manuscript is [hypergraph_product_codes__finite_support_and_unresolved_production_results.pdf](paper/hypergraph_product_codes__finite_support_and_unresolved_production_results.pdf), with [editable source](paper/manuscript.tex) and [bibliography](paper/references.tex). Build from `paper/` with `pdflatex -interaction=nonstopmode -halt-on-error manuscript.tex` twice, then copy `manuscript.pdf` to that descriptive filename and refresh hashes/review. the isolated writer manifest and independent review records record their exact hashes. Build instructions are provided with the manuscript. Local scientific evidence and editorial acceptance are separate from publication. No push, PR, merge, remote-byte verification, or public delivery is authorized in this task.

From the repository root, validate the evidence packet with:

```sh
python .agents/skills/replication-paper/scripts/stage_checks.py packet formalization/quintavalle-hgp/evidence-packet.json --root formalization/quintavalle-hgp
python -m unittest discover -s .agents/skills/replication-paper/tests -v
```

`analysis/gf2.py` is imported by the exact checks; it has no standalone execution target. Reproduction environment versions and the model-specific engine fallback are in `provenance/`. The absence of R SEM libraries is not a missing decoder dependency.

## Local Published/Ours attribution repair

The repaired manuscript has separate evidence-linked Published and Ours findings for all 14 headline rows. Null scalar contrasts no longer erase theorem statements, reported estimates, or completed finite checks. All four source threshold estimates are retained; our 0 of 4 production completion remains explicit. The broader confinement conjecture is distinct from the conditional linear-confinement theorem.

The updated reusable skill validates declared evidence, actual column headers and each rendered cell, with 190 passing tests including 18 new regressions. Such checks do not establish scientific source truth; a fresh source-by-source and rendered review is required. See `sources/headline-finding-audit.json` and the current review/validation records in `provenance/`. Original reporting artifacts are preserved in `provenance/published-column-original/`; their former passing reviews are superseded, not retroactively altered.

This repair is local on `repair/quintavalle-published-findings`; the earlier remote branch and archive are historical snapshots. No new scientific runs or production fits were performed. Current local publication status is recorded in `delivery.json`; no remote delivery of the repaired bytes is implied.
