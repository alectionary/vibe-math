# Fill standard errors for Gaussian random-coefficient fits whose
# incorrect-covariance optimizer stopped on the old tolerance.
# The other estimators in the file are left as they are.
sim_dir <- Sys.getenv("SIM_DIR", unset = getwd())
cores <- as.integer(Sys.getenv("SIM_CORES", unset = "1"))
src <- readLines(file.path(sim_dir, "run_grid_gaussian_rc.R"))
cut <- src[seq_len(grep("cells <- expand.grid", src)[1] - 1L)]
eval(parse(text = cut))

paths <- Sys.glob(file.path(sim_dir, "results", "grid", "gauss_rc", "rcN_*.csv"))
need <- Filter(function(path) {
  d <- tryCatch(read.csv(path, stringsAsFactors = FALSE), error = function(e) NULL)
  if (is.null(d) || !nrow(d)) return(FALSE)
  hit <- d$estimator %in% c("wtm.ics", "wam.ics") & (!d$converged %in% TRUE | !is.finite(d$se00))
  any(hit)
}, paths)
message("ics repair ", length(need), " ", Sys.time())

one <- function(path) {
  d <- read.csv(path, stringsAsFactors = FALSE)
  dat <- generate_rc(d$icc[1], d$nj[1], d$design[1], d$seed[1])
  dat$w1s <- scale_method2(dat$w_cond, dat$school)
  dat$w1a <- scale_method2(dat$w_cond_approx, dat$school)
  X <- cbind(1, dat$xgmc, dat$wj, dat$xw)
  fix_row <- function(est, fit) {
    i <- which(d$estimator == est)
    if (!length(i) || !isTRUE(fit$converged)) return()
    d$g00[i] <<- fit$beta[1]
    d$g10[i] <<- fit$beta[2]
    d$g01[i] <<- fit$beta[3]
    d$g11[i] <<- fit$beta[4]
    d$se00[i] <<- fit$se[1]
    d$se10[i] <<- fit$se[2]
    d$se01[i] <<- fit$se[3]
    d$se11[i] <<- fit$se[4]
    d$converged[i] <<- TRUE
  }
  if (any(d$estimator == "wtm.ics" & (!d$converged %in% TRUE | !is.finite(d$se00)))) {
    fix_row("wtm.ics", ri_mpml_fit(dat$y, X, dat$school, dat$w1s, dat$w_j))
  }
  if (any(d$estimator == "wam.ics" & (!d$converged %in% TRUE | !is.finite(d$se00)))) {
    fix_row("wam.ics", ri_mpml_fit(dat$y, X, dat$school, dat$w1a, rep(dat$wj_approx[1], nrow(dat))))
  }
  tmp <- paste0(path, ".tmp")
  write.csv(d, tmp, row.names = FALSE)
  file.rename(tmp, path)
  path
}

invisible(parallel::mclapply(need, one, mc.cores = cores))
message("ics repair done ", Sys.time())
