#!/usr/bin/env python3
"""Exact case-floor primal replay, retaining separately labeled broader screens."""
from pathlib import Path
from fractions import Fraction
import argparse,json,os,subprocess,sys,time
from verify_full_partner_projection_generic import sha,read,point_data
from complete_boolean_triples import matrix as boolean_matrix
ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--trial',type=Path,required=True)
    ap.add_argument('--point',type=Path,required=True);ap.add_argument('--old-replay',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists()
    started=time.monotonic();trial=read(a.trial);command=trial['command'];prior=read(a.old_replay)
    assert prior['status']=='PASS' and prior['certificate_sha256']==sha(a.point)
    assert all(sha(ROOT/p)==s for p,s in trial['input_and_source_hashes'].items())
    def values(flag):
        i=max(i for i,v in enumerate(command) if v==flag)+1;j=i
        while j<len(command) and not command[j].startswith('--'):j+=1
        return command[i:j]
    condition=trial['case_condition'];owner,_=point_data(a.point,32)
    moment=owner[condition['owner_coordinate']];floor=Fraction(condition['necessary_floor'])
    assert moment>=floor
    BM,rhs,_=boolean_matrix([Path(p) for p in values('--boolean-cuts')]);minimum=None
    for i in range(BM.shape[0]):
        row=BM.getrow(i);slack=int(rhs[i])-sum(int(v)*owner[int(j)] for j,v in zip(row.indices,row.data))
        assert slack>=0;minimum=slack if minimum is None else min(minimum,slack)
    steps=[('unified-exact','verify_unified_moment_point.py',['--certificate',str(a.point),'--old-replay',str(a.old_replay),'--matroid-cuts',*values('--matroid-cuts'),'--matroid-replays',*values('--matroid-replays')]),
        ('projected-exact','verify_projected_profile_moment_rows.py',['--point',str(a.point),'--banks',*values('--projected-cuts'),'--replays',*values('--projected-replays'),'--require-feasible']),
        ('basis-exact','verify_multi_orbit_coupling_rows.py',['--point',str(a.point),'--banks',*values('--basis-cuts'),'--replays',*values('--basis-replays'),'--require-feasible']),
        ('global-moment-screen','check_global_conditioned_moments.py',['--point',str(a.point),'--global-certificate','moment-resumption-results/global-four-trial.json','--global-replay','moment-resumption-results/global-four-trial-independent.json']),
        ('all-triples','complete_boolean_triples.py',['--point',str(a.point)]),
        ('triple-distributions','verify_all_triple_distributions.py',['--point',str(a.point)])]
    sources={**trial['input_and_source_hashes'],str(a.point):sha(a.point),str(a.old_replay):sha(a.old_replay),str(a.trial):sha(a.trial),
        'check_cover_case_moment_point.py':sha(Path(__file__))}
    for _,script,_ in steps:sources[script]=sha(ROOT/script)
    fp=a.output.with_suffix('.frozen.json');assert not fp.exists();fp.write_text(json.dumps({'status':'FROZEN_CASE_PRIMAL_CHECKS','source_C16_answered':False,'source_hashes':sources,'case_condition':condition,'point_sha256':sha(a.point)},indent=2)+'\n')
    env=os.environ.copy();env.update({k:'1' for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','VECLIB_MAXIMUM_THREADS','MKL_NUM_THREADS')})
    records=[]
    for name,script,args in steps:
        output=a.output.with_name(a.output.stem+'-'+name+'.json');assert not output.exists();t=time.monotonic()
        with output.with_suffix('.log').open('w') as log:
            result=subprocess.run([sys.executable,'-B',script,*args,'--output',str(output)],cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=180)
        receipt=read(output) if output.exists() else {}
        records.append({'stage':name,'returncode':result.returncode,'status':receipt.get('status'),'seconds':time.monotonic()-t,'receipt_sha256':sha(output) if output.exists() else None})
        print(records[-1],flush=True)
    unchanged=all(sha(ROOT/p)==s for p,s in sources.items())
    finite=all(r['returncode']==0 and r['status']=='PASS' for r in records[:3]) and unchanged
    all_pass=all(r['returncode']==0 and r['status']=='PASS' for r in records) and unchanged
    out={'status':'PASS_CASE_RELAXATION_AND_ALL_SCREENS' if all_pass else 'PASS_FINITE_CASE_RELAXATION_ONLY' if finite else 'CASE_PRIMAL_NOT_ACCEPTED',
        'source_C16_answered':False,'source_anchor_excluded':False,'point_sha256':sha(a.point),'trial_frozen_sha256':sha(a.trial),'case':condition['case'],
        'exact_case_moment':str(moment),'necessary_floor':str(floor),'exact_case_floor_slack':str(moment-floor),
        'selected_boolean_rows_checked':BM.shape[0],'minimum_exact_selected_boolean_slack':str(minimum),
        'old_profile_PSD_replay_sha256':sha(a.old_replay),'finite_model_feasible':finite,'broader_screens_pass':all_pass,
        'stages':records,'source_files_unchanged':unchanged,'frozen_sha256':sha(fp),'elapsed_seconds':time.monotonic()-started,
        'scope':'An accepted rational point prevents exclusion of this case by the stated finite relaxation plus its symmetry-derived floor. This does not construct a source frame or certify any true completion of the selected pair.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='stages'},indent=2))


if __name__=='__main__':main()
