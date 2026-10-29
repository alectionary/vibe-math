#!/usr/bin/env python3
"""Bounded common-domain anchored proof tasks; successes are safely combinable."""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor,as_completed
import argparse,hashlib,json,subprocess,sys,time,datetime,threading
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser();p.add_argument('--domain',type=Path,required=True);p.add_argument('--parent-cover',type=Path,required=True);p.add_argument('--seed-cuts',type=Path,nargs='+',required=True);p.add_argument('--library',type=Path,required=True);p.add_argument('--word-library',type=Path,required=True);p.add_argument('--select-cases',type=int,nargs='+',required=True);p.add_argument('--drat-trim',type=Path,required=True);p.add_argument('--workers',type=int,default=2);p.add_argument('--seconds',type=float,default=600);p.add_argument('--proof-seconds',type=float,default=300);p.add_argument('--output',type=Path,required=True);a=p.parse_args();start=time.monotonic();domain=json.loads(a.domain.read_text());cases=[tuple(domain['candidate_cases'][i]) for i in a.select_cases];parent=json.loads(a.parent_cover.read_text());assert parent['status']=='PASS';folder=a.output.parent;stem=a.output.stem;frozen={'status':'FROZEN_BEFORE_SOLVING','frozen_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_C16_answered':False,'domain_c16_path':str(a.domain.resolve().relative_to(ROOT)),'domain_sha256':sha(a.domain),'parent_cover_c16_path':str(a.parent_cover.resolve().relative_to(ROOT)),'parent_cover_sha256':sha(a.parent_cover),'cases':cases,'discovery_seconds_per_anchor':a.seconds,'proof_seconds_per_anchor':a.proof_seconds,'verification_seconds_per_anchor':900,'word_library_sha256':sha(a.word_library),'workers':a.workers,'seed_dependencies':[{'c16_path':str(p.resolve().relative_to(ROOT)),'sha256':sha(p)} for p in a.seed_cuts],'native_library_sha256':sha(a.library),'source_sha256':{n:sha(ROOT/n) for n in ['word_kept_anchor_domain_signature.py','verify_word_kept_anchor_domain_signature.py','verify_strategy_cover_bindings.py','fresh_strategy_proof.py','domain_forced_propagation_native.cpp','domain_forced_propagation.h']},'combination_rule':'Every accepted anchor is proved in the same common wider domain. Any subset of successful anchors can be removed together; discarded candidates remain retained. No domain clause is transferred to a wider domain without replay.'};(folder/(stem+'-frozen.json')).write_text(json.dumps(frozen,indent=2)+'\n');records=[];lock=threading.Lock()
    def task(index,case):
        output=folder/f'{stem}-case-{index:02d}.json';log=folder/f'{stem}-case-{index:02d}.log';row={'index':index,'case':case,'metadata_file':output.name,'accepted':False};command=[sys.executable,str(ROOT/'word_kept_anchor_domain_signature.py'),'--mode','restricted','--restricted-classes',str(a.domain),'--anchor',str(16*case[0]),str(16*case[1]+case[2]),'--parent-cover',str(a.parent_cover),'--seed-cuts',*map(str,a.seed_cuts),'--separator','closure','--native-library',str(a.library),'--word-library',str(a.word_library),'--signature-independent','--projection-count','--phase-profiles',str(ROOT/'algebraic-results/orbit-rank-profiles.json.gz'),'--rounds','3000','--seconds',str(a.seconds),'--output',str(output)]
        with log.open('w') as f:
            run=subprocess.run(command,stdout=f,stderr=subprocess.STDOUT,timeout=a.seconds+30);row['discovery_returncode']=run.returncode
            if not output.exists():row['status']='ERROR_BEFORE_CHECKPOINT';return row
            meta=json.loads(output.read_text());row.update(status=meta['status'],discovery_seconds=meta.get('elapsed_seconds'),records=len(meta.get('records',[])))
            if meta.get('answer') is False:
                try:
                    proof=subprocess.run([sys.executable,str(ROOT/'fresh_strategy_proof.py'),'--certificate',str(output),'--seconds',str(a.proof_seconds)],stdout=f,stderr=subprocess.STDOUT,timeout=a.proof_seconds+15);row['proof_returncode']=proof.returncode
                    if proof.returncode:return row
                    receipt=folder/f'{stem}-case-{index:02d}-independent.json';verify=subprocess.run([sys.executable,str(ROOT/'verify_word_kept_anchor_domain_signature.py'),'--certificate',str(output),'--drat-trim',str(a.drat_trim),'--output',str(receipt)],stdout=f,stderr=subprocess.STDOUT,timeout=900);row['verification_returncode']=verify.returncode
                    if verify.returncode:return row
                    d=json.loads(receipt.read_text());assert d['status']=='PASS' and d['answer'] is False and d['proof_status'].startswith('DRAT_PASS');row.update(accepted=True,status='ACCEPTED_ANCHORED_DOMAIN_UNSAT',metadata_sha256=sha(output),replay_file=receipt.name,replay_sha256=sha(receipt))
                except subprocess.TimeoutExpired:row['status']='PROOF_OR_REPLAY_WALL_LIMIT'
        return row
    with ThreadPoolExecutor(max_workers=a.workers) as pool:
        futures=[pool.submit(task,i,c) for i,c in enumerate(cases)]
        for future in as_completed(futures):
            try:r=future.result()
            except Exception as e:r={'accepted':False,'status':'TASK_ERROR','error':repr(e)}
            records.append(r);out={'status':'RUNNING','source_C16_answered':False,'frozen_file':stem+'-frozen.json','records':sorted(records,key=lambda r:r.get('index',999)),'accepted':sum(r['accepted'] for r in records),'elapsed_seconds':time.monotonic()-start};a.output.write_text(json.dumps(out,indent=2)+'\n');print('COVER BATCH',r.get('case'),r['status'],'accepted',out['accepted'],flush=True)
    out['status']='BOUNDED_BATCH_COMPLETE';a.output.write_text(json.dumps(out,indent=2)+'\n');print('COVER BATCH COMPLETE',out['accepted'],'of',len(cases),flush=True)
if __name__=='__main__':main()
