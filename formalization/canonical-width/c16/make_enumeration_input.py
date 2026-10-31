#!/usr/bin/env python3
"""Build physical checks/detectors without importing Lee's implementation."""
import argparse
import hashlib
import json
from pathlib import Path
from verify_partial_frame import reconstruct_checks,rank,mask,shift
from audit_pools import exchange


def build():
    root=Path(__file__).parent;hx,hz=reconstruct_checks();rows=[]
    for begin in range(0,len(hx),32):
        a=hx[begin:begin+16];b=hx[begin+16:begin+32]
        rows.extend(a+b+[x^y for x,y in zip(a,b)])
    data=json.loads((root/'physical-pool-source.json').read_text())
    detectors=[shift(mask(s['X']),h) for s in data['canonical_seeds'] for h in range(16)]
    assert len(rows)==720 and rank(rows)==rank(hx)==rank(hz)==480
    assert len(detectors)==128 and rank(hx+detectors)==608
    assert rank(hz+[exchange(v) for v in hx])==480 and rank(hx+[exchange(v) for v in hz])==480
    assert all(any(v>>q&1 for v in hx) for q in range(1088))
    def line(value):
        support=[q for q in range(1088) if value>>q&1]
        return str(len(support))+' '+' '.join(map(str,support))+'\n'
    return '1088 720 128 16\n'+''.join(line(v) for v in rows+detectors)


if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('output',type=Path);args=ap.parse_args()
    text=build();args.output.write_text(text)
    print('input SHA256',hashlib.sha256(text.encode()).hexdigest())
