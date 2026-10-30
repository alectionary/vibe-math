# Same generated dataset, upstream centred JAGS model, independently represented graph.
# Reuse only generator/data setup; do not rerun the reconstructed fit.
text<-readLines('simulation/jags_replication.R');stopline<-grep('^start <- proc.time',text)[1];eval(parse(text=text[seq_len(stopline-1)]))
original<-paste(readLines(file.path(Sys.getenv('SCHWABE_SOURCE','/tmp/schwabe-thesis'),'AE_1PL.R')),collapse='\n')
original<-gsub('1:ndz','1:n_dz',original,fixed=TRUE);original<-gsub('1:n.items','1:n_items',original,fixed=TRUE);original<-gsub('Ydz','y_dz',original,fixed=TRUE)
d<-list(n_mz=nmz,n_dz=N-nmz,n_items=J,b=b,y_mz=cbind(y[1:nmz,1,],y[1:nmz,2,]),y_dz=cbind(y[(nmz+1):N,1,],y[(nmz+1):N,2,]))
start<-proc.time()[3];m<-jags.model(textConnection(original),d,inits=list(.RNG.name='base::Mersenne-Twister',.RNG.seed=404),n.adapt=nadapt,quiet=TRUE);update(m,nburn,progress.bar='none');draws<-coda.samples(m,c('tau_a','tau_c','beta0','beta1','mu'),ndraw,progress.bar='none');mat<-as.matrix(draws);transformed<-cbind(beta1=mat[,'beta1'],mu=mat[,'mu'],va=1/mat[,'tau_a'],vc=1/mat[,'tau_c'],ve=exp(mat[,'beta0']));draws<-mcmc.list(mcmc(transformed));hpd<-HPDinterval(draws)[[1]];ess<-effectiveSize(draws)
write.csv(data.frame(parameter=colnames(transformed),mean=colMeans(transformed),sd=apply(transformed,2,sd),low=hpd[,1],high=hpd[,2],ess=ess,mcse=apply(transformed,2,sd)/sqrt(ess)),'outputs/original-c2-confirmation.csv',row.names=FALSE)
saveRDS(draws,'outputs/original-c2-confirmation-draws.rds');writeLines(as.character(proc.time()[3]-start),'outputs/original-c2-confirmation-time.txt')
