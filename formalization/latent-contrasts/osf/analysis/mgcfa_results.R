pacman::p_load(tidyverse, here)

# ---- Original Models ----
## ---- Significance Models ----

### ---- Import Summaries ----

mgcfa_cond1_n240_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond1_n240_summary.csv"))
mgcfa_cond2_n240_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond2_n240_summary.csv"))
mgcfa_cond3_n240_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond3_n240_summary.csv"))
mgcfa_cond1_n480_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond1_n480_summary.csv"))
mgcfa_cond2_n480_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond2_n480_summary.csv"))
mgcfa_cond3_n480_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond3_n480_summary.csv"))
mgcfa_cond1_n960_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond1_n960_summary.csv"))
mgcfa_cond2_n960_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond2_n960_summary.csv"))
mgcfa_cond3_n960_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond3_n960_summary.csv"))

### ---- Combine Summaries ----

mgcfa_summary <- rbind(mgcfa_cond1_n240_summary, mgcfa_cond2_n240_summary,
                       mgcfa_cond3_n240_summary, mgcfa_cond1_n480_summary,
                       mgcfa_cond2_n480_summary, mgcfa_cond3_n480_summary,
                       mgcfa_cond1_n960_summary, mgcfa_cond2_n960_summary,
                       mgcfa_cond3_n960_summary) 

options(scipen = 999)

mgcfa_summary <- mgcfa_summary |>
  # mimic_summary16 <- bind_rows(mimic_summary15, mimic_cond2_n1080_summary)
  # mimic_summary <- bind_rows(mimic_summary16, mimic_cond3_n1080_summary)
  mutate(
    # bias_c1_est = c1_avg_est - (-0.4),
    #      bias_c2_est = c2_avg_est - (-0.2),
    #      bias_c3_est = c3_avg_est - 0,
    #      abs_bias_c1_est = abs(bias_c1_est),
    #      abs_bias_c1_se = sd(bias_c1_est)/sqrt(10000),
    #      abs_bias_c1_83.4ci_lower = abs_bias_c1_est - 1.386*(abs_bias_c1_se),
    #      abs_bias_c1_83.4ci_upper = abs_bias_c1_est + 1.386*(abs_bias_c1_se),
    #      abs_bias_c1_95ci_lower = abs_bias_c1_est - 1.960*(abs_bias_c1_se),
    #      abs_bias_c1_95ci_upper = abs_bias_c1_est + 1.960*(abs_bias_c1_se),
    #      abs_bias_c2_est = abs(bias_c2_est),
    #      abs_bias_c2_se = sd(bias_c1_est)/sqrt(10000),
    #      abs_bias_c2_83.4ci_lower = abs_bias_c2_est - 1.386*(abs_bias_c2_se),
    #      abs_bias_c2_83.4ci_upper = abs_bias_c2_est + 1.386*(abs_bias_c2_se),
    #      abs_bias_c2_95ci_lower = abs_bias_c2_est - 1.960*(abs_bias_c2_se),
    #      abs_bias_c2_95ci_upper = abs_bias_c2_est + 1.960*(abs_bias_c2_se),
    #      abs_bias_c3_est = abs(bias_c3_est),
    #      abs_bias_c3_se = sd(bias_c1_est)/sqrt(10000),
    #      abs_bias_c3_83.4ci_lower = abs_bias_c3_est - 1.386*(abs_bias_c3_se),
    #      abs_bias_c3_83.4ci_upper = abs_bias_c3_est + 1.386*(abs_bias_c3_se),
    #      abs_bias_c3_95ci_lower = abs_bias_c3_est - 1.960*(abs_bias_c3_se),
    #      abs_bias_c3_95ci_upper = abs_bias_c3_est + 1.960*(abs_bias_c3_se),
    #      rel_bias_c1_est = abs_bias_c1_est/(-0.4),
    #      rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
    #      rel_bias_c1_83.4ci_lower = rel_bias_c1_est - 1.386*(rel_bias_c1_se),
    #      rel_bias_c1_83.4ci_upper = rel_bias_c1_est + 1.386*(rel_bias_c1_se),
    #      rel_bias_c1_95ci_lower = rel_bias_c1_est - 1.960*(rel_bias_c1_se),
    #      rel_bias_c1_95ci_upper = rel_bias_c1_est + 1.960*(rel_bias_c1_se),
    #      rel_bias_c2_est = abs_bias_c2_est/(-0.2),
    #      rel_bias_c2_se = sd(rel_bias_c1_est)/sqrt(10000),
    #      rel_bias_c2_83.4ci_lower = rel_bias_c2_est - 1.386*(rel_bias_c2_se),
    #      rel_bias_c2_83.4ci_upper = rel_bias_c2_est + 1.386*(rel_bias_c2_se),
    #      rel_bias_c2_95ci_lower = rel_bias_c2_est - 1.960*(rel_bias_c2_se),
    #      rel_bias_c2_95ci_upper = rel_bias_c2_est + 1.960*(rel_bias_c2_se),
    #      rel_bias_c3_est = abs_bias_c3_est,
    #      rel_bias_c3_se = sd(rel_bias_c1_est)/sqrt(10000),
    #      rel_bias_c3_83.4ci_lower = rel_bias_c3_est - 1.386*(rel_bias_c3_se),
    #      rel_bias_c3_83.4ci_upper = rel_bias_c3_est + 1.386*(rel_bias_c3_se),
    #      rel_bias_c3_95ci_lower = rel_bias_c3_est - 1.960*(rel_bias_c3_se),
    #      rel_bias_c3_95ci_upper = rel_bias_c3_est + 1.960*(rel_bias_c3_se),
    # efficiency_c1 = (bias_c1_est)^2+((bias_c1_est)^2/10000),
    # efficiency_c2 = (bias_c2_est)^2+((bias_c2_est)^2/10000),
    # efficiency_c3 = (bias_c3_est)^2+((bias_c3_est)^2/10000),
    power_c1 = 100*c1_prop_sig,
    power_c2 = 100*c2_prop_sig,
    power_c3 = 100*c3_prop_sig,
    sample_size = case_when(str_detect(condition, "240") ~ "240",
                            str_detect(condition, "360") ~ "360",
                            str_detect(condition, "480") ~ "480",
                            str_detect(condition, "720") ~ "720",
                            str_detect(condition, "960") ~ "960",
                            str_detect(condition, "1080") ~ "1080"),
    
    model = "MGCFA",
    condition = case_when(str_detect(condition, "cond1") ~ "Condition 1",
                          str_detect(condition, "cond2") ~ "Condition 2",
                          str_detect(condition, "cond3") ~ "Condition 3")) |>
  relocate(sample_size, .after = condition) |>
  relocate(model, .before = 1)
