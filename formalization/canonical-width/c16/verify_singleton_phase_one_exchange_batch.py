#!/usr/bin/env python3
"""Replay physical improving exchanges against a frozen exact phase-I dual."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    os.environ[key]='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,copy,gzip,hashlib,json,time
from verify_singleton_archive_cg import context as archive_context
from verify_singleton_negative_exchange_batch import low_edges,independent_forest,difference_rank,tiny_controls
from verify_singleton_exchange_terminal import rank

ROOT=Path(__file__).resolve().parent
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def read(path):
    p=Path(path);raw=p.read_bytes();return json.loads(gzip.decompress(raw) if p.suffix=='.gz' else raw)

def context(d):
    assert d['status']=='EXACT_PHASE_ONE_IMPROVING_EXCHANGE_BATCH_REQUIRES_REPLAY'
    for key in ('endpoint','phase_manifest','parent_manifest','parent_semantic'):
        assert sha(d[key])==d[key+'_sha256']
    assert all(sha(ROOT/p)==h for p,h in d['source_hashes'].items())
    r=read(d['endpoint']);phase=read(d['phase_manifest'])
    assert r['status']=='PASS_EXACT_SINGLETON_PHASE_ONE_OPTIMUM_AND_FULL_GREEDY_PRICING'
    assert r['consumer_sha256']==sha(ROOT/'verify_singleton_phase_one_v2.py')
    assert r['parser_sha256']==sha(ROOT/'read_soplex_exact_output_v2.py')
    assert r['manifest_sha256']==d['phase_manifest_sha256']
    assert phase['parent_manifest_sha256']==d['parent_manifest_sha256']
    parent,s,E,q,B,Z=archive_context(d['parent_manifest'])
    assert parent['semantic_sha256']==d['parent_semantic_sha256'] and read(d['parent_semantic'])==s
    assert d['point_sha256']==r['point_sha256']==s['point_sha256']
    assert d['anchor_orbit']==r['anchor_orbit']==s['anchor_orbit']==15
    assert d['prior_column_count']==len(B)==3225 and d['maximum_new_columns']==65
    assert Q(r['exact_restricted_L1_distance'])>0 and not r['full_singleton_membership']
    price=r['pricing'];assert Q(price['exact_global_separation_gap'])<=0 and price['global_rank_cut_candidate'] is None
    c={j:Q(0) for j in E}
    for j,value in r['dual_weights']:assert j in c;c[j]=Q(value)
    u=Q(r['dual_constant']);assert all(-1<=v<=1 for v in c.values())
    assert u+sum(c[j]*q[j] for j in E)==Q(r['exact_restricted_L1_distance'])
    assert all(u+sum(c[j] for j in b)<=0 for b in B)
    base=price['maximizing_physical_basis'];assert base==d['base_basis']
    assert base==sorted(set(base)) and set(base)<=set(E) and len(base)==rank(Z[j] for j in base)==127
    assert sum(c[j] for j in base)==Q(price['maximum_support'])
    profit=u+sum(c[j] for j in base);assert profit==Q(d['base_exact_profit'])>0
    existing=set(map(tuple,B));assert tuple(base) not in existing;existing.add(tuple(base))
    return s,E,B,Z,u,c,base,existing

def replay(d,data):
    s,E,B,Z,u,c,base,existing=data
    edges,D,stats=low_edges(Z,E,base,-u,{j:-c[j] for j in E},existing)
    expected=independent_forest(edges,64);records=d['columns']
    assert d['statistics']==stats
    assert d['selected_count']==len(records)==len(expected)<=64
    assert d['forest_direction_rank']==difference_rank([(r['removed'],r['added']) for r in records])==len(records)
    seen=set()
    for r,(delta,e,f,cost) in zip(records,expected):
        assert r['removed']==e and r['added']==f
        basis=sorted((set(base)-{e})|{f});assert r['indices']==basis
        assert tuple(basis) not in existing|seen;seen.add(tuple(basis))
        assert r['physical_rank']==len(basis)==rank(Z[j] for j in basis)==127
        profit=u+sum(c[j] for j in basis)
        assert profit==Q(r['exact_profit'])==Q(-cost,D)>0
        assert c[e]-c[f]==Q(r['exact_profit_loss'])==Q(delta,D)>=0
        assert r['same_maximum_face']==(delta==0)
    bank=read(d['column_bank']);wanted=B+[base]+[r['indices'] for r in records]
    assert bank['physical_bases']==wanted and len(set(map(tuple,wanted)))==len(wanted)
    assert bank['initial_endpoint_sha256']==s['endpoint_sha256'] and bank['initial_receipt_sha256']==s['endpoint_receipt_sha256']
    return dict(selected_exchange_columns=len(records),total_new_columns=1+len(records),enlarged_archive_count=len(wanted),
                exact_within_batch_direction_rank=len(records),same_maximum_face_count=sum(r['same_maximum_face'] for r in records),
                maximum_profit=str(max([Q(d['base_exact_profit'])]+[Q(r['exact_profit']) for r in records])),
                minimum_exchange_profit=str(min(Q(r['exact_profit']) for r in records)) if records else None,
                all_prior_columns_preserved=True,independence_modulo_old_archive_not_claimed=True)

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    start=time.monotonic();assert not a.output.exists();d=read(a.bank);data=context(d);result=replay(d,data)
    rejected=[]
    for label in ('wrong_profit','nonbasis','false_direction_rank'):
        bad=copy.deepcopy(d)
        if label=='wrong_profit':bad['columns'][0]['exact_profit']=str(Q(bad['columns'][0]['exact_profit'])+1)
        elif label=='nonbasis':bad['columns'][0]['indices'].pop()
        else:bad['forest_direction_rank']+=1
        try:replay(bad,data)
        except (AssertionError,ValueError):rejected.append(label)
        else:raise AssertionError(label)
    result.update(status='PASS_EXACT_PHASE_ONE_IMPROVING_EXCHANGE_BATCH',bank=str(a.bank),bank_sha256=sha(a.bank),
                  column_bank=d['column_bank'],column_bank_sha256=sha(d['column_bank']),endpoint_sha256=d['endpoint_sha256'],
                  consumer_sha256=sha(__file__),source_hashes=d['source_hashes'],tiny_controls=tiny_controls(),
                  negative_controls_rejected=rejected,point_sha256=d['point_sha256'],anchor_orbit=15,
                  source_C16_answered=False,new_optimization_performed=False,nice=19,threads=1,elapsed_seconds=time.monotonic()-start)
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k!='source_hashes'}),flush=True)
if __name__=='__main__':main()
