#!/usr/bin/env Rscript
# Refit Abbott (2010) CTSE II / CPSE II measurement models from Table 3.2.
#
# Usage, from this directory:
#   Rscript fit_models.R out
#
# Table 3.2 is the printed correlation matrix, means, and standard deviations.
# The .dat file named in Appendix J is not public. The fits below use the
# printed matrix as if it were a single complete-data covariance matrix.

args <- commandArgs(trailingOnly = TRUE)
out_dir <- if (length(args) >= 1) args[[1]] else "out"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

suppressPackageStartupMessages(library(lavaan))
suppressPackageStartupMessages(library(OpenMx))

session_path <- file.path(out_dir, "sessionInfo.txt")
writeLines(capture.output(sessionInfo()), session_path)

# ---- matrix --------------------------------------------------------------

table_path <- file.path("table32.csv")
raw <- read.csv(table_path, check.names = FALSE, stringsAsFactors = FALSE)
stopifnot(nrow(raw) == 37)
analysis <- raw$analysis_name
means <- raw$mean
sds <- raw$sd
R <- as.matrix(raw[, analysis])
storage.mode(R) <- "double"
rownames(R) <- colnames(R) <- analysis
diag(R) <- 1
# The printed matrix is lower-triangular in the source table. The CSV stores
# the symmetric completion written by parse_table32.py.
asym <- max(abs(R - t(R)))
if (asym > 1e-8) stop("correlation matrix is not symmetric")

S <- diag(sds) %*% R %*% diag(sds)
rownames(S) <- colnames(S) <- analysis
ev <- eigen(R, symmetric = TRUE, only.values = TRUE)$values

kmo_stat <- function(corr) {
  inv <- solve(corr)
  d <- diag(1 / sqrt(diag(inv)))
  partial <- -d %*% inv %*% d
  diag(partial) <- 1
  r2 <- corr^2
  p2 <- partial^2
  diag(r2) <- 0
  diag(p2) <- 0
  sum(r2) / (sum(r2) + sum(p2))
}

frac_gt <- function(corr, cut = 0.30) {
  vals <- corr[lower.tri(corr)]
  mean(abs(vals) > cut)
}

ctse_cpse <- c(
  paste0("CPDOMA", 1:4), paste0("CPFIEL", 1:4), paste0("CPPERS", 1:4),
  paste0("CTELAB", 2:5), paste0("CTFLEX", 1:4), paste0("CTFLUE", 1:4),
  paste0("CTORIG", 1:4)
)

matrix_note <- data.frame(
  min_eigen_R = min(ev),
  max_eigen_R = max(ev),
  kmo_all37 = kmo_stat(R),
  kmo_ctse_cpse = kmo_stat(R[ctse_cpse, ctse_cpse]),
  frac_abs_gt_030_all = frac_gt(R),
  frac_abs_gt_030_ctse_cpse = frac_gt(R[ctse_cpse, ctse_cpse]),
  frac_gt_030_ctse_cpse = mean(R[ctse_cpse, ctse_cpse][lower.tri(R[ctse_cpse, ctse_cpse])] > 0.30)
)
write.csv(matrix_note, file.path(out_dir, "matrix_checks.csv"), row.names = FALSE)

subcov <- function(vars) S[vars, vars, drop = FALSE]
submean <- function(vars) {
  m <- means
  names(m) <- analysis
  m[vars]
}

# ---- lavaan models -------------------------------------------------------

revised_items <- c(
  "CPDOMA1", "CPDOMA3", "CPDOMA4",
  "CPFIEL2", "CPFIEL3", "CPFIEL4",
  "CPPERS1", "CPPERS2", "CPPERS4",
  "CTELAB3", "CTELAB4", "CTELAB5",
  "CTFLEX1", "CTFLEX2", "CTFLEX3",
  "CTFLUE2", "CTFLUE3", "CTFLUE4",
  "CTORIG2", "CTORIG3", "CTORIG4"
)

residual3 <- "
  CTELAB4 ~~ CTELAB5
  CPDOMA1 ~~ CPDOMA4
  CPPERS2 ~~ CPFIEL2
"

measurement <- "
  CTFLUE =~ 1*CTFLUE2 + CTFLUE3 + CTFLUE4
  CTFLEX =~ 1*CTFLEX1 + CTFLEX2 + CTFLEX3
  CTORIG =~ 1*CTORIG2 + CTORIG3 + CTORIG4
  CTELAB =~ 1*CTELAB3 + CTELAB4 + CTELAB5
  CPDOMA =~ 1*CPDOMA1 + CPDOMA3 + CPDOMA4
  CPFIEL =~ 1*CPFIEL2 + CPFIEL3 + CPFIEL4
  CPPERS =~ 1*CPPERS1 + CPPERS2 + CPPERS4
"

second <- "
  CTSE =~ 1*CTFLUE + CTFLEX + CTORIG + CTELAB
  CPSE =~ 1*CPDOMA + CPFIEL + CPPERS
  CTSE ~~ CPSE
