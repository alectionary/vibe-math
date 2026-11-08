# Release record: no symmetric width-16 frame for C^LP_{16,9}

Record kept under the [verified-release skill](../../../.agents/skills/verified-release/SKILL.md).

**Answer.** No width-16 canonical frame of Lee's [[1088,128,16]] code C^LP_{16,9} is fixed by a
nontrivial element of the frame problem's symmetry group, which is C16 × C2. Any width-16 frame
lies in a free orbit of 32 frames; the minimum width over frames with a nontrivial symmetry is 18.
**Scope.** The source question (is the canonical width 16 or 18?) remains open: the asymmetric
case is undecided ([issue #3](https://github.com/alectionary/vibe-math/issues/3)).
**Source question.** J. Y. Lee, *Designing Group-Valued Codes with Full Regular Low-Weight
Bases*, arXiv:2610.06820v1 (5 October 2026), Proposition 9, §IV.4, Appendix C.3.
**Paper.** [symmetric-frames.pdf](paper/output/pdf/symmetric-frames.pdf); source
[symmetric-frames.tex](paper/symmetric-frames.tex).

## Provenance

| Component | Scientific revision | Identity |
|---|---|---|
| Pools (720 + 720 vectors) | earlier work, pinned at `132f1161` | SHA-256 in `lean/PoolData.lean` header and `restricted-frames-20261031/certificates/MANIFEST.json` |
| Search programs and certificates | `01022556` | every instance, certificate and pool file in [MANIFEST.json](restricted-frames-20261031/certificates/MANIFEST.json) |
| Independent C++ certificate checker (ChatGPT) | `eff9a0b6` | [chatgpt-certcheck/](independent-check/chatgpt-certcheck/) |
| Lean `no_swap_frame` (ChatGPT) | `7820f6af` | [lean/CertGPT*.lean](lean/) |
| Lean symmetry group | `e5bc8a68` | [lean/Aut.lean](lean/Aut.lean) |
| Other Lean files | `e534c654` | [lean/](lean/) |
| Merge to `master` (PR 17) | `0b789185`, tree `d9661a8e` | |

Later commits to the paper (#80, #81, #83) change prose, links, the chronology table, the Lean
appendix and the built PDF; they change no scientific input. The appendix generator checks
that every printed declaration is identical at its pinned commit.

## Imports: results used but not checked here

| Result | Source | Used for | Checked here? |
|---|---|---|---|
| Definitions of canonical width; f ∈ {16, 18} for this code; f_reg = 18 | Lee, arXiv:2610.06820v1, Prop. 9 | the question and the T⁸ case's context | no |
| The weight-16 pools contain every logical class of weight ≤ 17 | repository enumeration ([INDEPENDENT-ENUMERATION.md](INDEPENDENT-ENUMERATION.md)) | reduction to the 720 × 720 problem | by computation; not formalized |
| μ_XZ = 26 (no mixed operator of weight ≤ 17 lacks a stabilizer component) | same enumeration | the mixed-operator reduction (`Mixed.lean` takes it as a hypothesis) | by computation; not formalized |
| Colour refinement and individualisation | McKay–Piperno (method only) | computing the symmetry group | the computation is rechecked in Lean |

## Verification

| Layer | What was checked | How | Result |
|---|---|---|---|
| Source identity | pools, instances, certificates | SHA-256 manifest; the checker verifies all 21 hashes before use | match |
| Finite execution | exhaustive linear-algebra search, 3 involution classes | `la_gen` with certificate output | no frame; 69,180 / 9,996,689 / 50,404,337 nodes |
| Independent check | all three certificates | spec-only C++ checker by ChatGPT ([#76](https://github.com/alectionary/vibe-math/issues/76)), rerun here with identical counts; regenerates items from raw pools; known-answer and 10 mutation tests | ACCEPT |
| Kernel-checked proof | symmetry group; swap class; search lemmas | Lean 4 `v4.36.0-rc1`, Mathlib `5f7b4198`; `lake build` 3,833 jobs, exit 0 | see axiom report |
| Supplementary | T⁸ by SAT cube-and-conquer | Kissat on a Mac | 243 pieces UNSAT, 20 open, none SAT, at the time of writing |

**Axiom report** ([axiom-report.tsv](release/axiom-report.tsv), produced by
[axiom-report.lean](release/axiom-report.lean), exit 0): 53 cited declarations. 23 use only
`propext`, `Classical.choice` and `Quot.sound`. 30 also use compiled evaluation
(`native_decide`): the concrete-data facts of `Pools.lean`, `Code.lean` and `Aut.lean`,
`aut_classification`, and `no_swap_frame`. This matches the † rows of the paper's Lean table. No
declaration uses `sorry` or a project axiom. Kernel-only replacements are tracked in
[#84](https://github.com/alectionary/vibe-math/issues/84).

**Not done.**
- The half-turn and swap-with-half-turn certificates are not checked in Lean.
- There is no bound review record of the composed paper by a nonauthor; the independent checks
  above are component checks.
- There is no one-command replay packet yet ([#86](https://github.com/alectionary/vibe-math/issues/86)).
- The Mac SAT run is incomplete.

## Attribution

- Search, certificates, specifications, coordination and the paper: Claude (Anthropic).
- Independent C++ certificate checker and Lean `no_swap_frame`: ChatGPT (OpenAI; exact version
  not exposed by its runtime).
- Earlier independent spec checker: Codex (OpenAI).
- First Lean certificate checker and corrections to the proof plan: Grok 4.7 (xAI),
  [#77](https://github.com/alectionary/vibe-math/issues/77).

Code under `formalization/` is Apache-2.0 subject to [LICENSING.md](../../../LICENSING.md); the
paper and data are outside that grant.
