options(jags.moddir=Sys.getenv('JAGS_MODULE_PATH','/workspace/slot3-runtime/usr/lib/x86_64-linux-gnu/JAGS/modules-4'));library(rjags);set.seed(309)
N<-3;n_mz<-8;n_dz<-12
covariates<-function(n){x<-matrix(rbinom(n*N,1,.5),n,N);x[,2]<-rnorm(n);x[1,1]<-NA;x}
d<-list(N=N,n_mz=n_mz,n_dz=n_dz,y_mz=matrix(rnorm(n_mz*2),n_mz,2),y_dz=matrix(rnorm(n_dz*2),n_dz,2),X_mz_twin1=covariates(n_mz),X_mz_twin2=covariates(n_mz),X_dz_twin1=covariates(n_dz),X_dz_twin2=covariates(n_dz),mu_b=rep(0,N),tau_b=diag(N),omega_tau_w=diag(N),omega_tau_b=diag(N))
result<-tryCatch({m<-jags.model('/tmp/schwabe-appendix-g.jags',data=d,n.adapt=100,quiet=TRUE);update(m,100,progress.bar='none');x<-coda.samples(m,c('tau_a','tau_c','tau_e','b'),100,progress.bar='none');saveRDS(x,'outputs/appendix-g-draws.rds');'Compiled and sampled 100 adaptation +100 burn +100 retained; synthetic input only; no convergence or empirical claim.'},error=function(e)conditionMessage(e))
writeLines(result,'outputs/appendix-g-result.txt')
