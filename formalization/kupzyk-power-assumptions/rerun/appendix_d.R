source('formalization/kupzyk-power-assumptions/rerun/profile_reml.R')

# SAS/STAT 9.2 PROC MIXED containment with no random term syntactically
# containing time*group uses M-rank([X Z]). Person columns already span X
# and the cluster columns; each person contributes min(k,2) to this rank.
containment_df <- function(d) sum(d$k-pmin(d$k,2L))

# Scalar Satterthwaite approximation from the observed curvature of the
# full REML objective. At a boundary keep only active variance components.
sat_df <- function(d,z,f) {
 s <- reml_statistics(as.integer(d$k),as.integer(d$cluster),z$y,max(d$cluster))
 control <- max(d$cluster[d$group==0])
 par <- c(f[c('person_intercept','person_slope','cluster_intercept','cluster_slope')]/
            f[['residual']], f[['residual']])
 active <- par>1e-5
 q <- par[active]
 metrics <- function(q) {
  v <- par;v[active] <- q
  ev <- reml_eval(v[1:4],s,control,TRUE)
  c(ev[['logdet']]+ev[['df_reml']]*log(v[5])+ev[['rss']]/v[5],
    ev[['variance_ratio']]*v[5])
 }
 step <- pmin(q*.15,pmax(1,abs(q))*.00012)
 E <- diag(step,nrow=length(step))
 g <- numeric(length(q));H <- matrix(0,length(q),length(q));origin <- metrics(q)
 for(i in seq_along(q)) {
  hi <- metrics(q+E[i,]);lo <- metrics(q-E[i,])
  H[i,i] <- (hi[1]+lo[1]-2*origin[1])/step[i]^2
  g[i] <- (hi[2]-lo[2])/(2*step[i])
  if(i>1L) for(j in seq_len(i-1L)) {
   H[i,j] <- (metrics(q+E[i,]+E[j,])[1]-metrics(q+E[i,]-E[j,])[1]-
                metrics(q-E[i,]+E[j,])[1]+metrics(q-E[i,]-E[j,])[1])/(4*step[i]*step[j])
   H[j,i] <- H[i,j]
  }
 }
 adj <- tryCatch(forwardsolve(t(chol(H)),g),error=function(e) rep(NA_real_,length(q)))
 origin[2]^2/sum(adj^2)  # inverse information = 2 * inverse H
}

run_validation <- function(path) {
 rows <- list()
 set.seed(20960411)
 for(i in c(1L,54L)) for(rep in 1:20) {
  J <- if(i==1L) 16L else 28L;icc <- if(i==1L) .05 else .15
  d <- if(i==1L) design(J,icc,0,.5,1,FALSE) else design(J,icc,.15,.7,3,FALSE)
  z <- generate(d,icc,effect=if(rep%%2) 0 else .5)
  f <- fit_profile(d,z,icc)
  l <- suppressMessages(lmerTest::lmer(y~time*group+(1|cluster)+(0+time|cluster)+
                                        (1|person)+(0+time|person),data=z,REML=TRUE))
  ref <- coef(summary(l,ddf='Satterthwaite'))['time:group',]
  df <- sat_df(d,z,f)
  xz <- cbind(lme4::getME(l,'X'),lme4::getME(l,'Z'))
  rank_df <- nrow(z)-as.integer(Matrix::rankMatrix(xz,method='qr.R'))
  rows[[length(rows)+1]] <- data.frame(cell=i,draw=rep,sat_df=df,lmerTest_df=ref[4],
    sat_p=2*pt(-abs(f[['beta']]/f[['se']]),df),lmerTest_p=ref[5],
    containment_df=containment_df(d),containment_rank_check=rank_df,
    profile_boundary=f[['boundary']],lme4_boundary=lme4::isSingular(l))
 }
 a <- do.call(rbind,rows)
 write.csv(a,path,row.names=FALSE)
 stopifnot(all(a$containment_df==a$containment_rank_check))
}
if(sys.nframe()==0) run_validation(commandArgs(TRUE)[[1]])
