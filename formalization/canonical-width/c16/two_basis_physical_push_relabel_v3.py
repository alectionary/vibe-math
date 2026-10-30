#!/usr/bin/env python3
"""Source-bound bounded physical pilot for the frozen exact matroid solver.

Prepare every positive pattern. Couple the zero-basis law and all required
owner-bin laws by an exact common interval partition, producing explicit
full physical bases without a Cartesian product expansion.
"""
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations
import argparse, gzip, hashlib, json, math, os, subprocess, sys, time
from verify_two_sided_full_basis_oracle import physical_source, domains
from verify_two_basis_rank_geometry_allocation import data

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_text())
def write(p,value):
    p=Path(p);assert not p.exists();raw=(json.dumps(value,indent=2)+'\n').encode()
    p.write_bytes(gzip.compress(raw,mtime=0) if p.suffix=='.gz' else raw)
def pivots(vectors):
    rows={}
    for value in vectors:
        while value:
            k=value.bit_length()-1
            if k in rows:value^=rows[k]
            else:rows[k]=value;break
    return rows
def quotient(value,rows):
    for k in sorted(rows,reverse=True):
        if value>>k&1:value^=rows[k]
    return value
def initial_basis(vectors,target):
    rows={};B=[]
    for j in sorted(range(len(vectors)),key=lambda j:(-target[j],j)):
        value=vectors[j]
        while value:
            k=value.bit_length()-1
            if k in rows:value^=rows[k]
            else:rows[k]=value;B.append(j);break
    return sorted(B)
def contraction_controls():
    U=list(range(1,8));checks=0
    for F in [[],[0],[0,1],[0,2]]:
        P=pivots(U[j] for j in F);assert len(P)==len(F)
        E=[j for j in range(7) if j not in F];V=[quotient(U[j],P) for j in E]
        for mask in range(1<<len(E)):
            A=[i for i in range(len(E)) if mask>>i&1]
            assert len(pivots(V[i] for i in A))==len(pivots(U[j] for j in F+[E[i] for i in A]))-len(F)
            checks+=1
    return dict(exact_subset_contraction_identities=checks)
def interval_couple(components):
    assert components and all(component for component in components)
    assert all(all(w>0 for _,w in component) and sum(w for _,w in component)==1 for component in components)
    positions=[0]*len(components);remaining=[component[0][1] for component in components];out=[]
    while positions[0]<len(components[0]):
        delta=min(remaining);assert delta>0
        labels=tuple(component[position][0] for component,position in zip(components,positions));out.append((labels,delta))
        for i,component in enumerate(components):
            remaining[i]-=delta
            if not remaining[i]:
                positions[i]+=1
                if positions[i]<len(component):remaining[i]=component[positions[i]][1]
        assert all(position<len(component) for position,component in zip(positions,components)) or all(position==len(component) for position,component in zip(positions,components))
    assert sum(w for _,w in out)==1 and len(out)<=sum(map(len,components))-len(components)+1
    return out
def coupling_controls():
    cases=[[[('a',Q(1))]],[[('a',Q(1,3)),('b',Q(2,3))],[('c',Q(1,2)),('d',Q(1,2))]],
           [[('a',Q(2,7)),('b',Q(5,7))],[('c',Q(3,11)),('d',Q(8,11))],[('e',Q(1,13)),('f',Q(12,13))]]]
    count=0
    for components in cases:
        joined=interval_couple(components)
        for i,component in enumerate(components):
            for label,weight in component:
                assert sum(w for labels,w in joined if labels[i]==label)==weight;count+=1
    return dict(exact_component_marginals_checked=count,cohorts=len(cases))

