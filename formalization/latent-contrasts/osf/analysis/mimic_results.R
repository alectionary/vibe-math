pacman::p_load(tidyverse, here)

# ---- Original Models ----
## ---- Significance Model ----
### ---- Convergence Rates ----
#### ---- Import Convergence Rates ----

convergerate_cond1_n240 <- read.csv(here("./sem/mimic/convergerate_cond1_n240.csv"))
convergerate_cond2_n240 <- read.csv(here("./sem/mimic/convergerate_cond2_n240.csv"))
convergerate_cond3_n240 <- read.csv(here("./sem/mimic/convergerate_cond3_n240.csv"))
convergerate_cond1_n360 <- read.csv(here("./sem/mimic/convergerate_cond1_n360.csv"))
convergerate_cond2_n360 <- read.csv(here("./sem/mimic/convergerate_cond2_n360.csv"))
convergerate_cond3_n360 <- read.csv(here("./sem/mimic/convergerate_cond3_n360.csv"))
convergerate_cond1_n480 <- read.csv(here("./sem/mimic/convergerate_cond1_n480.csv"))
convergerate_cond2_n480 <- read.csv(here("./sem/mimic/convergerate_cond2_n480.csv"))
convergerate_cond3_n480 <- read.csv(here("./sem/mimic/convergerate_cond3_n480.csv"))
convergerate_cond1_n720 <- read.csv(here("./sem/mimic/convergerate_cond1_n720.csv"))
convergerate_cond2_n720 <- read.csv(here("./sem/mimic/convergerate_cond2_n720.csv"))
convergerate_cond3_n720 <- read.csv(here("./sem/mimic/convergerate_cond3_n720.csv"))
convergerate_cond1_n960 <- read.csv(here("./sem/mimic/convergerate_cond1_n960.csv"))
convergerate_cond2_n960 <- read.csv(here("./sem/mimic/convergerate_cond2_n960.csv"))
convergerate_cond3_n960 <- read.csv(here("./sem/mimic/convergerate_cond3_n960.csv"))
convergerate_cond1_n1080 <- read.csv(here("./sem/mimic/convergerate_cond1_n1080.csv"))
# convergerate_cond2_n1080 <- read.csv(here("./sem/mimic/convergerate_cond2_n1080.csv"))
# convergerate_cond3_n1080 <- read.csv(here("./sem/mimic/convergerate_cond3_n1080.csv"))

#### ---- Combine Convergence Rates ----

mimic_convergerate1 <- rbind(convergerate_cond1_n240, convergerate_cond2_n240)
mimic_convergerate2 <- rbind(mimic_convergerate1, convergerate_cond3_n240)
mimic_convergerate3 <- rbind(mimic_convergerate2, convergerate_cond1_n360)
mimic_convergerate4 <- rbind(mimic_convergerate3, convergerate_cond2_n360)
mimic_convergerate5 <- rbind(mimic_convergerate4, convergerate_cond3_n360)
mimic_convergerate6 <- rbind(mimic_convergerate5, convergerate_cond1_n480)
mimic_convergerate7 <- rbind(mimic_convergerate6, convergerate_cond2_n480)
mimic_convergerate8 <- rbind(mimic_convergerate7, convergerate_cond3_n480)
mimic_convergerate9 <- rbind(mimic_convergerate8, convergerate_cond1_n720)
mimic_convergerate10 <- rbind(mimic_convergerate9, convergerate_cond2_n720)
mimic_convergerate11 <- rbind(mimic_convergerate10, convergerate_cond3_n720)
mimic_convergerate12 <- rbind(mimic_convergerate11, convergerate_cond1_n960)
mimic_convergerate13 <- rbind(mimic_convergerate12, convergerate_cond2_n960)
mimic_convergerate14 <- rbind(mimic_convergerate13, convergerate_cond3_n960)
mimic_convergerate15 <- rbind(mimic_convergerate14, convergerate_cond1_n1080)
mimic_convergerate16 <- rbind(mimic_convergerate15, convergerate_cond2_n1080)
mimic_convergerates <- rbind(mimic_convergerate16, convergerate_cond3_n1080)

