"""Read saved RDS draws only; independently check summaries and Rhat, never fit a model."""
import numpy as np,pandas as pd,json
import subprocess,tempfile,atexit,argparse
from scipy.stats import rankdata,norm
from scipy.special import expit
from pathlib import Path
root=Path(__file__).resolve().parents[1]
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--namespace',default='production/jags-centered-extended-recovery-v1')
args=parser.parse_args()
namespace=(root/args.namespace).resolve()
assert namespace.is_relative_to(root/'production') and namespace != root/'production'
folder=namespace/'prepared/diagnostics'
ledger=json.loads((namespace/'chains/outcomes.json').read_text())
assert ledger['requested']==4 and len(ledger['outcomes'])==4
assert sorted(r['id'] for r in ledger['outcomes'])==[1,2,3,4]
assert all(r['state']=='exited' and r['returncode']==0 for r in ledger['outcomes'])
requests=json.loads((namespace/'requested-chains.json').read_text())
assert requests['requested']==4 and len(requests['commands'])==4
workspace=tempfile.TemporaryDirectory(prefix='schwabe-saved-draw-check-');atexit.register(workspace.cleanup);tmp=Path(workspace.name)
export="root <- commandArgs(TRUE)[1]\np <- readRDS(file.path(root,'protocol.rds')); ins<-readRDS(file.path(root,'initials.rds')); d<-readRDS(file.path(root,'data.rds'))\nfor(i in 1:4){\n req<-readRDS(file.path(root,paste0('chain-',i),'request.rds'));res<-readRDS(file.path(root,paste0('chain-',i),'result.rds'));m<-readRDS(file.path(root,paste0('chain-',i),'draws.rds'))\n stopifnot(p$requested_chains==4L,p$retained==28000L,p$adaptation==1000L,p$burn_in==7000L,p$thin==1L,identical(as.integer(p$chain_seeds),830101:830104),res$status=='completed',identical(req$protocol,p),identical(req$initials,ins[[i]]),req$chain==i,res$chain==i,nrow(m)==28000,ncol(m)==14,all(is.finite(m)),res$adaptation_complete,res$retained==28000,res$all_finite,res$draws_sha256==strsplit(system2('sha256sum',shQuote(file.path(root,paste0('chain-',i),'draws.rds')),stdout=TRUE),' ',fixed=TRUE)[[1]][1])\n write.table(m,paste0('/tmp/schwabe-jags-review/chain-',i,'.csv'),sep=',',row.names=FALSE,col.names=TRUE)\n}\nwriteLines(format(d$b[1],digits=17),'/tmp/schwabe-jags-review/b1.txt')\nprint(p[c('adaptation','burn_in','retained','thin','chain_seeds')])\n"
(tmp/'export.R').write_text(export.replace('/tmp/schwabe-jags-review',str(tmp)))
subprocess.run(['/workspace/slot3-runtime/bin/Rscript',str(tmp/'export.R'),str(namespace/'prepared')],cwd=root,check=True,stdout=subprocess.DEVNULL)
frames=[pd.read_csv(tmp/f'chain-{i}.csv') for i in range(1,5)];diag=pd.read_csv(folder/'diagnostics.csv').set_index('parameter');hpd=pd.read_csv(folder/'hpd-segment-sensitivity.csv');cs=pd.read_csv(folder/'chain-summaries.csv');b=float((tmp/'b1.txt').read_text())
def hp(x):
 y=np.sort(x);gap=int(np.floor(len(y)*.95));i=np.argmin(y[gap:]-y[:-gap]);return y[i],y[i+gap]
def rh(x):
 n=x.shape[0];w=np.var(x,axis=0,ddof=1).mean();bb=n*np.var(x.mean(axis=0),ddof=1);return np.sqrt(((n-1)*w/n+bb/n)/w)
