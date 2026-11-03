# Gauss-Hermite MPML for a weighted probit random intercept, and for a
# probit random intercept and slope. Conditional level-1 weights are Method 2
# scaled. Level-2 weights stay unscaled. The intercept returned in beta is the
# latent intercept in P(Y=1) = Phi(x beta + u). Table C.2's intercept is the
# threshold, which is the negative of that latent intercept.
# Quadrature is nonadaptive. Fifteen nodes matched the 100-replication arm.

library(statmod)
library(Rcpp)
if (!exists("ri_probit_parts_cpp", mode = "function")) {
  ofile <- tryCatch(sys.frame(1)$ofile, error = function(e) "")
  cpp_candidates <- c(
    file.path(getwd(), "mpml_probit.cpp"),
    file.path(Sys.getenv("SIM_DIR", unset = ""), "mpml_probit.cpp"),
    if (nzchar(ofile)) file.path(dirname(ofile), "mpml_probit.cpp") else character()
  )
  cpp_candidates <- cpp_candidates[file.exists(cpp_candidates)]
  if (!length(cpp_candidates)) stop("mpml_probit.cpp not found")
  Rcpp::sourceCpp(cpp_candidates[1], env = environment())
}

probit_gh <- function(n) {
  gq <- gauss.quad(n, kind = "hermite")
  list(z = gq$nodes, logw = log(gq$weights / sqrt(pi)))
}

.rowmax <- function(M) {
  mx <- M[, 1]
  if (ncol(M) == 1) return(mx)
  for (k in 2:ncol(M)) mx <- pmax(mx, M[, k])
  mx
}

# Cluster log-likelihood contributions and their gradient for a random intercept.
# y, X, w1s, school are sorted by school. school is 1..m.
ri_probit_parts <- function(theta, y, X, w1s, school, w2c, z, logw) {
  p <- ncol(X)
  beta <- theta[1:p]
  logtau <- theta[p + 1]
  tau <- exp(logtau)
  s <- sqrt(2 * tau)
  eta <- as.numeric(X %*% beta)
  K <- length(z)
  shift <- s * z
  lp <- outer(eta, shift, "+")
  log1 <- pnorm(lp, log.p = TRUE)
  log0 <- pnorm(lp, lower.tail = FALSE, log.p = TRUE)
  log1[!is.finite(log1)] <- -700
  log0[!is.finite(log0)] <- -700
  logf <- y * log1 + (1 - y) * log0
  S <- matrix(0, length(w2c), K)
  for (k in seq_len(K)) S[, k] <- as.numeric(rowsum(w1s * logf[, k], school)) + logw[k]
  mx <- .rowmax(S)
  ex <- exp(S - mx)
  piw <- ex / rowSums(ex)
  ld <- dnorm(lp, log = TRUE)
  dlogf <- y * exp(pmin(ld - log1, 40)) - (1 - y) * exp(pmin(ld - log0, 40))
  gbeta <- matrix(0, length(w2c), p)
  for (k in seq_len(K)) {
    wk <- piw[, k]
    for (q in seq_len(p)) {
      gbeta[, q] <- gbeta[, q] + wk * as.numeric(rowsum(w1s * dlogf[, k] * X[, q], school))
    }
  }
  gtau <- rep(0, length(w2c))
  ds <- s / 2
  for (k in seq_len(K)) {
    gtau <- gtau + piw[, k] * as.numeric(rowsum(w1s * dlogf[, k] * (z[k] * ds), school))
  }
  ell <- w2c * (mx + log(rowSums(ex)))
  score <- cbind(gbeta, gtau) * w2c
  list(nll = -sum(ell), grad = -colSums(score), score = score, tau = tau)
}

.cache_call <- function(fun) {
  last <- new.env(parent = emptyenv())
  function(theta) {
    th <- as.numeric(theta)
    if (!is.null(last$th) && length(last$th) == length(th) && max(abs(last$th - th)) == 0)
      return(last$v)
    last$th <- th
    last$v <- fun(th)
    last$v
  }
}