def prepare(a):
    c,f,fp,U,dd,lam,y=data(a.allocation,a.point);receipt=read(a.receipt)
    assert receipt['status']=='PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS'
    assert receipt['certificate_sha256']==sha(a.allocation) and receipt['frozen_sha256']==sha(fp)
    assert receipt['consumer_sha256']==sha(ROOT/'verify_two_basis_rank_geometry_allocation.py')
    assert receipt['point_sha256']==sha(a.point) and receipt['all_contracted_rank_le_three_rows_proved']
    tiny=read(a.tiny_receipt)
    assert tiny['status']=='PASS_EXHAUSTIVE_TINY_PUSH_RELABEL_ENDPOINTS'
    assert tiny['producer_sha256']==sha(ROOT/'exact_matroid_push_relabel.py')
    assert tiny['consumer_sha256']==sha(ROOT/'two_basis_structure_push_relabel_controls.py')
    prepared=[]
    for m,d in enumerate(dd):
        if not lam[m]:continue
        F=list(d['zero_forced']);E=list(d['zero_free']);P=pivots(U[j] for j in F)
        assert len(P)==len(F) and all(y[m][j]==lam[m] for j in F)
        vectors=[quotient(U[j],P) for j in E];q=[y[m][j]/lam[m] for j in E]
        r=d['zero_required']-len(F)
        assert len(pivots(vectors))==r and sum(q)==r and all(0<=v<=1 for v in q)
        owner=[]
        for bucket in d['bins']:
            probabilities=[y[m][j]/lam[m] for j in bucket]
            assert min(probabilities)>=0 and sum(probabilities)==1
            owner.append(dict(indices=bucket,conditional_probabilities=list(map(str,probabilities))))
        B=initial_basis(vectors,q);assert len(B)==r
        prepared.append(dict(mask=m,lambda_mass=str(lam[m]),forced_zero_indices=F,
            physical_zero_ground_indices=E,quotient_vectors_hex=[hex(v) for v in vectors],
            conditional_zero_target=list(map(str,q)),raw_sector_target=list(map(str,y[m])),
            contracted_rank=r,owner_bins=owner,initial_local_basis=B))
    assert f['side'] in ['X','Z'];selected=next(d for d in prepared if d['mask']==a.mask)
    assert selected['contracted_rank']+len(selected['forced_zero_indices'])+len(selected['owner_bins'])==128
    assert 0<a.seconds<=60 and 2<=a.maximum_bases<=5000
    paths=[Path(__file__).name,'exact_matroid_push_relabel.py','two_sided_full_basis_oracle.py',
        'verify_two_sided_full_basis_oracle.py','verify_two_basis_rank_geometry_allocation.py',
        'verify_two_basis_direct_allocation.py','verify_algebraic_model.py','two_basis_structure_push_relabel_controls.py',
        'physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']
    sources=dict(f['source_hashes']);sources.update({p:sha(ROOT/p) for p in paths})
    for p in [a.allocation,a.receipt,a.tiny_receipt,a.point,fp]:
        p=p.resolve();assert p.is_relative_to(ROOT);sources[str(p.relative_to(ROOT))]=sha(p)
    out=dict(status='FROZEN_PHYSICAL_PUSH_RELABEL_PILOT',point_sha256=sha(a.point),
        allocation_path=str(a.allocation),allocation_sha256=sha(a.allocation),allocation_receipt_sha256=sha(a.receipt),
        tiny_controls_receipt_sha256=sha(a.tiny_receipt),source_hashes=sources,
        X_anchors=f['X_anchors'],Z_anchors=f['Z_anchors'],side=f['side'],selected_mask=a.mask,
        prepared_positive_patterns=prepared,seconds=a.seconds,external_seconds=90,
        maximum_active_bases=a.maximum_bases,solver_maximum_bases_argument=a.maximum_bases-1,
        cap_convention='Frozen solver stops at len>argument; argument4999 gives maximum5000 after a one-basis split.',
        contraction_controls=contraction_controls(),coupling_controls=coupling_controls(),source_C16_answered=False,
        scope='One zero-matroid at one fixed pattern law and one allocation. Neither two-sided nor source-frame membership.')
    return out
