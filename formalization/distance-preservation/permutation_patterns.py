"""Bounded integer certificate discovery for144 complete cross-block patterns.

No claim that every low-weight logical has this form. No Lean catalog bridge.
"""
from pathlib import Path
from collections import Counter
from itertools import permutations,product
import datetime,json,time
import numpy as np
R=Path(__file__).resolve().parent
def add(*terms):return tuple(sum(t[j] for t in terms) for j in range(6))
def scale(n,t):return tuple(n*v for v in t)
zero=(0,)*6
def e(i,j):
    if not i or not j:return zero
    return tuple(int(k==(i-1)*3+j-1) for k in range(6))
def canon(v):return min(v,scale(-1,v))
def verify(A,target,c):return tuple(sum(c[i]*A[i][j] for i in range(6)) for j in range(6))==target
def main():
    start=time.monotonic();cycles={}
    for i,j in permutations(range(3),2):
        for c,d in permutations(range(4),2):
            f=canon(add(e(i,c),scale(-1,e(j,c)),e(j,d),scale(-1,e(i,d))))
            cycles[f]={'kind':'four','indices':[i,j,c,d]}
    for i,j,k in permutations(range(3)):
        for c,d,f in permutations(range(4),3):
            v=canon(add(e(i,c),scale(-1,e(j,c)),e(j,d),scale(-1,e(k,d)),e(k,f),scale(-1,e(i,f))))
            cycles[v]={'kind':'six','indices':[i,j,k,c,d,f]}
    rcpc=[]
    for k in range(3):
        i,j=[v for v in range(3) if v!=k]
        rcpc.append({'kind':'row','middle':k,'forms':[add(e(i,c),e(j,c),scale(-2,e(k,c))) for c in range(1,4)]})
    for a,b,c,d in [(0,1,2,3),(0,2,1,3),(0,3,1,2)]:
        rcpc.append({'kind':'column','pairs':[[a,b],[c,d]],'forms':[add(e(i,a),e(i,b),scale(-1,e(i,c)),scale(-1,e(i,d))) for i in [1,2]]})
    coeffs=np.array(list(product(range(-2,3),repeat=6)),dtype=np.int64)
    # Favor short certificates; arithmetic bounds below24 make int64 exact.
    coeffs=coeffs[np.argsort(np.sum(np.abs(coeffs),axis=1),kind='stable')]
    records=[]
    for k in permutations(range(4)):
        for l in permutations(range(3)):
            F=[[add(e(i,k[j]),e(l[i],j)) for j in range(4)] for i in range(3)]
            A=[add(F[i][j],scale(-1,F[i][0]),scale(-1,F[0][j]),F[0][0]) for i in [1,2] for j in [1,2,3]]
            combinations=coeffs@np.array(A,dtype=np.int64)
            table={}
            for v,c in zip(combinations.tolist(),coeffs.tolist()):table.setdefault(tuple(v),c)
            result=None
            for f,loc in cycles.items():
                if f in table:
                    result={'kind':'short_cycle_implied','target':f,'coefficients':table[f],'cycle':loc};break
            if result is None:
                for p in rcpc:
                    if all(f in table for f in p['forms']):
                        result={'kind':'RCPC_implied','partition':p,'coefficients':[table[f] for f in p['forms']]};break
            if result is None:
                for i,j in permutations(range(3),2):
                    forms=[add(e(i,c),scale(-1,e(j,c))) for c in [1,2,3]]
                    for g in [2,3]:
                        targets=[scale(g,f) for f in forms]
                        if all(f in table for f in targets):
                            result={'kind':'cyclic_torsion_collision','rows':[i,j],'torsion':g,'targets':targets,'coefficients':[table[f] for f in targets]};break
                    if result is not None:break
            if result is None:result={'kind':'unclassified_with_coefficient_cap2'}
            if result['kind']=='short_cycle_implied':assert verify(A,result['target'],result['coefficients'])
            elif result['kind']=='RCPC_implied':assert all(verify(A,f,c) for f,c in zip(result['partition']['forms'],result['coefficients']))
            elif result['kind']=='cyclic_torsion_collision':assert all(verify(A,f,c) for f,c in zip(result['targets'],result['coefficients']))
            records.append({'column_map':k,'row_map':l,'A':A,'certificate':result})
    out={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'cases':len(records),'coefficient_cap':2,
         'outcomes':dict(Counter(x['certificate']['kind'] for x in records)),'records':records,'seconds':time.monotonic()-start,
         'scope':'Exhaustive144 permutations of maps in the specified seven-coordinate complete cross-block pattern; bounded integer-combination certificate discovery. Every positive certificate is rechecked with Python integers. This does not classify all weight7 logicals or prove a Lean RCPC converse.',
         'equations':'U(j,k(j),s_j), V(l(i),i,t_i): s_j+E(i,k(j))=t_i-E(l(i),j). Normalize E first row/column to0. A lists the six row/column-separability constraints on E11,E12,E13,E21,E22,E23.',
         'torsion_argument':'If all four row-difference labels (including0) are killed by g<=3, they cannot be distinct in the cyclic group ZModL, whose g-torsion has at mostg elements. Some classical four-cycle follows. This written pigeonhole step and the pattern/source bridge are not Lean-certified.'}
    (R/'permutation-patterns.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='records'}),flush=True)
if __name__=='__main__':main()
