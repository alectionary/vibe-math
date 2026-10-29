# OpenAI Dot: Abbott (2010) replication archive

This is the **OpenAI Dot** analysis, preserved for comparison with [PR #47](https://github.com/alectionary/vibe-math/pull/47), which the user identifies as the **Grokbot** analysis. The comparison is **OpenAI Dot's opinion**, not an independent benchmark or a consensus judgment. In Dot's opinion, Grokbot's report is superior in focus, readability, and alignment with the SEM workflow; that does not mean every technical conclusion is stronger.

This branch is an archival exhibit, deliberately submitted as a draft PR and then closed without merging. No replication-skill changes are proposed here. The user intends to obtain Grokbot's own assessment before later improving the skill for both environments.

## Start here

- [Original result paper, PDF](report/abbott_replication.pdf)
- [Original editable paper, Markdown](report/replication_note.md)
- [Dot's later comparison and clarification](COMPARISON.md)
- [Original delivery README](README.original.md)
- [Detailed arithmetic analysis](report/published_checks.md), [SEM verification](report/sem_verification.md), [matrix audit](report/matrix_audit.md), and [source review](report/source_review.md)

The original report PDF, Markdown, supporting analyses, scripts and numerical outputs are unchanged from the delivered bundle. Statements there such as "private", "no remote changes" and "publication not authorized" describe the original run, before the user's subsequent publication request. They are not assertions about this archive. The PDF SHA-256 is `bdf6d8d110046b4464feee6433bf5f940585f17e91202b492273182c7989300c` (681,357 bytes, 11 pages).

**Later clarification:** `.8602` matches `.86` at the reported two-decimal precision. "Partial" describes reconstruction fidelity (rounded published matrix rather than original participant-level MLR/FIML data), not a failure of that numerical match. Read the original verdicts with this distinction; the original is retained rather than silently revised.

## Reproduction and archive boundaries

From this directory, with Python 3.12 and dependencies in `requirements.txt`:

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

The committed matrix CSV, model specifications, and selected numerical table text permit these computations offline. Only four source-text pages are retained: PDF pages 108–109 (Table 3.2) and 265–266 (power output). They are selected numerical evidence, not the complete dissertation text. Four narrow evidence crops support the report. Regenerating every source crop requires locally reacquiring the dissertation from the [official UNL record](https://digitalcommons.unl.edu/cehsdiss/68/), verifying the hash in `sources/provenance.json`, and following the original README. Create `sources/pages/` before extraction if using a fresh directory.

Skill instructions are identified by immutable repository commit, path and blob in `sources/provenance.json`; copied repository-wide guidance snapshots are omitted because they contain unrelated research material. The original README's reference to included skill snapshots describes the private bundle, not this narrowed archive.

Excluded from this public exhibit: the dissertation PDF, full extracted dissertation text, full-page renders, most crops, extracted full Appendix J syntax and Appendix I compilation, Python bytecode, and the original ZIP/its whole-bundle manifest. Some original supporting documents refer to those omitted reading aids; reacquire them from the official source rather than treating absent files as newly obtained evidence. The original model specifications and scripts remain intact. The original packaging script describes the private bundle, not the narrower public archive.

`ARCHIVE_MANIFEST.json` hashes this selected archive (excluding itself). `archive_validation.txt` records tests performed on the selected archive. Original logs remain historical run evidence. Neither archive validates raw-data MLR/FIML or qualitative replication; participant records and interview transcripts were unavailable.
