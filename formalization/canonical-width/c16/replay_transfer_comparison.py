#!/usr/bin/env python3
"""Replay every held-out outcome, including UNKNOWN, from physical sources."""
from pathlib import Path
import argparse, gzip, hashlib, json, subprocess, sys, time
ROOT=Path(__file__).resolve().parent
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output-directory',type=Path,required=True)
    ap.add_argument('--drat-trim',type=Path,required=True); a=ap.parse_args()
    a.output_directory.mkdir(parents=True,exist_ok=False); start=time.monotonic();folder=ROOT/'transfer-results'
    frozen=folder/'comparison-frozen.json';f=json.loads(frozen.read_text());runs=json.loads((folder/'comparison-runs.json').read_text())
    assert runs['status']=='COMPLETE' and runs['frozen_sha256']==sha(frozen)
    for p,h in f['source_hashes'].items():assert sha(ROOT/p)==h,p
    amendment=json.loads((folder/'measurement-amendment.json').read_text())
    assert runs['measurement_amendment_sha256']==sha(folder/'measurement-amendment.json')
    assert amendment['frozen_sha256']==sha(frozen)
    for p,h in amendment['repair_source_hashes'].items():assert sha(ROOT/p)==h,p
    original=json.loads((folder/'case-00-baseline.json').read_text());original.pop('fresh_proof',None)
    assert hashlib.sha256((json.dumps(original,indent=2)+'\n').encode()).hexdigest()==amendment['retained_first_metadata_sha256']
    assert sha(folder/'case-00-baseline.log')==amendment['retained_first_log_sha256']
    for case in f['initial_inputs']:
        raw={v:gzip.decompress((folder/d['file']).read_bytes()) for v,d in case['inputs'].items()}
        for v,b in raw.items():assert hashlib.sha256(b).hexdigest()==case['inputs'][v]['sha256']
        baseline=raw['baseline'].decode().splitlines();seeded=raw['seeded'].decode().splitlines()
        assert seeded[1:len(baseline)]==baseline[1:] and len(seeded)-len(baseline)==case['added_clauses']
        assert all(all(int(v)<0 for v in line.split()[:-1]) for line in seeded[len(baseline):])
    records=[]
    for t in f['trials']:
        source=folder/(t['name']+'.json');d=json.loads(source.read_text());prefix=f['initial_inputs'][t['case_index']]['inputs'][t['variant']]
        assert d['initial_input_sha256']==prefix['sha256']
        raw=gzip.decompress((folder/d['input_file']).read_bytes());lines=raw.decode().splitlines()
        first=gzip.decompress((folder/prefix['file']).read_bytes()).decode().splitlines()
        assert lines[1:len(first)]==first[1:] and hashlib.sha256(raw).hexdigest()==d['input_sha256']
        output=a.output_directory/(t['name']+'-independent.json');log=output.with_suffix('.log');began=time.monotonic()
        cmd=[sys.executable,str(ROOT/'verify_transfer_case.py'),'--certificate',str(source),'--output',str(output),'--drat-trim',str(a.drat_trim)]
        print('REPLAY START',t['name'],flush=True)
        with log.open('w') as stream:r=subprocess.run(cmd,cwd=ROOT,stdout=stream,stderr=subprocess.STDOUT,timeout=900)
        assert r.returncode==0,str(log);receipt=json.loads(output.read_text())
        assert receipt['status']=='PASS' and receipt['answer']==d['answer'] and receipt['input_sha256']==d['input_sha256']
        if d['answer'] is False:assert receipt['proof_status'].startswith('DRAT_PASS') and receipt['proof_sha256']==d['fresh_proof']['proof_sha256']
        row={'name':t['name'],'source_sha256':sha(source),'receipt':output.name,'receipt_sha256':sha(output),
             'answer':d['answer'],'proof_status':receipt['proof_status'],'input_sha256':d['input_sha256'],
             'source_cuts_checked':receipt['new_cuts_checked'],'partial_records_checked':receipt['SAT_partial_records_checked'],
             'elapsed_seconds':time.monotonic()-began}
        records.append(row);print('REPLAY END',json.dumps(row),flush=True)
    result={'status':'PASS','git_revision':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),
            'source_C16_answered':False,'frozen_sha256':sha(frozen),'initial_prefixes_checked':True,
            'consumer_sha256':sha(ROOT/'verify_transfer_case.py'),'drat_trim_sha256':sha(a.drat_trim),
            'records':records,'elapsed_seconds':time.monotonic()-start,
            'scope':'Independent physical source/cut and exact initial/final CNF replay for all six calls; physical partial model replay for SAT and ordinary DRAT for UNSAT. UNKNOWN remains unresolved. Cover induction is separate.'}
    (a.output_directory/'manifest.json').write_text(json.dumps(result,indent=2)+'\n');print('TRANSFER REPLAY PASS',flush=True)
if __name__=='__main__':main()