# |>
#   mutate(bias_c1_est = c1_avg_est - (-0.4),
#          bias_c2_est = c2_avg_est - (-0.2),
#          bias_c3_est = c3_avg_est - 0,
#          abs_bias_c1_est = abs(bias_c1_est),
#          abs_bias_c2_est = abs(bias_c2_est),
#          abs_bias_c3_est = abs(bias_c3_est),
#          rel_bias_c1_est = abs_bias_c1_est/(0.4),
#          rel_bias_c2_est = abs_bias_c2_est/(0.2),
#          rel_bias_c3_est = abs_bias_c3_est,
#          efficiency_c1 = (bias_c1_est)^2+((bias_c1_est)^2/10000),
#          efficiency_c2 = (bias_c2_est)^2+((bias_c2_est)^2/10000),
#          efficiency_c3 = (bias_c3_est)^2+((bias_c3_est)^2/10000),
#          power_c1 = 100*c1_prop_sig,
#          power_c2 = 100*c2_prop_sig,
#          power_c3 = 100*c3_prop_sig,
#          sample_size = case_when(str_detect(condition, "240") ~ "240",
#                                  str_detect(condition, "480") ~ "480",
#                                  str_detect(condition, "960") ~ "960"),
#          
#          model = "MGCFA",
#          condition = case_when(str_detect(condition, "cond1") ~ "Condition 1",
#                                str_detect(condition, "cond2") ~ "Condition 2",
#                                str_detect(condition, "cond3") ~ "Condition 3")) |>
#   relocate(sample_size, .after = condition) |>
#   relocate(model, .before = 1)

