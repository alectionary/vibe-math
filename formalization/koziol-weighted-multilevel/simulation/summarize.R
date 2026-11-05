# Summarize the Gaussian random-intercept Monte Carlo.
# A replication is dropped from every estimator if any estimator in that
# replication did not converge. Bias, relative bias, MSE, coverage, and RMSE
# use the same definitions as Koziol (2015) equations 34, 35, and 39-42.
# Coverage is the proportion of Wald intervals that use 1.96, matching a
# large-sample MLR interval rather than a survey t critical value.

args <- commandArgs(trailingOnly = TRUE)
sim_dir <- Sys.getenv("SIM_DIR", unset = getwd())
res_dir <- file.path(sim_dir, "results")
files <- Sys.glob(file.path(res_dir, "cell_*.csv"))
if (!length(files)) stop("no cell files")
raw <- do.call(rbind, lapply(files, read.csv, stringsAsFactors = FALSE))
raw <- raw[raw$estimator != "ERROR", ]
raw$ok <- isTRUE(raw$converged) | raw$converged %in% c(TRUE, "TRUE", "True")
# converged may be logical or character
raw$ok <- raw$converged %in% c(TRUE, "TRUE", "True", "true")
key <- paste(raw$cell_id, raw$rep)
bad_reps <- unique(key[!raw$ok | !is.finite(raw$g00)])
raw$kept <- !(key %in% bad_reps)

summ <- function(df) {
  ests <- c("us.ics", "um.ccs", "ws.ics", "wtm.ccs", "wam.ccs")
  rows <- list()
  for (est in ests) {
    sub <- df[df$estimator == est, ]
    if (!nrow(sub)) next
    one <- function(est_name, col, target, se_col) {
      x <- sub[[col]]
      bias <- mean(x) - target
      rb <- if (abs(target) < 1e-12) NA_real_ else bias / target
      mse <- mean((x - target)^2)
      se <- sub[[se_col]]
      cover <- mean(abs(x - target) <= 1.96 * se)
      c(bias = bias, rel_bias = rb, mse = mse, coverage = cover,
        mean = mean(x), sd = sd(x), mc_se = sd(x) / sqrt(length(x)))
    }
    g00 <- one(est, "g00", sub$target_g00[1], "se00")
    g01 <- one(est, "g01", sub$target_g01[1], "se01")
    g10 <- one(est, "g10", sub$target_g10[1], "se10")
    rows[[length(rows) + 1]] <- data.frame(
      cell_id = sub$cell_id[1], design = sub$design[1], icc = sub$icc[1],
      nj = sub$nj[1], estimator = est, reps = nrow(sub),
      bias_g00 = g00["bias"], rel_g01 = g01["rel_bias"], bias_g01 = g01["bias"],
      rel_g10 = g10["rel_bias"], bias_g10 = g10["bias"],
      mse_g00 = g00["mse"], mse_g01 = g01["mse"], mse_g10 = g10["mse"],
      cover_g00 = g00["coverage"], cover_g01 = g01["coverage"], cover_g10 = g10["coverage"],
      mcse_g00 = g00["mc_se"], rmse = mean(sub$rmse),
      mean_m = mean(sub$m), mean_n = mean(sub$n),
      mean_wj = mean(sub$mean_wj), sd_wj = mean(sub$sd_wj),
      mean_wcond = mean(sub$mean_wcond), mean_wij = mean(sub$mean_wij),
      stringsAsFactors = FALSE
    )
  }
  do.call(rbind, rows)
}

kept <- raw[raw$kept, ]
dropped <- aggregate(rep ~ cell_id, data = unique(raw[!raw$kept, c("cell_id", "rep")]), FUN = length)
names(dropped)[2] <- "dropped_reps"
out <- do.call(rbind, lapply(split(kept, kept$cell_id), summ))
out <- merge(out, dropped, by = "cell_id", all.x = TRUE)
out$dropped_reps[is.na(out$dropped_reps)] <- 0
out <- out[order(out$cell_id, out$estimator), ]
write.csv(out, file.path(res_dir, "summary.csv"), row.names = FALSE)
print(out[, c("cell_id", "design", "icc", "nj", "estimator", "reps", "dropped_reps",
              "bias_g00", "cover_g00", "rmse", "rel_g10", "mse_g00")], digits = 4)
cat("requested rows", nrow(raw), "kept rows", nrow(kept), "\n")