view(mimic_convergerate15)

write.csv(mimic_convergerates, here("./sem/mimic/mimic_convergerates.csv"))

### ---- Model Summaries ----
#### ---- Import Summaries ----

mimic_cond1_n240_summary <- read.csv(here("./sem/mimic/mimic_cond1_n240_summary.csv")) 
mimic_cond2_n240_summary <- read.csv(here("./sem/mimic/mimic_cond2_n240_summary.csv")) 
mimic_cond3_n240_summary <- read.csv(here("./sem/mimic/mimic_cond3_n240_summary.csv"))
mimic_cond1_n360_summary <- read.csv(here("./sem/mimic/mimic_cond1_n360_summary.csv")) |>
  select(-avg_int)
mimic_cond2_n360_summary <- read.csv(here("./sem/mimic/mimic_cond2_n360_summary.csv")) |>
  select(-avg_int)
mimic_cond3_n360_summary <- read.csv(here("./sem/mimic/mimic_cond3_n360_summary.csv")) |>
  select(-avg_int)
mimic_cond1_n480_summary <- read.csv(here("./sem/mimic/mimic_cond1_n480_summary.csv")) 
mimic_cond2_n480_summary <- read.csv(here("./sem/mimic/mimic_cond2_n480_summary.csv"))
mimic_cond3_n480_summary <- read.csv(here("./sem/mimic/mimic_cond3_n480_summary.csv")) 
mimic_cond1_n720_summary <- read.csv(here("./sem/mimic/mimic_cond1_n720_summary.csv")) |>
  select(-avg_int) 
mimic_cond2_n720_summary <- read.csv(here("./sem/mimic/mimic_cond2_n720_summary.csv")) |>
  select(-avg_int)
mimic_cond3_n720_summary <- read.csv(here("./sem/mimic/mimic_cond3_n720_summary.csv")) |>
  select(-avg_int)
mimic_cond1_n960_summary <- read.csv(here("./sem/mimic/mimic_cond1_n960_summary.csv"))
mimic_cond2_n960_summary <- read.csv(here("./sem/mimic/mimic_cond2_n960_summary.csv"))
mimic_cond3_n960_summary <- read.csv(here("./sem/mimic/mimic_cond3_n960_summary.csv"))
mimic_cond1_n1080_summary <- read.csv(here("./sem/mimic/mimic_cond1_n1080_summary.csv")) |>
  select(-avg_int)
mimic_cond2_n1080_summary <- read.csv(here("./sem/mimic/mimic_cond2_n1080_summary.csv")) |>
  select(-avg_int)
mimic_cond3_n1080_summary <- read.csv(here("./sem/mimic/mimic_cond3_n1080_summary.csv")) 

#### ---- Combine Summaries ----

options(scipen = 999)

mimic_summary <- rbind(mimic_cond1_n240_summary, mimic_cond2_n240_summary,
                       mimic_cond3_n240_summary, mimic_cond1_n480_summary, 
                       mimic_cond2_n480_summary, mimic_cond3_n480_summary, 
                       mimic_cond1_n960_summary, mimic_cond2_n960_summary,
                       mimic_cond3_n960_summary) |>
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
         
         model = "MIMIC",
         condition = case_when(str_detect(condition, "cond1") ~ "Condition 1",
                               str_detect(condition, "cond2") ~ "Condition 2",
                               str_detect(condition, "cond3") ~ "Condition 3")) |>
  relocate(sample_size, .after = condition) |>
  relocate(model, .before = 1)

# mimic_summary_og_analysis <- mimic_summary15 |>
#   filter(sample_size == "240" | sample_size == "480" | sample_size == "960")

write.csv(mimic_summary, here("./sem/mimic/mimic_summary.csv"))
# write.csv(mimic_summary_og_analysis, here("./sem/mimic/mimic_summary_og_analysis.csv"))
# write.csv(mimic_summary15, here("./sem/mimic/mimic_summary15.csv"))