write.csv(mgcfa_summary, here("./sem/mgcfa/mgcfa_summary.csv"))

## ---- Convergence Rates ----
### ---- Import Convergence Rates ----

convergerate_cond1_n240 <- read.csv(here("./sem/mgcfa/convergerate_cond1_n240.csv"))
convergerate_cond2_n240 <- read.csv(here("./sem/mgcfa/convergerate_cond2_n240.csv"))
convergerate_cond3_n240 <- read.csv(here("./sem/mgcfa/convergerate_cond3_n240.csv"))
convergerate_cond1_n480 <- read.csv(here("./sem/mgcfa/convergerate_cond1_n480.csv"))
convergerate_cond2_n480 <- read.csv(here("./sem/mgcfa/convergerate_cond2_n480.csv"))
convergerate_cond3_n480 <- read.csv(here("./sem/mgcfa/convergerate_cond3_n480.csv"))
convergerate_cond1_n960 <- read.csv(here("./sem/mgcfa/convergerate_cond1_n960.csv"))
convergerate_cond2_n960 <- read.csv(here("./sem/mgcfa/convergerate_cond2_n960.csv"))
convergerate_cond3_n960 <- read.csv(here("./sem/mgcfa/convergerate_cond3_n960.csv"))

### ---- Combine Convergence Rates ----

mgcfa_convergerates <- rbind(convergerate_cond1_n240, convergerate_cond3_n240,
                             convergerate_cond1_n480, convergerate_cond2_n480,
                             convergerate_cond3_n480, convergerate_cond1_n960,
                             convergerate_cond2_n960, convergerate_cond3_n960)

write.csv(mgcfa_convergerates, here("./sem/mgcfa/mgcfa_convergerates.csv"))

## ---- Null Models ----
### ---- Import Summaries ----

mgcfa_nullcond1_n240_summary <- read.csv(here("./sem/mgcfa/mgcfa_nullcond1_n240_summary.csv"))
mgcfa_nullcond2_n240_summary <- read.csv(here("./sem/mgcfa/mgcfa_nullcond2_n240_summary.csv"))
mgcfa_nullcond3_n240_summary <- read.csv(here("./sem/mgcfa/mgcfa_nullcond3_n240_summary.csv"))
mgcfa_nullcond1_n480_summary <- read.csv(here("./sem/mgcfa/mgcfa_nullcond1_n480_summary.csv"))
mgcfa_nullcond2_n480_summary <- read.csv(here("./sem/mgcfa/mgcfa_nullcond2_n480_summary.csv"))
mgcfa_nullcond3_n480_summary <- read.csv(here("./sem/mgcfa/mgcfa_nullcond3_n480_summary.csv"))
mgcfa_nullcond1_n960_summary <- read.csv(here("./sem/mgcfa/mgcfa_nullcond1_n960_summary.csv"))
mgcfa_nullcond2_n960_summary <- read.csv(here("./sem/mgcfa/mgcfa_nullcond2_n960_summary.csv"))
mgcfa_nullcond3_n960_summary <- read.csv(here("./sem/mgcfa/mgcfa_nullcond3_n960_summary.csv"))

### ---- Combine Summaries ----

mgcfa_null_summary <- rbind(mgcfa_nullcond1_n240_summary, mgcfa_nullcond2_n240_summary,
                            mgcfa_nullcond3_n240_summary, mgcfa_nullcond1_n480_summary,
                            mgcfa_nullcond2_n480_summary, mgcfa_nullcond3_n480_summary,
                            mgcfa_nullcond1_n960_summary, mgcfa_nullcond2_n960_summary,
                            mgcfa_nullcond3_n960_summary)

