# Hand-written graded probabilities against mirt::simdata's trace.
# Rscript check_generator.R out
args <- commandArgs(trailingOnly = TRUE)
out <- if (length(args)) args[[1]] else "out"
dir.create(out, showWarnings = FALSE, recursive = TRUE)
.libPaths(c("/tmp/beck/Rlib", .libPaths()))
suppressPackageStartupMessages(library(mirt))

one <- function(a, b, theta, predictor) {
  D <- 1
  asums <- rowSums(a)
  lin <- theta %*% t(a)
  # hand cumulative P(Y >= k)
  hand <- array(NA_real_, c(nrow(theta), nrow(a), ncol(b)))
  for (m in seq_len(ncol(b))) {
    shift <- if (predictor == "ink") b[, m] * asums else b[, m]
    hand[, , m] <- stats::plogis(D * sweep(lin, 2L, shift, "-"))
  }
  a_use <- D * a
  d <- if (predictor == "ink") -D * sweep(b, 1, asums, "*") else -D * b
  got <- simdata(a_use, d, N = nrow(theta), itemtype = "graded",
                 Theta = theta, mins = 0, returnList = TRUE)
  # ProbTrace columns are categories 0..M. Cumulative P(Y>=k) = sum of cols (k+1):end
  maxabs <- 0
  for (j in seq_len(nrow(a))) {
    P <- mirt:::ProbTrace(got$itemobjects[[j]], theta)
    for (m in seq_len(ncol(b))) {
      pk <- rowSums(P[, (m + 1L):ncol(P), drop = FALSE])
      maxabs <- max(maxabs, max(abs(pk - hand[, j, m])))
    }
  }
  maxabs
}

set.seed(1)
theta <- matrix(rnorm(30), 10, 3)
a <- matrix(c(1.4, 0.2, 0.1, 0.3, 2.1, 0.2), 2, 3, byrow = TRUE)
b <- matrix(c(-1.2, -0.2, 0.8, -0.5, 0.4, 1.1), 2, 3, byrow = TRUE)
ink <- one(a, b, theta, "ink")
std <- one(a, b, theta, "standard")
cat(sprintf("ink max abs %.3e\nstandard max abs %.3e\n", ink, std))
utils::write.csv(data.frame(predictor = c("ink", "standard"), max_abs = c(ink, std)),
                 file.path(out, "generator_probs.csv"), row.names = FALSE)
if (max(ink, std) > 1e-8) stop("generator mismatch")
cat("check_generator: ok\n")
