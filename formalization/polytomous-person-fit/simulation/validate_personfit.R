# Compare the fast statistics with mokken::coefH(se = FALSE) and PerFit.
# Usage: Rscript validate_personfit.R [out_dir]

args <- commandArgs(trailingOnly = TRUE)
out_dir <- if (length(args)) args[[1]] else "out"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
.libPaths(c("/tmp/beck/Rlib", .libPaths()))
suppressPackageStartupMessages({
  library(mokken)
  library(PerFit)
  library(mirt)
})
pf <- if (file.exists("personfit.R")) "personfit.R" else file.path("simulation", "personfit.R")
source(pf)

set.seed(11)
rows <- list()
for (Ncat in c(4L, 5L, 7L)) {
  for (J in c(12L, 36L)) {
    data <- matrix(sample(0:(Ncat - 1L), 400 * J, replace = TRUE), 400, J)
    data[1, ] <- 0L
    h_fast <- fast_HiT(data)
    h_pkg <- coefH(t(data), se = FALSE, results = FALSE)$Hi
    g_fast <- fast_gnormed(data, Ncat)
    u_fast <- fast_u3(data, Ncat)
    g_pkg <- Gnormed.poly(data, Ncat = Ncat)$PFscores[, 1]
    u_pkg <- U3poly(data, Ncat = Ncat)$PFscores[, 1]
    rows[[length(rows) + 1L]] <- data.frame(
      Ncat = Ncat, J = J, N = nrow(data),
      H_max_abs = max(abs(h_fast - h_pkg), na.rm = TRUE),
      G_max_abs = max(abs(g_fast - g_pkg), na.rm = TRUE),
      U3_max_abs = max(abs(u_fast - u_pkg), na.rm = TRUE)
    )
  }
}

# Standard graded predictor against mirt, one- and two-factor.
theta1 <- matrix(c(-1, 0, 1), ncol = 1)
a1 <- matrix(1.4, 1, 1)
b1 <- matrix(c(-0.8, 0.2, 1.1), 1)
d1 <- -b1
out1 <- simdata(a1, d1, N = 3, itemtype = "graded", Theta = theta1, returnList = TRUE)
P1 <- mirt:::ProbTrace(out1$itemobjects[[1]], theta1)
cum1 <- sapply(as.vector(b1), function(bk) plogis(1.4 * as.vector(theta1) - bk))
man1 <- cbind(1 - cum1[, 1], cum1[, 1] - cum1[, 2], cum1[, 2] - cum1[, 3], cum1[, 3])

theta2 <- matrix(c(-0.4, 0.7, 0.2, -0.5), ncol = 2)
a2 <- matrix(c(1.1, 0.3), 1)
b2 <- matrix(c(-0.5, 0.4), 1)
d2 <- -b2
out2 <- simdata(a2, d2, N = 2, itemtype = "graded", Theta = theta2, returnList = TRUE)
P2 <- mirt:::ProbTrace(out2$itemobjects[[1]], theta2)
eta <- as.vector(theta2 %*% t(a2))
cum2 <- sapply(as.vector(b2), function(bk) plogis(eta - bk))
man2 <- cbind(1 - cum2[, 1], cum2[, 1] - cum2[, 2], cum2[, 2])

cmp <- rbind(
  do.call(rbind, rows),
  data.frame(Ncat = NA, J = NA, N = NA,
             H_max_abs = NA, G_max_abs = NA, U3_max_abs = NA)
)
write.csv(do.call(rbind, rows), file.path(out_dir, "validate_personfit.csv"), row.names = FALSE)
cat(sprintf("mirt standard 1-factor max abs %.3e\n", max(abs(P1 - man1))))
cat(sprintf("mirt standard 2-factor max abs %.3e\n", max(abs(P2 - man2))))
print(do.call(rbind, rows))
# PerFit's exported PFscores are rounded to 4 decimals. The inversion count
# matches G() before that rounding. 5e-5 is half a unit in the fourth decimal.
tab <- do.call(rbind, rows)
if (any(tab$H_max_abs > 1e-8) || any(tab$G_max_abs > 5e-5) || any(tab$U3_max_abs > 5e-5)) {
  stop("person-fit mismatch")
}
if (max(abs(P1 - man1), abs(P2 - man2)) > 1e-8) stop("mirt probability mismatch")
cat("validate_personfit: ok\n")
