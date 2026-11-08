#!/usr/bin/env python3
"""No-solver exact map/control audit of the joint fixed-law producer."""
from pathlib import Path
from fractions import Fraction as Q
import argparse, hashlib, json, time
from two_basis_joint_fixed_star import prepare, compile_star, shift, recover
from verify_two_basis_joint_fixed_star import read, sha, load_inputs, check_values, star_value, ROOT

def val(e,x):return e[0]+sum(c*x[j] for j,c in e[1].items())
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True)
    ap.add_argument('--x-allocation',type=Path,required=True);ap.add_argument('--z-allocation',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic()
    configs={};Y={};sources={}
    for side,path in [('X',a.x_allocation),('Z',a.z_allocation)]:
        p=path.with_name(path.name.removesuffix('.json.gz')+'.frozen.json');configs[side]=p
        c=read(path);assert c['status']=='EXACT_DIRECT_COUNT_ALLOCATION_REQUIRES_REPLAY' and c['frozen_sha256']==sha(p)
        rp=path.with_name(path.name.removesuffix('.json.gz')+'-independent.json');receipt=read(rp)
        assert receipt['status']=='PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS' and receipt['certificate_sha256']==sha(path)
        assert receipt['consumer_sha256']==sha(ROOT/'verify_two_basis_rank_closed_allocation.py')
        Y[side]=[list(map(Q,row)) for row in c['exact_allocations']]
        for q in [path,p,rp]:sources[str(q)]=sha(q)
    producer_sha=sha(ROOT/'two_basis_joint_fixed_star.py')
    model=prepare(a.point,configs,[])
    x=[Y[side][m][j] for side,j,m in model['variables']]
    assert len(x)==len(set(tuple(v) for v in model['variables']))
    coordinate_checks=0
    for side in ['X','Z']:
        for m in range(16):
            for j in range(720):
                assert val(model['E'][side][m][j],x)==Y[side][m][j];coordinate_checks+=1
    assert all(val(e,x)==0 for e in model['equalities'])
    gaps=[val(e,x) for e in model['inequalities']];assert max(gaps)<=0
    assert all(v>0 for v in model['scales'])
    # Freeze an in-memory no-star schema and run the independent literal consumer.
    f=dict(status='FROZEN_JOINT_FIXED_LAW_OWNER_STAR_ALLOCATION_GATE',
        point_sha256=sha(a.point),source_hashes={**model['sources'],'two_basis_joint_fixed_star.py':producer_sha},
        X_anchors=model['X_anchors'],Z_anchors=model['Z_anchors'],lambda_masses=list(map(str,model['lambda_masses'])),
        x_config=str(configs['X']),z_config=str(configs['Z']),variables=model['variables'],
        variable_count=len(x),star_cut_count=0,star_banks=[])
    inputs=load_inputs(f,a.point);literal=check_values(Y,inputs)
    # Signed synthetic rows stress sector offsets and all four coefficient blocks.
    synthetic=0
    for k in range(64):
        cut=dict(side=['X','Z'][k%2],probe=k,rhs=0,
            lambda_coefficients=[[m,(-1 if (k+m)%2 else 1)*(1+(m+k)%5)] for m in range(16)],
            X_coefficients=[[m,(73*m+17*k)%720,(-1 if (m+k)%2 else 1)*(1+k%7)] for m in range(16)],
            Z_coefficients=[[m,(97*m+29*k)%720,(-1 if (m+k+1)%2 else 1)*(1+k%11)] for m in range(16)],
            T_coefficients=[[18270+45*(k%45)+j,(-1 if (j+k)%2 else 1)*(1+j%3)] for j in range(16)])
        e=compile_star(cut,model['E'],model['lambda_masses'],inputs['owner'])
        assert val(e,x)==star_value(cut,inputs['lam'],Y,inputs['owner']);synthetic+=1
    # Positive and negative rational coefficients exercise offset renumbering itself.
    for off in [0,len(configs),len(x)//2,len(x)]:
        e=(Q(-7,13),{0:Q(3,7),2:Q(-11,5)})
        z=[Q(j-10,17) for j in range(off+3)]
        assert val(shift(e,off),z)==e[0]+sum(c*z[off+j] for j,c in e[1].items())
    assert sha(ROOT/'two_basis_joint_fixed_star.py')==producer_sha
    sources.update(inputs['sources']);sources[Path(__file__).name]=sha(__file__)
    sources['verify_two_basis_joint_fixed_star.py']=sha(ROOT/'verify_two_basis_joint_fixed_star.py')
    out=dict(status='PASS_EXACT_JOINT_NO_STAR_MAPPING_CONTROL',producer_sha256=producer_sha,
        auditor_sha256=sha(__file__),source_hashes=sources,variables=len(x),
        reconstructed_allocations=coordinate_checks,global_bucket_equations=len(model['equalities']),
        symbolic_inequalities_checked=len(gaps),minimum_exact_slack=str(-max(gaps)),
        signed_synthetic_star_rows=synthetic,shift_controls=4,literal_checks=literal,
        solver_launched=False,source_C16_answered=False,all_subset_rank_membership_proved=False,
        scope='Accepted separate allocations satisfy every no-star joint-model row; all literal target equations are independently replayed. Synthetic stars verify coefficient translation, not source validity of arbitrary invented inequalities.',
        elapsed_seconds=time.monotonic()-start)
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='source_hashes'}),flush=True)
if __name__=='__main__':main()
