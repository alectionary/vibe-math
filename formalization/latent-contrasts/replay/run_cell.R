# Replay one Jeffries (2024) cell through the source's own path:
# simsem::exportData (seed 13131) to .dat files, read back in list.files order,
# lavaan MLR fits. Per-replicate results are written to <out>/<cell>.csv.gz.
# Usage: Rscript run_cell.R MODEL POP N COND OUT WORK NCORES
suppressMessages({library(simsem); library(lavaan); library(parallel)})
a <- commandArgs(TRUE)
model <- a[1]; pop <- a[2]; N <- as.integer(a[3]); cond <- as.integer(a[4])
out <- a[5]; work <- a[6]; ncores <- as.integer(a[7])
props <- list(c(.25,.25,.25,.25), c(.35,.35,.15,.15), c(.45,.45,.05,.05))[[cond]]
n <- as.list(as.integer(round(N * props)))
means <- if (pop == "true") "c(1, .6, .8, .4)" else "c(1, 1, 1, 1)"
popm <- paste0("eta =~ NA*i1 + 0.7*i1 + 0.7*i2 + 0.7*i3 + 0.7*i4
eta ~~ .5*eta
i1 ~~ 0.51*i1
i1 ~ 1*1
i2 ~~ 0.51*i2
i2 ~ 1*1
i3 ~~ 0.51*i3
i3 ~ 1*1
i4 ~~ 0.51*i4
i4 ~ 1*1
eta ~ ", means, "*1")
cell <- sprintf("%s_%s_n%d_c%d", model, pop, N, cond)
dir <- file.path(work, cell); dir.create(dir, recursive = TRUE, showWarnings = FALSE)
stem <- file.path(dir, sprintf("sim_data_n%d", N))
set.seed(1313)
exportData(nRep = 15000, model = popm, n = n, program = "Mplus",
           fileStem = stem, seed = 13131, pmMCAR = 0)
paths <- list.files(dir, pattern = ".dat", recursive = TRUE, full.names = TRUE)[-1]
stopifnot(length(paths) == 15000)
mg <- "eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ c(a, b, c, d)*1
i1 + i2 + i3 + i4 ~ c(eq, eq, eq, eq)*1
c1 := -1*((a + c) / 2) + ((b + d) / 2)
c2 := -1*((a + b) / 2) + ((c + d) / 2)
c3 := -1*((b + c) / 2) + ((a + d) / 2)"
mi <- "eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ c1 + c2 + c3
i1 + i2 + i3 + i4 ~ eq*1"
one <- function(i) {
  d <- read.table(paths[i], header = FALSE, sep = " ",
                  colClasses = rep("numeric", 5),
                  col.names = c("i1","i2","i3","i4","subgroup"))
  r <- tryCatch({
    if (model == "mgcfa") {
      fit <- sem(mg, data = d, missing = "ML", estimator = "MLR",
                 group = "subgroup", meanstructure = TRUE)
      pe <- parameterEstimates(fit, ci = FALSE)
      p <- pe[pe$op == ":=", ]
    } else {
      d$c1 <- factor(ifelse(d$subgroup %in% c(1,3), -1, 1), levels = c(-1,1), labels = c("g1","g2"))
      d$c2 <- factor(ifelse(d$subgroup %in% c(1,2), -1, 1), levels = c(-1,1), labels = c("g1","g2"))
      d$c3 <- factor(ifelse(d$subgroup %in% c(1,4), -1, 1), levels = c(-1,1), labels = c("g1","g2"))
      fit <- sem(mi, data = d, missing = "ML", estimator = "MLR")
      pe <- parameterEstimates(fit, ci = FALSE)
      p <- pe[pe$op == "~" & pe$lhs == "eta", ]
    }
    fm <- fitMeasures(fit)
    c(conv = as.numeric(lavInspect(fit, "converged")),
      est = p$est, se = p$se, z = p$z, p = p$pvalue,
      cfi = unname(fm["cfi"]), rmsea = unname(fm["rmsea"]), srmr = unname(fm["srmr"]),
      cfi_r = unname(fm["cfi.robust"]), rmsea_r = unname(fm["rmsea.robust"]))
  }, error = function(e) c(conv = 0, rep(NA_real_, 17)))
  c(rep = i, r)
}
idx <- split(seq_along(paths), ceiling(seq_along(paths) / 1000))
done <- 0L; res <- list()
for (b in idx) {
  res <- c(res, mclapply(b, one, mc.cores = ncores, mc.preschedule = TRUE))
  done <- sum(vapply(res, function(x) isTRUE(x[["conv"]] == 1), TRUE))
  if (done >= 10000) break
}
m <- do.call(rbind, res)
colnames(m) <- c("rep","conv", paste0("c",1:3,"_est"), paste0("c",1:3,"_se"),
                 paste0("c",1:3,"_z"), paste0("c",1:3,"_p"),
                 "cfi","rmsea","srmr","cfi_robust","rmsea_robust")
dir.create(out, recursive = TRUE, showWarnings = FALSE)
gz <- gzfile(file.path(out, paste0(cell, ".csv.gz")), "w")
write.csv(m, gz, row.names = FALSE); close(gz)
unlink(dir, recursive = TRUE)
cat(cell, "fitted", nrow(m), "converged", sum(m[, "conv"] == 1, na.rm = TRUE), "\n")
