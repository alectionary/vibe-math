#!/usr/bin/env python3
"""Independent Walsh-spectrum/least-pivot consumer of the12-anchor cover.

Does not import the orbit-cover generator or its rank implementation. The
written invariant-annihilator argument supplies completeness of fixed covectors.
"""
from pathlib import Path
import argparse
import hashlib
import json

ROOT=Path(__file__).resolve().parent


def rank(vectors):
    piv={}
    for v in vectors:
        while v:
            b=v&-v
            if b not in piv:piv[b]=v;break
            v^=piv[b]
    return len(piv)


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    cert=json.loads((ROOT/'overnight-results/anchor-cover.json').read_text())
    p=ROOT/'pools/xcoords.txt';raw=p.read_bytes();X=[int(s,16) for s in raw.split()]
    assert hashlib.sha256(raw).hexdigest()==cert['source_sha256']['pools/xcoords.txt']
    assert rank(X)==128 and len(X)==720
    residues=[];freq=[0]*256
    for orbit in range(45):
        labels=[]
        for v in X[16*orbit:16*orbit+16]:
            labels.append(sum((((v>>(16*b))&65535).bit_count()%2)*(1<<b) for b in range(8)))
        assert len(set(labels))==1
        residues.append(labels[0]);freq[labels[0]]+=1
    spectrum=freq[:];step=1
    while step<256:
        for lo in range(0,256,2*step):
            for j in range(lo,lo+step):
                u,v=spectrum[j],spectrum[j+step];spectrum[j],spectrum[j+step]=u+v,u-v
        step*=2
    assert spectrum[0]==45
    weights=[(45-spectrum[w])//2 for w in range(1,256)]
    assert all((45-spectrum[w])%2==0 for w in range(1,256))
    minimum=min(weights);winners=[w for w in range(1,256) if weights[w-1]==minimum]
    assert minimum==cert['optimal_anchor_orbit_count']==12 and len(winners)==11
    expected={r['fixed_mask']:r for r in cert['all_fixed_covectors']};assert set(expected)==set(range(1,256))
    for w in range(1,256):
        H=[i for i,v in enumerate(residues) if (w&v).bit_count()%2]
        assert len(H)==weights[w-1] and H==expected[w]['hit_orbits']
        assert rank(v for i,v in enumerate(X) if i//16 not in H)==expected[w]['complement_rank']
    assert sorted(r['fixed_mask'] for r in cert['minimum_covers'])==winners
    w=cert['chosen_fixed_covector_mask'];H=expected[w]['hit_orbits']
    assert H==cert['anchor_orbits'] and cert['anchor_point_indices']==[16*i for i in H]
    B=cert['positive_X_basis_control']['complement_basis_indices']
    assert len(B)==len(set(B))==127 and all(i//16 not in H for i in B)
    assert rank(X[i] for i in B)==127
    assert all(rank([X[i] for i in B]+[X[16*j]])==128 for j in H)
    result={'status':'PASS','source_C16_answered':False,'independent_method':'integer Walsh-Hadamard spectrum and least-significant-pivot binary rank; generator not imported',
        'nonzero_fixed_covectors':255,'maximum_nonconstant_Walsh_coefficient':max(spectrum[1:]),
        'optimal_orbit_cover_size':minimum,'minimum_cover_count':len(winners),'complement_ranks_rechecked':255,
        'positive_X_basis_controls':12,'anchor_orbits':H}
    casepath=ROOT/'overnight-results/pair-case-cover.json'
    assert casepath.exists()
    if casepath.exists():
        # Rebuild the pairing graph in physical coordinates. The producer
        # used logical coordinates and set unions; here use physical bit
        # pairings and integer incidence masks for all cover costs.
        from audit_pools import exchange
        from verify_partial_frame import mask,shift
        source=json.loads((ROOT/'physical-pool-source.json').read_text())
        Zp=[shift(mask(v),h) for v in source['Z_orbit_representatives'] for h in range(16)];Xp=list(map(exchange,Zp))
        physical_edges=[(i,j,h) for i in range(45) for j in range(45) for h in range(16) if (Xp[16*i]&Zp[16*j+h]).bit_count()%2]
        def canon(e):return min(e,(e[1],e[0],(16-e[2])%16))
        orbit_ids=sorted({canon(e) for e in physical_edges});position={e:k for k,e in enumerate(orbit_ids)}
        incidence=[0]*45
        for i,j,h in physical_edges:incidence[i]|=1<<position[canon((i,j,h))]
        data=json.loads(casepath.read_text());costs={r['fixed_mask']:r for r in data['costs_for_all_fixed_covectors']}
        assert len(physical_edges)==data['common_translation_pair_orbits']==6238
        assert len(orbit_ids)==data['translation_and_sector_exchange_pair_orbits']==3132
        expected_sets={}
        for w in range(1,256):
            hits=expected[w]['hit_orbits'];covered=0
            for i in hits:covered|=incidence[i]
            assert costs[w]['anchor_orbits']==hits and costs[w]['case_count']==covered.bit_count()
            expected_sets[w]=covered
        best=min((bits.bit_count(),len(expected[w]['hit_orbits']),w) for w,bits in expected_sets.items())
        assert best==(1082,12,140) and data['chosen_fixed_mask']==140 and data['optimal_case_count']==1082
        wanted=[e for k,e in enumerate(orbit_ids) if expected_sets[140]>>k&1]
        assert [tuple(r['orbit_tuple']) for r in data['cases']]==wanted
        assert len({r['id'] for r in data['cases']})==1082
        for case in data['cases']:
            i,j,h=case['orbit_tuple']
            assert case['X_index']==16*i and case['Z_index']==16*j+h and case['status']=='unresolved'
        assert data['whole_pair_cases_excluded']==0
        result['selected_pair_cover']={'status':'PASS','physical_pairing_orbits':6238,'symmetry_pair_cases':3132,'optimal_basis_cover_case_count':1082,'costs_checked':255,'all_completion_cases_unresolved':True}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print('PASS: independent Walsh spectrum gives minimum12,11 covers;255 ranks and12 X-basis controls.',flush=True)


if __name__=='__main__':main()
