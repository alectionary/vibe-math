# A0 same-JAGS score representation: saved data only. prepare never compiles, samples, or generates data.
# R_LIBS_USER=/workspace/slot3-posterior-library Rscript simulation/score_a0_prepare_run.R prepare DIR
# timeout 1600s Rscript simulation/score_a0_prepare_run.R run DIR CHAIN_ID
argv<-commandArgs(TRUE)
if(length(argv)<2 || !argv[1]%in%c('prepare','run'))stop('Usage: prepare DIR or run DIR CHAIN_ID')
action<-argv[1];outdir<-argv[2]
sha<-function(path)strsplit(system2('sha256sum',shQuote(path),stdout=TRUE),' ',fixed=TRUE)[[1]][1]
atomic_rds<-function(value,path){tmp<-paste0(path,'.tmp');saveRDS(value,tmp,compress=FALSE,version=3);if(!file.rename(tmp,path))stop('Atomic rename failed')}
source_script<-'simulation/jags_replication.R'
source_expected<-'55ab08fd95bc9a3210ba6eb64106c05777be6f786576abe9c7327ac8d7f28c20'
if(sha(source_script)!=source_expected)stop('Baseline source hash mismatch')
self<-'simulation/score_a0_prepare_run.R'
gate_library<-'/workspace/slot3-posterior-library'
if(dir.exists(gate_library)).libPaths(c(gate_library,.libPaths()))
if(!requireNamespace('posterior',quietly=TRUE))stop('Separate verified posterior library is required before preparation or execution')
posterior_manifest<-'provenance/posterior-runtime-packages.json'
if(!file.exists(posterior_manifest))stop('Posterior package archive manifest required')
initials<-list(list(mu=-1,beta0=-2.5,beta1=-1.5,ta=2,tc=5),list(mu=1,beta0=-.5,beta1=1.5,ta=5,tc=2),list(mu=-.5,beta0=-1,beta1=.5,ta=1,tc=10),list(mu=.5,beta0=-2,beta1=-.5,ta=10,tc=1))
seeds<-850101:850104
monitors<-c('mu','va','vc','ve','beta1','theta[1,1]','theta[1,2]','a[1,1]','c[1]','p[1,1,1]','p[1,2,1]')

