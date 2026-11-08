import sys,json,pathlib,collections,time
p=pathlib.Path(__file__).resolve().parent;sys.path.insert(0,str(p));from verify_algebraic_model import physical
X,Z,A=physical()
def add(B,v):
 while v:
  k=v.bit_length()-1
  if k not in B:B[k]=v;return
  v^=B[k]
rows=[]
for o in range(45):
 U={}
 for x in X[16*o:16*o+16]:add(U,x)
 UB=list(U.values());labels=[sum(((u&z).bit_count()%2)<<k for k,u in enumerate(UB)) for z in Z];B={};reps={}
 for j,v in enumerate(labels):
  if not v:add(B,Z[j])
 d1=len(B)
 for j,label in enumerate(labels):
  if label in reps:add(B,Z[j]^Z[reps[label]])
  else:reps[label]=j
 d2=len(B);r=128-len(U)
 rows.append({'orbit':o,'U_dimension':len(U),'W_dimension':r,'label_classes':len(reps),'short_sum_rank_1':d1,'short_sum_rank_2':d2,'bound_from_d2':len(U)-(2 if d2<r else 1 if d1<r else 0)})
for r in rows:print(r,flush=True)
(p/'strategy-results/short-sum-flat-gate.json').write_text(json.dumps({'status':'EXACT_D2_GATE','source_C16_answered':False,'records':rows},indent=2)+'\n')
