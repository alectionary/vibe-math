# All eight Bernoulli random-intercept cells, 1,000 replications.
# P(Y=1) = Phi(latent intercept + slopes + u). Table C.2's intercept is the
# threshold tau = -latent intercept. Slopes are unchanged by that sign flip.
# Each replication is its own file.

sim_dir <- Sys.getenv("SIM_DIR", unset = getwd())
reps <- as.integer(Sys.getenv("SIM_REPS", unset = "1000"))
cores <- as.integer(Sys.getenv("SIM_CORES", unset = "2"))
source(file.path(sim_dir, "parameters.R"))
source(file.path(sim_dir, "generate.R"))
source(file.path(sim_dir, "mpml_probit.R"))
library(survey)
library(lme4)
library(parallel)

fit_rep <- function(spec) {
  dir <- file.path(sim_dir, "results", "grid", "bern_ri")
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  path <- file.path(dir, sprintf("%s_r%04d.csv", spec$id, spec$rep))
  # Schema includes tau and finite standard errors. Older partial files are redone.
  if (file.exists(path) && file.info(path)$size > 80) {
    old <- tryCatch(read.csv(path, nrows = 2), error = function(e) NULL)
    if (!is.null(old) && "tau" %in% names(old) && "se00" %in% names(old)) return(path)
  }
  dat <- generate_sample(spec$icc, spec$nj, spec$design, spec$seed, outcome = "bernoulli")
  par <- attr(dat, "par")
  pa <- ri_pa_parameters(par)
  dat$w1s <- scale_method2(dat$w_cond, dat$school)
  dat$w1a <- scale_method2(dat$w_cond_approx, dat$school)
  X <- cbind(1, dat$xgmc, dat$wj)
  gu <- tryCatch(glmer(y ~ xgmc + wj + (1 | school), data = dat, family = binomial(link = "probit"),
                       control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 1e4))),
                 error = function(e) e)
  if (inherits(gu, "error")) return(path)
  b0 <- unname(fixef(gu))
  seu <- tryCatch(sqrt(diag(vcov(gu))), error = function(e) rep(NA_real_, 3))
  tau0 <- max(as.numeric(VarCorr(gu)$school[1, 1]), 1e-3)
  dat$w_one <- 1
  d1 <- tryCatch(svyglm(y ~ xgmc + wj, design = svydesign(ids = ~school, weights = ~w_uncond, data = dat),
                        family = quasibinomial(link = "probit")), error = function(e) e)
  d0 <- tryCatch(svyglm(y ~ xgmc + wj, design = svydesign(ids = ~school, weights = ~w_one, data = dat),
                        family = quasibinomial(link = "probit")), error = function(e) e)
  ft <- ri_probit_fast(dat$y, X, dat$school, dat$w1s, dat$w_j, b0, tau0, nquad = 15L)
  fa <- ri_probit_fast(dat$y, X, dat$school, dat$w1a, rep(dat$wj_approx[1], nrow(dat)), b0, tau0, nquad = 15L)
  # RMSE on the latent linear predictor. Threshold form uses the same predictor.
  eta <- par$gamma10 * dat$xgmc + par$gamma01 * dat$wj
  rmse_of <- function(latent) {
    if (!all(is.finite(latent))) return(NA_real_)
    sqrt(mean((latent[1] + latent[2] * dat$xgmc + latent[3] * dat$wj - eta)^2))
  }
  row <- function(est, latent, se, ok, tau = NA_real_) {
    data.frame(
      id = spec$id, rep = spec$rep, seed = spec$seed, model = "RI", outcome = "bernoulli",
      design = spec$design, icc = spec$icc, nj = spec$nj, estimator = est,
      g00 = -latent[1], g10 = latent[2], g01 = latent[3], g11 = NA_real_,
      se00 = se[1], se10 = se[2], se01 = se[3], se11 = NA_real_,
      tau = if (length(tau) == 1) tau else NA_real_,
      rmse = rmse_of(latent), converged = isTRUE(ok),
      t00 = 0, t10 = par$gamma10, t01 = par$gamma01, t11 = NA_real_,
      pa00 = 0, pa10 = pa$gamma10, pa01 = pa$gamma01,
      stringsAsFactors = FALSE)
  }
  rows <- list(
    row("um.ccs", b0, seu, all(is.finite(seu)), tau0)
  )
  if (!inherits(d0, "error")) rows[[length(rows)+1]] <- row("us.ics", unname(coef(d0)), unname(SE(d0)), TRUE)
  if (!inherits(d1, "error")) rows[[length(rows)+1]] <- row("ws.ics", unname(coef(d1)), unname(SE(d1)), TRUE)
  rows[[length(rows)+1]] <- row("wtm.ccs", ft$beta, ft$se, ft$converged, ft$tau)
  rows[[length(rows)+1]] <- row("wam.ccs", fa$beta, fa$se, fa$converged, fa$tau)
  write.csv(do.call(rbind, rows), path, row.names = FALSE)
  if (spec$rep %% 25L == 0L) message(spec$id, " rep ", spec$rep, " ", Sys.time())
  path
}

cells <- expand.grid(design = c("informative", "noninformative"),
                     icc = c(0.05, 0.25), nj = c(5, 20), stringsAsFactors = FALSE)
cells$id <- sprintf("riB_%s_%02d_%02d", substr(cells$design, 1, 3), cells$icc * 100, cells$nj)
tasks <- list()
for (i in seq_len(nrow(cells))) {
  for (r in seq_len(reps)) {
    tasks[[length(tasks) + 1]] <- list(
      id = cells$id[i], design = cells$design[i], icc = cells$icc[i], nj = cells$nj[i],
      rep = r, seed = 910000L + i * 1000L + r)
  }
}
message("bernoulli RI tasks ", length(tasks), " ", Sys.time())
# preschedule keeps one process per core. Round-robin across the task list
# balances the two cluster sizes without forking once per replication.
invisible(mclapply(tasks, fit_rep, mc.cores = cores, mc.preschedule = TRUE))
message("bernoulli RI finished ", Sys.time())
