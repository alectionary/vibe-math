# Original reconstruction of Schwabe (2016), Chapters 2 and 5.
# Run from this study directory: Rscript simulation/jags_replication.R chapter N J effect difficulty seed adapt burn draws tag
args <- commandArgs(TRUE)
ch <- as.integer(args[1]); N <- as.integer(args[2]); J <- as.integer(args[3]); effect <- as.numeric(args[4]); difficulty <- as.numeric(args[5]); seed <- as.integer(args[6]); nadapt <- as.integer(args[7]); nburn <- as.integer(args[8]); ndraw <- as.integer(args[9]); tag <- args[10]
options(jags.moddir=Sys.getenv('JAGS_MODULE_PATH','/workspace/slot3-runtime/usr/lib/x86_64-linux-gnu/JAGS/modules-4'))
library(rjags); library(coda)
set.seed(seed); nmz <- round(.28*N); rho <- c(rep(1,nmz),rep(.5,N-nmz))
# Independent non-centred generator. Genetic covariance is rho * var(A).
M <- rbinom(N,1,if(length(args)>10) as.numeric(args[11]) else .5)
Avar <- if(ch==2) .5 else .25; Cvar <- if(ch==2) .3 else .25; Evar <- if(ch==2) .2 else .5
A1 <- rnorm(N,sd=sqrt(Avar)); A2 <- rho*A1 + sqrt(Avar*(1-rho^2))*rnorm(N)
C <- rnorm(N,sd=sqrt(Cvar)); A <- cbind(A1,A2)
theta <- A + C + if(ch==5) .7*M else 0
if(ch==2) theta <- theta + matrix(rnorm(2*N),N,2)*sqrt(Evar*exp(effect*A)) else theta <- theta+matrix(rnorm(2*N,sd=sqrt(Evar)),N,2)
b <- if(ch==2) rnorm(J,difficulty,1) else seq(-3.2,3.2,length.out=J)
y <- array(0,c(N,2,J)); for(k in 1:J) y[,,k] <- matrix(rbinom(2*N,1,plogis(theta-b[k])),N,2)
ys <- matrix(apply(y,c(1,2),sum),N,2)
alpha <- J/(J-1)*(1-sum(apply(matrix(aperm(y,c(1,2,3)),2*N,J),2,var))/var(as.vector(ys)))
skew <- function(x) {n<-length(x); n/((n-1)*(n-2))*sum(((x-mean(x))/sd(x))^3)}
# Rasch likelihood, with normal latent ACE effects. Priors follow pp. 18 and 77.
prior <- if(ch==2) 'ta ~ dgamma(1,1); tc ~ dgamma(1,1); va <- 1/ta; vc <- 1/tc; beta0 ~ dnorm(0,1); beta1 ~ dnorm(0,.1); ve <- exp(beta0)' else 'for(k in 1:3){b0[k] ~ dnorm(-1,.5); b1[k] ~ dnorm(0,.1)}; main ~ dnorm(0,.1); va <- exp(b0[1]); vc <- exp(b0[2]); ve <- exp(b0[3])'
latent <- if(ch==2) 'vaf[i] <- va; vcf[i] <- vc; location[i] <- mu; for(t in 1:2){prec[i,t] <- exp(-beta0-beta1*a[i,t])}' else 'vaf[i] <- exp(b0[1]+b1[1]*M[i]); vcf[i] <- exp(b0[2]+b1[2]*M[i]); location[i] <- mu+main*M[i]; for(t in 1:2){prec[i,t] <- exp(-b0[3]-b1[3]*M[i])}'
measurement <- 'for(k in 1:J){logit(p[i,t,k]) <- theta[i,t]-b[k]; y[i,t,k] ~ dbern(p[i,t,k])}'
make_model <- function(measurement) paste('model {mu ~ dnorm(0,.1);',prior,'; for(i in 1:N){',latent,'; zc[i] ~ dnorm(0,1); za[i] ~ dnorm(0,1); zb[i] ~ dnorm(0,1); c[i] <- sqrt(vcf[i])*zc[i]; a[i,1] <- sqrt(vaf[i])*za[i]; a[i,2] <- sqrt(vaf[i])*(rho[i]*za[i]+sqrt(1-rho[i]*rho[i])*zb[i]); for(t in 1:2){theta[i,t] ~ dnorm(location[i]+a[i,t]+c[i],prec[i,t]);',measurement,'}}}')
vars <- if(ch==2) c('va','vc','ve','beta1','mu') else c('va','vc','ve','b1','main','mu')
data <- list(N=N,J=J,b=b,y=y,rho=rho,M=M)
mode <- if(length(args)>11) args[12] else 'items'
if(mode=='sums') {data <- list(N=N,rho=rho,theta=matrix(as.numeric(scale(as.vector(ys))),N,2),M=M); measurement <- ''}
start <- proc.time()[3]
result <- tryCatch({
 model <- jags.model(textConnection(gsub(";", "\n", make_model(measurement), fixed=TRUE)),data=data,inits=list(.RNG.name='base::Mersenne-Twister',.RNG.seed=as.integer(Sys.getenv("MCMC_SEED",seed+1))),n.chains=1,n.adapt=nadapt,quiet=TRUE)
 init_seconds <- proc.time()[3]-start
 update(model,nburn,progress.bar='none'); burn_seconds <- proc.time()[3]-start-init_seconds
 draws <- coda.samples(model,vars,ndraw,progress.bar='none'); mat<-as.matrix(draws)
 draw_seconds <- proc.time()[3]-start-init_seconds-burn_seconds
 hpd <- HPDinterval(draws)[[1]]; ess <- effectiveSize(draws)
 out <- data.frame(parameter=colnames(mat),mean=colMeans(mat),sd=apply(mat,2,sd),low=hpd[,1],high=hpd[,2],ess=as.numeric(ess),mcse=apply(mat,2,sd)/sqrt(as.numeric(ess)))
 saveRDS(draws,file.path('outputs',paste0(tag,'-draws.rds')))
 out
},error=function(e) data.frame(error=conditionMessage(e)))
write.csv(result,file.path('outputs',paste0(tag,'.csv')),row.names=FALSE)
write.csv(data.frame(ch,N,J,effect,difficulty,seed,nadapt,nburn,ndraw,mode,elapsed_seconds=proc.time()[3]-start,alpha,skew1=skew(ys[,1]),skew2=skew(ys[,2])),file.path('outputs',paste0(tag,'-run.csv')),row.names=FALSE)
if(exists('draw_seconds')) write.csv(data.frame(init_seconds,burn_seconds,draw_seconds),file.path('outputs',paste0(tag,'-timing.csv')),row.names=FALSE)
print(result); print(proc.time()[3]-start)
if('error' %in% names(result)) quit(status=1)
