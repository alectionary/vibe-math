import sys,json,itertools
from pathlib import Path
sys.path.insert(0,'/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16')
from block_moment_dual import layout
from moment_integer_form_cuts import coefficients
root=Path('/private/tmp');forms=json.load(open(root/'c16-new-pentagon-screen.json'))['cuts']+json.load(open(root/'c16-new-LLL-form-screen.json'))['cuts'];p,C,V=layout(90,16);reverse={j:('p',i) for i,j in enumerate(p)}
for h in range(16):
 for i in range(90):
  for j in range(90):reverse.setdefault(C[h][i][j],('C',h,i,j))
def value(var,masks):
 key=reverse[var]
 if key[0]=='p':return masks[key[1]].bit_count()
 _,h,i,j=key;b=masks[j];return (masks[i]&(((b>>h)|(b<<(16-h)))&65535)).bit_count()
trials=0;cuts=[];seen=set()
for cut in forms:
 row,rhs=coefficients(cut,p,C)
 if (row,rhs) not in seen:seen.add((row,rhs));cuts.append(cut)
 for bits in itertools.product([0,1],repeat=len(cut['events'])):
  masks=[0]*90
  for event,b in zip(cut['events'],bits):
   if b:masks[event//16]|=1<<(event%16)
  expected=0
  for h in range(16):
   S=cut['constant']+sum(b*(masks[v//16]>>((v%16+h)%16)&1) for v,b in zip(cut['events'],cut['weights']));expected+=S*(S-1)//2
  actual=16*rhs-sum(coef*value(j,masks) for j,coef in row);assert actual==expected and actual>=0;trials+=1
# Also test mixed integer coefficients and phase collisions, independent of the discovery templates.
for c in [-2,-1,0,1,2]:
 cut={'events':[0,1,16,33],'weights':[2,-1,1,-2],'constant':c};row,rhs=coefficients(cut,p,C)
 for bits in itertools.product([0,1],repeat=4):
  masks=[0]*90
  for event,b in zip(cut['events'],bits):
   if b:masks[event//16]|=1<<(event%16)
  expected=sum((S:=c+sum(b*(masks[v//16]>>((v%16+h)%16)&1) for v,b in zip(cut['events'],cut['weights'])))*(S-1)//2 for h in range(16));assert 16*rhs-sum(coef*value(j,masks) for j,coef in row)==expected>=0;trials+=1
(root/'c16-new-combined-integer-form-cuts.json').write_text(json.dumps(cuts)+'\n');r={'status':'PASS','input_discovered_forms':len(forms),'distinct_inequality_rows':len(cuts),'exact_literal_and_translated_moment_comparisons':trials,'source_C16_answered':False};(root/'c16-new-integer-form-controls.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r),flush=True)
