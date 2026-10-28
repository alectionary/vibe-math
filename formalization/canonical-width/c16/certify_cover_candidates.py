#!/usr/bin/env python3
"""Bounded compact proof attempts for previously UNKNOWN cover proposals."""
from pathlib import Path
import argparse
import gzip
import hashlib
import json
import subprocess
import sys
import tempfile
import time
from signature_cover import logical_data, encode

ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--input',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--per-call-seconds',type=float,default=10)
    ap.add_argument('--seconds',type=float,default=180)
    ap.add_argument('--count',type=int,default=100)
    a=ap.parse_args()
    start=time.monotonic();A,C,E=logical_data()
    source=json.loads(a.input.read_text())
    candidates=source['unknown_candidates']
    records=[];found=None
    for q,candidate in enumerate(candidates[:a.count]):
        if time.monotonic()-start>=a.seconds:break
        removed={tuple(c) for c in candidate}
        small=[e for e in E if C[e[3]] in removed]
        clauses,n,S,events=encode(A,C,small)
        clauses.extend([[v if c in removed else -v] for c,v in zip(C,S)])
        raw=(f'p cnf {n} {len(clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in clauses)).encode()
        call_start=time.monotonic()
        with tempfile.TemporaryDirectory(prefix='c16-compact-candidate-') as folder:
            ip=Path(folder)/'input.cnf';op=Path(folder)/'proof.drat';mp=Path(folder)/'model.json';ip.write_bytes(raw)
            worker="from pysat.solvers import Solver; from pysat.formula import CNF; import sys,json; s=Solver(name='cadical195',bootstrap_with=CNF(from_file=sys.argv[1]).clauses,with_proof=True); a=s.solve(); print(a,flush=True); open(sys.argv[3],'w').write(json.dumps(s.get_model()) if a else 'null'); p=s.get_proof() if not a else []; open(sys.argv[2],'w').write('\\n'.join(p)+'\\n'); s.delete()"
            try:
                run=subprocess.run([sys.executable,'-c',worker,str(ip),str(op),str(mp)],capture_output=True,text=True,timeout=min(a.per_call_seconds,max(.01,a.seconds-(time.monotonic()-start))),check=True)
                answer=run.stdout.strip()=='True'
                r={'index':q,'removed_classes':sorted(removed),'answer':answer,'call_seconds':time.monotonic()-call_start}
                if answer:
                    model=set(json.loads(mp.read_text()))
                    r['partial_matching']=[list(e[:2]) for k,e in enumerate(small,1) if k in model]
                else:
                    stem=a.output.parent/f'cover-{518-len(removed)}'
                    cnfpath=stem.with_suffix('.cnf.gz');proofpath=stem.with_suffix('.drat.gz')
                    proof=op.read_bytes();cnfpath.write_bytes(gzip.compress(raw,mtime=0));proofpath.write_bytes(gzip.compress(proof,mtime=0))
                    found={'status':'UNSAT_PROOF_CANDIDATE','source_C16_answered':False,'signature_compression':False,'retained_case_count':518-len(removed),'removed_case_tuples':sorted(removed),'retained_case_tuples':[c for c in C if c not in removed],'signature_edges_in_removed_classes':len(small),'parity_events':len(events),'variables':n,'clauses':len(clauses),'cnf_sha256':hashlib.sha256(raw).hexdigest(),'proof_sha256':hashlib.sha256(proof).hexdigest(),'proof_lines':len(proof.splitlines()),'cnf_file':cnfpath.name,'proof_file':proofpath.name,'elapsed_seconds':time.monotonic()-start}
                    stem.with_suffix('.json').write_text(json.dumps(found,indent=2)+'\n')
                    print('UNSAT candidate cover',found['retained_case_count'],flush=True)
            except subprocess.TimeoutExpired:
                r={'index':q,'removed_classes':sorted(removed),'answer':None,'call_seconds':time.monotonic()-call_start}
        records.append(r)
        print('compact candidate',q,r['answer'],r['call_seconds'],'seconds',flush=True)
        a.output.write_text(json.dumps({'status':'DISCOVERY_ONLY','source_C16_answered':False,'source_file':str(a.input),'records':records,'found':found,'elapsed_seconds':time.monotonic()-start},indent=2)+'\n')
        if found:break


if __name__=='__main__':main()
