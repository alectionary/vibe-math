# Same matrices scored by the May 2023 packages and by the fast functions
# that match PerFit 1.4.7 / mokken 3.1.2.
# Rscript version_check.R out
args <- commandArgs(trailingOnly = TRUE)
out <- if (length(args)) args[[1]] else "out"
dir.create(out, showWarnings = FALSE, recursive = TRUE)
.libPaths(c("/tmp/beck/Rlib2023", "/tmp/beck/Rlib", .libPaths()))
suppressPackageStartupMessages({
  library(PerFit)
  library(mokken)
})
source(if (file.exists("personfit.R")) "personfit.R" else "simulation/personfit.R")
stopifnot(as.character(packageVersion("PerFit")) == "1.4.6")
stopifnot(as.character(packageVersion("mokken")) == "3.0.6")

set.seed(3)
rows <- list()
for (Ncat in c(4L, 5L, 6L, 7L)) {
  for (J in c(12L, 36L)) {
    data <- matrix(sample(0:(Ncat - 1L), 250 * J, replace = TRUE), 250, J)
    data[1, ] <- 0L
    g_old <- Gnormed.poly(data, Ncat = Ncat)$PFscores[, 1]
    u_old <- U3poly(data, Ncat = Ncat)$PFscores[, 1]
    g_new <- fast_gnormed(data, Ncat)
    u_new <- fast_u3(data, Ncat)
    # mokken 3.0.6 on a shorter person count. Columns are persons.
    small <- t(data[1:40, , drop = FALSE])
    h_old <- coefH(small, se = FALSE, results = FALSE)$Hi
    h_new <- fast_HiT(t(small))
    rows[[length(rows) + 1L]] <- data.frame(
      Ncat = Ncat, J = J,
      G_max_abs = max(abs(g_old - round(g_new, 4))),
      U3_max_abs = max(abs(u_old - round(u_new, 4))),
      H_max_abs = max(abs(h_old - h_new), na.rm = TRUE)
    )
  }
}
tab <- do.call(rbind, rows)
utils::write.csv(tab, file.path(out, "version_check.csv"), row.names = FALSE)
print(tab, digits = 4)
cat("PerFit", as.character(packageVersion("PerFit")),
    "mokken", as.character(packageVersion("mokken")), "\n")
if (any(tab$G_max_abs > 5e-5 | tab$U3_max_abs > 5e-5 | tab$H_max_abs > 1e-8)) {
  stop("version mismatch")
}
cat("version_check: ok\n")
