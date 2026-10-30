"""Find source-universal dense Boolean integer forms from numerical PSD defects.

The full physical moment matrix is only a numerical discovery device. Each
returned row is the exact expansion of -binomial(c + sum(w_e I_e), 2) <= 0.
An independent full-support consumer must accept it before integration.
"""
from pathlib import Path
from functools import lru_cache, reduce
from math import gcd
import argparse, hashlib, json, time
import numpy as np

N=1440; V=36495
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()

@lru_cache(None)
def pair_layout():
    a,b=np.triu_indices(N,1)
    sa,va=np.divmod(a,720);sb,vb=np.divmod(b,720)
    i,t=np.divmod(va,16);j,u=np.divmod(vb,16);h=(u-t)%16
    reverse=h>8;h=np.where(reverse,16-h,h)
    ii=np.where(reverse,j,i);jj=np.where(reverse,i,j)
    symmetric=(h==0)|(h==8);i=np.where(symmetric,np.minimum(ii,jj),ii)
    j=np.where(symmetric,np.maximum(ii,jj),jj)
    coordinate=45+np.where(sa==sb,0,18225)+2025*h+45*i+j
    assert np.all((coordinate>=45)&(coordinate<V))
    return a,b,coordinate.astype(np.int64)

def compile_dense(events,weights,c):
    assert type(c)is int and 0<len(events)<=N and len(events)==len(weights)==len(set(events))
    assert all(type(e)is int and 0<=e<N for e in events)
    assert all(type(w)is int for w in weights)
    magnitude=sum(map(abs,weights)); bound=abs(c)*magnitude+(magnitude*magnitude+magnitude)//2
    assert bound < (1<<62), 'guarded exact int64 arithmetic'
    w=np.zeros(N,dtype=np.int64);w[events]=weights
    row=np.zeros(V,dtype=np.int64);a,b,coordinate=pair_layout()
    np.add.at(row,(np.arange(N)%720)//16,-(c*w+w*(w-1)//2))
    np.add.at(row,coordinate,-w[a]*w[b])
    indices=np.flatnonzero(row)
    return indices.tolist(),row[indices].tolist(),c*(c-1)//2

def scout(owner,maximum=12,scale=256):
    assert owner.shape==(V,) and np.all(np.isfinite(owner))
    a,b,coordinate=pair_layout();p=owner[(np.arange(N)%720)//16]
    M=np.empty((N+1,N+1));M[0,0]=1;M[0,1:]=M[1:,0]=p
    M[1:,1:][a,b]=M[1:,1:][b,a]=owner[coordinate]
    np.fill_diagonal(M[1:,1:],p)
    eigenvalues,eigenvectors=np.linalg.eigh(M)
    cuts=[];seen=set();attempted=0
    for k,value in enumerate(eigenvalues):
        if value>=-1e-8 or len(cuts)>=maximum:break
        attempted+=1;v=eigenvectors[:,k];w=np.rint(scale*v[1:]/max(abs(v[1:]))).astype(np.int64)
        events=np.flatnonzero(w).tolist();weights=w[events].tolist()
        if not events:continue
        c=int(np.rint(.5-float(w@p)))
        indices,coefficients,rhs=compile_dense(events,weights,c)
        gap=sum(float(q)*owner[j] for j,q in zip(indices,coefficients))-rhs
        norm=sum(map(abs,coefficients))+abs(rhs)
        if gap<=1e-9*max(1,norm):continue
        common=reduce(gcd,[abs(rhs),*map(abs,coefficients)])
        key=(tuple(zip(indices,[q//common for q in coefficients])),rhs//common)
        if key in seen:continue
        seen.add(key)
        cuts.append({'events':events,'weights':weights,'constant':c,'owner_indices':indices,
          'owner_coefficients':coefficients,'rhs':rhs,'numeric_gap':gap,'normalized_numeric_gap':gap/norm,
          'discovery_eigenvalue':float(value),'eigenvector_index':k})
    return cuts,{'minimum_eigenvalue':float(eigenvalues[0]),'negative_eigenvalues_below_1e_8':int((eigenvalues < -1e-8).sum()),
                 'eigenvectors_attempted':attempted,'accepted_for_independent_review':len(cuts)}

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--model-prefix',type=Path,required=True)
    ap.add_argument('--solution',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--maximum',type=int,default=12);a=ap.parse_args();assert not a.output.exists()
    start=time.monotonic();data_path=a.model_prefix.with_suffix('.linear-data.npz')
    data=np.load(data_path);solution=np.load(a.solution);owner=solution['x'][data['owner_to_canonical']]
    cuts,diagnostic=scout(owner,a.maximum)
    out={'status':'DENSE_INTEGER_FORM_NUMERICAL_SCOUT','source_C16_answered':False,
         'source_anchor_excluded':False,'cuts':cuts,'diagnostic':diagnostic,
         'source_hashes':{str(p):sha(p) for p in [Path(__file__),data_path,a.solution,
           Path('physical-pool-source.json'),Path('moment-resumption-results/symmetry-bridge-independent.json')]},
         'seconds':time.monotonic()-start,
         'scope':'Universal integer-form row candidates. Numerical separation only; independent full-support polynomial/source replay required. No exact source obstruction.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ('cuts','source_hashes')},flush=True)
if __name__=='__main__':main()
