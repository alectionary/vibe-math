#!/usr/bin/env python3
"""Independently reconstruct all frozen sparse-gate compact trials."""
from pathlib import Path
import argparse,concurrent.futures,hashlib,json,subprocess,sys,time
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser();p.add_argument('--directory',type=Path,default=ROOT/'three-term-results');p.add_argument('--output-directory',type=Path,required=True);p.add_argument('--drat-trim',type=Path,required=True);p.add_argument('--workers',type=int,default=2);a=p.parse_args();assert 1<=a.workers<=3
    a.output_directory.mkdir(parents=True,exist_ok=False);start=time.monotonic();frozen=json.loads((a.directory/'matched-frozen.json').read_text())
    for path,digest in frozen['source_hashes'].items():assert sha(ROOT/path)==digest,path
    metadata=[a.directory/f'matched-order-{order}.json' for order in frozen['variants']]
    inputs=[json.loads(path.read_text()) for path in metadata]
    assert len({d['initial_input_sha256'] for d in inputs})==1
    for order,d in zip(frozen['variants'],inputs):assert d['sparse_quotient_order']==order and d['source_C16_answered'] is False and d['status']!='RUNNING'
    def replay(path):
        output=a.output_directory/(path.stem+'-independent.json');log=output.with_suffix('.log');began=time.monotonic()
        cmd=[sys.executable,str(ROOT/'verify_sparse_kept_anchor.py'),'--certificate',str(path),'--drat-trim',str(a.drat_trim),'--output',str(output)]
        with log.open('w') as stream:r=subprocess.run(cmd,cwd=ROOT,stdout=stream,stderr=subprocess.STDOUT,timeout=frozen['independent_consumer_outer_seconds_each'])
        assert r.returncode==0,str(log)
        receipt=json.loads(output.read_text());source=json.loads(path.read_text())
        assert receipt['status']=='PASS' and receipt['source_C16_answered'] is False and receipt['answer']==source['answer'] and receipt['input_sha256']==source['input_sha256']
        result={'status':'PASS','source':str(path.relative_to(ROOT)),'source_sha256':sha(path),'receipt':output.name,'receipt_sha256':sha(output),'answer':source['answer'],'discovery_status':source['status'],'input_sha256':source['input_sha256'],'proof_status':receipt['proof_status'],'physical_records_checked':receipt['SAT_partial_records_checked'],'source_cuts_checked':receipt['new_cuts_checked'],'seconds':time.monotonic()-began}
        print(json.dumps(result),flush=True);return result
    with concurrent.futures.ThreadPoolExecutor(max_workers=a.workers) as pool:results=list(pool.map(replay,metadata))
    out={'status':'PASS','source_C16_answered':False,'git_revision':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),'frozen_sha256':sha(a.directory/'matched-frozen.json'),'identical_initial_input_sha256':inputs[0]['initial_input_sha256'],'consumer_sha256':sha(ROOT/'verify_sparse_kept_anchor.py'),'sparse_consumer_sha256':sha(ROOT/'verify_sparse_quotient.py'),'drat_trim_sha256':sha(a.drat_trim),'records':results,'elapsed_seconds':time.monotonic()-start,'scope':'Independent physical source, negative-cut, partial-matching and exact final-CNF replay of each matched trial. An UNKNOWN is not a cover removal or full-anchor exclusion.'}
    (a.output_directory/'manifest.json').write_text(json.dumps(out,indent=2)+'\n');print('MATCHED REPLAY PASS',flush=True)
if __name__=='__main__':main()
