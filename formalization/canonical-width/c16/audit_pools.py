#!/usr/bin/env python3
"""Bind saved coordinates and partner domains to physical operators.

Only source data are copied from Lee's release. Arithmetic and CSS checks use
the local independent equation-(50) reconstruction. This checks the listed
pool and the width-18 upper bound; it does not enumerate all low-weight words.
"""
import hashlib
import json
from pathlib import Path
from verify_partial_frame import N, P, mask, parity, rank, reconstruct_checks, shift


def exchange(value):
    result=0
    while value:
        bit=value & -value
        q=bit.bit_length()-1
        block,pos=divmod(q,P)
        tensor,trace=divmod(block,2)
        if tensor<25:
            a,b=divmod(tensor,5);tensor=b*5+a
        else:
            a,b=divmod(tensor-25,3);tensor=25+b*3+a
        result |= 1 << ((2*tensor+trace)*P+pos)
        value ^= bit
    return result


def main():
    root=Path(__file__).parent
    data=json.loads((root/'physical-pool-source.json').read_text())
    hx,hz=reconstruct_checks()
    assert len(hx)==len(hz)==480
    assert rank(hx)==rank(hz)==480 and N-960==128
    assert max(v.bit_count() for v in hx+hz)==9
    assert all(not parity(x,z) for x in hx for z in hz)
    canonical={s:[shift(mask(row[s]),h) for row in data['canonical_seeds'] for h in range(P)]
               for s in ['X','Z']}
    for s,checks in [('X',hz),('Z',hx)]:
        assert len(canonical[s])==128
        assert all(not parity(v,c) for v in canonical[s] for c in checks)
    assert all(parity(x,z)==(i==j) for i,x in enumerate(canonical['X'])
               for j,z in enumerate(canonical['Z']))
    assert max(v.bit_count() for vs in canonical.values() for v in vs)==18
    zseeds=[mask(s) for s in data['Z_orbit_representatives']]
    seeds={'Z':zseeds,'X':[exchange(z) for z in zseeds]}
    phys={s:[shift(v,h) for v in vs for h in range(P)] for s,vs in seeds.items()}
    coordinates={}
    for s,checks,dual in [('X',hz,canonical['Z']),('Z',hx,canonical['X'])]:
        assert len(phys[s])==len(set(phys[s]))==720
        assert all(v.bit_count()==16 for v in phys[s])
        assert all(not parity(v,c) for v in phys[s] for c in checks)
        coordinates[s]=[sum(parity(v,b)<<i for i,b in enumerate(dual)) for v in phys[s]]
        saved=[int(v,16) for v in (root/f'pools/{s.lower()}coords.txt').read_text().split()]
        assert coordinates[s]==saved
        assert len(set(saved))==720 and 0 not in saved and rank(saved)==128
    # Check every physical X/Z pairing, independent of the coordinate source.
    assert all(parity(x,z)==parity(coordinates['X'][i],coordinates['Z'][j])
               for i,x in enumerate(phys['X']) for j,z in enumerate(phys['Z']))
    mu=min((x|shift(z,h)).bit_count() for x in seeds['X'] for z in seeds['Z'] for h in range(P))
    assert mu==26
    report=json.loads((root/'partner-domain-counterexample.json').read_text())
    omitted=1<<report['omitted_bit']; kept=65535^omitted; p=report['retained_bit']
    zs=coordinates['Z']
    ids=[j for j,z in enumerate(zs) if ((z>>64)&kept)==1<<p]
    assert ids==report['complete_partner_indices']
    old=[j for j in ids if ((zs[j]>>64)&65535)==1<<p]
    assert old==report['old_partner_indices']
    extra=report['extra_partner_index']
    assert extra in set(ids)-set(old)
    assert hex(zs[extra])==report['extra_partner_logical_hex']
    assert phys['Z'][extra]==mask(report['extra_partner_physical_support'])
    assert [((zs[extra]>>(64+i))&1) for i in range(16)]==report['pairings_against_seed4_monomials']
    print(json.dumps({'checks':[480,480],'check_ranks':[480,480],'max_check_weight':9,
          'logical_dimension':128,'canonical_frame_pairs':128,'canonical_frame_width':18,
          'pool_sizes':[720,720],'pool_ranks':[128,128],'coordinate_files_match':True,
          'all_physical_pairings_match':True,'minimum_XZ_union':mu,
          'omitted_bit':report['omitted_bit'],'retained_bit':p,
          'old_partners':old,'complete_partners':ids,'extra_partner':extra,
          'pool_completeness_proved':False,
          'input_sha256':{str(p.relative_to(root)):hashlib.sha256(p.read_bytes()).hexdigest()
              for p in [root/'physical-pool-source.json',root/'pools/xcoords.txt',root/'pools/zcoords.txt']}},indent=2))


if __name__=='__main__':main()
