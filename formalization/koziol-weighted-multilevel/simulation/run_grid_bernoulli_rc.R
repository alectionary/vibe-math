# All eight Bernoulli random-coefficient cells, eight estimators.
# The binary outcome is the sign of the latent random-coefficient response.
# Table C.4's intercept is the threshold, the negative of the latent intercept.
# Weighted fits are Gauss-Hermite MPML. Incorrect-covariance fits are random
# intercept only. Each replication is its own file.

sim_dir <- Sys.getenv("SIM_DIR", unset = getwd())
reps <- as.integer(Sys.getenv("SIM_REPS", unset = "1000"))
cores <- as.integer(Sys.getenv("SIM_CORES", unset = "2"))
nquad <- as.integer(Sys.getenv("SIM_NQUAD", unset = "9"))
source(file.path(sim_dir, "parameters.R"))
source(file.path(sim_dir, "generate.R"))
source(file.path(sim_dir, "mpml_probit.R"))
library(survey)
library(lme4)
library(parallel)

rc_parameters <- function(icc) {
  tau00 <- icc / (1 - 1.5 * icc)
  tau11 <- 0.5 * tau00
  tau01 <- 0.30 * sqrt(tau00 * tau11)
  g10 <- gamma10_value()
  list(gamma00 = 0, gamma01 = sqrt(tau00 * 0.06 / 0.94), gamma10 = g10,
       gamma11 = sqrt(tau11 * 0.06 / 0.94),
       tau00 = tau00, tau11 = tau11, tau01 = tau01)
}

# Table 3.4 Monte Carlo population-averaged targets for the random-coefficient model.
rc_pa_table <- function(icc) {
  if (abs(icc - 0.05) < 1e-8) {
    c(g00 = -0.002, g01 = 0.056, g10 = 0.238, g11 = 0.039)
  } else {
    c(g00 = -0.008, g01 = 0.124, g10 = 0.184, g11 = 0.077)
  }
}

generate_rc_binary <- function(icc, nj_target, design, seed) {
  par <- rc_parameters(icc)
  set.seed(seed)
  M <- 48450
  Nj.ave <- if (nj_target == 5) 25 else 100
  wj <- rnorm(M)
  U <- MASS::mvrnorm(M, mu = c(0, 0), Sigma = matrix(c(par$tau00, par$tau01, par$tau01, par$tau11), 2))
  u0 <- U[, 1]; u1 <- U[, 2]
  delta <- pmin(pmax(rnorm(M, 0, sqrt(0.2)), -1.5 * sqrt(0.2)), 1.5 * sqrt(0.2))
  Nj <- pmax(as.integer(ifelse(delta <= 0, round(Nj.ave * exp(delta)),
                               round(2 * Nj.ave - Nj.ave * exp(-delta)))), 1L)
  school_all <- rep.int(seq_len(M), Nj)
  N <- length(school_all)
  rij <- rnorm(N); x <- rnorm(N)
  xgm <- as.numeric(rowsum(x, school_all, reorder = FALSE) /
                      rowsum(rep(1, N), school_all, reorder = FALSE))[school_all]
  xgmc <- x - xgm
  ystar <- par$gamma01 * wj[school_all] + u0[school_all] + par$gamma10 * xgmc +
    par$gamma11 * wj[school_all] * xgmc + u1[school_all] * xgmc + rij
  scale2 <- function(z) ((z - mean(z)) / sd(z)) * sqrt(2)
  if (design == "informative") {
    u_used <- scale2(u0); r_used <- scale2(rij)
  } else {
    u_used <- scale2(rnorm(M, 0, sqrt(2))); r_used <- scale2(rnorm(N, 0, sqrt(2)))
  }
  prob_j <- 1 / (1 + exp((-u_used / 2) + 4.12))
  prob_i <- 1 / (1 + exp((-r_used / 2) + 1.53))
  keep <- (prob_j > runif(M))[school_all] & (prob_i > runif(N))
  sch <- school_all[keep]
  w_j <- (1 / prob_j)[sch]
  w_cond <- (1 / prob_i)[keep]
  m <- length(unique(sch))
  wj_approx <- M / m
  dat <- data.frame(school = sch, y = as.integer(ystar[keep] > 0), xgmc = xgmc[keep],
                    wj = wj[sch], w_j = w_j, w_cond = w_cond, w_uncond = w_j * w_cond,
                    wj_approx = wj_approx,
                    w_cond_approx = (w_j * w_cond) / wj_approx,
                    stringsAsFactors = FALSE)
  dat$xw <- dat$xgmc * dat$wj
  attr(dat, "par") <- par
  dat
}

