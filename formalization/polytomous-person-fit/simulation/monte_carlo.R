# Beck (2023) Monte Carlo, scaled.
#
# Rscript monte_carlo.R out_dir reps predictor epsilon [cores] [care_frac] [moments]
#   predictor: ink | standard
#   epsilon: positive number; midpoint uses +epsilon, extreme uses -epsilon
#   moments: tablea1 | thesis_scale | thesis_corr
#     thesis_scale uses Beck (2015) Table A4 scale means, SDs, and correlations
#     thesis_corr uses those correlations with unit variances and means 0
#   disc: tablea3 | thesis_cfa
#   generator: mirt | hand
#     hand draws the graded response with one uniform per person-item
#     from the same linear predictor passed to mirt::simdata
#     thesis_cfa uses the 28 CFA loadings in Beck (2015) Table A3,
#     a = 1.702 * lambda / sqrt(residual), simple structure, dimensions in
#     Table A4 order (Anger, Avoid, Alcohol, Agora). Tests longer than 7 items
#     on a factor sample those 7 items with replacement.
#
# Assumptions recorded in every output row:
#   boundary draws are one uniform sample from Table A2, then sorted
#   k = 7 splits the widest k = 6 interval at its midpoint
#   s_delta is the sample standard deviation (divisor n - 1)
#   careless replaces every item with a uniform category
#   D = 1
#   shared 1,000 theta draws, then each base matrix is trimmed to 900
#   seed 20230511

args <- commandArgs(trailingOnly = TRUE)
out_dir <- if (length(args) >= 1) args[[1]] else "out"
reps <- if (length(args) >= 2) as.integer(args[[2]]) else 8L
predictor <- if (length(args) >= 3) args[[3]] else "ink"
epsilon <- if (length(args) >= 4) as.numeric(args[[4]]) else 1
cores <- if (length(args) >= 5) as.integer(args[[5]]) else 4L
care_frac <- if (length(args) >= 6) as.numeric(args[[6]]) else 1
moments <- if (length(args) >= 7) args[[7]] else "tablea1"
disc_mode <- if (length(args) >= 8) args[[8]] else "tablea3"
generator <- if (length(args) >= 9) args[[9]] else "mirt"
if (!predictor %in% c("ink", "standard")) stop("predictor must be ink or standard")
if (!moments %in% c("tablea1", "thesis_scale", "thesis_corr")) stop("unknown moments")
if (!disc_mode %in% c("tablea3", "thesis_cfa")) stop("unknown disc")
if (!generator %in% c("mirt", "hand")) stop("unknown generator")

dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
.libPaths(c("/tmp/beck/Rlib", .libPaths()))
suppressPackageStartupMessages({
  library(mirt)
  library(MASS)
})
pf <- if (file.exists("personfit.R")) "personfit.R" else file.path("simulation", "personfit.R")
source(pf)
disc_path <- if (file.exists("out/discriminations.csv")) "out/discriminations.csv" else
  file.path("simulation", "out", "discriminations.csv")

MASTER <- 20230511L
D_CONST <- 1
if (moments == "tablea1") {
  BASE_MEAN <- c(0.03, 0, 0.09, 0.02)
  SDR_MEAN <- c(-0.982, -0.964, -0.903, -0.868)
  SIGMA <- matrix(c(
    1.02, 0.49, 0.31, 0.43,
    0.49, 1.11, 0.38, 0.89,
    0.31, 0.38, 0.95, 0.40,
    0.43, 0.89, 0.40, 0.96
  ), 4, 4, byrow = TRUE)
} else {
  # Beck (2015) Table A4, order Anger, Avoid, Alcohol, Agora.
  thesis_r <- matrix(c(
    1, .43, .29, .37,
    .43, 1, .28, .81,
    .29, .28, 1, .33,
    .37, .81, .33, 1
  ), 4, 4, byrow = TRUE)
  if (moments == "thesis_scale") {
    thesis_sd <- c(0.91, 0.92, 0.98, 0.72)
    BASE_MEAN <- c(2.30, 1.96, 1.85, 1.53)
    SIGMA <- diag(thesis_sd) %*% thesis_r %*% diag(thesis_sd)
    SDR_MEAN <- BASE_MEAN - thesis_sd
  } else {
    BASE_MEAN <- rep(0, 4)
    SIGMA <- thesis_r
    SDR_MEAN <- rep(-1, 4)
  }
}

