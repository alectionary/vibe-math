pacman::p_load(lavaan, tidyverse, here)

# ---- Model Syntax ---- 

mgcfae_model <- "
eta =~ 1*i1 + i2 + i3 + i4

eta ~~ NA*eta 

eta ~ c(a, b, c, d)*1

i1 + i2 + i3 + i4 ~ c(eq, eq, eq, eq)*1

c1 := -1*((a + c) / 2) + ((b + d) / 2)
c2 := -1*((a + b) / 2) + ((c + d) / 2)
c3 := -1*((b + c) / 2) + ((a + d) / 2)
"

# ---- DFI ---- 
# 
# mgcfae_model <- "
# eta =~ 1*i1 + i2 + i3 + i4
# 
# eta ~~ NA*eta
# 
# eta ~ NA*1
# 
# i1 + i2 + i3 + i4 ~ eq*1
# "
# 
# dfi_fit <- sem(model = mgcfae_model,
#                data = cond1_data_list[[1]],
#                missing = "ML",
#                estimator = "MLR",
#                meanstructure = TRUE)
# 
# dfi_fit |>
#   summary(fit.measures = T)
# 
# cfaOne(model = dfi_fit)

# mgcfae_model_test <- "
# eta =~ 1*sim_n240_2.i1 + sim_n240_2.i2 + sim_n240_2.i3 + sim_n240_2.i4
# 
# eta ~~ NA*eta
# 
# eta ~ c(a, b, c, d)*1
# 
# sim_n240_2.i1 + sim_n240_2.i2 + sim_n240_2.i3 + sim_n240_2.i4 ~ c(eq, eq, eq, eq)*1
# 
# c1 := -1*((a + c) / 2) + ((b + d) / 2)
# c2 := -1*((a + b) / 2) + ((c + d) / 2)
# c3 := -1*((b + c) / 2) + ((a + d) / 2)
# "
# 
# names(as.data.frame(cond1_n240_data_list[1]))
# 
# test_mgcfa <- sem(model = mgcfae_model_test,
#    data = as.data.frame(cond1_n240_data_list[2]),
#    missing = "ML",
#    estimator = "MLR",
#    group = "sim_n240_2.subgroup",
#    meanstructure = TRUE) 

# ---- N = 240 ---- 
## ---- Condition 1 ---- 
### ---- Significance Model ----

