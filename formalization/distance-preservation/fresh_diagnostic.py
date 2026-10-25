"""Frozen diagnostic of the strengthened candidate condition; not a proof search certificate."""
from pathlib import Path
from collections import Counter
import datetime,hashlib,json,random,time
import research as r
import run_search
R=Path(__file__).resolve().parent
SEED=202610250413

def partial_row_pairing(E,L):
    for k in range(3):
        i,j=[v for v in range(3) if v!=k]
        vals=[(E[i][c]+E[j][c]-2*E[k][c])%L for c in range(4)]
        if max(Counter(vals).values())>=3:return True
    return False

def key(c):return (c['L'],tuple(v for row in c['E'] for v in row))

def freeze():
    path=R/'fresh-candidates.json'
    if path.exists():raise RuntimeError('Frozen fresh inputs already exist; do not regenerate.')
    rng=random.Random(SEED);records=[];counts=[]
    seen={key(c) for c in json.loads((R/'candidates.json').read_text())['candidates']}
    for L in range(12,25):
        ctr=Counter();accepted=[]
        for n in range(1,50001):
            vals=[rng.randrange(L) for _ in range(6)]
            E=[[0,0,0,0],[0]+vals[:3],[0]+vals[3:]]
            c={'id':f'fresh-L{L}-{len(accepted)}','L':L,'E':E}
            cycle=r.short_cycle(E,L)
            if cycle:ctr[f'cycle_{cycle}_reject']+=1;continue
            if r.rcpc(E,L):ctr['RCPC_reject']+=1;continue
            if partial_row_pairing(E,L):ctr['partial_row_reject']+=1;continue
            if key(c) in seen:ctr['literal_repeat_reject']+=1;continue
            seen.add(key(c));accepted.append(c)
            if len(accepted)==8:break
        ctr.update(attempted=n,L=L,accepted=len(accepted));counts.append(dict(ctr));records+=accepted
    path.write_text(json.dumps({'seed':SEED,'frozen_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'counts':counts,'candidates':records},indent=2)+'\n')
    print(json.dumps({'phase':'frozen','candidates':len(records),'sha256':hashlib.sha256(path.read_bytes()).hexdigest()}),flush=True)
    return records

def test(cs):
    if (R/'fresh-results.jsonl').exists():raise RuntimeError('Do not append a duplicate fresh campaign.')
    out=[];stop='completed_frozen_sample'
    with (R/'fresh-results.jsonl').open('w') as f:
        for c in cs:
            start=time.monotonic();L=c['L'];rows=r.classical(c['E'],L)
            d=r.exact_distance(rows,4*L,max_dim=27)
            dt=r.exact_distance(r.columns(rows,4*L),3*L,max_dim=27)
            x={**c,'classical':d,'transpose':dt}
            if not d['complete'] or not dt['complete']:
                x['criterion_eligible']=False;x['reason']='exact_distance_dimension_cap'
            elif dt['distance']<d['distance']:
                x['criterion_eligible']=False;x['reason']='transpose_distance_below_classical'
            else:
                x['criterion_eligible']=True
                x['search']=run_search.search(c,min(d['distance']-1,11),10000000)
                if x['search']['witness']:
                    import independent_verify as iv
                    x['independent_dense']=iv.verify(c['E'],L,x['search']['witness'])
                    x['verified_counterexample']=True;stop='verified_counterexample'
            x['seconds_total']=time.monotonic()-start;out.append(x)
            f.write(json.dumps(x)+'\n');f.flush()
            print(json.dumps({'id':c['id'],'dC':d.get('distance'),'dT':dt.get('distance'),'eligible':x['criterion_eligible'],'counterexample':x.get('verified_counterexample',False),'seconds':x['seconds_total']}),flush=True)
            if x.get('verified_counterexample'):break
    report={'seed':SEED,'frozen_count':len(cs),'tested_count':len(out),'criterion_eligible':sum(x['criterion_eligible'] for x in out),
            'verified_counterexamples':sum(x.get('verified_counterexample',False) for x in out),'stop':stop,
            'scope':'Bounded fresh diagnostic only. Search bound min(dC-1,11),10^7 nodes; no witness is not equality or a general lower bound.',
            'frozen_sha256':hashlib.sha256((R/'fresh-candidates.json').read_bytes()).hexdigest()}
    (R/'fresh-summary.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report),flush=True)

if __name__=='__main__':test(freeze())
