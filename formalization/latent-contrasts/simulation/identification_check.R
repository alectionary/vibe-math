# Identification toggle for the Jeffries (2024) contrasts.
# The main Monte Carlo is monte_carlo.R. This script turns one constraint
# off at a time on the balanced true-difference cell.
# Usage: Rscript identification_check.R [reps] [out_dir]

suppressPackageStartupMessages(library(lavaan))
suppressPackageStartupMessages(library(parallel))

args <- commandArgs(trailingOnly = TRUE)
reps <- if (length(args) >= 1) as.integer(args[[1]]) else 200L
out_dir <- if (length(args) >= 2) args[[2]] else "out"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

generate <- function(n_per, means, numeric_codes = FALSE) {
  parts <- lapply(seq_along(means), function(g) {
    eta <- rnorm(n_per, means[[g]], sqrt(0.5))
    x <- sapply(1:4, function(j) 1 + 0.7 * eta + rnorm(n_per, 0, sqrt(0.51)))
    data.frame(i1 = x[, 1], i2 = x[, 2], i3 = x[, 3], i4 = x[, 4], subgroup = g)
  })
  dat <- do.call(rbind, parts)
  sg <- dat$subgroup
  dat$subgroup <- factor(sg)
  c1 <- ifelse(sg %in% c(1, 3), -1, 1)
  c2 <- ifelse(sg %in% c(1, 2), -1, 1)
  c3 <- ifelse(sg %in% c(1, 4), 1, -1)
  if (numeric_codes) {
    dat$c1 <- c1
    dat$c2 <- c2
    dat$c3 <- c3
  } else {
    dat$c1 <- factor(c1, levels = c(-1, 1))
    dat$c2 <- factor(c2, levels = c(-1, 1))
    dat$c3 <- factor(c3, levels = c(-1, 1))
  }
  dat
}

models <- list(
  marker = list(
    model = "
      eta =~ i1 + i2 + i3 + i4
      eta ~ c(a1, a2, a3, a4)*1
      i1 ~ 0*1
      c1def := -(a1 + a3)/2 + (a2 + a4)/2
      c2def := -(a1 + a2)/2 + (a3 + a4)/2
      c3def := -(a2 + a3)/2 + (a1 + a4)/2
    ",
    group = TRUE, labels = c("c1def", "c2def", "c3def"),
    equal = c("loadings", "intercepts")
  ),
  fixed_measurement = list(
    model = "
      eta =~ 0.7*i1 + 0.7*i2 + 0.7*i3 + 0.7*i4
      i1 ~ 1*1
      i2 ~ 1*1
      i3 ~ 1*1
      i4 ~ 1*1
      eta ~ c(a1, a2, a3, a4)*1
      c1def := -(a1 + a3)/2 + (a2 + a4)/2
      c2def := -(a1 + a2)/2 + (a3 + a4)/2
      c3def := -(a2 + a3)/2 + (a1 + a4)/2
    ",
    group = TRUE, labels = c("c1def", "c2def", "c3def"),
    equal = NULL
  ),
  variance_fixed = list(
    model = "
      eta =~ NA*i1 + i2 + i3 + i4
      eta ~~ 0.5*eta
      eta ~ c(a1, a2, a3, a4)*1
      i1 ~ 0*1
      c1def := -(a1 + a3)/2 + (a2 + a4)/2
      c2def := -(a1 + a2)/2 + (a3 + a4)/2
      c3def := -(a2 + a3)/2 + (a1 + a4)/2
    ",
    group = TRUE, labels = c("c1def", "c2def", "c3def"),
    equal = c("loadings", "intercepts")
  ),
  mimic_marker = list(
    model = "
      eta =~ i1 + i2 + i3 + i4
      eta ~ b1*c1 + b2*c2 + b3*c3
    ",
    group = FALSE, labels = c("b1", "b2", "b3"),
    equal = NULL
  ),
  mimic_loading_fixed = list(
    model = "
      eta =~ 0.7*i1 + 0.7*i2 + 0.7*i3 + 0.7*i4
      eta ~ b1*c1 + b2*c2 + b3*c3
    ",
    group = FALSE, labels = c("b1", "b2", "b3"),
    equal = NULL
  ),
  mimic_numeric = list(
    model = "
      eta =~ 0.7*i1 + 0.7*i2 + 0.7*i3 + 0.7*i4
      eta ~ b1*c1 + b2*c2 + b3*c3
    ",
    group = FALSE, labels = c("b1", "b2", "b3"),
    equal = NULL, numeric = TRUE
  )
)

fit_once <- function(dat, spec) {
  fit <- tryCatch(
    if (isTRUE(spec$group)) {
      cfa(spec$model, data = dat, group = "subgroup",
          group.equal = spec$equal, estimator = "MLR", meanstructure = TRUE,
          warn = FALSE, control = list(iter.max = 1000))
    } else {
      sem(spec$model, data = dat, estimator = "MLR",
          warn = FALSE, control = list(iter.max = 1000))
    },
    error = function(e) NULL
  )
  if (is.null(fit) || !isTRUE(lavInspect(fit, "converged"))) return(NULL)
  pe <- parameterEstimates(fit)
  est <- vapply(spec$labels, function(lab) {
    hit <- pe[pe$label == lab, , drop = FALSE]
    if (nrow(hit) != 1) return(c(NA_real_, NA_real_, NA_real_))
    c(hit$est[[1]], hit$se[[1]], hit$pvalue[[1]])
  }, numeric(3))
  if (!all(is.finite(est[2, ]))) return(NULL)
  est
}

run_spec <- function(name, spec, n_per, reps, seed) {
  set.seed(seed)
  means <- c(1, 0.6, 0.8, 0.4)
  store <- vector("list", reps)
  for (r in seq_len(reps)) {
    dat <- generate(n_per, means, numeric_codes = isTRUE(spec$numeric))
    store[[r]] <- fit_once(dat, spec)
  }
  ok <- Filter(Negate(is.null), store)
  rows <- lapply(1:3, function(j) {
    est <- vapply(ok, function(z) z[1, j], numeric(1))
    p <- vapply(ok, function(z) z[3, j], numeric(1))
    data.frame(
      model = name, n_per = n_per, reps = reps, converged = length(ok),
      contrast = j, mean_est = mean(est), sd_est = stats::sd(est),
      pct_sig = mean(p < 0.05) * 100, stringsAsFactors = FALSE
    )
  })
  do.call(rbind, rows)
}

RNGkind("L'Ecuyer-CMRG")
set.seed(13131)
seeds <- sample.int(1e7, length(models))
names(seeds) <- names(models)
message("reps ", reps)
pieces <- mclapply(names(models), function(name) {
  run_spec(name, models[[name]], n_per = 60, reps = reps, seed = seeds[[name]])
}, mc.cores = 3)
tab <- do.call(rbind, pieces)

# One large sample, marker and fixed measurement, not part of the replicate loop.
set.seed(13131)
big <- generate(20000, c(1, 0.6, 0.8, 0.4))
for (name in c("marker", "fixed_measurement", "variance_fixed", "mimic_loading_fixed")) {
  est <- fit_once(big, models[[name]])
  if (is.null(est)) next
  tab <- rbind(tab, data.frame(
    model = paste0(name, "_N20000"), n_per = 20000, reps = 1, converged = 1,
    contrast = 1:3, mean_est = est[1, ], sd_est = NA, pct_sig = NA,
    stringsAsFactors = FALSE
  ))
}

out_csv <- file.path(out_dir, "identification_check.csv")
write.csv(tab, out_csv, row.names = FALSE)
message("wrote ", out_csv)
print(tab)
