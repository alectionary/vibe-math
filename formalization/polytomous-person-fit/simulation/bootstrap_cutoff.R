# Sample 5th percentile against the median of 1000 bootstrap 5th percentiles.
# Rscript bootstrap_cutoff.R out
args <- commandArgs(trailingOnly = TRUE)
out <- if (length(args)) args[[1]] else "out"
dir.create(out, showWarnings = FALSE, recursive = TRUE)
set.seed(1)
one <- function(x) {
  q <- stats::quantile(x, 0.05, type = 7, names = FALSE)
  boots <- replicate(1000, stats::quantile(sample(x, length(x), replace = TRUE),
                                           0.05, type = 7, names = FALSE))
  c(sample = q, boot_median = median(boots))
}
a <- one(rnorm(1000))
b <- one(c(rep(0, 80), rnorm(920)))
utils::write.csv(data.frame(case = c("continuous", "pointmass"),
                            sample = c(a["sample"], b["sample"]),
                            boot_median = c(a["boot_median"], b["boot_median"])),
                 file.path(out, "bootstrap_cutoff.csv"), row.names = FALSE)
