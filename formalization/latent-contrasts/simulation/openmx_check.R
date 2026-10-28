# Diagnose the MIMIC convergence gap with OpenMx.
# A one-thread benchmark on this machine (2026-10-28) was about 0.1 s for
# lavaan MLR and about 0.1 s for OpenMx SLSQP or CSOLNP. Eight cells of
# 10,000 lavaan fits on four cores are about 40 minutes. OpenMx on the
# failures plus 200 converged controls is a few minutes. That is inside
# a four-hour budget, so the check runs.
#
# Streams match validate_10k.R (hand generator, seeds in seeds_10k.csv)
# and env_miss.R (simsem 0.5-16 sim(), seed 13131).
# The model is the free-intercept MIMIC used in those runs: the OSF
# marker string with a free latent intercept, which is the fit that
# produced the 9,951-9,988 counts.
#
# Usage: Rscript openmx_check.R [out_dir]
# OpenMx 2.22.11 is installed from the CRAN source. This R 4.3.3 has
# Rf_isFrame and not Rf_isDataFrame, so omxData.cpp was edited for that
# one call before compilation.

args <- commandArgs(trailingOnly = TRUE)
out_dir <- if (length(args) >= 1) args[[1]] else "out"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

Sys.setenv(OMP_NUM_THREADS = "1")
.libPaths(c("/tmp/Rlib16", "/tmp/Rlib", .libPaths()))
suppressPackageStartupMessages({
  library(lavaan)
  library(OpenMx)
  library(simsem)
  library(parallel)
})
mxOption(NULL, "Number of Threads", 1)
stopifnot(identical(as.character(packageVersion("OpenMx")), "2.22.11"))
stopifnot(identical(as.character(packageVersion("simsem")), "0.5.16"))

n_control_each <- 25L

psi <- 0.5
theta <- 0.51
lambda <- c(1, 0.7, 0.7, 0.7)