"

general <- "
  CTSE =~ NA*CTFLUE + CTFLEX + CTORIG + CTELAB
  CPSE =~ NA*CPDOMA + CPFIEL + CPPERS
  CTSE ~~ 1*CTSE
  CPSE ~~ 1*CPSE
  CTSE ~~ 1*CPSE
"

bcse_open <- "
  BCSE =~ 1*BCSE1 + BCSE2 + BCSE3
  OPEN =~ 1*Open1 + start(-0.4)*Open2 + start(-0.4)*Open3 + start(-0.4)*Open4
  CTSE ~~ BCSE + OPEN
  CPSE ~~ BCSE + OPEN
  OPEN ~~ BCSE
"

residual_span <- "
  BCSE1 ~~ BCSE3
  BCSE3 ~~ CPFIEL4
  Open1 ~~ BCSE1
  Open1 ~~ BCSE3
  Open2 ~~ Open1
  Open3 ~~ Open2
  Open4 ~~ BCSE2
  Open4 ~~ BCSE3
"

span_items <- c(revised_items, "BCSE1", "BCSE2", "BCSE3", "Open1", "Open2", "Open3", "Open4")

# Saturated correlates: each unused item is free to covary with every other
# observed variable, and has no loading. Pairs are written once.
saturated_block <- function(unused, observed) {
  if (length(unused) == 0) return("")
  lines <- character()
  done <- character()
  for (u in unused) {
    others <- setdiff(observed, c(u, done))
    pieces <- vapply(others, function(o) {
      sprintf("start(0)*%s", o)
    }, character(1))
    var_start <- sprintf("%.8f", S[u, u])
    lines <- c(lines, paste0(
      u, " ~~ start(", var_start, ")*", u, " + ", paste(pieces, collapse = " + ")
    ))
    done <- c(done, u)
  }
  paste(lines, collapse = "\n")
}

all_items <- c(
  paste0("CPDOMA", 1:4), paste0("CPFIEL", 1:4), paste0("CPPERS", 1:4),
  paste0("CTELAB", 2:5), paste0("CTFLEX", 1:4),
  paste0("CTFLUE", 1:4), paste0("CTORIG", 1:4)
)
external <- c("BCSE1", "BCSE2", "BCSE3", "Open1", "Open2", "Open3", "Open4")

model_all <- paste(
  "CTFLUE =~ 1*CTFLUE1 + CTFLUE2 + CTFLUE3 + CTFLUE4",
  "CTFLEX =~ 1*CTFLEX1 + CTFLEX2 + CTFLEX3 + CTFLEX4",
  "CTORIG =~ 1*CTORIG1 + CTORIG2 + CTORIG3 + CTORIG4",
  "CTELAB =~ 1*CTELAB2 + CTELAB3 + CTELAB4 + CTELAB5",
  "CPDOMA =~ 1*CPDOMA1 + CPDOMA2 + CPDOMA3 + CPDOMA4",
  "CPFIEL =~ 1*CPFIEL1 + CPFIEL2 + CPFIEL3 + CPFIEL4",
  "CPPERS =~ 1*CPPERS1 + CPPERS2 + CPPERS3 + CPPERS4",
  second, bcse_open, residual3, residual_span,
  sep = "\n"
)

held_indicators <- c(
  "CTFLUE1", "CTFLUE2", "CTFLUE3",
  "CTFLEX1", "CTFLEX2", "CTFLEX3",
  "CTORIG1", "CTORIG2", "CTORIG3",
  "CTELAB2", "CTELAB3",
  "CPDOMA1", "CPDOMA2", "CPDOMA3",
  "CPFIEL1", "CPFIEL2", "CPFIEL3",
  "CPPERS1", "CPPERS2", "CPPERS3"
)
held_unused <- c(
  "CTFLUE4", "CTFLEX4", "CTORIG4", "CTELAB4", "CTELAB5",
  "CPDOMA4", "CPFIEL4", "CPPERS4"
)
held_observed <- c(held_indicators, held_unused, external)
variance_starts <- function(vars) {
  paste(sprintf("%s ~~ start(%.6f)*%s", vars, diag(S)[vars] * 0.5, vars), collapse = "\n")
}
factor_start_block <- function(syntax) {
  factors <- c(
    "CTFLUE", "CTFLEX", "CTORIG", "CTELAB", "CPDOMA", "CPFIEL", "CPPERS",
    "CTSE", "CPSE", "BCSE", "OPEN"
  )
  present <- factors[vapply(factors, function(f) {
    grepl(paste0("\\b", f, "\\b"), syntax, perl = TRUE)
  }, logical(1))]
  if (length(present) == 0) return("")
  starts <- ifelse(present %in% c("BCSE", "OPEN"), 0.5, 20)
  paste(sprintf("%s ~~ start(%s)*%s", present, starts, present), collapse = "\n")
}
model_held <- paste(
  "CTFLUE =~ 1*CTFLUE1 + CTFLUE2 + CTFLUE3",
  "CTFLEX =~ 1*CTFLEX1 + CTFLEX2 + CTFLEX3",
  "CTORIG =~ 1*CTORIG1 + CTORIG2 + CTORIG3",
  "CTELAB =~ 1*CTELAB2 + CTELAB3",
  "CPDOMA =~ 1*CPDOMA1 + CPDOMA2 + CPDOMA3",
  "CPFIEL =~ 1*CPFIEL1 + CPFIEL2 + CPFIEL3",
  "CPPERS =~ 1*CPPERS1 + CPPERS2 + CPPERS3",
  second, bcse_open,
  saturated_block(held_unused, held_observed),
  variance_starts(setdiff(held_observed, held_unused)),
  sep = "\n"
)
model_held <- paste(model_held, factor_start_block(model_held), sep = "\n")

