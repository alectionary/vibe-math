#!/usr/bin/env Rscript
# Seven-indicator GSCA trend: gesca 1.0.5 versus cSEM GSCA.
# Printed measurement percent bias, correct reflective, n = 1000:
#   i = 3, 5, 7: 15.918, 9.734, 13.667
# gesca previously fell: about 15.94, 9.85, 7.19.

.libPaths(c("/tmp/rlib", .libPaths()))
suppressPackageStartupMessages({
  library(cSEM)
  library(gesca)
  library(mvtnorm)
})
args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)
src <- if (length(file_arg)) dirname(normalizePath(sub("^--file=", "", file_arg))) else getwd()
source(file.path(src, "population.R"))

reps <- 40L
if ("--reps" %in% commandArgs(trailingOnly = TRUE)) {
  reps <- as.integer(commandArgs(trailingOnly = TRUE)[match("--reps", commandArgs(trailingOnly = TRUE)) + 1L])
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

fit_gesca <- function(data, syn, itmax = 1000, ceps = 1e-5) {
  fit <- tryCatch(suppressMessages(gesca::gesca.run(syn, data, nbt = 0, itmax = itmax, ceps = ceps)),
                  error = function(e) NULL)
  if (is.null(fit)) return(NULL)
  cr <- fit$CR
  rownames(cr) <- fit$wname
  est <- sapply(rownames(cr), function(y) {
    vals <- cr[y, ]
    vals[which.max(abs(vals))]
  })
  paths <- as.numeric(fit$mB)
  list(load = est, paths = paths, fit = unname(fit$FIT), niter = fit$niter)
}

fit_csem <- function(data, syn, dis = FALSE) {
  fit <- tryCatch(
    cSEM::csem(.data = data, .model = syn, .approach_weights = "GSCA",
               .disattenuate = dis, .iter_max = 1000, .tolerance = 1e-5),
    error = function(e) NULL
  )
  if (is.null(fit)) return(NULL)
  L <- fit$Estimates$Loading_estimates
  est <- sapply(colnames(L), function(y) {
    vals <- L[, y]
    vals[which.max(abs(vals))]
  })
  P <- fit$Estimates$Path_estimates
  paths <- c(P["eta2", "eta1"], P["eta3", "eta2"])
  list(load = est, paths = paths)
}

cells <- expand.grid(n = c(1000L), n_items = c(3L, 5L, 7L),
                     stringsAsFactors = FALSE)
# correct reflective only
out <- list()
for (i in seq_len(nrow(cells))) {
  n <- cells$n[i]
  n_items <- cells$n_items[i]
  model <- population_model(n_items, FALSE, FALSE)
  syn <- syntax_of(model)
  seed0 <- 20130715L + 3L * 100000L + match(n_items, c(3, 5, 7)) * 10000L + 1L * 1000L + 1L * 100L
  acc <- list(gesca = c(), csem = c(), csem_dis = c(),
              gesca_path = c(), csem_path = c())
  for (r in seq_len(reps)) {
    set.seed(seed0 + r)
    x <- as.data.frame(mvtnorm::rmvnorm(n, sigma = model$sigma))
    colnames(x) <- model$names
    g <- fit_gesca(x, syn)
    c0 <- fit_csem(x, syn, FALSE)
    c1 <- fit_csem(x, syn, TRUE)
    if (!is.null(g)) {
      acc$gesca <- c(acc$gesca, pct(g$load, 0.70))
      acc$gesca_path <- c(acc$gesca_path, pct(g$paths, 0.60))
    }
    if (!is.null(c0)) {
      acc$csem <- c(acc$csem, pct(c0$load, 0.70))
      acc$csem_path <- c(acc$csem_path, pct(c0$paths, 0.60))
    }
    if (!is.null(c1)) acc$csem_dis <- c(acc$csem_dis, pct(c1$load, 0.70))
  }
  cat(sprintf("\nn=%d i=%d reps=%d seed=%d\n", n, n_items, reps, seed0))
  for (nm in names(acc)) {
    v <- acc[[nm]]
    if (!length(v)) { cat(nm, "none\n"); next }
    cat(sprintf("  %-12s mean %7.3f  sd %6.3f  n %d\n", nm, mean(v), stats::sd(v), length(v)))
  }
  out[[length(out) + 1]] <- c(n = n, i = n_items,
                              gesca = mean(acc$gesca),
                              csem = mean(acc$csem),
                              csem_dis = mean(acc$csem_dis),
                              gesca_path = mean(acc$gesca_path),
                              csem_path = mean(acc$csem_path))
}

# one large-sample look at iteration counts and FIT
model <- population_model(7, FALSE, FALSE)
syn <- syntax_of(model)
set.seed(1)
x <- as.data.frame(mvtnorm::rmvnorm(5000, sigma = model$sigma))
colnames(x) <- model$names
g <- fit_gesca(x, syn)
cat("\nLarge sample i=7 gesca loading pct", round(pct(g$load, 0.70), 3),
    "FIT", round(g$fit, 4), "niter", g$niter, "\n")
g2 <- fit_gesca(x, syn, itmax = 100, ceps = 1e-5)
cat("itmax 100 loading pct", round(pct(g2$load, 0.70), 3), "niter", g2$niter, "\n")

saveRDS(out, file.path(src, "out", "gsca_compare.rds"))
cat("wrote gsca_compare.rds\n")
