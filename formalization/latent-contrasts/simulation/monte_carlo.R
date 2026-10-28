# Equal-loading reading of the Jeffries (2024) design.
# Every indicator is generated at loading 0.7. That is the Chapter III sentence.
# It is not the population lavaan builds from the Appendix A string, and it is
# not the model in the public OSF analysis script. validate_gaps.R and
# candidate_readings.R fit those. This file is kept so the earlier
# out/monte_carlo.csv remains reproducible.
#
# lavaan 0.6.17 is the version named in the dissertation. The random-number
# stream is R's, not simsem's, so replicates are not the printed ones.
# Usage: Rscript monte_carlo.R [reps_n240] [reps_n960] [out_dir]
# Recorded run: Rscript monte_carlo.R 200 100 out
# Seed: set.seed(13131) inside the script, after RNGkind("L'Ecuyer-CMRG").

suppressPackageStartupMessages(library(lavaan))
suppressPackageStartupMessages(library(parallel))

args <- commandArgs(trailingOnly = TRUE)
reps240 <- if (length(args) >= 1) as.integer(args[[1]]) else 250L
reps960 <- if (length(args) >= 2) as.integer(args[[2]]) else 120L
out_dir <- if (length(args) >= 3) args[[3]] else "out"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

sizes <- function(N, cond) {
  raw <- if (cond == 1) rep(N / 4, 4)
    else if (cond == 2) c(0.35, 0.35, 0.15, 0.15) * N
    else c(0.45, 0.45, 0.05, 0.05) * N
  as.integer(round(raw))
}

generate <- function(n_g, means) {
  parts <- lapply(seq_along(n_g), function(g) {
    eta <- rnorm(n_g[[g]], means[[g]], sqrt(0.5))
    x <- sapply(1:4, function(j) 1 + 0.7 * eta + rnorm(n_g[[g]], 0, sqrt(0.51)))
    data.frame(i1 = x[, 1], i2 = x[, 2], i3 = x[, 3], i4 = x[, 4], subgroup = g)
  })
  dat <- do.call(rbind, parts)
  sg <- dat$subgroup
  dat$subgroup <- factor(sg)
  dat$c1 <- factor(ifelse(sg %in% c(1, 3), -1, 1), levels = c(-1, 1))
  dat$c2 <- factor(ifelse(sg %in% c(1, 2), -1, 1), levels = c(-1, 1))
  # Table 2.2 column C3, not the negated appendix recode.
  dat$c3 <- factor(ifelse(sg %in% c(1, 4), 1, -1), levels = c(-1, 1))
  dat
}

mg_marker <- "
  eta =~ i1 + i2 + i3 + i4
  eta ~ c(a1, a2, a3, a4)*1
  i1 ~ 0*1
  c1def := -(a1 + a3)/2 + (a2 + a4)/2
  c2def := -(a1 + a2)/2 + (a3 + a4)/2
  c3def := -(a2 + a3)/2 + (a1 + a4)/2
"

mg_fixed <- "
  eta =~ 0.7*i1 + 0.7*i2 + 0.7*i3 + 0.7*i4
  i1 ~ 1*1
  i2 ~ 1*1
  i3 ~ 1*1
  i4 ~ 1*1
  eta ~ c(a1, a2, a3, a4)*1
  c1def := -(a1 + a3)/2 + (a2 + a4)/2
  c2def := -(a1 + a2)/2 + (a3 + a4)/2
  c3def := -(a2 + a3)/2 + (a1 + a4)/2
"

mimic_model <- "
  eta =~ i1 + i2 + i3 + i4
  eta ~ b1*c1 + b2*c2 + b3*c3
"

pull_defined <- function(fit, labels) {
  pe <- parameterEstimates(fit)
  rows <- lapply(labels, function(lab) {
    hit <- pe[pe$label == lab, , drop = FALSE]
    if (nrow(hit) != 1) return(c(est = NA, se = NA, p = NA))
    c(est = hit$est[[1]], se = hit$se[[1]], p = hit$pvalue[[1]])
  })
  do.call(rbind, rows)
}

