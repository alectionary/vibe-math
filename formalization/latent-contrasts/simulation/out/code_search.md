# Code search for the Jeffries dissertation scripts

Recorded 2026-10-28. The dissertation is Jay B. Jeffries, *Navigating Non-Orthogonality* (University of Nebraska–Lincoln, 2024). The public analysis record is OSF node `q9yu8`.

## OSF node q9yu8

API `https://api.osf.io/v2/nodes/q9yu8/` on 2026-10-28. Created 2025-04-18, modified 2025-09-20. Description empty. One contributor, Jay Jeffries. No children, no wiki, no linked nodes in the first page of relationships. Files, all uploaded 2025-09-20:

- `data/n = 240.zip`, `n = 480.zip`, `n = 960.zip` (generation scripts, not `.dat` replicates)
- `analysis/mimic model/mimic_model.R`, `mimic_results.R`
- `analysis/mgcfa model/mgcfa_model.R`, `mgcfa_results.R`
- `results/` summary CSVs

No `sessionInfo`, no log, no `.Rhistory`. The scripts call `set.seed(1313)` and pass seed `13131` to `exportData`. They do not set `RNGkind`.

## GitHub

Authenticated code and repository search, plus a shallow clone of every public repository of `jjeffries13` (the account matching the dissertation address `jayjeffries13`). `BovRJames` has no public repositories.

| Query | Result |
|---|---|
| `NA*i1 extension:R` | 1 hit, `Jacky222334/GCLS-CAT2` `analysis/factor_analysis/esem_analysis.R`. Not this study. |
| `user:jjeffries13 set.seed(1313)` | 0 |
| `"Navigating Non-Orthogonality"` | 6 hits, all in `alectionary/vibe-math` |
| `user:jjeffries13 simsem` | First try HTTP 429. Retry 2026-10-28: total 0. The clone of `jjeffries13/APA_2024` does contain `simsem` in `simulations/data_sims.R`, so this code-search index missed that file. |
| `"1*1" simsem extension:R` | First try HTTP 429. Retry: total 5. `simsem/simsem` examples `ex6.R`, `ex12.R`, `ex25.R`, plus `cjrwebb/aqm-taster-sem` and `cjrwebb/sem-pgrt`. Not this dissertation. |
| `set.seed(1313) extension:R` | First try HTTP 429. Retry: total 135. First page is `ModelOriented/DALEX`, `pbiecek/ema`, and `ModelOriented/iBreakDown`. The scoped query `user:jjeffries13 set.seed(1313)` is 0. |
| `"latent contrasts" Jeffries` | First try HTTP 429. Retry: total 0. |
| `filename:mgcfa_model.R` | First try HTTP 429. Retry: total 0. |
| `filename:mimic_model.R` | Retry: total 8. ProtoMotions docs, `jinpeng01/AIG_CL`, and `soffiafdz` mediation scripts. Not this dissertation. |
| `filename:mgcfa_results.R` | Retry: total 0. |
| `exportData 13131 extension:R` | Retry: total 0. |
| `"seed = 13131" extension:R` | Retry: total 3. `Permian-Global-Research/science-letter-west-et-al` and `itchyshin/gllvmTMB`. Code search did not return `jjeffries13/APA_2024`, which the clone shows does pass `seed = 13131` to `exportData`. |
| `Jay Jeffries Bovaird` | 85 hits. First is `jjeffries13/ACEs_2025`, a different project. |
| users `jeffries lavaan` | 0 |
| repos `Navigating Non-Orthogonality Jeffries` | 0 |
| repos `orthogonal latent mean Jeffries` | 0 |
| `org:simsem exportData` | 4 hits, the simsem package itself |
| users `jay jeffries` | `jjeffries13`, `Jax247` |
| users `james bovaird` | `BovRJames`, 0 repos |

Clone of all 20 `jjeffries13` repositories, then search for `NA*i1`, `set.seed(1313)`, `simsem`, `non-orthogonality`, `mgcfa`:

