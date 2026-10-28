# Monte Carlo under the model strings posted with the dissertation's OSF project
# (https://osf.io/q9yu8/, retrieved 2026-10-27).
#
# Data generation follows the Appendix A syntax as lavaan 0.6.17 parses it.
# `NA*i1 + 0.7*i1` leaves the first loading free, and simulateData fills a free
# loading with 1. Loadings 2--4 stay at 0.7, the factor variance at 0.5, and
# every intercept at 1.
#
# The MGCFA string is the one in mgcfa_model.R. The MIMIC string in
# mimic_model.R fixes the latent intercept at 0 in lavaan 0.6.17. A second
# MIMIC fit frees that intercept (`eta ~ 1 + c1 + c2 + c3`). The saved OSF
# summaries are near -0.40, which is the free-intercept value.
#
# Usage: Rscript validate_gaps.R [reps] [out_dir]

suppressPackageStartupMessages(library(lavaan))
suppressPackageStartupMessages(library(parallel))

args <- commandArgs(trailingOnly = TRUE)
reps <- if (length(args) >= 1) as.integer(args[[1]]) else 400L
out_dir <- if (length(args) >= 2) args[[2]] else "out"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

lambda <- c(1, 0.7, 0.7, 0.7)
psi <- 0.5
theta <- 0.51

