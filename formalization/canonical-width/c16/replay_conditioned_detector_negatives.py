#!/usr/bin/env python3
"""Independent evaluation-code row reduction for both zero-hit source gates.

Discovery eliminates128-bit pool vectors. Here128 physical evaluation rows,
each indexed by eligible pool coordinates, are reduced instead. A systematic
nullspace parity check has the same kernel by explicit orthogonality and rank.
"""
from pathlib import Path
from itertools import combinations
from collections import defaultdict,Counter
import hashlib,json,time
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def translated(bank):
    return {tuple(sorted(16*(i//16)+(i%16+h)%16 for i in c['indices'])) for c in bank for h in range(16)}
def parity_columns(U,V,J):
    ids=[i for i,u in enumerate(U) if all((u&V[j]).bit_count()%2==0 for j in J)];generators=[sum(((U[i]>>k)&1)<<t for t,i in enumerate(ids)) for k in range(128)];rows={}
    for value in generators:
        while value:
            p=(value&-value).bit_length()-1
            if p not in rows:rows[p]=value;break
            value^=rows[p]
    assert len(rows)==128-len(J)
    for p in sorted(rows,reverse=True):
        for q in rows:
            if q<p and rows[q]>>p&1:rows[q]^=rows[p]
    free=[t for t in range(len(ids)) if t not in rows];H={}
    for k,t in enumerate(free):H[ids[t]]=1<<k
    for p,row in rows.items():H[ids[p]]=sum(((row>>t)&1)<<k for k,t in enumerate(free))
    for row in generators:
        check=0
        while row:
            bit=row&-row;row-=bit;check^=H[ids[bit.bit_length()-1]]
        assert check==0
    # The free columns form an identity matrix, so rank(H)=n-rank(C).
    assert all(H[ids[t]]==1<<k for k,t in enumerate(free));return ids,H
def main():
    start=time.monotonic();directory=ROOT/'moment-resumption-results';paths=[directory/'detector-five/gate.json',directory/'double-pair/gate.json'];gates=[json.loads(p.read_text()) for p in paths]
    assert all(g['status']=='COMPLETE' and not g['cuts'] and g['candidates_processed']==383 for g in gates)
    assert [r['ids'] for r in gates[0]['records']]==[r['ids'] for r in gates[1]['records']]
    banks=[directory/'detector-five/child-bank.json',directory/'double-pair/child-bank.json'];F,P=[translated(json.loads(p.read_text())['cuts']) for p in banks];assert all(len(K)==2 for K in P)
    X,Z,A=physical();stats=Counter();records=[]
    for n,r in enumerate(gates[0]['records']):
        J=r['ids'];ids,H=parity_columns(X,Z,J);one=defaultdict(list);one[0].append(())
        for i in ids:one[H[i]].append((i,))
        pairs={h:list(v) for h,v in one.items()}
        for i,j in combinations(ids,2):pairs.setdefault(H[i]^H[j],[]).append((i,j))
        children=sorted(K for K in F if all(i in H for i in K));got=set()
        for K in children:
            h=0
            for i in K:h^=H[i]
            table=one if len(K)==4 else pairs
            for T in table.get(h,[]):
                if not set(K)&set(T):got.add(tuple(sorted(K+T)))
            if len(K)==2:
                for i in ids:
                    if i in K:continue
                    for T in pairs.get(h^H[i],[]):
                        if i not in T and not set(K)&set(T):got.add(tuple(sorted(K+(i,)+T)))
        assert not got,('unexpected_five_support',J,got)
        eligible_pairs=sorted(K for K in P if all(i in H for i in K));bundles={tuple(sorted(K+L)) for K,L in combinations(eligible_pairs,2) if not set(K)&set(L)};got6=set()
        for K in bundles:
            h=0
            for i in K:h^=H[i]
            for T in pairs.get(h,[]):
                if not set(K)&set(T):got6.add(tuple(sorted(K+T)))
        assert not got6,('unexpected_double_pair_support',J,got6)
        stats.update(queries=1,five_children=len(children),double_pair_bundles=len(bundles));records.append({'ids':J,'eligible_pool_size':len(ids),'rank':128-len(J),'five_support_hits':0,'double_pair_support_hits':0})
        if n%50==0:print('INDEPENDENT CONDITIONED',n,dict(stats),round(time.monotonic()-start,2),flush=True)
    result={'status':'PASS','source_C16_answered':False,'source_sha256':sha(Path(__file__)),'input_hashes':{str(p.relative_to(ROOT)):sha(p) for p in [*paths,*banks]},'statistics':dict(stats),'records':records,'elapsed_seconds':time.monotonic()-start,
            'scope':'Complete physical evaluation-code replay: no detecting support<=5 contains any fixed-bank child, and no support<=6 contains two disjoint fixed-bank forbidden pairs, on all383 frozen mandatory sets. Hence neither capacity composition can reject these sets. This is not extendibility, a full-anchor exclusion, or a cover result.'}
    (directory/'conditioned-detector-independent.json').write_text(json.dumps(result,indent=2)+'\n');print('INDEPENDENT CONDITIONED END',result['statistics'],result['elapsed_seconds'],flush=True)
if __name__=='__main__':main()
