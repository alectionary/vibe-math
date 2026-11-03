# Closed-form Gaussian MPML for a random intercept or a random intercept and slope.
# The conditional normal density is raised to the Method-2 weight and the
# cluster integral is raised to the unscaled level-2 weight. The random-intercept
# case reduces to the likelihood already checked against WeMix.

rc_mpml_fit <- function(y, X, zslope, school, w1s, w2, se = TRUE) {
  school <- as.integer(factor(school))
  o <- order(school)
  y <- as.numeric(y[o])
  X <- X[o, , drop = FALSE]
  zslope <- as.numeric(zslope[o])
  w1s <- as.numeric(w1s[o])
  w2 <- as.numeric(w2[o])
  school <- school[o]
  w2c <- as.numeric(rowsum(w2, school) / as.numeric(rowsum(rep(1, length(school)), school)))
  p <- ncol(X)
  sw <- sqrt(pmax(w1s, 1e-12))
  beta0 <- as.numeric(qr.solve(X * sw, y * sw))
  # Sufficient statistics that do not depend on beta: weights and the slope covariate.
  ww <- as.numeric(rowsum(w1s, school))
  wx <- as.numeric(rowsum(w1s * zslope, school))
  wxx <- as.numeric(rowsum(w1s * zslope * zslope, school))
  nll_parts <- function(theta, beta_only = FALSE) {
    beta <- theta[1:p]
    sig2 <- exp(theta[p + 1])
    a <- theta[p + 2]; b <- theta[p + 3]; c <- theta[p + 4]
    # G = L L', L = [e^a, 0; b, e^c]
    G00 <- exp(2 * a)
    G01 <- b * exp(a)
    G11 <- b * b + exp(2 * c)
    detG <- exp(2 * a + 2 * c)
    # G inverse
    Gi00 <- G11 / detG
    Gi11 <- G00 / detG
    Gi01 <- -G01 / detG
    r <- y - as.numeric(X %*% beta)
    s0 <- as.numeric(rowsum(w1s * r, school))
    s1 <- as.numeric(rowsum(w1s * r * zslope, school))
    Q <- as.numeric(rowsum(w1s * r * r, school))
    P00 <- ww / sig2 + Gi00
    P01 <- wx / sig2 + Gi01
    P11 <- wxx / sig2 + Gi11
    detP <- P00 * P11 - P01 * P01
    v0 <- s0 / sig2
    v1 <- s1 / sig2
    quad <- (P11 * v0 * v0 - 2 * P01 * v0 * v1 + P00 * v1 * v1) / detP
    logI <- -0.5 * ww * log(2 * pi * sig2) - Q / (2 * sig2) -
      0.5 * log(detG) - log(2 * pi) + log(2 * pi) - 0.5 * log(detP) + 0.5 * quad
    # k=2: +0.5*k*log(2*pi) - 0.5*log det(2*pi*G) = log(2*pi) - 0.5*log detG - log(2*pi)
    # = -0.5*log detG. The log(2*pi) terms cancel. Keep the formula explicit:
    logI <- -0.5 * ww * log(2 * pi * sig2) - Q / (2 * sig2) -
      0.5 * log((2 * pi)^2 * detG) + log(2 * pi) - 0.5 * log(detP) + 0.5 * quad
    list(nll = -sum(w2c * logI), beta = beta, sig2 = sig2, G00 = G00, G01 = G01, G11 = G11)
  }
  nll <- function(theta) {
    v <- tryCatch(nll_parts(theta)$nll, error = function(e) 1e12)
    if (!is.finite(v)) 1e12 else v
  }
  st <- c(beta0, log(1), log(sqrt(0.05)), 0, log(sqrt(0.02)))
  opt <- nlminb(st, nll, control = list(iter.max = 80, eval.max = 300, rel.tol = 1e-8))
  ok <- opt$convergence == 0 && is.finite(opt$objective) && opt$objective < 1e11
  se_beta <- rep(NA_real_, p)
  if (ok && se) {
    se_beta <- tryCatch({
      H <- numDeriv::hessian(nll, opt$par)
      # Cluster scores from a simple central difference of each cluster contribution
      # are unnecessary if we difference the total nll; sandwich needs the meat.
      # Use a cluster-wise objective.
      school_id <- school
      cl_nll <- function(theta) {
        # recompute logI vector by temporarily returning it
        beta <- theta[1:p]
        sig2 <- exp(theta[p + 1])
        aa <- theta[p + 2]; bb <- theta[p + 3]; cc <- theta[p + 4]
        G00 <- exp(2 * aa); G01 <- bb * exp(aa); G11 <- bb * bb + exp(2 * cc)
        detG <- exp(2 * aa + 2 * cc)
        Gi00 <- G11 / detG; Gi11 <- G00 / detG; Gi01 <- -G01 / detG
        r <- y - as.numeric(X %*% beta)
        s0 <- as.numeric(rowsum(w1s * r, school_id))
        s1 <- as.numeric(rowsum(w1s * r * zslope, school_id))
        Q <- as.numeric(rowsum(w1s * r * r, school_id))
        P00 <- ww / sig2 + Gi00
        P01 <- wx / sig2 + Gi01
        P11 <- wxx / sig2 + Gi11
        detP <- P00 * P11 - P01 * P01
        v0 <- s0 / sig2; v1 <- s1 / sig2
        quad <- (P11 * v0 * v0 - 2 * P01 * v0 * v1 + P00 * v1 * v1) / detP
        logI <- -0.5 * ww * log(2 * pi * sig2) - Q / (2 * sig2) -
          0.5 * log((2 * pi)^2 * detG) + log(2 * pi) - 0.5 * log(detP) + 0.5 * quad
        w2c * logI
      }
      S <- numDeriv::jacobian(cl_nll, opt$par)
      V <- solve(H, t(S) %*% S) %*% solve(H)
      sqrt(pmax(diag(V)[1:p], 0))
    }, error = function(e) rep(NA_real_, p))
  }
  list(beta = opt$par[1:p], se = se_beta, converged = ok && all(is.finite(se_beta)))
}
