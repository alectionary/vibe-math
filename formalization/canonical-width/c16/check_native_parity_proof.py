#!/usr/bin/env python3
"""Strict independent LRUP(parity) kernel using low-pivot integer elimination.

Format: Beame--Sun, SAT2026, DOI10.4230/LIPIcs.SAT.2026.5. Unlike merely
checking supplied derivation lines, this entry point requires a terminally
derived empty clause (or an empty input clause). No solver code is imported.
"""
from pathlib import Path
import argparse
import json
import time


class Span:
    def __init__(self):self.rows={}
    def reduce(self,v):
        for p in sorted(self.rows):
            if v&p:v^=self.rows[p]
        return v
    def add(self,v):
        v=self.reduce(v)
        if v:self.rows[v&-v]=v
    def has(self,v):return not self.reduce(v)


def literal(token,n):
    negative=token.startswith('-');body=token[1:] if negative else token
    assert body and '-' not in body
    indices=[int(s) for s in body.split('+')];assert len(indices)==len(set(indices)) and all(1<=i<=n for i in indices)
    return sum(1<<(i-1) for i in indices)^((1<<n) if negative else 0)


def read_input(text):
    lines=[s.strip() for s in text.splitlines() if s.strip() and not s.lstrip().startswith('c')]
    header=lines.pop(0).split();assert len(header)==4 and header[:2] in [['p','cnf'],['p','xnf']]
    n,count=map(int,header[2:]);assert n>=0 and count>=0
    clauses={};pending=[]
    for token in ' '.join(lines).split():
        if token=='0':clauses[len(clauses)+1]=[literal(t,n) for t in pending];pending=[]
        else:pending.append(token)
    assert not pending and len(clauses)==count
    return n,clauses


def check(input_text,proof_text):
    n,clauses=read_input(input_text);one=1<<n;empty=any(not c for c in clauses.values());learned=0;hints=0
    for raw in proof_text.splitlines():
        tokens=raw.split()
        if not tokens or tokens[0]=='c':continue
        zeros=[i for i,t in enumerate(tokens) if t=='0']
        if len(zeros)==1:
            assert zeros[0]==len(tokens)-1
            for t in tokens[:-1]:
                cid=int(t);assert cid in clauses;del clauses[cid]
            continue
        assert len(zeros)==2 and zeros[-1]==len(tokens)-1 and zeros[0]>=1
        cid=int(tokens[0]);assert cid>0 and cid not in clauses
        candidate=[literal(t,n) for t in tokens[1:zeros[0]]]
        reasons=[int(t) for t in tokens[zeros[0]+1:zeros[1]]]
        space=Span()
        # Falsify every disjunct of the candidate affine clause.
        for row in candidate:space.add(row)
        contradiction=space.has(one)
        for reason in reasons:
            assert reason in clauses
            if contradiction:break
            reduced={space.reduce(row) for row in clauses[reason]};reduced.discard(0);hints+=1
            if not reduced:contradiction=True;break
            if len(reduced)!=1:raise AssertionError('non-unit LRUP hint')
            row=next(iter(reduced));assert row!=one,'satisfied LRUP hint'
            space.add(row^one);contradiction=space.has(one)
        assert contradiction,'learned clause lacks a contradiction under its negation'
        clauses[cid]=candidate;learned+=1
        if not candidate:empty=True
    assert empty,'no empty clause was derived'
    return {'status':'PASS','variables':n,'learned_clauses':learned,'unit_hints_checked':hints,'empty_clause_present':empty}


def main():
    ap=argparse.ArgumentParser();ap.add_argument('instance',type=Path);ap.add_argument('proof',type=Path);ap.add_argument('--output',type=Path);a=ap.parse_args();start=time.monotonic();result=check(a.instance.read_text(),a.proof.read_text());result['elapsed_seconds']=time.monotonic()-start
    if a.output:a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__=='__main__':main()
