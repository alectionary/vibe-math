#!/usr/bin/env python3
"""Collect short, cyclically closed, independently checked necessary clauses."""
import argparse
import hashlib
import json
from pathlib import Path
from rank_oracle import rotate_row,verify_log


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--logs',type=Path,nargs='+',required=True);ap.add_argument('--transposed-logs',type=Path,nargs='*',default=[]);ap.add_argument('--max-size',type=int,default=6);ap.add_argument('--output',type=Path,required=True);args=ap.parse_args()
    root=Path(__file__).parent;X=[int(v,16) for v in (root/'pools/xcoords.txt').read_text().split()];Z=[int(v,16) for v in (root/'pools/zcoords.txt').read_text().split()]
    # Linear inverse taking Z_i to X_i. Every transformed certificate is then
    # checked directly in the destination pools, independently of this map.
    piv={}
    for x,z in zip(X,Z):
        v=z;tag=x
        while v:
            p=v.bit_length()-1
            if p not in piv:piv[p]=(v,tag);break
            v^=piv[p][0];tag^=piv[p][1]
        if not v:assert tag==0
    assert len(piv)==128
    def inverse(v):
        tag=0
        while v:
            p=v.bit_length()-1;v^=piv[p][0];tag^=piv[p][1]
        return tag
    assert all(inverse(z)==x for x,z in zip(X,Z))
    rows={};sources=[]
    for path,transpose in [(p,False) for p in args.logs]+[(p,True) for p in args.transposed_logs]:
        digest=hashlib.sha256();used=0;lines=0
        with path.open('rb') as source:
            for raw in source:
                if not raw.endswith(b'\n'):break
                digest.update(raw);used+=len(raw);lines+=1;row=json.loads(raw)
                if row['kind'] not in ['x_circuit','z_zero','z_eligible'] or len(row['indices'])>args.max_size:continue
                if transpose and 'annihilator' in row:row=dict(row,annihilator=hex(inverse(int(row['annihilator'],16))))
                def key(h):return tuple(sorted((i//16)*16+(i%16+h)%16 for i in row['indices']))
                h=min(range(16),key=key);item=rotate_row(row,h,X,Z);signature=tuple(item['indices'])
                if signature not in rows:rows[signature]=dict(item,cyclic=True)
        sources.append({'path':str(path),'transposed':transpose,'consumed_complete_lines':lines,'consumed_bytes':used,'consumed_prefix_sha256':digest.hexdigest()})
    args.output.write_text(''.join(json.dumps(row)+'\n' for _,row in sorted(rows.items())))
    clauses=verify_log(X,Z,args.output,equivariant=True)
    manifest={'max_indices':args.max_size,'base_clauses':len(rows),'expanded_clauses_before_duplicate_rotations':clauses,'sources':sources,'seed_sha256':hashlib.sha256(args.output.read_bytes()).hexdigest(),'verification':'each transported base certificate directly checked in X/Z pools; full-pool orthogonal cyclic equivariance checked'}
    args.output.with_suffix('.manifest.json').write_text(json.dumps(manifest,indent=2)+'\n');print(json.dumps({k:v for k,v in manifest.items() if k!='sources'}),flush=True)


if __name__=='__main__':main()