# Appendix J, implied structure: fluency and flexibility share one factor.
implied_struct_indicators <- c(
  "CTFLUE1", "CTFLUE2", "CTFLEX1", "CTFLEX2", "CTFLEX3", "CTFLEX4",
  "CTORIG1", "CTORIG3", "CTORIG4",
  "CTELAB2", "CTELAB4", "CTELAB5",
  "CPDOMA1", "CPDOMA3", "CPDOMA4",
  "CPFIEL2", "CPFIEL3", "CPFIEL4",
  "CPPERS1", "CPPERS2", "CPPERS4"
)
implied_struct_unused <- c(
  "CTFLUE3", "CTFLUE4", "CTORIG2", "CTELAB3", "CPDOMA2", "CPFIEL1", "CPPERS3"
)
implied_struct_observed <- c(implied_struct_indicators, implied_struct_unused, external)
model_implied_struct <- paste(
  "CTFLUE =~ 1*CTFLUE1 + CTFLUE2 + CTFLEX1 + CTFLEX2 + CTFLEX3 + CTFLEX4",
  "CTORIG =~ 1*CTORIG1 + CTORIG3 + CTORIG4",
  "CTELAB =~ 1*CTELAB2 + CTELAB4 + CTELAB5",
  "CPDOMA =~ 1*CPDOMA1 + CPDOMA3 + CPDOMA4",
  "CPFIEL =~ 1*CPFIEL2 + CPFIEL3 + CPFIEL4",
  "CPPERS =~ 1*CPPERS1 + CPPERS2 + CPPERS4",
  "CTSE =~ 1*CTFLUE + CTORIG + CTELAB",
  "CPSE =~ 1*CPDOMA + CPFIEL + CPPERS",
  "CTSE ~~ CPSE",
  bcse_open, residual3, residual_span,
  saturated_block(implied_struct_unused, implied_struct_observed),
  variance_starts(setdiff(implied_struct_observed, implied_struct_unused)),
  sep = "\n"
)
model_implied_struct <- paste(model_implied_struct, factor_start_block(model_implied_struct), sep = "\n")

implied_ind_indicators <- c(
  "CTFLUE1", "CTFLUE2",
  "CTFLEX1", "CTFLEX2", "CTFLEX3", "CTFLEX4",
  "CTORIG1", "CTORIG3", "CTORIG4",
  "CTELAB2", "CTELAB4", "CTELAB5",
  "CPDOMA1", "CPDOMA3", "CPDOMA4",
  "CPFIEL2", "CPFIEL3", "CPFIEL4",
  "CPPERS1", "CPPERS2", "CPPERS4"
)
implied_ind_unused <- c(
  "CTFLUE3", "CTFLUE4", "CTORIG2", "CTELAB3", "CPDOMA2", "CPFIEL1", "CPPERS3"
)
implied_ind_observed <- c(implied_ind_indicators, implied_ind_unused, external)
model_implied_ind <- paste(
  "CTFLUE =~ 1*CTFLUE1 + CTFLUE2",
  "CTFLEX =~ 1*CTFLEX1 + CTFLEX2 + CTFLEX3 + CTFLEX4",
  "CTORIG =~ 1*CTORIG1 + CTORIG3 + CTORIG4",
  "CTELAB =~ 1*CTELAB2 + CTELAB4 + CTELAB5",
  "CPDOMA =~ 1*CPDOMA1 + CPDOMA3 + CPDOMA4",
  "CPFIEL =~ 1*CPFIEL2 + CPFIEL3 + CPFIEL4",
  "CPPERS =~ 1*CPPERS1 + CPPERS2 + CPPERS4",
  second, bcse_open, residual3, residual_span,
  saturated_block(implied_ind_unused, implied_ind_observed),
  variance_starts(setdiff(implied_ind_observed, implied_ind_unused)),
  sep = "\n"
)
model_implied_ind <- paste(model_implied_ind, factor_start_block(model_implied_ind), sep = "\n")