fit_rep <- function(spec) {
  dir <- file.path(sim_dir, "results", "grid", "bern_rc")
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  path <- file.path(dir, sprintf("%s_r%04d.csv", spec$id, spec$rep))
  if (file.exists(path) && file.info(path)$size > 80) return(path)
  dat <- generate_rc_binary(spec$icc, spec$nj, spec$design, spec$seed)
  par <- attr(dat, "par")
  pa <- rc_pa_table(spec$icc)
  dat$w1s <- scale_method2(dat$w_cond, dat$school)
  dat$w1a <- scale_method2(dat$w_cond_approx, dat$school)
  X <- cbind(1, dat$xgmc, dat$wj, dat$xw)
  eta <- par$gamma10 * dat$xgmc + par$gamma01 * dat$wj + par$gamma11 * dat$xw
  rmse_of <- function(b) {
    if (!all(is.finite(b))) return(NA_real_)
    sqrt(mean((b[1] + b[2] * dat$xgmc + b[3] * dat$wj + b[4] * dat$xw - eta)^2))
  }
  rows <- list()
  add <- function(est, b, se, ok, tau = NA_real_) {
    if (length(b) < 4) b <- rep(NA_real_, 4)
    if (length(se) < 4) se <- rep(NA_real_, 4)
    rows[[length(rows) + 1]] <<- data.frame(
      id = spec$id, rep = spec$rep, seed = spec$seed, model = "RC", outcome = "bernoulli",
      design = spec$design, icc = spec$icc, nj = spec$nj, estimator = est,
      g00 = -b[1], g10 = b[2], g01 = b[3], g11 = b[4],
      se00 = se[1], se10 = se[2], se01 = se[3], se11 = se[4],
      tau = tau, rmse = rmse_of(b), converged = isTRUE(ok),
      t00 = par$gamma00, t10 = par$gamma10, t01 = par$gamma01, t11 = par$gamma11,
      pa00 = pa["g00"], pa10 = pa["g10"], pa01 = pa["g01"], pa11 = pa["g11"],
      stringsAsFactors = FALSE)
  }
  # Easy replicates converge in about 130 evaluations. A higher cap lets
  # flat likelihoods run for minutes without moving the weighted fits.
  ctrl <- glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 400))
  timed <- function(expr) {
    setTimeLimit(cpu = 25, elapsed = 30, transient = TRUE)
    on.exit(setTimeLimit(cpu = Inf, elapsed = Inf, transient = TRUE), add = TRUE)
    tryCatch(expr, error = function(e) e)
  }
  fl <- timed(glmer(y ~ xgmc + wj + xw + (xgmc | school), data = dat,
                    family = binomial(link = "probit"), control = ctrl))
  fi <- timed(glmer(y ~ xgmc + wj + xw + (1 | school), data = dat,
                    family = binomial(link = "probit"), control = ctrl))
  dat$w_one <- 1
  d1 <- svydesign(ids = ~school, weights = ~w_uncond, data = dat)
  d0 <- svydesign(ids = ~school, weights = ~w_one, data = dat)
  fs <- tryCatch(svyglm(y ~ xgmc + wj + xw, design = d1, family = quasibinomial(link = "probit")),
                 error = function(e) e)
  fu <- tryCatch(svyglm(y ~ xgmc + wj + xw, design = d0, family = quasibinomial(link = "probit")),
                 error = function(e) e)
  if (!inherits(fu, "error")) add("us.ics", unname(coef(fu)), unname(SE(fu)), TRUE)
  if (!inherits(fs, "error")) add("ws.ics", unname(coef(fs)), unname(SE(fs)), TRUE)
  start_b <- if (!inherits(fl, "error")) unname(fixef(fl)) else if (!inherits(fu, "error")) unname(coef(fu)) else rep(0, 4)
  start_i <- if (!inherits(fi, "error")) unname(fixef(fi)) else start_b
  if (!inherits(fl, "error")) {
    vc <- VarCorr(fl)$school
    G <- c(vc[1, 1], vc[1, 2], vc[2, 2])
    add("um.ccs", start_b, tryCatch(sqrt(diag(vcov(fl))), error = function(e) rep(NA_real_, 4)),
        TRUE, tau = unname(G[1]))
  } else G <- c(0.05, 0, 0.02)
  if (!inherits(fi, "error")) {
    tau_i <- max(as.numeric(VarCorr(fi)$school[1, 1]), 1e-4)
    add("um.ics", start_i, tryCatch(sqrt(diag(vcov(fi))), error = function(e) rep(NA_real_, 4)),
        TRUE, tau = tau_i)
  } else tau_i <- 0.05
  ft <- rc_probit_fast(dat$y, X, dat$xgmc, dat$school, dat$w1s, dat$w_j, start_b, G, nquad = nquad)
  add("wtm.ccs", ft$beta, ft$se, ft$converged, tau = ft$tau)
  fa <- rc_probit_fast(dat$y, X, dat$xgmc, dat$school, dat$w1a,
                       rep(dat$wj_approx[1], nrow(dat)), start_b, G, nquad = nquad)
  add("wam.ccs", fa$beta, fa$se, fa$converged, tau = fa$tau)
  it <- ri_probit_fast(dat$y, X, dat$school, dat$w1s, dat$w_j, start_i, tau_i, nquad = 15L)
  add("wtm.ics", it$beta, it$se, it$converged, tau = it$tau)
  ia <- ri_probit_fast(dat$y, X, dat$school, dat$w1a, rep(dat$wj_approx[1], nrow(dat)),
                       start_i, tau_i, nquad = 15L)
  add("wam.ics", ia$beta, ia$se, ia$converged, tau = ia$tau)
  write.csv(do.call(rbind, rows), path, row.names = FALSE)
  if (spec$rep %% 25L == 0L) message(spec$id, " rep ", spec$rep, " ", Sys.time())
  path
}

