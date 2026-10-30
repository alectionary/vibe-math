options(jags.moddir=Sys.getenv('JAGS_MODULE_PATH','/workspace/slot3-runtime/usr/lib/x86_64-linux-gnu/JAGS/modules-4'))
library(rjags);library(coda);library(matrixStats);library(foreign)
upstream<-Sys.getenv('BAYESTWIN_SOURCE','/tmp/schwabe-author/BayesTwin')
for(f in list.files(file.path(upstream,'R'),full.names=TRUE))source(f)
set.seed(308);rows<-list()
for(model in c('ACE','ADE','AE'))for(irt in c('1PL','2PL','PCM','GPCM')){
 result<-tryCatch({x<-simulatetwin(n_mz=10,n_dz=20,model=model,var_a=.5,var_c=if(model=='ACE').3 else 0,var_d=if(model=='ADE').3 else 0,var_e=if(model=='AE').5 else .2,n_items=6,n_cat=3,irt_model=irt);saveRDS(x,file.path('outputs',paste0('bayestwin-',model,'-',irt,'.rds')));paste('Generator ran; fields',paste(names(x),collapse=','))},error=function(e)conditionMessage(e))
 rows[[length(rows)+1]]<-data.frame(model,irt,stage='generator',result)
}
x<-readRDS('outputs/bayestwin-ACE-1PL.rds');print(str(x))
write.csv(do.call(rbind,rows),'outputs/bayestwin-checks.csv',row.names=FALSE)
for(model in c('ACE','ADE','AE'))for(irt in c('1PL','2PL','PCM','GPCM')){
 x<-readRDS(file.path('outputs',paste0('bayestwin-',model,'-',irt,'.rds')))
 result<-tryCatch({fit<-IRTtwin(x$y_mz,x$y_dz,1:6,7:12,decomp_model=model,irt_model=irt,n_iter=50,n_burnin=50,Nk=3);paste('Fit returned;',paste(names(fit),collapse=','))},error=function(e)conditionMessage(e))
 rows[[length(rows)+1]]<-data.frame(model,irt,stage='fit',result)
}
write.csv(do.call(rbind,rows),'outputs/bayestwin-checks.csv',row.names=FALSE)
# Explicit compatibility repair for R >=4.2 vector conditions; preserve original results.
txt<-paste(readLines(file.path(upstream,'R','IRTtwin.R')),collapse='\n');txt<-gsub('is.na(inits)','all(is.na(inits))',txt,fixed=TRUE);eval(parse(text=txt))
for(model in c('ACE','ADE','AE'))for(irt in c('1PL','2PL','PCM','GPCM')){
 x<-readRDS(file.path('outputs',paste0('bayestwin-',model,'-',irt,'.rds')))
 result<-tryCatch({fit<-IRTtwin(x$y_mz,x$y_dz,1:6,7:12,decomp_model=model,irt_model=irt,n_iter=50,n_burnin=50,Nk=3);paste('Fit returned;',paste(names(fit),collapse=','))},error=function(e)conditionMessage(e))
 rows[[length(rows)+1]]<-data.frame(model,irt,stage='fit after vector-condition repair',result)
}
write.csv(do.call(rbind,rows),'outputs/bayestwin-checks.csv',row.names=FALSE)
