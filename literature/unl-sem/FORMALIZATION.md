# Selecting mathematical targets from the SEM seed

The ten inventoried entries are author-stated statistical methods directions. They are potentially useful sources of formalization work, but none yet fixes all of the model, quantifiers and success guarantee needed for the precise-target denominator. No purely social theory or empirical association was added as a mathematical conjecture. Eight entries came from the first pass; two were added by the CFA/measurement-model continuation.

## Inclusion rule

Retain a source-stated question if its mathematical core can concern distributions, matrices, parameter maps, estimators, algorithms, likelihoods, or statistical error guarantees. Record the exact source location and the assumptions still to be fixed. A simulation comparison is evidence about its evaluated conditions; it does not state universal dominance or convergence. A fitted causal diagram does not by itself establish causal identification.

Exclude questions that require new observations to answer: whether an intervention changes attitudes, whether leadership predicts satisfaction in another population, whether an instrument validates in a new setting, or which predators are active at night. Their sources remain in the bibliography and their exclusion reasons remain in the screen.

## Source directions and the statement work they need

| Source agenda | Mathematical content to specify before formalization |
| --- | --- |
| Pleiotropy versus closely linked QTL | Competing genotype/trait models, priors, marginal likelihoods, and separation/identifiability conditions |
| Missing phenotypes | Missingness mechanism, imputation law, estimator and the particular consistency/error criterion |
| Mixed binary/continuous traits | Joint model and link functions, identification constraints and inferential guarantee |
| Environment/block interactions | Random effects, covariance restrictions and interaction parameterization; compare the later Mi et al. 2011 model |
| Correlated residuals | Positive-definite covariance class and structural restrictions; do not assume identification survives arbitrary residual dependence |
| Nonlinear trait relationships | A bounded nonlinear family, noise law and an exact existence/identification/estimation claim |
| Dynamic-fit robustness | SEM family, discrepancy thresholds, Monte Carlo calibration, Type-I/II error or coverage criterion |
| Dynamic-fit multigroup/multilevel extension | Group/cluster model, calibration method and a stated level/power guarantee |
| Angoff item-subset selection | Item-by-judge probabilities, sample design and allocation, score estimator and an error/coverage criterion relative to the full test |
| Detecting interpretation variability | Ordinal-response factor/mixture model, identification constraints and detection accuracy; exclude demographic or population effects requiring new observations |

The expanded registry labels ten adjacent IRT/latent-class/exploratory-factor or scale-structure dissertations separately from its SEM/CFA core. These include factor-structure scale-development records without an asserted CFA analysis, and one explicitly planned-but-unexecuted CFA with exploratory scale analyses. The Angoff source is a 2003 conference paper recovered through the author of a 2005 IRT dissertation; it is earlier background. The interpretation source is a 2013 article explicitly citing Marincic's dissertation; no Griffin/Marincic surname equivalence is assumed.

For the Angoff direction, a useful project-derived first task is to express the full-test score as a functional of a fixed finite item-by-judge matrix and bound the deviation of a correctly weighted random subset estimator. This is a proposed formulation, not the source's exact conjecture. Its empirical 50% result does not supply a universal sampling guarantee, and a claim that additional strata always improve precision needs allocation and variance assumptions.

## Project-derived formalization tasks, separate from author-posed questions

These are possible implementation starting points, not additional author conjectures, newly discovered open problems, or claims of mathematical novelty. They are excluded from the canonical question count.

1. **Finite acyclic SEM algebra.** Specify a strictly triangular real coefficient matrix B and a noise vector. Formalize the finite inverse/path-sum identity for I−B, then the mean/covariance transformation. This would supply reusable definitions for QTL and mixed-outcome extensions; it would not settle their inferential questions.
2. **Two explicit competing QTL models.** After a current-method comparison, freeze one finite pleiotropic model and one linked-locus model. Determine what observables and marker assumptions distinguish their induced distributions. A faithful identifiability statement is the first research milestone; a numerical Bayes factor alone is insufficient.
3. **Monte Carlo calibration certificates.** Specify independent simulation draws and a bounded rejection indicator. Formalize an existing concentration bound for its estimated rejection rate and connect it to a fixed calibration routine. This certifies sampling accuracy for a specified model; it does not prove uniform model-fit validity.

The first and third tasks can reuse known mathematical results. Existing theorem coverage and implementation effort have not been audited here, so no unsupported claim of missing Lean infrastructure or estimated discovery time is made.

## Downstream correction that affects target selection

Peugh and Feldon (2020) suggested equivalence testing for SEM fit and called for broader testing. Their own 2024 letter reports unfavorable subsequent simulations and withdraws the recommendation. Keep the 2020 request as historical context. The 2024 letter's separate dynamic-fit questions are the new inventory entries; neither the earlier recommendation nor a universal failure theorem is inferred from those simulations.
