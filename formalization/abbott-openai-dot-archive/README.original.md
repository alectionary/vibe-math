# Abbott 2010 dissertation replication

This private research bundle reconstructs published statistics from Daniel H. Abbott's *Constructing a creative self-efficacy inventory: A mixed methods inquiry* (University of Nebraska-Lincoln, May 2010).

**Outcome: partial reconstruction, not a raw-data empirical replication.** Eight structural models on the rounded published correlation matrix broadly preserve the two-dimension association and model-preference pattern. Several printed-summary calculations need clarification. Original FIML/MLR data, missingness patterns, full simulation inputs, and full interview transcripts were not obtained. No participant records were synthesized.

Start with [the readable report](report/abbott_replication.pdf) or its [editable Markdown](report/replication_note.md). Supporting detailed notes are [source review](report/source_review.md), [matrix audit](report/matrix_audit.md), [published arithmetic](report/published_checks.md), and [independent model verification](report/sem_verification.md).

## Reproduce the calculations

Run from this directory using Python 3.12.14. Exact tested Python dependencies are in `requirements.txt`; Poppler 26.05.0 is needed only for source extraction/rendering and PDF QA. Use an environment permitting those packages; installation is not silently attempted by the scripts.

```sh
export OPENBLAS_NUM_THREADS=1
python scripts/extract_matrix.py
python scripts/fit_sem.py
python scripts/verify_sem.py
python scripts/published_checks.py
python scripts/compare_models.py
python scripts/rounding_sensitivity.py --replicates 200
python -m unittest discover -s tests -v
python scripts/build_report.py
```

The included `sources/pages/` text and printed-summary CSVs allow every numerical calculation without a network connection or participant dataset. Extraction and published checks are deterministic. Fitting has deterministic starting points; the independent numerical verification uses seed **8675309**. Rounding diagnostics use seed **201005**, 200 independent symmetric matrix perturbations, not simulated respondents. A ten-draw benchmark projected about 32 seconds; the full diagnostic completed in about 32 seconds on the checked environment. Timing fields and last numerical digits may vary across platforms. Ranges are exploratory and not confidence intervals or exhaustive bounds.

`outputs/model_comparison.csv` puts the original robust statistics beside the limited plain-ML reconstruction without equating them; `outputs/model_ranking.csv` records the AIC contrasts.

`outputs/sem_fits.json` records objective values, solutions, parameters, software versions, and optimizer agreement. `outputs/sem_verification.json` records independent RAM-covariance and numerical-gradient checks, local identification ranks, auxiliary-profile checks, and covariance/sample-size conventions. `outputs/published_checks.{json,csv,md}` holds all 36 summary checks. `outputs/matrix_audit.json` holds matrix diagnostics, KMO subsets, and the conditional SD bound. `outputs/rounding_sensitivity.{csv,json}` records every diagnostic draw.

## Verify or reacquire the source

