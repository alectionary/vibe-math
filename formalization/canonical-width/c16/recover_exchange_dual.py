#!/usr/bin/env python3
"""Recover a rational, residual-corrected cyclic dual from a stored split ray.

No optimization is run. Linear rows are unscaled using a separately regenerated
integer model; PSD matrices are congruence-lifted from sector plus/minus blocks.
Semantic source-row verification is a separate consumer obligation.
"""
from pathlib import Path
from collections import defaultdict
import argparse
import gzip
import json
import math
import numpy as np
from scipy.sparse import load_npz
from certify_rank_moment_dual import unsvec


def exchange_layout(q):
    p=list(range(q));counter=q;families=[]
    for _ in range(2):
        C={}
        for h in range(9):
            M=[[None]*q for _ in range(q)]
            if h in [0,8]:
                for i in range(q):
                    for j in range(i,q):
                        M[i][j]=M[j][i]=counter;counter+=1
            else:
                for j in range(q):
                    for i in range(q):M[i][j]=counter;counter+=1
            C[h]=M
        for h in range(9,16):C[h]=list(map(list,zip(*C[16-h])))
        families.append(C)
    S,T=families
    C={h:[S[h][i]+T[h][i] for i in range(q)]+[T[h][i]+S[h][i] for i in range(q)] for h in range(16)}
    return p,S,T,p+p,C,counter


