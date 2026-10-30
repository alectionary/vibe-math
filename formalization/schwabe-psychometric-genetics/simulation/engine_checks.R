suppressPackageStartupMessages(library(lavaan));suppressPackageStartupMessages(library(OpenMx));mxOption(NULL,'Number of Threads',1);set.seed(306)
N<-4000;rho<-c(rep(1,1120),rep(.5,2880));a1<-rnorm(N,sd=sqrt(.5));a2<-rho*a1+sqrt(.5*(1-rho^2))*rnorm(N);cc<-rnorm(N,sd=sqrt(.3));d<-data.frame(y1=a1+cc+rnorm(N,sd=sqrt(.2)),y2=a2+cc+rnorm(N,sd=sqrt(.2)),zyg=ifelse(rho==1,'MZ','DZ'))
lav<-sem('y1 ~~ v*y1\ny2 ~~ v*y2\ny1 ~~ c(kmz,kdz)*y2\ny1 ~ m*1\ny2 ~ m*1\nA := 2*(kmz-kdz)\nC := 2*kdz-kmz\nE := v-kmz',data=d,group='zyg',group.label=c('MZ','DZ'),meanstructure=TRUE)
p<-parameterEstimates(lav);l<-p[p$op==':=',c('lhs','est','se')];names(l)<-c('parameter','estimate','se');l$engine<-'lavaan'
m<-mxModel('ace',mxMatrix('Full',1,1,TRUE,.5,lbound=.0001,name='A'),mxMatrix('Full',1,1,TRUE,.3,lbound=.0001,name='C'),mxMatrix('Full',1,1,TRUE,.2,lbound=.0001,name='E'),mxMatrix('Full',1,2,TRUE,0,labels='mean',name='means'),mxAlgebra(rbind(cbind(A+C+E,A+C),cbind(A+C,A+C+E)),name='MZcov'),mxAlgebra(rbind(cbind(A+C+E,.5*A+C),cbind(.5*A+C,A+C+E)),name='DZcov'))
for(g in c('MZ','DZ'))m<-mxModel(m,mxModel(g,mxData(d[d$zyg==g,1:2],'raw'),mxExpectationNormal(paste0('ace.',g,'cov'),'ace.means',dimnames=c('y1','y2')),mxFitFunctionML()))
m<-mxModel(m,mxFitFunctionMultigroup(c('MZ.fitfunction','DZ.fitfunction')));f<-mxRun(m,silent=TRUE);v<-sqrt(diag(vcov(f)));r<-data.frame(parameter=c('A','C','E'),estimate=c(mxEval(A,f),mxEval(C,f),mxEval(E,f)),se=v[1:3],engine='OpenMx')
write.csv(rbind(l,r),'outputs/engine-agreement.csv',row.names=FALSE)
# Original Appendix F: retain native model, omit only package installation lines.
original<-readLines(file.path(Sys.getenv('SCHWABE_SOURCE','/tmp/schwabe-thesis'),'full_information_approach.R'))
original<-original[!grepl("^source\\(|^install.packages",original)]
rows<-list()
for(Nvar in c(2,5))for(repair in c(FALSE,TRUE)){
 set.seed(307);mzData<-as.data.frame(matrix(rnorm(80*(2+2*Nvar)),80));dzData<-as.data.frame(matrix(rnorm(120*(2+2*Nvar)),120));txt<-paste(original,collapse='\n')
 if(repair)txt<-sub('label=c("beta1","beta2","beta3",[[:space:]]*"beta4","beta5")','label=paste0("beta",seq_len(Nvar))',txt)
 result<-tryCatch({eval(parse(text=txt));f<-mxRun(twin_ACE_cov,silent=TRUE);paste('status',f$output$status$code,'minus2loglik',f$output$fit)},error=function(e)conditionMessage(e))
 rows[[length(rows)+1]]<-data.frame(Nvar,repair,result)
}
write.csv(do.call(rbind,rows),'outputs/original-openmx.csv',row.names=FALSE)
writeLines(capture.output(sessionInfo()),'provenance/R-session.txt')
