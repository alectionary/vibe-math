# Public OSF project for Jeffries and Bovaird

Retrieved 2026-10-27 from <https://osf.io/q9yu8/> (node `q9yu8`, title "Examining the accuracy of orthogonal latent mean comparisons in unbalanced conditions", created 2025-04-18). The node has no description and no article PDF. The data archives do not contain the `.dat` replicates. They contain the generation scripts. The analysis scripts and the summary CSV files are the estimation record.

`analysis/mgcfa_model.R` is the multigroup syntax that produced `results/mgcfa_summary.csv`. `analysis/mimic_model.R` is the MIMIC syntax. The standard error in the summary is `sd(estimate) / sqrt(n)`.

`generation/n240_cond1_sims.R` is the N=240 condition-1 generation script. The population intercept is written `i1 ~ 1*1`. The loading line is still `NA*i1 + 0.7*i1`. The `exportData` call in that file is commented out.
