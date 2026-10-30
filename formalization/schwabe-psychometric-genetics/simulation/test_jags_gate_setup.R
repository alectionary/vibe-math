# Synthetic diagnostic/setup fixtures only. Never invokes jags.model or chain sampling.
.libPaths(c('/workspace/slot3-posterior-library',.libPaths()));stopifnot(requireNamespace('posterior',quietly=TRUE))
set.seed(8671);iid<-matrix(rnorm(48000),12000,4);shifted<-iid;shifted[,4]<-shifted[,4]+3;constant<-matrix(1,12000,4);bad<-iid;bad[1,1]<-NA_real_
checks<-data.frame(test=c('iid_rhat','iid_bulk','iid_tail','shifted_chain_rejected','constant_rhat_NA','nonfinite_rhat_NA','quantile_mcse_finite','quantile_ess_finite'),passed=c(posterior::rhat(iid)<1.01,posterior::ess_bulk(iid)>400,posterior::ess_tail(iid)>400,posterior::rhat(shifted)>1.01,is.na(posterior::rhat(constant)),is.na(posterior::rhat(bad)),all(is.finite(posterior::mcse_quantile(iid,probs=c(.025,.975)))),all(is.finite(posterior::ess_quantile(iid,probs=c(.025,.975))))))
stopifnot(all(checks$passed));write.csv(checks,'outputs/jags-gate-diagnostic-fixtures.csv',row.names=FALSE)
# Freeze synthetic files under /tmp; they are not simulation evidence or actual chains.
root<-tempfile('schwabe-diagnostic-fixture-');dir.create(root)
prepared<-'/tmp/schwabe-gate-preparation-final-v4';protocol<-readRDS(file.path(prepared,'protocol.rds'))
prepared_files<-c('data.rds','model.jags','initials.rds','protocol.rds','prepared-hashes.csv');file.copy(file.path(prepared,prepared_files),file.path(root,prepared_files));initials<-readRDS(file.path(root,'initials.rds'))
sha<-function(path)strsplit(system2('sha256sum',shQuote(path),stdout=TRUE),' ',fixed=TRUE)[[1]][1]
for(i in 1:4){dir<-file.path(root,paste0('chain-',i));dir.create(dir);set.seed(400+i);m<-matrix(rnorm(12000*length(c(protocol$monitors,protocol$derived))),12000,dimnames=list(NULL,c(protocol$monitors,protocol$derived)))
 saveRDS(m,file.path(dir,'draws.rds'));saveRDS(list(chain=i,protocol=protocol,initials=initials[[i]]),file.path(dir,'request.rds'));saveRDS(list(chain=i,status='completed',adaptation_complete=TRUE,retained=12000L,all_finite=all(is.finite(m)),draws_sha256=sha(file.path(dir,'draws.rds'))),file.path(dir,'result.rds'))}
status<-system2('/workspace/slot3-runtime/bin/Rscript',c('simulation/diagnose_jags_gate.R',shQuote(root)),stdout=file.path(root,'test.log'),stderr=file.path(root,'test.log'))
stopifnot(status==0);summary<-read.csv(file.path(root,'diagnostics','diagnostics.csv'));stopifnot(nrow(summary)==14,all(summary$operational_gate_pass));unlink(root,recursive=TRUE)
cat('Eight package fixtures and full14-parameter synthetic diagnostic pipeline passed; zero JAGS chains run.\n')
