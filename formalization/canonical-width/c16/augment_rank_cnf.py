#!/usr/bin/env python3
"""Add independently certified rank clauses to an existing frame CNF."""
import argparse
from array import array
import hashlib
import json
from pathlib import Path
from rank_oracle import verify_log,rotate_row


def main():
    ap=argparse.ArgumentParser();ap.add_argument('base',type=Path);ap.add_argument('lemmas',type=Path,nargs='+')
    ap.add_argument('--output',type=Path,required=True);ap.add_argument('--private-model',type=Path);args=ap.parse_args()
    root=Path(__file__).parent;X=[int(v,16) for v in (root/'pools/xcoords.txt').read_text().split()];Z=[int(v,16) for v in (root/'pools/zcoords.txt').read_text().split()]
    private=json.loads(args.private_model.read_text())['private_literals'] if args.private_model else None
    total=0
    for path in args.lemmas:
        count=verify_log(X,Z,path,private,equivariant=True);total+=count
        print('verified',path,count,flush=True)
    rows=[];seen=set()
    for path in args.lemmas:
        with path.open() as source:
            for line in source:
                row=json.loads(line)
                for h in range(16 if row.get('cyclic') else 1):
                    item=rotate_row(row,h,X,Z,private) if row.get('cyclic') else row
                    clause=item['clause'];key=hashlib.sha256(array('i',sorted(clause)).tobytes()).digest()
                    if key in seen:continue
                    seen.add(key);rows.append(clause)
    base=args.base.read_text().splitlines();header=next(s for s in base if s.startswith('p cnf ')).split();n=int(header[2]);count=int(header[3])
    assert all(all(0<abs(l)<=n for l in c) for c in rows)
    assert count==sum(bool(line.strip()) and not line.startswith(('p','c')) for line in base)
    with args.output.open('w') as out:
        out.write(f'p cnf {n} {count+len(rows)}\n')
        for line in base:
            if not line.startswith(('p','c')) and line.strip():out.write(line+'\n')
        for clause in rows:out.write(' '.join(map(str,clause))+' 0\n')
    files=[args.base,*args.lemmas,args.output]
    manifest={'base_variables':n,'base_clauses':count,'certified_clauses_before_deduplication':total,'unique_added_clauses':len(rows),'cyclic_check':'base certificates plus checked orthogonal equivariance on both entire pools','sha256':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in files}}
    args.output.with_suffix('.manifest.json').write_text(json.dumps(manifest,indent=2)+'\n');print(json.dumps(manifest),flush=True)


if __name__=='__main__':main()
