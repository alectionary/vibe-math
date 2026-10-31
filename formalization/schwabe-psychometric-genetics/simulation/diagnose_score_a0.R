# Joint diagnostics only; never starts, extends or replaces chains.
# R_LIBS_USER=/workspace/slot3-posterior-library Rscript simulation/diagnose_score_a0.R DIR
args<-commandArgs(TRUE);if(length(args)!=1)stop('Usage: diagnose_score_a0.R DIR');root<-args[1]
sha<-function(path)strsplit(system2('sha256sum',shQuote(path),stdout=TRUE),' ',fixed=TRUE)[[1]][1]
prepared_hashes<-read.csv(file.path(root,'prepared-hashes.csv'),stringsAsFactors=FALSE)
required_files<-c('data.rds','model.jags','initials.rds','protocol.rds')
if(nrow(prepared_hashes)!=length(required_files)||!setequal(prepared_hashes$file,required_files))stop('Incomplete or duplicate prepared-file manifest')
for(i in seq_len(nrow(prepared_hashes)))if(sha(file.path(root,prepared_hashes$file[i]))!=prepared_hashes$sha256[i])stop('Prepared file checksum mismatch')
prepared_initials<-readRDS(file.path(root,'initials.rds'))
if(length(prepared_initials)!=4L)stop('Expected four prepared initializations')
protocol<-readRDS(file.path(root,'protocol.rds'))
for(name in c('data','model','initials')){
 filename<-switch(name,data='data.rds',model='model.jags',initials='initials.rds')
 if(sha(file.path(root,filename))!=protocol[[paste0(name,'_sha256')]])stop('Protocol/prepared-input hash mismatch')
}
if(sha('simulation/jags_replication.R')!=protocol$source_sha256||sha('simulation/score_a0_prepare_run.R')!=protocol$wrapper_sha256)stop('Source/wrapper changed since preparation')
if(!identical(as.integer(protocol$chain_seeds),850101:850104)||!identical(vapply(prepared_initials,function(x)as.integer(x$.RNG.seed),integer(1)),850101:850104))stop('Four distinct prescribed chain seeds required')
if(protocol$requested_chains!=4L||protocol$retained!=28000L)stop('Unexpected gate size')
if(sha('simulation/diagnose_score_a0.R')!=protocol$diagnostic_script_sha256)stop('Diagnostic script changed since preparation');.libPaths(c(protocol$diagnostic_library,.libPaths()))
if(!requireNamespace('posterior',quietly=TRUE))stop('Verified posterior library unavailable')
if(as.character(packageVersion('posterior'))!=protocol$posterior_version||sha('provenance/posterior-runtime-packages.json')!=protocol$posterior_manifest_sha256)stop('Posterior runtime mismatch')
library(coda)
out<-file.path(root,'diagnostics');if(dir.exists(out))stop('Refusing to replace previous diagnostics');dir.create(out)
records<-lapply(1:4,function(i){p<-file.path(root,paste0('chain-',i),'result.rds');if(file.exists(p))readRDS(p)else list(chain=i,status='not_completed',adaptation_complete=FALSE,retained=0L)})
write.csv(do.call(rbind,lapply(records,function(r)data.frame(chain=r$chain,status=r$status,adaptation_complete=r$adaptation_complete,retained=if(is.null(r$retained))0L else r$retained))),file.path(out,'chain-accounting.csv'),row.names=FALSE)
if(any(vapply(records,function(r)r$status!='completed',logical(1))))stop('All four requested chains must complete; incomplete denominator retained')
matrices<-lapply(1:4,function(i){request<-readRDS(file.path(root,paste0('chain-',i),'request.rds'));if(request$chain!=i||records[[i]]$chain!=i||!identical(request$protocol,protocol))stop('Chain request/protocol identity mismatch');if(!identical(request$initials,prepared_initials[[i]]))stop('Chain initialization/RNG identity mismatch');path<-file.path(root,paste0('chain-',i),'draws.rds');if(sha(path)!=records[[i]]$draws_sha256)stop('Draw hash mismatch');m<-readRDS(path);if(!is.matrix(m)||!identical(as.integer(nrow(m)),as.integer(protocol$retained))||!identical(as.integer(records[[i]]$retained),as.integer(protocol$retained)))stop('Unexpected or contradictory retained count');if(!identical(records[[i]]$all_finite,all(is.finite(m))))stop('Contradictory all_finite result');m})
if(!all(vapply(matrices,function(m)identical(colnames(m),colnames(matrices[[1]])),logical(1))))stop('Parameter names/order mismatch')
parameters<-colnames(matrices[[1]]);if(!setequal(parameters,c(protocol$monitors,protocol$derived)))stop('Missing or unexpected monitored parameters');rows<-list();hpd_rows<-list();chain_rows<-list()
pdf(file.path(out,'traces-and-ranks.pdf'),width=10,height=7,useDingbats=FALSE)
for(v in parameters){
 x<-do.call(cbind,lapply(matrices,function(m)m[,v]));finite<-all(is.finite(x))
 if(!finite){rhat<-bulk<-tail<-mean_mcse<-sd_all<-NA_real_;quant_mcse<-quant_ess<-rep(NA_real_,2)}else{
  rhat<-posterior::rhat(x);bulk<-posterior::ess_bulk(x);tail<-posterior::ess_tail(x);mean_mcse<-posterior::mcse_mean(x);sd_all<-stats::sd(as.numeric(x));quant_mcse<-posterior::mcse_quantile(x,probs=c(.025,.975));quant_ess<-posterior::ess_quantile(x,probs=c(.025,.975))
 }
 gate<-finite&&all(vapply(records,function(r)isTRUE(r$adaptation_complete),logical(1)))&&all(is.finite(c(rhat,bulk,tail,mean_mcse,sd_all)))&&rhat<1.01&&bulk>=400&&tail>=400&&sd_all>0&&mean_mcse/sd_all<=.05
 pooled_hpd<-if(finite)coda::HPDinterval(coda::mcmc(as.vector(x)),prob=.95)[1,]else c(NA_real_,NA_real_)
 rows[[v]]<-data.frame(hpd_pooled_low=pooled_hpd[1],hpd_pooled_high=pooled_hpd[2],parameter=v,all_finite=finite,rhat_rank_split_folded=rhat,ess_bulk=bulk,ess_tail=tail,mean=mean(x),sd=sd_all,mcse_mean=mean_mcse,mcse_over_sd=mean_mcse/sd_all,ess_q025=quant_ess[1],ess_q975=quant_ess[2],mcse_q025=quant_mcse[1],mcse_q975=quant_mcse[2],operational_gate_pass=gate,detection_classification='withheld pending manual HPD endpoint/tail precision review')
 for(i in 1:4){
  chain_rows[[length(chain_rows)+1L]]<-data.frame(parameter=v,chain=i,mean=mean(x[,i]),sd=stats::sd(x[,i]),low=if(all(is.finite(x[,i])))quantile(x[,i],.025)else NA_real_,high=if(all(is.finite(x[,i])))quantile(x[,i],.975)else NA_real_)
  for(part in c('whole','first_half','second_half')){
   z<-switch(part,whole=x[,i],first_half=x[1:14000,i],second_half=x[14001:28000,i]);interval<-if(all(is.finite(z)))coda::HPDinterval(coda::mcmc(z),prob=.95)[1,]else c(NA_real_,NA_real_)
   hpd_rows[[length(hpd_rows)+1L]]<-data.frame(parameter=v,chain=i,segment=part,low=interval[1],high=interval[2],excludes_zero=all(is.finite(interval))&&(interval[1]>0||interval[2]<0))
  }
 }
 par(mfrow=c(2,1),mar=c(3,4,2,1));if(any(is.finite(x))){matplot(x,type='l',lty=1,col=1:4,main=paste(v,'traces'),xlab='Retained iteration',ylab='Draw');legend('topright',legend=1:4,col=1:4,lty=1,cex=.7)}else{plot.new();text(.5,.5,paste(v,'all draws nonfinite'))}
 if(finite){ranks<-matrix(rank(as.vector(x),ties.method='average'),nrow(x),4);breaks<-seq(0,length(x),length.out=21);counts<-sapply(1:4,function(i)hist(ranks[,i],breaks=breaks,plot=FALSE)$counts);matplot(seq_len(nrow(counts)),counts,type='l',lty=1,col=1:4,main=paste(v,'pooled-rank bin counts'),xlab='Rank bin',ylab='Count')}else{plot.new();text(.5,.5,'Nonfinite draws: rank plot unavailable')}
}
dev.off()
summary<-do.call(rbind,rows);write.csv(summary,file.path(out,'diagnostics.csv'),row.names=FALSE);write.csv(do.call(rbind,chain_rows),file.path(out,'chain-summaries.csv'),row.names=FALSE);write.csv(do.call(rbind,hpd_rows),file.path(out,'hpd-segment-sensitivity.csv'),row.names=FALSE)
record<-list(requested_chains=4,completed_chains=4,all_operational_gates_pass=all(summary$operational_gate_pass),manual_review='pending; finite diagnostics do not prove convergence',detection_classification='withheld pending HPD endpoint/tail precision review',posterior_version=as.character(packageVersion('posterior')),posterior_manifest_sha256=protocol$posterior_manifest_sha256,source_protocol_sha256=sha(file.path(root,'protocol.rds')),diagnostic_script_sha256=sha('simulation/diagnose_score_a0.R'),draw_hashes=vapply(1:4,function(i)sha(file.path(root,paste0('chain-',i),'draws.rds')),character(1)),meaning='One fixed dataset and four chains. This does not reproduce the100-dataset source simulation or whole dissertation.')
saveRDS(record,file.path(out,'review-record.rds'));capture.output(str(record),file=file.path(out,'review-record.txt'));capture.output(sessionInfo(),file=file.path(out,'sessionInfo.txt'));print(summary)

