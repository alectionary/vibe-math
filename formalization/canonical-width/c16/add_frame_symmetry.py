#!/usr/bin/env python3
"""Add lexicographic leaders for common translation and sector exchange.

For a full frame, its selected Z set equals its private-neighbor set. Choose
the lexicographically largest selected-X bit string among both sectors and all
16 shifts. Translation and sector exchange preserve every full-frame condition.
The augmented model is therefore equisatisfiable, but no individual symmetry
clause is asserted to hold for every frame.
"""
import argparse
import hashlib
import json
from pathlib import Path


def lex_clauses(left,right,top):
    assert len(left)==len(right) and left
    clauses=[];p=None
    for i,(a,b) in enumerate(zip(left,right)):
        clauses.append([a,-b] if p is None else [-p,a,-b])
        if i==len(left)-1:continue
        top+=1;nxt=top
        if p is None:clauses.extend([[-nxt,-a,b],[-nxt,a,-b],[-a,-b,nxt],[a,b,nxt]])
        else:clauses.extend([[-nxt,p],[-nxt,-a,b],[-nxt,a,-b],[-p,-a,-b,nxt],[-p,a,b,nxt]])
        p=nxt
    return clauses,top


def main():
    ap=argparse.ArgumentParser();ap.add_argument('cnf',type=Path);ap.add_argument('private_model',type=Path);ap.add_argument('--output',type=Path,required=True);args=ap.parse_args()
    private=json.loads(args.private_model.read_text())['private_literals'];assert len(private)==720 and all(private)
    with args.cnf.open() as source:header=source.readline().split()
    assert header[:2]==['p','cnf'];top,count=map(int,header[2:]);before=top;clauses=[]
    # p implies that all earlier entries were equal. Exact equality propagation
    # makes the first differing entries obey a>=b (selected=True first).
    for sector in [list(range(1,721)),private]:
        for h in range(16):
            if sector==list(range(1,721)) and h==0:continue
            right=[sector[i//16*16+(i%16-h)%16] for i in range(720)]
            rows,top=lex_clauses(list(range(1,721)),right,top);clauses.extend(rows)
    with args.output.open('w') as out:
        out.write(f'p cnf {top} {count+len(clauses)}\n');actual=0
        with args.cnf.open() as source:
            for line in source:
                if line.startswith(('p','c')) or not line.strip():continue
                actual+=1;out.write(line)
        assert actual==count
        for row in clauses:out.write(' '.join(map(str,row))+' 0\n')
    result={'scope':'equisatisfiable cyclic/sector lexicographic symmetry reduction','status':'CNF_BUILT','variables':top,'clauses':count+len(clauses),'new_variables':top-before,'new_clauses':len(clauses),'group_elements':32,'sha256':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in [args.cnf,args.private_model,args.output]}}
    args.output.with_suffix('.manifest.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))


if __name__=='__main__':main()
