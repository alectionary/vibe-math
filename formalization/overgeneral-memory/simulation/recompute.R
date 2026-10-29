# Recompute the behavioral tests in Sorenson (2015) from the printed
# means, standard deviations, and sample sizes.
#
# The dissertation does not name the program that produced these tests.
# Base R is used because the checks are Student and Welch t statistics,
# Pearson chi-square statistics, F and correlation tail probabilities,
# and the integer-score constraints on the printed means.
#
# From the repository root:
#   Rscript formalization/overgeneral-memory/simulation/recompute.R
#
# Writes simulation/out/claims.json, claims.csv, derived.json, and
# sessionInfo.txt next to this script.

args_out <- {
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) >= 1) args[[1]] else file.path("formalization", "overgeneral-memory", "simulation", "out")
}

dir.create(args_out, recursive = TRUE, showWarnings = FALSE)

# Half a unit in the last printed digit. "31.5" has one decimal place.
half_digit <- function(printed) {
  s <- format(printed, scientific = FALSE, trim = TRUE, nsmall = 0)
  if (!grepl("\\.", s)) return(0.5)
  dec <- nchar(sub(".*\\.", "", s))
  0.5 * 10^(-dec)
}

# Round half away from zero, which is the rounding used to test whether
# a printed decimal can be an average of integers.
round_half_away <- function(x, digits) {
  p <- 10^digits
  sign(x) * floor(abs(x) * p + 0.5 + 1e-10) / p
}

student_t <- function(m1, s1, n1, m2, s2, n2) {
  df <- n1 + n2 - 2
  sp2 <- ((n1 - 1) * s1^2 + (n2 - 1) * s2^2) / df
  se <- sqrt(sp2 * (1 / n1 + 1 / n2))
  t <- (m1 - m2) / se
  p <- 2 * pt(-abs(t), df)
  d <- (m1 - m2) / sqrt(sp2)
  j <- 1 - 3 / (4 * df - 1)
  tc <- qt(0.975, df)
  list(t = t, df = df, p = p, d = d, g = j * d, se = se,
       ci = c(m1 - m2 - tc * se, m1 - m2 + tc * se), sp = sqrt(sp2))
}

welch_t <- function(m1, s1, n1, m2, s2, n2) {
  v1 <- s1^2 / n1
  v2 <- s2^2 / n2
  se2 <- v1 + v2
  t <- (m1 - m2) / sqrt(se2)
  df <- se2^2 / (v1^2 / (n1 - 1) + v2^2 / (n2 - 1))
  p <- 2 * pt(-abs(t), df)
  list(t = t, df = df, p = p)
}

one_sample_t <- function(m, s, n, mu) {
  se <- s / sqrt(n)
  t <- (m - mu) / se
  df <- n - 1
  p <- 2 * pt(-abs(t), df)
  tc <- qt(0.975, df)
  list(t = t, df = df, p = p, se = se, ci = c(m - mu - tc * se, m - mu + tc * se))
}

# Let each printed moment move by half a unit in its last digit.
# The returned interval is the range of the Student t on that box.
rounding_band <- function(m1, s1, n1, m2, s2, n2, dm1, ds1, dm2, ds2) {
  grid <- expand.grid(
    a = seq(-1, 1, length.out = 5),
    b = seq(-1, 1, length.out = 5),
    c = seq(-1, 1, length.out = 5),
    d = seq(-1, 1, length.out = 5)
  )
  ts <- apply(grid, 1, function(z) {
    student_t(
      m1 + z[1] * dm1, max(s1 + z[2] * ds1, 1e-8), n1,
      m2 + z[3] * dm2, max(s2 + z[4] * ds2, 1e-8), n2
    )$t
  })
  c(min = min(ts), max = max(ts), center = student_t(m1, s1, n1, m2, s2, n2)$t)
}

one_sample_band <- function(m, s, n, mu, dm, ds) {
  grid <- expand.grid(a = seq(-1, 1, length.out = 9), b = seq(-1, 1, length.out = 9))
  ts <- apply(grid, 1, function(z) {
    one_sample_t(m + z[1] * dm, max(s + z[2] * ds, 1e-8), n, mu)$t
  })
  c(min = min(ts), max = max(ts), center = one_sample_t(m, s, n, mu)$t)
}

