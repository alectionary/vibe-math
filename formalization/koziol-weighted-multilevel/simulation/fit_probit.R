# Random-intercept probit MPML with Gauss-Hermite quadrature.
# The conditional Bernoulli density is raised to the Method-2 scaled weight and
# the cluster contribution is then raised to the unscaled level-2 weight, the
# same pseudo-likelihood used for the Gaussian fits. Residual variance is fixed
# at 1, matching the latent-response generation in Appendix A.

library(statmod)

probit_nodes <- function(n = 31L) {
  gq <- gauss.quad(n, kind = "hermite")
  list(z = gq$nodes, w = gq$weights / sqrt(pi))
}

ri_probit_mpml <- function(y, X, school, w1s, w2, nquad = 31L) {
  school <- as.integer(factor(school))
  o <- order(school)
  y <- as.numeric(y[o])
  X <- X[o, , drop = FALSE]
  w1s <- as.numeric(w1s[o])
  w2 <- as.numeric(w2[o])
  school <- school[o]
  w2c <- as.numeric(rowsum(w2, school) / as.numeric(rowsum(rep(1, length(school)), school)))
  nd <- probit_nodes(nquad)
  p <- ncol(X)
  # unweighted probit start
  beta0 <- tryCatch(coef(glm(y ~ X - 1, family = binomial(link = "probit"))),
                    error = function(e) rep(0, p))
  if (length(beta0) != p || any(!is.finite(beta0))) beta0 <- rep(0, p)
  cluster_ll <- function(theta) {
    beta <- theta[1:p]
    tau <- exp(theta[p + 1])
    eta <- as.numeric(X %*% beta)
    acc <- rep(0, max(school))
    # log-sum-exp over quadrature nodes of exp(sum w log f) * node weight
    logs <- vector("list", length(nd$z))
    for (k in seq_along(nd$z)) {
      u <- sqrt(2 * tau) * nd$z[k]
      lp <- eta + u
      # clip the probit probability away from 0 and 1
      pr <- pnorm(lp)
      pr <- pmin(pmax(pr, 1e-12), 1 - 1e-12)
      logf <- ifelse(y > 0.5, log(pr), log(1 - pr))
      logs[[k]] <- as.numeric(rowsum(w1s * logf, school)) + log(nd$w[k])
    }
    M <- do.call(cbind, logs)
    mx <- apply(M, 1, max)
    logI <- mx + log(rowSums(exp(M - mx)))
    w2c * logI
  }
  nll <- function(theta) {
    val <- tryCatch(-sum(cluster_ll(theta)), error = function(e) 1e12)
    if (!is.finite(val)) 1e12 else val
  }
  opt <- nlminb(c(beta0, log(0.05)), nll,
                control = list(iter.max = 40, eval.max = 120, rel.tol = 1e-8))
  ok <- is.finite(opt$objective) && opt$objective < 1e11 && opt$convergence == 0
  se <- rep(NA_real_, p)
  if (ok) {
    se <- tryCatch({
      S <- numDeriv::jacobian(cluster_ll, opt$par, method = "simple", method.args = list(eps = 1e-4))
      H <- numDeriv::hessian(nll, opt$par, method = "simple", method.args = list(eps = 1e-4))
      V <- solve(H, t(S) %*% S) %*% solve(H)
      sqrt(pmax(diag(V)[1:p], 0))
    }, error = function(e) rep(NA_real_, p))
  }
  list(beta = opt$par[1:p], se = se, tau = exp(opt$par[p + 1]),
       converged = ok, objective = opt$objective, conv = opt$convergence)
}
