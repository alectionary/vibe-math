"""Independent low-pivot full-basis proof and factor-one feature controls.

Acceptance imports no four-anchor producer code. Numerical failure to separate
is never membership; the compiler only accepts matched exact support receipts.
"""
from pathlib import Path
from fractions import Fraction
from collections import Counter
from itertools import combinations
import argparse,gzip,hashlib,json,random,time
import numpy as np
from scipy.sparse import csr_matrix
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import rebuild_domain,check_support
from verify_projected_profile_moment_rows import point_vector
ROOT=Path(__file__).resolve().parent
PAIRS=tuple(combinations(range(4),2)); N=3611
LAYOUT='1,P[4],PP[6 lex],Q[720],P_Q[4,720].ravel(C)'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    b=Path(p).read_bytes();return json.loads(gzip.decompress(b) if str(p).endswith('.gz') else b)
def coord(side,h,i,j):
    h%=16
    if h>8:h,i,j=16-h,j,i
    if h in (0,8) and i>j:i,j=j,i
    return i if side=='S' and h==0 and i==j else 45+(0 if side=='S' else 18225)+2025*h+45*i+j
def columns(anchors):
    assert len(anchors)==len(set(anchors))==4 and all(type(v)is int and 0<=v<720 for v in anchors)
    a=[divmod(v,16) for v in anchors]
    return [None]+[i for i,t in a]+[coord('S',v-u,i,j) for (i,u),(j,v) in ((a[k],a[l]) for k,l in PAIRS)]+[j//16 for j in range(720)]+[coord('T',b-t,i,j) for i,t in a for j in range(45) for b in range(16)]
def features(mask,basis):
    assert type(mask)is int and 0<=mask<16 and len(set(basis))==len(basis) and all(type(j)is int and 0<=j<720 for j in basis)
    p=[(mask>>i)&1 for i in range(4)]; q=[int(j in set(basis)) for j in range(720)]
    return [1]+p+[p[i]*p[j] for i,j in PAIRS]+q+[p[i]*q[j] for i in range(4) for j in range(720)]
def target(point,anchors):
    v=point_vector(point);return [Fraction(1) if j is None else v[j] for j in columns(anchors)]
def compile_row(c,upper,anchors):
    assert len(c)==N and all(type(v)is int for v in c) and type(upper)is int
    r=Counter()
    for a,j in zip(c,columns(anchors)):
        if j is not None:r[j]+=a
    return dict(sorted((j,v) for j,v in r.items() if v)),upper-c[0]
def validate(bank,receipt,path):
    assert receipt['status']=='PASS' and receipt['bank_sha256']==sha(path)
    assert receipt['consumer_sha256']==sha(Path(__file__)) and receipt['cuts_checked']==len(bank['cuts'])
    assert bank['feature_layout']==LAYOUT and bank['selection_patterns']==list(range(16))
    assert {'physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','moment-resumption-results/symmetry-bridge-independent.json'}<=set(bank['source_hashes'])
    assert all(sha(ROOT/p)==v for p,v in bank['source_hashes'].items())
def matrix(banks,replays):
    assert len(banks)==len(replays);rr=[];cc=[];dd=[];rhs=[];meta=[]
    for path,rpath in zip(banks,replays):
        bank,receipt=read(path),read(rpath);validate(bank,receipt,path)
        for i,cut in enumerate(bank['cuts']):
            row,b=compile_row(cut['coefficients'],cut['upper_bound'],bank['anchors']);k=len(rhs)
            for j,v in row.items():rr.append(k);cc.append(j);dd.append(v)
            rhs.append(b);meta.append({'family':'four_fixed_X_anchor_full_partner','bank':str(path),'cut':i,'anchors':bank['anchors']})
    return csr_matrix((np.array(dd,dtype=np.int64),(rr,cc)),shape=(len(rhs),36495)),np.array(rhs,dtype=np.int64),meta
def controls():
    from four_anchor_full_partner import FourAnchorOracle,column_features,moment_target
    rng=random.Random(202610300859);checks=0;support_checks=0;rejected=0
    X,Z,_=physical()
    for anchors in ([512,517,432,437],[512,520,432,440]):
        oracle=FourAnchorOracle(anchors)
        for p in (0,.13,.5,1):
            A=np.array([[int(rng.random()<p) for _ in range(16)] for _ in range(45)]);B=np.array([[int(rng.random()<p) for _ in range(16)] for _ in range(45)])
            count=np.zeros(36495,dtype=np.int64);literal=np.zeros(N,dtype=np.int64)
            for first,second in ((A,B),(B,A)):
                for rot in range(16):
                    U=np.roll(first,rot,axis=1);V=np.roll(second,rot,axis=1)
                    m=sum(int(U[j//16,j%16])<<i for i,j in enumerate(anchors));basis=[j for j in range(720) if V[j//16,j%16]]
                    f=features(m,basis);assert np.array_equal(column_features(m,basis),f);literal+=f
                    count[:45]+=U[:,0]
                    for h in range(9):
                        count[45+2025*h:45+2025*(h+1)]+=np.outer(U[:,0],U[:,h]).ravel()
                        count[18270+2025*h:18270+2025*(h+1)]+=np.outer(U[:,0],V[:,h]).ravel()
            exact=[Fraction(int(x),32) for x in count];t=[Fraction(1) if j is None else exact[j] for j in columns(anchors)]
            assert t==list(moment_target(exact,anchors))==[Fraction(int(x),32) for x in literal];checks+=N
        for c in ([0]*N,[0]*11+[-1]*720+[0]*2880,[rng.randrange(-9,10) for _ in range(N)]):
            priced=oracle.price(c)
            for row in priced['records']:
                m=row['mask'];selected=sorted(anchors[i] for i in range(4) if m>>i&1);d=rebuild_domain(X,Z,selected,128)
                w=[c[11+j]+sum(c[731+720*i+j] for i in range(4) if m>>i&1) for j in range(720)]
                support_checks+=check_support(Z,selected,128,d,w,row)
                if row['value'] is not None:assert row['full_value']==sum(a*b for a,b in zip(c,features(m,list(row['selected_Z_indices']))))
        for bad in ([0.0]*N,[0]*(N-1)):
            try:oracle.price(bad)
            except (TypeError,ValueError):rejected+=1
            else:raise AssertionError('bad coefficient input accepted')
    return {'status':'PASS_CONTROLS','literal_32_action_equalities':checks,'signed_prefix_rank_checks':support_checks,'invalid_inputs_rejected':rejected,'source_C16_answered':False}
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path);ap.add_argument('--point',type=Path);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--controls',action='store_true');a=ap.parse_args();assert not a.output.exists();start=time.monotonic()
    if a.controls:out=controls()
    else:
        bank=read(a.bank);assert bank['feature_layout']==LAYOUT and bank['selection_patterns']==list(range(16)) and bank['cuts'];assert bank['point_sha256']==sha(a.point)
        assert {'physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','moment-resumption-results/symmetry-bridge-independent.json'}<=set(bank['source_hashes'])
        assert all(sha(ROOT/p)==v for p,v in bank['source_hashes'].items());X,Z,_=physical();anchors=bank['anchors'];tar=target(a.point,anchors);res=[]
        for cut in bank['cuts']:
            c=cut['coefficients'];assert len(c)==N and all(type(v)is int for v in c);records=cut['support_records'];assert [r['mask'] for r in records]==list(range(16));prefixes=0;values=[]
            for rec in records:
                m=rec['mask'];selected=sorted(anchors[i] for i in range(4) if m>>i&1);d=rebuild_domain(X,Z,selected,128);w=[c[11+j]+sum(c[731+720*i+j] for i in range(4) if m>>i&1) for j in range(720)]
                prefixes+=check_support(Z,selected,128,d,w,rec)
                if rec['value'] is not None:
                    total=sum(a*b for a,b in zip(c,features(m,rec['selected_Z_indices'])));assert total==rec['full_value'];values.append(total)
            assert max(values)==cut['upper_bound'];exact=sum(a*b for a,b in zip(c,tar));gap=exact-cut['upper_bound'];assert gap>0 and str(exact)==cut['exact_target_value'] and str(gap)==cut['exact_violation'];row,rhs=compile_row(c,cut['upper_bound'],anchors);owner=point_vector(a.point);assert sum(v*owner[j] for j,v in row.items())-rhs==gap
            res.append({'exact_violation':str(gap),'prefix_rank_checks':prefixes,'owner_row_nonzeros':len(row),'upper_bound':cut['upper_bound']})
        out={'status':'PASS','bank_sha256':sha(a.bank),'point_sha256':sha(a.point),'consumer_sha256':sha(Path(__file__)),'cuts_checked':len(res),'results':res,'source_C16_answered':False,'scope':'Exact full-basis necessity for selected subsets of four fixed X anchors. Absences and remaining X completion are relaxed.'}
    out['elapsed_seconds']=time.monotonic()-start;a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
