# Small Bolza quantum memories: a bounded replication

The sixfold physical-qubit saving replicates exactly. Performance curves are close but are not identical: at physical error probability 0.001, our four-logical-qubit block failure rates are 0.13822 for 16-qubit Bolza and 0.13030 for four planar patches using 96 qubits. The corresponding figure-derived values are 0.13390 and 0.12977. This study covers Higgott's Figure 7.14a and small-code parameters, with supporting second-size simulations. It does not replicate the whole dissertation.

Read [sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.pdf](paper/sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.pdf), or edit [sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.tex](paper/sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.tex).

The separate **Higgott_Chapter_7_Figure_7_14_Source_Evidence_Appendix.pdf** contains five pages and six independently checked source crops. It is delivered separately through Library, identity `libfile_00168a0941b881918bd1d5086249da3a`; its pixels are not included in this local bundle. The original thesis PDF and vector-extraction program are also not bundled. Rebuilding our paper or rerunning simulations does not require them; independently repeating source extraction does.

## Snapshot and scope

The local archive contains all simulation prerequisites, including selected upstream circuit data and the comparator generator's source and licenses. `SNAPSHOT.json` identifies a local Git revision containing the runnable code and inputs. It is the reproduction revision. Starting master `ca1d06209b03cad666db0a2ffb9678abc89a6b71` is historical workflow provenance, **not** a runnable revision of this new study. The replication skill SHA-256 is `28332faba7f168d0b2d42e7815dc20021fbe8bd3968fd763e57d94a4986544ab`; it was not modified.

No new study files are on GitHub master yet. Manuscript links intentionally point to intended master paths under repository conventions; they are navigation placeholders until publication, not immutable reproduction links. No PR, publication, or merge occurred.

## Prerequisites and setup

Commands below run from this study directory, `formalization/higgott-quantum-decoding`, unless otherwise stated. Python 3.12 was used for the primary run. The package lock contains the versions actually installed; installs require network access to the Python package index. Native wheels are available for this Linux environment; other platforms may need a compiler. No R/SEM packages are required.

```sh
python3.12 -m venv .venv
.venv/bin/python -m pip install -r provenance/requirements-lock.txt
export PYTHONPATH="$PWD/vendor/honeycomb-boundaries/src"
export MPLCONFIGDIR=/tmp/higgott-mpl
export XDG_CACHE_HOME=/tmp/higgott-cache
export OPENBLAS_NUM_THREADS=1
export OMP_NUM_THREADS=1
```

The vendor tree is pinned to `Strilanc/honeycomb-boundaries` revision `cc33baac44c7831bd643db81d0053f8ec6eae9d8` with only the import-location correction in [honeycomb_scipy_compat.patch](provenance/honeycomb_scipy_compat.patch). Bolza inputs come from `oscarhiggott/hyperbolic-floquet-data` revision `457975f0d6c67b3a505aacf44589d36779f5dcc1`. Both licenses are included. These files are research inputs; the skill itself is not vendored or changed.

## Rebuild the paper from saved outputs

This does not rerun simulations or acquire missing source PDFs.

```sh
.venv/bin/python summarize.py
cd paper
pdflatex -interaction=nonstopmode -halt-on-error sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.tex
pdflatex -interaction=nonstopmode -halt-on-error sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.tex
```

Expected outputs: `results/figure_comparison.csv`, `results/aggregated_rates.json`, `results/summary.json`, the comparison plot PDF/PNG, and the descriptively named eight-page paper PDF (page count may vary with TeX fonts). The bibliography is editable within the `.tex` source; BibTeX is not required. Build used pdfTeX 1.40.26, TeX Live 2025/dev, with geometry, amsmath, booktabs, longtable, graphicx, array, xurl, natbib, hyperref and fontenc.

## Rerun simulations

```sh
.venv/bin/python run_replication.py --source inputs/bolza --shots 100000 --workers 2
.venv/bin/python summarize.py
```

This runs all 226 documented conditions: Bolza sizes 16/64, planar distances 2/3/4, both bases, 48/96 subrounds, and both planar boundary-noise variants. Family keys `b1,b2` denote Bolza; `q2,q3,q4` are the aligned EM3_v3 planar model; `p2,p3,p4` are the EM3_v2 diagnostic. The 48-subround first-size grid has 16 logarithmically spaced p values; remaining arms have five specified p values. Every arm has 100,000 fixed shots, in batches at most 8192.

Each condition checkpoints atomically to `results/FAMILY_BASIS_pP_sSUBROUNDS_nSHOTS.json`. Existing files are reused by name. **The cache does not detect code edits:** for a genuine rerun after changes, move the complete `results` directory aside and create an empty one first. Do not mix runs from different script versions. Seeds derive deterministically from the full condition key, with exact seed and circuit hash saved per row. Exact Monte Carlo counts can change across software versions, platforms, or sampling batch sizes even with a fixed seed. Scientific conclusions should agree within statistical uncertainty.

