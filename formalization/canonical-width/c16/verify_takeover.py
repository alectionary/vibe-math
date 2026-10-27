#!/usr/bin/env python3
"""Check physical bridges, saved domain coverage and solver witnesses.

This validates the recorded finite outputs; replay_seed4.py repeats the search.
Neither command supplies a kernel-checked proof or independent pool enumeration.
"""
import hashlib
import json
from pathlib import Path
from audit_pools import exchange, main as audit, mask, parity, shift
from replay_seed4 import check_log, masks_for


def main():
    root=Path(__file__).parent
    audit()
    saved=root/'takeover-results'
    manifest=json.loads((saved/'manifest.json').read_text())
    for name,digest in manifest['sources_sha256'].items():
        assert hashlib.sha256((root/name).read_bytes()).hexdigest()==digest,name
    Z=[int(s,16) for s in (root/'pools/zcoords.txt').read_text().split()]
    for m,case in manifest['cases'].items():
        expected=masks_for(16-int(m))
        assert sorted(row['omitted'] for row in case['results'])==expected
        for row in case['results']:
            path=saved/row['log']
            assert hashlib.sha256(path.read_bytes()).hexdigest()==row['sha256']
            actual=check_log(path,Z,row['omitted'])
            assert all(actual[k]==row[k] for k in actual),path
            assert actual['outcome']=='NO_FRAME',path
        assert case['rotation_orbits']==len(expected)
        assert case['assignments']==sum(row['total'] for row in case['results'])
        assert case['full_rank']==sum(row['full'] for row in case['results'])
        print(f"checked saved {m}-monomial coverage: {case['assignments']} assignments, "
              f"{case['full_rank']} full-rank quotients")
    source=json.loads((root/'physical-pool-source.json').read_text())
    zseeds=[mask(s) for s in source['Z_orbit_representatives']]
    phys={'Z':[shift(v,h) for v in zseeds for h in range(16)],
          'X':[shift(exchange(v),h) for v in zseeds for h in range(16)]}
    for name in ['solver-positive16.json','solver-max88.json']:
        path=saved/name
        if not path.exists(): continue
        result=json.loads(path.read_text());pairs=result['pool_pairs']
        assert len(set(i for i,j in pairs))==len(set(j for i,j in pairs))==len(pairs)
        assert all(parity(phys['X'][i],phys['Z'][j])==(a==b)
                   for a,(i,_) in enumerate(pairs) for b,(_,j) in enumerate(pairs))
        print(f"checked {name}: physical Gram identity on {len(pairs)} pairs")
    print('Historical takeover audit passes; unrestricted width remains unresolved. This command does not check pool completeness; run verify_independent_enumeration.py for the later independent computation. No Lean certificate.')


if __name__=='__main__':main()