if (identical(Sys.getenv("SIM_RUN", unset = "1"), "1")) {
  cells <- expand.grid(design = c("informative", "noninformative"),
                       icc = c(0.05, 0.25), nj = c(5, 20), stringsAsFactors = FALSE)
  cells$id <- sprintf("rcB_%s_%02d_%02d", substr(cells$design, 1, 3), cells$icc * 100, cells$nj)
  cells$slot <- seq_len(nrow(cells))
  want <- Sys.getenv("SIM_CELLS", unset = "")
  if (nzchar(want)) {
    keep <- strsplit(want, ",", fixed = TRUE)[[1]]
    cells <- cells[cells$id %in% keep, , drop = FALSE]
  }
  tasks <- list()
  for (i in seq_len(nrow(cells))) {
    for (r in seq_len(reps)) {
      tasks[[length(tasks) + 1]] <- list(
        id = cells$id[i], design = cells$design[i], icc = cells$icc[i], nj = cells$nj[i],
        rep = r, seed = 920000L + cells$slot[i] * 1000L + r)
    }
  }
  message("bernoulli RC tasks ", length(tasks), " nquad ", nquad, " ", Sys.time())
  # One process per core. Forking once per replication dominated the runtime.
  invisible(mclapply(tasks, fit_rep, mc.cores = cores, mc.preschedule = TRUE))
  message("bernoulli RC finished ", Sys.time())
}