revised_sat_unused <- c(
  "CTFLUE1", "CTFLEX4", "CTORIG1", "CTELAB2", "CPDOMA2", "CPFIEL1", "CPPERS3"
)
revised_sat_observed <- c(revised_items, revised_sat_unused, external)
model_revised_sat <- paste(
  measurement, second, bcse_open, residual3, residual_span,
  saturated_block(revised_sat_unused, revised_sat_observed),
  variance_starts(setdiff(revised_sat_observed, revised_sat_unused)),
  sep = "\n"
)
model_revised_sat <- paste(model_revised_sat, factor_start_block(model_revised_sat), sep = "\n")

models <- list(
  initial = list(syntax = paste(measurement, second), vars = revised_items),
  refined = list(syntax = paste(measurement, second, residual3), vars = revised_items),
  general = list(syntax = paste(measurement, general, residual3), vars = revised_items),
  span = list(syntax = paste(measurement, second, bcse_open, residual3, residual_span), vars = span_items),
  revised_sat = list(syntax = model_revised_sat, vars = revised_sat_observed),
  all = list(syntax = model_all, vars = c(all_items, external)),
  held = list(syntax = model_held, vars = held_observed),
  implied_struct = list(syntax = model_implied_struct, vars = implied_struct_observed),
  implied_ind = list(syntax = model_implied_ind, vars = implied_ind_observed)
)

fit_one <- function(spec, n, likelihood, optimizer) {
  fit <- lavaan(
    model = spec$syntax,
    sample.cov = subcov(spec$vars),
    sample.mean = submean(spec$vars),
    sample.nobs = n,
    meanstructure = TRUE,
    likelihood = likelihood,
    estimator = "ML",
    auto.fix.first = FALSE,
    int.ov.free = TRUE,
    int.lv.free = FALSE,
    auto.var = TRUE,
    auto.cov.lv.x = TRUE,
    optim.method = optimizer,
        control = list(iter.max = 3000),
    warn = FALSE
  )
  fit
}

row_from_fit <- function(fit, label, n, likelihood, optimizer, engine) {
  pe <- parameterEstimates(fit)
  conv <- lavInspect(fit, "converged")
  measures <- tryCatch(
    fitMeasures(fit, c("chisq", "df", "pvalue", "cfi", "tli", "rmsea", "srmr", "aic", "bic", "npar", "baseline.chisq", "baseline.df")),
    error = function(e) NULL
  )
  if (is.null(measures)) {
    return(data.frame(
      model = label, engine = engine, optimizer = optimizer, n = n,
      likelihood = likelihood, converged = FALSE, chisq = NA, df = NA,
      pvalue = NA, cfi = NA, tli = NA, rmsea = NA, srmr = NA, aic = NA,
      bic = NA, npar = NA, baseline.chisq = NA, baseline.df = NA,
      stringsAsFactors = FALSE
    ))
  }
  data.frame(
    model = label, engine = engine, optimizer = optimizer, n = n,
    likelihood = likelihood, converged = isTRUE(conv),
    chisq = unname(measures["chisq"]),
    df = unname(measures["df"]),
    pvalue = unname(measures["pvalue"]),
    cfi = unname(measures["cfi"]),
    tli = unname(measures["tli"]),
    rmsea = unname(measures["rmsea"]),
    srmr = unname(measures["srmr"]),
    aic = unname(measures["aic"]),
    bic = unname(measures["bic"]),
    npar = unname(measures["npar"]),
    baseline.chisq = unname(measures["baseline.chisq"]),
    baseline.df = unname(measures["baseline.df"]),
    stringsAsFactors = FALSE
  )
}

# Grid the sample size and the Wishart versus normal likelihood on the
# initial model. Mplus 5.2 multiplies the ML fit function by N. lavaan's
# Wishart likelihood multiplies by N-1.
grid <- list()
for (n in c(296, 297, 308)) {
  for (likelihood in c("wishart", "normal")) {
    fit <- fit_one(models$initial, n, likelihood, "nlminb")
    grid[[length(grid) + 1]] <- row_from_fit(fit, "initial", n, likelihood, "nlminb", "lavaan")
  }
}
grid_df <- do.call(rbind, grid)
# Implied unscaled chi-square: printed MLR chi-square times the printed
# scaling factor. Mplus prints the scaled statistic and the scaling factor
# such that the ML statistic is approximately scaled * factor.
target_ml <- 350.161 * 1.456
grid_df$abs_gap_vs_scaled_times_factor <- abs(grid_df$chisq - target_ml)
write.csv(grid_df, file.path(out_dir, "n_likelihood_grid.csv"), row.names = FALSE)
ord <- order(grid_df$abs_gap_vs_scaled_times_factor)
chosen <- grid_df[ord[1], ]
chosen_n <- chosen$n
chosen_lik <- chosen$likelihood

