"""Deduplicate conditioned forbidden-pattern inequalities by actual coefficients."""
import json
from collections import Counter
from scipy.sparse import coo_matrix

def matrix(paths):
    rows=[];seen=set();tagged_count=0
    def coordinate(h,i,j):
        if h>8:h=16-h;i,j=j,i
        if h in (0,8) and i>j:i,j=j,i
        return 45+2025*h+45*i+j
    for path in paths:
        for cut in json.loads(path.read_text())['cuts']:
            assert cut['kind'] in ('universal_sparse_quotient','universal_sparse_quotient_four')
            J=cut['indices'];assert len(J)>=2 and len(J)==len(set(J))
            for a in J:
                terms=Counter(coordinate((b-a)%16,a//16,b//16) for b in J if b!=a)
                if len(J)>2:terms[a//16]-=len(J)-2
                key=tuple(sorted((j,c) for j,c in terms.items() if c))
                tagged_count+=1
                if key not in seen:seen.add(key);rows.append(key)
    ii=[];jj=[];vv=[]
    for k,row in enumerate(rows):
        for j,value in row:ii.append(k);jj.append(j);vv.append(value)
    M=coo_matrix((vv,(ii,jj)),shape=(len(rows),45+9*2025),dtype='int64').tocsr()
    return M,rows
