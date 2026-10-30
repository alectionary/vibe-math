# Whole-dissertation continuation (open)

PR64 is a partial research milestone. `../coverage.json` lists every identified substantive result and explicit background/future-work exclusions. Feasible pending items keep the study open. The preserved stage-1 pure-X scripts and results are not overwritten.

Run from the repository root, with the original source checked out separately at PanQEC revision `686560e5d03c2e5d31f6c6260b03756af03a7e93` and the author-hosted dissertation obtained as documented in the study README. This directory does not vendor either source.

## General Pauli path and pure-Z stage

Use the study's pinned primary Python dependencies. The validation imports qecsim1.0b9 from the separately installed historical-reference dependency directory (substitute its actual path).

```sh
PYTHONPATH=/tmp/slot2-deps OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/expansion/validate_pauli.py /tmp/bn3d-2021 formalization/pesah-biased-cubic/expansion/validation.json
OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/expansion/run.py formalization/pesah-biased-cubic/expansion/pure-z-pilot-config.json formalization/pesah-biased-cubic/expansion/pure-z-pilot.json
for L in 4 6 8 10; do
  OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/expansion/run.py formalization/pesah-biased-cubic/expansion/pure-z-L${L}-config.json formalization/pesah-biased-cubic/expansion/pure-z-L${L}.json || break
done
OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/expansion/analyze_z.py
```

The runner resumes complete condition/generator rows using fixed seeds; interrupted rows restart from their seed, avoiding double counting. It rejects a changed configuration hash. Delete or select a different output path only for a deliberately fresh run. Atomic checkpoints record completion, runtime and resident memory. CPU limits apply per process. The first pure-Z stage uses 8,800 fresh trials, both generators and all four sizes. It is not the entire dissertation.

## Geometry and source figures

```sh
PYTHONPATH=/tmp/slot2-deps OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/expansion/check_geometry.py /tmp/bn3d-2021 formalization/pesah-biased-cubic/expansion/geometry-check.json
python formalization/pesah-biased-cubic/expansion/extract_bias.py /tmp/pesah-site/assets/pdf/master-thesis-ucl.pdf formalization/pesah-biased-cubic/expansion/source-bias-curves.json
```

Geometry checks establish finite commutation, ranks, logical witnesses and restricted-axis nullities. They do not establish distance lower bounds or asymptotic decoder thresholds. Bias extraction reads vector coordinates; manually inspect legends and axes (the colors swap meanings between the two figures). Eta3 appears in the plotted coordinates although the methods specify eta5; both alternatives remain in coverage. Figure values retain extraction uncertainty distinct from unknown original simulation uncertainty.

## Historical matching runtime

See `historical-runtime-attempts.md`. Exact PyMatching0.2.4 execution is blocked by an HTTP403 dependency download. Do not retry the denied host or fetch that dependency through another route. A modern matching reconstruction must be labeled separately and independently validated. No historical-equivalence claim is established by successful installation of a newer matching engine.

## Full numerical families and native OSD

Build original native source with a C++17 compiler on a little-endian host (the checked build used g++ as recorded in `native-build.json`):

```sh
g++ -O3 -std=c++17 -shared -fPIC formalization/pesah-biased-cubic/expansion/osd_native.cpp -o formalization/pesah-biased-cubic/expansion/osd_native.so
OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/expansion/validate_native.py
PYTHONPATH=/tmp/slot2-deps OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/expansion/validate_rhombic.py /tmp/bn3d-2021 formalization/pesah-biased-cubic/expansion/rhombic-validation.json
```

`families-plan.json`, `broad-plan.json` and `confirmation-plan.json` contain the exact configuration filenames. Run them sequentially with the following driver (parallelism is optional and must respect CPU/memory quotas). Existing completed outputs are checked by configuration hash and skipped; retain them, or use a separate output directory for a genuinely fresh rerun.

