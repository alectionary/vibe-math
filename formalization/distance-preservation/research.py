"""Exact binary source construction and frozen candidate generation. Python stdlib."""
from pathlib import Path
from itertools import combinations, permutations
import argparse, json, random, time
ROOT=Path(__file__).resolve().parent

def bit_indices(v):
    while v:
        b=v&-v; yield b.bit_length()-1;v^=b

def rref(rows,n):
    rows=list(rows); piv=[];r=0
    for c in range(n):
        k=next((k for k in range(r,len(rows)) if (rows[k]>>c)&1),None)
        if k is None:continue
        rows[r],rows[k]=rows[k],rows[r]
        for k in range(len(rows)):
            if k!=r and (rows[k]>>c)&1:rows[k]^=rows[r]
        piv.append(c);r+=1
        if r==len(rows):break
    return rows[:r],piv

def kernel(rows,n):
    red,piv=rref(rows,n);ps=set(piv)
    return [(1<<c)|sum(((row>>c)&1)<<p for row,p in zip(red,piv))
            for c in range(n) if c not in ps]

def echelon(rows):
    basis={}
    for v in rows:
        while v:
            p=v.bit_length()-1
            if p not in basis:basis[p]=v;break
            v^=basis[p]
    return basis

def reduce(v,basis):
    while v:
        p=v.bit_length()-1
        if p not in basis:return v
        v^=basis[p]
    return 0

def classical(E,L):
    m=len(E);n=len(E[0]);rows=[0]*(m*L)
    for i in range(m):
        for j in range(n):
            for t in range(L):rows[i*L+(t+E[i][j])%L]^=1<<(j*L+t)
    return rows

def product(E,L):
    m=len(E);n=len(E[0]);hx=[0]*(m*n*L);hz=[0]*(n*m*L)
    for i in range(m):
        for j in range(n):
            for t in range(L):
                # Row ((i,j),t); first qubit block ((k,j),s).
                for k in range(n):hx[(i*n+j)*L+t]^=1<<((k*n+j)*L+(t-E[i][k])%L)
                for l in range(m):hx[(i*n+j)*L+t]^=1<<((n*n+i*m+l)*L+(t+E[l][j])%L)
    for j in range(n):
        for i in range(m):
            for t in range(L):
                for k in range(n):hz[(j*m+i)*L+t]^=1<<((j*n+k)*L+(t-E[i][k])%L)
                for l in range(m):hz[(j*m+i)*L+t]^=1<<((n*n+l*m+i)*L+(t+E[l][j])%L)
    return hx,hz

def columns(rows,n):
    cols=[0]*n
    for i,row in enumerate(rows):
        for j in bit_indices(row):cols[j]|=1<<i
    return cols

def commutes(hx,hz):return all((x&z).bit_count()%2==0 for x in hx for z in hz)

def rcpc(E,L):
    m=len(E);n=len(E[0]);res=[]
    # Pair partitions: first remaining paired with each other, odd case one self-pair.
    def partitions(a):
        if not a:yield [];return
        if len(a)%2:
            for k in a:
                for p in partitions([v for v in a if v!=k]):yield [(k,k)]+p
            return
        i=a[0]
        for j in a[1:]:
            for p in partitions([v for v in a if v!=i and v!=j]):yield [(i,j)]+p
    for side,vs in [('row',E),('column',list(map(list,zip(*E))))]:
        for pairs in partitions(list(range(len(vs)))):
            sums=[tuple((a+b)%L for a,b in zip(vs[i],vs[j])) for i,j in pairs]
            if len(set(sums))==1:res.append([side,pairs])
    return res

def short_cycle(E,L):
    m=len(E);n=len(E[0])
    for i,j in combinations(range(m),2):
        for a,b in combinations(range(n),2):
            if (E[i][a]-E[j][a]+E[j][b]-E[i][b])%L==0:return 4
    for i,j,k in combinations(range(m),3):
        for a,b,c in permutations(range(n),3):
            if (E[i][a]-E[j][a]+E[j][b]-E[k][b]+E[k][c]-E[i][c])%L==0:return 6
    return None

def girth(rows,n):
    adj=[[] for _ in range(n+len(rows))]
    for i,row in enumerate(rows):
        for v in bit_indices(row):adj[v].append(n+i);adj[n+i].append(v)
    best=n+len(rows)+1
    for root in range(n):
        dist=[-1]*len(adj);parent=[-1]*len(adj);dist[root]=0;q=[root]
        for a in q:
            if 2*dist[a]>=best:continue
            for b in adj[a]:
                if dist[b]<0:dist[b]=dist[a]+1;parent[b]=a;q.append(b)
                elif parent[a]!=b:best=min(best,dist[a]+dist[b]+1)
    return best if best<=n+len(rows) else None

def exact_distance(rows,n,max_dim=27):
    basis=kernel(rows,n);k=len(basis)
    if k>max_dim:return {'kernel_dimension':k,'complete':False}
    best=n+1;witness=0;v=0
    for i in range(1,1<<k):
        j=(i&-i).bit_length()-1;v^=basis[j];w=v.bit_count()
        if w<best:best=w;witness=v
    return {'kernel_dimension':k,'complete':True,'distance':best,'witness':list(bit_indices(witness)),'enumerated_nonzero':(1<<k)-1}

def generate():
    rng=random.Random(20261025);records=[];counts=[]
    for L in range(6,25):
        accepted=[];seen=set();c4=c6=rpc=0
        for attempts in range(1,50001):
            vals=tuple(rng.randrange(L) for _ in range(6));E=[[0]*4,[0]+list(vals[:3]),[0]+list(vals[3:])]
            sc=short_cycle(E,L)
            if sc==4:c4+=1;continue
            if sc==6:c6+=1;continue
            if rcpc(E,L):rpc+=1;continue
            if vals in seen:continue
            seen.add(vals);accepted.append({'L':L,'E':E,'id':f'L{L}-{len(accepted)}'})
            if len(accepted)==5:break
        records.extend(accepted);counts.append({'L':L,'attempted':attempts,'four_cycle_rejects':c4,'six_cycle_rejects':c6,'rcpc_rejects':rpc,'accepted':len(accepted)})
    out={'seed':20261025,'counts':counts,'candidates':records}
    (ROOT/'candidates.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(counts))

def regress():
    examples=[(7,[[0,0,0],[0,1,3]],6),(24,[[0,0,0,0],[0,1,2,3],[0,5,9,14]],20),(24,[[0,0,0,0],[0,1,3,7],[0,9,16,5]],20)]
    out=[]
    for L,E,d in examples:
        n=(len(E)**2+len(E[0])**2)*L;hx,hz=product(E,L)
        assert commutes(hx,hz)
        rec={'L':L,'E':E,'n':n,'rank_X':len(echelon(hx)),'rank_Z':len(echelon(hz)),'RCPC':rcpc(E,L),'girth_classical':girth(classical(E,L),len(E[0])*L),'short_cycle_filter':short_cycle(E,L)}
        assert (rec['girth_classical']>=8)==(rec['short_cycle_filter'] is None)
        if L<10:
            rec['classical']=exact_distance(classical(E,L),len(E[0])*L);assert rec['classical']['distance']==d
        out.append(rec)
    (ROOT/'regression.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out))

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('action',choices=['generate','regress']);a=ap.parse_args()
    {'generate':generate,'regress':regress}[a.action]()
