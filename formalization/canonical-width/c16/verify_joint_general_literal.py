#!/usr/bin/env python3
"""Literal exact primal proof for a general shared-law joint allocation.

No symbolic elimination or optimizer module is imported. Conditional masses,
physical coordinates, all retained moments, supplied ranks and source-valid
owner-star rows are checked directly. A pinned law remains explicitly pinned.
"""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19, 'verified nice19 required'
for _k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    assert os.environ.get(_k)=='1'
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
import argparse,copy,gzip,hashlib,json,time
from verify_two_sided_full_basis_oracle import physical_source,domains,target,point_owner
from verify_two_basis_direct_allocation import check_allocation
from verify_conditional_owner_star_v2 import expression as star_expression,forbidden

ROOT=Path(__file__).resolve().parent
LOW=[0,1,2,4,8,3,5,9,6,10,12]
HIGH=[7,11,13,14,15]
def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def read(p):
    p=ROOT/p;b=p.read_bytes();return json.loads(gzip.decompress(b) if p.suffix=='.gz' else b)
def rational(v):
    assert type(v)is str
    q=Q(v);assert str(q)==v
    return q
def rank(vectors):
    piv={}
    for x in vectors:
        while x:
            p=x&-x
            if p in piv:x^=piv[p]
            else:piv[p]=x;break
    return len(piv)
def normalized_rank(r):return {k:r[k] for k in ('mask','forced_zero_indices','indices','contraction_rank')}
def rankkey(r):return r['mask'],tuple(r['forced_zero_indices']),tuple(r['indices']),r['contraction_rank']
def geometry(r,U,dd):
    m,F,S,rr=[r[k] for k in ('mask','forced_zero_indices','indices','contraction_rank')]
    assert type(m)is int and 0<=m<16 and type(rr)is int and rr>=0
    assert F==dd[m]['zero_forced'] and S==sorted(set(S))
    assert all(type(j)is int and 0<=j<720 for j in F+S)
    assert set(S)<=set(dd[m]['zero_free']) and rank(U[j] for j in F)==len(F)
    assert rank(U[j] for j in F+S)-len(F)==rr

