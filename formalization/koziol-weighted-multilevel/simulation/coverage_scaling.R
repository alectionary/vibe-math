# Mplus-style finite-sample multipliers applied to the saved standard errors
# from the informative normal random-intercept cell rho=.05, nj=20 (cell 5).
# Koziol Table E.2 prints wtm.ccs intercept coverage 0.282. Our CR-0 coverage
# is about 0.252. The multipliers below are the ones named in the Mplus MLR
# sandwich description and in the usual cluster corrections G/(G-1) and
# N/(N-1). They multiply the variance; the standard error is multiplied by
# the square root. A second column multiplies the standard error by the
# factor itself, which is the more generous reading.

sim_dir <- Sys.getenv("SIM_DIR", unset = getwd())
d <- read.csv(file.path(sim_dir, "results", "cell_05.csv"))
d <- d[d$estimator == "wtm.ccs" & d$converged %in% c("TRUE", "True") &
         is.finite(d$g00) & is.finite(d$se00), ]
G <- mean(d$m)
N <- mean(d$n)
p0 <- mean(abs(d$g00) <= 1.96 * d$se00)
mc_se <- sqrt(p0 * (1 - p0) / nrow(d))
factors <- c(
  CR0 = 1,
  `G/(G-1)` = G / (G - 1),
  `N/(N-1)` = N / (N - 1),
  `G/(G-1)*(N-1)/(N-3)` = (G / (G - 1)) * ((N - 1) / (N - 3))
)
rows <- lapply(names(factors), function(nm) {
  f <- factors[[nm]]
  data.frame(
    factor = nm, value = f, reps = nrow(d), clusters = G, students = N,
    cover_var_scaled = mean(abs(d$g00) <= 1.96 * sqrt(f) * d$se00),
    cover_se_scaled = mean(abs(d$g00) <= 1.96 * f * d$se00),
    published = 0.282, cr0 = p0, mc_se = mc_se,
    stringsAsFactors = FALSE
  )
})
out <- do.call(rbind, rows)
path <- file.path(sim_dir, "results", "coverage_scaling.csv")
write.csv(out, path, row.names = FALSE)
print(out, digits = 6)
cat("mc_se", mc_se, "gap", 0.282 - p0, "gap_over_mc_se", (0.282 - p0) / mc_se, "\n")
