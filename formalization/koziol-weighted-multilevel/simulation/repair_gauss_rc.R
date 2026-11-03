# Recompute Gaussian random-coefficient checkpoints whose incorrect-covariance
# fit stopped on the old 1e-10 tolerance. The point estimate had already
# settled; the rerun uses the looser tolerance in estimators.R and fills in
# the standard errors. Files the main job has finished are safe to replace.

sim_dir <- Sys.getenv("SIM_DIR", unset = getwd())
cores <- as.integer(Sys.getenv("SIM_CORES", unset = "1"))
src <- readLines(file.path(sim_dir, "run_grid_gaussian_rc.R"))
cut <- src[seq_len(grep("cells <- expand.grid", src)[1] - 1L)]
eval(parse(text = cut))

paths <- Sys.glob(file.path(sim_dir, "results", "grid", "gauss_rc", "rcN_*.csv"))
bad <- Filter(function(path) {
  d <- tryCatch(read.csv(path, stringsAsFactors = FALSE), error = function(e) NULL)
  if (is.null(d) || !nrow(d)) return(FALSE)
  any(!d$converged %in% TRUE) || any(!is.finite(d$se00))
}, paths)
message("repair candidates ", length(bad), " ", Sys.time())

one <- function(path) {
  d <- read.csv(path, stringsAsFactors = FALSE)
  spec <- list(id = d$id[1], design = d$design[1], icc = d$icc[1], nj = d$nj[1],
               rep = d$rep[1], seed = d$seed[1])
  file.remove(path)
  fit_rep(spec)
}

invisible(parallel::mclapply(bad, one, mc.cores = cores))
message("repair finished ", Sys.time())
