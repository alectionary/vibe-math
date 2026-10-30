#!/usr/bin/env python3
"""Independent full-archive audit of a fixed-lambda Minkowski Wolfe endpoint.

Every physical atom is checked; only the final support direction is exactly
repriced. Nonzero numerical residuals and negative final gaps stay inconclusive.
"""
from fractions import Fraction as Q
from pathlib import Path
import argparse
import json
import math
import time
import numpy as np
from verify_two_sided_full_basis_oracle import ROOT, sha, read, physical_source, domains, target, check_sector
from audit_two_sided_full_basis_endpoint import check_basis


def rows(mask, basis):
    return list(basis)+[720*(i+1)+j for i in range(4) if mask >> i & 1 for j in basis]


def audit(path):
    start=time.monotonic(); report=read(path)
    frozen_path=path.with_name(path.stem+'.frozen.json'); frozen=read(frozen_path)
    assert report['frozen_sha256']==sha(frozen_path)
    assert report['source_hashes']==frozen['source_hashes']
    assert all(sha(ROOT/p)==h for p,h in report['source_hashes'].items())
    for k,v in frozen.items():
        if k!='status': assert report[k]==v, k
    assert report['status']=='BOUNDED_FIXED_LAMBDA_L2_INCONCLUSIVE' and not report['cuts']
    assert not report['exact_membership_proved'] and not report['global_moment_cut_proved']
    assert report['selection_patterns']==list(range(16))
    point=ROOT/report['point_c16_path']; assert sha(point)==report['point_sha256']
    initial_path=ROOT/report['initial_atom_source']; initial=read(initial_path)
    assert sha(initial_path)==report['initial_atom_sha256']
    bound_receipts=[ROOT/p for p,h in report['source_hashes'].items() if h==report['initial_receipt_sha256']]
    assert len(bound_receipts)==1
    receipt=read(bound_receipts[0]); assert receipt['status']=='PASS_EXACT_PHYSICAL_SECTOR_MIXTURE_WITH_ERRORS'
    assert receipt['state_sha256']==sha(initial_path) and receipt['point_sha256']==sha(point)
    assert receipt['consumer_sha256']==sha(ROOT/'verify_two_basis_sector_state.py')
    side=report['side']; assert side in ('X','Z') and side==initial['side']
    xx,zz=report['X_anchors'],report['Z_anchors']; assert xx==initial['X_anchors'] and zz==initial['Z_anchors']
    X,Z,bridge=physical_source(); pool=X if side=='X' else Z
    dd=domains(X,Z,xx,zz); assert len(dd)==16 and all(d['feasible'] for d in dd)
    full=target(point,xx,zz); offset=720*(side=='Z')
    wanted=full[11+offset:731+offset]+[full[1451+1440*i+offset+j] for i in range(4) for j in range(720)]
    assert wanted==list(map(Q,report['sector_target']))==list(map(Q,initial['sector_target']))
    lam=list(map(Q,report['lambda_masses'])); assert lam==list(map(Q,initial['lambda_masses']))
    assert len(lam)==16 and min(lam)>=0 and sum(lam)==1
    for k in range(11):
        low=[]
        for m in range(16):
            bits=[(m>>i)&1 for i in range(4)]
            low.append([1,*bits,*[bits[i]*bits[j] for i in range(4) for j in range(i+1,4)]][k])
        assert sum(lam[m]*low[m] for m in range(16))==full[k]
    D=math.lcm(*(v.denominator for v in lam)); assert str(D)==report['aggregate_feature_denominator'] and 0<D<2**63
    numer=[int(v*D) for v in lam]
    initial_feature=[Q(0)]*3600; mass=[Q(0)]*16
    for r in initial['pattern_basis_records']:
        m,B,w=r['mask'],r['selected_indices'],Q(r['weight']); assert 0<=m<16 and w>0
        check_basis(pool,dd[m][side],B); mass[m]+=w
        for j in rows(m,B): initial_feature[j]+=w
    assert mass==lam and all(0<=v<=1 for v in initial_feature)
    positive=list(map(Q,initial['positive_feature_errors'])); negative=list(map(Q,initial['negative_feature_errors']))
    assert len(positive)==len(negative)==3600 and min(positive+negative)>=0
    assert all(x+p-n==b and p*n==0 for x,p,n,b in zip(initial_feature,positive,negative,wanted))
    assert sum(positive)+sum(negative)==Q(initial['phase_I_objective'])>0
    archive=Path(report['columns_artifact']); assert sha(archive)==report['columns_sha256']
    data=np.load(archive,allow_pickle=False)
    F,N,B=data['features'],data['feature_numerators'],data['pattern_selected_indices']
    w,active=data['master_mixture_weights'],data['active_atom_ids']; size=len(F)
    assert size==report['history_atoms'] and F.shape==N.shape==(size,3600) and B.shape==(size,16,128)
    assert F.dtype.kind=='f' and N.dtype.kind in 'iu' and B.dtype.kind in 'iu'
    assert np.isfinite(F).all() and F.min()>=0 and F.max()<=1
    assert str(data['aggregate_feature_denominator'])==str(D)
    assert np.all(N[0]==0) and np.all(B[0]==-1)
    assert np.array_equal(F[0],np.asarray(list(map(float,initial_feature))))
    for a in range(1,size):
        literal=np.zeros(3600,dtype=np.int64)
        for m in range(16):
            basis=list(map(int,B[a,m])); check_basis(pool,dd[m][side],basis)
            literal[rows(m,basis)]+=numer[m]
        assert np.array_equal(literal,N[a]) and int(literal.min())>=0 and int(literal.max())<=D
        assert np.array_equal(F[a],literal.astype(float)/D)
    assert w.shape==(size,) and np.isfinite(w).all() and w.min()>=0
    assert active.dtype.kind in 'iu' and len(set(map(int,active)))==len(active)
    assert all(0<=int(i)<size for i in active)
    assert np.flatnonzero(w).tolist()==sorted(int(i) for i in active if w[i])
    assert active.tolist()==report['final_active_atom_ids'] and w[active].tolist()==report['final_numeric_weights']
    assert abs(float(w.sum())-1)<1e-12
    b=np.asarray(list(map(float,wanted))); x=w[active]@F[active]; residual=b-x
    maxerr=float(max(abs(residual))); l1=float(sum(abs(residual))); obj=.5*float(residual@residual)
    assert abs(maxerr-report['numeric_max_feature_residual'])<1e-13
    assert abs(l1-report['numeric_feature_L1_residual'])<1e-11
    last=next(r for r in reversed(report['rounds']) if 'exact_violation' in r)
    assert last is report['rounds'][-1], 'final direction requires a saved generating mixture'
    assert abs(obj-last['objective'])<1e-13 and abs(l1-last['feature_L1_residual'])<1e-11
    scale=report['pricing_scale']; assert scale==2**24 and maxerr>0
    direction=residual/maxerr; c=[int(np.rint(v*scale)) for v in direction]
    assert c==report['last_integer_direction']==data['last_integer_direction'].tolist()
    records=report['last_support_records']; assert [r['mask'] for r in records]==list(range(16))
    bounds=[]; prefix=0
    for m,r in enumerate(records):
        potential=[c[j]+sum(c[720*(i+1)+j] for i in range(4) if m>>i&1) for j in range(720)]
        bound,count=check_sector(pool,128,dd[m][side],potential,r['selected_indices'])
        selected=r['selected_indices']; sd=dd[m][side]
        assert sorted(r['zero_basis_indices'])==sorted(j for j in selected if not sd['signatures'][j])
        assert r['owner_indices']==[next(j for j in selected if sd['signatures'][j]==(o,)) for o in sd['opposite']]
        assert bound==Q(r['value']); bounds.append(bound); prefix+=count
    left=sum(v*t for v,t in zip(c,wanted)); right=sum(v*t for v,t in zip(bounds,lam)); gap=left-right
    assert left==Q(last['exact_left']) and right==Q(last['exact_right_at_lambda']) and gap==Q(last['exact_violation'])<=0
    assert abs(float(gap/scale)-last['normalized_violation'])<1e-14
    priced=last['priced_atom']; assert B[priced].tolist()==[r['selected_indices'] for r in records]
    assert sum(int(v)*Q(int(n),D) for v,n in zip(c,N[priced]))==right
    scores=F@direction; chosen=int(np.argmax(scores)); improvement=float(scores[chosen]-direction@x)
    quantization=float(sum(abs(direction-np.asarray(c)/scale)))
    assert chosen==last['chosen_atom'] and abs(improvement-last['true_gradient_improvement'])<1e-10
    assert abs(quantization-last['quantization_advantage_bound'])<1e-10
    assert abs(improvement+quantization-last['numerical_Wolfe_upper_with_rounding'])<1e-10
    exact_weight_mass=sum((Q.from_float(float(v)) for v in w if v),Q(0))
    return dict(status='PASS_FULL_FIXED_LAMBDA_ENDPOINT_INCONCLUSIVE',source_C16_answered=False,
        report_sha256=sha(path),frozen_sha256=sha(frozen_path),archive_sha256=sha(archive),point_sha256=sha(point),
        initial_state_sha256=sha(initial_path),initial_state_receipt_sha256=sha(bound_receipts[0]),source_hashes=report['source_hashes'],
        side=side,X_anchors=xx,Z_anchors=zz,physical_symmetry_bridge=bridge,
        all_aggregate_atoms_checked=size-1,all_aggregate_physical_bases_checked=(size-1)*16,
        initial_physical_basis_records_checked=len(initial['pattern_basis_records']),
        exact_aggregate_feature_coordinates_checked=(size-1)*3600,exact_initial_feature_error_equations=3600,
        exact_anchor_low_moment_equations=11,zero_mass_patterns=[m for m,v in enumerate(lam) if not v],
        active_atoms=len(active),positive_numeric_weights=int(sum(w>0)),exact_binary_weight_mass=str(exact_weight_mass),
        numeric_weight_mass=float(w.sum()),numeric_minimum_weight=float(w.min()),numeric_max_feature_residual=maxerr,
        numeric_feature_L1_residual=l1,numeric_objective=obj,exact_final_direction=c,
        exact_final_pattern_bounds=list(map(str,bounds)),exact_final_left=str(left),exact_final_right=str(right),
        exact_final_gap=str(gap),normalized_final_gap=float(gap/scale),final_signed_prefix_rank_checks=prefix,
        final_true_gradient_improvement=improvement,final_quantization_advantage_bound=quantization,
        pilot_search_budget_seconds=frozen['seconds'],reported_search_and_preservation_elapsed_seconds=report['elapsed_seconds'],
        intermediate_pricing_directions_independently_replayed=False,exact_target_membership=False,global_moment_cut=False,
        elapsed_seconds=time.monotonic()-start,auditor_sha256=sha(__file__),
        dependencies={p:sha(ROOT/p) for p in ['verify_two_sided_full_basis_oracle.py','audit_two_sided_full_basis_endpoint.py','verify_two_basis_sector_state.py']},
        scope='Every saved atom is a valid fixed-lambda physical sector mixture; every aggregate numerator and final exact signed support bound was independently replayed. Only the final direction is repriced. Nonzero target errors and negative final gaps are inconclusive; no exact target allocation, joint two-sector law, global cut, source frame or case exclusion follows.')


def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--report',type=Path,required=True); ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args(); assert not a.output.exists(); out=audit(a.report)
    a.output.write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({k:v for k,v in out.items() if k not in ('source_hashes','exact_final_direction','exact_final_pattern_bounds')},indent=2),flush=True)

if __name__=='__main__': main()
