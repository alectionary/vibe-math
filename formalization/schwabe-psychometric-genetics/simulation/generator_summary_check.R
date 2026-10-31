# Response-generation only. No model compilation, fitting or posterior draws.
# Run from study: /workspace/slot3-runtime/bin/Rscript simulation/generator_summary_check.R OUTDIR pilot|run
args<-commandArgs(TRUE);stopifnot(length(args)==2,args[2]%in%c('pilot','run'))
out<-args[1];if(dir.exists(out))stop('Refuse existing output directory');dir.create(out,recursive=TRUE)
grid<-rbind(data.frame(ch=2,N=500,J=60,effect=0,difficulty=c(1,-1),replicates=100,role=c('floor','ceiling')),
 transform(expand.grid(ch=2,N=c(500,1000,2000),J=60,Delta=c(1,1.3,1.5,1.7)),effect=log(Delta)/sqrt(.5),difficulty=0,replicates=100,role='power')[,c('ch','N','J','effect','difficulty','replicates','role')],
 data.frame(ch=5,N=c(1000,2000,4000,8000,1000),J=c(60,60,60,60,20),effect=0,difficulty=0,replicates=250,role='moderator'))
# Source alpha statements do not specify one seed, one twin subset or aggregation.
# Report all source N/effect cells applicable to the 60/20-item reliability claims.
atomic_csv<-function(x,path){tmp<-paste0(path,'.tmp');write.csv(x,tmp,row.names=FALSE);if(!file.rename(tmp,path))stop('Atomic CSV rename failed')}
grid$condition<-seq_len(nrow(grid));write.csv(grid,file.path(out,'conditions.csv'),row.names=FALSE)
skews<-function(x){n<-length(x);z<-x-mean(x);g1<-mean(z^3)/mean(z^2)^1.5;c(g1=g1,G1=sqrt(n*(n-1))/(n-2)*g1,b1=((n-1)/n)^1.5*g1)}
alpha<-function(y){J<-ncol(y);J/(J-1)*(1-sum(apply(y,2,var))/var(rowSums(y)))}
generate<-function(ch,N,J,effect,difficulty,seed){
 set.seed(seed);nmz<-round(.28*N);rho<-c(rep(1,nmz),rep(.5,N-nmz));M<-rbinom(N,1,.5)
 av<-if(ch==2).5 else .25;cv<-if(ch==2).3 else .25;ev<-if(ch==2).2 else .5
 a1<-rnorm(N,sd=sqrt(av));a2<-rho*a1+sqrt(av*(1-rho^2))*rnorm(N);cc<-rnorm(N,sd=sqrt(cv));aa<-cbind(A1=a1,A2=a2)
 theta<-aa+cc+if(ch==5).7*M else 0
 if(ch==2)theta<-theta+matrix(rnorm(2*N),N,2)*sqrt(ev*exp(effect*aa)) else theta<-theta+matrix(rnorm(2*N,sd=sqrt(ev)),N,2)
 b<-if(ch==2)rnorm(J,difficulty,1)else seq(-3.2,3.2,length.out=J)
 y<-array(0,c(N,2,J));for(k in seq_len(J))y[,,k]<-matrix(rbinom(2*N,1,plogis(theta-b[k])),N,2)
 list(y=y,ys=apply(y,c(1,2),sum),b=b,nmz=nmz,theta=theta)
}
rows<-list();histrows<-list();t0<-proc.time()[3]
for(g in seq_len(nrow(grid))){
 d<-grid[g,];nrep<-if(args[2]=='pilot')1 else d$replicates
 for(rep in seq_len(nrep)){
  seed<-910000L+1000L*g+rep;s<-generate(d$ch,d$N,d$J,d$effect,d$difficulty,seed)
  all<-matrix(s$y,2*d$N,d$J);dz<-c((s$nmz+1):d$N,d$N+(s$nmz+1):d$N);sk<-skews(as.vector(s$ys[(s$nmz+1):d$N,]))
  # Equivalent covariance identity independently checks alpha implementation.
  covar<-cov(all);alternate<-d$J/(d$J-1)*(1-sum(diag(covar))/sum(covar));a<-alpha(all)
  stopifnot(is.finite(a),abs(a-alternate)<1e-12)
  rows[[length(rows)+1]]<-data.frame(condition=g,replicate=rep,seed=seed,alpha_all=a,alpha_DZ=alpha(all[dz,]),alpha_twin1=alpha(all[seq_len(d$N),]),skew_g1=sk[1],skew_G1=sk[2],skew_b1=sk[3],skew_min=min(sk),skew_max=max(sk),DZ_n=length(dz),elapsed_seconds=proc.time()[3]-t0)
  if(rep==1){h<-tabulate(as.vector(s$ys[(s$nmz+1):d$N,])+1,nbins=d$J+1);histrows[[length(histrows)+1]]<-data.frame(condition=g,seed=seed,score=0:d$J,count=h)}
 }
 # Preserve completed conditions if externally capped; no completion claim until terminal.
 atomic_csv(do.call(rbind,rows),file.path(out,'summaries.csv'))
 atomic_csv(do.call(rbind,histrows),file.path(out,'first-replicate-DZ-histograms.csv'))
}
saveRDS(list(status='completed',mode=args[2],rows=length(rows),elapsed_seconds=proc.time()[3]-t0,scope='Generation-only; no posterior/power/empirical replication'),file.path(out,'terminal.rds'))
capture.output(sessionInfo(),file=file.path(out,'sessionInfo.txt'))
