#!/usr/bin/env python3
"""Accept old indices as fresh physical geometry, never old weights/targets."""
from fractions import Fraction as Q
from pathlib import Path
import argparse,copy,gzip,hashlib,json,os,time

ROOT=Path(__file__).resolve().parent
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
def guard():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    assert all(os.environ.get(k)=='1' for k in THREADS)
def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def read(p):
    p=ROOT/p;b=p.read_bytes();return json.loads(gzip.decompress(b) if p.suffix=='.gz' else b)
def rank(vs):
    rows={}
    for v in vs:
        while v:
            k=v&-v
            if k in rows:v^=rows[k]
            else:rows[k]=v;break
    return len(rows)
def geometry_only(d):
    # The only fields read from an old record are basis indices and provenance.
    return [('numerical_basis_archive',i,J) for i,J in enumerate(d.get('numerical_basis_archive',[]))]+[
        ('zero_bases',i,r['indices']) for i,r in enumerate(d.get('zero_bases',[]))]

def check(c,X,Z,owner,target):
    assert c['status']=='GEOMETRY_SEED' and c['seed_kind']=='LEGACY_PHYSICAL_COLUMNS_ONLY'
    for p,h in c['source_hashes'].items():assert sha(p)==h
    assert c['point_sha256']==sha(c['point'])
    k=c['anchor_orbit'];assert type(k)is int and 0<=k<45
    p=owner[k];q=[v/(16*p) for v in target[55:]]
    assert 0<p<1 and Q(c['conditional_probability'])==p and list(map(Q,c['conditional_target']))==q
    assert all(0<=v<=1 for v in q) and sum(q)==128
    E=[j for j in range(720) if (X[16*k]&Z[j]).bit_count()%2==0];EE=set(E);U=set(range(720))-EE
    assert c['physical_zero_ground_indices']==E and rank(Z[j] for j in E)==127
    assert sum(q[j] for j in E)==127 and sum(q[j] for j in U)==1
    B=[];origins=[];lookup={};records=0
    for source in c['legacy_sources']:
        assert sha(source['path'])==source['sha256']==c['source_hashes'][source['path']]
        d=read(source['path']);assert source['declared_anchor_orbit']==d['anchor_orbit']==k
        assert source['legacy_status']==d['status'];cols=geometry_only(d);assert len(cols)==source['columns_seen']
        for field,index,J in cols:
            assert J==sorted(set(J)) and len(J)==127 and all(type(j)is int and j in EE for j in J)
            key=tuple(J);origin=dict(path=source['path'],field=field,index=index);records+=1
            if key not in lookup:
                assert rank(Z[j] for j in J)==127;lookup[key]=len(B);B.append(J);origins.append([])
            origins[lookup[key]].append(origin)
    assert 1<=len(B)<=5000 and B==c['physical_bases'] and origins==c['column_origins'] and len(B)==c['variable_count']
    expected=[dict(index=j,probability=str(q[j])) for j in sorted(U) if q[j]]
    assert expected==c['unit_probabilities']
    assert c['old_weights_used'] is c['old_target_claims_used'] is c['current_point_membership_claimed'] is c['discovery_solver_launched'] is False
    assert c['exact_current_target_rebuilt'] is True
    assert not any(key in c for key in ('zero_bases','mixture_weights','achieved_numerators','exact_L1_residual'))
    union=set().union(*map(set,B));intersection=set(B[0]).intersection(*map(set,B[1:]))
    missing=[j for j in E if q[j]>0 and j not in union]
    universal_nonunit=[j for j in sorted(intersection) if q[j]<1]
    return dict(anchor_orbit=k,physical_bases_checked=len(B),legacy_geometry_records_checked=records,
                annihilator_size=len(E),annihilator_rank=127,fresh_coordinates_checked=720,
                fresh_unit_probabilities=len(expected),old_weights_or_target_used=False,
                missing_positive_zero_coordinates=missing,archive_universal_nonunit_coordinates=universal_nonunit,
                archive_union_size=len(union),archive_intersection_size=len(intersection),
                fresh_target_membership_proved=False,source_C16_answered=False)

def main():
    guard();start=time.monotonic()
    from verify_algebraic_model import physical
    from verify_full_partner_projection import point_data
    ap=argparse.ArgumentParser();ap.add_argument('--seed',required=True);ap.add_argument('--output',required=True);a=ap.parse_args()
    c=read(a.seed);X,Z,_=physical();assert rank(X)==rank(Z)==128 and len(X)==len(Z)==720
    owner,target=point_data(c['point'],c['anchor_orbit']);out=check(c,X,Z,owner,target);badlabels=[]
    for label in ('wrong_point','changed_fresh_target','nonbasis','duplicate_basis','changed_unit','old_weights_claim'):
        bad=copy.deepcopy(c)
        if label=='wrong_point':bad['point_sha256']='0'*64
        elif label=='changed_fresh_target':bad['conditional_target'][0]=str(Q(bad['conditional_target'][0])+1)
        elif label=='nonbasis':bad['physical_bases'][0].pop()
        elif label=='duplicate_basis':bad['physical_bases'][1]=bad['physical_bases'][0]
        elif label=='changed_unit':bad['unit_probabilities'][0]['probability']='-1'
        else:bad['old_weights_used']=True
        try:check(bad,X,Z,owner,target)
        except (AssertionError,ValueError,KeyError,IndexError):badlabels.append(label)
        else:raise AssertionError(('accepted corruption',label))
    # Literal control: all old weights and conditional targets can be nonsense
    # without affecting extraction of the geometry actually accepted above.
    discarded=[]
    for source in c['legacy_sources']:
        d=read(source['path']);before=geometry_only(d);bad=copy.deepcopy(d)
        for row in bad.get('zero_bases',[]):row['weight']='NOT_A_PROBABILITY'
        bad['conditional_target']='DISCARDED_OLD_POINT';bad['conditional_probability']='DISCARDED_OLD_MASS'
        assert geometry_only(bad)==before;discarded.append(source['path'])
    out.update(status='PASS_EXACT_SINGLETON_GEOMETRY_SEED',seed_sha256=sha(a.seed),point_sha256=c['point_sha256'],
               consumer_sha256=sha(Path(__file__).name),corruptions_rejected=badlabels,discarded_field_controls=discarded,
               source_hashes={**c['source_hashes'],a.seed:sha(a.seed),Path(__file__).name:sha(Path(__file__).name),
                              'verify_algebraic_model.py':sha('verify_algebraic_model.py'),'verify_full_partner_projection.py':sha('verify_full_partner_projection.py')},
               elapsed_seconds=time.monotonic()-start,priority=19,
               scope='Only this seed geometry is accepted. Fresh point target/unit law is reconstructed; no old membership, weights, or source conclusion transfers.')
    path=ROOT/a.output;assert not path.exists();path.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='source_hashes'},sort_keys=True))
if __name__=='__main__':main()
