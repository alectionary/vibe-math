#!/usr/bin/env python3
"""Independent replay of global symmetry-normalized cover exchanges."""
from pathlib import Path
import argparse
import json
import subprocess
import sys
import tempfile
import time
from verify_anchored_cover_chain import physical,canonical,check_proof

ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--chain',type=Path,required=True);ap.add_argument('--drat-trim',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();data=json.loads(a.chain.read_text());basepath=ROOT/data['base_chain_c16_path']
    with tempfile.TemporaryDirectory(prefix='c16-exchange-base-') as folder:
        out=Path(folder)/'base.json';run=subprocess.run([sys.executable,str(ROOT/'verify_anchored_cover_chain.py'),'--chain',str(basepath),'--drat-trim',str(a.drat_trim),'--output',str(out)],capture_output=True,text=True,check=True,timeout=240);base_replay=json.loads(out.read_text());assert base_replay['status']=='PASS'
    base=json.loads(basepath.read_text());R=set(map(tuple,base['removed_case_tuples']));assert sorted(R)==list(map(tuple,data['initial_removed']))
    A,C,pos,sig=physical();allclasses=set(C);orbits={}
    def witness(pairs):
        value=0
        for k,(i,j) in enumerate(pairs):
            assert (i,j) in sig and canonical(i,j) in allclasses;value^=sig[i,j]
            for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
        assert value==65535
        return {canonical(i,j) for i,j in pairs}
    for pairs in data['seed_witnesses']:witness(pairs)
    sat=0
    for record in data['records']:
        if record['answer'] is True:
            support=witness(record['counterexample_edges']);assert support<=set(map(tuple,record['trial_removed'])) and support==set(map(tuple,record['counterexample_classes']));sat+=1
    steps=[];proofs=0
    for step in data['steps']:
        assert sorted(R)==list(map(tuple,step['parent_removed']));trial=set(map(tuple,step['trial_removed']));assert trial<=allclasses and len(trial)==len(R)+1
        added=trial-R;restored=R-trial;assert added==set(map(tuple,step['new_classes'])) and restored==set(map(tuple,step['restored_classes'])) and added
        checked=[];covered=set()
        for name in step['branch_certificates']:
            p=a.chain.parent/name;cert=json.loads(p.read_text());c=tuple(cert['case']);assert c in added and c not in covered;covered.add(c);assert set(map(tuple,cert['trial_removed']))==trial
            x,z=16*c[0],16*c[1]+c[2];assert cert['anchor']==[x,z] and sig[x,z]==cert['anchor_signature']
            if c not in orbits:
                orbit={(16*(x//16)+(x+h)%16,16*(z//16)+(z+h)%16) for h in range(16)};orbit|={(j,i) for i,j in list(orbit)};assert orbit=={e for e,s in sig.items() if canonical(*e)==c};orbits[c]=len(orbit)
            free=[(i,j,s,0) for (i,j),s in sig.items() if s and canonical(i,j) in trial and (i,j)!=(x,z) and i!=x and j!=z and not A[i]>>z&1 and not A[x]>>j&1]
            target=65535^sig[x,z];assert target==cert['free_target_signature'] and len(free)==cert['free_edge_count']
            result=check_proof(A,[0],free,cert,p,a.drat_trim,target=target);checked.append({'case':c,**result});proofs+=1
        assert covered==added
        steps.append({'new_retained_count':518-len(trial),'added_classes':sorted(added),'restored_classes':sorted(restored),'branches_checked':checked});R=trial
    D=allclasses-R;assert R==set(map(tuple,data['removed_case_tuples'])) and D==set(map(tuple,data['retained_case_tuples'])) and len(D)==data['retained_case_count']
    result={'status':'PASS','source_C16_answered':False,'base_case_count':base_replay['new_case_count'],'base_chain_fully_replayed':True,'base_anchored_proofs':base_replay['anchored_proofs_checked'],'new_case_count':len(D),'successful_exchange_steps':len(steps),'new_anchored_proofs_checked':proofs,'steps':steps,'physical_pairings_rebuilt':518400,'seed_positive_witnesses_checked':len(data['seed_witnesses']),'new_positive_counterexamples_checked':sat,'unknown_proposals':len(data['unknown_candidates']),'cases':[{'id':f'X{x:02d}-Z{z:02d}-h{h:02d}','X_index':16*x,'Z_index':16*z+h,'orbit_tuple':[x,z,h],'status':'unresolved'} for x,z,h in C if (x,z,h) in D],'elapsed_seconds':time.monotonic()-start,'scope':'Sufficient cover from exact case-split proofs. Restored classes need no exclusion proof because removing possibilities preserves UNSAT. No whole class is excluded from source frames; no minimum-cover claim.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print('PASS: cover',len(D),'exchange steps',len(steps),'new anchored proofs',proofs,'seconds',result['elapsed_seconds'],flush=True)


if __name__=='__main__':main()
