#!/usr/bin/env python3
"""Exact rational PSD certificates for dyadic cyclic moment duals.

Integer periodic difference vectors split the cyclic representation over Q.
Every transformed block is preconditioned by a supplied rational matrix. Its
integer congruence must be strictly diagonally dominant with positive diagonal.
The consumer uses integer arithmetic only; NumPy/SciPy occur only in --generate.
"""
from pathlib import Path
import argparse,json,gzip,hashlib
from flint import fmpz_mat


def matrix_hash(data):
    fields={k:data[k] for k in ['period','denominator','constant','mean','D']}
    return hashlib.sha256(json.dumps(fields,sort_keys=True,separators=(',',':')).encode()).hexdigest()


def dyadic_blocks(data):
    P=data['period'];assert P==16 and type(data['denominator']) is int and data['denominator']>0 and type(data['constant']) is int and all(type(v) is int for v in data['mean']);N=len(data['mean']);assert N>0;D={int(h):M for h,M in data['D'].items()}
    for h in range(9,16):D[h]=list(map(list,zip(*D[16-h])))
    assert all(type(v) is int for M in D.values() for row in M for v in row)
    assert all(len(D[h])==N and all(len(r)==N for r in D[h]) for h in range(P))
    assert all(D[h][i][j]==D[(-h)%P][j][i] for h in range(P) for i in range(N) for j in range(N))
    groups=[[[1]*P]]
    for d in [1,2,4,8]:groups.append([[1 if h%(2*d)==j else -1 if h%(2*d)==j+d else 0 for h in range(P)] for j in range(d)])
    assert all(sum(v)==0 for group in groups[1:] for v in group)
    flat=[v for group in groups for v in group];assert len(flat)==P
    assert all(sum(a*b for a,b in zip(v,w))==(sum(a*a for a in v) if i==j else 0) for i,v in enumerate(flat) for j,w in enumerate(flat))
    assert all(sum(a*a for a in v)>0 for v in flat)
    # Cross-correlations between distinct groups vanish at every cyclic shift;
    # hence the block-circulant dual has no cross-group blocks under this basis.
    zeros=0
    for g,U in enumerate(groups):
        for k,V in enumerate(groups):
            if g==k:continue
            for u in U:
                for v in V:
                    for h in range(P):assert sum(u[r]*v[(r+h)%P] for r in range(P))==0;zeros+=1
    u=data['mean'];B0=[[data['constant']]+[P*v for v in u]]
    for i in range(N):B0.append([P*u[i]]+[P*sum(D[h][i][j] for h in range(P)) for j in range(N)])
    blocks=[fmpz_mat(B0)]
    for group in groups[1:]:
        d=len(group);coeff=[[[sum(a[r]*b[(r+h)%P] for r in range(P)) for h in range(P)] for b in group] for a in group]
        M=[[0]*(d*N) for _ in range(d*N)]
        for a in range(d):
            for b in range(d):
                weights=[(h,c) for h,c in enumerate(coeff[a][b]) if c]
                for i in range(N):
                    for j in range(N):M[a*N+i][b*N+j]=sum(c*D[h][i][j] for h,c in weights)
        blocks.append(fmpz_mat(M))
    assert sum(B.nrows() for B in blocks)==1+P*N
    return blocks,zeros


def verify(data,certificate):
    assert certificate['source_dual_matrix_SHA256']==matrix_hash(data)
    assert type(certificate['preconditioner_denominator']) is int and certificate['preconditioner_denominator']>0
    blocks,zeros=dyadic_blocks(data);assert len(blocks)==len(certificate['preconditioners']);report=[]
    for B,raw in zip(blocks,certificate['preconditioners']):
        n=B.nrows();assert len(raw)==n and all(len(r)==n and all(type(v) is int for v in r) for r in raw)
        R=fmpz_mat(raw);Q=R*B*R.transpose()
        assert all(Q[i,j]==Q[j,i] for i in range(n) for j in range(n))
        gaps=[Q[i,i]-sum(abs(Q[i,j]) for j in range(n) if j!=i) for i in range(n)]
        assert min(gaps)>0
        report.append({'dimension':n,'strict_integer_diagonal_dominance':True,'minimum_gap_numerator':str(min(gaps))})
    return {'status':'PASS','method':'integer dyadic congruence and exact rational Gershgorin certificates','full_dual_dimension':1+16*len(data['mean']),'cross_group_cyclic_correlations_checked_zero':zeros,'PSD_blocks':report,'floating_point_operations_in_consumer':0}


def generate(data):
    import numpy as np
    from scipy.linalg import solve_triangular
    blocks,zeros=dyadic_blocks(data);DR=1<<45;out=[]
    for B in blocks:
        n=B.nrows();F=np.array([[float(B[i,j])/data['denominator'] for j in range(n)] for i in range(n)])
        L=np.linalg.cholesky((F+F.T)/2);R=solve_triangular(L,np.eye(n),lower=True)
        out.append([[round(float(v)*DR) for v in row] for row in R])
        print('PRECONDITIONED',n,flush=True)
    certificate={'source_dual_matrix_SHA256':matrix_hash(data),'preconditioner_denominator':DR,'preconditioners':out}
    return certificate,verify(data,certificate)


def read(path):
    raw=path.read_bytes();return json.loads(gzip.decompress(raw) if path.suffix=='.gz' else raw)


def main():
    ap=argparse.ArgumentParser();ap.add_argument('dual',type=Path);ap.add_argument('--generate',action='store_true');ap.add_argument('--preconditioners',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();data=read(a.dual)
    if a.generate:
        cert,result=generate(data);raw=(json.dumps(cert)+'\n').encode();a.preconditioners.write_bytes(gzip.compress(raw,mtime=0) if a.preconditioners.suffix=='.gz' else raw)
    else:result=verify(data,read(a.preconditioners))
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)
if __name__=='__main__':main()
