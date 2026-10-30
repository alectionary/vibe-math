#!/usr/bin/env python3
"""Literal physical replay of a frozen, finite existing-subset screen."""
from fractions import Fraction as Q
from pathlib import Path
import argparse,copy,json,time
from verify_fixed_owner_residual_physical import (
    guard,sha,read,write,bound,context,physical_cut,low_rows,reduce)

def closure(p,S):
    d,U=p['d'],p['U'];S=set(S);F=set(d['F']);E=set(d['E'])
    rows=low_rows(U[j] for j in sorted(F|(E&S)))
    out=(S&F)|{j for j in E if reduce(U[j],rows)==0}
    allowed=F|E
    for B in d['bins']:
        B=set(B);allowed|=B
        if B&S:out|=B
    out|=set(range(720))-allowed
    return tuple(sorted(out))

def check(p,c):
    assert c['status']=='FIXED_OWNER_EXISTING_SUBSET_SCREEN_REQUIRES_INDEPENDENT_REPLAY'
    bound(c['source_hashes']);f=p['f'];M=read(f['semantic'])['model'];rows=M['sectors'][f['side']]['rank_rows']
    assert all(c[k]==f[k] for k in ('side','probe_side','probe','mask'))
    sets={}
    for k,r in enumerate(rows):
        if r['mask']!=f['mask']:continue
        for kind,S in [('stored',r['indices']),('forced_union',sorted(set(r['indices'])|set(r['forced_zero_indices'])))]:
            sets.setdefault(tuple(S),[]).append(dict(rank_row=k,variant=kind))
    seeds=list(sets.items())
    for S,origins in seeds:
        sets.setdefault(closure(p,S),[]).extend(dict(**o,closure=True) for o in origins)
    limit=c['maximum_subsets'];assert type(limit)is int and 0<limit<=5000
    cohort=sorted(sets)[:limit]
    assert c['source_rank_rows']==len(rows)
    assert c['selected_mask_rank_rows']==sum(r['mask']==f['mask'] for r in rows)
    assert c['seed_subsets']==len(seeds) and c['unique_subsets']==len(sets)
    assert c['subset_cap_reached']==(len(sets)>limit) and c['checked_subsets']==len(cohort)==len(c['results'])
    exact=[]
    for S,stored in zip(cohort,c['results']):
        literal=physical_cut(p,list(S));ordinary=sum(p['z'][j] for j in S)-literal['original_rank']*p['lam']
        assert ordinary<=0
        literal.update(origins=sets[S],ordinary_domain_raw_violation=str(ordinary))
        assert literal==stored;exact.append(literal)
    cuts=[r for r in exact if Q(r['raw_violation'])>0]
    assert cuts==c['cuts']
    assert c['best']==(max(exact,key=lambda r:Q(r['raw_violation'])) if exact else None)
    assert c['specifically_fixed_owner_cuts']==sum(r['specifically_uses_fixed_owner_distribution'] for r in cuts)
    return dict(checked_subsets=len(exact),positive_rows=len(cuts),
                specifically_fixed_owner_cuts=c['specifically_fixed_owner_cuts'],
                maximum_raw_violation=c['best']['raw_violation'] if c['best'] else None,
                source_domain_closures_rebuilt=True,proxy_rank_used_for_acceptance=False,
                global_target_exclusion_proved=False,all_subset_membership_proved=False)

def main():
    guard();start=time.monotonic();ap=argparse.ArgumentParser();ap.add_argument('--certificate',required=True);ap.add_argument('--output',required=True);args=ap.parse_args()
    c=read(args.certificate);f=read(c['frozen']);pr=read(c['preparation_receipt'])
    assert c['frozen_sha256']==sha(c['frozen']) and c['preparation_receipt_sha256']==sha(c['preparation_receipt'])
    assert pr['status']=='PASS_INDEPENDENT_FIXED_OWNER_RESIDUAL_PREPARATION'
    assert pr['frozen_sha256']==sha(c['frozen']) and pr['consumer_sha256']==sha('verify_fixed_owner_residual_physical.py')
    bound(pr['source_hashes']);p=context(f);out=check(p,c);mutants=[]
    for name in ('wrong_physical_rank','wrong_raw_gap','missing_subset'):
        bad=copy.deepcopy(c)
        if name=='wrong_physical_rank':bad['results'][0]['original_rank']+=1
        elif name=='wrong_raw_gap':bad['results'][0]['raw_violation']=str(Q(bad['results'][0]['raw_violation'])+1)
        else:bad['results'].pop()
        try:check(p,bad)
        except (AssertionError,ValueError,KeyError,IndexError):mutants.append(name)
        else:raise AssertionError(('accepted mutation',name))
    out.update(status='PASS_INDEPENDENT_FIXED_OWNER_EXISTING_SUBSET_SCREEN',certificate_sha256=sha(args.certificate),
               frozen_sha256=sha(c['frozen']),point_sha256=f['point_sha256'],consumer_sha256=sha(Path(__file__).name),
               source_hashes={**c['source_hashes'],args.certificate:sha(args.certificate),Path(__file__).name:sha(Path(__file__).name),
                              'verify_fixed_owner_residual_physical.py':sha('verify_fixed_owner_residual_physical.py')},
               corruptions_rejected=mutants,elapsed_seconds=time.monotonic()-start,priority=19)
    write(args.output,out);print(json.dumps({k:v for k,v in out.items() if k!='source_hashes'},sort_keys=True))
if __name__=='__main__':main()
