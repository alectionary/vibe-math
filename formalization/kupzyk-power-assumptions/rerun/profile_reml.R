# Load from the repository root. Compile once before forking.
study <- 'formalization/kupzyk-power-assumptions'
source(file.path(study, 'scripts/model.R'))
Rcpp::sourceCpp(file.path(study, 'rerun/profile_reml.cpp'))
fit_profile <- function(d, z, icc) {
  y <- if (is.numeric(z)) z else z$y
  s <- reml_statistics(as.integer(d$k), as.integer(d$cluster), y, max(d$cluster))
  control <- max(d$cluster[d$group == 0])
  obj <- function(p) reml_eval(p, s, control)[[1L]]
  start <- c(.4, 2*(1-icc), .2, 2*icc)
  opts <- list(eval.max=250L, iter.max=150L, rel.tol=1e-10)
  f <- nlminb(start, obj, lower=rep(0,4), control=opts)
  retried <- f$convergence != 0
  if (retried) {
    g <- optim(f$par,obj,method='L-BFGS-B',lower=rep(0,4),control=list(factr=1000))
    if (g$convergence==0 && g$value <= f$objective + 1e-6) {
      f$par <- g$par
      f$convergence <- 0L
    }
  }
  c(reml_eval(f$par,s,control,TRUE), converged=as.integer(f$convergence==0),
    boundary=as.integer(any(f$par < 1e-8)), retried=as.integer(retried))
}
