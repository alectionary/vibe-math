#!/usr/bin/env python3
"""A shared phase-mask distribution, coupled to several selected anchors.

This strengthens separate one-orbit and conditional marginal tests. Numerical
LP status is exploratory. A positive saved cut is an exact integer functional
bounded separately on every cyclic class of source-allowed phase masks.
"""
from pathlib import Path
from fractions import Fraction
from collections import defaultdict
import argparse,gzip,hashlib,json,time
import numpy as np
from scipy.optimize import linprog
from scipy.sparse import coo_matrix,eye,hstack,csc_matrix
from certify_profile_moment_point import layout
from verify_weighted_matroid_cuts import rank
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def rotate(mask,h):return ((mask<<h)|(mask>>(16-h)))&65535
def features(mask):return (mask.bit_count(),)+tuple((mask&rotate(mask,h)).bit_count() for h in range(1,9))

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--orbit',type=int,default=27);ap.add_argument('--all-anchors',action='store_true');ap.add_argument('--seconds',type=float,default=120);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    hp=ROOT/'algebraic-results/hulls-16-rank.json.gz';pp=ROOT/'algebraic-results/orbit-rank-profiles.json.gz';hulls=json.loads(gzip.decompress(hp.read_bytes()));profiles=json.loads(gzip.decompress(pp.read_bytes()));_,index,m=layout(hulls);v=list(map(Fraction,json.loads(gzip.decompress(a.point.read_bytes()))['values']))
    hr=next(r for r in hulls['records'] if r['orbit']==a.orbit);pr=next(r for r in profiles['records'] if r['orbit']==a.orbit);shape_index={tuple(s['moments']):j for j,s in enumerate(hr['shapes'])};bad=bytearray(65536)
    for row in pr['minimal_bad_certificates']:bad[row['mask']]=1
    for mask in range(65536):
        if a.orbit==12 and mask.bit_count()>11:bad[mask]=1
        if bad[mask]:continue
        bits=mask
        while bits:
            bit=bits&-bits;bits-=bit
            if bad[mask^bit]:bad[mask]=1;break
    allowed=[mask for mask in range(65536) if not bad[mask]];assert len(allowed)==hr['phase_patterns'];classes=defaultdict(list)
    for mask in allowed:classes[min(rotate(mask,h) for h in range(16))].append(mask)
    classes=list(classes.values());shape_of=[shape_index[features(c[0])] for c in classes]
    assert all(len(c)==len(set(rotate(c[0],h) for h in range(16))) for c in classes)
    pools=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz'];selection_path=ROOT/'moment-resumption-results/common-profile32-all.json';selection=json.loads(selection_path.read_text());assert selection['point_sha256']==sha(a.point) and a.orbit==32;anchors=[tuple(anchor) for anchor,coefs in zip(selection['anchors'],selection['cuts'][0]['anchor_coefficients']) if any(coefs)]
    frozen={'status':'FROZEN_BEFORE_COMMON_PROFILE_PROBE','orbit':a.orbit,'anchors':anchors,'selection_bank_sha256':sha(selection_path),'point_sha256':sha(a.point),'script_sha256':sha(Path(__file__)),'hulls_sha256':sha(hp),'profiles_sha256':sha(pp),'seconds':a.seconds,'scope':'Shared unconditional cyclic phase distribution with separate anchor subdistributions and free shape weights; only first and second moments are fixed. No common distribution across anchors is required; necessary relaxation only.'}
    a.output.with_suffix('.frozen.json').write_text(json.dumps(frozen,indent=2)+'\n')
    shape_count=10;r=shape_count+17*len(anchors);ii=[];jj=[];vv=[];ui=[];uj=[];uv=[];columns=[]
    for c,masks in enumerate(classes):
        for row,coef in enumerate((1,*features(masks[0]))):
            if coef:ii.append(row);jj.append(c);vv.append(len(masks)*coef)
    column=len(classes)
    for k,(side,orbit) in enumerate(anchors):
        av=pools[0 if side=='S' else 1][16*orbit]
        for c,masks in enumerate(classes):
            for mask in masks:
                bits=[h for h in range(16) if mask>>h&1];vectors=[pools[0][16*a.orbit+h] for h in bits]
                if side=='T':compatible=sum((av&x).bit_count()%2 for x in vectors)<=1
                else:compatible=rank(vectors+[av])==len(vectors)+int(not (orbit==a.orbit and mask&1))
                if side=='S' and orbit==a.orbit:compatible=bool(mask&1)
                if not compatible:continue
                ii.append(shape_count+17*k);jj.append(column);vv.append(1)
                for h in bits:ii.append(shape_count+17*k+1+h);jj.append(column);vv.append(1)
                bound=len(columns);ui.extend([bound,bound]);uj.extend([column,c]);uv.extend([1,-1]);columns.append((k,c,mask,column));column+=1
    A=coo_matrix((vv,(ii,jj)),shape=(r,column),dtype=np.int64).tocsc();U=coo_matrix((uv,(ui,uj)),shape=(len(columns),column),dtype=np.int64).tocsc()
    b=[Fraction(1),16*v[index['p',a.orbit]],*[16*v[m('S',h,a.orbit,a.orbit)] for h in range(1,9)]]
    for side,orbit in anchors:b.extend([v[index['p',orbit]],*[v[m(side,h,orbit,a.orbit)] for h in range(16)]])
    C=hstack([A,eye(r),-eye(r)],format='csc');UC=hstack([U,csc_matrix((U.shape[0],2*r))],format='csc')
    lp=linprog(np.r_[np.zeros(column),np.ones(2*r)],A_eq=C,b_eq=list(map(float,b)),A_ub=UC,b_ub=np.zeros(U.shape[0]),bounds=(0,None),method='highs',options={'time_limit':a.seconds})
    cuts=[]
    if lp.status==0 and lp.fun>1e-7:
        for scale in (1,16,256,4096):
            y=np.rint(lp.eqlin.marginals*scale).astype(np.int64);positive=np.zeros(len(classes),dtype=np.int64)
            for k,c,mask,col in columns:
                value=int(y[shape_count+17*k])+sum(int(y[shape_count+17*k+1+h]) for h in range(16) if mask>>h&1)
                positive[c]+=max(0,value)
            excess=max(sum(int(q)*f for q,f in zip(y[:shape_count],(1,*features(masks[0]))))+(int(positive[c])+len(masks)-1)//len(masks) for c,masks in enumerate(classes))
            y[0]-=excess
            violation=sum(int(coef)*value for coef,value in zip(y,b))
            if violation>0:cuts.append({'unconditional_coefficients':y[:shape_count].tolist(),'anchor_coefficients':[y[shape_count+17*k:shape_count+17*(k+1)].tolist() for k in range(len(anchors))],'exact_violation':str(violation),'scale':scale});break
    result={'status':'EXACT_CUT_CANDIDATE' if cuts else 'NO_EXACT_CUT_FOUND','source_C16_answered':False,'orbit':a.orbit,'anchors':anchors,'allowed_masks':len(allowed),'cyclic_classes':len(classes),'shapes':len(shape_index),'unconditional_moment_rows':shape_count,'profile_weights_free':True,'variables':column,'equality_rows':r,'domination_rows':len(columns),'numeric_status':int(lp.status),'numeric_message':lp.message,'phase1_objective':float(lp.fun) if lp.fun is not None else None,'cuts':cuts,'point_sha256':sha(a.point),'frozen_sha256':sha(a.output.with_suffix('.frozen.json')),'elapsed_seconds':time.monotonic()-start,'scope':'Positive cuts use exact integer bounds over each allowed cyclic phase class; independent enumeration required before accepting. A zero numerical objective or timeout proves neither source feasibility nor this relaxation feasible.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