k7_edges <- function() {
  edges <- c(-13.71, -6.68, -4.78, -3.09, -1.42, 2.42)
  width <- diff(edges)
  j <- which.max(width)
  mid <- (edges[j] + edges[j + 1]) / 2
  sort(c(edges, mid))
}

intervals_for <- function(k) {
  known <- list(
    "4" = list(c(-13.71, -5.19), c(-5.19, -2.51), c(-2.51, 2.42)),
    "5" = list(c(-13.71, -5.81), c(-5.81, -2.19), c(-2.19, 2.42), c(1.5, 3)),
    "6" = list(c(-13.71, -6.68), c(-6.68, -4.78), c(-4.78, -3.09),
               c(-3.09, -1.42), c(-1.42, 2.42))
  )
  if (as.character(k) %in% names(known)) return(known[[as.character(k)]])
  edges <- k7_edges()
  Map(function(j) c(edges[j], edges[j + 1]), seq_len(length(edges) - 1))
}

draw_boundaries <- function(k, n_items) {
  iv <- intervals_for(k)
  b <- matrix(NA_real_, n_items, length(iv))
  for (j in seq_along(iv)) b[, j] <- stats::runif(n_items, iv[[j]][1], iv[[j]][2])
  t(apply(b, 1, sort))
}

if (disc_mode == "tablea3") {
  disc <- read.csv(disc_path)
  A <- as.matrix(disc[, c("a1", "a2", "a3", "a4")])
  factor_items <- split(disc$item, disc$factor)
} else {
  # Nate's transcription of Beck (2015) Table A3, CFA loadings and residuals.
  cfa <- list(
    c(0.61, 0.68, 0.71, 0.78, 0.81, 0.83, 0.78),
    c(0.77, 0.76, 0.88, 0.73, 0.86, 0.81, 0.84),
    c(0.83, 0.88, 0.90, 0.85, 0.69, 0.88, 0.91),
    c(0.74, 0.61, 0.75, 0.84, 0.60, 0.83, 0.78)
  )
  res <- list(
    c(0.63, 0.54, 0.49, 0.39, 0.34, 0.31, 0.39),
    c(0.41, 0.43, 0.22, 0.48, 0.26, 0.35, 0.30),
    c(0.32, 0.22, 0.19, 0.28, 0.53, 0.22, 0.17),
    c(0.45, 0.63, 0.44, 0.29, 0.64, 0.31, 0.39)
  )
  A <- matrix(0, 28, 4)
  for (f in 1:4) {
    rows <- (f - 1L) * 7L + seq_len(7)
    A[rows, f] <- 1.702 * cfa[[f]] / sqrt(res[[f]])
  }
  factor_items <- split(seq_len(28), rep(1:4, each = 7))
}
n_items <- nrow(A)

cell_grid <- expand.grid(k = c(4L, 5L, 6L, 7L), dim = 1:4, length = c(12L, 36L))
cell_grid <- cell_grid[order(cell_grid$k, cell_grid$dim, cell_grid$length), ]
rownames(cell_grid) <- NULL

set.seed(MASTER)
boundaries <- lapply(c(4L, 5L, 6L, 7L), function(k) draw_boundaries(k, n_items))
names(boundaries) <- c("4", "5", "6", "7")
theta0 <- mvrnorm(1000L, BASE_MEAN, SIGMA)
item_ids <- vector("list", nrow(cell_grid))
for (i in seq_len(nrow(cell_grid))) {
  len <- cell_grid$length[i]
  dm <- cell_grid$dim[i]
  per <- len / dm
  ids <- unlist(lapply(seq_len(dm), function(f) {
    pool <- factor_items[[as.character(f)]]
    sample(pool, per, replace = length(pool) < per)
  }))
  item_ids[[i]] <- ids
}