def source_data(certificate,base_model,base_receipt):
    c=read(certificate);assert c['status']=='EXACT_GENERAL_JOINT_ALLOCATION_REQUIRES_REPLAY'
    manifest=read(c['manifest']);assert c['manifest_sha256']==sha(c['manifest'])
    assert manifest['status']=='PASS_EXACT_GENERAL_LP_FRACTION_TEXT_ROUNDTRIP'
    assert manifest['lp_sha256']==sha(manifest['lp'])
    assert manifest['semantic_sha256']==c['semantic_sha256']==sha(manifest['semantic'])
    saved=read(manifest['semantic']);M=saved['model']
    assert saved['status']=='EXACT_GENERAL_JOINT_LP_EXPORT_REQUIRE_REPLAY'
    assert type(saved['zero_tau_pins'])is bool and c['zero_tau_pins']==manifest['zero_tau_pins']==saved['zero_tau_pins']
    assert c['point_sha256']==saved['point_sha256']==M['point_sha256']==sha(c['point'])
    assert saved['point']==c['point']
    for p,h in {**M['source_hashes'],**c['source_bindings']}.items():assert sha(p)==h
    base=read(base_model);receipt=read(base_receipt)
    assert M['source_hashes'][str(base_model)]==sha(base_model)
    assert M['source_hashes'][str(base_receipt)]==sha(base_receipt)
    assert receipt['status']=='PASS_EXACT_GENERAL_SHARED_LAW_MODEL'
    assert receipt['model_sha256']==sha(base_model) and receipt['point_sha256']==c['point_sha256']
    assert receipt['consumer_sha256']==sha('verify_two_basis_joint_general.py')
    assert M['variables']==base['variables'] and M['equalities']==base['equalities']
    assert M['high_masks']==HIGH and M['structural_only_elimination'] is True and M['fixed_law_faces_used'] is False
    assert [M[k] for k in ('X_anchors','Z_anchors')]==[base[k] for k in ('X_anchors','Z_anchors')]
    X,Z,bridge=physical_source();dd=domains(X,Z,M['X_anchors'],M['Z_anchors'])
    assert all(d['feasible'] for d in dd)
    full=target(c['point'],M['X_anchors'],M['Z_anchors']);owner=point_owner(c['point'])
    assert list(map(rational,saved['feature_values']))==[Q(1),*owner]
    # Reconstruct the exact listed-rank cohort from the accepted base and additions.
    expected={s:list(base['sectors'][s]['rank_rows']) for s in ('X','Z')}
    for binding in M['additional_rank_bindings']:
        b,r=read(binding['bank']),read(binding['receipt'])
        assert binding['bank_sha256']==sha(binding['bank'])==r['bank_sha256']
        assert binding['receipt_sha256']==sha(binding['receipt'])
        assert r['status'] in ('PASS_EXACT_PHYSICAL_CONDITIONAL_CLOSED_RANK_ROWS','PASS_EXACT_PHYSICAL_CONDITIONAL_RANK_ROWS')
        assert [b[k] for k in ('X_anchors','Z_anchors')]==[M[k] for k in ('X_anchors','Z_anchors')]
        for p,h in b['source_hashes'].items():assert sha(p)==h
        side=b['side'];assert side in expected
        seen={(x['mask'],tuple(x['indices'])) for x in expected[side]};n=0
        for row in b['cuts']:
            geometry(row,X if side=='X' else Z,[d[side] for d in dd])
            key=row['mask'],tuple(row['indices'])
            if key not in seen:seen.add(key);expected[side].append(normalized_rank(row));n+=1
        assert n==binding['added_rows']
    for side,U in [('X',X),('Z',Z)]:
        assert expected[side]==M['sectors'][side]['rank_rows']
        for row in expected[side]:geometry(row,U,[d[side] for d in dd])
    stars=[]
    physical=dict(X=X,Z=Z,xa=M['X_anchors'],za=M['Z_anchors'])
    for bindex,binding in enumerate(M['star_bindings']):
        bank,checked=read(binding['bank']),read(binding['receipt'])
        assert sha(binding['bank'])==binding['bank_sha256']==checked['bank_sha256']
        assert sha(binding['receipt'])==binding['receipt_sha256']
        assert checked['status']=='PASS_EXACT_CONDITIONAL_OWNER_STAR_CUTS'
        assert binding['consumer'] in ('verify_conditional_owner_star.py','verify_conditional_owner_star_v2.py')
        assert checked['consumer_sha256']==binding['consumer_sha256']==sha(binding['consumer'])
        assert bank['source_hashes']==checked['source_hashes']
        for p,h in bank['source_hashes'].items():assert sha(p)==h
        assert [bank[k] for k in ('X_anchors','Z_anchors')]==[M[k] for k in ('X_anchors','Z_anchors')]
        assert checked['cuts_checked']==len(bank['cuts'])
        for index,cut in enumerate(bank['cuts']):
            sparse=source_star(physical,cut)
            stars.append(dict(binding=bindex,cut_index=index,coefficients=sparse))
    assert len(stars)==len(M['star_rows'])
    assert [(r['binding'],r['cut_index']) for r in stars]==[(r['binding'],r['cut_index']) for r in M['star_rows']]
    # Every literal inequality is represented exactly once, independently of ordering.
    kinds=Counter(d['kind'] for d in M['inequalities'])
    assert set(kinds)=={'lambda_nonnegative','box','rank','owner_star'}
    assert sorted(d['mask'] for d in M['inequalities'] if d['kind']=='lambda_nonnegative')==list(range(16))
    boxes=[(d['side'],d['mask'],d['index'],d['bound']) for d in M['inequalities'] if d['kind']=='box']
    assert len(boxes)==len(set(boxes))==2*16*720*2
    assert set(boxes)=={(s,m,j,k) for s in ('X','Z') for m in range(16) for j in range(720) for k in ('lower','upper')}
    rr=[(d['side'],d['rank_index']) for d in M['inequalities'] if d['kind']=='rank']
    assert len(rr)==len(set(rr)) and set(rr)=={(s,i) for s in expected for i in range(len(expected[s]))}
    assert sorted(d['star_index'] for d in M['inequalities'] if d['kind']=='owner_star')==list(range(len(stars)))
    labels=[dict(name=k+str(i),kind=k,index=i) for k in ('equalities','inequalities') for i in range(len(M[k]))]
    if saved['zero_tau_pins']:
        labels += [dict(name='zero_tau'+str(i),kind='zero_tau',index=i) for i,v in enumerate(M['variables']) if v['kind']=='tau']
    assert labels==saved['row_labels']
    assert manifest['row_count']==len(labels) and manifest['variable_count']==len(M['variables'])
    assert manifest['base_equalities']==len(M['equalities']) and manifest['inequalities']==len(M['inequalities'])
    return c,M,dd,full,owner,stars,manifest

