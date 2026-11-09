# Run dynamic::cfaOne the way the commented block in osf/analysis/mgcfa_model.R
# writes it, on one generated dataset, and save the cutoffs or the error.
# Usage: Rscript run_dynamic.R DATA.dat OUT.txt
# DATA.dat is one replicate with columns i1 i2 i3 i4 subgroup, no header.
suppressMessages({library(lavaan); library(dynamic)})
args <- commandArgs(TRUE)
data_path <- args[1]
out_path <- args[2]
d <- read.table(data_path, header = FALSE, sep = " ",
                colClasses = rep("numeric", 5),
                col.names = c("i1", "i2", "i3", "i4", "subgroup"))
model <- "eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ NA*1
i1 + i2 + i3 + i4 ~ eq*1"
dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)
con <- file(out_path, "wt")
sink(con, split = TRUE)
cat("data", data_path, "n", nrow(d), "\n")
cat("call: cfaOne(model = dfi_fit, plot = FALSE) on the commented single-group syntax\n")
fit <- tryCatch(
  sem(model, data = d, missing = "ML", estimator = "MLR", meanstructure = TRUE),
  error = function(e) e
)
if (inherits(fit, "error")) {
  cat("FIT_ERROR: ", conditionMessage(fit), "\n", sep = "")
} else {
  cat("converged", lavInspect(fit, "converged"), "\n")
  one <- tryCatch(cfaOne(model = fit, plot = FALSE), error = function(e) e)
  if (inherits(one, "error")) {
    cat("CFAONE_ERROR: ", conditionMessage(one), "\n", sep = "")
  } else {
    cat("CFAONE_OK\n")
    print(one)
  }
}
sink()
close(con)
