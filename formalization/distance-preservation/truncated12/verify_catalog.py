"""Replay final certificates using only integer arithmetic and the source incidence.

Does not import the discovery generators or symbolic-algebra libraries.
The source/support topology theorem remains a separate mathematical obligation.
"""
from pathlib import Path
from itertools import combinations
from collections import Counter,deque
import gzip,hashlib,json,time

R=Path(__file__).resolve().parent
Z=(0,)*6
def variable(i,j):
    a=[0]*6
    if i and j:a[3*(i-1)+j-1]=1
    return tuple(a)
def sub(a,b):return tuple(x-y for x,y in zip(a,b))
def add(a,b):return tuple(x+y for x,y in zip(a,b))
def mul(k,a):return tuple(k*x for x in a)

def rebuild(weight,p):
    pairs=[]
    if weight==7:
        ks=p['column_map'];ls=p['row_map']
        assert sorted(ks)==list(range(4)) and sorted(ls)==list(range(3))
        vertices=[('U',j,ks[j]) for j in range(4)]+[('V',ls[i],i) for i in range(3)]
        pairs=[(j,4+i,j,i) for j in range(4) for i in range(3)]
    elif weight==10:
        cs=p['columns'];rs=p['rows'];bits=p['flips']
        assert len(cs)==3 and len(rs)==2 and len(bits)==6
        assert all(len(x)==2 and x[0]<x[1] and min(x)>=0 and max(x)<4 for x in cs)
        assert all(len(x)==2 and x[0]<x[1] and min(x)>=0 and max(x)<3 for x in rs)
        assert all(x in (0,1) for x in bits)
        vertices=[('U',j+1,k) for j,ks in enumerate(cs) for k in ks]
        vertices += [('V',l,i+1) for i,ls in enumerate(rs) for l in ls]
        pairs=[(2*j,2*j+1,j+1,0) for j in range(3)]
        for i in range(2):
            pairs.append((6+2*i,6+2*i+1,0,i+1))
            for j in range(3):
                for t in range(2):pairs.append((2*j+t,6+2*i+(t^bits[3*i+j]),j+1,i+1))
    else:
        ks=p['single_columns'];ls=p['row_map'];ca,cb=p['centers'];leaves=p['leaves'];orientation=p['orientation']
        assert len(ks)==len(set(ks))==3 and all(0<=x<4 for x in ks)
        assert sorted(ls)==list(range(3)) and orientation in (1,2)
        assert 0<=ca<4 and 0<=cb<4 and len(leaves)==3
        assert all(0<=x<4 and x not in (ca,cb) for x in leaves)
        vertices=[('U',j,ks[j]) for j in range(3)]+[('U',3,x) for x in [ca,cb]+leaves]+[('V',ls[i],i) for i in range(3)]
        pairs=[(j,8+i,j,i) for j in range(3) for i in range(3)]
        for leaf in range(3):
            pairs += [(3,5+leaf,3,(leaf+orientation)%3),(4,5+leaf,3,(leaf-orientation)%3),(5+leaf,8+leaf,3,leaf)]
    assert len(vertices)==weight
    def offset(vertex,j,i):
        side,a,b=vertex
        if side=='U':assert a==j;return variable(i,b)
        assert b==i;return mul(-1,variable(a,j))
    adjacency=[[] for _ in vertices];sockets=[set() for _ in vertices];normal=set()
    equations=[]
    for a,b,j,i in pairs:
        assert a!=b and tuple(sorted((a,b))) not in normal
        normal.add(tuple(sorted((a,b))))
        for v in (a,b):
            socket=i if vertices[v][0]=='U' else j
            assert socket not in sockets[v];sockets[v].add(socket)
        d=sub(offset(vertices[a],j,i),offset(vertices[b],j,i));equations.append((a,b,d))
        adjacency[a].append((b,d));adjacency[b].append((a,mul(-1,d)))
    for v,s in zip(vertices,sockets):assert s==set(range(3 if v[0]=='U' else 4))
    assert all(not ((a,b) in normal and (a,c) in normal and (b,c) in normal) for a,b,c in combinations(range(weight),3))
    potentials={0:Z};queue=deque([0])
    while queue:
        a=queue.popleft()
        for b,d in adjacency[a]:
            if b not in potentials:potentials[b]=add(potentials[a],d);queue.append(b)
    assert len(potentials)==weight
    rows=[]
    for a,b,d in equations:
        row=sub(add(potentials[a],d),potentials[b])
        if row!=Z:rows.append(row)
    return rows

