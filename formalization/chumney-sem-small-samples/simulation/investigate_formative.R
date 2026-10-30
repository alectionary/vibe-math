#!/usr/bin/env Rscript
# Readings of the n = 1000, three-item, correct formative structural cell.
# The printed mean absolute percent bias is 1.196. The neighboring
# seven- and five-item cells in the same row are 2.623.

.libPaths(c("/tmp/rlib", .libPaths()))
suppressPackageStartupMessages({
  library(lavaan)
  library(mvtnorm)
})
args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)
src <- if (length(file_arg)) dirname(normalizePath(sub("^--file=", "", file_arg))) else getwd()
source(file.path(src, "population.R"))

reps <- 150L
n <- 1000L
n_items <- 3L
model <- population_model(n_items, formative = TRUE, misspecified = FALSE)
seed0 <- 20130715L + 3L * 100000L + 1L * 10000L + 1L * 1000L + 2L * 100L
# cell_id(1000, 3, correct, formative) = 20130715 + 3*100000 + 1*10000 + 1*1000 + 2*100
stopifnot(seed0 == 20441915L)

syn <- paste(
  paste0("eta1 =~ ", paste(model$sets$eta1, collapse = " + ")),
  paste0("eta2 =~ ", paste(model$sets$eta2, collapse = " + ")),
  paste0("eta3 =~ ", paste(model$sets$eta3, collapse = " + ")),
  "eta2 ~ eta1",
  "eta3 ~ eta2",
  sep = "\n"
)

fit_one <- function(data, std.lv) {
  tryCatch(
    lavaan::sem(syn, data = data, std.lv = std.lv,
                control = list(iter.max = 1000), warn = FALSE),
    error = function(e) NULL
  )
}

plausible <- function(fit) {
  if (is.null(fit) || !isTRUE(lavaan::lavInspect(fit, "converged"))) return(FALSE)
  est <- lavaan::lavInspect(fit, "est")
  all(diag(est$theta) > 0) && all(diag(est$psi) > 0)
}

row_for <- function(fit, std.lv) {
  std <- lavaan::standardizedSolution(fit)
  paths_std <- std$est.std[std$op == "~"]
  pe <- lavaan::parameterEstimates(fit)
  paths_raw <- pe$est[pe$op == "~"]
  # standardized residual variances of eta2 and eta3
  rv <- std$est.std[std$op == "~~" & std$lhs == std$rhs & std$lhs %in% c("eta2", "eta3")]
  c(paths_std = paths_std, paths_raw = paths_raw, resid_std = rv,
    ok = TRUE)
}

records <- vector("list", reps)
for (r in seq_len(reps)) {
  set.seed(seed0 + r)
  x <- mvtnorm::rmvnorm(n, sigma = model$sigma)
  colnames(x) <- model$names
  data <- as.data.frame(x)
  data_z <- as.data.frame(scale(data))
  f_std <- fit_one(data, TRUE)
  f_mark <- fit_one(data, FALSE)
  f_z <- fit_one(data_z, TRUE)
  records[[r]] <- list(
    std = if (plausible(f_std)) row_for(f_std) else NULL,
    mark = if (plausible(f_mark)) row_for(f_mark) else NULL,
    z = if (plausible(f_z)) row_for(f_z) else NULL,
    std_any = if (!is.null(f_std) && isTRUE(lavaan::lavInspect(f_std, "converged"))) row_for(f_std) else NULL
  )
}

pct_abs <- function(est, target) 100 * abs(est - target) / abs(target)
pct_signed <- function(est, target) 100 * (est - target) / abs(target)

summarize_paths <- function(recs, field, which_paths = 1:2, target = 0.60,
                            absolute = TRUE, label) {
  mats <- lapply(recs, function(r) r[[field]])
  mats <- mats[!vapply(mats, is.null, logical(1))]
  if (!length(mats)) {
    cat(sprintf("%-28s  n=0\n", label))
    return(invisible(NULL))
  }
  P <- do.call(rbind, lapply(mats, function(v) v[paste0("paths_std", which_paths)]))
  # names may be paths_std1 paths_std2 depending on c()
  # row_for uses c(paths_std = ..., ) which recycles the name
  nm <- names(mats[[1]])
  idx <- grep("^paths_std", nm)[which_paths]
  P <- do.call(rbind, lapply(mats, function(v) v[idx]))
  fn <- if (absolute) pct_abs else pct_signed
  per_rep <- apply(P, 1, function(est) mean(fn(est, target)))
  cat(sprintf("%-42s n=%3d  mean=%7.3f  sd=%6.3f  pathmeans=%s\n",
              label, length(per_rep), mean(per_rep), stats::sd(per_rep),
              paste(round(colMeans(P), 4), collapse = ",")))
  invisible(per_rep)
}

