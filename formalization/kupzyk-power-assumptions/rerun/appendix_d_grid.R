source('formalization/kupzyk-power-assumptions/rerun/appendix_d.R')
out <- commandArgs(TRUE)[[1]]
dir.create(out,recursive=TRUE,showWarnings=FALSE)
targets <- read.csv(file.path(study,'outputs/targets.csv'))
# Replay the corresponding baseline and extreme streams to pair all four
# denominator rules; keep this separate from the already-running main grid.
jobs <- rbind(expand.grid(cell=1:54,block=1:128,arm='main'),
              expand.grid(cell=1L,block=1:250,arm='baseline-followup'),
              expand.grid(cell=c(1L,54L),block=1:128,arm='null'))
jobs$seed <- 20270001L+seq_len(nrow(jobs))
jobs <- subset(jobs,cell %in% c(1L,54L) & arm %in% c('main','null'))
jobs <- jobs[order(jobs$block,jobs$cell,jobs$arm),]
one <- function(i) {
 job <- jobs[i,]
 path <- file.path(out,sprintf('%s-%02d-%03d.csv',job$arm,job$cell,job$block))
 if(file.exists(path)) return(TRUE)
 set.seed(job$seed)
 r <- targets[job$cell,]
 J <- if(job$cell==1L) 16L else 28L
 effect <- if(job$arm=='null') 0 else .5
 v <- replicate(200,{
  d <- design(J,r$icc,r$attrition,r$treat,r$size,FALSE)
  z <- generate(d,r$icc,effect)
  f <- fit_profile(d,z,r$icc)
  if (f[['converged']]!=1) rep(NA_integer_,4) else {
   test <- abs(f[['beta']]/f[['se']])
   df <- c(od=J-2,bw=nrow(z)-J-2,containment=containment_df(d),sat=sat_df(d,z,f))
   as.integer(2*pt(-test,df)<=.05)
  }
 })
 rownames(v) <- c('od','bw','containment','sat')
 res <- data.frame(job, attempted=ncol(v),t(rowSums(!is.na(v))),t(rowSums(v,na.rm=TRUE)))
 names(res)[6:13] <- c(paste0(rownames(v),'_valid'),paste0(rownames(v),'_reject'))
 write.csv(res,paste0(path,'.tmp'),row.names=FALSE)
 stopifnot(file.rename(paste0(path,'.tmp'),path))
 TRUE
}
stopifnot(all(vapply(parallel::mclapply(seq_len(nrow(jobs)),one,mc.cores=2L),isTRUE,logical(1))))
