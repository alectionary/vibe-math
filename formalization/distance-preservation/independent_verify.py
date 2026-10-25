"""Independent dense block expansion. Does not import the discovery implementation."""
from pathlib import Path
from collections import Counter,deque
import hashlib,json,time
import numpy as np
R=Path(__file__).resolve().parent

def expand(E,L):
    m=len(E);n=len(E[0]);P=np.roll(np.eye(L,dtype=np.uint8),1,axis=0)
    powers=[np.linalg.matrix_power(P,e) for e in range(L)]
    C=np.block([[powers[E[i][j]%L] for j in range(n)] for i in range(m)])
    # Build polynomial Kronecker matrices by coefficients, then expand their
    # circulant blocks. This is not the discovery program's edge-index loop.
    coefficients=[]
    for e in range(L):
        B=np.array([[E[i][j]%L==e for j in range(n)] for i in range(m)],dtype=np.uint8)
        Bt=np.array([[(-E[i][j])%L==e for i in range(m)] for j in range(n)],dtype=np.uint8)
        X=np.hstack([np.kron(B,np.eye(n,dtype=np.uint8)),np.kron(np.eye(m,dtype=np.uint8),Bt)])
        Z=np.hstack([np.kron(np.eye(n,dtype=np.uint8),B),np.kron(Bt,np.eye(m,dtype=np.uint8))])
        coefficients.append((np.kron(X,powers[e]),np.kron(Z,powers[e])))
    HX=np.bitwise_xor.reduce([x for x,z in coefficients]);HZ=np.bitwise_xor.reduce([z for x,z in coefficients])
    return C,HX,HZ

def eliminate(A):
    A=A.copy();rows,cols=A.shape;r=0;piv=[]
    for j in range(cols):
        hits=np.flatnonzero(A[r:,j])
        if not len(hits):continue
        k=r+int(hits[0]);A[[r,k]]=A[[k,r]]
        for k in range(rows):
            if k!=r and A[k,j]:A[k]^=A[r]
        piv.append(j);r+=1
        if r==rows:break
    return A[:r],piv

def distance(A):
    red,piv=eliminate(A);free=[j for j in range(A.shape[1]) if j not in piv];basis=[]
    for j in free:
        v=np.zeros(A.shape[1],dtype=np.uint8);v[j]=1;v[piv]=red[:,j]
        basis.append(sum(int(b)<<i for i,b in enumerate(v)))
    assert len(basis)<=27
    hist=Counter({0:1});v=0;best=A.shape[1]+1;witness=0
    for k in range(1,1<<len(basis)):
        v^=basis[(k&-k).bit_length()-1];w=v.bit_count();hist[w]+=1
        if w<best:best=w;witness=v
    return {'rank':len(piv),'dimension':len(free),'distance':best,'weight_enumerator':dict(sorted(hist.items())),'witness':[i for i in range(A.shape[1]) if witness>>i&1],'enumerated_codewords':1<<len(basis)}

def bfs_girth(A):
    m,n=A.shape;adj=[[] for _ in range(m+n)]
    for i,j in zip(*np.nonzero(A)):adj[int(i)].append(m+int(j));adj[m+int(j)].append(int(i))
    best=m+n+1
    for root in range(m+n):
        q=deque([root]);d={root:0};parent={root:-1}
        while q:
            a=q.popleft()
            if d[a]*2>=best:continue
            for b in adj[a]:
                if b not in d:d[b]=d[a]+1;parent[b]=a;q.append(b)
                elif parent[a]!=b:best=min(best,d[a]+d[b]+1)
    return best

def verify(E,L,support,sep=None):
    assert len(set(support))==len(support), "Support indices must be unique"
    start=time.monotonic();C,X,Z=expand(E,L);n=X.shape[1]
    assert not np.any((X@Z.T)%2)
    w=np.zeros(n,dtype=np.uint8);w[support]=1
    assert not np.any((Z@w)%2)
    rx=len(eliminate(X)[1]);rz=len(eliminate(Z)[1]);newrank=len(eliminate(np.vstack([X,w]))[1])
    assert newrank==rx+1
    if sep is not None:
        u=np.zeros(n,dtype=np.uint8);u[sep]=1
        assert not np.any((X@u)%2) and int((w@u)%2)==1
    d=distance(C);dt=distance(C.T)
    assert len(support)<d['distance']
    return {'E':E,'L':L,'n':n,'rank_X':rx,'rank_Z':rz,'k':n-rx-rz,'classical':d,'transpose_classical':dt,'quantum_logical_weight':len(support),'quantum_logical_support':support,'augmented_rank_X':newrank,'girth_classical':bfs_girth(C),'girth_X':bfs_girth(X),'girth_Z':bfs_girth(Z),'row_weights_X':sorted(set(map(int,X.sum(axis=1)))),'column_weights_X':sorted(set(map(int,X.sum(axis=0)))),'matrix_sha256':{'C':hashlib.sha256(C.tobytes()).hexdigest(),'HX':hashlib.sha256(X.tobytes()).hexdigest(),'HZ':hashlib.sha256(Z.tobytes()).hexdigest()},'seconds':time.monotonic()-start}

if __name__=='__main__':
    c=json.loads((R/'counterexample.json').read_text())
    out=[verify(c['E'],11,c['quantum_witness'],c['separator']),verify([[0,0,0,0],[0,4,8,12],[0,3,13,10]],16,[256,260,264,268,304,308,312,316])]
    report={'method':'Independent dense NumPy coefficient/Kronecker expansion, binary elimination and complete classical kernel enumeration; separate BFS graph search. No discovery-program imports.','numpy_version':np.__version__,'counterexamples':out}
    (R/'independent-verification.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps([{k:v for k,v in x.items() if k in ['L','n','k','rank_X','quantum_logical_weight','girth_classical','seconds']} for x in out]),flush=True)
