#!/usr/bin/env python3
"""Cover extensions by an orbit representative of the newly added class.

If P(R) is UNSAT, any partial matching witnessing P(R union {c}) uses c.
An action preserving R,c,compatibility and the target can move that edge to
the canonical representative. Thus one anchored UNSAT proof extends P(R).
The prior UNSAT premise is essential. No frame-invariance assumption is used.
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
from signature_cover import logical_data,encode

ROOT=Path(__file__).resolve().parent


def parity_chains(clauses,n,events,target,nbits=16):
    for t in range(nbits):
        vs=[v for v,s in events if s>>t&1]
        if not vs:
            if target>>t&1:clauses.append([])
            continue
        old=vs[0]
        for v in vs[1:]:
            n+=1;new=n
            clauses.extend([[old,v,-new],[-old,-v,-new],[old,-v,new],[-old,v,new]])
            old=new
        clauses.append([old if target>>t&1 else -old])
    return n


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--prior',type=Path,required=True);ap.add_argument('--candidates',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=600);ap.add_argument('--call-seconds',type=float,default=20);ap.add_argument('--drat-trim',type=Path,required=True);a=ap.parse_args();start=time.monotonic();a.output.parent.mkdir(parents=True,exist_ok=True)
    A,C,E=logical_data();base=json.loads(a.prior.read_text());removed=set(map(tuple,base['removed_case_tuples']));initial=sorted(removed);records=[];steps=[];signatures={e[:2]:e[2] for e in E}
    for rawcase in json.loads(a.candidates.read_text())['case_tuples']:
        if time.monotonic()-start>=a.seconds:break
        case=tuple(rawcase)
        if case in removed:continue
        x,z=16*case[0],16*case[1]+case[2];sig=signatures[x,z];trial=removed|{case}
        small=[(i,j,s,0) for i,j,s,c in E if C[c] in trial and (i,j)!=(x,z) and i!=x and j!=z and not A[i]>>z&1 and not A[x]>>j&1]
        clauses,n,_,events=encode(A,[0],small,with_xor=False);target=65535^sig;n=parity_chains(clauses,n,events,target)
        raw=(f'p cnf {n} {len(clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in clauses)).encode();call_start=time.monotonic();record={'case':case,'anchor':[x,z],'removed_count_before':len(removed),'free_edges':len(small),'answer':None}
        with tempfile.TemporaryDirectory(prefix='c16-anchored-cover-') as folder:
            ip=Path(folder)/'input.cnf';pp=Path(folder)/'proof.drat';mp=Path(folder)/'model.json';ip.write_bytes(raw)
            worker="from pysat.solvers import Solver; from pysat.formula import CNF; import sys,json; s=Solver(name='cadical195',bootstrap_with=CNF(from_file=sys.argv[1]).clauses,with_proof=True); a=s.solve(); print(a,flush=True); open(sys.argv[3],'w').write(json.dumps(s.get_model()) if a else 'null'); p=s.get_proof() if not a else []; open(sys.argv[2],'w').write('\\n'.join(p)+'\\n'); s.delete()"
            try:
                run=subprocess.run([sys.executable,'-c',worker,str(ip),str(pp),str(mp)],capture_output=True,text=True,timeout=min(a.call_seconds,max(.01,a.seconds-(time.monotonic()-start))),check=True)
                answer=run.stdout.strip()=='True';record['answer']=answer
                if answer:
                    model=set(json.loads(mp.read_text()));record['partial_matching']=[[x,z]]+[list(e[:2]) for k,e in enumerate(small,1) if k in model]
                else:
                    check=subprocess.run([str(a.drat_trim),str(ip),str(pp)],capture_output=True,text=True,timeout=60);assert check.returncode==0 and 's VERIFIED' in check.stdout
                    stem=a.output.parent/f'step-{len(steps):03d}';cp=stem.with_suffix('.cnf.gz');dp=stem.with_suffix('.drat.gz');proof=pp.read_bytes();cp.write_bytes(gzip.compress(raw,compresslevel=3,mtime=0));dp.write_bytes(gzip.compress(proof,compresslevel=3,mtime=0))
                    cert={'status':'ANCHORED_UNSAT_PROOF_CANDIDATE','case_added_to_removed':case,'anchor':[x,z],'removed_before':sorted(removed),'removed_after':sorted(trial),'retained_case_count':518-len(trial),'anchor_signature':sig,'free_target_signature':target,'free_edge_count':len(small),'variables':n,'clauses':len(clauses),'cnf_file':cp.name,'proof_file':dp.name,'cnf_sha256':hashlib.sha256(raw).hexdigest(),'proof_sha256':hashlib.sha256(proof).hexdigest(),'proof_lines':len(proof.splitlines()),'source_C16_answered':False}
                    stem.with_suffix('.json').write_text(json.dumps(cert,indent=2)+'\n');steps.append(stem.with_suffix('.json').name);removed=trial;record['proof_file']=stem.with_suffix('.json').name
                    print('anchored candidate cover',518-len(removed),'free edges',len(small),flush=True)
            except subprocess.TimeoutExpired:pass
        record['call_seconds']=time.monotonic()-call_start;records.append(record)
        result={'status':'CHAIN_CANDIDATE','source_C16_answered':False,'base_certificate_c16_path':str(a.prior.resolve().relative_to(ROOT)),'initial_removed':initial,'steps':steps,'retained_case_count':518-len(removed),'removed_case_tuples':sorted(removed),'retained_case_tuples':[c for c in C if c not in removed],'records':records,'elapsed_seconds':time.monotonic()-start,'scope':'Inductive symmetry-normalized cover proofs, conditional on base UNSAT. No whole source anchor class is excluded; final physical chain replay is required.'}
        a.output.write_text(json.dumps(result,indent=2)+'\n');print('class',case,record['answer'],'seconds',time.monotonic()-start,flush=True)


if __name__=='__main__':main()
