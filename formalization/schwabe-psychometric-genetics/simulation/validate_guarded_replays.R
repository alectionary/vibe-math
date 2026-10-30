# Independent replay comparison; run after the three commands in production-guard-review.json.
args<-commandArgs(TRUE);replay_dir<-if(length(args))args[1] else '/tmp/schwabe-independent-guard-check'
rows<-list()
for(case in list(c('2','MCAR','independent-q2-MCAR'),c('2','MAR','independent-q2-MAR'),c('5','MNAR','independent-q5-MNAR-v2'))) {
 q<-as.integer(case[1]);mech<-case[2];tag<-case[3]
 for(m in c('full','deletion')) {
  old<-read.csv(sprintf('outputs/pilot-c6-%s-q%d-m0.1-r0-%s.csv',mech,q,m))
  new<-read.csv(file.path(replay_dir,sprintf('%s-%s.csv',tag,m)))
  diag<-readRDS(file.path(replay_dir,sprintf('%s-%s-diagnostics.rds',tag,m)))$diagnostic
  stopifnot(all(new$valid),identical(old$parameter,new$parameter))
  gap<-max(abs(as.matrix(old[,c('estimate','se','minus2loglik')])-as.matrix(new[,c('estimate','se','minus2loglik')])))
  stopifnot(gap<1e-10)
  H<-diag$hessian;V<-diag$covariance;J<-diag$jacobian
  inv_gap<-max(abs(V-2*solve(H)));se_gap<-max(abs(new$se-sqrt(diag(J%*%V%*%t(J)))))
  stopifnot(inv_gap<1e-10,se_gap<1e-12,min(eigen(H,symmetric=TRUE,only.values=TRUE)$values)>0,min(eigen(V,symmetric=TRUE,only.values=TRUE)$values)>0)
  rows[[length(rows)+1]]<-data.frame(q=q,mechanism=mech,method=m,parameter_rows=nrow(new),maximum_baseline_difference=gap,independent_inverse_covariance_difference=inv_gap,independent_delta_se_difference=se_gap,all_guard_valid=all(new$valid))
 }
}
write.csv(do.call(rbind,rows),'outputs/independent-guard-replays.csv',row.names=FALSE)
print(do.call(rbind,rows))
