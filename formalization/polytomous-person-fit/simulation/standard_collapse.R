# Count non-constant base rows under the two linear predictors.
# Rscript standard_collapse.R out
# Uses the item samples and boundaries already written by monte_carlo.R.

args <- commandArgs(trailingOnly = TRUE)
out_dir <- if (length(args)) args[[1]] else "out"
.libPaths(c("/tmp/beck/Rlib", .libPaths()))
suppressPackageStartupMessages(library(mirt))
disc <- read.csv(if (file.exists("out/discriminations.csv")) "out/discriminations.csv" else
                   file.path(out_dir, "discriminations.csv"))
A <- as.matrix(disc[, c("a1", "a2", "a3", "a4")])
# Rebuild boundaries with the master seed, same order as monte_carlo.R.
source_lines <- readLines("monte_carlo.R")
# Call the builders by sourcing after stubbing the run. Easier: duplicate the seed prefix.
MASTER <- 20230511
BASE_MEAN <- c(0.03, 0, 0.09, 0.02)
SIGMA <- matrix(c(
  1.02, 0.49, 0.31, 0.43,
  0.49, 1.11, 0.38, 0.89,
  0.31, 0.38, 0.95, 0.40,
  0.43, 0.89, 0.40, 0.96
), 4, 4, byrow = TRUE)
# One shared item and one shared theta, k = 4, first 12 factor-1 items, to show the ceiling.
set.seed(MASTER)
# Skip the same RNG prefix as monte_carlo.R: four boundary matrices of 144 items,
# with 3, 4, 5, and 6 uniforms each, then 1000 thetas.
n_thr <- c(3, 4, 5, 6)
for (nt in n_thr) {
  b <- matrix(stats::runif(144 * nt), 144, nt)
  b <- t(apply(b, 1, sort))
  if (nt == 3) b4 <- b
}
theta <- MASS::mvrnorm(1000, BASE_MEAN, SIGMA)
items <- 1:12
a <- A[items, , drop = FALSE]
b <- b4[items, , drop = FALSE]
count_var <- function(d, label) {
  X <- simdata(a, d, N = 1000, itemtype = "graded", Theta = theta, mins = 0)
  nvar <- sum(apply(X, 1, stats::sd) > 0)
  cat(label, "nonconstant", nvar, "of", nrow(X), "\n")
}
count_var(-b, "standard d=-b")
count_var(-sweep(b, 1, rowSums(a), "*"), "ink d=-b*sum(a)")
