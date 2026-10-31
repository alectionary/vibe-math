"""Read saved RDS draws only; independently check summaries and Rhat, never fit a model."""
import numpy as np,pandas as pd,json
import subprocess,tempfile,atexit
from scipy.stats import rankdata,norm
from scipy.special import expit
from pathlib import Path
root=Path(__file__).resolve().parents[1];folder=root/'production/jags-gate-v1/prepared/diagnostics'
workspace=tempfile.TemporaryDirectory(prefix='schwabe-saved-draw-check-');atexit.register(workspace.cleanup);tmp=Path(workspace.name)
export="root <- 'production/jags-gate-v1/prepared'\np <- readRDS(file.path(root,'protocol.rds')); ins<-readRDS(file.path(root,'initials.rds')); d<-readRDS(file.path(root,'data.rds'))\nfor(i in 1:4){\n req<-readRDS(file.path(root,paste0('chain-',i),'request.rds'));res<-readRDS(file.path(root,paste0('chain-',i),'result.rds'));m<-readRDS(file.path(root,paste0('chain-',i),'draws.rds'))\n stopifnot(identical(req$protocol,p),identical(req$initials,ins[[i]]),req$chain==i,res$chain==i,nrow(m)==12000,ncol(m)==14,all(is.finite(m)),res$adaptation_complete,res$retained==12000,res$all_finite,res$draws_sha256==strsplit(system2('sha256sum',shQuote(file.path(root,paste0('chain-',i),'draws.rds')),stdout=TRUE),' ',fixed=TRUE)[[1]][1])\n write.table(m,paste0('/tmp/schwabe-jags-review/chain-',i,'.csv'),sep=',',row.names=FALSE,col.names=TRUE)\n}\nwriteLines(format(d$b[1],digits=17),'/tmp/schwabe-jags-review/b1.txt')\nprint(p[c('adaptation','burn_in','retained','thin','chain_seeds')])\n"
(tmp/'export.R').write_text(export.replace('/tmp/schwabe-jags-review',str(tmp)))
subprocess.run(['/workspace/slot3-runtime/bin/Rscript',str(tmp/'export.R')],cwd=root,check=True,stdout=subprocess.DEVNULL)
frames=[pd.read_csv(tmp/f'chain-{i}.csv') for i in range(1,5)];diag=pd.read_csv(folder/'diagnostics.csv').set_index('parameter');hpd=pd.read_csv(folder/'hpd-segment-sensitivity.csv');cs=pd.read_csv(folder/'chain-summaries.csv');b=float((tmp/'b1.txt').read_text())
def hp(x):
 y=np.sort(x);gap=int(np.floor(len(y)*.95));i=np.argmin(y[gap:]-y[:-gap]);return y[i],y[i+gap]
def rh(x):
 n=x.shape[0];w=np.var(x,axis=0,ddof=1).mean();bb=n*np.var(x.mean(axis=0),ddof=1);return np.sqrt(((n-1)*w/n+bb/n)/w)
def rankrh(x):
 split=np.column_stack([x[:6000],x[6000:]])
 def rn(z):return norm.ppf((rankdata(z).reshape(z.shape)-.375)/(z.size+.25))
 return max(rh(rn(split)),rh(rn(abs(split-np.median(split)))))
maxerr={'rhat':0.,'pooled_mean':0.,'pooled_sd':0.,'pooled_hpd':0.,'segment_hpd':0.,'log_transforms':0.,'conditional_probability_transform':0.};sensitivity={}
for v in frames[0]:
 x=np.column_stack([f[v] for f in frames]);d=diag.loc[v]
 maxerr['rhat']=max(maxerr['rhat'],abs(rankrh(x)-d.rhat_rank_split_folded));maxerr['pooled_mean']=max(maxerr['pooled_mean'],abs(x.mean()-d['mean']));maxerr['pooled_sd']=max(maxerr['pooled_sd'],abs(x.std(ddof=1)-d.sd));maxerr['pooled_hpd']=max(maxerr['pooled_hpd'],max(abs(np.array(hp(x.flatten()))-np.array([d.hpd_pooled_low,d.hpd_pooled_high]))))
 for i in range(4):
  for segment,z in [('whole',x[:,i]),('first_half',x[:6000,i]),('second_half',x[6000:,i])]:
   r=hpd[(hpd.parameter==v)&(hpd.chain==i+1)&(hpd.segment==segment)].iloc[0];maxerr['segment_hpd']=max(maxerr['segment_hpd'],max(abs(np.array(hp(z))-np.array([r.low,r.high]))))
 rows=hpd[hpd.parameter==v];means=cs[cs.parameter==v]['mean'];sensitivity[v]={'chain_mean_range':[means.min(),means.max()],'segment_lower_endpoint_range':[rows.low.min(),rows.low.max()],'segment_upper_endpoint_range':[rows.high.min(),rows.high.max()],'segments_excluding_zero':int(rows.excludes_zero.sum()),'segments':len(rows)}
for f in frames:
 for v in ['va','vc','ve']:maxerr['log_transforms']=max(maxerr['log_transforms'],abs(np.log(f[v])-f['log_'+v]).max())
 for j in [1,2]:maxerr['conditional_probability_transform']=max(maxerr['conditional_probability_transform'],abs(expit(f[f'theta[1,{j}]']-b)-f[f'p[1,{j},1]']).max())
assert all(e<1e-10 for e in maxerr.values()),maxerr
print(json.dumps({'maximum_absolute_discrepancies':maxerr,'hpd_sensitivity':sensitivity},indent=2))
