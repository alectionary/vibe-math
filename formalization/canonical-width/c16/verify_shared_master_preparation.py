#!/usr/bin/env python3
"""Independent literal full shared-master LP, physical columns and exact start."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,copy,json,time
from verify_shared_master_common import *

DEPS=['verify_shared_master_common.py','verify_owner_star_flow_extension.py','verify_owner_star_capacity_extension.py',
      'verify_owner_k22_capacity_extension.py','verify_two_sided_full_basis_oracle.py','verify_algebraic_model.py']

def context(manifest_path,preparation_receipt=None,check_columns=True):
    d=read(manifest_path);assert d['status']=='EXACT_SHARED_BASIS_PHASE_ONE_LP_REQUIRES_REPLAY'
    assert d['zero_tau_pins'] is False and d['all_sixteen_patterns'] is True
    assert d['removed_pin_rows']==[dict(name='zero_tau'+str(i),variable=i,mask=m) for i,m in enumerate([7,11,13,14,15])]
    bindings(d['source_hashes'])
    semantic=field(d,'semantic');seed=field(d,'seed');geometry=field(d,'geometry_bank')
    assert sha(d['lp'])==d['lp_sha256']
    assert semantic['status']=='EXACT_SHARED_BASIS_PHASE_ONE_MODEL_REQUIRES_REPLAY'
    assert seed['status']=='EXACT_SHARED_MASTER_FEASIBLE_ARTIFICIAL_START_REQUIRES_REPLAY'
    shared=['parent_manifest','parent_receipt','parent_endpoint','parent_endpoint_receipt','parent_wrapper','parent_full_semantic',
            'accepted_seed','accepted_seed_receipt','geometry_bank','point']
    for key in shared:
        assert semantic[key]==seed[key]==d[key]
        assert semantic[key+'_sha256']==seed[key+'_sha256']==d[key+'_sha256']==sha(d[key])
    assert semantic['source_hashes']==seed['source_hashes']==d['source_hashes']
    assert semantic['zero_tau_pins'] is seed['zero_tau_pins'] is False
    assert semantic['all_sixteen_patterns'] is seed['all_sixteen_patterns'] is True
    assert semantic['removed_pin_rows']==seed['removed_pin_rows']==d['removed_pin_rows']
    assert semantic['seed']==d['seed'] and semantic['seed_sha256']==d['seed_sha256']
    data=parent_context(d['parent_manifest'],d['parent_receipt'])
    assert d['parent_wrapper']==data['manifest']['semantic']
    assert d['parent_full_semantic']==data['wrapper']['parent_semantic']
    assert list(map(Q,semantic['feature_values']))==data['f']
    assert d['point_sha256']==data['manifest']['point_sha256']
    endpoint=read(d['parent_endpoint']);er=read(d['parent_endpoint_receipt'])
    assert er['status']=='PASS_EXACT_LITERAL_OWNER_K22_CAPACITY_ALLOCATION'
    assert er['consumer_sha256']==sha('verify_owner_k22_capacity_endpoint.py')
    assert er['certificate_sha256']==d['parent_endpoint_sha256'] and er['point_sha256']==d['point_sha256']
    assert endpoint['point_sha256']==d['point_sha256'] and endpoint['manifest_sha256']==d['parent_manifest_sha256']
    assert er['model_sha256']==data['manifest']['semantic_sha256']
    bindings(endpoint['source_bindings'])
    oldseed=read(d['accepted_seed']);sr=read(d['accepted_seed_receipt'])
    assert sr['status']=='PASS_EXACT_SHARED_BASIS_PHASE_ONE_SEED'
    assert sr['consumer_sha256']==sha('verify_shared_basis_phase_one_seed.py')
    assert sr['certificate_sha256']==d['accepted_seed_sha256'] and sr['endpoint_sha256']==d['parent_endpoint_sha256']
    assert oldseed['endpoint_sha256']==d['parent_endpoint_sha256']
    assert oldseed['parent_exact_parameters']==endpoint['exact_parameters'] and len(endpoint['exact_parameters'])==22513
    assert oldseed['parent_exact_allocations']==endpoint['exact_allocations'] and oldseed['lambda_masses']==endpoint['lambda_masses']
    bindings(oldseed['source_hashes']);bindings(geometry.get('source_hashes',{}))
    columns=geometry['columns'];assert 32<=len(columns)<3000
    assert geometry.get('point_sha256',d['point_sha256'])==d['point_sha256']
    seen=set()
    for c in columns:
        key=physical_column(c,data) if check_columns else (c['side'],c['mask'],tuple(sorted(c['indices'])))
        assert key not in seen;seen.add(key)
    L=layout(columns);N=L['variable_count'];n=L['nB']
    expected_layout=dict(parent_variables=22513,weight_offset=22513,weight_count=n,
        positive_error_offset=22513+n,negative_error_offset=22513+n+23040,
        error_count_per_sign=23040,variable_count=N,block_order='mask-major, X then Z, physical index 0..719')
    assert semantic['layout']==seed['layout']==expected_layout
    assert semantic['objective']==dict(kind='sum_all_positive_and_negative_link_errors',first=L['plus_start'],stop=N,coefficient='1')
    assert semantic['row_layout']==dict(parent_full_rows_without_pins=98863,parent_equalities=len(data['M']['equalities']),
        parent_inequalities=len(data['M']['inequalities']),k22_appended_rows=138,mass_rows=32,link_rows=23040,nonnegative_rows=n+46080)
    assert d['basis_count']==n and d['variable_count']==N and d['row_count']==98863+32+23040+n+46080
    assert d['block_counts']=={s:[len(L['blocks'][s,m]) for m in range(16)] for s in 'XZ'}
    if preparation_receipt:
        pr=read(preparation_receipt)
        assert pr['status']=='PASS_EXACT_SHARED_BASIS_PHASE_ONE_MODEL'
        assert pr['consumer_sha256']==sha(Path(__file__).name)
        assert pr['manifest_sha256']==sha(manifest_path) and pr['semantic_sha256']==d['semantic_sha256']
        assert pr['lp_sha256']==d['lp_sha256'] and pr['seed_sha256']==d['seed_sha256']
        assert pr['point_sha256']==d['point_sha256'] and pr['zero_tau_pins'] is False
        bindings(pr['dependencies'])
    data.update(manifest=d,semantic=semantic,seed=seed,oldseed=oldseed,endpoint=endpoint,geometry=geometry)
    return data,L,semantic

def seed_values(data,L):
    s=data['seed'];old=data['oldseed'];c=data['endpoint'];N=L['variable_count']
    assert len(s['exact_parameters'])==N and s['exact_parameters'][:22513]==c['exact_parameters']
    values=list(map(Q,s['exact_parameters']));masses=list(map(Q,c['lambda_masses']))
    assert len(masses)==16 and all(v>=0 for v in masses) and sum(masses)==1
    x0=values[:22513];M=data['M'];f=data['f']
    assert [value(e,f,x0) for e in M['lambda_expressions']]==masses
    for side in 'XZ':
        assert [[str(value(e,f,x0)) for e in row] for row in M['sectors'][side]['allocations']]==c['exact_allocations'][side]
    expected=values[:22513]+[Q(0)]*(N-22513);used=set()
    seeds={(b['side'],b['mask'],tuple(sorted(b['indices']))):b for b in old['blocks']}
    assert len(seeds)==22
    for k,col in enumerate(L['columns']):
        key=col['side'],col['mask'],tuple(sorted(col['indices']))
        if key not in seeds:continue
        b=seeds[key];used.add(key);side,m=col['side'],col['mask'];mass=masses[m]
        assert Q(b['weight'])==mass>0;expected[L['weight_start']+k]=mass
        selected=set(col['indices'])
        for j,e in enumerate(M['sectors'][side]['allocations'][m]):
            y=value(e,f,x0);residual=y-mass*int(j in selected);q=link_index(side,m,j)
            assert Q(b['positive_slack'][j])==max(residual,0) and Q(b['negative_slack'][j])==max(-residual,0)
            expected[L['plus_start']+q]=max(residual,0);expected[L['minus_start']+q]=max(-residual,0)
    assert used==set(seeds) and expected==values
    assert s['positive_weight_count']==22 and s['nonzero_errors'] is True and s['model_membership_claimed'] is False
    return values

def controls(data=None,L=None):
    # A free parent variable is fixed to1/2; the sole physical column gives1.
    # This checks the parent-dual cancellation and a positive restricted L1.
    rows=[('parent',add(term(1,0),term(0,0,Q(-1,2))),'='),('mass',add(term(1,1),term(0,0,-1)),'='),
          ('link',({},{0:Q(-1),1:Q(1),2:Q(1),3:Q(-1)}),'=')]
    rows += [('n'+str(j),term(1,j,-1),'<=') for j in range(1,4)]
    f=[Q(1)];x=[Q(1,2),Q(1),Q(0),Q(1,2)];cost={2:Q(1),3:Q(1)}
    pi=dict(parent=Q(-1),mass=Q(1),link=Q(-1),n1=Q(0),n2=Q(-2),n3=Q(0))
    obj,count,slack=check_primal(rows,f,x,cost);assert obj==Q(1,2) and count==6
    assert exact_dual(rows,f,4,cost,pi,obj)[0]==1
    rows2=list(rows);rows2[0]=('parent',add(term(1,0),term(0,0,-1)),'=')
    x2=[Q(1),Q(1),Q(0),Q(0)];pi2={k:Q(0) for k in pi};pi2.update(n2=Q(-1),n3=Q(-1))
    assert check_primal(rows2,f,x2,cost)[0]==0 and exact_dual(rows2,f,4,cost,pi2,Q(0))[0]==1
    raw='Minimize obj: + 1 x2 + 1 x3 Subject To parent: + 1 x0 = 1/2 mass: + 1 x1 = 1 link: - 1 x0 + 1 x1 + 1 x2 - 1 x3 = 0 n1: - 1 x1 <= 0 n2: - 1 x2 <= 0 n3: - 1 x3 <= 0 Bounds x0 free x1 free x2 free x3 free End'
    assert parse_lp(None,rows,f,4,cost,raw)['rows_checked']==6
    rejected=[]
    def reject(label,fn):
        try:fn()
        except (AssertionError,ValueError,IndexError,KeyError):rejected.append(label)
        else:raise AssertionError(('accepted control corruption',label))
    reject('wrong_objective',lambda:parse_lp(None,rows,f,4,cost,raw.replace('obj: + 1 x2','obj: + 2 x2')))
    reject('wrong_error_sign',lambda:parse_lp(None,rows,f,4,cost,raw.replace('- 1 x3 =','+ 1 x3 =')))
    reject('missing_weight_bound',lambda:parse_lp(None,rows,f,4,cost,raw.replace('n1: - 1 x1 <= 0 ','')))
    reject('implicit_parent_bound',lambda:parse_lp(None,rows,f,4,cost,raw.replace('x0 free','0 <= x0')))
    bad=dict(pi);bad['parent']=0;reject('uncancelled_finite_parent_dual',lambda:exact_dual(rows,f,4,cost,bad,obj))
    bad=dict(pi);bad['n2']=2;reject('wrong_min_inequality_sign',lambda:exact_dual(rows,f,4,cost,bad,obj))
    reject('false_objective_equality',lambda:exact_dual(rows,f,4,cost,pi,Q(3,4)))
    badx=x.copy();badx[3]=-Q(1,2);reject('negative_error',lambda:check_primal(rows,f,badx,cost))
    if data is not None:
        c=copy.deepcopy(L['columns'][0]);c['indices'].pop();reject('physical127_column',lambda:physical_column(c,data))
        c=copy.deepcopy(L['columns'][0]);c['indices'][1]=c['indices'][0];reject('duplicate_physical_index',lambda:physical_column(c,data))
        c=copy.deepcopy(next(c for c in L['columns'] if c['mask']==0));absent=data['domains'][0][c['side']]['absent'][0];c['indices'][0]=absent
        reject('forced_absent_anchor_in_basis',lambda:physical_column(c,data))
        c=[b for b in L['columns'] if not (b['side']=='X' and b['mask']==15)]
        reject('missing_zero_seed_mass_domain',lambda:layout(c))
    return dict(exact_primal_dual_controls=2,streaming_lp_control=1,corruptions_rejected=rejected)

def main():
    guard();ap=argparse.ArgumentParser();ap.add_argument('--manifest',required=True);ap.add_argument('--output',required=True);a=ap.parse_args();start=time.monotonic()
    outpath=resolve(a.output);assert not outpath.exists();data,L,semantic=context(a.manifest)
    d=data['manifest'];N=L['variable_count'];cost=objective(L)
    text=parse_lp(d['lp'],expected_rows(data,L),data['f'],N,cost)
    assert text['rows_checked']==d['row_count'] and text['nonzeros_checked']==d['nonzeros']
    assert text['equalities_checked']==d['equalities'] and text['inequalities_checked']==d['inequalities']
    initial=seed_values(data,L);obj,rows,slack=check_primal(expected_rows(data,L),data['f'],initial,cost)
    assert rows==d['row_count'] and obj==Q(data['seed']['objective'])==Q(data['oldseed']['total_L1'])==Q(d['artificial_seed_L1'])>0
    tests=controls(data,L)
    out=dict(status='PASS_EXACT_SHARED_BASIS_PHASE_ONE_MODEL',manifest_sha256=sha(a.manifest),semantic_sha256=d['semantic_sha256'],
        lp_sha256=d['lp_sha256'],seed_sha256=d['seed_sha256'],consumer_sha256=sha(Path(__file__).name),point_sha256=d['point_sha256'],
        geometry_bank_sha256=d['geometry_bank_sha256'],source_hashes=d['source_hashes'],dependencies={p:sha(p) for p in DEPS},
        variables=N,physical_columns_checked=L['nB'],domain_blocks_checked=32,all_sixteen_patterns=True,zero_tau_pins=False,
        retained_parent_rows=98863,excluded_explicit_pin_rows=5,mass_rows=32,link_rows=23040,nonnegative_rows=L['nB']+46080,
        exact_seed_parent_strings=22513,exact_seed_rows_checked=rows,exact_seed_objective=str(obj),minimum_seed_inequality_slack=str(slack),
        literal_lp=text,controls=tests,solver_executed=False,shared_master_solved=False,full_basis_membership_claimed=False,
        source_C16_answered=False,nice=19,threads=1,elapsed_seconds=time.monotonic()-start,
        scope='Exact unrestricted-law restricted-master preparation and feasible positive-artificial-error start; no solve or full-hull obstruction.')
    outpath.parent.mkdir(parents=True,exist_ok=True);outpath.write_text(json.dumps(out,indent=2,sort_keys=True)+'\n')
    print(json.dumps({k:v for k,v in out.items() if k not in ('source_hashes','dependencies')}),flush=True)
if __name__=='__main__':main()