mgcfa_null_summary <- mgcfa_null_summary |>
  mutate(bias_c1_est = c1_avg_est,
         bias_c2_est = c2_avg_est,
         bias_c3_est = c3_avg_est,
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         rel_bias_c1_est = abs_bias_c1_est,
         rel_bias_c2_est = abs_bias_c2_est,
         rel_bias_c3_est = abs_bias_c3_est,
         efficiency_c1 = (bias_c1_est)^2+((bias_c1_est)^2/10000),
         efficiency_c2 = (bias_c2_est)^2+((bias_c2_est)^2/10000),
         efficiency_c3 = (bias_c3_est)^2+((bias_c3_est)^2/10000),
         type1_c1 = 100*c1_prop_sig,
         type1_c2 = 100*c2_prop_sig,
         type1_c3 = 100*c3_prop_sig,
         sample_size = case_when(str_detect(condition, "240") ~ "240",
                                 str_detect(condition, "480") ~ "480",
                                 str_detect(condition, "960") ~ "960"),
         model = "MGCFA",
         condition = case_when(str_detect(condition, "nullcond1") ~ "Null Condition 1",
                               str_detect(condition, "nullcond2") ~ "Null Condition 2",
                               str_detect(condition, "nullcond3") ~ "Null Condition 3")) |>
  relocate(sample_size, .after = condition) |>
  relocate(model, .before = 1) 

write.csv(mgcfa_null_summary, here("./sem/mgcfa/mgcfa_null_summary.csv"))

## ---- Convergence Rates ----
### ---- Import Convergence Rates ----

convergerate_nullcond1_n240 <- read.csv(here("./sem/mgcfa/convergerate_nullcond1_n240.csv"))
convergerate_nullcond2_n240 <- read.csv(here("./sem/mgcfa/convergerate_nullcond2_n240.csv"))
convergerate_nullcond3_n240 <- read.csv(here("./sem/mgcfa/convergerate_nullcond3_n240.csv"))
convergerate_nullcond1_n480 <- read.csv(here("./sem/mgcfa/convergerate_nullcond1_n480.csv"))
convergerate_nullcond2_n480 <- read.csv(here("./sem/mgcfa/convergerate_nullcond2_n480.csv"))
convergerate_nullcond3_n480 <- read.csv(here("./sem/mgcfa/convergerate_nullcond3_n480.csv"))
convergerate_nullcond1_n960 <- read.csv(here("./sem/mgcfa/convergerate_nullcond1_n960.csv"))
convergerate_nullcond2_n960 <- read.csv(here("./sem/mgcfa/convergerate_nullcond2_n960.csv"))
convergerate_nullcond3_n960 <- read.csv(here("./sem/mgcfa/convergerate_nullcond3_n960.csv"))

### ---- Combine Convergence Rates ----

mgcfa_null_convergerates <- rbind(convergerate_nullcond1_n240, convergerate_nullcond2_n240,
                                  convergerate_nullcond3_n240, convergerate_nullcond1_n480,
                                  convergerate_nullcond2_n480, convergerate_nullcond3_n480,
                                  convergerate_nullcond1_n960, convergerate_nullcond2_n960,
                                  convergerate_nullcond3_n960)

write.csv(mgcfa_null_convergerates, here("./sem/mgcfa/mgcfa_null_convergerates.csv"))

# ---- Extra Models ----
## ---- Significance Models ----
### ---- Import Summaries ----

mgcfa_cond1_n360_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond1_n360_summary.csv"))
mgcfa_cond2_n360_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond2_n360_summary.csv"))
mgcfa_cond3_n360_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond3_n360_summary.csv"))
mgcfa_cond1_n720_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond1_n720_summary.csv"))
mgcfa_cond2_n720_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond2_n720_summary.csv"))
mgcfa_cond3_n720_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond3_n720_summary.csv"))
mgcfa_cond1_n1080_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond1_n1080_summary.csv"))
mgcfa_cond2_n1080_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond2_n1080_summary.csv"))
mgcfa_cond3_n1080_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond3_n1080_summary.csv"))

### ---- Combine Summaries ----

mgcfa_summary_extra <- rbind(mgcfa_cond1_n360_summary, mgcfa_cond2_n360_summary,
                             mgcfa_cond3_n360_summary, mgcfa_cond1_n720_summary,
                             mgcfa_cond2_n720_summary, mgcfa_cond3_n720_summary,
                             mgcfa_cond1_n1080_summary, mgcfa_cond2_n1080_summary,
                             mgcfa_cond3_n1080_summary)

options(scipen = 999)

