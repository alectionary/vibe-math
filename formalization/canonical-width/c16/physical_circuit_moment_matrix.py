"""Conditioned source-circuit rank inequalities in the sector-folded layout."""
from collections import Counter
from scipy.sparse import coo_matrix
def matrix(circuits):
    rows=[];metadata=[];seen=set()
    def coord(side,h,i,j):
        if side=='S' and h==0 and i==j:return i
        if h>8:h=16-h;i,j=j,i
        if h in (0,8) and i>j:i,j=j,i
        return 45+(0 if side=='S' else 9*2025)+2025*h+45*i+j
    for ci,C in enumerate(circuits):
        for phase in range(16):
            D=[16*(v//16)+(v%16+phase)%16 for v in C]
            for side in ('S','T'):
                for i in range(45):
                    terms=Counter({i:-(len(C)-1)})
                    for v in D:terms[coord(side,v%16,i,v//16)]+=1
                    key=tuple(sorted((j,a) for j,a in terms.items() if a))
                    if key in seen:continue
                    seen.add(key);rows.append(key);metadata.append({'circuit_index':ci,'phase':phase,'child_sector':side,'anchor_orbit':i})
    ii=[];jj=[];vv=[]
    for r,row in enumerate(rows):
        for j,v in row:ii.append(r);jj.append(j);vv.append(v)
    M=coo_matrix((vv,(ii,jj)),shape=(len(rows),45+18*2025),dtype='int64').tocsr();return M,rows,metadata
