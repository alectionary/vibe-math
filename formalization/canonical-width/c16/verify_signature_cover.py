#!/usr/bin/env python3
"""Physical-support consumer of a nonlinear parity/compatibility cover proof.

No discovery solver or encoder is imported. CNF is regenerated from physical
pairings, compared byte for byte, then an external DRAT checker checks UNSAT.
Small controls compare both encodings with literal induced-match enumeration.
"""
from pathlib import Path
import argparse
import collections
import gzip
import hashlib
import itertools
import json
import subprocess
import tempfile
import time

ROOT=Path(__file__).resolve().parent


def bits(v):
    while v:
        b=v&-v;v^=b;yield b.bit_length()-1


def rank(vs):
    piv={}
    for v in vs:
        while v:
            b=v&-v
            if b not in piv:piv[b]=v;break
            v^=piv[b]
    return len(piv)


def canonical(i,j):
    a,b,h=i//16,j//16,(j-i)%16
    return min((a,b,h),(b,a,(-h)%16))


def independent_cnf(A,C,E,compressed,nbits=16,target=65535,allow=None):
    clauses=[];defs=[];last=len(E)
    L=collections.defaultdict(list);R=collections.defaultdict(list)
    positions={}
    for k,(i,j,s,c) in enumerate(E,1):L[i].append(k);R[j].append(k);positions[i,j]=k
    p={};q={}
    for i in sorted(L):last+=1;p[i]=last;defs.append((last,'or',L[i]))
    for j in sorted(R):last+=1;q[j]=last;defs.append((last,'or',R[j]))
    selectors=[]
    for k in range(len(C)):last+=1;selectors.append(last)
    for k,(i,j,s,c) in enumerate(E,1):
        clauses.append([-k,p[i]]);clauses.append([-k,q[j]]);clauses.append([-k,selectors[c]])
    for i in sorted(L):
        for j in sorted(R):
            if (A[i]>>j)&1:
                row=[-p[i],-q[j]]
                if (i,j) in positions:row.append(positions[i,j])
                clauses.append(row)
    for groups in [L,R]:
        for key in sorted(groups):
            vs=groups[key]
            if len(vs)<=1:continue
            last+=1;prefix=last;clauses.append([-vs[0],prefix]);defs.append((prefix,'or',vs[:1]))
            for index in range(1,len(vs)-1):
                e=vs[index];last+=1;nextprefix=last
                clauses.append([-e,nextprefix]);clauses.append([-prefix,nextprefix]);clauses.append([-e,-prefix])
                defs.append((nextprefix,'or',vs[:index+1]));prefix=nextprefix
            clauses.append([-vs[-1],-prefix])
    events=[(k,e[2]) for k,e in enumerate(E,1)]
    if compressed:
        groups=collections.defaultdict(list)
        for k,s in events:groups[s].append(k)
        events=[]
        for s in sorted(groups):
            last+=1;v=last
            for k in groups[s]:clauses.append([-k,v])
            clauses.append([-v]+groups[s]);defs.append((v,'or',groups[s]));events.append((v,s))
    for t in range(nbits):
        vs=[v for v,s in events if s>>t&1]
        if not vs:
            if target>>t&1:clauses.append([])
            continue
        previous=vs[0]
        for v in vs[1:]:
            last+=1;out=last
            clauses.extend([[previous,v,-out],[-previous,-v,-out],[previous,-v,out],[-previous,v,out]])
            defs.append((out,'xor',[previous,v]));previous=out
        clauses.append([previous if target>>t&1 else -previous])
    if allow is not None:
        for k,v in enumerate(selectors):clauses.append([v if k in allow else -v])
    return clauses,last,defs,selectors


