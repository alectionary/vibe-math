# Execute locally acquired originals; do not copy their unlicensed text into git.
options(jags.moddir=Sys.getenv('JAGS_MODULE_PATH','/workspace/slot3-runtime/usr/lib/x86_64-linux-gnu/JAGS/modules-4'))
library(rjags);set.seed(303)
upstream<-Sys.getenv('SCHWABE_SOURCE','/tmp/schwabe-thesis')
base<-list(n_mz=12,n_dz=28,n_items=9,b=seq(-2,2,length.out=9),y_mz=matrix(rbinom(12*18,1,.5),12,18),y_dz=matrix(rbinom(28*18,1,.5),28,18))
rows<-list()
check<-function(file,variant,data,patch=function(x)x){
 t<-proc.time()[3]
 result<-tryCatch({txt<-patch(paste(readLines(file.path(upstream,file)),collapse='\n'));m<-jags.model(textConnection(txt),data=data,inits=list(.RNG.name='base::Mersenne-Twister',.RNG.seed=404),n.adapt=50,quiet=TRUE);update(m,50,progress.bar='none');v<-if(grepl('ACE_M',file)) 'beta_1e' else 'beta1';x<-as.matrix(coda.samples(m,v,50,progress.bar='none'));paste('Compiled; 50 adapt,50 burn,50 retained; mean',mean(x))},error=function(e)conditionMessage(e))
 rows[[length(rows)+1]]<<-data.frame(file,variant,result,seconds=proc.time()[3]-t)
}
check('AE_1PL.R','unmodified documented inputs',base)
check('AE_1PL.R','three identifier repairs',base,function(x){x<-gsub('1:ndz','1:n_dz',x,fixed=TRUE);x<-gsub('1:n.items','1:n_items',x,fixed=TRUE);gsub('Ydz','y_dz',x,fixed=TRUE)})
d<-base;d$x_MZ<-rbinom(12,1,.5);d$x_DZ<-rbinom(28,1,.5);check('ACE_M.R','unmodified',d)
d$x_MZ<-matrix(rbinom(24,1,.5),12,2);d$x_DZ<-matrix(rbinom(56,1,.5),28,2);check('ACE_M_separate_moderator_values.R','unmodified',d)
d<-base;d$b<-NULL;d$y_mz<-matrix(sample(1:3,12*18,TRUE),12);d$y_dz<-matrix(sample(1:3,28*18,TRUE),28);check('AE_AC_GPCM.R','unmodified',d)
write.csv(do.call(rbind,rows),'outputs/original-programs.csv',row.names=FALSE)
