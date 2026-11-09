# Run from the repository root: Rscript --vanilla .../rerun/full_grid.R OUT WORKERS
source('formalization/kupzyk-power-assumptions/rerun/profile_reml.R')
args <- commandArgs(TRUE)
stopifnot(length(args)==2L)
out <- args[[1]]
workers <- as.integer(args[[2]])
stopifnot(!is.na(workers),workers>=1L)
dir.create(out,recursive=TRUE,showWarnings=FALSE)
writeLines(capture.output(sessionInfo()),file.path(out,'session-info.txt'))
targets <- read.csv(file.path(study,'outputs/targets.csv'))
stopifnot(identical(targets$cell,1:54))
batch <- 200L
# Disjoint named substreams. Null runs cover the two published cases for BW
# and J−2 only; SAS containment and the small-sample adjustments are separate.
jobs <- rbind(
  expand.grid(cell=1:54,block=1:128,arm='main'),
  expand.grid(cell=1L,block=1:250,arm='baseline-followup'),
  expand.grid(cell=c(1L,54L),block=1:128,arm='null'))
jobs$seed <- 20270001L+seq_len(nrow(jobs))
jobs <- jobs[order(jobs$block,jobs$arm,jobs$cell),]
run_job <- function(k) {
  j <- jobs[k,]
  fn <- file.path(out,sprintf('%s-%02d-%03d.csv',j$arm,j$cell,j$block))
  if (file.exists(fn)) return(TRUE)
  set.seed(j$seed)
  r <- targets[j$cell,]
  J <- c(16,22,28)[match(r$icc,c(.05,.10,.15))]
  effect <- if (j$arm=='null') 0 else .5
  draws <- replicate(batch,{
    d <- design(J,r$icc,r$attrition,r$treat,r$size,FALSE)
    z <- generate(d,r$icc,effect)
    f <- fit_profile(d,z,r$icc)
    t <- abs(f[['beta']]/f[['se']])
    c(f,bw=as.integer(2*pt(-t,nrow(z)-J-2)<=.05),
      od=as.integer(2*pt(-t,J-2)<=.05),
      icc_hat=f[['cluster_slope']]/(f[['cluster_slope']]+f[['person_slope']]))
  })
  valid <- draws['converged',]==1 & is.finite(draws['bw',])
  sums <- rowSums(draws[,valid,drop=FALSE],na.rm=TRUE)
  squares <- rowSums(draws[,valid,drop=FALSE]^2,na.rm=TRUE)
  row <- data.frame(j,attempted=batch,valid=sum(valid),t(sums),
                    t(setNames(squares,paste0(names(squares),'_sq'))),check.names=FALSE)
  write.csv(row,paste0(fn,'.tmp'),row.names=FALSE)
  stopifnot(file.rename(paste0(fn,'.tmp'),fn))
  TRUE
}
results <- parallel::mclapply(seq_len(nrow(jobs)),run_job,mc.cores=workers)
stopifnot(all(vapply(results,isTRUE,logical(1))))
