#!/usr/bin/env python3
"""Append the unchanged source bank to the previously checked full anchor input."""
from pathlib import Path
import argparse,datetime,gzip,hashlib,json,time
from verify_algebraic_model import physical
from verify_sparse_quotient import SparseQuotientConsumer
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def rebuild():
    basepath=ROOT/'strategy-results/merged-full-instance.json';base=json.loads(basepath.read_text())
    assert base['anchor']==[48,48] and base['source_full_frame_size']==128
    raw=gzip.decompress((basepath.parent/base['input_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==base['input_sha256']
    lines=raw.decode().splitlines();header=lines.pop(0).split();n=int(header[2]);assert int(header[3])==len(lines)
    X,Z,A=physical(); assert A==[sum(((A[i]>>j)&1)<<i for i in range(720)) for j in range(720)]
    shift=lambda i:16*(i//16)+(i+1)%16
    for i in range(720):
        assert sum(1<<shift(j) for j in range(720) if A[i]>>j&1)==A[shift(i)]
    seedpath=ROOT/'relevant-results/comparison-seed-cuts.json';seeds=json.loads(seedpath.read_text())['cuts'];assert len(seeds)==256
    seen={tuple(sorted(map(int,line.split()[:-1]))) for line in lines};added=set();consumer=SparseQuotientConsumer(X,Z)
    for cut in seeds:
        assert cut['kind']=='universal_sparse_quotient';row=cut['certificate'];clause=consumer.check(row)
        assert cut['sector']==1-row['side'] and cut['indices']==row['mandatory_opposite']
        assert clause==[-i-1-720*cut['sector'] for i in cut['indices']]
        for h in range(16):
            ids=[16*(i//16)+(i%16+h)%16 for i in cut['indices']]
            for side in (0,1):added.add(tuple(sorted(-i-1-720*side for i in ids)))
    extra=sorted(added-seen);final=(f'p cnf {n} {len(lines)+len(extra)}\n'+'\n'.join(lines)+'\n'+''.join(' '.join(map(str,c))+' 0\n' for c in extra)).encode()
    return final,base,{'variables':n,'clauses':len(lines)+len(extra),'new_unique_clauses':len(extra),'new_source_certificates_checked':len(seeds),
        'base_c16_path':str(basepath.relative_to(ROOT)),'base_metadata_sha256':sha(basepath),'base_input_sha256':base['input_sha256'],
        'seed_c16_path':str(seedpath.relative_to(ROOT)),'seed_sha256':sha(seedpath),'symmetry_checked_from_physical_Gram':True}
def main():
    p=argparse.ArgumentParser();p.add_argument('--mode',choices=['export','verify'],required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();start=time.monotonic()
    folder=ROOT/'transfer-results';f=json.loads((folder/'comparison-frozen.json').read_text());r=json.loads((folder/'comparison-runs.json').read_text())
    assert r['status']=='COMPLETE' and r['frozen_sha256']==sha(folder/'comparison-frozen.json')
    benefits=[]
    for k in range(3):
        pair={row['variant']:row for row in r['results'] if row['case_index']==k}
        if pair['seeded']['answer'] is False and (pair['baseline']['answer'] is None or pair['baseline']['answer'] is False and pair['seeded']['elapsed_seconds']<pair['baseline']['elapsed_seconds']):benefits.append(k)
    assert len(benefits)>=2,'Frozen transfer gate did not pass; use structural fallback'
    assert f['full_completion_anchor_preselected']==[48,48]
    raw,base,info=rebuild();digest=hashlib.sha256(raw).hexdigest()
    canonical=folder/'full-anchor-instance.json';cp=folder/'full-anchor-instance.cnf.gz'
    if a.mode=='export':
        assert a.output==canonical and not canonical.exists();cp.write_bytes(gzip.compress(raw,mtime=0))
        result={'status':'FROZEN_FULL_SOURCE_ANCHOR_WITH_TRANSFER_BANK','source_C16_answered':False,'source_full_frame_size':128,
                'anchor':[48,48],'input_file':cp.name,'input_sha256':digest,**info,'frozen_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
                'comparison_runs_sha256':sha(folder/'comparison-runs.json'),'provisional_transfer_benefit_cases':benefits,
                'base_clean_replay_c16_path':'strategy-results/clean-model-replay/merged.json',
                'base_clean_replay_sha256':sha(ROOT/'strategy-results/clean-model-replay/merged.json'),
                'source_hashes':{p:sha(ROOT/p) for p in ['transfer_full_anchor.py','merged_full_anchor.py','verify_sparse_quotient.py']},
                'elapsed_seconds':time.monotonic()-start,'scope':'Exact full source anchor48/48. Existing merged full model plus only the unchanged256 universal source patterns. No restricted pair domain or signature projection. Historical base source/theory replays inherited; fresh replay of new clauses and exact augmentation.'}
    else:
        meta=json.loads(canonical.read_text());assert raw==gzip.decompress(cp.read_bytes()) and digest==meta['input_sha256']
        assert meta['comparison_runs_sha256']==sha(folder/'comparison-runs.json')
        for key,value in info.items():assert meta[key]==value,key
        for path,h in meta['source_hashes'].items():assert sha(ROOT/path)==h,path
        rp=ROOT/meta['base_clean_replay_c16_path'];assert sha(rp)==meta['base_clean_replay_sha256'];receipt=json.loads(rp.read_text())
        assert receipt['status']=='PASS' and receipt['input_sha256']==base['input_sha256'] and receipt['anchor']==[48,48]
        result={'status':'PASS','source_C16_answered':False,'input_sha256':digest,**info,'elapsed_seconds':time.monotonic()-start,
                'scope':'New source clauses and physical cyclic/sector symmetry checked independently of discovery; exact augmentation reconstructed. Immutable earlier full-source/theory replay receipt inherited. No satisfiability conclusion.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2),flush=True)
if __name__=='__main__':main()
