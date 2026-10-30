source('formalization/kupzyk-power-assumptions/scripts/model.R')
targets<-read.csv(file.path(base,'outputs/targets.csv'));thresholds<-read.csv(file.path(base,'outputs/threshold-targets.csv'))
set.seed(581019)
results<-list();checks<-list();draws<-list();th<-list()
for(i in 1:54){
 r<-targets[i,];B<-if(r$attrition==0)1 else 1000
 vals<-matrix(NA,B,4);colnames(vals)<-c('bw','od','person','nominal')
 for(b in 1:B){d<-design(r$J,r$icc,r$attrition,r$treat,r$size);v<-info_blocks(d,r$icc)
  dfs<-c(sum(d$k)-r$J-2,r$J-2,sum(d$k)-nrow(d)-2,r$J*80-r$J-2)
  vals[b,]<-vapply(dfs,function(df)power_value(v,df),numeric(1))
  if(b==1){vd<-info_dense(d,r$icc);checks[[i]]<-data.frame(cell=i,block=v,dense=vd,error=abs(v-vd));stopifnot(abs(v-vd)<1e-10)}
 }
 results[[i]]<-data.frame(r,ours=mean(vals[,1]),mask_sd=if(B>1)sd(vals[,1])else 0,mean_se=if(B>1)sd(vals[,1])/sqrt(B)else 0,masks=B,
  q025=quantile(vals[,1],.025),q975=quantile(vals[,1],.975),od=mean(vals[,2]),person=mean(vals[,3]),nominal=mean(vals[,4]))
 draws[[i]]<-data.frame(cell=i,rep=1:B,vals)
 write.csv(do.call(rbind,results),file.path(base,'outputs/exemplary.csv'),row.names=FALSE)
 # Verify reported threshold J and J-1; J12 has no printed unequal-size array.
 for(J in c(thresholds$required_J[i]-1,thresholds$required_J[i])){
  if(J<13 && r$size!=1){th[[length(th)+1]]<-data.frame(cell=i,J=J,mean=NA,sd=NA,above=NA,masks=0);next}
  Bth<-if(r$attrition==0)1 else 200
  pp<-replicate(Bth,{d<-design(J,r$icc,r$attrition,r$treat,r$size);exemplary(d,r$icc)['power']})
  th[[length(th)+1]]<-data.frame(cell=i,J=J,mean=mean(pp),sd=if(Bth>1)sd(pp)else 0,above=mean(pp>=.8),masks=Bth)
 }
}
write.csv(do.call(rbind,draws),file.path(base,'outputs/exemplary-draws.csv'),row.names=FALSE)
write.csv(do.call(rbind,checks),file.path(base,'outputs/gls-independent-check.csv'),row.names=FALSE)
write.csv(do.call(rbind,th),file.path(base,'outputs/thresholds.csv'),row.names=FALSE)
# Original J stage, using the exact Appendix B frequency vectors, and OD/BW formula arms.
initial<-list();formula<-list()
for(i in 1:54){r<-targets[i,];J<-c(16,22,28)[match(r$icc,c(.05,.1,.15))];B<-if(r$attrition==0)1 else 500
 pp<-replicate(B,{d<-design(J,r$icc,r$attrition,r$treat,r$size);exemplary(d,r$icc)['power']})
 initial[[i]]<-data.frame(cell=i,J=J,mean=mean(pp),mask_sd=if(B>1)sd(pp)else 0)
}
for(icc in c(.05,.1,.15))for(J in 12:41){
 # Slope measurement variance = .5/sum((0:3-mean(0:3))^2) = .1.
 # Continuous equal allocation is the formula; actual odd-J allocation checked separately.
 v<-4*(icc+(1-icc+.1)/20)/J
 formula[[length(formula)+1]]<-data.frame(icc=icc,J=J,lambda=.25/v,OD=power_value(v,J-2),BW=power_value(v,J*80-J-2))
}
write.csv(do.call(rbind,initial),file.path(base,'outputs/initial-exemplary.csv'),row.names=FALSE)
write.csv(do.call(rbind,formula),file.path(base,'outputs/formulaic.csv'),row.names=FALSE)
# Table3 oversampling arm.
ov<-list()
for(k in 1:3)for(a in c(.05,.15)){
 icc<-c(.05,.1,.15)[k];J<-if(a==.05)c(15,22,29)[k]else c(19,28,36)[k]
 pp<-replicate(500,{d<-design(J,icc,a,.5,1);exemplary(d,icc)['power']})
 ov[[length(ov)+1]]<-data.frame(icc=icc,a=a,J=J,mean=mean(pp),mask_sd=sd(pp),masks=500)
}
write.csv(do.call(rbind,ov),file.path(base,'outputs/oversampling.csv'),row.names=FALSE)
