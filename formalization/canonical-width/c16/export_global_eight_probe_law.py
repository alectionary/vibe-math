#!/usr/bin/env python3
"""Freeze an exact eight-event necessary marginal polytope and LP; no solve."""
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations
import argparse,gzip,hashlib,json,os,time
ROOT=Path(__file__).resolve().parent
EVENTS=[80,512,720+186,720+433,614,281,720+51,720+83]
PAIRS=list(combinations(range(8),2))
def read(p):
    b=(ROOT/p).read_bytes();return json.loads(gzip.decompress(b) if str(p).endswith('.gz') else b)
def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def write(p,d):
    p=ROOT/p;assert not p.exists();p.write_text(json.dumps(d,sort_keys=True,indent=2)+'\n')
def rank(vectors):
    rows={}
    for v in vectors:
        while v:
            k=v&-v
            if k in rows:v^=rows[k]
            else:rows[k]=v;break
    return len(rows)
def coordinate(a,b):
    sa,a=divmod(a,720);sb,b=divmod(b,720);i,t=divmod(a,16);j,u=divmod(b,16);h=(u-t)%16
    if sa==sb and a==b:return i
    if h>8:h,i,j=16-h,j,i
    if h in (0,8) and i>j:i,j=j,i
    return 45+(0 if sa==sb else 18225)+2025*h+45*i+j
def features(mask):
    b=[mask>>i&1 for i in range(8)];return [1,*b,*[b[i]*b[j] for i,j in PAIRS]]
def action(e,shift,swap):
    s,v=divmod(e,720);i,t=divmod(v,16);return (s^swap)*720+16*i+(t+shift)%16
