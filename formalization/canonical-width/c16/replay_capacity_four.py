#!/usr/bin/env python3
"""Independently verify the negative support-four gate and its precise bottleneck."""
from pathlib import Path
from itertools import combinations
from collections import defaultdict,Counter
import argparse,hashlib,json,time
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def supports_through_four(X,Z,J):
    E=[i for i,x in enumerate(X) if all(not (x&Z[j]).bit_count()%2 for j in J)]
    selected=[];pivots={}
    for i in reversed(E):
        value=X[i]
        for p,row in sorted(pivots.items()):
            if value>>p&1:value^=row
        if value:p=(value&-value).bit_length()-1;pivots[p]=value;selected.append(i)
    r=len(selected);assert r==128-len(J);matrix=[[X[i],1<<k] for k,i in enumerate(selected)];cols=[];at=0
    for col in range(128):
        pivot=next((k for k in range(at,r) if matrix[k][0]>>col&1),None)
        if pivot is None:continue
        matrix[pivot],matrix[at]=matrix[at],matrix[pivot]
        for k in range(r):
            if k!=at and matrix[k][0]>>col&1:matrix[k][0]^=matrix[at][0];matrix[k][1]^=matrix[at][1]
        cols.append(col);at+=1
    dual=[sum(((row[1]>>k)&1)<<p for row,p in zip(matrix,cols)) for k in range(r)]
    support=[sum(((X[i]&w).bit_count()%2)<<i for i in E) for w in dual]
    bm=sum(1<<i for i in selected);extra=[s&~bm for s in support];nonbasis=[i for i in E if not bm>>i&1]
    found=set()
    def consider(T):
        s=0
        for i in T:s^=support[i]
        if s.bit_count()<=4:found.add(s)
    for i in range(r):consider([i])
    near=defaultdict(list)
    for k,e in enumerate(extra):
        near[e].append(k)
        for i in nonbasis:near[e^(1<<i)].append(k)
    # Complete unordered pair table, unlike the incremental discovery table.
    pairs=defaultdict(list)
    for i,j in combinations(range(r),2):pairs[extra[i]^extra[j]].append((i,j))
    for value,group in pairs.items():
        for i,j in group:
            consider([i,j])
            for k in near.get(value,[]):
                if k>j:consider([i,j,k])
            for k,l in group:
                if j<k:consider([i,j,k,l])
    assert 0 not in found
    return [tuple(i for i in E if s>>i&1) for s in found]
def main():
    p=argparse.ArgumentParser();p.add_argument('--output',type=Path,required=True);a=p.parse_args();start=time.monotonic();out=ROOT/'transfer-results/capacity-four'
    f=json.loads((out/'frozen.json').read_text());g=json.loads((out/'gate.json').read_text());assert g['status']=='COMPLETE' and not g['cuts'] and g['frozen_sha256']==sha(out/'frozen.json')
    for name,h in f['source_hashes'].items():assert sha(ROOT/name)==h
    parent=ROOT/f['parent_cohort_c16_path'];assert sha(parent)==f['parent_cohort_sha256'];cohort=json.loads(parent.read_text())['cohort']
    bp=ROOT/f['bank_c16_path'];assert sha(bp)==f['bank_sha256'];bank=json.loads(bp.read_text())['cuts'];forbidden=set()
    for c in bank:
        for h in range(16):forbidden.add(tuple(sorted(16*(i//16)+(i%16+h)%16 for i in c['indices'])))
    X,Z,A=physical();total=Counter();queries_with_support=0
    for k,item in enumerate(cohort):
        record=g['records'][k];assert record['ids']==item['ids'] and record['candidate_index']==k and not record['capacity_reject']
        supports=supports_through_four(X,Z,item['ids']);counts=Counter();queries_with_support+=bool(supports)
        for S in supports:
            assert 2<=len(S)<=4;counts['supports_'+str(len(S))]+=1
            assert not any(K in forbidden for n in range(2,len(S)+1) for K in combinations(S,n))
        assert dict(counts)==record['diagnostics'],(k,counts,record['diagnostics']);total.update(counts)
        if k%25==0:print('CAPACITY4 REPLAY',k,dict(total),round(time.monotonic()-start,2),flush=True)
    assert dict(total)==g['statistics'] and len(g['records'])==len(cohort)==384
    result={'status':'PASS','source_C16_answered':False,'frozen_sha256':sha(out/'frozen.json'),'gate_sha256':sha(out/'gate.json'),
            'queries_replayed':384,'total_supports_by_size':dict(total),'queries_with_support_at_most4':queries_with_support,
            'queries_with_minimum_nonzero_support_at_least5':384-queries_with_support,'forbidden_child_hits':0,
            'elapsed_seconds':time.monotonic()-start,'scope':'Independent reversed-basis low-pivot enumeration of every nonzero residual functional with detecting support at most4 in this finite cohort. None contains a child from the fixed256 bank. This proves a bottleneck for this gate, not extendibility or global frame nonexistence.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
