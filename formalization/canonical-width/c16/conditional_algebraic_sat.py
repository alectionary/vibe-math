#!/usr/bin/env python3
"""Proof-producing CNF comparison for a bounded conditional parity domain."""
from pathlib import Path
import argparse,gzip,hashlib,json,time
from algebraic_domain import make_domain
from signature_cover import encode
from anchored_cover_chain import parity_chains
from exchange_anchored_cover import signature_amo

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--kind',choices=['hard','control'],required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--solver',default='cadical195');ap.add_argument('--amo',action='store_true');a=ap.parse_args();start=time.monotonic();A,E,t,eq,anchor,R=make_domain(a.kind);E=[(*e,0) for e in E];clauses,n,_,events=encode(A,[0],E,with_xor=False);n=parity_chains(clauses,n,events,t)
 if a.amo:n=signature_amo(clauses,n,E)
 raw=(f'p cnf {n} {len(clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in clauses)).encode();cp=a.output.with_suffix('.cnf.gz');cp.write_bytes(gzip.compress(raw,mtime=0));print('ENCODED',len(E),n,len(clauses),flush=True)
 from pysat.solvers import Solver
 s=Solver(name=a.solver,bootstrap_with=clauses,with_proof=True);ans=s.solve();d={'status':'DISCOVERY','answer':ans,'source_C16_answered':False,'kind':a.kind,'anchor':anchor,'trial_removed':sorted(R),'free_target_signature':t,'free_edge_count':len(E),'signature_compression':False,'one_per_signature':a.amo,'variables':n,'clauses':len(clauses),'cnf_file':cp.name,'cnf_sha256':hashlib.sha256(raw).hexdigest(),'solver':a.solver}
 if not ans:
  proof=('\n'.join(s.get_proof())+'\n').encode();pp=a.output.with_suffix('.drat.gz');pp.write_bytes(gzip.compress(proof,mtime=0));d.update(status='UNSAT_PROOF_CANDIDATE',proof_file=pp.name,proof_sha256=hashlib.sha256(proof).hexdigest(),proof_lines=len(proof.splitlines()))
 else:d['partial_matching']=[e[:2] for k,e in enumerate(E,1) if k in set(s.get_model())]
 s.delete();d['elapsed_seconds']=time.monotonic()-start;a.output.write_text(json.dumps(d,indent=2)+'\n');print(d['status'],ans,flush=True)
if __name__=='__main__':main()
