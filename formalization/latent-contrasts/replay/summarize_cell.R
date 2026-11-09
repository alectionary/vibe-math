# Summarise one replay cell the way osf/analysis/mgcfa_model.R summarises a
# converged block, and compare every numeric column with one OSF summary row.
# Usage:
#   Rscript summarize_cell.R CELL.csv.gz OSF.csv ROW OUT.txt [true|null]
# ROW is 1-based in the data (header is not a row). Population targets are
# (-0.4, -0.2, 0) for true and (0, 0, 0) for null.
args <- commandArgs(TRUE)
cell_path <- args[1]
osf_path <- args[2]
row_i <- as.integer(args[3])
out_path <- args[4]
pop <- if (length(args) >= 5) args[5] else "true"
targets <- if (pop == "null") c(0, 0, 0) else c(-0.4, -0.2, 0)

d <- read.csv(cell_path, stringsAsFactors = FALSE)
conv <- d[d$conv == 1, ]
conv <- conv[seq_len(min(10000L, nrow(conv))), ]
stopifnot(nrow(conv) > 0)

num <- function(x) suppressWarnings(as.numeric(x))
sig_n <- function(p) sum(num(p) < 0.05, na.rm = TRUE)
accept_ge <- function(x, cut) sum(num(x) >= cut, na.rm = TRUE)
accept_le <- function(x, cut) sum(num(x) <= cut, na.rm = TRUE)

one_contrast <- function(est, p, target, prefix) {
  est <- num(est)
  n <- length(est)
  avg <- mean(est)
  se <- stats::sd(est) / sqrt(n)
  bias <- est - target
  abs_bias <- abs(bias)
  rel <- if (target == 0) bias else bias / target
  abs_se <- stats::sd(abs_bias) / sqrt(10000)
  rel_se <- stats::sd(rel) / sqrt(10000)
  avg_abs <- mean(abs_bias)
  avg_rel <- mean(rel)
  n_sig <- sig_n(p)
  c(
    setNames(avg, paste0(prefix, "_avg_est")),
    setNames(se, paste0(prefix, "_se_est")),
    setNames(avg + 1.96 * se, paste0(prefix, "_ci_upper_est")),
    setNames(avg - 1.96 * se, paste0(prefix, "_ci_lower_est")),
    setNames(n_sig, paste0(prefix, "_n_sig")),
    setNames(n_sig / nrow(conv), paste0(prefix, "_prop_sig")),
    setNames(mean(bias^2) / 10000, paste0("mse_", prefix)),
    setNames(avg_abs, paste0("avg_abs_bias_", prefix, "_est")),
    setNames(abs_se, paste0("abs_bias_", prefix, "_se")),
    setNames(avg_abs - 1.386 * abs_se, paste0("abs_bias_", prefix, "_83.4ci_lower")),
    setNames(avg_abs + 1.386 * abs_se, paste0("abs_bias_", prefix, "_83.4ci_upper")),
    setNames(avg_abs - 1.960 * abs_se, paste0("abs_bias_", prefix, "_95ci_lower")),
    setNames(avg_abs + 1.960 * abs_se, paste0("abs_bias_", prefix, "_95ci_upper")),
    setNames(avg_rel, paste0("avg_rel_bias_", prefix, "_est")),
    setNames(rel_se, paste0("rel_bias_", prefix, "_se")),
    setNames(avg_rel - 1.386 * rel_se, paste0("rel_bias_", prefix, "_83.4ci_lower")),
    setNames(avg_rel + 1.386 * rel_se, paste0("rel_bias_", prefix, "_83.4ci_upper")),
    setNames(avg_rel - 1.960 * rel_se, paste0("rel_bias_", prefix, "_95ci_lower")),
    setNames(avg_rel + 1.960 * rel_se, paste0("rel_bias_", prefix, "_95ci_upper")),
    setNames(100 * n_sig / nrow(conv), paste0("power_", prefix))
  )
}

