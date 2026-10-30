#!/usr/bin/env python3
"""Literal exact acceptance of joint fixed-law count/rank/star allocations.

No discovery model, numerical solver, elimination or recovery code is imported.
Every retained physical coordinate is checked directly. Listed rank/star rows
do not imply all-rank membership, joint-frame membership or source exclusion.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse, copy, gzip, hashlib, json, time
from verify_two_sided_full_basis_oracle import physical_source, domains, target, point_owner
from verify_two_basis_direct_allocation import check_allocation

ROOT=Path(__file__).resolve().parent
RANK_CONSUMERS={
    'PASS_EXACT_CONTRACTED_PATTERN_RANK_CUTS':['two_basis_structure_verify_rank_screen.py'],
    'PASS_EXACT_PATTERN_CONTRACTED_RANK_ROWS':['verify_two_basis_rank_allocation.py','verify_two_basis_rank_geometry_allocation.py','verify_two_basis_rank_closed_allocation.py'],
    'PASS_COMPLETE_CONTRACTED_RANK_LE_3_GEOMETRY':['two_basis_structure_verify_small_geometry.py'],
    'PASS_EXACT_PHYSICAL_CONDITIONAL_RANK_ROWS':['two_basis_structure_verify_physical_rank_bank.py'],
    'PASS_EXACT_PHYSICAL_CONDITIONAL_CLOSED_RANK_ROWS':['two_basis_structure_verify_physical_closed_rank_bank.py'],
}

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def frozen_path(p):return p.with_name(p.name.removesuffix('.json.gz').removesuffix('.json')+'.frozen.json')
def rank(vectors):
    B={}
    for v in vectors:
        while v:
            p=(v&-v).bit_length()-1
            if p in B:v^=B[p]
            else:B[p]=v;break
    return len(B)
def source_guard(mapping,seen):
    for p,h in mapping.items():
        assert sha(ROOT/p)==h
        if p in seen:assert seen[p]==h
        seen[p]=h
def normrow(r):return {k:r[k] for k in ['mask','forced_zero_indices','indices','contraction_rank']}
def rowkey(r):return r['mask'],tuple(r['forced_zero_indices']),tuple(r['indices']),r['contraction_rank']
def exact_terms(terms,width,limits):
    assert isinstance(terms,list)
    keys=[]
    for t in terms:
        assert isinstance(t,list) and len(t)==width and all(type(v)is int for v in t)
        assert t[-1]!=0
        assert all(lo<=v<hi for v,(lo,hi) in zip(t[:-1],limits))
        keys.append(tuple(t[:-1]))
    assert len(keys)==len(set(keys))
    return terms
def star_value(cut,lam,y,owner):
    assert cut['side'] in ['X','Z'] and type(cut['probe'])is int and 0<=cut['probe']<720
    assert type(cut['rhs'])is int and cut['rhs']==0
    value=Q(0)
    for m,c in exact_terms(cut['lambda_coefficients'],2,[(0,16)]):value+=c*lam[m]
    for side in ['X','Z']:
        for m,j,c in exact_terms(cut[side+'_coefficients'],3,[(0,16),(0,720)]):value+=c*y[side][m][j]
    for j,c in exact_terms(cut['T_coefficients'],2,[(18270,36495)]):value+=c*owner[j]
    return value

def load_inputs(f,point):
    assert f['status']=='FROZEN_JOINT_FIXED_LAW_OWNER_STAR_ALLOCATION_GATE'
    assert f['point_sha256']==sha(point)
    seen={};source_guard(f['source_hashes'],seen)
    assert f['source_hashes']['two_basis_joint_fixed_star.py']==sha(ROOT/'two_basis_joint_fixed_star.py')
    cfg={side:read(ROOT/f[side.lower()+'_config']) for side in ['X','Z']}
    lam=list(map(Q,f['lambda_masses']));assert len(lam)==16 and min(lam)>=0 and sum(lam)==1
    assert all(not l for m,l in enumerate(lam) if m.bit_count()>2)
    xx,zz=f['X_anchors'],f['Z_anchors'];X,Z,_=physical_source();D=domains(X,Z,xx,zz)
    full=target(point,xx,zz);owner=point_owner(point)
    assert [sum(lam[m] for m in range(16) if m&t==t) for t in [0,1,2,4,8,3,5,9,6,10,12]]==full[:11]
    rank_rows={};wanted={};dd={};variables=[];starcuts=[]
    for s,side in enumerate(['X','Z']):
        c=cfg[side];path=f[side.lower()+'_config']
        assert f['source_hashes'][path]==sha(ROOT/path)
        assert [c[k] for k in ['side','X_anchors','Z_anchors','point_sha256']]==[side,xx,zz,sha(point)]
        assert list(map(Q,c['lambda_masses']))==lam
        source_guard(c['source_hashes'],seen)
        U=X if side=='X' else Z;dd[side]=[d[side] for d in D]
        wanted[side]=full[11+720*s:731+720*s]+[full[1451+1440*i+720*s+j] for i in range(4) for j in range(720)]
        variables.extend([side,*v] for v in c['variables'])
        inherited={}
        for spec in c['rank_banks']:
            bp,rp=ROOT/spec['bank'],ROOT/spec['receipt'];bank,receipt=read(bp),read(rp)
            assert sha(bp)==spec['bank_sha256']==receipt['bank_sha256'] and sha(rp)==spec['receipt_sha256']
            assert receipt['status'] in RANK_CONSUMERS
            assert receipt['consumer_sha256'] in [sha(ROOT/p) for p in RANK_CONSUMERS[receipt['status']]]
            assert [bank[k] for k in ['side','X_anchors','Z_anchors']]==[side,xx,zz]
            source_guard(bank['source_hashes'],seen)
            for row in bank['rows'] if receipt['status']=='PASS_COMPLETE_CONTRACTED_RANK_LE_3_GEOMETRY' else bank['cuts']:
                if lam[row['mask']]:inherited[rowkey(row)]=normrow(row)
        assert [inherited[k] for k in sorted(inherited)]==c['rank_rows']
        for r in c['rank_rows']:
            m,F,A,rr=[r[k] for k in ['mask','forced_zero_indices','indices','contraction_rank']]
            assert type(m)is int and 0<=m<16 and lam[m]>0 and type(rr)is int and rr>=0
            assert F==dd[side][m]['zero_forced'] and rank(U[j] for j in F)==len(F)
            assert A==sorted(set(A)) and all(type(j)is int and 0<=j<720 for j in A) and set(A)<=set(dd[side][m]['zero_free'])
            assert rank(U[j] for j in F+A)-len(F)==rr
        rank_rows[side]=c['rank_rows']
    assert variables==f['variables'] and len(variables)==f['variable_count']
    for spec in f['star_banks']:
        bp,rp=ROOT/spec['bank'],ROOT/spec['receipt'];bank,receipt=read(bp),read(rp)
        assert f['source_hashes'][spec['bank']]==sha(bp)==receipt['bank_sha256']
        assert f['source_hashes'][spec['receipt']]==sha(rp)
        assert receipt['status']=='PASS_EXACT_CONDITIONAL_OWNER_STAR_CUTS'
        assert receipt['consumer_sha256']==sha(ROOT/'verify_conditional_owner_star.py')
        assert bank['X_anchors']==xx and bank['Z_anchors']==zz
        source_guard(receipt['source_hashes'],seen);source_guard(bank['source_hashes'],seen)
        starcuts.extend(bank['cuts'])
    assert len(starcuts)==f['star_cut_count']
    return dict(lam=lam,dd=dd,wanted=wanted,rank_rows=rank_rows,starcuts=starcuts,owner=owner,configs=cfg,sources=seen)

def check_values(y,inputs):
    lam=inputs['lam'];checks={};slacks=[]
    assert set(y)=={'X','Z'}
    for side in ['X','Z']:
        checks[side]=check_allocation(y[side],lam,inputs['dd'][side],inputs['wanted'][side])
        for r in inputs['rank_rows'][side]:
            v=lam[r['mask']]*r['contraction_rank']-sum(y[side][r['mask']][j] for j in r['indices'])
            assert v>=0;slacks.append(v)
        for face in inputs['configs'][side]['local_face_fixes']:
            m,j=face['mask'],face['vector'];normal=face['normal'];assert len(normal)==5
            assert y[side][m][j]==Q(face['value'])
            upper=Q(0)
            for q,d in enumerate(inputs['dd'][side]):
                a=normal[0]+sum(normal[i+1] for i in range(4) if q>>i&1)
                allowed=set(d['zero_forced']+d['zero_free']+[j for B in d['bins'] for j in B])
                upper+=lam[q]*(a if j in d['forced'] else max(0,a) if j in allowed else 0)
            assert sum(Q(v)*inputs['wanted'][side][720*k+j] for k,v in enumerate(normal))==upper
    stars=[]
    for cut in inputs['starcuts']:
        value=star_value(cut,lam,y,inputs['owner']);assert value<=0;stars.append(-value)
    return dict(sector_checks=checks,target_equalities=7200,anchor_equalities=11,
        listed_rank_rows=sum(map(len,inputs['rank_rows'].values())),star_rows_checked=len(stars),
        minimum_rank_slack=str(min(slacks)) if slacks else None,
        minimum_star_slack=str(min(stars)) if stars else None)

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True)
    ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();assert not a.output.exists();start=time.monotonic();c=read(a.certificate);fp=frozen_path(a.certificate);f=read(fp)
    assert c['status']=='EXACT_JOINT_FIXED_ALLOCATION_REQUIRES_REPLAY' and c['frozen_sha256']==sha(fp)
    inputs=load_inputs(f,a.point);y={s:[list(map(Q,row)) for row in c['exact_allocations'][s]] for s in ['X','Z']}
    checks=check_values(y,inputs);assert c['exact_box_failures']==[] and c['exact_inequality_failures']==[]
    rejected=[]
    for side in ['X','Z']:
        for label,value in [('negative',Q(-1)),('changed-target',y[side][0][0]+Q(1,1<<55))]:
            z=copy.deepcopy(y);z[side][0][0]=value
            try:check_values(z,inputs)
            except AssertionError:rejected.append(side+'-'+label)
            else:raise AssertionError('corrupt joint allocation accepted')
    out=dict(status='PASS_EXACT_JOINT_FIXED_ALLOCATION_LISTED_RANK_AND_STAR_ROWS',
        certificate_sha256=sha(a.certificate),frozen_sha256=sha(fp),point_sha256=sha(a.point),
        consumer_sha256=sha(__file__),checks=checks,corruptions_rejected=rejected,
        source_hashes=inputs['sources'],elapsed_seconds=time.monotonic()-start,
        all_subset_rank_membership_proved=False,all_owner_stars_feasible_proved=False,
        two_sector_basis_membership_proved=False,shared_lambda_excluded=False,
        global_target_excluded=False,source_C16_answered=False,
        scope='Exact common-law allocation satisfying all physical count/box equations and only the supplied physical rank and owner-star rows.')
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