def old_new(meta,q):
    p,S,T,_,_,V=exchange_layout(q)
    names={v:k for k,v in meta['variables'].items()};out={}
    for name,indices in [('exchange_first',p)]+[(prefix+str(h),[M[h][i][j] for i in range(q) for j in range(i,q)] if h in [0,8] else [M[h][i][j] for j in range(q) for i in range(q)]) for prefix,M in [('S',S),('T',T)] for h in range(9)]:
        start=meta['offsets'][names[name]]
        for i,j in enumerate(indices):out[start+i]=j
    assert set(out)==set(range(V)) and len(set(out.values()))==V
    return out


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--normalized',type=Path,required=True)
    ap.add_argument('--integer',type=Path,required=True)
    ap.add_argument('--ray',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--families',type=int,nargs='+',default=[0,3,4])
    a=ap.parse_args()
    mn=json.loads(a.normalized.with_suffix('.canonical.json').read_text());mi=json.loads(a.integer.with_suffix('.canonical.json').read_text())
    An=load_npz(a.normalized.with_suffix('.A.npz')).tocsr();Au=load_npz(a.integer.with_suffix('.A.npz')).tocsr()
    bn=np.load(a.normalized.with_suffix('.bc.npz'))['b'];bu=np.load(a.integer.with_suffix('.bc.npz'))['b']
    ray=np.load(a.ray)['y'];assert len(ray)==An.shape[0]==Au.shape[0]
    assert mn['zero']==mi['zero'] and mn['nonneg']==mi['nonneg'] and mn['psd']==mi['psd']
    z=mi['zero'];end=z+mi['nonneg'];q=mi['psd'][0]-1;N=2*q;P=16
    from verify_exchange_dual import prepare_source, ROOT, read
    families=sorted(set(a.families))
    active=prepare_source(read(ROOT/'inversion-results/normal-form.json'),families)[0]
    assert len(active)==q
    assert mi['psd']==[q+1,q]+[v for k in range(1,9) for v in ([2*q,2*q] if k<8 else [q,q])]
    assert np.max(abs(Au[:end].data-np.rint(Au[:end].data)))<1e-12
    assert np.max(abs(bu[:end]-np.rint(bu[:end])))<1e-12
    eqscale=[]
    for i in range(end):
        un=Au[i:i+1];nn=An[i:i+1]
        assert np.array_equal(un.indices,nn.indices)
        if len(un.data):scale=nn.data[0]/un.data[0]
        elif bu[i]:scale=bn[i]/bu[i]
        else:scale=1.
        assert scale>0 and np.max(abs(nn.data-scale*un.data),initial=0)<1e-10
        assert abs(bn[i]-scale*bu[i])<1e-9
        eqscale.append(scale)
    yy=ray[:end]*np.array(eqscale)
    matrices=[];offset=end
    for d in mi['psd']:
        size=d*(d+1)//2
        matrices.append(unsvec(ray[offset:offset+size],d));offset+=size
    assert offset==len(ray)
    even,odd=matrices[:2]
    Y0=np.zeros((N+1,N+1));Y0[0,0]=even[0,0]
    Y0[0,1:q+1]=Y0[0,q+1:]=even[0,1:]/2
    Y0[1:,0]=Y0[0,1:]
    Y0[1:q+1,1:q+1]=Y0[q+1:,q+1:]=even[1:,1:]/4+odd/2
    Y0[1:q+1,q+1:]=Y0[q+1:,1:q+1]=even[1:,1:]/4-odd/2
    U={};W={}
    for k in range(1,9):
        parts=[]
        for Y in matrices[2+2*(k-1):4+2*(k-1)]:
            parts.append((Y,np.zeros_like(Y)) if k==8 else ((Y[:q,:q]+Y[q:,q:])/2,(Y[q:,:q]-Y[:q,q:])/2))
        up,vp=parts[0];um,vm=parts[1]
        U[k]=np.block([[up+um,up-um],[up-um,up+um]])/2
        W[k]=np.block([[vp+vm,vp-vm],[vp-vm,vp+vm]])/2
    D={}
    for h in range(9):
        B=Y0[1:,1:]+((-1)**h)*U[8]
        for k in range(1,8):B=B+2*(math.cos(2*math.pi*k*h/P)*U[k]+math.sin(2*math.pi*k*h/P)*W[k])
        D[h]=B/P
    p,S,T,fullp,fullC,V=exchange_layout(q);mapping=old_new(mi,q)
    den=1<<40
    dd={h:np.rint(B*den).astype(np.int64).tolist() for h,B in D.items()}
    for h in [0,8]:
        for i in range(N):
            for j in range(i,N):dd[h][i][j]=dd[h][j][i]=round((dd[h][i][j]+dd[h][j][i])/2)
    mean=np.rint(Y0[0,1:]/4*den).astype(np.int64).tolist();constant=round(float(Y0[0,0])*den)
    integerA=Au[:end].copy();integerA.data=np.rint(integerA.data).astype(np.int64)
    # Reordering canonical columns only changes bookkeeping, not coefficients.
    rows=[]
    for i in range(end):
        rr=integerA[i:i+1]
        rows.append((tuple(sorted((mapping[int(j)],int(v)) for j,v in zip(rr.indices,rr.data) if v)),round(float(bu[i]))))
    for threshold in [1e-7,1e-8,0.]:
        terms=defaultdict(int)
        for i,y in enumerate(yy):
            if abs(y)<threshold:continue
            mult=round(float(y)*den)
            if i>=z:mult=max(0,mult)
            if mult:terms[('eq' if i<z else 'ineq',rows[i])]+=mult
        linear=[{'kind':kind,'coeff':key[0],'rhs':key[1],'multiplier':v} for (kind,key),v in terms.items() if v]
        for shift in [1e-7,1e-6,1e-5,1e-4]:
            delta=math.ceil(shift*den);Ds={h:[r[:] for r in B] for h,B in dd.items()}
            for i in range(N):Ds[0][i][i]+=delta
            residual=[0]*V;b=constant+delta
            for t in linear:
                b+=t['rhs']*t['multiplier']
                for j,v in t['coeff']:residual[j]+=v*t['multiplier']
            for i in range(N):residual[fullp[i]]-=2*P*mean[i]
            for h in range(P):
                B=Ds[h] if h<=8 else list(map(list,zip(*Ds[P-h])))
                for i in range(N):
                    for j in range(N):residual[fullC[h][i][j]]-=P*B[i][j]
            lower=sum(min(0,v) for v in residual);gap=b-lower
            print('RATIONAL_RESIDUAL',threshold,shift,'gap',gap/den,'terms',len(linear),flush=True)
            if gap>=0:continue
            cert={'status':'RATIONAL_EXCHANGE_DUAL_CANDIDATE','source_C16_answered':False,'X_thin_families':families,'Z_thin_families':families,'layout':'original-active-sector-exchange','original_active_orbits':active,'period':16,'target':128,'denominator':den,'constant':constant+delta,'mean':mean,'D':Ds,'linear_terms':linear,'sparsification_threshold':threshold,'identity_shift_numerator':delta,'box_gap_numerator':gap,'consumer_obligations':'Regenerate source-valid linear rows in this quotient layout and independently check the rational PSD congruence. No exact source exclusion claimed until both pass.'}
            from rational_cyclic_psd import generate
            try:psd,check=generate(cert)
            except (AssertionError,np.linalg.LinAlgError) as e:
                print('PSD_RETRY',str(e)[:150],flush=True);continue
            a.output.write_bytes(gzip.compress((json.dumps(cert)+'\n').encode(),mtime=0))
            a.output.with_suffix('.PSD.json.gz').write_bytes(gzip.compress((json.dumps(psd)+'\n').encode(),mtime=0))
            a.output.with_suffix('.PSD.checked.json').write_text(json.dumps(check,indent=2)+'\n')
            print('RATIONAL_PSD_CANDIDATE',flush=True)
            return
    raise AssertionError('No strict residual-corrected PSD candidate recovered')


if __name__=='__main__':main()
