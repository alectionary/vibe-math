"""Exhaustive normalized bases at fixed small prime/compound L; explicit orbit action."""
from itertools import permutations
from collections import Counter
import argparse,json,math,time
import research as r

RP=list(permutations(range(3)));CP=list(permutations(range(4)))
def canonical(E,L):
    best=None;transform=None
    for rp in RP:
        for cp in CP:
            vals=[(E[rp[i]][cp[j]]-E[rp[i]][cp[0]]-E[rp[0]][cp[j]]+E[rp[0]][cp[0]])%L for i in [1,2] for j in [1,2,3]]
            for u in range(1,L):
                if math.gcd(u,L)!=1:continue
                v=tuple(x*u%L for x in vals)
                if best is None or v<best:best=v;transform=(rp,cp,u)
    return best,transform

def classify(L):
    start=time.monotonic();triples=list(permutations(range(1,L),3));counts=Counter();classes={};seen=set()
    for a in triples:
        for b in triples:
            counts['two_nonzero_distinct_rows']+=1
            if len({0,*((x-y)%L for x,y in zip(a,b))})!=4:continue
            E=[[0]*4,[0,*a],[0,*b]]
            if r.short_cycle(E,L):continue
            counts['girth_at_least_eight']+=1
            if r.rcpc(E,L):counts['rcpc']+=1;continue
            counts['rcpc_free']+=1
            flat=tuple(a)+tuple(b)
            if flat in seen:continue
            key,tr=canonical(E,L)
            if key not in classes:
                E0=[[0]*4,[0,*key[:3]],[0,*key[3:]]]
                C=r.exact_distance(r.classical(E0,L),4*L)
                CT=r.exact_distance(r.classical(list(map(list,zip(*E0))),L),3*L)
                classes[key]={'id':f'exhaustive-L{L}-{len(classes)}','L':L,'E':E0,'classical':C,'transpose_classical':CT,'normalized_orbit_size':0}
            # Enumerate all normalized transformations, recording coverage explicitly.
            for rp in RP:
                for cp in CP:
                    vals=[(E[rp[i]][cp[j]]-E[rp[i]][cp[0]]-E[rp[0]][cp[j]]+E[rp[0]][cp[0]])%L for i in [1,2] for j in [1,2,3]]
                    for u in range(1,L):
                        if math.gcd(u,L)==1:seen.add(tuple(x*u%L for x in vals))
    # Orbits are disjoint because canonical() explicitly minimizes the full action.
    for c in classes.values():
        E=c['E'];orbit=set()
        for rp in RP:
            for cp in CP:
                vals=[(E[rp[i]][cp[j]]-E[rp[i]][cp[0]]-E[rp[0]][cp[j]]+E[rp[0]][cp[0]])%L for i in [1,2] for j in [1,2,3]]
                for u in range(1,L):
                    if math.gcd(u,L)==1:orbit.add(tuple(x*u%L for x in vals))
        c['normalized_orbit_size']=len(orbit)
    assert sum(c['normalized_orbit_size'] for c in classes.values())==counts['rcpc_free']==len(seen)
    out={'L':L,'counts':dict(counts),'classes':list(classes.values()),'seconds':time.monotonic()-start,'scope':'All normalized fully populated 3x4 exponent arrays modulo L; rejected short-cycle cases tested via exact voltage criteria. Orbit equivalence is an ordinary explicit permutation/gauge/unit calculation, not yet a Lean theorem.'}
    (r.ROOT/f'exhaustive-L{L}.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({'L':L,'counts':dict(counts),'classes':len(classes),'seconds':out['seconds']}),flush=True)
if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('L',type=int);a=ap.parse_args();classify(a.L)