save_world <- function() {
  rows <- list()
  for (i in seq_len(nrow(cell_grid))) {
    rows[[i]] <- data.frame(cell = i, k = cell_grid$k[i], dim = cell_grid$dim[i],
                            length = cell_grid$length[i],
                            items = paste(item_ids[[i]], collapse = ","))
  }
  utils::write.csv(do.call(rbind, rows), file.path(out_dir, "item_samples.csv"), row.names = FALSE)
  utils::write.csv(data.frame(item = seq_len(n_items), boundaries[["5"]]),
                   file.path(out_dir, paste0("boundaries_k5_", predictor, ".csv")),
                   row.names = FALSE)
}

sample_mgrm <- function(a, b, theta) {
  asums <- rowSums(a)
  lin <- theta %*% t(a)
  u <- matrix(stats::runif(nrow(theta) * nrow(a)), nrow(theta), nrow(a))
  Y <- matrix(0L, nrow(theta), nrow(a))
  for (m in seq_len(ncol(b))) {
    shift <- if (predictor == "ink") b[, m] * asums else b[, m]
    pk <- stats::plogis(D_CONST * sweep(lin, 2L, shift, "-"))
    Y <- Y + (u < pk)
  }
  Y
}

respond <- function(items, b_item, theta, k) {
  a <- A[items, , drop = FALSE]
  b <- b_item[items, , drop = FALSE]
  if (generator == "hand") return(sample_mgrm(a, b, theta))
  a_use <- D_CONST * a
  if (predictor == "ink") {
    d <- -D_CONST * sweep(b, 1, rowSums(a), "*")
  } else {
    d <- -D_CONST * b
  }
  simdata(a_use, d, N = nrow(theta), itemtype = "graded", Theta = theta, mins = 0)
}

trim_base <- function(X) {
  keep <- apply(X, 1, stats::sd) > 0
  nkeep <- sum(keep)
  if (nkeep < 900L) return(list(ok = FALSE, nkeep = nkeep))
  list(ok = TRUE, nkeep = nkeep,
       X = X[keep, , drop = FALSE][sample.int(nkeep, 900L), , drop = FALSE])
}

shift_rows <- function(b, sign) {
  s <- apply(b, 1, stats::sd)
  sweep(b, 1, sign * s, "+")
}

spread_rows <- function(b, eps) {
  m <- rowMeans(b)
  exp(eps) * sweep(b, 1, m, "-") + m
}

