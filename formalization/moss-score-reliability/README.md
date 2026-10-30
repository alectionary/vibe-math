# Score weighting and reliability: Moss (2020)

All 20 selected Table3 values match their printed three-decimal precision, and all ten headline score-weighting gains retain their direction. This is a bounded same-data reproduction of Paper I, Example11 in Jonas Moss's *Psychometrics and the modelling of publication bias* (University of Oslo,2020), using the complete author-repository version. It is not a replication of the whole thesis, universal advice about alpha, or a claim of population superiority or model validity. Equivalence to the final deposited edition is unverified.

Main paper: [score_weighting_and_reliability__a_replication_of_moss_2020.pdf](paper/score_weighting_and_reliability__a_replication_of_moss_2020.pdf). Editable [TeX](paper/score_weighting_and_reliability__a_replication_of_moss_2020.tex) and [references.tex](paper/references.tex). Manuscript master links are navigation aids and will not resolve for these new files until merge; the draft PR provides immutable current-commit links.

## Recompute

Prerequisites: R4.5.0, lavaan0.6-19, OpenMx2.21.13, Python3.12.14. Debian trixie packages r-base-core4.5.0-3, r-cran-lavaan0.6.19-1 and r-cran-openmx2.21.13+dfsg-1 supplied this run. The selected environment used workspace-local extraction of their .deb dependencies and a launcher for the unmodified R executable; installation did not require privileged writes. [preflight.json](provenance/preflight.json) records the successful engine check before fitting. [sessionInfo.txt](outputs/sessionInfo.txt) records numerical dependencies.

Check out the immutable computational revision printed in the paper's artifacts appendix (the historical master baseline is not runnable for this study). From the repository root:

```sh
python3 .agents/skills/replication-paper/scripts/preflight.py
OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 Rscript formalization/moss-score-reliability/scripts/replicate.R
python3 formalization/moss-score-reliability/scripts/compare.py
```

The complete input data are bundled in inputs/bfi.rda with original documentation and GPL notice. No full thesis or original source code is required. All five fits run serially in seconds. There are no seeds or checkpoints: computations are deterministic optimizations; commands overwrite their named outputs. Expected: 20/20 rounding matches, zero20-contrast sign reversals, maximum OpenMx reliability difference below1e-5 (observed3.06e-7). Runtime fields and PDF metadata are not mathematical results. compare.py validates all new fits and the preserved original-replay.csv; it does not freshly rerun upstream code. RcppParallel emitted TBB-location warnings in this local setup; serial OpenMx returned status0 for all models, with independent agreement.

## Optional fresh upstream replay

The external package has inconsistent license declarations (CC BY-SA4.0 in DESCRIPTION versus CC BY4.0 in LICENSE.md), so no original code is redistributed. The retained original-replay.csv was produced from this exact checkout. To regenerate it, from the repository root:

```sh
git clone https://github.com/JonasMoss/standardized.git /tmp/moss-standardized
git -C /tmp/moss-standardized checkout e14ad236da3ead61f6ea04d0244e9e458bd7b0cf
Rscript formalization/moss-score-reliability/scripts/replay_original.R /tmp/moss-standardized
python3 formalization/moss-score-reliability/scripts/compare.py
```

The replay wrapper executes the external source's four original formulas using the original marker-variable model and lavaan defaults. Original plotting/table formatting dependencies are not needed; no attempt is made to call this an entire original-environment replay.

## Rebuild the paper from saved results

Additional prerequisites: pdfTeX1.40.26/TeX Live2025 with geometry,booktabs,longtable,array,graphicx,amsmath,xcolor,hyperref,xurl,natbib. No R fitting or source download needed. From repository root:

```sh
sh formalization/moss-score-reliability/scripts/build_paper.sh
python3 .agents/skills/replication-paper/scripts/check_citations.py formalization/moss-score-reliability/paper/score_weighting_and_reliability__a_replication_of_moss_2020.tex --references formalization/moss-score-reliability/paper/references.tex --log formalization/moss-score-reliability/outputs/paper-build.log
```

build_tables.py regenerates headline.tex,comparison.tex,availability.tex and compliance.tex from the saved JSON records. The build runs LaTeX twice and creates the descriptively named main PDF. Build inputs are the main TeX, preamble.tex, references.tex, revision.tex and those four generated tables. Historical baseline and approved-template revision:69a290d2fadef4df1337d6ae93c31e0f784475a4. The final delivery record binds the rendered reviewer to all eight inputs, not just the main source.

## Re-extract source evidence

This needs an external full author-thesis repository, Poppler26.05.0 and Pillow (version recorded below). Full source obtained at c539b0bc4ab1424352ab93f5aaae5150f02fa9e3 includes thesis TeX and all six article PDFs. It is not a certified final deposited PDF. Reviewer read the complete source collection; source-review.json distinguishes reading from independent proof certification. From repository root:

```sh
git clone https://github.com/JonasMoss/phd-thesis.git /tmp/moss-thesis
git -C /tmp/moss-thesis checkout c539b0bc4ab1424352ab93f5aaae5150f02fa9e3
python3 formalization/moss-score-reliability/scripts/crop_source.py /tmp/moss-thesis/papers/paperI.pdf
```

The extractor rejects a different PDF hash, renders page18 (printed19) with pdftoppm at600dpi, then crops the table. Inputs/published.csv is a visually checked manual transcription, not output of a hidden text extractor. Whole source is not redistributed. Do not substitute an inaccessible or different edition silently.

## Evidence, limitations and rights

[comparison.json](outputs/comparison.json) separates numerical agreement from scope; [contrasts.json](outputs/contrasts.json) separates scientific gains from reproduction deviations. These are descriptive same-data comparisons. There is no Monte Carlo uncertainty, population CI, or multiplicity-adjusted inferential claim. Rounding bounds of±.001 on differences of printed cells do not describe sampling error. Model-fit diagnostics caution against generalization, especially N RMSEA.163.

The two numerical routes share data and model; OpenMx supplies a different optimizer and separately expanded score formulas. [numerical-review.json](provenance/numerical-review.json) provides independent arithmetic review. [availability.json](provenance/availability.json), [compliance.json](provenance/compliance.json), [rights.json](provenance/rights.json) and [source-review.json](provenance/source-review.json) document access, scope and rights. Root LICENSING.md and THIRD_PARTY.md remain controlling; all R, inputs, evidence and paper material remain outside the new root Apache grant. No upstream code or whole thesis is redistributed.

Scheduled slot1, latent factors,2026-10-30T09:13:16Z; task moss-score-reliability. [scope.json](provenance/scope.json) and the repository scheduled-run register record the deduplication identity and final PR. No merge or external announcement is included.

Pillow version used: 12.3.0.

## Verify published delivery

After publishing an artifact commit, the following fetches15 immutable remote files, checks each against local bytes, and writes the delivery receipt. Substitute the actual full artifact SHA and a distinct download directory. The independent rendered-manuscript review must already exist and match the current paper/build inputs.

```sh
python3 formalization/moss-score-reliability/scripts/verify_remote.py ARTIFACT_SHA --download-dir /tmp/moss-remote-verification
python3 .agents/skills/replication-paper/scripts/delivery_check.py formalization/moss-score-reliability/provenance/delivery-record.json --root formalization/moss-score-reliability
```

Downloaded copies are external receipt evidence, not bundled inputs. Re-running the verification reconstructs them. The checker validates hashes and review records, not scientific truth or actual review depth.
