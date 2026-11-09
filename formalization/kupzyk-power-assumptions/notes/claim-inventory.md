# Dissertation claim inventory

Page numbers here are printed page numbers. Add ten to locate the physical page
in the verified university PDF for Arabic-numbered pages.

| Source section | Substantive content to account for | Plan entries and evidence |
| --- | --- | --- |
| Ch. I, pp. 1–6 | Motivation and proposed comparison of three methods for longitudinal cluster trials; no separate original dataset or experiment. | ch1; formula-od; initial-empirical; initial-exemplary |
| Ch. II, pp. 7–58 | Background on testing, attrition, trial design, and power approaches; worked G*Power and Optimal Design software examples and noncentrality formulas. | ch2; Figures 1–3; source-identities.json |
| Ch. II, pp. 59–64 | Empirical power is a Bernoulli mean; small Monte Carlo runs can shift the apparent sample-size crossing; 500-draw seed illustration; 1,000-draw binomial quantiles and recommended counts for full widths .01 and .005. | precision; Figure 4; figure4-independent-summary.json; source-identities.json |
| Ch. II, pp. 64–67 | Four research questions; all three violations expected to reduce power, with attrition expected to have the largest impact. | rq1–rq4; hypothesis-order |
| Ch. III, pp. 68–83 | Three-level Gaussian model and crossed grid. Two types of unequal cluster sizes, cumulative attrition based on original N, cluster-level allocation; planned cluster counts and df choices. Figure 5 gives planned oversampling, while results report a later six-cell analysis with different cluster baselines. | ch3; Figure 5; appendix-a; appendix-b |
| Ch. IV, pp. 84–89 | 54 empirical cells at 25,600 draws, four cells each losing one fit; boundary estimates and recovery of generating parameters; initial exemplary and empirical power; df explanation for formulaic discrepancy. | initial-empirical; initial-exemplary; formula-od; formula-bw; appendix-c; Figures 6–8 |
| Ch. IV, pp. 89–90 | Initial power losses attributed to dropout, imbalance and sizes; treatment imbalance interacts with other design factors; empirical power slightly below exemplary in many cells; 50,000-draw baseline check; final exemplary grid lowers cluster counts to near .80 at baseline. | empirical-gap; baseline-50000; final-exemplary; Figures 6–11 |
| Ch. IV, pp. 92–95 | Final grid, pooled attrition losses, oversampling by lost participants, and discussion of oversampling by lost observations. | rq1; oversample; Tables 1–3 |
| Ch. IV, pp. 95–96 | Treatment imbalance loss, small size imbalance loss, and greatest losses at the lowest ICC. Also claims losses decrease with ICC, even though the printed skew-size loss rises from .6 to .7 pp at the final ICC step. | rq2–rq4; Tables 1 and 4 |
| Ch. IV, pp. 97–98 | Minimum cluster counts for adequate power; maximum eight extra clusters relative to the df-matched reference. | thresholds; Table 5 |
| Ch. V, pp. 99–112 | Practical interpretation; differences among denominator rules, Type I error under two settings, empirical and exemplary gap and sampling variation hypothesis; caveats about rounded counts and transfer to more complex dropout or design assumptions. | ch5; empirical-gap; null-baseline; null-extreme; practical-verdict |
| Appendix A, pp. 124–126 | SAS simulation and fitting syntax, zero-seed generators, allocation, missingness, variance components, and between–within test. | appendix-a; source seed check; independent R fitting |
| Appendix B, pp. 127–129 | SAS exemplary syntax, exact printed normal/skewed arrays, independent covariance, one dropout mask per realized design, test of the interaction, power via noncentral F. | appendix-b; independent fixed-covariance calculations |
| Appendix C, pp. 130–132 | Six crossed tables with 324 fitted means and population values, including mean estimated slope ICC and interaction. | appendix-c; Tables C.1–C.6 |
| Appendix D, p. 133 | Five df methods and two design cells; compare Type I error, power, and intervals against both nominal and practical criteria. | null-baseline; null-extreme; Tables D.1–D.2 |
| References, pp. 113–123 | Bibliographic attribution; no new original claim. | Citation evidence for methods used. |

Source and reconstructed parameters are kept separate. The main empirical
counts include all original crossed conditions and the distinct baseline
follow-up. The source's exact initial exemplary random masks, exact original
random streams, and per-draw SAS output are not available. The figure audit
keeps missing markers missing; it does not use adjacent marker coordinates
or fill those entries with prose estimates.
