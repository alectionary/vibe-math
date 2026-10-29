#!/usr/bin/env python3
"""Replay old domain clauses under a changed allowed graph; retain only survivors."""
from pathlib import Path
import argparse,json,hashlib,time
from signature_cover import logical_data
from verify_algebraic_model import physical
from verify_domain_closure import DomainClosureConsumer
from native_domain_forced_propagation import NativeDomainForcedPropagation
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser();p.add_argument('--domain',type=Path,required=True);p.add_argument('--cuts',type=Path,nargs='+',required=True);p.add_argument('--library',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();start=time.monotonic();X,Z,A=physical();AA,C,E=logical_data();assert A==AA;R=set(map(tuple,json.loads(a.domain.read_text())['classes']));allowed=A.copy()
    for i,j,s,k in E:
        if C[k] not in R:allowed[i]&=~(1<<j)
    columns=[sum(((A[i]>>j)&1)<<i for i in range(720)) for j in range(720)];opposite=[sum(((allowed[i]>>j)&1)<<i for i in range(720)) for j in range(720)];native=[NativeDomainForcedPropagation(X,Z,allowed,a.library),NativeDomainForcedPropagation(Z,X,opposite,a.library)];consumer=[DomainClosureConsumer(X,Z,A,allowed),DomainClosureConsumer(Z,X,columns,opposite)];kept=[];records=[];seen=set()
    for path in a.cuts:
        d=json.loads(path.read_text())
        for index,c in enumerate(d['cuts']):
            if c['kind'] not in ['domain_forced_propagation','joint_domain_forced_propagation']:continue
            key=(c['kind'],c.get('sector'),tuple(c.get('indices',[])),tuple(c.get('required_X',[])),tuple(c.get('required_Z',[])))
            if key in seen:continue
            seen.add(key)
            if c['kind']=='domain_forced_propagation':
                side=c['sector'];reject=native[side].exclusion(sum(1<<i for i in c['indices'])) is not None
                if reject:assert not consumer[side].replay(c['indices'])['possible']
            else:reject=not consumer[0].replay(c['required_X'],c['required_Z'])['possible']
            records.append({'source_file':path.name,'source_cut_index':index,'retained':reject})
            if reject:kept.append(c)
    for n in native:n.close()
    out={'status':'PASS_RESCOPED_BY_INDEPENDENT_DOMAIN_REPLAY','source_C16_answered':False,'cuts':kept,'restricted_classes_c16_path':str(a.domain.resolve().relative_to(ROOT)),'restricted_classes_sha256':sha(a.domain),'domain_allowed_rows_sha256':hashlib.sha256(('\n'.join(hex(row) for row in allowed)+'\n').encode()).hexdigest(),'domain_nogoods_are_universal_source_cuts':False,'source_dependencies':[{'c16_path':str(p.resolve().relative_to(ROOT)),'sha256':sha(p)} for p in a.cuts],'unique_old_cuts_checked':len(records),'retained':len(kept),'not_retained':len(records)-len(kept),'physical_coloop_covectors_checked':sum(c.forced_covectors_checked for c in consumer),'records':records,'elapsed_seconds':time.monotonic()-start,'scope':'Only contradictions independently reproduced under the destination domain are retained. Old validity alone does not permit transfer to a wider domain.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print('DOMAIN RESCOPE',len(records),len(kept),out['elapsed_seconds'],flush=True)
if __name__=='__main__':main()
