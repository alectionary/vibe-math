# Large-sample MIMIC slopes on the appendix-parsed population.
# Seed 7. One sample, 100000 per group.
# Usage: Rscript mimic_large.R [out_dir]

suppressPackageStartupMessages(library(lavaan))
args <- commandArgs(trailingOnly = TRUE)
out_dir <- if (length(args) >= 1) args[[1]] else "out"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

set.seed(7)
n <- 100000
alpha <- c(1, 0.6, 0.8, 0.4)
lam <- c(1, 0.7, 0.7, 0.7)
parts <- lapply(1:4, function(g) {
  eta <- rnorm(n, alpha[[g]], sqrt(0.5))
  x <- sapply(seq_along(lam), function(j) 1 + lam[[j]] * eta + rnorm(n, 0, sqrt(0.51)))
  data.frame(i1 = x[, 1], i2 = x[, 2], i3 = x[, 3], i4 = x[, 4], subgroup = g)
})
dat <- do.call(rbind, parts)
sg <- dat$subgroup
dat$c1 <- factor(ifelse(sg %in% c(1, 3), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
dat$c2 <- factor(ifelse(sg %in% c(1, 2), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
dat$c3 <- factor(ifelse(sg %in% c(1, 4), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))

free <- "
eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ 1 + c1 + c2 + c3
i1 + i2 + i3 + i4 ~ eq*1
"
posted <- "
eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ c1 + c2 + c3
i1 + i2 + i3 + i4 ~ eq*1
"
rows <- list()
for (nm in c("free", "posted")) {
  fit <- sem(if (nm == "free") free else posted, data = dat, estimator = "MLR", warn = FALSE)
  pe <- parameterEstimates(fit)
  hit <- pe[pe$lhs == "eta" & pe$op == "~" & pe$rhs %in% c("c1", "c2", "c3"), ]
  hit$reading <- nm
  rows[[nm]] <- hit[, c("reading", "rhs", "est", "se")]
}
tab <- do.call(rbind, rows)
write.csv(tab, file.path(out_dir, "mimic_large.csv"), row.names = FALSE)
print(tab)
