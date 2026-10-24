from pathlib import Path
import runpy,collections,json,time
W=Path(__file__).resolve().parent;d=runpy.run_path(str(W/'enumerate.py'));cols=d['cols'];rows=d['rows'];hz=d['hz'];found=set();nodes=0;start=time.monotonic()
def visit(S):
 global nodes
 nodes+=1;degree=collections.Counter(c for v in S for c in cols[v]);c=next((c for c,k in sorted(degree.items())if k==1),None)
 if c is None:found.add(tuple(sorted(S)));return
 if len(S)==6:return
 for v in rows[c]:
  if v not in S:visit(S|{v})
for v in range(882):visit({v})
assert found==hz and len(found)==441
out=dict(evidence='exact finite computation; corroboration, not Lean premise',roots=882,nodes=nodes,size_six_supports=len(found),equals_all_companion_rows=True,all_supports=[list(S)for S in sorted(found)],seconds=time.monotonic()-start)
(W/'full-root-check.json').write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items()if k!='all_supports'})
