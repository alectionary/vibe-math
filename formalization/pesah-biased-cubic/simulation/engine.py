"""Original implementation of periodic cubic-code decoding for this replication."""
import itertools
import numpy as np
from scipy.sparse import csr_matrix


def lattice(L):
    """Boundary maps of the periodic cubical cell complex; axis-major edges."""
    sites=list(itertools.product(range(L),repeat=3)); n=3*L**3
    def edge(a,v): return a*L**3+np.ravel_multi_index(tuple(x%L for x in v),(L,)*3)
    def move(v,a,s=1):
        w=list(v);w[a]+=s;return w
    vertex=np.zeros((L**3,n),dtype=np.uint8)
    face=np.zeros((n,n),dtype=np.uint8)
    for i,v in enumerate(sites):
        for a in range(3):
            vertex[i,edge(a,v)]=1; vertex[i,edge(a,move(v,a,-1))]=1
    for normal in range(3):
        a,b=[j for j in range(3) if j!=normal]
        for i,v in enumerate(sites):
            for k,w in [(a,v),(b,v),(a,move(v,b)),(b,move(v,a))]:
                face[normal*L**3+i,edge(k,w)]=1
    strings=np.zeros((3,n),dtype=np.uint8);membranes=strings.copy()
    for a in range(3):
        for v in sites:
            if all(v[b]==0 for b in range(3) if b!=a): strings[a,edge(a,v)]=1
            if v[a]==0: membranes[a,edge(a,v)]=1
    return vertex,face,strings,membranes


def osd(H,s,probabilities,sort_kind="quicksort"):
    """Order-zero OSD via integer-row Gaussian elimination in reliability order."""
    order=np.argsort(-probabilities,kind=sort_kind)
    # Integer bit i is reliability-ordered column i; last bit is RHS.
    packed=np.packbits(H[:,order],axis=1,bitorder='little')
    n=H.shape[1]; rows=[int.from_bytes(x.tobytes(),'little')|(int(y)<<n) for x,y in zip(packed,s)]
    pivot=0;pivots=[]
    for col in range(n):
        bit=1<<col
        found=next((r for r in range(pivot,len(rows)) if rows[r]&bit),None)
        if found is None: continue
        rows[pivot],rows[found]=rows[found],rows[pivot]
        for r in range(len(rows)):
            if r!=pivot and rows[r]&bit: rows[r]^=rows[pivot]
        pivots.append(col);pivot+=1
        if pivot==len(rows): break
    answer=np.zeros(n,dtype=np.uint8)
    for r,c in enumerate(pivots): answer[order[c]]=(rows[r]>>n)&1
    return answer


class Decoder:
    def __init__(self,H,probabilities,iterations=10,sort_kind="quicksort"):
        self.sort_kind=sort_kind
        self.H=H;self.sparse=csr_matrix(H); self.iterations=iterations
        self.row,self.col=np.nonzero(H)
        self.degrees=H.sum(axis=1).astype(int)
        assert len(set(self.degrees))==1
        self.degree=int(self.degrees[0]); self.p=np.asarray(probabilities)
        self.prior=np.log((1-self.p-1e-8)/(self.p+1e-8))
    def decode(self,s):
        outgoing=self.prior[self.col].reshape(-1,self.degree).copy()
        for step in range(self.iterations):
            signs=np.sign(outgoing); total=signs.prod(axis=1)
            absolute=np.abs(outgoing); sorted_values=np.partition(absolute,1,axis=1)
            first=sorted_values[:,0];second=sorted_values[:,1]
            # Equal minima give identical excluded minima.
            minima=np.where(absolute>first[:,None],first[:,None],second[:,None])
            incoming=(1-2*s.astype(int))[:,None]*(1-2**(-step-1))*total[:,None]*signs*minima
            sums=np.bincount(self.col,weights=incoming.ravel(),minlength=self.H.shape[1])
            posterior=self.prior+sums; correction=(posterior<0).astype(np.uint8)
            if np.array_equal(self.sparse@correction%2,s): return correction,False
            outgoing=(self.prior[self.col]+sums[self.col]-incoming.ravel()).reshape(-1,self.degree)
        probabilities=1/(np.exp(np.clip(posterior,-700,700))+1)
        return osd(self.H,s,probabilities,self.sort_kind),True


def trial(decoders,graphs,errors,deformed):
    V,F,S,M=graphs;n=V.shape[1]
    ex=errors.copy();ez=np.zeros(n,dtype=np.uint8)
    if deformed: ez[:n//3]=ex[:n//3]; ex[:n//3]=0
    cx,ox=decoders[0].decode(decoders[0].sparse@ex%2)
    cz,oz=decoders[1].decode(decoders[1].sparse@ez%2)
    rx=ex^cx;rz=ez^cz
    valid=not(np.any(decoders[0].sparse@rx%2) or np.any(decoders[1].sparse@rz%2))
    point=bool(np.any(M@rx%2));loop=bool(np.any(S@rz%2))
    return int(not valid or point or loop),int(point),int(loop),int(ox),int(oz),int(not valid)


def make_decoders(graphs,p,deformed,iterations=10,sort_kind="quicksort"):
    V,F,_,_=graphs;n=V.shape[1];px=np.full(n,p);pz=np.zeros(n)
    if deformed:px[:n//3]=0;pz[:n//3]=p
    return Decoder(V,px,iterations,sort_kind),Decoder(F,pz,iterations,sort_kind)
