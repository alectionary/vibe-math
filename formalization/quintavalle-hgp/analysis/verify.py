"""Exact finite checks. Universal source theorems are not certified by this file."""
import itertools
import json
import re
import time
from pathlib import Path
import numpy as np
from gf2 import HGP, bit_rank, in_span, kernel, product3, rank, repetition, span, weights_upto

ROOT = Path(__file__).resolve().parents[1]


def seeds():
    h = np.array([[1,1,1,0,1,0,0],[1,0,1,1,0,1,0],[0,1,1,1,0,0,1]],dtype=np.uint8)
    ht = np.array([[1,1,0,1,1,0,0],[1,0,1,1,0,1,0],[0,1,1,1,0,0,1],[1,0,1,0,1,0,1]],dtype=np.uint8)
    return [('planar3',repetition(3),3),('planar5',repetition(5),5),('toric2',repetition(2,True),2),
            ('toric3',repetition(3,True),3),('hamming65',ht,3),('hamming98',(h.T@h)%2,3)]


def structural(c):
    assert not ((c.hx @ c.hz.T)%2).any()
    assert not ((c.hx @ c.lz.T)%2).any()
    assert not ((c.hz @ c.lx.T)%2).any()
    assert np.array_equal((c.lx@c.lz.T)%2,np.eye(c.k,dtype=np.uint8))
    assert c.n-rank(c.hx)-rank(c.hz)==c.k
    assert rank(c.hx)==bit_rank(c.hx) and rank(c.hz)==bit_rank(c.hz)
    assert rank(np.vstack((c.hx,c.lx)))==rank(c.hx)+c.k
    assert rank(np.vstack((c.hz,c.lz)))==rank(c.hz)+c.k
    # Direct-sum projection is idempotent and kills exactly the seed image.
    assert np.array_equal((c.pl@c.pl)%2,c.pl)
    assert not ((c.b@c.pl)%2).any()
    assert np.array_equal((c.pr@c.pr)%2,c.pr)
    assert not ((c.a.T@c.pr)%2).any()
    for basis in [c.lx,c.lz]:
        for v in basis:
            l=v[:c.left].reshape(c.na,c.nb);r=v[c.left:].reshape(c.ma,c.mb)
            grids=[x for x in [l,r] if x.any()]
            assert len(grids)==1
            g=grids[0]
            assert min(np.count_nonzero(g.any(axis=0)),np.count_nonzero(g.any(axis=1)))==1


def transform(x,z,kind,c):
    x=x.copy();z=z.copy();p=0
    if kind.startswith('sibling'):
        perm=np.r_[np.arange(c.left,c.n),np.arange(c.left)]
        pairs=[(i,c.left+i) for i in range(c.left)]
    else:
        perm=np.r_[np.arange(c.left).reshape(c.na,c.nb).T.ravel(),c.left+np.arange(c.n-c.left).reshape(c.ma,c.mb).T.ravel()]
        pairs=[(i,int(j)) for i,j in enumerate(perm) if i<j]
    if kind.endswith('hswap'):
        p=int(2*np.dot(x,z))%4
        return z[perm],x[perm],p
    if kind=='square-czs':
        for i,j in enumerate(perm):
            if i==j:
                if x[i]:
                    z[i]^=1;p+=(1 if i<c.left else -1)
    for i,j in pairs:
        p+=2*int(x[i])*int(x[j]);z[i]^=x[j];z[j]^=x[i]
    return x,z,p%4


def gates(c,symmetric):
    kinds=['square-hswap','square-czs']+(['sibling-hswap','sibling-cz'] if symmetric else [])
    records=[]
    for kind in kinds:
        checked=0
        failures=[]
        for b,typ in [(c.hx,'x'),(c.hz,'z')]:
            for generator,v in enumerate(b):
                zero=np.zeros(c.n,dtype=np.uint8)
                x,z,p=transform(v if typ=='x' else zero,v if typ=='z' else zero,kind,c)
                support_ok=in_span(x,c.hx) and in_span(z,c.hz)
                if not support_ok or p!=0:
                    failures.append(dict(type=typ,generator=generator,phase=p,support_ok=bool(support_ok),input=v.tolist(),output_x=x.tolist(),output_z=z.tolist()))
                checked+=1
        logical=[]
        for i,label in enumerate(c.labels):
            sector,j,k=label
            target=('R' if sector=='L' else 'L',j,k) if kind.startswith('sibling') else (sector,k,j)
            t=c.labels.index(target)
            for typ in ['x','z']:
                zero=np.zeros(c.n,dtype=np.uint8)
                x,z,p=transform(c.lx[i] if typ=='x' else zero,c.lz[i] if typ=='z' else zero,kind,c)
                ex=zero.copy();ez=zero.copy();ep=0
                if kind.endswith('hswap'):
                    if typ=='x':ez=c.lz[t]
                    else:ex=c.lx[t]
                elif typ=='z':ez=c.lz[i]
                else:
                    ex=c.lx[i];ez=c.lz[t]
                    if kind=='square-czs' and j==k:ep=1 if sector=='L' else 3
                assert np.array_equal(x,ex) and np.array_equal(z,ez) and p==ep
                logical.append(dict(index=i,type=typ,target=t,phase=p))
        records.append(dict(gate=kind,stabilizer_generators_checked=checked,logical_images_checked=len(logical),phase_sensitive=True,stabilizer_failures=failures))
    return records