The supplied circuit files have 96 subrounds. Our 48-subround reconstruction changes the bulk repeat count from 15 to 7 and retains boundary operations. EM3 is reconstructed through its joint Pauli/measurement channel; numerical literal replacement is not used. Simulator helper qubits do not count as physical EM3 qubits.

The pilot and actual run were feasible under four CPU cores and 16 GiB RAM using two processes. Runtime depends on hardware and noise strength; inspect `elapsed_seconds` in the checkpoints. No portable speed claim is made.

## Reproduce independent checks

```sh
.venv/bin/python audit_supplied_circuits.py --source inputs/bolza --output provenance/supplied_circuit_pilot.json
.venv/bin/python code_parameters.py --source inputs/bolza
.venv/bin/python audit_structure.py
.venv/bin/python independent_checks.py
.venv/bin/python prepare_historical_circuits.py
.venv/bin/python graph_conversion_check.py
```

Outputs are respectively the supplied-data pilot, independent embedded-code parameters, EM3 generator and logical-basis audits, independent channel/optimizer checks, serialized primary circuits, and legacy/native graph-conversion comparisons. Distinguish embedded-distance enumeration from graphlike circuit-distance searches: no unrestricted circuit-distance theorem is claimed. In the embedded enumeration, `null` in a directional distance means greater than four, not failure; the opposite direction establishes the reported minimum.

`independent_checks.py` compares equivalent binary-generator and mutually exclusive categorical noise representations, checks noiseless circuits, computes exact no-correction probabilities, and uses NetworkX shortest paths plus minimum-weight matching as a second optimizer on 1,000 syndromes. Both circuit samplers still use Stim. `graph_conversion_check.py` imports the historical converter but omits its artificial weight-1e10 dummy edges, which modern PyMatching rejects. This is a documented graph-policy sensitivity, not an exact execution of the entire historical decoder.

## Historical software sensitivity

Install Python 3.10 separately if it is unavailable. A separate environment avoids replacing the primary libraries.

```sh
python3.10 -m venv .historical
.historical/bin/python -m pip install -r provenance/historical-requirements-lock.txt
.venv/bin/python prepare_historical_circuits.py
.historical/bin/python historical_check.py
```

Expected output: `provenance/historical_results.json`, 64 basis circuits with 100,000 shots each, using Stim 1.12.0 and PyMatching 2.1.0. These versions approximate the thesis era, not a recovered original lockfile. Historical circuits are also bundled, so regeneration is optional when replaying the unchanged snapshot.

## Tests and known failures

```sh
.venv/bin/python -m pytest vendor/honeycomb-boundaries/src/hcb/tools/gen/noise_test.py vendor/honeycomb-boundaries/src/hcb/codes/honeycomb -k 'EM3 or test_em3' -q
.venv/bin/python -m pytest vendor/honeycomb-boundaries/src/hcb/tools/gen/noise_test.py vendor/honeycomb-boundaries/src/hcb/codes/honeycomb -q
```

The first command passed 122 tests, with 168 deselected. The second passed 270 and failed 20 SD6/SI1000 decomposed-distance expectations under modern Stim. Those failures are retained in `provenance/generator_tests_compat.log`; they prevent a claim that the complete external suite passed, but do not invalidate the separately checked EM3 arms. The original import failure is preserved in `generator_tests.log`.

From the enclosing repository root, the unchanged workflow checks were:

```sh
python3 -m unittest discover -s .agents/skills/replication-paper/tests -v
python3 .agents/skills/replication-paper/scripts/check_citations.py formalization/higgott-quantum-decoding/paper/sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.tex --references formalization/higgott-quantum-decoding/paper/sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.tex --log formalization/higgott-quantum-decoding/paper/sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.log
```

## Source extraction and uncertainty

[figure_7_14a_vector_values.csv](source/figure_7_14a_vector_values.csv) contains independently supplied figure coordinates converted to probabilities, not original shot arrays. [figure_provenance.json](source/figure_provenance.json) records source hashes and extraction bounds. Exact re-extraction requires the separately held thesis PDF, arXiv v1 figure PDF, and source review extraction program. Our report rebuild uses the saved CSV and does not pretend to recreate those inputs.

Our Monte Carlo uncertainty, vector extraction bounds, and unknown original-source Monte Carlo uncertainty remain distinct. The .02 margin is an exploratory practical comparison, not a hypothesis-test standard error or a source-specified tolerance. The exact sixfold resource ratio is independent of this margin. The second-size run is supporting simulation evidence; Figure 7.14b was not numerically digitized here.
