# Independent setup/integrity fixtures only; never invoke action=run or a sampler.
Rscript <- '/workspace/slot3-runtime/bin/Rscript'
sha <- function(p)strsplit(system2('sha256sum',shQuote(p),stdout=TRUE),' ',fixed=TRUE)[[1]][1]
base <- tempfile('schwabe-independent-prepare-');log <- tempfile('prepare-log-')
rc <- system2(Rscript,c('simulation/jags_convergence_gate.R','prepare',shQuote(base)),stdout=log,stderr=log)
stopifnot(rc==0)
protocol <- readRDS(file.path(base,'protocol.rds'));initials <- readRDS(file.path(base,'initials.rds'))
checks <- list();put <- function(name,passed,detail=''){stopifnot(passed);checks[[length(checks)+1L]]<<-data.frame(test=name,passed=passed,detail=detail)}
put('prepared_data_identity',sha(file.path(base,'data.rds'))=='5a9814682484e6cd62d8ee7c1415b8d67ba30be6b9696a685c85b58b5e60240a')
put('prepared_model_identity',sha(file.path(base,'model.jags'))=='65ae9f0cd26e420d4dec7d325cc577f9c70f51251b249c78ce27e810085649cf')
put('fixed_chain_protocol',identical(protocol$chain_seeds,830101:830104)&&protocol$adaptation==1000&&protocol$burn_in==7000&&protocol$retained==12000&&protocol$requested_chains==4)
put('explicit_dispersed_initials',length(unique(vapply(initials,function(x)x$beta1,numeric(1))))==4&&identical(vapply(initials,function(x)x$.RNG.seed,integer(1)),830101:830104))
make_fixture<-function(kind){
 root<-tempfile(paste0('schwabe-independent-',kind,'-'));dir.create(root)
 file.copy(list.files(base,full.names=TRUE),root)
 for(i in 1:4){
  if(kind=='missing_chain'&&i==4)next
  dir<-file.path(root,paste0('chain-',i));dir.create(dir);set.seed(9100+i)
  m<-matrix(rnorm(12000*14),12000,dimnames=list(NULL,c(protocol$monitors,protocol$derived)))
  if(kind=='shifted_chain'&&i==4)m[,'beta1']<-m[,'beta1']+3
  if(kind=='nonfinite_draw'&&i==2)m[1,'beta1']<-NA_real_
  saveRDS(m,file.path(dir,'draws.rds'))
  request<-list(chain=i,protocol=protocol,initials=initials[[i]])
  if(kind=='wrong_initials'&&i==4)request$initials<-initials[[1]]
  saveRDS(request,file.path(dir,'request.rds'))
  result<-list(chain=i,status='completed',adaptation_complete=!(kind=='adaptation_failed'&&i==3),retained=if(kind=='wrong_retained'&&i==4)6000L else 12000L,all_finite=all(is.finite(m)),draws_sha256=sha(file.path(dir,'draws.rds')))
  saveRDS(result,file.path(dir,'result.rds'))
 }
 if(kind=='data_tampered')cat('changed',file=file.path(root,'data.rds'),append=TRUE)
 root
}
for(kind in c('iid','missing_chain','wrong_initials','wrong_retained','data_tampered','adaptation_failed','shifted_chain','nonfinite_draw')){
 root<-make_fixture(kind);status<-suppressWarnings(system2(Rscript,c('simulation/diagnose_jags_gate.R',shQuote(root)),stdout=file.path(root,'test.log'),stderr=file.path(root,'test.log')))
 must_fail<-kind%in%c('missing_chain','wrong_initials','wrong_retained','data_tampered')
 if(must_fail){
  put(paste0(kind,'_rejected'),status!=0,paste(readLines(file.path(root,'test.log')),collapse=' | '))
  put(paste0(kind,'_no_completion_claim'),!file.exists(file.path(root,'diagnostics','review-record.rds')))
  if(kind=='missing_chain'){account<-read.csv(file.path(root,'diagnostics','chain-accounting.csv'));put('missing_chain_denominator_four',nrow(account)==4&&sum(account$status=='completed')==3)}
 } else {
  stopifnot(status==0);d<-read.csv(file.path(root,'diagnostics','diagnostics.csv'));record<-readRDS(file.path(root,'diagnostics','review-record.rds'))
  put(paste0(kind,'_gate_behavior'),if(kind=='iid')all(d$operational_gate_pass)else!all(d$operational_gate_pass))
  put(paste0(kind,'_detection_withheld'),all(grepl('withheld',d$detection_classification))&&grepl('withheld',record$detection_classification))
 }
 unlink(root,recursive=TRUE)
}
unlink(base,recursive=TRUE);unlink(log)
write.csv(do.call(rbind,checks),'outputs/jags-gate-independent-fixtures.csv',row.names=FALSE)
cat(length(checks),'independent setup/diagnostic checks passed; no JAGS chains run.\n')
