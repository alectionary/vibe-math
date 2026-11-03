# Does the printed random-coefficient slope bias of about 0.034 appear when the
# level-1 covariate is the raw score rather than the population group-mean
# centered score saved in Appendix A? Twenty informative replications, lmer only.
# This file does not overwrite rc_inf_05_5.csv.

sim_dir <- Sys.getenv("SIM_DIR", unset = getwd())
source(file.path(sim_dir, "parameters.R"))
library(lme4)

rc_par <- function(icc = 0.05) {
  tau00 <- icc / (1 - 1.5 * icc)
  tau11 <- 0.5 * tau00
  tau01 <- 0.30 * sqrt(tau00 * tau11)
  g10 <- gamma10_value()
  list(gamma00 = 0, gamma01 = sqrt(tau00 * 0.06 / 0.94), gamma10 = g10,
       gamma11 = sqrt(tau11 * 0.06 / 0.94), tau00 = tau00, tau11 = tau11, tau01 = tau01)
}

one <- function(seed) {
  par <- rc_par()
  set.seed(seed)
  M <- 48450; Nj.ave <- 25
  wj <- rnorm(M)
  U <- MASS::mvrnorm(M, c(0, 0), matrix(c(par$tau00, par$tau01, par$tau01, par$tau11), 2))
  delta <- pmin(pmax(rnorm(M, 0, sqrt(0.2)), -1.5 * sqrt(0.2)), 1.5 * sqrt(0.2))
  Nj <- pmax(as.integer(ifelse(delta <= 0, round(Nj.ave * exp(delta)),
                               round(2 * Nj.ave - Nj.ave * exp(-delta)))), 1L)
  school_all <- rep.int(seq_len(M), Nj)
  N <- length(school_all)
  rij <- rnorm(N); x <- rnorm(N)
  xgm <- as.numeric(rowsum(x, school_all, reorder = FALSE) /
                      rowsum(rep(1, N), school_all, reorder = FALSE))[school_all]
  xgmc <- x - xgm
  y <- par$gamma01 * wj[school_all] + U[school_all, 1] + par$gamma10 * xgmc +
    par$gamma11 * wj[school_all] * xgmc + U[school_all, 2] * xgmc + rij
  scale2 <- function(z) ((z - mean(z)) / sd(z)) * sqrt(2)
  prob_j <- 1 / (1 + exp((-scale2(U[, 1]) / 2) + 4.12))
  prob_i <- 1 / (1 + exp((-scale2(rij) / 2) + 1.53))
  keep <- (prob_j[school_all] > runif(M)[school_all]) & (prob_i > runif(N))
  dat <- data.frame(school = school_all[keep], y = y[keep], xgmc = xgmc[keep],
                    xraw = x[keep], wj = wj[school_all[keep]])
  dat$xw_c <- dat$xgmc * dat$wj
  dat$xw_r <- dat$xraw * dat$wj
  fc <- lmer(y ~ xgmc + wj + xw_c + (xgmc | school), data = dat, REML = FALSE)
  fr <- lmer(y ~ xraw + wj + xw_r + (xraw | school), data = dat, REML = FALSE)
  c(centered = unname(fixef(fc)["xgmc"]) - par$gamma10,
    raw = unname(fixef(fr)["xraw"]) - par$gamma10,
    centered_int = unname(fixef(fc)[1]),
    raw_int = unname(fixef(fr)[1]))
}

set.seed(1)
seeds <- 810000 + seq_len(20)
res <- t(sapply(seeds, one))
out <- data.frame(res)
path <- file.path(sim_dir, "results", "slope_coding_check.csv")
write.csv(out, path, row.names = FALSE)
cat("mean centered slope bias", mean(out$centered), "\n")
cat("mean raw slope bias", mean(out$raw), "\n")
cat("mean centered intercept", mean(out$centered_int), "\n")
cat("mean raw intercept", mean(out$raw_int), "\n")
