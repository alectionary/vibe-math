"""Independent illustration of Figure 4's instability; original toy model is unspecified."""
import csv
import json
import sys
from pathlib import Path

import numpy as np
from scipy.optimize import brentq
from scipy.stats import nct, t

out=Path(sys.argv[1])
rng=np.random.default_rng(20261109)
sizes=np.arange(71,82)

# Fixed standardized predictor illustration. Set population power to .80 at
# n=75; the source does not give enough information to recover its power curve.
def exact(n, beta):
    df=n-2
    c=t.ppf(.975,df)
    nc=beta*np.sqrt(n-1)
    return nct.sf(c,df,nc)+nct.cdf(-c,df,nc)

beta=brentq(lambda b: exact(75,b)-.8,0,1)
probs=np.array([exact(n,beta) for n in sizes])
with (out/"figure4-independent-demo.csv").open("w",newline="") as f:
    w=csv.writer(f,lineterminator="\n");w.writerow(["draws","seed_panel","n","exact_power","empirical_power"])
    for n_draws in (500,25600):
        for j in range(1,3):
            for n,p,y in zip(sizes,probs,rng.binomial(n_draws,probs),strict=True):
                w.writerow([n_draws,j,n,p,y/n_draws])
summary={}
for n_draws in (500,25600):
    estimates=rng.binomial(n_draws,probs,size=(10000,11))/n_draws
    first=np.where((estimates>=.8).any(axis=1),sizes[(estimates>=.8).argmax(axis=1)],0)
    summary[n_draws]={"first_crossing":{int(n):int((first==n).sum()) for n in np.unique(first)},
                    "any_decrease":float((np.diff(estimates,axis=1)<0).any(axis=1).mean())}
(out/"figure4-independent-summary.json").write_text(json.dumps(summary,indent=2)+"\n")
