#!/usr/bin/env Rscript
# Monte Carlo subset for Chumney (2013).
# Usage, from this directory:
#   Rscript replicate.R --pilot
#   Rscript replicate.R --reps 150
#
# Seeds: cell_seed + replication index. cell_seed is documented in cell_id().

args <- commandArgs(trailingOnly = TRUE)
reps <- 150L
if ("--pilot" %in% args) reps <- 20L
if ("--reps" %in% args) {
  reps <- as.integer(args[match("--reps", args) + 1L])
}
methods <- c("ML", "PLS", "GSCA")
if ("--methods" %in% args) {
  methods <- strsplit(args[match("--methods", args) + 1L], ",", fixed = TRUE)[[1]]
}
pls_scheme <- "centroid"
if ("--wscheme" %in% args) {
  pls_scheme <- args[match("--wscheme", args) + 1L]
}

.libPaths(c("/tmp/rlib", .libPaths()))
suppressPackageStartupMessages({
  library(lavaan)
  library(cSEM)
  library(gesca)
  library(mvtnorm)
})

src <- Sys.getenv("CHUMNEY_SRC", unset = "")
if (!nzchar(src)) {
  args_file <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args_file, value = TRUE)
  src <- if (length(file_arg)) dirname(normalizePath(sub("^--file=", "", file_arg))) else getwd()
}
source(file.path(src, "population.R"))

cell_id <- function(n, n_items, spec, form) {
  # 20130715 is the dissertation date printed on the title page (15 July 2013).
  ni <- match(n, c(50L, 300L, 1000L))
  ii <- match(n_items, c(3L, 5L, 7L))
  si <- if (spec == "correct") 1L else 2L
  fi <- if (form == "reflective") 1L else 2L
  20130715L + ni * 100000L + ii * 10000L + si * 1000L + fi * 100L
}

lavaan_syntax <- function(model) {
  lines <- c()
  for (f in names(model$sets)) {
    lines <- c(lines, paste0(f, " =~ ", paste(model$sets[[f]], collapse = " + ")))
  }
  lines <- c(lines, "eta2 ~ eta1", "eta3 ~ eta2")
  paste(lines, collapse = "\n")
}

fit_ml <- function(data) {
  syn <- lavaan_syntax(attr(data, "model"))
  fit <- tryCatch(
    lavaan::sem(syn, data = data, std.lv = TRUE,
                control = list(iter.max = 1000),
                warn = FALSE),
    error = function(e) NULL
  )
  if (is.null(fit)) return(failed_result())
  conv <- isTRUE(lavaan::lavInspect(fit, "converged"))
  est <- lavaan::lavInspect(fit, "est")
  theta <- diag(est$theta)
  psi <- diag(est$psi)
  plausible <- conv && all(is.finite(theta)) && all(theta > 0) &&
    all(is.finite(psi)) && all(psi > 0)
  if (!plausible) {
    out <- failed_result()
    out$converged_raw <- conv
    return(out)
  }
  std <- lavaan::standardizedSolution(fit)
  load <- std[std$op == "=~", c("lhs", "rhs", "est.std")]
  paths <- std[std$op == "~", c("lhs", "rhs", "est.std")]
  r2 <- lavaan::lavInspect(fit, "rsquare")
  r2_end <- mean(r2[c("eta2", "eta3")])
  cbar <- mean(load$est.std^2)
  list(
    ok = TRUE,
    loadings = setNames(load$est.std, load$rhs),
    paths = paths$est.std,
    gof = sqrt(cbar * r2_end),
    cbar = cbar,
    r2 = r2_end
  )
}

fit_pls <- function(data, wscheme) {
  model <- attr(data, "model")
  syn <- lavaan_syntax(model)
  # .disattenuate = FALSE keeps the classical outer loadings. Consistent
  # PLS (PLSc) is not what semPLS reports.
  scheme <- if (wscheme %in% c("path", "pathWeighting")) "path" else wscheme
  fit <- tryCatch(
    cSEM::csem(
      .data = data, .model = syn,
      .approach_weights = "PLS-PM",
      .PLS_weight_scheme_inner = scheme,
      .disattenuate = FALSE,
      .iter_max = 1000,
      .tolerance = 1e-05
    ),
    error = function(e) NULL
  )
  if (is.null(fit)) return(failed_result())
  L <- fit$Estimates$Loading_estimates
  est <- numeric(length(model$names))
  names(est) <- model$names
  for (y in model$names) {
    vals <- L[, y]
    est[y] <- vals[which.max(abs(vals))]
  }
  P <- fit$Estimates$Path_estimates
  paths <- c(P["eta2", "eta1"], P["eta3", "eta2"])
  r2 <- fit$Estimates$R2
  r2_end <- mean(r2[c("eta2", "eta3")])
  cbar <- mean(est^2)
  if (any(!is.finite(est)) || any(abs(est) > 1 + 1e-6) || any(!is.finite(paths))) {
    return(failed_result())
  }
  list(ok = TRUE, loadings = est, paths = paths,
       gof = sqrt(cbar * r2_end), cbar = cbar, r2 = r2_end)
}

