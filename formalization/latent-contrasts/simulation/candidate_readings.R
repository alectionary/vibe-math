# Fit each identification and coding reading in lavaan 0.6.17.
#
# Population moments give the large-sample contrast. One simulated sample
# per population, seed 13131, is the check that a lavaan fit on data lands
# on that moment fit. simsem 0.5.17, the installed successor of the named
# 0.5.16, parses the Appendix A string.
#
# Usage: Rscript candidate_readings.R [out_dir]
# Seed for the simulated samples: 13131. Moment fits do not use a seed.

suppressPackageStartupMessages(library(lavaan))
.libPaths(c("/tmp/Rlib", .libPaths()))
suppressPackageStartupMessages(library(simsem))

args <- commandArgs(trailingOnly = TRUE)
out_dir <- if (length(args) >= 1) args[[1]] else "out"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

alpha <- c(1, 0.6, 0.8, 0.4)
defined <- c(
  c1 = -mean(alpha[c(1, 3)]) + mean(alpha[c(2, 4)]),
  c2 = -mean(alpha[c(1, 2)]) + mean(alpha[c(3, 4)]),
  c3 = -mean(alpha[c(2, 3)]) + mean(alpha[c(1, 4)])
)

moments <- function(lambda, psi, theta, tau, means) {
  covs <- list()
  mus <- list()
  for (g in seq_along(means)) {
    mu <- tau + lambda * means[[g]]
    names(mu) <- paste0("i", 1:4)
    sig <- psi * tcrossprod(lambda)
    diag(sig) <- diag(sig) + theta
    dimnames(sig) <- list(names(mu), names(mu))
    covs[[g]] <- sig
    mus[[g]] <- mu
  }
  list(cov = covs, mean = mus)
}

mg_osf <- "
eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ c(a, b, c, d)*1
i1 + i2 + i3 + i4 ~ c(eq, eq, eq, eq)*1
c1 := -1*((a + c) / 2) + ((b + d) / 2)
c2 := -1*((a + b) / 2) + ((c + d) / 2)
c3 := -1*((b + c) / 2) + ((a + d) / 2)
"

mg_marker <- "
eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ c(a1, a2, a3, a4)*1
i1 ~ 0*1
c1 := -(a1 + a3)/2 + (a2 + a4)/2
c2 := -(a1 + a2)/2 + (a3 + a4)/2
c3 := -(a2 + a3)/2 + (a1 + a4)/2
"

mg_fixed_loading <- "
eta =~ 0.7*i1 + 0.7*i2 + 0.7*i3 + 0.7*i4
eta ~~ NA*eta
eta ~ c(a, b, c, d)*1
i1 + i2 + i3 + i4 ~ 1*1
c1 := -1*((a + c) / 2) + ((b + d) / 2)
c2 := -1*((a + b) / 2) + ((c + d) / 2)
c3 := -1*((b + c) / 2) + ((a + d) / 2)
"

mg_psi_fixed <- "
eta =~ NA*i1 + i2 + i3 + i4
eta ~~ 0.5*eta
eta ~ c(a, b, c, d)*1
i1 + i2 + i3 + i4 ~ c(eq, eq, eq, eq)*1
c1 := -1*((a + c) / 2) + ((b + d) / 2)
c2 := -1*((a + b) / 2) + ((c + d) / 2)
c3 := -1*((b + c) / 2) + ((a + d) / 2)
"

mg_ref0 <- "
eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ c(a, b, c, d)*1
a == 0
i1 + i2 + i3 + i4 ~ c(eq, eq, eq, eq)*1
c1 := -1*((a + c) / 2) + ((b + d) / 2)
c2 := -1*((a + b) / 2) + ((c + d) / 2)
c3 := -1*((b + c) / 2) + ((a + d) / 2)
"

pull_defined <- function(fit) {
  pe <- parameterEstimates(fit)
  hit <- pe[pe$op == ":=", c("label", "est")]
  est <- hit$est
  names(est) <- hit$label
  if (!all(c("c1", "c2", "c3") %in% names(est))) {
    return(c(c1 = NA_real_, c2 = NA_real_, c3 = NA_real_))
  }
  est[c("c1", "c2", "c3")]
}

fit_moments <- function(model, mom, nobs = 1e7, likelihood = "default", estimator = "ML") {
  sem(model, sample.cov = mom$cov, sample.mean = mom$mean,
      sample.nobs = rep(nobs, 4), likelihood = likelihood,
      estimator = estimator, meanstructure = TRUE, warn = FALSE,
      auto.fix.first = FALSE)
}

row_of <- function(reading, population, analysis, est, note) {
  data.frame(
    reading = reading,
    population = population,
    analysis = analysis,
    c1 = unname(est[["c1"]]),
    c2 = unname(est[["c2"]]),
    c3 = unname(est[["c3"]]),
    gap_c1 = unname(est[["c1"]]) - defined[["c1"]],
    note = note,
    stringsAsFactors = FALSE
  )
}

