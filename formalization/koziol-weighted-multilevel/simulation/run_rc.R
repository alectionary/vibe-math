# Random-coefficient arm, normal outcome, informative design.
# Appendix A block for ICC .05 and average sample cluster size 5, extended
# with the same variance construction Koziol used at the other ICC
# (tau00 = rho / (1 - 1.5 rho), tau11 = tau00 / 2, correlation .30).
# Replication count is SIM_REPS (default 40), not 1,000.
# Weighted multilevel fits are WeMix. Single-level fits are survey::svyglm.

sim_dir <- Sys.getenv("SIM_DIR", unset = getwd())
source(file.path(sim_dir, "parameters.R"))
source(file.path(sim_dir, "generate.R"))
library(survey)
library(lme4)
library(WeMix)
library(parallel)

reps <- as.integer(Sys.getenv("SIM_REPS", unset = "40"))
cores <- as.integer(Sys.getenv("SIM_CORES", unset = "3"))

rc_parameters <- function(icc) {
  tau00 <- icc / (1 - 1.5 * icc)
  tau11 <- 0.5 * tau00
  tau01 <- 0.30 * sqrt(tau00 * tau11)
  g10 <- gamma10_value()
  list(gamma00 = 0, gamma01 = sqrt(tau00 * 0.06 / 0.94), gamma10 = g10,
       gamma11 = sqrt(tau11 * 0.06 / 0.94),
       tau00 = tau00, tau11 = tau11, tau01 = tau01, sigma2 = 1)
}

generate_rc <- function(icc, nj_target, seed) {
  par <- rc_parameters(icc)
  set.seed(seed)
  M <- 48450
  Nj.ave <- if (nj_target == 5) 25 else 100
  wj <- rnorm(M)
  U <- MASS::mvrnorm(M, mu = c(0, 0), Sigma = matrix(c(par$tau00, par$tau01, par$tau01, par$tau11), 2))
  u0 <- U[, 1]; u1 <- U[, 2]
  delta <- rnorm(M, 0, sqrt(0.2))
  cap <- 1.5 * sqrt(0.2)
  delta <- pmin(pmax(delta, -cap), cap)
  Nj <- ifelse(delta <= 0, round(Nj.ave * exp(delta)), round(2 * Nj.ave - Nj.ave * exp(-delta)))
  Nj <- pmax(as.integer(Nj), 1L)
  school_all <- rep.int(seq_len(M), Nj)
  N <- length(school_all)
  rij <- rnorm(N); x <- rnorm(N)
  x_sum <- rowsum(x, school_all, reorder = FALSE)
  x_n <- rowsum(rep(1, N), school_all, reorder = FALSE)
  xgmc <- x - as.numeric(x_sum / x_n)[school_all]
  y <- par$gamma00 + par$gamma01 * wj[school_all] + u0[school_all] +
    par$gamma10 * xgmc + par$gamma11 * wj[school_all] * xgmc + u1[school_all] * xgmc + rij
  scale2 <- function(z) ((z - mean(z)) / sd(z)) * sqrt(2)
  u_used <- scale2(u0); r_used <- scale2(rij)
  prob_j <- 1 / (1 + exp((-u_used / 2) + 4.12))
  prob_i <- 1 / (1 + exp((-r_used / 2) + 1.53))
  keep <- (prob_j[school_all] > runif(M)[school_all]) & (prob_i > runif(N))
  sch <- school_all[keep]
  m <- length(unique(sch))
  w_j <- 1 / prob_j
  w_cond <- 1 / prob_i
  wj_approx <- M / m
  dat <- data.frame(
    school = sch, y = y[keep], xgmc = xgmc[keep], wj = wj[sch],
    w_j = w_j[sch], w_cond = w_cond[keep],
    w_uncond = w_j[sch] * w_cond[keep],
    wj_approx = wj_approx,
    w_cond_approx = (w_j[sch] * w_cond[keep]) / wj_approx,
    stringsAsFactors = FALSE
  )
  dat$xw <- dat$xgmc * dat$wj
  attr(dat, "par") <- par
  dat
}

one <- function(spec) {
  dat <- generate_rc(spec$icc, spec$nj, spec$seed)
  par <- attr(dat, "par")
  dat$w1s <- scale_method2(dat$w_cond, dat$school)
  dat$w1a <- scale_method2(dat$w_cond_approx, dat$school)
  grab <- function(est, b, ok) {
    data.frame(rep = spec$rep, seed = spec$seed, icc = spec$icc, nj = spec$nj,
               estimator = est, g00 = b[1], g10 = b[2], g01 = b[3], g11 = b[4],
               converged = ok,
               t00 = par$gamma00, t10 = par$gamma10, t01 = par$gamma01, t11 = par$gamma11,
               stringsAsFactors = FALSE)
  }
  d1 <- svydesign(ids = ~school, weights = ~w_uncond, data = dat)
  dat$w_one <- 1
  d0 <- svydesign(ids = ~school, weights = ~w_one, data = dat)
  fs <- tryCatch(svyglm(y ~ xgmc + wj + xw, design = d1), error = function(e) e)
  fu <- tryCatch(svyglm(y ~ xgmc + wj + xw, design = d0), error = function(e) e)
  fl <- tryCatch(lmer(y ~ xgmc + wj + xw + (xgmc | school), data = dat, REML = FALSE),
                 error = function(e) e)
  # coef order: intercept, xgmc, wj, xw -> g00, g10, g01, g11
  wm <- tryCatch(mix(y ~ xgmc + wj + xw + (xgmc | school), data = dat,
                     weights = c("w1s", "w_j"), cWeights = TRUE), error = function(e) e)
  wa <- tryCatch(mix(y ~ xgmc + wj + xw + (xgmc | school), data = dat,
                     weights = c("w1a", "wj_approx"), cWeights = TRUE), error = function(e) e)
  rows <- list()
  if (!inherits(fu, "error")) rows[[length(rows)+1]] <- grab("us.ics", unname(coef(fu)), TRUE)
  if (!inherits(fs, "error")) rows[[length(rows)+1]] <- grab("ws.ics", unname(coef(fs)), TRUE)
  if (!inherits(fl, "error")) rows[[length(rows)+1]] <- grab("um.ccs", unname(fixef(fl)), TRUE)
  if (!inherits(wm, "error")) rows[[length(rows)+1]] <- grab("wtm.ccs", unname(coef(wm)), TRUE)
  if (!inherits(wa, "error")) rows[[length(rows)+1]] <- grab("wam.ccs", unname(coef(wa)), TRUE)
  do.call(rbind, rows)
}

specs <- lapply(seq_len(reps), function(r) list(rep = r, seed = 800000L + r, icc = 0.05, nj = 5))
message("RC start ", Sys.time(), " reps ", reps)
parts <- mclapply(specs, one, mc.cores = cores)
tab <- do.call(rbind, parts)
path <- file.path(sim_dir, "results", "rc_inf_05_5.csv")
write.csv(tab, path, row.names = FALSE)
message("wrote ", path, " ", nrow(tab), " ", Sys.time())
