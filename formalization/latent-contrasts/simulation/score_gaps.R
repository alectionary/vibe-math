# Compare a Monte Carlo summary to the printed N=240 tables.
# The printed SE is the standard error of the Monte Carlo mean
# (sd / sqrt(10000) in the public summary script).
#
# The agreement check for the 30 rejection rates is a two-sided normal test
# on each rate. The uncorrected 5% critical value is qnorm(0.975) = 1.96.
# The paper's 2-SE band is that rule with 2 in place of 1.96.
# Bonferroni and Holm are applied to those 30 two-sided p-values only.
# qnorm(1 - 0.05/30) is about 2.94 and is the one-sided Bonferroni critical
# value. The two-sided Bonferroni critical value is qnorm(1 - 0.05/(2*30)).
# The dissertation's own Wald tests at alpha = 0.05 are not part of this family.
#
# Usage: Rscript score_gaps.R [validate_csv] [out_csv]

args <- commandArgs(trailingOnly = TRUE)
src <- if (length(args) >= 1) args[[1]] else "out/validate_gaps.csv"
out <- if (length(args) >= 2) args[[2]] else "out/gap_scores.csv"

ours <- read.csv(src, stringsAsFactors = FALSE)

# Printed Table 4.1 / 4.3 (MGCFA) and Table 4.2 / 4.4 (MIMIC), N=240.
# Averages and SEs are the page. Counts are the page percents times 100.
printed <- rbind(
  data.frame(kind = "mgcfa", cond = 1, setting = "true", contrast = 1:3,
             est = c(-0.4046, -0.2027, -0.0010),
             se = c(0.0013, 0.0013, 0.0013),
             pct = c(87.23, 35.57, 5.29)),
  data.frame(kind = "mgcfa", cond = 2, setting = "true", contrast = 1:3,
             est = c(-0.4045, -0.2069, 0.0023),
             se = c(0.0014, 0.0014, 0.0014),
             pct = c(81.27, 31.63, 5.66)),
  data.frame(kind = "mgcfa", cond = 3, setting = "true", contrast = 1:3,
             est = c(-0.4038, -0.2181, 0.0054),
             se = c(0.0021, 0.0021, 0.0021),
             pct = c(49.23, 21.08, 7.77)),
  data.frame(kind = "mgcfa", cond = 1, setting = "null", contrast = 1:3,
             est = c(0.0011, -0.0004, -0.0021),
             se = c(0.0013, 0.0013, 0.0013),
             pct = c(5.10, 4.77, 5.39)),
  data.frame(kind = "mgcfa", cond = 2, setting = "null", contrast = 1:3,
             est = c(0.0014, -0.0044, 0.0017),
             se = c(0.0014, 0.0014, 0.0014),
             pct = c(5.02, 5.15, 5.41)),
  data.frame(kind = "mgcfa", cond = 3, setting = "null", contrast = 1:3,
             est = c(-0.0028, -0.0212, -0.0012),
             se = c(0.0022, 0.0023, 0.0022),
             pct = c(8.13, 8.59, 7.73)),
  data.frame(kind = "mimic_free", cond = 1, setting = "true", contrast = 1:3,
             est = c(-0.4001, -0.2001, 0.0006),
             se = c(0.0011, 0.0011, 0.0011),
             pct = c(95.73, 46.11, 5.27)),
  data.frame(kind = "mimic_free", cond = 3, setting = "true", contrast = 1:3,
             est = c(-0.4014, -0.2007, 0.0004),
             se = c(0.0018, 0.0018, 0.0018),
             pct = c(62.98, 23.37, 6.60)),
  data.frame(kind = "mimic_free", cond = 1, setting = "null", contrast = 1:3,
             est = c(0.0011, -0.0001, 0.0006),
             se = c(0.0011, 0.0011, 0.0011),
             pct = c(5.18, 5.13, 5.32)),
  data.frame(kind = "mimic_free", cond = 3, setting = "null", contrast = 1:3,
             est = c(-0.0012, -0.0006, 0.0005),
             se = c(0.0018, 0.0018, 0.0018),
             pct = c(6.64, 7.41, 6.68))
)

# Table 4.5, proportion converged among the reported attempts, N=240.
conv_printed <- data.frame(
  kind = c("mgcfa", "mgcfa", "mgcfa", "mimic_free", "mimic_free"),
  cond = c(1, 2, 3, 1, 3),
  setting = c("true", "true", "true", "true", "true"),
  rate = c(98.86, 98.11, 89.29, 100, 100)
)

classify <- function(diff, se, zcrit = 2) {
  ifelse(abs(diff) <= zcrit * se, "within noise", "outside noise")
}

