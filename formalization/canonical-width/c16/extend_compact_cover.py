#!/usr/bin/env python3
"""Monotone compact cover proof extension after a frozen greedy screen.

Prior SAT witnesses survive enlarging the removed set, so retry only UNKNOWN
classes. A compact, uncompressed CNF and CaDiCaL DRAT proof are generated for
each UNSAT improvement. Only the strongest proof is retained by this driver.
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


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--prior',type=Path,required=True);ap.add_argument('--screen',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=600);ap.add_argument('--call-seconds',type=float,default=20);ap.add_argument('--drat-trim',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    A,C,E=logical_data();d=json.loads(a.prior.read_text());removed=set(map(tuple,d['removed_case_tuples']));screen=json.loads(a.screen.read_text());todo=[tuple(r['case']) for r in screen['trials'] if r['answer'] is None and tuple(r['case']) not in removed];records=[]
    for candidate in todo:
        if time.monotonic()-start>a.seconds:break
        trial=removed|{candidate};small=[e for e in E if C[e[3]] in trial];clauses,n,S,events=encode(A,C,small)
        clauses.extend([[v if c in trial else -v] for c,v in zip(C,S)])
        raw=(f'p cnf {n} {len(clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in clauses)).encode();call_start=time.monotonic()
        r={'case':candidate,'removed_count_before':len(removed),'trial_removed_classes':sorted(trial)}
        with tempfile.TemporaryDirectory(prefix='c16-monotone-cover-') as folder:
            ip=Path(folder)/'input.cnf';pp=Path(folder)/'proof.drat';mp=Path(folder)/'model.json';ip.write_bytes(raw)
            worker="from pysat.solvers import Solver; from pysat.formula import CNF; import sys,json; s=Solver(name='cadical195',bootstrap_with=CNF(from_file=sys.argv[1]).clauses,with_proof=True); a=s.solve(); print(a,flush=True); open(sys.argv[3],'w').write(json.dumps(s.get_model()) if a else 'null'); p=s.get_proof() if not a else []; open(sys.argv[2],'w').write('\\n'.join(p)+'\\n'); s.delete()"
            try:
                run=subprocess.run([sys.executable,'-c',worker,str(ip),str(pp),str(mp)],capture_output=True,text=True,check=True,timeout=min(a.call_seconds,max(.01,a.seconds-(time.monotonic()-start))))
                answer=run.stdout.strip()=='True';r['answer']=answer
                if answer:
                    model=set(json.loads(mp.read_text()));r['partial_matching']=[list(e[:2]) for k,e in enumerate(small,1) if k in model]
                else:
                    check=subprocess.run([str(a.drat_trim),str(ip),str(pp)],capture_output=True,text=True,check=True,timeout=30)
                    assert 's VERIFIED' in check.stdout
                    proof=pp.read_bytes();stem=a.output.parent/'cover-best';cnfpath=stem.with_suffix('.cnf.gz');proofpath=stem.with_suffix('.drat.gz')
                    cnfpath.write_bytes(gzip.compress(raw,mtime=0));proofpath.write_bytes(gzip.compress(proof,mtime=0))
                    cert={'status':'UNSAT_PROOF_CANDIDATE','source_C16_answered':False,'signature_compression':False,'retained_case_count':518-len(trial),'removed_case_tuples':sorted(trial),'retained_case_tuples':[c for c in C if c not in trial],'signature_edges_in_removed_classes':len(small),'parity_events':len(events),'variables':n,'clauses':len(clauses),'cnf_sha256':hashlib.sha256(raw).hexdigest(),'proof_sha256':hashlib.sha256(proof).hexdigest(),'proof_lines':len(proof.splitlines()),'cnf_file':cnfpath.name,'proof_file':proofpath.name,'elapsed_seconds':time.monotonic()-start}
                    stem.with_suffix('.json').write_text(json.dumps(cert,indent=2)+'\n');removed=trial;r['discovery_DRAT_check']='PASS';r['proof_sha256']=cert['proof_sha256']
                    print('checked compact UNSAT; candidate cover',518-len(removed),flush=True)
            except subprocess.TimeoutExpired:
                r['answer']=None
        r['call_seconds']=time.monotonic()-call_start;records.append(r)
        result={'status':'DISCOVERY_ONLY','source_C16_answered':False,'prior':str(a.prior),'screen':str(a.screen),'retained_case_count':518-len(removed),'removed_case_tuples':sorted(removed),'retained_case_tuples':[c for c in C if c not in removed],'records':records,'elapsed_seconds':time.monotonic()-start,'scope':'Only UNKNOWN classes retried; prior SAT witnesses remain valid by monotonicity. Strongest proof saved as cover-best; physical independent CNF regeneration still required.'}
        a.output.write_text(json.dumps(result,indent=2)+'\n');print('class',candidate,r['answer'],'elapsed',time.monotonic()-start,flush=True)


if __name__=='__main__':main()
