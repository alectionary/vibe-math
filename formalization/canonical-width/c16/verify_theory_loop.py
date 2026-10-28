#!/usr/bin/env python3
"""Physical checks for projected-rank blocks and inclusion-minimal cover data."""
from pathlib import Path
import argparse
import itertools
import json
import time

ROOT=Path(__file__).resolve().parent


def rank(rows):
    basis={}
    for v in rows:
        while v:
            b=v&-v
            if b not in basis:basis[b]=v;break
            v^=basis[b]
    return len(basis)


def canonical(i,j):
    a,b,h=i//16,j//16,(j-i)%16
    return min((a,b,h),(b,a,-h%16))


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    from audit_pools import exchange
    from verify_partial_frame import mask,shift
    source=json.loads((ROOT/'physical-pool-source.json').read_text());Zp=[shift(mask(s),h) for s in source['Z_orbit_representatives'] for h in range(16)];Xp=list(map(exchange,Zp));beta=lambda x,z:(x&z).bit_count()%2
    seeds={s:[shift(mask(seed[s]),h) for seed in source['canonical_seeds'] for h in range(16)] for s in ['X','Z']}
    assert all(beta(x,z)==(i==j) for i,x in enumerate(seeds['X']) for j,z in enumerate(seeds['Z']))
    X=[sum(beta(x,z)<<i for i,z in enumerate(seeds['Z'])) for x in Xp];Z=[sum(beta(x,z)<<i for i,x in enumerate(seeds['X'])) for z in Zp]
    assert rank(X)==rank(Z)==128
    assert all(beta(x,z)==beta(X[i],Z[j]) for i,x in enumerate(Xp) for j,z in enumerate(Zp))
    def matching(pairs):
        value=0
        for k,(i,j) in enumerate(pairs):
            assert beta(Xp[i],Zp[j]);value^=sum((beta(Xp[i],Zp[608+t])*beta(Xp[608+t],Zp[j]))<<t for t in range(16))
            for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not beta(Xp[i],Zp[jj]) and not beta(Xp[ii],Zp[j])
        return value
    folder=ROOT/'theory-loop-results';blocks=[]
    for path in sorted(folder.glob('block-*.json')):
        d=json.loads(path.read_text());r=d['dimension'];U=list(map(lambda s:int(s,16),d['auxiliary_U_hex']));V=list(map(lambda s:int(s,16),d['auxiliary_V_hex']));assert U==[X[i] for i in d['auxiliary_U_source_indices']]
        assert len(U)==len(V)==r and all(beta(u,v)==(i==j) for i,u in enumerate(U) for j,v in enumerate(V))
        H=[sum((beta(u,v)^beta(u,Z[48])*beta(X[48],v))<<j for j,v in enumerate(V)) for u in U]
        assert H==[int(s,16) for s in d['conditional_target_rows_hex']];hr=rank(H);assert hr==d['conditional_target_rank']==d['necessary_free_pairs_at_least'] and hr+1==d['necessary_total_partial_pairs_at_least']
        baseline=json.loads((ROOT/'residual-identity-results/adaptive-anchor-compact.json').read_text());excluded=[{'iteration':p['iteration'],'partial_size':p['partial_size']} for p in baseline['records'] if p['answer'] is True and p['partial_size']-1<hr];assert excluded==d['baseline_partial_witnesses_ruled_out_by_rank']
        if d['answer'] is True:
            pairs=d['partial_matching'];assert pairs[0]==[48,48] and len(pairs)>=hr+1;matching(pairs)
            for u in U:
                for v in V:assert sum(beta(X[i],v)*beta(u,Z[j]) for i,j in pairs)%2==beta(u,v)
        blocks.append({'dimension':r,'conditional_rank':hr,'minimum_total_partial_pairs':hr+1,'baseline_partial_witnesses_ruled_out_by_rank':len(excluded),'solver_answer':d['answer']})
    minimal=json.loads((folder/'minimality-witnesses.json').read_text());chain=json.loads((folder/'anchored/chain.json').read_text());R=set(map(tuple,chain['removed_case_tuples']));D=set(map(tuple,chain['retained_case_tuples']));assert set(map(tuple,minimal['removed_case_tuples']))==R
    seen=set()
    for record in minimal['records']:
        c=tuple(record['case']);assert c in D and c not in seen;seen.add(c);pairs=record['partial_matching'];assert matching(pairs)==65535
        support={canonical(i,j) for i,j in pairs};assert c in support and support<=R|{c}
    assert seen==D and len(D)==minimal['retained_case_count']==480
    # Rank of a sum of m rank-one atoms is at most m, checked literally for
    # all sums of up to three atoms in binary dimensions1..3.
    controls=0
    for n in range(1,4):
        atoms=[tuple(z if x>>i&1 else 0 for i in range(n)) for x in range(1<<n) for z in range(1<<n)]
        atoms=list(set(atoms))
        for m in range(4):
            for chosen in itertools.combinations_with_replacement(atoms,m):
                rows=[0]*n
                for atom in chosen:
                    for i,v in enumerate(atom):rows[i]^=v
                assert rank(rows)<=m;controls+=1
    result={'status':'PASS','source_C16_answered':False,'physical_pairings_checked':518400,'projected_blocks':blocks,'inclusion_minimal_cover':{'cover_size':480,'positive_witnesses_checked':len(seen),'scope':'Inclusion minimality for the original16-signature UNSAT criterion, conditional on separately checked cover480 chain. Not minimum cardinality among other covers and not full-frame feasibility.'},'small_rank_sum_controls':controls,'elapsed_seconds':time.monotonic()-start}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))


if __name__=='__main__':main()
