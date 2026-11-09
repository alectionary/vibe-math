# Reuse the 50,000-draw baseline stream. Change only the covariance used in the test.
source('formalization/kupzyk-power-assumptions/rerun/profile_reml.R')
source(file.path(study,'rerun/fast_generator.R'))
args <- commandArgs(TRUE)
stopifnot(length(args)==2L)
workers <- as.integer(args[2])
stopifnot(!is.na(workers),workers>=1L)
design0 <- design(16L,.05,0,.5,1L,FALSE)
known_se <- sqrt(info_dense(design0,.05))
known_theta <- c(.4,1.9,.2,.1)
critical <- qt(.975,1262)
first_seed <- 20270001L+54L*128L
one <- function(block) {
  set.seed(first_seed+block)
  t(replicate(200L,{
    y <- generate_response(design0,.05,.5)
    f <- fit_profile(design0,y,.05)
    stopifnot(f[['converged']]==1)
    stats <- reml_statistics(as.integer(design0$k),as.integer(design0$cluster),y,16L)
    known <- reml_eval(known_theta,stats,8L,TRUE)
    c(known=as.integer(abs(known[['beta']]/known_se)>critical),
      refit=as.integer(abs(f[['beta']]/f[['se']])>critical))
  }))
}
rows <- do.call(rbind,parallel::mclapply(seq_len(250L),one,mc.cores=workers))
stopifnot(nrow(rows)==50000L)
gap <- rows[,'refit']-rows[,'known']
write.csv(data.frame(draws=nrow(rows),known_rejections=sum(rows[,'known']),
                     refit_rejections=sum(rows[,'refit']),known_power=mean(rows[,'known']),
                     refit_power=mean(rows[,'refit']),refit_minus_known=mean(gap),
                     paired_mcse=sd(gap)/sqrt(length(gap)),known_se=known_se,
                     theoretical_fixed_power=power_value(known_se^2,1262)),
          args[1],row.names=FALSE)
