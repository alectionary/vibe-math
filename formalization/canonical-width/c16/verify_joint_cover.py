#!/usr/bin/env python3
"""Independent physical-support replay of conditional graphs and the new cover.

Does not import any discovery script or its cyclic-mask formulas. Rebuilds all
518400 physical pairings, uses column bitsets for residual degrees and an LSB
rank implementation. The cover is reconstructed by literally translating both
endpoints of each allowed pair and evaluating the two fixed physical witnesses.
"""
from pathlib import Path
import argparse
import collections
import copy
import gzip
import hashlib
import itertools
import json
import time

ROOT=Path(__file__).resolve().parent


def rank(vectors):
    piv={}
    for v in vectors:
        while v:
            bit=v&-v
            if bit not in piv:
                piv[bit]=v
                break
            v^=piv[bit]
    return len(piv)


def canonical(a,b,h):
    x=(a,b,h)
    y=(b,a,(16-h)%16)
    return x if x<=y else y


def check_cover(data, rows):
    assert data['source_C16_answered'] is False
    assert data['whole_pair_cases_excluded']==0
    u,v=data['witness']['u_X_index'],data['witness']['v_Z_index']
    assert 0<=u<720 and 0<=v<720 and rows[u]>>v&1
    wanted=set()
    raw=0
    for a in range(45):
        for b in range(45):
            for h in range(16):
                if not rows[16*a]>>(16*b+h)&1:
                    continue
                for t in range(16):
                    # beta(X_(a,t), witness_v) AND
                    # beta(witness_u, Z_(b,t+h)). No reversed-polynomial shortcut.
                    if (rows[16*a+t]>>v&1) and (rows[u]>>(16*b+(t+h)%16)&1):
                        wanted.add(canonical(a,b,h))
                        raw+=1
                        break
    got=[]
    for c in data['cases']:
        a,b,h=c['orbit_tuple']
        assert c['id']==f'X{a:02d}-Z{b:02d}-h{h:02d}'
        assert c['X_index']==16*a and c['Z_index']==16*b+h
        assert c['status']=='unresolved'
        got.append((a,b,h))
    assert got==sorted(wanted)
    assert data['case_count']==len(got)==518
    return {'case_count':len(got),'pre_exchange_oriented_pair_orbits':raw,'witness_indices':[u,v]}


def small_controls():
    count=0
    for n in range(1,4):
        for basis in itertools.permutations(range(1,1<<n),n):
            if rank(basis)!=n:
                continue
            dual=[]
            for i in range(n):
                choices=[z for z in range(1<<n) if all(((x&z).bit_count()%2)==(i==j) for j,x in enumerate(basis))]
                assert len(choices)==1
                dual.append(choices[0])
            for u in range(1<<n):
                for v in range(1<<n):
                    lhs=(u&v).bit_count()%2
                    rhs=sum(((u&z).bit_count()%2)*((x&v).bit_count()%2) for x,z in zip(basis,dual))%2
                    assert lhs==rhs
                    count+=1
    # A partial frame need not satisfy the identity.
    assert (2&2).bit_count()%2==1 and ((2&1).bit_count()%2)*((1&2).bit_count()%2)==0
    return count


