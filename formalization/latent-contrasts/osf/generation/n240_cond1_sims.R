pacman::p_load(here, tidyverse, simsem, lavaan, purrr)
set.seed(1313)

# ---- Significance Model ----

## ---- Model Syntax ----
# 4 item model

pop_model_cond1 <- "
eta =~ NA*i1 + 0.7*i1 + 0.7*i2 + 0.7*i3 + 0.7*i4

eta ~~ .5*eta

i1 ~~ 0.51*i1
i1 ~ 1*1

i2 ~~ 0.51*i2
i2 ~ 1*1

i3 ~~ 0.51*i3
i3 ~ 1*1

i4 ~~ 0.51*i4
i4 ~ 1*1

eta ~ c(1, .6, .8, .4)*1
"

## ---- Simulate ----

# exportData(nRep = 15000, model = pop_model_cond1, n = list(60, 60, 60, 60), program = "Mplus",
#            fileStem = here("./data/n=240/cond1/sim_data_n240"), seed = 13131, pmMCAR = 0)

data_cond1_n240_paths <- list.files(path = here("./data/n=240/cond1"), pattern = ".dat", recursive = T, full.names = T)

data_cond1_n240_paths <- data_cond1_n240_paths[-1]

data_cond1_n240_filenames <- list.files(path = here("./data/n=240/cond1"), pattern = ".dat", recursive = F, full.names = F)

data_cond1_n240_filenames <- data_cond1_n240_filenames[-1]

## ---- Recoding ----

cond1_n240_data_list <- lapply(data_cond1_n240_paths,
                          function(x) read.table(x, header = F, sep = " ",
                                                 colClasses = c("numeric", "numeric", 
                                                             "numeric", "numeric", "numeric"), 
                                                 col.names = c("i1", "i2", "i3", "i4", "subgroup")))

# read_recode <- function(x) {
#   mutate(x, 
#          c1 = factor(case_when(subgroup == 1 ~ -1,
#                                subgroup == 3 ~ -1,
#                                subgroup == 2 ~ 1,
#                                subgroup == 4 ~ 1)),
#          c2 = factor(case_when(subgroup == 1 ~ -1,
#                                subgroup == 2 ~ -1,
#                                subgroup == 3 ~ 1,
#                                subgroup == 4 ~ 1)),
#          c3 = factor(case_when(subgroup == 1 ~ 1,
#                                subgroup == 2 ~ -1,
#                                subgroup == 3 ~ -1,
#                                subgroup == 4 ~ 1)))
# }
# 
# map(cond1_n240_data_list, read_recode)

for (i in 1:length(cond1_n240_data_list)) {
  temp_data <- cond1_n240_data_list[[i]] |>
  mutate(c1 = factor(case_when(subgroup == 1 ~ -1,
                                     subgroup == 3 ~ -1,
                                     subgroup == 2 ~ 1,
                                     subgroup == 4 ~ 1),
                           levels = c(-1, 1), 
                           labels = c("g1", "g2")),
         c2 = factor(case_when(subgroup == 1 ~ -1,
                                     subgroup == 2 ~ -1,
                                     subgroup == 3 ~ 1,
                                     subgroup == 4 ~ 1),
                           levels = c(-1, 1), 
                           labels = c("g1", "g2")),
         c3 = factor(case_when(subgroup == 1 ~ -1,
                               subgroup == 4 ~ -1,
                               subgroup == 2 ~ 1,
                               subgroup == 3 ~ 1),
                           levels = c(-1, 1), 
                           labels = c("g1", "g2")))
  
  cond1_n240_data_list[[i]] <- temp_data
  
  names(cond1_n240_data_list)[i] <- paste0("sim_n240_", i)
}

cond1_n240_data_list[2]

# ---- Null Model ----

## ---- Model Syntax ----
# 4 item model

pop_nullmodel_cond1 <- "
eta =~ NA*i1 + 0.7*i1 + 0.7*i2 + 0.7*i3 + 0.7*i4

eta ~~ .5*eta

i1 ~~ 0.51*i1
i1 ~ 1*1

i2 ~~ 0.51*i2
i2 ~ 1*1

i3 ~~ 0.51*i3
i3 ~ 1*1

i4 ~~ 0.51*i4
i4 ~ 1*1

eta ~ c(1, 1, 1, 1)*1
 "

 ## ---- Simulate ----

# exportData(nRep = 15000, model = pop_nullmodel_cond1, n = list(60, 60, 60, 60), program = "Mplus",
#             fileStem = here("./data/n=240/null cond1/sim_data_n240"), seed = 13131, pmMCAR = 0)

data_nullcond1_n240_paths <- list.files(path = here("./data/n=240/null cond1"), pattern = ".dat",
                                        recursive = T, full.names = T)

data_nullcond1_n240_paths <- data_nullcond1_n240_paths[-1]

data_nullcond1_n240_filenames <- list.files(path = here("./data/n=240/null cond1"), pattern = ".dat",
                                        recursive = F, full.names = F)

data_nullcond1_n240_filenames <- data_nullcond1_n240_filenames[-1]

## ---- Recoding ----

nullcond1_n240_data_list <- lapply(data_nullcond1_n240_paths,
                                   function(x) read.table(x, header = F, sep = " ",
                                                          colClasses = c("numeric", "numeric", "numeric", "numeric", "numeric"),
                                                          col.names = c("i1", "i2", "i3", "i4", 
                                                                        "subgroup")))

for (i in 1:length(nullcond1_n240_data_list)) {
  temp_data <- nullcond1_n240_data_list[[i]] |>
    mutate(c1 = factor(case_when(subgroup == 1 ~ -1,
                                 subgroup == 3 ~ -1,
                                 subgroup == 2 ~ 1,
                                 subgroup == 4 ~ 1),
                       levels = c(-1, 1), 
                       labels = c("g1", "g2")),
           c2 = factor(case_when(subgroup == 1 ~ -1,
                                 subgroup == 2 ~ -1,
                                 subgroup == 3 ~ 1,
                                 subgroup == 4 ~ 1),
                       levels = c(-1, 1), 
                       labels = c("g1", "g2")),
           c3 = factor(case_when(subgroup == 1 ~ -1,
                                 subgroup == 4 ~ -1,
                                 subgroup == 2 ~ 1,
                                 subgroup == 3 ~ 1),
                       levels = c(-1, 1), 
                       labels = c("g1", "g2")))
  
  nullcond1_n240_data_list[[i]] <- temp_data
  
  names(nullcond1_n240_data_list)[i] <- paste0("sim_n240_", i)
}