one_fit <- function(dat, kind) {
  fit <- tryCatch(
    if (kind == "marker") {
      cfa(mg_marker, data = dat, group = "subgroup",
          group.equal = c("loadings", "intercepts"),
          estimator = "MLR", meanstructure = TRUE,
          warn = FALSE,
          control = list(iter.max = 1000))
    } else if (kind == "fixed") {
      cfa(mg_fixed, data = dat, group = "subgroup",
          estimator = "MLR", meanstructure = TRUE,
          warn = FALSE,
          control = list(iter.max = 1000))
    } else {
      sem(mimic_model, data = dat, estimator = "MLR",
          warn = FALSE,
          control = list(iter.max = 1000))
    },
    error = function(e) NULL
  )
  if (is.null(fit)) return(NULL)
  labels <- if (kind == "mimic") c("b1", "b2", "b3") else c("c1def", "c2def", "c3def")
  est <- tryCatch(pull_defined(fit, labels), error = function(e) NULL)
  if (is.null(est)) return(NULL)
  converged <- isTRUE(lavInspect(fit, "converged")) && all(is.finite(est[, "se"]))
  list(converged = converged, est = est)
}

run_cell <- function(cell) {
  means <- if (cell$setting == "true") c(1, 0.6, 0.8, 0.4) else c(1, 1, 1, 1)
  n_g <- sizes(cell$N, cell$cond)
  store <- vector("list", cell$reps)
  for (r in seq_len(cell$reps)) {
    dat <- generate(n_g, means)
    store[[r]] <- one_fit(dat, cell$kind)
  }
  ok <- Filter(function(z) !is.null(z) && isTRUE(z$converged), store)
  summarize <- function(j) {
    if (!length(ok)) {
      return(c(mean = NA, sd = NA, pct = NA))
    }
    est <- vapply(ok, function(z) z$est[j, "est"], numeric(1))
    p <- vapply(ok, function(z) z$est[j, "p"], numeric(1))
    c(mean = mean(est), sd = stats::sd(est), pct = mean(p < 0.05) * 100)
  }
  rows <- lapply(1:3, function(j) {
    s <- summarize(j)
    data.frame(
      kind = cell$kind, N = cell$N, cond = cell$cond, setting = cell$setting,
      contrast = j, reps = cell$reps, attempted = length(store),
      converged = length(ok),
      mean_est = s[["mean"]], sd_est = s[["sd"]], pct_sig = s[["pct"]],
      stringsAsFactors = FALSE
    )
  })
  do.call(rbind, rows)
}

cells <- rbind(
  data.frame(kind = "marker", N = 240, cond = 1:3, setting = "true", reps = reps240),
  data.frame(kind = "marker", N = 240, cond = 1:3, setting = "null", reps = reps240),
  data.frame(kind = "mimic", N = 240, cond = 1:3, setting = "true", reps = reps240),
  data.frame(kind = "mimic", N = 240, cond = 1:3, setting = "null", reps = reps240),
  data.frame(kind = "marker", N = 960, cond = c(1, 3), setting = "true", reps = reps960),
  data.frame(kind = "mimic", N = 960, cond = c(1, 3), setting = "true", reps = reps960),
  data.frame(kind = "fixed", N = 240, cond = 1, setting = "true", reps = min(80L, reps240))
)
cells <- cells[rep(seq_len(nrow(cells)), 1), ]
cell_list <- split(cells, seq_len(nrow(cells)))

RNGkind("L'Ecuyer-CMRG")
set.seed(13131)
cell_list <- lapply(cell_list, function(df) {
  df$seed <- sample.int(1e7, 1)
  df
})

worker <- function(df) {
  set.seed(df$seed[[1]])
  run_cell(df)
}

message("cells ", length(cell_list), " cores 3")
pieces <- mclapply(cell_list, worker, mc.cores = 3)
tab <- do.call(rbind, pieces)
out_csv <- file.path(out_dir, "monte_carlo.csv")
write.csv(tab, out_csv, row.names = FALSE)
message("wrote ", out_csv)
print(tab)