## ---- Null Models ----
### ---- Convergence Rates ----
#### ---- Import Convergence Rates ----

convergerate_nullcond1_n240 <- read.csv(here("./sem/mimic/convergerate_nullcond1_n240.csv"))
convergerate_nullcond2_n240 <- read.csv(here("./sem/mimic/convergerate_nullcond2_n240.csv"))
convergerate_nullcond3_n240 <- read.csv(here("./sem/mimic/convergerate_nullcond3_n240.csv"))
convergerate_nullcond1_n480 <- read.csv(here("./sem/mimic/convergerate_nullcond1_n480.csv"))
convergerate_nullcond2_n480 <- read.csv(here("./sem/mimic/convergerate_nullcond2_n480.csv"))
convergerate_nullcond3_n480 <- read.csv(here("./sem/mimic/convergerate_nullcond3_n480.csv"))
convergerate_nullcond1_n960 <- read.csv(here("./sem/mimic/convergerate_nullcond1_n960.csv"))
convergerate_nullcond2_n960 <- read.csv(here("./sem/mimic/convergerate_nullcond2_n960.csv"))
convergerate_nullcond3_n960 <- read.csv(here("./sem/mimic/convergerate_nullcond3_n960.csv"))

#### ---- Combine Convergence Rates ----

mimic_null_convergerate1 <- rbind(convergerate_nullcond1_n240, convergerate_nullcond2_n240)
mimic_null_convergerate2 <- rbind(mimic_null_convergerate1, convergerate_nullcond3_n240)
mimic_null_convergerate3 <- rbind(mimic_null_convergerate2, convergerate_nullcond1_n480)
mimic_null_convergerate4 <- rbind(mimic_null_convergerate3, convergerate_nullcond2_n480)
mimic_null_convergerate5 <- rbind(mimic_null_convergerate4, convergerate_nullcond3_n480)
mimic_null_convergerate6 <- rbind(mimic_null_convergerate5, convergerate_nullcond1_n960)
mimic_null_convergerate7 <- rbind(mimic_null_convergerate6, convergerate_nullcond2_n960)
mimic_null_convergerates <- rbind(mimic_null_convergerate7, convergerate_nullcond3_n960)

view(mimic_null_convergerates)

write.csv(mimic_null_convergerates, here("./sem/mimic/mimic_null_convergerates.csv"))

### ---- Model Summaries ----
#### ---- Import Summaries ----

mimic_nullcond1_n240_summary <- read.csv(here("./sem/mimic/mimic_nullcond1_n240_summary.csv")) 
mimic_nullcond2_n240_summary <- read.csv(here("./sem/mimic/mimic_nullcond2_n240_summary.csv"))
mimic_nullcond3_n240_summary <- read.csv(here("./sem/mimic/mimic_nullcond3_n240_summary.csv")) 
mimic_nullcond1_n480_summary <- read.csv(here("./sem/mimic/mimic_nullcond1_n480_summary.csv"))
mimic_nullcond2_n480_summary <- read.csv(here("./sem/mimic/mimic_nullcond2_n480_summary.csv"))
mimic_nullcond3_n480_summary <- read.csv(here("./sem/mimic/mimic_nullcond3_n480_summary.csv"))
mimic_nullcond1_n960_summary <- read.csv(here("./sem/mimic/mimic_nullcond1_n960_summary.csv"))
mimic_nullcond2_n960_summary <- read.csv(here("./sem/mimic/mimic_nullcond2_n960_summary.csv")) 
mimic_nullcond3_n960_summary <- read.csv(here("./sem/mimic/mimic_nullcond3_n960_summary.csv")) 

#### ---- Combine Summaries ----

mimic_null_summary <- rbind(mimic_nullcond1_n240_summary, mimic_nullcond2_n240_summary,
                            mimic_nullcond3_n240_summary,  mimic_nullcond1_n480_summary,
                            mimic_nullcond2_n480_summary, mimic_nullcond3_n480_summary,
                            mimic_nullcond1_n960_summary, mimic_nullcond2_n960_summary,
                            mimic_nullcond3_n960_summary)

