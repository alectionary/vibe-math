#!/usr/bin/env python3
"""Check the independent execution record and all its physical output data.

The full traversal is repeated with enumerate_physical.cpp; this checker does
not re-execute 47 million nodes or supply a Lean proof of the search program.
"""
import hashlib
import json
from pathlib import Path
import re
from make_enumeration_input import build
from verify_partial_frame import reconstruct_checks,rank,mask,shift,parity
from audit_pools import exchange


def main():
    root=Path(__file__).parent;folder=root/'four-hours-results/enumeration'
    manifest=json.loads((folder/'manifest.json').read_text())
    for name,digest in manifest['sha256'].items():
        path=root/name;assert hashlib.sha256(path.read_bytes()).hexdigest()==digest,name
    assert (folder/'input.txt').read_text()==build()
    result=json.loads((folder/'result.json').read_text());assert result['complete'] and result['W']==17
    assert result['first_root']==0 and result['end_root']==68
    log=(folder/'stderr.log').read_text();records=re.findall(r'^root (\d+) COMPLETE nodes (\d+)',log,re.M)
    assert [int(a) for a,b in records]==list(range(68)) and 'INCOMPLETE' not in log
    assert sum(int(b) for a,b in records)==result['nodes']==47708679
    source=json.loads((root/'physical-pool-source.json').read_text())
    expected={mask(s) for s in source['Z_orbit_representatives']};found={int(s,16) for s in result['masks_hex']}
    assert found==expected and len(found)==45 and {v.bit_count() for v in found}=={16}
    hx,hz=reconstruct_checks();cx=[shift(mask(s['X']),h) for s in source['canonical_seeds'] for h in range(16)]
    assert rank(hx+cx)==608 and rank(hx)==rank(hz)==480
    assert all(not parity(x,z) for x in hx+cx for z in hz)
    # Consequently hx+cx spans ker(hz), so the detector test is exact.
    assert all(all(not parity(v,c) for c in hx) and any(parity(v,x) for x in cx) for v in found)
    assert all(v==min(shift(v,h) for h in range(16)) for v in found)
    assert rank(hz+[exchange(v) for v in hx])==480 and rank(hx+[exchange(v) for v in hz])==480
    assert all(exchange(exchange(1<<q))==1<<q for q in range(1088))
    assert all(exchange(shift(1<<q,1))==shift(exchange(1<<q),1) for q in range(1088))
    assert all(any(v>>q&1 for v in hx) for q in range(1088))
    physicalZ=[shift(v,h) for v in found for h in range(16)]
    assert len(set(physicalZ))==720
    union=min((exchange(x)|shift(z,h)).bit_count() for x in found for z in found for h in range(16))
    assert union==26
    print('PASS: all68 roots complete;47,708,679 nodes;45 matching weight16 orbits;720 physical representatives per sector; minimum X/Z union26.')
    print('Evidence: independent finite enumeration plus written completeness argument. No Lean search certificate.')


if __name__=='__main__':main()
