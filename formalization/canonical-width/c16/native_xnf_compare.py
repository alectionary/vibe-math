#!/usr/bin/env python3
"""Bounded native-parity solver comparison on one exact anchored domain."""
from pathlib import Path
import argparse
import hashlib
import json
import subprocess
import time
from signature_cover import logical_data,encode
from check_native_parity_proof import check

ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--domain',type=Path,required=True);ap.add_argument('--solver',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=30);a=ap.parse_args();start=time.monotonic();a.output.parent.mkdir(parents=True,exist_ok=True)
    A,C,E=logical_data();d=json.loads(a.domain.read_text());R=set(map(tuple,d.get('trial_removed',d.get('removed_after'))));x,z=d['anchor'];target=d['free_target_signature'];small=[(i,j,s,0) for i,j,s,c in E if C[c] in R and (i,j)!=(x,z) and i!=x and j!=z and not A[i]>>z&1 and not A[x]>>j&1]
    clauses,n,_,events=encode(A,[0],small,with_xor=False,compress_signatures=True);lines=[' '.join(map(str,c))+' 0' for c in clauses]
    for t in range(16):
        variables=[v for v,s in events if s>>t&1]
        if variables:lines.append(('' if target>>t&1 else '-')+'+'.join(map(str,variables))+' 0')
        elif target>>t&1:lines.append('0')
    raw=f'p xnf {n} {len(lines)}\n'+'\n'.join(lines)+'\n';ip=a.output.with_suffix('.xnf');pp=a.output.with_suffix('.lrup');lp=a.output.with_suffix('.log');ip.write_text(raw)
    command=[str(a.solver),'--compact=false','--equation-repr=sparse','--seed=0',f'--proof={pp}',str(ip)];result={'source_C16_answered':False,'solver_commit':'af93ea646a4237958e9925bc684dcd545e68de30','gf2_commit':'0b09e44fd2c6615a6a1958c480650e207703b84c','domain_c16_path':str(a.domain.resolve().relative_to(ROOT)),'anchor':[x,z],'removed_classes':sorted(R),'free_target_signature':target,'free_edges':len(small),'variables':n,'xnf_clauses':len(lines),'input_sha256':hashlib.sha256(raw.encode()).hexdigest(),'signature_compression':True,'command':command,'answer':None}
    try:
        run=subprocess.run(command,capture_output=True,text=True,timeout=a.seconds);lp.write_text(run.stdout+run.stderr);result['returncode']=run.returncode
        if 's UNSATISFIABLE' in run.stdout:
            result['answer']=False;result['independent_parity_kernel']=check(raw,pp.read_text());result['proof_sha256']=hashlib.sha256(pp.read_bytes()).hexdigest()
        elif 's SATISFIABLE' in run.stdout:
            result['answer']=True;values={}
            for line in run.stdout.splitlines():
                if line.startswith('v '):
                    for token in line[2:].split():
                        k=int(token)
                        if k:values[abs(k)]=k>0
            reps={}
            for k,e in enumerate(small,1):
                assert k in values
                if values[k]:reps.setdefault(e[2],e[:2])
            pairs=[(x,z)]+list(reps.values());value=0
            for i,j in pairs:
                value^=next(e[2] for e in E if e[:2]==(i,j))
            assert value==65535
            for k,(i,j) in enumerate(pairs):
                for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
            result['partial_matching']=pairs
    except subprocess.TimeoutExpired as err:
        output=err.stdout or b'';error=err.stderr or b''
        lp.write_bytes((output.encode() if isinstance(output,str) else output)+(error.encode() if isinstance(error,str) else error));result['timeout']=True
    result['elapsed_seconds']=time.monotonic()-start;a.output.write_text(json.dumps(result,indent=2)+'\n');print('native XNF',result['answer'],'seconds',result['elapsed_seconds'],'kernel',result.get('independent_parity_kernel',{}).get('status'),flush=True)


if __name__=='__main__':main()
