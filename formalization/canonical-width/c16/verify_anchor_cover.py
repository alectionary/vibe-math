#!/usr/bin/env python3
"""Optimal orbit-union hitting set for source X bases, via fixed covectors.

If the span of the complement of removed cyclic orbits is proper, its
annihilator is nonzero and invariant. In characteristic2, (T*-I)^16=0,
so this annihilator contains a nonzero fixed covector. Such covectors have
one constant bit per16-bit block: only255 possibilities, not2^45 subsets.
"""
from pathlib import Path
from collections import Counter
import argparse
import hashlib
import json

ROOT=Path(__file__).resolve().parent


def basis_indices(values,indices):
    piv={};out=[]
    for i in indices:
        v=values[i]
        while v:
            k=v.bit_length()-1
            if k not in piv:piv[k]=v;out.append(i);break
            v^=piv[k]
    return out


def rotate(v,h):
    if not h:return v
    out=0
    for b in range(8):
        word=(v>>(16*b))&65535
        out|=(((word<<h)|(word>>(16-h)))&65535)<<(16*b)
    return out


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    paths=[ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt']
    X,Z=[[int(s,16) for s in p.read_text().split()] for p in paths]
    assert len(X)==len(Z)==720 and len(basis_indices(X,range(720)))==128
    assert all(v[16*i+h]==rotate(v[16*i],h) for v in [X,Z] for i in range(45) for h in range(16))
    assert all((x&z).bit_count()%2==(rotate(x,1)&rotate(z,1)).bit_count()%2 for x in X for z in Z)
    # Explicit fixed covectors constitute the complete8-dimensional fixed
    # space of simultaneous eight-block cyclic translation on the dual.
    residues=[sum((((x>>(16*b))&65535).bit_count()%2)<<b for b in range(8)) for x in X[::16]]
    records=[]
    for mask in range(1,256):
        w=sum(65535<<(16*b) for b in range(8) if mask>>b&1)
        assert rotate(w,1)==w
        H=[i for i,v in enumerate(residues) if (mask&v).bit_count()%2]
        assert H and all((w&X[16*i+h]).bit_count()%2==(i in H) for i in range(45) for h in range(16))
        B=basis_indices(X,[i for i in range(720) if i//16 not in H])
        assert len(B)<128
        records.append({'fixed_mask':mask,'hit_orbits':H,'complement_rank':len(B)})
    minimum=min(len(r['hit_orbits']) for r in records)
    winners=[r for r in records if len(r['hit_orbits'])==minimum]
    chosen=winners[0];H=chosen['hit_orbits'];B=basis_indices(X,[i for i in range(720) if i//16 not in H])
    assert len(B)==127 and all(len(basis_indices(X,B+[16*i]))==128 for i in H)
    result={'status':'PASS','source_C16_answered':False,
        'theorem':'Every full source frame is a common cyclic translate of a frame containing X_(16*a) for some a in the listed12 anchor orbits. No union of fewer than12 complete X orbits meets every source X basis.',
        'optimal_anchor_orbit_count':minimum,'anchor_orbits':H,'anchor_point_indices':[16*i for i in H],
        'chosen_fixed_covector_mask':chosen['fixed_mask'],'chosen_complement_rank':127,
        'positive_X_basis_control':{'complement_basis_indices':B,'each_anchor_extends_to_rank':128,'anchor_cases_checked':len(H)},
        'minimum_covers':winners,'all_fixed_covectors':records,
        'fixed_covector_count':255,'orbit_cover_size_histogram':dict(sorted(Counter(len(r['hit_orbits']) for r in records).items())),
        'scope':'Coverage and optimality for orbit-union hitting sets of spanning X subsets. All12 frame-anchored cases remain unresolved; no endpoint or global runtime gain measured.',
        'source_sha256':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}}
    assert minimum==12 and len(winners)==11
    a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ['status','optimal_anchor_orbit_count','anchor_orbits','chosen_complement_rank','source_C16_answered']}),flush=True)


if __name__=='__main__':main()