def small_controls():
    graphs=0;assignments=0
    for cells in itertools.product(range(4),repeat=6):
        A=[sum((cells[3*i+j]!=0)<<j for j in range(3)) for i in range(2)]
        E=[(i,j,cells[3*i+j],0) for i in range(2) for j in range(3) if cells[3*i+j]]
        exists=[]
        for compressed in [False,True]:
            cnf,n,defs,selectors=independent_cnf(A,[0],E,compressed,2,3,{0})
            any_model=False
            for choice in range(1<<len(E)):
                selected=[k for k in range(len(E)) if choice>>k&1]
                induced=True
                for a,k in enumerate(selected):
                    i,j,_,_=E[k]
                    for l in selected[:a]:
                        ii,jj,_,_=E[l]
                        if i==ii or j==jj or A[i]>>jj&1 or A[ii]>>j&1:induced=False
                sig=0
                for s in ({E[k][2] for k in selected} if compressed else [E[k][2] for k in selected]):sig^=s
                expected=induced and sig==3
                values=[False]*(n+1)
                for k in selected:values[k+1]=True
                for v in selectors:values[v]=True
                for v,op,terms in defs:values[v]=(any(values[x] for x in terms) if op=='or' else bool(sum(values[x] for x in terms)%2))
                accepted=all(any(values[abs(l)]==(l>0) for l in clause) for clause in cnf)
                assert accepted==expected
                any_model|=accepted;assignments+=1
            exists.append(any_model)
        assert exists[0]==exists[1]
        graphs+=1
    return graphs,assignments


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--drat-trim',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--proof-seconds',type=float,default=120);a=ap.parse_args();start=time.monotonic()
    from audit_pools import exchange
    from verify_partial_frame import mask,shift
    source=json.loads((ROOT/'physical-pool-source.json').read_text())
    Z=[shift(mask(s),h) for s in source['Z_orbit_representatives'] for h in range(16)];X=list(map(exchange,Z))
    A=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
    assert rank(A)==128
    assert all(((A[i]>>j)&1)==((A[j]>>i)&1) for i in range(720) for j in range(720))
    assert all(((A[i]>>j)&1)==((A[16*(i//16)+(i+1)%16]>>(16*(j//16)+(j+1)%16))&1) for i in range(720) for j in range(720))
    assert all((X[608+t]&Z[608+t]).bit_count()%2==1 for t in range(16))
    F=[sum(((x&Z[608+t]).bit_count()%2)<<t for t in range(16)) for x in X]
    G=[sum(((X[608+t]&z).bit_count()%2)<<t for t in range(16)) for z in Z]
    C=sorted({canonical(i,j) for i,row in enumerate(A) for j in bits(row) if F[i]&G[j]})
    assert len(C)==518
    old=json.loads((ROOT/'joint-cover-results/source-witness-cover.json').read_text());assert C==[tuple(c['orbit_tuple']) for c in old['cases']]
    for i,row in enumerate(A):
        for j in bits(row):assert bool(F[i]&G[j])==(canonical(i,j) in C)
    cert=json.loads(a.certificate.read_text());removed={tuple(c) for c in cert['removed_case_tuples']};retained={tuple(c) for c in cert['retained_case_tuples']}
    assert removed and removed<=set(C) and retained==set(C)-removed
    assert len(retained)==cert['retained_case_count']
    pos={c:k for k,c in enumerate(C)}
    E=[(i,j,F[i]&G[j],pos[canonical(i,j)]) for i,row in enumerate(A) for j in bits(row) if canonical(i,j) in removed]
    assert all(e[2] for e in E)
    compressed=cert.get('signature_compression',False)
    clauses,n,_,_=independent_cnf(A,C,E,compressed,allow={pos[c] for c in removed})
    raw=(f'p cnf {n} {len(clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in clauses)).encode()
    saved=gzip.decompress((a.certificate.parent/cert['cnf_file']).read_bytes());proof=gzip.decompress((a.certificate.parent/cert['proof_file']).read_bytes())
    assert raw==saved and hashlib.sha256(raw).hexdigest()==cert['cnf_sha256']
    assert hashlib.sha256(proof).hexdigest()==cert['proof_sha256']
    with tempfile.TemporaryDirectory(prefix='c16-signature-independent-') as folder:
        ip=Path(folder)/'physical.cnf';pp=Path(folder)/'proof.drat';ip.write_bytes(raw);pp.write_bytes(proof)
        check=subprocess.run([str(a.drat_trim),str(ip),str(pp)],capture_output=True,text=True,timeout=a.proof_seconds)
        assert check.returncode==0 and 's VERIFIED' in check.stdout
        empty=Path(folder)/'empty.drat';empty.write_text('')
        bad=subprocess.run([str(a.drat_trim),str(ip),str(empty)],capture_output=True,text=True,timeout=10)
        assert 's VERIFIED' not in bad.stdout
    graphs,assignments=small_controls()
    cases=[{'id':f'X{x:02d}-Z{z:02d}-h{h:02d}','X_index':16*x,'Z_index':16*z+h,'orbit_tuple':[x,z,h],'status':'unresolved'} for x,z,h in C if (x,z,h) in retained]
    result={'status':'PASS','source_C16_answered':False,'old_case_count':518,'new_case_count':len(retained),'removed_classes':len(removed),'completed_conditional_cases':0,'physical_pairings_rebuilt':518400,'physical_pairing_rank':128,'signature_witness_indices':list(range(608,624)),'removed_class_signature_edges':len(E),'independent_CNF_sha256':hashlib.sha256(raw).hexdigest(),'proof_sha256':hashlib.sha256(proof).hexdigest(),'proof_checker_sha256':hashlib.sha256(a.drat_trim.read_bytes()).hexdigest(),'proof_checker_output':check.stdout,'empty_proof_rejected':True,'small_signed_graphs_exhausted':graphs,'literal_encoder_assignment_controls':assignments,'compression_existence_equivalences_checked':graphs,'cases':cases,'scope':'A proved proper nonlinear subcover of518, using simultaneous binary identities and source induced-matching compatibility. All retained completions open; no whole removed class is excluded from full frames. No minimum over nonlinear covers or measured full-search speedup.','elapsed_seconds':time.monotonic()-start}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(f'PASS: independent physical cover{len(retained)}, DRAT proof, {graphs} signed graphs, {assignments} literal controls; {result["elapsed_seconds"]:.1f}s',flush=True)


if __name__=='__main__':main()
