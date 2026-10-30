# Translation of Kupzyk (2011), Appendices A/B. Numeric time and treatment.
sasround <- function(x) floor(x + .5)
base <- 'formalization/kupzyk-power-assumptions'
normal <- as.matrix(read.csv(file.path(base,'outputs/normsizes.csv'),header=FALSE))
skew <- as.matrix(read.csv(file.path(base,'outputs/skewsizes.csv'),header=FALSE))
sizes <- function(J,condition,exemplary=TRUE) {
 if(condition==1) return(rep(20L,J))
 if(exemplary) {
  stopifnot(J>=13,J<=41)
  v <- rep(if(condition==2) 15:25 else 15:22,if(condition==2)normal[J-12,] else skew[J-12,])
  ans <- numeric(J);ans[seq_len(ceiling(J/2))] <- v[seq(1,J,2)]
  ans[ceiling(J/2)+seq_len(floor(J/2))] <- v[seq(2,J,2)]
  return(ans)
 }
 v <- sasround(20+2*rnorm(J))
 if(condition==3) {
  toggle <- 2
  for(j in seq_len(J)) if(v[j]>20) {toggle<-1/toggle;v[j]<-if(toggle==2) 40-v[j] else sasround(20+.5*(v[j]-20))}
 }
 pmin(if(condition==2)25 else 22,pmax(15,v))
}
design <- function(J,icc,a,p,condition,exemplary=TRUE,rank_method='uniform') {
 n <- sizes(J,condition,exemplary);N<-sum(n);cluster<-rep(seq_len(J),n)
 ranks <- if(a==0) seq_len(N) else if(rank_method=='uniform')rank(runif(N)) else sample.int(N)
 counts <- rep(4L,N)
 for(t in 1:3)counts[ranks<=sasround(a*t*N)]<-pmin(counts[ranks<=sasround(a*t*N)],t)
 data.frame(person=seq_len(N),cluster=cluster,group=as.integer(cluster>sasround(J*(1-p))),k=counts)
}
# Woodbury reduces each individual's observations to 2x2 information,
# and then adds independent cluster random intercept/slope covariance.
info_blocks <- function(d,icc) {
 H<-lapply(1:4,function(k){Z<-cbind(1,0:(k-1)); D<-.2+ (1-icc)*tcrossprod(0:(k-1)) + diag(.5,k);crossprod(Z,solve(D,Z))})
 infos <- lapply(split(d,d$cluster),function(v){A<-Reduce('+',lapply(1:4,function(k)sum(v$k==k)*H[[k]])); solve(solve(A)+diag(c(.1,icc)))})
 g<-tapply(d$group,d$cluster,head,1)
 B0<-solve(Reduce('+',infos[g==0]));B1<-solve(Reduce('+',infos[g==1]))
 B0[2,2]+B1[2,2]
}
# Independently assemble full observation covariance within each cluster.
info_dense <- function(d,icc) {
 I<-matrix(0,4,4)
 for(v in split(d,d$cluster)){
  idx<-rep(seq_len(nrow(v)),v$k);t<-unlist(lapply(v$k,function(k)0:(k-1)));g<-v$group[idx]
  same<-outer(v$person[idx],v$person[idx],'==')
  V<-.1+icc*tcrossprod(t)+same*(.2+(1-icc)*tcrossprod(t))+diag(.5,length(t))
  X<-cbind(1,t,g,t*g);L<-chol(V);Z<-forwardsolve(t(L),X);I<-I+crossprod(Z)
 }
 solve(I)[4,4]
}
power_value <- function(v,df) pf(qf(.95,1,df),1,df,ncp=.25/v,lower.tail=FALSE)
exemplary <- function(d,icc,dfmode='bw',dense=FALSE){
 J<-length(unique(d$cluster));df<-switch(dfmode,bw=sum(d$k)-J-2,od=J-2,person=sum(d$k)-nrow(d)-2,nominal=J*80-J-2)
 v<-if(dense)info_dense(d,icc) else info_blocks(d,icc)
 c(power=power_value(v,df),variance=v,df=df)
}
generate <- function(d,icc,effect=.5,method='components'){
 J<-max(d$cluster);N<-nrow(d);idx<-rep(seq_len(N),d$k);tt<-unlist(lapply(d$k,function(k)0:(k-1)))
 z<-data.frame(person=factor(d$person[idx]),cluster=factor(d$cluster[idx]),time=tt,group=d$group[idx]);z$y<-effect*tt*z$group
 if(method=='components') {
  u0<-rnorm(J,0,sqrt(.1));u1<-rnorm(J,0,sqrt(icc));b0<-rnorm(N,0,sqrt(.2));b1<-rnorm(N,0,sqrt(1-icc))
  z$y<-z$y+u0[d$cluster[idx]]+u1[d$cluster[idx]]*tt+b0[idx]+b1[idx]*tt+rnorm(nrow(z),0,sqrt(.5))
 } else for(c in levels(z$cluster)){
  ii<-which(z$cluster==c);t<-z$time[ii];same<-outer(z$person[ii],z$person[ii],'==')
  V<-.1+icc*tcrossprod(t)+same*(.2+(1-icc)*tcrossprod(t))+diag(.5,length(t))
  z$y[ii]<-z$y[ii]+drop(t(chol(V))%*%rnorm(length(ii)))
 }
 z
}
fit_empirical <- function(z,engine='lme4',reml=TRUE,optimizer='bobyqa'){
 warnings<-character();start<-proc.time()[3]
 ans<-tryCatch(withCallingHandlers({
 if(engine=='lme4'){
  f<-lme4::lmer(y~time*group+(1|cluster)+(0+time|cluster)+(1|person)+(0+time|person),data=z,REML=reml,
   control=lme4::lmerControl(optimizer=optimizer,calc.derivs=TRUE,optCtrl=if(optimizer=='bobyqa')list(maxfun=20000)else list(maxeval=20000)))
  b<-lme4::fixef(f)['time:group'];se<-sqrt(diag(as.matrix(vcov(f))))['time:group'];converged<-!any(!grepl('boundary (singular) fit',f@optinfo$conv$lme4$messages,fixed=TRUE))&&f@optinfo$conv$opt==0
  vc<-as.data.frame(lme4::VarCorr(f));singular<-lme4::isSingular(f);vv<-vc$vcov
 }else{
  f<-nlme::lme(y~time*group,random=list(cluster=nlme::pdDiag(~time),person=nlme::pdDiag(~time)),data=z,method=if(reml)'REML'else'ML',control=nlme::lmeControl(msMaxIter=200,returnObject=FALSE))
  b<-nlme::fixef(f)['time:group'];se<-sqrt(diag(vcov(f)))['time:group'];converged<-TRUE
  vv<-suppressWarnings(as.numeric(nlme::VarCorr(f)[,'Variance']));vv<-vv[is.finite(vv)];singular<-any(vv<1e-8)
 }
 df<-nrow(z)-nlevels(z$cluster)-2;tval<-unname(b/se)
 c(beta=unname(b),se=unname(se),df=df,pbw=2*pt(-abs(tval),df),pod=2*pt(-abs(tval),nlevels(z$cluster)-2),
  converged=converged,singular=singular,minvariance=min(vv),seconds=proc.time()[3]-start)
 },warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')},message=function(m)invokeRestart('muffleMessage')),error=function(e)c(beta=NA,se=NA,df=NA,pbw=NA,pod=NA,converged=0,singular=NA,minvariance=NA,seconds=proc.time()[3]-start))
 names(ans)[length(ans)]<-'seconds';ans
}
