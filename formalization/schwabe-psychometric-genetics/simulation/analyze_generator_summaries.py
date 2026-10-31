"""Analyze the fixed completed response-generation grid; no new simulations."""
import csv,json,math,statistics,hashlib
from pathlib import Path
root=Path(__file__).resolve().parents[1]
base=root/'production/generator-summary-v1'
rows=list(csv.DictReader((base/'summaries.csv').open()));grid=list(csv.DictReader((base/'conditions.csv').open()))
assert len(rows)==2650 and len({int(r['seed']) for r in rows})==2650
assert len(grid)==19
metrics=['alpha_all','alpha_DZ','alpha_twin1','skew_g1','skew_G1','skew_b1','skew_min','skew_max']
def quantile(x,p):
    x=sorted(x);a=(len(x)-1)*p;i=int(a);return x[i]+(a-i)*(x[min(i+1,len(x)-1)]-x[i])
def stats(x):return dict(mean=statistics.mean(x),replicate_sd=statistics.stdev(x),mcse_mean=statistics.stdev(x)/math.sqrt(len(x)),empirical_q025=quantile(x,.025),empirical_q975=quantile(x,.975),minimum=min(x),maximum=max(x),positive=sum(t>0 for t in x),negative=sum(t<0 for t in x))
out=[]
for g in grid:
    rr=[r for r in rows if r['condition']==g['condition']];n=int(g['replicates']);assert len(rr)==n and sorted(int(r['replicate']) for r in rr)==list(range(1,n+1))
    values={m:stats([float(r[m]) for r in rr]) for m in metrics}
    source_alpha=.9 if g['role'] in ('floor','ceiling') or (g['role']=='moderator' and int(g['J'])==60) else .92 if g['role']=='power' else .75
    mean=values['alpha_all']['mean']
    out.append(dict(condition=g,replicates=n,metrics=values,first_fixed_replicate={k:rr[0][k] for k in ['seed',*metrics]},source_alpha=source_alpha,descriptive_mean_minus_source_alpha=mean-source_alpha,mean_rounds_to_printed_two_decimal_alpha=f'{mean:.2f}'==f'{source_alpha:.2f}',interpretation='Rounding comparison of our across-dataset mean only; source aggregation/calibration/subset unspecified. Not a source-estimand match or a hypothesis test.'))
x={'input_sha256':{str(p.relative_to(root)):hashlib.sha256(p.read_bytes()).hexdigest() for p in [base/'summaries.csv',base/'conditions.csv',root/'simulation/generator_summary_check.R']},'analysis_script_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'completed_generation_datasets':2650,'posterior_fits':0,'conditions':out,'uncertainty':'Across-independent-dataset MCSE describes our reconstruction mean; empirical quantiles describe replicate variability and are not confidence bands or source uncertainty. Within-dataset twins dependent. Source skew endpoints are three estimators applied to an illustrative unknown-seed DZ sample, not original replicate extrema. Pilot19datasets repeat first fixed seeds and are not additional independent observations.','source_comparability':'Source alpha subset/aggregation and fixed-vs-redrawn Chapter2 calibration unspecified; Chapter5 moderator probability.5 remains supplied assumption. Means versus quoted illustrative/rounded descriptors cannot establish definitive numerical replication/nonreplication.'}
(root/'outputs/generator-summary-analysis.json').write_text(json.dumps(x,indent=2)+'\n')
print(json.dumps({'conditions':19,'datasets':2650,'posterior_fits':0,'rounding_matches_of_our_means':sum(r['mean_rounds_to_printed_two_decimal_alpha'] for r in out),'not_a_replication_success_fraction':True}))
