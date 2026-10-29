#!/usr/bin/env python3
"""Reconstruct a merged full input and bind its separately replayed certificates."""
from pathlib import Path
import argparse,gzip,hashlib,json,subprocess,sys,tempfile,time
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser();p.add_argument('--instance',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();start=time.monotonic();d=json.loads(a.instance.read_text());basepath=ROOT/d['base_c16_path'];assert sha(basepath)==d['base_metadata_sha256'];base=json.loads(basepath.read_text());rawbase=gzip.decompress((basepath.parent/base['input_file']).read_bytes());assert hashlib.sha256(rawbase).hexdigest()==d['base_input_sha256'];lines=rawbase.decode().splitlines();header=lines.pop(0).split();n=int(header[2]);assert int(header[3])==len(lines)
    with tempfile.TemporaryDirectory(prefix='c16-merged-base-replay-') as temp:
        op=Path(temp)/'base.json';r=subprocess.run([sys.executable,str(ROOT/'verify_binary_owner_frame_model.py'),'--instance',str(basepath),'--output',str(op)],capture_output=True,text=True,timeout=180);assert r.returncode==0,r.stderr;base_receipt=json.loads(op.read_text());assert base_receipt['status']=='PASS' and base_receipt['input_sha256']==d['base_input_sha256']
    seen=set();extra=[];counts=[]
    for dep in d['theory_dependencies']:
        log=ROOT/dep['log_c16_path'];rp=ROOT/dep['replay_c16_path'];assert sha(log)==dep['log_sha256'] and sha(rp)==dep['replay_sha256'];receipt=json.loads(rp.read_text());assert receipt['status']=='PASS' and receipt['theory_file_sha256']==dep['log_sha256'];count=0
        for line in log.open():
            row=json.loads(line);assert row['kind'] in ['basis_circuit','conditional_span','conditional_private_partner','conditional_no_short_word'];clause=row['clause'];assert all(1<=abs(v)<=1440 for v in clause);count+=1;key=tuple(sorted(clause))
            if key not in seen:seen.add(key);extra.append(clause)
        assert count==dep['certificates'];counts.append(count)
    raw=(f'p cnf {n} {len(lines)+len(extra)}\n'+'\n'.join(lines)+'\n'+''.join(' '.join(map(str,c))+' 0\n' for c in extra)).encode();assert raw==gzip.decompress((a.instance.parent/d['input_file']).read_bytes()) and hashlib.sha256(raw).hexdigest()==d['input_sha256'];assert len(extra)==d['unique_added_theory_clauses'] and n==d['variables'];out={'status':'PASS','source_C16_answered':False,'source_full_frame_size':128,'anchor':d['anchor'],'input_sha256':d['input_sha256'],'variables':n,'clauses':len(lines)+len(extra),'unique_added_theory_clauses':len(extra),'separately_replayed_theory_records':counts,'base_replay':base_receipt,'elapsed_seconds':time.monotonic()-start,'scope':'Physical full source input rebuilt; separately completed certificate receipts and all imported rows are hash-bound. Regenerate those theory receipts separately for a fresh full replay. No satisfiability conclusion.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='base_replay'},flush=True)
if __name__=='__main__':main()