rows <- list()
for (i in seq_len(nrow(printed))) {
  p <- printed[i, ]
  hit <- ours[ours$kind == p$kind & ours$cond == p$cond &
                ours$setting == p$setting & ours$contrast == p$contrast, ]
  if (nrow(hit) != 1) next
  se_est <- sqrt(p$se^2 + hit$se_of_mean^2)
  p_hat <- hit$pct_sig / 100
  p_pr <- p$pct / 100
  se_pct <- 100 * sqrt(p_pr * (1 - p_pr) / 10000 + p_hat * (1 - p_hat) / hit$n_used)
  sd_print <- p$se * sqrt(10000)
  rows[[length(rows) + 1]] <- data.frame(
    kind = p$kind, cond = p$cond, setting = p$setting, contrast = p$contrast,
    printed_est = p$est, our_est = hit$mean_est,
    est_diff = hit$mean_est - p$est, est_se = se_est,
    est_call = classify(hit$mean_est - p$est, se_est),
    printed_sd = sd_print, our_sd = hit$sd_est,
    printed_pct = p$pct, our_pct = hit$pct_sig,
    pct_diff = hit$pct_sig - p$pct, pct_se = se_pct,
    pct_call = classify(hit$pct_sig - p$pct, se_pct),
    n_used = hit$n_used, n_optim = hit$n_optim, reps = hit$reps,
    stringsAsFactors = FALSE
  )
}
tab <- do.call(rbind, rows)
tab$z_pct <- tab$pct_diff / tab$pct_se
tab$p_pct <- 2 * stats::pnorm(-abs(tab$z_pct))
m <- nrow(tab)
alpha <- 0.05
z_unc <- stats::qnorm(1 - alpha / 2)
z_bonf_one <- stats::qnorm(1 - alpha / m)
z_bonf_two <- stats::qnorm(1 - alpha / (2 * m))
tab$call_z2 <- classify(tab$pct_diff, tab$pct_se, 2)
tab$call_unc <- ifelse(tab$p_pct <= alpha, "outside noise", "within noise")
tab$call_bonf_two <- ifelse(tab$p_pct <= alpha / m, "outside noise", "within noise")
tab$call_z294 <- classify(tab$pct_diff, tab$pct_se, z_bonf_one)
ord <- order(tab$p_pct)
holm_cut <- alpha / (m - seq_len(m) + 1)
holm_reject <- rep(FALSE, m)
for (i in seq_along(ord)) {
  if (tab$p_pct[[ord[[i]]]] <= holm_cut[[i]]) {
    holm_reject[[ord[[i]]]] <- TRUE
  } else {
    break
  }
}
rank_of <- match(seq_len(m), ord)
tab$holm_cut <- holm_cut[rank_of]
tab$call_holm <- ifelse(holm_reject, "outside noise", "within noise")

k_z2 <- sum(tab$call_z2 == "outside noise")
k_unc <- sum(tab$call_unc == "outside noise")
k_bonf <- sum(tab$call_bonf_two == "outside noise")
k_z294 <- sum(tab$call_z294 == "outside noise")
k_holm <- sum(tab$call_holm == "outside noise")
# Upper-tail binomial test. Contrasts that share a cell are dependent, so this
# p-value treats the 30 rates as independent and is not an exact test.
bin_z2 <- stats::binom.test(k_z2, m, p = alpha, alternative = "greater")
bin_unc <- stats::binom.test(k_unc, m, p = alpha, alternative = "greater")

write.csv(tab, out, row.names = FALSE)
summary_path <- sub("\\.csv$", "_multiplicity.csv", out)
summary <- data.frame(
  rule = c(
    "two_se_band",
    "uncorrected_two_sided_5pct",
    "bonferroni_z_one_sided",
    "bonferroni_two_sided",
    "holm_two_sided"
  ),
  critical_z = c(2, z_unc, z_bonf_one, z_bonf_two, NA),
  alpha_per_test = c(2 * stats::pnorm(-2), alpha, alpha / m, alpha / m, NA),
  n_outside = c(k_z2, k_unc, k_z294, k_bonf, k_holm),
  n_tests = m,
  binomial_p_greater = c(
    bin_z2$p.value, bin_unc$p.value, NA, NA, NA
  ),
  stringsAsFactors = FALSE
)
write.csv(summary, summary_path, row.names = FALSE)
print(tab[, c("kind", "cond", "setting", "contrast", "z_pct", "p_pct",
              "call_z2", "call_bonf_two", "call_holm")])
cat("\n")
print(summary)
cat(sprintf(
  "\nBinomial test of %d misses out of %d at p=0.05, two-SE band: p = %.4g\n",
  k_z2, m, bin_z2$p.value
))
cat("Dependence: the three contrasts in a cell use the same replicates.\n")

cat("\nconvergence, our optim rate versus Table 4.5\n")
for (i in seq_len(nrow(conv_printed))) {
  p <- conv_printed[i, ]
  hit <- ours[ours$kind == p$kind & ours$cond == p$cond & ours$setting == p$setting, ]
  if (nrow(hit) == 0) next
  rate <- 100 * hit$n_optim[[1]] / hit$reps[[1]]
  se <- 100 * sqrt((p$rate / 100) * (1 - p$rate / 100) / 10000 +
                     (rate / 100) * (1 - rate / 100) / hit$reps[[1]])
  cat(sprintf("%s cond %s %s  printed %.2f  ours %.2f  diff %.2f  se %.2f  %s\n",
              p$kind, p$cond, p$setting, p$rate, rate, rate - p$rate, se,
              classify(rate - p$rate, se)))
}
message("wrote ", out)
