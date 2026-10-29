# Person-fit statistics matched to mokken 3.1.2 and PerFit 1.4.7.
#
# fast_HiT is the se = FALSE branch of mokken::coefH on the transposed
# response matrix: Hi = sum of off-diagonal covariances divided by the sum of
# off-diagonal maximum covariances, and the maximum covariance is var() of the
# column-sorted matrix (van der Ark's rearrangement).
#
# fast_gnormed and fast_u3 follow the complete-data branches of
# PerFit::Gnormed.poly and PerFit::U3poly. High values are more misfit.
# Scores are integers 0, 1, ..., Ncat-1.

fast_HiT <- function(data) {
  Xt <- t(as.matrix(data))
  S <- stats::var(Xt)
  Smax <- stats::var(apply(Xt, 2L, sort))
  diag(S) <- 0
  diag(Smax) <- 0
  Hi <- rowSums(S) / rowSums(Smax)
  Hi[!is.finite(Hi)] <- NA_real_
  Hi
}

.item_step_matrix <- function(data, Ncat) {
  data <- as.matrix(data)
  N <- nrow(data)
  I <- ncol(data)
  M <- Ncat - 1L
  probs <- matrix(NA_real_, I, M)
  for (m in seq_len(M)) probs[, m] <- colMeans(data >= m)
  isd <- matrix(0, N, I * M)
  for (i in seq_len(I)) {
    for (m in seq_len(M)) {
      isd[, (i - 1L) * M + m] <- as.integer(data[, i] >= m)
    }
  }
  list(isd = isd, probs = as.vector(t(probs)), I = I, M = M, Ncat = Ncat,
       score = rowSums(data))
}

.guttman_inversions <- function(binary_easy_to_hard) {
  x <- binary_easy_to_hard
  L <- ncol(x)
  ones <- upper.tri(matrix(0, L, L), diag = TRUE) * 1
  cs <- x %*% ones
  ones_before <- cbind(0, cs[, -L, drop = FALSE])
  idx <- matrix(seq_len(L) - 1L, nrow = nrow(x), ncol = L, byrow = TRUE)
  zeros_before <- idx - ones_before
  as.numeric(rowSums(x * zeros_before))
}

# Emons recursion. extremum is "max" for normed Guttman errors and "min" for U3.
.step_recursion <- function(cum, Ncat, extremum) {
  I <- nrow(cum)
  pick <- if (extremum == "max") max else min
  V <- matrix(rep(cum[1L, ], Ncat), ncol = Ncat, byrow = FALSE)
  add <- matrix(rep(cum[2L, ], nrow(V)), ncol = Ncat, byrow = TRUE)
  V <- V + add
  Tvec <- vapply(2:sum(dim(V)), function(s) pick(V[col(V) + row(V) == s]), numeric(1))
  if (I >= 3L) {
    for (i in 3L:I) {
      V <- matrix(rep(Tvec, Ncat), ncol = Ncat, byrow = FALSE)
      add <- matrix(rep(cum[i, ], nrow(V)), ncol = Ncat, byrow = TRUE)
      V <- V + add
      Tvec <- vapply(2:sum(dim(V)), function(s) pick(V[col(V) + row(V) == s]), numeric(1))
    }
  }
  Tvec
}

fast_gnormed <- function(data, Ncat) {
  s <- .item_step_matrix(data, Ncat)
  ord <- order(s$probs, decreasing = TRUE)
  num <- .guttman_inversions(s$isd[, ord, drop = FALSE])
  ranks <- matrix(rank(s$I * s$M - s$probs, ties.method = "first"),
                  nrow = s$I, byrow = TRUE)
  cum <- cbind(0, t(apply(ranks, 1L, cumsum)))
  Tvec <- .step_recursion(cum, Ncat, "max")
  xs <- 0:(s$I * s$M)
  maxG <- Tvec - vapply(xs, function(x) 0.5 * x * (x + 1), numeric(1))
  res <- num / maxG[s$score + 1L]
  res[is.nan(res)] <- 0
  res
}

fast_u3 <- function(data, Ncat) {
  s <- .item_step_matrix(data, Ncat)
  logits <- log(s$probs / (1 - s$probs))
  logits[is.infinite(logits)] <- 0
  W <- as.numeric(s$isd %*% logits)
  logits_mat <- matrix(logits, nrow = s$I, byrow = TRUE)
  cum <- cbind(0, t(apply(logits_mat, 1L, cumsum)))
  minW <- .step_recursion(cum, Ncat, "min")
  flat <- as.vector(logits_mat)
  xs <- 0:(s$I * s$M)
  maxW <- vapply(xs, function(x) {
    if (x == 0L) return(0)
    sum(sort(flat, decreasing = TRUE)[seq_len(x)])
  }, numeric(1))
  den <- maxW - minW
  den[c(1L, length(den))] <- 1
  res <- (maxW[s$score + 1L] - W) / den[s$score + 1L]
  res[is.nan(res)] <- NA_real_
  res
}

# Lower tail for H_i^T. Upper tail for U3 and normed Guttman errors,
# which increase with misfit. The literal 5th-percentile rule flags the
# lower tail of every statistic; both are returned.
classify_rates <- function(stat, aberrant, tail = c("lower", "upper")) {
  tail <- match.arg(tail)
  ok <- is.finite(stat)
  prob <- if (tail == "lower") 0.05 else 0.95
  cut <- stats::quantile(stat[ok], probs = prob, na.rm = TRUE, names = FALSE, type = 7)
  flag <- rep(FALSE, length(stat))
  if (tail == "lower") flag[ok] <- stat[ok] <= cut else flag[ok] <- stat[ok] >= cut
  tp <- sum(flag & aberrant)
  fp <- sum(flag & !aberrant)
  tn <- sum(!flag & !aberrant)
  fn <- sum(!flag & aberrant)
  n_ab <- sum(aberrant)
  n_ok <- sum(!aberrant)
  c(cutoff = unname(cut),
    n_flag = sum(flag),
    n_na = sum(!ok),
    sensitivity = tp / n_ab,
    specificity = tn / n_ok,
    ppv = if (tp + fp == 0) NA_real_ else tp / (tp + fp),
    npv = if (tn + fn == 0) NA_real_ else tn / (tn + fn))
}