one_cell <- function(i) {
  k <- cell_grid$k[i]
  items <- item_ids[[i]]
  b0 <- boundaries[[as.character(k)]]
  # Re-seed per cell so a parallel schedule does not change the aberrant draws.
  set.seed(MASTER + i * 10007L)
  trimmed <- trim_base(respond(items, b0, theta0, k))
  if (!isTRUE(trimmed$ok)) {
    return(data.frame(cell = i, k = k, dim = cell_grid$dim[i],
                      length = cell_grid$length[i], bias = NA_character_,
                      rep = NA_integer_, nkeep = trimmed$nkeep,
                      stringsAsFactors = FALSE))
  }
  base <- trimmed$X
  biases <- list(
    acquiescence = list(kind = "shift", sign = 1, mean = BASE_MEAN),
    disacquiescence = list(kind = "shift", sign = -1, mean = BASE_MEAN),
    midpoint = list(kind = "spread", eps = epsilon, mean = BASE_MEAN),
    extreme = list(kind = "spread", eps = -epsilon, mean = BASE_MEAN),
    social = list(kind = "shift", sign = 1, mean = SDR_MEAN),
    careless = list(kind = "careless", mean = BASE_MEAN)
  )
  out <- vector("list", length(biases) * reps)
  pos <- 0L
  aberrant <- c(rep(FALSE, 900L), rep(TRUE, 100L))
  for (bn in names(biases)) {
    spec <- biases[[bn]]
    b_use <- b0
    if (spec$kind == "shift") b_use <- shift_rows(b0, spec$sign)
    if (spec$kind == "spread") b_use <- spread_rows(b0, spec$eps)
    for (r in seq_len(reps)) {
      th <- mvrnorm(100L, spec$mean, SIGMA)
      extra <- respond(items, b_use, th, k)
      if (spec$kind == "careless") {
        n_rep <- max(1L, round(care_frac * ncol(extra)))
        for (p in seq_len(nrow(extra))) {
          cols <- sample.int(ncol(extra), n_rep)
          extra[p, cols] <- sample.int(k, n_rep, replace = TRUE) - 1L
        }
      }
      data <- rbind(base, extra)
      H <- fast_HiT(data)
      G <- fast_gnormed(data, k)
      U <- fast_u3(data, k)
      rates <- list(
        H_lower = classify_rates(H, aberrant, "lower"),
        G_upper = classify_rates(G, aberrant, "upper"),
        G_lower = classify_rates(G, aberrant, "lower"),
        U3_upper = classify_rates(U, aberrant, "upper"),
        U3_lower = classify_rates(U, aberrant, "lower")
      )
      pos <- pos + 1L
      row <- data.frame(cell = i, k = k, dim = cell_grid$dim[i],
                        length = cell_grid$length[i], bias = bn, rep = r,
                        predictor = predictor, epsilon = epsilon,
                        careless_fraction = care_frac, moments = moments,
                        disc_mode = disc_mode,
                        stringsAsFactors = FALSE)
      for (nm in names(rates)) {
        rt <- rates[[nm]]
        row[[paste0(nm, "_sens")]] <- rt[["sensitivity"]]
        row[[paste0(nm, "_spec")]] <- rt[["specificity"]]
        row[[paste0(nm, "_ppv")]] <- rt[["ppv"]]
        row[[paste0(nm, "_npv")]] <- rt[["npv"]]
        row[[paste0(nm, "_nflag")]] <- rt[["n_flag"]]
      }
      out[[pos]] <- row
    }
  }
  do.call(rbind, out)
}

save_world()
cat(sprintf("running %d cells x %d reps, generator %s, predictor %s, epsilon %s, moments %s, cores %d\n",
            nrow(cell_grid), reps, generator, predictor, epsilon, moments, cores))
cat("means", paste(round(BASE_MEAN, 3), collapse = " "), "\n")
cat("sdr", paste(round(SDR_MEAN, 3), collapse = " "), "\n")
t0 <- proc.time()
if (cores > 1L) {
  parts <- parallel::mclapply(seq_len(nrow(cell_grid)), one_cell, mc.cores = cores)
} else {
  parts <- lapply(seq_len(nrow(cell_grid)), one_cell)
}
bad <- vapply(parts, inherits, logical(1), "try-error")
if (any(bad)) {
  print(parts[bad])
  stop("a cell failed")
}
cols <- unique(unlist(lapply(parts, names)))
parts <- lapply(parts, function(p) {
  missing <- setdiff(cols, names(p))
  if (length(missing)) p[missing] <- NA
  p[, cols, drop = FALSE]
})
tab <- do.call(rbind, parts)
fn <- file.path(out_dir, sprintf("mc_%s_%s_%s_%s_eps%s_c%s_r%d.csv",
                                 generator, predictor, moments, disc_mode, epsilon, care_frac, reps))
utils::write.csv(tab, fn, row.names = FALSE)
if ("nkeep" %in% names(tab)) {
  failed <- tab[is.na(tab$bias), c("cell", "k", "dim", "length", "nkeep")]
  if (nrow(failed)) {
    utils::write.csv(failed, sub("\\.csv$", "_trimfail.csv", fn), row.names = FALSE)
    cat("trim failed on", nrow(failed), "cells\n")
  }
}
el <- (proc.time() - t0)[["elapsed"]]
cat(sprintf("wrote %s (%d rows) in %.1f s\n", fn, nrow(tab), el))
