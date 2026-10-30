#!/usr/bin/env python3
"""Create explicit geometry-context versions; preserve all prior sources."""
from pathlib import Path
import os,difflib,hashlib,json
ROOT=Path(__file__).resolve().parent
CONTEXT='''def context(manifest):
    m=read(manifest);assert m['status']=='EXACT_SINGLETON_GEOMETRY_ARCHIVE_LP_REQUIRES_TEXT_REPLAY'
    assert sha(m['semantic'])==m['semantic_sha256'] and sha(m['lp'])==m['lp_sha256']
    s=read(m['semantic']);assert s['status']=='FROZEN_SINGLETON_GEOMETRY_BASIS_ARCHIVE' and s['seed_kind']=='GEOMETRY_SEED'
    assert s['old_weights_used'] is False and s['old_target_claims_used'] is False
    assert all(sha(ROOT/p)==h for p,h in s['source_hashes'].items())
    c=read(s['geometry_seed']);r=read(s['geometry_receipt'])
    assert c['status']=='GEOMETRY_SEED' and c['seed_kind']=='LEGACY_PHYSICAL_COLUMNS_ONLY'
    assert c['old_weights_used'] is False and c['old_target_claims_used'] is False and c['current_point_membership_claimed'] is False
    assert r['status']=='PASS_EXACT_SINGLETON_GEOMETRY_SEED'
    assert sha(s['geometry_seed'])==s['geometry_seed_sha256']==r['seed_sha256'] and sha(s['geometry_receipt'])==s['geometry_receipt_sha256']
    assert r['consumer_sha256']==sha(ROOT/'verify_singleton_geometry_seed.py')
    assert all(sha(ROOT/p)==h for p,h in {**c['source_hashes'],**r['source_hashes']}.items())
    X,Z,_=physical();assert rank(X)==rank(Z)==128
    k=s['anchor_orbit'];assert type(k)is int and k==32==c['anchor_orbit']
    owner,target=point_data(s['point'],k);p=owner[k];q=[v/(16*p) for v in target[55:]]
    assert sha(s['point'])==m['point_sha256']==s['point_sha256']==c['point_sha256']==r['point_sha256']
    assert Q(s['conditional_probability'])==Q(c['conditional_probability'])==p and 0<p<1
    assert list(map(Q,s['conditional_target']))==list(map(Q,c['conditional_target']))==q and all(0<=v<=1 for v in q)
    E=[j for j in range(720) if (X[16*k]&Z[j]).bit_count()%2==0]
    assert E==s['physical_zero_ground_indices']==c['physical_zero_ground_indices']
    assert rank(Z[j] for j in E)==sum(q[j] for j in E)==127
    U=sorted(set(range(720))-set(E));assert sum(q[j] for j in U)==1
    B=s['physical_bases'];assert B==c['physical_bases'] and 1<=len(B)<=5000 and len({tuple(b) for b in B})==len(B)
    for b in B:assert b==sorted(set(b)) and len(b)==127 and all(type(j)is int and j in E for j in b) and rank(Z[j] for j in b)==127
    assert s['unit_probabilities']==c['unit_probabilities']
    units={b['index']:Q(b['probability']) for b in s['unit_probabilities']}
    assert len(units)==len(s['unit_probabilities']) and set(units)<=set(U) and all(0<w<=1 for w in units.values())
    assert all(units.get(j,0)==q[j] for j in U)
    assert m['variable_count']==s['variable_count']==len(B)
    assert m['row_count']==len(B)+len(E)+1 and m['nonzeros']==len(B)*129
    return m,s,E,q,B,Z

'''

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
    records=[];diffs=[]
    def save(old,new,text):
        original=(ROOT/old).read_text();p=ROOT/new;assert not p.exists();compile(text,new,'exec');p.write_text(text)
        records.append(dict(original=old,original_sha256=hashlib.sha256(original.encode()).hexdigest(),version=new,sha256=hashlib.sha256(text.encode()).hexdigest()))
        diffs.extend(difflib.unified_diff(original.splitlines(True),text.splitlines(True),fromfile=old,tofile=new))
    old='verify_singleton_archive_cg.py';text=(ROOT/old).read_text();start=text.index('def context(manifest):');end=text.index('def rows(',start)
    text=text[:start]+CONTEXT+text[end:]
    text=text.replace('PASS_EXACT_SINGLETON_ARCHIVE_LP_TEXT_AND_PHYSICAL_COLUMNS','PASS_EXACT_SINGLETON_GEOMETRY_ARCHIVE_LP_TEXT_AND_PHYSICAL_COLUMNS')
    save(old,'verify_singleton_geometry_archive.py',text)
    old='run_singleton_archive_cg_soplex_generic.py';text=(ROOT/old).read_text()
    text=text.replace('EXACT_SINGLETON_ARCHIVE_LP_REQUIRES_TEXT_REPLAY','EXACT_SINGLETON_GEOMETRY_ARCHIVE_LP_REQUIRES_TEXT_REPLAY')
    text=text.replace('PASS_EXACT_SINGLETON_ARCHIVE_LP_TEXT_AND_PHYSICAL_COLUMNS','PASS_EXACT_SINGLETON_GEOMETRY_ARCHIVE_LP_TEXT_AND_PHYSICAL_COLUMNS')
    text=text.replace('verify_singleton_archive_cg.py','verify_singleton_geometry_archive.py')
    save(old,'run_singleton_geometry_archive_soplex.py',text)
    old='price_singleton_archive_cg.py';text=(ROOT/old).read_text();assert text.count('verify_singleton_archive_cg.py')==1
    text=text.replace('verify_singleton_archive_cg.py','verify_singleton_geometry_archive.py')
    save(old,'price_singleton_geometry_archive.py',text)
    diff=ROOT/'two-basis-results/singleton-geometry-context.diff';assert not diff.exists();diff.write_text(''.join(diffs))
    out=ROOT/'two-basis-results/singleton-geometry-context.json';assert not out.exists()
    out.write_text(json.dumps(dict(status='SINGLETON_GEOMETRY_CONTEXT_REQUIRES_INDEPENDENT_REVIEW',files=records,
                diff=str(diff.relative_to(ROOT)),diff_sha256=hashlib.sha256(diff.read_bytes()).hexdigest(),
                scope='Anchor32 geometry-seed context only; exact row parsing, mixture, Farkas and physical greedy pricing arithmetic unchanged.',
                solver_launched=False,maximum_solver_seconds=60,maximum_external_seconds=90),indent=2)+'\n')
    print(json.dumps(records),flush=True)

if __name__=='__main__':main()