# Integers L whose average rounds to the printed mean at the stated decimals.
grim_totals <- function(mean, n, digits) {
  tol <- 0.5 * 10^(-digits)
  lo <- floor((mean - tol) * n - 1)
  hi <- ceiling((mean + tol) * n + 1)
  keep <- integer(0)
  for (L in seq.int(lo, hi)) {
    if (abs(round_half_away(L / n, digits) - mean) < 10^(-(digits + 6))) {
      keep <- c(keep, L)
    }
  }
  keep
}

# Minimum sample standard deviation of n integers in [lo, hi] that sum to L.
# Returns NA when no such integers exist.
min_sample_sd <- function(L, n, lo, hi) {
  if (L < n * lo || L > n * hi) return(NA_real_)
  # Most equal integers inside the bounds.
  base <- floor(L / n)
  if (base < lo) base <- lo
  # Distribute the remainder without leaving the bounds.
  rest <- L - n * base
  if (base + 1 > hi && rest > 0) return(NA_real_)
  # If base itself is below lo we already lifted it. Recompute rest.
  # Values are `base` or `base+1`, then clipped by moving pairs if needed.
  k_hi <- rest
  k_lo <- n - rest
  if (base < lo || base + (k_hi > 0) > hi) return(NA_real_)
  mu <- L / n
  ssd <- k_hi * (base + 1 - mu)^2 + k_lo * (base - mu)^2
  if (n == 1) return(0)
  sqrt(ssd / (n - 1))
}

# Feasible paired t given marginal means and standard deviations.
# sd of the difference lies between |s1-s2| and s1+s2.
paired_bounds <- function(m1, s1, m2, s2, n) {
  d <- m1 - m2
  sd_lo <- abs(s1 - s2)
  sd_hi <- s1 + s2
  scale <- abs(d) * sqrt(n)
  t_at <- function(sd) if (sd <= 0) Inf else scale / sd
  # The larger standard deviation of the difference gives the smaller |t|.
  c(t_min = t_at(sd_hi), t_max = t_at(sd_lo), diff = d, n = n)
}

implied_paired_r <- function(m1, s1, m2, s2, n, t_printed) {
  d <- m1 - m2
  sd_d <- abs(d) * sqrt(n) / abs(t_printed)
  # Var(X-Y) = s1^2 + s2^2 - 2 r s1 s2, with variances the printed ones.
  cov <- (s1^2 + s2^2 - sd_d^2) / 2
  cov / (s1 * s2)
}

pearson_chisq <- function(tab) {
  ct <- suppressWarnings(chisq.test(tab, correct = FALSE))
  list(stat = unname(ct$statistic), df = unname(ct$parameter), p = ct$p.value,
       expected = ct$expected)
}

cor_p <- function(r, n) {
  df <- n - 2
  t <- r * sqrt(df / (1 - r^2))
  p <- 2 * pt(-abs(t), df)
  list(t = t, df = df, p = p)
}

f_p <- function(F, df1, df2) {
  list(F = F, df1 = df1, df2 = df2, p = pf(F, df1, df2, lower.tail = FALSE))
}

inside <- function(target, band) {
  target >= band["min"] && target <= band["max"]
}

# Printed moments. Group 1 is depressed, group 2 is nondepressed.
# Final analysis sample stated in the results: 20 and 17.
# Recruited sample stated in the methods and in Table 1 gender counts: 20 and 19.

bdi_20_17 <- student_t(26.34, 9.51, 20, 1.84, 2.24, 17)
bdi_20_19 <- student_t(26.34, 9.51, 20, 1.84, 2.24, 19)
bdi_w_20_17 <- welch_t(26.34, 9.51, 20, 1.84, 2.24, 17)
bdi_w_20_19 <- welch_t(26.34, 9.51, 20, 1.84, 2.24, 19)

panas_pos_20_17 <- student_t(22.89, 8.39, 20, 27.78, 8.01, 17)
panas_neg_20_17 <- student_t(16.89, 4.91, 20, 11.28, 1.96, 17)
panas_pos_19_18 <- student_t(22.89, 8.39, 19, 27.78, 8.01, 18)
panas_neg_19_18 <- student_t(16.89, 4.91, 19, 11.28, 1.96, 18)
panas_neg_band_20_17 <- rounding_band(
  16.89, 4.91, 20, 11.28, 1.96, 17, 0.005, 0.005, 0.005, 0.005
)
panas_pos_band_20_17 <- rounding_band(
  22.89, 8.39, 20, 27.78, 8.01, 17, 0.005, 0.005, 0.005, 0.005
)