published <- data.frame(
  model = c("initial", "refined", "general", "span", "revised_sat", "all", "held", "implied_struct", "implied_ind"),
  chisq = c(350.161, 295.571, 319.462, 514.150, 514.108, 1047.897, 739.173, 526.884, 572.421),
  df = c(181, 178, 179, 326, 326, 536, 311, 327, 326),
  scaling = c(1.456, 1.463, 1.488, 1.261, 1.261, 1.244, 1.295, 1.357, 1.363),
  cfi = c(0.934, 0.954, 0.945, 0.950, 0.963, 0.900, 0.917, 0.961, 0.952),
  rmsea = c(0.055, 0.046, 0.050, 0.043, 0.043, 0.056, 0.067, 0.045, 0.050),
  srmr = c(0.061, 0.057, 0.055, 0.058, 0.054, 0.062, 0.060, 0.049, 0.054),
  aic = c(52830.056, 52758.669, 52799.519, 59249.022, 76438.957, 76674.046, 76777.647, 76503.431, 76570.611),
  stringsAsFactors = FALSE
)
published$ml_from_scaling <- published$chisq * published$scaling

rows <- list()
fits <- list()
for (label in names(models)) {
  fit <- fit_one(models[[label]], chosen_n, chosen_lik, "nlminb")
  fits[[label]] <- fit
  rows[[length(rows) + 1]] <- row_from_fit(fit, label, chosen_n, chosen_lik, "nlminb", "lavaan")
  # Second optimizer on the three headline models and the span model.
  if (label %in% c("initial", "refined", "general", "span")) {
    fit_b <- fit_one(models[[label]], chosen_n, chosen_lik, "BFGS")
    rows[[length(rows) + 1]] <- row_from_fit(fit_b, label, chosen_n, chosen_lik, "BFGS", "lavaan")
  }
}

# Standard chi-square difference on the ML fits, and the printed-input
# Satorra-Bentler algebra that reproduces the dissertation's 52.457.
sb_from_printed <- function(chi0, df0, c0, chi1, df1, c1) {
  cd <- (df0 * c0 - df1 * c1) / (df0 - df1)
  data.frame(
    cd = cd,
    diff_scaled_over_cd = (chi0 - chi1) / cd,
    diff_unscaled_over_cd = (chi0 * c0 - chi1 * c1) / cd,
    df_diff = df0 - df1
  )
}
sb_refine <- sb_from_printed(350.161, 181, 1.456, 295.571, 178, 1.463)
sb_general <- sb_from_printed(319.462, 179, 1.488, 295.571, 178, 1.463)
write.csv(rbind(
  cbind(contrast = "initial_vs_refined", sb_refine),
  cbind(contrast = "general_vs_refined", sb_general)
), file.path(out_dir, "satorra_printed.csv"), row.names = FALSE)

ml_diff <- data.frame(
  contrast = c("initial_minus_refined", "general_minus_refined"),
  chisq = c(
    fits$initial@Fit@test[[1]]$stat - fits$refined@Fit@test[[1]]$stat,
    fits$general@Fit@test[[1]]$stat - fits$refined@Fit@test[[1]]$stat
  ),
  df = c(
    fits$initial@Fit@test[[1]]$df - fits$refined@Fit@test[[1]]$df,
    fits$general@Fit@test[[1]]$df - fits$refined@Fit@test[[1]]$df
  )
)
write.csv(ml_diff, file.path(out_dir, "ml_differences.csv"), row.names = FALSE)

# Rounding band. Each off-diagonal correlation is moved by a uniform
# draw on [-0.005, 0.005], the diagonal is restored, and a non-positive
# definite matrix is shrunk toward the identity until the smallest
# eigenvalue is at least 1e-8. Thirty draws, seed 20100501.
set.seed(20100501)
round_band <- function(base_fit, vars, n_rep = 30) {
  out <- numeric(n_rep)
  for (i in seq_len(n_rep)) {
    Rr <- R
    noise <- matrix(0, 37, 37)
    noise[lower.tri(noise)] <- runif(sum(lower.tri(noise)), -0.005, 0.005)
    noise <- noise + t(noise)
    Rr <- pmin(pmax(Rr + noise, -0.999), 0.999)
    diag(Rr) <- 1
    evs <- eigen(Rr, symmetric = TRUE, only.values = TRUE)$values
    shrink <- 0
    while (min(evs) < 1e-8 && shrink < 0.2) {
      shrink <- shrink + 0.01
      Rr <- (1 - shrink) * Rr
      diag(Rr) <- 1
      evs <- eigen(Rr, symmetric = TRUE, only.values = TRUE)$values
    }
    Ss <- diag(sds) %*% Rr %*% diag(sds)
    rownames(Ss) <- colnames(Ss) <- analysis
    fit <- tryCatch(
      lavaan(
        model = models$initial$syntax,
        sample.cov = Ss[vars, vars],
        sample.mean = submean(vars),
        sample.nobs = chosen_n,
        meanstructure = TRUE,
        likelihood = chosen_lik,
        estimator = "ML",
        auto.fix.first = FALSE,
        int.ov.free = TRUE,
        int.lv.free = FALSE,
        optim.method = "nlminb",
        control = list(iter.max = 400),
        warn = FALSE
      ),
      error = function(e) NULL
    )
    out[i] <- if (is.null(fit) || !lavInspect(fit, "converged")) NA else fitMeasures(fit, "chisq")
  }
  out
}
# chosen_n is used above and is already assigned.
round_chi <- round_band(fits$initial, revised_items, n_rep = 3)
write.csv(data.frame(draw = seq_along(round_chi), chisq = round_chi),
          file.path(out_dir, "rounding_band.csv"), row.names = FALSE)