def source_star(d,cut):
    side,i=cut['side'],cut['probe'];assert side in ('X','Z') and type(i)is int and 0<=i<720
    edges=lambda j:(i,j) if side=='X' else (j,i)
    near=[j for j in range(720) if (d['X'][edges(j)[0]]&d['Z'][edges(j)[1]]).bit_count()%2]
    proof=cut['proof'];assert proof['neighbors']==near
    lc,uc=proof['lower_choices'],proof['upper_choices']
    assert len(lc)==len(uc)==16 and all(len(row)==len(near) for row in lc+uc)
    for m in range(16):
        for k,j in enumerate(near):
            assert type(lc[m][k])is int and lc[m][k] in (0,1)
            assert uc[m][k] in ('X','Z','zero')
            if uc[m][k]=='zero':assert forbidden(d,m,*edges(j))
    actual=star_expression(d,cut,near,lc,uc);stored={}
    for name,arity in [('lambda',2),('X',3),('Z',3),('T',2)]:
        terms=cut[name+'_coefficients'];assert terms==sorted(terms)
        for t in terms:
            assert len(t)==arity and all(type(v)is int for v in t) and t[-1]
            key=(name,*t[:-1]);assert key not in stored;stored[key]=t[-1]
    assert stored==actual and type(cut['rhs'])is int and cut['rhs']==0
    return actual

def check_law(lam,full,pinned):
    assert len(lam)==16 and min(lam)>=0
    for k,S in enumerate(LOW):assert sum(lam[m] for m in range(16) if m&S==S)==full[k]
    high=[sum(lam[m] for m in range(16) if m&S==S) for S in HIGH]
    if pinned:assert high==[0]*5
    return high