amt <- student_t(10.80, 1.64, 20, 11.82, 1.51, 17)
amt_band <- rounding_band(10.80, 1.64, 20, 11.82, 1.51, 17, 0.005, 0.005, 0.005, 0.005)
# The page prints an unsigned t. The prose says the depressed mean is lower.
amt_abs_center <- abs(amt$t)

age <- student_t(30.35, 9.22, 20, 30.58, 8.72, 19)
edu <- student_t(15.95, 2.09, 20, 16.79, 2.58, 19)

ship_19_19 <- student_t(31.5, 3.27, 19, 30.83, 4.13, 19)
ship_20_18 <- student_t(31.5, 3.27, 20, 30.83, 4.13, 18)
ship_band_20_18 <- rounding_band(31.50, 3.27, 20, 30.83, 4.13, 18, 0.005, 0.005, 0.005, 0.005)

# Valence marginals, independent-samples reading of t(72): n = 37 and 37.
# Negative-cue SD is printed as 0.8, one decimal. Also checked as 0.80.
val_nn <- student_t(3.97, 0.83, 37, 3.49, 0.80, 37)
val_nn_band <- rounding_band(3.97, 0.83, 37, 3.49, 0.80, 37, 0.005, 0.005, 0.005, 0.005)
val_pn <- student_t(3.81, 0.97, 37, 3.49, 0.80, 37)
val_pn_band <- rounding_band(3.81, 0.97, 37, 3.49, 0.80, 37, 0.005, 0.005, 0.005, 0.005)
val_nn_wide <- rounding_band(3.97, 0.83, 37, 3.49, 0.8, 37, 0.005, 0.005, 0.005, 0.05)

clarity <- student_t(3.9, 0.59, 20, 3.9, 0.66, 17)
clarity_band <- rounding_band(3.9, 0.59, 20, 3.9, 0.66, 17, 0.05, 0.005, 0.05, 0.005)

general <- student_t(4.05, 3.73, 20, 2.18, 3.47, 17)
roi <- student_t(1405.65, 158.63, 20, 1401.35, 190.96, 17)
enc <- student_t(91.5, 4.1, 20, 93.1, 3.7, 17)
enc_band <- rounding_band(91.5, 4.1, 20, 93.1, 3.7, 17, 0.05, 0.05, 0.05, 0.05)
reinst_g <- student_t(69.5, 7.0, 20, 64.9, 8.2, 17)
reinst_g_band <- rounding_band(69.5, 7.0, 20, 64.9, 8.2, 17, 0.05, 0.05, 0.05, 0.05)
reinst_one <- one_sample_t(67.5, 7.8, 37, 50)
reinst_one_band <- one_sample_band(67.5, 7.8, 37, 50, 0.05, 0.05)

gender <- pearson_chisq(matrix(c(13, 7, 11, 8), nrow = 2, byrow = TRUE))
gender_yates <- suppressWarnings(chisq.test(
  matrix(c(13, 7, 11, 8), nrow = 2, byrow = TRUE), correct = TRUE
))
hand_3 <- pearson_chisq(matrix(c(17, 2, 1, 17, 2, 0), nrow = 2, byrow = TRUE))
hand_right <- pearson_chisq(matrix(c(17, 3, 17, 2), nrow = 2, byrow = TRUE))

reward_paired <- paired_bounds(25.41, 9.32, 24.11, 11.27, 37)
reward_r <- implied_paired_r(25.41, 9.32, 24.11, 11.27, 37, 1.80)
clarity_paired <- paired_bounds(4.6, 0.46, 3.28, 0.73, 37)
clarity_r <- implied_paired_r(4.6, 0.46, 3.28, 0.73, 37, 13.08)

# Pooled within-subject residual for 37 participants, 4 cells, and the six
# within-subject terms of group x reward x memory (three within effects,
# each also interacting with group).
pooled_df <- 37 * 3 - 6

f_valence <- f_p(3.32, 2, 70)
f_inter <- f_p(0.53, 2, 70)
f_group <- f_p(3.84, 1, 35)
f_reward <- f_p(2.97, 1, 35)
f_reward_297 <- f_p(297, 1, 35)
f_mem <- f_p(379.55, 1, 105)
t_reward_p <- 2 * pt(-abs(1.80), 36)
t_clarity_p <- 2 * pt(-abs(13.08), 36)
t_printed_amt_p <- 2 * pt(-abs(1.96), 35)
t_reinst_printed_p <- 2 * pt(-abs(1.89), 35)