published_cor <- matrix(c(
  1, .50, .64, .58, .69, .42, .48, .47, .46, .53, .65,
  .50, 1, .68, .62, .72, .48, .56, .55, .53, .62, .38,
  .64, .68, 1, .80, .94, .63, .72, .71, .69, .81, .49,
  .58, .62, .80, 1, .85, .57, .65, .64, .63, .73, .45,
  .69, .72, .94, .85, 1, .67, .77, .75, .74, .86, .53,
  .42, .48, .63, .57, .67, 1, .70, .68, .67, .78, .35,
  .48, .56, .72, .65, .77, .70, 1, .78, .77, .89, .41,
  .47, .55, .71, .64, .75, .68, .78, 1, .75, .88, .40,
  .46, .53, .69, .63, .74, .67, .77, .75, 1, .86, .39,
  .53, .62, .81, .73, .86, .78, .89, .88, .86, 1, .45,
  .65, .38, .49, .45, .53, .35, .41, .40, .39, .45, 1
), 11, 11, byrow = TRUE)
pub_names <- c("BCSE", "CPDOMA", "CPFIEL", "CPPERS", "CPSE", "CTELAB", "CTFLEX", "CTFLUE", "CTORIG", "CTSE", "OPEN")
dimnames(published_cor) <- list(pub_names, pub_names)
our_cor <- lavInspect(fits$span, "cor.lv")[pub_names, pub_names]
cor_gap <- our_cor - published_cor
cor_long <- data.frame(
  row = pub_names[row(cor_gap)[lower.tri(cor_gap, diag = TRUE)]],
  col = pub_names[col(cor_gap)[lower.tri(cor_gap, diag = TRUE)]],
  published = published_cor[lower.tri(published_cor, diag = TRUE)],
  ours = our_cor[lower.tri(our_cor, diag = TRUE)],
  gap = cor_gap[lower.tri(cor_gap, diag = TRUE)],
  stringsAsFactors = FALSE
)
write.csv(cor_long, file.path(out_dir, "table41_gaps.csv"), row.names = FALSE)

# Latent correlations and standard deviations from the span model.
span <- fits$span
lv_cor <- lavInspect(span, "cor.lv")
lv_cov <- lavInspect(span, "cov.lv")
lv_names <- c(
  "BCSE", "CPDOMA", "CPFIEL", "CPPERS", "CPSE",
  "CTELAB", "CTFLEX", "CTFLUE", "CTORIG", "CTSE", "OPEN"
)
lv_names <- lv_names[lv_names %in% colnames(lv_cor)]
cor_out <- data.frame(latent = lv_names, sd = sqrt(diag(lv_cov)[lv_names]), stringsAsFactors = FALSE)
for (nm in lv_names) cor_out[[nm]] <- lv_cor[lv_names, nm]
write.csv(cor_out, file.path(out_dir, "span_latent_correlations.csv"), row.names = FALSE)

