"""Exact local-box projection to five shared higher anchor moments.

The numerical six-variable max-margin LP proposes a rational primal/dual.
Exact row replay is mandatory; no cardinality or full-basis membership follows.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import defaultdict
import argparse,hashlib,json,time
import numpy as np
from scipy.optimize import linprog
from flint import fmpz_mat
from two_basis_structure import (LOW,HIGH,generator,anchor_feature,lambda_affine,
    lambda_values,status_normals,pattern_support,outer_row,solve_unique,compose_outer_cut)
from verify_algebraic_model import physical
from verify_two_sided_anchor_count import domain,columns
from verify_projected_profile_moment_rows import point_vector
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def local_classes(X,Z,xx,zz):
    statuses=[[-1]*16 for _ in range(1440)]
    for m in range(16):
        d=domain(X,Z,xx,zz,m);assert d is not None
        forced,buckets=d
        for j in forced:statuses[j][m]=1
        for _,free in buckets:
            for j in free:assert statuses[j][m]==-1;statuses[j][m]=0
    groups=defaultdict(list)
    for j,status in enumerate(statuses):groups[tuple(status)].append(j)
    return sorted(groups.items())

def moment_target(point,xx,zz):
    v=point_vector(point)
    return [Q(1) if j is None else v[j] for j in columns(xx,zz)]

def construct(X,Z,xx,zz,tar):
    low=tar[:11];rows=[];classes=[]
    for m in range(16):
        h=[int(m==j) for j in range(16)];a,b=outer_row(h,0,low)
        rows.append({'kind':'lambda_nonnegative','mask':m,'h':h,'feature_terms':[],'a':a,'b':b})
    for cid,(status,indices) in enumerate(local_classes(X,Z,xx,zz)):
        normals=status_normals(status);classes.append({'class':cid,'status':status,'indices':indices,**normals})
        for kind,normals_here in [('facet',normals['facet_normals']),('equality',normals['equality_normals'])]:
            for normal in normals_here:
                for sign in (1,-1):
                    v=[sign*x for x in normal];values=[sum(v[k]*tar[11+j if k==0 else 1451+1440*(k-1)+j] for k in range(5)) for j in indices];left=max(values);j=indices[values.index(left)];h=pattern_support(status,v);a,b=outer_row(h,left,low)
                    terms=[[11+j if k==0 else 1451+1440*(k-1)+j,v[k]] for k in range(5) if v[k]]
                    rows.append({'kind':kind,'class':cid,'vector':j,'normal':v,'h':h,'feature_terms':terms,'a':a,'b':b})
    return rows,classes

def exact_margin(rows):
    # Tautologies with zero coefficient need no margin; a negative constant
    # row is already a one-row exact Farkas certificate.
    fixed_bad=[i for i,r in enumerate(rows) if not any(r['a']) and r['b']<0]
    if fixed_bad:return {'status':'EXACT_CONSTANT_ROW_OBSTRUCTION','dual_indices':[fixed_bad[0]],'dual_weights':['1'],'exact_combined_rhs':str(rows[fixed_bad[0]]['b'])}
    kept=[i for i,r in enumerate(rows) if any(r['a'])]
    A=np.array([rows[i]['a']+[1] for i in kept],dtype=float);b=np.array([float(rows[i]['b']) for i in kept]);c=np.array([0]*5+[-1],dtype=float)
    lp=linprog(c,A_ub=A,b_ub=b,bounds=[(None,None)]*6,method='highs',options={'presolve':False,'time_limit':30,'primal_feasibility_tolerance':1e-9,'dual_feasibility_tolerance':1e-9})
    result={'numeric_status':int(lp.status),'numeric_message':lp.message,'numerical_margin':None if lp.x is None else float(lp.x[-1])}
    if lp.status!=0 or lp.x is None:return {**result,'status':'NUMERICAL_OUTER_INCONCLUSIVE'}
    tight=sorted(range(len(kept)),key=lambda i:abs(float(A[i]@lp.x-b[i])));chosen=[]
    for i in tight:
        trial=chosen+[i]
        if fmpz_mat([rows[kept[k]]['a']+[1] for k in trial]).rank()>len(chosen):chosen.append(i)
        if len(chosen)==6:break
    try:
        x=solve_unique([rows[kept[i]]['a']+[1] for i in chosen],[rows[kept[i]]['b'] for i in chosen]);assert all(sum(Q(a)*v for a,v in zip(r['a'],x[:5]))+x[5]<=r['b'] for r in rows if any(r['a']))
        indices=[kept[i] for i,z in enumerate(lp.ineqlin.marginals) if z< -1e-10];D=[[rows[i]['a'][j] for i in indices] for j in range(5)]+[[1]*len(indices)];z=solve_unique(D,[0]*5+[1]);assert all(v>=0 for v in z);value=sum(v*rows[i]['b'] for i,v in zip(indices,z));assert value==x[5]
    except (AssertionError,ZeroDivisionError) as error:return {**result,'status':'RATIONAL_RECOVERY_REJECTED','error':str(error),'numeric_solution':lp.x.tolist(),'numeric_dual_indices':[kept[i] for i,z in enumerate(lp.ineqlin.marginals) if z<0]}
    return {**result,'status':'EXACT_OUTER_FEASIBLE' if x[5]>=0 else 'EXACT_OUTER_INFEASIBLE','high_moments':list(map(str,x[:5])),'exact_margin':str(x[5]),'primal_active_rows':[kept[i] for i in chosen],'dual_indices':indices,'dual_weights':list(map(str,z)),'exact_combined_rhs':str(value)}

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--X',type=int,nargs=2,required=True);ap.add_argument('--Z',type=int,nargs=2,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic()
    paths=['two_basis_structure.py','two_basis_structure_zonotope.py','verify_algebraic_model.py','verify_two_sided_anchor_count.py','verify_projected_profile_moment_rows.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt'];hashes={p:sha(ROOT/p) for p in paths}
    frozen={'status':'FROZEN_FIVE_DIMENSIONAL_LOCAL_BOX_GATE','source_C16_answered':False,'point_sha256':sha(a.point),'X_anchors':a.X,'Z_anchors':a.Z,'source_hashes':hashes,'high_moment_subsets':HIGH,'scope':'Exact projection of per-vector conditional boxes only; bucket cardinalities, matroid ranks and unanchored pairings remain omitted.'};fp=a.output.with_suffix('.frozen.json');assert not fp.exists();fp.write_text(json.dumps(frozen,indent=2)+'\n')
    X,Z,A=physical();tar=moment_target(a.point,a.X,a.Z);rows,classes=construct(X,Z,a.X,a.Z,tar);solution=exact_margin(rows);out={**frozen,'frozen_sha256':sha(fp),'status':solution['status'],'classes':classes,'rows':[{**r,'b':str(r['b'])} for r in rows],'exact_target':list(map(str,tar)),'solution':solution,'elapsed_seconds':time.monotonic()-start}
    if solution['status']=='EXACT_OUTER_FEASIBLE':
        tau=list(map(Q,solution['high_moments']));lam=lambda_values(tar[:11],tau);assert min(lam)>=0 and sum(lam)==1 and all(sum(lam[m]*anchor_feature(m)[j] for m in range(16))==tar[j] for j in range(11));out['lambda_masses']=list(map(str,lam));seed={**frozen,'status':'EXACT_LOCAL_BOX_PATTERN_LAW_CANDIDATE','lambda_masses':out['lambda_masses'],'high_moments':solution['high_moments'],'parent_candidate':str(a.output),'scope':frozen['scope']};sp=a.output.with_suffix('.lambda.json');assert not sp.exists();sp.write_text(json.dumps(seed,indent=2)+'\n');out['lambda_seed_sha256']=sha(sp)
    elif solution['status'] in ('EXACT_OUTER_INFEASIBLE','EXACT_CONSTANT_ROW_OBSTRUCTION'):
        chosen=[rows[i] for i in solution['dual_indices']];z=list(map(Q,solution['dual_weights']));c=compose_outer_cut(chosen,z);assert sum(x*y for x,y in zip(c,tar))>0;out['projected_normal']=list(map(str,c));out['exact_projected_value']=str(sum(x*y for x,y in zip(c,tar)))
    assert all(sha(ROOT/p)==v for p,v in hashes.items());a.output.write_text(json.dumps(out,indent=2)+'\n');print({'status':out['status'],'classes':[(len(c['indices']),c['rank'],len(c['facet_normals']),len(c['equality_normals'])) for c in classes],'rows':len(rows),'solution':solution,'elapsed_seconds':out['elapsed_seconds']},flush=True)
if __name__=='__main__':main()
