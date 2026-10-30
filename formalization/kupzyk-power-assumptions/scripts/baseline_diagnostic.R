source('formalization/kupzyk-power-assumptions/scripts/model.R')
e<-read.csv(file.path(base,'outputs/empirical-draws.csv'))
e<-e[e$cell==1 & e$tag%in%c('main','baseline-extra') & e$converged==1,]
v<-info_blocks(design(16,.05,0,.5,1),.05);crit<-qt(.975,1262)
known<-abs(e$beta/sqrt(v))>crit;estimated<-e$pbw<=.05;diff<-as.numeric(estimated)-as.numeric(known)
out<-data.frame(n=nrow(e),known_variance_rejections=mean(known),refitted_variance_rejections=mean(estimated),paired_difference=mean(diff),paired_se=sd(diff)/sqrt(length(diff)),beta_mean=mean(e$beta),beta_sd=sd(e$beta),known_se=sqrt(v),mean_fitted_se=mean(e$se),fixed_ncf_power=power_value(v,1262),known_normal_power=pnorm(-crit,mean=.5/sqrt(v))+pnorm(crit,mean=.5/sqrt(v),lower.tail=FALSE),cluster_slope_nct_power=pt(-crit,14,ncp=.5/sqrt(v))+pt(crit,14,ncp=.5/sqrt(v),lower.tail=FALSE))
write.csv(out,file.path(base,'outputs/baseline-diagnostic.csv'),row.names=FALSE)