r_amt_general <- cor_p(-0.36, 37)
r_amt_class <- cor_p(-0.33, 37)
r_amt_class_36 <- cor_p(-0.33, 36)
r_mfg <- cor_p(0.46, 37)
r_mfg_36 <- cor_p(0.46, 36)
r_hits <- cor_p(0.03, 37)
r_mask <- cor_p(-0.03, 37)

rt_group_p <- f_p(1.18, 1, 36)$p
rt_reward_p <- f_p(0.00, 1, 36)$p
rt_inter_p <- f_p(0.21, 1, 36)$p
hits_group_p <- f_p(0.01, 1, 35)$p

grim_rows <- list(
  list(name = "AMT depressed total", mean = 10.80, n = 20, digits = 2, lo = 0, hi = 15, sd = 1.64),
  list(name = "AMT nondepressed total", mean = 11.82, n = 17, digits = 2, lo = 0, hi = 15, sd = 1.51),
  list(name = "BDI depressed n=20", mean = 26.34, n = 20, digits = 2, lo = 0, hi = 63, sd = 9.51),
  list(name = "BDI nondepressed n=19", mean = 1.84, n = 19, digits = 2, lo = 0, hi = 63, sd = 2.24),
  list(name = "BDI nondepressed n=17", mean = 1.84, n = 17, digits = 2, lo = 0, hi = 63, sd = 2.24),
  list(name = "PANAS positive depressed n=20", mean = 22.89, n = 20, digits = 2, lo = 10, hi = 50, sd = 8.39),
  list(name = "PANAS positive depressed n=19", mean = 22.89, n = 19, digits = 2, lo = 10, hi = 50, sd = 8.39),
  list(name = "PANAS positive nondepressed n=17", mean = 27.78, n = 17, digits = 2, lo = 10, hi = 50, sd = 8.01),
  list(name = "PANAS positive nondepressed n=18", mean = 27.78, n = 18, digits = 2, lo = 10, hi = 50, sd = 8.01),
  list(name = "PANAS negative depressed n=20", mean = 16.89, n = 20, digits = 2, lo = 10, hi = 50, sd = 4.91),
  list(name = "PANAS negative depressed n=19", mean = 16.89, n = 19, digits = 2, lo = 10, hi = 50, sd = 4.91),
  list(name = "PANAS negative nondepressed n=17", mean = 11.28, n = 17, digits = 2, lo = 10, hi = 50, sd = 1.96),
  list(name = "PANAS negative nondepressed n=18", mean = 11.28, n = 18, digits = 2, lo = 10, hi = 50, sd = 1.96),
  list(name = "Shipley depressed n=20", mean = 31.5, n = 20, digits = 1, lo = 0, hi = 40, sd = 3.27),
  list(name = "Shipley nondepressed n=19", mean = 30.83, n = 19, digits = 2, lo = 0, hi = 40, sd = 4.13),
  list(name = "Shipley nondepressed n=18", mean = 30.83, n = 18, digits = 2, lo = 0, hi = 40, sd = 4.13),
  list(name = "Age depressed", mean = 30.35, n = 20, digits = 2, lo = 18, hi = 50, sd = 9.22),
  list(name = "Age nondepressed", mean = 30.58, n = 19, digits = 2, lo = 18, hi = 50, sd = 8.72),
  list(name = "Education depressed", mean = 15.95, n = 20, digits = 2, lo = 12, hi = 30, sd = 2.09),
  list(name = "Education nondepressed", mean = 16.79, n = 19, digits = 2, lo = 12, hi = 30, sd = 2.58),
  list(name = "Neutral specific", mean = 3.97, n = 37, digits = 2, lo = 0, hi = 5, sd = 0.83),
  list(name = "Negative specific", mean = 3.49, n = 37, digits = 2, lo = 0, hi = 5, sd = 0.8),
  list(name = "Positive specific", mean = 3.81, n = 37, digits = 2, lo = 0, hi = 5, sd = 0.97),
  list(name = "General hits depressed", mean = 4.05, n = 20, digits = 2, lo = 0, hi = 96, sd = 3.73),
  list(name = "General hits nondepressed", mean = 2.18, n = 17, digits = 2, lo = 0, hi = 96, sd = 3.47)
)

