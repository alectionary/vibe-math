"""Deterministic target audit on an existing saved dataset; no fitting/sampling."""
import csv, hashlib, json, math, pathlib, re, subprocess, tempfile, time
from exact_rasch_score import CalibratedRasch
from rasch_score_jags_adapter import prepare_chapter2_case

ROOT = pathlib.Path(__file__).resolve().parents[1]
DATA = ROOT/'production/jags-centered-extended-recovery-v1/prepared/data.rds'
EXPECTED = '5a9814682484e6cd62d8ee7c1415b8d67ba30be6b9696a685c85b58b5e60240a'
assert hashlib.sha256(DATA.read_bytes()).hexdigest() == EXPECTED
start = time.monotonic()
with tempfile.TemporaryDirectory(prefix='rasch-score-saved-') as tmp:
    tmp = pathlib.Path(tmp)
    script = tmp/'export.R'
    script.write_text('''a<-commandArgs(TRUE);d<-readRDS(a[1]);out<-a[2]
stopifnot(d$N==500,d$J==60)
writeLines(sprintf("%.17g",d$b),file.path(out,"b.txt"))
writeLines(sprintf("%.17g",d$rho),file.path(out,"rho.txt"))
rows<-do.call(rbind,lapply(1:d$N,function(i)rbind(d$y[i,1,],d$y[i,2,])))
write.table(rows,file.path(out,"y.csv"),sep=",",row.names=FALSE,col.names=FALSE)
''')
    subprocess.run(['/workspace/slot3-runtime/bin/Rscript',str(script),str(DATA),str(tmp)],check=True)
    b = [float(v) for v in (tmp/'b.txt').read_text().splitlines()]
    rho = [float(v) for v in (tmp/'rho.txt').read_text().splitlines()]
    ys = [[int(v) for v in row] for row in csv.reader((tmp/'y.csv').open())]
pairs = [ys[i:i+2] for i in range(0,len(ys),2)]
prepared = prepare_chapter2_case(b,pairs,rho)
norm = lambda s: re.sub(r'[\s;]','',s)
original_model = ROOT/'production/jags-centered-extended-recovery-v1/prepared/model.jags'
assert norm(prepared['models']['items']) == norm(original_model.read_text())
model = CalibratedRasch(b)
constant = math.fsum(sum(x) for x in prepared['audit']['item_minus_canonical_log_constants'])
def normal(x,mu,precision):
    return .5*(math.log(precision)-math.log(2*math.pi))-.5*precision*(x-mu)**2

targets = []
max_factor_error = 0.
for setting in range(3):
    mu = [-.3,0.,.7][setting];ta=[1.2,2.,3.4][setting];tc=[2.,3.,1.4][setting]
    beta0=[-1.,-1.6,-.5][setting];beta1=[-.4,0.,.6][setting]
    prior = -ta-tc+normal(mu,0.,.1)+normal(beta0,0.,1.)+normal(beta1,0.,.1)
    latent=[];item=[];canonical=[];score=[]
    for i,(pair,r) in enumerate(zip(pairs,rho)):
        c=.2*math.cos(i+setting);a1=.3*math.sin(i+.5*setting)
        a2=a1 if r==1 else .5*a1+.2*math.cos(i+setting)
        latent.extend([normal(c,0.,tc),normal(a1,0.,ta)])
        if r!=1:latent.append(normal(a2,.5*a1,ta/.75))
        for t,(y,a) in enumerate(zip(pair,(a1,a2))):
            theta=((2*i+t)%23-11)/3+.37*setting
            latent.append(normal(theta,mu+c+a,math.exp(-beta0-beta1*a)))
            s=model.score(y);li=model.log_pattern_probability(theta,y)
            ls=model.log_score_probability(theta,s)
            lk=model.canonical_log_kernel(theta,s)
            max_factor_error=max(max_factor_error,abs(li-ls-model.log_pattern_given_score(y)))
            item.append(li);canonical.append(lk-1);score.append(ls)
    common=prior+math.fsum(latent)
    targets.append({'setting':setting,'item_log_target':common+math.fsum(item),
        'score_log_target':common+math.fsum(score),
        'canonical_zero_poisson_log_target':common+math.fsum(canonical)})
expected_difference=constant+len(ys)
errors=[abs(x['item_log_target']-x['canonical_zero_poisson_log_target']-expected_difference) for x in targets]
assert max_factor_error<1e-10 and max(errors)<1e-8
out=ROOT/'outputs/exact-score-static';out.mkdir(exist_ok=True)
for name,text in prepared['models'].items():(out/('chapter2-'+name+'.jags')).write_text(text)
record={'scope':'Static implementation audit on the existing one-dataset input; no new dataset, fit, compilation, sampling or performance comparison.',
 'input_data_sha256':EXPECTED,'persons':len(ys),'items':len(b),'MZ_pairs':rho.count(1.),'DZ_pairs':rho.count(.5),
 'original_item_graph_equal_after_whitespace_semicolon_normalization':True,
 'model_priors':'Gamma(1,rate1) on ta/tc; mu,beta1 Normal(0,variance10); beta0 Normal(0,variance1), unchanged.',
 'full_target_settings':targets,'item_minus_canonical_zero_poisson_constant':expected_difference,
 'maximum_full_target_difference_error':max(errors),'maximum_item_score_factorization_error':max_factor_error,
 'deterministic_check_wall_seconds':time.monotonic()-start,
 'timing_interpretation':'Cost of this audit including export/preparation; not a sampler benchmark or speedup measurement.',
 'limitations':['Same JAGS backend for both graphs, not independent engines.','Generated graphs have not been compiled or sampled.','Known calibration only; no informative-missingness or unknown-calibration equivalence claim.'],
 'artifacts':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in
 [pathlib.Path(__file__),ROOT/'simulation/exact_rasch_score.py',ROOT/'simulation/rasch_score_jags_adapter.py',*sorted(out.glob('*.jags'))]}}
(ROOT/'outputs/exact-score-saved-data-audit.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps({k:v for k,v in record.items() if k not in ('full_target_settings','artifacts')}))