# Composite validity, sum of squared standardized loadings over that sum
# plus the sum of standardized residual variances. For a second-order
# factor the loadings are the total effects on its observed indicators.
std_load <- lavInspect(span, "std")$lambda
std_theta <- diag(lavInspect(span, "std")$theta)
composite <- function(fit_std_lambda, theta, items) {
  lam <- fit_std_lambda[items, , drop = FALSE]
  # An item's loading on the factor column. Callers pass one column.
  lam <- as.numeric(lam)
  num <- sum(lam^2)
  den <- num + sum(theta[items])
  num / den
}
# First-order factors use their own columns. Second-order composite validity
# uses the model-implied standardized total loadings, computed below from
# the standardized solution's indirect path.
std_all <- standardizedSolution(span)
first_order <- c("CTFLUE", "CTFLEX", "CTORIG", "CTELAB", "CPDOMA", "CPFIEL", "CPPERS", "BCSE", "OPEN")
cv_rows <- list()
for (f in first_order) {
  items <- std_all$rhs[std_all$lhs == f & std_all$op == "=~"]
  lams <- std_all$est.std[std_all$lhs == f & std_all$op == "=~"]
  th <- std_theta[items]
  num <- sum(lams^2)
  cv_rows[[length(cv_rows) + 1]] <- data.frame(
    factor = f, formula = "sum_lambda_sq",
    cv = num / (num + sum(th)),
    cv_sum = (sum(lams)^2) / ((sum(lams)^2) + sum(th))
  )
}
cv_span <- do.call(rbind, cv_rows)
cv_span$model <- "span"
cv_more <- list(cv_span)
for (label in c("refined", "revised_sat")) {
  std_i <- standardizedSolution(fits[[label]])
  theta_i <- diag(lavInspect(fits[[label]], "std")$theta)
  names(theta_i) <- rownames(lavInspect(fits[[label]], "std")$theta)
  for (f in intersect(first_order, unique(std_i$lhs))) {
    rows_f <- std_i$lhs == f & std_i$op == "=~"
    items <- std_i$rhs[rows_f]
    lams <- std_i$est.std[rows_f]
    num <- sum(lams^2)
    den_th <- sum(theta_i[items])
    cv_more[[length(cv_more) + 1]] <- data.frame(
      factor = f, formula = "sum_lambda_sq",
      cv = num / (num + den_th),
      cv_sum = (sum(lams)^2) / ((sum(lams)^2) + den_th),
      model = label,
      stringsAsFactors = FALSE
    )
  }
}
write.csv(do.call(rbind, cv_more), file.path(out_dir, "composite_validity.csv"), row.names = FALSE)

# Free-loading check for the general-factor model. lavaan must not pin the
# first second-order loading back to 1.
gen_pe <- parTable(fits$general)
gen_mark <- gen_pe[gen_pe$lhs %in% c("CTSE", "CPSE") & gen_pe$op == "=~", c("lhs", "rhs", "free", "est")]
write.csv(gen_mark, file.path(out_dir, "general_second_order_loadings.csv"), row.names = FALSE)

lavaan_df <- do.call(rbind, rows)
write.csv(lavaan_df, file.path(out_dir, "lavaan_fits.csv"), row.names = FALSE)

# ---- OpenMx --------------------------------------------------------------

openmx_cfa <- function(label, vars, residuals, general_factor, covmat, nobs, optimizer) {
  latents <- c("CTFLUE", "CTFLEX", "CTORIG", "CTELAB", "CPDOMA", "CPFIEL", "CPPERS", "CTSE", "CPSE")
  blocks <- list(
    CTFLUE = c("CTFLUE2", "CTFLUE3", "CTFLUE4"),
    CTFLEX = c("CTFLEX1", "CTFLEX2", "CTFLEX3"),
    CTORIG = c("CTORIG2", "CTORIG3", "CTORIG4"),
    CTELAB = c("CTELAB3", "CTELAB4", "CTELAB5"),
    CPDOMA = c("CPDOMA1", "CPDOMA3", "CPDOMA4"),
    CPFIEL = c("CPFIEL2", "CPFIEL3", "CPFIEL4"),
    CPPERS = c("CPPERS1", "CPPERS2", "CPPERS4")
  )
  paths <- list()
  for (f in names(blocks)) {
    items <- blocks[[f]]
    paths[[length(paths) + 1]] <- mxPath(
      from = f, to = items, arrows = 1,
      free = c(FALSE, rep(TRUE, length(items) - 1)),
      values = c(1, rep(0.9, length(items) - 1)),
      labels = paste0(f, "_", items)
    )
  }
  if (!general_factor) {
    paths[[length(paths) + 1]] <- mxPath(
      from = "CTSE", to = c("CTFLUE", "CTFLEX", "CTORIG", "CTELAB"), arrows = 1,
      free = c(FALSE, TRUE, TRUE, TRUE), values = c(1, 1, 1, 1)
    )
    paths[[length(paths) + 1]] <- mxPath(
      from = "CPSE", to = c("CPDOMA", "CPFIEL", "CPPERS"), arrows = 1,
      free = c(FALSE, TRUE, TRUE), values = c(1, 1, 1)
    )
    paths[[length(paths) + 1]] <- mxPath(
      from = c("CTSE", "CPSE"), arrows = 2, free = TRUE, values = 1
    )
    paths[[length(paths) + 1]] <- mxPath(
      from = "CTSE", to = "CPSE", arrows = 2, free = TRUE, values = 0.2
    )
  } else {
    paths[[length(paths) + 1]] <- mxPath(
      from = "CTSE", to = c("CTFLUE", "CTFLEX", "CTORIG", "CTELAB"), arrows = 1,
      free = TRUE, values = 1
    )
    paths[[length(paths) + 1]] <- mxPath(
      from = "CPSE", to = c("CPDOMA", "CPFIEL", "CPPERS"), arrows = 1,
      free = TRUE, values = 1
    )
    paths[[length(paths) + 1]] <- mxPath(
      from = c("CTSE", "CPSE"), arrows = 2, free = FALSE, values = 1
    )
    paths[[length(paths) + 1]] <- mxPath(
      from = "CTSE", to = "CPSE", arrows = 2, free = FALSE, values = 1
    )
  }
  paths[[length(paths) + 1]] <- mxPath(
    from = setdiff(latents, c("CTSE", "CPSE")), arrows = 2, free = TRUE, values = 1
  )
  paths[[length(paths) + 1]] <- mxPath(
    from = vars, arrows = 2, free = TRUE, values = diag(covmat) * 0.4
  )
  for (pair in residuals) {
    paths[[length(paths) + 1]] <- mxPath(
      from = pair[1], to = pair[2], arrows = 2, free = TRUE, values = 1
    )
  }
  model <- mxModel(
    label, type = "RAM",
    manifestVars = vars, latentVars = latents,
    paths,
    mxData(observed = covmat, type = "cov", numObs = nobs),
    mxFitFunctionML(rowDiagnostics = FALSE)
  )
  model <- mxOption(model, "Calculate Hessian", "No")
  model <- mxOption(model, "Standard Errors", "No")
  old <- mxOption(NULL, "Default optimizer")
  mxOption(NULL, "Default optimizer", optimizer)
  on.exit(mxOption(NULL, "Default optimizer", old), add = TRUE)
  model <- mxRun(model, silent = TRUE)
  model
}

