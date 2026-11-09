# The source's two published corners, alternative and null. Match main seeds.
source('formalization/kupzyk-power-assumptions/rerun/kenward_roger.R')
out <- commandArgs(TRUE)[[1]]
dir.create(out,recursive=TRUE,showWarnings=FALSE)
targets <- read.csv(file.path(study,'outputs/targets.csv'))
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
 counts <- replicate(200,{
  d <- design(J,r$icc,r$attrition,r$treat,r$size,FALSE)
  y <- generate_response(d,r$icc,effect)
  f <- fit_profile(d,y,r$icc)
  if (f[['converged']]!=1) c(kr=NA_real_,drop=NA_real_) else {
    p <- kr_scalar(d,f)[['p']]
    boundary <- f[['boundary']]==1L
    p_drop <- if(boundary) kr_scalar(d,f,drop_boundary=TRUE)[['p']] else p
    c(kr=as.integer(p<=.05),drop=as.integer(p_drop<=.05))
  }
 })
 result <- data.frame(job,attempted=ncol(counts),kr_valid=sum(is.finite(counts[1,])),
                      kr_reject=sum(counts[1,],na.rm=TRUE),
                      drop_valid=sum(is.finite(counts[2,])),
                      drop_reject=sum(counts[2,],na.rm=TRUE))
 write.csv(result,paste0(path,'.tmp'),row.names=FALSE)
 stopifnot(file.rename(paste0(path,'.tmp'),path))
 TRUE
}
stopifnot(all(vapply(parallel::mclapply(seq_len(nrow(jobs)),one,mc.cores=2L),isTRUE,logical(1))))