mimic_null_summary <- mimic_null_summary |>
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
         model = "MIMIC",
         condition = case_when(str_detect(condition, "nullcond1") ~ "Null Condition 1",
                               str_detect(condition, "nullcond2") ~ "Null Condition 2",
                               str_detect(condition, "nullcond3") ~ "Null Condition 3")) |>
  relocate(sample_size, .after = condition) |>
  relocate(model, .before = 1) 

write.csv(mimic_null_summary, here("./sem/mimic/mimic_null_summary.csv"))

# ---- Extra Models ----
## ---- Significance Model ----
### ---- Model Summaries Rates ----
#### ---- Import Summaries ----

mimic_cond1_n360_summary <- read.csv(here("./sem/mimic/mimic_cond1_n360_summary.csv")) |>
  select(-avg_int)
mimic_cond2_n360_summary <- read.csv(here("./sem/mimic/mimic_cond2_n360_summary.csv")) |>
  select(-avg_int)
mimic_cond3_n360_summary <- read.csv(here("./sem/mimic/mimic_cond3_n360_summary.csv")) |>
  select(-avg_int)
mimic_cond1_n720_summary <- read.csv(here("./sem/mimic/mimic_cond1_n720_summary.csv")) |>
  select(-avg_int) 
mimic_cond2_n720_summary <- read.csv(here("./sem/mimic/mimic_cond2_n720_summary.csv")) |>
  select(-avg_int)
mimic_cond3_n720_summary <- read.csv(here("./sem/mimic/mimic_cond3_n720_summary.csv")) |>
  select(-avg_int)
mimic_cond1_n1080_summary <- read.csv(here("./sem/mimic/mimic_cond1_n1080_summary.csv")) |>
  select(-avg_int)
mimic_cond2_n1080_summary <- read.csv(here("./sem/mimic/mimic_cond2_n1080_summary.csv")) |>
  select(-avg_int)
mimic_cond3_n1080_summary <- read.csv(here("./sem/mimic/mimic_cond3_n1080_summary.csv")) 

#### ---- Combine Summaries ----

options(scipen = 999)

correct_columns <- colnames(mimic_cond2_n1080_summary)
mimic_cond3_n1080_summary <- mimic_cond3_n1080_summary |>
  select(all_of(correct_columns))

mimic_summary_extra <- rbind(mimic_cond1_n360_summary, mimic_cond2_n360_summary,
                       mimic_cond3_n360_summary, mimic_cond1_n720_summary, 
                       mimic_cond2_n720_summary, mimic_cond3_n720_summary, 
                       mimic_cond1_n1080_summary, mimic_cond2_n1080_summary,
                       mimic_cond3_n1080_summary) |>
  mutate(power_c3 = 100*c3_prop_sig,
         sample_size = case_when(str_detect(condition, "240") ~ "240",
                            str_detect(condition, "360") ~ "360",
                            str_detect(condition, "480") ~ "480",
                            str_detect(condition, "720") ~ "720",
                            str_detect(condition, "960") ~ "960",
                            str_detect(condition, "1080") ~ "1080"),
         model = "MIMIC",
         condition = case_when(str_detect(condition, "cond1") ~ "Condition 1",
                               str_detect(condition, "cond2") ~ "Condition 2",
                               str_detect(condition, "cond3") ~ "Condition 3")) |>
  relocate(sample_size, .after = condition) |>
  relocate(model, .before = 1)

write.csv(mimic_summary_extra, here("./sem/mimic/mimic_summary_extra.csv"))

correct_columns_extra <- colnames(mimic_summary_extra)

mimic_summary_small <- mimic_summary |>
  select(all_of(correct_columns_extra))

mimic_summary_all <- rbind(mimic_summary_extra, mimic_summary_small) |>
  mutate(sample_size = factor(sample_size, 
                              levels = c("240", "360", "480", "720", "960", "1080"))) |>
  arrange(-desc(sample_size))

write.csv(mimic_summary_all, here("./sem/mimic/mimic_summary_all.csv"))