def all_witness_costs(data,rows,cols):
    """Independent actual-edge enumeration, with no cyclic correlation masks."""
    E=sorted({canonical(i,j,h) for i in range(45) for j in range(45) for h in range(16) if rows[16*i]>>(16*j+h)&1})
    pos={e:k for k,e in enumerate(E)}
    # Each actual allowed edge belongs to exactly one of these3132 classes.
    edgeclass=[]
    for k,row in enumerate(rows):
        d={}
        while row:
            bit=row&-row
            l=bit.bit_length()-1
            row^=bit
            d[l]=1<<pos[canonical(k//16,l//16,(l-k)%16)]
        edgeclass.append(d)
    costs={}
    minimum=3133
    winners=[]
    start=time.monotonic()
    for u in range(0,720,16):
        for v in range(720):
            if not rows[u]>>v&1:
                continue
            cover=0
            candidates=cols[v]
            while candidates:
                bit=candidates&-candidates
                k=bit.bit_length()-1
                candidates^=bit
                partners=rows[k]&rows[u]
                while partners:
                    b=partners&-partners
                    l=b.bit_length()-1
                    partners^=b
                    cover|=edgeclass[k][l]
            n=cover.bit_count()
            costs[(u,v)]=n
            if n<minimum:
                minimum=n
                winners=[(u,v)]
            elif n==minimum:
                winners.append((u,v))
    expected={(r['u_X_index'],r['v_Z_index']):r['case_count'] for r in data['witness_costs']}
    assert costs==expected and len(costs)==6238 and minimum==518
    return {'witness_orbits_checked':len(costs),'minimum_case_count':minimum,'minimizing_witnesses':winners,'seconds':time.monotonic()-start}


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--cover',type=Path,default=ROOT/'joint-cover-results/source-witness-cover.json')
    a=ap.parse_args()
    start=time.monotonic()
    from audit_pools import exchange
    from verify_partial_frame import mask,shift
    sourcepath=ROOT/'physical-pool-source.json'
    source=json.loads(sourcepath.read_text())
    Z=[shift(mask(seed),h) for seed in source['Z_orbit_representatives'] for h in range(16)]
    X=[exchange(z) for z in Z]
    assert len(X)==len(Z)==720 and all(v.bit_count()==16 for v in X+Z)
    rows=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
    assert rank(rows)==128
    # Establish both symmetry generators on the literal physical graph.
    assert all(((rows[i]>>j)&1)==((rows[j]>>i)&1) for i in range(720) for j in range(720))
    assert all(((rows[i]>>j)&1)==((rows[16*(i//16)+(i+1)%16]>>(16*(j//16)+(j+1)%16))&1) for i in range(720) for j in range(720))
    data=json.loads(a.cover.read_text())
    covercheck=check_cover(data,rows)
    bad=[]
    d=copy.deepcopy(data);d['cases'].pop();d['case_count']-=1;bad.append(('missing_case',d))
    d=copy.deepcopy(data);d['witness']['v_Z_index']=next(j for j in range(720) if not rows[d['witness']['u_X_index']]>>j&1);bad.append(('nonpairing_witness',d))
    d=copy.deepcopy(data);d['cases'][0]['Z_index']=(d['cases'][0]['Z_index']+1)%720;bad.append(('wrong_phase_index',d))
    rejected=[]
    for name,d in bad:
        try:
            check_cover(d,rows)
        except AssertionError:
            rejected.append(name)
        else:
            raise AssertionError('Accepted corrupted cover '+name)
    cols=[sum(((r>>j)&1)<<i for i,r in enumerate(rows)) for j in range(720)]
    fullcostcheck=all_witness_costs(data,rows,cols)
    old=json.loads((ROOT/'overnight-results/pair-case-cover.json').read_text())
    producer=json.loads(gzip.decompress((ROOT/'joint-cover-results/residual-invariants.json.gz').read_bytes()))
    recorded={r['id']:r for r in producer['cases']}
    signatures={}
    conditional_rank_hist=collections.Counter()
    for c in old['cases']:
        i,j=c['X_index'],c['Z_index']
        L=((1<<720)-1)^cols[j]
        R=((1<<720)-1)^rows[i]
        ld=collections.Counter((r&R).bit_count() for k,r in enumerate(rows) if L>>k&1)
        rd=collections.Counter((r&L).bit_count() for k,r in enumerate(cols) if R>>k&1)
        key=(min(L.bit_count(),R.bit_count()),max(L.bit_count(),R.bit_count()),tuple(sorted((tuple(sorted(ld.items())),tuple(sorted(rd.items()))))))
        # JSON normalizes tuples to lists; compare exact contents after normalization.
        assert json.loads(json.dumps(key))==recorded[c['id']]['invariant']
        assert key not in signatures
        signatures[key]=c['id']
        r=rank(row&R for k,row in enumerate(rows) if L>>k&1)
        assert r==127
        conditional_rank_hist[r]+=1
    oldids={c['id'] for c in old['cases']}
    newids={c['id'] for c in data['cases']}
    u,v=covercheck['witness_indices']
    controls=small_controls()
    result={'status':'PASS','source_C16_answered':False,
            'physical_source_sha256':hashlib.sha256(sourcepath.read_bytes()).hexdigest(),
            'cover_sha256':hashlib.sha256(a.cover.read_bytes()).hexdigest(),
            'physical_pairings_rebuilt':518400,'full_physical_pairing_matrix_rank_F2':128,
            'simultaneous_translation_and_sector_exchange_verified':True,
            'physical_witness':{'u_X_index':u,'v_Z_index':v,'u_support':[i for i in range(1088) if X[u]>>i&1],'v_support':[i for i in range(1088) if Z[v]>>i&1],'pairing':(X[u]&Z[v]).bit_count()%2},
            'new_cover':covercheck,
            'independent_source_witness_minimum':fullcostcheck,
            'old_cover_cases':len(oldids),'new_cover_cases':len(newids),'common_cases':len(oldids&newids),'new_cases_outside_old_cover':len(newids-oldids),
            'conditional_graphs_independently_distinguished':len(signatures),'conditional_matrix_rank_histogram':dict(conditional_rank_hist),
            'small_full_basis_expansion_controls':controls,'negative_controls_rejected':rejected,
            'scope':'Coverage and pairwise nonisomorphism proved; no conditional completion solved. Cover518 need not be a subset of cover1082. No timing claim for completing either cover.',
            'elapsed_seconds':time.monotonic()-start}
    a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(f'PASS: physical cover518, {len(signatures)} old residual graphs pairwise nonisomorphic, {controls} dual-expansion controls, {len(rejected)} corruptions rejected; {result["elapsed_seconds"]:.1f}s',flush=True)


if __name__=='__main__':
    main()
