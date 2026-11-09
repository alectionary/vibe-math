source('formalization/kupzyk-power-assumptions/rerun/profile_reml.R')
source(file.path(study,'rerun/fast_generator.R'))
out <- commandArgs(TRUE)[[1]]
dir.create(out,recursive=TRUE,showWarnings=FALSE)
# Refit matched simulations and vary only the denominator degrees of freedom.
jobs <- rbind(expand.grid(cell=1:54,block=1:128,arm='main'),
              expand.grid(cell=1L,block=1:250,arm='baseline-followup'),
              expand.grid(cell=c(1L,54L),block=1:128,arm='null'))
jobs$seed <- 20270001L+seq_len(nrow(jobs))
jobs <- subset(jobs,cell==54L & arm %in% c('main','null'))
dfs <- c(12:26,60,1000)
one <- function(i) {
  job <- jobs[i,]
  set.seed(job$seed)
  effect <- if(job$arm=='null') 0 else .5
  v <- replicate(200,{
    d <- design(28,.15,.15,.7,3,FALSE)
    y <- generate_response(d,.15,effect)
    f <- fit_profile(d,y,.15)
    stopifnot(f[['converged']]==1)
    as.integer(2*pt(-abs(f[['beta']]/f[['se']]),dfs)<=.05)
  })
  data.frame(arm=job$arm,df=dfs,n=200,reject=rowSums(v))
}
a <- do.call(rbind,parallel::mclapply(seq_len(nrow(jobs)),one,mc.cores=4L))
a <- aggregate(cbind(n,reject)~arm+df,a,sum)
a$rate <- a$reject/a$n
write.csv(a,file.path(out,'appendix-d2-df-sweep.csv'),row.names=FALSE)
