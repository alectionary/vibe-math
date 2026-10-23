"""Exploratory two-phase box refinement, old data only; not the frozen holdout rule."""
from pathlib import Path
import json,time
from develop_loop_mechanisms import codes
from merged_reference_states import graph,states
from loop_reference import interval_step
HERE=Path(__file__).resolve().parent

def run():
 old=json.loads((HERE/'loop-development-full-results.json').read_text());results=[];start=time.monotonic()
 for name,c in codes().items():
  for label in ['original','merged']:
   rec=next(r for r in old['records'] if r['design']==name and r['representation']==label);idx=rec['example_indices']['hard_only'];w=next(w for w in rec['witnesses'] if w['index']==idx)
   history,terminal=states(c[label],w['error']);assert not terminal[1]
   period=w['hard_tail_period'];g=graph(c[label]);target=[sum(w['error'][v]=='1' for v in row)%2 for row in c[label]]
   boxes=[]
   for phase in range(period):
    selected=[s['q'] for k,s in enumerate(history) if k>=len(history)-8*period and k%period==phase]
    boxes.append([(min(q[e] for q in selected),max(q[e] for q in selected)) for e in range(756)])
   passes=0;rejects=[];certified=False
   for iteration in range(1,129):
    evaluations=[interval_step(g,target,box) for box in boxes];closed=True
    for phase,(nxt,bits,odd) in enumerate(evaluations):
     target_box=boxes[(phase+1)%period]
     if not all(lo<=a and b<=hi for (lo,hi),(a,b) in zip(target_box,nxt)):closed=False
    if closed:
     passes=iteration;rejects=[odd[0] if odd else -1 for nxt,bits,odd in evaluations];certified=all(c>=0 for c in rejects);break
    updated=[box.copy() for box in boxes]
    for phase,(nxt,bits,odd) in enumerate(evaluations):
     j=(phase+1)%period
     updated[j]=[(min(lo,a),max(hi,b)) for (lo,hi),(a,b) in zip(boxes[j],nxt)]
    boxes=updated
   result=dict(design=name,representation=label,index=idx,period=period,closure_passes=passes,rejecting_checks=rejects,certified=certified)
   if certified:result['boxes']=boxes;result['error']=w['error']
   results.append(result);print({k:v for k,v in result.items() if k not in ['boxes','error']},flush=True)
 out=dict(status='exploratory_old_data_refinement_not_frozen_holdout',new_noise_patterns=0,max_passes=128,records=results,elapsed_seconds=time.monotonic()-start)
 (HERE/'loop-two-phase-development.json').write_text(json.dumps(out,indent=2)+'\n')
if __name__=='__main__':run()