cat("Printed target for this cell: 1.196 (SD 1.271), n converged in the table = 150\n")
cat("Neighboring printed cells at n=1000: i=5 is 2.623, i=7 is 2.623\n\n")

summarize_paths(records, "std", label = "A std.lv absolute paths vs 0.60")
summarize_paths(records, "mark", label = "B marker absolute paths vs 0.60")
summarize_paths(records, "std", absolute = FALSE, label = "C std.lv signed paths vs 0.60")
summarize_paths(records, "mark", absolute = FALSE, label = "D marker signed paths vs 0.60")
summarize_paths(records, "z", label = "E column-z data, std.lv absolute")
summarize_paths(records, "std_any", label = "F std.lv absolute, ignore Heywood")

# bias of the mean, not the mean of absolute deviations
std_ok <- records[vapply(records, function(r) !is.null(r$std), logical(1))]
P <- do.call(rbind, lapply(std_ok, function(r) {
  v <- r$std
  v[grep("^paths_std", names(v))]
}))
cat(sprintf("%-42s n=%3d  value=%7.3f\n",
            "G |mean(path)-0.60|/0.60*100", nrow(P),
            mean(100 * abs(colMeans(P) - 0.60) / 0.60)))

# unstandardized marker paths
mark_ok <- records[vapply(records, function(r) !is.null(r$mark), logical(1))]
U <- do.call(rbind, lapply(mark_ok, function(r) {
  v <- r$mark
  v[grep("^paths_raw", names(v))]
}))
per <- apply(U, 1, function(est) mean(pct_abs(est, 0.60)))
cat(sprintf("%-42s n=%3d  mean=%7.3f  sd=%6.3f\n",
            "H marker unstandardized paths vs 0.60", length(per), mean(per), stats::sd(per)))

# paths plus standardized residual variances (targets 0.60, 0.60, 0.64, 0.64)
both <- do.call(rbind, lapply(std_ok, function(r) {
  v <- r$std
  c(v[grep("^paths_std", names(v))], v[grep("^resid_std", names(v))])
}))
targets <- c(0.60, 0.60, 0.64, 0.64)
per <- apply(both, 1, function(est) mean(pct_abs(est, targets)))
cat(sprintf("%-42s n=%3d  mean=%7.3f  sd=%6.3f\n",
            "I paths and residual variances, absolute", length(per), mean(per), stats::sd(per)))

per_med <- apply(P, 1, function(est) stats::median(pct_abs(est, 0.60)))
cat(sprintf("%-42s n=%3d  mean=%7.3f\n",
            "J mean of within-rep median absolute", nrow(P), mean(per_med)))

# each path alone
for (j in 1:2) {
  per <- pct_abs(P[, j], 0.60)
  cat(sprintf("%-42s n=%3d  mean=%7.3f  sd=%6.3f\n",
              paste0("K path ", j, " alone, absolute"), length(per), mean(per), stats::sd(per)))
}

dest <- file.path(src, "out", "formative_readings.txt")
# The cat() stream is the console. Re-run is the record; also save a copy
# by asking the caller to redirect. Write a small summary file from the
# objects we still have.
sink(dest)
cat("seed0", seed0, "reps", reps, "n", n, "\n")
cat("n_std", sum(vapply(records, function(r) !is.null(r$std), logical(1))), "\n")
cat("n_mark", sum(vapply(records, function(r) !is.null(r$mark), logical(1))), "\n")
cat("mean_abs_std", mean(apply(P, 1, function(est) mean(pct_abs(est, 0.60)))), "\n")
cat("mean_signed_std", mean(apply(P, 1, function(est) mean(pct_signed(est, 0.60)))), "\n")
cat("bias_of_mean", mean(100 * abs(colMeans(P) - 0.60) / 0.60), "\n")
cat("path_means", paste(round(colMeans(P), 5), collapse = ","), "\n")
sink()
cat("wrote", dest, "\n")
