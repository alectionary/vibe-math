#!/usr/bin/env Rscript
# Bayesian arm for the Chumney (2013) design.
#
# The procedures section sets the maximum number of iterations to 1,000
# and estimates MCMC in Mplus 6. It does not name a prior, a chain count,
# or a PSR cutoff. Mplus 6's default priors, which the dissertation's
# cited Bayesian Mplus notes call noninformative, are a flat prior on
# loadings and regressions and IG(-1, 0) on variances. Stan requires
# proper priors, so the loadings and regressions use normal(0, 1e4) and
# the standard deviations use gamma(0.01, 0.01). Two chains, 500 burn-in
# iterations and 500 retained draws (1,000 iterations in total), and
# convergence when the largest potential scale reduction is below 1.05,
# which is Mplus's default BCONVERGENCE of 0.05.
#
# Usage:
#   Rscript bayes_subset.R --reps 40

.libPaths(c("/tmp/rlib", .libPaths()))
suppressPackageStartupMessages({
  library(blavaan)
  library(lavaan)
  library(mvtnorm)
  library(coda)
})
args <- commandArgs(trailingOnly = TRUE)
reps <- 40L
if ("--reps" %in% args) reps <- as.integer(args[match("--reps", args) + 1L])
file_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
src <- if (length(file_arg)) dirname(normalizePath(sub("^--file=", "", file_arg))) else getwd()
source(file.path(src, "population.R"))

# A Stan translation of Mplus's improper IG(-1, 0) variance prior,
# gamma(0.01, 0.01) on the standard deviation with normal(0, 1e4)
# loadings, produced divergent transitions and a potential scale
# reduction of 2.39 on a single n = 50 fit. The run below uses
# blavaan's proper defaults: normal(0, 10) for loadings and
# regressions, and gamma(1, 0.5) for residual standard deviations.
# Those priors are weakly informative. The dissertation discusses
# noninformative priors and does not name a numeric prior.

cell_id <- function(n, n_items, spec, form) {
  ni <- match(n, c(50L, 300L, 1000L))
  ii <- match(n_items, c(3L, 5L, 7L))
  si <- if (spec == "correct") 1L else 2L
  fi <- if (form == "reflective") 1L else 2L
  20130715L + ni * 100000L + ii * 10000L + si * 1000L + fi * 100L
}

syntax_of <- function(model) {
  paste(
    paste0("eta1 =~ ", paste(model$sets$eta1, collapse = " + ")),
    paste0("eta2 =~ ", paste(model$sets$eta2, collapse = " + ")),
    paste0("eta3 =~ ", paste(model$sets$eta3, collapse = " + ")),
    "eta2 ~ eta1",
    "eta3 ~ eta2",
    sep = "\n"
  )
}

pct <- function(est, target) 100 * mean(abs(est - target) / abs(target))

fit_bayes <- function(data, syn, seed) {
  fit <- tryCatch(
    blavaan::bsem(
      syn, data = data, std.lv = TRUE,
      n.chains = 2, burnin = 500, sample = 500, adapt = 500,
      target = "stan",
      seed = seed,
      bcontrol = list(adapt_delta = 0.8)
    ),
    error = function(e) e
  )
  if (inherits(fit, "error")) return(list(ok = FALSE, reason = conditionMessage(fit)))
  psrf <- tryCatch(blavaan::blavInspect(fit, "psrf"), error = function(e) NULL)
  mx <- if (is.null(psrf)) Inf else max(as.numeric(psrf), na.rm = TRUE)
  conv <- is.finite(mx) && mx < 1.05
  if (!conv) return(list(ok = FALSE, psrf = mx))
  std <- lavaan::standardizedSolution(fit)
  load <- std$est.std[std$op == "=~"]
  paths <- std$est.std[std$op == "~"]
  # names
  load_nm <- std$rhs[std$op == "=~"]
  if (any(!is.finite(load)) || any(!is.finite(paths))) return(list(ok = FALSE, psrf = mx))
  list(ok = TRUE, psrf = mx, loadings = setNames(load, load_nm), paths = paths)
}

# Documented subset: both sample-size extremes, three indicators, all four
# specification cells, plus the seven-indicator correct reflective cells
# where Table 1 shows MCMC convergence falling from 147 to 51 at n = 50.
cells <- rbind(
  expand.grid(n = c(50L, 1000L), n_items = 3L,
              spec = c("correct", "misspec"),
              form = c("reflective", "formative"),
              stringsAsFactors = FALSE),
  data.frame(n = c(50L, 1000L), n_items = 7L,
             spec = "correct", form = "reflective",
             stringsAsFactors = FALSE)
)

results <- list()
t0 <- proc.time()
for (i in seq_len(nrow(cells))) {
  n <- cells$n[i]; n_items <- cells$n_items[i]
  spec <- cells$spec[i]; form <- cells$form[i]
  model <- population_model(n_items, form == "formative", spec == "misspec")
  syn <- syntax_of(model)
  seed0 <- cell_id(n, n_items, spec, form)
  cat(sprintf("cell n=%d i=%d %s %s seed=%d\n", n, n_items, spec, form, seed0))
  reps_out <- vector("list", reps)
  for (r in seq_len(reps)) {
    set.seed(seed0 + r)
    x <- as.data.frame(mvtnorm::rmvnorm(n, sigma = model$sigma))
    colnames(x) <- model$names
    tr <- system.time(reps_out[[r]] <- fit_bayes(x, syn, seed0 + r))
    if (r == 1 || r %% 10 == 0) cat(sprintf("  rep %d  %.1fs  ok=%s psrf=%s\n",
      r, tr[["elapsed"]], reps_out[[r]]$ok,
      if (is.null(reps_out[[r]]$psrf)) NA else round(reps_out[[r]]$psrf, 3)))
  }
  ok <- vapply(reps_out, function(z) isTRUE(z$ok), logical(1))
  meas <- if (any(ok)) vapply(reps_out[ok], function(z) pct(z$loadings[model$names], model$nominal_loading), numeric(1)) else numeric()
  struct <- if (any(ok)) vapply(reps_out[ok], function(z) pct(z$paths, 0.60), numeric(1)) else numeric()
  results[[i]] <- list(
    n = n, n_items = n_items, spec = spec, form = form, seed = seed0,
    n_ok = sum(ok), n_rep = reps,
    meas_mean = if (length(meas)) mean(meas) else NA,
    meas_sd = if (length(meas) > 1) stats::sd(meas) else NA,
    struct_mean = if (length(struct)) mean(struct) else NA,
    struct_sd = if (length(struct) > 1) stats::sd(struct) else NA
  )
  cat(sprintf("  conv %d/%d  meas %s  struct %s\n",
              sum(ok), reps,
              if (length(meas)) round(mean(meas), 3) else NA,
              if (length(struct)) round(mean(struct), 3) else NA))
}
elapsed <- proc.time() - t0
dest <- file.path(src, "out", sprintf("bayes-reps%d.rds", reps))
saveRDS(list(reps = reps, elapsed = elapsed, cells = results,
             priors = "blavaan defaults: normal(0,10) loadings and regressions; gamma(1,0.5) on residual sd",
             iterations = "2 chains, burnin 500, sample 500, adapt 500, PSR < 1.05",
             session = utils::sessionInfo()), dest)
cat("wrote", dest, "elapsed", elapsed[["elapsed"]], "\n")