fun_mgcfa <- function(cond1_n240_data_list){
  fit = sem(model = mgcfae_model,
            data = cond1_n240_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "cond1_n240_data_list"

results_cond1_n240 <- lapply(cond1_n240_data_list, fun_mgcfa)

names(results_cond1_n240) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_cond1_n240 <- list() # initialize

for (i in 1:length(results_cond1_n240)) {
  c1_est <- results_cond1_n240[[i]]$summary$pe$est[57]
  c1_se <- results_cond1_n240[[i]]$summary$pe$se[57]
  c1_z <- results_cond1_n240[[i]]$summary$pe$z[57]
  c1_p <- format(results_cond1_n240[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_cond1_n240[[i]]$summary$pe$est[58]
  c2_se <- results_cond1_n240[[i]]$summary$pe$se[58]
  c2_z <- results_cond1_n240[[i]]$summary$pe$z[58]
  c2_p <- format(results_cond1_n240[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_cond1_n240[[i]]$summary$pe$est[59]
  c3_se <- results_cond1_n240[[i]]$summary$pe$se[59]
  c3_z <- results_cond1_n240[[i]]$summary$pe$z[59]
  c3_p <- format(results_cond1_n240[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_cond1_n240[[i]]$summary$fit[17]
  rmsea <- results_cond1_n240[[i]]$summary$fit[31]
  srmr <- results_cond1_n240[[i]]$summary$fit[49]
  conv <- results_cond1_n240[[i]]$summary$header$optim.converged[1]
  
  modelfit_cond1_n240[[i]] <- tibble(cfi = cfi,
                                     rmsea = rmsea,
                                     srmr = srmr,
                                     conv = conv,
                                     c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                     c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                     c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond1_n240)[[i]] <- names(results_cond1_n240)[[i]]
}

mgcfa_output1_cond1_n240 <- bind_rows(modelfit_cond1_n240) 

mgcfa_output1_cond1_n240 <- mgcfa_output1_cond1_n240 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_cond1_n240, file = here("./sem/mgcfa/mgcfa_cond1_n240_output.csv"))

mgcfa_output1_cond1_n240 <- read_csv(file = here("./sem/mgcfa/mgcfa_cond1_n240_output.csv"))

mgcfa_simulated_cond1_n240 <- mgcfa_output1_cond1_n240 |>
  filter(row_number() <= 10000)

convergerate_cond1_n240 <- mgcfa_simulated_cond1_n240 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_cond1_n240))

write_csv(convergerate_cond1_n240, file = here("./sem/mgcfa/convergerate_cond1_n240.csv"))

mgcfa_converged_cond1_n240 <- mgcfa_output1_cond1_n240 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_cond1_n240, file = 
            here("./sem/mgcfa/mgcfa_converged_cond1_n240_output.csv"))

mgcfa_cond1_n240_summary <- mgcfa_converged_cond1_n240 |>
  mutate(bias_c1_est = c1_est - (-0.4),
         bias_c2_est = c2_est - (-0.2),
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est/(-0.4),
         rel_bias_c2_est = bias_c2_est/(-0.2),
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_cond1_n240",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se)
  )

# |>
#   mutate(rep_bias_c1 = c1_est - (-0.4),
#          rep_bias_c1_sqrd = (rep_bias_c1)^2,
#          
#          rep_bias_c2 = c2_est - (-0.2),
#          rep_bias_c2_sqrd = (rep_bias_c2)^2,
#          
#          rep_bias_c3 = c3_est - (0),
#          rep_bias_c3_sqrd = (rep_bias_c3)^2) |>
#   summarise(condition = "mgcfae_cond1_n240",
#             c1_avg_est = mean(c1_est),
#             c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
#             c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
#             c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
#             c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
#                                      c1_p < .05 ~ 1)),
#             c1_prop_sig = c1_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c2_avg_est = mean(c2_est),
#             c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
#             c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
#             c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
#             c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
#                                      c2_p < .05 ~ 1)),
#             c2_prop_sig = c2_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c3_avg_est = mean(c3_est),
#             c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
#             c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
#             c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
#             c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
#                                      c3_p < .05 ~ 1)),
#             c3_prop_sig = c3_n_sig/nrow(mgcfa_converged_cond1_n240),
#             cfi_min = min(cfi, na.rm = T),
#             cfi_max = max(cfi, na.rm = T),
#             cfi_avg = mean(cfi, na.rm = T),
#             rmsea_min = min(rmsea, na.rm = T),
#             rmsea_max = max(rmsea, na.rm = T),
#             rmsea_avg = mean(rmsea, na.rm = T),
#             srmr_min = min(srmr, na.rm = T),
#             srmr_max = max(srmr, na.rm = T),
#             srmr_avg = mean(srmr, na.rm = T),
#             converged = sum(case_when(conv == "TRUE" ~ 1,
#                                       conv == "FALSE" ~ 0)),
#             conv_prop = converged/nrow(mgcfa_converged_cond1_n240),
#             
#             n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
#                                          cfi < 0.9 ~ 0)),
#             prop_accept_cfi = n_accept_cfi/10000,
#             n_accept_dyn_cfi = sum(case_when(cfi >= 0.989 ~ 1,
#                                              cfi < 0.989 ~ 0)),
#             prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
#             
#             n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
#                                            rmsea > 0.08 ~ 0)),
#             prop_accept_rmsea = n_accept_rmsea/10000,
#             n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.093 ~ 1,
#                                                rmsea > 0.093 ~ 0)),
#             prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
#             
#             n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
#                                           srmr > 0.08 ~ 0)),
#             prop_accept_srmr = n_accept_srmr/10000,
#             n_accept_dyn_srmr = sum(case_when(srmr <= 0.019 ~ 1,
#                                                srmr > 0.019 ~ 0)),
#             prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
#             
#             mse_c1 = format(mean(rep_bias_c1_sqrd)/10000, scientific = F),
#             mse_c2 = format(mean(rep_bias_c2_sqrd)/10000, scientific = F),
#             mse_c3 = format(mean(rep_bias_c3_sqrd)/1000, scientific = F))

view(mgcfa_cond1_n240_summary)

write_csv(mgcfa_cond1_n240_summary, file = here("./sem/mgcfa/mgcfa_cond1_n240_summary.csv"))

### ---- Null Model ----

fun_mgcfa <- function(nullcond1_n240_data_list){
  fit = sem(model = mgcfae_model,
            data = nullcond1_n240_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "nullcond1_n240_data_list"

results_nullcond1_n240 <- lapply(nullcond1_n240_data_list, fun_mgcfa)

names(results_nullcond1_n240) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_nullcond1_n240 <- list() # initialize

for (i in 1:length(results_nullcond1_n240)) {
  c1_est <- results_nullcond1_n240[[i]]$summary$pe$est[57]
  c1_se <- results_nullcond1_n240[[i]]$summary$pe$se[57]
  c1_z <- results_nullcond1_n240[[i]]$summary$pe$z[57]
  c1_p <- format(results_nullcond1_n240[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_nullcond1_n240[[i]]$summary$pe$est[58]
  c2_se <- results_nullcond1_n240[[i]]$summary$pe$se[58]
  c2_z <- results_nullcond1_n240[[i]]$summary$pe$z[58]
  c2_p <- format(results_nullcond1_n240[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_nullcond1_n240[[i]]$summary$pe$est[59]
  c3_se <- results_nullcond1_n240[[i]]$summary$pe$se[59]
  c3_z <- results_nullcond1_n240[[i]]$summary$pe$z[59]
  c3_p <- format(results_nullcond1_n240[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_nullcond1_n240[[i]]$summary$fit[17]
  rmsea <- results_nullcond1_n240[[i]]$summary$fit[31]
  srmr <- results_nullcond1_n240[[i]]$summary$fit[49]
  conv <- results_nullcond1_n240[[i]]$summary$header$optim.converged[1]
  
  modelfit_nullcond1_n240[[i]] <- tibble(cfi = cfi,
                                         rmsea = rmsea,
                                         srmr = srmr,
                                         conv = conv,
                                         c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                         c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                         c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond1_n240)[[i]] <- names(results_cond1_n240)[[i]]
}

mgcfa_output1_nullcond1_n240 <- bind_rows(modelfit_nullcond1_n240) 

mgcfa_output1_nullcond1_n240 <- mgcfa_output1_nullcond1_n240 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_nullcond1_n240, file = here("./sem/mgcfa/mgcfa_nullcond1_n240_output.csv"))

mgcfa_nullcond1_n240_output <- read_csv(file = here("./sem/mgcfa/mgcfa_nullcond1_n240_output.csv"))

mgcfa_simulated_nullcond1_n240 <- mgcfa_nullcond1_n240_output |>
  filter(row_number() <= 10000)

convergerate_nullcond1_n240 <- mgcfa_simulated_nullcond1_n240 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_nullcond1_n240))

write_csv(convergerate_nullcond1_n240, file = here("./sem/mgcfa/convergerate_nullcond1_n240.csv"))

mgcfa_converged_nullcond1_n240 <- mgcfa_nullcond1_n240_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_nullcond1_n240, file = 
            here("./sem/mgcfa/mgcfa_converged_nullcond1_n240_output.csv"))

mgcfa_nullcond1_n240_summary <- mgcfa_converged_nullcond1_n240 |>
  mutate(bias_c1_est = c1_est - 0,
         bias_c2_est = c2_est - 0,
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_nullcond1_n240",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se))

view(mgcfa_nullcond1_n240_summary)

write_csv(mgcfa_nullcond1_n240_summary, file = here("./sem/mgcfa/mgcfa_nullcond1_n240_summary.csv"))

## ---- Condition 2 ---- 
### ---- Significance Model ----

fun_mgcfa <- function(cond2_n240_data_list){
  fit = sem(model = mgcfae_model,
            data = cond2_n240_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "cond2_n240_data_list"

results_cond2_n240 <- lapply(cond2_n240_data_list, fun_mgcfa)

names(results_cond2_n240) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_cond2_n240 <- list() # initialize

for (i in 1:length(results_cond2_n240)) {
  c1_est <- results_cond2_n240[[i]]$summary$pe$est[57]
  c1_se <- results_cond2_n240[[i]]$summary$pe$se[57]
  c1_z <- results_cond2_n240[[i]]$summary$pe$z[57]
  c1_p <- format(results_cond2_n240[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_cond2_n240[[i]]$summary$pe$est[58]
  c2_se <- results_cond2_n240[[i]]$summary$pe$se[58]
  c2_z <- results_cond2_n240[[i]]$summary$pe$z[58]
  c2_p <- format(results_cond2_n240[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_cond2_n240[[i]]$summary$pe$est[59]
  c3_se <- results_cond2_n240[[i]]$summary$pe$se[59]
  c3_z <- results_cond2_n240[[i]]$summary$pe$z[59]
  c3_p <- format(results_cond2_n240[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_cond2_n240[[i]]$summary$fit[17]
  rmsea <- results_cond2_n240[[i]]$summary$fit[31]
  srmr <- results_cond2_n240[[i]]$summary$fit[49]
  conv <- results_cond2_n240[[i]]$summary$header$optim.converged[1]
  
  modelfit_cond2_n240[[i]] <- tibble(cfi = cfi,
                                     rmsea = rmsea,
                                     srmr = srmr,
                                     conv = conv,
                                     c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                     c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                     c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p,)
  
  #names(output1_cond1_n240)[[i]] <- names(results_cond1_n240)[[i]]
}

mgcfa_output1_cond2_n240 <- bind_rows(modelfit_cond2_n240) |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_cond2_n240, file = here("./sem/mgcfa/mgcfa_cond2_n240_output.csv"))

mgcfa_cond2_n240_output <- read_csv(file = here("./sem/mgcfa/mgcfa_cond2_n240_output.csv"))

mgcfa_simulated_cond2_n240 <- mgcfa_cond2_n240_output |>
  filter(row_number() <= 10000)

convergerate_cond2_n240 <- mgcfa_simulated_cond2_n240 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_cond2_n240))

write_csv(convergerate_cond2_n240, file = here("./sem/mgcfa/convergerate_cond2_n240.csv"))

mgcfa_converged_cond2_n240 <- mgcfa_cond2_n240_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_cond2_n240, 
          file = here("./sem/mgcfa/mgcfa_converged_cond2_n240_output.csv"))

mgcfa_cond2_n240_summary <- mgcfa_converged_cond2_n240 |>
  mutate(bias_c1_est = c1_est - (-0.4),
         bias_c2_est = c2_est - (-0.2),
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est/(-0.4),
         rel_bias_c2_est = bias_c2_est/(-0.2),
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_cond2_n240",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se)
  )
# 
# |>
#   mutate(rep_bias_c1 = c1_est - (-0.4),
#          rep_bias_c1_sqrd = (rep_bias_c1)^2,
#          
#          rep_bias_c2 = c2_est - (-0.2),
#          rep_bias_c2_sqrd = (rep_bias_c2)^2,
#          
#          rep_bias_c3 = c3_est - (0),
#          rep_bias_c3_sqrd = (rep_bias_c3)^2) |>
#   summarise(condition = "mgcfae_cond2_n240",
#             c1_avg_est = mean(c1_est),
#             c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
#             c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
#             c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
#             c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
#                                      c1_p < .05 ~ 1)),
#             c1_prop_sig = c1_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c2_avg_est = mean(c2_est),
#             c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
#             c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
#             c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
#             c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
#                                      c2_p < .05 ~ 1)),
#             c2_prop_sig = c2_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c3_avg_est = mean(c3_est),
#             c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
#             c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
#             c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
#             c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
#                                      c3_p < .05 ~ 1)),
#             c3_prop_sig = c3_n_sig/nrow(mgcfa_converged_cond1_n240),
#             cfi_min = min(cfi, na.rm = T),
#             cfi_max = max(cfi, na.rm = T),
#             cfi_avg = mean(cfi, na.rm = T),
#             rmsea_min = min(rmsea, na.rm = T),
#             rmsea_max = max(rmsea, na.rm = T),
#             rmsea_avg = mean(rmsea, na.rm = T),
#             srmr_min = min(srmr, na.rm = T),
#             srmr_max = max(srmr, na.rm = T),
#             srmr_avg = mean(srmr, na.rm = T),
#             converged = sum(case_when(conv == "TRUE" ~ 1,
#                                       conv == "FALSE" ~ 0)),
#             conv_prop = converged/nrow(mgcfa_converged_cond1_n240),
#             
#             n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
#                                          cfi < 0.9 ~ 0)),
#             prop_accept_cfi = n_accept_cfi/10000,
#             n_accept_dyn_cfi = sum(case_when(cfi >= 0.989 ~ 1,
#                                              cfi < 0.989 ~ 0)),
#             prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
#             
#             n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
#                                            rmsea > 0.08 ~ 0)),
#             prop_accept_rmsea = n_accept_rmsea/10000,
#             n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.093 ~ 1,
#                                                rmsea > 0.093 ~ 0)),
#             prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
#             
#             n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
#                                           srmr > 0.08 ~ 0)),
#             prop_accept_srmr = n_accept_srmr/10000,
#             n_accept_dyn_srmr = sum(case_when(srmr <= 0.019 ~ 1,
#                                               srmr > 0.019 ~ 0)),
#             prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
#             
#             mse_c1 = format(mean(rep_bias_c1_sqrd)/10000, scientific = F),
#             mse_c2 = format(mean(rep_bias_c2_sqrd)/10000, scientific = F),
#             mse_c3 = format(mean(rep_bias_c3_sqrd)/1000, scientific = F))

view(mgcfa_cond2_n240_summary)

write_csv(mgcfa_cond2_n240_summary, file = here("./sem/mgcfa/mgcfa_cond2_n240_summary.csv"))

### ---- Null Model ----

fun_mgcfa <- function(nullcond2_n240_data_list){
  fit = sem(model = mgcfae_model,
            data = nullcond2_n240_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "nullcond2_n240_data_list"

results_nullcond2_n240 <- lapply(nullcond2_n240_data_list, fun_mgcfa)

names(results_nullcond2_n240) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_nullcond2_n240 <- list() # initialize

for (i in 1:length(results_nullcond2_n240)) {
  c1_est <- results_nullcond2_n240[[i]]$summary$pe$est[57]
  c1_se <- results_nullcond2_n240[[i]]$summary$pe$se[57]
  c1_z <- results_nullcond2_n240[[i]]$summary$pe$z[57]
  c1_p <- format(results_nullcond2_n240[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_nullcond2_n240[[i]]$summary$pe$est[58]
  c2_se <- results_nullcond2_n240[[i]]$summary$pe$se[58]
  c2_z <- results_nullcond2_n240[[i]]$summary$pe$z[58]
  c2_p <- format(results_nullcond2_n240[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_nullcond2_n240[[i]]$summary$pe$est[59]
  c3_se <- results_nullcond2_n240[[i]]$summary$pe$se[59]
  c3_z <- results_nullcond2_n240[[i]]$summary$pe$z[59]
  c3_p <- format(results_nullcond2_n240[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_nullcond2_n240[[i]]$summary$fit[17]
  rmsea <- results_nullcond2_n240[[i]]$summary$fit[31]
  srmr <- results_nullcond2_n240[[i]]$summary$fit[49]
  conv <- results_nullcond2_n240[[i]]$summary$header$optim.converged[1]
  
  modelfit_nullcond2_n240[[i]] <- tibble(cfi = cfi,
                                      rmsea = rmsea,
                                      srmr = srmr,
                                      conv = conv,
                                      c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                      c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                      c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond1_n240)[[i]] <- names(results_cond1_n240)[[i]]
}

mgcfa_output1_nullcond2_n240 <- bind_rows(modelfit_nullcond2_n240) 

mgcfa_output1_nullcond2_n240 <- mgcfa_output1_nullcond2_n240 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_nullcond2_n240, file = here("./sem/mgcfa/mgcfa_nullcond2_n240_output.csv"))

mgcfa_nullcond2_n240_output <- read_csv(file = here("./sem/mgcfa/mgcfa_nullcond2_n240_output.csv"))

mgcfa_simulated_nullcond2_n240 <- mgcfa_nullcond2_n240_output |>
  filter(row_number() <= 10000)

convergerate_nullcond2_n240 <- mgcfa_simulated_nullcond2_n240 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_nullcond2_n240))

write_csv(convergerate_nullcond2_n240, file = here("./sem/mgcfa/convergerate_nullcond2_n240.csv"))

mgcfa_converged_nullcond2_n240 <- mgcfa_nullcond2_n240_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_nullcond2_n240, file = 
            here("./sem/mgcfa/mgcfa_converged_nullcond2_n240_output.csv"))

mgcfa_nullcond2_n240_summary <- mgcfa_converged_nullcond2_n240 |>
  mutate(bias_c1_est = c1_est - 0,
         bias_c2_est = c2_est - 0,
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_nullcond2_n240",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se))

view(mgcfa_nullcond2_n240_summary)

write_csv(mgcfa_nullcond2_n240_summary, file = here("./sem/mgcfa/mgcfa_nullcond2_n240_summary.csv"))

## ---- Condition 3 ---- 
### ---- Significance Model ----

fun_mgcfa <- function(cond3_n240_data_list){
  fit = sem(model = mgcfae_model,
            data = cond3_n240_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "cond3_n240_data_list"

results_cond3_n240 <- lapply(cond3_n240_data_list, fun_mgcfa)

names(results_cond3_n240) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_cond3_n240 <- list() # initialize

for (i in 1:length(results_cond3_n240)) {
  c1_est <- results_cond3_n240[[i]]$summary$pe$est[57]
  c1_se <- results_cond3_n240[[i]]$summary$pe$se[57]
  c1_z <- results_cond3_n240[[i]]$summary$pe$z[57]
  c1_p <- format(results_cond3_n240[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_cond3_n240[[i]]$summary$pe$est[58]
  c2_se <- results_cond3_n240[[i]]$summary$pe$se[58]
  c2_z <- results_cond3_n240[[i]]$summary$pe$z[58]
  c2_p <- format(results_cond3_n240[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_cond3_n240[[i]]$summary$pe$est[59]
  c3_se <- results_cond3_n240[[i]]$summary$pe$se[59]
  c3_z <- results_cond3_n240[[i]]$summary$pe$z[59]
  c3_p <- format(results_cond3_n240[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_cond3_n240[[i]]$summary$fit[17]
  rmsea <- results_cond3_n240[[i]]$summary$fit[31]
  srmr <- results_cond3_n240[[i]]$summary$fit[49]
  conv <- results_cond3_n240[[i]]$summary$header$optim.converged[1]
  
  modelfit_cond3_n240[[i]] <- tibble(cfi = cfi,
                                     rmsea = rmsea,
                                     srmr = srmr,
                                     conv = conv,
                                     c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                     c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                     c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p,)
  
  #names(output1_cond1_n240)[[i]] <- names(results_cond1_n240)[[i]]
}

mgcfa_output1_cond3_n240 <- bind_rows(modelfit_cond3_n240) |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_cond3_n240, file = here("./sem/mgcfa/mgcfa_cond3_n240_output.csv"))

mgcfa_cond3_n240_output <- read_csv(file = here("./sem/mgcfa/mgcfa_cond3_n240_output.csv"))

mgcfa_simulated_cond3_n240 <- mgcfa_cond3_n240_output |>
  filter(row_number() <= 10000)

convergerate_cond3_n240 <- mgcfa_simulated_cond3_n240 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_cond3_n240))

write_csv(convergerate_cond3_n240, file = here("./sem/mgcfa/convergerate_cond3_n240.csv"))

mgcfa_converged_cond3_n240 <- mgcfa_cond3_n240_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_cond3_n240, 
          file = here("./sem/mgcfa/mgcfa_converged_cond3_n240_output.csv"))

mgcfa_cond3_n240_summary <- mgcfa_converged_cond3_n240 |>
  mutate(bias_c1_est = c1_est - (-0.4),
         bias_c2_est = c2_est - (-0.2),
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est/(-0.4),
         rel_bias_c2_est = bias_c2_est/(-0.2),
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_cond3_n240",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se)
  )

# |>
#   mutate(rep_bias_c1 = c1_est - (-0.4),
#          rep_bias_c1_sqrd = (rep_bias_c1)^2,
#          
#          rep_bias_c2 = c2_est - (-0.2),
#          rep_bias_c2_sqrd = (rep_bias_c2)^2,
#          
#          rep_bias_c3 = c3_est - (0),
#          rep_bias_c3_sqrd = (rep_bias_c3)^2) |>
#   summarise(condition = "mgcfae_cond3_n240",
#             c1_avg_est = mean(c1_est),
#             c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
#             c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
#             c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
#             c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
#                                      c1_p < .05 ~ 1)),
#             c1_prop_sig = c1_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c2_avg_est = mean(c2_est),
#             c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
#             c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
#             c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
#             c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
#                                      c2_p < .05 ~ 1)),
#             c2_prop_sig = c2_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c3_avg_est = mean(c3_est),
#             c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
#             c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
#             c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
#             c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
#                                      c3_p < .05 ~ 1)),
#             c3_prop_sig = c3_n_sig/nrow(mgcfa_converged_cond1_n240),
#             cfi_min = min(cfi, na.rm = T),
#             cfi_max = max(cfi, na.rm = T),
#             cfi_avg = mean(cfi, na.rm = T),
#             rmsea_min = min(rmsea, na.rm = T),
#             rmsea_max = max(rmsea, na.rm = T),
#             rmsea_avg = mean(rmsea, na.rm = T),
#             srmr_min = min(srmr, na.rm = T),
#             srmr_max = max(srmr, na.rm = T),
#             srmr_avg = mean(srmr, na.rm = T),
#             converged = sum(case_when(conv == "TRUE" ~ 1,
#                                       conv == "FALSE" ~ 0)),
#             conv_prop = converged/nrow(mgcfa_converged_cond1_n240),
#             
#             n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
#                                          cfi < 0.9 ~ 0)),
#             prop_accept_cfi = n_accept_cfi/10000,
#             n_accept_dyn_cfi = sum(case_when(cfi >= 0.989 ~ 1,
#                                              cfi < 0.989 ~ 0)),
#             prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
#             
#             n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
#                                            rmsea > 0.08 ~ 0)),
#             prop_accept_rmsea = n_accept_rmsea/10000,
#             n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.093 ~ 1,
#                                                rmsea > 0.093 ~ 0)),
#             prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
#             
#             n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
#                                           srmr > 0.08 ~ 0)),
#             prop_accept_srmr = n_accept_srmr/10000,
#             n_accept_dyn_srmr = sum(case_when(srmr <= 0.019 ~ 1,
#                                               srmr > 0.019 ~ 0)),
#             prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
#             
#             mse_c1 = format(mean(rep_bias_c1_sqrd)/10000, scientific = F),
#             mse_c2 = format(mean(rep_bias_c2_sqrd)/10000, scientific = F),
#             mse_c3 = format(mean(rep_bias_c3_sqrd)/1000, scientific = F))

view(mgcfa_cond3_n240_summary)

write_csv(mgcfa_cond3_n240_summary, file = here("./sem/mgcfa/mgcfa_cond3_n240_summary.csv"))

### ---- Null Model ----

fun_mgcfa <- function(nullcond3_n240_data_list){
  fit = sem(model = mgcfae_model,
            data = nullcond3_n240_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "nullcond3_n240_data_list"

results_nullcond3_n240 <- lapply(nullcond3_n240_data_list, fun_mgcfa)

names(results_nullcond3_n240) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_nullcond3_n240 <- list() # initialize

for (i in 1:length(results_nullcond3_n240)) {
  c1_est <- results_nullcond3_n240[[i]]$summary$pe$est[57]
  c1_se <- results_nullcond3_n240[[i]]$summary$pe$se[57]
  c1_z <- results_nullcond3_n240[[i]]$summary$pe$z[57]
  c1_p <- format(results_nullcond3_n240[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_nullcond3_n240[[i]]$summary$pe$est[58]
  c2_se <- results_nullcond3_n240[[i]]$summary$pe$se[58]
  c2_z <- results_nullcond3_n240[[i]]$summary$pe$z[58]
  c2_p <- format(results_nullcond3_n240[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_nullcond3_n240[[i]]$summary$pe$est[59]
  c3_se <- results_nullcond3_n240[[i]]$summary$pe$se[59]
  c3_z <- results_nullcond3_n240[[i]]$summary$pe$z[59]
  c3_p <- format(results_nullcond3_n240[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_nullcond3_n240[[i]]$summary$fit[17]
  rmsea <- results_nullcond3_n240[[i]]$summary$fit[31]
  srmr <- results_nullcond3_n240[[i]]$summary$fit[49]
  conv <- results_nullcond3_n240[[i]]$summary$header$optim.converged[1]
  
  modelfit_nullcond3_n240[[i]] <- tibble(cfi = cfi,
                                         rmsea = rmsea,
                                         srmr = srmr,
                                         conv = conv,
                                         c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                         c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                         c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond1_n240)[[i]] <- names(results_cond1_n240)[[i]]
}

mgcfa_output1_nullcond3_n240 <- bind_rows(modelfit_nullcond3_n240) 

mgcfa_output1_nullcond3_n240 <- mgcfa_output1_nullcond3_n240 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_nullcond3_n240, file = here("./sem/mgcfa/mgcfa_nullcond3_n240_output.csv"))

mgcfa_nullcond3_n240_output <- read_csv(file = here("./sem/mgcfa/mgcfa_nullcond3_n240_output.csv"))

mgcfa_simulated_nullcond3_n240 <- mgcfa_nullcond3_n240_output |>
  filter(row_number() <= 10000)

convergerate_nullcond3_n240 <- mgcfa_simulated_nullcond3_n240 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_nullcond3_n240))

write_csv(convergerate_nullcond3_n240, file = here("./sem/mgcfa/convergerate_nullcond3_n240.csv"))

mgcfa_converged_nullcond3_n240 <- mgcfa_nullcond3_n240_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_nullcond3_n240, file = here("./sem/mgcfa/mgcfa_converged_nullcond3_n240_output.csv"))

mgcfa_nullcond3_n240_summary <- mgcfa_converged_nullcond3_n240 |>
  mutate(bias_c1_est = c1_est - 0,
         bias_c2_est = c2_est - 0,
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_nullcond3_n240",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se))

view(mgcfa_nullcond3_n240_summary)

write_csv(mgcfa_nullcond3_n240_summary, file = here("./sem/mgcfa/mgcfa_nullcond3_n240_summary.csv"))

# ---- N = 480 ---- 
## ---- Condition 1 ---- 
### ---- Significance Model ----

fun_mgcfa <- function(cond1_n480_data_list){
  fit = sem(model = mgcfae_model,
            data = cond1_n480_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "cond1_n480_data_list"

results_cond1_n480 <- lapply(cond1_n480_data_list, fun_mgcfa)

names(results_cond1_n480) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_cond1_n480 <- list() # initialize

for (i in 1:length(results_cond1_n480)) {
  c1_est <- results_cond1_n480[[i]]$summary$pe$est[57]
  c1_se <- results_cond1_n480[[i]]$summary$pe$se[57]
  c1_z <- results_cond1_n480[[i]]$summary$pe$z[57]
  c1_p <- format(results_cond1_n480[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_cond1_n480[[i]]$summary$pe$est[58]
  c2_se <- results_cond1_n480[[i]]$summary$pe$se[58]
  c2_z <- results_cond1_n480[[i]]$summary$pe$z[58]
  c2_p <- format(results_cond1_n480[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_cond1_n480[[i]]$summary$pe$est[59]
  c3_se <- results_cond1_n480[[i]]$summary$pe$se[59]
  c3_z <- results_cond1_n480[[i]]$summary$pe$z[59]
  c3_p <- format(results_cond1_n480[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_cond1_n480[[i]]$summary$fit[17]
  rmsea <- results_cond1_n480[[i]]$summary$fit[31]
  srmr <- results_cond1_n480[[i]]$summary$fit[49]
  conv <- results_cond1_n480[[i]]$summary$header$optim.converged[1]
  
  modelfit_cond1_n480[[i]] <- tibble(cfi = cfi,
                                     rmsea = rmsea,
                                     srmr = srmr,
                                     conv = conv,
                                     c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                     c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                     c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond1_n240)[[i]] <- names(results_cond1_n240)[[i]]
}

mgcfa_output1_cond1_n480 <- bind_rows(modelfit_cond1_n480) 

mgcfa_output1_cond1_n480 <- mgcfa_output1_cond1_n480 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_cond1_n480, file = here("./sem/mgcfa/mgcfa_cond1_n480_output.csv"))

mgcfa_cond1_n480_output <- read_csv(file = here("./sem/mgcfa/mgcfa_cond1_n480_output.csv"))

mgcfa_simulated_cond1_n480 <- mgcfa_cond1_n480_output |>
  filter(row_number() <= 10000)

convergerate_cond1_n480 <- mgcfa_simulated_cond1_n480 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_cond1_n480))

write_csv(convergerate_cond1_n480, file = here("./sem/mgcfa/convergerate_cond1_n480.csv"))

mgcfa_converged_cond1_n480 <- mgcfa_cond1_n480_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_cond1_n480, file = 
            here("./sem/mgcfa/mgcfa_converged_cond1_n480_output.csv"))

mgcfa_cond1_n480_summary <- mgcfa_converged_cond1_n480 |>
  mutate(bias_c1_est = c1_est - (-0.4),
         bias_c2_est = c2_est - (-0.2),
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est/(-0.4),
         rel_bias_c2_est = bias_c2_est/(-0.2),
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_cond1_n480",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se)
  )

# |>
#   mutate(rep_bias_c1 = c1_est - (-0.4),
#          rep_bias_c1_sqrd = (rep_bias_c1)^2,
#          
#          rep_bias_c2 = c2_est - (-0.2),
#          rep_bias_c2_sqrd = (rep_bias_c2)^2,
#          
#          rep_bias_c3 = c3_est - (0),
#          rep_bias_c3_sqrd = (rep_bias_c3)^2) |>
#   summarise(condition = "mgcfae_cond1_n480",
#             c1_avg_est = mean(c1_est),
#             c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
#             c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
#             c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
#             c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
#                                      c1_p < .05 ~ 1)),
#             c1_prop_sig = c1_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c2_avg_est = mean(c2_est),
#             c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
#             c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
#             c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
#             c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
#                                      c2_p < .05 ~ 1)),
#             c2_prop_sig = c2_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c3_avg_est = mean(c3_est),
#             c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
#             c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
#             c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
#             c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
#                                      c3_p < .05 ~ 1)),
#             c3_prop_sig = c3_n_sig/nrow(mgcfa_converged_cond1_n240),
#             cfi_min = min(cfi, na.rm = T),
#             cfi_max = max(cfi, na.rm = T),
#             cfi_avg = mean(cfi, na.rm = T),
#             rmsea_min = min(rmsea, na.rm = T),
#             rmsea_max = max(rmsea, na.rm = T),
#             rmsea_avg = mean(rmsea, na.rm = T),
#             srmr_min = min(srmr, na.rm = T),
#             srmr_max = max(srmr, na.rm = T),
#             srmr_avg = mean(srmr, na.rm = T),
#             converged = sum(case_when(conv == "TRUE" ~ 1,
#                                       conv == "FALSE" ~ 0)),
#             conv_prop = converged/nrow(mgcfa_converged_cond1_n240),
#             
#             n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
#                                          cfi < 0.9 ~ 0)),
#             prop_accept_cfi = n_accept_cfi/10000,
#             n_accept_dyn_cfi = sum(case_when(cfi >= 0.989 ~ 1,
#                                              cfi < 0.989 ~ 0)),
#             prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
#             
#             n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
#                                            rmsea > 0.08 ~ 0)),
#             prop_accept_rmsea = n_accept_rmsea/10000,
#             n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.093 ~ 1,
#                                                rmsea > 0.093 ~ 0)),
#             prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
#             
#             n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
#                                           srmr > 0.08 ~ 0)),
#             prop_accept_srmr = n_accept_srmr/10000,
#             n_accept_dyn_srmr = sum(case_when(srmr <= 0.019 ~ 1,
#                                               srmr > 0.019 ~ 0)),
#             prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
#             
#             mse_c1 = format(mean(rep_bias_c1_sqrd)/10000, scientific = F),
#             mse_c2 = format(mean(rep_bias_c2_sqrd)/10000, scientific = F),
#             mse_c3 = format(mean(rep_bias_c3_sqrd)/1000, scientific = F))

view(mgcfa_cond1_n480_summary)

write_csv(mgcfa_cond1_n480_summary, file = here("./sem/mgcfa/mgcfa_cond1_n480_summary.csv"))

### ---- Null Model ----

fun_mgcfa <- function(nullcond1_n480_data_list){
  fit = sem(model = mgcfae_model,
            data = nullcond1_n480_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "nullcond1_n480_data_list"

results_nullcond1_n480 <- lapply(nullcond1_n480_data_list, fun_mgcfa)

names(results_nullcond1_n480) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_nullcond1_n480 <- list() # initialize

for (i in 1:length(results_nullcond1_n480)) {
  c1_est <- results_nullcond1_n480[[i]]$summary$pe$est[57]
  c1_se <- results_nullcond1_n480[[i]]$summary$pe$se[57]
  c1_z <- results_nullcond1_n480[[i]]$summary$pe$z[57]
  c1_p <- format(results_nullcond1_n480[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_nullcond1_n480[[i]]$summary$pe$est[58]
  c2_se <- results_nullcond1_n480[[i]]$summary$pe$se[58]
  c2_z <- results_nullcond1_n480[[i]]$summary$pe$z[58]
  c2_p <- format(results_nullcond1_n480[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_nullcond1_n480[[i]]$summary$pe$est[59]
  c3_se <- results_nullcond1_n480[[i]]$summary$pe$se[59]
  c3_z <- results_nullcond1_n480[[i]]$summary$pe$z[59]
  c3_p <- format(results_nullcond1_n480[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_nullcond1_n480[[i]]$summary$fit[17]
  rmsea <- results_nullcond1_n480[[i]]$summary$fit[31]
  srmr <- results_nullcond1_n480[[i]]$summary$fit[49]
  conv <- results_nullcond1_n480[[i]]$summary$header$optim.converged[1]
  
  modelfit_nullcond1_n480[[i]] <- tibble(cfi = cfi,
                                         rmsea = rmsea,
                                         srmr = srmr,
                                         conv = conv,
                                         c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                         c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                         c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond1_n240)[[i]] <- names(results_cond1_n240)[[i]]
}

mgcfa_output1_nullcond1_n480 <- bind_rows(modelfit_nullcond1_n480) 

mgcfa_output1_nullcond1_n480 <- mgcfa_output1_nullcond1_n480 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_nullcond1_n480, file = here("./sem/mgcfa/mgcfa_nullcond1_n480_output.csv"))

mgcfa_nullcond1_n480_output <- read_csv(file = here("./sem/mgcfa/mgcfa_nullcond1_n480_output.csv"))

mgcfa_simulated_nullcond1_n480 <- mgcfa_nullcond1_n480_output |>
  filter(row_number() <= 10000)

convergerate_nullcond1_n480 <- mgcfa_simulated_nullcond1_n480 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_nullcond1_n480))

write_csv(convergerate_nullcond1_n480, file = here("./sem/mgcfa/convergerate_nullcond1_n480.csv"))

mgcfa_converged_nullcond1_n480 <- mgcfa_nullcond1_n480_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_nullcond1_n480, file = 
            here("./sem/mgcfa/mgcfa_converged_nullcond1_n480_output.csv"))

mgcfa_nullcond1_n480_summary <- mgcfa_converged_nullcond1_n480 |>
  mutate(bias_c1_est = c1_est - 0,
         bias_c2_est = c2_est - 0,
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_nullcond1_n480",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se))

view(mgcfa_nullcond1_n480_summary)

write_csv(mgcfa_nullcond1_n480_summary, file = here("./sem/mgcfa/mgcfa_nullcond1_n480_summary.csv"))

## ---- Condition 2 ---- 
### ---- Significance Model ----

fun_mgcfa <- function(cond2_n480_data_list){
  fit = sem(model = mgcfae_model,
            data = cond2_n480_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "cond2_n480_data_list"

results_cond2_n480 <- lapply(cond2_n480_data_list, fun_mgcfa)

names(results_cond2_n480) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_cond2_n480 <- list() # initialize

for (i in 1:length(results_cond2_n480)) {
  c1_est <- results_cond2_n480[[i]]$summary$pe$est[57]
  c1_se <- results_cond2_n480[[i]]$summary$pe$se[57]
  c1_z <- results_cond2_n480[[i]]$summary$pe$z[57]
  c1_p <- format(results_cond2_n480[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_cond2_n480[[i]]$summary$pe$est[58]
  c2_se <- results_cond2_n480[[i]]$summary$pe$se[58]
  c2_z <- results_cond2_n480[[i]]$summary$pe$z[58]
  c2_p <- format(results_cond2_n480[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_cond2_n480[[i]]$summary$pe$est[59]
  c3_se <- results_cond2_n480[[i]]$summary$pe$se[59]
  c3_z <- results_cond2_n480[[i]]$summary$pe$z[59]
  c3_p <- format(results_cond2_n480[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_cond2_n480[[i]]$summary$fit[17]
  rmsea <- results_cond2_n480[[i]]$summary$fit[31]
  srmr <- results_cond2_n480[[i]]$summary$fit[49]
  conv <- results_cond2_n480[[i]]$summary$header$optim.converged[1]
  
  modelfit_cond2_n480[[i]] <- tibble(cfi = cfi,
                                     rmsea = rmsea,
                                     srmr = srmr,
                                     conv = conv,
                                     c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                     c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                     c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond2_n240)[[i]] <- names(results_cond2_n240)[[i]]
}

mgcfa_output1_cond2_n480 <- bind_rows(modelfit_cond2_n480) 

mgcfa_output1_cond2_n480 <- mgcfa_output1_cond2_n480 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_cond2_n480, file = here("./sem/mgcfa/mgcfa_cond2_n480_output.csv"))

mgcfa_cond2_n480_output <- read_csv(file = here("./sem/mgcfa/mgcfa_cond2_n480_output.csv"))

mgcfa_simulated_cond2_n480 <- mgcfa_cond2_n480_output |>
  filter(row_number() <= 10000)

convergerate_cond2_n480 <- mgcfa_simulated_cond2_n480 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_cond2_n480))

write_csv(convergerate_cond2_n480, file = here("./sem/mgcfa/convergerate_cond2_n480.csv"))

mgcfa_converged_cond2_n480 <- mgcfa_cond2_n480_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_cond2_n480, file = 
            here("./sem/mgcfa/mgcfa_converged_cond2_n480_output.csv"))

mgcfa_cond2_n480_summary <- mgcfa_converged_cond2_n480 |>
  mutate(bias_c1_est = c1_est - (-0.4),
         bias_c2_est = c2_est - (-0.2),
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est/(-0.4),
         rel_bias_c2_est = bias_c2_est/(-0.2),
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_cond2_n480",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se)
  )

# |>
#   mutate(rep_bias_c1 = c1_est - (-0.4),
#          rep_bias_c1_sqrd = (rep_bias_c1)^2,
#          
#          rep_bias_c2 = c2_est - (-0.2),
#          rep_bias_c2_sqrd = (rep_bias_c2)^2,
#          
#          rep_bias_c3 = c3_est - (0),
#          rep_bias_c3_sqrd = (rep_bias_c3)^2) |>
#   summarise(condition = "mgcfae_cond2_n480",
#             c1_avg_est = mean(c1_est),
#             c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
#             c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
#             c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
#             c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
#                                      c1_p < .05 ~ 1)),
#             c1_prop_sig = c1_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c2_avg_est = mean(c2_est),
#             c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
#             c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
#             c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
#             c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
#                                      c2_p < .05 ~ 1)),
#             c2_prop_sig = c2_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c3_avg_est = mean(c3_est),
#             c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
#             c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
#             c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
#             c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
#                                      c3_p < .05 ~ 1)),
#             c3_prop_sig = c3_n_sig/nrow(mgcfa_converged_cond1_n240),
#             cfi_min = min(cfi, na.rm = T),
#             cfi_max = max(cfi, na.rm = T),
#             cfi_avg = mean(cfi, na.rm = T),
#             rmsea_min = min(rmsea, na.rm = T),
#             rmsea_max = max(rmsea, na.rm = T),
#             rmsea_avg = mean(rmsea, na.rm = T),
#             srmr_min = min(srmr, na.rm = T),
#             srmr_max = max(srmr, na.rm = T),
#             srmr_avg = mean(srmr, na.rm = T),
#             converged = sum(case_when(conv == "TRUE" ~ 1,
#                                       conv == "FALSE" ~ 0)),
#             conv_prop = converged/nrow(mgcfa_converged_cond1_n240),
#             
#             n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
#                                          cfi < 0.9 ~ 0)),
#             prop_accept_cfi = n_accept_cfi/10000,
#             n_accept_dyn_cfi = sum(case_when(cfi >= 0.989 ~ 1,
#                                              cfi < 0.989 ~ 0)),
#             prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
#             
#             n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
#                                            rmsea > 0.08 ~ 0)),
#             prop_accept_rmsea = n_accept_rmsea/10000,
#             n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.093 ~ 1,
#                                                rmsea > 0.093 ~ 0)),
#             prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
#             
#             n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
#                                           srmr > 0.08 ~ 0)),
#             prop_accept_srmr = n_accept_srmr/10000,
#             n_accept_dyn_srmr = sum(case_when(srmr <= 0.019 ~ 1,
#                                               srmr > 0.019 ~ 0)),
#             prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
#             
#             mse_c1 = format(mean(rep_bias_c1_sqrd)/10000, scientific = F),
#             mse_c2 = format(mean(rep_bias_c2_sqrd)/10000, scientific = F),
#             mse_c3 = format(mean(rep_bias_c3_sqrd)/1000, scientific = F))

view(mgcfa_cond2_n480_summary)

write_csv(mgcfa_cond2_n480_summary, file = here("./sem/mgcfa/mgcfa_cond2_n480_summary.csv"))

### ---- Null Model ----

fun_mgcfa <- function(nullcond2_n480_data_list){
  fit = sem(model = mgcfae_model,
            data = nullcond2_n480_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "nullcond2_n480_data_list"

results_nullcond2_n480 <- lapply(nullcond2_n480_data_list, fun_mgcfa)

names(results_nullcond2_n480) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_nullcond2_n480 <- list() # initialize

for (i in 1:length(results_nullcond2_n480)) {
  c1_est <- results_nullcond2_n480[[i]]$summary$pe$est[57]
  c1_se <- results_nullcond2_n480[[i]]$summary$pe$se[57]
  c1_z <- results_nullcond2_n480[[i]]$summary$pe$z[57]
  c1_p <- format(results_nullcond2_n480[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_nullcond2_n480[[i]]$summary$pe$est[58]
  c2_se <- results_nullcond2_n480[[i]]$summary$pe$se[58]
  c2_z <- results_nullcond2_n480[[i]]$summary$pe$z[58]
  c2_p <- format(results_nullcond2_n480[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_nullcond2_n480[[i]]$summary$pe$est[59]
  c3_se <- results_nullcond2_n480[[i]]$summary$pe$se[59]
  c3_z <- results_nullcond2_n480[[i]]$summary$pe$z[59]
  c3_p <- format(results_nullcond2_n480[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_nullcond2_n480[[i]]$summary$fit[17]
  rmsea <- results_nullcond2_n480[[i]]$summary$fit[31]
  srmr <- results_nullcond2_n480[[i]]$summary$fit[49]
  conv <- results_nullcond2_n480[[i]]$summary$header$optim.converged[1]
  
  modelfit_nullcond2_n480[[i]] <- tibble(cfi = cfi,
                                         rmsea = rmsea,
                                         srmr = srmr,
                                         conv = conv,
                                         c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                         c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                         c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond2_n240)[[i]] <- names(results_cond2_n240)[[i]]
}

mgcfa_output1_nullcond2_n480 <- bind_rows(modelfit_nullcond2_n480) 

mgcfa_output1_nullcond2_n480 <- mgcfa_output1_nullcond2_n480 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_nullcond2_n480, file = here("./sem/mgcfa/mgcfa_nullcond2_n480_output.csv"))

mgcfa_nullcond2_n480_output <- read_csv(file = here("./sem/mgcfa/mgcfa_nullcond2_n480_output.csv"))

mgcfa_simulated_nullcond2_n480 <- mgcfa_nullcond2_n480_output |>
  filter(row_number() <= 10000)

convergerate_nullcond2_n480 <- mgcfa_simulated_nullcond2_n480 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_nullcond2_n480))

write_csv(convergerate_nullcond2_n480, file = here("./sem/mgcfa/convergerate_nullcond2_n480.csv"))

mgcfa_converged_nullcond2_n480 <- mgcfa_nullcond2_n480_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_nullcond2_n480, file = 
            here("./sem/mgcfa/mgcfa_converged_nullcond2_n480_output.csv"))

mgcfa_nullcond2_n480_summary <- mgcfa_converged_nullcond2_n480 |>
  mutate(bias_c1_est = c1_est - 0,
         bias_c2_est = c2_est - 0,
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_nullcond2_n480",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se))

view(mgcfa_nullcond2_n480_summary)

write_csv(mgcfa_nullcond2_n480_summary, file = here("./sem/mgcfa/mgcfa_nullcond2_n480_summary.csv"))

## ---- Condition 3 ---- 
### ---- Significance Model ----

fun_mgcfa <- function(cond3_n480_data_list){
  fit = sem(model = mgcfae_model,
            data = cond3_n480_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "cond3_n480_data_list"

results_cond3_n480 <- lapply(cond3_n480_data_list, fun_mgcfa)

names(results_cond3_n480) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_cond3_n480 <- list() # initialize

for (i in 1:length(results_cond3_n480)) {
  c1_est <- results_cond3_n480[[i]]$summary$pe$est[57]
  c1_se <- results_cond3_n480[[i]]$summary$pe$se[57]
  c1_z <- results_cond3_n480[[i]]$summary$pe$z[57]
  c1_p <- format(results_cond3_n480[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_cond3_n480[[i]]$summary$pe$est[58]
  c2_se <- results_cond3_n480[[i]]$summary$pe$se[58]
  c2_z <- results_cond3_n480[[i]]$summary$pe$z[58]
  c2_p <- format(results_cond3_n480[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_cond3_n480[[i]]$summary$pe$est[59]
  c3_se <- results_cond3_n480[[i]]$summary$pe$se[59]
  c3_z <- results_cond3_n480[[i]]$summary$pe$z[59]
  c3_p <- format(results_cond3_n480[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_cond3_n480[[i]]$summary$fit[17]
  rmsea <- results_cond3_n480[[i]]$summary$fit[31]
  srmr <- results_cond3_n480[[i]]$summary$fit[49]
  conv <- results_cond3_n480[[i]]$summary$header$optim.converged[1]
  
  modelfit_cond3_n480[[i]] <- tibble(cfi = cfi,
                                     rmsea = rmsea,
                                     srmr = srmr,
                                     conv = conv,
                                     c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                     c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                     c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond3_n240)[[i]] <- names(results_cond3_n240)[[i]]
}

mgcfa_output1_cond3_n480 <- bind_rows(modelfit_cond3_n480) 

mgcfa_output1_cond3_n480 <- mgcfa_output1_cond3_n480 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_cond3_n480, file = here("./sem/mgcfa/mgcfa_cond3_n480_output.csv"))

mgcfa_cond3_n480_output <- read_csv(file = here("./sem/mgcfa/mgcfa_cond3_n480_output.csv"))

mgcfa_simulated_cond3_n480 <- mgcfa_cond3_n480_output |>
  filter(row_number() <= 10000)

convergerate_cond3_n480 <- mgcfa_simulated_cond3_n480 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_cond3_n480))

write_csv(convergerate_cond3_n480, file = here("./sem/mgcfa/convergerate_cond3_n480.csv"))

mgcfa_converged_cond3_n480 <- mgcfa_cond3_n480_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_cond3_n480, file = 
            here("./sem/mgcfa/mgcfa_converged_cond3_n480_output.csv"))

mgcfa_cond3_n480_summary <- mgcfa_converged_cond3_n480 |>
  mutate(bias_c1_est = c1_est - (-0.4),
         bias_c2_est = c2_est - (-0.2),
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est/(-0.4),
         rel_bias_c2_est = bias_c2_est/(-0.2),
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_cond3_n480",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se)
  )

# |>
#   mutate(rep_bias_c1 = c1_est - (-0.4),
#          rep_bias_c1_sqrd = (rep_bias_c1)^2,
#          
#          rep_bias_c2 = c2_est - (-0.2),
#          rep_bias_c2_sqrd = (rep_bias_c2)^2,
#          
#          rep_bias_c3 = c3_est - (0),
#          rep_bias_c3_sqrd = (rep_bias_c3)^2) |>
#   summarise(condition = "mgcfae_cond3_n480",
#             c1_avg_est = mean(c1_est),
#             c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
#             c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
#             c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
#             c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
#                                      c1_p < .05 ~ 1)),
#             c1_prop_sig = c1_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c2_avg_est = mean(c2_est),
#             c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
#             c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
#             c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
#             c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
#                                      c2_p < .05 ~ 1)),
#             c2_prop_sig = c2_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c3_avg_est = mean(c3_est),
#             c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
#             c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
#             c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
#             c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
#                                      c3_p < .05 ~ 1)),
#             c3_prop_sig = c3_n_sig/nrow(mgcfa_converged_cond1_n240),
#             cfi_min = min(cfi, na.rm = T),
#             cfi_max = max(cfi, na.rm = T),
#             cfi_avg = mean(cfi, na.rm = T),
#             rmsea_min = min(rmsea, na.rm = T),
#             rmsea_max = max(rmsea, na.rm = T),
#             rmsea_avg = mean(rmsea, na.rm = T),
#             srmr_min = min(srmr, na.rm = T),
#             srmr_max = max(srmr, na.rm = T),
#             srmr_avg = mean(srmr, na.rm = T),
#             converged = sum(case_when(conv == "TRUE" ~ 1,
#                                       conv == "FALSE" ~ 0)),
#             conv_prop = converged/nrow(mgcfa_converged_cond1_n240),
#             
#             n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
#                                          cfi < 0.9 ~ 0)),
#             prop_accept_cfi = n_accept_cfi/10000,
#             n_accept_dyn_cfi = sum(case_when(cfi >= 0.989 ~ 1,
#                                              cfi < 0.989 ~ 0)),
#             prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
#             
#             n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
#                                            rmsea > 0.08 ~ 0)),
#             prop_accept_rmsea = n_accept_rmsea/10000,
#             n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.093 ~ 1,
#                                                rmsea > 0.093 ~ 0)),
#             prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
#             
#             n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
#                                           srmr > 0.08 ~ 0)),
#             prop_accept_srmr = n_accept_srmr/10000,
#             n_accept_dyn_srmr = sum(case_when(srmr <= 0.019 ~ 1,
#                                               srmr > 0.019 ~ 0)),
#             prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
#             
#             mse_c1 = format(mean(rep_bias_c1_sqrd)/10000, scientific = F),
#             mse_c2 = format(mean(rep_bias_c2_sqrd)/10000, scientific = F),
#             mse_c3 = format(mean(rep_bias_c3_sqrd)/1000, scientific = F))

view(mgcfa_cond3_n480_summary)

write_csv(mgcfa_cond3_n480_summary, file = here("./sem/mgcfa/mgcfa_cond3_n480_summary.csv"))

### ---- Null Model ----

fun_mgcfa <- function(nullcond3_n480_data_list){
  fit = sem(model = mgcfae_model,
            data = nullcond3_n480_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "nullcond3_n480_data_list"

results_nullcond3_n480 <- lapply(nullcond3_n480_data_list, fun_mgcfa)

names(results_nullcond3_n480) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_nullcond3_n480 <- list() # initialize

for (i in 1:length(results_nullcond3_n480)) {
  c1_est <- results_nullcond3_n480[[i]]$summary$pe$est[57]
  c1_se <- results_nullcond3_n480[[i]]$summary$pe$se[57]
  c1_z <- results_nullcond3_n480[[i]]$summary$pe$z[57]
  c1_p <- format(results_nullcond3_n480[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_nullcond3_n480[[i]]$summary$pe$est[58]
  c2_se <- results_nullcond3_n480[[i]]$summary$pe$se[58]
  c2_z <- results_nullcond3_n480[[i]]$summary$pe$z[58]
  c2_p <- format(results_nullcond3_n480[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_nullcond3_n480[[i]]$summary$pe$est[59]
  c3_se <- results_nullcond3_n480[[i]]$summary$pe$se[59]
  c3_z <- results_nullcond3_n480[[i]]$summary$pe$z[59]
  c3_p <- format(results_nullcond3_n480[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_nullcond3_n480[[i]]$summary$fit[17]
  rmsea <- results_nullcond3_n480[[i]]$summary$fit[31]
  srmr <- results_nullcond3_n480[[i]]$summary$fit[49]
  conv <- results_nullcond3_n480[[i]]$summary$header$optim.converged[1]
  
  modelfit_nullcond3_n480[[i]] <- tibble(cfi = cfi,
                                         rmsea = rmsea,
                                         srmr = srmr,
                                         conv = conv,
                                         c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                         c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                         c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond3_n240)[[i]] <- names(results_cond3_n240)[[i]]
}

mgcfa_output1_nullcond3_n480 <- bind_rows(modelfit_nullcond3_n480) 

mgcfa_output1_nullcond3_n480 <- mgcfa_output1_nullcond3_n480 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_nullcond3_n480, file = here("./sem/mgcfa/mgcfa_nullcond3_n480_output.csv"))

mgcfa_nullcond3_n480_output <- read_csv(file = here("./sem/mgcfa/mgcfa_nullcond3_n480_output.csv"))

mgcfa_simulated_nullcond3_n480 <- mgcfa_nullcond3_n480_output |>
  filter(row_number() <= 10000)

convergerate_nullcond3_n480 <- mgcfa_simulated_nullcond3_n480 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_nullcond3_n480))

write_csv(convergerate_nullcond3_n480, file = here("./sem/mgcfa/convergerate_nullcond3_n480.csv"))

mgcfa_converged_nullcond3_n480 <- mgcfa_nullcond3_n480_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

mgcfa_simulated_nullcond3_n480 <- mgcfa_nullcond3_n480_output |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_nullcond3_n480, file = 
            here("./sem/mgcfa/mgcfa_converged_nullcond3_n480_output.csv"))

mgcfa_nullcond3_n480_summary <- mgcfa_converged_nullcond3_n480 |>
  mutate(bias_c1_est = c1_est - 0,
         bias_c2_est = c2_est - 0,
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_nullcond3_n480",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se))

view(mgcfa_nullcond3_n480_summary)

write_csv(mgcfa_nullcond3_n480_summary, file = here("./sem/mgcfa/mgcfa_nullcond3_n480_summary.csv"))

# ---- N = 960 ---- 
## ---- Condition 1 ---- 
### ---- Significance Model ----

fun_mgcfa <- function(cond1_n960_data_list){
  fit = sem(model = mgcfae_model,
            data = cond1_n960_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "cond1_n960_data_list"

results_cond1_n960 <- lapply(cond1_n960_data_list, fun_mgcfa)

names(results_cond1_n960) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_cond1_n960 <- list() # initialize

for (i in 1:length(results_cond1_n960)) {
  c1_est <- results_cond1_n960[[i]]$summary$pe$est[57]
  c1_se <- results_cond1_n960[[i]]$summary$pe$se[57]
  c1_z <- results_cond1_n960[[i]]$summary$pe$z[57]
  c1_p <- format(results_cond1_n960[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_cond1_n960[[i]]$summary$pe$est[58]
  c2_se <- results_cond1_n960[[i]]$summary$pe$se[58]
  c2_z <- results_cond1_n960[[i]]$summary$pe$z[58]
  c2_p <- format(results_cond1_n960[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_cond1_n960[[i]]$summary$pe$est[59]
  c3_se <- results_cond1_n960[[i]]$summary$pe$se[59]
  c3_z <- results_cond1_n960[[i]]$summary$pe$z[59]
  c3_p <- format(results_cond1_n960[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_cond1_n960[[i]]$summary$fit[17]
  rmsea <- results_cond1_n960[[i]]$summary$fit[31]
  srmr <- results_cond1_n960[[i]]$summary$fit[49]
  conv <- results_cond1_n960[[i]]$summary$header$optim.converged[1]
  
  modelfit_cond1_n960[[i]] <- tibble(cfi = cfi,
                                     rmsea = rmsea,
                                     srmr = srmr,
                                     conv = conv,
                                     c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                     c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                     c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond1_n240)[[i]] <- names(results_cond1_n240)[[i]]
}

mgcfa_output1_cond1_n960 <- bind_rows(modelfit_cond1_n960) 

mgcfa_output1_cond1_n960 <- mgcfa_output1_cond1_n960 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_cond1_n960, file = here("./sem/mgcfa/mgcfa_cond1_n960_output.csv"))

mgcfa_cond1_n960_output <- read_csv(file = here("./sem/mgcfa/mgcfa_cond1_n960_output.csv"))

mgcfa_simulated_cond1_n960 <- mgcfa_cond1_n960_output |>
  filter(row_number() <= 10000)

convergerate_cond1_n960 <- mgcfa_simulated_cond1_n960 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_cond1_n960))

write_csv(convergerate_cond1_n960, file = here("./sem/mgcfa/convergerate_cond1_n960.csv"))

mgcfa_converged_cond1_n960 <- mgcfa_cond1_n960_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_cond1_n960, file = 
            here("./sem/mgcfa/mgcfa_converged_cond1_n960_output.csv"))

mgcfa_cond1_n960_summary <- mgcfa_converged_cond1_n960 |>
  mutate(bias_c1_est = c1_est - (-0.4),
         bias_c2_est = c2_est - (-0.2),
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est/(-0.4),
         rel_bias_c2_est = bias_c2_est/(-0.2),
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_cond1_n960",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se)
  )

# |>
#   mutate(rep_bias_c1 = c1_est - (-0.4),
#          rep_bias_c1_sqrd = (rep_bias_c1)^2,
#          
#          rep_bias_c2 = c2_est - (-0.2),
#          rep_bias_c2_sqrd = (rep_bias_c2)^2,
#          
#          rep_bias_c3 = c3_est - (0),
#          rep_bias_c3_sqrd = (rep_bias_c3)^2) |>
#   summarise(condition = "mgcfae_cond1_n960",
#             c1_avg_est = mean(c1_est),
#             c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
#             c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
#             c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
#             c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
#                                      c1_p < .05 ~ 1)),
#             c1_prop_sig = c1_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c2_avg_est = mean(c2_est),
#             c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
#             c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
#             c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
#             c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
#                                      c2_p < .05 ~ 1)),
#             c2_prop_sig = c2_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c3_avg_est = mean(c3_est),
#             c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
#             c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
#             c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
#             c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
#                                      c3_p < .05 ~ 1)),
#             c3_prop_sig = c3_n_sig/nrow(mgcfa_converged_cond1_n240),
#             cfi_min = min(cfi, na.rm = T),
#             cfi_max = max(cfi, na.rm = T),
#             cfi_avg = mean(cfi, na.rm = T),
#             rmsea_min = min(rmsea, na.rm = T),
#             rmsea_max = max(rmsea, na.rm = T),
#             rmsea_avg = mean(rmsea, na.rm = T),
#             srmr_min = min(srmr, na.rm = T),
#             srmr_max = max(srmr, na.rm = T),
#             srmr_avg = mean(srmr, na.rm = T),
#             converged = sum(case_when(conv == "TRUE" ~ 1,
#                                       conv == "FALSE" ~ 0)),
#             conv_prop = converged/nrow(mgcfa_converged_cond1_n240),
#             
#             n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
#                                          cfi < 0.9 ~ 0)),
#             prop_accept_cfi = n_accept_cfi/10000,
#             n_accept_dyn_cfi = sum(case_when(cfi >= 0.989 ~ 1,
#                                              cfi < 0.989 ~ 0)),
#             prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
#             
#             n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
#                                            rmsea > 0.08 ~ 0)),
#             prop_accept_rmsea = n_accept_rmsea/10000,
#             n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.093 ~ 1,
#                                                rmsea > 0.093 ~ 0)),
#             prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
#             
#             n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
#                                           srmr > 0.08 ~ 0)),
#             prop_accept_srmr = n_accept_srmr/10000,
#             n_accept_dyn_srmr = sum(case_when(srmr <= 0.019 ~ 1,
#                                               srmr > 0.019 ~ 0)),
#             prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
#             
#             mse_c1 = format(mean(rep_bias_c1_sqrd)/10000, scientific = F),
#             mse_c2 = format(mean(rep_bias_c2_sqrd)/10000, scientific = F),
#             mse_c3 = format(mean(rep_bias_c3_sqrd)/1000, scientific = F))

view(mgcfa_cond1_n960_summary)

write_csv(mgcfa_cond1_n960_summary, file = here("./sem/mgcfa/mgcfa_cond1_n960_summary.csv"))

### ---- Null Model ----

fun_mgcfa <- function(nullcond1_n960_data_list){
  fit = sem(model = mgcfae_model,
            data = nullcond1_n960_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "nullcond1_n960_data_list"

results_nullcond1_n960 <- lapply(nullcond1_n960_data_list, fun_mgcfa)

names(results_nullcond1_n960) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_nullcond1_n960 <- list() # initialize

for (i in 1:length(results_nullcond1_n960)) {
  c1_est <- results_nullcond1_n960[[i]]$summary$pe$est[57]
  c1_se <- results_nullcond1_n960[[i]]$summary$pe$se[57]
  c1_z <- results_nullcond1_n960[[i]]$summary$pe$z[57]
  c1_p <- format(results_nullcond1_n960[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_nullcond1_n960[[i]]$summary$pe$est[58]
  c2_se <- results_nullcond1_n960[[i]]$summary$pe$se[58]
  c2_z <- results_nullcond1_n960[[i]]$summary$pe$z[58]
  c2_p <- format(results_nullcond1_n960[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_nullcond1_n960[[i]]$summary$pe$est[59]
  c3_se <- results_nullcond1_n960[[i]]$summary$pe$se[59]
  c3_z <- results_nullcond1_n960[[i]]$summary$pe$z[59]
  c3_p <- format(results_nullcond1_n960[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_nullcond1_n960[[i]]$summary$fit[17]
  rmsea <- results_nullcond1_n960[[i]]$summary$fit[31]
  srmr <- results_nullcond1_n960[[i]]$summary$fit[49]
  conv <- results_nullcond1_n960[[i]]$summary$header$optim.converged[1]
  
  modelfit_nullcond1_n960[[i]] <- tibble(cfi = cfi,
                                         rmsea = rmsea,
                                         srmr = srmr,
                                         conv = conv,
                                         c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                         c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                         c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond1_n240)[[i]] <- names(results_cond1_n240)[[i]]
}

mgcfa_output1_nullcond1_n960 <- bind_rows(modelfit_nullcond1_n960) 

mgcfa_output1_nullcond1_n960 <- mgcfa_output1_nullcond1_n960 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_nullcond1_n960, file = here("./sem/mgcfa/mgcfa_nullcond1_n960_output.csv"))

mgcfa_nullcond1_n960_output <- read_csv(file = here("./sem/mgcfa/mgcfa_nullcond1_n960_output.csv"))

mgcfa_simulated_nullcond1_n960 <- mgcfa_nullcond1_n960_output |>
  filter(row_number() <= 10000)

convergerate_nullcond1_n960 <- mgcfa_simulated_nullcond1_n960 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_nullcond1_n960))

write_csv(convergerate_nullcond1_n960, file = here("./sem/mgcfa/convergerate_nullcond1_n960.csv"))

mgcfa_converged_nullcond1_n960 <- mgcfa_nullcond1_n960_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_nullcond1_n960, file = 
            here("./sem/mgcfa/mgcfa_converged_nullcond1_n960_output.csv"))

mgcfa_nullcond1_n960_summary <- mgcfa_converged_nullcond1_n960 |>
  mutate(bias_c1_est = c1_est - 0,
         bias_c2_est = c2_est - 0,
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_nullcond1_n960",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se))

view(mgcfa_nullcond1_n960_summary)

write_csv(mgcfa_nullcond1_n960_summary, file = here("./sem/mgcfa/mgcfa_nullcond1_n960_summary.csv"))

## ---- Condition 2 ---- 
### ---- Significance Model ----

fun_mgcfa <- function(cond2_n960_data_list){
  fit = sem(model = mgcfae_model,
            data = cond2_n960_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "cond2_n960_data_list"

results_cond2_n960 <- lapply(cond2_n960_data_list, fun_mgcfa)

names(results_cond2_n960) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_cond2_n960 <- list() # initialize

for (i in 1:length(results_cond2_n960)) {
  c1_est <- results_cond2_n960[[i]]$summary$pe$est[57]
  c1_se <- results_cond2_n960[[i]]$summary$pe$se[57]
  c1_z <- results_cond2_n960[[i]]$summary$pe$z[57]
  c1_p <- format(results_cond2_n960[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_cond2_n960[[i]]$summary$pe$est[58]
  c2_se <- results_cond2_n960[[i]]$summary$pe$se[58]
  c2_z <- results_cond2_n960[[i]]$summary$pe$z[58]
  c2_p <- format(results_cond2_n960[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_cond2_n960[[i]]$summary$pe$est[59]
  c3_se <- results_cond2_n960[[i]]$summary$pe$se[59]
  c3_z <- results_cond2_n960[[i]]$summary$pe$z[59]
  c3_p <- format(results_cond2_n960[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_cond2_n960[[i]]$summary$fit[17]
  rmsea <- results_cond2_n960[[i]]$summary$fit[31]
  srmr <- results_cond2_n960[[i]]$summary$fit[49]
  conv <- results_cond2_n960[[i]]$summary$header$optim.converged[1]
  
  modelfit_cond2_n960[[i]] <- tibble(cfi = cfi,
                                     rmsea = rmsea,
                                     srmr = srmr,
                                     conv = conv,
                                     c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                     c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                     c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond2_n240)[[i]] <- names(results_cond2_n240)[[i]]
}

mgcfa_output1_cond2_n960 <- bind_rows(modelfit_cond2_n960) 

mgcfa_output1_cond2_n960 <- mgcfa_output1_cond2_n960 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_cond2_n960, file = here("./sem/mgcfa/mgcfa_cond2_n960_output.csv"))

mgcfa_cond2_n960_output <- read_csv(file = here("./sem/mgcfa/mgcfa_cond2_n960_output.csv"))

mgcfa_simulated_cond2_n960 <- mgcfa_cond2_n960_output |>
  filter(row_number() <= 10000)

convergerate_cond2_n960 <- mgcfa_simulated_cond2_n960 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_cond2_n960))

write_csv(convergerate_cond2_n960, file = here("./sem/mgcfa/convergerate_cond2_n960.csv"))

mgcfa_converged_cond2_n960 <- mgcfa_cond2_n960_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_cond2_n960, file = 
            here("./sem/mgcfa/mgcfa_converged_cond2_n960_output.csv"))

mgcfa_cond2_n960_summary <- mgcfa_converged_cond2_n960 |>
  mutate(bias_c1_est = c1_est - (-0.4),
         bias_c2_est = c2_est - (-0.2),
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est/(-0.4),
         rel_bias_c2_est = bias_c2_est/(-0.2),
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_cond2_n960",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se)
  )

# |>
#   mutate(rep_bias_c1 = c1_est - (-0.4),
#          rep_bias_c1_sqrd = (rep_bias_c1)^2,
#          
#          rep_bias_c2 = c2_est - (-0.2),
#          rep_bias_c2_sqrd = (rep_bias_c2)^2,
#          
#          rep_bias_c3 = c3_est - (0),
#          rep_bias_c3_sqrd = (rep_bias_c3)^2) |>
#   summarise(condition = "mgcfae_cond2_n960",
#             c1_avg_est = mean(c1_est),
#             c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
#             c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
#             c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
#             c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
#                                      c1_p < .05 ~ 1)),
#             c1_prop_sig = c1_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c2_avg_est = mean(c2_est),
#             c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
#             c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
#             c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
#             c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
#                                      c2_p < .05 ~ 1)),
#             c2_prop_sig = c2_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c3_avg_est = mean(c3_est),
#             c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
#             c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
#             c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
#             c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
#                                      c3_p < .05 ~ 1)),
#             c3_prop_sig = c3_n_sig/nrow(mgcfa_converged_cond1_n240),
#             cfi_min = min(cfi, na.rm = T),
#             cfi_max = max(cfi, na.rm = T),
#             cfi_avg = mean(cfi, na.rm = T),
#             rmsea_min = min(rmsea, na.rm = T),
#             rmsea_max = max(rmsea, na.rm = T),
#             rmsea_avg = mean(rmsea, na.rm = T),
#             srmr_min = min(srmr, na.rm = T),
#             srmr_max = max(srmr, na.rm = T),
#             srmr_avg = mean(srmr, na.rm = T),
#             converged = sum(case_when(conv == "TRUE" ~ 1,
#                                       conv == "FALSE" ~ 0)),
#             conv_prop = converged/nrow(mgcfa_converged_cond1_n240),
#             
#             n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
#                                          cfi < 0.9 ~ 0)),
#             prop_accept_cfi = n_accept_cfi/10000,
#             n_accept_dyn_cfi = sum(case_when(cfi >= 0.989 ~ 1,
#                                              cfi < 0.989 ~ 0)),
#             prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
#             
#             n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
#                                            rmsea > 0.08 ~ 0)),
#             prop_accept_rmsea = n_accept_rmsea/10000,
#             n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.093 ~ 1,
#                                                rmsea > 0.093 ~ 0)),
#             prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
#             
#             n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
#                                           srmr > 0.08 ~ 0)),
#             prop_accept_srmr = n_accept_srmr/10000,
#             n_accept_dyn_srmr = sum(case_when(srmr <= 0.019 ~ 1,
#                                               srmr > 0.019 ~ 0)),
#             prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
#             
#             mse_c1 = format(mean(rep_bias_c1_sqrd)/10000, scientific = F),
#             mse_c2 = format(mean(rep_bias_c2_sqrd)/10000, scientific = F),
#             mse_c3 = format(mean(rep_bias_c3_sqrd)/1000, scientific = F))

view(mgcfa_cond2_n960_summary)

write_csv(mgcfa_cond2_n960_summary, file = here("./sem/mgcfa/mgcfa_cond2_n960_summary.csv"))

### ---- Null Model ----

fun_mgcfa <- function(nullcond2_n960_data_list){
  fit = sem(model = mgcfae_model,
            data = nullcond2_n960_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "nullcond2_n960_data_list"

results_nullcond2_n960 <- lapply(nullcond2_n960_data_list, fun_mgcfa)

names(results_nullcond2_n960) <- paste0(rep("sim_output", 14998), 1:14998)

modelfit_nullcond2_n960 <- list() # initialize

for (i in 1:length(results_nullcond2_n960)) {
  c1_est <- results_nullcond2_n960[[i]]$summary$pe$est[57]
  c1_se <- results_nullcond2_n960[[i]]$summary$pe$se[57]
  c1_z <- results_nullcond2_n960[[i]]$summary$pe$z[57]
  c1_p <- format(results_nullcond2_n960[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_nullcond2_n960[[i]]$summary$pe$est[58]
  c2_se <- results_nullcond2_n960[[i]]$summary$pe$se[58]
  c2_z <- results_nullcond2_n960[[i]]$summary$pe$z[58]
  c2_p <- format(results_nullcond2_n960[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_nullcond2_n960[[i]]$summary$pe$est[59]
  c3_se <- results_nullcond2_n960[[i]]$summary$pe$se[59]
  c3_z <- results_nullcond2_n960[[i]]$summary$pe$z[59]
  c3_p <- format(results_nullcond2_n960[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_nullcond2_n960[[i]]$summary$fit[17]
  rmsea <- results_nullcond2_n960[[i]]$summary$fit[31]
  srmr <- results_nullcond2_n960[[i]]$summary$fit[49]
  conv <- results_nullcond2_n960[[i]]$summary$header$optim.converged[1]
  
  modelfit_nullcond2_n960[[i]] <- tibble(cfi = cfi,
                                         rmsea = rmsea,
                                         srmr = srmr,
                                         conv = conv,
                                         c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                         c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                         c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond2_n240)[[i]] <- names(results_cond2_n240)[[i]]
}

mgcfa_output1_nullcond2_n960 <- bind_rows(modelfit_nullcond2_n960) 

mgcfa_output1_nullcond2_n960 <- mgcfa_output1_nullcond2_n960 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_nullcond2_n960, file = here("./sem/mgcfa/mgcfa_nullcond2_n960_output.csv"))

mgcfa_nullcond2_n960_output <- read_csv(file = here("./sem/mgcfa/mgcfa_nullcond2_n960_output.csv"))

mgcfa_simulated_nullcond2_n960 <- mgcfa_nullcond2_n960_output |>
  filter(row_number() <= 10000)

convergerate_nullcond2_n960 <- mgcfa_simulated_nullcond2_n960 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_nullcond2_n960))

write_csv(convergerate_nullcond2_n960, file = here("./sem/mgcfa/convergerate_nullcond2_n960.csv"))

mgcfa_converged_nullcond2_n960 <- mgcfa_nullcond2_n960_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_nullcond2_n960, file = 
            here("./sem/mgcfa/mgcfa_converged_nullcond2_n960_output.csv"))

mgcfa_nullcond2_n960_summary <- mgcfa_converged_nullcond2_n960 |>
  mutate(bias_c1_est = c1_est - 0,
         bias_c2_est = c2_est - 0,
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_nullcond2_n960",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se))

view(mgcfa_nullcond2_n960_summary)

write_csv(mgcfa_nullcond2_n960_summary, file = here("./sem/mgcfa/mgcfa_nullcond2_n960_summary.csv"))

## ---- Condition 3 ---- 
### ---- Significance Model ----

fun_mgcfa <- function(cond3_n960_data_list){
  fit = sem(model = mgcfae_model,
            data = cond3_n960_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "cond3_n960_data_list"

results_cond3_n960 <- lapply(cond3_n960_data_list, fun_mgcfa)

names(results_cond3_n960) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_cond3_n960 <- list() # initialize

for (i in 1:length(results_cond3_n960)) {
  c1_est <- results_cond3_n960[[i]]$summary$pe$est[57]
  c1_se <- results_cond3_n960[[i]]$summary$pe$se[57]
  c1_z <- results_cond3_n960[[i]]$summary$pe$z[57]
  c1_p <- format(results_cond3_n960[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_cond3_n960[[i]]$summary$pe$est[58]
  c2_se <- results_cond3_n960[[i]]$summary$pe$se[58]
  c2_z <- results_cond3_n960[[i]]$summary$pe$z[58]
  c2_p <- format(results_cond3_n960[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_cond3_n960[[i]]$summary$pe$est[59]
  c3_se <- results_cond3_n960[[i]]$summary$pe$se[59]
  c3_z <- results_cond3_n960[[i]]$summary$pe$z[59]
  c3_p <- format(results_cond3_n960[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_cond3_n960[[i]]$summary$fit[17]
  rmsea <- results_cond3_n960[[i]]$summary$fit[31]
  srmr <- results_cond3_n960[[i]]$summary$fit[49]
  conv <- results_cond3_n960[[i]]$summary$header$optim.converged[1]
  
  modelfit_cond3_n960[[i]] <- tibble(cfi = cfi,
                                     rmsea = rmsea,
                                     srmr = srmr,
                                     conv = conv,
                                     c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                     c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                     c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond3_n240)[[i]] <- names(results_cond3_n240)[[i]]
}

mgcfa_output1_cond3_n960 <- bind_rows(modelfit_cond3_n960) 

mgcfa_output1_cond3_n960 <- mgcfa_output1_cond3_n960 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_cond3_n960, file = here("./sem/mgcfa/mgcfa_cond3_n960_output.csv"))

mgcfa_cond3_n960_output <- read_csv(file = here("./sem/mgcfa/mgcfa_cond3_n960_output.csv"))

mgcfa_simulated_cond3_n960 <- mgcfa_cond3_n960_output |>
  filter(row_number() <= 10000)

convergerate_cond3_n960 <- mgcfa_simulated_cond3_n960 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_cond3_n960))

write_csv(convergerate_cond3_n960, file = here("./sem/mgcfa/convergerate_cond3_n960.csv"))

mgcfa_converged_cond3_n960 <- mgcfa_cond3_n960_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_cond3_n960, file = 
            here("./sem/mgcfa/mgcfa_converged_cond3_n960_output.csv"))

mgcfa_cond3_n960_summary <- mgcfa_converged_cond3_n960 |>
  mutate(bias_c1_est = c1_est - (-0.4),
         bias_c2_est = c2_est - (-0.2),
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est/(-0.4),
         rel_bias_c2_est = bias_c2_est/(-0.2),
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_cond3_n960",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se)
  )

# |>
#   mutate(rep_bias_c1 = c1_est - (-0.4),
#          rep_bias_c1_sqrd = (rep_bias_c1)^2,
#          
#          rep_bias_c2 = c2_est - (-0.2),
#          rep_bias_c2_sqrd = (rep_bias_c2)^2,
#          
#          rep_bias_c3 = c3_est - (0),
#          rep_bias_c3_sqrd = (rep_bias_c3)^2) |>
#   summarise(condition = "mgcfae_cond3_960",
#             c1_avg_est = mean(c1_est),
#             c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
#             c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
#             c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
#             c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
#                                      c1_p < .05 ~ 1)),
#             c1_prop_sig = c1_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c2_avg_est = mean(c2_est),
#             c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
#             c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
#             c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
#             c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
#                                      c2_p < .05 ~ 1)),
#             c2_prop_sig = c2_n_sig/nrow(mgcfa_converged_cond1_n240),
#             
#             c3_avg_est = mean(c3_est),
#             c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
#             c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
#             c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
#             c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
#                                      c3_p < .05 ~ 1)),
#             c3_prop_sig = c3_n_sig/nrow(mgcfa_converged_cond1_n240),
#             cfi_min = min(cfi, na.rm = T),
#             cfi_max = max(cfi, na.rm = T),
#             cfi_avg = mean(cfi, na.rm = T),
#             rmsea_min = min(rmsea, na.rm = T),
#             rmsea_max = max(rmsea, na.rm = T),
#             rmsea_avg = mean(rmsea, na.rm = T),
#             srmr_min = min(srmr, na.rm = T),
#             srmr_max = max(srmr, na.rm = T),
#             srmr_avg = mean(srmr, na.rm = T),
#             converged = sum(case_when(conv == "TRUE" ~ 1,
#                                       conv == "FALSE" ~ 0)),
#             conv_prop = converged/nrow(mgcfa_converged_cond1_n240),
#             
#             n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
#                                          cfi < 0.9 ~ 0)),
#             prop_accept_cfi = n_accept_cfi/10000,
#             n_accept_dyn_cfi = sum(case_when(cfi >= 0.989 ~ 1,
#                                              cfi < 0.989 ~ 0)),
#             prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
#             
#             n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
#                                            rmsea > 0.08 ~ 0)),
#             prop_accept_rmsea = n_accept_rmsea/10000,
#             n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.093 ~ 1,
#                                                rmsea > 0.093 ~ 0)),
#             prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
#             
#             n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
#                                           srmr > 0.08 ~ 0)),
#             prop_accept_srmr = n_accept_srmr/10000,
#             n_accept_dyn_srmr = sum(case_when(srmr <= 0.019 ~ 1,
#                                               srmr > 0.019 ~ 0)),
#             prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
#             
#             mse_c1 = format(mean(rep_bias_c1_sqrd)/10000, scientific = F),
#             mse_c2 = format(mean(rep_bias_c2_sqrd)/10000, scientific = F),
#             mse_c3 = format(mean(rep_bias_c3_sqrd)/1000, scientific = F))

view(mgcfa_cond3_n960_summary)

write_csv(mgcfa_cond3_n960_summary, file = here("./sem/mgcfa/mgcfa_cond3_n960_summary.csv"))

### ---- Null Model ----

fun_mgcfa <- function(nullcond3_n960_data_list){
  fit = sem(model = mgcfae_model,
            data = nullcond3_n960_data_list,
            missing = "ML",
            estimator = "MLR",
            group = "subgroup",
            meanstructure = TRUE)
  sum = summary(fit, fit.measures = T)
  list(fit = fit, summary = sum)
}

data_list <- "nullcond3_n960_data_list"

results_nullcond3_n960 <- lapply(nullcond3_n960_data_list, fun_mgcfa)

names(results_nullcond3_n960) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_nullcond3_n960 <- list() # initialize

for (i in 1:length(results_nullcond3_n960)) {
  c1_est <- results_nullcond3_n960[[i]]$summary$pe$est[57]
  c1_se <- results_nullcond3_n960[[i]]$summary$pe$se[57]
  c1_z <- results_nullcond3_n960[[i]]$summary$pe$z[57]
  c1_p <- format(results_nullcond3_n960[[i]]$summary$pe$pvalue[57], scientific = F)
  
  c2_est <- results_nullcond3_n960[[i]]$summary$pe$est[58]
  c2_se <- results_nullcond3_n960[[i]]$summary$pe$se[58]
  c2_z <- results_nullcond3_n960[[i]]$summary$pe$z[58]
  c2_p <- format(results_nullcond3_n960[[i]]$summary$pe$pvalue[58], scientific = F)
  
  c3_est <- results_nullcond3_n960[[i]]$summary$pe$est[59]
  c3_se <- results_nullcond3_n960[[i]]$summary$pe$se[59]
  c3_z <- results_nullcond3_n960[[i]]$summary$pe$z[59]
  c3_p <- format(results_nullcond3_n960[[i]]$summary$pe$pvalue[59], scientific = F)
  
  cfi <- results_nullcond3_n960[[i]]$summary$fit[17]
  rmsea <- results_nullcond3_n960[[i]]$summary$fit[31]
  srmr <- results_nullcond3_n960[[i]]$summary$fit[49]
  conv <- results_nullcond3_n960[[i]]$summary$header$optim.converged[1]
  
  modelfit_nullcond3_n960[[i]] <- tibble(cfi = cfi,
                                         rmsea = rmsea,
                                         srmr = srmr,
                                         conv = conv,
                                         c1_est = c1_est, c1_se = c1_se, c1_z = c1_z, c1_p = c1_p,
                                         c2_est = c2_est, c2_se = c2_se, c2_z = c2_z, c2_p = c2_p,
                                         c3_est = c3_est, c3_se = c3_se, c3_z = c3_z, c3_p = c3_p)
  
  #names(modelfit_cond3_n240)[[i]] <- names(results_cond3_n240)[[i]]
}

mgcfa_output1_nullcond3_n960 <- bind_rows(modelfit_nullcond3_n960) 

mgcfa_output1_nullcond3_n960 <- mgcfa_output1_nullcond3_n960 |>
  mutate(model_num = row_number()) |>
  relocate(model_num, .before = 1)

write_csv(mgcfa_output1_nullcond3_n960, file = here("./sem/mgcfa/mgcfa_nullcond3_n960_output.csv"))

mgcfa_nullcond3_n960_output <- read_csv(file = here("./sem/mgcfa/mgcfa_nullcond3_n960_output.csv"))

mgcfa_simulated_nullcond3_n960 <- mgcfa_nullcond3_n960_output |>
  filter(row_number() <= 10000)

convergerate_nullcond3_n960 <- mgcfa_simulated_nullcond3_n960 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mgcfa_simulated_nullcond3_n960))

write_csv(convergerate_nullcond3_n960, file = here("./sem/mgcfa/convergerate_nullcond3_n960.csv"))

mgcfa_converged_nullcond3_n960 <- mgcfa_nullcond3_n960_output |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mgcfa_converged_nullcond3_n960, file = 
            here("./sem/mgcfa/mgcfa_converged_nullcond3_n960_output.csv"))

mgcfa_nullcond3_n960_summary <- mgcfa_converged_nullcond3_n960 |>
  mutate(bias_c1_est = c1_est - 0,
         bias_c2_est = c2_est - 0,
         bias_c3_est = c3_est - 0,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mgcfa_nullcond3_n960",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_cond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_cond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_cond1_n240),
            
            cfi_min = min(cfi, na.rm = T),
            cfi_max = max(cfi, na.rm = T),
            cfi_avg = mean(cfi, na.rm = T),
            cfi_med = median(cfi, na.rm = T),
            rmsea_min = min(rmsea, na.rm = T),
            rmsea_max = max(rmsea, na.rm = T),
            rmsea_avg = mean(rmsea, na.rm = T),
            rmsea_med = median(rmsea, na.rm = T),
            srmr_min = min(srmr, na.rm = T),
            srmr_max = max(srmr, na.rm = T),
            srmr_avg = mean(srmr, na.rm = T),
            srmr_med = median(srmr, na.rm = T),
            converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_converged_cond1_n240),
            
            n_accept_cfi = sum(case_when(cfi >= 0.9 ~ 1,
                                         cfi < 0.9 ~ 0)),
            prop_accept_cfi = n_accept_cfi/10000,
            n_accept_dyn_cfi = sum(case_when(cfi >= 0.985 ~ 1,
                                             cfi < 0.985 ~ 0)),
            prop_accept_dyn_cfi = n_accept_dyn_cfi/10000,
            
            n_accept_rmsea = sum(case_when(rmsea <= 0.08 ~ 1,
                                           rmsea > 0.08 ~ 0)),
            prop_accept_rmsea = n_accept_rmsea/10000,
            n_accept_dyn_rmsea = sum(case_when(rmsea <= 0.069 ~ 1,
                                               rmsea > 0.069 ~ 0)),
            prop_accept_dyn_rmsea = n_accept_dyn_rmsea/10000,
            
            n_accept_srmr = sum(case_when(srmr <= 0.08 ~ 1,
                                          srmr > 0.08 ~ 0)),
            prop_accept_srmr = n_accept_srmr/10000,
            n_accept_dyn_srmr = sum(case_when(srmr <= 0.020 ~ 1,
                                              srmr > 0.020 ~ 0)),
            prop_accept_dyn_srmr = n_accept_dyn_srmr/10000,
            
            mse_c1 = format(mean(bias_c1_est_sqrd)/10000, scientific = F),
            mse_c2 = format(mean(bias_c2_est_sqrd)/10000, scientific = F),
            mse_c3 = format(mean(bias_c3_est_sqrd)/1000, scientific = F),
            
            avg_abs_bias_c1_est = mean(abs_bias_c1_est),
            abs_bias_c1_se = sd(abs_bias_c1_est)/sqrt(10000),
            abs_bias_c1_83.4ci_lower = avg_abs_bias_c1_est - 1.386*(abs_bias_c1_se),
            abs_bias_c1_83.4ci_upper = avg_abs_bias_c1_est + 1.386*(abs_bias_c1_se),
            abs_bias_c1_95ci_lower = avg_abs_bias_c1_est - 1.960*(abs_bias_c1_se),
            abs_bias_c1_95ci_upper = avg_abs_bias_c1_est + 1.960*(abs_bias_c1_se),
            
            avg_abs_bias_c2_est = mean(abs_bias_c2_est),
            abs_bias_c2_se = sd(abs_bias_c2_est)/sqrt(10000),
            abs_bias_c2_83.4ci_lower = avg_abs_bias_c2_est - 1.386*(abs_bias_c2_se),
            abs_bias_c2_83.4ci_upper = avg_abs_bias_c2_est + 1.386*(abs_bias_c2_se),
            abs_bias_c2_95ci_lower = avg_abs_bias_c2_est - 1.960*(abs_bias_c2_se),
            abs_bias_c2_95ci_upper = avg_abs_bias_c2_est + 1.960*(abs_bias_c2_se),
            
            avg_abs_bias_c3_est = mean(abs_bias_c3_est),
            abs_bias_c3_se = sd(abs_bias_c3_est)/sqrt(10000),
            abs_bias_c3_83.4ci_lower = avg_abs_bias_c3_est - 1.386*(abs_bias_c3_se),
            abs_bias_c3_83.4ci_upper = avg_abs_bias_c3_est + 1.386*(abs_bias_c3_se),
            abs_bias_c3_95ci_lower = avg_abs_bias_c3_est - 1.960*(abs_bias_c3_se),
            abs_bias_c3_95ci_upper = avg_abs_bias_c3_est + 1.960*(abs_bias_c3_se),
            
            avg_rel_bias_c1_est = mean(rel_bias_c1_est),
            rel_bias_c1_se = sd(rel_bias_c1_est)/sqrt(10000),
            rel_bias_c1_83.4ci_lower = avg_rel_bias_c1_est - 1.386*(rel_bias_c1_se),
            rel_bias_c1_83.4ci_upper = avg_rel_bias_c1_est + 1.386*(rel_bias_c1_se),
            rel_bias_c1_95ci_lower = avg_rel_bias_c1_est - 1.960*(rel_bias_c1_se),
            rel_bias_c1_95ci_upper = avg_rel_bias_c1_est + 1.960*(rel_bias_c1_se),
            
            avg_rel_bias_c2_est = mean(rel_bias_c2_est),
            rel_bias_c2_se = sd(rel_bias_c2_est)/sqrt(10000),
            rel_bias_c2_83.4ci_lower = avg_rel_bias_c2_est - 1.386*(rel_bias_c2_se),
            rel_bias_c2_83.4ci_upper = avg_rel_bias_c2_est + 1.386*(rel_bias_c2_se),
            rel_bias_c2_95ci_lower = avg_rel_bias_c2_est - 1.960*(rel_bias_c2_se),
            rel_bias_c2_95ci_upper = avg_rel_bias_c2_est + 1.960*(rel_bias_c2_se),
            
            avg_rel_bias_c3_est = mean(rel_bias_c3_est),
            rel_bias_c3_se = sd(rel_bias_c3_est)/sqrt(10000),
            rel_bias_c3_83.4ci_lower = avg_rel_bias_c3_est - 1.386*(rel_bias_c3_se),
            rel_bias_c3_83.4ci_upper = avg_rel_bias_c3_est + 1.386*(rel_bias_c3_se),
            rel_bias_c3_95ci_lower = avg_rel_bias_c3_est - 1.960*(rel_bias_c3_se),
            rel_bias_c3_95ci_upper = avg_rel_bias_c3_est + 1.960*(rel_bias_c3_se))

view(mgcfa_nullcond3_n960_summary)

write_csv(mgcfa_nullcond3_n960_summary, file = here("./sem/mgcfa/mgcfa_nullcond3_n960_summary.csv"))
