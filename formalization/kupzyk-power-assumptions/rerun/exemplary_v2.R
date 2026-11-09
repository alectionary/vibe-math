# Independent fresh masks and an exhaustive scan over the printed size arrays.
source('formalization/kupzyk-power-assumptions/rerun/profile_reml.R')
out <- commandArgs(TRUE)[[1]]
dir.create(out,recursive=TRUE,showWarnings=FALSE)
targets <- read.csv(file.path(study,'outputs/targets.csv'))
thresholds <- read.csv(file.path(study,'outputs/threshold-targets.csv'))
set.seed(20361109)
scales <- c(.05,.10,.15)
Jinitial <- c(16,22,28)
estimate <- function(J,icc,a,p,size,B) {
 if(a==0) B <- 1L
 pp <- replicate(B,{
  d <- design(J,icc,a,p,size)
  v <- known_variance(as.integer(d$k),as.integer(d$cluster),J,
                      as.integer(sasround(J*(1-p))),icc)
  power_value(v,sum(d$k)-J-2)
 })
 c(power=mean(pp),mask_sd=if(B>1) sd(pp) else 0,
   mask_se=if(B>1) sd(pp)/sqrt(B) else 0,
   lower=unname(quantile(pp,.025)),upper=unname(quantile(pp,.975)),
   below80=mean(pp<.8),masks=B)
}
check <- lapply(seq_len(nrow(targets)),function(i) {
 r <- targets[i,];d <- design(r$J,r$icc,r$attrition,r$treat,r$size)
 c(cell=i,compact=known_variance(as.integer(d$k),as.integer(d$cluster),r$J,
                                as.integer(sasround(r$J*(1-r$treat))),r$icc),
   dense=info_dense(d,r$icc),block=info_blocks(d,r$icc))
})
check <- as.data.frame(do.call(rbind,check))
stopifnot(max(abs(check$compact-check$dense))<1e-10,max(abs(check$compact-check$block))<1e-10)
write.csv(check,file.path(out,'fresh-gls-validation.csv'),row.names=FALSE)
task <- function(i) {
 r <- targets[i,];icc <- r$icc;a <- r$attrition;p <- r$treat;sz <- r$size
 ii <- match(icc,scales);J0 <- Jinitial[ii]
 set.seed(20730000L+i)
 core <- rbind(c(cell=i,stage=0,J=J0,estimate(J0,icc,a,p,sz,1500)),
               c(cell=i,stage=1,J=r$J,estimate(r$J,icc,a,p,sz,2500)))
 # Printed unequal-size arrays cover J=13..41. Allocation rounding can make
 # power nonmonotone, so inspect every available J through the final design bound.
 js <- if(sz==1) 4:41 else 13:41
 scan <- lapply(js,function(j)c(cell=i,J=j,published_min=thresholds$required_J[i],
                               estimate(j,icc,a,p,sz,500)))
 list(core=core,scan=do.call(rbind,scan))
}
jobs <- parallel::mclapply(seq_len(nrow(targets)),task,mc.cores=2L)
stopifnot(all(vapply(jobs,is.list,logical(1))))
write.csv(do.call(rbind,lapply(jobs,'[[','core')),file.path(out,'exemplary-v2.csv'),row.names=FALSE)
write.csv(do.call(rbind,lapply(jobs,'[[','scan')),file.path(out,'threshold-scan.csv'),row.names=FALSE)
os <- list()
for(k in 1:3)for(a in c(.05,.15)) {
 icc <- scales[k];J <- if(a==.05)c(15,22,29)[k]else c(19,28,36)[k]
 os[[length(os)+1L]] <- c(icc=icc,attrition=a,J=J,estimate(J,icc,a,.5,1,10000))
}
write.csv(do.call(rbind,os),file.path(out,'oversampling-v2.csv'),row.names=FALSE)
