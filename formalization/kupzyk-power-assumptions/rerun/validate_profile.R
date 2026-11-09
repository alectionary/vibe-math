source('formalization/kupzyk-power-assumptions/rerun/profile_reml.R')
targets <- read.csv(file.path(study,'outputs/targets.csv'))
set.seed(20261109)
compare <- function(i) {
  r <- targets[i,]; J <- c(16,22,28)[match(r$icc,c(.05,.10,.15))]
  d <- design(J,r$icc,r$attrition,r$treat,r$size,FALSE)
  z <- generate(d,r$icc,method=if (i%%2L) 'components' else 'dense')
  f <- fit_profile(d,z,r$icc)
  g <- fit_empirical(z)
  h <- if (i %% 3L == 1L) fit_empirical(z, engine='nlme') else c(beta=NA,se=NA,converged=NA)
  c(cell=i, profile_ok=f[['converged']], lme4_ok=g[['converged']], nlme_ok=h[['converged']],
    profile_boundary=f[['boundary']], lme4_boundary=g[['singular']],
    profile_beta=f[['beta']], lme4_beta=g[['beta']], nlme_beta=h[['beta']],
    profile_se=f[['se']], lme4_se=g[['se']], nlme_se=h[['se']])
}
result <- as.data.frame(do.call(rbind,lapply(seq_len(nrow(targets)),compare)))
write.csv(result,commandArgs(TRUE)[1],row.names=FALSE)
both <- with(result,profile_ok==1 & lme4_ok==1)
stopifnot(sum(both) >= 50L,
          max(abs(result$profile_beta[both]-result$lme4_beta[both])) < 2e-4,
          max(abs(result$profile_se[both]-result$lme4_se[both])) < 2e-4)
