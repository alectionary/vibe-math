# Small Bolza quantum memories: a bounded replication

The sixfold physical-qubit saving replicates exactly. Fresh fixed-budget confirmation gives Bolza .13772 versus planar .12925 at p=.001, a difference .00847 with simultaneous half-width .00135 over five selected comparisons. This supports a resource/performance tradeoff, not equal error rates. In the preserved original baseline: at physical error probability 0.001, our four-logical-qubit block failure rates are 0.13822 for 16-qubit Bolza and 0.13030 for four planar patches using 96 qubits. The corresponding figure-derived values are 0.13390 and 0.12977. This study covers Higgott's Figure 7.14a and small-code parameters, with supporting second-size simulations. It does not replicate the whole dissertation.

Read [sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.pdf](paper/sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.pdf), or edit [sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.tex](paper/sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.tex).

The bundled [Higgott_Chapter_7_Figure_7_14_Source_Evidence_Appendix.pdf](source-evidence/Higgott_Chapter_7_Figure_7_14_Source_Evidence_Appendix.pdf) contains five pages and six source crops. [source-evidence/README.md](source-evidence/README.md) links the crops, hashes, CSV and extraction program. Full source PDF bytes are external prerequisites for re-extraction, not for rebuilding the report.

## Snapshot and scope

