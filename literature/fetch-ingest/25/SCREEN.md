# Screen for fetch issue 25

- Fetch issue: https://github.com/alectionary/vibe-math/issues/25
- Manifest id: `vibe-math-25-worker-20261102`
- SHA-256: `255187936be0c14fa254ca59e50e121bea9dc3c943e77eff13ca8b665a608a3c`
- Pages: 22
- Record: F182
- Question count in this screen: 1

This note copies the 2026-11-02 screen in [fetched-papers-2026-11-02.md](../../fetched-papers-2026-11-02.md). It does not add a finding. The manifest `question_screen.status` stays `not_screened`.

## What the paper establishes

Tri Le and Bertrand S. Clarke, *In praise of partially interpretable predictors*. The stored file is the UNL DigitalCommons faculty copy of the 2020 journal article, including the repository cover. Stable link: https://doi.org/10.1002/sam.11450.

The paper compares linear models, Priestley–Chao and Nadaraya–Watson smoothers, and stacking combinations on mean squared error. Theorems 3.1–3.3 give asymptotic MSE and IMSE comparisons for the linear and partially linear predictors. Section 4 computes examples, including a 100-point subset of the Nebraska wheat measurements in Campbell et al. (F150). Section 5 argues that a blended interpretable and uninterpretable predictor often has smaller MSE than either extreme, under caveats on complexity, model error, and sample size.

## Open questions

[L-F182-stacking-mse-asymptotics](../../OPEN-PROBLEMS.md#l-f182-stacking-mse-asymptotics). In Section 3.2 the authors conjecture that Clause 1 of Theorem 3.3 can be combined with Clause 2 or Clause 3 to give asymptotic pointwise MSE forms for the (PC, LM) and (NW, LM) predictors. They do not write those forms, and they say the combination looks too complicated for a clean comparison. Extracted lines 890–908. This is a method direction until the expression and the hypotheses of those clauses are fixed. Present resolution and Lean discovery were not assessed.

The same paragraph says the nonlinearity of stacking seems to block existing results for (STK, PC), (STK, PC)−LM, and STK−(PC, LM). That is a limitation of the argument they use, not a second target. Section 5’s tradeoff between interpretability and MSE is the paper’s methodological stance, not a numbered conjecture.