fit_block <- function(cfi, rmsea, srmr, tag) {
  c(
    setNames(min(num(cfi), na.rm = TRUE), paste0("cfi_min", tag)),
    setNames(max(num(cfi), na.rm = TRUE), paste0("cfi_max", tag)),
    setNames(mean(num(cfi), na.rm = TRUE), paste0("cfi_avg", tag)),
    setNames(min(num(rmsea), na.rm = TRUE), paste0("rmsea_min", tag)),
    setNames(max(num(rmsea), na.rm = TRUE), paste0("rmsea_max", tag)),
    setNames(mean(num(rmsea), na.rm = TRUE), paste0("rmsea_avg", tag)),
    setNames(min(num(srmr), na.rm = TRUE), paste0("srmr_min", tag)),
    setNames(max(num(srmr), na.rm = TRUE), paste0("srmr_max", tag)),
    setNames(mean(num(srmr), na.rm = TRUE), paste0("srmr_avg", tag)),
    setNames(accept_ge(cfi, 0.9), paste0("n_accept_cfi", tag)),
    setNames(accept_ge(cfi, 0.9) / 10000, paste0("prop_accept_cfi", tag)),
    setNames(accept_ge(cfi, 0.985), paste0("n_accept_dyn_cfi", tag)),
    setNames(accept_ge(cfi, 0.985) / 10000, paste0("prop_accept_dyn_cfi", tag)),
    setNames(accept_le(rmsea, 0.08), paste0("n_accept_rmsea", tag)),
    setNames(accept_le(rmsea, 0.08) / 10000, paste0("prop_accept_rmsea", tag)),
    setNames(accept_le(rmsea, 0.069), paste0("n_accept_dyn_rmsea", tag)),
    setNames(accept_le(rmsea, 0.069) / 10000, paste0("prop_accept_dyn_rmsea", tag)),
    setNames(accept_le(srmr, 0.08), paste0("n_accept_srmr", tag)),
    setNames(accept_le(srmr, 0.08) / 10000, paste0("prop_accept_srmr", tag)),
    setNames(accept_le(srmr, 0.020), paste0("n_accept_dyn_srmr", tag)),
    setNames(accept_le(srmr, 0.020) / 10000, paste0("prop_accept_dyn_srmr", tag))
  )
}

ours <- c(
  one_contrast(conv$c1_est, conv$c1_p, targets[1], "c1"),
  one_contrast(conv$c2_est, conv$c2_p, targets[2], "c2"),
  one_contrast(conv$c3_est, conv$c3_p, targets[3], "c3"),
  fit_block(conv$cfi, conv$rmsea, conv$srmr, ""),
  converged = nrow(conv),
  conv_prop = nrow(conv) / 10000
)
if ("cfi_robust" %in% names(conv)) {
  ours <- c(ours, fit_block(conv$cfi_robust, conv$rmsea_robust, conv$srmr, "_robustcfi"))
}

osf <- read.csv(osf_path, stringsAsFactors = FALSE, check.names = FALSE)
osf_row <- osf[row_i, ]
osf_num <- suppressWarnings(as.numeric(osf_row))
names(osf_num) <- names(osf_row)

lines <- c(
  paste("cell", cell_path),
  paste("osf", osf_path, "row", row_i),
  paste("pop", pop),
  paste("rows_in_file", nrow(d)),
  paste("converged_in_file", sum(d$conv == 1, na.rm = TRUE)),
  paste("summarised_n", nrow(conv)),
  "column\tours\tosf\tdiff\tabs_diff\tnote"
)
exact_means <- TRUE
exact_sigs <- TRUE
for (nm in names(osf_num)) {
  ov <- osf_num[[nm]]
  if (is.na(ov)) next
  if (!nm %in% names(ours)) {
    lines <- c(lines, paste(nm, NA, ov, NA, NA, "not_in_cell_summary", sep = "\t"))
    next
  }
  mv <- as.numeric(ours[[nm]])
  diff <- mv - ov
  lines <- c(lines, paste(nm, sprintf("%.12g", mv), sprintf("%.12g", ov),
                          sprintf("%.12g", diff), sprintf("%.12g", abs(diff)),
                          "compared", sep = "\t"))
}
mean_names <- c("c1_avg_est", "c2_avg_est", "c3_avg_est")
sig_names <- c("c1_n_sig", "c2_n_sig", "c3_n_sig")
mean_ok <- all(abs(as.numeric(ours[mean_names]) - osf_num[mean_names]) < 1e-8)
sig_ok <- all(as.numeric(ours[sig_names]) == osf_num[sig_names])
lines <- c(
  lines,
  paste("exact_means_1e-8", mean_ok),
  paste("exact_sig_counts", sig_ok),
  paste("gate", if (isTRUE(mean_ok) && isTRUE(sig_ok)) "PASS" else "FAIL")
)
dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)
writeLines(lines, out_path)
cat(paste(lines[c(1:6, length(lines) - 2, length(lines) - 1, length(lines))], collapse = "\n"), "\n")
