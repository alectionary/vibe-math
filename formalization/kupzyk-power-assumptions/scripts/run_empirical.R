source('formalization/kupzyk-power-assumptions/scripts/model.R')
targets<-read.csv(file.path(base,'outputs/targets.csv'))
# Predeclared after 54-cell pilot: 400 per cell, 12000 total baseline,
# 2000 null draws at first/last cells. Save each batch atomically.
jobs<-list()
add<-function(cell,reps,effect=.5,generator='components',tag='main'){
 for(start in seq(1,reps,100)) jobs[[length(jobs)+1]]<<-list(cell=cell,start=start,n=min(100,reps-start+1),effect=effect,generator=generator,tag=tag)
}
for(i in 1:54)add(i,400)
add(1,11600,tag='baseline-extra')
for(i in c(1,54))add(i,2000,effect=0,tag='null')
for(i in c(1,18,37,54))add(i,200,generator='dense',tag='independent-generator')
dir.create(file.path(base,'outputs/checkpoints'),showWarnings=FALSE)
runjob<-function(job){
 path<-file.path(base,'outputs/checkpoints',sprintf('%s-%02d-%05d.csv',job$tag,job$cell,job$start))
 if(file.exists(path))return(path)
 seed<-20261029L+job$cell*100000L+job$start+match(job$tag,c('main','baseline-extra','null','independent-generator'))*10000000L
 set.seed(seed);r<-targets[job$cell,];J<-c(16,22,28)[match(r$icc,c(.05,.1,.15))]
 out<-lapply(seq_len(job$n),function(k){d<-design(J,r$icc,r$attrition,r$treat,r$size,FALSE);z<-generate(d,r$icc,job$effect,job$generator);fit<-fit_empirical(z)
  # Retry genuine optimizer issues; keep boundary solutions and record retry.
  retried<-0
  if(!isTRUE(fit['converged']==1)){fit2<-fit_empirical(z,optimizer='nloptwrap');retried<-1;if(isTRUE(fit2['converged']==1))fit<-fit2}
  data.frame(cell=job$cell,rep=job$start+k-1,tag=job$tag,seed=seed,effect=job$effect,generator=job$generator,retried=retried,t(fit))
 })
 write.csv(do.call(rbind,out),paste0(path,'.tmp'),row.names=FALSE);file.rename(paste0(path,'.tmp'),path);path
}
paths<-unlist(parallel::mclapply(jobs,runjob,mc.cores=3,mc.preschedule=FALSE))
write.csv(do.call(rbind,lapply(paths,read.csv)),file.path(base,'outputs/empirical-draws.csv'),row.names=FALSE)
