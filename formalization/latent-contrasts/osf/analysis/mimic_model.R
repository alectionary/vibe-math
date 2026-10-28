pacman::p_load(lavaan, tidyverse, here, dynamic, parallel)
set.seed(1313)

# ---- Model Syntax ---- 

mimic_model <- "
eta =~ 1*i1 + i2 + i3 + i4

eta ~~ NA*eta 

eta ~ c1 + c2 + c3

i1 + i2 + i3 + i4 ~ eq*1
"

# model_a2 <- sem(model = mimic_model, data = test_data, 
#                 estimator = "MLR", missing = "FIML", meanstructure = F)
# model_a2 |>
#   summary(ci = T)

# ---- DFI ---- 

# dfi_fit <- sem(model = mimic_model,
#     data = cond1_data_list[[1]],
#     missing = "ML",
#     estimator = "MLR")
# 
# dfi_fit |>
#   summary(fit.measures = T)
# 
# cfaOne(model = dfi_fit)

# ---- N = 240 ---- 
## ---- Condition 1 ---- 
### ---- Significance Model ----

fun_mimic <- function(cond1_data_list){
  
  fit = sem(model = mimic_model,
            data = cond1_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_cond1_n240 <- lapply(cond1_data_list, fun_mimic)

names(results_cond1_n240) <- paste0(rep("sim_output", 15000), 1:15000)

results_a2$sim_output1$summary$fit

modelfit_cond1_n240 <- list() # initialize

for (i in 1:length(results_cond1_n240)) {
  c1_est  <- results_cond1_n240[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_cond1_n240[[i]]$summary$pe$se[6] # c1 standard error
  c1_est <- results_cond1_n240[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_cond1_n240[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_cond1_n240[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_cond1_n240[[i]]$summary$pe$se[7] # c2 standard error
  c2_est <- results_cond1_n240[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_cond1_n240[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_cond1_n240[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_cond1_n240[[i]]$summary$pe$se[8] # c3 standard error
  c3_est <- results_cond1_n240[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_cond1_n240[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_cond1_n240[[i]]$summary$fit[17] 
  rmsea <- results_cond1_n240[[i]]$summary$fit[31]
  srmr <- results_cond1_n240[[i]]$summary$fit[49]
  conv <- results_cond1_n240[[i]]$summary$header$optim.converged[1]
  
  model_fit_cond1_n240[[i]] <- tibble(c1_est = c1_est, 
                                      c1_se = c1_se, 
                                      c1_est = c1_est, 
                                      c1_p = c1_p,
                                      
                                      c2_est = c2_est,
                                      c2_se = c2_se,
                                      c2_est = c2_est,
                                      c2_p = c2_p,
                                      
                                      c3_est = c3_est,
                                      c3_se = c3_se,
                                      c3_est = c3_est,
                                      c3_p = c3_p,
                                      
                                      cfi = cfi,
                                      rmsea = rmsea,
                                      srmr = srmr,
                                      conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_cond1_n240 <- bind_rows(model_fit_cond1_n240)

write_csv(mimic_output1_cond1_n240, file = here("./sem/mimic/mimic_cond1_n240_output.csv"))

mimic_output1_cond1_n240 <- read_csv(file = here("./sem/mimic/mimic_cond1_n240_output.csv"))

mimic_simulated_cond1_n240 <- mimic_output1_cond1_n240 |>
  filter(row_number() <= 10000)

convergerate_cond1_n240 <- mimic_simulated_cond1_n240 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_cond1_n240))

write_csv(convergerate_cond1_n240, file = here("./sem/mimic/convergerate_cond1_n240.csv"))

mimic_converged_cond1_n240 <- mimic_output1_cond1_n240 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_cond1_n240, file = 
            here("./sem/mimic/mimic_converged_cond1_n240_output.csv"))

mimic_cond1_n240_summary <- mimic_converged_cond1_n240 |>
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
  summarise(condition = "mimic_cond1_n240",
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

view(mimic_cond1_n240_summary)

write_csv(mimic_cond1_n240_summary, file = here("./sem/mimic/mimic_cond1_n240_summary.csv"))

### ---- Null Model ----

fun_mimic <- function(nullcond1_n240_data_list){
  
  fit = sem(model = mimic_model,
            data = nullcond1_n240_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_nullcond1_n240 <- mclapply(nullcond1_n240_data_list, fun_mimic,
                                   mc.cores = 8)

names(results_nullcond1_n240) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_nullcond1_n240 <- list() # initialize

for (i in 1:length(results_nullcond1_n240)) {
  c1_est  <- results_nullcond1_n240[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_nullcond1_n240[[i]]$summary$pe$se[6] # c1 standard error
  c1_z <- results_nullcond1_n240[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_nullcond1_n240[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_nullcond1_n240[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_nullcond1_n240[[i]]$summary$pe$se[7] # c2 standard error
  c2_z <- results_nullcond1_n240[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_nullcond1_n240[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_nullcond1_n240[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_nullcond1_n240[[i]]$summary$pe$se[8] # c3 standard error
  c3_z <- results_nullcond1_n240[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_nullcond1_n240[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_nullcond1_n240[[i]]$summary$fit[17] 
  rmsea <- results_nullcond1_n240[[i]]$summary$fit[31]
  srmr <- results_nullcond1_n240[[i]]$summary$fit[49]
  conv <- results_nullcond1_n240[[i]]$summary$header$optim.converged[1]
  
  model_fit_nullcond1_n240[[i]] <- tibble(c1_est = c1_est, 
                                          c1_se = c1_se, 
                                          c1_z = c1_z, 
                                          c1_p = c1_p,
                                          
                                          c2_est = c2_est,
                                          c2_se = c2_se,
                                          c2_z = c2_z,
                                          c2_p = c2_p,
                                          
                                          c3_est = c3_est,
                                          c3_se = c3_se,
                                          c3_z = c3_z,
                                          c3_p = c3_p,
                                          
                                          cfi = cfi,
                                          rmsea = rmsea,
                                          srmr = srmr,
                                          conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_nullcond1_n240 <- bind_rows(model_fit_nullcond1_n240)

write_csv(mimic_output1_nullcond1_n240, file = here("./sem/mimic/mimic_nullcond1_n240_output.csv"))

mimic_output1_nullcond1_n240 <- read_csv(file = here("./sem/mimic/mimic_nullcond1_n240_output.csv"))

mimic_simulated_nullcond1_n240 <- mimic_output1_nullcond1_n240 |>
  filter(row_number() <= 10000)

convergerate_nullcond1_n240 <- mimic_simulated_nullcond1_n240 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_nullcond1_n240))

write_csv(convergerate_nullcond1_n240, file = here("./sem/mimic/convergerate_nullcond1_n240.csv"))

mimic_converged_nullcond1_n240 <- mimic_output1_nullcond1_n240 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_nullcond1_n240, file = 
            here("./sem/mimic/mimic_converged_nullcond1_n240_output.csv"))

mimic_nullcond1_n240_summary <- mimic_converged_nullcond1_n240 |>
  mutate(bias_c1_est = c1_est,
         bias_c2_est = c2_est,
         bias_c3_est = c3_est,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mimic_nullcond1_n240",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_nullcond1_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_nullcond1_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_nullcond1_n240),
            
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
            conv_prop = converged/nrow(mimic_converged_nullcond1_n240),
            
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

view(mimic_nullcond1_n240_summary)

write_csv(mimic_nullcond1_n240_summary, file = here("./sem/mimic/mimic_nullcond1_n240_summary.csv"))

## ---- Condition 2 ---- 
### ---- Significance Model ----

fun_mimic <- function(cond2_n240_data_list){
  
  fit = sem(model = mimic_model,
            data = cond2_n240_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_cond2_n240 <- mclapply(cond2_n240_data_list, fun_mimic,
                               mc.cores = 8)

names(results_cond2_n240) <- paste0(rep("sim_output", 15000), 1:15000)

results_a2$sim_output1$summary$fit

modelfit_cond2_n240 <- list() # initialize

for (i in 1:length(results_cond2_n240)) {
  c1_est  <- results_cond2_n240[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_cond2_n240[[i]]$summary$pe$se[6] # c1 standard error
  c1_est <- results_cond2_n240[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_cond2_n240[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_cond2_n240[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_cond2_n240[[i]]$summary$pe$se[7] # c2 standard error
  c2_est <- results_cond2_n240[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_cond2_n240[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_cond2_n240[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_cond2_n240[[i]]$summary$pe$se[8] # c3 standard error
  c3_est <- results_cond2_n240[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_cond2_n240[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_cond2_n240[[i]]$summary$fit[17] 
  rmsea <- results_cond2_n240[[i]]$summary$fit[31]
  srmr <- results_cond2_n240[[i]]$summary$fit[49]
  conv <- results_cond2_n240[[i]]$summary$header$optim.converged[1]
  
  model_fit_cond2_n240[[i]] <- tibble(c1_est = c1_est, 
                                      c1_se = c1_se, 
                                      c1_est = c1_est, 
                                      c1_p = c1_p,
                                      
                                      c2_est = c2_est,
                                      c2_se = c2_se,
                                      c2_est = c2_est,
                                      c2_p = c2_p,
                                      
                                      c3_est = c3_est,
                                      c3_se = c3_se,
                                      c3_est = c3_est,
                                      c3_p = c3_p,
                                      
                                      cfi = cfi,
                                      rmsea = rmsea,
                                      srmr = srmr,
                                      conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_cond2_n240 <- bind_rows(model_fit_cond2_n240)

write_csv(mimic_output1_cond2_n240, file = here("./sem/mimic/mimic_cond2_n240_output.csv"))

mimic_output1_cond2_n240 <- read_csv(file = here("./sem/mimic/mimic_cond2_n240_output.csv"))

mimic_simulated_cond2_n240 <- mimic_output1_cond2_n240 |>
  filter(row_number() <= 10000)

convergerate_cond2_n240 <- mimic_simulated_cond2_n240 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_cond2_n240))

write_csv(convergerate_cond2_n240, file = here("./sem/mimic/convergerate_cond2_n240.csv"))

mimic_converged_cond2_n240 <- mimic_output1_cond2_n240 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_cond2_n240, file = 
            here("./sem/mimic/mimic_converged_cond2_n240_output.csv"))

mimic_cond2_n240_summary <- mimic_converged_cond2_n240 |>
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
  summarise(condition = "mimic_cond2_n240",
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

view(mimic_cond2_n240_summary)

write_csv(mimic_cond2_n240_summary, file = here("./sem/mimic/mimic_cond2_n240_summary.csv"))

### ---- Null Model ----

fun_mimic <- function(nullcond2_n240_data_list){
  
  fit = sem(model = mimic_model,
            data = nullcond2_n240_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_nullcond2_n240 <- mclapply(nullcond2_n240_data_list, fun_mimic,
                                   mc.cores = 8)

names(results_nullcond2_n240) <- paste0(rep("sim_output", 15000), 1:15000)

results_a2$sim_output1$summary$fit

modelfit_nullcond2_n240 <- list() # initialize

for (i in 1:length(results_nullcond2_n240)) {
  c1_est  <- results_nullcond2_n240[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_nullcond2_n240[[i]]$summary$pe$se[6] # c1 standard error
  c1_est <- results_nullcond2_n240[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_nullcond2_n240[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_nullcond2_n240[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_nullcond2_n240[[i]]$summary$pe$se[7] # c2 standard error
  c2_est <- results_nullcond2_n240[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_nullcond2_n240[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_nullcond2_n240[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_nullcond2_n240[[i]]$summary$pe$se[8] # c3 standard error
  c3_est <- results_nullcond2_n240[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_nullcond2_n240[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_nullcond2_n240[[i]]$summary$fit[17] 
  rmsea <- results_nullcond2_n240[[i]]$summary$fit[31]
  srmr <- results_nullcond2_n240[[i]]$summary$fit[49]
  conv <- results_nullcond2_n240[[i]]$summary$header$optim.converged[1]
  
  model_fit_nullcond2_n240[[i]] <- tibble(c1_est = c1_est, 
                                          c1_se = c1_se, 
                                          c1_est = c1_est, 
                                          c1_p = c1_p,
                                          
                                          c2_est = c2_est,
                                          c2_se = c2_se,
                                          c2_est = c2_est,
                                          c2_p = c2_p,
                                          
                                          c3_est = c3_est,
                                          c3_se = c3_se,
                                          c3_est = c3_est,
                                          c3_p = c3_p,
                                          
                                          cfi = cfi,
                                          rmsea = rmsea,
                                          srmr = srmr,
                                          conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_nullcond2_n240 <- bind_rows(model_fit_nullcond2_n240)

write_csv(mimic_output1_nullcond2_n240, file = here("./sem/mimic/mimic_nullcond2_n240_output.csv"))

mimic_output1_nullcond2_n240 <- read_csv(file = here("./sem/mimic/mimic_nullcond2_n240_output.csv"))

mimic_simulated_nullcond2_n240 <- mimic_output1_nullcond2_n240 |>
  filter(row_number() <= 10000)

convergerate_nullcond2_n240 <- mimic_simulated_nullcond2_n240 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_nullcond2_n240))

write_csv(convergerate_nullcond2_n240, file = here("./sem/mimic/convergerate_nullcond2_n240.csv"))

mimic_converged_nullcond2_n240 <- mimic_output1_nullcond2_n240 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_nullcond2_n240, file = 
            here("./sem/mimic/mimic_converged_nullcond2_n240_output.csv"))

mimic_nullcond2_n240_summary <- mimic_converged_nullcond2_n240 |>
  mutate(bias_c1_est = c1_est,
         bias_c2_est = c2_est,
         bias_c3_est = c3_est,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mimic_nullcond2_n240",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_nullcond2_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_nullcond2_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_nullcond2_n240),
            
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
            conv_prop = converged/nrow(mimic_converged_nullcond2_n240),
            
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

view(mimic_nullcond2_n240_summary)

write_csv(mimic_nullcond2_n240_summary, file = here("./sem/mimic/mimic_nullcond2_n240_summary.csv"))

## ---- Condition 3 ---- 
### ---- Significance Model ----

fun_mimic <- function(cond3_n240_data_list){
  
  fit = sem(model = mimic_model,
            data = cond3_n240_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_cond3_n240 <- mclapply(cond3_n240_data_list, fun_mimic,
                               mc.cores = 8)

names(results_cond3_n240) <- paste0(rep("sim_output", 15000), 1:15000)

results_a2$sim_output1$summary$fit

modelfit_cond3_n240 <- list() # initialize

for (i in 1:length(results_cond3_n240)) {
  c1_est  <- results_cond3_n240[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_cond3_n240[[i]]$summary$pe$se[6] # c1 standard error
  c1_est <- results_cond3_n240[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_cond3_n240[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_cond3_n240[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_cond3_n240[[i]]$summary$pe$se[7] # c2 standard error
  c2_est <- results_cond3_n240[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_cond3_n240[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_cond3_n240[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_cond3_n240[[i]]$summary$pe$se[8] # c3 standard error
  c3_est <- results_cond3_n240[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_cond3_n240[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_cond3_n240[[i]]$summary$fit[17] 
  rmsea <- results_cond3_n240[[i]]$summary$fit[31]
  srmr <- results_cond3_n240[[i]]$summary$fit[49]
  conv <- results_cond3_n240[[i]]$summary$header$optim.converged[1]
  
  model_fit_cond3_n240[[i]] <- tibble(c1_est = c1_est, 
                                      c1_se = c1_se, 
                                      c1_est = c1_est, 
                                      c1_p = c1_p,
                                      
                                      c2_est = c2_est,
                                      c2_se = c2_se,
                                      c2_est = c2_est,
                                      c2_p = c2_p,
                                      
                                      c3_est = c3_est,
                                      c3_se = c3_se,
                                      c3_est = c3_est,
                                      c3_p = c3_p,
                                      
                                      cfi = cfi,
                                      rmsea = rmsea,
                                      srmr = srmr,
                                      conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_cond3_n240 <- bind_rows(model_fit_cond3_n240)

write_csv(mimic_output1_cond3_n240, file = here("./sem/mimic/mimic_cond3_n240_output.csv"))

mimic_output1_cond3_n240 <- read_csv(file = here("./sem/mimic/mimic_cond3_n240_output.csv"))

mimic_simulated_cond3_n240 <- mimic_output1_cond3_n240 |>
  filter(row_number() <= 10000)

convergerate_cond3_n240 <- mimic_simulated_cond3_n240 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_cond3_n240))

write_csv(convergerate_cond3_n240, file = here("./sem/mimic/convergerate_cond3_n240.csv"))

mimic_converged_cond3_n240 <- mimic_output1_cond3_n240 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_cond3_n240, file = 
            here("./sem/mimic/mimic_converged_cond3_n240_output.csv"))

mimic_cond3_n240_summary <- mimic_converged_cond3_n240 |>
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
  summarise(condition = "mimic_cond3_n240",
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

view(mimic_cond3_n240_summary)

write_csv(mimic_cond3_n240_summary, file = here("./sem/mimic/mimic_cond3_n240_summary.csv"))

### ---- Null Model ----

fun_mimic <- function(nullcond3_n240_data_list){
  
  fit = sem(model = mimic_model,
            data = nullcond3_n240_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_nullcond3_n240 <- mclapply(nullcond3_n240_data_list, fun_mimic,
                                   mc.cores = 8)

names(results_nullcond3_n240) <- paste0(rep("sim_output", 15000), 1:15000)

results_a2$sim_output1$summary$fit

modelfit_nullcond3_n240 <- list() # initialize

for (i in 1:length(results_nullcond3_n240)) {
  c1_est  <- results_nullcond3_n240[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_nullcond3_n240[[i]]$summary$pe$se[6] # c1 standard error
  c1_est <- results_nullcond3_n240[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_nullcond3_n240[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_nullcond3_n240[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_nullcond3_n240[[i]]$summary$pe$se[7] # c2 standard error
  c2_est <- results_nullcond3_n240[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_nullcond3_n240[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_nullcond3_n240[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_nullcond3_n240[[i]]$summary$pe$se[8] # c3 standard error
  c3_est <- results_nullcond3_n240[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_nullcond3_n240[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_nullcond3_n240[[i]]$summary$fit[17] 
  rmsea <- results_nullcond3_n240[[i]]$summary$fit[31]
  srmr <- results_nullcond3_n240[[i]]$summary$fit[49]
  conv <- results_nullcond3_n240[[i]]$summary$header$optim.converged[1]
  
  model_fit_nullcond3_n240[[i]] <- tibble(c1_est = c1_est, 
                                          c1_se = c1_se, 
                                          c1_est = c1_est, 
                                          c1_p = c1_p,
                                          
                                          c2_est = c2_est,
                                          c2_se = c2_se,
                                          c2_est = c2_est,
                                          c2_p = c2_p,
                                          
                                          c3_est = c3_est,
                                          c3_se = c3_se,
                                          c3_est = c3_est,
                                          c3_p = c3_p,
                                          
                                          cfi = cfi,
                                          rmsea = rmsea,
                                          srmr = srmr,
                                          conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_nullcond3_n240 <- bind_rows(model_fit_nullcond3_n240)

write_csv(mimic_output1_nullcond3_n240, file = here("./sem/mimic/mimic_nullcond3_n240_output.csv"))

mimic_output1_nullcond3_n240 <- read_csv(file = here("./sem/mimic/mimic_nullcond3_n240_output.csv"))

mimic_simulated_nullcond3_n240 <- mimic_output1_nullcond3_n240 |>
  filter(row_number() <= 10000)

convergerate_nullcond3_n240 <- mimic_simulated_nullcond3_n240 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_nullcond3_n240))

write_csv(convergerate_nullcond3_n240, file = here("./sem/mimic/convergerate_nullcond3_n240.csv"))

mimic_converged_nullcond3_n240 <- mimic_output1_nullcond3_n240 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_nullcond3_n240, file = 
            here("./sem/mimic/mimic_converged_nullcond3_n240_output.csv"))

mimic_nullcond3_n240_summary <- mimic_converged_nullcond3_n240 |>
  mutate(bias_c1_est = c1_est,
         bias_c2_est = c2_est,
         bias_c3_est = c3_est,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mimic_nullcond3_n240",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_nullcond3_n240),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_nullcond3_n240),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_nullcond3_n240),
            
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
            conv_prop = converged/nrow(mimic_converged_nullcond3_n240),
            
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

view(mimic_nullcond3_n240_summary)

write_csv(mimic_nullcond3_n240_summary, file = here("./sem/mimic/mimic_nullcond3_n240_summary.csv"))

# ---- N = 480 ---- 
## ---- Condition 1 ---- 
### ---- Significance Model ----

fun_mimic <- function(cond1_n480_data_list){
  
  fit = sem(model = mimic_model,
            data = cond1_n480_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum)
}

results_cond1_n480 <- mclapply(cond1_n480_data_list, fun_mimic,
                               mc.cores = 8)

names(results_cond1_n480) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_cond1_n480 <- list() # initialize

for (i in 1:length(results_cond1_n480)) {
  c1_est  <- results_cond1_n480[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_cond1_n480[[i]]$summary$pe$se[6] # c1 standard error
  c1_est <- results_cond1_n480[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_cond1_n480[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_cond1_n480[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_cond1_n480[[i]]$summary$pe$se[7] # c2 standard error
  c2_est <- results_cond1_n480[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_cond1_n480[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_cond1_n480[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_cond1_n480[[i]]$summary$pe$se[8] # c3 standard error
  c3_est <- results_cond1_n480[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_cond1_n480[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_cond1_n480[[i]]$summary$fit[17] 
  rmsea <- results_cond1_n480[[i]]$summary$fit[31]
  srmr <- results_cond1_n480[[i]]$summary$fit[49]
  conv <- results_cond1_n480[[i]]$summary$header$optim.converged[1]
  
  model_fit_cond1_n480[[i]] <- tibble(c1_est = c1_est, 
                                      c1_se = c1_se, 
                                      c1_est = c1_est, 
                                      c1_p = c1_p,
                                      
                                      c2_est = c2_est,
                                      c2_se = c2_se,
                                      c2_est = c2_est,
                                      c2_p = c2_p,
                                      
                                      c3_est = c3_est,
                                      c3_se = c3_se,
                                      c3_est = c3_est,
                                      c3_p = c3_p,
                                      
                                      cfi = cfi,
                                      rmsea = rmsea,
                                      srmr = srmr,
                                      conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_cond1_n480 <- bind_rows(model_fit_cond1_n480)

write_csv(mimic_output1_cond1_n480, file = here("./sem/mimic/mimic_cond1_n480_output.csv"))

mimic_output1_cond1_n480 <- read_csv(file = here("./sem/mimic/mimic_cond1_n480_output.csv"))

mimic_simulated_cond1_n480 <- mimic_output1_cond1_n480 |>
  filter(row_number() <= 10000)

convergerate_cond1_n480 <- mimic_simulated_cond1_n480 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_cond1_n480))

write_csv(convergerate_cond1_n480, file = here("./sem/mimic/convergerate_cond1_n480.csv"))

mimic_converged_cond1_n480 <- mimic_output1_cond1_n480 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_cond1_n480, file = 
            here("./sem/mimic/mimic_converged_cond1_n480_output.csv"))

mimic_cond1_n480_summary <- mimic_converged_cond1_n480 |>
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
  summarise(condition = "mimic_cond1_n480",
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

view(mimic_cond1_n480_summary)

write_csv(mimic_cond1_n480_summary, file = here("./sem/mimic/mimic_cond1_n480_summary.csv"))

### ---- Null Model ----

fun_mimic <- function(nullcond1_n480_data_list){
  
  fit = sem(model = mimic_model,
            data = nullcond1_n480_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_nullcond1_n480 <- mclapply(nullcond1_n480_data_list, fun_mimic,
                                   mc.cores = 8)

names(results_nullcond1_n480) <- paste0(rep("sim_output", 15000), 1:15000)

results_a2$sim_output1$summary$fit

modelfit_nullcond1_n480 <- list() # initialize

for (i in 1:length(results_nullcond1_n480)) {
  c1_est  <- results_nullcond1_n480[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_nullcond1_n480[[i]]$summary$pe$se[6] # c1 standard error
  c1_est <- results_nullcond1_n480[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_nullcond1_n480[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_nullcond1_n480[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_nullcond1_n480[[i]]$summary$pe$se[7] # c2 standard error
  c2_est <- results_nullcond1_n480[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_nullcond1_n480[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_nullcond1_n480[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_nullcond1_n480[[i]]$summary$pe$se[8] # c3 standard error
  c3_est <- results_nullcond1_n480[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_nullcond1_n480[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_nullcond1_n480[[i]]$summary$fit[17] 
  rmsea <- results_nullcond1_n480[[i]]$summary$fit[31]
  srmr <- results_nullcond1_n480[[i]]$summary$fit[49]
  conv <- results_nullcond1_n480[[i]]$summary$header$optim.converged[1]
  
  model_fit_nullcond1_n480[[i]] <- tibble(c1_est = c1_est, 
                                          c1_se = c1_se, 
                                          c1_est = c1_est, 
                                          c1_p = c1_p,
                                          
                                          c2_est = c2_est,
                                          c2_se = c2_se,
                                          c2_est = c2_est,
                                          c2_p = c2_p,
                                          
                                          c3_est = c3_est,
                                          c3_se = c3_se,
                                          c3_est = c3_est,
                                          c3_p = c3_p,
                                          
                                          cfi = cfi,
                                          rmsea = rmsea,
                                          srmr = srmr,
                                          conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_nullcond1_n480 <- bind_rows(model_fit_nullcond1_n480)

write_csv(mimic_output1_nullcond1_n480, file = here("./sem/mimic/mimic_nullcond1_n480_output.csv"))

mimic_output1_nullcond1_n480 <- read_csv(file = here("./sem/mimic/mimic_nullcond1_n480_output.csv"))

mimic_simulated_nullcond1_n480 <- mimic_output1_nullcond1_n480 |>
  filter(row_number() <= 10000)

convergerate_nullcond1_n480 <- mimic_simulated_nullcond1_n480 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_nullcond1_n480))

write_csv(convergerate_nullcond1_n480, file = here("./sem/mimic/convergerate_nullcond1_n480.csv"))

mimic_converged_nullcond1_n480 <- mimic_output1_nullcond1_n480 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_nullcond1_n480, file = 
            here("./sem/mimic/mimic_converged_nullcond1_n480_output.csv"))

mimic_nullcond1_n480_summary <- mimic_converged_nullcond1_n480 |>
  mutate(bias_c1_est = c1_est,
         bias_c2_est = c2_est,
         bias_c3_est = c3_est,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mimic_nullcond1_n480",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_nullcond1_n480),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_nullcond1_n480),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_nullcond1_n480),
            
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
            conv_prop = converged/nrow(mimic_converged_nullcond1_n480),
            
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

view(mimic_nullcond1_n480_summary)

write_csv(mimic_nullcond1_n480_summary, file = here("./sem/mimic/mimic_nullcond1_n480_summary.csv"))

## ---- Condition 2 ---- 
### ---- Significance Model ----

fun_mimic <- function(cond2_n480_data_list){
  
  fit = sem(model = mimic_model,
            data = cond2_n480_data_list,
            missing = "ML",
            estimator = "MLR",
            meanstructure = T)
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_cond2_n480 <- mclapply(cond2_n480_data_list, fun_mimic,
                               mc.cores = 4)

names(results_cond2_n480) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_cond2_n480 <- list() # initialize

for (i in 1:length(results_cond2_n480)) {
  intercept <- results_cond2_n480[[i]]$summary$pe$est[6] # eta intercept
  
  c1_est  <- results_cond2_n480[[i]]$summary$pe$est[7] # c1 direct effect
  c1_se <- results_cond2_n480[[i]]$summary$pe$se[7] # c1 standard error
  c1_z <- results_cond2_n480[[i]]$summary$pe$z[7] # c1 z stat
  c1_p <- results_cond2_n480[[i]]$summary$pe$pvalue[7] # c1 p value
  
  c2_est <- results_cond2_n480[[i]]$summary$pe$est[8] # c2 direct effect
  c2_se <- results_cond2_n480[[i]]$summary$pe$se[8] # c2 standard error
  c2_z <- results_cond2_n480[[i]]$summary$pe$z[8] # c2 z stat
  c2_p <- results_cond2_n480[[i]]$summary$pe$pvalue[8] # c2 p value
  
  c3_est <- results_cond2_n480[[i]]$summary$pe$est[9] # c3 direct effect
  c3_se <- results_cond2_n480[[i]]$summary$pe$se[9] # c3 standard error
  c3_z <- results_cond2_n480[[i]]$summary$pe$z[9] # c3 z stat
  c3_p <- results_cond2_n480[[i]]$summary$pe$pvalue[9] # c3 p value
  
  cfi <- results_cond2_n480[[i]]$summary$fit[17] 
  rmsea <- results_cond2_n480[[i]]$summary$fit[31]
  srmr <- results_cond2_n480[[i]]$summary$fit[49]
  conv <- results_cond2_n480[[i]]$summary$header$optim.converged[1]
  
  model_fit_cond2_n480[[i]] <- tibble(intercept = intercept,
                                      
                                      c1_est = c1_est, 
                                      c1_se = c1_se, 
                                      c1_z = c1_z, 
                                      c1_p = c1_p,
                                      
                                      c2_est = c2_est,
                                      c2_se = c2_se,
                                      c2_z = c2_z,
                                      c2_p = c2_p,
                                      
                                      c3_est = c3_est,
                                      c3_se = c3_se,
                                      c3_z = c3_z,
                                      c3_p = c3_p,
                                      
                                      cfi = cfi,
                                      rmsea = rmsea,
                                      srmr = srmr,
                                      conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_cond2_n480 <- bind_rows(model_fit_cond2_n480)

write_csv(mimic_output1_cond2_n480, file = here("./sem/mimic/mimic_cond2_n480_output.csv"))

mimic_output1_cond2_n480 <- read_csv(file = here("./sem/mimic/mimic_cond2_n480_output.csv"))

mimic_simulated_cond2_n480 <- mimic_output1_cond2_n480 |>
  filter(row_number() <= 10000)

convergerate_cond2_n480 <- mimic_simulated_cond2_n480 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_cond2_n480))

write_csv(convergerate_cond2_n480, file = here("./sem/mimic/convergerate_cond2_n480.csv"))

mimic_converged_cond2_n480 <- mimic_output1_cond2_n480 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_cond2_n480, file = 
            here("./sem/mimic/mimic_converged_cond2_n480_output.csv"))

mimic_cond2_n480_summary <- mimic_converged_cond2_n480 |>
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
  summarise(condition = "mimic_cond2_n480",
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

view(mimic_cond2_n480_summary)

write_csv(mimic_cond2_n480_summary, file = here("./sem/mimic/mimic_cond2_n480_summary.csv"))

### ---- Null Model ----

fun_mimic <- function(nullcond2_n480_data_list){
  
  fit = sem(model = mimic_model,
            data = nullcond2_n480_data_list,
            missing = "ML",
            estimator = "MLR",
            meanstructure = T)
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_nullcond2_n480 <- mclapply(nullcond2_n480_data_list, fun_mimic,
                                   mc.cores = 4)

names(results_nullcond2_n480) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_nullcond2_n480 <- list() # initialize

for (i in 1:length(results_nullcond2_n480)) {
  intercept  <- results_nullcond2_n480[[i]]$summary$pe$est[6] # eta intercept
  
  c1_est  <- results_nullcond2_n480[[i]]$summary$pe$est[7] # c1 direct effect
  c1_se <- results_nullcond2_n480[[i]]$summary$pe$se[7] # c1 standard error
  c1_est <- results_nullcond2_n480[[i]]$summary$pe$z[7] # c1 z stat
  c1_p <- results_nullcond2_n480[[i]]$summary$pe$pvalue[7] # c1 p value
  
  c2_est <- results_nullcond2_n480[[i]]$summary$pe$est[8] # c2 direct effect
  c2_se <- results_nullcond2_n480[[i]]$summary$pe$se[8] # c2 standard error
  c2_est <- results_nullcond2_n480[[i]]$summary$pe$z[8] # c2 z stat
  c2_p <- results_nullcond2_n480[[i]]$summary$pe$pvalue[8] # c2 p value
  
  c3_est <- results_nullcond2_n480[[i]]$summary$pe$est[9] # c3 direct effect
  c3_se <- results_nullcond2_n480[[i]]$summary$pe$se[9] # c3 standard error
  c3_est <- results_nullcond2_n480[[i]]$summary$pe$z[9] # c3 z stat
  c3_p <- results_nullcond2_n480[[i]]$summary$pe$pvalue[9] # c3 p value
  
  cfi <- results_nullcond2_n480[[i]]$summary$fit[17] 
  rmsea <- results_nullcond2_n480[[i]]$summary$fit[31]
  srmr <- results_nullcond2_n480[[i]]$summary$fit[49]
  conv <- results_nullcond2_n480[[i]]$summary$header$optim.converged[1]
  
  model_fit_nullcond2_n480[[i]] <- tibble(intercept = intercept,
                                          
                                          c1_est = c1_est, 
                                          c1_se = c1_se, 
                                          c1_z = c1_z, 
                                          c1_p = c1_p,
                                          
                                          c2_est = c2_est,
                                          c2_se = c2_se,
                                          c2_z = c2_z,
                                          c2_p = c2_p,
                                          
                                          c3_est = c3_est,
                                          c3_se = c3_se,
                                          c3_z = c3_z,
                                          c3_p = c3_p,
                                          
                                          cfi = cfi,
                                          rmsea = rmsea,
                                          srmr = srmr,
                                          conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_nullcond2_n480 <- bind_rows(model_fit_nullcond2_n480)

write_csv(mimic_output1_nullcond2_n480, file = here("./sem/mimic/mimic_nullcond2_n480_output.csv"))

mimic_output1_nullcond2_n480 <- read_csv(file = here("./sem/mimic/mimic_nullcond2_n480_output.csv"))

mimic_simulated_nullcond2_n480 <- mimic_output1_nullcond2_n480 |>
  filter(row_number() <= 10000)

convergerate_nullcond2_n480 <- mimic_simulated_nullcond2_n480 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_nullcond2_n480))

write_csv(convergerate_nullcond2_n480, file = here("./sem/mimic/convergerate_nullcond2_n480.csv"))

mimic_converged_nullcond2_n480 <- mimic_output1_nullcond2_n480 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_nullcond2_n480, file = 
            here("./sem/mimic/mimic_converged_nullcond2_n480_output.csv"))

mimic_nullcond2_n480_summary <- mimic_converged_nullcond2_n480 |>
  mutate(bias_c1_est = c1_est,
         bias_c2_est = c2_est,
         bias_c3_est = c3_est,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mimic_nullcond2_n480",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_nullcond2_n480),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_nullcond2_n480),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_nullcond2_n480),
            
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
            conv_prop = converged/nrow(mimic_converged_nullcond2_n480),
            
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

view(mimic_nullcond2_n480_summary)

write_csv(mimic_nullcond2_n480_summary, file = here("./sem/mimic/mimic_nullcond2_n480_summary.csv"))

## ---- Condition 3 ---- 
### ---- Significance Model ----

fun_mimic <- function(cond3_n480_data_list){
  
  fit = sem(model = mimic_model,
            data = cond3_n480_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_cond3_n480 <- mclapply(cond3_n480_data_list, fun_mimic,
                               mc.cores = 8)

names(results_cond3_n480) <- paste0(rep("sim_output", 15000), 1:15000)

results_a2$sim_output1$summary$fit

modelfit_cond3_n480 <- list() # initialize

for (i in 1:length(results_cond3_n480)) {
  c1_est  <- results_cond3_n480[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_cond3_n480[[i]]$summary$pe$se[6] # c1 standard error
  c1_est <- results_cond3_n480[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_cond3_n480[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_cond3_n480[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_cond3_n480[[i]]$summary$pe$se[7] # c2 standard error
  c2_est <- results_cond3_n480[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_cond3_n480[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_cond3_n480[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_cond3_n480[[i]]$summary$pe$se[8] # c3 standard error
  c3_est <- results_cond3_n480[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_cond3_n480[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_cond3_n480[[i]]$summary$fit[17] 
  rmsea <- results_cond3_n480[[i]]$summary$fit[31]
  srmr <- results_cond3_n480[[i]]$summary$fit[49]
  conv <- results_cond3_n480[[i]]$summary$header$optim.converged[1]
  
  model_fit_cond3_n480[[i]] <- tibble(c1_est = c1_est, 
                                      c1_se = c1_se, 
                                      c1_est = c1_est, 
                                      c1_p = c1_p,
                                      
                                      c2_est = c2_est,
                                      c2_se = c2_se,
                                      c2_est = c2_est,
                                      c2_p = c2_p,
                                      
                                      c3_est = c3_est,
                                      c3_se = c3_se,
                                      c3_est = c3_est,
                                      c3_p = c3_p,
                                      
                                      cfi = cfi,
                                      rmsea = rmsea,
                                      srmr = srmr,
                                      conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_cond3_n480 <- bind_rows(model_fit_cond3_n480)

write_csv(mimic_output1_cond3_n480, file = here("./sem/mimic/mimic_cond3_n480_output.csv"))

mimic_output1_cond3_n480 <- read_csv(file = here("./sem/mimic/mimic_cond3_n480_output.csv"))

mimic_simulated_cond3_n480 <- mimic_output1_cond3_n480 |>
  filter(row_number() <= 10000)

convergerate_cond3_n480 <- mimic_simulated_cond3_n480 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_cond3_n480))

write_csv(convergerate_cond3_n480, file = here("./sem/mimic/convergerate_cond3_n480.csv"))

mimic_converged_cond3_n480 <- mimic_output1_cond3_n480 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_cond3_n480, file = 
            here("./sem/mimic/mimic_converged_cond3_n480_output.csv"))

mimic_cond3_n480_summary <- mimic_converged_cond3_n480 |>
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
  summarise(condition = "mimic_cond3_n480",
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

view(mimic_cond3_n480_summary)

write_csv(mimic_cond3_n480_summary, file = here("./sem/mimic/mimic_cond3_n480_summary.csv"))

### ---- Null Model ----

fun_mimic <- function(nullcond3_n480_data_list){
  
  fit = sem(model = mimic_model,
            data = nullcond3_n480_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_nullcond3_n480 <- map(nullcond3_n480_data_list, fun_mimic)

names(results_nullcond3_n480) <- paste0(rep("sim_output", 14996), 1:14996)

modelfit_nullcond3_n480 <- list() # initialize

for (i in 1:length(results_nullcond3_n480)) {
  c1_est  <- results_nullcond3_n480[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_nullcond3_n480[[i]]$summary$pe$se[6] # c1 standard error
  c1_z <- results_nullcond3_n480[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_nullcond3_n480[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_nullcond3_n480[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_nullcond3_n480[[i]]$summary$pe$se[7] # c2 standard error
  c2_z <- results_nullcond3_n480[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_nullcond3_n480[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_nullcond3_n480[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_nullcond3_n480[[i]]$summary$pe$se[8] # c3 standard error
  c3_z <- results_nullcond3_n480[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_nullcond3_n480[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_nullcond3_n480[[i]]$summary$fit[17] 
  rmsea <- results_nullcond3_n480[[i]]$summary$fit[31]
  srmr <- results_nullcond3_n480[[i]]$summary$fit[49]
  conv <- results_nullcond3_n480[[i]]$summary$header$optim.converged[1]
  
  modelfit_nullcond3_n480[[i]] <- tibble(c1_est = c1_est, 
                                          c1_se = c1_se, 
                                          c1_z = c1_z, 
                                          c1_p = c1_p,
                                          
                                          c2_est = c2_est,
                                          c2_se = c2_se,
                                          c2_z = c2_z,
                                          c2_p = c2_p,
                                          
                                          c3_est = c3_est,
                                          c3_se = c3_se,
                                          c3_z = c3_z,
                                          c3_p = c3_p,
                                          
                                          cfi = cfi,
                                          rmsea = rmsea,
                                          srmr = srmr,
                                          conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_nullcond3_n480 <- bind_rows(modelfit_nullcond3_n480)

write_csv(mimic_output1_nullcond3_n480, file = here("./sem/mimic/mimic_nullcond3_n480_output.csv"))

mimic_output1_nullcond3_n480 <- read_csv(file = here("./sem/mimic/mimic_nullcond3_n480_output.csv"))

mimic_simulated_nullcond3_n480 <- mimic_output1_nullcond3_n480 |>
  filter(row_number() <= 10000)

convergerate_nullcond3_n480 <- mimic_simulated_nullcond3_n480 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_nullcond3_n480))

write_csv(convergerate_nullcond3_n480, file = here("./sem/mimic/convergerate_nullcond3_n480.csv"))

mimic_converged_nullcond3_n480 <- mimic_output1_nullcond3_n480 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_nullcond3_n480, file = 
            here("./sem/mimic/mimic_converged_nullcond3_n480_output.csv"))

mimic_nullcond3_n480_summary <- mimic_converged_nullcond3_n480 |>
  mutate(bias_c1_est = c1_est,
         bias_c2_est = c2_est,
         bias_c3_est = c3_est,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mimic_nullcond3_n480",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_nullcond3_n480),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_nullcond3_n480),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_nullcond3_n480),
            
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
            conv_prop = converged/nrow(mimic_converged_nullcond3_n480),
            
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

view(mimic_nullcond3_n480_summary)

write_csv(mimic_nullcond3_n480_summary, file = here("./sem/mimic/mimic_nullcond3_n480_summary.csv"))

# ---- N = 960 ---- 
## ---- Condition 1 ---- 
### ---- Significance Model ----

fun_mimic <- function(cond1_n960_data_list){
  
  fit = sem(model = mimic_model,
            data = cond1_n960_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_cond1_n960 <- mclapply(cond1_n960_data_list, fun_mimic,
                              mc.cores = 8)

names(results_cond1_n960) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_cond1_n960 <- list() # initialize

for (i in 1:length(results_cond1_n960)) {
  c1_est  <- results_cond1_n960[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_cond1_n960[[i]]$summary$pe$se[6] # c1 standard error
  c1_est <- results_cond1_n960[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_cond1_n960[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_cond1_n960[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_cond1_n960[[i]]$summary$pe$se[7] # c2 standard error
  c2_est <- results_cond1_n960[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_cond1_n960[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_cond1_n960[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_cond1_n960[[i]]$summary$pe$se[8] # c3 standard error
  c3_est <- results_cond1_n960[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_cond1_n960[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_cond1_n960[[i]]$summary$fit[17] 
  rmsea <- results_cond1_n960[[i]]$summary$fit[31]
  srmr <- results_cond1_n960[[i]]$summary$fit[49]
  conv <- results_cond1_n960[[i]]$summary$header$optim.converged[1]
  
  modelfit_cond1_n960[[i]] <- tibble(c1_est = c1_est, 
                                     c1_se = c1_se, 
                                     c1_est = c1_est, 
                                     c1_p = c1_p,
                                     
                                     c2_est = c2_est,
                                     c2_se = c2_se,
                                     c2_est = c2_est,
                                     c2_p = c2_p,
                                     
                                     c3_est = c3_est,
                                     c3_se = c3_se,
                                     c3_est = c3_est,
                                     c3_p = c3_p,
                                     
                                     cfi = cfi,
                                     rmsea = rmsea,
                                     srmr = srmr,
                                     conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_cond1_n960 <- bind_rows(modelfit_cond1_n960)

write_csv(mimic_output1_cond1_n960, file = here("./sem/mimic/mimic_cond1_n960_output.csv"))

mimic_output1_cond1_n960 <- read_csv(file = here("./sem/mimic/mimic_cond1_n960_output.csv"))

mimic_simulated_cond1_n960 <- mimic_output1_cond1_n960 |>
  filter(row_number() <= 10000)

convergerate_cond1_n960 <- mimic_simulated_cond1_n960 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_cond1_n960))

write_csv(convergerate_cond1_n960, file = here("./sem/mimic/convergerate_cond1_n960.csv"))

mimic_converged_cond1_n960 <- mimic_output1_cond1_n960 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_cond1_n960, file = 
            here("./sem/mimic/mimic_converged_cond1_n960_output.csv"))

mimic_cond1_n960_summary <- mimic_converged_cond1_n960 |>
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
  summarise(condition = "mimic_cond1_n960",
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

view(mimic_cond1_n960_summary)

write_csv(mimic_cond1_n960_summary, file = here("./sem/mimic/mimic_cond1_n960_summary.csv"))

### ---- Null Model ----

fun_mimic <- function(nullcond1_n960_data_list){
  
  fit = sem(model = mimic_model,
            data = nullcond1_n960_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_nullcond1_n960 <- mclapply(nullcond1_n960_data_list, fun_mimic,
                                  mc.cores = 8)

names(results_nullcond1_n960) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_nullcond1_n960 <- list() # initialize

for (i in 1:length(results_nullcond1_n960)) {
  c1_est  <- results_nullcond1_n960[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_nullcond1_n960[[i]]$summary$pe$se[6] # c1 standard error
  c1_est <- results_nullcond1_n960[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_nullcond1_n960[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_nullcond1_n960[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_nullcond1_n960[[i]]$summary$pe$se[7] # c2 standard error
  c2_est <- results_nullcond1_n960[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_nullcond1_n960[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_nullcond1_n960[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_nullcond1_n960[[i]]$summary$pe$se[8] # c3 standard error
  c3_est <- results_nullcond1_n960[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_nullcond1_n960[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_nullcond1_n960[[i]]$summary$fit[17] 
  rmsea <- results_nullcond1_n960[[i]]$summary$fit[31]
  srmr <- results_nullcond1_n960[[i]]$summary$fit[49]
  conv <- results_nullcond1_n960[[i]]$summary$header$optim.converged[1]
  
  modelfit_nullcond1_n960[[i]] <- tibble(c1_est = c1_est, 
                                          c1_se = c1_se, 
                                          c1_est = c1_est, 
                                          c1_p = c1_p,
                                          
                                          c2_est = c2_est,
                                          c2_se = c2_se,
                                          c2_est = c2_est,
                                          c2_p = c2_p,
                                          
                                          c3_est = c3_est,
                                          c3_se = c3_se,
                                          c3_est = c3_est,
                                          c3_p = c3_p,
                                          
                                          cfi = cfi,
                                          rmsea = rmsea,
                                          srmr = srmr,
                                          conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_nullcond1_n960 <- bind_rows(modelfit_nullcond1_n960)

write_csv(mimic_output1_nullcond1_n960, file = here("./sem/mimic/mimic_nullcond1_n960_output.csv"))

mimic_output1_nullcond1_n960 <- read_csv(file = here("./sem/mimic/mimic_nullcond1_n960_output.csv"))

mimic_simulated_nullcond1_n960 <- mimic_output1_nullcond1_n960 |>
  filter(row_number() <= 10000)

convergerate_nullcond1_n960 <- mimic_simulated_nullcond1_n960 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_nullcond1_n960))

write_csv(convergerate_nullcond1_n960, file = here("./sem/mimic/convergerate_nullcond1_n960.csv"))

mimic_converged_nullcond1_n960 <- mimic_output1_nullcond1_n960 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_nullcond1_n960, file = 
            here("./sem/mimic/mimic_converged_nullcond1_n960_output.csv"))

mimic_nullcond1_n960_summary <- mimic_converged_nullcond1_n960 |>
  mutate(bias_c1_est = c1_est,
         bias_c2_est = c2_est,
         bias_c3_est = c3_est,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mimic_nullcond1_n960",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_nullcond1_n960),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_nullcond1_n960),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_nullcond1_n960),
            
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
            conv_prop = converged/nrow(mimic_converged_nullcond1_n960),
            
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

view(mimic_nullcond1_n960_summary)

write_csv(mimic_nullcond1_n960_summary, file = here("./sem/mimic/mimic_nullcond1_n960_summary.csv"))

## ---- Condition 2 ---- 
### ---- Significance Model ----

fun_mimic <- function(cond2_n960_data_list){
  
  fit = sem(model = mimic_model,
            data = cond2_n960_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_cond2_n960 <- mclapply(cond2_n960_data_list, fun_mimic,
                               mc.cores = 8)

names(results_cond2_n960) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_cond2_n960 <- list() # initialize

for (i in 1:length(results_cond2_n960)) {
  c1_est  <- results_cond2_n960[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_cond2_n960[[i]]$summary$pe$se[6] # c1 standard error
  c1_est <- results_cond2_n960[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_cond2_n960[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_cond2_n960[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_cond2_n960[[i]]$summary$pe$se[7] # c2 standard error
  c2_est <- results_cond2_n960[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_cond2_n960[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_cond2_n960[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_cond2_n960[[i]]$summary$pe$se[8] # c3 standard error
  c3_est <- results_cond2_n960[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_cond2_n960[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_cond2_n960[[i]]$summary$fit[17] 
  rmsea <- results_cond2_n960[[i]]$summary$fit[31]
  srmr <- results_cond2_n960[[i]]$summary$fit[49]
  conv <- results_cond2_n960[[i]]$summary$header$optim.converged[1]
  
  modelfit_cond2_n960[[i]] <- tibble(c1_est = c1_est, 
                                      c1_se = c1_se, 
                                      c1_z = c1_z, 
                                      c1_p = c1_p,
                                      
                                      c2_est = c2_est,
                                      c2_se = c2_se,
                                      c2_z = c2_z,
                                      c2_p = c2_p,
                                      
                                      c3_est = c3_est,
                                      c3_se = c3_se,
                                      c3_z = c3_z,
                                      c3_p = c3_p,
                                      
                                      cfi = cfi,
                                      rmsea = rmsea,
                                      srmr = srmr,
                                      conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_cond2_n960 <- bind_rows(modelfit_cond2_n960)

write_csv(mimic_output1_cond2_n960, file = here("./sem/mimic/mimic_cond2_n960_output.csv"))

mimic_output1_cond2_n960 <- read_csv(file = here("./sem/mimic/mimic_cond2_n960_output.csv"))

mimic_simulated_cond2_n960 <- mimic_output1_cond2_n960 |>
  filter(row_number() <= 10000)

convergerate_cond2_n960 <- mimic_simulated_cond2_n960 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_cond2_n960))

write_csv(convergerate_cond2_n960, file = here("./sem/mimic/convergerate_cond2_n960.csv"))

mimic_converged_cond2_n960 <- mimic_output1_cond2_n960 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_cond2_n960, file = 
            here("./sem/mimic/mimic_converged_cond2_n960_output.csv"))

mimic_cond2_n960_summary <- mimic_converged_cond2_n960 |>
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
  summarise(condition = "mimic_cond2_n960",
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

view(mimic_cond2_n960_summary)

write_csv(mimic_cond2_n960_summary, file = here("./sem/mimic/mimic_cond2_n960_summary.csv"))

### ---- Null Model ----

fun_mimic <- function(nullcond2_n960_data_list){
  
  fit = sem(model = mimic_model,
            data = nullcond2_n960_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_nullcond2_n960 <- mclapply(nullcond2_n960_data_list, fun_mimic,
                                   mc.cores = 8)

names(results_nullcond2_n960) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_nullcond2_n960 <- list() # initialize

for (i in 1:length(results_nullcond2_n960)) {
  c1_est  <- results_nullcond2_n960[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_nullcond2_n960[[i]]$summary$pe$se[6] # c1 standard error
  c1_z <- results_nullcond2_n960[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_nullcond2_n960[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_nullcond2_n960[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_nullcond2_n960[[i]]$summary$pe$se[7] # c2 standard error
  c2_z <- results_nullcond2_n960[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_nullcond2_n960[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_nullcond2_n960[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_nullcond2_n960[[i]]$summary$pe$se[8] # c3 standard error
  c3_z <- results_nullcond2_n960[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_nullcond2_n960[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_nullcond2_n960[[i]]$summary$fit[17] 
  rmsea <- results_nullcond2_n960[[i]]$summary$fit[31]
  srmr <- results_nullcond2_n960[[i]]$summary$fit[49]
  conv <- results_nullcond2_n960[[i]]$summary$header$optim.converged[1]
  
  modelfit_nullcond2_n960[[i]] <- tibble(c1_est = c1_est, 
                                          c1_se = c1_se, 
                                          c1_z = c1_z, 
                                          c1_p = c1_p,
                                          
                                          c2_est = c2_est,
                                          c2_se = c2_se,
                                          c2_z = c2_z,
                                          c2_p = c2_p,
                                          
                                          c3_est = c3_est,
                                          c3_se = c3_se,
                                          c3_z = c3_z,
                                          c3_p = c3_p,
                                          
                                          cfi = cfi,
                                          rmsea = rmsea,
                                          srmr = srmr,
                                          conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_nullcond2_n960 <- bind_rows(modelfit_nullcond2_n960)

write_csv(mimic_output1_nullcond2_n960, file = here("./sem/mimic/mimic_nullcond2_n960_output.csv"))

mimic_output1_nullcond2_n960 <- read_csv(file = here("./sem/mimic/mimic_nullcond2_n960_output.csv"))

mimic_simulated_nullcond2_n960 <- mimic_output1_nullcond2_n960 |>
  filter(row_number() <= 10000)

convergerate_nullcond2_n960 <- mimic_simulated_nullcond2_n960 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_nullcond2_n960))

write_csv(convergerate_nullcond2_n960, file = here("./sem/mimic/convergerate_nullcond2_n960.csv"))

mimic_converged_nullcond2_n960 <- mimic_output1_nullcond2_n960 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_nullcond2_n960, file = 
            here("./sem/mimic/mimic_converged_nullcond2_n960_output.csv"))

mimic_nullcond2_n960_summary <- mimic_converged_nullcond2_n960 |>
  mutate(bias_c1_est = c1_est,
         bias_c2_est = c2_est,
         bias_c3_est = c3_est,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mimic_nullcond2_n960",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_nullcond2_n960),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_nullcond2_n960),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_nullcond2_n960),
            
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
            conv_prop = converged/nrow(mimic_converged_nullcond2_n960),
            
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

view(mimic_nullcond2_n960_summary)

write_csv(mimic_nullcond2_n960_summary, file = here("./sem/mimic/mimic_nullcond2_n960_summary.csv"))

## ---- Condition 3 ---- 
### ---- Significance Model ----

fun_mimic <- function(cond3_n960_data_list){
  
  fit = sem(model = mimic_model,
            data = cond3_n960_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_cond3_n960 <- mclapply(cond3_n960_data_list, fun_mimic,
                               mc.cores = 8)

names(results_cond3_n960) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_cond3_n960 <- list() # initialize

for (i in 1:length(results_cond3_n960)) {
  c1_est  <- results_cond3_n960[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_cond3_n960[[i]]$summary$pe$se[6] # c1 standard error
  c1_z <- results_cond3_n960[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_cond3_n960[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_cond3_n960[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_cond3_n960[[i]]$summary$pe$se[7] # c2 standard error
  c2_z <- results_cond3_n960[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_cond3_n960[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_cond3_n960[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_cond3_n960[[i]]$summary$pe$se[8] # c3 standard error
  c3_z <- results_cond3_n960[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_cond3_n960[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_cond3_n960[[i]]$summary$fit[17] 
  rmsea <- results_cond3_n960[[i]]$summary$fit[31]
  srmr <- results_cond3_n960[[i]]$summary$fit[49]
  conv <- results_cond3_n960[[i]]$summary$header$optim.converged[1]
  
  model_fit_cond3_n960[[i]] <- tibble(c1_est = c1_est, 
                                      c1_se = c1_se, 
                                      c1_est = c1_est, 
                                      c1_p = c1_p,
                                      
                                      c2_est = c2_est,
                                      c2_se = c2_se,
                                      c2_est = c2_est,
                                      c2_p = c2_p,
                                      
                                      c3_est = c3_est,
                                      c3_se = c3_se,
                                      c3_est = c3_est,
                                      c3_p = c3_p,
                                      
                                      cfi = cfi,
                                      rmsea = rmsea,
                                      srmr = srmr,
                                      conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_cond3_n960 <- bind_rows(model_fit_cond3_n960)

write_csv(mimic_output1_cond3_n960, file = here("./sem/mimic/mimic_cond3_n960_output.csv"))

mimic_output1_cond3_n960 <- read_csv(file = here("./sem/mimic/mimic_cond3_n960_output.csv"))

mimic_simulated_cond3_n960 <- mimic_output1_cond3_n960 |>
  filter(row_number() <= 10000)

convergerate_cond3_n960 <- mimic_simulated_cond3_n960 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_cond3_n960))

write_csv(convergerate_cond3_n960, file = here("./sem/mimic/convergerate_cond3_n960.csv"))

mimic_converged_cond3_n960 <- mimic_output1_cond3_n960 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_cond3_n960, file = 
            here("./sem/mimic/mimic_converged_cond3_n960_output.csv"))

mimic_cond3_n960_summary <- mimic_converged_cond3_n960 |>
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
  summarise(condition = "mimic_cond3_n960",
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

view(mimic_cond3_n960_summary)
            
write_csv(mimic_cond3_n960_summary, file = here("./sem/mimic/mimic_cond3_n960_summary.csv"))

### ---- Null Model ----

fun_mimic <- function(nullcond3_n960_data_list){
  
  fit = sem(model = mimic_model,
            data = nullcond3_n960_data_list,
            missing = "ML",
            estimator = "MLR")
  sum = summary(fit,
                fit.measures = T)
  list(fit = fit, summary = sum) #, modindices = mi)
}

results_nullcond3_n960 <- mclapply(nullcond3_n960_data_list, fun_mimic,
                                   mc.cores = 8)

names(results_nullcond3_n960) <- paste0(rep("sim_output", 15000), 1:15000)

modelfit_nullcond3_n960 <- list() # initialize

for (i in 1:length(results_nullcond3_n960)) {
  c1_est  <- results_nullcond3_n960[[i]]$summary$pe$est[6] # c1 direct effect
  c1_se <- results_nullcond3_n960[[i]]$summary$pe$se[6] # c1 standard error
  c1_est <- results_nullcond3_n960[[i]]$summary$pe$z[6] # c1 z stat
  c1_p <- results_nullcond3_n960[[i]]$summary$pe$pvalue[6] # c1 p value
  
  c2_est <- results_nullcond3_n960[[i]]$summary$pe$est[7] # c2 direct effect
  c2_se <- results_nullcond3_n960[[i]]$summary$pe$se[7] # c2 standard error
  c2_est <- results_nullcond3_n960[[i]]$summary$pe$z[7] # c2 z stat
  c2_p <- results_nullcond3_n960[[i]]$summary$pe$pvalue[7] # c2 p value
  
  c3_est <- results_nullcond3_n960[[i]]$summary$pe$est[8] # c3 direct effect
  c3_se <- results_nullcond3_n960[[i]]$summary$pe$se[8] # c3 standard error
  c3_est <- results_nullcond3_n960[[i]]$summary$pe$z[8] # c3 z stat
  c3_p <- results_nullcond3_n960[[i]]$summary$pe$pvalue[8] # c3 p value
  
  cfi <- results_nullcond3_n960[[i]]$summary$fit[17] 
  rmsea <- results_nullcond3_n960[[i]]$summary$fit[31]
  srmr <- results_nullcond3_n960[[i]]$summary$fit[49]
  conv <- results_nullcond3_n960[[i]]$summary$header$optim.converged[1]
  
  model_fit_nullcond3_n960[[i]] <- tibble(c1_est = c1_est, 
                                          c1_se = c1_se, 
                                          c1_est = c1_est, 
                                          c1_p = c1_p,
                                          
                                          c2_est = c2_est,
                                          c2_se = c2_se,
                                          c2_est = c2_est,
                                          c2_p = c2_p,
                                          
                                          c3_est = c3_est,
                                          c3_se = c3_se,
                                          c3_est = c3_est,
                                          c3_p = c3_p,
                                          
                                          cfi = cfi,
                                          rmsea = rmsea,
                                          srmr = srmr,
                                          conv = conv)
  
  # names(output1_a2)[[i]] <- names(results_a2)[[i]]
}

mimic_output1_nullcond3_n960 <- bind_rows(model_fit_nullcond3_n960)

write_csv(mimic_output1_nullcond3_n960, file = here("./sem/mimic/mimic_nullcond3_n960_output.csv"))

mimic_output1_nullcond3_n960 <- read_csv(file = here("./sem/mimic/mimic_nullcond3_n960_output.csv"))

mimic_simulated_nullcond3_n960 <- mimic_output1_nullcond3_n960 |>
  filter(row_number() <= 10000)

convergerate_nullcond3_n960 <- mimic_simulated_nullcond3_n960 |>
  summarise(converged = sum(case_when(conv == "TRUE" ~ 1,
                                      conv == "FALSE" ~ 0)),
            conv_prop = converged/nrow(mimic_simulated_nullcond3_n960))

write_csv(convergerate_nullcond3_n960, file = here("./sem/mimic/convergerate_nullcond3_n960.csv"))

mimic_converged_nullcond3_n960 <- mimic_output1_nullcond3_n960 |>
  filter(conv == TRUE) |>
  filter(row_number() <= 10000)

write_csv(mimic_converged_nullcond3_n960, file = 
            here("./sem/mimic/mimic_converged_nullcond3_n960_output.csv"))

mimic_nullcond3_n960_summary <- mimic_converged_nullcond3_n960 |>
  mutate(bias_c1_est = c1_est,
         bias_c2_est = c2_est,
         bias_c3_est = c3_est,
         
         bias_c1_est_sqrd = (bias_c1_est)^2,
         bias_c2_est_sqrd = (bias_c2_est)^2,
         bias_c3_est_sqrd = (bias_c3_est)^2,
         
         abs_bias_c1_est = abs(bias_c1_est),
         abs_bias_c2_est = abs(bias_c2_est),
         abs_bias_c3_est = abs(bias_c3_est),
         
         rel_bias_c1_est = bias_c1_est,
         rel_bias_c2_est = bias_c2_est,
         rel_bias_c3_est = bias_c3_est) |>
  summarise(condition = "mimic_nullcond3_n960",
            c1_avg_est = mean(c1_est),
            c1_se_est = sd(c1_est)/sqrt(length(c1_est)),
            c1_ci_upper_est = c1_avg_est + (1.96*c1_se_est),
            c1_ci_lower_est = c1_avg_est - (1.96*c1_se_est),
            c1_n_sig = sum(case_when(c1_p >= .05 ~ 0,
                                     c1_p < .05 ~ 1)),
            c1_prop_sig = c1_n_sig/nrow(mimic_converged_nullcond3_n960),
            
            c2_avg_est = mean(c2_est),
            c2_se_est = sd(c2_est)/sqrt(length(c2_est)),
            c2_ci_upper_est = c2_avg_est + (1.96*c2_se_est),
            c2_ci_lower_est = c2_avg_est - (1.96*c2_se_est),
            c2_n_sig = sum(case_when(c2_p >= .05 ~ 0,
                                     c2_p < .05 ~ 1)),
            c2_prop_sig = c2_n_sig/nrow(mimic_converged_nullcond3_n960),
            
            c3_avg_est = mean(c3_est),
            c3_se_est = sd(c3_est)/sqrt(length(c3_est)),
            c3_ci_upper_est = c3_avg_est + (1.96*c3_se_est),
            c3_ci_lower_est = c3_avg_est - (1.96*c3_se_est),
            c3_n_sig = sum(case_when(c3_p >= .05 ~ 0,
                                     c3_p < .05 ~ 1)),
            c3_prop_sig = c3_n_sig/nrow(mimic_converged_nullcond3_n960),
            
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
            conv_prop = converged/nrow(mimic_converged_nullcond3_n960),
            
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

view(mimic_nullcond3_n960_summary)

write_csv(mimic_nullcond3_n960_summary, file = here("./sem/mimic/mimic_nullcond3_n960_summary.csv"))
