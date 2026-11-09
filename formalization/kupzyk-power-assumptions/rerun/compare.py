"""Signed power contrasts and conditional agreement at full or provisional scale."""
import argparse
import csv
import json
import math
from collections import defaultdict
from pathlib import Path
from statistics import NormalDist, mean

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("study", type=Path)
parser.add_argument("empirical", type=Path)
parser.add_argument("exemplary", type=Path)
parser.add_argument("out", type=Path)
parser.add_argument("--provisional", action="store_true")
args = parser.parse_args()
args.out.mkdir(parents=True,exist_ok=True)

def read(path):
    with path.open(newline="") as f:
        return list(csv.DictReader(f))

def save(name,rows):
    with (args.out/name).open("w",newline="") as f:
        w=csv.DictWriter(f,list(rows[0]),lineterminator="\n");w.writeheader();w.writerows(rows)

def frac(r,k):
    return float(r[k]) if r[k] else None

target=read(args.study/"outputs/targets.csv")
key={(float(r["icc"]),float(r["treat"]),int(r["size"]),round(100*float(r["attrition"]))):
     int(r["cell"]) for r in target}
assert len(key)==54
figs=read(args.study/"source-values/figures-6-11.csv")
figmap={}
for r in figs:
    stage=int(int(r["figure"])>=9)
    i=key[(float(r["icc"]),float(r["allocation"]),("equal","normal","skewed").index(r["size"])+1,
           int(r["attrition_pct"]))]
    figmap[(stage,i,r["method"])]=r
emp={(r["arm"],int(r["cell"])):r for r in read(args.empirical)}
ex={(int(r["stage"]),int(r["cell"])):r for r in read(args.exemplary)}
assert len(ex)==108
if not args.provisional:
    assert len(emp)==57
    assert all(int(r["attempted"])==(50000 if arm=="baseline-followup" else 25600)
               for (arm,i),r in emp.items())
ncomp={"empirical":54,
       "exemplary-initial":sum(r["power"]!="" for (stage,i,method),r in figmap.items()
                              if stage==0 and method=="exemplary"),
       "exemplary-final-mask":36}
def z_adj(family):
    return NormalDist().inv_cdf(1-.05/(2*ncomp[family]))

cell_rows=[]
for row in target:
    i=int(row["cell"])
    for stage,method in ((0,"empirical"),(0,"exemplary"),(1,"exemplary")):
        p=figmap[stage,i,method]
        published=frac(p,"power")
        reading=frac(p,"reading_error")
        raw = emp.get(("main",i)) if method=="empirical" else ex[(stage,i)]
        ours=None if raw is None else frac(raw,"bw_mean" if method=="empirical" else "power")
        rounded_table=None;source_mc=None;our_mc=None;source_mask_sd=None;incompat=None;ordinary=None
        if ours is not None:
            if method=="empirical":
                our_mc=frac(raw,"bw_mcse")
                if published is not None:
                    source_mc=math.sqrt(published*(1-published)/25600)
                    pooled=math.hypot(source_mc,our_mc)
                    ordinary=abs(ours-published)>reading+2*pooled
                    incompat=abs(ours-published)>reading+z_adj("empirical")*pooled
            else:
                our_mc=frac(raw,"mask_se")
                source_mask_sd=frac(raw,"mask_sd")
                if stage==1 and float(row["attrition"])==0:
                    rounded_table=abs(ours-float(row["published"]))<=.000005
                if published is not None:
                    pooled=math.hypot(source_mask_sd,our_mc)
                    family="exemplary-final-mask" if stage else "exemplary-initial"
                    ordinary=abs(ours-published)>reading+2*pooled
                    incompat=abs(ours-published)>reading+z_adj(family)*pooled
        cell_rows.append(dict(cell=i,stage=stage,method=method,published_figure=published,
             reading_error=reading,published_table=float(row["published"]) if stage else None,
             ours=ours,deviation=None if published is None or ours is None else ours-published,
             source_mcse=source_mc,ours_mcse=our_mc,source_mask_sd=source_mask_sd,
             outside_ordinary=ordinary,outside_adjusted=incompat,table_rounding_agrees=rounded_table))
save("power-cell-comparison.csv",cell_rows)

# Separate matched scientific contrasts from ours-minus-published deviations.
# All effects below are reference power minus power in the violating condition.
conditions=[
 ("attrition-5",(3,0),(3,5)), ("attrition-15",(3,0),(3,15)),
 ("allocation",(1,.5),(1,.7)), ("normal-size",(2,1),(2,2)),
 ("skewed-size",(2,1),(2,3))]
lookup={(r["cell"],r["stage"],r["method"]):r for r in cell_rows}
contrast_rows=[]
for stage,method in ((0,"empirical"),(0,"exemplary"),(1,"exemplary")):
 for label,(axis,ref),(_,viol) in conditions:
    for k,i in key.items():
        if k[axis]!=ref: continue
        altered=list(k);altered[axis]=viol;j=key[tuple(altered)]
        a,b=lookup[i,stage,method],lookup[j,stage,method]
        def effect(field):
            return (a[field]-b[field])*100 if a[field] is not None and b[field] is not None else None
        source=effect("published_table" if stage else "published_figure")
        ours=effect("ours")
        contrast_rows.append(dict(stage=stage,method=method,contrast=label,icc=k[0],
          reference_cell=i,violation_cell=j,published_pp=source,ours_pp=ours,
          reversal=(source*ours<0 if source is not None and ours is not None else None)))
save("paired-contrasts.csv",contrast_rows)

summary={"provisional":args.provisional,
         "fit_counts":{arm:sum(int(r["attempted"]) for (a,i),r in emp.items() if a==arm)
                       for arm in ("main","baseline-followup","null")},
         "contrast_summary":[]}
for stage,method in ((0,"empirical"),(0,"exemplary"),(1,"exemplary")):
 for label,_,_ in conditions:
    group=[r for r in contrast_rows if (r["stage"],r["method"],r["contrast"])==(stage,method,label)]
    for icc in (None,.05,.10,.15):
        rows=[r for r in group if icc is None or r["icc"]==icc]
        common=[r for r in rows if r["published_pp"] is not None and r["ours_pp"] is not None]
        summary["contrast_summary"].append(dict(stage=stage,method=method,contrast=label,icc=icc,
          expected=len(rows),paired=len(common),
          published_pp=mean(r["published_pp"] for r in common) if common else None,
          ours_pp=mean(r["ours_pp"] for r in common) if common else None,
          reversals=sum(r["reversal"] is True for r in common)))
pairs=[]
for i in range(1,55):
 a,b=lookup[i,0,"empirical"],lookup[i,0,"exemplary"]
 pub=None if None in (a["published_figure"],b["published_figure"]) else a["published_figure"]-b["published_figure"]
 ours=None if None in (a["ours"],b["ours"]) else a["ours"]-b["ours"]
 pairs.append(dict(cell=i,published_empirical_minus_exemplary=pub,ours_empirical_minus_exemplary=ours,
                  reversal=pub*ours<0 if pub is not None and ours is not None else None))
save("empirical-exemplary-gaps.csv",pairs)
summary["gap"]={field:dict(available=len(v), below=sum(x<0 for x in v),minimum=min(v),maximum=max(v))
                for field in list(pairs[0])[1:3] if (v:=[r[field] for r in pairs if r[field] is not None])}
(args.out/"comparison-summary.json").write_text(json.dumps(summary,indent=2)+"\n")
