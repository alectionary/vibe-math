#!/usr/bin/env python3
"""Independent physical consumer for symmetry-normalized cover proof chains.

Reconstructs the entire physical graph, checks both group generators and each
new-class orbit, rebuilds every anchored CNF, and checks all DRAT proofs. The
base UNSAT certificate is replayed rather than accepted from a JSON status.
"""
from pathlib import Path
import argparse
import gzip
import hashlib
import json
import subprocess
import tempfile
import time
from verify_signature_cover import independent_cnf,small_controls,rank

ROOT=Path(__file__).resolve().parent


def independent_signature_amo(clauses,n,E):
    grouped={}
    definitions=[]
    for index,edge in enumerate(E,1):grouped.setdefault(edge[2],[]).append(index)
    for signature in sorted(grouped):
        variables=grouped[signature]
        if len(variables)<=1:continue
        n+=1;prefix=n;clauses.append([-variables[0],prefix]);definitions.append((prefix,'or',variables[:1]))
        for j in range(1,len(variables)-1):
            e=variables[j];n+=1;out=n
            clauses.append([-e,out]);clauses.append([-prefix,out]);clauses.append([-e,-prefix]);definitions.append((out,'or',variables[:j+1]));prefix=out
        clauses.append([-variables[-1],-prefix])
    return n,definitions


def canonical(i,j):
    a,b,h=i//16,j//16,(j-i)%16
    return min((a,b,h),(b,a,-h%16))


