"""Sparse degree-two consequences of universal forbidden same-sector patterns."""
import json
from scipy.sparse import coo_matrix

def matrix(paths):
    rows=[];seen=set()
    def coordinate(h,i,j):
        if h>8:h=16-h;i,j=j,i
        if h in (0,8) and i>j:i,j=j,i
        return 45+2025*h+45*i+j
    for path in paths:
        for cut in json.loads(path.read_text())['cuts']:
            assert cut['kind'] in ('universal_sparse_quotient','universal_sparse_quotient_four')
            J=cut['indices'];assert len(J)>=2
            for a in J:
                terms=tuple(sorted(coordinate((b-a)%16,a//16,b//16) for b in J if b!=a))
                key=(a//16,len(J)-2,terms)
                if key not in seen:seen.add(key);rows.append(key)
    ii=[];jj=[];vv=[]
    for k,(p,bound,terms) in enumerate(rows):
        if bound:ii.append(k);jj.append(p);vv.append(-bound)
        for term in terms:ii.append(k);jj.append(term);vv.append(1)
    M=coo_matrix((vv,(ii,jj)),shape=(len(rows),45+9*2025),dtype='int64').tocsr();M.sum_duplicates();return M,rows
