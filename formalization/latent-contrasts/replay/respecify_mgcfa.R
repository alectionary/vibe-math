# Chapter IV respecification, printed as Tables 5.1 and 5.2.
# On the Condition 3, N=240 datasets (true or null), fit the three successive
# equality constraints the dissertation adds to the original MGCFA:
#   equal factor variances;
#   equal factor variances and loadings;
#   equal factor variances, loadings and residual variances.
# Intercepts stay equal, as in the original model. Latent means stay free.
# The datasets are regenerated with the same exportData call as run_cell.R,
# then the replicate indices of the first 10000 converged rows of the
# already-replayed cell are refit.
# Usage: Rscript respecify_mgcfa.R POP CELL.csv.gz OUTDIR WORK NCORES
suppressMessages({library(simsem); library(lavaan); library(parallel)})
a <- commandArgs(TRUE)
pop <- a[1]
cell_csv <- a[2]
out <- a[3]
work <- a[4]
ncores <- as.integer(a[5])
N <- 240L
cond <- 3L
props <- c(.45, .45, .05, .05)
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
cell <- sprintf("mgcfa_%s_n240_c3", pop)
dir <- file.path(work, paste0(cell, "_respec"))
dir.create(dir, recursive = TRUE, showWarnings = FALSE)
stem <- file.path(dir, "sim_data_n240")
set.seed(1313)
exportData(nRep = 15000, model = popm, n = n, program = "Mplus",
           fileStem = stem, seed = 13131, pmMCAR = 0)
paths <- list.files(dir, pattern = ".dat", recursive = TRUE, full.names = TRUE)[-1]
stopifnot(length(paths) == 15000)

prev <- read.csv(cell_csv)
prev <- prev[prev$conv == 1, ]
prev <- prev[seq_len(min(10000L, nrow(prev))), ]
reps <- prev$rep
stopifnot(length(reps) == 10000L)

defs <- "
eta ~ c(a, b, c, d)*1
i1 + i2 + i3 + i4 ~ c(eq, eq, eq, eq)*1
c1 := -1*((a + c) / 2) + ((b + d) / 2)
c2 := -1*((a + b) / 2) + ((c + d) / 2)
c3 := -1*((b + c) / 2) + ((a + d) / 2)"
models <- list(
  equal_var = paste0("eta =~ 1*i1 + i2 + i3 + i4
eta ~~ c(v, v, v, v)*eta
", defs),
  equal_var_load = paste0("eta =~ 1*i1 + c(l2,l2,l2,l2)*i2 + c(l3,l3,l3,l3)*i3 + c(l4,l4,l4,l4)*i4
eta ~~ c(v, v, v, v)*eta
", defs),
  equal_var_load_resid = paste0("eta =~ 1*i1 + c(l2,l2,l2,l2)*i2 + c(l3,l3,l3,l3)*i3 + c(l4,l4,l4,l4)*i4
eta ~~ c(v, v, v, v)*eta
i1 ~~ c(e1,e1,e1,e1)*i1
i2 ~~ c(e2,e2,e2,e2)*i2
i3 ~~ c(e3,e3,e3,e3)*i3
i4 ~~ c(e4,e4,e4,e4)*i4
", defs)
)

one <- function(i) {
  d <- read.table(paths[i], header = FALSE, sep = " ",
                  colClasses = rep("numeric", 5),
                  col.names = c("i1", "i2", "i3", "i4", "subgroup"))
  out_i <- c(rep = i)
  for (nm in names(models)) {
    r <- tryCatch({
      fit <- sem(models[[nm]], data = d, missing = "ML", estimator = "MLR",
                 group = "subgroup", meanstructure = TRUE)
      pe <- parameterEstimates(fit, ci = FALSE)
      p <- pe[pe$op == ":=", ]
      c(conv = as.numeric(lavInspect(fit, "converged")),
        est = p$est, se = p$se, z = p$z, p = p$pvalue)
    }, error = function(e) c(conv = 0, rep(NA_real_, 12)))
    names(r) <- paste0(nm, "_", c("conv", paste0("c", 1:3, "_est"),
                                  paste0("c", 1:3, "_se"),
                                  paste0("c", 1:3, "_z"),
                                  paste0("c", 1:3, "_p")))
    out_i <- c(out_i, r)
  }
  out_i
}

idx <- split(reps, ceiling(seq_along(reps) / 1000))
res <- list()
for (b in idx) res <- c(res, mclapply(b, one, mc.cores = ncores))
m <- do.call(rbind, res)
dir.create(out, recursive = TRUE, showWarnings = FALSE)
gz <- gzfile(file.path(out, paste0(cell, "_respec.csv.gz")), "w")
write.csv(m, gz, row.names = FALSE)
close(gz)
unlink(dir, recursive = TRUE)
cat(cell, "respec rows", nrow(m), "\n")
