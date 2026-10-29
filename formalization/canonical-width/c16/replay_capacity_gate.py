#!/usr/bin/env python3
"""Independent reverse-basis enumeration of every capacity-gate query."""
from pathlib import Path
from itertools import combinations
from collections import defaultdict
import argparse,hashlib,json,time
from verify_algebraic_model import physical
from verify_sparse_quotient import SparseQuotientConsumer
from verify_sparse_gate import independent_obstruction
from verify_detecting_capacity import CapacityConsumer
from verify_mandatory_closure import ClosureConsumer
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

def independently_rejects(X,Z,J,forbidden):
    eligible=[i for i,x in enumerate(X) if all((x&Z[j]).bit_count()%2==0 for j in J)]
    ids=[];pivots={}
    for i in reversed(eligible):
        value=X[i]
        for p,row in sorted(pivots.items()):
            if value>>p&1:value^=row
        if value:
            p=(value&-value).bit_length()-1;pivots[p]=value;ids.append(i)
    r=len(ids);assert r==128-len(J)
    matrix=[[X[i],1<<k] for k,i in enumerate(ids)];positions=[];at=0
    for col in range(128):
        k=next((k for k in range(at,r) if matrix[k][0]>>col&1),None)
        if k is None:continue
        matrix[at],matrix[k]=matrix[k],matrix[at]
        for k in range(r):
            if k!=at and matrix[k][0]>>col&1:matrix[k][0]^=matrix[at][0];matrix[k][1]^=matrix[at][1]
        positions.append(col);at+=1
    dual=[sum(((row[1]>>k)&1)<<p for row,p in zip(matrix,positions)) for k in range(r)]
    supports=[sum(((X[i]&w).bit_count()%2)<<i for i in eligible) for w in dual]
    mask=sum(1<<i for i in ids);extra=[s&~mask for s in supports];lookup=defaultdict(list)
    for i,s in enumerate(extra):lookup[s].append(i)
    residue=SparseQuotientConsumer.quotient(Z[j] for j in J);labels={0,*(residue(z) for z in Z)}
    def test(T):
        support=w=0
        for i in T:support^=supports[i];w^=dual[i]
        q=support.bit_count()
        if not 2<=q<=3:return False
        S=tuple(i for i in range(720) if support>>i&1)
        if not any(K in forbidden for n in range(2,q+1) for K in combinations(S,n)):return False
        target=residue(w);assert target
        if target in labels:return False
        if q==3 and any(target^v in labels for v in labels):return False
        return True
    for i in range(r):
        if test([i]):return True
    for i,j in combinations(range(r),2):
        if test([i,j]):return True
        for k in lookup.get(extra[i]^extra[j],[]):
            if k>j and test([i,j,k]):return True
    return False

def main():
    p=argparse.ArgumentParser();p.add_argument('--directory',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();start=time.monotonic()
    f=json.loads((a.directory/'frozen.json').read_text());g=json.loads((a.directory/'gate.json').read_text());assert g['frozen_sha256']==sha(a.directory/'frozen.json')
    for name,h in f['source_hashes'].items():assert sha(ROOT/name)==h,name
    bp=ROOT/f['bank_c16_path'];assert sha(bp)==f['bank_sha256'];bank=json.loads(bp.read_text())['cuts'];assert len(bank)==256
    forbidden=set();expected=set()
    for cut in bank:
        for h in range(16):forbidden.add(tuple(sorted(16*(i//16)+(i%16+h)%16 for i in cut['indices'])))
        for i in cut['indices']:
            rest=[j for j in cut['indices'] if j!=i]
            expected.add(min(tuple(sorted(16*(j//16)+(j%16+h)%16 for j in rest)) for h in range(16)))
    assert [tuple(item['ids']) for item in f['cohort']]==sorted(expected,key=lambda t:(len(t),t))
    X,Z,A=physical();consumer=CapacityConsumer(X,Z,bank);closure=ClosureConsumer(X,Z,A);checked=0;positive=0
    by_ids={tuple(c['indices']):c for c in g['cuts']};assert len(by_ids)==len(g['cuts'])
    for k,record in enumerate(g['records']):
        J=f['cohort'][k]['ids'];assert record['ids']==J and record['candidate_index']==k
        previous=independent_obstruction(X,Z,0,J);assert not previous[3] and not record['old_complete3_native_reject']
        answer=independently_rejects(X,Z,J,forbidden);assert answer==record['capacity_reject'];checked+=1
        if answer:
            cut=by_ids[tuple(J)];assert cut['kind']=='universal_detecting_capacity' and cut['sector']==1
            assert cut['certificate']['mandatory_opposite']==J;consumer.check(cut['certificate']);positive+=1
            propagation=closure.replay([],J);assert propagation==record['propagation'] and cut['passes_unrestricted_propagation']==propagation['possible']
        if k%25==0:print('CAPACITY REPLAY',k,positive,round(time.monotonic()-start,2),flush=True)
    assert checked==g['candidates_processed'] and positive==len(g['cuts'])
    if g['status']=='COMPLETE':assert checked==len(f['cohort'])
    result={'status':'PASS','source_C16_answered':False,'frozen_sha256':sha(a.directory/'frozen.json'),'gate_sha256':sha(a.directory/'gate.json'),
            'queries_independently_replayed':checked,'composed_certificates_checked':positive,
            'strict_over_old_complete3':positive,'strict_over_old_propagation':sum(c['passes_unrestricted_propagation'] for c in g['cuts']),
            'elapsed_seconds':time.monotonic()-start,'scope':'Complete support-at-most3 capacity test on the saved finite cohort, using reversed source order and independent low-pivot elimination. All child certificates and physical symmetries checked for accepted conclusions. Non-rejection is not a completion witness.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
