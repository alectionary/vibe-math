# Re-run Kupzyk (2011)

From the repository root, use R 4.5.3 with Rcpp, lme4, nlme, lmerTest and
pbkrtest, and Python 3 with NumPy, SciPy, PyYAML and PyMuPDF. Select a new run
directory and set a worker count appropriate for the host.

```sh
study=formalization/kupzyk-power-assumptions
sh "$study/rerun/reproduce.sh" /tmp/kupzyk-reproduction 4
```

The runner uses one BLAS thread per process. It schedules 128 batches of 200
draws for each of 54 settings, a separate 50,000-draw baseline follow-up, and
both Appendix D null cells. The checksums and full comparisons are under
`results/full/`. Interim results are retained under `results/interim/`
and are superseded by the full comparisons. Only reuse a checkpoint directory
with the same generator, fitting implementation, seeds, and inputs.

The approved R fallback and lost SAS-specific checks are documented in
`notes/rerun-engine.json`. Historical analysis inputs are kept in `outputs/`.
The published design grids and source transcriptions are in `source-values/`.

For the source audit, obtain the archived PDF recorded in
`provenance/source-acquisition.json` and verify its SHA-256. Use Poppler to
recreate the layout text, then run `read_source_tables.py`, `digitize_power.py`,
`figure4_and_design.py`, and `check_source.py`. Three exemplary plot markers
were occluded and have no extracted values.
