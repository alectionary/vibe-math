#!/usr/bin/env python3
"""Exact unrestricted-law shared full-basis phase-I LP; preparation only."""
import os
assert os.getpriority(os.PRIO_PROCESS, 0) == 19
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
assert all(os.environ.get(k)=='1' for k in THREADS)
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,time
from two_basis_owner_star_capacity import decode,row_expression as parent_expression
from owner_k22_capacity_extension import unpack
from two_sided_full_basis_oracle import TwoSidedFullBasisOracle,rank,DOMAIN_OK,SIDE_OK
from export_joint_fixed_exact_lp import write_row

ROOT=Path(__file__).resolve().parent
OLD_ROOTS=[Path('/private/tmp/c16-two-basis-20261030T1438/formalization/canonical-width/c16'),
           Path('/private/tmp/c16-coupling-20261030T0514/formalization/canonical-width/c16')]
def resolve(path):
    p=Path(path)
    if not p.is_absolute():return ROOT/p
    for old in OLD_ROOTS:
        try:return ROOT/p.relative_to(old)
        except ValueError:pass
    return p
def sha(path):return hashlib.sha256(resolve(path).read_bytes()).hexdigest()
def read(path):
    p=resolve(path);data=p.read_bytes()
    return json.loads(gzip.decompress(data) if p.suffix=='.gz' else data)
def write(path,obj):
    p=resolve(path);assert not p.exists(),p;p.parent.mkdir(parents=True,exist_ok=True)
    data=(json.dumps(obj,separators=(',',':'))+'\n').encode()
    p.write_bytes(gzip.compress(data,mtime=0) if p.suffix=='.gz' else data)
def pairs(d):return [[j,str(v)] for j,v in sorted(d.items()) if v]
def negative(e):return tuple({j:-v for j,v in d.items() if v} for d in e)
def add(d,j,v):
    d[j]=d.get(j,Q(0))+v
    if not d[j]:del d[j]
def block_number(side,mask):return 2*mask+(side=='Z')

def parent_rows(model,wrapper):
    for kind,relation in [('equalities','='),('inequalities','<=')]:
        for i,d in enumerate(model[kind]):yield kind+str(i),relation,parent_expression(model,d)
    for row in wrapper['appended_rows']:
        yield row['name'],row['relation'],unpack(row['expression'])

def all_rows(model,wrapper,columns,layout):
    yield from parent_rows(model,wrapper)
    groups={(s,m):[] for m in range(16) for s in 'XZ'}
    by_coordinate={(s,m,j):[] for m in range(16) for s in 'XZ' for j in range(720)}
    for k,c in enumerate(columns):
        i=layout['weight_offset']+k;groups[c['side'],c['mask']].append(i)
        for j in c['indices']:by_coordinate[c['side'],c['mask'],j].append(i)
    for m in range(16):
        for s in 'XZ':
            e=negative(model['lambda_expressions'][m])
            for i in groups[s,m]:add(e[1],i,Q(1))
            yield f'sm_mass_{s}_{m}','=',e
    for m in range(16):
        for s in 'XZ':
            for j in range(720):
                q=720*block_number(s,m)+j
                e=negative(model['sectors'][s]['allocations'][m][j])
                for i in by_coordinate[s,m,j]:add(e[1],i,Q(1))
                add(e[1],layout['positive_error_offset']+q,Q(1))
                add(e[1],layout['negative_error_offset']+q,Q(-1))
                yield f'sm_link_{s}_{m}_{j}','=',e
    for i in range(layout['weight_offset'],layout['variable_count']):
        yield f'sm_nonneg_{i}','<=',({}, {i:Q(-1)})

def tokens(path):
    with resolve(path).open() as f:
        for line in f:yield from line.split()