- `APA_2024/simulations/data_sims.R` uses `pacman::p_load(here, tidyverse, simsem, lavaan, ...)` and the loading line `f1 =~ NA*i1 + 0.7*i1 + ...` for a ten-indicator model, with `sim(..., seed = 13131)`. It is the 2024 APA imputation study, not the four-indicator dissertation design. It has no `sessionInfo` and no `RNGkind`.
- `Dynamic-Fit-Indices/DFI_Presentation.Rmd` calls `sessionInfo()` for a different talk.
- No repository contains the dissertation title, `set.seed(1313)`, or `mgcfa_model.R`.

## GitLab, Zenodo, OSF search

| Query | Result |
|---|---|
| GitLab `GET /api/v4/projects?search=jeffries latent` | 0 projects |
| Zenodo `q=Jeffries orthogonal latent mean contrasts` | No dissertation record. The hits are unrelated taxonomic and methods records. |
| OSF `filter[title]=orthogonal latent` | One node, `q9yu8` |

## Session files in the jjeffries13 repositories

Checked 2026-10-28 on a shallow clone of every public repository, then the GitHub commit lists and file trees for `Dynamic-Fit-Indices`, `APA_2023`, `APA_2024`, and `APA_2024_Censored_Tobit_Model`.

`Dynamic-Fit-Indices/DFI_Presentation.Rmd` (YAML date 3/9/2022) calls `sessionInfo()` and sinks it to `DFIsessionInfo.txt`. That text file is not in the tree. The commit that added the R Markdown file (`694df0cc`, 2022-03-25) added only `DFI_Presentation.Rmd`. The sixteen commits run from 2022-03-15 through 2022-10-23. `DynamicFitIndexSlides.pdf` is a 27-page Google-slides deck. Its text has no `sessionInfo` block and no R version. The working directory in the R Markdown file is `/Users/jayjeffries/Desktop/R Resources/Dynamic Fit Indices`.

No repository contains `renv.lock`, `packrat.lock`, `.Rprofile`, or a package `DESCRIPTION`. The only `sessionInfo()` call found is the one above.

Other environment traces, with the date of the latest commit on that repository:

| Place | Date | What it shows |
|---|---|---|
| `MLM-In-R/README.md` badge `Rversion-4.2.1` | 2023-02-01 | A shield, not a `sessionInfo` dump. Paths in the learning checks are `/Users/jayjeffries/Desktop/`. |
| `ParameterizedReports/README.md` same badge | 2023-06-20 | Same shield. Data paths are `/Users/jayjeffries/Desktop/`. |
| `APA_2023` | 2023-08-02 | Mac paths under `/Users/jayjeffries/Desktop/Longitudinal/`. No package versions. |
| `APA_2024/simulations/data_sims.R` | commits 2023-12-19 to 2023-12-22 | `simsem` and `lavaan` loaded with `pacman`. Uncommented `exportData(..., seed = 13131)`. Ten- and fifteen-indicator missing-data study, not the dissertation. No versions. |
| `APA_2024_Censored_Tobit_Model` | 2024-07-29 to 2024-08-09 | README edits only in the commit subjects. No session file. |
| `Technostress/Code/Technostress_Descriptives.Rmd` | file date 5/10/2022; repo tip 2022-05-27 | A commented `setwd("C:/Users/jjeffries8/OneDrive - University of Nebraska-Lincoln/...")`. The file that is read uses a relative path. A sibling file reads `/Users/jayjeffries/Desktop/`. |

The dissertation text names R 4.2.2. The 2023 badges say 4.2.1, which is the previous patch release (2022-06-23; R 4.2.2 is 2022-10-31). That is a nearby Mac setup in the 4.2 series. It does not record the lavaan or simsem version, the BLAS, or the machine that ran the dissertation's 10,000 replicates. No cell was rerun from this pass.

## Versions named in the dissertation

Printed pages: R 4.2.2, simsem 0.5.16, lavaan 0.6.17, optimizer `nlminb`, maximum 10,000 iterations. No operating system. CRAN dates: simsem 0.5-16 on 2021-03-28, simsem 0.5-17 on 2025-04-02, lavaan 0.6-17 on 2023-12-20. The default `RNGkind` since R 3.6.0 is Mersenne-Twister / Inversion / Rejection. `sim()` sets L'Ecuyer-CMRG.