generate <- function(n_g, means) {
  parts <- lapply(seq_along(n_g), function(g) {
    eta <- rnorm(n_g[[g]], means[[g]], sqrt(psi))
    x <- sapply(seq_along(lambda), function(j) {
      1 + lambda[[j]] * eta + rnorm(n_g[[g]], 0, sqrt(theta))
    })
    data.frame(i1 = x[, 1], i2 = x[, 2], i3 = x[, 3], i4 = x[, 4], subgroup = g)
  })
  dat <- do.call(rbind, parts)
  sg <- dat$subgroup
  dat$subgroup <- factor(sg)
  # Appendix A. Levels are -1 and 1. c3 is the negative of Table 2.2.
  dat$c1 <- factor(ifelse(sg %in% c(1, 3), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
  dat$c2 <- factor(ifelse(sg %in% c(1, 2), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
  dat$c3 <- factor(ifelse(sg %in% c(1, 4), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
  dat
}

mg_model <- "
eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ c(a, b, c, d)*1
i1 + i2 + i3 + i4 ~ c(eq, eq, eq, eq)*1
c1 := -1*((a + c) / 2) + ((b + d) / 2)
c2 := -1*((a + b) / 2) + ((c + d) / 2)
c3 := -1*((b + c) / 2) + ((a + d) / 2)
"

mimic_posted <- "
eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ c1 + c2 + c3
i1 + i2 + i3 + i4 ~ eq*1
"

mimic_free <- "
eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ 1 + c1 + c2 + c3
i1 + i2 + i3 + i4 ~ eq*1
"

variances_ok <- function(fit) {
  pe <- parameterEstimates(fit)
  v <- pe$est[pe$op == "~~" & pe$lhs == pe$rhs]
  length(v) > 0 && all(is.finite(v)) && all(v >= -1e-8)
}

one_fit <- function(dat, kind) {
  fit <- tryCatch(
    if (kind == "mgcfa") {
      sem(mg_model, data = dat, group = "subgroup", missing = "ML",
          estimator = "MLR", meanstructure = TRUE, warn = FALSE,
          control = list(iter.max = 10000))
    } else if (kind == "mimic_free") {
      sem(mimic_free, data = dat, missing = "ML", estimator = "MLR",
          warn = FALSE, control = list(iter.max = 10000))
    } else {
      sem(mimic_posted, data = dat, missing = "ML", estimator = "MLR",
          warn = FALSE, control = list(iter.max = 10000))
    },
    error = function(e) NULL
  )
  empty <- c(0, 0, rep(NA_real_, 9))
  if (is.null(fit)) return(empty)
  optim_ok <- isTRUE(lavInspect(fit, "converged"))
  var_ok <- isTRUE(tryCatch(variances_ok(fit), error = function(e) FALSE))
  pe <- tryCatch(parameterEstimates(fit), error = function(e) NULL)
  if (is.null(pe)) return(c(as.numeric(optim_ok), as.numeric(var_ok), rep(NA_real_, 9)))
  est <- se <- p <- rep(NA_real_, 3)
  if (kind == "mgcfa") {
    for (j in 1:3) {
      hit <- pe[pe$label == c("c1", "c2", "c3")[[j]], , drop = FALSE]
      if (nrow(hit) == 1) {
        est[[j]] <- hit$est[[1]]
        se[[j]] <- hit$se[[1]]
        p[[j]] <- hit$pvalue[[1]]
      }
    }
  } else {
    hit <- pe[pe$lhs == "eta" & pe$op == "~" & pe$rhs %in% c("c1", "c2", "c3"), , drop = FALSE]
    for (name in c("c1", "c2", "c3")) {
      row <- hit[hit$rhs == name, , drop = FALSE]
      j <- match(name, c("c1", "c2", "c3"))
      if (nrow(row) == 1) {
        est[[j]] <- row$est[[1]]
        se[[j]] <- row$se[[1]]
        p[[j]] <- row$pvalue[[1]]
      }
    }
  }
  c(as.numeric(optim_ok), as.numeric(var_ok), est, se, p)
}

run_cell <- function(cell) {
  means <- if (cell$setting == "true") c(1, 0.6, 0.8, 0.4) else c(1, 1, 1, 1)
  n_g <- switch(as.character(cell$cond),
    "1" = rep(cell$N / 4, 4),
    "2" = c(0.35, 0.35, 0.15, 0.15) * cell$N,
    "3" = c(0.45, 0.45, 0.05, 0.05) * cell$N
  )
  n_g <- as.integer(round(n_g))
  set.seed(cell$seed[[1]])
  store <- vector("list", cell$reps)
  for (r in seq_len(cell$reps)) {
    store[[r]] <- one_fit(generate(n_g, means), cell$kind)
  }
  mat <- do.call(rbind, store)
  optim_ok <- mat[, 1] == 1
  var_ok <- mat[, 2] == 1
  usable <- optim_ok & apply(mat[, 3:11], 1, function(z) all(is.finite(z)))
  rows <- lapply(1:3, function(j) {
    est <- mat[usable, 2 + j]
    se <- mat[usable, 5 + j]
    p <- mat[usable, 8 + j]
    data.frame(
      kind = cell$kind, N = cell$N, cond = cell$cond, setting = cell$setting,
      contrast = j, reps = cell$reps,
      n_optim = sum(optim_ok), n_var_ok = sum(optim_ok & var_ok),
      n_used = sum(usable),
      mean_est = mean(est), sd_est = stats::sd(est),
      se_of_mean = stats::sd(est) / sqrt(length(est)),
      mean_se = mean(se), pct_sig = mean(p < 0.05) * 100,
      stringsAsFactors = FALSE
    )
  })
  do.call(rbind, rows)
}

# Large-sample check, one draw per cell, before the Monte Carlo.
large_n <- function() {
  rows <- list()
  specs <- list(
    list(kind = "mgcfa", cond = 1, setting = "true"),
    list(kind = "mgcfa", cond = 3, setting = "true"),
    list(kind = "mimic_free", cond = 1, setting = "true"),
    list(kind = "mimic_posted", cond = 1, setting = "true")
  )
  set.seed(1)
  for (sp in specs) {
    means <- c(1, 0.6, 0.8, 0.4)
    n_g <- if (sp$cond == 1) rep(20000, 4) else c(20000, 20000, 4000, 4000)
    dat <- generate(n_g, means)
    ans <- one_fit(dat, sp$kind)
    for (j in 1:3) {
      rows[[length(rows) + 1]] <- data.frame(
        kind = sp$kind, cond = sp$cond, contrast = j,
        est = ans[[2 + j]], se = ans[[5 + j]], stringsAsFactors = FALSE
      )
    }
  }
  tab <- do.call(rbind, rows)
  write.csv(tab, file.path(out_dir, "large_n_check.csv"), row.names = FALSE)
  tab
}

message("large-N check")
print(large_n())

cells <- rbind(
  data.frame(kind = "mgcfa", N = 240, cond = c(1, 2, 3), setting = "true", reps = reps),
  data.frame(kind = "mgcfa", N = 240, cond = c(1, 2, 3), setting = "null", reps = reps),
  data.frame(kind = "mimic_free", N = 240, cond = c(1, 3), setting = "true", reps = reps),
  data.frame(kind = "mimic_free", N = 240, cond = c(1, 3), setting = "null", reps = reps),
  data.frame(kind = "mimic_posted", N = 240, cond = 1, setting = "true", reps = reps)
)
RNGkind("L'Ecuyer-CMRG")
set.seed(13131)
cell_list <- split(cells, seq_len(nrow(cells)))
cell_list <- lapply(cell_list, function(df) {
  df$seed <- sample.int(1e7, 1)
  df
})
message("cells ", length(cell_list), " reps ", reps)
pieces <- mclapply(cell_list, run_cell, mc.cores = 3)
tab <- do.call(rbind, pieces)
out_csv <- file.path(out_dir, "validate_gaps.csv")
write.csv(tab, out_csv, row.names = FALSE)
message("wrote ", out_csv)
print(tab)
