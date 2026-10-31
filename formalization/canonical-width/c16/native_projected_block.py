#!/usr/bin/env python3
"""Bounded native-XNF test of an unrestricted-source projected matrix block."""
from pathlib import Path
import argparse
import gzip
import hashlib
import json
import subprocess
import tempfile
import time
from signature_cover import logical_data,encode
from adaptive_matrix_identities import parity

ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--block',type=Path,required=True);ap.add_argument('--solver',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=30);a=ap.parse_args();start=time.monotonic()
    A,_,_=logical_data();X,Z=[[int(s,16) for s in (ROOT/f'pools/{side}coords.txt').read_text().split()] for side in ['x','z']];b=json.loads(a.block.read_text());prior=json.loads((ROOT/'residual-identity-results/adaptive-anchor-compact.json').read_text());U=list(map(lambda s:int(s,16),b['auxiliary_U_hex']));V=list(map(lambda s:int(s,16),b['auxiliary_V_hex']));equations=[(int(e['u_hex'],16),int(e['v_hex'],16)) for e in prior['equations']]+[(u,v) for u in U for v in V]
    target=0
    for k,(u,v) in enumerate(equations):target|=(parity(u,v)^parity(X[48],v)*parity(u,Z[48]))<<k
    sx=[sum(parity(x,v)<<k for k,(u,v) in enumerate(equations)) for x in X];sz=[sum(parity(u,z)<<k for k,(u,v) in enumerate(equations)) for z in Z]
    E=[(i,j,sx[i]&sz[j],0) for i in range(720) if i!=48 and not A[i]>>48&1 for j in range(720) if j!=48 and not A[48]>>j&1 and A[i]>>j&1 and sx[i]&sz[j]]
    cnf,n,_,events=encode(A,[0],E,with_xor=False);lines=[' '.join(map(str,c))+' 0' for c in cnf]
    for k in range(len(equations)):
        vs=[v for v,s in events if s>>k&1]
        if vs:lines.append(('' if target>>k&1 else '-')+'+'.join(map(str,vs))+' 0')
        elif target>>k&1:lines.append('0')
    raw=(f'p xnf {n} {len(lines)}\n'+'\n'.join(lines)+'\n').encode();ip=a.output.with_suffix('.xnf.gz');ip.write_bytes(gzip.compress(raw,compresslevel=3,mtime=0))
    result={'source_C16_answered':False,'anchor':[48,48],'block_dimension':b['dimension'],'block_c16_path':str(a.block.resolve().relative_to(ROOT)),'baseline_equations':len(prior['equations']),'equations':len(equations),'free_edges':len(E),'variables':n,'xnf_clauses':len(lines),'input_sha256':hashlib.sha256(raw).hexdigest(),'input_file':ip.name,'solver_commit':'af93ea646a4237958e9925bc684dcd545e68de30','answer':None,'construction_seconds':time.monotonic()-start}
    with tempfile.TemporaryDirectory(prefix='c16-native-block-') as folder:
        inp=Path(folder)/'instance.xnf';proof=Path(folder)/'proof.lrup';inp.write_bytes(raw)
        command=[str(a.solver),'--compact=false','--equation-repr=sparse','--seed=0',f'--proof={proof}',str(inp)];result['command_options']=command[1:-1]
        try:
            run=subprocess.run(command,capture_output=True,text=True,timeout=a.seconds);a.output.with_suffix('.log').write_text(run.stdout+run.stderr);result['returncode']=run.returncode
            if 's SATISFIABLE' in run.stdout:
                values={}
                for line in run.stdout.splitlines():
                    if line.startswith('v '):
                        for s in line[2:].split():
                            v=int(s)
                            if v:values[abs(v)]=v>0
                pairs=[(48,48)]+[e[:2] for k,e in enumerate(E,1) if values.get(k,False)];assert len(pairs)<=128
                for q,(i,j) in enumerate(pairs):
                    assert A[i]>>j&1
                    for ii,jj in pairs[:q]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
                for u,v in equations:assert sum(parity(X[i],v)*parity(u,Z[j]) for i,j in pairs)%2==parity(u,v)
                result.update({'answer':True,'partial_matching':pairs,'partial_size':len(pairs)})
            elif 's UNSATISFIABLE' in run.stdout:
                pp=a.output.with_suffix('.lrup.gz');pp.write_bytes(gzip.compress(proof.read_bytes(),compresslevel=3,mtime=0));result.update({'answer':False,'proof_file':pp.name,'proof_sha256':hashlib.sha256(proof.read_bytes()).hexdigest(),'status':'UNSAT_CANDIDATE_REQUIRES_PHYSICAL_AND_KERNEL_REPLAY'})
        except subprocess.TimeoutExpired as err:
            out=err.stdout or b'';error=err.stderr or b'';a.output.with_suffix('.log').write_bytes((out.encode() if isinstance(out,str) else out)+(error.encode() if isinstance(error,str) else error));result['timeout']=True
            partial=list(Path(folder).glob('proof.lrup*'))
            if partial:result['incomplete_trace']={'bytes':partial[0].stat().st_size,'sha256':hashlib.sha256(partial[0].read_bytes()).hexdigest(),'retained':False,'reason':'Incomplete trace is not a proof; input and run parameters retained.'}
    result['elapsed_seconds']=time.monotonic()-start;result['scope']='All original source edges compatible with the anchor are considered before removing zero-signature edges. SAT is only a projected-equation partial witness unless128 original pairs are independently verified; UNKNOWN is no exclusion.';a.output.write_text(json.dumps(result,indent=2)+'\n');print('native block',b['dimension'],result['answer'],'partial',result.get('partial_size'),'seconds',result['elapsed_seconds'],flush=True)


if __name__=='__main__':main()
