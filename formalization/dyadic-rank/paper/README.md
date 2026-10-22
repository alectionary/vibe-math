# Dyadic rank support formalization paper

The manuscript presents the general Lean proof, credits the source of the conjecture and the dissertation discovery context, and compares the induction with published proofs. It makes no claim to a new mathematical theorem, first proof method, or first Lean formalization. The author line is unset for review.

- Editable source: [main.tex](main.tex).
- Exported paper: [PDF](output/pdf/dyadic-rank-support.pdf).
- Complete companion Lean project and audit evidence: [artifact](artifact/).
- Snapshot hashes: [artifact-manifest.json](artifact-manifest.json).

The artifact is copied from repository revision `150bddaab87f80b1d2bf2ee44b8518af7ae2c2b0`. Its sources are byte-identical to that snapshot. The code listing is generated reversibly from the supplied `Recursive.lean` file using TeX escapes for Unicode glyphs. Run `python3 render-listings.py` to regenerate it without changing the Lean source. The proof project pins Lean `4.36.0-rc1`, mathlib, and all transitive dependencies through its toolchain and Lake files.

Compile `main.tex` in the built-in LaTeX editor or with Tectonic. To reproduce the Lean check, run `lake build` and `lake env lean Checks.lean` from `artifact/`; dependency retrieval requires network access or a populated cache. The original project was rechecked during manuscript preparation. The export and review record is in `paper-verification.json`.

The source includes 14 bibliography entries and a claim-to-citation appendix. The precise question is credited to Gómez-Fonseca, Matthews, Morris, and Pllaha, Remark 3.4; the discovery context credits Martinez, Morris, and UNL DigitalCommons. Friedlander–Pevtsova, its erratum, Benson, Kustin–Şega–Vraciu, Lean, and mathlib receive separate attribution for their respective roles. Negative search findings are bounded by the recorded source and index coverage.

The revised abstract and introduction state the approximately 21-year interval between the April 2005 published criterion and the May 3, 2026 conjecture. The explicit connection is a contribution of this exposition, with no claim of historical priority for that connection. See [arXiv readiness review](ARXIV-READINESS.txt) for submission requirements and remaining author decisions.