pops <- list(
  prose = moments(rep(0.7, 4), 0.5, 0.51, 1, alpha),
  appendix = moments(c(1, 0.7, 0.7, 0.7), 0.5, 0.51, 1, alpha),
  unit_variance = moments(rep(0.7, 4), 1, 0.51, 1, alpha)
)

specs <- list(
  list("prose loadings 0.7, marker loading 1, first intercept 0", "prose", mg_marker,
       "Chapter III loading, marker identification"),
  list("prose loadings 0.7, OSF common-intercept marker", "prose", mg_osf,
       "OSF syntax on the equal-loading population"),
  list("prose loadings 0.7, loadings and intercepts fixed", "prose", mg_fixed_loading,
       "analysis fixes the generating measurement"),
  list("prose loadings 0.7, factor variance fixed at 0.5", "prose", mg_psi_fixed,
       "scale set by the factor variance"),
  list("appendix parse, OSF common-intercept marker", "appendix", mg_osf,
       "lavaan-parsed appendix population, OSF analysis"),
  list("appendix parse, marker loading 1, first intercept 0", "appendix", mg_marker,
       "Hancock marker on the parsed population"),
  list("appendix parse, first group mean fixed at 0", "appendix", mg_ref0,
       "reference-group mean fixed"),
  list("appendix parse, loadings fixed at 0.7", "appendix", mg_fixed_loading,
       "fixed loadings on a population whose first loading is 1"),
  list("factor variance 1 and loadings 0.7, marker", "unit_variance", mg_marker,
       "standardized factor, marker loading 1"),
  list("factor variance 1 and loadings 0.7, OSF marker", "unit_variance", mg_osf,
       "standardized factor, OSF syntax")
)

rows <- lapply(specs, function(sp) {
  fit <- tryCatch(fit_moments(sp[[3]], pops[[sp[[2]]]]), error = function(e) e)
  if (inherits(fit, "error")) {
    return(row_of(sp[[1]], sp[[2]], "moment ML", c(c1 = NA, c2 = NA, c3 = NA),
                  paste("failed:", conditionMessage(fit))))
  }
  row_of(sp[[1]], sp[[2]], "moment ML", pull_defined(fit), sp[[4]])
})

# Normal versus Wishart at the appendix moments. MLR needs raw data, so that
# comparison is made on the simulated sample below.
base <- fit_moments(mg_osf, pops$appendix, estimator = "ML")
wish <- fit_moments(mg_osf, pops$appendix, likelihood = "wishart")
rows <- c(rows, list(
  row_of("appendix, OSF syntax, Wishart likelihood", "appendix", "moment Wishart",
         pull_defined(wish), "n-1 covariance likelihood")
))
ml_est <- pull_defined(base)
wish_est <- pull_defined(wish)

