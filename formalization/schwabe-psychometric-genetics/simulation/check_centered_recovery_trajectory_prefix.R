# Saved-data-only dependence audit; no compilation or sampling.
args<-commandArgs(TRUE);stopifnot(length(args)==2,!file.exists(args[1]));rows<-list()
for(i in 1:4){
 old<-readRDS(file.path('production/jags-centered-gate-v1/prepared',paste0('chain-',i),'draws.rds'))
 new<-readRDS(file.path(file.path(args[2],'prepared'),paste0('chain-',i),'draws.rds'))
 stopifnot(nrow(old)==12000,nrow(new)==28000,identical(colnames(old),colnames(new)))
 prefix<-new[seq_len(12000),,drop=FALSE]
 rows[[i]]<-data.frame(chain=i,old_retained=12000,new_retained=28000,identical_prefix=identical(prefix,old),maximum_absolute_prefix_difference=max(abs(prefix-old)),independent_datasets=0)
}
# Also audit every saved interrupted prefix; these are not independent draws.
for(i in 1:4){
 old<-readRDS(file.path('production/jags-centered-extended-v1/prepared',paste0('chain-',i),'partial-draws.rds'))
 new<-readRDS(file.path(args[2],'prepared',paste0('chain-',i),'draws.rds'))
 stopifnot(nrow(old)<=28000,all(colnames(old)%in%colnames(new)))
 prefix<-new[seq_len(nrow(old)),colnames(old),drop=FALSE]
 rows[[i+4]]<-data.frame(chain=i,old_retained=nrow(old),new_retained=28000,identical_prefix=identical(prefix,old),maximum_absolute_prefix_difference=max(abs(prefix-old)),independent_datasets=0)
}
write.csv(do.call(rbind,rows),args[1],row.names=FALSE);print(do.call(rbind,rows))
