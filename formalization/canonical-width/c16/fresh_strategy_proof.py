#!/usr/bin/env python3
"""Ordinary proof regeneration on an exact saved CNF, with a hard outer limit."""
from pathlib import Path
import argparse,gzip,hashlib,json,subprocess,sys,tempfile,time
def main():
    p=argparse.ArgumentParser();p.add_argument('--certificate',type=Path,required=True);p.add_argument('--seconds',type=float,default=600);p.add_argument('--child',action='store_true');p.add_argument('--input',type=Path);p.add_argument('--answer',type=Path);p.add_argument('--proof',type=Path);a=p.parse_args()
    if a.child:
        from pysat.formula import CNF
        from pysat.solvers import Solver
        with Solver(name='cadical195',bootstrap_with=CNF(from_file=str(a.input)).clauses,with_proof=True) as solver:
            answer=solver.solve();a.answer.write_text(json.dumps({'answer':answer,'statistics':solver.accum_stats()})+'\n')
            if not answer:a.proof.write_text('\n'.join(solver.get_proof())+'\n')
        return
    start=time.monotonic();data=json.loads(a.certificate.read_text());assert data['answer'] is False;ip=a.certificate.parent/data['input_file'];raw=gzip.decompress(ip.read_bytes());assert hashlib.sha256(raw).hexdigest()==data['input_sha256']
    with tempfile.TemporaryDirectory(prefix='c16-fresh-strategy-proof-') as temp:
        folder=Path(temp);cnf=folder/'input.cnf';cnf.write_bytes(raw);op=folder/'answer.json';proof=folder/'proof.drat';command=[sys.executable,str(Path(__file__).resolve()),'--certificate',str(a.certificate),'--child','--input',str(cnf),'--answer',str(op),'--proof',str(proof)]
        run=subprocess.run(command,timeout=a.seconds,capture_output=True,text=True);assert run.returncode==0,run.stderr;answer=json.loads(op.read_text());assert answer['answer'] is False;proofbytes=proof.read_bytes();out=a.certificate.with_suffix('.drat.gz');out.write_bytes(gzip.compress(proofbytes,mtime=0));data['fresh_proof']={'solver':'pysat/cadical195 ordinary static CNF','input_sha256':data['input_sha256'],'proof_file':out.name,'proof_sha256':hashlib.sha256(proofbytes).hexdigest(),'proof_bytes':len(proofbytes),'elapsed_seconds':time.monotonic()-start,'statistics':answer['statistics']};a.certificate.write_text(json.dumps(data,indent=2)+'\n');print('FRESH STRATEGY PROOF',data['fresh_proof'],flush=True)
if __name__=='__main__':main()
