#!/usr/bin/env python3
"""Bounded local-distribution separation using physical partial-frame patterns.

Every full frame restricted to a set of events has independent selected vectors
in each sector, and its selected cross-pairing graph has maximum degree one.
These necessary conditions define a finite superset of allowed restrictions.
An exact separating linear functional valid on this superset is a valid source
moment inequality. Numerical feasibility alone is not an exact certificate.
"""
from pathlib import Path
from fractions import Fraction
from itertools import combinations
import argparse, gzip, hashlib, json, random, time
import numpy as np
from scipy.optimize import linprog
from scipy.sparse import csc_matrix, eye, hstack
from certify_profile_moment_point import layout
from verify_weighted_matroid_cuts import rank

ROOT = Path(__file__).resolve().parent

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def features(bits):
    return [1, *bits, *(bits[i]*bits[j] for i,j in combinations(range(len(bits)),2))]

def allowed(events, pools):
    n=len(events)
    edges=[(i,j) for i,(s,a) in enumerate(events)
           for j,(t,b) in enumerate(events[:i])
           if s!=t and (pools[s][a]&pools[t][b]).bit_count()%2]
    masks=[]
    for mask in range(1<<n):
        selected=[i for i in range(n) if mask>>i&1]
        degrees=[0]*n
        for i,j in edges:
            if mask>>i&1 and mask>>j&1:
                degrees[i]+=1; degrees[j]+=1
        if max(degrees,default=0)>1:
            continue
        if any(rank([pools[s][events[i][1]] for i in selected if events[i][0]==s])
               !=sum(events[i][0]==s for i in selected) for s in (0,1)):
            continue
        masks.append(mask)
    return masks

def point_values(events,v,index,m):
    return [Fraction(1),*[v[index['p',a//16]] for s,a in events],
            *[v[m('S' if s==t else 'T',(b-a)%16,a//16,b//16)]
              for (s,a),(t,b) in combinations(events,2)]]

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--point',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--seconds',type=float,default=360)
    a=ap.parse_args();start=time.monotonic();rng=random.Random(202610300328)
    pools=[[int(x,16) for x in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    hulls=json.loads(gzip.decompress((ROOT/'algebraic-results/hulls-16-rank.json.gz').read_bytes()))
    _,index,m=layout(hulls)
    v=list(map(Fraction,json.loads(gzip.decompress(a.point.read_bytes()))['values']))
    cohort=[]
    for q in range(32):
        cohort.append({'kind':'uniform_mixed','events':[(s,j) for s in (0,1) for j in rng.sample(range(720),6)]})
    for q in range(32):
        anchor=rng.randrange(720)
        opposite=[j for j in range(720) if (pools[0][anchor]&pools[1][j]).bit_count()%2]
        same=rng.sample([j for j in range(720) if j!=anchor],5)
        cohort.append({'kind':'pairing_hub','events':[(0,anchor),*[(0,j) for j in same],*[(1,j) for j in rng.sample(opposite,6)]]})
    for q in range(32):
        orbit=rng.sample(range(45),2)
        cohort.append({'kind':'two_orbits','events':[(s,16*orbit[s]+h) for s in (0,1) for h in rng.sample(range(16),6)]})
    for q in range(32):
        anchor=rng.randrange(720);events=[(0,anchor)]
        for s,count in [(0,5),(1,6)]:
            candidates=[j for j in range(720) if s or j!=anchor]
            candidates.sort(key=lambda j:(-float(v[m('S' if s==0 else 'T',(j-anchor)%16,anchor//16,j//16)]),j))
            events.extend((s,j) for j in rng.sample(candidates[:32],count))
        cohort.append({'kind':'large_pair_moments','events':events})
    frozen={'status':'FROZEN_BEFORE_LOCAL_JOINT_PROBE','point_sha256':digest(a.point),
            'script_sha256':digest(Path(__file__)),'seed':202610300328,'seconds':a.seconds,
            'cohort':cohort,'scope':'128 specified local 12-event marginal tests; no global feasibility claim.'}
    a.output.with_suffix('.frozen.json').write_text(json.dumps(frozen,indent=2)+'\n')
    records=[];cuts=[]
    for number,item in enumerate(cohort):
        if time.monotonic()-start>a.seconds:break
        events=item['events'];n=len(events);masks=allowed(events,pools)
        A=np.array([features([(mask>>i)&1 for i in range(n)]) for mask in masks],dtype=np.int64).T
        b=point_values(events,v,index,m);bf=np.array(list(map(float,b)));r=len(b)
        # Phase-I distance: the equality dual is a separating functional when positive.
        eq=hstack([csc_matrix(A),eye(r),-eye(r)],format='csc')
        lp=linprog(np.r_[np.zeros(len(masks)),np.ones(2*r)],A_eq=eq,b_eq=bf,
                   bounds=(0,None),method='highs',options={'time_limit':15.0})
        record={'index':number,'kind':item['kind'],'allowed_patterns':len(masks),
                'solver_status':int(lp.status),'phase1_objective':float(lp.fun) if lp.fun is not None else None}
        if lp.status==0 and lp.fun>1e-7:
            for scale in (1,16,256,4096):
                y=np.rint(lp.eqlin.marginals*scale).astype(np.int64)
                maximum=int(np.max(y@A));y[0]-=maximum
                exact=sum(int(c)*value for c,value in zip(y,b))
                if exact>0:
                    cuts.append({'events':events,'coefficients':y.tolist(),'bound':0,
                                 'exact_violation':str(exact),'allowed_patterns':len(masks),
                                 'cohort_index':number})
                    record['exact_separation']=str(exact);break
        records.append(record);print(record,flush=True)
    result={'status':'EXACT_SEPARATING_CUTS' if cuts else 'NO_EXACT_SEPARATION_FOUND',
            'source_C16_answered':False,'point_sha256':digest(a.point),
            'frozen_sha256':digest(a.output.with_suffix('.frozen.json')),
            'records':records,'cuts':cuts,'elapsed_seconds':time.monotonic()-start,
            'scope':'Bounded local necessary-pattern LP; each saved cut is exhaustively integer-checked on its generated pattern set. Independent physical pattern replay required before acceptance. Numerical zero objectives do not certify local or global feasibility.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n')
    print('FINISHED',len(records),'cuts',len(cuts),flush=True)

if __name__=='__main__':main()
