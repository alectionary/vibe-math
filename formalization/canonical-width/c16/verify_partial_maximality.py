#!/usr/bin/env python3
"""Direct-extension maximality in physical coordinates; no logical search data."""
from pathlib import Path
import argparse
import hashlib
import json
from audit_pools import exchange
from verify_partial_frame import mask,shift

ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    source=ROOT/'physical-pool-source.json';witness=ROOT/'partial-frame-88.json'
    s=json.loads(source.read_text());f=json.loads(witness.read_text())
    Z=[shift(mask(v),h) for v in s['Z_orbit_representatives'] for h in range(16)];X=list(map(exchange,Z))
    assert len(set(X))==len(set(Z))==720
    selectedX={mask(p['X']) for p in f['pairs']};selectedZ={mask(p['Z']) for p in f['pairs']}
    assert len(selectedX)==len(selectedZ)==88 and selectedX<=set(X) and selectedZ<=set(Z)
    I=[i for i,x in enumerate(X) if x not in selectedX and all((x&z).bit_count()%2==0 for z in selectedZ)]
    J=[j for j,z in enumerate(Z) if z not in selectedZ and all((x&z).bit_count()%2==0 for x in selectedX)]
    edges=[(i,j) for i in I for j in J if (X[i]&Z[j]).bit_count()%2]
    assert len(I)==13 and len(J)==5 and not edges
    result={'status':'PASS','source_C16_answered':False,'physical_input_pairs':88,
        'theorem':'The preserved88-pair physical frame is maximal under direct addition of one pair from the complete source minimum-weight pools.',
        'compatible_X_pool_indices':I,'compatible_Z_pool_indices':J,'compatible_cross_edges':0,
        'representation':'1088 physical support bits; logical xcoords/zcoords and the local-neighborhood search are not read.',
        'limit':'Maximality under direct extension is not a maximum-cardinality theorem. Replacing existing pairs may improve the frame.',
        'source_sha256':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [source,witness]}}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print('PASS: physical direct-extension graph13 by5 has no edges;88 is maximal, maximum unknown.',flush=True)


if __name__=='__main__':main()