fit_gsca <- function(data) {
  model <- attr(data, "model")
  syn <- lavaan_syntax(model)
  # gesca uses the same =~ / ~ syntax. nbt = 0 skips the bootstrap.
  # The ALS progress line is printed with cat(), so capture it.
  fit <- tryCatch(
    suppressMessages(
      gesca::gesca.run(syn, data, nbt = 0, itmax = 1000, ceps = 1e-5)
    ),
    error = function(e) NULL
  )
  if (is.null(fit)) return(failed_result())
  # CR is indicators by latents; the nonzero entry is the component loading.
  # mB is the structural coefficients in equation order (eta2~eta1, eta3~eta2).
  est <- numeric(length(model$names))
  names(est) <- model$names
  cr <- fit$CR
  rownames(cr) <- fit$wname
  colnames(cr) <- fit$lname
  for (y in model$names) {
    vals <- cr[y, ]
    est[y] <- vals[which.max(abs(vals))]
  }
  paths <- as.numeric(fit$mB)
  r2 <- as.numeric(fit$R2)
  # Column order follows lname: eta1, eta2, eta3. eta1 is exogenous.
  r2_end <- mean(r2[match(c("eta2", "eta3"), fit$lname)])
  cbar <- mean(est^2)
  # A component loading outside [-1, 1] implies a negative residual variance
  # on the standardized indicator, which the dissertation counts as implausible.
  if (any(!is.finite(est)) || any(abs(est) > 1) || any(!is.finite(paths))) {
    return(failed_result())
  }
  list(ok = TRUE, loadings = est, paths = paths, gof = sqrt(cbar * r2_end),
       cbar = cbar, r2 = r2_end)
}

failed_result <- function() {
  list(ok = FALSE, loadings = NULL, paths = NULL, gof = NA_real_,
       cbar = NA_real_, r2 = NA_real_)
}

percent_bias <- function(est, target) {
  100 * abs(est - target) / abs(target)
}

one_rep <- function(model, n, seed, wscheme) {
  set.seed(seed)
  x <- mvtnorm::rmvnorm(n, sigma = model$sigma)
  colnames(x) <- model$names
  data <- as.data.frame(x)
  attr(data, "model") <- model
  out <- list()
  if ("ML" %in% methods) out$ML <- fit_ml(data)
  if ("PLS" %in% methods) out$PLS <- fit_pls(data, wscheme)
  if ("GSCA" %in% methods) out$GSCA <- fit_gsca(data)
  out
}

summarize_method <- function(reps, model) {
  ok <- vapply(reps, function(r) isTRUE(r$ok), logical(1))
  n_ok <- sum(ok)
  if (n_ok == 0) {
    return(list(n_ok = 0L, n = length(reps)))
  }
  use <- reps[ok]
  meas <- vapply(use, function(r) {
    mean(percent_bias(r$loadings[model$names], model$nominal_loading))
  }, numeric(1))
  # Model-implied completely standardized primary loadings.
  implied <- diag(0, length(model$names))
  implied <- sapply(model$names, function(y) {
    # primary factor is the one with unstandardized loading 1
    j <- which(model$lambda[y, ] == 1)
    if (length(j) != 1) j <- which.max(abs(model$lambda[y, ]))
    model$lambda_std[y, j]
  })
  meas_implied <- vapply(use, function(r) {
    mean(percent_bias(r$loadings[model$names], implied))
  }, numeric(1))
  struct <- vapply(use, function(r) mean(percent_bias(r$paths, model$path)), numeric(1))
  gof <- vapply(use, function(r) r$gof, numeric(1))
  pop <- population_gof(model)
  list(
    n_ok = n_ok,
    n = length(reps),
    meas_mean = mean(meas),
    meas_sd = stats::sd(meas),
    meas_implied_mean = mean(meas_implied),
    meas_implied_sd = stats::sd(meas_implied),
    struct_mean = mean(struct),
    struct_sd = stats::sd(struct),
    gof_mean = mean(gof),
    gof_sd = stats::sd(gof),
    gof_bias_std = mean(gof) - pop$gof,
    gof_bias_one = mean(gof) - pop$gof_loading_one,
    pop_gof = pop$gof,
    pop_gof_one = pop$gof_loading_one
  )
}

