"""Independent interval equations and exact-state persistence diagnostics."""
from merged_reference_states import graph,states,CAP,PRIOR
from benchmark_decoding import string_mask,rowmask,syndrome

def interval_check(syn,intervals):
 signs={bool(syn)};low=high=1000*(1<<20)
 for lo,hi in intervals:
  assert lo<=hi
  possible={False} if lo>=0 else {True} if hi<0 else {False,True}
  signs={a!=b for a in signs for b in possible}
  lower=0 if lo<=0<=hi else min(abs(lo),abs(hi));upper=max(abs(lo),abs(hi))
  low=min(low,lower);high=min(high,upper)
 normalize=lambda n:min(CAP,(800*n+500)//1000)
 values=[]
 for sign in signs:
  values.extend([-normalize(high),-normalize(low)] if sign else [normalize(low),normalize(high)])
 return min(values),max(values)

def interval_step(g,target,box):
 r=[None]*len(box)
 for c,es in enumerate(g['ce']):
  for e in es:r[e]=interval_check(target[c],[box[f] for f in es if f!=e])
 bits=[];next_box=[None]*len(box)
 clip=lambda n:max(-CAP,min(CAP,n))
 for v,es in enumerate(g['ve']):
  lo=PRIOR+sum(r[e][0] for e in es);hi=PRIOR+sum(r[e][1] for e in es)
  bits.append(1 if hi<0 else 0 if lo>=0 else None)
  for e in es:next_box[e]=(clip(PRIOR+sum(r[f][0] for f in es if f!=e)),clip(PRIOR+sum(r[f][1] for f in es if f!=e)))
 odd=[]
 for c,es in enumerate(g['ce']):
  values=[bits[g['edge'][e][1]] for e in es]
  if None not in values and sum(values)%2!=target[c]:odd.append(c)
 return next_box,bits,odd

def interval_tail(rows,error,q75,entry=75,radius=1):
 g=graph(rows);target=syndrome(list(map(rowmask,rows)),string_mask(error));box=[(max(-CAP,x-radius),min(CAP,x+radius)) for x in q75]
 trace=[];persistent=set(range(len(rows)));last=entry-1
 for iteration in range(entry,101):
  nxt,bits,odd=interval_step(g,target,box)
  trace.append(dict(iteration=iteration,box=box,next_box=nxt,bits=bits,odd_checks=odd))
  if not odd:break
  persistent.intersection_update(odd);last=iteration;box=nxt
 return dict(last=last,pinned=min(persistent) if last==100 and persistent else -1,trace=trace)

def diagnostics(rows,error):
 history,terminal=states(rows,error);g=graph(rows);target=syndrome(list(map(rowmask,rows)),string_mask(error))
 seen={};start=period=repeat=0
 for k,state in enumerate(history):
  key=tuple(state['q'])
  if key in seen:start=seen[key]+1;period=k-seen[key];repeat=k+1;break
  seen[key]=k
 box_passes=0;box_check=-1
 if not terminal[1] and history:
  tail=history[-8:];box=[(min(s['q'][e] for s in tail),max(s['q'][e] for s in tail)) for e in range(len(g['edge']))]
  for pass_index in range(1,33):
   nxt,bits,odd=interval_step(g,target,box)
   if all(lo<=a and b<=hi for (lo,hi),(a,b) in zip(box,nxt)):
    box_passes=pass_index;box_check=odd[0] if odd else -1;break
   box=[(min(lo,a),max(hi,b)) for (lo,hi),(a,b) in zip(box,nxt)]
 if len(history)>=75:tail=interval_tail(rows,error,history[74]['q'])
 else:tail=dict(last=-1,pinned=-1)
 return dict(terminal=terminal,cycle_start=start,cycle_period=period,cycle_repeat=repeat,box_passes=box_passes,box_check=box_check,robust_last=tail['last'],pinned=tail['pinned']),history
