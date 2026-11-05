# Estimators for the Gaussian random-intercept cells.
# Weighted multilevel point estimates are the analytic MPML that matches WeMix
# when conditional weights are scaled by Method 2 and level-2 weights are unscaled.
# Sandwich standard errors are cluster CR-0 from the observed pseudo-likelihood.

library(survey)
library(lme4)

ri_mpml_fit <- function(y, X, school, w1s, w2) {
  school <- as.integer(factor(school))
  o <- order(school)
  y <- y[o]
  X <- X[o, , drop = FALSE]
  w1s <- as.numeric(w1s[o])
  w2 <- as.numeric(w2[o])
  school <- school[o]
  w2c <- as.numeric(rowsum(w2, school) / as.numeric(rowsum(rep(1, length(school)), school)))
  p <- ncol(X)
  sw <- sqrt(pmax(w1s, 1e-12) * pmax(w2, 1e-12))
  beta0 <- as.numeric(qr.solve(X * sw, y * sw))
  r0 <- y - as.numeric(X %*% beta0)
  sig20 <- sum(w1s * w2 * r0^2) / sum(w1s * w2)
  cluster_ll <- function(theta) {
    beta <- theta[1:p]
    sig2 <- exp(theta[p + 1])
    tau <- exp(theta[p + 2])
    r <- y - as.numeric(X %*% beta)
    W <- as.numeric(rowsum(w1s, school))
    S <- as.numeric(rowsum(w1s * r, school))
    Q <- as.numeric(rowsum(w1s * r * r, school))
    a <- W / (2 * sig2) + 1 / (2 * tau)
    b <- S / sig2
    logI <- -0.5 * W * log(2 * pi * sig2) - Q / (2 * sig2) - 0.5 * log(2 * pi * tau) +
      0.5 * log(pi / a) + (b * b) / (4 * a)
    w2c * logI
  }
  nll <- function(theta) -sum(cluster_ll(theta))
  th0 <- c(beta0, log(max(sig20, 1e-6)), log(0.05))
  opt <- nlminb(th0, nll, control = list(iter.max = 200, eval.max = 600, rel.tol = 1e-8))
  ok <- opt$convergence == 0 && all(is.finite(opt$par))
  se <- rep(NA_real_, p)
  if (ok) {
    se <- tryCatch({
      S <- numDeriv::jacobian(cluster_ll, opt$par)
      H <- numDeriv::hessian(nll, opt$par)
      # nll hessian is the negative loglik hessian. Bread is solve(H_ll) = -solve(H_nll).
      V <- solve(H, t(S) %*% S) %*% solve(H)
      sqrt(pmax(diag(V)[1:p], 0))
    }, error = function(e) rep(NA_real_, p))
  }
  list(beta = opt$par[1:p], se = se, sig2 = exp(opt$par[p + 1]),
       tau = exp(opt$par[p + 2]), converged = ok)
}

rmse_fixed <- function(b0, b_x, b_w, dat) {
  eta_hat <- b0 + b_x * dat$xgmc + b_w * dat$wj
  sqrt(mean((eta_hat - dat$eta)^2))
}

