#!/usr/bin/env python3
"""Turn a pool-pair result into physical supports for the independent checker."""
import argparse
import hashlib
import json
from pathlib import Path
from audit_pools import exchange
from verify_partial_frame import mask,shift


def main():
    ap=argparse.ArgumentParser();ap.add_argument('result',type=Path);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--allow-partial',action='store_true');args=ap.parse_args()
    root=Path(__file__).parent;result=json.loads(args.result.read_text());pairs=result['pool_pairs']
    assert 0<len(pairs)<=128 and (args.allow_partial or len(pairs)==128)
    assert len({i for i,j in pairs})==len({j for i,j in pairs})==len(pairs)
    data=json.loads((root/'physical-pool-source.json').read_text());Z=[shift(mask(row),h) for row in data['Z_orbit_representatives'] for h in range(16)];X=[exchange(z) for z in Z]
    def support(v):return [q for q in range(1088) if v>>q&1]
    witness={'n_pairs':len(pairs),'pairs':[{'X':support(X[i]),'Z':support(Z[j])} for i,j in pairs],
             'canonical_target_id':'L-F91-c16-unrestricted-width','source_pool_pairs':pairs,
             'result_sha256':hashlib.sha256(args.result.read_bytes()).hexdigest(),
             'physical_pool_source_sha256':hashlib.sha256((root/'physical-pool-source.json').read_bytes()).hexdigest()}
    args.output.write_text(json.dumps(witness,indent=2)+'\n');print('Materialized',len(pairs),'physical pairs; run verify_partial_frame.py next.')


if __name__=='__main__':main()