def physical(witness_orbit=38):
    from audit_pools import exchange
    from verify_partial_frame import mask,shift
    source=json.loads((ROOT/'physical-pool-source.json').read_text())
    Z=[shift(mask(seed),h) for seed in source['Z_orbit_representatives'] for h in range(16)];X=list(map(exchange,Z))
    A=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
    assert rank(A)==128
    root=16*witness_orbit
    assert 0<=witness_orbit<45 and all((X[root+t]&Z[root+t]).bit_count()%2==1 for t in range(16))
    F=[sum(((x&Z[root+t]).bit_count()%2)<<t for t in range(16)) for x in X]
    G=[sum(((X[root+t]&z).bit_count()%2)<<t for t in range(16)) for z in Z]
    sig={(i,j):F[i]&G[j] for i in range(720) for j in range(720) if A[i]>>j&1}
    C=sorted({canonical(i,j) for (i,j),s in sig.items() if s});pos={c:k for k,c in enumerate(C)}
    if witness_orbit==38:assert len(C)==518
    shiftindex=lambda i:16*(i//16)+(i+1)%16
    for i in range(720):
        for j in range(720):
            assert (A[i]>>j&1)==(A[j]>>i&1)==(A[shiftindex(i)]>>shiftindex(j)&1)
    for (i,j),s in sig.items():
        assert s==sig[j,i]
        assert sig[shiftindex(i),shiftindex(j)]==((s<<1)&65535)|(s>>15)
        assert bool(s)==(canonical(i,j) in pos)
    return A,C,pos,sig


def check_proof(A,C,E,cert,path,checker,target=65535,allow=None,reject_empty=False):
    clauses,n,_,_=independent_cnf(A,C,E,cert.get('signature_compression',False),target=target,allow=allow)
    if cert.get('one_per_signature',False):n,_=independent_signature_amo(clauses,n,E)
    raw=(f'p cnf {n} {len(clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in clauses)).encode()
    saved=gzip.decompress((path.parent/cert['cnf_file']).read_bytes());proof=gzip.decompress((path.parent/cert['proof_file']).read_bytes())
    assert raw==saved and hashlib.sha256(raw).hexdigest()==cert['cnf_sha256']
    assert n==cert['variables'] and len(clauses)==cert['clauses']
    assert hashlib.sha256(proof).hexdigest()==cert['proof_sha256']
    trivial=any(not clause for clause in clauses)
    with tempfile.TemporaryDirectory(prefix='c16-chain-replay-') as folder:
        ip=Path(folder)/'input.cnf';pp=Path(folder)/'proof.drat';ip.write_bytes(raw);pp.write_bytes(proof)
        if not trivial:
            check=subprocess.run([str(checker),str(ip),str(pp)],capture_output=True,text=True,timeout=180)
            assert check.returncode==0 and 's VERIFIED' in check.stdout
        if reject_empty and not trivial:
            empty=Path(folder)/'empty.drat';empty.write_text('')
            bad=subprocess.run([str(checker),str(ip),str(empty)],capture_output=True,text=True,timeout=10)
            assert 's VERIFIED' not in bad.stdout
    return {'variables':n,'clauses':len(clauses),'edges':len(E),'cnf_sha256':hashlib.sha256(raw).hexdigest(),'proof_sha256':hashlib.sha256(proof).hexdigest(),'verification_kind':'literal_empty_input_clause' if trivial else 'DRAT'}


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--chain',type=Path,required=True);ap.add_argument('--drat-trim',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    A,C,pos,sig=physical();data=json.loads(a.chain.read_text());basepath=ROOT/data['base_certificate_c16_path'];base=json.loads(basepath.read_text());R=set(map(tuple,base['removed_case_tuples']));assert sorted(R)==list(map(tuple,data['initial_removed']))
    E=[(i,j,s,pos[canonical(i,j)]) for (i,j),s in sig.items() if s and canonical(i,j) in R]
    basecheck=check_proof(A,C,E,base,basepath,a.drat_trim,allow={pos[c] for c in R},reject_empty=True)
    steps=[];sat_witnesses=[];stepfiles=[]
    for record in data['records']:
        c=tuple(record['case']);assert c in pos and c not in R
        x,z=16*c[0],16*c[1]+c[2];assert [x,z]==record['anchor'] and canonical(x,z)==c and sig[x,z]
        trial=R|{c}
        if record['answer'] is True:
            pairs=record['partial_matching'];assert pairs[0]==[x,z];value=0
            for k,(i,j) in enumerate(pairs):
                assert (i,j) in sig and canonical(i,j) in trial;value^=sig[i,j]
                for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
            assert value==65535;sat_witnesses.append({'case':c,'partial_matching':pairs})
        elif record['answer'] is False:
            p=a.chain.parent/record['proof_file'];cert=json.loads(p.read_text());assert list(map(tuple,cert['removed_before']))==sorted(R) and list(map(tuple,cert['removed_after']))==sorted(trial)
            assert tuple(cert['case_added_to_removed'])==c and cert['anchor']==[x,z]
            # Literal orbit equality is the transitivity premise for this step.
            orbit={(16*(x//16)+(x+h)%16,16*(z//16)+(z+h)%16) for h in range(16)}
            orbit|={(j,i) for i,j in list(orbit)}
            assert orbit=={e for e,s in sig.items() if canonical(*e)==c}
            free=[(i,j,s,0) for (i,j),s in sig.items() if s and canonical(i,j) in trial and (i,j)!=(x,z) and i!=x and j!=z and not A[i]>>z&1 and not A[x]>>j&1]
            target=65535^sig[x,z];assert target==cert['free_target_signature'] and sig[x,z]==cert['anchor_signature'] and len(free)==cert['free_edge_count']
            checked=check_proof(A,[0],free,cert,p,a.drat_trim,target=target)
            steps.append({'case':c,'orbit_size':len(orbit),'retained_count':518-len(trial),**checked});stepfiles.append(p.name);R=trial
    assert stepfiles==data['steps'] and R==set(map(tuple,data['removed_case_tuples']))
    D=set(C)-R;assert D==set(map(tuple,data['retained_case_tuples'])) and len(D)==data['retained_case_count']
    graphs,assignments=small_controls()
    # A two-colour conflict example demonstrates why base UNSAT cannot be
    # omitted: R={signature3} is SAT, but forcing its conflicting signature1
    # class is UNSAT at target3. All signatures are nonzero.
    example=[(0,0,3),(1,1,1)];models=[]
    for choice in range(4):
        chosen=[e for k,e in enumerate(example) if choice>>k&1];value=0
        for i,j,s in chosen:value^=s
        # The all-one2x2 source matrix forbids both diagonal pairs together.
        if len(chosen)<=1 and value==3:models.append(choice)
    assert models==[1] and not any(choice&2 for choice in models)
    result={'status':'PASS','source_C16_answered':False,'base_case_count':base['retained_case_count'],'new_case_count':len(D),'base_proof':basecheck,'anchored_proofs_checked':len(steps),'steps':steps,'physical_pairings_rebuilt':518400,'group_generator_checks':'source transpose and common C16 shift; signature shift covariance and invariant65535 target','new_class_transitivity_checks':len(steps),'SAT_partial_witnesses_checked':len(sat_witnesses),'small_signed_graphs_exhausted':graphs,'literal_encoder_assignment_controls':assignments,'base_premise_negative_control':'Conflicting signatures3/1 at target3: without base UNSAT the implication fails.','cases':[{'id':f'X{x:02d}-Z{z:02d}-h{h:02d}','X_index':16*x,'Z_index':16*z+h,'orbit_tuple':[x,z,h],'status':'unresolved'} for x,z,h in C if (x,z,h) in D],'elapsed_seconds':time.monotonic()-start,'scope':'Inductive sufficient cover only. No removed class is excluded from full frames, no retained full completion is solved, and no nonlinear-cover optimum is asserted.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print('PASS: cover',len(D),'base proof and',len(steps),'anchored proofs;',result['elapsed_seconds'],'seconds',flush=True)


if __name__=='__main__':main()
