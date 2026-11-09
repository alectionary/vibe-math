source('formalization/kupzyk-power-assumptions/rerun/profile_reml.R')
source(file.path(study,'rerun/fast_generator.R'))
# For V linear in variance parameters, the first derivative of X'V^-1 X
# is P_i, half its symmetric second derivative is Q_ij, and minus the
# Hessian of log|V| gives tr(V^-1 V_i V^-1 V_j). These yield the expected
# REML information and the KR correction without observation-sized matrices.
kr_scalar <- function(d, f, drop_boundary=FALSE) {
  J <- max(d$cluster)
  groups <- matrix(tabulate(d$cluster+(d$k-1L)*J,4L*J),J,4L)
  control <- max(d$cluster[d$group==0])
  par <- unname(f[c('person_intercept','person_slope','cluster_intercept','cluster_slope','residual')])
  active <- if(drop_boundary) which(par>1e-8) else 1:5
  m <- length(active)
  step <- rep(.00012,m)
  E <- matrix(0,5,m)
  E[cbind(active,seq_len(m))] <- step
  ev <- function(p) covariance_moments(p,groups,control)
  to_matrix <- function(x) {
    z <- matrix(0,4L,4L)
    z[1:2,1:2] <- x[c(1,2,2,3)]
    z[3:4,3:4] <- x[c(4,5,5,6)]
    z
  }
  origin <- ev(par)
  phi <- solve(to_matrix(origin))
  P <- vector('list',m)
  second <- array(0,c(7L,m,m))
  for(i in seq_len(m)) {
    hi <- ev(par+E[,i]);lo <- ev(par-E[,i])
    P[[i]] <- to_matrix((hi-lo)/(2*step[i]))
    second[,i,i] <- (hi+lo-2*origin)/step[i]^2
    if(i>1L) for(j in seq_len(i-1L)) {
      second[,i,j] <- (ev(par+E[,i]+E[,j])-ev(par+E[,i]-E[,j])-
                          ev(par-E[,i]+E[,j])+ev(par-E[,i]-E[,j]))/(4*step[i]*step[j])
      second[,j,i] <- second[,i,j]
    }
  }
  term <- vector('list',m*m)
  info <- matrix(0,m,m)
  for(i in seq_len(m)) for(j in seq_len(m)) {
    q <- to_matrix(second[,i,j])/2
    r <- P[[i]] %*% phi %*% P[[j]]
    term[[i+(j-1L)*m]] <- q-r
    info[i,j] <- -second[7,i,j]-2*sum(phi*q)+sum(phi*r)
  }
  w <- tryCatch(2*chol2inv(chol(info)),error=function(e) NULL)
  if(is.null(w)) return(c(df=NA_real_,p=NA_real_,se=NA_real_))
  L <- c(0,-1,0,1)
  v <- drop(phi %*% L)
  phi_l <- sum(L*v)
  u <- vapply(P,function(p)sum(v*(p%*%v))/phi_l,numeric(1))
  a <- sum(u*(w%*%u))
  correction <- sum(as.vector(w)*vapply(term,function(q)sum(v*(q%*%v)),numeric(1)))
  vv <- phi_l+2*correction
  if(a<=0 || vv<=0) return(c(df=NA_real_,p=NA_real_,se=NA_real_))
  df <- 2/a
  c(df=df,p=2*pt(-abs(f[['beta']])/sqrt(vv),df),se=sqrt(vv))
}

run_kr_validation <- function(path) {
  set.seed(20291109)
  rows <- list()
  for (cell in c(1L,54L)) for (rep in 1:8) {
    icc <- if(cell==1L) .05 else .15
    d <- if(cell==1L) design(16,icc,0,.5,1,FALSE) else design(28,icc,.15,.7,3,FALSE)
    z <- generate(d,icc,if(rep%%2L) 0 else .5)
    f <- fit_profile(d,z,icc)
    kr <- kr_scalar(d,f)
    fit <- suppressMessages(lmerTest::lmer(y~time*group+(1|cluster)+(0+time|cluster)+
                                           (1|person)+(0+time|person),data=z,REML=TRUE))
    ref <- coef(summary(fit,ddf='Kenward-Roger'))['time:group',]
    rows[[length(rows)+1L]] <- data.frame(cell=cell,draw=rep,profile_boundary=f[['boundary']],
      kr_df=kr[['df']],pbkrtest_df=ref[['df']],kr_se=kr[['se']],pbkrtest_se=ref[['Std. Error']],
      kr_p=kr[['p']],pbkrtest_p=ref[['Pr(>|t|)']])
    write.csv(do.call(rbind,rows),path,row.names=FALSE)
  }
  a <- do.call(rbind,rows)
  stopifnot(all(is.finite(a$kr_p)),max(abs(a$kr_p-a$pbkrtest_p))<.00025,
            max(abs(a$kr_df-a$pbkrtest_df))<.1)
}
if(sys.nframe()==0) run_kr_validation(commandArgs(TRUE)[[1]])
