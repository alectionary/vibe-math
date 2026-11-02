# Finite-population two-stage Poisson sample.
# Follows Koziol (2015) Appendix A (pp. 182-184) and equations 24-28 (pp. 73-75).
# This is one design per call. The appendix loop drew the informative and
# non-informative samples from one RNG stream; the Monte Carlo law is the same
# when each design is drawn from its own seed.

generate_sample <- function(icc, nj_target, design, seed, outcome = "normal") {
  if (!design %in% c("informative", "noninformative")) stop("design")
  if (!nj_target %in% c(5, 20)) stop("nj")
  if (!outcome %in% c("normal", "bernoulli")) stop("outcome")
  par <- ri_parameters(icc)
  set.seed(seed)
  M <- 48450
  Nj.ave <- if (nj_target == 5) 25 else 100
  wj <- rnorm(M)
  u0 <- rnorm(M, 0, sqrt(par$tau00))
  delta <- rnorm(M, 0, sqrt(0.2))
  cap <- 1.5 * sqrt(0.2)
  delta <- pmin(pmax(delta, -cap), cap)
  Nj <- ifelse(delta <= 0,
               round(Nj.ave * exp(delta)),
               round(2 * Nj.ave - Nj.ave * exp(-delta)))
  Nj <- pmax(as.integer(Nj), 1L)
  N <- sum(Nj)
  school_all <- rep.int(seq_len(M), Nj)
  rij <- rnorm(N)
  x <- rnorm(N)
  # Population group-mean centering, as in Appendix A columns xij.cov.gm / gmc.
  x_sum <- rowsum(x, school_all, reorder = FALSE)
  x_n <- rowsum(rep(1, N), school_all, reorder = FALSE)
  xgm <- as.numeric(x_sum / x_n)[school_all]
  xgmc <- x - xgm
  ystar <- par$gamma00 + par$gamma01 * wj[school_all] + u0[school_all] +
    par$gamma10 * xgmc + rij
  ybin <- as.integer(ystar > 0)

  scale_to_var2 <- function(z) ((z - mean(z)) / sd(z)) * sqrt(2)
  if (design == "informative") {
    u_used <- scale_to_var2(u0)
    r_used <- scale_to_var2(rij)
  } else {
    u_used <- scale_to_var2(rnorm(M, 0, sqrt(2)))
    r_used <- scale_to_var2(rnorm(N, 0, sqrt(2)))
  }
  prob_j <- 1 / (1 + exp((-u_used / 2) + 4.12))
  prob_i <- 1 / (1 + exp((-r_used / 2) + 1.53))
  sel_j <- prob_j > runif(M)
  sel_i <- prob_i > runif(N)
  keep <- sel_j[school_all] & sel_i
  # Release the population vectors before building the sample frame.
  w_j <- 1 / prob_j
  w_cond <- 1 / prob_i
  sch <- school_all[keep]
  # Drop clusters that contributed no level-1 selections. Approximate cluster
  # weights use this realized cluster count (Appendix A, M / nrow unique schools).
  m_samp <- length(unique(sch))
  wj_approx <- M / m_samp
  out <- data.frame(
    school = sch,
    y = if (outcome == "normal") ystar[keep] else ybin[keep],
    xgmc = xgmc[keep],
    wj = wj[sch],
    w_j = w_j[sch],
    w_cond = w_cond[keep],
    w_uncond = w_j[sch] * w_cond[keep],
    wj_approx = wj_approx,
    w_cond_approx = (w_j[sch] * w_cond[keep]) / wj_approx,
    eta = par$gamma00 + par$gamma01 * wj[sch] + par$gamma10 * xgmc[keep],
    stringsAsFactors = FALSE
  )
  attr(out, "par") <- par
  attr(out, "design") <- design
  attr(out, "nj_target") <- nj_target
  attr(out, "M") <- M
  attr(out, "N") <- N
  attr(out, "outcome") <- outcome
  out
}

scale_method2 <- function(w, school) {
  # Pfeffermann method A / Mplus WTSCALE = CLUSTER (Koziol equation 15).
  # Scaled conditional weights sum to the cluster sample size.
  ave(w, school, FUN = function(z) z * length(z) / sum(z))
}
