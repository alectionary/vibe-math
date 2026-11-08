"""Independent exact source-row witness replay for actual pattern-local bounds.

No probability-bound producer import and no optimization or matroid query.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse
import copy
import json
import time
from verify_shared_master_common import guard,resolve,sha,read,bindings
from verify_shared_master_preparation import context


def add(a,b,c=Q(1)):
    out=(dict(a[0]),dict(a[1]))
    for k in (0,1):
        for j,v in b[k].items():
            t=out[k].get(j,Q(0))+c*v
            if t:out[k][j]=t
            else:out[k].pop(j,None)
    return out


def variable(j,v=1):return ({},{j:Q(v)})


def combination(witness,rows):
    out=({},{})
    assert witness and len({name for name,c in witness})==len(witness)
    for name,c in witness:
        assert type(c)is int and c>0
        expression,relation=rows[name]
        assert relation=='<=','Bound witness must use nonnegative inequality combination'
        out=add(out,expression,Q(c))
    return out


def check_bound(record,metadata,M,rows):
    j,m=record['variable'],record['mask'];want=metadata[j]
    assert type(j)is int and type(m)is int and 0<=m<16
    assert record['kind']==want['kind'] and m==want['mask']
    if want['kind']=='conditional_same_sector_pair':assert record['side']==want['side']
    assert combination(record['lower'],rows)==variable(j,-1)
    assert combination(record['upper'],rows)==add(variable(j),M['lambda_expressions'][m],Q(-1))


def main():
    guard();ap=argparse.ArgumentParser();ap.add_argument('--certificate',required=True);ap.add_argument('--output',required=True)
    a=ap.parse_args();start=time.monotonic();out=resolve(a.output);assert not out.exists();c=read(a.certificate)
    assert c['status']=='EXACT_SHARED_MASTER_PATTERN_PROBABILITY_BOUNDS_REQUIRES_REPLAY'
    assert sha(c['manifest'])==c['manifest_sha256'] and sha(c['preparation'])==c['preparation_sha256']
    bindings(c['source_hashes']);data,L,semantic=context(c['manifest'],c['preparation'],check_columns=False)
    M=data['M'];assert len(M['variables'])==22481
    assert c['point_sha256']==data['manifest']['point_sha256'] and c['semantic_sha256']==data['manifest']['semantic_sha256']
    assert c['full_parent_variables']==22513 and c['bounded_variables']==22508 and c['tau_variables']==5
    assert c['all16_patterns'] is True and c['zero_tau_pins'] is False
    metadata=list(M['variables'])+[dict(kind='conditional_same_sector_pair',mask=m,side=s) for m in range(16) for s in 'XZ']
    rows={name:(e,rel) for name,e,rel in data['parent_rows']};assert len(rows)==98863
    records=c['bounds'];assert len(records)==22508 and [r['variable'] for r in records]==list(range(5,22513))
    for record in records:check_bound(record,metadata,M,rows)
    counts={k:sum(r['kind']==k for r in records) for k in ('allocation','owner_joint','conditional_same_sector_pair')}
    assert counts==c['kind_counts']==dict(allocation=13388,owner_joint=9088,conditional_same_sector_pair=32)
    total=({},{})
    for e in M['lambda_expressions']:total=add(total,e)
    assert total==({0:Q(1)},{})
    high=[7,11,13,14,15]
    expected=[dict(variable=i,mask=h,pattern_masks=[m for m in range(16) if m&h==h]) for i,h in enumerate(high)]
    assert c['tau_superset_identities']==expected
    for i,h in enumerate(high):
        assert metadata[i]['kind']=='tau' and metadata[i]['mask']==h
        expr=({},{})
        for m in expected[i]['pattern_masks']:expr=add(expr,M['lambda_expressions'][m])
        assert expr==variable(i)
    # Elementary signed bound controls include zero lambda and both tight ends.
    tiny=0
    for mass in (Q(0),Q(1,7),Q(1,2),Q(1)):
        for fraction in (Q(0),Q(1,3),Q(1)):
            for coefficient in (Q(-11,5),Q(-1),Q(0),Q(2,7),Q(3)):
                v=mass*fraction
                assert coefficient*v>=min(Q(0),coefficient)*mass>=min(Q(0),coefficient)
                tiny+=1
    rejected=[]
    def reject(label,fn):
        try:fn()
        except (AssertionError,KeyError,IndexError):rejected.append(label)
        else:raise AssertionError(('accepted corrupted bound',label))
    bad=copy.deepcopy(records[-1]);bad['upper']=bad['upper'][:-1]
    reject('missing_K22_upper_box',lambda:check_bound(bad,metadata,M,rows))
    bad=copy.deepcopy(records[0]);bad['mask']=(bad['mask']+1)%16
    reject('wrong_pattern',lambda:check_bound(bad,metadata,M,rows))
    bad=copy.deepcopy(records[0]);bad['variable']+=1
    reject('wrong_variable',lambda:check_bound(bad,metadata,M,rows))
    bad=copy.deepcopy(records[-1]);bad['upper'][0][1]=-1
    reject('negative_row_multiplier',lambda:check_bound(bad,metadata,M,rows))
    wrong=({},{})
    for m in (7,):wrong=add(wrong,M['lambda_expressions'][m])
    def wrong_tau():assert wrong==variable(0)
    reject('tau_as_exact_atom',wrong_tau)
    def wrong_coverage():assert [r['variable'] for r in records[:-1]]==list(range(5,22513))
    reject('missing_K22_variable',wrong_coverage)
    eqname=next(name for name,(e,rel) in rows.items() if rel=='=')
    reject('equality_misused_as_positive_bound',lambda:combination([[eqname,1]],rows))
    result=dict(status='PASS_EXACT_SHARED_MASTER_PATTERN_LOCAL_PROBABILITY_BOUNDS',certificate_sha256=sha(a.certificate),
                consumer_sha256=sha(Path(__file__).name),manifest_sha256=c['manifest_sha256'],point_sha256=c['point_sha256'],
                source_hashes=c['source_hashes'],dependencies={p:sha(p) for p in ('verify_shared_master_common.py','verify_shared_master_preparation.py')},
                finite_variables_covered=22508,lower_row_witnesses=22508,upper_row_witnesses=22508,kind_counts=counts,
                exact_tau_superset_identities=5,exact_lambda_total_identities=1,signed_probability_tiny_controls=tiny,
                rejected_mutants=rejected,zero_tau_pins=False,
                source_valid_pattern_residual_formula='r*v>=min(0,r)*lambda_mask',
                scope='Bounds/projection preparation only; no fallback source combination, optimization or new source exclusion.',
                source_C16_answered=False,elapsed_seconds=time.monotonic()-start,nice=19,threads=1)
    out.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ('source_hashes','dependencies')}))


if __name__=='__main__':main()