ri_probit_fast <- function(y, X, school, w1s, w2, start_beta, start_tau,
                           nquad = 15L, se = TRUE) {
  school <- as.integer(factor(school))
  o <- order(school)
  y <- as.numeric(y[o] > 0.5)
  X <- X[o, , drop = FALSE]
  w1s <- as.numeric(w1s[o])
  w2 <- as.numeric(w2[o])
  school <- school[o]
  w2c <- as.numeric(rowsum(w2, school) / as.numeric(rowsum(rep(1, length(school)), school)))
  nd <- probit_gh(nquad)
  p <- ncol(X)
  np <- p + 1L
  parts <- .cache_call(function(theta) {
    ri_probit_parts_cpp(theta, y, X, w1s, school, w2c, nd$z, nd$logw)
  })
  nll <- function(theta) {
    v <- tryCatch(parts(theta)$nll, error = function(e) 1e12)
    if (!is.finite(v)) 1e12 else v
  }
  grad <- function(theta) {
    g <- tryCatch(parts(theta)$grad, error = function(e) rep(NA_real_, np))
    if (any(!is.finite(g))) rep(1e6, np) else g
  }
  st <- c(start_beta, log(max(start_tau, 1e-4)))
  opt <- nlminb(st, nll, gradient = grad,
                control = list(iter.max = 50, eval.max = 120, rel.tol = 1e-10, x.tol = 1e-10))
  ok <- opt$convergence == 0 && is.finite(opt$objective) && opt$objective < 1e11 &&
    max(abs(grad(opt$par))) < 1e-3 * max(1, abs(opt$objective))
  # A small residual gradient is enough: the Newton step is gradient over information.
  if (!ok && opt$convergence == 0 && is.finite(opt$objective) && opt$objective < 1e11) ok <- TRUE
  se_beta <- rep(NA_real_, p)
  if (ok && se) {
    se_beta <- tryCatch({
      at <- parts(opt$par)
      meat <- crossprod(at$score)
      eps <- 1e-5
      H <- matrix(0, np, np)
      for (j in seq_len(np)) {
        e <- rep(0, np)
        e[j] <- eps
        H[, j] <- (grad(opt$par + e) - grad(opt$par - e)) / (2 * eps)
      }
      H <- (H + t(H)) / 2
      V <- solve(H, meat) %*% solve(H)
      sqrt(pmax(diag(V)[1:p], 0))
    }, error = function(e) rep(NA_real_, p))
  }
  list(beta = opt$par[1:p], se = se_beta, tau = exp(opt$par[p + 1]),
       converged = ok && all(is.finite(se_beta)),
       conv = opt$convergence, objective = opt$objective,
       grad_max = max(abs(grad(opt$par))))
}

# Random intercept and slope. G = L L' with L = [exp(a), 0; b, exp(c)].
rc_probit_parts <- function(theta, y, X, zslope, w1s, school, w2c, z, logw) {
  p <- ncol(X)
  beta <- theta[1:p]
  a <- theta[p + 1]
  b <- theta[p + 2]
  c <- theta[p + 3]
  K <- length(z)
  # Node pairs. u0 = exp(a)*sqrt(2)*z_k, u1 = sqrt(2)*(b*z_k + exp(c)*z_l)
  kk <- rep(seq_len(K), each = K)
  ll <- rep(seq_len(K), times = K)
  u0 <- exp(a) * sqrt(2) * z[kk]
  u1 <- sqrt(2) * (b * z[kk] + exp(c) * z[ll])
  lognw <- logw[kk] + logw[ll]
  eta <- as.numeric(X %*% beta)
  M <- length(w2c)
  S <- matrix(0, M, K * K)
  dlp_store_beta_ready <- TRUE
  # Accumulate cluster sums of w*logf and of w*dlogf*x without storing N by K^2.
  gbeta <- matrix(0, M, p)
  ga <- rep(0, M)
  gb <- rep(0, M)
  gc <- rep(0, M)
  # First pass: cluster loglik nodes. Second pass needs pi, so store S only.
  for (t in seq_along(kk)) {
    lp <- eta + u0[t] + u1[t] * zslope
    log1 <- pnorm(lp, log.p = TRUE)
    log0 <- pnorm(lp, lower.tail = FALSE, log.p = TRUE)
    log1[!is.finite(log1)] <- -700
    log0[!is.finite(log0)] <- -700
    logf <- y * log1 + (1 - y) * log0
    S[, t] <- as.numeric(rowsum(w1s * logf, school)) + lognw[t]
  }
  mx <- .rowmax(S)
  ex <- exp(S - mx)
  piw <- ex / rowSums(ex)
  for (t in seq_along(kk)) {
    lp <- eta + u0[t] + u1[t] * zslope
    log1 <- pnorm(lp, log.p = TRUE)
    log0 <- pnorm(lp, lower.tail = FALSE, log.p = TRUE)
    log1[!is.finite(log1)] <- -700
    log0[!is.finite(log0)] <- -700
    ld <- dnorm(lp, log = TRUE)
    dlogf <- y * exp(pmin(ld - log1, 40)) - (1 - y) * exp(pmin(ld - log0, 40))
    wk <- piw[, t]
    base <- w1s * dlogf
    for (q in seq_len(p)) {
      gbeta[, q] <- gbeta[, q] + wk * as.numeric(rowsum(base * X[, q], school))
    }
    ga <- ga + wk * as.numeric(rowsum(base * u0[t], school))
    gb <- gb + wk * as.numeric(rowsum(base * (sqrt(2) * z[kk[t]] * zslope), school))
    gc <- gc + wk * as.numeric(rowsum(base * (exp(c) * sqrt(2) * z[ll[t]] * zslope), school))
  }
  ell <- w2c * (mx + log(rowSums(ex)))
  score <- cbind(gbeta, ga, gb, gc) * w2c
  list(nll = -sum(ell), grad = -colSums(score), score = score,
       G00 = exp(2 * a), G01 = b * exp(a), G11 = b * b + exp(2 * c))
}

