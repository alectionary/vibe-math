source('formalization/kupzyk-power-assumptions/scripts/model.R')
targets<-read.csv(file.path(base,'outputs/targets.csv'));set.seed(710229)
out<-list()
for(i in c(1,6,18,37,42,54))for(rep in 1:10){r<-targets[i,];J<-c(16,22,28)[match(r$icc,c(.05,.1,.15))];d<-design(J,r$icc,r$attrition,r$treat,r$size,FALSE);z<-generate(d,r$icc)
 f1<-fit_empirical(z);f2<-fit_empirical(z,'nlme');f3<-fit_empirical(z,optimizer='nloptwrap');fm<-fit_empirical(z,reml=FALSE)
 out[[length(out)+1]]<-data.frame(cell=i,rep=rep,engine=c('lme4-bobyqa','nlme','lme4-nloptwrap','lme4-ML'),rbind(f1,f2,f3,fm))
}
write.csv(do.call(rbind,out),file.path(base,'outputs/independent-engines.csv'),row.names=FALSE)
# Source-count, allocation, covariance, and alternative-generator structural checks.
checks<-list()
for(i in 1:54){r<-targets[i,];d<-design(r$J,r$icc,r$attrition,r$treat,r$size);N<-nrow(d);M<-sum(d$k)
 expected<-4*N-sum(sasround(r$attrition*(1:3)*N));stopifnot(M==expected)
 counts<-table(d$cluster);stopifnot(all(counts==sizes(r$J,r$size)))
 z<-generate(d,r$icc,method='dense');C<-model.matrix(~cluster-1,z);W<-cbind(z$time,z$time*z$group)
 rank<-qr(cbind(C,W))$rank;stopifnot(rank==r$J+2)
 checks[[i]]<-data.frame(cell=i,N=N,M=M,rank=rank,df=M-rank,control=sasround(r$J*(1-r$treat)))
}
write.csv(do.call(rbind,checks),file.path(base,'outputs/design-checks.csv'),row.names=FALSE)
