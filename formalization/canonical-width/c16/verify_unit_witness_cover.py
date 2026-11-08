#!/usr/bin/env python3
"""Physical consumer for a new-witness unit-signature cover chain."""
from pathlib import Path
import argparse
import json
import time
from verify_anchored_cover_chain import physical,canonical,check_proof


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--chain',type=Path,required=True);ap.add_argument('--drat-trim',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();d=json.loads(a.chain.read_text());A,C,pos,sig=physical(d['witness_orbit']);assert len(C)==d['support_case_count']
    weights={canonical(i,j):s.bit_count() for (i,j),s in sig.items() if s};assert all(weights[canonical(i,j)]==s.bit_count() for (i,j),s in sig.items() if s)
    nonunit=sum(w!=1 for w in weights.values());assert nonunit==d['nonunit_case_count'] and len(C)-nonunit==d['unit_case_count']
    def matching(pairs):
        value=0
        for k,(i,j) in enumerate(pairs):
            assert (i,j) in sig;value^=sig[i,j]
            for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
        assert value==65535
    mandatory=set()
    for record in d['single_class_unit_positive_records']:
        c=tuple(record['case']);assert c in pos and weights[c]==1 and c not in mandatory;mandatory.add(c);matching(record['partial_matching']);assert all(canonical(i,j)==c for i,j in record['partial_matching'])
    R=set();assert d['initial_removed']==[] and 65535!=0
    steps=[];sat=0;filenames=[];trivial=0
    for record in d['records']:
        c=tuple(record['case']);assert c in pos and c not in R and weights[c]==1
        trial=R|{c};x,z=16*c[0],16*c[1]+c[2];assert record['anchor']==[x,z] and sig[x,z].bit_count()==1
        target=65535^sig[x,z]
        if record['answer'] is True:
            pairs=record['partial_matching'];assert pairs[0]==[x,z] and len(pairs)==16;matching(pairs);assert all(canonical(i,j) in trial for i,j in pairs);sat+=1
        elif record['answer'] is False:
            p=a.chain.parent/f'step-{len(steps):03d}.json';cert=json.loads(p.read_text());assert set(map(tuple,cert['removed_before']))==R and set(map(tuple,cert['removed_after']))==trial and tuple(cert['case_added_to_removed'])==c
            orbit={(16*(x//16)+(x+h)%16,16*(z//16)+(z+h)%16) for h in range(16)};orbit|={(j,i) for i,j in list(orbit)};assert orbit=={e for e,s in sig.items() if canonical(*e)==c}
            original=[(i,j,s,0) for (i,j),s in sig.items() if s and canonical(i,j) in trial and (i,j)!=(x,z) and i!=x and j!=z and not A[i]>>z&1 and not A[x]>>j&1];assert all(s.bit_count()==1 for i,j,s,k in original)
            free=[e for e in original if e[2]&target];assert len(original)==cert['free_edges_before_zero_target_deletion'] and len(free)==cert['free_edge_count'] and target==cert['free_target_signature'] and cert['signature_compression'] and cert['one_per_signature']
            checked=check_proof(A,[0],free,cert,p,a.drat_trim,target=target);trivial+=checked['verification_kind']=='literal_empty_input_clause';steps.append({'case':c,'retained_count':len(C)-len(trial),**checked});filenames.append(p.name);R=trial
    assert filenames==d['steps'] and R==set(map(tuple,d['removed_case_tuples']));D=set(C)-R;assert D==set(map(tuple,d['retained_case_tuples'])) and len(D)==d['retained_case_count']
    result={'status':'PASS','source_C16_answered':False,'witness_orbit':d['witness_orbit'],'linear_support_case_count':len(C),'new_case_count':len(D),'unit_classes':len(C)-nonunit,'nonunit_classes':nonunit,'anchored_proofs_checked':len(steps),'literal_empty_clause_cases':trivial,'steps':steps,'positive_signature_partial_frames_checked':sat,'single_class_unit_positive_witnesses_checked':len(mandatory),'restricted_unit_cover_lower_bound':nonunit+len(mandatory),'base_UNSAT':'literal empty set cannot have nonzero XOR65535','physical_pairings_rebuilt':518400,'cases':[{'id':f'X{x:02d}-Z{z:02d}-h{h:02d}','X_index':16*x,'Z_index':16*z+h,'orbit_tuple':[x,z,h],'status':'unresolved'} for x,z,h in C if (x,z,h) in D],'elapsed_seconds':time.monotonic()-start,'scope':'New sufficient cover using witness-specific16 signatures. Not a subcover of the old518 support; restricted lower bound applies only when every nonunit class is retained. No whole source completion is solved.'};a.output.write_text(json.dumps(result,indent=2)+'\n');print('PASS: witness',d['witness_orbit'],'cover',len(D),'proofs',len(steps),'seconds',result['elapsed_seconds'],flush=True)


if __name__=='__main__':main()
