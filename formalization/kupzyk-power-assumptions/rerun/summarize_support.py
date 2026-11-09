"""Summarize full supporting arms and compare them to source transcriptions."""
import argparse
import csv
import json
from collections import defaultdict
from math import sqrt
from pathlib import Path
from statistics import NormalDist

p=argparse.ArgumentParser(description=__doc__)
p.add_argument("study",type=Path)
p.add_argument("raw",type=Path)
p.add_argument("out",type=Path)
p.add_argument("--provisional",action="store_true")
a=p.parse_args()

def read(path):
    with path.open(newline="") as f:
        return list(csv.DictReader(f))

def save(name,rows):
    with (a.out/name).open("w",newline="") as f:
        w=csv.DictWriter(f,list(rows[0]));w.writeheader();w.writerows(rows)

a.out.mkdir(parents=True,exist_ok=True)
source=a.study/"source-values"
grid={(r["arm"],int(r["cell"])):r for r in read(a.raw/"empirical.csv")}
scan=read(a.raw/"exemplary-v2"/"threshold-scan.csv")
by=defaultdict(list)
for r in scan:
    by[int(r["cell"])].append(r)
assert len(by)==54
rows=[]
for i,rs in sorted(by.items()):
    assert len({r["J"] for r in rs})==len(rs)
    pub=int(rs[0]["published_min"])
    hits=[int(r["J"]) for r in rs if float(r["power"])>=.8]
    cross=min(hits) if hits else None
    at=next(r for r in rs if int(r["J"])==pub)
    previous=next((r for r in rs if int(r["J"])==pub-1),None)
    rows.append(dict(cell=i,published_min=pub,our_mean_power_min=cross,
        searched_min=min(int(r["J"]) for r in rs),searched_max=max(int(r["J"]) for r in rs),
        our_mean_at_published=at["power"],our_mask_prob_below80_at_published=at["below80"],
        our_mean_at_predecessor=previous["power"] if previous else "",
        our_mask_prob_below80_at_predecessor=previous["below80"] if previous else ""))
save("threshold-comparison.csv",rows)

diagnostics=[]
for i,var in enumerate(("person_intercept","cluster_intercept","person_slope",
                        "cluster_slope","icc_hat","beta"),1):
    for row in read(source/f"table-C.{i}.csv"):
        cell=int(row["cell"])
        r=grid.get(("main",cell))
        if r is None: continue
        estimate=float(r[var+"_mean"])
        mc=float(r[var+"_mcse"])
        src_mc=mc*sqrt(int(r["valid"])/25600)
        delta=estimate-float(row["estimated_mean"])
        # Treat original MCSE as a conditional approximation from the R run.
        approx=sqrt(mc**2+src_mc**2)
        z=NormalDist().inv_cdf(1-.05/(2*324))
        diagnostics.append(dict(table=f"C.{i}",cell=cell,parameter=var,
           population=row["population"],published=row["estimated_mean"],ours=estimate,
           deviation=delta,our_mcse=mc,assumed_source_mcse=src_mc,
           beyond_two_se=abs(delta)>.00005+2*approx,
           beyond_bonferroni=abs(delta)>.00005+z*approx))
save("appendix-c-comparison.csv",diagnostics)

methods=("od","bw","containment","sat")
totals=defaultdict(lambda:defaultdict(int))
for path in sorted((a.raw/"appendix-d-grid").glob("*-*.csv")):
    r,=read(path)
    key=(r["arm"],int(r["cell"]))
    for field in ("attempted",*(f"{m}_{k}" for m in methods for k in ("valid","reject"))):
        totals[key][field]+=int(r[field])
drows=[]
if totals:
    for (arm,cell),r in sorted(totals.items()):
        if not a.provisional:
            assert r["attempted"]==25600
        table=1 if cell==1 else 2
        d=read(source/f"table-D.{table}.csv")
        for method,ref in zip(methods,d[:4],strict=True):
            n=r[f"{method}_valid"]
            if not n: continue
            q=r[f"{method}_reject"]/n
            drows.append(dict(table=f"D.{table}",arm=arm,method=method,
               attempted=r["attempted"],valid=n,published=ref["power" if arm=="main" else "type_i_error"],
               ours=q,mcse=sqrt(q*(1-q)/n)))
    save("appendix-d-comparison.csv",drows)
    if not a.provisional:
        assert len(drows)==16
        for (arm,cell),r in totals.items():
            for method in ("od","bw"):
                assert int(grid[arm,cell]["valid"])==r[f"{method}_valid"]
                assert abs(float(grid[arm,cell][f"{method}_mean"])-r[f"{method}_reject"]/r[f"{method}_valid"])<1e-10
