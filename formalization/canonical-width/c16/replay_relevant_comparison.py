#!/usr/bin/env python3
"""Clean physical/CNF/DRAT replay of the frozen relevant-clause comparison."""
from pathlib import Path
import argparse,gzip,hashlib,json,subprocess,sys,time
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser();p.add_argument('--output-directory',type=Path,required=True);p.add_argument('--drat-trim',type=Path,required=True);a=p.parse_args();a.output_directory.mkdir(parents=True,exist_ok=False);start=time.monotonic();folder=ROOT/'relevant-results';f=json.loads((folder/'comparison-frozen.json').read_text())
    for path,digest in f['source_hashes'].items():assert sha(ROOT/path)==digest,path
    initial={name:gzip.decompress((folder/d['file']).read_bytes()) for name,d in f['initial_inputs'].items()}
    for name,raw in initial.items():assert hashlib.sha256(raw).hexdigest()==f['initial_inputs'][name]['sha256']
    baseline=initial['baseline'].decode().splitlines();seeded=initial['seeded'].decode().splitlines();assert seeded[1:len(baseline)]==baseline[1:];assert len(seeded)-len(baseline)==f['additional_initial_clauses'];assert all(all(int(v)<0 for v in line.split()[:-1]) for line in seeded[len(baseline):])
    records=[]
    for name in ['seeded','baseline']:
        source=folder/f'{name}.json';d=json.loads(source.read_text());assert d['initial_input_sha256']==f['initial_inputs'][name]['sha256'];raw=gzip.decompress((folder/d['input_file']).read_bytes());lines=raw.decode().splitlines();prefix=initial[name].decode().splitlines();assert lines[1:len(prefix)]==prefix[1:];assert hashlib.sha256(raw).hexdigest()==d['input_sha256']
        output=a.output_directory/f'{name}-independent.json';log=output.with_suffix('.log');began=time.monotonic();cmd=[sys.executable,str(ROOT/'verify_sparse_kept_anchor.py'),'--certificate',str(source),'--output',str(output),'--drat-trim',str(a.drat_trim)]
        with log.open('w') as stream:r=subprocess.run(cmd,cwd=ROOT,stdout=stream,stderr=subprocess.STDOUT,timeout=f['independent_replay_outer_seconds_each'])
        assert r.returncode==0,str(log);receipt=json.loads(output.read_text());assert receipt['status']=='PASS' and receipt['answer']==d['answer'] and receipt['input_sha256']==d['input_sha256']
        if d['answer'] is False:assert receipt['proof_status'].startswith('DRAT_PASS') and receipt['proof_sha256']==d['fresh_proof']['proof_sha256']
        record={'status':'PASS','variant':name,'source':str(source.relative_to(ROOT)),'source_sha256':sha(source),'receipt':output.name,'receipt_sha256':sha(output),'answer':d['answer'],'input_sha256':d['input_sha256'],'proof_sha256':receipt['proof_sha256'],'proof_status':receipt['proof_status'],'source_cuts_checked':receipt['new_cuts_checked'],'partial_records_checked':receipt['SAT_partial_records_checked'],'seconds':time.monotonic()-began};records.append(record);print(json.dumps(record),flush=True)
    out={'status':'PASS','source_C16_answered':False,'git_revision':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),'frozen_sha256':sha(folder/'comparison-frozen.json'),'consumer_sha256':sha(ROOT/'verify_sparse_kept_anchor.py'),'sparse_consumer_sha256':sha(ROOT/'verify_sparse_quotient.py'),'initial_prefixes_checked':True,'drat_trim_sha256':sha(a.drat_trim),'records':records,'elapsed_seconds':time.monotonic()-start,'scope':'Independent physical source/cut, exact initial-and-final CNF, and ordinary DRAT replay of both comparison outcomes. Any cover change additionally requires the separate domain-inclusion induction. No full source anchor is excluded.'};(a.output_directory/'manifest.json').write_text(json.dumps(out,indent=2)+'\n');print('RELEVANT COMPARISON REPLAY PASS',flush=True)
if __name__=='__main__':main()
