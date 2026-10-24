"""Independent integer-matrix, CSS, and definition-based verification."""
from itertools import combinations
from pathlib import Path
import json


def rank2(rows):
    pivots={}
    for r in rows:
        while r:
            p=r.bit_length()-1
            if p not in pivots:
                pivots[p]=r
                break
            r^=pivots[p]
    return len(pivots)


def matrix_from_blocks(blocks):
    nr=1+max(x for b in blocks for x in b)
    return [[int(r in b) for b in blocks] for r in range(nr)]


def gram(M):
    return [[sum(x*y for x,y in zip(a,b)) for b in M] for a in M]


def qc_matrices(blocks,ell,support):
    A=matrix_from_blocks(blocks);m=len(A);n=len(blocks)
    X=[[0]*((n+m)*ell) for _ in range(m*ell)]
    Z=[[0]*((n+m)*ell) for _ in range(n*ell)]
    for p,b in enumerate(blocks):
        for t in range(ell):
            for r in b:
                X[r*ell+t][p*ell+t]=1
                Z[p*ell+t][(n+r)*ell+t]=1
            for e in support:
                Z[p*ell+t][p*ell+(t-e)%ell]=1
    for r in range(m):
        for t in range(ell):
            for e in support:X[r*ell+(t-e)%ell][(n+r)*ell+t]=1
    return X,Z


def bitrows(M):
    return [sum(x<<i for i,x in enumerate(r)) for r in M]


def connected(M):
    nr=len(M);nc=len(M[0]);seen={0};todo=[0]
    adj=[[] for _ in range(nr+nc)]
    for r,row in enumerate(M):
        for c,x in enumerate(row):
            if x:adj[r].append(nr+c);adj[nr+c].append(r)
    while todo:
        for w in adj[todo.pop()]:
            if w not in seen:seen.add(w);todo.append(w)
    return len(seen)==nr+nc


def export_cpp(name,M):
    """Columns as unsigned 128-bit check masks for separate C++ checker."""
    n=len(M[0]);m=len(M)
    cols=[sum(M[r][v]<<r for r in range(m)) for v in range(n)]
    assert m<=128
    Path('work/absorbing42/'+name+'.masks').write_text(
        str(n)+'\n'+'\n'.join(f'{c&((1<<64)-1)} {c>>64}' for c in cols)+'\n')


def main():
    witness=json.loads(Path('work/absorbing42/cubic-witness.json').read_text())
    results={};Gs=[];BGs=[]
    for name in ['A','B']:
        b=witness[name];A=matrix_from_blocks(b);X,Z=qc_matrices(b,7,[0,1,3])
        xm=bitrows(X);zm=bitrows(Z)
        assert all((x&z).bit_count()%2==0 for x in xm for z in zm)
        assert all(sum(r)==6 for r in X)
        assert all(sum(X[r][v] for r in range(len(X)))==3 for v in range(len(X[0])))
        cols=[sum(X[r][v]<<r for r in range(len(X))) for v in range(len(X[0]))]
        assert all((x&y).bit_count()<=1 for x,y in combinations(cols,2))
        gx=gram(X);gb=gram(A);Gs.append(gx);BGs.append(gb)
        rx,rz=rank2(xm),rank2(zm)
        results[name]=dict(n=len(X[0]),mX=len(X),mZ=len(Z),rankX=rx,rankZ=rz,
                           k=len(X[0])-rx-rz,base_rank=rank2(bitrows(A)),
                           connected=connected(X),no_four_cycles=True,
                           X_variable_degree=3,X_check_degree=6,CSS_commutes=True)
        export_cpp('cubic-'+name,X)
    assert Gs[0]==Gs[1] and BGs[0]==BGs[1]
    results['equal_integer_base_Gram']=True
    results['equal_integer_X_Gram']=True
    Path('work/absorbing42/independent-results.json').write_text(json.dumps(results,indent=2))
    print(json.dumps(results,indent=2))


if __name__=='__main__':main()
