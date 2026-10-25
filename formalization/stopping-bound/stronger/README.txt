Useful spectral replacements and incidence stopping bounds for QC-GHP codes
24October2026 Pacific. Expanded follow-up to L-F16-stopping-bound.

The original Proposition5.1 useful-parameter question remains answered NEGATIVELY by the earlier universal source-question proof.

Useful stronger-replacement existence is answered POSITIVELY. ShortFamily supplies explicit supports0,1,3,11 and0,5,12,18 for every odd n>=37: column/row4/8, moment88n, bound5 and nontrivial logical content. Practical27/Core/Design/Spectral prove the54-variable instance, both sectors, moment2376 and a strict Zhu-Chugg formula comparison. SeparateSidon proves the weaker separate/mixed support criterion. MomentBound proves a fourth-Gram-moment criterion implying stopping distance>=gamma+1. JointMomentFamily supplies actual binary QC-GHP/CSS matrices with explicit joint-Sidon supports, exact spectral equality and fixed degrees on arbitrarily long lifts. JointPowers and JointKernel prove nontrivial logical content and both sector kernel bounds. The mathematical ingredients were already available in source Lemma4.8 and classical overlap results; no new-classical-principle or optimal-universal claim is made.

The incidence-conditioned existence question is positive too: the reusable partition criterion, paired powers families and an exact stopping/logical-distance-six family extend beyond B1. GramGap proves an unbounded obstruction to uniformly informative real Gram-only bounds on paired/repeated twins. Both separate real check Grams agree (BothGram), but encoded quantum dimension, binary rank and cross-sector incidence are not assumed shared. BadLogical proves nontrivial bad logical words and both sector minimum two.

BicycleSpectralFamily proves eta>=290/13 on every39-cover and strict negativity of both Zhu-Chugg formulas under their strict gap. JointSpectralBase gives eta>=121/20 on the new n81 joint-support instance and the analogous negative-formula comparison. No numerical spectral estimate or external search is a proof premise.

Reproduce with Lean4.36.0-rc1 and pinned mathlib5f7b4198d22a9c82e1c698a379334fe128095c82:
  lake build StrongerAnswer
  lake env lean AuditStronger.lean
All named declarations, including four unchanged inherited modules, have signatures and axiom reports. Only propext,Classical.choice and Quot.sound occur.

Read stronger-stopping-paper.pdf, PROOF-LINKS.md (every full current and immutable Lean URL), SOURCE-CHRONOLOGY.md (all source dates/deltas), and verification.json. The source archive includes standalone checked sources and shared inventory/planning snapshots. External copyrighted papers stay in ignored local extraction. The X draft is NOT POSTED.

Shared totals:295 canonical entries,144 eligible targets,119 papers,106 full main-paper screens,5 complete canonical proofs. Separate historical indexing deltas20/8/4,3/1/1 and5/0/4; no new canonical completion is counted for project-derived follow-ups. Newly harvested current-resolution/Lean/difficulty assessments remain unassessed.

Presentation revision (24 October 2026 Pacific): main.tex and supplement.tex
replace the custom ReportLab layout with the established article format used
by the earlier dyadic-rank and cyclic-lifts papers. The introduction explains
the original negative answer before motivating the positive replacement.
The central chronology is Table 2 near the introduction; the complete ledger
remains in Appendix C. All checked Lean source files and immutable pins are
unchanged. PRESENTATION-REVISION.json records the editorial scope and checks.

Compile the editable manuscript with Tectonic:
  python3 make_paper.py --tectonic /path/to/tectonic
or set TECTONIC and run python3 make_paper.py. PAPER_OUTPUT_DIR is supported;
--only-cached disables resource downloads. main.tex also opens in a LaTeX
editor. The source archive contains both TeX files and the updated workflow
skill snapshot. The X draft remains unchanged and unposted.
