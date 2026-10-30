"""Exact full-Z-basis support for four fixed physical X anchors.

The 16 patterns specify selected anchors only; absent anchors are relaxed.
No rotational reduction is made. Feature targets use p/S/T with factor ONE.
"""
from itertools import combinations
from numbers import Integral
import numpy as np
from full_partner_basis_oracle import FullPartnerBasisOracle
from projected_profile_moment_matrix import owner_coordinate

PAIRS = tuple(combinations(range(4), 2))
FEATURES = 3611
LAYOUT = '1,P[4],PP[6 lex],Q[720],P_Q[4,720].ravel(C)'

def anchors_checked(anchors):
    a = tuple(anchors)
    if len(a) != 4 or len(set(a)) != 4 or any(type(i) is not int or not 0 <= i < 720 for i in a):
        raise ValueError('four distinct physical X indices are required')
    return a

def column_features(mask, selected_Z_indices):
    if type(mask) is not int or not 0 <= mask < 16:
        raise ValueError('mask must be in 0..15')
    chosen = tuple(selected_Z_indices)
    if len(set(chosen)) != len(chosen) or any(type(j) is not int or not 0 <= j < 720 for j in chosen):
        raise ValueError('invalid selected physical Z indices')
    p = np.array([(mask >> i) & 1 for i in range(4)], dtype=np.int8)
    q = np.zeros(720, dtype=np.int8); q[list(chosen)] = 1
    return np.r_[1, p, [int(p[i])*int(p[j]) for i,j in PAIRS], q, (p[:,None]*q).ravel()].astype(np.int8)

def target_columns(anchors):
    anchors = anchors_checked(anchors); a = [divmod(i,16) for i in anchors]
    return [None] + [j for j,t in a] + [owner_coordinate('S',(a[l][1]-a[i][1])%16,a[i][0],a[l][0]) for i,l in PAIRS] + [j//16 for j in range(720)] + [owner_coordinate('T',(b-t)%16,i,j) for i,t in a for j in range(45) for b in range(16)]

def moment_target(owner, anchors):
    if len(owner) != 36495: raise ValueError('wrong owner vector length')
    return tuple(1 if j is None else owner[j] for j in target_columns(anchors))

class FourAnchorOracle:
    def __init__(self, anchors):
        self.anchors = anchors_checked(anchors); self.oracle = FullPartnerBasisOracle()
        self.domains = [self.oracle.prepare_selected([self.anchors[i] for i in range(4) if m>>i&1]) for m in range(16)]
        self.bits = np.array([[(m>>i)&1 for i in range(4)] for m in range(16)],dtype=np.int64)
        self.local = np.array([column_features(m,())[:11] for m in range(16)],dtype=np.int64)

    def price(self, coefficients, records=True):
        c = tuple(coefficients)
        if len(c)!=FEATURES or any(not isinstance(v,Integral) or isinstance(v,bool) for v in c):
            raise TypeError('3611 exact integer coefficients required')
        c = tuple(map(int,c)); bound = max(abs(c[11+j])+sum(abs(c[731+720*i+j]) for i in range(4)) for j in range(720))
        safe = bound <= (1<<63)-1 and sum(abs(v) for v in c[:11]) <= (1<<63)-1
        if safe:
            v=np.array(c,dtype=np.int64); w=self.bits@v[731:].reshape(4,720)+v[11:731]; local=self.local@v[:11]
        else:
            w=[[c[11+j]+sum(c[731+720*i+j] for i in range(4) if m>>i&1) for j in range(720)] for m in range(16)]
            local=[sum(c[k]*int(self.local[m,k]) for k in range(11)) for m in range(16)]
        rows=[]; columns=[]
        for mask,domain in enumerate(self.domains):
            result=self.oracle.support(domain,[int(v) for v in w[mask]])
            if result['status']!='EXACT_FULL_PARTNER_BASIS_SUPPORT':
                rows.append({'mask':mask,**result}); columns.append(None); continue
            value=int(result['value']); total=int(local[mask])+value
            f=column_features(mask,list(result['selected_Z_indices']))
            assert total==sum(a*int(b) for a,b in zip(c,f))
            rows.append({'mask':mask,**result,'value':value,'full_value':total}); columns.append(f)
        feasible=[i for i,r in enumerate(rows) if r['status']=='EXACT_FULL_PARTNER_BASIS_SUPPORT']
        if not feasible: raise ValueError('no feasible selection pattern')
        best=max(feasible,key=lambda i:rows[i]['full_value'])
        return {'upper_bound':rows[best]['full_value'],'best':best,'records':rows,'columns':columns,'backend':'int64' if safe else 'python_int'}
