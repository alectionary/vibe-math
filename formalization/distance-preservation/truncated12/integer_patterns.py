"""Discovery with exact integer relation certificates; independent replay required.

Enumerate the restricted socket topologies described in PROTOCOL.txt. Smith
decomposition is used only to FIND coefficients; saved certificates are plain
integer linear combinations, whose verification needs no symbolic algebra.
"""
from pathlib import Path
from itertools import combinations, permutations, product
from collections import Counter
import argparse, gzip, json, time
from sympy import ZZ
from sympy.polys.matrices import DomainMatrix
from sympy.polys.matrices.normalforms import smith_normal_decomp

ROOT = Path(__file__).resolve().parent
ZERO = (0,) * 6

def entry(i, j):
    return tuple(int(i > 0 and j > 0 and k == (i-1)*3+j-1) for k in range(6))

def plus(a, b, sign=1):
    return tuple(x+sign*y for x, y in zip(a, b))

def scale(n, a):
    return tuple(n*x for x in a)

def constraints(vertices, edges):
    """Edges (a,b,d) mean fiber(b)=fiber(a)+d; derive cycle equations."""
    adj = [[] for _ in vertices]
    for a, b, d in edges:
        adj[a].append((b,d)); adj[b].append((a,scale(-1,d)))
    pot = {0: ZERO}; queue = [0]
    for a in queue:
        for b, d in adj[a]:
            if b not in pot:
                pot[b] = plus(pot[a],d); queue.append(b)
    assert len(pot) == len(vertices)
    rows = []
    for a, b, d in edges:
        row = plus(plus(pot[a],d),pot[b],-1)
        if row != ZERO:
            rows.append(row)
    duplicates=[]
    for a,b in combinations(range(len(vertices)),2):
        if vertices[a] == vertices[b]:
            duplicates.append((a,b,plus(pot[a],pot[b],-1)))
    return rows,pot,duplicates

def pattern10():
    cp=list(combinations(range(4),2));rp=list(combinations(range(3),2))
    for cs in product(cp,repeat=3):
        for rs in product(rp,repeat=2):
            for flips in product(range(2),repeat=6):
                vs=[('U',j+1,c) for j in range(3) for c in cs[j]]
                vs += [('V',r,i+1) for i in range(2) for r in rs[i]]
                edges=[]
                for j in range(3):
                    edges.append((2*j,2*j+1,ZERO)) # missing row0
                for i in range(2):
                    edges.append((6+2*i,6+2*i+1,ZERO)) # missing col0
                    for j in range(3):
                        f=flips[i*3+j]
                        for t in range(2):
                            r=rs[i][f^t];c=cs[j][t]
                            edges.append((2*j+t,6+2*i+(f^t),plus(entry(i+1,c),entry(r,j+1))))
                yield {'columns':cs,'rows':rs,'flips':flips},vs,edges

def pattern11():
    # U0..2 are singleton groups j0..2; U3,4 are K2,3 centers;
    # U5..7 leaves with missing colors 0..2; V8..10 have second index0..2.
    for ks in permutations(range(4),3):
        for ls in permutations(range(3)):
            for ca,cb in product(range(4),repeat=2):
                available=[k for k in range(4) if k not in (ca,cb)]
                for leaves in product(available,repeat=3):
                    for orientation in (1,2):
                        vs=[('U',j,ks[j]) for j in range(3)]
                        vs += [('U',3,k) for k in (ca,cb)+leaves]
                        vs += [('V',ls[i],i) for i in range(3)]
                        edges=[]
                        for j in range(3):
                            for i in range(3):
                                edges.append((j,8+i,plus(entry(i,ks[j]),entry(ls[i],j))))
                        for leaf in range(3):
                            for center,k,color in [(3,ca,(leaf+orientation)%3),(4,cb,(leaf-orientation)%3)]:
                                edges.append((center,5+leaf,plus(entry(color,k),entry(color,leaves[leaf]),-1)))
                            edges.append((5+leaf,8+leaf,plus(entry(leaf,leaves[leaf]),entry(ls[leaf],3))))
                        yield {'single_columns':ks,'row_map':ls,'centers':(ca,cb),'leaves':leaves,'orientation':orientation},vs,edges

def pattern7():
    for ks in permutations(range(4)):
        for ls in permutations(range(3)):
            vs=[('U',j,ks[j]) for j in range(4)]+[('V',ls[i],i) for i in range(3)]
            edges=[(j,4+i,plus(entry(i,ks[j]),entry(ls[i],j))) for j in range(4) for i in range(3)]
            yield {'column_map':ks,'row_map':ls},vs,edges

