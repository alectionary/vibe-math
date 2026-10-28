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
| `user:jjeffries13 simsem` | HTTP 429, then not retried as a second code query. The clone grep below covers it. |
| `"1*1" simsem extension:R` | HTTP 429 |
| `set.seed(1313) extension:R` | HTTP 429 |
| `"latent contrasts" Jeffries` | HTTP 429 |
| `filename:mgcfa_model.R` | HTTP 429 |
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

## Versions named in the dissertation

Printed pages: R 4.2.2, simsem 0.5.16, lavaan 0.6.17, optimizer `nlminb`, maximum 10,000 iterations. No operating system. CRAN dates: simsem 0.5-16 on 2021-03-28, simsem 0.5-17 on 2025-04-02, lavaan 0.6-17 on 2023-12-20. The default `RNGkind` since R 3.6.0 is Mersenne-Twister / Inversion / Rejection. `sim()` sets L'Ecuyer-CMRG.
