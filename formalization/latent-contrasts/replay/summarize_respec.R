# Summarise one respecification file the way Tables 5.1 and 5.2 do:
# mean estimate, SE of that mean, percent significant, mean absolute bias,
# mean relative bias, and mean squared error as in the OSF scripts.
# Usage: Rscript summarize_respec.R RESPEC.csv.gz true|null OUT.txt
args <- commandArgs(TRUE)
d <- read.csv(args[1])
pop <- args[2]
out <- args[3]
targets <- if (pop == "null") c(0, 0, 0) else c(-0.4, -0.2, 0)
specs <- c("equal_var", "equal_var_load", "equal_var_load_resid")
lines <- c(paste("file", args[1]), paste("pop", pop), paste("rows", nrow(d)))
for (sp in specs) {
  conv <- d[[paste0(sp, "_conv")]] == 1
  lines <- c(lines, paste(sp, "converged", sum(conv, na.rm = TRUE), "of", nrow(d)))
  use <- d[conv, ]
  for (k in 1:3) {
    est <- use[[paste0(sp, "_c", k, "_est")]]
    p <- use[[paste0(sp, "_c", k, "_p")]]
    n <- length(est)
    avg <- mean(est)
    se <- stats::sd(est) / sqrt(n)
    nsig <- sum(p < 0.05, na.rm = TRUE)
    bias <- est - targets[k]
    rel <- if (targets[k] == 0) bias else bias / targets[k]
    # source mse_c3 divides by 1000; c1 and c2 by 10000
    mse_div <- if (k == 3) 1000 else 10000
    lines <- c(lines, sprintf(
      "%s c%d avg=%.6f se=%.6f pct_sig=%.2f abs_bias=%.4f rel_bias=%.4f mse=%.8f n=%d",
      sp, k, avg, se, 100 * nsig / n, mean(abs(bias)), mean(rel),
      mean(bias^2) / mse_div, n))
  }
}
writeLines(lines, out)
cat(paste(lines, collapse = "\n"), "\n")
