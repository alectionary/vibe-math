#!/usr/bin/env python3
"""Sector-exchange averaged moment model; no selected-frame invariance.

In the original pool order, the verified physical exchange swaps X_i and Z_i.
Thus averaged C_h has blocks [[S_h,T_h],[T_h,S_h]]. Sector plus/minus splits
every Fourier PSD block. Normal-form coordinates are recovered by an exact
permutation/rephasing sparse map, so all source cuts remain applicable.
"""
import math
import numpy as np
import cvxpy as cp
from scipy.sparse import coo_matrix


def model(root, mapping, families, target, normalize=True):
    P=16
    X=[int(s,16) for s in (root/'pools/xcoords.txt').read_text().split()]
    Z=[int(s,16) for s in (root/'pools/zcoords.txt').read_text().split()]
    # Check the actual exchange bridge and cyclic adjacency convention.
    assert all((x&z).bit_count()%2==(X[j]&Z[i]).bit_count()%2
               for i,x in enumerate(X) for j,z in enumerate(Z))
    norm_active=[9*c+i for c in families for i in range(9)]
    original_active=[{mapping[side][16*i]//16 for i in norm_active} for side in [0,1]]
    assert original_active[0]==original_active[1]
    ids=sorted(original_active[0]);q=len(ids);lookup={v:i for i,v in enumerate(ids)}
    patterns=[[sum(((X[16*i]&Z[16*j+h]).bit_count()%2)<<h for h in range(P)) for j in ids] for i in ids]
    p=cp.Variable(q,name='exchange_first')
    S={0:cp.Variable((q,q),symmetric=True,name='S0'),8:cp.Variable((q,q),symmetric=True,name='S8')}
    T={0:cp.Variable((q,q),symmetric=True,name='T0'),8:cp.Variable((q,q),symmetric=True,name='T8')}
    for h in range(1,8):
        S[h]=cp.Variable((q,q),name=f'S{h}')
        T[h]=cp.Variable((q,q),name=f'T{h}')
        S[P-h]=S[h].T;T[P-h]=T[h].T
    con=[p>=0,p<=1,cp.diag(S[0])==p,P*cp.sum(p)==target]
    scale=target if normalize else 1
    for B in [sum(S.values()),sum(T.values())]:
        con.append(cp.sum(B,axis=1)/scale==(target/scale)*p)
    for h in range(9):
        for B in [S[h],T[h]]:
            rows=cp.reshape(p,(q,1),order='C')@np.ones((1,q))
            con.extend([B>=0,B<=rows,B<=rows.T,B>=rows+rows.T-1])
    flow=sum(cp.multiply(np.array([[patterns[i][j]>>h&1 for j in range(q)] for i in range(q)]),T[h]) for h in range(P))
    con.append(cp.sum(flow,axis=1)==p)
    even0=(sum(S.values())+sum(T.values()))/2
    G=cp.bmat([[np.ones((1,1)),4*cp.reshape(p,(1,q),order='C')],
               [4*cp.reshape(p,(q,1),order='C'),even0]])
    con.extend([G>>0,(sum(S.values())-sum(T.values()))>>0])
    for k in range(1,9):
        for sign in [1,-1]:
            B={h:S[h]+sign*T[h] for h in range(P)}
            re=B[0]+((-1)**k)*B[8];im=0*B[0]
            for h in range(1,8):
                c=(-1)**h if k==8 else math.cos(2*math.pi*k*h/P)
                s=0 if k==8 else math.sin(2*math.pi*k*h/P)
                re=re+c*(B[h]+B[h].T);im=im+s*(B[h]-B[h].T)
            con.append((re if k==8 else cp.bmat([[re,-im],[im,re]]))>>0)
    raw=cp.hstack([p]+[cp.vec(S[h],order='F') for h in range(9)]+[cp.vec(T[h],order='F') for h in range(9)])
    ri=[];ci=[]
    # Exactly reconstruct full90-type normal-form first and pair moments.
    old=[]
    for side in [0,1]:
        old.extend([(side,)+divmod(mapping[side][P*i],P) for i in range(45)])
    for i,(_,a,_) in enumerate(old):
        if a in lookup:ri.append(i);ci.append(lookup[a])
    for h in range(9):
        for i,(side,a,ha) in enumerate(old):
            if a not in lookup:continue
            for j,(other,b,hb) in enumerate(old):
                if b not in lookup:continue
                u,v=lookup[a],lookup[b];shift=(hb+h-ha)%P
                if shift>8:u,v,shift=v,u,P-shift
                ri.append(90+h*90*90+i+90*j)
                ci.append(q+(0 if side==other else 9*q*q)+shift*q*q+u+q*v)
    E=coo_matrix((np.ones(len(ri)),(ri,ci)),shape=(90+9*90*90,q+18*q*q)).tocsr()
    full=E@raw
    pfull=full[:90]
    C={h:cp.reshape(full[90+h*90*90:90+(h+1)*90*90],(90,90),order='F') for h in range(9)}
    for h in range(9,16):C[h]=C[16-h].T
    info={'moment_symmetry':'cyclic translation and physical sector exchange; no frame symmetry',
          'original_active_orbits':ids,'sector_types':q,'raw_model_variables':q+18*q*q,
          'PSD_max_real_order':2*q,'zero_frequency_even_order':q+1,
          'mapping_nonzeros':E.nnz}
    return cp.Problem(cp.Minimize(0),con),pfull,C,info