run_cell <- function(n, n_items, spec, form, reps, wscheme) {
  model <- population_model(n_items, formative = form == "formative",
                            misspecified = spec == "misspec")
  seed0 <- cell_id(n, n_items, spec, form)
  cat(sprintf("cell n=%d i=%d %s %s seed=%d\n", n, n_items, spec, form, seed0))
  results <- vector("list", reps)
  for (r in seq_len(reps)) {
    results[[r]] <- one_rep(model, n, seed0 + r, wscheme)
    if (r %% 25 == 0) cat("  rep", r, "\n")
  }
  summary <- lapply(methods, function(m) {
    summarize_method(lapply(results, function(z) z[[m]]), model)
  })
  names(summary) <- methods
  list(n = n, n_items = n_items, spec = spec, form = form,
       seed = seed0, wscheme = wscheme, summary = summary)
}

# The dissertation's data conditions are 3 x 3 x 2 x 2 = 36. MCMC is not
# in this grid. Pass --slice i3 to keep the three-indicator slice.
default_cells <- function() {
  items <- c(3L, 5L, 7L)
  if ("--slice" %in% args && args[match("--slice", args) + 1L] == "i3") {
    items <- 3L
  }
  expand.grid(
    n = c(50L, 300L, 1000L),
    n_items = items,
    spec = c("correct", "misspec"),
    form = c("reflective", "formative"),
    stringsAsFactors = FALSE
  )
}

main <- function() {
  cells <- default_cells()
  t0 <- proc.time()
  out <- vector("list", nrow(cells))
  for (i in seq_len(nrow(cells))) {
    out[[i]] <- run_cell(cells$n[i], cells$n_items[i], cells$spec[i],
                         cells$form[i], reps, pls_scheme)
  }
  elapsed <- proc.time() - t0
  dest <- file.path(src, "out")
  dir.create(dest, showWarnings = FALSE, recursive = TRUE)
  slice <- if ("--slice" %in% args) args[match("--slice", args) + 1L] else "full"
  tag <- if (reps < 150) sprintf("pilot-%d", reps) else paste0("reps", reps)
  tag <- paste0(tag, "-", slice)
  if (pls_scheme != "centroid") tag <- paste0(tag, "-", pls_scheme)
  path <- file.path(dest, paste0(tag, ".rds"))
  saveRDS(list(reps = reps, methods = methods, wscheme = pls_scheme,
               elapsed = elapsed, cells = out,
               session = utils::sessionInfo()), path)
  cat("wrote", path, "\n")
  cat("elapsed sec", elapsed[["elapsed"]], "\n")
  print_table(out)
}

print_table <- function(out) {
  for (cell in out) {
    cat(sprintf("\n=== n=%d i=%d %s %s ===\n", cell$n, cell$n_items, cell$spec, cell$form))
    for (m in names(cell$summary)) {
      s <- cell$summary[[m]]
      cat(sprintf(
        "%-5s conv %3d/%d  meas %7.3f (sd %6.3f)  struct %7.3f (sd %6.3f)  gof %7.3f (sd %6.3f)  bias_std %7.3f  bias_one %7.3f\n",
        m, s$n_ok, s$n,
        s$meas_mean %||% NA, s$meas_sd %||% NA,
        s$struct_mean %||% NA, s$struct_sd %||% NA,
        s$gof_mean %||% NA, s$gof_sd %||% NA,
        s$gof_bias_std %||% NA, s$gof_bias_one %||% NA
      ))
    }
  }
}

`%||%` <- function(a, b) if (is.null(a) || length(a) == 0 || (length(a) == 1 && is.na(a))) b else a

# Probe gesca once so parse_gesca can be finished before the loop if needed.
probe_gesca <- function() {
  model <- population_model(3, FALSE, FALSE)
  set.seed(1)
  x <- as.data.frame(mvtnorm::rmvnorm(200, sigma = model$sigma))
  colnames(x) <- model$names
  syn <- lavaan_syntax(model)
  fit <- tryCatch(gesca::gesca.run(syn, x, nbt = 0, itmax = 100), error = function(e) e)
  if (inherits(fit, "error")) {
    cat("gesca error:", conditionMessage(fit), "\n")
    fit <- tryCatch(gesca::gesca.run(syn, x, nbt = 1, itmax = 100), error = function(e) e)
    if (inherits(fit, "error")) {
      cat("gesca nbt=1 error:", conditionMessage(fit), "\n")
      return(invisible(NULL))
    }
  }
  cat("gesca class:", paste(class(fit), collapse = ","), "\n")
  cat("names:", paste(names(fit), collapse = ", "), "\n")
  str(fit, max.level = 1)
  invisible(fit)
}

if (sys.nframe() == 0) {
  if ("--probe-gesca" %in% args) {
    probe_gesca()
  } else {
    main()
  }
}
