source('formalization/kupzyk-power-assumptions/scripts/model.R')
set.seed(219873)
out<-list();times<-numeric()
for(cell in c(1,54))for(effect in c(0,.5))for(rep in 1:20){
 icc<-if(cell==1).05 else .15;J<-if(cell==1)16 else 28;a<-if(cell==1)0 else .15;p<-if(cell==1).5 else .7;size<-if(cell==1)1 else 3
 d<-design(J,icc,a,p,size,FALSE);z<-generate(d,icc,effect)
 t0<-proc.time()[3]
 f<-suppressMessages(lmerTest::lmer(y~time*group+(1|cluster)+(0+time|cluster)+(1|person)+(0+time|person),data=z,REML=TRUE,control=lme4::lmerControl(optimizer='bobyqa')))
 sat<-coef(summary(f,ddf='Satterthwaite'))['time:group',]
 # A bounded first-pass KR subset, 5 per condition, due dense matrix cost.
 kr<-if(rep<=5)tryCatch(coef(summary(f,ddf='Kenward-Roger'))['time:group',],error=function(e)rep(NA,5))else rep(NA,5)
 b<-lme4::fixef(f)['time:group'];se<-sqrt(diag(as.matrix(vcov(f))))['time:group'];tv<-unname(b/se)
 out[[length(out)+1]]<-data.frame(cell=cell,effect=effect,rep=rep,beta=unname(b),se=unname(se),sat_df=sat[3],sat_p=sat[5],kr_df=kr[3],kr_p=kr[5],bw_p=2*pt(-abs(tv),nrow(z)-J-2),od_p=2*pt(-abs(tv),J-2),seconds=proc.time()[3]-t0)
 write.csv(do.call(rbind,out),file.path(base,'outputs/df-diagnostics.csv'),row.names=FALSE)
}
