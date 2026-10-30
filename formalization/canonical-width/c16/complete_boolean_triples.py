#!/usr/bin/env python3
"""Screen every Boolean triangle using rigorous fixed-point enclosures.

Pair bounds plus the triangle and union inequalities are precisely the
conditions for three Boolean variables to admit some joint distribution.
This does not require a common distribution across different triples.
"""
from pathlib import Path
from fractions import Fraction
from collections import Counter
import argparse,gzip,hashlib,json,math,time
import numpy as np
from scipy.sparse import coo_matrix
from certify_profile_moment_point import layout
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

def terms(cut):
    a,b,c=cut['events'];kind=cut['kind'];d=Counter()
    def pair(x,y):
        s,i=divmod(x,720);t,j=divmod(y,720);oi,hi=divmod(i,16);oj,hj=divmod(j,16);h=(hj-hi)%16
        if s==t and i==j:return oi
        if h>8:h=16-h;oi,oj=oj,oi
        if h in (0,8) and oi>oj:oi,oj=oj,oi
        return 45+(0 if s==t else 9*2025)+h*2025+oi*45+oj
    if kind=='triangle':
        d[(a%720)//16]-=1;d[pair(a,b)]+=1;d[pair(a,c)]+=1;d[pair(b,c)]-=1;rhs=0
    else:
        assert kind=='union'
        for e in (a,b,c):d[(e%720)//16]+=1
        for x,y in ((a,b),(a,c),(b,c)):d[pair(x,y)]-=1
        rhs=1
    return tuple(sorted((j,v) for j,v in d.items() if v)),rhs

def matrix(paths):
    rows=[];rhs=[];seen=set()
    for path in paths:
        for cut in json.loads(path.read_text())['cuts']:
            row,b=terms(cut)
            if (row,b) not in seen:seen.add((row,b));rows.append(row);rhs.append(b)
    ii=[];jj=[];vv=[]
    for i,row in enumerate(rows):
        for j,v in row:ii.append(i);jj.append(j);vv.append(v)
    return coo_matrix((vv,(ii,jj)),shape=(len(rows),45+18*2025),dtype=np.int64).tocsr(),np.array(rhs),rows

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--per-anchor',type=int,default=100);a=ap.parse_args();start=time.monotonic()
    hulls=json.loads(gzip.decompress((ROOT/'algebraic-results/hulls-16-rank.json.gz').read_bytes()));_,index,m=layout(hulls)
    v=list(map(Fraction,json.loads(gzip.decompress(a.point.read_bytes()))['values']))
    scale=1<<50;lo=np.array([x.numerator*scale//x.denominator for x in v],dtype=np.int64);hi=np.array([-((-x.numerator*scale)//x.denominator) for x in v],dtype=np.int64)
    ids=np.empty((1440,1440),dtype=np.int32)
    for e in range(1440):
        s,i=divmod(e,720)
        ids[e]=[m('S' if s==t else 'T',(j-i)%16,i//16,j//16) for t in (0,1) for j in range(720)]
    L=lo[ids];H=hi[ids];pids=np.array([index['p',(e%720)//16] for e in range(1440)]);pL=lo[pids];pH=hi[pids]
    b,c=np.triu_indices(1440,1);cuts=[];records=[];checked=0;uncertain=0;violations=0
    for orbit in range(45):
        anchor=16*orbit;valid=(b!=anchor)&(c!=anchor);bb=b[valid];cc=c[valid];rec={'anchor_orbit':orbit,'families':{}}
        for kind in ('triangle','union'):
            upper=H[anchor,bb]+H[anchor,cc]-L[bb,cc]-pL[anchor] if kind=='triangle' else pH[anchor]+pH[bb]+pH[cc]-L[anchor,bb]-L[anchor,cc]-L[bb,cc]-scale
            possible=np.flatnonzero(upper>0);checked+=len(bb);uncertain+=len(possible);bad=[]
            for k in possible:
                x,y=int(bb[k]),int(cc[k])
                exact=v[ids[anchor,x]]+v[ids[anchor,y]]-v[ids[x,y]]-v[pids[anchor]] if kind=='triangle' else v[pids[anchor]]+v[pids[x]]+v[pids[y]]-v[ids[anchor,x]]-v[ids[anchor,y]]-v[ids[x,y]]-1
                if exact>0:bad.append((exact,x,y))
            violations+=len(bad);bad.sort(reverse=True)
            for value,x,y in bad[:a.per_anchor]:cuts.append({'kind':kind,'events':[anchor,x,y],'exact_violation':str(value)})
            rec['families'][kind]={'rows':len(bb),'exact_fallback_rows':len(possible),'violated':len(bad),'max_exact_violation':str(bad[0][0]) if bad else None}
        records.append(rec);print(rec,flush=True)
    out={'status':'PASS' if not violations else 'SEPARATED','source_C16_answered':False,'point_sha256':sha(a.point),'consumer_sha256':sha(Path(__file__)),'fixed_point_scale':scale,'all_rows_checked_including_symmetry_duplicates':checked,'exact_fallback_rows':uncertain,'violated_rows':violations,'selected_cuts':len(cuts),'per_anchor_family_cap':a.per_anchor,'cuts':cuts,'records':records,'elapsed_seconds':time.monotonic()-start,'scope':'Complete three-distinct-event triangle and union families under already checked cyclic/sector moment symmetries. Existing exact pair bounds plus PASS imply a separate joint distribution for each triple; not one common distribution or a source frame.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print('FINISHED',out['status'],checked,violations,len(cuts),flush=True)
if __name__=='__main__':main()
