"""Tiny fixed-fixture compilation only: JAGS n.adapt=0 and zero updates.

Initialization is not a posterior sample. No data generation or scientific fit.
"""
import csv, hashlib, json, os, pathlib, subprocess, tempfile, time
from rasch_score_jags_adapter import prepare_chapter2_case
ROOT=pathlib.Path(__file__).resolve().parents[1]
b=[-2.,-.4,.7,3.]
y=[[[1,0,1,0],[0,0,0,0]],[[1,1,1,1],[0,1,0,1]]]
masks=[[[True,False,True,False],[False]*4],[[False,True,False,True],[True]*4]]
complete=prepare_chapter2_case(b,y,[1,.5])
masked=prepare_chapter2_case(b,y,[1,.5],masks)
def array_r(x):
    # R array order i,t,k, with i varying fastest.
    vals=[x[i][t][k] for k in range(4) for t in range(2) for i in range(2)]
    return 'array(c('+','.join(map(str,vals))+'),dim=c(2,2,4))'
cases=[('items_complete',complete['models']['items'],{'y':array_r(y)}),
       ('score_complete',complete['models']['score'],complete['score_data']),
       ('score_masked_empty_person',masked['models']['score'],masked['score_data'])]
start=time.monotonic()
with tempfile.TemporaryDirectory(prefix='score-compile-only-') as folder:
    folder=pathlib.Path(folder);body=[]
    for name,model,data in cases:
        (folder/(name+'.jags')).write_text(model)
        assignments='d<-list(N=2,J=4,b=c(-2,-.4,.7,3))\n'
        if 'y' in data:assignments+='d$y<-'+data['y']+'\n'
        else:
            for key in ('canonical_y','observed'):assignments+='d$'+key+'<-'+array_r(data[key])+'\n'
            assignments+='d$zeros<-matrix(0,2,2)\n'
        body.append(assignments+f'''m<-jags.model(file.path(out,"{name}.jags"),data=d,inits=list(mu=0,ta=2,tc=3,beta0=-1,beta1=.2,c=c(0,0),a=matrix(c(.1,.1,NA,.2),2,2),theta=matrix(0,2,2),.RNG.name="base::Mersenne-Twister",.RNG.seed=151),n.chains=1,n.adapt=0,quiet=TRUE)
stopifnot(m$iter()==0L)
capture.output(list.samplers(m),file=file.path(out,"{name}-samplers.txt"))
rows[[length(rows)+1L]]<-data.frame(case="{name}",compiled=TRUE,adaptation_iterations=0L,posterior_iterations=m$iter())
rm(m);gc()
''')
    script=folder/'check.R';script.write_text('''out<-commandArgs(TRUE)[1]
options(jags.moddir=Sys.getenv("JAGS_MODULE_PATH","/workspace/slot3-runtime/usr/lib/x86_64-linux-gnu/JAGS/modules-4"))
library(rjags);rows<-list()
'''+''.join(body)+'''write.csv(do.call(rbind,rows),file.path(out,"results.csv"),row.names=FALSE)
capture.output(sessionInfo(),file=file.path(out,"sessionInfo.txt"))
''')
    run=subprocess.run(['/workspace/slot3-runtime/bin/Rscript',str(script),str(folder)],
        capture_output=True,text=True,timeout=30,
        env=dict(os.environ,OMP_NUM_THREADS='1',OPENBLAS_NUM_THREADS='1',MKL_NUM_THREADS='1'))
    record={'scope':'Tiny deterministic graph compilation/initialization, not posterior sampling or a scientific model fit.',
      'timeout_seconds':30,'elapsed_seconds':time.monotonic()-start,'returncode':run.returncode,
      'stdout':run.stdout,'stderr':run.stderr,'updates_requested':0,'adaptation_requested':0,
      'script_sha256':hashlib.sha256(pathlib.Path(__file__).read_bytes()).hexdigest(),
      'adapter_sha256':hashlib.sha256((ROOT/'simulation/rasch_score_jags_adapter.py').read_bytes()).hexdigest()}
    if run.returncode==0:
        record['cases']=list(csv.DictReader((folder/'results.csv').open()))
        record['sampler_assignments']={name:(folder/(name+'-samplers.txt')).read_text() for name,_,_ in cases}
        record['sessionInfo']=(folder/'sessionInfo.txt').read_text()
    (ROOT/'provenance/exact-score-compilation-check.json').write_text(json.dumps(record,indent=2)+'\n')
    print(json.dumps({k:v for k,v in record.items() if k not in ('sampler_assignments','sessionInfo','stdout','stderr')}))
    if run.returncode:raise RuntimeError(run.stderr)
