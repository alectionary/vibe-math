#!/usr/bin/env python3
"""Prepare one exact improving forest batch from an accepted phase-I dual."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    os.environ[key]='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,time
from singleton_negative_exchange_batch import candidates,forest_select,rank
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def write(p,d):
    p=Path(p);assert not p.exists();raw=(json.dumps(d,indent=2)+'\n').encode()
    p.write_bytes(gzip.compress(raw,mtime=0) if p.suffix=='.gz' else raw)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--endpoint',type=Path,required=True)
    ap.add_argument('--prefix',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    d=read(a.endpoint)
    assert d['status']=='PASS_EXACT_SINGLETON_PHASE_ONE_OPTIMUM_AND_FULL_GREEDY_PRICING'
    assert d['consumer_sha256']==sha(ROOT/'verify_singleton_phase_one_v2.py')
    assert d['parser_sha256']==sha(ROOT/'read_soplex_exact_output_v2.py')
    assert d['anchor_orbit']==15 and d['point_sha256']=='4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f'
    assert Q(d['exact_restricted_L1_distance'])>0 and Q(d['pricing']['exact_global_separation_gap'])<0
    pm=read(d['manifest']);assert sha(d['manifest'])==d['manifest_sha256']
    parent=read(pm['parent_manifest']);assert sha(pm['parent_manifest'])==pm['parent_manifest_sha256']
    s=read(parent['semantic']);assert sha(parent['semantic'])==parent['semantic_sha256']
    assert all(sha(ROOT/p)==h for p,h in d['source_hashes'].items())
    archive=s['physical_bases'];E=s['physical_zero_ground_indices'];B=d['pricing']['maximizing_physical_basis']
    assert len(archive)==len(set(map(tuple,archive)))==3225
    X,Z,_=physical();assert E==[j for j in range(720) if (X[16*15]&Z[j]).bit_count()%2==0]
    assert B==sorted(set(B)) and set(B)<=set(E) and len(B)==rank(Z[j] for j in B)==rank(Z[j] for j in E)==127
    c={j:Q(0) for j in E}
    assert len(dict(d['dual_weights']))==len(d['dual_weights'])
    for j,value in d['dual_weights']:assert j in c;c[j]=Q(value)
    u=Q(d['dual_constant']);assert all(-1<=v<=1 for v in c.values())
    profit=u+sum(c[j] for j in B)
    assert profit==Q(d['exact_restricted_L1_distance'])-Q(d['pricing']['exact_global_separation_gap'])>0
    assert sum(c[j] for j in B)==Q(d['pricing']['maximum_support'])
    existing=set(map(tuple,archive));assert tuple(B) not in existing;existing.add(tuple(B))
    edges,D,statistics=candidates(Z,E,B,-u,{j:-c[j] for j in E},existing)
    ui=int(u*D);ci={j:int(c[j]*D) for j in E}
    assert all(ui+sum(ci[j] for j in C)<=0 for C in archive)
    selected=forest_select(edges,E,64);records=[]
    for loss,removed,added,negative_cost in selected:
        C=sorted((set(B)-{removed})|{added})
        assert tuple(C) not in existing and len(C)==rank(Z[j] for j in C)==127
        value=Q(-negative_cost,D);assert value==profit-Q(loss,D)>0
        records.append(dict(removed=removed,added=added,indices=C,physical_rank=127,
                            exact_profit=str(value),exact_profit_loss=str(Q(loss,D)),same_maximum_face=loss==0))
    assert 1<=len(records)<=64 and len({tuple(r['indices']) for r in records})==len(records)
    bank=Path(str(a.prefix)+'.json');columns=Path(str(a.prefix)+'-columns.json.gz')
    sources=dict(d['source_hashes'])
    paths=[a.endpoint,Path(d['manifest']),Path(pm['parent_manifest']),Path(parent['semantic']),
           Path(s['column_bank']),Path(__file__),ROOT/'singleton_negative_exchange_batch.py',
           ROOT/'verify_singleton_phase_one_v2.py',ROOT/'read_soplex_exact_output_v2.py',
           ROOT/'two-basis-results/singleton-phase-one-v2-peer-review.json']
    for p in paths:sources[str(p.resolve().relative_to(ROOT))]=sha(p)
    out=dict(status='EXACT_PHASE_ONE_IMPROVING_EXCHANGE_BATCH_REQUIRES_REPLAY',endpoint=str(a.endpoint),endpoint_sha256=sha(a.endpoint),
             phase_manifest=d['manifest'],phase_manifest_sha256=sha(d['manifest']),
             parent_manifest=pm['parent_manifest'],parent_manifest_sha256=sha(pm['parent_manifest']),
             parent_semantic=parent['semantic'],parent_semantic_sha256=sha(parent['semantic']),
             point_sha256=s['point_sha256'],anchor_orbit=15,prior_column_count=len(archive),base_basis=B,
             base_exact_profit=str(profit),columns=records,selected_count=len(records),forest_direction_rank=len(records),
             statistics=statistics,column_bank=str(columns),maximum_new_columns=65,
             same_maximum_face_count=sum(r['same_maximum_face'] for r in records),
             selection_rule='Increasing exact profit loss, then removed/added index, retaining forest edges.',
             independent_modulo_existing_archive_not_claimed=True,source_hashes=sources,
             producer_sha256=sha(__file__),new_lp_performed=False,source_C16_answered=False,
             elapsed_seconds=time.monotonic()-start,nice=19,threads=1)
    write(bank,out)
    old=read(s['column_bank']);origins=list(old['column_origins'])
    origins.append(dict(kind='phase_one_maximizing_basis',endpoint=str(a.endpoint),endpoint_sha256=sha(a.endpoint)))
    origins.extend(dict(kind='phase_one_improving_exchange',bank=str(bank),bank_sha256=sha(bank),index=i) for i in range(len(records)))
    all_bases=archive+[B]+[r['indices'] for r in records]
    assert len(all_bases)==len(origins)==len(set(map(tuple,all_bases)))<=3290
    write(columns,dict(status='FROZEN_SINGLETON_COLUMN_ARCHIVE',initial_endpoint_sha256=s['endpoint_sha256'],
                       initial_receipt_sha256=s['endpoint_receipt_sha256'],physical_bases=all_bases,column_origins=origins,
                       batch=str(bank),batch_sha256=sha(bank),source_hashes=sources))
    print(json.dumps({k:v for k,v in out.items() if k not in ('columns','source_hashes','base_basis')}),flush=True)
if __name__=='__main__':main()
