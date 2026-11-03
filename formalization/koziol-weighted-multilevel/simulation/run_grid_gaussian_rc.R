# All eight normal random-coefficient cells, 1,000 replications, eight estimators.
# Weighted multilevel fits use the closed-form Gaussian MPML in mpml_gaussian.R,
# which matches WeMix on a checked replicate. Each replication is written to its
# own file so a stopped job can resume.

sim_dir <- Sys.getenv("SIM_DIR", unset = getwd())
reps <- as.integer(Sys.getenv("SIM_REPS", unset = "1000"))
cores <- as.integer(Sys.getenv("SIM_CORES", unset = "2"))
source(file.path(sim_dir, "parameters.R"))
source(file.path(sim_dir, "generate.R"))
source(file.path(sim_dir, "mpml_gaussian.R"))
source(file.path(sim_dir, "estimators.R"))
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

generate_rc <- function(icc, nj_target, design, seed) {
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
  y <- par$gamma01 * wj[school_all] + u0[school_all] + par$gamma10 * xgmc +
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
  dat <- data.frame(school = sch, y = y[keep], xgmc = xgmc[keep], wj = wj[sch],
                    w_j = w_j, w_cond = w_cond, w_uncond = w_j * w_cond,
                    wj_approx = wj_approx,
                    w_cond_approx = (w_j * w_cond) / wj_approx,
                    stringsAsFactors = FALSE)
  dat$xw <- dat$xgmc * dat$wj
  attr(dat, "par") <- par
  dat
}

fit_rep <- function(spec) {
  dir <- file.path(sim_dir, "results", "grid", "gauss_rc")
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  path <- file.path(dir, sprintf("%s_r%04d.csv", spec$id, spec$rep))
  if (file.exists(path) && file.info(path)$size > 50) return(path)
  dat <- generate_rc(spec$icc, spec$nj, spec$design, spec$seed)
  par <- attr(dat, "par")
  dat$w1s <- scale_method2(dat$w_cond, dat$school)
  dat$w1a <- scale_method2(dat$w_cond_approx, dat$school)
  X <- cbind(1, dat$xgmc, dat$wj, dat$xw)
  eta <- par$gamma10 * dat$xgmc + par$gamma01 * dat$wj + par$gamma11 * dat$xw
  rmse_of <- function(b) sqrt(mean((b[1] + b[2] * dat$xgmc + b[3] * dat$wj + b[4] * dat$xw - eta)^2))
  rows <- list()
  add <- function(est, b, se, ok) {
    if (length(b) < 4) b <- rep(NA_real_, 4)
    if (length(se) < 4) se <- rep(NA_real_, 4)
    rows[[length(rows) + 1]] <<- data.frame(
      id = spec$id, rep = spec$rep, seed = spec$seed, model = "RC", outcome = "normal",
      design = spec$design, icc = spec$icc, nj = spec$nj, estimator = est,
      g00 = b[1], g10 = b[2], g01 = b[3], g11 = b[4],
      se00 = se[1], se10 = se[2], se01 = se[3], se11 = se[4],
      rmse = if (all(is.finite(b))) rmse_of(b) else NA_real_,
      converged = isTRUE(ok),
      t00 = par$gamma00, t10 = par$gamma10, t01 = par$gamma01, t11 = par$gamma11,
      stringsAsFactors = FALSE)
  }
  dat$w_one <- 1
  d1 <- svydesign(ids = ~school, weights = ~w_uncond, data = dat)
  d0 <- svydesign(ids = ~school, weights = ~w_one, data = dat)
  fs <- tryCatch(svyglm(y ~ xgmc + wj + xw, design = d1), error = function(e) e)
  fu <- tryCatch(svyglm(y ~ xgmc + wj + xw, design = d0), error = function(e) e)
  fl <- tryCatch(lmer(y ~ xgmc + wj + xw + (xgmc | school), data = dat, REML = FALSE,
                      control = lmerControl(optimizer = "bobyqa")), error = function(e) e)
  fi <- tryCatch(lmer(y ~ xgmc + wj + xw + (1 | school), data = dat, REML = FALSE,
                      control = lmerControl(optimizer = "bobyqa")), error = function(e) e)
  if (!inherits(fu, "error")) add("us.ics", unname(coef(fu)), unname(SE(fu)), TRUE)
  if (!inherits(fs, "error")) add("ws.ics", unname(coef(fs)), unname(SE(fs)), TRUE)
  if (!inherits(fl, "error")) add("um.ccs", unname(fixef(fl)), sqrt(diag(vcov(fl))), TRUE)
  if (!inherits(fi, "error")) add("um.ics", unname(fixef(fi)), sqrt(diag(vcov(fi))), TRUE)
  ft <- rc_mpml_fit(dat$y, X, dat$xgmc, dat$school, dat$w1s, dat$w_j, se = TRUE)
  add("wtm.ccs", ft$beta, ft$se, ft$converged)
  fa <- rc_mpml_fit(dat$y, X, dat$xgmc, dat$school, dat$w1a, rep(dat$wj_approx[1], nrow(dat)), se = TRUE)
  add("wam.ccs", fa$beta, fa$se, fa$converged)
  it <- ri_mpml_fit(dat$y, X, dat$school, dat$w1s, dat$w_j)
  add("wtm.ics", it$beta, it$se, it$converged)
  ia <- ri_mpml_fit(dat$y, X, dat$school, dat$w1a, rep(dat$wj_approx[1], nrow(dat)))
  add("wam.ics", ia$beta, ia$se, ia$converged)
  tab <- do.call(rbind, rows)
  write.csv(tab, path, row.names = FALSE)
  path
}

cells <- expand.grid(design = c("informative", "noninformative"),
                     icc = c(0.05, 0.25), nj = c(5, 20), stringsAsFactors = FALSE)
cells$id <- sprintf("rcN_%s_%02d_%02d", substr(cells$design, 1, 3), cells$icc * 100, cells$nj)
tasks <- list()
for (i in seq_len(nrow(cells))) {
  for (r in seq_len(reps)) {
    tasks[[length(tasks) + 1]] <- list(
      id = cells$id[i], design = cells$design[i], icc = cells$icc[i], nj = cells$nj[i],
      rep = r, seed = 700000L + i * 1000L + r)
  }
}
message("gaussian RC tasks ", length(tasks), " ", Sys.time())
done <- mclapply(tasks, fit_rep, mc.cores = cores)
message("gaussian RC finished ", sum(lengths(done) > 0), " ", Sys.time())
