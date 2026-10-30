#!/usr/bin/env python3
"""Literal independent Boolean row and accepted-allocation gap replay; no solver."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,copy,gzip,hashlib,json,os,time
ROOT=Path(__file__).resolve().parent
POINT='coupling-results/two-basis-integer-witness22-rational.json.gz'
CERT='two-basis-results/joint-owner-capacity-zero-face-point22-exact.json'
RECEIPT='two-basis-results/joint-owner-capacity-zero-face-point22-exact-independent.json'
XIDS=(614,281);ZIDS=(51,83)
FIELDS=('lambda_coefficients','yX_coefficients','yZ_coefficients','t_coefficients','owner_coefficients')
def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def read(p):
    raw=(ROOT/p).read_bytes();return json.loads(gzip.decompress(raw) if str(p).endswith('.gz') else raw)
def same_pair_value(point,a,b):
    # Independently index the packed S blocks; h=0,8 store only i<=j.
    i,t=divmod(a,16);j,u=divmod(b,16);h=(u-t)%16
    if h>=9:i,j,h=j,i,16-h
    if h in (0,8):i,j=sorted((i,j))
    packed=45+sum(1035 if k in (0,8) else 2025 for k in range(h))
    packed+=(45*i-i*(i-1)//2+j-i) if h in (0,8) else 45*i+j
    owner=45+2025*h+45*i+j
    return Q(point['values'][packed]),owner,dict(phase_distance=h,first_orbit=i,second_orbit=j,packed_index=packed,owner_index=owner)
def truth(row,owner_index):
    maximum=None;maximizer=None;checked=0
    for m in range(16):
        for bits in range(16):
            x={j:(bits>>i)&1 for i,j in enumerate(XIDS)}
            z={j:(bits>>(i+2))&1 for i,j in enumerate(ZIDS)}
            lhs=sum(w*(n==m) for n,w in row['lambda_coefficients'])
            lhs+=sum(w*(n==m)*x[j] for n,j,w in row['yX_coefficients'])
            lhs+=sum(w*(n==m)*z[j] for n,j,w in row['yZ_coefficients'])
            lhs+=sum(w*(n==m)*x[i]*z[j] for n,i,j,w in row['t_coefficients'])
            for j,w in row['owner_coefficients']:
                assert j==owner_index;lhs+=w*x[XIDS[0]]*x[XIDS[1]]
            lhs-=row['rhs'];checked+=1
            if maximum is None or lhs>maximum:maximum=lhs;maximizer=dict(mask=m,bits=bits)
    return maximum,checked,maximizer
def context(bank):
    for p,h in bank['source_hashes'].items():assert sha(p)==h
    assert bank['point_sha256']==sha(POINT) and bank['allocation_sha256']==sha(CERT)
    c=read(CERT);r=read(RECEIPT)
    assert r['status']=='PASS_EXACT_LITERAL_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION'
    assert r['consumer_sha256']==sha('verify_owner_capacity_joint_literal.py')
    assert r['certificate_sha256']==sha(CERT) and c['point_sha256']==r['point_sha256']==sha(POINT)
    assert c['manifest_sha256']==r['manifest_sha256']==sha(c['manifest'])
    assert c['semantic_sha256']==r['model_sha256']==sha(c['semantic'])
    assert c['preparation_receipt_sha256']==r['preparation_receipt_sha256']==sha(c['preparation_receipt'])
    for table in (r['source_hashes'],r['dependencies'],c['source_bindings']):
        for p,h in table.items():assert sha(p)==h
    model=read(c['semantic']);assert model['point_sha256']==sha(POINT)
    meta=model['model']['owner_flow_extension']
    from verify_algebraic_model import physical
    X,Z,_=physical()
    expected=sorted({(i,j) for i in XIDS for j in range(720) if (X[i]&Z[j]).bit_count()%2}
                   |{(i,j) for j in ZIDS for i in range(720) if (X[i]&Z[j]).bit_count()%2})
    assert meta['physical_pairs']==[list(p) for p in expected]
    assert meta['base_variable_count']==13393 and len(expected)==568
    assert all((X[i]&Z[j]).bit_count()%2 for i in XIDS for j in ZIDS)
    params=c['exact_parameters'];assert len(params)==13393+16*len(expected)
    pairs={p:i for i,p in enumerate(expected)}
    def t(m,i,j):return Q(params[13393+len(expected)*m+pairs[i,j]])
    Y=c['exact_allocations'];assert all(len(Y[s])==16 and all(len(row)==720 for row in Y[s]) for s in 'XZ')
    lam=list(map(Q,c['lambda_masses']));assert len(lam)==16 and min(lam)>=0 and sum(lam)==1
    s,owner,coord=same_pair_value(read(POINT),*XIDS);assert owner==7847 and coord['packed_index']==6857
    def y(side,m,j):return Q(Y[side][m][j])
    for m in range(16):
        for i in XIDS:
            assert 0<=y('X',m,i)<=lam[m]
            for j in ZIDS:
                assert 0<=y('Z',m,j)<=lam[m]
                assert max(Q(0),y('X',m,i)+y('Z',m,j)-lam[m])<=t(m,i,j)<=min(y('X',m,i),y('Z',m,j))
    return c,lam,y,t,s,owner,coord
def replay(bank,data):
    c,lam,y,t,s,owner,coord=data
    assert bank['status']=='EXACT_CONDITIONAL_BOOLEAN_UNION_CUT_CANDIDATE' and len(bank['cuts'])==1
    assert bank['point_sha256']==sha(POINT) and bank['allocation_sha256']==sha(CERT)
    assert bank['global_moment_point_excluded'] is False and bank['source_C16_answered'] is False
    assert bank['provided_allocation_excluded'] is True
    row=bank['cuts'][0];active=[]
    for m in range(16):
        candidates=[(y('X',m,614)+y('X',m,281)+y('Z',m,z)-lam[m]-t(m,614,z)-t(m,281,z),z) for z in ZIDS]
        value,z=max(candidates,key=lambda v:(v[0],-v[1]))
        if value>0:active.append(dict(mask=m,Z_index=z,lower_bound=str(value)))
    assert [(v['mask'],v['Z_index']) for v in active]==[(2,51),(9,51)] and row['active_choices']==active
    expected=dict(lambda_coefficients=[[m,-1] for m in (2,9)],
        yX_coefficients=[[m,j,1] for m in (2,9) for j in XIDS],yZ_coefficients=[[m,51,1] for m in (2,9)],
        t_coefficients=[[m,j,51,-1] for m in (2,9) for j in XIDS],owner_coefficients=[[owner,-1]],rhs=0)
    assert all(row[k]==v for k,v in expected.items())
    assert row['proof_kind']=='conditional_boolean_union_with_global_same_sector_pair_total'
    literal=sum(w*lam[m] for m,w in row['lambda_coefficients'])
    literal+=sum(w*y('X',m,j) for m,j,w in row['yX_coefficients'])
    literal+=sum(w*y('Z',m,j) for m,j,w in row['yZ_coefficients'])
    literal+=sum(w*t(m,i,j) for m,i,j,w in row['t_coefficients'])
    literal+=sum(w*s for j,w in row['owner_coefficients'])
    assert literal==sum(Q(v['lower_bound']) for v in active)-s==Q(row['exact_violation'])>0
    maximum,count,_=truth(row,owner);assert maximum==0 and count==256
    # Exact nonnegative identity, independent of any physical matching rule.
    for bits in range(8):
        x,k,z=[(bits>>i)&1 for i in range(3)]
        assert x*k-x-k-z+1+x*z+k*z==(1-z)*(1-x)*(1-k)+z*x*k>=0
    return dict(exact_violation=str(literal),global_same_sector_pair=str(s),coordinate=coord,
                active_choices=active,truth_assignments_checked=count,maximum_literal_row_value=maximum,
                boolean_identity_assignments_checked=8)
def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    assert all(os.environ.get(k)=='1' for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'))
    ap=argparse.ArgumentParser();ap.add_argument('--bank',required=True);ap.add_argument('--output',required=True);a=ap.parse_args();start=time.monotonic()
    bank=read(a.bank);data=context(bank);out=replay(bank,data);rejected=[];counterexamples={}
    for label in ('wrong_global_pair_sign','missing_flow_term','wrong_lambda_sign','duplicated_active_pattern'):
        row=copy.deepcopy(bank['cuts'][0])
        if label=='wrong_global_pair_sign':row['owner_coefficients'][0][1]=1
        elif label=='missing_flow_term':row['t_coefficients'].pop(0)
        elif label=='wrong_lambda_sign':row['lambda_coefficients'][0][1]=1
        else:
            for field in FIELDS[:-1]:row[field].extend(copy.deepcopy([r for r in row[field] if r[0]==2]))
        value,_,assignment=truth(row,data[5]);assert value>0
        counterexamples[label]=dict(**assignment,literal_row_value=value);rejected.append(label)
    for label in ('wrong_point_hash','changed_gap','wrong_flow_coordinate','false_global_claim'):
        bad=copy.deepcopy(bank)
        if label=='wrong_point_hash':bad['point_sha256']='0'*64
        elif label=='changed_gap':bad['cuts'][0]['exact_violation']=str(Q(bad['cuts'][0]['exact_violation'])+1)
        elif label=='wrong_flow_coordinate':bad['cuts'][0]['t_coefficients'][0][2]=83
        else:bad['global_moment_point_excluded']=True
        try:replay(bad,data)
        except (AssertionError,KeyError,ValueError):rejected.append(label)
        else:raise AssertionError(('accepted corruption',label))
    sources=dict(bank['source_hashes'])
    for p in [a.bank,Path(__file__).name,'verify_owner_capacity_joint_literal.py','verify_algebraic_model.py']:sources[p]=sha(p)
    out.update(status='PASS_EXACT_CONDITIONAL_BOOLEAN_UNION_AUXILIARY_ROW',bank_sha256=sha(a.bank),
        point_sha256=sha(POINT),allocation_sha256=sha(CERT),allocation_receipt_sha256=sha(RECEIPT),
        consumer_sha256=sha(Path(__file__).name),source_hashes=sources,corruptions_rejected=rejected,
        invalid_row_literal_counterexamples=counterexamples,provided_allocation_excluded=True,
        global_moment_point_excluded=False,source_C16_answered=False,complete_conditional_pair_law_proved=False,
        K22_geometry_needed_for_inequality=False,full_parent_allocation_replay_repeated=False,
        proof='xy-x-y-z+1+xz+yz=(1-z)(1-x)(1-y)+zxy>=0, conditioned per pattern; sum selected pattern lower bounds and use sum_m E[1_m xy]=Sxy.',
        scope='One globally source-valid auxiliary inequality; its positive gap rejects only the hash-bound saved allocation, not the global moment point or the source problem.',
        priority=19,elapsed_seconds=time.monotonic()-start)
    path=ROOT/a.output;assert not path.exists();path.write_text(json.dumps(out,indent=2,sort_keys=True)+'\n')
    print(json.dumps(dict(status=out['status'],gap=float(Q(out['exact_violation'])),truth_assignments=256,mutants=len(rejected),receipt_sha256=sha(a.output),seconds=out['elapsed_seconds'])))
if __name__=='__main__':main()