def check_primal(c,M,dd,full,owner,stars):
    lam=list(map(rational,c['lambda_masses']));high=check_law(lam,full,c['zero_tau_pins'])
    assert set(c['exact_allocations'])=={'X','Z'}
    Y={s:[list(map(rational,row)) for row in c['exact_allocations'][s]] for s in ('X','Z')}
    checks={};slacks=[]
    for side in ('X','Z'):
        off=720*int(side=='Z');b=full[11+off:731+off]+[full[1451+1440*i+off+j] for i in range(4) for j in range(720)]
        checks[side]=check_allocation(Y[side],lam,[d[side] for d in dd],b)
        for r in M['sectors'][side]['rank_rows']:
            gap=r['contraction_rank']*lam[r['mask']]-sum(Y[side][r['mask']][j] for j in r['indices'])
            assert gap>=0;slacks.append(gap)
    star_slacks=[]
    for row in stars:
        value=Q(0)
        for key,v in row['coefficients'].items():
            q=lam[key[1]] if key[0]=='lambda' else owner[key[1]] if key[0]=='T' else Y[key[0]][key[1]][key[2]]
            value+=v*q
        assert value<=0;star_slacks.append(-value)
    params=list(map(rational,c['exact_parameters']));assert len(params)==len(M['variables'])
    wanted=[]
    for v in M['variables']:
        if v['kind']=='tau':wanted.append(high[HIGH.index(v['mask'])])
        else:
            assert v['kind']=='allocation';wanted.append(Y[v['side']][v['mask']][v['index']])
    assert params==wanted
    # These mutants exercise the literal checker rather than an eliminated row.
    rejected=[]
    bad=list(lam);bad[0]+=Q(1,1<<60)
    try:check_law(bad,full,c['zero_tau_pins'])
    except AssertionError:rejected.append('changed-common-law')
    else:raise AssertionError('accepted changed law')
    off=0;b=full[11:731]+[full[1451+1440*i+j] for i in range(4) for j in range(720)]
    for label,change in [('negative-coordinate',lambda y:y[0].__setitem__(0,Q(-1))),('changed-marginal',lambda y:y[0].__setitem__(0,y[0][0]+Q(1,1<<60))),('selected-anchor',lambda y:y[15].__setitem__(M['X_anchors'][0],Q(1)))]:
        bad=[list(row) for row in Y['X']];change(bad)
        try:check_allocation(bad,lam,[d['X'] for d in dd],b)
        except AssertionError:rejected.append(label)
        else:raise AssertionError(('accepted mutant',label))
    return dict(checks=checks,anchor_moment_equalities=11,shared_high_moments=list(map(str,high)),
                rank_rows_checked=len(slacks),star_rows_checked=len(star_slacks),
                minimum_listed_rank_slack=str(min(slacks)),minimum_star_slack=str(min(star_slacks)),
                literal_parameters_checked=len(params),corruptions_rejected=rejected)

def main():
    p=argparse.ArgumentParser();p.add_argument('--certificate',type=Path,required=True)
    p.add_argument('--base-model',type=Path,default=Path('two-basis-results/two-basis-joint-general-point22.json.gz'))
    p.add_argument('--base-receipt',type=Path,default=Path('two-basis-results/two-basis-joint-general-point22-independent.json'))
    p.add_argument('--output',type=Path,required=True);a=p.parse_args();assert not a.output.exists();t=time.monotonic()
    c,M,dd,full,owner,stars,manifest=source_data(a.certificate,a.base_model,a.base_receipt)
    checks=check_primal(c,M,dd,full,owner,stars)
    out=dict(status='PASS_EXACT_LITERAL_GENERAL_JOINT_ALLOCATION',certificate_sha256=sha(a.certificate),
             manifest_sha256=c['manifest_sha256'],semantic_sha256=c['semantic_sha256'],point_sha256=c['point_sha256'],
             consumer_sha256=sha(Path(__file__).name),base_receipt_sha256=sha(a.base_receipt),
             source_hashes=M['source_hashes'],dependencies={p:sha(p) for p in ('verify_two_sided_full_basis_oracle.py','verify_two_basis_direct_allocation.py','verify_conditional_owner_star_v2.py')},
             zero_tau_pins=c['zero_tau_pins'],all_sixteen_patterns_checked=True,
             symbolic_elimination_used_for_primal_acceptance=False,**checks,
             all_subset_rank_membership_proved=False,all_owner_stars_satisfied=False,
             listed_star_rows_satisfied=True,source_C16_answered=False,global_target_exclusion_proved=False,
             scope='Exact feasible allocation for the listed finite physical-rank and owner-star relaxation; '+('the chosen zero-high law is pinned.' if c['zero_tau_pins'] else 'the five higher moments are unrestricted.'),
             priority=19,elapsed_seconds=time.monotonic()-t)
    a.output.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n')
    print(json.dumps({k:v for k,v in out.items() if k not in ('source_hashes','dependencies')}),flush=True)

if __name__=='__main__':main()
