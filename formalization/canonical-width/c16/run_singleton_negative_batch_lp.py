#!/usr/bin/env python3
"""Exactly one enlarged archive LP, followed by at most one exact pricing query."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):os.environ[k]='1'
os.environ['PYTHONDONTWRITEBYTECODE']='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,json,time
from singleton_exact_column_gate import read,write,sha,run,accept_cut,ROOT
from verify_algebraic_model import physical
from verify_full_partner_projection import point_data

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--batch',type=Path,required=True);ap.add_argument('--receipt',type=Path,required=True);ap.add_argument('--prefix',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    batch=read(a.batch);receipt=read(a.receipt)
    assert receipt['status']=='PASS_EXACT_NEGATIVE_PHYSICAL_EXCHANGE_BATCH' and receipt['bank_sha256']==sha(a.batch)
    assert receipt['consumer_sha256']==sha(ROOT/'verify_singleton_negative_exchange_batch.py') and receipt['selected_columns_checked']==64
    assert all(sha(ROOT/p)==h for p,h in batch['source_hashes'].items())
    priced=read(batch['pricing']);manifest=read(priced['manifest']);s=read(manifest['semantic'])
    assert sha(batch['pricing'])==batch['pricing_sha256'] and sha(manifest['semantic'])==manifest['semantic_sha256']
    B=[list(b) for b in s['physical_bases']];assert len(B)==3160 and batch['prior_discovered_count']==3161
    B.append(priced['minimizing_physical_basis']);B.extend(record['indices'] for record in batch['columns'])
    assert len(B)==len(set(map(tuple,B)))==3225
    old_columns=read(s['column_bank']);origins=list(old_columns['column_origins'])
    origins.append(dict(kind='prior_final_unsolved_minimizer',pricing=batch['pricing'],pricing_sha256=batch['pricing_sha256']))
    origins.extend(dict(kind='negative_exchange_batch',bank=str(a.batch),bank_sha256=sha(a.batch),index=i) for i in range(64))
    assert len(origins)==len(B)
    sources=dict(batch['source_hashes'])
    paths=[a.batch,a.receipt,Path(__file__),ROOT/'singleton_exact_column_gate.py',ROOT/'run_singleton_archive_cg_soplex_generic.py',ROOT/'export_singleton_archive_cg.py',ROOT/'verify_singleton_archive_cg.py',ROOT/'price_singleton_archive_cg.py',ROOT/'verify_singleton_exact_pricing.py']
    sources.update({str(p.resolve().relative_to(ROOT)):sha(p) for p in paths})
    stem=str(a.prefix);fp=stem+'.frozen.json'
    write(fp,dict(status='FROZEN_ONE_NEGATIVE_EXCHANGE_BATCH_LP',source_hashes=sources,point_sha256=s['point_sha256'],anchor_orbit=15,
                  last_solved_columns=3160,prior_discovered_columns=3161,new_exchange_columns=64,lp_columns=3225,
                  maximum_lp_calls=1,maximum_post_lp_pricing_calls=1,solver_internal_seconds=60,solver_external_seconds=90,
                  maximum_solver_rss_bytes=2*1024**3,nice=19,threads=1,no_automatic_extension=True))
    column_bank=stem+'-columns.json.gz'
    write(column_bank,dict(status='FROZEN_SINGLETON_COLUMN_ARCHIVE',initial_endpoint_sha256=s['endpoint_sha256'],initial_receipt_sha256=s['endpoint_receipt_sha256'],physical_bases=B,column_origins=origins,gate_frozen=fp,gate_frozen_sha256=sha(fp)))
    stages=[]
    stages.append(run(['export_singleton_archive_cg.py','--endpoint',s['endpoint'],'--receipt',s['endpoint_receipt'],'--columns',column_bank,'--prefix',stem+'-model'],stem+'-export.log',20))
    model=stem+'-model.json';prep=stem+'-model-independent.json'
    stages.append(run(['verify_singleton_archive_cg.py','--manifest',model,'--output',prep],stem+'-model-independent.log',20))
    stages.append(run(['run_singleton_archive_cg_soplex_generic.py','--manifest',model,'--receipt',prep,'--output-prefix',stem+'-solve'],stem+'-solve-supervisor.log',100))
    solve=read(stem+'-solve.json');outcome='BOUNDED_SOLVER_RESULT';result=None;pricing_calls=0
    if solve['external_stop'] is None and solve['returncode']==0:
        if solve['reported_solver_status']=='problem is solved [optimal]':
            result_receipt=stem+'-membership-independent.json'
            stages.append(run(['verify_singleton_archive_cg.py','--manifest',model,'--solver-frozen',stem+'-solve.frozen.json','--primal',stem+'-solve.primal','--output',result_receipt],stem+'-membership-independent.log',20))
            rr=read(result_receipt);assert rr['status']=='PASS_EXACT_GLOBAL_SINGLETON_ARCHIVE_BASIS_MEMBERSHIP'
            outcome='EXACT_GLOBAL_SINGLETON_MEMBERSHIP';result=dict(receipt=result_receipt,receipt_sha256=sha(result_receipt),positive_basis_count=rr['positive_basis_count'])
        elif solve['reported_solver_status']=='problem is solved [infeasible]':
            dual=stem+'-farkas-independent.json';pricing=stem+'-pricing.json';pr=stem+'-pricing-independent.json'
            stages.append(run(['verify_singleton_archive_cg.py','--manifest',model,'--solver-frozen',stem+'-solve.frozen.json','--farkas',stem+'-solve.dual','--output',dual],stem+'-farkas-independent.log',20))
            stages.append(run(['price_singleton_archive_cg.py','--manifest',model,'--farkas-receipt',dual,'--output',pricing],stem+'-pricing.log',20));pricing_calls=1
            stages.append(run(['verify_singleton_exact_pricing.py','--pricing',pricing,'--output',pr],stem+'-pricing-independent.log',20))
            r=read(pr);assert r['status']=='PASS_EXACT_SINGLETON_PHYSICAL_BASIS_PRICING' and r['pricing_sha256']==sha(pricing) and r['consumer_sha256']==sha(ROOT/'verify_singleton_exact_pricing.py')
            d=read(pricing)
            if d['global_rank_cut_candidate'] is not None:
                owner,target=point_data(s['point'],15);p=owner[15];q=[v/(16*p) for v in target[55:]];X,Z,_=physical()
                result=accept_cut(d['global_rank_cut_candidate'],Z,q,p,s['point'],owner,a.prefix,sources);outcome='EXACT_GLOBAL_RANK_CUT'
            else:
                assert d['missing_archive_column'] and Q(d['minimum_affine_value'])<0
                assert tuple(d['minimizing_physical_basis']) not in set(map(tuple,B))
                outcome='EXACT_RESTRICTED_ARCHIVE_INFEASIBLE_WITH_MISSING_COLUMN'
                result=dict(pricing=pricing,pricing_sha256=sha(pricing),pricing_receipt=pr,pricing_receipt_sha256=sha(pr),
                            new_minimizing_basis_unsolved=True,last_solved_columns=3225,discovered_columns=3226,
                            minimum_affine_value=d['minimum_affine_value'])
    assert all(sha(ROOT/p)==h for p,h in sources.items())
    out=dict(status='ONE_NEGATIVE_EXCHANGE_BATCH_LP_FINISHED',outcome=outcome,result=result,
             frozen_sha256=sha(fp),stages=stages,lp_calls=1,post_lp_pricing_calls=pricing_calls,
             point_sha256=s['point_sha256'],anchor_orbit=15,elapsed_seconds=time.monotonic()-start,
             source_C16_answered=False,no_automatic_extension=True)
    write(stem+'.json',out);print(json.dumps({k:v for k,v in out.items() if k!='stages'}),flush=True)
if __name__=='__main__':main()
