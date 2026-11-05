# Gaussian random-intercept factorial.
# Prespecified before the production run:
#   designs: informative, noninformative
#   ICC: 0.05, 0.25
#   average sample cluster size: 5, 20
#   outcome: normal
#   replications: 1000 per cell
#   estimators: us.ics, um.ccs, ws.ics, wtm.ccs, wam.ccs
# This is 8 of the 208 dissertation settings. Bernoulli and random-coefficient
# settings are not in this run.
# Seeds: 1000 * cell_id + replication. RNGkind is recorded in the manifest.
# A replication is retained for every estimator even if one estimator fails;
# the summary drops a replication from all estimators when any estimator in
# that replication did not converge, and reports the count.

args <- commandArgs(trailingOnly = TRUE)
sim_dir <- Sys.getenv("SIM_DIR", unset = getwd())
out_dir <- file.path(sim_dir, "results")
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
cores <- as.integer(Sys.getenv("SIM_CORES", unset = "3"))
reps <- as.integer(Sys.getenv("SIM_REPS", unset = "1000"))
only <- Sys.getenv("SIM_CELLS", unset = "")

source(file.path(sim_dir, "parameters.R"))
source(file.path(sim_dir, "generate.R"))
source(file.path(sim_dir, "estimators.R"))

cells <- expand.grid(
  design = c("informative", "noninformative"),
  icc = c(0.05, 0.25),
  nj = c(5, 20),
  stringsAsFactors = FALSE
)
cells$cell_id <- seq_len(nrow(cells))
if (nzchar(only)) {
  keep <- as.integer(strsplit(only, ",")[[1]])
  cells <- cells[cells$cell_id %in% keep, , drop = FALSE]
}
write.csv(cells, file.path(out_dir, "cells.csv"), row.names = FALSE)

run_rep <- function(spec) {
  dat <- generate_sample(spec$icc, spec$nj, spec$design, seed = spec$seed, outcome = "normal")
  tab <- fit_one(dat)
  tab$cell_id <- spec$cell_id
  tab$rep <- spec$rep
  tab$seed <- spec$seed
  tab$design <- spec$design
  tab$icc <- spec$icc
  tab$nj <- spec$nj
  par <- attr(dat, "par")
  tab$target_g00 <- par$gamma00
  tab$target_g01 <- par$gamma01
  tab$target_g10 <- par$gamma10
  tab$N_pop <- attr(dat, "N")
  tab
}

library(parallel)
manifest <- data.frame()
for (i in seq_len(nrow(cells))) {
  cell <- cells[i, ]
  message(sprintf("cell %s design=%s icc=%s nj=%s reps=%s %s",
                  cell$cell_id, cell$design, cell$icc, cell$nj, reps, Sys.time()))
  specs <- lapply(seq_len(reps), function(r) {
    list(cell_id = cell$cell_id, design = cell$design, icc = cell$icc,
         nj = cell$nj, rep = r, seed = cell$cell_id * 1000L + r)
  })
  t0 <- proc.time()
  parts <- mclapply(specs, function(spec) {
    tryCatch(run_rep(spec), error = function(e) {
      data.frame(cell_id = spec$cell_id, rep = spec$rep, seed = spec$seed,
                 estimator = "ERROR", note = conditionMessage(e),
                 stringsAsFactors = FALSE)
    })
  }, mc.cores = cores, mc.preschedule = TRUE)
  elapsed <- (proc.time() - t0)[["elapsed"]]
  tab <- do.call(rbind, parts)
  path <- file.path(out_dir, sprintf("cell_%02d.csv", cell$cell_id))
  write.csv(tab, path, row.names = FALSE)
  message(sprintf("wrote %s rows=%s elapsed_sec=%.1f", path, nrow(tab), elapsed))
  manifest <- rbind(manifest, data.frame(
    cell_id = cell$cell_id, rows = nrow(tab), elapsed_sec = elapsed,
    path = path, stringsAsFactors = FALSE
  ))
}
rng <- RNGkind()
writeLines(c(
  paste("R", R.version.string),
  paste("RNGkind", paste(rng, collapse = " / ")),
  paste("reps", reps),
  paste("cores", cores),
  paste("survey", as.character(packageVersion("survey"))),
  paste("lme4", as.character(packageVersion("lme4"))),
  paste("WeMix", as.character(packageVersion("WeMix"))),
  paste("numDeriv", as.character(packageVersion("numDeriv"))),
  paste("Matrix", as.character(packageVersion("Matrix"))),
  paste("finished", Sys.time())
), file.path(out_dir, "RUN.txt"))
write.csv(manifest, file.path(out_dir, "manifest.csv"), row.names = FALSE)
message("done")
