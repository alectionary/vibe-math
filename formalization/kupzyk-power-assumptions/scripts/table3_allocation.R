source('formalization/kupzyk-power-assumptions/scripts/model.R');set.seed(932718)
x<-do.call(rbind,lapply(1:1000,function(i){d<-design(19,.05,.15,.5,1);v<-exemplary(d,.05);d2<-d;d2$group<-as.integer(d2$cluster>9);v2<-exemplary(d2,.05);data.frame(rep=i,source_halfup=v['power'],alternate_floor=v2['power'],M=sum(d$k),df=v['df'])}))
write.csv(x,file.path(base,'outputs/table3-allocation.csv'),row.names=FALSE)
write.csv(data.frame(source_mean=mean(x$source_halfup),alternate_mean=mean(x$alternate_floor),maximum_paired_change=max(abs(x$source_halfup-x$alternate_floor)),M=x$M[1],df=x$df[1]),file.path(base,'outputs/table3-allocation-summary.csv'),row.names=FALSE)
