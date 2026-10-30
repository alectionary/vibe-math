source('formalization/kupzyk-power-assumptions/scripts/model.R');set.seed(42910)
# Table3 first-ICC high-attrition cell has a larger supporting gap: inspect
# predictive tails, not a Gaussian approximation to a skewed mask distribution.
B<-10000
pp<-replicate(B,{d<-design(19,.05,.15,.5,1);exemplary(d,.05)['power']})
write.csv(data.frame(rep=1:B,power=pp),file.path(base,'outputs/table3-gap-masks.csv'),row.names=FALSE)
write.csv(data.frame(published=.88187,ours=mean(pp),sd=sd(pp),min=min(pp),q001=quantile(pp,.001),q01=quantile(pp,.01),q025=quantile(pp,.025),q975=quantile(pp,.975),two_sided_rank_p=2*min((1+sum(pp<=.88187))/(B+1),(1+sum(pp>=.88187))/(B+1))),file.path(base,'outputs/table3-gap-summary.csv'),row.names=FALSE)
# Formula, df, allocation and mask-allocation sensitivities on the same condition.
out<-list()
for(J in c(18,19,20))for(mode in c('bw','od','person','nominal')){
 p<-replicate(200,{d<-design(J,.05,.15,.5,1);exemplary(d,.05,mode)['power']})
 out[[length(out)+1]]<-data.frame(J=J,dfmode=mode,mean=mean(p),sd=sd(p))
}
write.csv(do.call(rbind,out),file.path(base,'outputs/table3-sensitivities.csv'),row.names=FALSE)
# Explicit alternatives to the Appendix B arrangement/rounding are diagnostic,
# not quietly substituted into the replication.
targets<-read.csv(file.path(base,'outputs/targets.csv'));aout<-list()
for(i in which(targets$attrition==0)){
 r<-targets[i,];d<-design(r$J,r$icc,0,r$treat,r$size)
 d_bank<-d;d_bank$group<-as.integer(d$cluster>round(r$J*(1-r$treat)))
 ns<-sort(sizes(r$J,r$size));cl<-rep(1:r$J,ns);ds<-data.frame(person=1:sum(ns),cluster=cl,group=as.integer(cl>sasround(r$J*(1-r$treat))),k=4)
 aout[[length(aout)+1]]<-data.frame(cell=i,source=exemplary(d,r$icc)['power'],ties_even=exemplary(d_bank,r$icc)['power'],sorted_sizes=exemplary(ds,r$icc)['power'])
}
write.csv(do.call(rbind,aout),file.path(base,'outputs/allocation-sensitivities.csv'),row.names=FALSE)