def rankrh(x):
 split=np.column_stack([x[:14000],x[14000:]])
 def rn(z):return norm.ppf((rankdata(z).reshape(z.shape)-.375)/(z.size+.25))
 return max(rh(rn(split)),rh(rn(abs(split-np.median(split)))))
maxerr={'rhat':0.,'pooled_mean':0.,'pooled_sd':0.,'pooled_hpd':0.,'segment_hpd':0.,'log_transforms':0.,'conditional_probability_transform':0.,'chain_summary':0.};sensitivity={}
for v in frames[0]:
 x=np.column_stack([f[v] for f in frames]);d=diag.loc[v]
 maxerr['rhat']=max(maxerr['rhat'],abs(rankrh(x)-d.rhat_rank_split_folded));maxerr['pooled_mean']=max(maxerr['pooled_mean'],abs(x.mean()-d['mean']));maxerr['pooled_sd']=max(maxerr['pooled_sd'],abs(x.std(ddof=1)-d.sd));maxerr['pooled_hpd']=max(maxerr['pooled_hpd'],max(abs(np.array(hp(x.flatten()))-np.array([d.hpd_pooled_low,d.hpd_pooled_high]))))
 for i in range(4):
  row=cs[(cs.parameter==v)&(cs.chain==i+1)].iloc[0]
  expected=np.array([x[:,i].mean(),x[:,i].std(ddof=1),*np.quantile(x[:,i],[.025,.975])])
  maxerr['chain_summary']=max(maxerr['chain_summary'],max(abs(expected-np.array([row['mean'],row.sd,row.low,row.high]))))
  for segment,z in [('whole',x[:,i]),('first_half',x[:14000,i]),('second_half',x[14000:,i])]:
   r=hpd[(hpd.parameter==v)&(hpd.chain==i+1)&(hpd.segment==segment)].iloc[0];maxerr['segment_hpd']=max(maxerr['segment_hpd'],max(abs(np.array(hp(z))-np.array([r.low,r.high]))))
 rows=hpd[hpd.parameter==v];means=cs[cs.parameter==v]['mean'];sensitivity[v]={'chain_mean_range':[means.min(),means.max()],'segment_lower_endpoint_range':[rows.low.min(),rows.low.max()],'segment_upper_endpoint_range':[rows.high.min(),rows.high.max()],'segments_excluding_zero':int(rows.excludes_zero.sum()),'segments':len(rows)}
for f in frames:
 for v in ['va','vc','ve']:maxerr['log_transforms']=max(maxerr['log_transforms'],abs(np.log(f[v])-f['log_'+v]).max())
 for j in [1,2]:maxerr['conditional_probability_transform']=max(maxerr['conditional_probability_transform'],abs(expit(f[f'theta[1,{j}]']-b)-f[f'p[1,{j},1]']).max())
assert len(diag)==14 and len(hpd)==168 and len(cs)==56
assert all(list(f.columns)==list(frames[0].columns) for f in frames)
assert set(diag.index)==set(frames[0].columns)
gate=(diag.rhat_rank_split_folded<1.01)&(diag.ess_bulk>=400)&(diag.ess_tail>=400)&(diag.mcse_over_sd<=.05)&(diag.sd>0)&diag.all_finite
assert np.array_equal(gate.to_numpy(),diag.operational_gate_pass.to_numpy())
assert np.isfinite(diag[['rhat_rank_split_folded','ess_bulk','ess_tail','mcse_mean','sd']]).all().all()
assert np.max(abs(diag.mcse_mean/diag.sd-diag.mcse_over_sd))<1e-10
assert all(e<1e-10 for e in maxerr.values()),maxerr
print(json.dumps({'namespace':str(namespace.relative_to(root)),'requested_chains':4,'completed_chains':4,'retained_per_chain':28000,'all_adapted_and_finite':True,'all_operational_gates_pass':bool(gate.all()),'failed_parameters':list(diag.index[~gate]),'maximum_absolute_discrepancies':maxerr,'hpd_sensitivity':sensitivity},indent=2))
