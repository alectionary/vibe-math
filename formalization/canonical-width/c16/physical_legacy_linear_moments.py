"""Translate earlier rectangle, triangle and integer-form constraints physically."""
from pathlib import Path
from collections import Counter
import gzip,json
from scipy.sparse import coo_matrix
from block_moment_dual import layout
from moment_triangle_cuts import constraint as triangle
from moment_integer_form_cuts import coefficients as integer_form
ROOT=Path(__file__).resolve().parent
def read(p):return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def build(mapping):
    p,C,n=layout(90,16);fold={};records=[];seen=set()
    def physical_event(i,h):
        side='X' if i<45 else 'Z';v=mapping[side][16*(i%45)+h];return (i//45,v)
    def coord_pair(i,j,h):
        si,a=physical_event(i,0);sj,b=physical_event(j,h);oa,ha=divmod(a,16);ob,hb=divmod(b,16);phase=(hb-ha)%16;side='S' if si==sj else 'T'
        if side=='S' and oa==ob and phase==0:return oa
        if phase>8:phase=16-phase;oa,ob=ob,oa
        if phase in (0,8) and oa>ob:oa,ob=ob,oa
        return 45+(0 if side=='S' else 9*2025)+2025*phase+45*oa+ob
    for i in range(90):fold[p[i]]=physical_event(i,0)[1]//16
    for h in range(9):
        for i in range(90):
            for j in range(90):assert fold.setdefault(C[h][i][j],coord_pair(i,j,h))==coord_pair(i,j,h)
    def save(terms,rhs,metadata):
        d=Counter()
        for j,c in terms:d[fold[j]]+=c
        row=tuple(sorted((j,c) for j,c in d.items() if c));key=(row,rhs)
        if key in seen:return
        seen.add(key);records.append({'coefficients':row,'rhs':rhs,'origin':metadata})
    folder=ROOT/'inverse-four-hour-results';chosen={(r['sector'],r['thin_mask'],r['thick_mask']) for r in read(folder/'lattice-source-rankcuts.json.gz')};rectangles={}
    for side in ('X','Z'):
        for r in read(folder/f'rank-rectangle-{side}.json'):
            cols=[(0 if side=='X' else 45)+9*t+i for t in range(5) if r['thin_mask']>>t&1 for i in range(9) if r['thick_mask']>>i&1];ids=tuple(sorted(physical_event(i,0)[1]//16 for i in cols));assert rectangles.setdefault(ids,r['rank'])==r['rank'];origin={'kind':'source_rank_rectangle','physical_orbits':ids,'rank':r['rank']}
            save([(p[j],16) for j in cols],r['rank'],origin)
            if (side,r['thin_mask'],r['thick_mask']) in chosen:
                for i in range(90):save([(C[h][i][j],1) for h in range(16) for j in cols]+[(p[i],-r['rank'])],0,{**origin,'conditional_anchor_old':i,'sector_old':side})
    for k,r in enumerate(read(folder/'lattice-source-triangles.json.gz')):
        terms,rhs=triangle(r,p,C,16);save(terms,rhs,{'kind':'Boolean_triangle','index':k})
    for k,r in enumerate(read(folder/'lattice-source-integer-forms.json.gz')):
        terms,rhs=integer_form(r,p,C,16);save(terms,rhs,{'kind':'integer_affine_form','index':k})
    ii=[];jj=[];vv=[]
    for k,r in enumerate(records):
        for j,c in r['coefficients']:ii.append(k);jj.append(j);vv.append(c)
    M=coo_matrix((vv,(ii,jj)),shape=(len(records),45+18*2025),dtype='int64').tocsr();return M,[r['rhs'] for r in records],records,rectangles,fold