def worker(frozen_path,output):
    frozen=read(frozen_path);assert all(sha(ROOT/p)==h for p,h in frozen['source_hashes'].items())
    d=next(d for d in frozen['prepared_positive_patterns'] if d['mask']==frozen['selected_mask'])
    from exact_matroid_push_relabel import solve
    vectors=[int(v,16) for v in d['quotient_vectors_hex']];q=list(map(Q,d['conditional_zero_target']))
    result=solve(vectors,q,seconds=frozen['seconds'],maximum_bases=frozen['solver_maximum_bases_argument'],
        initial=[(d['initial_local_basis'],Q(1))],verify_invariants=False)
    X,Z,_=physical_source();U=X if frozen['side']=='X' else Z
    F,E=d['forced_zero_indices'],d['physical_zero_ground_indices'];l=Q(d['lambda_mass']);D=int(result['denominator'])
    assert D>0 and result['rank']==d['contracted_rank'] and result['maximum_active_bases']<=frozen['maximum_active_bases']
    counts=[0]*len(E);zero_law=[];mass=0
    for record in result['bases']:
        B=record['indices'];w=int(record['weight_numerator']);assert w>0 and len(B)==len(set(B))==d['contracted_rank']
        assert all(type(i)is int and 0<=i<len(E) for i in B)
        chosen=tuple(sorted(F+[E[i] for i in B]));assert len(chosen)==128-len(d['owner_bins'])
        assert len(pivots(U[j] for j in chosen))==len(chosen)
        mass+=w
        for i in B:counts[i]+=w
        zero_law.append((chosen,Q(w,D)))
    assert mass==D and counts==list(map(int,result['achieved_numerators']))
    components=[zero_law]
    for bucket in d['owner_bins']:
        components.append([(j,Q(q)) for j,q in zip(bucket['indices'],bucket['conditional_probabilities']) if Q(q)>0])
    joined=interval_couple(components);full_D=math.lcm(*(w.denominator for _,w in joined))
    physical=[];raw_counts=[0]*720
    for labels,weight in joined:
        chosen=sorted([*labels[0],*labels[1:]]);w=int(weight*full_D)
        assert len(chosen)==len(set(chosen))==128 and len(pivots(U[j] for j in chosen))==128 and w>0
        physical.append(dict(selected_indices=chosen,weight_numerator=str(w)))
        for j in chosen:raw_counts[j]+=w
    assert sum(int(b['weight_numerator']) for b in physical)==full_D
    assert len(physical)<=sum(len(component) for component in components)-len(components)+1
    achieved=[l*Q(v,full_D) for v in raw_counts]
    wanted=list(map(Q,d['raw_sector_target']));gap=[wanted[j]-achieved[j] for j in range(720)]
    cut=None
    if result['status']=='EXACT_BASE_MIXTURE':assert not any(gap)
    elif result['status']=='EXACT_RANK_VIOLATION':
        local=result['violated_rank']['indices'];A=sorted(E[i] for i in local)
        r=len(pivots(U[j] for j in F+A))-len(F);raw_gap=sum(wanted[j] for j in A)-r*l
        assert raw_gap>0 and r==result['violated_rank']['rank'] and raw_gap/l==Q(result['violated_rank']['exact_violation'])
        cut=dict(forced_zero_indices=F,indices=A,contraction_rank=r,physical_span_rank=r+len(F),exact_raw_violation=str(raw_gap))
    else:assert result['status']=='BOUNDED_PUSH_RELABEL_INCONCLUSIVE'
    out=dict(status='PHYSICAL_PUSH_RELABEL_ENDPOINT_REQUIRES_REPLAY',frozen_sha256=sha(frozen_path),
        point_sha256=frozen['point_sha256'],allocation_sha256=frozen['allocation_sha256'],
        selected_mask=frozen['selected_mask'],side=frozen['side'],solver_endpoint=result,
        lift_method='Exact common-interval refinement of zero-basis and required-owner laws',
        lift_component_support_sizes=[len(component) for component in components],
        physical_basis_records=physical,full_basis_denominator=str(full_D),physical_rank_cut=cut,raw_achieved_allocations=list(map(str,achieved)),
        exact_raw_L1_residual=str(sum(map(abs,gap))),exact_raw_max_residual=str(max(map(abs,gap))),
        exact_local_membership_candidate=result['status']=='EXACT_BASE_MIXTURE',source_C16_answered=False,
        all_patterns_membership_proved=False,two_sector_membership_proved=False)
    assert all(sha(ROOT/p)==h for p,h in frozen['source_hashes'].items());write(output,out)
    print(json.dumps(dict(status=result['status'],reason=result['stop_reason'],bases=len(physical),steps=result['steps'],
        seconds=result['seconds'],raw_L1=out['exact_raw_L1_residual'])),flush=True)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--allocation',type=Path);ap.add_argument('--receipt',type=Path);ap.add_argument('--point',type=Path)
    ap.add_argument('--tiny-receipt',type=Path);ap.add_argument('--mask',type=int,default=0);ap.add_argument('--seconds',type=float,default=60)
    ap.add_argument('--maximum-bases',type=int,default=5000);ap.add_argument('--output-prefix',type=Path)
    ap.add_argument('--worker',type=Path);ap.add_argument('--worker-output',type=Path)
    a=ap.parse_args()
    if a.worker:worker(a.worker,a.worker_output);return
    assert all([a.allocation,a.receipt,a.point,a.tiny_receipt,a.output_prefix]);start=time.monotonic()
    f=prepare(a);fp=Path(str(a.output_prefix)+'.frozen.json');output=Path(str(a.output_prefix)+'.json.gz');write(fp,f)
    log=Path(str(a.output_prefix)+'.worker.log');assert not log.exists() and not output.exists()
    command=[sys.executable,'-B',str(Path(__file__).resolve()),'--worker',str(fp),'--worker-output',str(output)]
    env=dict(os.environ,OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1',MKL_NUM_THREADS='1',VECLIB_MAXIMUM_THREADS='1',PYTHONDONTWRITEBYTECODE='1')
    with log.open('w') as stream:
        try:r=subprocess.run(command,cwd=ROOT,env=env,stdout=stream,stderr=subprocess.STDOUT,timeout=90);code=r.returncode
        except subprocess.TimeoutExpired:code='EXTERNAL_TIMEOUT_90_SECONDS'
    exit_record=dict(status='BOUNDED_PHYSICAL_PILOT_RETURNED' if code==0 else 'PHYSICAL_PILOT_REQUIRES_FOLLOWUP',
        returncode=code,frozen_sha256=sha(fp),endpoint_sha256=sha(output) if output.exists() else None,
        worker_log_sha256=sha(log),elapsed_seconds=time.monotonic()-start,source_C16_answered=False)
    write(Path(str(a.output_prefix)+'.exit.json'),exit_record);print(json.dumps(exit_record),flush=True)
if __name__=='__main__':main()
