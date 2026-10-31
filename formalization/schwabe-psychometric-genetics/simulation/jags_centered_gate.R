# Fixed, separate four-chain diagnostic gate. prepare never compiles or samples JAGS.
# R_LIBS_USER=/workspace/slot3-posterior-library Rscript simulation/jags_centered_gate.R prepare DIR
# timeout 1800s Rscript simulation/jags_centered_gate.R run DIR CHAIN_ID
argv<-commandArgs(TRUE)
if(length(argv)<2 || !argv[1]%in%c('prepare','run'))stop('Usage: prepare DIR or run DIR CHAIN_ID')
action<-argv[1];outdir<-argv[2]
sha<-function(path)strsplit(system2('sha256sum',shQuote(path),stdout=TRUE),' ',fixed=TRUE)[[1]][1]
atomic_rds<-function(value,path){tmp<-paste0(path,'.tmp');saveRDS(value,tmp,compress=FALSE,version=3);if(!file.rename(tmp,path))stop('Atomic rename failed')}
source_script<-'simulation/jags_replication.R'
source_expected<-'55ab08fd95bc9a3210ba6eb64106c05777be6f786576abe9c7327ac8d7f28c20'
if(sha(source_script)!=source_expected)stop('Baseline source hash mismatch')
self<-'simulation/jags_centered_gate.R'
gate_library<-'/workspace/slot3-posterior-library'
if(dir.exists(gate_library)).libPaths(c(gate_library,.libPaths()))
if(!requireNamespace('posterior',quietly=TRUE))stop('Separate verified posterior library is required before preparation or execution')
posterior_manifest<-'provenance/posterior-runtime-packages.json'
if(!file.exists(posterior_manifest))stop('Posterior package archive manifest required')
initials<-list(list(mu=-1,beta0=-2.5,beta1=-1.5,ta=2,tc=5),list(mu=1,beta0=-.5,beta1=1.5,ta=5,tc=2),list(mu=-.5,beta0=-1,beta1=.5,ta=1,tc=10),list(mu=.5,beta0=-2,beta1=-.5,ta=10,tc=1))
seeds<-830101:830104
monitors<-c('mu','va','vc','ve','beta1','theta[1,1]','theta[1,2]','a[1,1]','c[1]','p[1,1,1]','p[1,2,1]')
if(action=='prepare') {
 if(dir.exists(outdir)&&length(list.files(outdir,all.files=TRUE,no..=TRUE)))stop('Refusing to overwrite preparation directory')
 dir.create(outdir,recursive=TRUE,showWarnings=FALSE)
 # Evaluate only the baseline pre-sampling expressions, preserving the exact RNG order.
 env<-new.env(parent=globalenv());env$commandArgs<-function(...)c(2,500,60,0,1,301,1000,7000,12000,'unused','.5','items')
 expressions<-parse(source_script);stop_index<-which(vapply(expressions,function(x)is.call(x)&&identical(x[[1]],as.name('<-'))&&identical(x[[2]],as.name('start')),logical(1)))[1]
 if(is.na(stop_index))stop('Baseline sampling boundary not found')
 for(expr in expressions[seq_len(stop_index-1)])eval(expr,envir=env)
 stopifnot(env$data$N==500,env$data$J==60,identical(env$data$rho,c(rep(1,140),rep(.5,360))))
 # Exact centered representation for this fixed diagnostic design only.
 # Source priors reused byte-for-byte from baseline pre-sampling expressions.
 model<-gsub(';','\n',paste('model {mu ~ dnorm(0,.1);',env$prior,
 ';for(i in 1:N){c[i] ~ dnorm(0,tc);for(t in 1:2){prec[i,t] <- exp(-beta0-beta1*a[i,t]);theta[i,t] ~ dnorm(mu+a[i,t]+c[i],prec[i,t]);for(k in 1:J){logit(p[i,t,k]) <- theta[i,t]-b[k];y[i,t,k] ~ dbern(p[i,t,k])}}};for(i in 1:140){a[i,1] ~ dnorm(0,ta);a[i,2] <- a[i,1]};for(i in 141:N){a[i,1] ~ dnorm(0,ta);a[i,2] ~ dnorm(.5*a[i,1],ta/.75)}}'),fixed=TRUE)
 # Independent explicit generator checks that extraction did not change data or RNG order.
 set.seed(301);N<-500L;J<-60L;rho<-c(rep(1,140),rep(.5,360));M<-rbinom(N,1,.5)
 a1<-rnorm(N,sd=sqrt(.5));a2<-rho*a1+sqrt(.5*(1-rho^2))*rnorm(N);cc<-rnorm(N,sd=sqrt(.3));aa<-cbind(a1,a2)
 theta<-aa+cc+matrix(rnorm(2*N),N,2)*sqrt(.2*exp(0*aa));b<-rnorm(J,1,1);y<-array(0,c(N,2,J))
 for(k in 1:J)y[,,k]<-matrix(rbinom(2*N,1,plogis(theta-b[k])),N,2)
 independent<-list(N=as.numeric(N),J=as.numeric(J),b=b,y=y,rho=rho,M=M)
 # Baseline integer N/J data representation is preserved; numerical and array identities exact.
 stopifnot(identical(env$data$y,independent$y),identical(env$data$b,independent$b),identical(env$data$rho,independent$rho),identical(env$data$M,independent$M),env$data$N==N,env$data$J==J)
 atomic_rds(env$data,file.path(outdir,'data.rds'));writeLines(model,file.path(outdir,'model.jags'))
 for(i in 1:4){initials[[i]]$.RNG.name<-'base::Mersenne-Twister';initials[[i]]$.RNG.seed<-seeds[i]}
 atomic_rds(initials,file.path(outdir,'initials.rds'))
 protocol<-list(source_sha256=source_expected,wrapper_sha256=sha(self),diagnostic_script_sha256=sha('simulation/diagnose_jags_centered_gate.R'),data_sha256=sha(file.path(outdir,'data.rds')),model_sha256=sha(file.path(outdir,'model.jags')),initials_sha256=sha(file.path(outdir,'initials.rds')),requested_chains=4L,chain_seeds=seeds,adaptation=1000L,burn_in=7000L,retained=12000L,thin=1L,monitors=monitors,derived=c('log_va','log_vc','log_ve'),data_seed=301L,diagnostic_library=gate_library,posterior_version=as.character(packageVersion('posterior')),posterior_manifest_sha256=sha(posterior_manifest),model_scope='Same baseline posterior under reviewed centered reparameterization:140sharedMZ A plus360conditionalDZ pairs, centered C. No prior/estimand change; not same sampler trajectory.',prepare_only=TRUE,setup_generated_data_identity='Exact against independent explicit generator; no JAGS compilation or sampling')
 atomic_rds(protocol,file.path(outdir,'protocol.rds'));write.csv(data.frame(file=c('data.rds','model.jags','initials.rds','protocol.rds'),sha256=vapply(file.path(outdir,c('data.rds','model.jags','initials.rds','protocol.rds')),sha,character(1))),file.path(outdir,'prepared-hashes.csv'),row.names=FALSE)
 capture.output(sessionInfo(),file=file.path(outdir,'prepare-sessionInfo.txt'))
 print(data.frame(prepare_only=TRUE,exact_generated_data_identity=TRUE,requested_chains=4,model_sha256=protocol$model_sha256,data_sha256=protocol$data_sha256));quit(status=0)
}
if(length(argv)!=3 || !argv[3]%in%as.character(1:4))stop('Run requires chain ID1-4')
id<-as.integer(argv[3]);prepared_hashes<-read.csv(file.path(outdir,'prepared-hashes.csv'),stringsAsFactors=FALSE)
if(nrow(prepared_hashes)!=4L||!setequal(prepared_hashes$file,c('data.rds','model.jags','initials.rds','protocol.rds')))stop('Incomplete or duplicate prepared-file manifest')
for(i in seq_len(nrow(prepared_hashes)))if(sha(file.path(outdir,prepared_hashes$file[i]))!=prepared_hashes$sha256[i])stop('Prepared file checksum mismatch')
protocol<-readRDS(file.path(outdir,'protocol.rds'))
if(as.character(packageVersion('posterior'))!=protocol$posterior_version||sha(posterior_manifest)!=protocol$posterior_manifest_sha256)stop('Posterior runtime manifest/version mismatch')
if(sha(self)!=protocol$wrapper_sha256)stop('Wrapper changed since preparation')
for(name in c('data','model','initials')){
 file<-file.path(outdir,switch(name,data='data.rds',model='model.jags',initials='initials.rds'))
 if(sha(file)!=protocol[[paste0(name,'_sha256')]])stop('Prepared input hash mismatch')
}
chain_dir<-file.path(outdir,paste0('chain-',id));if(dir.exists(chain_dir))stop('Refusing to overwrite or silently resume an existing chain')
dir.create(chain_dir);request<-list(chain=id,protocol=protocol,initials=readRDS(file.path(outdir,'initials.rds'))[[id]],requested_utc=format(Sys.time(),tz='UTC',usetz=TRUE),status='requested')
atomic_rds(request,file.path(chain_dir,'request.rds'));capture.output(sessionInfo(),file=file.path(chain_dir,'sessionInfo.txt'))
options(jags.moddir=Sys.getenv('JAGS_MODULE_PATH','/workspace/slot3-runtime/usr/lib/x86_64-linux-gnu/JAGS/modules-4'));library(rjags);library(coda)
t0<-proc.time()[3];warnings_seen<-character();adapted<-FALSE
result<-tryCatch(withCallingHandlers({
 model<-jags.model(file.path(outdir,'model.jags'),data=readRDS(file.path(outdir,'data.rds')),inits=request$initials,n.chains=1,n.adapt=0,quiet=TRUE)
 adapted<-adapt(model,1000,end.adaptation=TRUE);atomic_rds(list(adaptation_complete=adapted,elapsed_seconds=proc.time()[3]-t0),file.path(chain_dir,'adaptation.rds'))
 atomic_rds(model$state(internal=TRUE),file.path(chain_dir,'adaptation-state.rds'))
 update(model,7000,progress.bar='none')
 atomic_rds(model$state(internal=TRUE),file.path(chain_dir,'burn-in-state.rds'))
 chunks<-list()
 for(chunk in 1:3){
  draws<-coda.samples(model,protocol$monitors,n.iter=4000,thin=1,progress.bar='none')
  chunks[[chunk]]<-as.matrix(draws);partial<-do.call(rbind,chunks)
  atomic_rds(partial,file.path(chain_dir,'partial-draws.rds'))
  atomic_rds(model$state(internal=TRUE),file.path(chain_dir,'checkpoint-sampler-state.rds'))
  atomic_rds(list(completed_chunks=chunk,retained=nrow(partial),partial_sha256=sha(file.path(chain_dir,'partial-draws.rds')),state_sha256=sha(file.path(chain_dir,'checkpoint-sampler-state.rds')),elapsed_seconds=proc.time()[3]-t0,status='partial; no automaticresume or convergence verdict'),file.path(chain_dir,'checkpoint.rds'))
 }
 mat<-partial;mat<-cbind(mat,log_va=log(mat[,'va']),log_vc=log(mat[,'vc']),log_ve=log(mat[,'ve']))
 atomic_rds(mat,file.path(chain_dir,'draws.rds'))
 # Retain sampler state for forensic checks, never present a fresh chain as continuation.
 atomic_rds(model$state(internal=TRUE),file.path(chain_dir,'final-sampler-state.rds'))
 list(status='completed',chain=id,adaptation_complete=adapted,retained=nrow(mat),all_finite=all(is.finite(mat)),draws_sha256=sha(file.path(chain_dir,'draws.rds')),elapsed_seconds=proc.time()[3]-t0)
},warning=function(w){warnings_seen<<-c(warnings_seen,conditionMessage(w));invokeRestart('muffleWarning')}),error=function(e)list(status='failed',chain=id,error=conditionMessage(e),adaptation_complete=adapted,elapsed_seconds=proc.time()[3]-t0))
result$warnings<-unique(warnings_seen);result$requested_chains<-4L;result$meaning<-'Execution and adaptation record only; joint four-chain diagnostics and manual review still required.'
atomic_rds(result,file.path(chain_dir,'result.rds'));capture.output(str(result),file=file.path(chain_dir,'result.txt'));print(result)
if(result$status!='completed')quit(status=1)
