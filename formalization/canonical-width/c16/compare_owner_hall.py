#!/usr/bin/env python3
"""Frozen conditional comparison of count-only and actual owner allocation."""
import argparse
from collections import Counter
import hashlib
import itertools
import json
from pathlib import Path
import random
import time
import numpy as np
from owner_hall import allocation,literal_owners
from orbit_benders import canonical


def controls():
    cases=0
    for P,bins in [(3,3),(4,4)]:
        for graph in range(1<<(P*bins)):
            masks=[graph>>(P*b)&((1<<P)-1) for b in range(bins)];demands=[1]*bins
            expected=any(all(masks[b]>>p[b]&1 for b in range(bins)) for p in itertools.permutations(range(P),bins))
            assert allocation(masks,demands)['possible']==expected;cases+=1
    for graph in range(64):
        masks=[graph&7,graph>>3&7]
        for n in itertools.product(range(4),repeat=2):
            slots=[b for b,c in enumerate(n) for _ in range(c)]
            expected=len(slots)<=3 and any(all(masks[b]>>p[k]&1 for k,b in enumerate(slots)) for p in itertools.permutations(range(3),len(slots)))
            assert allocation(masks,list(n))['possible']==expected;cases+=1
    return cases


def main():
    ap=argparse.ArgumentParser();ap.add_argument('inputs',type=Path);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--samples',type=int,default=200);ap.add_argument('--seed',type=int,default=202610271737);args=ap.parse_args();start=time.monotonic();count=controls();folder=args.inputs
    masks=list(map(int,(folder/'masks.txt').read_text().split()));profiles=json.loads((folder/'profiles.json').read_text());patterns=json.loads((folder/'mapping.json').read_text())['patterns'];member=np.array([[v>>i&1 for i in range(16)] for v in masks],dtype=np.int16);weights=member.sum(axis=1);powers=2**np.arange(16,dtype=np.int64);data={}
    for row in profiles:
        f=row['pattern'];adj=np.array([[f>>((j-i)%16)&1 for j in range(16)] for i in range(16)],dtype=np.int16);degree=member@adj;zero=(degree==0).sum(axis=1);own=member&(((degree==1).astype(np.int16)@adj.T)>0);owners=own@powers
        assert np.array_equal(zero,row['zero']) and np.array_equal(own.sum(axis=1),row['owners']);data[f]=(zero,owners,np.array(row['owners']))
    by_weight={w:np.flatnonzero(weights==w).tolist() for w in range(17)};rng=random.Random(args.seed);rows=[]
    # Discovery rows are frozen historical flow rows, not fresh holdout cases.
    flow=json.loads((folder/'even-flow.json').read_text())
    for side in ['X','Z']:
        own=flow['X_counts'] if side=='X' else flow['Z_counts'];opp=flow['Z_counts'] if side=='X' else flow['X_counts']
        for a in range(45):
            if not own[a]:continue
            demand=flow['flow'][a] if side=='X' else [flow['flow'][b][a] for b in range(45)]
            rows.append({'cohort':'historical_flow','side':side,'owner':a,'count':own[a],'demands':demand,'zero_demands':[opp[b]-demand[b] for b in range(45)]})
    attempted=0;accepted=0
    while accepted<args.samples and attempted<100000:
        attempted+=1;a=rng.randrange(45);weight=rng.choice([4,6,8]);k=rng.choice(by_weight[weight]);active=rng.sample(range(45),min(4,weight));cuts=sorted(rng.sample(range(1,weight),len(active)-1));parts=[v-u for u,v in zip([0]+cuts,cuts+[weight])];demand=[0]*45;zero=[0]*45;good=True
        for b,n in zip(active,parts):
            f=canonical(patterns[a][b]);z,o,c=data[f]
            if c[k]<n:good=False;break
            demand[b]=n;zero[b]=rng.randrange(int(z[k])+1)
        if not good:continue
        accepted+=1;rows.append({'cohort':'conditional_holdout','side':'X','owner':a,'count':weight,'demands':demand,'zero_demands':zero,'generating_shape':masks[k]})
    assert accepted==args.samples
    report=[];stats={cohort:Counter() for cohort in ['historical_flow','conditional_holdout']}
    for number,row in enumerate(rows):
        a=row['owner'];n=row['demands'];d=row['zero_demands'];eligible=weights==row['count']
        for b in range(45):
            if not(n[b] or d[b]):continue
            z,o,c=data[canonical(patterns[a][b])];eligible&=(z>=d[b])&(c>=n[b])
        possible=np.flatnonzero(eligible);survivors=[];failures=[];active=[b for b in range(45) if n[b]]
        for k in possible:
            ownership=[int(data[canonical(patterns[a][b])][1][k]) for b in active];answer=allocation(ownership,[n[b] for b in active])
            if answer['possible']:survivors.append(int(k))
            else:
                bins=[active[b] for b in answer['bins']];failure={'shape':masks[int(k)],'bins':bins,'required':answer['required'],'available_owners':answer['available_owners'],'deficiency':answer['deficiency']}
                # Independently recompute the Hall witness from literal adjacency.
                union=0
                for b in bins:union|=literal_owners(canonical(patterns[a][b]),masks[int(k)])[1]
                assert union==failure['available_owners'] and sum(n[b] for b in bins)>union.bit_count();failures.append(failure)
        c=stats[row['cohort']];c['rows']+=1;c['profile_shapes']+=len(possible);c['hall_shapes']+=len(survivors);c['profile_feasible_rows']+=bool(len(possible));c['hall_feasible_rows']+=bool(survivors);c['newly_excluded_rows']+=bool(len(possible) and not survivors);c['shape_choices_removed']+=len(failures)
        report.append(dict(row,baseline_shapes=len(possible),hall_shapes=len(survivors),hall_failures=failures))
    result={'status':'PASS','canonical_question_answered':False,'scope':'local necessary-condition comparison; conditional holdout is not a sample of full frames','protocol':{'seed':args.seed,'requested_holdout_rows':args.samples,'generation_attempts':attempted,'accepted_rows':accepted,'condition':'generating real phase shape passes individual zero/private-owner-count tests; Hall not used in acceptance'},'controls':count,'stats':{k:dict(v) for k,v in stats.items()},'seconds':time.monotonic()-start,'rows':report}
    args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k!='rows'}),flush=True)


if __name__=='__main__':main()
