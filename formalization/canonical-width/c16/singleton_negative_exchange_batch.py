#!/usr/bin/env python3
"""Prepare up to64 negative-priced physical basis exchanges; never solve an LP."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):os.environ[k]='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,math,time
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def rank(vectors):
    rows={}
    for v in vectors:
        while v:
            bit=v.bit_length()-1
            if bit in rows:v^=rows[bit]
            else:rows[bit]=v;break
    return len(rows)
def candidates(vectors,E,B,u,v,existing):
    """High-pivot fundamental circuits, with exact common-denominator costs."""
    B=tuple(B);assert B==tuple(sorted(set(B))) and set(B)<=set(E)
    D=math.lcm(u.denominator,*(v[j].denominator for j in E));ui=int(u*D);wi={j:int(v[j]*D) for j in E}
    base_cost=ui+sum(wi[j] for j in B);assert base_cost<0
    rows={}
    for pos,j in enumerate(B):
        x=vectors[j];expression=1<<pos
        while x:
            bit=x.bit_length()-1
            if bit in rows:a,b=rows[bit];x^=a;expression^=b
            else:rows[bit]=(x,expression);break
        assert x
    edges=[];exchanges=negative=duplicates=0
    for added in sorted(set(E)-set(B)):
        x=vectors[added];expression=0
        while x:
            bit=x.bit_length()-1;assert bit in rows
            a,b=rows[bit];x^=a;expression^=b
        while expression:
            bit=expression&-expression;expression^=bit;removed=B[bit.bit_length()-1]
            delta=wi[added]-wi[removed];assert delta>=0,'Input basis is not minimum for this ray'
            exchanges+=1;cost=base_cost+delta
            if cost>=0:continue
            negative+=1;new=tuple(sorted((set(B)-{removed})|{added}))
            if new in existing:duplicates+=1;continue
            edges.append((delta,removed,added,cost))
    edges.sort()
    return edges,D,dict(fundamental_exchange_count=exchanges,strictly_negative_exchange_count=negative,
                         existing_duplicate_count=duplicates,eligible_new_exchange_count=len(edges),
                         zero_cost_new_exchange_count=sum(delta==0 for delta,_,_,_ in edges))
def forest_select(edges,E,limit):
    parent={j:j for j in E}
    def find(j):
        while parent[j]!=j:parent[j]=parent[parent[j]];j=parent[j]
        return j
    selected=[]
    for edge in edges:
        _,removed,added,_=edge;a,b=find(removed),find(added)
        if a==b:continue
        parent[a]=b;selected.append(edge)
        if len(selected)==limit:break
    return selected
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--pricing',type=Path,required=True);ap.add_argument('--pricing-receipt',type=Path,required=True)
    ap.add_argument('--gate',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--limit',type=int,default=64);a=ap.parse_args();start=time.monotonic()
    assert 1<=a.limit<=64 and not a.output.exists();d=read(a.pricing);r=read(a.pricing_receipt);g=read(a.gate)
    assert r['status']=='PASS_EXACT_SINGLETON_PHYSICAL_BASIS_PRICING' and r['pricing_sha256']==sha(a.pricing)
    assert r['consumer_sha256']==sha(ROOT/'verify_singleton_exact_pricing.py') and r['missing_archive_column']
    assert d['missing_archive_column'] and d['global_rank_cut_candidate'] is None
    assert g['stop_reason']=='MAXIMUM_20_ROUNDS' and g['anchor_orbit']==d['anchor_orbit']==15
    assert g['records'][-1]['pricing_sha256']==sha(a.pricing)
    m=read(d['manifest']);s=read(m['semantic']);f=read(d['farkas_receipt'])
    assert sha(d['manifest'])==d['manifest_sha256'] and sha(m['semantic'])==m['semantic_sha256']
    assert sha(d['farkas_receipt'])==d['farkas_receipt_sha256'] and f['status']=='PASS_EXACT_RESTRICTED_SINGLETON_ARCHIVE_INFEASIBILITY'
    assert all(sha(ROOT/p)==h for p,h in s['source_hashes'].items())
    X,Z,_=physical();E=s['physical_zero_ground_indices'];B=d['minimizing_physical_basis'];archive=s['physical_bases']
    assert rank(Z[j] for j in E)==rank(Z[j] for j in B)==len(B)==127
    assert E==[j for j in range(720) if (X[16*15]&Z[j]).bit_count()%2==0]
    existing=set(map(tuple,archive));assert tuple(B) not in existing and len(existing)==len(archive)
    assert len(archive)==g['records'][-1]['columns']==3160 and g['final_columns']==3161
    existing.add(tuple(B));weights={key:Q(value) for key,value in f['proof']['multipliers'].items()}
    u=weights.get('mass',Q(0));v={j:weights.get('q'+str(j),Q(0)) for j in E}
    assert u==Q(d['constant']) and [[j,str(v[j])] for j in E if v[j]]==d['weights']
    assert u+sum((v[j] for j in B),Q(0))==Q(d['minimum_affine_value'])<0
    edges,D,statistics=candidates(Z,E,B,u,v,existing);selected=forest_select(edges,E,a.limit);records=[]
    for delta,removed,added,cost in selected:
        C=sorted((set(B)-{removed})|{added});assert len(C)==rank(Z[j] for j in C)==127 and tuple(C) not in existing
        records.append(dict(removed=removed,added=added,indices=C,physical_rank=127,
                            exact_cost_change=str(Q(delta,D)),exact_affine_cost=str(Q(cost,D)),
                            same_minimum_face=delta==0))
    sources=dict(s['source_hashes'])
    for p in [a.pricing,a.pricing_receipt,a.gate,Path(d['manifest']),Path(m['semantic']),Path(d['farkas_receipt']),Path(__file__),ROOT/'verify_singleton_negative_exchange_batch.py',ROOT/'verify_singleton_exact_pricing.py']:
        sources[str(p.resolve().relative_to(ROOT))]=sha(p)
    out=dict(status='EXACT_NEGATIVE_PHYSICAL_EXCHANGE_BATCH_REQUIRES_REPLAY',source_hashes=sources,
             pricing=str(a.pricing),pricing_sha256=sha(a.pricing),pricing_receipt=str(a.pricing_receipt),pricing_receipt_sha256=sha(a.pricing_receipt),
             gate=str(a.gate),gate_sha256=sha(a.gate),point_sha256=s['point_sha256'],anchor_orbit=15,
             last_solved_archive_count=len(archive),prior_discovered_count=g['final_columns'],
             base_basis=B,base_exact_affine_cost=d['minimum_affine_value'],selection_limit=a.limit,
             selection_rule='Increasing exact cost change, then removed/added index; retain forest edges only.',
             statistics=statistics,columns=records,selected_count=len(records),forest_direction_rank=len(records),
             same_minimum_face_count=sum(c['same_minimum_face'] for c in records),
             independent_modulo_existing_archive_not_claimed=True,new_lp_performed=False,source_C16_answered=False,
             producer_sha256=sha(__file__),elapsed_seconds=time.monotonic()-start,nice=19,threads=1)
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ('columns','source_hashes','base_basis')}),flush=True)
if __name__=='__main__':main()
