# Replication: Chen (2021), mediation analysis in regression discontinuity designs

Full-design replication of Donna Chen, *Statistical Mediation Analysis in Regression Discontinuity
Design for Causal Inference*, PhD dissertation, University of Nebraska-Lincoln, December 2021
(first adviser James A. Bovaird, second adviser Lorey A. Wheeler).
[Digital Commons record](https://digitalcommons.unl.edu/cehsdiss/403/).

Coordination: [issue #88](https://github.com/alectionary/vibe-math/issues/88).
Workflow: `replication-paper` skill; `REPLICATION-PLAN.yaml` was committed before any analysis.

## Inputs not in git

- `source/chen2021.pdf`: download from the Digital Commons record above. SHA-256
  `9206b3d824077d36c86b4935ff7f19f64b3fdebde7746943b8a94500fe11e557`, 6,720,692 bytes, 203 pages.
  Needed only by `build_packet.py` (to check source excerpts) and the paper build.
- `simulation/work/`: one JSON file per simulation condition (1,280 files), produced by the run below.
- The Head Start Impact Study data used in Chapter 4 (RQ2) are restricted-use and were not obtained;
  see `notes/availability.md`.

## Reproduce

Python 3 with NumPy (tested with Python 3.13.18 / NumPy 2.5.3 and Python 3.10.12 / NumPy 2.2.6);
`validate_estimator.py` also needs scikit-learn. All commands run from this directory.

| Step | Command | Output | Time |
|---|---|---|---|
| Check the estimator | `cd simulation && python3 validate_estimator.py` | prints `PASS_ESTIMATOR_VALIDATION` | seconds |
| Full simulation | `cd simulation && OPENBLAS_NUM_THREADS=1 python3 chen_sim.py run --out work --workers 2` | `simulation/work/cond_0000.json` ... `cond_1279.json` | about 13.7 core-hours |
| Aggregate | `cd simulation && python3 aggregate.py work ../results` | `results/cells.csv`, `table48_ours.csv`, `table49_ours.csv`, `type1.csv`, `power.csv`, `summary.json` | seconds |
| Prose-statement checks | `cd simulation && python3 statement_checks.py ../results/cells.csv > ../results/statement_checks.csv` | `results/statement_checks.csv` | seconds |
| Table 4.6-4.7 arithmetic | `cd secondary && python3 table_arithmetic.py` | `secondary/table_arithmetic.csv` | seconds |
| Table 4.8 zero-estimate diagnostic | `python3 secondary/zero_estimate_check.py > secondary/zero_estimate_check.csv` | `secondary/zero_estimate_check.csv` | seconds |
| Evidence packet | `python3 build_packet.py` (needs the source PDF and `pdftotext`) | `evidence-packet.json` | seconds |

**Seeds.** Condition `k` (0-1279, the order of `chen_sim.CONDITIONS`) uses
`numpy.random.SeedSequence(20211201, spawn_key=(k,))`, so conditions can run in any order or on
different machines and give identical results (`notes/run-record.md` records a cross-host check).
`chen_sim.py run` skips conditions whose output file exists, so an interrupted run resumes;
`--only K ...` runs selected conditions.

`chen_sim.py bench` times one replication at each sample size.