grim_out <- lapply(grim_rows, function(row) {
  Ls <- grim_totals(row$mean, row$n, row$digits)
  mins <- if (length(Ls)) vapply(Ls, min_sample_sd, numeric(1), n = row$n, lo = row$lo, hi = row$hi) else numeric(0)
  list(
    name = row$name, mean = row$mean, n = row$n, digits = row$digits,
    totals = Ls,
    possible = length(Ls) > 0,
    min_sd = if (length(mins)) min(mins, na.rm = TRUE) else NA_real_,
    printed_sd = row$sd,
    sd_above_minimum = if (length(mins)) row$sd + 1e-8 >= min(mins, na.rm = TRUE) else NA
  )
})

claims <- list(
  list(id = "amt_t", published = "t(35) = 1.96, p = .058",
       ours = sprintf("t = %.4f, p = %.4f; band [%.4f, %.4f]",
                      amt_abs_center, amt$p, abs(amt_band["max"]), abs(amt_band["min"])),
       center = amt_abs_center, p = amt$p,
       band = c(abs(amt_band["max"]), abs(amt_band["min"])),
       target = 1.96, verdict = "match"),
  list(id = "amt_F", published = "F(1, 35) = 3.84, p = .06",
       ours = sprintf("1.96^2 = %.4f; p of F = %.4f; moment t^2 = %.4f",
                      1.96^2, f_group$p, amt$t^2),
       verdict = "match"),
  list(id = "valence_df", published = "F(2, 70)",
       ours = "(3 - 1) * (37 - 2) = 70", verdict = "match"),
  list(id = "valence_F", published = "F(2, 70) = 3.32, p = .04",
       ours = sprintf("p = %.4f; F not recomputed", f_valence$p), verdict = "partial"),
  list(id = "interaction_F", published = "F(2, 70) = 0.53, p > 0.1",
       ours = sprintf("p = %.4f; F not recomputed", f_inter$p), verdict = "partial"),
  list(id = "neutral_negative", published = "t(72) = 2.56, p < .05",
       ours = sprintf("t = %.4f, p = %.4f; band [%.4f, %.4f]",
                      val_nn$t, val_nn$p, val_nn_band["min"], val_nn_band["max"]),
       verdict = "match"),
  list(id = "positive_negative", published = "t(72) = 1.57, p > 0.1",
       ours = sprintf("t = %.4f, p = %.4f; band [%.4f, %.4f]",
                      val_pn$t, val_pn$p, val_pn_band["min"], val_pn_band["max"]),
       verdict = "match"),
  list(id = "gender", published = "chi-square(1, N = 39) = 0.20, p > 0.1",
       ours = sprintf("%.5f, df = %d, p = %.4f", gender$stat, gender$df, gender$p),
       yates = unname(gender_yates$statistic), verdict = "close"),
  list(id = "age", published = "t(37) = 0.08, p > 0.1",
       ours = sprintf("t = %.4f, p = %.4f", age$t, age$p), verdict = "match"),
  list(id = "education", published = "t(37) = 1.12, p > .1",
       ours = sprintf("t = %.4f, p = %.4f", edu$t, edu$p), verdict = "match"),
  list(id = "handedness", published = "chi-square(1, N = 39) = 0.98, p > 0.1",
       ours = sprintf("2 x 3 Pearson = %.4f, df = %d, p = %.4f; right vs not = %.4f",
                      hand_3$stat, hand_3$df, hand_3$p, hand_right$stat),
       verdict = "partial"),
  list(id = "shipley", published = "t(36) = 0.55, p > .1",
       ours = sprintf("n = 19/19 gives t = %.4f; n = 20/18 gives t = %.4f",
                      ship_19_19$t, ship_20_18$t),
       verdict = "close"),
  list(id = "bdi", published = "t(35) = 10.94, p < 0.001",
       ours = sprintf("n = 20/19 gives t = %.4f (df %d); n = 20/17 gives t = %.4f (df %d)",
                      bdi_20_19$t, bdi_20_19$df, bdi_20_17$t, bdi_20_17$df),
       welch_20_19 = bdi_w_20_19$t, welch_20_17 = bdi_w_20_17$t,
       verdict = "partial"),
  list(id = "panas_pos_stated", published = "t(35) = 1.81, p = .08",
       ours = sprintf("n = 20/17 gives t = %.4f, p = %.4f; band [%.4f, %.4f]",
                      panas_pos_20_17$t, panas_pos_20_17$p,
                      panas_pos_band_20_17["min"], panas_pos_band_20_17["max"]),
       verdict = "close"),
  list(id = "panas_neg_stated", published = "t(35) = 4.5, p < 0.001",
       ours = sprintf("n = 20/17 gives t = %.4f, p = %.6f; band [%.4f, %.4f]",
                      panas_neg_20_17$t, panas_neg_20_17$p,
                      panas_neg_band_20_17["min"], panas_neg_band_20_17["max"]),
       verdict = "no match"),
  list(id = "panas_19_18", published = "t(35) = 1.81 and t(35) = 4.5",
       ours = sprintf("n = 19/18 gives t = %.4f (p = %.4f) and t = %.4f (p = %.6f)",
                      panas_pos_19_18$t, panas_pos_19_18$p,
                      panas_neg_19_18$t, panas_neg_19_18$p),
       verdict = "match"),
  list(id = "clarity_t", published = "t(35) = 0.17, p > 0.1",
       ours = sprintf("t = %.4f at the printed means; band [%.4f, %.4f]",
                      clarity$t, clarity_band["min"], clarity_band["max"]),
       verdict = "match"),
  list(id = "clarity_paired", published = "t(36) = 13.08, p < 0.001",
       ours = sprintf("p of the printed t = %.3e; feasible |t| in [%.3f, %.3f]; implied r = %.3f",
                      t_clarity_p, clarity_paired["t_min"], clarity_paired["t_max"], clarity_r),
       verdict = "partial"),
  list(id = "memory_F_df", published = "F(1, 105) = 379.55, p < 0.001",
       ours = sprintf("37 * 3 - 6 = %d; p of the printed F = %.3e", pooled_df, f_mem$p),
       verdict = "partial"),
  list(id = "reward_F", published = "F(1, 35) = 2,97, p = 0.09",
       ours = sprintf("p of F = 2.97 is %.4f; p of F = 297 is %.3e", f_reward$p, f_reward_297$p),
       verdict = "match"),
  list(id = "reward_paired", published = "t(36) = 1.80, p = 0.08",
       ours = sprintf("p of the printed t = %.4f; feasible |t| in [%.3f, %.3f]; implied r = %.3f",
                      t_reward_p, reward_paired["t_min"], reward_paired["t_max"], reward_r),
       verdict = "partial"),
  list(id = "hits_group_F", published = "F(1, 35) = 0.01, p > 0.1",
       ours = sprintf("p = %.4f; F not recomputed", hits_group_p), verdict = "partial"),
  list(id = "rt_df", published = "F(1, 36) for group, reward, and the interaction",
       ours = sprintf("p = %.4f, %.4f, %.4f; hits ANOVA in the same paragraph uses df 35",
                      rt_group_p, rt_reward_p, rt_inter_p),
       verdict = "partial"),
  list(id = "general_hits", published = "t(35) = 1.57, p > 0.1",
       ours = sprintf("t = %.4f, p = %.4f", general$t, general$p), verdict = "match"),
  list(id = "roi_voxels", published = "t(35) = 0.07, p > 0.1",
       ours = sprintf("t = %.4f, which rounds to %.2f; p = %.4f", roi$t, round(roi$t, 2), roi$p),
       verdict = "match"),
  list(id = "encoding_accuracy", published = "t(35) = 1.26, p > 0.1",
       ours = sprintf("t = %.4f, p = %.4f; band [%.4f, %.4f]",
                      abs(enc$t), enc$p, abs(enc_band["max"]), abs(enc_band["min"])),
       verdict = "match"),
  list(id = "reinstatement_chance", published = "t(36) = 13.54, p < .01",
       ours = sprintf("t = %.4f, p = %.3e; band [%.4f, %.4f]",
                      reinst_one$t, reinst_one$p, reinst_one_band["min"], reinst_one_band["max"]),
       verdict = "match"),
  list(id = "reinstatement_group", published = "t(35) = 1.89, p = 0.073",
       ours = sprintf("t = %.4f, p = %.4f; band [%.4f, %.4f]; p of printed t = %.4f",
                      reinst_g$t, reinst_g$p, reinst_g_band["min"], reinst_g_band["max"],
                      t_reinst_printed_p),
       verdict = "close"),
  list(id = "r_general", published = "r = -.36, p < 0.05",
       ours = sprintf("p = %.4f at N = 37", r_amt_general$p), verdict = "match"),
  list(id = "r_classifier", published = "r = -0.33, p < 0.05",
       ours = sprintf("p = %.4f at N = 37; p = %.4f at N = 36", r_amt_class$p, r_amt_class_36$p),
       verdict = "match"),
  list(id = "r_mfg", published = "r = .46, p < .01",
       ours = sprintf("p = %.4f at N = 37; p = %.4f at N = 36", r_mfg$p, r_mfg_36$p),
       verdict = "match"),
  list(id = "r_small", published = "r = .03 and r = -0.03, p > 0.1",
       ours = sprintf("p = %.4f and p = %.4f at N = 37", r_hits$p, r_mask$p),
       verdict = "match")
)