reference<-'production/jags-centered-extended-recovery-v1/prepared'
review_path<-'provenance/jags-centered-extended-recovery-independent-review.json'
review_hash<-'867ce28035fb5c79aea04d6009975a0d798b15c739bafbe5a3f34df8b62a3589'
original_draw_hashes<-c('0e9933747545732af3376e00ed2fc2f03bfc1cb457a8069e8002f7e94b365274','cc81c830dfd217f72110b2386c4fc9da49a4ce3d1f723e3b6cd34db3051edefd','9a652fdad4a541b484957f8c815aa894ad9153a3e7da224bf7744d2a7c30fa41','3342674c5c6ec304ee633b86d16f5a148a935adf265144fb65c5e47d16cfba54')
static_graph<-'outputs/exact-score-static/chapter2-score.jags'
static_graph_hash<-'3d90ea4f149cd8fa0b3f1853c0fe306fbe0286a8ccafb71b665264beacdb4855'
if(action=='prepare') {
 if(length(argv)!=2)stop('prepare DIR only')
 if(dir.exists(outdir)&&length(list.files(outdir,all.files=TRUE,no..=TRUE)))stop('Refusing to overwrite preparation directory')
 if(sha(review_path)!=review_hash)stop('Original independent review changed')
 if(sha(file.path(reference,'data.rds'))!='5a9814682484e6cd62d8ee7c1415b8d67ba30be6b9696a685c85b58b5e60240a')stop('Saved data changed')
 if(sha(static_graph)!=static_graph_hash)stop('Reviewed score graph changed')
 old_protocol<-readRDS(file.path(reference,'protocol.rds'))
 old_initials<-readRDS(file.path(reference,'initials.rds'))
 old_hashes<-read.csv(file.path(reference,'prepared-hashes.csv'),stringsAsFactors=FALSE)
 stopifnot(nrow(old_hashes)==4L,setequal(old_hashes$file,c('data.rds','model.jags','initials.rds','protocol.rds')))
 for(i in 1:nrow(old_hashes))stopifnot(sha(file.path(reference,old_hashes$file[i]))==old_hashes$sha256[i])
 old_review<-readRDS(file.path(reference,'diagnostics/review-record.rds'))
 old_diag<-read.csv(file.path(reference,'diagnostics/diagnostics.csv'),check.names=FALSE)
 stopifnot(isTRUE(old_review$all_operational_gates_pass),nrow(old_diag)==14,all(old_diag$operational_gate_pass),
 all(old_diag$rhat_rank_split_folded<1.01),all(old_diag$ess_bulk>=400),all(old_diag$ess_tail>=400),all(old_diag$mcse_over_sd<=.05))
 records<-lapply(1:4,function(i){
  cd<-file.path(reference,paste0('chain-',i));mat<-readRDS(file.path(cd,'draws.rds'));res<-readRDS(file.path(cd,'result.rds'));req<-readRDS(file.path(cd,'request.rds'))
  stopifnot(sha(file.path(cd,'draws.rds'))==original_draw_hashes[i],res$draws_sha256==original_draw_hashes[i],old_review$draw_hashes[i]==original_draw_hashes[i],
  identical(req$protocol,old_protocol),identical(req$initials,old_initials[[i]]),req$chain==i,res$chain==i,res$status=='completed',isTRUE(res$adaptation_complete),isTRUE(res$all_finite),res$retained==28000,
  is.matrix(mat),nrow(mat)==28000,ncol(mat)==14,all(is.finite(mat)),setequal(colnames(mat),c(monitors,'log_va','log_vc','log_ve')))
  data.frame(chain=i,draws_sha256=original_draw_hashes[i],rows=nrow(mat),columns=ncol(mat),adapted=res$adaptation_complete,all_finite=all(is.finite(mat)),original_rng_seed=req$initials$.RNG.seed)
 })
 original<-readRDS(file.path(reference,'data.rds'))
 stopifnot(original$N==500,original$J==60,identical(original$rho,c(rep(1,140),rep(.5,360))),all(is.finite(original$b)),all(original$y%in%c(0,1)),identical(dim(original$y),c(500L,2L,60L)))
 # Canonical pattern: first S observed items are successes. No new data or RNG call.
 scores<-apply(original$y,c(1,2),sum);canonical<-array(0,dim(original$y))
 for(k in 1:60)canonical[,,k]<-as.numeric(scores>=k)
 data<-list(N=original$N,J=original$J,b=original$b,canonical_y=canonical,observed=array(1,dim(original$y)),zeros=matrix(0,500,2))
 stopifnot(identical(unname(apply(canonical,c(1,2),sum)),unname(scores)))
 # Independent analytic likelihood difference: sum b*(canonical-original), plus1/person.
 constant<-sum(sweep(canonical-original$y,3,original$b,'*'))+1000
 target_errors<-numeric(4)
 for(i in 1:4){
  # Explicit deterministic physical starts, with distinct offsets/scales, not sampled.
  index<-seq_len(500);a1<-.25*sin(index+i);a2<-.5*a1+.2*cos(index+i)
  a2[1:140]<-a1[1:140];cc<-.2*cos(index+2*i)
  physical_a<-cbind(a1,a2);theta<-initials[[i]]$mu+physical_a+cc+matrix(.15*sin(seq_len(1000)+i),500,2)
  aa<-physical_a;aa[1:140,2]<-NA_real_ # deterministic nodes must not receive inits
  initials[[i]]$a<-aa;initials[[i]]$c<-cc;initials[[i]]$theta<-theta
  initials[[i]]$.RNG.name<-'base::Mersenne-Twister';initials[[i]]$.RNG.seed<-seeds[i]
  stopifnot(sum(is.na(aa))==140,all(is.finite(aa[!is.na(aa)])),all(is.finite(cc)),all(is.finite(theta)))
  li<-lc<-0
  for(k in 1:60){
   eta<-theta-original$b[k]
   # Item oracle uses stable log logistic via pnorm-free plogis(log.p=TRUE).
   li<-li+sum(ifelse(original$y[,,k]==1,plogis(eta,log.p=TRUE),plogis(eta,lower.tail=FALSE,log.p=TRUE)))
   signed<-(1-2*canonical[,,k])*eta
   lc<-lc-sum(pmax(signed,0)+log1p(exp(-abs(signed))))
  }
  target_errors[i]<-abs((li-(lc-1000))-constant)
 }
 stopifnot(all(target_errors<1e-8))
 dir.create(outdir,recursive=TRUE,showWarnings=FALSE)
 atomic_rds(data,file.path(outdir,'data.rds'));file.copy(static_graph,file.path(outdir,'model.jags'),overwrite=FALSE)
 atomic_rds(initials,file.path(outdir,'initials.rds'))
 protocol<-old_protocol
 protocol$wrapper_sha256<-sha(self);protocol$diagnostic_script_sha256<-sha('simulation/diagnose_score_a0.R')
 protocol$data_sha256<-sha(file.path(outdir,'data.rds'));protocol$model_sha256<-sha(file.path(outdir,'model.jags'));protocol$initials_sha256<-sha(file.path(outdir,'initials.rds'))
 protocol$chain_seeds<-seeds;protocol$reference_directory<-reference;protocol$reference_draw_hashes<-original_draw_hashes;protocol$reference_review_sha256<-review_hash
 protocol$reference_diagnostics_sha256<-sha(file.path(reference,'diagnostics/diagnostics.csv'))
 protocol$model_scope<-'Same calibrated Rasch posterior; canonical score-pattern zeros likelihood, same JAGS backend, not independent engines. Explicit full stochastic starts; fixed known calibration.'
 protocol$setup_generated_data_identity<-'NO DATA GENERATION: exact saved data transformed to canonical observed score representation; physical starts deterministic; no compile/sample.'
 protocol$maximum_initial_target_difference_error<-max(target_errors);protocol$item_minus_zeros_constant<-constant
 atomic_rds(protocol,file.path(outdir,'protocol.rds'))
 write.csv(data.frame(file=c('data.rds','model.jags','initials.rds','protocol.rds'),sha256=vapply(file.path(outdir,c('data.rds','model.jags','initials.rds','protocol.rds')),sha,character(1))),file.path(outdir,'prepared-hashes.csv'),row.names=FALSE)
 write.csv(do.call(rbind,records),file.path(outdir,'reference-reuse.csv'),row.names=FALSE)
 write.csv(data.frame(chain=1:4,seed=seeds,absolute_target_error=target_errors,item_minus_zeros_constant=constant),file.path(outdir,'initial-target-check.csv'),row.names=FALSE)
 capture.output(sessionInfo(),file=file.path(outdir,'prepare-sessionInfo.txt'))
 print(list(prepare_only=TRUE,no_generated_data=TRUE,no_sampling=TRUE,maximum_target_error=max(target_errors)));quit(status=0)
}
if(Sys.getenv('SCORE_A0_SAMPLING_AUTHORIZED')!='1')stop('Sampling requires approved dispatcher; preparation is not authorization')
if(length(argv)!=3 || !argv[3]%in%as.character(1:4))stop('Run requires chain ID1-4')
id<-as.integer(argv[3]);prepared_hashes<-read.csv(file.path(outdir,'prepared-hashes.csv'),stringsAsFactors=FALSE)
if(nrow(prepared_hashes)!=4L||!setequal(prepared_hashes$file,c('data.rds','model.jags','initials.rds','protocol.rds')))stop('Incomplete or duplicate prepared-file manifest')
for(i in seq_len(nrow(prepared_hashes)))if(sha(file.path(outdir,prepared_hashes$file[i]))!=prepared_hashes$sha256[i])stop('Prepared file checksum mismatch')
protocol<-readRDS(file.path(outdir,'protocol.rds'))
if(as.character(packageVersion('posterior'))!=protocol$posterior_version||sha(posterior_manifest)!=protocol$posterior_manifest_sha256)stop('Posterior runtime manifest/version mismatch')
if(sha(self)!=protocol$wrapper_sha256)stop('Wrapper changed since preparation')
if(sha('simulation/diagnose_score_a0.R')!=protocol$diagnostic_script_sha256)stop('Diagnostic code changed since preparation')
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
 if(!isTRUE(adapted))stop('Fixed adaptation did not complete; no posterior sampling')
 update(model,7000,progress.bar='none')
 atomic_rds(model$state(internal=TRUE),file.path(chain_dir,'burn-in-state.rds'))
 chunks<-list()
 for(chunk in 1:7){
  draws<-coda.samples(model,protocol$monitors,n.iter=4000,thin=1,progress.bar='none')
  chunks[[chunk]]<-as.matrix(draws);partial<-do.call(rbind,chunks)
  if(nrow(chunks[[chunk]])!=4000L||!all(is.finite(chunks[[chunk]])))stop('Invalid retained draw block')
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