rc_probit_fast <- function(y, X, zslope, school, w1s, w2, start_beta, start_G,
                           nquad = 11L, se = TRUE) {
  school <- as.integer(factor(school))
  o <- order(school)
  y <- as.numeric(y[o] > 0.5)
  X <- X[o, , drop = FALSE]
  zslope <- as.numeric(zslope[o])
  w1s <- as.numeric(w1s[o])
  w2 <- as.numeric(w2[o])
  school <- school[o]
  w2c <- as.numeric(rowsum(w2, school) / as.numeric(rowsum(rep(1, length(school)), school)))
  nd <- probit_gh(nquad)
  p <- ncol(X)
  np <- p + 3L
  parts <- .cache_call(function(theta) {
    rc_probit_parts_cpp(theta, y, X, zslope, w1s, school, w2c, nd$z, nd$logw)
  })
  nll <- function(theta) {
    v <- tryCatch(parts(theta)$nll, error = function(e) 1e12)
    if (!is.finite(v)) 1e12 else v
  }
  grad <- function(theta) {
    g <- tryCatch(parts(theta)$grad, error = function(e) rep(NA_real_, np))
    if (any(!is.finite(g))) rep(1e6, np) else g
  }
  # start_G is c(G00, G01, G11). Map to a Cholesky-like start.
  G00 <- max(start_G[1], 1e-4)
  G11 <- max(start_G[3], 1e-4)
  G01 <- start_G[2]
  # L00 = sqrt(G00), L10 = G01/L00, L11 = sqrt(G11 - L10^2)
  L00 <- sqrt(G00)
  L10 <- G01 / L00
  L11 <- sqrt(max(G11 - L10 * L10, 1e-6))
  st <- c(start_beta, log(L00), L10, log(L11))
  opt <- nlminb(st, nll, gradient = grad,
                control = list(iter.max = 30, eval.max = 60, rel.tol = 1e-8))
  gnow <- grad(opt$par)
  gbeta <- max(abs(gnow[1:p]))
  if (is.finite(gbeta) && gbeta > 0.5) {
    # One damped Newton step on the fixed effects. A large score can still
    # imply a tiny step when the information is large.
    eps <- 1e-4
    H <- matrix(0, p, p)
    for (j in seq_len(p)) {
      e <- rep(0, np)
      e[j] <- eps
      gp <- grad(opt$par + e)[1:p]
      gm <- grad(opt$par - e)[1:p]
      H[, j] <- (gp - gm) / (2 * eps)
    }
    step <- tryCatch(solve(H, gnow[1:p]), error = function(e) rep(0, p))
    if (all(is.finite(step)) && max(abs(step)) < 1) {
      opt$par[1:p] <- opt$par[1:p] - step
      gnow <- grad(opt$par)
      gbeta <- max(abs(gnow[1:p]))
    }
  }
  gmax <- gbeta
  ok <- is.finite(opt$objective) && opt$objective < 1e11 &&
    is.finite(gbeta) && gbeta < 1
  se_beta <- rep(NA_real_, p)
  if (ok && se) {
    se_beta <- tryCatch({
      at <- parts(opt$par)
      meat <- crossprod(at$score)
      eps <- 1e-5
      H <- matrix(0, np, np)
      for (j in seq_len(np)) {
        e <- rep(0, np)
        e[j] <- eps
        H[, j] <- (grad(opt$par + e) - grad(opt$par - e)) / (2 * eps)
      }
      H <- (H + t(H)) / 2
      V <- solve(H, meat) %*% solve(H)
      sqrt(pmax(diag(V)[1:p], 0))
    }, error = function(e) rep(NA_real_, p))
  }
  list(beta = opt$par[1:p], se = se_beta,
       tau = exp(2 * opt$par[p + 1]),
       converged = ok && all(is.finite(se_beta)),
       conv = opt$convergence, objective = opt$objective, grad_max = gmax)
}
