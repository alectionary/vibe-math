# Replication status

A replication is **complete** only when `preflight.py done` (replication-paper
skill) reports `complete`: its plan passes every check, and every figure and
table in the source is accounted for. Other authors' PDFs and documents are never
committed; what is committed is the evidence read from it: an
inventory of its figures and tables tied to its sha256, and the values read
from each. Published notes stay published; this page says which ones are not
done.

As of 2026-11-08, no dissertation replication is complete. Each is missing at
least one piece of material evidence:

| Study | Source | Source PDF, or a committed inventory of it | Plan in the current format | Status |
|---|---|---|---|---|
| [abbott-ctse](abbott-ctse/) | Abbott (2010), UNL dissertation | missing, [#94](https://github.com/alectionary/vibe-math/issues/94) | no plan | incomplete |
| [chen-rdd-mediation](https://github.com/alectionary/vibe-math/pull/90) (PR #90, not merged) | Chen (2021), UNL dissertation | verified copy in the current workspace; inventory not yet committed, [#93](https://github.com/alectionary/vibe-math/issues/93) | plan lacks `source_inventory` and `source_items` | incomplete |
| [chumney-sem-small-samples](chumney-sem-small-samples/) | Chumney (2013), UNL dissertation | missing, [#95](https://github.com/alectionary/vibe-math/issues/95) | no plan | incomplete |
| [correlated-residuals](correlated-residuals/) | Mi et al. (2010), SAGMB article; Mi (2009), UNL dissertation | missing, [#19](https://github.com/alectionary/vibe-math/issues/19), [#18](https://github.com/alectionary/vibe-math/issues/18) | no plan | incomplete |
| [denys-bosonic-pauli](denys-bosonic-pauli/) | Denys (2024), Sorbonne thesis | missing, [#100](https://github.com/alectionary/vibe-math/issues/100) | no plan | incomplete |
| [higgott-quantum-decoding](higgott-quantum-decoding/) | Higgott (2024), UCL thesis | never held locally, [#99](https://github.com/alectionary/vibe-math/issues/99) | no plan | incomplete |
| [koziol-weighted-multilevel](koziol-weighted-multilevel/) | Koziol (2015), UNL dissertation | removed from git (other authors' PDF); inventory committed (`source-inventory.json`, sha256 `b64a3c3f…`) | plan predates `source_items`, `published_evidence` and limit kinds | incomplete |
| [kupzyk-power-assumptions](kupzyk-power-assumptions/) | Kupzyk (2011), UNL dissertation | missing, [#96](https://github.com/alectionary/vibe-math/issues/96) | no plan | incomplete |
| [latent-contrasts](latent-contrasts/) | Jeffries (2024), UNL dissertation | missing, [#97](https://github.com/alectionary/vibe-math/issues/97) | no plan | incomplete |
| [moss-score-reliability](moss-score-reliability/) | Moss (2020), Oslo thesis, Paper I | missing, [#101](https://github.com/alectionary/vibe-math/issues/101) | no plan | incomplete |
| [pesah-biased-cubic](pesah-biased-cubic/) | Pesah (2021), UCL MRes dissertation | missing, [#102](https://github.com/alectionary/vibe-math/issues/102) | no plan | incomplete |
| [polytomous-person-fit](polytomous-person-fit/) | Beck (2023), UNL dissertation | missing, [#98](https://github.com/alectionary/vibe-math/issues/98) | no plan | incomplete |

## Which studies must be re-replicated

Every study above needs its records brought up to the current format: the
source inventory and the values read from each figure and table, and a plan
that passes every check. That alone needs the PDF once (its fetch issue) but
does not change results. A study **must be re-replicated** when its own records
show a gap that the current skill no longer accepts and that could change its
results: a reduced run where the full design is tractable, the source's own
engine or code replaced without a recorded decision from the person, or
plotted results compared only from prose. This is read from each study's
committed records; "to confirm" means the records do not settle it. Each study
has an assessment issue with my opinion and the arguments for and against.

| Study (assessment issue) | Re-replicate? | Why, from the study's own records |
|---|---|---|
| chen-rdd-mediation ([#88](https://github.com/alectionary/vibe-math/issues/88#issuecomment-6730497699)) | **yes**, in progress (PR #90) | Python replaced Chen's seeded R code without asking; her figures were not read. Since fixed: the exact R replay (#92) and all 27 result figures digitized. The paper still has to be revised and re-reviewed. |
| kupzyk-power-assumptions ([#103](https://github.com/alectionary/vibe-math/issues/103)) | **yes** | SAS and Optimal Design 2.0 were not run, and R was used with no recorded decision. The simulation is reduced: 20 draws per cell (a 5-draw Kenward-Roger subset), against 25,600 per cell in the source. |
| koziol-weighted-multilevel ([#104](https://github.com/alectionary/vibe-math/issues/104)) | **yes** | Koziol's Mplus analyses were rebuilt in R without a recorded decision. The plan's parts are all `partly`, and one is `input_unavailable` with no sufficient-statistics check. Its 19 result figures (raster) have not been read. |
| latent-contrasts ([#105](https://github.com/alectionary/vibe-math/issues/105)) | **yes** | Mplus and OpenMx were not installed. The dissertation names its seeds (`set.seed(1313)`, `exportData` seed 13131) and its scripts are public on OSF, so exact reproduction may be possible. The recorded Monte Carlo is 400 replicates. |
| higgott-quantum-decoding ([#106](https://github.com/alectionary/vibe-math/issues/106)) | **yes**, in part | Figure 7.14b was not numerically digitized. An earlier audit found an engine preflight failure with no fallback record. |
| pesah-biased-cubic ([#107](https://github.com/alectionary/vibe-math/issues/107)) | **yes** | PyMatching 2.3.1 stands in for the unavailable historical build (disclosed, but with no recorded decision). By its own coverage record, the whole-dissertation objective is still open. |
| chumney-sem-small-samples ([#108](https://github.com/alectionary/vibe-math/issues/108)) | to confirm | The main grid ran in full (36 conditions, 150 replications, three estimators), but the Bayesian estimator ran only as a subset. The source's GeSCA host was down, and the R `gesca` package was used. Whether the subset was your decision is not recorded. |
| polytomous-person-fit ([#109](https://github.com/alectionary/vibe-math/issues/109)) | to confirm | `mirt` was pinned to 1.36 to build on R 4.3.3. Whether the Monte Carlo matches Beck's replication counts is not stated in the README. |
| abbott-ctse ([#110](https://github.com/alectionary/vibe-math/issues/110)) | records only, probably | The fits use the printed correlation matrix (sufficient statistics, as now required). Mplus 5.2 was not available and lavaan/OpenMx were used; that departure needs your recorded decision, but the fit to a printed matrix should not change. |
| denys-bosonic-pauli ([#111](https://github.com/alectionary/vibe-math/issues/111)) | records only | The engine departure has a domain fallback record (SEM engines cannot express the SDP). The bounded scope (Figure 3.2) was digitized. Its other figures need recorded exclusions. |
| moss-score-reliability ([#112](https://github.com/alectionary/vibe-math/issues/112)) | records only | A same-data reproduction: all 20 selected Table 3 values match. The rest of the thesis needs recorded exclusions. |
| correlated-residuals ([#113](https://github.com/alectionary/vibe-math/issues/113)) | records only | An identification result checked in Lean and by simulation, not a re-run of the source's analysis. Its sources still need their fetch issues (#18, #19). |

To bring a study back to complete: fetch its source (the fetch issue), commit
the inventory and the values read from each figure and table (not the PDF),
write or update `REPLICATION-PLAN.yaml` in the one current format (including
`source_sha256`, `source_inventory`, `source_items` and `published_evidence`),
redo what the checks then require, and run `preflight.py done` until it reports
`complete`.
Update this table when a study's status changes.
