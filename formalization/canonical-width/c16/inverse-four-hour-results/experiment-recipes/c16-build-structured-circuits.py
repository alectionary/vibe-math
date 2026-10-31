from pathlib import Path
import json,sys
root=Path('/private/tmp');short=json.load(open(root/'c16-new-source-short-circuits.json'));thick=json.load(open(root/'c16-new-thick-circuits6.json'));thin=json.load(open(root/'c16-new-thin-relations.json'));out={}
normalize=lambda t:min(tuple(sorted((i//16)*16+(i%16+h)%16 for i in t)) for h in range(16))
for side in ['X','Z']:
 cs=set(map(tuple,short[side]))
 for c in thick[side]:
  for t in range(5):cs.add(normalize([(t*9+v//16)*16+v%16 for v in c]))
 for c in thin[side]['minimal_relation_orbits_through12']:
  for i in range(9):cs.add(normalize([(9*(v//16)+i)*16+v%16 for v in c]))
 out[side]=sorted(cs)
print({s:{str(k):sum(len(c)==k for c in v) for k in range(3,13)} for s,v in out.items()})
(root/'c16-new-structured-circuits6.json').write_text(json.dumps(out)+'\n')