```sh
python - <<'PY'
import json,pathlib,subprocess,sys,os
r=pathlib.Path('formalization/pesah-biased-cubic/expansion')
for plan in ['families-plan.json','broad-plan.json','confirmation-plan.json']:
    for name in json.loads((r/plan).read_text())['configs']:
        subprocess.run([sys.executable,str(r/'run.py'),str(r/name),str(r/name.replace('-config.json','.json'))],check=True,env=dict(os.environ,OPENBLAS_NUM_THREADS='1'))
PY
OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/expansion/analyze_families.py
OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/expansion/refit_families.py
OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/expansion/analyze_confirmation.py
OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/expansion/decoder_diagnostics.py
```

The original and normalized fit outputs are both retained. Normalization and wider grids were selected after boundary diagnostics, so they are exploratory. Boundary, nonphysical-prediction and extrapolation flags must not be ignored when interpreting point estimates. Never equate a completed simulation file with an identified threshold.

## Sweep reconstruction and software checks

A separate environment supplies PyMatching2.3.1, NumPy2.3.5, SciPy1.17.0, qecsim1.0b9, NetworkX2.6.2 and Flask3.1.2. Use its Python in these commands; the environment path below is illustrative. This is explicitly a modern-matching reconstruction. Do not try to recover the denied historical dependency through another host.

```sh
/tmp/slot2-historical-env/bin/python formalization/pesah-biased-cubic/expansion/validate_matching.py formalization/pesah-biased-cubic/expansion/matching-validation.json
for axis in X Z depolarizing; do
  OPENBLAS_NUM_THREADS=1 /tmp/slot2-historical-env/bin/python formalization/pesah-biased-cubic/expansion/run_sweep.py /tmp/bn3d-2021 formalization/pesah-biased-cubic/expansion/sweep-${axis}-config.json formalization/pesah-biased-cubic/expansion/sweep-${axis}.json || break
done
OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/expansion/analyze_sweep.py
PYTHONPATH=/tmp/slot2-deps OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/expansion/benchmark_osd.py /tmp/bn3d-2021 formalization/pesah-biased-cubic/expansion/osd-benchmark.json
/tmp/slot2-historical-env/bin/python formalization/pesah-biased-cubic/expansion/check_gui.py /tmp/bn3d-2021 /workspace/vibe-math/formalization/pesah-biased-cubic/expansion/gui-backend.json
```

The GUI command needs an absolute output path because the historical Flask app runs from its own checkout. It tests zero-syndrome backend cases, not frontend rendering or arbitrary noisy decoding. `gui-browser.json` records the attempted browser check and denied external module. The benchmark's naive baseline is reconstructed and the recorded run had other workloads active; its timings do not reproduce the missing original workload/hardware.

## Finite certificates, comparisons and paper

```sh
OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/expansion/distance_certificates.py
python formalization/pesah-biased-cubic/expansion/sector_limits.py
python formalization/pesah-biased-cubic/expansion/extract_crossovers.py /tmp/pesah-site/assets/pdf/master-thesis-ucl.pdf formalization/pesah-biased-cubic/expansion/source-crossovers.json
python formalization/pesah-biased-cubic/expansion/analyze_curves.py
python formalization/pesah-biased-cubic/expansion/compare_thresholds.py
python formalization/pesah-biased-cubic/expansion/compare_ranking.py
python formalization/pesah-biased-cubic/expansion/paper_tables.py
python formalization/pesah-biased-cubic/expansion/plot_curves.py
sh formalization/pesah-biased-cubic/paper/expanded-build.sh
```

The finite distance certificates are exact arithmetic checks at the five recorded sizes, not a general formal proof. The binomial sector audit assumes ideal component decoding and independent errors; it is not a BP-OSD threshold result. Source extraction uses PyMuPDF (fitz), crops use Poppler/Pillow, and manuscript compilation uses pdfLaTeX/BibTeX. The expanded manuscript is explicitly a working draft until its review/delivery record is complete. Stage-1 delivery records apply only to their recorded hashes.