The original numerical baseline is immutable at `8cbde40ad9db1b314e19e5878f2a8148ce2d958d`; its result files remain unchanged. Source evidence was added at `6fb8e490467cca4d208c191c8616626455d46031`. These are historical provenance, not the revision for new follow-up code. For the revised study, use the artifact/reproduction revision in [delivery_record.json](revision3/delivery_record.json), or checkout the exact current-commit links in [draft PR57](https://github.com/alectionary/vibe-math/pull/57). That revision contains the code, saved outputs, manuscript and required local inputs; the later delivery-record commit documents verification without changing those artifacts. Starting master `ca1d06209b03cad666db0a2ffb9678abc89a6b71` identifies the original workflow version. Research and skill changes have separate draft PRs; no merge is authorized.

Manuscript links retain intended master paths and resolve there after merge. PR links pin current review artifacts. The approved Kupzyk preamble supplies the letter page size, margins, paragraph style and scalable body fonts.

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
.venv/bin/python revision2/summarize_followup.py
.venv/bin/python revision2/build_ledgers.py
python revision3/comparisons.py
cd paper
pdflatex -interaction=nonstopmode -halt-on-error sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.tex
pdflatex -interaction=nonstopmode -halt-on-error sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.tex
```

Expected outputs: `results/figure_comparison.csv`, `results/aggregated_rates.json`, `results/summary.json`, the comparison plot PDF/PNG, and the descriptively named thirteen-page paper PDF (page count may vary with TeX fonts). The bibliography is editable in `paper/references.tex`; BibTeX is not required. Build used pdfTeX 1.40.26, TeX Live 2025/dev, with geometry, amsmath, booktabs, longtable, graphicx, array, xurl, natbib and hyperref.

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

[figure_7_14a_vector_values.csv](source/figure_7_14a_vector_values.csv) contains independently supplied figure coordinates converted to probabilities, not original shot arrays. [figure_provenance.json](source/figure_provenance.json) records source hashes and extraction bounds. Exact re-extraction requires external thesis and arXiv v1 figure PDF bytes; the source review extraction program is bundled under source-evidence. Our report rebuild uses the saved CSV and does not pretend to recreate those inputs.

Our Monte Carlo uncertainty, vector extraction bounds, and unknown original-source Monte Carlo uncertainty remain distinct. The .02 margin is an exploratory practical comparison, not a hypothesis-test standard error or a source-specified tolerance. The exact sixfold resource ratio is independent of this margin. The second-size run is supporting simulation evidence; Figure 7.14b was not numerically digitized here.

## Follow-up checks

The fixed protocol is [protocol.md](revision2/protocol.md); original outputs are never pooled with confirmation. Commands run from this study directory after primary setup:

```sh
.venv/bin/python revision2/confirm_and_decode.py
.venv/bin/python revision2/independent_frame.py
.venv/bin/python revision2/basis_mapping.py
.venv/bin/python revision2/summarize_followup.py
.venv/bin/python -m unittest discover -s revision2 -p 'test_*.py' -v
```

Outputs are respectively `revision2/confirmation.json` plus `decoder_diagnostics.json`, `independent_frame_results.json`, `basis_mapping.json`, and `followup_summary.json` plus `paper/confirmation_table.tex`. Confirmation uses twenty fixed one-million-shot arms and seeds 710000 onward. Scripts overwrite only their own follow-up outputs; they do not resume partial runs. The independent pilot uses ten fixed 10,000-shot batches per basis with seeds 811–820, plus separate Stim comparison seed820. Its source parser shares Stim syntax handling, while its sampler uses NumPy and no Stim detector model. Geometry, detector annotations and decoding remain shared.

The source-pinned diagnostic needs Python3.10 and the runtime lock. It executes the original comparator graph converter including dummy edges on four saved p=.001 circuits, using 100,000 shots each and seeds93000–93003:

```sh
python3.10 -m venv .source-pinned
.source-pinned/bin/python -m pip install -r revision2/source-pinned-requirements-lock.txt
.source-pinned/bin/python revision2/source_pinned_check.py
```

Output: `revision2/source_pinned_results.json`. A separate 10,000-shot pilot is retained as `source_pinned_pilot.json`, not pooled. Repository pins are not Higgott's recovered production environment. StimCirq/cirq-web/pytest were unnecessary for this serialized-circuit diagnostic and were not installed; NetworkX2.8.8 supplies an otherwise unpinned dependency. Installation and execution logs are retained.

The bounded archival result is [public_archival_audit.md](revision2/public_archival_audit.md). Exact illustrated logical-path correspondence remains unavailable; the explicit canonical mapping in `basis_mapping.json` is not substituted for it. No author contact occurred. Additional full simulator work is not needed for this bounded pilot; independent geometry and ideal-state synthesis would be a larger separate task.

## Verify published delivery

The independent rendered review is [manuscript_review.json](revision3/manuscript_review.json). The delivery record pins the artifact revision and records downloaded-byte checks for the main PDF, editable source, bibliography, README and every source-evidence file. `revision2/verify_delivery.py` reproduces those downloads (network and curl required), writing temporary copies under `/tmp/higgott-verified-delivery` and refreshing only delivery metadata:

```sh
python revision2/verify_delivery.py ARTIFACT_COMMIT_FROM_DELIVERY_RECORD revision3
python /path/to/replication-paper/scripts/delivery_check.py revision3/delivery_record.json --root .
```

Use the checker from the separate skill draft PR58. Its test success is not manuscript acceptance: the independent review separately records layout, findings/tolerances, citations, ledger rows, links and independence limits against the PDF and all LaTeX/figure build inputs. Artifact review URLs use immutable commits; paper navigation links continue to target master after merge.

## Headline and uncertainty reporting audit

The scientific headline has two components: exact resource savings and failure-rate performance. Embedded distance and second-size simulations are supporting checks. [claim_inventory.json](revision3/claim_inventory.json) records roles and signed contrasts. The p=.01 source point ordering reverses in fresh simulation; source ranking inference remains withheld because original counts are unavailable.

To recompute reporting from preserved counts (no simulation):

```sh
python revision3/comparisons.py
python -m unittest discover -s revision3 -v
```

Outputs: `revision3/comparison_decisions.json`, `revision3/calculation_check.json` when stdout is saved, and `paper/confirmation_decisions.tex` / `paper/baseline_decisions.tex`. Run this before the two PDF build passes. Families are 32 baseline source comparisons, 10 confirmation source comparisons and five reconstructed contrasts. The detailed tables separate display-rounding verdict, reconstruction scope and conditional band status. The old `.02` classification in saved baseline outputs/table is preserved as historical exploratory sensitivity, not the criterion used by current tables. Source uncertainty remains unknown; normal/delta approximations are restricted to high-count first-size comparisons, and rare-event supporting inference is withheld.
