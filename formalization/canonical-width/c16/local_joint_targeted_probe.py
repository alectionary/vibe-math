#!/usr/bin/env python3
"""Frozen seven-support local hull discovery; exact repricing, no acceptance.

Every full frame restricts to independent selections with cross pairing degree
at most one. The frozen supports are independent in each sector, so only the
matching test removes masks. A separate consumer must replay all source masks,
truth values and the normalized physical moment row before any use.
"""
from collections import Counter
from fractions import Fraction as Q
from itertools import combinations
from pathlib import Path
import datetime
import json
import math
import time
import numpy as np
from scipy.optimize import linprog
from scipy.sparse import csc_matrix,eye,hstack
from verify_two_sided_full_basis_oracle import point_owner,coordinate,rank
ROOT=Path(__file__).resolve().parent
PREFIX=ROOT/'two-basis-results/local-joint-targeted-matched-v1'


def sha(p):
    import hashlib
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def write(p,o):Path(p).write_text(json.dumps(o,indent=2)+'\n')
def read(p):return json.loads(Path(p).read_text())
def columns(events):
    result=[None,*[(e%720)//16 for e in events]]
    for a,b in combinations(events,2):
        s,i=divmod(a,720);t,j=divmod(b,720)
        result.append(coordinate('S' if s==t else 'T',(j%16-i%16)%16,i//16,j//16))
    return result

def feature_matrix(n,masks):
    bits=((np.asarray(masks,dtype=np.int64)[:,None]>>np.arange(n))&1)
    return np.vstack([np.ones(len(masks),dtype=np.int64),bits.T,*[bits[:,i]*bits[:,j] for i,j in combinations(range(n),2)]])

def owner_row(c,bound,events):
    row=Counter()
    for col,v in zip(columns(events),c):
        if col is not None:row[col]+=int(v)
    return [[j,v] for j,v in sorted(row.items()) if v],int(bound)-int(c[0])

def main():
    started=time.monotonic();deadline=started+120
    outpath=Path(str(PREFIX)+'.json');frozenpath=Path(str(PREFIX)+'.frozen.json');statepath=Path(str(PREFIX)+'.numeric-endpoints.npz')
    assert not any(p.exists() for p in [outpath,frozenpath,statepath])
    planpath=ROOT/'two-basis-results/local-joint-targeted-support-plan.json';countpath=ROOT/'two-basis-results/local-joint-targeted-pattern-counts.json'
    plan,counts=read(planpath),read(countpath);assert counts['support_plan_sha256']==sha(planpath)
    assert len(plan['planned_supports'])==len(counts['records'])==7
    pools=[[int(x,16) for x in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    assert all(counts['physical_pool_sha256'][s]==sha(ROOT/f'pools/{s}coords.txt') for s in 'xz')
    support_records=[];matrices={}
    for k,item in enumerate(plan['planned_supports']):
        E=item['events'];n=len(E);assert 7<=n<=14 and len(set(E))==n and all(type(e)is int and 0<=e<1440 for e in E)
        sector_sizes=[sum(e//720==s for e in E) for s in (0,1)]
        rr=[rank(pools[s][e%720] for e in E if e//720==s) for s in (0,1)];assert rr==sector_sizes
        adjacency=[sum(1<<j for j,f in enumerate(E) if e//720!=f//720 and (pools[e//720][e%720]&pools[f//720][f%720]).bit_count()%2) for e in E]
        allmasks=list(range(1<<n));allowed=[m for m in allmasks if all(not(m>>j&1) or (m&a).bit_count()<=1 for j,a in enumerate(adjacency))]
        assert len(allowed)==counts['records'][k]['matching_patterns'] and E==counts['records'][k]['events']
        import hashlib
        assert hashlib.sha256(json.dumps(allowed,separators=(',',':')).encode()).hexdigest()==counts['records'][k]['matching_mask_list_sha256']
        assert 0 in allowed
        A=feature_matrix(n,allmasks);matrices[k]=A
        support_records.append(dict(support_index=k,events=E,typed_events=[[e//720,e%720] for e in E],feature_layout='1,bits[event order],pair_products[lex i<j]',sector_support_ranks=rr,sector_event_counts=sector_sizes,rank_filter_redundant=True,adjacency_bitmasks=adjacency,unfiltered_masks=allmasks,physical_masks=allowed,core_events_not_forced=True))
    names=['sourcecase323200-homotopy2','two-basis-integer-witness18'];points=[];owners={};sources={}
    for name in names:
        point=ROOT/f'coupling-results/{name}-rational.json.gz';summary=ROOT/f'coupling-results/{name}-checks-summary.json';checkfrozen=ROOT/f'coupling-results/{name}-checks-frozen.json'
        ss,ff=read(summary),read(checkfrozen);assert ss['status']=='PASS_LISTED_RELAXATION' and ss['frozen_sha256']==sha(checkfrozen) and len(ss['stages'])==7
        assert all(ss['sources_unchanged'].values())
        for p,h in ff['input_and_source_hashes'].items():assert sha(ROOT/p)==h;sources[p]=h
        for stage in ss['stages']:
            rp=ROOT/f"coupling-results/{name}-{stage['stage']}.json";record=read(rp)
            assert stage['status']==record['status']=='PASS' and stage['receipt_sha256']==sha(rp)
            assert record.get('point_sha256',record.get('certificate_sha256'))==sha(point)
            sources[str(rp.relative_to(ROOT))]=sha(rp)
        for p in [point,summary,checkfrozen]:sources[str(p.relative_to(ROOT))]=sha(p)
        owners[name]=point_owner(point);points.append(dict(name=name,point=str(point.relative_to(ROOT)),point_sha256=sha(point),seven_stage_summary=str(summary.relative_to(ROOT)),seven_stage_summary_sha256=sha(summary)))
    for p,h in plan['bank_hashes'].items():assert sha(ROOT/p)==h;sources[p]=h
    for p in [Path(__file__),ROOT/'run_local_joint_targeted_bounded.py',ROOT/'verify_two_sided_full_basis_oracle.py',planpath,countpath,ROOT/'two-basis-results/local-joint-targeted-strategy-review.json']:
        sources[str(p.relative_to(ROOT))]=sha(p)
    priority=[4,6,5,1,3,0,2];order=[dict(point=name,support_index=k,mode=mode) for name in names for k in priority for mode in ['all_boolean','physical_matching']]
    frozen=dict(status='FROZEN_BEFORE_MATCHED_LOCAL_JOINT_GATE',schema='c16-local-joint-cut-v1',source_C16_answered=False,utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),source_hashes=sources,points=points,supports=support_records,query_order=order,seconds=120,per_LP_seconds=5,external_seconds=150,maximum_LPs=28,stop_after_distinct_exact_candidates=2,coefficient_grids=[1,16,256,4096,65536,1048576],solver='highs-ds',presolve=False,pattern_states_conditioned_on_core=False,scope='Discovery only; exact coefficients/support scores must be independently replayed before source-row acceptance. Numeric zero distances do not certify local or global membership.')
    write(frozenpath,frozen);records=[];cuts=[];seenrows=set();arrays={};stop='FIXED_COHORT_COMPLETE'
    write(outpath,dict(status='RUNNING_MATCHED_LOCAL_JOINT_GATE',frozen_sha256=sha(frozenpath),source_C16_answered=False,records=records,cuts=cuts))
    for query_id,query in enumerate(order):
        remaining=deadline-time.monotonic()
        if remaining<=0:stop='TIME_LIMIT';break
        name,k,mode=query['point'],query['support_index'],query['mode'];support=support_records[k];E=support['events'];Aall=matrices[k]
        masks=support['unfiltered_masks'] if mode=='all_boolean' else support['physical_masks'];A=Aall[:,masks];cols=columns(E)
        wanted=[Q(1) if j is None else owners[name][j] for j in cols];b=np.asarray(list(map(float,wanted)));d=len(wanted)
        eq=hstack([csc_matrix(A),eye(d),-eye(d)],format='csc')
        before=time.monotonic();lp=linprog(np.r_[np.zeros(len(masks)),np.ones(2*d)],A_eq=eq,b_eq=b,bounds=(0,None),method='highs-ds',options={'presolve':False,'time_limit':min(5,remaining),'primal_feasibility_tolerance':1e-9,'dual_feasibility_tolerance':1e-9})
        r=dict(query_id=query_id,**query,allowed_patterns=len(masks),feature_count=d,solver_status=int(lp.status),solver_message=lp.message,solver_seconds=time.monotonic()-before,numeric_phase_I_objective=float(lp.fun) if lp.fun is not None else None,exact_membership_proved=False)
        if lp.x is not None:
            arrays[f'q{query_id:03d}_variables']=lp.x
            r['numeric_minimum_variable']=float(min(lp.x));r['numeric_maximum_phase_I_equality_residual']=float(max(abs(eq@lp.x-b)));r['numeric_moment_L1_residual']=float(sum(abs(A@lp.x[:len(masks)]-b)))
        dual=lp.eqlin.marginals if getattr(lp,'eqlin',None) is not None else None
        if dual is not None and len(dual)==d and np.isfinite(dual).all():
            arrays[f'q{query_id:03d}_row_dual']=dual;r['repricing']=[]
            for scale in frozen['coefficient_grids']:
                c=[int(np.rint(v*scale)) for v in dual];assert sum(abs(v) for v in c)<2**62
                scores=np.asarray(c,dtype=np.int64)@Aall;physical_scores=scores[support['physical_masks']]
                bound=int(max(physical_scores));unfiltered=int(max(scores));left=sum(v*t for v,t in zip(c,wanted));gap=left-bound;bgap=left-unfiltered
                r['repricing'].append(dict(grid=scale,physical_bound=bound,unfiltered_bound=unfiltered,exact_gap=str(gap),exact_unfiltered_gap=str(bgap)))
                if gap<=0:continue
                row,rhs=owner_row(c,bound,E);assert sum(v*owners[name][j] for j,v in row)-rhs==gap
                gcd=math.gcd(*([abs(v) for j,v in row]+[abs(rhs)]));assert gcd>0
                key=(tuple((j,v//gcd) for j,v in row),rhs//gcd)
                if key in seenrows:r['duplicate_exact_candidate']=True;break
                seenrows.add(key)
                cut=dict(support_index=k,events=E,point_name=name,point_sha256=next(p['point_sha256'] for p in points if p['name']==name),coefficients=c,bound=bound,exact_target_value=str(left),exact_violation=str(gap),coefficient_grid=scale,coefficient_l1=sum(abs(v) for v in c),violation_per_coefficient_l1=str(gap/sum(abs(v) for v in c)),physical_mask_scores=list(map(int,physical_scores)),unfiltered_mask_scores=list(map(int,scores)),matched_unfiltered_bound=unfiltered,matched_unfiltered_exact_violation=str(bgap),physical_filter_needed_for_this_separation=bgap<=0,owner_row_terms=row,owner_rhs=rhs,canonical_owner_row_terms=[[j,v//gcd] for j,v in row],canonical_owner_rhs=rhs//gcd,discovery_query_id=query_id,discovery_mode=mode)
                cuts.append(cut);r['exact_candidate_index']=len(cuts)-1;break
        records.append(r);np.savez_compressed(statepath,**arrays)
        write(outpath,dict(status='RUNNING_MATCHED_LOCAL_JOINT_GATE',frozen_sha256=sha(frozenpath),source_C16_answered=False,records=records,cuts=cuts))
        print(json.dumps({k:v for k,v in r.items() if k!='repricing'}),flush=True)
        if len(cuts)>=2:stop='TWO_DISTINCT_EXACT_CANDIDATES';break
    assert all(sha(ROOT/p)==h for p,h in sources.items())
    out=dict(frozen);out.update(status='EXACT_LOCAL_JOINT_CUT_CANDIDATES' if cuts else 'BOUNDED_LOCAL_JOINT_INCONCLUSIVE',frozen_sha256=sha(frozenpath),records=records,cuts=cuts,stop_reason=stop,elapsed_seconds=time.monotonic()-started,numeric_endpoint_archive=str(statepath.relative_to(ROOT)),numeric_endpoint_archive_sha256=sha(statepath) if statepath.exists() else None,LPs_run=len(records),exact_local_membership_certificates=0,independent_source_consumer_accepted=False,source_case_exclusions=0)
    write(outpath,out);print(json.dumps({k:out[k] for k in ['status','LPs_run','stop_reason','elapsed_seconds']}),flush=True)

if __name__=='__main__':main()
