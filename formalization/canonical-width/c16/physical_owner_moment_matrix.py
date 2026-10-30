"""Existing private-partner inequalities in the physical, sector-averaged layout."""
from collections import Counter
from scipy.sparse import coo_matrix
def matrix(A):
    assert len(A)==720;rows=[];metadata=[]
    def coord(side,h,i,j):
        if h>8:h=16-h;i,j=j,i
        if h in (0,8) and i>j:i,j=j,i
        return 45+(0 if side=='S' else 9*2025)+2025*h+45*i+j
    for i in range(45):
        for k in range(720):
            if k==16*i:continue
            j,h=divmod(k,16);terms=Counter({i:-1});terms[coord('S',h,i,j)]+=1;common=A[16*i]&A[k];physical=[]
            while common:
                bit=common&-common;common-=bit;v=bit.bit_length()-1;physical.append(v);o,t=divmod(v,16);terms[coord('T',t,i,o)]+=1
            rows.append(tuple(sorted((c,a) for c,a in terms.items() if a)));metadata.append({'anchor_orbit':i,'other_index':k,'common_opposite':physical})
    ii=[];jj=[];vv=[]
    for r,row in enumerate(rows):
        for j,v in row:ii.append(r);jj.append(j);vv.append(v)
    M=coo_matrix((vv,(ii,jj)),shape=(len(rows),45+18*2025),dtype='int64').tocsr();return M,rows,metadata