generate_hand <- function(n_g, means) {
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
  dat$c1 <- factor(ifelse(sg %in% c(1, 3), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
  dat$c2 <- factor(ifelse(sg %in% c(1, 2), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
  dat$c3 <- factor(ifelse(sg %in% c(1, 4), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
  dat
}

pop_of <- function(means) {
  sprintf("
eta =~ NA*i1 + 0.7*i1 + 0.7*i2 + 0.7*i3 + 0.7*i4
eta ~~ .5*eta
i1 ~~ 0.51*i1
i1 ~ 1*1
i2 ~~ 0.51*i2
i2 ~ 1*1
i3 ~~ 0.51*i3
i3 ~ 1*1
i4 ~~ 0.51*i4
i4 ~ 1*1
eta ~ c(%s)*1
", paste(means, collapse = ", "))
}

recast <- function(dat) {
  dat$subgroup <- factor(dat$group)
  sg <- as.integer(as.character(dat$subgroup))
  dat$c1 <- factor(ifelse(sg %in% c(1, 3), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
  dat$c2 <- factor(ifelse(sg %in% c(1, 2), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
  dat$c3 <- factor(ifelse(sg %in% c(1, 4), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
  dat
}

mimic_free <- "
eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ 1 + c1 + c2 + c3
i1 + i2 + i3 + i4 ~ eq*1
"

lav_one <- function(dat, ..., control = list(iter.max = 10000)) {
  warns <- character()
  fit <- withCallingHandlers(
    tryCatch(
      sem(mimic_free, data = dat, missing = "ML", estimator = "MLR",
          control = control, ...),
      error = function(e) NULL
    ),
    warning = function(w) {
      warns <<- c(warns, conditionMessage(w))
      invokeRestart("muffleWarning")
    }
  )
  out <- list(conv = 0L, est = rep(NA_real_, 3), p = rep(NA_real_, 3),
              min_var = NA_real_, niter = NA_integer_,
              gradient = as.integer(any(grepl("gradient", warns, ignore.case = TRUE))))
  if (is.null(fit)) return(out)
  out$conv <- as.integer(isTRUE(lavInspect(fit, "converged")))
  out$niter <- tryCatch(as.integer(lavInspect(fit, "iterations")), error = function(e) NA_integer_)
  pe <- tryCatch(parameterEstimates(fit), error = function(e) NULL)
  if (!is.null(pe)) {
    v <- pe$est[pe$op == "~~" & pe$lhs == pe$rhs]
    if (length(v)) out$min_var <- min(v, na.rm = TRUE)
    hit <- pe[pe$lhs == "eta" & pe$op == "~" & pe$rhs %in% c("c1", "c2", "c3"), , drop = FALSE]
    for (name in c("c1", "c2", "c3")) {
      row <- hit[hit$rhs == name, , drop = FALSE]
      j <- match(name, c("c1", "c2", "c3"))
      if (nrow(row) == 1) {
        out$est[[j]] <- row$est[[1]]
        out$p[[j]] <- row$pvalue[[1]]
      }
    }
  }
  out
}

as_openmx <- function(dat) {
  mm <- model.matrix(~ c1 + c2 + c3, dat)
  data.frame(i1 = dat$i1, i2 = dat$i2, i3 = dat$i3, i4 = dat$i4,
             c1 = mm[, 2], c2 = mm[, 3], c3 = mm[, 4])
}

omx_build <- function(num) {
  manifests <- c("i1", "i2", "i3", "i4", "c1", "c2", "c3")
  mxModel(
    "mimic", type = "RAM",
    mxData(num[, manifests], type = "raw"),
    manifestVars = manifests, latentVars = "eta",
    mxPath(from = "eta", to = "i1", free = FALSE, values = 1),
    mxPath(from = "eta", to = c("i2", "i3", "i4"), free = TRUE, values = 0.7),
    mxPath(from = "eta", arrows = 2, free = TRUE, values = 0.5),
    mxPath(from = c("i1", "i2", "i3", "i4"), arrows = 2, free = TRUE, values = 0.5),
    mxPath(from = "one", to = c("i1", "i2", "i3", "i4"), free = TRUE, values = 1, labels = "int"),
    mxPath(from = "one", to = "eta", free = TRUE, values = 0),
    mxPath(from = c("c1", "c2", "c3"), to = "eta", free = TRUE, values = 0, labels = c("b1", "b2", "b3")),
    mxPath(from = c("c1", "c2", "c3"), arrows = 2, free = TRUE, values = 0.25),
    mxPath(from = "one", to = c("c1", "c2", "c3"), free = TRUE, values = 0.5),
    mxPath(from = "c1", to = c("c2", "c3"), arrows = 2, free = TRUE, values = 0),
    mxPath(from = "c2", to = "c3", arrows = 2, free = TRUE, values = 0)
  )
}

omx_one <- function(num, opt) {
  mxOption(NULL, "Default optimizer", opt)
  fit <- tryCatch(mxRun(omx_build(num), silent = TRUE, suppressWarnings = TRUE),
                  error = function(e) NULL)
  if (is.null(fit)) {
    return(list(code = NA_integer_, est = rep(NA_real_, 3)))
  }
  code <- fit$output$status$code
  if (length(code) < 1) code <- NA_integer_
  est <- tryCatch(as.numeric(omxGetParameters(fit)[c("b1", "b2", "b3")]),
                  error = function(e) rep(NA_real_, 3))
  list(code = as.integer(code[[1]]), est = est)
}

data_flags <- function(dat) {
  cv <- stats::cov(dat[, c("i1", "i2", "i3", "i4")])
  ev <- eigen(cv, symmetric = TRUE, only.values = TRUE)$values
  c(kappa = kappa(cv), min_eig = min(ev), n = nrow(dat))
}

scan_cell <- function(cell) {
  means <- if (cell$setting == "true") c(1, 0.6, 0.8, 0.4) else c(1, 1, 1, 1)
  n_g <- if (cell$cond == 1) c(60, 60, 60, 60) else c(108, 108, 12, 12)
  log_path <- file.path(out_dir, "openmx_check.log")
  # Hand stream: validate_10k.R draws one replicate and fits it before the
  # next draw. lavaan::sem changes .Random.seed, so the fit has to stay
  # inside that loop or the later replicates are not the same ones.
  # simsem stream: env_miss.R draws the whole list with sim() first.
  base <- vector("list", cell$reps)
  dats <- vector("list", cell$reps)
  if (cell$stream == "hand") {
    RNGkind("L'Ecuyer-CMRG")
    set.seed(cell$seed)
    for (r in seq_len(cell$reps)) {
      dats[[r]] <- generate_hand(n_g, means)
      base[[r]] <- lav_one(dats[[r]])
      if (r %% 1000L == 0L) {
        cat(sprintf("%s %s c%s base rep %d fails %d\n",
                    cell$stream, cell$setting, cell$cond, r,
                    sum(vapply(base[seq_len(r)], function(z) z$conv == 0L, logical(1)))),
            file = log_path, append = TRUE)
      }
    }
  } else {
    drawn <- sim(nRep = cell$reps, model = pop_of(means), n = as.list(n_g),
                 dataOnly = TRUE, seed = cell$seed, silent = TRUE, multicore = FALSE)
    for (r in seq_len(cell$reps)) {
      dats[[r]] <- recast(drawn[[r]])
      base[[r]] <- lav_one(dats[[r]])
      if (r %% 1000L == 0L) {
        cat(sprintf("%s %s c%s base rep %d fails %d\n",
                    cell$stream, cell$setting, cell$cond, r,
                    sum(vapply(base[seq_len(r)], function(z) z$conv == 0L, logical(1)))),
            file = log_path, append = TRUE)
      }
    }
    rm(drawn)
  }
  conv <- vapply(base, function(z) z$conv == 1L, logical(1))
  fail_idx <- which(!conv)
  ok_idx <- which(conv)
  set.seed(cell$pick_seed)
  ctrl_idx <- if (length(ok_idx) <= n_control_each) ok_idx else sample(ok_idx, n_control_each)
  keep <- sort(unique(c(fail_idx, ctrl_idx)))

  rows <- lapply(keep, function(r) {
    dat <- dats[[r]]
    flags <- data_flags(dat)
    num <- as_openmx(dat)
    bfgs <- lav_one(dat, optim.method = "BFGS")
    long <- lav_one(dat, control = list(iter.max = 50000))
    simple <- lav_one(dat, start = "simple")
    slsqp <- omx_one(num, "SLSQP")
    csolnp <- omx_one(num, "CSOLNP")
    # This CRAN build's default optimizer is SLSQP. NPSOL is not compiled in.
    deflt <- slsqp
    lav <- base[[r]]
    data.frame(
      stream = cell$stream, cond = cell$cond, setting = cell$setting,
      seed = cell$seed, rep = r,
      role = if (r %in% fail_idx) "fail" else "control",
      kappa = flags[["kappa"]], min_eig = flags[["min_eig"]],
      lav_conv = lav$conv, lav_min_var = lav$min_var, lav_niter = lav$niter,
      lav_gradient = lav$gradient,
      lav_b1 = lav$est[[1]], lav_b2 = lav$est[[2]], lav_b3 = lav$est[[3]],
      lav_p1 = lav$p[[1]], lav_p2 = lav$p[[2]], lav_p3 = lav$p[[3]],
      bfgs_conv = bfgs$conv, long_conv = long$conv, simple_conv = simple$conv,
      bfgs_p1 = bfgs$p[[1]], bfgs_p2 = bfgs$p[[2]], bfgs_p3 = bfgs$p[[3]],
      long_p1 = long$p[[1]], long_p2 = long$p[[2]], long_p3 = long$p[[3]],
      simple_p1 = simple$p[[1]], simple_p2 = simple$p[[2]], simple_p3 = simple$p[[3]],
      slsqp_code = slsqp$code, csolnp_code = csolnp$code, default_code = deflt$code,
      slsqp_b1 = slsqp$est[[1]], slsqp_b2 = slsqp$est[[2]], slsqp_b3 = slsqp$est[[3]],
      stringsAsFactors = FALSE
    )
  })
  detail <- do.call(rbind, rows)
  sig <- function(p) is.finite(p) & p < 0.05
  base_sig <- vapply(base, function(z) if (z$conv == 1L) sum(sig(z$p)) else NA_integer_, integer(1))
  # per-contrast base counts
  base_n <- sum(conv)
  base_k <- integer(3)
  for (j in 1:3) {
    base_k[[j]] <- sum(vapply(base[conv], function(z) sig(z$p[[j]]), logical(1)))
  }
  # failures recovered by each lavaan retry, using that retry's p
  recovered <- function(flag, pcols) {
    sub <- detail[detail$role == "fail", ]
    got <- sub[[flag]] == 1L
    extra_n <- sum(got)
    extra_k <- integer(3)
    for (j in 1:3) extra_k[[j]] <- sum(sig(sub[[pcols[[j]]]][got]))
    list(n = base_n + extra_n, k = base_k + extra_k)
  }
  rate_row <- function(label, nn, kk) {
    data.frame(
      stream = cell$stream, cond = cell$cond, setting = cell$setting,
      rule = label, n_used = nn,
      pct1 = 100 * kk[[1]] / nn, pct2 = 100 * kk[[2]] / nn, pct3 = 100 * kk[[3]] / nn,
      stringsAsFactors = FALSE
    )
  }
  bf <- recovered("bfgs_conv", c("bfgs_p1", "bfgs_p2", "bfgs_p3"))
  lg <- recovered("long_conv", c("long_p1", "long_p2", "long_p3"))
  sm <- recovered("simple_conv", c("simple_p1", "simple_p2", "simple_p3"))
  rates <- rbind(
    rate_row("nlminb_10000", base_n, base_k),
    rate_row("bfgs", bf$n, bf$k),
    rate_row("iter_50000", lg$n, lg$k),
    rate_row("start_simple", sm$n, sm$k)
  )
  fail <- detail[detail$role == "fail", ]
  ctrl <- detail[detail$role == "control", ]
  diff3 <- function(a, b) pmax(abs(a - b), na.rm = FALSE)
  maxdiff <- if (nrow(ctrl) == 0) NA_real_ else max(abs(c(
    ctrl$slsqp_b1 - ctrl$lav_b1,
    ctrl$slsqp_b2 - ctrl$lav_b2,
    ctrl$slsqp_b3 - ctrl$lav_b3
  )), na.rm = TRUE)
  summary_row <- data.frame(
    stream = cell$stream, cond = cell$cond, setting = cell$setting, seed = cell$seed,
    reps = cell$reps, n_fail = length(fail_idx), n_control = length(ctrl_idx),
    fail_kappa_med = median(fail$kappa), fail_min_eig_med = median(fail$min_eig),
    fail_neg_var = sum(is.finite(fail$lav_min_var) & fail$lav_min_var < -1e-8),
    fail_gradient = sum(fail$lav_gradient == 1L),
    omx_slsqp_0 = sum(fail$slsqp_code == 0L, na.rm = TRUE),
    omx_slsqp_1 = sum(fail$slsqp_code == 1L, na.rm = TRUE),
    omx_csolnp_0 = sum(fail$csolnp_code == 0L, na.rm = TRUE),
    omx_csolnp_1 = sum(fail$csolnp_code == 1L, na.rm = TRUE),
    omx_default_0 = sum(fail$default_code == 0L, na.rm = TRUE),
    omx_default_1 = sum(fail$default_code == 1L, na.rm = TRUE),
    bfgs_recovered = sum(fail$bfgs_conv == 1L),
    long_recovered = sum(fail$long_conv == 1L),
    simple_recovered = sum(fail$simple_conv == 1L),
    control_max_abs_diff = maxdiff,
    stringsAsFactors = FALSE
  )
  tag <- sprintf("%s_c%s_%s", cell$stream, cell$cond, cell$setting)
  write.csv(detail, file.path(out_dir, paste0("openmx_", tag, ".csv")), row.names = FALSE)
  list(summary = summary_row, rates = rates)
}

cells <- list(
  data.frame(stream = "hand", cond = 1L, setting = "true", reps = 10000L, seed = 2403101L, pick_seed = 11L),
  data.frame(stream = "hand", cond = 1L, setting = "null", reps = 10000L, seed = 2404101L, pick_seed = 12L),
  data.frame(stream = "hand", cond = 3L, setting = "true", reps = 10000L, seed = 2403301L, pick_seed = 13L),
  data.frame(stream = "hand", cond = 3L, setting = "null", reps = 10000L, seed = 2404301L, pick_seed = 14L),
  data.frame(stream = "simsem", cond = 1L, setting = "true", reps = 10000L, seed = 13131L, pick_seed = 21L),
  data.frame(stream = "simsem", cond = 1L, setting = "null", reps = 10000L, seed = 13131L, pick_seed = 22L),
  data.frame(stream = "simsem", cond = 3L, setting = "true", reps = 10000L, seed = 13131L, pick_seed = 23L),
  data.frame(stream = "simsem", cond = 3L, setting = "null", reps = 10000L, seed = 13131L, pick_seed = 24L)
)

message("OpenMx ", packageVersion("OpenMx"), " default ", mxOption(NULL, "Default optimizer"))
pieces <- mclapply(cells, scan_cell, mc.cores = 4L, mc.preschedule = FALSE)
summ <- do.call(rbind, lapply(pieces, `[[`, "summary"))
rates <- do.call(rbind, lapply(pieces, `[[`, "rates"))
write.csv(summ, file.path(out_dir, "openmx_summary.csv"), row.names = FALSE)
write.csv(rates, file.path(out_dir, "openmx_rates.csv"), row.names = FALSE)
sess <- file.path(out_dir, "openmx_session.txt")
cat("OpenMx ", as.character(packageVersion("OpenMx")), "\n", file = sess)
cat("default optimizer ", mxOption(NULL, "Default optimizer"), "\n", file = sess, append = TRUE)
cat("NPSOL not compiled into this CRAN build\n", file = sess, append = TRUE)
cat("compile note: Rf_isDataFrame replaced by Rf_isFrame in omxData.cpp\n",
    file = sess, append = TRUE)
cat("lavaan ", as.character(packageVersion("lavaan")), "\n", file = sess, append = TRUE)
cat("simsem ", as.character(packageVersion("simsem")), "\n", file = sess, append = TRUE)
cat("R ", R.version.string, "\n", file = sess, append = TRUE)
message("wrote ", file.path(out_dir, "openmx_summary.csv"))
print(summ)
