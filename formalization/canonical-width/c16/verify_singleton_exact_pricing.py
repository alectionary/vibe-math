#!/usr/bin/env python3
"""Independent exact physical pricing of a restricted-archive Farkas ray."""
from fractions import Fraction as Q
from itertools import combinations
from pathlib import Path
import argparse,copy,gzip,hashlib,json,os,time

ROOT=Path(__file__).resolve().parent
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
def guard():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    assert all(os.environ.get(k)=='1' for k in THREADS)
def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def read(p):
    b=(ROOT/p).read_bytes();return json.loads(gzip.decompress(b) if str(p).endswith('.gz') else b)
def rank(v):
    rows={}
    for x in v:
        while x:
            k=x&-x
            if k in rows:x^=rows[k]
            else:rows[k]=x;break
    return len(rows)
def bound(vectors,ground,weights):
    order=sorted(ground,key=lambda j:(weights[j],j));rows={};ranks=[]
    for j in order:
        x=vectors[j]
        while x:
            k=x&-x
            if k in rows:x^=rows[k]
            else:rows[k]=x;break
        ranks.append(len(rows))
    value=weights[order[-1]]*ranks[-1]+sum(((weights[order[i]]-weights[order[i+1]])*ranks[i] for i in range(len(order)-1)),Q(0))
    return value,order,ranks
def indices(J,n):
    assert J==sorted(set(J)) and all(type(j)is int and 0<=j<n for j in J)
    return J

def check(c,m,s,r,X,Z,p,q):
    assert c['status']=='EXACT_SINGLETON_ARCHIVE_FARKAS_PRICING_DIAGNOSTIC'
    k=s['anchor_orbit'];E=[j for j in range(720) if (X[16*k]&Z[j]).bit_count()%2==0]
    assert E==s['physical_zero_ground_indices'] and rank(Z[j] for j in E)==127
    assert all(0<=x<=1 for x in q) and sum(q[j] for j in E)==127
    assert sum(q[j] for j in range(720) if j not in set(E))==1
    mult={name:Q(v) for name,v in r['proof']['multipliers'].items()}
    valid={'mass',*('q'+str(j) for j in E),*('n'+str(i) for i in range(len(s['physical_bases'])))}
    assert set(mult)<=valid
    u=mult.get('mass',Q(0));v={j:mult.get('q'+str(j),Q(0)) for j in E}
    # Independently recheck the exact archive ray, including its inequality sign.
    for i,B in enumerate(s['physical_bases']):
        n=mult.get('n'+str(i),Q(0));assert n>=0 and u+sum((v[j] for j in B),Q(0))==n
    target=u+sum((v[j]*q[j] for j in E),Q(0))
    assert target==-Q(r['proof']['exact_gap'])<0
    assert c['anchor_orbit']==k and c['point_sha256']==s['point_sha256']
    assert Q(c['constant'])==u and c['weights']==[[j,str(v[j])] for j in E if v[j]]
    assert Q(c['target_affine_value'])==target
    minimum,order,ranks=bound(Z,E,v);assert ranks[-1]==127
    B=indices(c['minimizing_physical_basis'],720)
    assert len(B)==127 and set(B)<=set(E) and rank(Z[j] for j in B)==127
    assert sum((v[j] for j in B),Q(0))==minimum==Q(c['minimum_physical_basis_weight'])
    reduced=u+minimum;assert Q(c['minimum_affine_value'])==reduced
    assert c['independent_prefix_rank_checks']==len(E) and c['exact_minimum_verified'] is True
    assert c['missing_archive_column']==(reduced<0)
    prefix=None;mass=Q(0)
    for i,j in enumerate(order):
        mass+=q[j]
        if mass>ranks[i]:prefix=(sorted(order[:i+1]),ranks[i],mass-ranks[i]);break
    cut=c['global_rank_cut_candidate']
    if reduced<0:
        assert cut is None and tuple(B) not in {tuple(J) for J in s['physical_bases']}
        result='MISSING_PHYSICAL_ARCHIVE_COLUMN'
    else:
        assert prefix is not None and cut is not None
        J,rr,gap=prefix
        assert cut['sector']=='T' and cut['anchor_orbit']==k and cut['mandatory_index'] is None
        assert indices(cut['indices'],720)==J and rank(Z[j] for j in J)==cut['bound']==rr
        assert p*gap==Q(cut['exact_violation'])>0
        result='GLOBAL_SINGLETON_CONDITIONAL_RANK_CUT'
    return dict(pricing_result=result,minimum_affine_value=str(reduced),target_affine_value=str(target),
                source_bases_priced='all physical zero-pool bases, including signed weights',
                prefix_ranks_checked=len(E),archive_columns_checked=len(s['physical_bases']),
                physical_minimizer_size=len(B),global_rank_cut=cut,source_C16_answered=False)

