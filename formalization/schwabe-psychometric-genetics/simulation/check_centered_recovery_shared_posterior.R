.libPaths(c('/workspace/slot3-posterior-library',.libPaths()))
root<-'production/jags-centered-extended-recovery-v1/prepared'
d<-read.csv(file.path(root,'diagnostics/diagnostics.csv'))
m<-lapply(1:4,function(i)readRDS(file.path(root,paste0('chain-',i),'draws.rds')))
rows<-lapply(seq_len(nrow(d)),function(i){x<-do.call(cbind,lapply(m,function(z)z[,d$parameter[i]]));data.frame(parameter=d$parameter[i],bulk_error=abs(posterior::ess_bulk(x)-d$ess_bulk[i]),tail_error=abs(posterior::ess_tail(x)-d$ess_tail[i]),mcse_error=abs(posterior::mcse_mean(x)-d$mcse_mean[i]))})
out<-do.call(rbind,rows);stopifnot(max(out$bulk_error)<1e-7,max(out$tail_error)<1e-7,max(out$mcse_error)<1e-12)
write.csv(out,'provenance/jags-centered-extended-recovery-shared-posterior-check.csv',row.names=FALSE)
print(out)
