#!/usr/bin/env python3
"""Reuse independently checked universal full-basis clauses in a static full model."""
from pathlib import Path
import argparse,gzip,hashlib,json,subprocess,tempfile,time
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def export(a):
    base=json.loads(a.base.read_text());raw=gzip.decompress((a.base.parent/base['input_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==base['input_sha256'];lines=raw.decode().splitlines();header=lines.pop(0).split();n=int(header[2]);assert int(header[3])==len(lines);seen=set();extra=[];deps=[]
    assert len(a.theory_log)==len(a.theory_receipt)
    for path,rp in zip(a.theory_log,a.theory_receipt):
        receipt=json.loads(rp.read_text());assert receipt['status']=='PASS' and receipt['theory_file_sha256']==sha(path);assert receipt['input_sha256'] in [base['input_sha256'],'f624d3e939fdc7be6f227ff2beaf0be39b66944984e3e55aac980921ea350e7a'];count=0
        for line in path.open():
            row=json.loads(line);assert row['kind'] in ['basis_circuit','conditional_span','conditional_private_partner','conditional_no_short_word'];clause=row['clause'];assert all(1<=abs(v)<=1440 for v in clause);count+=1;key=tuple(sorted(clause))
            if key not in seen:seen.add(key);extra.append(clause)
        deps.append({'log_c16_path':str(path.resolve().relative_to(ROOT)),'log_sha256':sha(path),'replay_c16_path':str(rp.resolve().relative_to(ROOT)),'replay_sha256':sha(rp),'certificates':count})
    text=(f'p cnf {n} {len(lines)+len(extra)}\n'+'\n'.join(lines)+'\n'+''.join(' '.join(map(str,c))+' 0\n' for c in extra)).encode();a.output.with_suffix('.cnf.gz').write_bytes(gzip.compress(text,mtime=0));d={'status':'FROZEN_MERGED_FULL_SOURCE_ANCHOR','source_C16_answered':False,'anchor':base['anchor'],'source_full_frame_size':128,'base_c16_path':str(a.base.resolve().relative_to(ROOT)),'base_metadata_sha256':sha(a.base),'base_input_sha256':base['input_sha256'],'input_file':a.output.with_suffix('.cnf.gz').name,'input_sha256':hashlib.sha256(text).hexdigest(),'variables':n,'clauses':len(lines)+len(extra),'unique_added_theory_clauses':len(extra),'theory_dependencies':deps,'scope':'All imported clauses are universal full-basis consequences with completed independent receipts; no restricted-domain clause or deleted-pair projection clause is imported.'};a.output.write_text(json.dumps(d,indent=2)+'\n');print('MERGED FULL MODEL',n,d['clauses'],'added',len(extra),flush=True)
def solve(a):
    meta=json.loads(a.instance.read_text());raw=gzip.decompress((a.instance.parent/meta['input_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==meta['input_sha256'];start=time.monotonic();d={'status':'RUNNING','source_C16_answered':False,'answer':None,'source_full_frame_size':128,'anchor':meta['anchor'],'input_file':meta['input_file'],'input_sha256':meta['input_sha256'],'instance_c16_path':str(a.instance.resolve().relative_to(ROOT)),'instance_sha256':sha(a.instance),'solver_binary_sha256':sha(a.binary),'outer_wall_seconds':a.seconds};a.output.write_text(json.dumps(d,indent=2)+'\n');log=a.output.with_suffix('.log')
    with tempfile.TemporaryDirectory(prefix='c16-static-merged-') as temp:
        ip=Path(temp)/'input.cnf';ip.write_bytes(raw);expired=False
        with log.open('w') as f:
            try:run=subprocess.run([str(a.binary),'--time='+str(int(a.seconds)),str(ip)],stdout=f,stderr=subprocess.STDOUT,timeout=a.seconds);code=run.returncode
            except subprocess.TimeoutExpired:expired=True;code=None
    output=log.read_text();answer=True if 's SATISFIABLE' in output else False if 's UNSATISFIABLE' in output else None;d.update(answer=answer,status='SAT_FULL_FRAME_REQUIRES_PHYSICAL_REPLAY' if answer is True else 'UNSAT_REQUIRES_FRESH_PROOF_AND_SOURCE_REPLAY' if answer is False else 'UNKNOWN_OUTER_WALL_OR_SOLVER_LIMIT',returncode=code,outer_wall_expired=expired,total_wall_seconds=time.monotonic()-start,log_file=log.name,log_sha256=sha(log))
    if answer:
        model=[int(v) for line in output.splitlines() if line.startswith('v ') for v in line.split()[1:] if v!='0'];truth=set(model);rows=[list(map(int,line.split()))[:-1] for line in raw.decode().splitlines()[1:]];assert all(any(v in truth for v in c) for c in rows);X,Z,A=physical();xi=[i for i in range(720) if i+1 in truth];zj=[j for j in range(720) if j+721 in truth];assert len(xi)==len(zj)==128;pairs=[]
        for i in xi:
            partners=[j for j in zj if A[i]>>j&1];assert len(partners)==1;pairs.append([i,partners[0]])
        assert len({j for i,j in pairs})==128;assert all(bool(A[i]>>jj&1)==(k==l) for k,(i,j) in enumerate(pairs) for l,(ii,jj) in enumerate(pairs));d.update(model=model,pool_pairs=pairs)
    a.output.write_text(json.dumps(d,indent=2)+'\n');print('MERGED FULL TRIAL',d['status'],flush=True)
def main():
    p=argparse.ArgumentParser();p.add_argument('--mode',choices=['export','solve'],required=True);p.add_argument('--base',type=Path);p.add_argument('--theory-log',type=Path,nargs='*',default=[]);p.add_argument('--theory-receipt',type=Path,nargs='*',default=[]);p.add_argument('--instance',type=Path);p.add_argument('--binary',type=Path);p.add_argument('--seconds',type=float,default=900);p.add_argument('--output',type=Path,required=True);a=p.parse_args();export(a) if a.mode=='export' else solve(a)
if __name__=='__main__':main()