mgcfa_summary_extra <- mgcfa_summary_extra |>
  mutate(power_c1 = 100*c1_prop_sig,
         power_c2 = 100*c2_prop_sig,
         power_c3 = 100*c3_prop_sig,
         sample_size = case_when(str_detect(condition, "240") ~ "240",
                                 str_detect(condition, "360") ~ "360",
                                 str_detect(condition, "480") ~ "480",
                                 str_detect(condition, "720") ~ "720",
                                 str_detect(condition, "960") ~ "960",
                                 str_detect(condition, "1080") ~ "1080"),
         model = "MGCFA",
         condition = case_when(str_detect(condition, "cond1") ~ "Condition 1",
                               str_detect(condition, "cond2") ~ "Condition 2",
                               str_detect(condition, "cond3") ~ "Condition 3")) |>
  relocate(sample_size, .after = condition) |>
  relocate(model, .before = 1)

write.csv(mgcfa_summary_extra, here("./sem/mgcfa/mgcfa_summary_extra.csv"))

mgcfa_summary_all <- rbind(mgcfa_summary_extra, mgcfa_summary) |>
  mutate(sample_size = factor(sample_size, 
                              levels = c("240", "360", "480", "720", "960", "1080"))) |>
  arrange(-desc(sample_size))

write.csv(mgcfa_summary_all, here("./sem/mgcfa/mgcfa_summary_all.csv"))

## ---- Null Models ----

### ---- Import Summaries ----

mgcfa_cond1_n360_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond1_n360_summary.csv"))
mgcfa_cond2_n360_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond2_n360_summary.csv"))
mgcfa_cond3_n360_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond3_n360_summary.csv"))
mgcfa_cond1_n720_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond1_n720_summary.csv"))
mgcfa_cond2_n720_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond2_n720_summary.csv"))
mgcfa_cond3_n720_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond3_n720_summary.csv"))
mgcfa_cond1_n1080_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond1_n1080_summary.csv"))
mgcfa_cond2_n1080_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond2_n1080_summary.csv"))
mgcfa_cond3_n1080_summary <- read.csv(here("./sem/mgcfa/mgcfa_cond3_n1080_summary.csv"))

### ---- Combine Summaries ----

mgcfa_summary_extra <- rbind(mgcfa_cond1_n360_summary, mgcfa_cond2_n360_summary,
                             mgcfa_cond3_n360_summary, mgcfa_cond1_n720_summary,
                             mgcfa_cond2_n720_summary, mgcfa_cond3_n720_summary,
                             mgcfa_cond1_n1080_summary, mgcfa_cond2_n1080_summary,
                             mgcfa_cond3_n1080_summary)

options(scipen = 999)

mgcfa_summary_extra <- mgcfa_summary_extra |>
  mutate(power_c1 = 100*c1_prop_sig,
         power_c2 = 100*c2_prop_sig,
         power_c3 = 100*c3_prop_sig,
         sample_size = case_when(str_detect(condition, "240") ~ "240",
                                 str_detect(condition, "360") ~ "360",
                                 str_detect(condition, "480") ~ "480",
                                 str_detect(condition, "720") ~ "720",
                                 str_detect(condition, "960") ~ "960",
                                 str_detect(condition, "1080") ~ "1080"),
         model = "MGCFA",
         condition = case_when(str_detect(condition, "cond1") ~ "Condition 1",
                               str_detect(condition, "cond2") ~ "Condition 2",
                               str_detect(condition, "cond3") ~ "Condition 3")) |>
  relocate(sample_size, .after = condition) |>
  relocate(model, .before = 1)

write.csv(mgcfa_summary_extra, here("./sem/mgcfa/mgcfa_summary_extra.csv"))

mgcfa_summary_all <- rbind(mgcfa_summary_extra, mgcfa_summary) |>
  mutate(sample_size = factor(sample_size, 
                              levels = c("240", "360", "480", "720", "960", "1080"))) |>
  arrange(-desc(sample_size))

write.csv(mgcfa_summary_all, here("./sem/mgcfa/mgcfa_summary_all.csv"))

# ---- Revised Models ----
## ---- Significance Models ----
### ---- Import Summaries ----

mgcfa_cond3_n240_model1_summary <- read.csv(here("./sem/mgcfa/revised_mgcfa_cond3_n240_model1_summary.csv"))
mgcfa_cond3_n240_model2_summary <- read.csv(here("./sem/mgcfa/revised_mgcfa_cond3_n240_model2_summary.csv"))
mgcfa_cond3_n240_model3_summary <- read.csv(here("./sem/mgcfa/revised_mgcfa_cond3_n240_model3_summary.csv"))