# Frozen five-global mean comparison. Historical A is not a contemporary benchmark.
reference<-protocol$reference_directory
if(sha('provenance/jags-centered-extended-recovery-independent-review.json')!=protocol$reference_review_sha256)stop('Historical independent review changed')
if(sha(file.path(reference,'diagnostics/diagnostics.csv'))!=protocol$reference_diagnostics_sha256)stop('Historical diagnostics changed')
for(i in 1:4)if(sha(file.path(reference,paste0('chain-',i),'draws.rds'))!=protocol$reference_draw_hashes[i])stop('Historical draws changed')
a<-read.csv(file.path(reference,'diagnostics/diagnostics.csv'),check.names=FALSE)
comparison<-do.call(rbind,lapply(c('mu','va','vc','ve','beta1'),function(v){
 old<-a[a$parameter==v,];new<-summary[summary$parameter==v,]
 stopifnot(nrow(old)==1,nrow(new)==1)
 ok<-all(a$operational_gate_pass)&&all(summary$operational_gate_pass)
 difference<-old$mean-new$mean;se<-sqrt(old$mcse_mean^2+new$mcse_mean^2)
 ok<-ok&&all(is.finite(c(difference,se)))&&se>0
 low<-if(ok)difference-2.5758293035489004*se else NA_real_
 high<-if(ok)difference+2.5758293035489004*se else NA_real_
 data.frame(parameter=v,historical_item_mean=old$mean,new_score_mean=new$mean,item_minus_score=difference,combined_mcse=se,
 simultaneous_mc_low=low,simultaneous_mc_high=high,comparison_eligible=ok,
 discrepancy_flag=if(ok)(low>0||high<0)else NA,
 interpretation='Monte Carlo uncertainty conditional on this dataset; zero inclusion is not equivalence. Same backend, historical baseline; no speedup inference.')
}))
write.csv(comparison,file.path(out,'five-global-mean-comparison.csv'),row.names=FALSE)
