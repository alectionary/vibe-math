#!/usr/bin/env python3
"""Freeze checked negative CEGAR cuts into an exact private-neighbor CNF.

The source generators check each cut before writing it. This builder additionally
checks syntax, cyclic action and the orthogonal sector exchange. It does not
replay every algebraic certificate: the frozen logs remain required evidence.
"""
import argparse
import hashlib
import json
from pathlib import Path
import tempfile
from pysat.card import CardEnc,EncType


def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    ap=argparse.ArgumentParser();ap.add_argument('base',type=Path);ap.add_argument('private_model',type=Path);ap.add_argument('lemmas',type=Path,nargs='+');ap.add_argument('--output',type=Path,required=True);args=ap.parse_args()
    root=Path(__file__).parent;X=[int(v,16) for v in (root/'pools/xcoords.txt').read_text().split()];Z=[int(v,16) for v in (root/'pools/zcoords.txt').read_text().split()]
    from rank_oracle import rotate_value
    swap=lambda v:sum((v>>(16*b)&65535)<<(16*c) for b,c in enumerate([0,1,4,5,2,3,6,7]))
    assert all(swap(x)==z and swap(z)==x for x,z in zip(X,Z))
    assert all(rotate_value(v,h)==V[(i//16)*16+(i%16+h)%16] for V in [X,Z] for i,v in enumerate(V) for h in range(16))
    metadata=json.loads(args.private_model.read_text());private=metadata['private_literals'];assert len(private)==720 and all(private)
    with args.base.open() as f:header=f.readline().split()
    assert header[:2]==['p','cnf'];top,count=map(int,header[2:]);assert max(map(abs,private))<=top
    # All twelve-monomial classes were completely excluded in the prior block.
    mono=[i for i,x in enumerate(X) if x.bit_count()==1 and x>>64&65535];assert mono==list(range(192,208))
    extra=[]
    for literals in [[i+1 for i in mono],[private[i] for i in mono]]:
        enc=CardEnc.atmost(literals,11,top_id=top,encoding=EncType.seqcounter);extra.extend(enc.clauses);top=enc.nv
    classes={};snapshot_paths=[]
    for k,path in enumerate(args.lemmas):
        snap=args.output.with_suffix(f'.cuts{k}.jsonl');snapshots=[]
        # A live source can end with an incomplete last line. Preserve exactly
        # the complete rows read; never assume the live file stayed unchanged.
        for line in path.read_text().splitlines():
            try:row=json.loads(line)
            except json.JSONDecodeError:continue
            ids=sorted(row['indices']);assert ids and len(ids)==len(set(ids)) and all(0<=i<720 for i in ids)
            assert row['kind'] in ['x_circuit','z_zero','z_eligible','forced_propagation']
            assert row['clause']==[-i-1 for i in row['indices']]
            key=min(tuple(sorted(i//16*16+(i%16+h)%16 for i in ids)) for h in range(16)) if row.get('cyclic') else tuple(ids)
            if key in classes:continue
            classes[key]=bool(row.get('cyclic'));snapshots.append(row)
        snap.write_text(''.join(json.dumps(row)+'\n' for row in snapshots));snapshot_paths.append(snap)
    args.output.parent.mkdir(parents=True,exist_ok=True)
    with tempfile.TemporaryFile(mode='w+t') as body:
        actual=0
        with args.base.open() as source:
            for line in source:
                if line.startswith(('p','c')) or not line.strip():continue
                body.write(line);actual+=1
        assert actual==count
        for row in extra:body.write(' '.join(map(str,row))+' 0\n');actual+=1
        expanded=0
        for ids,cyclic in classes.items():
            orbit={tuple(sorted(i//16*16+(i%16+h)%16 for i in ids)) for h in range(16 if cyclic else 1)}
            for selected in orbit:
                for clause in [[-i-1 for i in selected],[-private[i] for i in selected]]:
                    body.write(' '.join(map(str,clause))+' 0\n');actual+=1;expanded+=1
        body.seek(0)
        with args.output.open('w') as out:
            out.write(f'p cnf {top} {actual}\n')
            while chunk:=body.read(1048576):out.write(chunk)
    result={'scope':'exact128-pair private-neighbor model plus necessary checked CEGAR cuts','status':'CNF_BUILT','base':str(args.base),'private_model':str(args.private_model),'variables':top,'clauses':actual,'base_clauses':count,'cap_clauses':len(extra),'unique_cut_classes':len(classes),'expanded_both_sector_clauses':expanded,'seed4_cap':11,'cut_verification':'each producer checks before logging; frozen logs retained for separate replay','sha256':{str(p):sha(p) for p in [args.base,args.private_model,*snapshot_paths,args.output]}}
    args.output.with_suffix('.manifest.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)


if __name__=='__main__':main()