derived <- list(
  amt = list(diff_depressed_minus_nondepressed = 10.80 - 11.82, d = amt$d, g = amt$g,
             ci = amt$ci, p_of_printed_t = t_printed_amt_p),
  bdi_final = list(d = bdi_20_17$d, g = bdi_20_17$g, ci = bdi_20_17$ci, p = bdi_20_17$p),
  bdi_recruited = list(d = bdi_20_19$d, g = bdi_20_19$g, ci = bdi_20_19$ci, p = bdi_20_19$p),
  panas_neg_stated = list(d = panas_neg_20_17$d, ci = panas_neg_20_17$ci),
  panas_neg_19_18 = list(d = panas_neg_19_18$d, ci = panas_neg_19_18$ci),
  general = list(d = general$d, ci = general$ci),
  reinstatement_group = list(d = reinst_g$d, ci = reinst_g$ci),
  pooled_df = pooled_df,
  valence_error_df = (3 - 1) * (37 - 2)
)

json_lite_ok <- requireNamespace("jsonlite", quietly = TRUE)
write_json <- function(obj, path) {
  if (json_lite_ok) {
    jsonlite::write_json(obj, path, auto_unbox = TRUE, pretty = TRUE, digits = 8, na = "null")
  } else {
    # A compact fallback that keeps numbers readable. jsonlite is preferred.
    writeLines(deparse(obj, width.cutoff = 500), path)
  }
}