def forbidden_forms():
    out=[]
    for i,k in combinations(range(3),2):
        for a,b in combinations(range(4),2):
            out.append(('cycle4',(i,k,a,b),[plus(plus(entry(i,a),entry(k,a),-1),plus(entry(k,b),entry(i,b),-1))]))
    seen=set()
    for a,b,c in permutations(range(4),3):
        f=plus(plus(entry(1,b),entry(1,a),-1),plus(entry(2,c),entry(2,b),-1))
        canonical=min(f,scale(-1,f))
        if canonical not in seen:
            seen.add(canonical);out.append(('cycle6',(a,b,c),[f]))
    for k in range(3):
        i,j=[x for x in range(3) if x!=k]
        values=[plus(plus(entry(i,c),entry(j,c)),scale(-2,entry(k,c))) for c in range(4)]
        for a,b,c in combinations(range(4),3):
            out.append(('partial_row',(k,a,b,c),[plus(values[b],values[a],-1),plus(values[c],values[a],-1)]))
    for b in range(1,4):
        c,d=[x for x in range(1,4) if x!=b]
        out.append(('column_rcpc',(0,b,c,d),[plus(plus(entry(i,0),entry(i,b)),plus(entry(i,c),entry(i,d)),-1) for i in (1,2)]))
    return out

def decompose(rows):
    m=len(rows)
    D,S,T=smith_normal_decomp(DomainMatrix([[ZZ(v) for v in r] for r in rows],(m,6),ZZ))
    ds=D.to_list();ss=S.to_list();tt=T.to_list()
    def certificate(f):
        q=[]
        for j in range(6):
            v=sum(f[k]*tt[k][j] for k in range(6));d=ds[j][j] if j<m else 0
            if d:
                if v%d:return None
                q.append(v//d)
            elif v:return None
            else:q.append(0)
        return [int(sum(q[k]*ss[k][j] for k in range(min(m,6)))) for j in range(m)]
    return certificate,[int(ds[i][i]) for i in range(min(m,6))]

def classify(mode):
    gen={7:pattern7,10:pattern10,11:pattern11}[mode]
    path=ROOT/f'integer-patterns-{mode}.jsonl.gz';summary=ROOT/f'integer-patterns-{mode}-summary.json'
    if path.exists():raise RuntimeError('Preserve existing discovery output')
    counts=Counter();smith=Counter();cache={};start=time.monotonic();forms=forbidden_forms()
    with gzip.open(path,'wt') as out:
        for idx,(description,vs,edges) in enumerate(gen()):
            rows,pot,duplicates=constraints(vs,edges);key=tuple(rows)
            if key not in cache:
                cert,diag=decompose(rows);result=None
                for kind,locator,fs in forms:
                    coefficients=[cert(f) for f in fs]
                    if all(c is not None for c in coefficients):
                        result={'kind':kind,'locator':locator,'forms':fs,'coefficients':coefficients};break
                if result is None:
                    # A full row's four entries cannot all lie in a cyclic
                    # subgroup of order at most3 while its column differences
                    # are distinct (classical four-cycle exclusion).
                    for n in (2,3):
                        for i,k in combinations(range(3),2):
                            fs=[scale(n,plus(entry(i,j),entry(k,j),-1)) for j in range(1,4)]
                            coefficients=[cert(f) for f in fs]
                            if all(c is not None for c in coefficients):
                                result={'kind':'cyclic_torsion','locator':(n,i,k),'forms':fs,'coefficients':coefficients};break
                        if result:break
                cache[key]=(result,diag)
            result,diag=cache[key]
            if result is None:
                cert,_=decompose(rows)
                for a,b,f in duplicates:
                    c=cert(f)
                    if c is not None:
                        result={'kind':'duplicate_coordinate','locator':(a,b),'forms':[f],'coefficients':[c]};break
            if result is None:result={'kind':'unclassified','smith_diagonal':diag}
            # Check the generated identities immediately; separate replay will
            # reconstruct the pattern and source equations without SymPy.
            for f,c in zip(result.get('forms',[]),result.get('coefficients',[])):
                assert tuple(sum(c[i]*rows[i][j] for i in range(len(rows))) for j in range(6))==tuple(f)
            counts[result['kind']]+=1;smith[tuple(diag)]+=1
            out.write(json.dumps({'id':idx,'pattern':description,'certificate':result},separators=(',',':'))+'\n')
            if (idx+1)%5000==0:print(json.dumps({'mode':mode,'processed':idx+1,'seconds':time.monotonic()-start,'counts':dict(counts)}),flush=True)
    record={'mode':mode,'patterns':sum(counts.values()),'counts':dict(counts),'distinct_matrices':len(cache),'smith_diagonals':{str(k):v for k,v in smith.items()},'seconds':time.monotonic()-start,'scope':'Exact integer identities for the explicitly enumerated restricted topology only; source/support classification is a separate proof obligation.'}
    summary.write_text(json.dumps(record,indent=2)+'\n');print(json.dumps(record),flush=True)

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('weight',type=int,choices=[7,10,11]);classify(ap.parse_args().weight)