# One large sample from each population. Seed 13131.
simulate_pop <- function(lambda, psi, theta, n_per) {
  set.seed(13131)
  parts <- lapply(seq_along(alpha), function(g) {
    eta <- rnorm(n_per, alpha[[g]], sqrt(psi))
    x <- sapply(seq_along(lambda), function(j) {
      1 + lambda[[j]] * eta + rnorm(n_per, 0, sqrt(theta))
    })
    data.frame(i1 = x[, 1], i2 = x[, 2], i3 = x[, 3], i4 = x[, 4], subgroup = g)
  })
  dat <- do.call(rbind, parts)
  sg <- dat$subgroup
  dat$subgroup <- factor(sg)
  dat$c1 <- factor(ifelse(sg %in% c(1, 3), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
  dat$c2 <- factor(ifelse(sg %in% c(1, 2), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
  dat$c3 <- factor(ifelse(sg %in% c(1, 4), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
  dat$n1 <- ifelse(sg %in% c(1, 3), -1, 1)
  dat$n2 <- ifelse(sg %in% c(1, 2), -1, 1)
  dat$n3 <- ifelse(sg %in% c(1, 4), -1, 1)
  dat
}

mimic_free <- "
eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ 1 + c1 + c2 + c3
i1 + i2 + i3 + i4 ~ eq*1
"
mimic_posted <- "
eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ c1 + c2 + c3
i1 + i2 + i3 + i4 ~ eq*1
"
mimic_numeric <- "
eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ 1 + n1 + n2 + n3
i1 + i2 + i3 + i4 ~ eq*1
"

pull_slopes <- function(fit, names) {
  pe <- parameterEstimates(fit)
  hit <- pe[pe$lhs == "eta" & pe$op == "~" & pe$rhs %in% names, c("rhs", "est")]
  est <- hit$est
  names(est) <- hit$rhs
  if (!all(names %in% names(est))) {
    return(c(c1 = NA_real_, c2 = NA_real_, c3 = NA_real_))
  }
  out <- est[names]
  names(out) <- c("c1", "c2", "c3")
  out
}

dat_app <- simulate_pop(c(1, 0.7, 0.7, 0.7), 0.5, 0.51, 20000)
dat_prose <- simulate_pop(rep(0.7, 4), 0.5, 0.51, 20000)

fit_data <- function(model, dat, ...) {
  sem(model, data = dat, estimator = "ML", warn = FALSE, ...)
}

fit_app_ml <- fit_data(mg_osf, dat_app, group = "subgroup", meanstructure = TRUE)
fit_app_mlr <- sem(mg_osf, data = dat_app, group = "subgroup", estimator = "MLR",
                   meanstructure = TRUE, warn = FALSE)
rows <- c(rows, list(
  row_of("simulated appendix, OSF syntax, ML", "appendix", "N=20000 per group",
         pull_defined(fit_app_ml), "seed 13131"),
  row_of("simulated appendix, OSF syntax, MLR", "appendix", "N=20000 per group",
         pull_defined(fit_app_mlr), "same sample as the ML row"),
  row_of("simulated prose, marker intercept 0", "prose", "N=20000 per group",
         pull_defined(fit_data(mg_marker, dat_prose, group = "subgroup", meanstructure = TRUE)),
         "cross-check of the equal-loading marker"),
  row_of("MIMIC, free latent intercept, factor codes", "appendix", "lavaan sem",
         pull_slopes(fit_data(mimic_free, dat_app), c("c1", "c2", "c3")),
         "eta ~ 1 + c1 + c2 + c3"),
  row_of("MIMIC, posted syntax, latent intercept fixed", "appendix", "lavaan sem",
         pull_slopes(fit_data(mimic_posted, dat_app), c("c1", "c2", "c3")),
         "eta ~ c1 + c2 + c3"),
  row_of("MIMIC, numeric codes -1 and 1, free intercept", "appendix", "lavaan sem",
         pull_slopes(fit_data(mimic_numeric, dat_app), c("n1", "n2", "n3")),
         "slope per unit of a two-unit code")
))

dat_fx <- dat_app
contrasts(dat_fx$c1) <- contr.sum(2)
contrasts(dat_fx$c2) <- contr.sum(2)
contrasts(dat_fx$c3) <- contr.sum(2)
sg <- as.integer(as.character(dat_app$subgroup))
dat_app$e1 <- ifelse(sg %in% c(1, 3), 1, -1)
dat_app$e2 <- ifelse(sg %in% c(1, 2), 1, -1)
dat_app$e3 <- ifelse(sg %in% c(1, 4), 1, -1)
mimic_effects <- "
eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ 1 + e1 + e2 + e3
i1 + i2 + i3 + i4 ~ eq*1
"
rows <- c(rows, list(
  row_of("MIMIC, contr.sum on the factors, free intercept", "appendix", "lavaan sem",
         pull_slopes(fit_data(mimic_free, dat_fx), c("c1", "c2", "c3")),
         "contrasts() set to contr.sum; lavaan may ignore it"),
  row_of("MIMIC, numeric effects codes +1 and -1", "appendix", "lavaan sem",
         pull_slopes(fit_data(mimic_effects, dat_app), c("e1", "e2", "e3")),
         "explicit effects codes")
))

# Finite-sample ML versus Wishart on one N=240 appendix sample.
set.seed(13131)
small <- simulate_pop(c(1, 0.7, 0.7, 0.7), 0.5, 0.51, 60)
# simulate_pop resets the seed, so rebuild with the subgroup sizes only.
fit_s_ml <- fit_data(mg_osf, small, group = "subgroup", meanstructure = TRUE)
fit_s_w <- sem(mg_osf, data = small, group = "subgroup", estimator = "ML",
               likelihood = "wishart", meanstructure = TRUE, warn = FALSE)
rows <- c(rows, list(
  row_of("N=240 equal groups, normal likelihood", "appendix", "one sample",
         pull_defined(fit_s_ml), "seed 13131"),
  row_of("N=240 equal groups, Wishart likelihood", "appendix", "one sample",
         pull_defined(fit_s_w), "same sample as the normal-likelihood row")
))

tab <- do.call(rbind, rows)
write.csv(tab, file.path(out_dir, "candidate_readings.csv"), row.names = FALSE)

scale_note <- data.frame(
  comparison = c(
    "moment ML minus moment Wishart",
    "sample ML minus sample MLR",
    "normal minus Wishart at N=240"
  ),
  c1 = c(ml_est[["c1"]] - wish_est[["c1"]],
         pull_defined(fit_app_ml)[["c1"]] - pull_defined(fit_app_mlr)[["c1"]],
         pull_defined(fit_s_ml)[["c1"]] - pull_defined(fit_s_w)[["c1"]]),
  c2 = c(ml_est[["c2"]] - wish_est[["c2"]],
         pull_defined(fit_app_ml)[["c2"]] - pull_defined(fit_app_mlr)[["c2"]],
         pull_defined(fit_s_ml)[["c2"]] - pull_defined(fit_s_w)[["c2"]]),
  c3 = c(ml_est[["c3"]] - wish_est[["c3"]],
         pull_defined(fit_app_ml)[["c3"]] - pull_defined(fit_app_mlr)[["c3"]],
         pull_defined(fit_s_ml)[["c3"]] - pull_defined(fit_s_w)[["c3"]])
)
write.csv(scale_note, file.path(out_dir, "likelihood_differences.csv"), row.names = FALSE)

# Appendix string as lavaan and simsem parse it.
printed <- "
eta =~ NA*i1 + 0.7*i1 + 0.7*i2 + 0.7*i3 + 0.7*i4
eta ~~ .5*eta
i1 ~~ 0.51*i1
i1 ~ 1*
i2 ~~ 0.51*i2
i2 ~ 1*1
i3 ~~ 0.51*i3
i3 ~ 1*1
i4 ~~ 0.51*i4
i4 ~ 1*1
eta ~ c(1, .6, .8, .4)*1
"
repaired <- sub("i1 ~ 1\\*", "i1 ~ 1*1", printed, fixed = FALSE)
pt <- lavaanify(repaired, ngroups = 4, auto = TRUE)
loadings <- pt[pt$op == "=~", c("lhs", "rhs", "group", "free", "ustart", "label")]
write.csv(loadings, file.path(out_dir, "appendix_lavaanify.csv"), row.names = FALSE)

parser <- data.frame(
  software = character(), check = character(), result = character(),
  stringsAsFactors = FALSE
)
add_parser <- function(software, check, result) {
  parser[nrow(parser) + 1, ] <<- list(software, check, result)
}
broken <- tryCatch(lavaanify(printed, ngroups = 4), error = function(e) conditionMessage(e))
add_parser("lavaan 0.6.17", "significance string i1 ~ 1*",
           if (inherits(try(lavaanify(printed), silent = TRUE), "try-error")) broken else "parsed")
add_parser("lavaan 0.6.17", "null-model repair i1 ~ 1*1", "parsed")

one_group <- "
eta =~ NA*i1 + 0.7*i1 + 0.7*i2 + 0.7*i3 + 0.7*i4
eta ~~ 0.5*eta
i1 ~~ 0.51*i1
i2 ~~ 0.51*i2
i3 ~~ 0.51*i3
i4 ~~ 0.51*i4
i1 ~ 1*1
i2 ~ 1*1
i3 ~ 1*1
i4 ~ 1*1
eta ~ 1*1
"
set.seed(13131)
drawn <- simulateData(one_group, sample.nobs = 20000, model.type = "sem")
add_parser("lavaan simulateData", "mean i1 at factor mean 1",
           sprintf("%.4f", mean(drawn$i1)))
add_parser("lavaan simulateData", "mean i2 at factor mean 1",
           sprintf("%.4f", mean(drawn$i2)))
add_parser("lavaan simulateData", "variance i1",
           sprintf("%.4f", var(drawn$i1)))
add_parser("lavaan simulateData", "variance i2",
           sprintf("%.4f", var(drawn$i2)))

sim_try <- tryCatch({
  simsem::sim(
    nRep = 1, model = mg_osf, n = list(400, 400, 400, 400),
    generate = repaired, lavaanfun = "sem", seed = 13131, multicore = FALSE
  )
}, error = function(e) e)
if (inherits(sim_try, "error")) {
  add_parser("simsem 0.5.17", "sim() on the repaired appendix string",
             paste("failed:", conditionMessage(sim_try)))
} else {
  add_parser("simsem 0.5.17", "sim() on the repaired appendix string", "returned a fit")
}
broken_sim <- tryCatch({
  simsem::sim(
    nRep = 1, model = mg_osf, n = list(50, 50, 50, 50),
    generate = printed, lavaanfun = "sem", seed = 1, multicore = FALSE
  )
}, error = function(e) conditionMessage(e))
add_parser("simsem 0.5.17", "sim() on the printed i1 ~ 1* string",
           if (inherits(broken_sim, "character")) substr(broken_sim, 1, 180) else "returned a fit")

write.csv(parser, file.path(out_dir, "parser_checks.csv"), row.names = FALSE)
print(tab[, c("reading", "c1", "c2", "c3", "gap_c1")])
print(parser)
message("wrote ", out_dir)