### ---- Combine Summaries ----

revised_mgcfa_summary_extra <- rbind(mgcfa_cond3_n240_model1_summary,
                                     mgcfa_cond3_n240_model2_summary,
                                     mgcfa_cond3_n240_model3_summary)

options(scipen = 999)

revised_mgcfa_summary_extra <- revised_mgcfa_summary_extra |>
  mutate(power_c1 = 100*c1_prop_sig,
         power_c2 = 100*c2_prop_sig,
         power_c3 = 100*c3_prop_sig,
         sample_size = "240",
         model = case_when(str_detect(condition, "model1") 
                           ~ "MGCFA Equal Factor Variance, Loadings, Resids",
                           str_detect(condition, "model2") ~ "MGCFA Equal Factor Variance, Loadings",
                           str_detect(condition, "model3") ~ "MGCFA Equal Factor Variance"),
         condition = "Condition 3") |>
  relocate(sample_size, .after = condition) |>
  relocate(model, .before = 1)

write.csv(revised_mgcfa_summary_extra, here("./sem/mgcfa/revised_mgcfa_summary_extra.csv"))

## ---- Null Models ----
### ---- Import Summaries ----

mgcfa_nullcond3_n240_model1_summary <- read.csv(
  here("./sem/mgcfa/revised_mgcfa_nullcond3_n240_model1_summary.csv"))
view(mgcfa_nullcond3_n240_model1_summary)

mgcfa_nullcond3_n240_model2_summary <- read.csv(
  here("./sem/mgcfa/revised_mgcfa_nullcond3_n240_model2_summary.csv"))
view(mgcfa_nullcond3_n240_model2_summary)

mgcfa_nullcond3_n240_model3_summary <- read.csv(
  here("./sem/mgcfa/revised_mgcfa_nullcond3_n240_model3_summary.csv"))
view(mgcfa_nullcond3_n240_model3_summary)

### ---- Combine Summaries ----

revised_mgcfa_null_summary_extra <- rbind(mgcfa_nullcond3_n240_model1_summary,
                                          mgcfa_nullcond3_n240_model2_summary,
                                          mgcfa_nullcond3_n240_model3_summary)

options(scipen = 999)
revised_mgcfa_null_summary_extra <- revised_mgcfa_null_summary_extra |>
  mutate(type1_c1 = 100*c1_prop_sig,
         type1_c2 = 100*c2_prop_sig,
         type1_c3 = 100*c3_prop_sig,
         sample_size = "240",
         model = case_when(str_detect(condition, "model1") 
                           ~ "MGCFA Equal Factor Variance, Loadings, Resids",
                           str_detect(condition, "model2") ~ "MGCFA Equal Factor Variance, Loadings",
                           str_detect(condition, "model3") ~ "MGCFA Equal Factor Variance"),
         condition = "Null Condition 3") |>
  relocate(sample_size, .after = condition) |>
  relocate(model, .before = 1)

write.csv(revised_mgcfa_null_summary_extra, here("./sem/mgcfa/revised_mgcfa_null_summary_extra.csv"))

compare_cols <- names(revised_mgcfa_summary_extra)

mimic_summary_n240 <- read.csv(here("./sem/mimic/mimic_summary.csv")) |>
  filter(sample_size == "240",
         condition == "Condition 3") |>
  select(all_of(compare_cols))

compare_cols_null <- names(revised_mgcfa_null_summary_extra)

mimic_null_summary_n240 <- read.csv(here("./sem/mimic/mimic_null_summary.csv")) |>
  filter(sample_size == "240",
         condition == "Null Condition 3") |>
  select(all_of(compare_cols_null))

compare_summaries <- rbind(revised_mgcfa_summary_extra, mimic_summary_n240)

write.csv(compare_summaries, here("./sem/compare_summaries.csv"))

compare_summaries_null <- rbind(revised_mgcfa_null_summary_extra, mimic_null_summary_n240)

write.csv(compare_summaries_null, here("./sem/compare_summaries_null.csv"))