The original PDF is intentionally not in the ZIP. Obtain it through the [official UNL record](https://digitalcommons.unl.edu/cehsdiss/68/) or [official download](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1067&context=cehsdiss), save it locally, then run:

```sh
python scripts/verify_source.py --pdf /path/to/abbott-unl.pdf --extract
python scripts/render_matrix.py --pdf /path/to/abbott-unl.pdf
python scripts/render_published_crops.py --pdf /path/to/abbott-unl.pdf
python scripts/crop_source_mapping.py --pdf /path/to/abbott-unl.pdf
```

Expected SHA-256: `a3c381d6f6295e917806834364b7f55fc35684b3db53174a53c3564feab4d70a`; 7,626,437 bytes; 283 PDF pages. Every renderer rejects a mismatching hash. Printed page 1 = PDF page 15. The default path in some scripts is `/tmp/abbott-unl.pdf`, used during this run, not a claim that this path will exist on another machine. If the archive changes the binary, do not silently bypass the hash check: compare the versions and record fresh provenance.

Source evidence is cropped from 600 dpi Poppler renders, with manifests under `outputs/crops/`, `outputs/matrix_crops/`, and `outputs/source_crops/`. The reported disputed values were visually checked. The full extracted text is supplied only as a source-reading aid, not as a replacement for inspecting ink.

## What the implementation does

`fit_sem.py` builds the hierarchical model covariance explicitly and minimizes normal-theory ML with SciPy. It is not a wrapper for Mplus, lavaan, or an original program. Both L-BFGS-B and SLSQP are run from distinct starts. `verify_sem.py` independently reconstructs a directed-path RAM covariance and uses numerical-gradient optimization; it also tests covariance normalization and full observed-covariance auxiliary profiling.

For the common 35-variable model comparisons, unused indicators are profiled as unrestricted observed auxiliaries. This gives the comparable AIC part `n*F - 2*df`. It does not certify the original Mplus latent residual parameterization; assigning all auxiliary cross-covariances only to residuals produces non-positive-definite residual matrices. Core model residual matrices are positive definite. The report preserves this limitation.

The original estimator was MLR/FIML on 308 people; Table 3.2 says n=296, while the text reports 297 complete. Our ordinary-ML fit indices are therefore not exact substitutes for the original robust fit indices. Changing the multiplier to 308 is sensitivity analysis, not recovery of missing cases. No raw-scale AIC is asserted from rounded SDs.

## Files and claim traceability

- `sources/appendix_j_mplus.txt`: extracted original model syntax with source-page headings, not a standalone script or complete input dataset.
- `sources/appendix_i_power_output.txt`: original selected power output, not complete simulation input.
- `sources/model_specifications.json`: frozen Appendix J revised structure and main published fits.
- `sources/table_3_2.csv` and `table_3_2_items.csv`: all 37 variables, 666 correlations, 74 mean/SD values, original labels and canonical item names.
- `sources/claim_inventory.json`: source claims and future-research screen with verified page offsets.
- `sources/availability_ledger.md`: dated code/data searches and explicit unperformed steps.
- `sources/provenance.json`: source/skill revisions and workflow scope.
- `outputs/file_manifest.json`: hashes of deliverable content; generated at closeout.
- `outputs/verification.log`: final tests and compilation log.

Key functions are `Model.matrices`, `Model.objective`, and `Model.fit` in `scripts/fit_sem.py`; `ram_covariance` and the verification routines in `scripts/verify_sem.py`; `sb_difference`, `rounding_band`, and `read_power_table` in `scripts/published_checks.py`; and `extract`, `kmo`, and `audit` in `scripts/extract_matrix.py`. Full function line locations are in `outputs/function_index.json`.

## Skill version and departures

Used `alectionary/vibe-math` current master **055e3308bf142c9b1e7ab300298712f09acf61d1**, with replication skill blob **db47095f56283493981114209e72e20b9151ccec**, retrieved 2026-10-29. Snapshots of the skill and relevant repository guidance are included. The headline finding leads the report, source crops accompany disputed values, and assumptions and unresolved gaps are separate.

The source already contains Mplus syntax; original code was searched before describing missing materials. A verified author-controlled GitHub account was not found, so cloning every repository was not performed. OSF/GitLab/Zenodo searches were indexed discovery, not exhaustive authenticated inventories. R/lavaan and Mplus were absent in the checked environments, so the numerical implementation uses explicitly documented SciPy instead. No Lean formalization was attempted for the arithmetic/profile identity. Local file links and content hashes replace master links and remote commit IDs because publication was not authorized. These departures are limitations, not completed skill steps.

No remote files, public issues, pull requests, author messages, or participant contacts were created. The package does not claim misconduct or that the original participant data were erroneous.

## Package the private bundle

After final rendering and QA, run `python scripts/package_bundle.py`. It creates `../abbott-replication-bundle.zip`, hashes every included file, verifies CRCs and all manifest hashes, and writes `../abbott-replication-delivery.json`. Full-page report QA rasters and Python bytecode are excluded. The original dissertation PDF is not included.