def target_forms(c):
    kind=c['kind'];loc=c['locator']
    if kind=='cycle4':
        i,k,a,b=loc;assert 0<=i<k<3 and 0<=a<b<4
        return [add(sub(variable(i,a),variable(k,a)),sub(variable(k,b),variable(i,b)))]
    if kind=='cycle6':
        a,b,c=loc;assert len({a,b,c})==3 and all(0<=x<4 for x in loc)
        return [add(sub(variable(1,b),variable(1,a)),sub(variable(2,c),variable(2,b)))]
    if kind=='partial_row':
        k,a,b,c=loc;assert 0<=k<3 and 0<=a<b<c<4
        i,j=[x for x in range(3) if x!=k]
        values=[sub(add(variable(i,x),variable(j,x)),mul(2,variable(k,x))) for x in [a,b,c]]
        return [sub(values[1],values[0]),sub(values[2],values[0])]
    if kind=='column_rcpc':
        a,b,c,d=loc;assert sorted(loc)==list(range(4))
        return [sub(add(variable(i,a),variable(i,b)),add(variable(i,c),variable(i,d))) for i in [1,2]]
    if kind=='cyclic_torsion':
        n,i,k=loc;assert n in (2,3) and 0<=i<k<3
        return [mul(n,sub(variable(i,j),variable(k,j))) for j in [1,2,3]]
    if kind=='column_two_torsion':
        a,b=loc;assert 0<=a<b<4
        return [mul(2,sub(variable(i,a),variable(i,b))) for i in [1,2]]
    if kind=='classical_weight_le10':
        a,b=loc;assert a==0 and 0<b<4
        return [mul(5,variable(i,b)) for i in [1,2]]
    raise AssertionError(kind)

if __name__=='__main__':
    reports=[];start=time.monotonic()
    for weight,n,name in [(7,144,'completed-patterns-7.jsonl.gz'),(10,124416,'final-patterns-10.jsonl.gz'),(11,58752,'completed-patterns-11.jsonl.gz')]:
        path=R/name;seen=set();counts=Counter()
        with gzip.open(path,'rt') as f:
            for idx,line in enumerate(f):
                rec=json.loads(line);assert rec['id']==idx
                p=rec['pattern'];key=json.dumps(p,sort_keys=True);assert key not in seen;seen.add(key)
                rows=rebuild(weight,p);c=rec['certificate'];forms=target_forms(c)
                assert [list(x) for x in forms]==c['forms'] and len(forms)==len(c['coefficients'])
                for target,coeff in zip(forms,c['coefficients']):
                    assert len(coeff)==len(rows) and all(isinstance(x,int) for x in coeff)
                    actual=tuple(sum(coeff[i]*rows[i][j] for i in range(len(rows))) for j in range(6))
                    assert actual==target
                counts[c['kind']]+=1
                if (idx+1)%25000==0:print(json.dumps({'weight':weight,'checked':idx+1}),flush=True)
        assert len(seen)==n
        reports.append({'weight':weight,'patterns':n,'counts':dict(counts),'catalog_sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
    out={'status':'PASS','independent_of':'No imports from discovery generators, SymPy or Smith decomposition. All source offsets, sockets, cycle equations, target forms and integer identities reconstructed. Exact unique pattern counts verify the declared parameter universes.','scope_limit':'This verifies restricted pattern certificates. It does not by itself prove every actual small logical has one of these topologies or establish the finite enumeration theorem in Lean.','reports':reports,'seconds':time.monotonic()-start,'verifier_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
    (R/'catalog-verification.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
