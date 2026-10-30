options(jags.moddir=Sys.getenv('JAGS_MODULE_PATH','/workspace/slot3-runtime/usr/lib/x86_64-linux-gnu/JAGS/modules-4'));library(rjags);library(coda)
output<-normalizePath('outputs');setwd(Sys.getenv('BAYESTWIN_2016','/tmp/bayestwin-2016/R'));source('simulate_twin_data.R');source('twinUniv.R');set.seed(310)
rows<-list()
for(model in c('ACE','ADE','AE'))for(irt in c('1PL','2PL','PCM','GPCM')){
 result<-tryCatch({x<-simulate_twin_data(n_mz=10,n_dz=20,model=model,var_a=.5,var_c=if(model=='ACE').3 else 0,var_d=if(model=='ADE').3 else 0,var_e=if(model=='AE').5 else .2,n_items=6,irt_model=irt);twinUniv(x$y_mz,x$y_dz,1:6,7:12,decomp_model=model,irt_model=irt,n_iter=50,n_burnin=50);'Generator and fit returned; short smoke test only'},error=function(e)conditionMessage(e))
 rows[[length(rows)+1]]<-data.frame(model,irt,result)
}
write.csv(do.call(rbind,rows),file.path(output,'historical-bayestwin.csv'),row.names=FALSE)