write_json(claims, file.path(args_out, "claims.json"))
write_json(grim_out, file.path(args_out, "grim.json"))
write_json(derived, file.path(args_out, "derived.json"))

claim_df <- do.call(rbind, lapply(claims, function(cl) {
  data.frame(
    id = cl$id,
    published = cl$published,
    ours = cl$ours,
    verdict = cl$verdict,
    stringsAsFactors = FALSE
  )
}))
write.csv(claim_df, file.path(args_out, "claims.csv"), row.names = FALSE)

sink(file.path(args_out, "sessionInfo.txt"))
print(sessionInfo())
sink()

# Identities the note relies on. A failure here means the script and the
# note have drifted, or the formulas have changed.
stopifnot(abs(gender$stat - 0.2078266) < 1e-5)
stopifnot(abs(abs(age$t) - 0.08) < 0.005)
stopifnot(abs(abs(edu$t) - 1.12) < 0.005)
stopifnot(abs(bdi_20_19$t - 10.94) < 0.01)
stopifnot(abs(bdi_20_17$t - 10.36) < 0.02)
stopifnot(pooled_df == 105)
amt_abs_band <- range(abs(unname(amt_band[c("min", "max")])))
stopifnot(1.96 >= amt_abs_band[1] && 1.96 <= amt_abs_band[2])
stopifnot(!inside(4.5, panas_neg_band_20_17))
stopifnot(abs(panas_neg_19_18$t - 4.5) < 0.03)
stopifnot(abs(hand_3$stat - 0.975) < 1e-6)
stopifnot(grim_out[[1]]$possible)
stopifnot(!grim_out[[3]]$possible)

message("Wrote ", args_out)
message(sprintf("AMT |t| = %.4f  BDI 20/19 = %.4f  BDI 20/17 = %.4f  PANAS- 20/17 = %.4f  PANAS- 19/18 = %.4f",
                amt_abs_center, bdi_20_19$t, bdi_20_17$t, panas_neg_20_17$t, panas_neg_19_18$t))
