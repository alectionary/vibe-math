#!/usr/bin/env python3
"""Compare physical owner rows to prior polynomial formulas and exact controls."""
from pathlib import Path
from fractions import Fraction
import gzip,hashlib,json,time
import numpy as np
from physical_owner_moment_matrix import matrix
from verify_algebraic_model import physical
from moment_owner_cuts import common_events,neighbor_polynomials
from certify_profile_moment_point import layout
from verify_partial_frame import mask,shift
from audit_pools import exchange
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    start=time.monotonic();X,Z,A=physical();M,rows,meta=matrix(A);assert len(rows)==32355
    patterns=[[(A[16*i]>>(16*j))&65535 for j in range(45)] for i in range(45)];neighbors=neighbor_polynomials(patterns)
    for r in meta:
        i,k=r['anchor_orbit'],r['other_index'];j,h=divmod(k,16);expected={16*(b-45)+t for b,t in common_events({'i':i,'k':j,'l':h},patterns,neighbors=neighbors)};assert expected==set(r['common_opposite'])
    source=json.loads((ROOT/'physical-pool-source.json').read_text());Zp=[shift(mask(s),h) for s in source['Z_orbit_representatives'] for h in range(16)];Xp=list(map(exchange,Zp));xi={v:i for i,v in enumerate(Xp)};zi={v:i for i,v in enumerate(Zp)};pairs=[(xi[mask(r['X'])],zi[mask(r['Z'])]) for r in json.loads((ROOT/'partial-frame-88.json').read_text())['pairs']];assert len(pairs)==88
    assert all(((A[x]>>z)&1)==(i==j) for i,(x,_) in enumerate(pairs) for j,(_,z) in enumerate(pairs));masks=[[0]*45 for _ in range(2)]
    for x,z in pairs:
        for side,v in enumerate((x,z)):masks[side][v//16]|=1<<(v%16)
    corr=lambda a,b,h:(a&((b>>h)|(b<<(16-h)))&65535).bit_count()
    flat=[masks[0][i].bit_count()+masks[1][i].bit_count() for i in range(45)]
    for side in ('S','T'):
        for h in range(9):
            for i in range(45):
                for j in range(45):flat.append(sum(corr(masks[s][i],masks[s if side=='S' else 1-s][j],h) for s in (0,1)))
    residual=M@np.array(flat,dtype=np.int64);assert max(residual)<=0
    hulls=json.loads(gzip.decompress((ROOT/'algebraic-results/hulls-16-rank.json.gz').read_bytes()));names,index,m=layout(hulls);screens=[]
    for point in [ROOT/'algebraic-results/profile-moment-face1.json.gz',ROOT/'moment-resumption-results/interior-pivots-point.json.gz']:
        values=list(map(Fraction,json.loads(gzip.decompress(point.read_bytes()))['values']));flat=[values[index['p',i]] for i in range(45)]+[values[m(side,h,i,j)] for side in ('S','T') for h in range(9) for i in range(45) for j in range(45)];res=[sum(a*flat[c] for c,a in row) for row in rows]
        screens.append({'point_c16_path':str(point.relative_to(ROOT)),'sha256':sha(point),'violated_rows':sum(v>0 for v in res),'maximum_exact_violation':str(max(res)),'minimum_exact_slack':str(-max(res))})
    result={'status':'PASS','source_C16_answered':False,'folded_owner_inequalities':len(rows),'unfolded_sector_rows':2*len(rows),'matrix_nonzeros':M.nnz,'physical_common_neighbor_sets_compared_to_prior_formula':len(rows),'physical88_sector_and_cyclic_average_controls':len(rows),'old_and_new_candidate_screens':screens,'source_hashes':{p:sha(ROOT/p) for p in ['physical_owner_moment_matrix.py','prepare_physical_owner_moments.py','moment_owner_cuts.py','physical-pool-source.json']},'elapsed_seconds':time.monotonic()-start,
            'scope':'Reuses the previously justified private-partner ownership theorem. New physical-coordinate compiler is compared against the old polynomial-neighbor formula for every row and tested on the verified88-pair matching. This prepares combination with profile/capacity/forbidden-pattern moments, not a new ownership theorem or source answer.'}
    (ROOT/'moment-resumption-results/physical-owner-preparation.json').write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
