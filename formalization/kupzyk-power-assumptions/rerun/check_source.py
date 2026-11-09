"""Cross-check identities in Kupzyk's printed tables and source plots."""
import csv
import json
import math
import sys
from pathlib import Path
from statistics import mean
from scipy.stats import binom, nct, t

root = Path(sys.argv[1])
src = root / "source-values"

def read(name):
    with (src/f"{name}.csv").open(newline="") as f:
        return list(csv.DictReader(f))

t1 = read("table-1")
t2 = read("table-2")
t3 = read("table-3")
t4 = read("table-4")
t5 = read("table-5")
six = list(t1[0])[2:]
t1v = [[float(r[k]) for k in six] for r in t1]
flat = [x for row in t1v for x in row]
rounding = []
for col,k in enumerate(six):
    pooled=[mean(t1v[i][col] for i in (a,a+3,a+6)) for a in range(3)]
    expected=pooled+[pooled[0]-pooled[1],pooled[0]-pooled[2]]
    for r,v in zip(t2,expected,strict=True):
        rounding.append(abs(float(r[k])-v))

moderation = []
for i, row in enumerate(t4):
    x,y,z=t1v[i*3:i*3+3]
    contrasts=[
        mean(a-b for a,b in zip(x,y,strict=True)),
        mean(a-b for a,b in zip(x,z,strict=True)),
        mean(r[k]-r[k+3] for r in (x,y,z) for k in range(3)),
        mean(r[k]-r[k+1] for r in (x,y,z) for k in (0,3)),
        mean(r[k]-r[k+2] for r in (x,y,z) for k in (0,3)),
    ]
    moderation.append(dict(icc=row["icc"], recomputed_pp=[100*c for c in contrasts],
                           published_pp=[float(row[k]) for k in list(row)[1:]]))

d_checks=[]
for arm in (1,2):
    for row in read(f"table-D.{arm}"):
        e,lo,hi=(float(row[k]) for k in ("type_i_error","ci_low","ci_high"))
        d_checks.append(dict(table=f"D.{arm}",method=row["method"],
            difference_rounds=abs(.05-e-float(row["point05_minus_error"]))<=.000055,
            interval_center_error=(lo+hi)/2-e, interval_halfwidth=(hi-lo)/2,
            implied_n=4*e*(1-e)/(((hi-lo)/2)**2),
            bradley_ok=.025<=e<=.075, serlin_ok=.035<=e<=.065))
with (root/"results"/"appendix-d-source-identity.csv").open("w",newline="") as f:
    w=csv.DictWriter(f,list(d_checks[0]),lineterminator="\n");w.writeheader();w.writerows(d_checks)

fplots=read("figures-6-11")
mapped=[]
for row in fplots:
    if int(row["figure"])<9: continue
    icc=(.05,.10,.15).index(float(row["icc"]))
    a=(0,5,15).index(int(row["attrition_pct"]))
    j=("equal","normal","skewed").index(row["size"])+(0 if float(row["allocation"])==.5 else 3)
    published=t1v[icc*3+a][j]
    mapped.append(dict(row,printed=published,delta=float(row["power"])-published,
                       within_reading_error=abs(float(row["power"])-published)<=float(row["reading_error"])))
with (root/"results"/"figure-table1-check.csv").open("w",newline="") as f:
    w=csv.DictWriter(f,list(mapped[0]),lineterminator="\n");w.writeheader();w.writerows(mapped)

f23=[]
for r in read("figures-2-3"):
    if r["figure"]=="2":
        df=118;lam=.4*math.sqrt(30)
    else:
        df=22;lam=.4*math.sqrt(24/(4*(float(r["icc"])+(1-float(r["icc"]))/5)))
    cut=t.ppf(.975,df)
    f23.append(dict(figure=r["figure"],icc=r["icc"],reference=float(r["power"]),
                    ours=nct.sf(cut,df,lam)+nct.cdf(-cut,df,lam),df=df,ncp=lam))
summary=dict(
    table1=dict(count=len(flat), outside_probability=sum(not 0<=v<=1 for v in flat)),
    table2=dict(max_abs_power_difference=max(rounding),pairwise_rounding_allowance=.000015),
    table3=dict(published_J=[[15,22,29],[19,28,36]],
                implied_nearest_J=[[math.floor(j*(1+a)+.5) for j in (13,19,25)] for a in (.15,.45)],
                loss_of_observations=[.075,.225], published_power=[[float(x[k]) for k in list(x)[1:]] for x in t3]),
    table4=moderation,
    table5=dict(count=len(t5)*6, min_extra=min(int(r[k])-int(r["bw_reference"]) for r in t5 for k in six),
                max_extra=max(int(r[k])-int(r["bw_reference"]) for r in t5 for k in six)),
    figures2_3=f23,
    figure4=dict(draws=500,approx_se_at_80=math.sqrt(.8*.2/500),
                 p80_exact_1000_quantiles=list(binom.ppf([.025,.975],1000,.8)/1000),
                 draws_for_full_width_01=round(16*.8*.2/.01**2),
                 draws_for_full_width_005=round(16*.8*.2/.005**2)),
)
(root/"results"/"source-identities.json").write_text(json.dumps(summary,indent=2)+"\n")
