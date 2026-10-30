# Independent reconstruction of Chapter 6; direct joint Gaussian ML in OpenMx.
# Args q missing mechanism seed tag [N=1000] [beta_shape=equal]
suppressPackageStartupMessages(library(OpenMx)); library(MASS)
mxOption(NULL,'Number of Threads',1)
args<-commandArgs(TRUE);q<-as.integer(args[1]);miss<-as.numeric(args[2]);mechanism<-args[3];seed<-as.integer(args[4]);tag<-args[5];N<-if(length(args)>5)as.integer(args[6]) else 1000
set.seed(seed);nmz<-round(.28*N);rho<-c(rep(1,nmz),rep(.5,N-nmz));W<-matrix(.1,q,q);diag(W)<-1;B<-matrix(.5,q,q);diag(B)<-1;S<-W+B
beta<-rep(1,q);if(length(args)>6 && args[7]=='unequal') beta<-seq_len(q)
beta<-beta*sqrt(.64/drop(t(beta)%*%S%*%beta))
# Generator independent of the fitted block-covariance code: family + individual draws.
family<-mvrnorm(N,rep(0,q),B);x1<-family+mvrnorm(N,rep(0,q),W);x2<-family+mvrnorm(N,rep(0,q),W)
a1<-rnorm(N,sd=sqrt(.5));a2<-rho*a1+sqrt(.5*(1-rho^2))*rnorm(N);c<-rnorm(N,sd=sqrt(.3));y1<-x1%*%beta+a1+c+rnorm(N,sd=sqrt(.2));y2<-x2%*%beta+a2+c+rnorm(N,sd=sqrt(.2))
x<-cbind(x1,x2);prob<-switch(mechanism,MCAR=rep(1,length(x)),MAR=as.vector(cbind(matrix(plogis(-2-1.7*y1),N,q),matrix(plogis(-2-1.7*y2),N,q))),MNAR=as.vector(plogis(-2-1.7*x)))
x[sample(seq_along(x),round(length(x)*miss),prob=prob)]<-NA
dat<-data.frame(y1=as.numeric(y1),y2=as.numeric(y2),x);names(dat)<-c('y1','y2',paste0('x',seq_len(2*q)))
fit_joint<-function(dat,optimizer=Sys.getenv('OPENMX_OPTIMIZER','SLSQP')){
 dims<-names(dat);p<-ncol(dat)
 # Symmetric covariance blocks via separate Cholesky factors guarantee PSD.
 model<-mxModel('joint',mxMatrix('Full',1,1,TRUE,sqrt(.5),name='a'),mxMatrix('Full',1,1,TRUE,sqrt(.3),name='c'),mxMatrix('Full',1,1,TRUE,sqrt(.2),name='e'),mxMatrix('Full',q,1,TRUE,.1,name='beta'),mxMatrix('Lower',q,q,TRUE,t(chol(W)),name='LW'),mxMatrix('Lower',q,q,TRUE,t(chol(B)),name='LB'),mxMatrix('Full',1,p,TRUE,0,labels=c('my','my',if(Sys.getenv('MEAN_MODE')=='shared')rep('mx',2*q) else rep(paste0('mx',1:q),2)),name='means'),mxAlgebra(a*a,name='A'),mxAlgebra(c*c,name='C'),mxAlgebra(e*e,name='E'),mxAlgebra(LW%*%t(LW),name='W'),mxAlgebra(LB%*%t(LB),name='B'),mxAlgebra(W+B,name='S'),mxAlgebra(A/(A+C+E),name='h2'),mxAlgebra(rbind(cbind(A+C+E+t(beta)%*%S%*%beta,A+C+t(beta)%*%B%*%beta,t(beta)%*%S,t(beta)%*%B),cbind(A+C+t(beta)%*%B%*%beta,A+C+E+t(beta)%*%S%*%beta,t(beta)%*%B,t(beta)%*%S),cbind(S%*%beta,B%*%beta,S,B),cbind(B%*%beta,S%*%beta,B,S)),name='SMZ'),mxAlgebra(rbind(cbind(A+C+E+t(beta)%*%S%*%beta,.5*A+C+t(beta)%*%B%*%beta,t(beta)%*%S,t(beta)%*%B),cbind(.5*A+C+t(beta)%*%B%*%beta,A+C+E+t(beta)%*%S%*%beta,t(beta)%*%B,t(beta)%*%S),cbind(S%*%beta,B%*%beta,S,B),cbind(B%*%beta,S%*%beta,B,S)),name='SDZ'))
 for(g in c('MZ','DZ')){idx<-if(g=='MZ')seq_len(nmz) else (nmz+1):N;model<-mxModel(model,mxModel(g,mxData(dat[idx,,drop=FALSE],'raw'),mxExpectationNormal(paste0('joint.S',g),'joint.means',dimnames=dims),mxFitFunctionML()))}
 model<-mxModel(model,mxFitFunctionMultigroup(c('MZ.fitfunction','DZ.fitfunction')));mxOption(NULL,'Default optimizer',optimizer)
 fit<-mxRun(model,silent=TRUE);s<-summary(fit)
 pars<-c(A=mxEval(A,fit),C=mxEval(C,fit),E=mxEval(E,fit),h2=mxEval(h2,fit),setNames(as.numeric(mxEval(beta,fit)),paste0('beta',1:q)))
 # Delta-method SE from the observed-information parameter covariance.
 V<-vcov(fit);pn<-names(omxGetParameters(fit));jac<-matrix(0,length(pars),length(pn));rownames(jac)<-names(pars);colnames(jac)<-pn
 a<-mxEval(a,fit);cc<-mxEval(c,fit);e<-mxEval(e,fit);total<-sum(pars[1:3]);jac[1,'joint.a[1,1]']<-2*a;jac[2,'joint.c[1,1]']<-2*cc;jac[3,'joint.e[1,1]']<-2*e
 jac[4,]<-((total-pars[1])*jac[1,]-pars[1]*(jac[2,]+jac[3,]))/total^2
 for(k in 1:q)jac[4+k,paste0('joint.beta[',k,',1]')]<-1
 se<-sqrt(pmax(0,diag(jac%*%V%*%t(jac))))
 data.frame(parameter=names(pars),estimate=pars,se,status=fit$output$status$code,minus2loglik=fit$output$fit,optimizer)
}
fit_conditional<-function(dat){
 dims<-c('y1','y2');p<-ncol(dat);dat[is.na(dat)]<-0 # y missing flags restored below
 for(twin in 1:2){bad<-!complete.cases(x[,((twin-1)*q+seq_len(q)),drop=FALSE]);dat[bad,twin]<-NA}
 model<-mxModel('joint',mxMatrix('Full',1,1,TRUE,sqrt(.5),name='a'),mxMatrix('Full',1,1,TRUE,sqrt(.3),name='c'),mxMatrix('Full',1,1,TRUE,sqrt(.2),name='e'),mxMatrix('Full',q,1,TRUE,.1,name='beta'),mxMatrix('Full',1,1,TRUE,0,name='mu'),mxAlgebra(a*a,name='A'),mxAlgebra(c*c,name='C'),mxAlgebra(e*e,name='E'),mxAlgebra(A/(A+C+E),name='h2'),mxAlgebra(rbind(cbind(A+C+E,A+C),cbind(A+C,A+C+E)),name='SMZ'),mxAlgebra(rbind(cbind(A+C+E,.5*A+C),cbind(.5*A+C,A+C+E)),name='SDZ'))
 for(g in c('MZ','DZ')){idx<-if(g=='MZ')seq_len(nmz) else (nmz+1):N;d<-dat[idx,,drop=FALSE];d<-d[rowSums(!is.na(d[,1:2]))>0,,drop=FALSE]
 model<-mxModel(model,mxModel(g,mxMatrix('Full',1,q,FALSE,0,labels=paste0('data.x',seq_len(q)),name='x1'),mxMatrix('Full',1,q,FALSE,0,labels=paste0('data.x',q+seq_len(q)),name='x2'),mxAlgebra(cbind(joint.mu+x1%*%joint.beta,joint.mu+x2%*%joint.beta),name='means'),mxData(d,'raw'),mxExpectationNormal(paste0('joint.S',g),'means',dimnames=dims),mxFitFunctionML()))}
 model<-mxModel(model,mxFitFunctionMultigroup(c('MZ.fitfunction','DZ.fitfunction')));fit<-mxRun(model,silent=TRUE)
 pars<-c(A=mxEval(A,fit),C=mxEval(C,fit),E=mxEval(E,fit),h2=mxEval(h2,fit),setNames(as.numeric(mxEval(beta,fit)),paste0('beta',1:q)))
 V<-vcov(fit);pn<-names(omxGetParameters(fit));jac<-matrix(0,length(pars),length(pn));rownames(jac)<-names(pars);colnames(jac)<-pn
 a<-mxEval(a,fit);cc<-mxEval(c,fit);e<-mxEval(e,fit);total<-sum(pars[1:3]);jac[1,'joint.a[1,1]']<-2*a;jac[2,'joint.c[1,1]']<-2*cc;jac[3,'joint.e[1,1]']<-2*e
 jac[4,]<-((total-pars[1])*jac[1,]-pars[1]*(jac[2,]+jac[3,]))/total^2
 for(k in 1:q)jac[4+k,paste0('joint.beta[',k,',1]')]<-1
 data.frame(parameter=names(pars),estimate=pars,se=sqrt(pmax(0,diag(jac%*%V%*%t(jac)))),status=fit$output$status$code,minus2loglik=fit$output$fit,optimizer=mxOption(NULL,'Default optimizer'))
}
rows<-list();for(method in c('full','deletion')){
 d<-dat;if(method=='deletion')for(twin in 1:2){cols<-2+((twin-1)*q+seq_len(q));bad<-!complete.cases(d[,cols,drop=FALSE]);d[bad,c(twin,cols)]<-NA}
 start<-proc.time()[3];ans<-tryCatch(if(method=='full')fit_joint(d) else fit_conditional(d),error=function(e)data.frame(error=conditionMessage(e)))
 ans$method<-method;ans$elapsed_seconds<-proc.time()[3]-start;ans$q<-q;ans$missing<-miss;ans$mechanism<-mechanism;ans$seed<-seed;ans$N<-N
 rows[[method]]<-ans
}
# Separate files preserve failures without incompatible row binding.
for(method in names(rows))write.csv(rows[[method]],file.path('outputs',paste0(tag,'-',method,'.csv')),row.names=FALSE)
saveRDS(list(data=dat,beta=beta),file.path('outputs',paste0(tag,'-input.rds')))
print(rows)
