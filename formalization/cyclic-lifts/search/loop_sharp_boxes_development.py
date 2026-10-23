"""Old-data-only diagnostic refinement: signed-min corner interval propagation.

The decoder is unchanged. This separate diagnostic process replaces only the
interval enclosure function; it does not revise the frozen holdout detector.
Candidate boxes are exploratory until separately proved sound and closed.
"""
from pathlib import Path
import json,random,time
from develop_loop_mechanisms import codes
from merged_reference_states import graph,states,check,CAP
import loop_reference as ref
HERE=Path(__file__).resolve().parent

def raw(a,z):return (-1 if (a<0)!=(z<0) else 1)*min(abs(a),abs(z))
def normalize(x):return (-1 if x<0 else 1)*min(CAP,(800*abs(x)+500)//1000)
def sharp_check(s,intervals):
 lo=hi=(-1 if s else 1)*1000*(1<<20)
 for a,z in intervals:
  values=[raw(x,y) for x in [lo,hi] for y in [a,z]];lo=min(values);hi=max(values)
 return normalize(lo),normalize(hi)

def run():
 start=time.monotonic();coarse=ref.interval_check;rng=random.Random(184309);samples=0
 for i in range(2000):
  xs=[]
  for k in range(rng.randrange(1,12)):
   a=rng.randint(-CAP,CAP);z=rng.randint(-CAP,CAP);xs.append((min(a,z),max(a,z)))
  s=rng.randrange(2);lo,hi=sharp_check(s,xs);a,z=coarse(s,xs);assert a<=lo<=hi<=z
  for j in range(10):assert lo<=check(s,[rng.randint(a,z) for a,z in xs])<=hi;samples+=1
 # Diagnostic-only injection into the interval propagator. Exact decoder states
 # still come from the untouched merged_reference_states implementation.
 ref.interval_check=sharp_check
 old=json.loads((HERE/'loop-development-full-results.json').read_text());results=[]
 for name,c in codes().items():
  for label in ['original','merged']:
   rec=next(r for r in old['records'] if r['design']==name and r['representation']==label)
   choices=sorted(set(rec['example_indices'][key] for key in ['hard_only','pinned'] if key in rec['example_indices']))
   for idx in choices:
    w=next(w for w in rec['witnesses'] if w['index']==idx);history,terminal=states(c[label],w['error']);assert not terminal[1]
    g=graph(c[label]);target=[sum(w['error'][v]=='1' for v in row)%2 for row in c[label]]
    for period in [1,2]:
     boxes=[]
     for phase in range(period):
      selected=[state['q'] for k,state in enumerate(history) if k>=100-8*period and k%period==phase]
      boxes.append([(min(q[e] for q in selected),max(q[e] for q in selected)) for e in range(756)])
     passes=0;rejects=[];certified=False
     for iteration in range(1,129):
      evaluations=[ref.interval_step(g,target,box) for box in boxes]
      if all(all(lo<=a and z<=hi for (lo,hi),(a,z) in zip(boxes[(phase+1)%period],ev[0])) for phase,ev in enumerate(evaluations)):
       passes=iteration;rejects=[ev[2][0] if ev[2] else -1 for ev in evaluations];certified=all(c>=0 for c in rejects);break
      updated=[box.copy() for box in boxes]
      for phase,ev in enumerate(evaluations):
       j=(phase+1)%period;updated[j]=[(min(lo,a),max(hi,z)) for (lo,hi),(a,z) in zip(boxes[j],ev[0])]
      boxes=updated
     result=dict(design=name,representation=label,index=idx,period=period,closure_passes=passes,rejecting_checks=rejects,candidate_certificate=certified)
     if certified:result.update(boxes=boxes,error=w['error'])
     results.append(result);print({k:v for k,v in result.items() if k not in ['boxes','error']},flush=True)
 out=dict(status='exploratory_old_data_only_sharper_enclosures_not_frozen_holdout',new_noise_patterns=0,sampled_enclosures_checked=samples,records=results,elapsed_seconds=time.monotonic()-start)
 (HERE/'loop-sharp-boxes-development.json').write_text(json.dumps(out,indent=2)+'\n')
if __name__=='__main__':run()
