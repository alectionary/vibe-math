source('formalization/kupzyk-power-assumptions/scripts/model.R')
x<-read.csv(file.path(base,'outputs/exemplary.csv'))
x$gap<-x$ours-x$published;x$prediction_se<-sqrt(x$mask_sd^2+x$mean_se^2)
x$z<-ifelse(x$prediction_se>0,x$gap/x$prediction_se,0)
x$p<-ifelse(x$prediction_se>0,2*pnorm(-abs(x$z)),1)
x$holm<-p.adjust(x$p,'holm');x$within_two_predictive_sd<-abs(x$gap)<=2*x$prediction_se+0.000005
draws<-read.csv(file.path(base,'outputs/exemplary-draws.csv'));x$predictive_rank_p<-vapply(seq_len(nrow(x)),function(i){if(x$attrition[i]==0)return(1);v<-draws$bw[draws$cell==x$cell[i]];min(1,2*min((1+sum(v<=x$published[i]))/(length(v)+1),(1+sum(v>=x$published[i]))/(length(v)+1)))},numeric(1));x$predictive_rank_holm<-p.adjust(x$predictive_rank_p,'holm');write.csv(x,file.path(base,'outputs/comparison.csv'),row.names=FALSE)
# Source single-mask uncertainty for contrasts; all coefficients explicit.
coefs<-list(attrition05=ifelse(x$attrition==0,1/18,ifelse(x$attrition==.05,-1/18,0)),attrition15=ifelse(x$attrition==0,1/18,ifelse(x$attrition==.15,-1/18,0)),imbalance=ifelse(x$treat==.5,1/27,-1/27),unequal=ifelse(x$size==1,1/18,-1/36))
effects<-do.call(rbind,lapply(names(coefs),function(name){w<-coefs[[name]];se<-sqrt(sum(w^2*x$prediction_se^2));gap<-sum(w*x$gap);data.frame(claim=name,published=100*sum(w*x$published),ours=100*sum(w*x$ours),prediction_se_pp=100*se,mean_se_pp=100*sqrt(sum(w^2*x$mean_se^2)),z=gap/se,p=2*pnorm(-abs(gap/se)))}))
effects$holm<-p.adjust(effects$p,'holm');write.csv(effects,file.path(base,'outputs/headline-effects.csv'),row.names=FALSE)
# Headline mechanism by ICC.
byicc<-do.call(rbind,lapply(unique(x$icc),function(icc){z<-x[x$icc==icc,];data.frame(icc=icc,attrition05=mean(z$ours[z$attrition==0])-mean(z$ours[z$attrition==.05]),attrition15=mean(z$ours[z$attrition==0])-mean(z$ours[z$attrition==.15]),imbalance=mean(z$ours[z$treat==.5])-mean(z$ours[z$treat==.7]),normal=mean(z$ours[z$size==1])-mean(z$ours[z$size==2]),skew=mean(z$ours[z$size==1])-mean(z$ours[z$size==3]))}))
write.csv(byicc,file.path(base,'outputs/icc-effects.csv'),row.names=FALSE)
if(file.exists(file.path(base,'outputs/empirical-draws.csv'))){
 e<-read.csv(file.path(base,'outputs/empirical-draws.csv'));e$tag[e$tag=='baseline-extra']<-'main'
 summarize<-function(v){ok<-v$converged==1&is.finite(v$pbw);p<-mean(v$pbw[ok]<=.05);po<-mean(v$pod[ok]<=.05)
 data.frame(cell=v$cell[1],tag=v$tag[1],requested=nrow(v),converged=sum(ok),failed=sum(!ok),singular=sum(v$singular==1,na.rm=TRUE),retries=sum(v$retried),power=p,se=sqrt(p*(1-p)/sum(ok)),od_power=po,unconditional_lower=sum(v$pbw[ok]<=.05)/nrow(v),unconditional_upper=(sum(v$pbw[ok]<=.05)+sum(!ok))/nrow(v),beta=mean(v$beta[ok]),mean_se=mean(v$se[ok]))}
 es<-do.call(rbind,lapply(split(e,list(e$cell,e$tag),drop=TRUE),summarize));write.csv(es,file.path(base,'outputs/empirical-summary.csv'),row.names=FALSE)
 null<-es[es$tag=='null',];null$published_bw<-ifelse(null$cell==1,.06839,.06279);null$published_od<-ifelse(null$cell==1,.04736,.04279);null$bw_gap<-null$power-null$published_bw;null$nominal_alpha<-.05;null$z_nominal<-(null$power-.05)/null$se;null$p_nominal<-2*pnorm(-abs(null$z_nominal));null$holm_nominal<-p.adjust(null$p_nominal,'holm');write.csv(null,file.path(base,'outputs/null-comparison.csv'),row.names=FALSE)
 gen<-merge(es[es$tag=='main',],es[es$tag=='independent-generator',],by='cell',suffixes=c('_components','_dense'));gen$gap<-gen$power_components-gen$power_dense;gen$combined_se<-sqrt(gen$se_components^2+gen$se_dense^2);gen$p<-2*pnorm(-abs(gen$gap/gen$combined_se));gen$holm<-p.adjust(gen$p,'holm');write.csv(gen,file.path(base,'outputs/generator-comparison.csv'),row.names=FALSE)
 init<-read.csv(file.path(base,'outputs/initial-exemplary.csv'));es<-merge(es[es$tag!='null',],init,by='cell');es$gap<-es$power-es$mean;es$z<-es$gap/es$se;es$p<-2*pnorm(-abs(es$z));es$holm<-ave(es$p,es$tag,FUN=function(p)p.adjust(p,'holm'))
 write.csv(es,file.path(base,'outputs/empirical-comparison.csv'),row.names=FALSE)
}
# Direct optimizer comparison on the same generated datasets.
v<-read.csv(file.path(base,'outputs/independent-engines.csv'));a<-v[v$engine=='lme4-bobyqa',];b<-v[v$engine=='nlme',];c<-v[v$engine=='lme4-nloptwrap',];ml<-v[v$engine=='lme4-ML',]
chk<-data.frame(cell=a$cell,rep=a$rep,beta_nlme=a$beta-b$beta,se_nlme=a$se-b$se,p_nlme=a$pbw-b$pbw,beta_nlopt=a$beta-c$beta,se_nlopt=a$se-c$se,p_nlopt=a$pbw-c$pbw,p_ml=ml$pbw-a$pbw)
write.csv(chk,file.path(base,'outputs/engine-differences.csv'),row.names=FALSE)
pdf(file.path(base,'paper/comparison-plot.pdf'),width=8,height=6)
par(mfrow=c(2,1),mar=c(4,4,2,1));plot(x$cell,x$published,pch=1,ylim=c(.64,.82),xlab='Table 1 cell (source order)',ylab='Power',main='Published single-mask power and reconstructed mean')
segments(x$cell,x$q025,x$cell,x$q975,col='gray');points(x$cell,x$ours,pch=16,cex=.5,col='navy');legend('topright',c('Published','Ours; gray: mask range'),pch=c(1,16),col=c('black','navy'),bty='n',cex=.7)
barplot(rbind(effects$published,effects$ours),beside=TRUE,names.arg=c('5% attrition','15% attrition','Imbalance','Unequal sizes'),col=c('gray60','navy'),ylab='Loss in percentage points',main='Headline losses, averaged over the final-stage design');legend('topleft',c('Published table','Ours'),fill=c('gray60','navy'),bty='n',cex=.7)
dev.off()
