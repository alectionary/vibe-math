#!/usr/bin/env python3
"""Independent coordinate identities and frozen tiny endpoint regression."""
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations
import argparse, gzip, hashlib, json, time
from two_basis_structure_push_relabel_controls import rank, check
import exact_matroid_push_relabel_cached as candidate

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def rows_for(U,B):
    rows={}
    for j in B:
        v=U[j];mask=1<<j
        while v:
            pivot=v&-v
            if pivot in rows:
                old,coefficients=rows[pivot];v^=old;mask^=coefficients
            else:rows[pivot]=(v,mask);break
        assert v
    return rows
def express(rows,value):
    coefficients=0
    while value:
        pivot=value&-value;v,mask=rows[pivot];value^=v;coefficients^=mask
    return coefficients
def coordinate_controls():
    updates=identities=queries=0;rejected=False
    fixtures=[[1,2,3],[0,1,1,2,2,3],list(range(1,8)),[1,1,2,4,3,5,6,7]]
    for U in fixtures:
        r=rank(U)
        for B in combinations(range(len(U)),r):
            if rank(U[j] for j in B)!=r:continue
            old=rows_for(U,B)
            for s in set(range(len(U)))-set(B):
                expression=express(old,U[s])
                for t in B:
                    if not expression>>t&1:continue
                    newB=sorted((set(B)-{t})|{s});new=rows_for(U,newB)
                    actual=candidate.exchange_cached_rows(old,expression,t,s)
                    assert actual.keys()==old.keys();updates+=1
                    for pivot,(v,m) in actual.items():
                        assert v==old[pivot][0] and m==express(new,v)
                        assert not m>>t&1 and all(j in newB for j in range(len(U)) if m>>j&1)
                        literal=0
                        for j in range(len(U)):
                            if m>>j&1:literal^=U[j]
                        assert literal==v;identities+=1
                    for v in U:assert express(actual,v)==express(new,v);queries+=1
                    if not rejected:
                        bad=dict(actual);pivot=next(iter(bad));v,m=bad[pivot];bad[pivot]=(v,m^(1<<t))
                        try:assert all(mm==express(new,vv) for vv,mm in bad.values())
                        except AssertionError:rejected=True
                        else:raise AssertionError('corrupted coordinate substitution accepted')
    assert rejected
    return dict(exchanges_checked=updates,row_coefficient_identities=identities,ground_vector_coordinate_queries=queries,corrupt_coordinate_rejected=True)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();assert not a.output.exists();start=time.monotonic()
    bank=json.loads(gzip.decompress(a.bank.read_bytes()));assert bank['producer_sha256']==sha(ROOT/'exact_matroid_push_relabel.py')
    controls=coordinate_controls();matched=subsets=updates=builds=0
    for record in bank['records']:
        c=record['case'];q=list(map(Q,c['target']));initial=None if c['initial'] is None else [(B,Q(w)) for B,w in c['initial']]
        result=candidate.solve(c['vectors'],q,seconds=2,maximum_steps=1 if record.get('allow_inconclusive') else 100000,
            maximum_bases=1000,verify_invariants=True,initial=initial)
        accepted=check(c['vectors'],q,result,record.get('allow_inconclusive',False))
        for key,value in record['result'].items():
            if key!='seconds':assert result[key]==value,(c['name'],key)
        matched+=1;subsets+=accepted['subsets_checked'];updates+=result['cache_updates'];builds+=result['cache_builds']
    out=dict(status='PASS_EXACT_CACHE_SUBSTITUTION_AND_MATCHED_TINY_ENDPOINTS',consumer_sha256=sha(__file__),
        cached_producer_sha256=sha(ROOT/'exact_matroid_push_relabel_cached.py'),frozen_original_sha256=sha(ROOT/'exact_matroid_push_relabel.py'),
        original_tiny_bank_sha256=sha(a.bank),independent_endpoint_consumer_sha256=sha(ROOT/'two_basis_structure_push_relabel_controls.py'),
        coordinate_controls=controls,matched_endpoints=matched,independent_subset_rank_checks=subsets,
        cache_updates_exercised=updates,full_cache_builds=builds,elapsed_seconds=time.monotonic()-start,
        source_C16_answered=False,physical_timing_claim=False,
        scope='Only cache representation changes. All frozen tiny endpoint fields except wall time match; every coordinate substitution is checked independently on explicit bases.')
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