def text_replay(path,rows,features,layout):
    t=iter(tokens(path));assert next(t)=='Minimize' and next(t)=='obj:'
    for i in range(layout['positive_error_offset'],layout['variable_count']):
        assert [next(t),next(t),next(t)]==['+','1','x'+str(i)]
    assert [next(t),next(t)]==['Subject','To'];count=0
    for name,relation,e in rows:
        assert next(t)==name+':'
        expected=e[1] or {0:Q(0)}
        for j,v in sorted(expected.items()):
            assert next(t)==('+' if v>=0 else '-')
            assert Q(next(t))==abs(v) and next(t)=='x'+str(j)
        constant=sum((features[j]*v for j,v in e[0].items()),Q(0))
        assert next(t)==relation and Q(next(t))==-constant;count+=1
    assert next(t)=='Bounds'
    for i in range(layout['variable_count']):assert [next(t),next(t)]==['x'+str(i),'free']
    assert next(t)=='End'
    try:next(t)
    except StopIteration:pass
    else:raise AssertionError('trailing LP tokens')
    return count

def validate_basis(oracle,domain,side,indices):
    assert domain['status']==DOMAIN_OK;d=domain[side];assert d['status']==SIDE_OK
    U=oracle.X if side=='X' else oracle.Z
    assert all(type(j)is int and 0<=j<720 for j in indices)
    B=set(indices);assert len(B)==len(indices)==128 and rank(U[j] for j in B)==128
    assert set(d['selected_anchor_indices'])<=B and B.isdisjoint(d['absent_anchor_indices'])
    allowed=set(d['forced_zero_indices']+d['zero_free_indices'])
    for owner in d['owner_bins']:allowed.update(owner['candidate_indices'])
    assert B<=allowed
    for owner in d['owner_bins']:
        assert len(B.intersection(owner['candidate_indices']))==1
        if owner['forced_index'] is not None:assert owner['forced_index'] in B

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--geometry-bank',required=True)
    ap.add_argument('--prefix',required=True);a=ap.parse_args();start=time.monotonic()
    prefix=Path(a.prefix);paths={k:str(prefix)+v for k,v in [('lp','.lp'),('semantic','.model.json.gz'),('seed','.seed.json.gz'),('manifest','.json')]}
    assert not any(resolve(p).exists() for p in paths.values())
    parent_manifest='two-basis-results/joint-owner-k22-eight-point22.json'
    parent_receipt='two-basis-results/joint-owner-k22-eight-point22-independent.json'
    endpoint='two-basis-results/joint-owner-k22-eight-point22-exact.json'
    endpoint_receipt='two-basis-results/joint-owner-k22-eight-point22-exact-independent.json'
    seed_path='two-basis-results/shared-basis-phase-one-point22-seed.json.gz'
    seed_receipt='two-basis-results/shared-basis-phase-one-point22-seed-independent.json'
    pm,pr,c,cr,seed,sr=[read(p) for p in [parent_manifest,parent_receipt,endpoint,endpoint_receipt,seed_path,seed_receipt]]
    assert pr['status']=='PASS_EXACT_OWNER_K22_CAPACITY_MODEL' and pr['manifest_sha256']==sha(parent_manifest)
    assert pr['consumer_sha256']==sha('verify_owner_k22_capacity_extension.py')
    assert cr['status']=='PASS_EXACT_LITERAL_OWNER_K22_CAPACITY_ALLOCATION' and cr['certificate_sha256']==sha(endpoint)
    assert cr['consumer_sha256']==sha('verify_owner_k22_capacity_endpoint.py')
    assert sr['status']=='PASS_EXACT_SHARED_BASIS_PHASE_ONE_SEED' and sr['certificate_sha256']==sha(seed_path)
    assert sr['consumer_sha256']==sha('verify_shared_basis_phase_one_seed.py')
    assert seed['endpoint_sha256']==sha(endpoint) and seed['parent_exact_parameters']==c['exact_parameters']
    assert seed['parent_exact_allocations']==c['exact_allocations']
    wrapper=read(pm['semantic']);assert sha(pm['semantic'])==pm['semantic_sha256']==cr['model_sha256']
    saved=read(wrapper['parent_semantic']);assert sha(wrapper['parent_semantic'])==wrapper['parent_semantic_sha256']
    model=decode(saved['model']);features=list(map(Q,saved['feature_values']))
    assert len(features)==36496 and features[0]==1
    assert len(model['variables'])==22481 and wrapper['full_variables']==22513
    assert model['fixed_law_faces_used'] is False and model['structural_only_elimination'] is True
    assert [(i,v['mask']) for i,v in enumerate(model['variables']) if v['kind']=='tau']==[(0,7),(1,11),(2,13),(3,14),(4,15)]
    assert len(model['equalities'])+len(model['inequalities'])==98725 and len(wrapper['appended_rows'])==138
    sources={}
    for obj in [model,wrapper,c,cr,seed,sr]:
        for key in ('source_hashes','source_bindings','dependencies'):
            for p,h in obj.get(key,{}).items():
                assert sha(p)==h,p
                assert p not in sources or sources[p]==h;sources[p]=h
    geometry=read(a.geometry_bank);columns=geometry['columns']
    assert 32<=len(columns)<3000
    if 'point_sha256' in geometry:assert geometry['point_sha256']==c['point_sha256']
    for p,h in geometry.get('source_hashes',{}).items():assert sha(p)==h;sources[p]=h
    oracle=TwoSidedFullBasisOracle();domains=oracle.prepare([80,512],[186,433]);seen=set();groups={(s,m):[] for m in range(16) for s in 'XZ'}
    for k,col in enumerate(columns):
        s,m=col['side'],col['mask'];assert s in 'XZ' and type(m)is int and 0<=m<16
        validate_basis(oracle,domains[m],s,col['indices'])
        key=s,m,tuple(sorted(col['indices']));assert key not in seen;seen.add(key);groups[s,m].append(k)
    assert all(groups.values())
    nB=len(columns);layout=dict(parent_variables=22513,weight_offset=22513,weight_count=nB,
        positive_error_offset=22513+nB,negative_error_offset=22513+nB+23040,
        error_count_per_sign=23040,variable_count=22513+nB+46080,block_order='mask-major, X then Z, physical index 0..719')
    initial=list(map(Q,c['exact_parameters']))+[Q(0)]*(nB+46080)
    seeds={(b['side'],b['mask'],tuple(sorted(b['indices']))):b for b in seed['blocks']}
    used=set()
    for k,col in enumerate(columns):
        key=col['side'],col['mask'],tuple(sorted(col['indices']))
        if key in seeds:
            b=seeds[key];initial[22513+k]=Q(b['weight']);used.add(key)
            q=720*block_number(col['side'],col['mask'])
            for j in range(720):
                initial[layout['positive_error_offset']+q+j]=Q(b['positive_slack'][j])
                initial[layout['negative_error_offset']+q+j]=Q(b['negative_slack'][j])
    assert used==set(seeds)
    for p in [parent_manifest,parent_receipt,endpoint,endpoint_receipt,seed_path,seed_receipt,pm['semantic'],wrapper['parent_semantic'],
              a.geometry_bank,Path(__file__).name,'two_basis_owner_star_capacity.py','owner_k22_capacity_extension.py',
              'two_sided_full_basis_oracle.py','export_joint_fixed_exact_lp.py','SHARED-MASTER-TWO-HOURS.md']:
        sources[str(p)]=sha(p)
    rows=all_rows(model,wrapper,columns,layout);nrows=0;nnz=0;neq=0;names=set();minimum_slack=None
    resolve(paths['lp']).parent.mkdir(parents=True,exist_ok=True)
    with resolve(paths['lp']).open('w') as stream:
        stream.write('Minimize\n obj:')
        for q,i in enumerate(range(layout['positive_error_offset'],layout['variable_count'])):
            if q%10==0:stream.write('\n  ')
            stream.write(' + 1 x'+str(i))
        stream.write('\nSubject To\n')
        for name,relation,e in rows:
            assert name not in names;names.add(name)
            constant=sum((v*features[j] for j,v in e[0].items()),Q(0))
            value=constant+sum((v*initial[j] for j,v in e[1].items()),Q(0))
            assert value==0 if relation=='=' else value<=0,(name,value)
            if relation=='<=':minimum_slack=-value if minimum_slack is None else min(minimum_slack,-value)
            write_row(stream,name,e[1],-constant,relation)
            nrows+=1;nnz+=len(e[1]);neq+=relation=='='
        stream.write('Bounds\n')
        for i in range(layout['variable_count']):stream.write(' x'+str(i)+' free\n')
        stream.write('End\n')
    assert nrows==98863+32+23040+nB+46080
    assert text_replay(paths['lp'],all_rows(model,wrapper,columns,layout),features,layout)==nrows
    objective=sum(initial[layout['positive_error_offset']:]);assert objective==Q(seed['total_L1'])>0
    shared=dict(parent_manifest=parent_manifest,parent_manifest_sha256=sha(parent_manifest),
        parent_receipt=parent_receipt,parent_receipt_sha256=sha(parent_receipt),
        parent_endpoint=endpoint,parent_endpoint_sha256=sha(endpoint),parent_endpoint_receipt=endpoint_receipt,parent_endpoint_receipt_sha256=sha(endpoint_receipt),
        parent_wrapper=pm['semantic'],parent_wrapper_sha256=sha(pm['semantic']),
        parent_full_semantic=wrapper['parent_semantic'],parent_full_semantic_sha256=sha(wrapper['parent_semantic']),
        accepted_seed=seed_path,accepted_seed_sha256=sha(seed_path),accepted_seed_receipt=seed_receipt,accepted_seed_receipt_sha256=sha(seed_receipt),
        geometry_bank=a.geometry_bank,geometry_bank_sha256=sha(a.geometry_bank),
        point=saved['point'],point_sha256=c['point_sha256'],source_hashes=sources,
        path_relocations=[dict(old=str(p),new=str(ROOT)) for p in OLD_ROOTS],all_sixteen_patterns=True,zero_tau_pins=False,
        removed_pin_rows=[dict(name='zero_tau'+str(j),variable=j,mask=m) for j,m in [(0,7),(1,11),(2,13),(3,14),(4,15)]])
    seed_out=dict(status='EXACT_SHARED_MASTER_FEASIBLE_ARTIFICIAL_START_REQUIRES_REPLAY',**shared,
        layout=layout,exact_parameters=list(map(str,initial)),objective=str(objective),positive_weight_count=len(used),
        all_parent_parameter_strings_retained=initial[:22513]==list(map(Q,c['exact_parameters'])),
        nonzero_errors=True,model_membership_claimed=False)
    write(paths['seed'],seed_out)
    semantic=dict(status='EXACT_SHARED_BASIS_PHASE_ONE_MODEL_REQUIRES_REPLAY',**shared,
        layout=layout,feature_values=saved['feature_values'],
        row_layout=dict(parent_full_rows_without_pins=98863,parent_equalities=len(model['equalities']),parent_inequalities=len(model['inequalities']),
                        k22_appended_rows=138,mass_rows=32,link_rows=23040,nonnegative_rows=nB+46080),
        seed=paths['seed'],seed_sha256=sha(paths['seed']),objective=dict(kind='sum_all_positive_and_negative_link_errors',first=layout['positive_error_offset'],stop=layout['variable_count'],coefficient='1'),
        parent_row_scope='All full symbolic parent rows retained except five explicit zero_tau pin equalities; no zero-face reduction or inherited tau0 faces.',
        physical_columns_are_geometry_only=True,unanchored_mutual_pairings_enforced=False)
    write(paths['semantic'],semantic)
    assert all(sha(p)==h for p,h in sources.items())
    out=dict(status='EXACT_SHARED_BASIS_PHASE_ONE_LP_REQUIRES_REPLAY',**shared,
        semantic=paths['semantic'],semantic_sha256=sha(paths['semantic']),lp=paths['lp'],lp_sha256=sha(paths['lp']),lp_bytes=resolve(paths['lp']).stat().st_size,
        seed=paths['seed'],seed_sha256=sha(paths['seed']),variable_count=layout['variable_count'],row_count=nrows,equalities=neq,
        inequalities=nrows-neq,nonzeros=nnz,basis_count=nB,block_counts={s:[len(groups[s,m]) for m in range(16)] for s in 'XZ'},
        artificial_seed_L1=str(objective),exact_text_roundtrip=True,exact_initial_all_rows_checked=True,
        priority=19,threads=1,elapsed_seconds=time.monotonic()-start,solver_launched=False,independent_acceptance=False,source_C16_answered=False)
    write(paths['manifest'],out)
    print(json.dumps({k:v for k,v in out.items() if k not in ('source_hashes','removed_pin_rows','path_relocations')}),flush=True)
if __name__=='__main__':main()
