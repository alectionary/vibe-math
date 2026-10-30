"""Exact int64 batch construction of equivariant physical Z-candidate weights.

No source-domain or support-acceptance logic is changed. The conservative
sum-of-absolute-coefficients gate prevents every possible intermediate overflow.
Oracle calls receive Python ints; their full128-basis sums remain arbitrary size.
"""
from numbers import Integral
import numpy as np
from full_partner_projection_features import column_features,mask_score
MAX_INT64=(1<<63)-1


class IntegerPhaseWeightBatch:
    def __init__(self,masks):
        masks=tuple(masks)
        if any(not isinstance(m,Integral) or isinstance(m,bool) or not 0<=int(m)<65536 for m in masks):
            raise ValueError('masks must be16-bit integers')
        self.masks=tuple(map(int,masks))
        self.bits=np.array([[(m>>t)&1 for t in range(16)] for m in self.masks],dtype=np.int64).reshape(-1,16)
        indices=np.arange(720,dtype=np.int64)
        self.shifted_indices=16*(indices//16)[None,:]+((indices%16)[None,:]-np.arange(16)[:,None])%16

    def weights(self,coefficients):
        c=tuple(coefficients)
        if len(c)!=775:raise ValueError('expected775 coefficients')
        if any(not isinstance(v,Integral) or isinstance(v,bool) for v in c):
            raise TypeError('batch weights require exact integer coefficients')
        c=tuple(map(int,c))
        bound=max(abs(c[10+j])+sum(abs(c[55+16*j+h]) for h in range(16)) for j in range(45))
        if bound>MAX_INT64:raise OverflowError('absolute coefficient sum exceeds safe int64 range')
        constants=np.repeat(np.asarray(c[10:55],dtype=np.int64),16)
        shifted=np.asarray(c[55:],dtype=np.int64)[self.shifted_indices]
        return self.bits@shifted+constants


def support_all_batched(oracle,domains,coefficients,batch=None):
    batch=batch or IntegerPhaseWeightBatch(mask for mask,_ in domains)
    if batch.masks!=tuple(mask for mask,_ in domains):raise ValueError('batch/domain mask order mismatch')
    weights=batch.weights(coefficients);records=[];columns=[];maximum=None
    for (mask,domain),row in zip(domains,weights):
        result=oracle.support(domain,[int(v) for v in row])
        if result['status']!='EXACT_FULL_PARTNER_BASIS_SUPPORT':
            raise ValueError('Infeasible domain needs a separate exclusion certificate')
        assert result['value'].denominator==1
        value=int(result['value']);total=mask_score(mask,coefficients)+value
        feature=column_features(mask,result['selected_Z_indices'])
        assert total==sum(int(c)*f for c,f in zip(coefficients,feature))
        records.append({'mask':mask,'support_value':value,'full_value':total,
            'selected_Z_indices':list(result['selected_Z_indices']),
            'zero_basis_indices':list(result['zero_basis_indices']),'owner_indices':list(result['owner_indices'])})
        columns.append(feature);maximum=total if maximum is None else max(maximum,total)
    return maximum,records,columns
