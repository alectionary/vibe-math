#!/usr/bin/env python3
"""Bounded existing-rank-subset screen; no new subset search or oracle."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,time
from fixed_owner_residual_rank import runtime_guard,read,sha,write,decode_problem,basis_rows,reduced,translate_cut

def main():
    runtime_guard();ap=argparse.ArgumentParser();ap.add_argument('--frozen',type=Path,required=True)
    ap.add_argument('--preparation-receipt',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--maximum-subsets',type=int,default=2000);a=ap.parse_args();assert 0<a.maximum_subsets<=5000
    start=time.monotonic();f=read(a.frozen);r=read(a.preparation_receipt)
    assert r['status']=='PASS_INDEPENDENT_FIXED_OWNER_RESIDUAL_PREPARATION' and r['frozen_sha256']==sha(a.frozen)
    for p,h in f['source_hashes'].items():assert sha(p)==h
    p=decode_problem(f['problem']);M=read(f['semantic'])['model'];source_rows=M['sectors'][f['side']]['rank_rows'];sets={}
    for k,row in enumerate(source_rows):
        if row['mask']!=f['mask']:continue
        for kind,S in [('stored',row['indices']),('forced_union',sorted(set(row['indices'])|set(row['forced_zero_indices'])))]:
            key=tuple(S);sets.setdefault(key,[]).append(dict(rank_row=k,variant=kind))
    seeds=list(sets.items());v=p['original_vectors']
    for S,origins in seeds:
        rows=basis_rows(v[j] for j in S);closed=tuple(j for j,value in enumerate(v) if not reduced(value,rows))
        sets.setdefault(closed,[]).extend(dict(**o,closure=True) for o in origins)
    candidates=sorted(sets);limited=len(candidates)>a.maximum_subsets
    candidates=candidates[:a.maximum_subsets];results=[]
    for S in candidates:
        row=translate_cut(p,list(S));r0=row['original_rank']
        ordinary=sum(p['raw_allocation'][j] for j in S)-r0*p['lambda_mass']
        assert ordinary<=0,'both-sector membership prerequisite disagrees with original-domain rank'
        row.update(origins=sets[S],ordinary_domain_raw_violation=str(ordinary))
        results.append(row);assert time.monotonic()-start<90,'existing subset screen bounded time'
    cuts=[row for row in results if Q(row['raw_violation'])>0]
    best=max(results,key=lambda r:Q(r['raw_violation'])) if results else None
    out=dict(status='FIXED_OWNER_EXISTING_SUBSET_SCREEN_REQUIRES_INDEPENDENT_REPLAY',
             frozen=str(a.frozen),frozen_sha256=sha(a.frozen),preparation_receipt=str(a.preparation_receipt),preparation_receipt_sha256=sha(a.preparation_receipt),
             side=f['side'],probe_side=f['probe_side'],probe=f['probe'],mask=f['mask'],
             source_rank_rows=len(source_rows),selected_mask_rank_rows=sum(r['mask']==f['mask'] for r in source_rows),
             seed_subsets=len(seeds),unique_subsets=len(sets),checked_subsets=len(results),subset_cap_reached=limited,
             maximum_subsets=a.maximum_subsets,results=results,cuts=cuts,best=best,
             specifically_fixed_owner_cuts=sum(r['specifically_uses_fixed_owner_distribution'] for r in cuts),
             source_hashes={str(a.frozen):sha(a.frozen),str(a.preparation_receipt):sha(a.preparation_receipt),f['semantic']:sha(f['semantic']),Path(__file__).name:sha(Path(__file__).name),'fixed_owner_residual_rank.py':sha('fixed_owner_residual_rank.py')},
             elapsed_seconds=time.monotonic()-start,physical_colored_oracle_queries=0,priority=19,
             scope='Existing subset rows, forced unions and auxiliary-M0 closures only. Negative screen is not all-rank membership; a positive row still needs physical-rank replay.')
    write(a.output,out);print(dict(status=out['status'],checked_subsets=len(results),cuts=len(cuts),specifically_fixed_owner_cuts=out['specifically_fixed_owner_cuts'],elapsed_seconds=out['elapsed_seconds']),flush=True)

if __name__=='__main__':main()
