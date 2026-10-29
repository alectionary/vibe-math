#!/usr/bin/env python3
"""Exercise new sparse-certificate CNF wiring without running a fourth SAT trial."""
from pathlib import Path
import argparse,gzip,hashlib,json
from sparse_kept_anchor_domain_signature import setup,expand,dump_input,ROOT
from verify_algebraic_model import physical
from verify_sparse_quotient import SparseQuotientConsumer

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser();p.add_argument('--base',type=Path,required=True);p.add_argument('--gate',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    d=json.loads(a.base.read_text());assert d['answer'] is None;gate=json.loads(a.gate.read_text())
    A,C,E,anchor,R,target,base,n,owners,events=setup(d['mode'],d['signature_independent'],ROOT/d['phase_profiles_c16_path'],True,ROOT/d['restricted_classes_c16_path'],d['anchor'])
    raw=gzip.decompress((a.base.parent/d['input_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==d['input_sha256']
    lines=raw.decode().splitlines();assert lines[0]==f"p cnf {n} {d['clauses']}"
    rows=[list(map(int,line.split()))[:-1] for line in lines[1:]];seen={tuple(sorted(c)) for c in rows};before=len(rows)
    X,Z,AA=physical();assert A==AA;consumer=SparseQuotientConsumer(X,Z)
    for row in gate['new_certificates']:
        consumer.check(row);cut={'kind':'universal_sparse_quotient','sector':1-row['side'],'indices':row['mandatory_opposite'],'certificate':row};d['cuts'].append(cut)
        for clause in sorted(expand(cut,owners,anchor)-seen):rows.append(list(clause));seen.add(clause)
    assert len(rows)>before,'Control must emit at least one new clause to exercise wiring.'
    d.update(status='INTEGRATION_CONTROL_NO_SOLVER_CALL',answer=None,integration_control_only=True,integration_base_sha256=sha(a.base),integration_gate_sha256=sha(a.gate),integration_sparse_certificates=len(gate['new_certificates']),integration_added_clauses=len(rows)-before,clauses=len(rows),input_file=a.output.with_suffix('.cnf.gz').name)
    d['input_sha256']=dump_input(a.output.with_suffix('.cnf.gz'),n,rows);a.output.write_text(json.dumps(d,indent=2)+'\n')
    print({'status':d['status'],'certificates':d['integration_sparse_certificates'],'new_clauses':d['integration_added_clauses'],'final_clauses':d['clauses']},flush=True)
if __name__=='__main__':main()
