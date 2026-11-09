# Replication status

A replication is **complete** only when `preflight.py done` (replication-paper
skill) reports `complete`: its plan passes every check, and the source PDF is
present, matches the recorded sha256, and is stored where any later session can
read it, so every figure and table in it can be checked. Published notes stay
published; this page says which ones are not done.

As of 2026-11-08, no dissertation replication is complete. Each is missing at
least one piece of material evidence:

| Study | Source | Source PDF | Plan in the current format | Status |
|---|---|---|---|---|
| [abbott-ctse](abbott-ctse/) | Abbott (2010), UNL dissertation | missing, [#94](https://github.com/alectionary/vibe-math/issues/94) | no plan | incomplete |
| [chen-rdd-mediation](https://github.com/alectionary/vibe-math/pull/90) (PR #90, not merged) | Chen (2021), UNL dissertation | copy only in a temporary workspace, [#93](https://github.com/alectionary/vibe-math/issues/93) | plan lacks `source_items` | incomplete |
| [chumney-sem-small-samples](chumney-sem-small-samples/) | Chumney (2013), UNL dissertation | missing, [#95](https://github.com/alectionary/vibe-math/issues/95) | no plan | incomplete |
| [correlated-residuals](correlated-residuals/) | Mi et al. (2010), SAGMB article; Mi (2009), UNL dissertation | missing, [#19](https://github.com/alectionary/vibe-math/issues/19), [#18](https://github.com/alectionary/vibe-math/issues/18) | no plan | incomplete |
| [denys-bosonic-pauli](denys-bosonic-pauli/) | Denys (2024), Sorbonne thesis | missing, [#100](https://github.com/alectionary/vibe-math/issues/100) | no plan | incomplete |
| [higgott-quantum-decoding](higgott-quantum-decoding/) | Higgott (2024), UCL thesis | never held locally, [#99](https://github.com/alectionary/vibe-math/issues/99) | no plan | incomplete |
| [koziol-weighted-multilevel](koziol-weighted-multilevel/) | Koziol (2015), UNL dissertation | in git (`source/koziol2015.pdf`) | plan predates `source_items`, `published_evidence` and limit kinds | incomplete |
| [kupzyk-power-assumptions](kupzyk-power-assumptions/) | Kupzyk (2011), UNL dissertation | missing, [#96](https://github.com/alectionary/vibe-math/issues/96) | no plan | incomplete |
| [latent-contrasts](latent-contrasts/) | Jeffries (2024), UNL dissertation | missing, [#97](https://github.com/alectionary/vibe-math/issues/97) | no plan | incomplete |
| [moss-score-reliability](moss-score-reliability/) | Moss (2020), Oslo thesis, Paper I | missing, [#101](https://github.com/alectionary/vibe-math/issues/101) | no plan | incomplete |
| [pesah-biased-cubic](pesah-biased-cubic/) | Pesah (2021), UCL MRes dissertation | missing, [#102](https://github.com/alectionary/vibe-math/issues/102) | no plan | incomplete |
| [polytomous-person-fit](polytomous-person-fit/) | Beck (2023), UNL dissertation | missing, [#98](https://github.com/alectionary/vibe-math/issues/98) | no plan | incomplete |

To bring a study back to complete: fetch its source (the fetch issue), store it
durably, write or update `REPLICATION-PLAN.yaml` in the one current format
(including `source_sha256`, `source_items` and `published_evidence`), redo what
the checks then require, and run `preflight.py done` until it reports `complete`.
Update this table when a study's status changes.