def appendix_table():
    lines=(ROOT/'sources/browser-extraction.txt').read_text().splitlines()
    rows=[];matrix=[]
    for line in lines:
        if not re.match(r'L(46[2-8][0-9]|469[0-2])@P78:',line):continue
        s=line.split(': ',1)[1]
        if re.fullmatch(r'[01](?: [01]){6,}',s):matrix.append([int(x) for x in s.split()])
        elif re.fullmatch(r'\d+ \d+ 0\.\d+ \d+ \d+',s):
            n,k,rate,d,w=s.split();h=np.array(matrix,dtype=np.uint8);matrix=[]
            a=(h.T@h)%2
            assert rank(a)==bit_rank(a)
            ka,_=kernel(a);words=span(ka);distance=int(np.sum(words[1:],axis=1).min())
            ours=[2*a.shape[0]**2,2*len(ka)**2,distance,2*int(a.sum(axis=1).max())]
            expected=[int(n),int(k),int(d),int(w)]
            assert ours==expected,(ours,expected)
            # k,n and inherited d are computed independently of printed values.
            rows.append(dict(seed=h.tolist(),seed_rank=rank(h),product_seed_rank=rank(a),published=expected,ours=ours,
                             printed_rate=rate,computed_rate=ours[1]/ours[0],distance_scope='exact seed distance; quantum distance uses cited HGP theorem'))
    assert len(rows)==9
    return rows


def exhaustive(c):
    success_by_weight=[0]*(c.n+1);total_by_weight=[0]*(c.n+1);shape_success=0;shape_total=0
    # Cache decoder by syndrome; count every physical error independently.
    cache={}
    da=min(np.sum(v) for v in c.ca[1:]) if len(c.ca)>1 else float('inf')
    db=min(np.sum(v) for v in c.cbt[1:]) if len(c.cbt)>1 else float('inf')
    for bits in range(1<<c.n):
        e=np.array([(bits>>j)&1 for j in range(c.n)],dtype=np.uint8)
        s=c.syndrome(e);key=s.tobytes()
        if key not in cache:cache[key]=c.correct(e)
        residual=e^cache[key]
        assert not c.syndrome(residual).any()
        good=not c.logical(residual).any();w=int(e.sum())
        success_by_weight[w]+=int(good);total_by_weight[w]+=1
        l=e[:c.left].reshape(c.na,c.nb);r=e[c.left:].reshape(c.ma,c.mb)
        if np.count_nonzero(l.any(axis=1))<da/2 and np.count_nonzero(r.any(axis=0))<db/2:
            shape_total+=1;shape_success+=int(good);assert good
    return dict(errors=1<<c.n,success_by_weight=success_by_weight,total_by_weight=total_by_weight,
                shaped_errors_tested=shape_total,shaped_errors_corrected=shape_success)


def shadow():
    a=repetition(2);d0,hx,meta=product3(a,a,a.T)
    n=hx.shape[1];m=hx.shape[0]
    assert n==12 and not ((hx@d0)%2).any() and not ((meta@hx)%2).any()
    syndromes=np.array([sum(int(v)<<i for i,v in enumerate(row)) for row in hx.T],dtype=np.uint64)
    syn=np.zeros(1<<n,dtype=np.uint64)
    for e in range(1,1<<n):
        bit=e&-e;syn[e]=syn[e^bit]^syndromes[bit.bit_length()-1]
    leaders={}
    for e in sorted(range(1<<n),key=lambda x:(x.bit_count(),x)):
        leaders.setdefault(int(syn[e]),e)
    reduced={s:e.bit_count() for s,e in leaders.items()}
    # Source Definition 1 minimizes over ALL same-syndrome errors, not just stabilizers.
    assert all(4*w<=s.bit_count()**3 for s,w in reduced.items() if w<=4)
    shadow_s=[s for s,w in reduced.items() if w<=2]
    recoveries={obs:leaders[min(shadow_s,key=lambda s:((obs^s).bit_count(),s))] for obs in range(1<<m)}
    checked=0
    for s,w in reduced.items():
        if w>2:continue
        for noise in range(1<<m):
            residual_s=s^int(syn[recoveries[s^noise]])
            assert 4*reduced[residual_s]<=(2*noise.bit_count())**3
            checked+=1
    return dict(n=n,k=n-rank(hx)-rank(d0),syndrome_bits=m,physical_errors_enumerated=1<<n,
                syndrome_classes=len(leaders),shadow_checks=checked,confinement='4*reduced_weight <= syndrome_weight**3',
                reduced_weight_definition='minimum weight among all errors with the same syndrome',universal_proof=False)


def main():
    start=time.monotonic();result={'cases':[]}
    for name,a,d in seeds():
        c=HGP(a,a);structural(c)
        checked=0
        for e in weights_upto(c.n,(d-1)//2):
            residual=e^c.correct(e)
            assert not c.syndrome(residual).any() and not c.logical(residual).any()
            checked+=1
        symmetric=a.shape[0]==a.shape[1] and all(in_span(v,a) for v in a.T)
        item=dict(name=name,n=c.n,k=c.k,d=d,adversarial_errors=checked,gates=gates(c,symmetric))
        if c.n<=13:item['exhaustive']=exhaustive(c)
        result['cases'].append(item)
        print(name,'passed',flush=True)
    # Fully specified census, including zero and rank-deficient seed matrices.
    mats=[np.array([(v>>j)&1 for j in range(4)],dtype=np.uint8).reshape(2,2) for v in range(16)]
    for a,b in itertools.product(mats,repeat=2):structural(HGP(a,b))
    result['all_2_by_2_seed_pairs']=256
    result['appendix_table']=appendix_table()
    result['shadow']=shadow()
    result['elapsed_seconds']=time.monotonic()-start
    (ROOT/'results/exact_checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print('All exact checks passed',flush=True)


if __name__=='__main__':main()
