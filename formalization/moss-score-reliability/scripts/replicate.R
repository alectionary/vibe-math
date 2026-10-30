# Original reconstruction of Moss (2020), Paper I Example 11; no upstream code copied.
# Run from repository root with Rscript; dependencies lavaan and OpenMx.
suppressPackageStartupMessages(library(lavaan))
suppressPackageStartupMessages(library(OpenMx))
mxOption(NULL, 'Number of Threads', 1)
root <- 'formalization/moss-score-reliability'
load(file.path(root,'inputs/bfi.rda'))
traits <- c('A','C','E','N','O')
# Equation (5): reliability of the sign-aligned weighted score, conditional on model.
score_reliability <- function(loadings, residual_variances) {
  a <- abs(loadings)
  weights <- list(R=rep(1,length(a)), H=a/residual_variances,
                  S=1/sqrt(a*a+residual_variances), sigma=1/sqrt(residual_variances))
  vapply(weights,function(w) {
    signal <- sum(w*a)^2
    signal/(signal+sum(w*w*residual_variances))
  },numeric(1))
}
result <- parameters <- diagnostics <- independent <- list()
started <- proc.time()
for (trait in traits) {
  vars <- paste0(trait,1:5)
  d <- bfi[complete.cases(bfi[vars]),vars]
  syntax <- paste('f =~',paste(vars,collapse=' + '))
  fit <- cfa(syntax,data=d,std.lv=TRUE,estimator='ML',meanstructure=FALSE,
             missing='listwise',likelihood='normal')
  stopifnot(lavInspect(fit,'converged'),lavInspect(fit,'post.check'))
  p <- lavInspect(fit,'est'); a <- as.vector(p$lambda); v <- diag(p$theta)
  value <- score_reliability(a,v)
  result[[trait]] <- data.frame(trait=trait,metric=names(value),ours=as.numeric(value),n=nrow(d))
  parameters[[trait]] <- data.frame(trait=trait,item=vars,loading=a,residual_variance=v)
  f <- fitMeasures(fit,c('chisq','df','cfi','rmsea','srmr'))
  diagnostics[[trait]] <- data.frame(trait=trait,n=nrow(d),chisq=f[1],df=f[2],cfi=f[3],rmsea=f[4],srmr=f[5])
  # Separate OpenMx matrix-algebra model, unit factor variance, covariance ML.
  # Supply the unbiased sample covariance; OpenMx normal ML internally applies
  # the (N-1)/N moment normalization, matching lavaan normal likelihood.
  S <- cov(d)
  model <- mxModel(paste0('independent_',trait),
    mxMatrix('Full',5,1,free=TRUE,values=sign(a)*.7,name='L'),
    mxMatrix('Diag',5,5,free=TRUE,values=rep(1,5),lbound=1e-6,name='V'),
    mxAlgebra(L %*% t(L)+V,name='Sigma',dimnames=list(vars,vars)),
    mxData(S,type='cov',numObs=nrow(d)),
    mxExpectationNormal(covariance='Sigma',dimnames=vars),mxFitFunctionML())
  mx <- mxRun(model,silent=TRUE)
  stopifnot(mx$output$status$code %in% c(0,1))
  ma <- as.vector(mxEval(L,mx)); mv <- diag(mxEval(V,mx))
  # Independent formulas: squared signal/noise ratios rather than generic weights.
  q <- abs(ma)/sqrt(mv)
  rr <- c(R=sum(abs(ma))^2/(sum(abs(ma))^2+sum(mv)),
          H=sum(q*q)/(1+sum(q*q)),
          S=sum(abs(ma)/sqrt(ma*ma+mv))^2 /
            (sum(abs(ma)/sqrt(ma*ma+mv))^2+sum(mv/(ma*ma+mv))),
          sigma=sum(q)^2/(sum(q)^2+length(q)))
  independent[[trait]] <- data.frame(trait=trait,metric=names(rr),openmx=as.numeric(rr),
    lavaan=as.numeric(value),difference=as.numeric(rr-value),status=mx$output$status$code,
    max_covariance_gap=max(abs(mxEval(Sigma,mx)-fitted(fit)$cov)))
}
write.csv(do.call(rbind,result),file.path(root,'outputs/results.csv'),row.names=FALSE)
write.csv(do.call(rbind,parameters),file.path(root,'outputs/parameters.csv'),row.names=FALSE)
write.csv(do.call(rbind,diagnostics),file.path(root,'outputs/fit-diagnostics.csv'),row.names=FALSE)
write.csv(do.call(rbind,independent),file.path(root,'outputs/independent.csv'),row.names=FALSE)
capture.output(sessionInfo(),file=file.path(root,'outputs/sessionInfo.txt'))
writeLines(sprintf('elapsed_seconds=%.3f', (proc.time()-started)[['elapsed']]),file.path(root,'outputs/runtime.txt'))
