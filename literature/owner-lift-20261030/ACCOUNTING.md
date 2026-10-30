# Owner-lift source and question reconciliation

Checked 2026-10-30. This is source accounting, with no new mathematical resolution or Lean completion. C16 remains open. The current cohort is **430 canonical entries, 161 eligible targets, 213 paper records, 170 full-text screens, 141 central research sources and 6 completed Lean targets**. The explicit delta from426/160/209/168/137/6 is4/1/4/2/4/0.

| Source | Reading scope | Inventory outcome |
|---|---|---|
| [F178: Frank–Murota, box-TDI min-max formulas](https://arxiv.org/html/2007.03507v3) | Complete v3 HTML, introduction, Sections2–6, appendix and references | One specific M2 algorithm question and two broad directions |
| [F179: Lendl–Peis–Timmermans, constrained base intersections](https://pmc.ncbi.nlm.nih.gov/articles/PMC9237001/) | Complete publisher text, Sections1–6, both appendices and references | One norm-generalization direction |
| [F180: Frank–Murota, discrete/continuous relation](https://arxiv.org/html/2202.06561v2) | Remark4.4 and relevant context only | Later known-solvability evidence; complete question count remains null |
| [F181: Takazawa–Yokoi, generalized polymatroids](https://arxiv.org/html/1805.05528v3) | Paramodularity and intersection hypotheses only | Method comparison; complete question count remains null |

The [acquisition record](acquisition.json) binds all four full texts and local extractions. Full-text acquisition does not upgrade a targeted screen. Author-owned HTML/XML/text remain under ignored `local-extraction/owner-lift-20261030/`. Direct PMC retrieval returned a challenge page, retained as [a rejected attempt](retrieval-attempts.json); Europe PMC's official full-text XML endpoint supplied the accepted F179 content. The old remote-read notes remain immutable; their “no catalogue change” statement describes that earlier checkpoint.

## Questions and status boundaries

- **L-F178-m2-square-strong-polynomial:** ordinary square-sum minimization on a nonempty M2-convex set. The source fixes the objective and intersection of integral base-polyhedra; this is one eligible algorithmic target. Its present resolution, Lean evidence and difficulty remain unassessed. An implementation must state the oracle/arithmetic model.
- **L-F178-box-tdi-algorithms:** a broad program to turn min-max formulas into strongly polynomial algorithms. Repeated introduction/Section5.3 passages are merged; no extra target is created for the appendix's answered conjugate examples.
- **L-F178-inverse-optimization-algorithms:** the related but more specific inverse-optimization program in Section6/Remark6.5. Cost bounds, deviations from a box and deviation costs are examples within one direction, not separate theorem counts.
- **L-F179-polymatroid-norm-constraints:** norm-constrained two-base optimization, including the Euclidean subcase, is recorded once. The conjectured convex-optimization approach remains a formulation gate until norm representation, input oracle and exact/approximate output are fixed.

F178's weighted M-convex square-sum question is **not added as currently open**. The same authors' later F180 Remark4.4 says this discrete weighted quadratic problem is known strongly polynomial and supplies references. This is later primary evidence of known solvability, not a resolution by this project; the cited original algorithm hypotheses have not been audited here. It does not settle the distinct M2 intersection question. F179's historical recoverable-robust matroid question is answered in F179 itself and is likewise excluded from new open targets.

Bounded searches did not establish a current resolution for the added M2/norm questions. That outcome is not proof they remain open. The general and inverse algorithm programs are not individually resolved by this screen. No Lean search or difficulty estimate was manufactured. The structural peer review agreed with the classification, conditional on the source passages; it was not an additional independent full-text screen.

## Research relevance and handoff

Two intersecting base polyhedra do not automatically retain box-TDI or generalized-polymatroid properties after prescribed cross-pattern totals are added. None of these papers supplies the missing C16 mutual-pairing proof. No algorithmic runtime or integrality conclusion is transferred to the implemented research relaxation.

Further literature work should finish F180/F181 question screens separately, and inspect original algorithms cited by F180 before reuse. Follow-up bibliographies are not recursively counted as screened. The [structured accounting](accounting.json), four source-screen records, [resolution-search boundary](resolution-search.json) and [validation receipt](validation.json) preserve the exact delta and limits.

The current literature, canonical-inventory, question-screening and current-difficulty validators pass. A supplemental historical difficulty validator fails on preexisting relationship lists. Also, the existing central index repeats `OkadaKasai2026`: the headline141 is a **record count**, with140 distinct source IDs. Both issues were reproduced against HEAD, are unchanged by this delta, and are preserved in [the gap record](preexisting-gaps.json). All four new source IDs are unique. The first supplemental controller's uniqueness assertion is recorded as a failed diagnostic, not silently turned into a claim that the old index was unique.
