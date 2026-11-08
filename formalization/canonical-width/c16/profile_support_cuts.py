"""Exact integer support bounds and optional LP-guided local-hull separation."""
from pathlib import Path
from itertools import combinations,product
from math import gcd
from functools import reduce
import argparse,gzip,hashlib,json,time
import numpy as np
from scipy.optimize import linprog
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def normalize(c,b):
    g=reduce(gcd,map(abs,c));assert g and b%g==0;return [int(v//g) for v in c],int(b//g)
def check(cut,hull):
    c=cut['coefficients'];assert len(c)==9 and all(type(v) is int for v in c) and type(cut['bound']) is int
    terms=[(i,v) for i,v in enumerate(c) if v];assert terms
    maximum=max(sum(c*shape['moments'][i] for i,c in terms) for shape in hull['shapes']);assert maximum==cut['bound'];return len(hull['shapes'])
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--numeric',type=Path);ap.add_argument('--parent',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();hp=ROOT/'algebraic-results/hulls-16-rank.json.gz';hulls=json.loads(gzip.decompress(hp.read_bytes()));assert hulls['period']==16 and hulls['mode']=='rank';cuts=[];diagnostics=[]
    if a.parent:
        parent=json.loads(a.parent.read_text());assert parent['hulls_sha256']==sha(hp);cuts=list(parent['cuts'])
    seen={(r['orbit'],tuple(r['coefficients'])) for r in cuts};before=len(cuts)
    if a.numeric:
        z=np.load(a.numeric)
        for r in hulls['records']:
            o=r['orbit'];features=np.array([s['moments'] for s in r['shapes']],dtype=np.int64);target=np.array([16*z['p'][o]]+[16*z[f'S{h}'][o,o] for h in range(1,9)])
            objective=np.r_[-target,1.0];A=np.column_stack([features,-np.ones(len(features))]);lp=linprog(objective,A_ub=A,b_ub=np.zeros(len(features)),bounds=[(-1,1)]*9+[(None,None)],method='highs',options={'time_limit':5.0});rec={'orbit':o,'LP_status':lp.status,'numeric_support_gap':-float(lp.fun) if lp.fun is not None else None}
            if lp.success and lp.fun < -1e-6:
                c=np.rint(lp.x[:9]*(1<<20)).astype(np.int64);b=int(max(features@c));c,b=normalize(c.tolist(),b);violation=float(np.dot(c,target)-b);rec['rounded_cut_violation']=violation
                if violation>1e-6 and (o,tuple(c)) not in seen:cuts.append({'orbit':o,'coefficients':c,'bound':b,'discovery':'LP direction rounded to integer; support recomputed exactly'});seen.add((o,tuple(c)))
            diagnostics.append(rec)
    else:
        directions=[]
        for n in (1,2):
            for ids in combinations(range(9),n):
                for signs in product((-1,1),repeat=n):
                    c=[0]*9
                    for i,v in zip(ids,signs):c[i]=v
                    directions.append(c)
        D=np.array(directions,dtype=np.int64)
        for r in hulls['records']:
            o=r['orbit'];features=np.array([s['moments'] for s in r['shapes']],dtype=np.int64);bounds=np.max(features@D.T,axis=0)
            for c,b in zip(directions,bounds):
                if (o,tuple(c)) not in seen:cuts.append({'orbit':o,'coefficients':c,'bound':int(b),'discovery':'All signed directions on one or two feature coordinates'});seen.add((o,tuple(c)))
    checked=sum(check(c,hulls['records'][c['orbit']]) for c in cuts)
    result={'status':'EXACT_SUPPORT_BOUNDS_CHECKED','source_C16_answered':False,'hulls_sha256':sha(hp),'source_profile_hulls_completeness_receipt_sha256':sha(ROOT/'algebraic-results/preflight-replay/profile-hulls.json'),'cuts':cuts,'new_cuts':len(cuts)-before,'all_shape_integer_inequality_checks':checked,'numeric_sha256':sha(a.numeric) if a.numeric else None,'parent_sha256':sha(a.parent) if a.parent else None,'diagnostics':diagnostics,'source_sha256':sha(Path(__file__)),'elapsed_seconds':time.monotonic()-start,'scope':'Every cut is bounded by the exact maximum over all43473 certified local shapes. These necessary inequalities replace profile weights only in an outer relaxation. Numerical membership/nonseparation is not an exact local-hull certificate; no frame or source obstruction follows from a floating status.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print({k:v for k,v in result.items() if k not in ('cuts','diagnostics')},flush=True)
if __name__=='__main__':main()
