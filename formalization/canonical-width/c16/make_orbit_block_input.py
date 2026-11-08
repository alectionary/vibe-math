#!/usr/bin/env python3
"""Identify exact circulant block patterns and cardinality-equivalent classes."""
import argparse
import json
from pathlib import Path


def affine(pattern,multiplier,shift,P=16):
    return sum(((pattern>>i)&1)<<((multiplier*i+shift)%P) for i in range(P))


def canonical(pattern):return min(affine(pattern,a,b) for a in range(1,16,2) for b in range(16))


def main():
    ap=argparse.ArgumentParser();ap.add_argument('prefix',type=Path);args=ap.parse_args();root=Path(__file__).parent
    X=[int(v,16) for v in (root/'pools/xcoords.txt').read_text().split()];Z=[int(v,16) for v in (root/'pools/zcoords.txt').read_text().split()]
    patterns=[[sum(((X[16*a]&Z[16*b+h]).bit_count()%2)<<h for h in range(16)) for b in range(45)] for a in range(45)]
    assert all((X[16*a+p]&Z[16*b+q]).bit_count()%2==((patterns[a][b]>>((q-p)%16))&1) for a in range(45) for b in range(45) for p in range(16) for q in range(16))
    normal={f:canonical(f) for row in patterns for f in row};classes=sorted(set(normal.values()));mapping=[[normal[f] for f in row] for row in patterns]
    args.prefix.with_suffix('.patterns.txt').write_text(''.join(str(f)+'\n' for f in classes));args.prefix.with_suffix('.mapping.json').write_text(json.dumps({'P':16,'blocks':45,'patterns':patterns,'canonical_patterns':mapping,'classes':classes,'equivalence':'simultaneous phase multiplication by an odd unit and a relative phase shift; both preserve all cardinality triples'},indent=2)+'\n')
    print('Distinct actual block patterns',len(normal),'affine classes',len(classes),'degrees',sorted({f.bit_count() for f in normal}))


if __name__=='__main__':main()
