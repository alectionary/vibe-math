#!/usr/bin/env python3
"""Nonlinear unit-signature cover for a selected self-paired source witness.

The objective is signature simplicity, not minimum linear support. Every
removed class has one-bit signatures; free zero-target groups can be deleted,
and each positive target group can be represented by exactly one source edge.
This gives a15-colour compatibility problem after anchoring a new class.
"""
from pathlib import Path
import argparse
import gzip
import hashlib
import json
import subprocess
import sys
import tempfile
import time
from signature_cover import logical_data,canonical,encode
from anchored_cover_chain import parity_chains
from exchange_anchored_cover import signature_amo

ROOT=Path(__file__).resolve().parent


def data(w):
    A,_,_=logical_data();root=16*w;assert all(A[root+t]>>(root+t)&1 for t in range(16));F=[(row>>root)&65535 for row in A]
    all_edges=[(i,j,F[i]&F[j]) for i,row in enumerate(A) for j in range(720) if row>>j&1]
    C=sorted({canonical(i,j) for i,j,s in all_edges if s});pos={c:k for k,c in enumerate(C)};E=[(i,j,s,pos[canonical(i,j)]) for i,j,s in all_edges if s]
    weights={e[3]:e[2].bit_count() for e in E};assert all(weights[e[3]]==e[2].bit_count() for e in E)
    return A,C,E,weights


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--witness-orbit',type=int,required=True);ap.add_argument('--single-survey',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=900);ap.add_argument('--call-seconds',type=float,default=2);ap.add_argument('--drat-trim',type=Path,required=True);a=ap.parse_args();start=time.monotonic();a.output.parent.mkdir(parents=True,exist_ok=True)
    A,C,E,weights=data(a.witness_orbit);by={e[:2]:e[2] for e in E};pos={c:k for k,c in enumerate(C)};single=next(r for r in json.loads(a.single_survey.read_text())['records'] if r['witness_orbit']==a.witness_orbit);mandatory={pos[tuple(r['case'])] for r in single['positive_records']};order=[k for k in range(len(C)) if weights[k]==1 and k not in mandatory]
    # Start with source classes having the most internal incompatibility.
    def difficulty(c):
        a,b,h=C[c];orbit=[e for e in E if e[3]==c];return sum(not A[i]>>zz&1 and not A[ii]>>z&1 and i!=ii and z!=zz for i,z,s,k in orbit for ii,zz,ss,kk in orbit)
    order.sort(key=lambda c:(difficulty(c),C[c]));R=set();records=[];steps=[]
    for c in order:
        if time.monotonic()-start>=a.seconds:break
        trial=R|{c};aa,bb,h=C[c];x,z=16*aa,16*bb+h;target=65535^by[x,z]
        original=[(i,j,s,0) for i,j,s,k in E if k in trial and (i,j)!=(x,z) and i!=x and j!=z and not A[i]>>z&1 and not A[x]>>j&1];assert all(s.bit_count()==1 for i,j,s,k in original)
        small=[e for e in original if e[2]&target];clauses,n,_,events=encode(A,[0],small,with_xor=False,compress_signatures=True);n=parity_chains(clauses,n,events,target);n=signature_amo(clauses,n,small)
        raw=(f'p cnf {n} {len(clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in clauses)).encode();call_start=time.monotonic();record={'case':C[c],'anchor':[x,z],'removed_count_before':len(R),'free_edges':len(small),'answer':None}
        with tempfile.TemporaryDirectory(prefix='c16-unit-witness-') as folder:
            ip=Path(folder)/'input.cnf';pp=Path(folder)/'proof.drat';mp=Path(folder)/'model.json';ip.write_bytes(raw)
            worker="from pysat.solvers import Solver; from pysat.formula import CNF; import sys,json; s=Solver(name='cadical195',bootstrap_with=CNF(from_file=sys.argv[1]).clauses,with_proof=True); a=s.solve(); print(a,flush=True); open(sys.argv[3],'w').write(json.dumps(s.get_model()) if a else 'null'); p=s.get_proof() if not a else []; open(sys.argv[2],'w').write('\\n'.join(p)+'\\n'); s.delete()"
            try:
                run=subprocess.run([sys.executable,'-c',worker,str(ip),str(pp),str(mp)],capture_output=True,text=True,timeout=min(a.call_seconds,max(.01,a.seconds-(time.monotonic()-start))),check=True);answer=run.stdout.strip()=='True';record['answer']=answer
                if answer:
                    model=set(json.loads(mp.read_text()));record['partial_matching']=[[x,z]]+[list(e[:2]) for k,e in enumerate(small,1) if k in model]
                else:
                    if not any(not clause for clause in clauses):
                        check=subprocess.run([str(a.drat_trim),str(ip),str(pp)],capture_output=True,text=True,timeout=30);assert check.returncode==0 and 's VERIFIED' in check.stdout
                    proof=pp.read_bytes();stem=a.output.parent/f'step-{len(steps):03d}';cp=stem.with_suffix('.cnf.gz');dp=stem.with_suffix('.drat.gz');cp.write_bytes(gzip.compress(raw,compresslevel=3,mtime=0));dp.write_bytes(gzip.compress(proof,compresslevel=3,mtime=0))
                    cert={'case_added_to_removed':C[c],'anchor':[x,z],'removed_before':[C[k] for k in sorted(R)],'removed_after':[C[k] for k in sorted(trial)],'retained_case_count':len(C)-len(trial),'anchor_signature':by[x,z],'free_target_signature':target,'free_edges_before_zero_target_deletion':len(original),'free_edge_count':len(small),'unit_zero_target_deletion':True,'signature_compression':True,'one_per_signature':True,'variables':n,'clauses':len(clauses),'cnf_file':cp.name,'proof_file':dp.name,'cnf_sha256':hashlib.sha256(raw).hexdigest(),'proof_sha256':hashlib.sha256(proof).hexdigest(),'proof_lines':len(proof.splitlines())};stem.with_suffix('.json').write_text(json.dumps(cert,indent=2)+'\n');steps.append(stem.with_suffix('.json').name);R=trial
            except subprocess.TimeoutExpired:pass
        record['call_seconds']=time.monotonic()-call_start;records.append(record);D=[c for k,c in enumerate(C) if k not in R]
        result={'status':'UNIT_CHAIN_CANDIDATE','source_C16_answered':False,'witness_orbit':a.witness_orbit,'witness_indices':list(range(16*a.witness_orbit,16*a.witness_orbit+16)),'support_case_count':len(C),'nonunit_case_count':sum(v!=1 for v in weights.values()),'unit_case_count':sum(v==1 for v in weights.values()),'initial_removed':[],'base_reason':'Empty edge set cannot XOR to65535.','retained_case_count':len(D),'removed_case_tuples':[C[k] for k in sorted(R)],'retained_case_tuples':D,'steps':steps,'records':records,'single_class_unit_positive_records':single['positive_records'],'trials_possible':len(order),'elapsed_seconds':time.monotonic()-start,'scope':'New witness support, not a subcover of the old518 list. Every removed class has unit signatures. Final physical replay required; no optimum or full-frame completion claimed.'};a.output.write_text(json.dumps(result,indent=2)+'\n')
        if len(records)%25==0:print('witness',a.witness_orbit,len(records),'trials candidate cover',len(D),'removed',len(R),'unknown',sum(r['answer'] is None for r in records),'seconds',time.monotonic()-start,flush=True)


if __name__=='__main__':main()
