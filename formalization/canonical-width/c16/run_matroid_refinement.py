#!/usr/bin/env python3
"""Bounded sequential rank-cut generation, exact cut replay, and warm solves."""
from pathlib import Path
import argparse,datetime,hashlib,json,os,subprocess,sys,time
ROOT=Path(__file__).resolve().parent
OUT=ROOT/'moment-resumption-results'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def stamp():return datetime.datetime.now(datetime.timezone.utc).isoformat()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--deadline',required=True);ap.add_argument('--rounds',type=int,default=8);ap.add_argument('--prefix',default='rank-loop');a=ap.parse_args();deadline=datetime.datetime.fromisoformat(a.deadline.replace('Z','+00:00'));start=time.monotonic();statepath=OUT/(a.prefix+'-state.json');assert not statepath.exists();env=os.environ.copy();env.update({k:'1' for k in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','VECLIB_MAXIMUM_THREADS','MKL_NUM_THREADS']});candidate='moment-resumption-results/unified-matroid-warm3.npz';active='moment-resumption-results/active-moment-rows3.json';banks=['moment-resumption-results/matroid-owner0.json','moment-resumption-results/matroid-warm1.json','moment-resumption-results/zero-face-warm3.json'];replays=[p.replace('.json','-independent.json') for p in banks];state={'status':'RUNNING','source_C16_answered':False,'started_utc':stamp(),'deadline':a.deadline,'maximum_rounds':a.rounds,'records':[],'scope':'Adaptive exploration of a necessary relaxation. All proposed rank cuts must pass independent exact replay before use. Numeric feasible points are not source frames; numerical infeasibility requires exact dual recovery.'}
 def save():
  state.update(candidate=candidate,active_rows=active,rank_banks=banks,rank_replays=replays,elapsed_seconds=time.monotonic()-start,updated_utc=stamp());statepath.write_text(json.dumps(state,indent=2)+'\n')
 def run(command,name,limit):
  fp=OUT/(name+'-controller-frozen.json');assert not fp.exists();paths=[str(Path(__file__).relative_to(ROOT)),*banks,*replays,candidate,active]+[s for s in command if s.endswith(('.py','.json','.npz','.gz')) and (ROOT/s).is_file()];paths+=['conditional_matroid_moment_matrix.py','weighted_matroid_separator.py','verify_weighted_matroid_cuts.py','physical_owner_moment_matrix.py','physical_circuit_moment_matrix.py','physical_legacy_linear_moments.py','moment-resumption-results/physical-rank-moment-bank.json'];fp.write_text(json.dumps({'status':'FROZEN_BEFORE_STEP','utc':stamp(),'command':command,'outer_seconds':limit,'hashes':{p:sha(ROOT/p) for p in dict.fromkeys(paths)}},indent=2)+'\n');print('START',name,stamp(),flush=True)
  with (OUT/(name+'-controller.log')).open('w') as log:
   try:r=subprocess.run(command,cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=limit);rc=r.returncode
   except subprocess.TimeoutExpired:rc='OUTER_TIMEOUT'
  print('END',name,rc,stamp(),flush=True);assert rc==0,(name,rc)
 save();no_gain=0
 try:
  for k in range(a.rounds):
   if (deadline-datetime.datetime.now(datetime.timezone.utc)).total_seconds()<540:state['status']='STOPPED_AT_RESERVED_TIME';break
   record={'round':k,'input_candidate':candidate,'started_utc':stamp()}
   if k:
    mode='full' if k%2 else 'zero';sep=OUT/f'{a.prefix}-separation-{k}.json';script='weighted_matroid_separator.py' if mode=='full' else 'conditioned_zero_pool_separator.py';iters=500 if mode=='full' else 800
    run([sys.executable,'-u',script,'--candidate',candidate,'--iterations',str(iters),'--seconds','240','--output',str(sep.relative_to(ROOT))],f'{a.prefix}-separator-{k}',300);sd=json.loads(sep.read_text());rp=sep.with_name(sep.stem+'-independent.json');run([sys.executable,'-u','verify_weighted_matroid_cuts.py','--certificate',str(sep.relative_to(ROOT)),'--output',str(rp.relative_to(ROOT))],f'{a.prefix}-replay-{k}',90);assert json.loads(rp.read_text())['status']=='PASS';record.update(separator=mode,new_cuts=len(sd['cuts']),queries=len(sd['records']),separator_elapsed=sd['elapsed_seconds'])
    if not sd['cuts']:
     no_gain+=1;record['status']='NO_CUT_IN_BOUNDED_SEPARATOR';state['records'].append(record);save()
     if no_gain>=2:state['status']='STOPPED_AFTER_TWO_BOUNDED_NO_GAIN_SCREENS';break
     continue
    no_gain=0;banks.append(str(sep.relative_to(ROOT)));replays.append(str(rp.relative_to(ROOT)))
   nextactive=f'moment-resumption-results/{a.prefix}-active-{k}.json';run([sys.executable,'prepare_active_moment_rows.py','--candidate',candidate,'--parent',active,'--tolerance','1e-8','--output',nextactive],f'{a.prefix}-active-{k}',90);active=nextactive;name=f'{a.prefix}-model-{k}'
   command=[sys.executable,'-u','run_moment_variant.py','--parent','moment-resumption-results/unified-physical-frozen.json','--model','unified_warm_matroid_mapped_model.py','--name',name,'--seconds','300','--outer-seconds','420','--scope',state['scope'],'--extra','--active-cuts',active,'--matroid-cuts',*banks,'--matroid-replays',*replays,'--warm-point',candidate,'--eps','1e-9']
   run(command,name,450);result=json.loads((OUT/(name+'.json')).read_text());record.update(model=name,status=result['status'],max_constraint_violation=result.get('max_constraint_violation'),matroid_rows=result.get('conditional_matroid_rows'),omitted_family_screen=result.get('omitted_family_numeric_screen'),model_elapsed=result.get('wall_seconds'));state['records'].append(record)
   if result['status'] not in ('optimal','optimal_inaccurate') or result.get('max_constraint_violation',1)>1e-6:state['status']='STOPPED_FOR_NUMERICAL_RESULT_REVIEW';save();break
   candidate=f'moment-resumption-results/{name}.npz';save()
  else:state['status']='MAXIMUM_ROUNDS_FINISHED'
 except Exception as e:state['status']='STEP_FAILED_REQUIRES_REVIEW';state['error']=repr(e)
 save();print(json.dumps(state,indent=2),flush=True)
if __name__=='__main__':main()
