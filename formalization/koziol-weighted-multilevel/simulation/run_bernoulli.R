# Bernoulli random-intercept arm.
# Koziol Table C.2 reports a negative intercept bias under informative sampling
# (us.ics -0.693, wtm.ccs -0.170 at rho=.05, nj=5) even though selection favors
# large positive random intercepts and residuals, which raises P(Y=1).
# The fit used here is P(Y=1) = Phi(gamma + x beta + u). The latent intercept
# is then positive. The Mplus binary threshold [y$1] in the parameterization
# P(Y=1) = Phi(-tau + x beta + u) is tau = -gamma. Both are saved.
# Replication count is SIM_REPS (default 100), not 1,000.

args <- commandArgs(trailingOnly = TRUE)
sim_dir <- Sys.getenv("SIM_DIR", unset = getwd())
source(file.path(sim_dir, "parameters.R"))
source(file.path(sim_dir, "generate.R"))
source(file.path(sim_dir, "fit_probit.R"))
library(survey)
library(lme4)
library(glmmTMB)
library(parallel)

reps <- as.integer(Sys.getenv("SIM_REPS", unset = "100"))
cores <- as.integer(Sys.getenv("SIM_CORES", unset = "2"))
out_dir <- file.path(sim_dir, "results")

probit_mpml_started <- function(y, X, school, w1s, w2, start_beta, start_tau, nquad = 15L) {
  school <- as.integer(factor(school))
  o <- order(school)
  y <- as.numeric(y[o]); X <- X[o, , drop = FALSE]
  w1s <- as.numeric(w1s[o]); w2 <- as.numeric(w2[o]); school <- school[o]
  w2c <- as.numeric(rowsum(w2, school) / as.numeric(rowsum(rep(1, length(school)), school)))
  nd <- probit_nodes(nquad)
  p <- ncol(X)
  cluster_ll <- function(theta) {
    beta <- theta[1:p]
    tau <- exp(theta[p + 1])
    eta <- as.numeric(X %*% beta)
    logs <- vector("list", length(nd$z))
    for (k in seq_along(nd$z)) {
      pr <- pmin(pmax(pnorm(eta + sqrt(2 * tau) * nd$z[k]), 1e-12), 1 - 1e-12)
      logf <- ifelse(y > 0.5, log(pr), log(1 - pr))
      logs[[k]] <- as.numeric(rowsum(w1s * logf, school)) + log(nd$w[k])
    }
    M <- do.call(cbind, logs)
    mx <- do.call(pmax, as.data.frame(M))
    w2c * (mx + log(rowSums(exp(M - mx))))
  }
  nll <- function(theta) {
    v <- tryCatch(-sum(cluster_ll(theta)), error = function(e) 1e12)
    if (!is.finite(v)) 1e12 else v
  }
  st <- c(start_beta, log(max(start_tau, 1e-4)))
  opt <- nlminb(st, nll, control = list(iter.max = 60, eval.max = 150, rel.tol = 1e-7))
  bfgs <- NULL
  if (get0("do_bfgs", inherits = TRUE) %||% FALSE) {
    bfgs <- optim(st, nll, method = "BFGS", control = list(maxit = 60, reltol = 1e-7))
  }
  list(beta = opt$par[1:p], tau = exp(opt$par[p + 1]),
       converged = opt$convergence == 0 && is.finite(opt$objective) && opt$objective < 1e11,
       conv = opt$convergence,
       bfgs = if (is.null(bfgs)) NA_real_ else bfgs$par[1])
}

`%||%` <- function(a, b) if (is.null(a)) b else a

one_rep <- function(spec) {
  dat <- generate_sample(spec$icc, spec$nj, "informative", seed = spec$seed, outcome = "bernoulli")
  dat$w1s <- scale_method2(dat$w_cond, dat$school)
  dat$w1a <- scale_method2(dat$w_cond_approx, dat$school)
  dat$wobs <- dat$w1s * dat$w_j
  X <- cbind(1, dat$xgmc, dat$wj)
  gu <- tryCatch(glmer(y ~ xgmc + wj + (1 | school), data = dat,
                       family = binomial(link = "probit"),
                       control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 2e4))),
                 error = function(e) e)
  if (inherits(gu, "error")) {
    return(data.frame(spec, estimator = "ERROR", note = conditionMessage(gu)))
  }
  b_u <- unname(fixef(gu))
  tau_u <- max(as.numeric(VarCorr(gu)$school[1, 1]), 1e-4)
  d1 <- svydesign(ids = ~school, weights = ~w_uncond, data = dat)
  fs <- tryCatch(svyglm(y ~ xgmc + wj, design = d1, family = quasibinomial(link = "probit")),
                 error = function(e) e)
  b_s <- if (inherits(fs, "error")) rep(NA_real_, 3) else unname(coef(fs))
  do_bfgs <<- (spec$rep %% 10L == 1L)
  ft <- probit_mpml_started(dat$y, X, dat$school, dat$w1s, dat$w_j, b_u, tau_u, nquad = 15L)
  fa <- probit_mpml_started(dat$y, X, dat$school, dat$w1a, rep(dat$wj_approx[1], nrow(dat)),
                            b_u, tau_u, nquad = 15L)
  gt <- tryCatch(glmmTMB(y ~ xgmc + wj + (1 | school), data = dat,
                         family = binomial(link = "probit"), weights = wobs),
                 error = function(e) e)
  b_g <- if (inherits(gt, "error")) rep(NA_real_, 3) else unname(fixef(gt)$cond)
  row <- function(est, latent, conv, extra = NA_real_) {
    data.frame(cell = spec$cell, icc = spec$icc, nj = spec$nj, rep = spec$rep, seed = spec$seed,
               estimator = est, latent = latent, threshold = -latent,
               converged = conv, bfgs_latent = extra, stringsAsFactors = FALSE)
  }
  rbind(
    row("um.ccs", b_u[1], TRUE),
    row("ws.ics", b_s[1], !inherits(fs, "error")),
    row("wtm.ccs", ft$beta[1], ft$converged, ft$bfgs),
    row("wam.ccs", fa$beta[1], fa$converged),
    row("glmmTMB_obsweight", b_g[1], !inherits(gt, "error"))
  )
}

cells <- list(
  list(cell = "bern_inf_05_5", icc = 0.05, nj = 5),
  list(cell = "bern_inf_05_20", icc = 0.05, nj = 20)
)
for (cell in cells) {
  message(cell$cell, " ", Sys.time())
  specs <- lapply(seq_len(reps), function(r) {
    c(cell, list(rep = r, seed = 900000L + match(cell$cell, vapply(cells, `[[`, "", "cell")) * 1000L + r))
  })
  parts <- mclapply(specs, one_rep, mc.cores = cores)
  tab <- do.call(rbind, parts)
  path <- file.path(out_dir, paste0(cell$cell, ".csv"))
  write.csv(tab, path, row.names = FALSE)
  message("wrote ", path, " rows ", nrow(tab))
}
message("bernoulli done")
