source('formalization/kupzyk-power-assumptions/scripts/model.R');set.seed(91591)
out<-list()
for(size in 1:3)for(p in c(.5,.7)){
 pp<-replicate(1000,{d<-design(19,.05,.15,p,size);exemplary(d,.05)['power']})
 out[[length(out)+1]]<-data.frame(size=size,treat=p,mean=mean(pp),sd=sd(pp),q025=quantile(pp,.025),q975=quantile(pp,.975),rank_p=2*min((1+sum(pp<=.88187))/1001,(1+sum(pp>=.88187))/1001))
}
write.csv(do.call(rbind,out),file.path(base,'outputs/table3-alternatives.csv'),row.names=FALSE)
# Deterministically regenerate the most extreme original diagnostic draw and
# check the alternate dense covariance implementation on those exact rows.
set.seed(42910);lowest<-Inf;best<-NULL;bi<-0
for(i in 1:10000){d<-design(19,.05,.15,.5,1);v<-exemplary(d,.05)['power'];if(v<lowest){lowest<-v;best<-d;bi<-i}}
write.csv(best,file.path(base,'outputs/table3-extreme-mask.csv'),row.names=FALSE)
write.csv(data.frame(draw=bi,block=lowest,dense=exemplary(best,.05,dense=TRUE)['power']),file.path(base,'outputs/table3-independent-check.csv'),row.names=FALSE)