fit_one <- function(dat) {
  dat$w1s_true <- scale_method2(dat$w_cond, dat$school)
  dat$w1s_approx <- scale_method2(dat$w_cond_approx, dat$school)
  X <- cbind(1, dat$xgmc, dat$wj)
  rows <- list()
  add <- function(estimator, g00, g10, g01, se00, se10, se01, converged, rmse, extra = NA_real_) {
    rows[[length(rows) + 1]] <<- data.frame(
      estimator = estimator, g00 = g00, g10 = g10, g01 = g01,
      se00 = se00, se10 = se10, se01 = se01,
      converged = converged, rmse = rmse, tau = extra,
      stringsAsFactors = FALSE
    )
  }
  # Unweighted and weighted single-level, cluster sandwich (Mplus TYPE=COMPLEX, MLR).
  d1 <- svydesign(ids = ~school, weights = ~w_uncond, data = dat)
  dat$w_one <- 1
  d0 <- svydesign(ids = ~school, weights = ~w_one, data = dat)
  f_ws <- tryCatch(svyglm(y ~ xgmc + wj, design = d1), error = function(e) e)
  f_us <- tryCatch(svyglm(y ~ xgmc + wj, design = d0), error = function(e) e)
  if (!inherits(f_ws, "error")) {
    b <- coef(f_ws); s <- SE(f_ws)
    add("ws.ics", b[1], b[2], b[3], s[1], s[2], s[3], TRUE,
        rmse_fixed(b[1], b[2], b[3], dat))
  } else add("ws.ics", NA, NA, NA, NA, NA, NA, FALSE, NA)
  if (!inherits(f_us, "error")) {
    b <- coef(f_us); s <- SE(f_us)
    add("us.ics", b[1], b[2], b[3], s[1], s[2], s[3], TRUE,
        rmse_fixed(b[1], b[2], b[3], dat))
  } else add("us.ics", NA, NA, NA, NA, NA, NA, FALSE, NA)
  f_um <- tryCatch(lmer(y ~ xgmc + wj + (1 | school), data = dat, REML = FALSE,
                        control = lmerControl(optimizer = "bobyqa")),
                   error = function(e) e)
  um_msgs <- if (!inherits(f_um, "error")) f_um@optinfo$conv$lme4$messages else "error"
  um_ok <- !inherits(f_um, "error") && (is.null(um_msgs) || length(um_msgs) == 0)
  if (um_ok) {
    b <- fixef(f_um)
    vv <- as.matrix(vcov(f_um))
    s <- sqrt(diag(vv))
    add("um.ccs", b[1], b[2], b[3], s[1], s[2], s[3], TRUE,
        rmse_fixed(b[1], b[2], b[3], dat), extra = as.numeric(VarCorr(f_um)$school[1, 1]))
  } else if (!inherits(f_um, "error")) {
    b <- fixef(f_um)
    add("um.ccs", b[1], b[2], b[3], NA, NA, NA, FALSE,
        rmse_fixed(b[1], b[2], b[3], dat))
  } else add("um.ccs", NA, NA, NA, NA, NA, NA, FALSE, NA)
  f_wt <- ri_mpml_fit(dat$y, X, dat$school, dat$w1s_true, dat$w_j)
  add("wtm.ccs", f_wt$beta[1], f_wt$beta[2], f_wt$beta[3],
      f_wt$se[1], f_wt$se[2], f_wt$se[3], f_wt$converged,
      if (all(is.finite(f_wt$beta))) rmse_fixed(f_wt$beta[1], f_wt$beta[2], f_wt$beta[3], dat) else NA,
      extra = f_wt$tau)
  f_wa <- ri_mpml_fit(dat$y, X, dat$school, dat$w1s_approx, rep(dat$wj_approx[1], nrow(dat)))
  add("wam.ccs", f_wa$beta[1], f_wa$beta[2], f_wa$beta[3],
      f_wa$se[1], f_wa$se[2], f_wa$se[3], f_wa$converged,
      if (all(is.finite(f_wa$beta))) rmse_fixed(f_wa$beta[1], f_wa$beta[2], f_wa$beta[3], dat) else NA,
      extra = f_wa$tau)
  tab <- do.call(rbind, rows)
  tab$m <- length(unique(dat$school))
  tab$n <- nrow(dat)
  tab$mean_wj <- mean(dat$w_j[!duplicated(dat$school)])
  tab$sd_wj <- sd(dat$w_j[!duplicated(dat$school)])
  tab$mean_wcond <- mean(dat$w_cond)
  tab$sd_wcond <- sd(dat$w_cond)
  tab$mean_wij <- mean(dat$w_uncond)
  tab$sd_wij <- sd(dat$w_uncond)
  tab$mean_nj <- mean(as.numeric(table(dat$school)))
  tab$min_nj <- min(as.numeric(table(dat$school)))
  tab$max_nj <- max(as.numeric(table(dat$school)))
  tab
}