def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
    ap=argparse.ArgumentParser();ap.add_argument('--prefix',required=True);a=ap.parse_args();start=time.monotonic()
    from verify_two_sided_full_basis_oracle import point_owner
    from physical_integer_form_rows import coordinate as checked_coordinate
    point='coupling-results/two-basis-integer-witness22-rational.json.gz';summary='coupling-results/two-basis-integer-witness22-checks-summary.json'
    assert sha(point)=='4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f'
    sr=read(summary);assert sr['status']=='PASS_LISTED_RELAXATION' and len(sr['stages'])==7
    pools=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz'];assert all(len(p)==720 and rank(p)==128 for p in pools)
    assert len(EVENTS)==len(set(EVENTS))==8 and all(0<=e<1440 for e in EVENTS)
    owner=point_owner(point);columns=[None,*[(e%720)//16 for e in EVENTS],*[coordinate(EVENTS[i],EVENTS[j]) for i,j in PAIRS]]
    wanted=[Q(1) if j is None else owner[j] for j in columns];assert len(wanted)==37
    actions_checked=0
    for swap in (0,1):
        for shift in range(16):
            es=[action(e,shift,swap) for e in EVENTS]
            transformed=[None,*[(e%720)//16 for e in es],*[coordinate(es[i],es[j]) for i,j in PAIRS]]
            assert transformed==columns;actions_checked+=37
            assert all(coordinate(es[i],es[j])==checked_coordinate(es[i],es[j]) for i,j in PAIRS)
    adjacency=[]
    for e in EVENTS:
        s,i=divmod(e,720);adjacency.append(sum(1<<j for j,f in enumerate(EVENTS) if s!=f//720 and (pools[s][i]&pools[f//720][f%720]).bit_count()%2))
    records=[];allowed=[];F=[]
    for mask in range(256):
        chosen=[i for i in range(8) if mask>>i&1]
        counts=[sum(EVENTS[i]//720==s for i in chosen) for s in (0,1)]
        ranks=[rank(pools[s][EVENTS[i]%720] for i in chosen if EVENTS[i]//720==s) for s in (0,1)]
        degrees=[(mask&adjacency[i]).bit_count() if mask>>i&1 else 0 for i in range(8)]
        reasons=[]
        if ranks!=counts:reasons.append('selected_same_sector_linear_dependence')
        if max(degrees)>1:reasons.append('selected_cross_degree_greater_than_one')
        ok=not reasons
        records.append(dict(mask=mask,allowed=ok,selected_counts=counts,selected_ranks=ranks,selected_cross_degrees=degrees,reasons=reasons))
        if ok:allowed.append(mask);F.append(features(mask))
    assert 0 in allowed and len(allowed)>0
    # Explicit source-filter controls: subsets of a genuine small dual basis
    # always pass; duplicate/dependent selections and a branching edge fail.
    for mx in range(8):
        for mz in range(8):
            xx=[1<<i for i in range(3) if mx>>i&1];zz=[1<<j for j in range(3) if mz>>j&1]
            assert rank(xx)==len(xx) and rank(zz)==len(zz)
            assert all(sum((x&z).bit_count()%2 for z in zz)<=1 for x in xx)
            assert all(sum((x&z).bit_count()%2 for x in xx)<=1 for z in zz)
    assert rank([1,2,3])<3 and rank([1,1])<2
    assert sum((1&z).bit_count()%2 for z in [1,3])==2
    sourcefiles=[Path(__file__).name,point,summary,'physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt',
                 'verify_two_sided_full_basis_oracle.py','physical_integer_form_rows.py','verify_moment_symmetry_bridge.py',
                 'moment-resumption-results/symmetry-bridge-independent.json','local_joint_moment_probe.py','local_joint_targeted_probe.py']
    source_hashes={p:sha(p) for p in sourcefiles}
    typed_events=[['X' if e<720 else 'Z',e%720] for e in EVENTS]
    frozen=dict(status='FROZEN_EXACT_GLOBAL_EIGHT_PROBE_POLYTOPE',source_hashes=source_hashes,
                point=point,point_sha256=sha(point),events=typed_events,physical_event_ids=EVENTS,
                feature_layout='1,8 event indicators in listed order,28 pair products in lexicographic event-position order',
                pair_positions=[list(p) for p in PAIRS],owner_columns=columns,target=list(map(str,wanted)),
                adjacency_bitmasks=adjacency,all_state_records=records,allowed_masks=allowed,feature_columns=F,
                variable_masks=allowed,variable_names=['x'+str(i) for i in range(len(allowed))],
                equality_names=['f'+str(j) for j in range(37)],nonnegative_names=['n'+str(i) for i in range(len(allowed))],
                equalities=37,nonnegative_rows=len(allowed),all_256_states_screened=True,
                target_normalization='factor1 canonical p/S/T after the existing32-action symmetry averaging',
                conditioned_events_forced_selected=False,conditional_allocation_frozen=False,
                previous_auxiliary_law_used=False,optional_full_basis_extension_filter_used=False,
                complete_source_frame_criterion=False,source_C16_answered=False,solver_launched=False,
                tiny_dual_frame_subsets_checked=64,rank_dependency_controls=2,branching_degree_controls=1,
                literal_coordinate_action_checks=actions_checked,
                scope='Finite necessary restriction of actual source frames. Exact infeasibility can separate the global moment target after independent full-state/row replay; exact feasibility proves only this8-bit local law.')
    semantic=a.prefix+'.model.json';write(semantic,frozen)
    lp=a.prefix+'.lp';path=ROOT/lp;assert not path.exists()
    with path.open('x') as stream:
        stream.write('Minimize\n obj: + 0 x0\nSubject To\n')
        for row in range(37):
            expression=' '.join('+ 1 x'+str(i) for i,col in enumerate(F) if col[row]) or '+ 0 x0'
            stream.write(' f'+str(row)+': '+expression+' = '+str(wanted[row])+'\n')
        for i in range(len(allowed)):stream.write(' n'+str(i)+': - 1 x'+str(i)+' <= 0\n')
        stream.write('Bounds\n')
        for i in range(len(allowed)):stream.write(' x'+str(i)+' free\n')
        stream.write('End\n')
    manifest=dict(status='EXACT_GLOBAL_EIGHT_PROBE_LP_REQUIRES_REPLAY',semantic=semantic,semantic_sha256=sha(semantic),
                  lp=lp,lp_sha256=sha(lp),point=point,point_sha256=sha(point),source_sha256=sha(Path(__file__).name),
                  events=typed_events,allowed_masks=allowed,targets=list(map(str,wanted)),source_hashes=source_hashes,
                  variable_count=len(allowed),equality_count=37,row_count=37+len(allowed),
                  nonzeros=sum(map(sum,F))+len(allowed),physical_filter_excluded=256-len(allowed),
                  elapsed_seconds=time.monotonic()-start,priority=19,solver_launched=False,source_C16_answered=False)
    write(a.prefix+'.json',manifest);print(manifest)
if __name__=='__main__':main()