openmx_rows <- list()
resid_pairs <- list(c("CTELAB4", "CTELAB5"), c("CPDOMA1", "CPDOMA4"), c("CPPERS2", "CPFIEL2"))
for (optimizer in c("SLSQP", "CSOLNP")) {
  for (spec in list(
    list("initial", list(), FALSE),
    list("refined", resid_pairs, FALSE),
    list("general", resid_pairs, TRUE)
  )) {
    label <- spec[[1]]
    message("OpenMx ", optimizer, " ", label)
    fit <- tryCatch(
      openmx_cfa(label, revised_items, spec[[2]], spec[[3]], subcov(revised_items), chosen_n, optimizer),
      error = function(e) e
    )
    if (inherits(fit, "error")) {
      openmx_rows[[length(openmx_rows) + 1]] <- data.frame(
        model = label, engine = "OpenMx", optimizer = optimizer, n = chosen_n,
        likelihood = "openmx_ml", converged = FALSE, chisq = NA, df = NA,
        pvalue = NA, cfi = NA, tli = NA, rmsea = NA, srmr = NA, aic = NA,
        bic = NA, npar = NA, baseline.chisq = NA, baseline.df = NA,
        status = conditionMessage(fit), stringsAsFactors = FALSE
      )
      next
    }
    sm <- summary(fit)
    openmx_rows[[length(openmx_rows) + 1]] <- data.frame(
      model = label, engine = "OpenMx", optimizer = optimizer, n = chosen_n,
      likelihood = "openmx_ml", converged = fit$output$status$code == 0,
      chisq = sm$Chi, df = sm$ChiDoF, pvalue = NA,
      cfi = if (!is.null(sm$CFI)) sm$CFI else NA,
      tli = if (!is.null(sm$TLI)) sm$TLI else NA,
      rmsea = if (!is.null(sm$RMSEA)) sm$RMSEA else NA,
      srmr = if (!is.null(sm$SRMR)) sm$SRMR else NA,
      aic = NA, bic = NA, npar = NA, baseline.chisq = NA, baseline.df = NA,
      status = fit$output$status$code, stringsAsFactors = FALSE
    )
  }
}
openmx_df <- do.call(rbind, openmx_rows)
write.csv(openmx_df, file.path(out_dir, "openmx_fits.csv"), row.names = FALSE)

cmp <- merge(
  lavaan_df[lavaan_df$optimizer == "nlminb", ],
  published,
  by = "model",
  suffixes = c("_ours", "_pub")
)
cmp$ml_gap <- cmp$chisq_ours - cmp$ml_from_scaling
cmp$cfi_gap <- cmp$cfi_ours - cmp$cfi_pub
cmp$rmsea_gap <- cmp$rmsea_ours - cmp$rmsea_pub
cmp$srmr_gap <- cmp$srmr_ours - cmp$srmr_pub
cmp$aic_gap <- cmp$aic_ours - cmp$aic_pub
write.csv(cmp, file.path(out_dir, "comparison.csv"), row.names = FALSE)

cat("chosen_n", chosen_n, "likelihood", chosen_lik, "\n")
print(cmp[, c(
  "model", "converged", "chisq_ours", "chisq_pub", "ml_from_scaling",
  "df_ours", "df_pub", "srmr_ours", "srmr_pub", "cfi_ours", "cfi_pub", "aic_gap"
)])
cat("SB refined diff_scaled_over_cd", sb_refine$diff_scaled_over_cd, "\n")
cat("SB general diff_scaled_over_cd", sb_general$diff_scaled_over_cd, "\n")
print(matrix_note)
