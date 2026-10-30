# Numerical stopping assessment while proof coordination is pending

Local assessment after PR64 milestone edb0cb62e0f09d8287a07f017613a06461070644. No ownership retry or proof development. The published paper is unchanged by this assessment; the following new diagnostic has not yet been incorporated into a reviewed PDF.

## New justified test, now complete

The earlier logistic-model failure did not test the source's quadratic family. We therefore froze `quadratic-adequacy-plan.json` before bootstrap draws: same two fresh grids, same five-start unweighted quadratic estimator, no source targets or new physical-error trials. Parametric binomial count draws from each fitted model are refitted with the identical estimator; binomial deviance is calibrated by2000draws per family. This is a post-inspection exploratory plug-in model diagnostic, not exact finite-sample testing or threshold coverage. Failed/nonphysical/boundary/nonmonotone draws would remain unresolved and bound the tail probability, not be discarded.

Twenty-draw pilots cost0.258/0.258seconds; projected total51.6seconds. Production took25.513/28.100seconds, peak RSS81308KiB, one worker, 2GiB/2400CPU caps. Pilot draws excluded; distinct fixed seeds recorded. All4000production fits passed validity checks.

| Fixed family | Observed quadratic deviance | Exceedances/2000 | Add-one tail estimate | MonteCarlo95% upper bound |
|---|---:|---:|---:|---:|
| Cubic Z eta5 U |138.189758|0|0.00049975|0.00184274|
| Rhombic X eta100 U |41.372056|0|0.00049975|0.00184274|

Both reject at the two-model Bonferroni threshold0.025 and the separately stated0.005 sensitivity. The upper bounds describe simulation uncertainty in the plug-in tail probability; they do not remove fitting-model or source uncertainty. The quadratic and logistic failures agree only about inadequacy on these fixed grids, not the true threshold.

**Stop these two local model-fitting campaigns.** A physical, monotone fitted curve is insufficient. Retain all raw counts and all primary/wider/fresh estimates. Do not repeat more shots on the same grid, select windows to match the source, or report fitted thresholds as established.

## Remaining numerical obligations and explicit stopping statements

- **All74 registered numerical items were attempted**:18endpoint arm cells,48finite-bias arm cells and8pure-channel sector/arm families. Their finite computations are preserved, not a claim that all scientific results succeeded. `numerical-stopping-inventory.json` retains every item and its evidence. The82 expanded source-comparison quantities comprise73flagged/qualified quantities and9conditional quantities with fewer diagnostics; even the latter exclude source/model uncertainty. Preserved pure-X inference remains separate.
- **Unstable endpoint/bias thresholds:** retain conditional point outputs and optimizer/physicality/size diagnostics. Current grids do not establish an asymptotic threshold. Source-family bootstrap adequacy is now tested only for the two named fresh local families; no extrapolation of that rejection to all others. Additional numerical work must specify an identifiable model and validate it before reporting thresholds; blanket increases in trials are not justified.
- **Deformed cubic pure-Z and eta100 total thresholds:** sector plateaus and size drifts defeat a single reliable current fit. Stop forcing a global threshold. Exact next scientific input is a justified sector-resolved/finite-size scaling model or source production fitting protocol. Any new larger-size study must freeze its model, rates, target precision and failure criteria first. L12/14 may be candidate sizes, not approved windows or promised resources; largest-size memory and decoder-cost pilots are required before deciding sizes/counts. Present data do not give a defensible total compute estimate for that new model-dependent experiment.
- **Cross-code ranking:** all six signed contrasts have been computed, but the eta100 reversal is driven by an unstable cubic fit. Stop interpreting it as a new ranking. It needs valid threshold estimates for both members with propagated uncertainty and the original source uncertainty. Rerunning the six contrasts cannot supply those inputs.
- **Pure-channel curve agreement:** all6804 source-coordinate intervals were checked using the full declared family. Wide simultaneous bands at100shots/condition establish only limited compatibility. Stop claiming equivalence. A genuine equivalence test needs a scientifically justified tolerance and original count/error information, then a prospectively powered experiment; neither is recovered by arbitrarily shrinking extracted source intervals.
- **Eta3/eta5 ambiguity:** both alternatives were simulated. Stop trying to choose the “correct” source point by agreement. Need the original job manifest/plot data identifying the plotted bias, not more simulations.
- **Sweep–Match:** all endpoint arms and residual failures were retained. Modern-matching comparisons are limited reconstructions. Exact historical equivalence needs the historical runtime/dependency through an explicitly permitted source; prior LEMON access remains denied and must not be retried or routed around. More modern-engine trials do not resolve this blocker.
- **OSD tenfold speed claim:** reconstructed implementations already support an optimization mechanism but not the exact published factor. Need original baseline code, benchmark matrices/workload and hardware/timing protocol. Stop collecting more timings on our different workload to chase tenfold.
- **GUI:**28backend checks completed, frontend rendering blocked by denied original Three.js access. No retry/alternative host. “Useful visualization” lacks an evaluation protocol; cannot manufacture a quantitative replication target.
- **Original production equivalence:** all quantitative source comparisons still lack original counts/outcomes, seeds, BP settings/tie handling, package/production revision and fitting windows/protocol. These are unavailable inputs, not evidence that arbitrary additional computation will reproduce the source. No author contact is authorized.

## Exact next work

While public-claim permission is pending, no proof work dependent on that prerequisite will begin. No further physical MonteCarlo run is currently justified merely to cure the observed fit failures. Allowed preparation can specify and critique candidate correction-to-scaling/sector models or a prospectively powered equivalence design, without asserting that one has been selected or validated. Full lattice/homology/probability/algorithm proof obligations remain open and coordination-gated. Publication of this new diagnostic would require updating the actual main paper, a fresh rendered/scientific review and remote-byte verification; it has not been silently attached to the earlier PDF's review.
