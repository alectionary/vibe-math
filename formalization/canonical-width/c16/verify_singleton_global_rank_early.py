#!/usr/bin/env python3
"""Literal physical singleton endpoint replay; imports no discovery oracle."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS',
            'VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):os.environ[key]='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,copy,gzip,hashlib,json,time
from verify_algebraic_model import physical
from verify_full_partner_projection import point_data
from verify_singleton_exchange_terminal import rank

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def check(c,f,point,X,Z):
    assert c['status']=='GLOBAL_SINGLETON_EXACT_ORACLE_ENDPOINT_REQUIRES_REPLAY'
    assert c['point_sha256']==f['point_sha256']==sha(point)
    assert c['source_hashes']==f['source_hashes'] and all(sha(ROOT/p)==h for p,h in f['source_hashes'].items())
    k=c['anchor_orbit'];assert type(k)is int and 0<=k<45 and k==f['anchor_orbit']
    owner,target=point_data(point,k);p=owner[k];assert 0<p<1 and str(p)==c['conditional_probability']==f['conditional_probability']
    q=[v/(16*p) for v in target[55:]];assert list(map(Q,c['conditional_target']))==list(map(Q,f['conditional_target']))==q
    assert all(0<=v<=1 for v in q) and sum(q)==128
    E=[j for j in range(720) if (X[16*k]&Z[j]).bit_count()%2==0];U=sorted(set(range(720))-set(E))
    assert E==f['physical_zero_ground_indices'] and U==f['physical_unit_indices']
    assert [hex(Z[j]) for j in E]==f['vectors_hex'] and rank(Z[j] for j in E)==127
    assert sum(q[j] for j in E)==127 and sum(q[j] for j in U)==1
    x=[Q(0)]*720;seen=set();mass=Q(0)
    result=c['solver_endpoint'];D=int(result['denominator']);assert D>0 and result['rank']==127
    assert len(c['zero_bases'])==len(result['bases'])
    for b,local in zip(c['zero_bases'],result['bases']):
        J=b['indices'];w=Q(b['weight']);I=local['indices']
        assert I==sorted(set(I)) and all(type(i)is int and 0<=i<len(E) for i in I)
        assert J==sorted(E[i] for i in I) and J==sorted(set(J)) and len(J)==127
        assert tuple(J) not in seen and set(J)<=set(E) and rank(Z[j] for j in J)==127
        assert w==Q(int(local['weight_numerator']),D)>0;seen.add(tuple(J));mass+=w
        for j in J:x[j]+=w
    assert mass==1
    unit={}
    for b in c['unit_probabilities']:
        j=b['index'];w=Q(b['probability']);assert type(j)is int and j in U and j not in unit and 0<w<=1
        assert w==q[j];unit[j]=w;x[j]=w
    assert sum(unit.values())==1 and all(unit.get(j,0)==q[j] for j in U)
    assert [Q(int(v),D) for v in result['achieved_numerators']]==[x[j] for j in E]
    assert [Q(int(v),D) for v in result['target_numerators']]==[q[j] for j in E]
    residual=sum(abs(q[j]-x[j]) for j in range(720));status=result['status'];gap=None
    if status=='EXACT_BASE_MIXTURE':
        assert residual==0 and 'cut' not in c;accepted='PASS_EXACT_GLOBAL_SINGLETON_CONDITIONAL_BASIS_MEMBERSHIP'
    elif status=='EXACT_RANK_VIOLATION':
        cut=c['cut'];J=cut['indices'];assert J==sorted(set(J)) and J and all(type(j)is int and j in E for j in J)
        assert cut['sector']=='T' and cut['anchor_orbit']==k and cut['mandatory_index'] is None
        r=rank(Z[j] for j in J);assert r==cut['bound']==result['violated_rank']['rank']
        assert J==sorted(E[i] for i in result['violated_rank']['indices'])
        gap=p*(sum(q[j] for j in J)-r);assert gap>0 and gap==Q(cut['exact_violation'])
        assert gap/p==Q(result['violated_rank']['exact_violation'])
        accepted='PASS_EXACT_GLOBAL_SINGLETON_CONDITIONAL_RANK_CUT'
    else:
        assert status=='BOUNDED_PUSH_RELABEL_INCONCLUSIVE';accepted='PASS_EXACT_GLOBAL_SINGLETON_PARTIAL_STATE'
    return dict(status=accepted,zero_bases=len(seen),unit_probabilities=len(unit),exact_coordinates=720,
                exact_L1_residual=str(residual),exact_global_row_violation=str(gap) if gap is not None else None,
                all_rank_membership_proved=status=='EXACT_BASE_MIXTURE')

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic()
    c=read(a.certificate);fp=a.certificate.with_name(a.certificate.name.removesuffix('.json.gz')+'.frozen.json');f=read(fp)
    assert c['frozen_sha256']==sha(fp)
    tiny=read(ROOT/f['tiny_receipt']);assert tiny['producer_sha256']==f['solver_sha256']==sha(ROOT/'exact_matroid_push_relabel_early.py')
    assert tiny['status']=='PASS_EXACT_VERSIONED_PUSH_RELABEL_TINY_ENDPOINTS' and sha(ROOT/f['tiny_receipt'])==f['tiny_receipt_sha256']
    X,Z,_=physical();assert rank(X)==rank(Z)==128
    assert X==[int(v,16) for v in (ROOT/'pools/xcoords.txt').read_text().split()]
    assert Z==[int(v,16) for v in (ROOT/'pools/zcoords.txt').read_text().split()]
    out=check(c,f,a.point,X,Z);mutants=[]
    bad=copy.deepcopy(c);bad['point_sha256']='0'*64;mutants.append(('point',bad))
    bad=copy.deepcopy(c);bad['conditional_target'][0]=str(Q(bad['conditional_target'][0])+1);mutants.append(('target',bad))
    bad=copy.deepcopy(c);bad['zero_bases'][0]['weight']='-1';mutants.append(('negative_weight',bad))
    bad=copy.deepcopy(c);bad['zero_bases'][0]['indices'].pop();mutants.append(('nonbasis',bad))
    bad=copy.deepcopy(c);bad['unit_probabilities'][0]['probability']='-1';mutants.append(('negative_unit',bad))
    if 'cut' in c:
        bad=copy.deepcopy(c);bad['cut']['bound']-=1;mutants.append(('lower_rank',bad))
    rejected=[]
    for label,bad in mutants:
        try:check(bad,f,a.point,X,Z)
        except (AssertionError,ValueError,IndexError):rejected.append(label)
        else:raise AssertionError('accepted mutant '+label)
    out.update(certificate_sha256=sha(a.certificate),frozen_sha256=sha(fp),point_sha256=sha(a.point),
               anchor_orbit=c['anchor_orbit'],consumer_sha256=sha(__file__),source_hashes=f['source_hashes'],
               negative_controls_rejected=rejected,source_C16_answered=False,physical_full_frame=False,
               scope='Fresh selected-conditioned T law; phase-zero physical bases plus exact unit simplex. No absent/S law, joint-profile or source-frame membership.',
               elapsed_seconds=time.monotonic()-start)
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='source_hashes'}),flush=True)
if __name__=='__main__':main()