def tiny_controls():
    vectors=[0,1,1,2,3];R=rank(vectors);bases=[B for B in combinations(range(5),R) if rank(vectors[j] for j in B)==R]
    weights=[[0]*5,[-3,-2,-1,-4,-5],[7,-1,2,-3,4],[Q(1,3),Q(-2,5),Q(1,7),Q(2,3),Q(-4,7)],[4,4,4,4,4]]
    for w in weights:
        val,_,_=bound(vectors,list(range(5)),w)
        assert val==min(sum(w[j] for j in B) for B in bases)
    # A negative target value with nonnegative minimum affine basis value forces
    # a rank-deficient prefix. A missing archive column has the opposite sign.
    v=[1,2,3];w=[Q(-1),Q(0),Q(0)];minimum,order,ranks=bound(v,[0,1,2],w)
    q=[Q(3,2),Q(1,2),Q(0)];u=Q(1)
    assert u+minimum==0 and u+sum(x*y for x,y in zip(w,q))==Q(-1,2)
    assert q[order[0]]>ranks[0]
    assert Q(0)+minimum<0
    return dict(exhaustive_signed_weight_cohorts=len(weights),literal_bases=len(bases),prefix_cut_control=True,missing_column_sign_control=True)

def main():
    guard();start=time.monotonic()
    from verify_algebraic_model import physical
    from verify_full_partner_projection import point_data
    ap=argparse.ArgumentParser()
    for name in ('pricing','output'):ap.add_argument('--'+name,required=True)
    for name in ('manifest','farkas-receipt'):ap.add_argument('--'+name)
    ap.add_argument('--archive-consumer',default='verify_singleton_archive_cg.py')
    ap.add_argument('--pricing-producer',default='price_singleton_archive_cg.py')
    a=ap.parse_args();c=read(a.pricing)
    a.manifest=a.manifest or c['manifest'];a.farkas_receipt=a.farkas_receipt or c['farkas_receipt']
    m=read(a.manifest);s=read(m['semantic']);r=read(a.farkas_receipt)
    assert m['status']=='EXACT_SINGLETON_ARCHIVE_LP_REQUIRES_TEXT_REPLAY'
    assert r['status']=='PASS_EXACT_RESTRICTED_SINGLETON_ARCHIVE_INFEASIBILITY'
    assert c['manifest_sha256']==r['manifest_sha256']==sha(a.manifest)
    assert c['farkas_receipt_sha256']==sha(a.farkas_receipt)
    assert c['manifest']==a.manifest and c['farkas_receipt']==a.farkas_receipt
    assert sha(m['semantic'])==m['semantic_sha256']==r['semantic_sha256']
    assert sha(m['lp'])==m['lp_sha256']==r['lp_sha256']
    assert r['consumer_sha256']==sha(a.archive_consumer) and c['producer_sha256']==sha(a.pricing_producer)
    assert c['source_hashes']==s['source_hashes']==r['source_hashes']
    for path,h in s['source_hashes'].items():assert sha(path)==h
    X,Z,_=physical();assert len(X)==len(Z)==720 and rank(X)==rank(Z)==128
    k=s['anchor_orbit'];assert type(k)is int and 0<=k<45
    owner,target=point_data(s['point'],k);p=owner[k];assert 0<p<1 and Q(s['conditional_probability'])==p
    q=[v/(16*p) for v in target[55:]]
    assert sha(s['point'])==s['point_sha256']==r['point_sha256'] and list(map(Q,s['conditional_target']))==q
    out=check(c,m,s,r,X,Z,p,q);controls=tiny_controls();rejected=[]
    for label in ('wrong_minimum','nonbasis','wrong_target_sign','wrong_outcome'):
        bad=copy.deepcopy(c)
        if label=='wrong_minimum':bad['minimum_physical_basis_weight']=str(Q(bad['minimum_physical_basis_weight'])+1)
        elif label=='nonbasis':bad['minimizing_physical_basis'].pop()
        elif label=='wrong_target_sign':bad['target_affine_value']=str(-Q(bad['target_affine_value']))
        else:bad['missing_archive_column']=not bad['missing_archive_column']
        try:check(bad,m,s,r,X,Z,p,q)
        except (AssertionError,IndexError,ValueError,KeyError):rejected.append(label)
        else:raise AssertionError(('accepted mutation',label))
    out.update(status='PASS_EXACT_SINGLETON_PHYSICAL_BASIS_PRICING',manifest_sha256=sha(a.manifest),
               pricing_sha256=sha(a.pricing),farkas_receipt_sha256=sha(a.farkas_receipt),
               missing_archive_column=c['missing_archive_column'],global_rank_cut_candidate=c['global_rank_cut_candidate'] is not None,
               point_sha256=s['point_sha256'],anchor_orbit=k,consumer_sha256=sha(Path(__file__).name),
               tiny_controls=controls,corruptions_rejected=rejected,
               source_hashes={**s['source_hashes'],a.manifest:sha(a.manifest),a.farkas_receipt:sha(a.farkas_receipt),
                              a.pricing:sha(a.pricing),a.archive_consumer:sha(a.archive_consumer),
                              a.pricing_producer:sha(a.pricing_producer),Path(__file__).name:sha(Path(__file__).name)},
               elapsed_seconds=time.monotonic()-start,priority=19,
               scope='Exact physical support of one restricted-archive dual. Only a verified nonnegative global basis minimum plus a strict target gap proves a global conditional-rank cut.')
    path=ROOT/a.output;assert not path.exists();path.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n')
    print(json.dumps({k:v for k,v in out.items() if k!='source_hashes'},sort_keys=True))
if __name__=='__main__':main()
