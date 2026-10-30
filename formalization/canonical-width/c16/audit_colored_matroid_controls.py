#!/usr/bin/env python3
"""Independent replay of every saved tiny colored endpoint and subset."""
import os
assert os.nice(0)==19
from pathlib import Path
from fractions import Fraction as Q
import argparse, gzip, hashlib, json, time

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def rank(vs):
    piv={}
    for v in vs:
        while v:
            k=(v&-v).bit_length()-1
            if k in piv:v^=piv[k]
            else:piv[k]=v;break
    return len(piv)
def check(record,allow_partial=False):
    pools=record['pools'];mass=list(map(Q,record['masses']));target=list(map(Q,record['target']));e=record['endpoint']
    n=len(target);ranks=[rank(p) for p in pools];positive=[c for c,m in enumerate(mass) if m]
    R=ranks[positive[0]];assert all(ranks[c]==R for c in positive) and sum(mass)==1 and min(mass)>=0
    assert sum(target)==R and min(target,default=0)>=0
    D=int(e['denominator']);assert D>0 and all((q*D).denominator==1 for q in mass+target)
    counts=[0]*n;cm=[0]*len(mass);seen=set()
    for b in e['bases']:
        c,B,w=b['color'],b['indices'],int(b['weight_numerator'])
        assert type(c)is int and 0<=c<len(mass) and mass[c]>0 and w>0
        assert B==sorted(set(B)) and len(B)==R and all(type(j)is int and 0<=j<n for j in B)
        assert rank(pools[c][j] for j in B)==R and (c,tuple(B)) not in seen;seen.add((c,tuple(B)))
        cm[c]+=w
        for j in B:counts[j]+=w
    assert cm==[int(q*D) for q in mass]==list(map(int,e['achieved_color_mass_numerators']))
    assert cm==list(map(int,e['color_mass_numerators']))
    assert counts==list(map(int,e['achieved_numerators'])) and [int(q*D) for q in target]==list(map(int,e['target_numerators']))
    maximum=Q(0);subsets=0
    for bits in range(1<<n):
        S=[j for j in range(n) if bits>>j&1]
        gap=sum(target[j] for j in S)-sum(m*rank(p[j] for j in S) for m,p in zip(mass,pools))
        maximum=max(maximum,gap);subsets+=1
    if e['status']=='EXACT_COLORED_BASE_MIXTURE':assert [Q(c,D) for c in counts]==target and maximum==0
    elif e['status']=='EXACT_WEIGHTED_RANK_VIOLATION':
        c=e['violated_weighted_rank'];S=c['indices'];assert S==sorted(set(S)) and all(type(j)is int and 0<=j<n for j in S)
        rr=[rank(p[j] for j in S) for p in pools];bound=sum(m*r for m,r in zip(mass,rr));gap=sum(target[j] for j in S)-bound
        assert gap>0 and gap<=maximum and rr==c['ranks_by_color']
        assert Q(c['weighted_rank'])==bound and int(c['weighted_rank_numerator'])==int(bound*D)
        assert Q(c['exact_violation'])==gap
    else:assert allow_partial and e['status']=='BOUNDED_COLORED_PUSH_RELABEL_INCONCLUSIVE'
    return subsets
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path,required=True);ap.add_argument('--receipt',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();assert not a.output.exists();start=time.monotonic();b,r=read(a.bank),read(a.receipt)
    assert r['status']=='PASS_FINITE_COLORED_AND_PHYSICAL_CONTROLS' and sha(a.bank)==r['bank_sha256']
    assert all(sha(ROOT/p)==h for p,h in r['source_hashes'].items())
    checked=sum(check(row) for row in b['records']);assert checked==r['exhaustive_subset_checks'] and len(b['records'])==r['cases']
    # Fresh replay of the reviewed cache/physical/invalid-input controls.
    import colored_matroid_controls_draft as harness
    import exact_colored_matroid_push_relabel_draft as solver
    import colored_physical_domain_representation_draft as representation
    import verify_colored_physical_endpoint_draft as consumer
    collision,caps=harness.cache_collision_controls(solver)
    assert int(collision['denominator'])==30 and len(caps)==4
    physical=harness.physical_controls(solver,representation,consumer);assert physical==r['physical_controls']
    invalid=harness.invalid_input_controls(solver);assert invalid==r['invalid_inputs_rejected']
    assert all(sha(ROOT/p)==h for p,h in r['source_hashes'].items())
    out=dict(status='PASS_INDEPENDENT_SAVED_COLORED_ENDPOINT_AND_PHYSICAL_REPLAY',
        bank_sha256=sha(a.bank),prior_receipt_sha256=sha(a.receipt),consumer_sha256=sha(__file__),source_hashes=r['source_hashes'],
        saved_endpoints_checked=len(b['records']),independent_exhaustive_subsets=checked,
        physical_control_replay=physical,warm_denominator=30,cap_controls=4,invalid_inputs_rejected=invalid,
        nice=os.nice(0),elapsed_seconds=time.monotonic()-start,large_physical_run=False,source_C16_answered=False,
        maximum_defect_claimed=False,scope='All saved tiny endpoints and subset inequalities independently rederived; audited finite physical/cache/input harness freshly replayed. No large source-instance conclusion.')
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
