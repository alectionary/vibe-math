"""Independent cycle-seeded lower bounds and opposite-pivot logical witnesses."""
from pathlib import Path
import hashlib,json,subprocess,sys,tempfile
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent.parent;S=R/'formalization/cyclic-lifts/search'
sys.path.insert(0,str(S))
import benchmark_decoding as b
import exact_distance as e

def low_basis(rows):
 out={}
 for w in rows:
  while w:
   pivot=w&-w
   if pivot in out:w^=out[pivot]
   else:out[pivot]=w;break
 return out

def member(w,basis):
 while w:
  p=w&-w
  if p not in basis:return False
  w^=basis[p]
 return True

x=json.loads((S/'exact-distance-results.json').read_text());six=json.loads((S/'logical-six-results.json').read_text())
for name,sha in x['sha256'].items():assert hashlib.sha256((R/name).read_bytes()).hexdigest()==sha,name
records=[]
with tempfile.TemporaryDirectory(prefix='cyclic-distance-cycle-') as temp:
 exe=Path(temp)/'check'
 subprocess.run(['c++','-std=c++17','-O2',str(S/'distance_cycle_validation.cpp'),'-o',str(exe)],check=True)
 for rec in x['records']:
  hx,zm,meta=b.construction(rec['parameters']['B'],14);xm=list(map(b.rowmask,hx))
  rows,stab=(xm,zm) if rec['sector']=='z' else (zm,xm)
  # The cycle-seeded completeness argument needs actual girth and degrees in
  # each sector, not only the source's graph-isomorphism statement.
  adjacency={('v',v):set() for v in range(252)}
  for c,row in enumerate(rows):
   adjacency['c',c]=set()
   for v in range(252):
    if row>>v&1:
     adjacency['c',c].add(('v',v));adjacency['v',v].add(('c',c))
  assert all(len(adjacency['v',v])==3 for v in range(252))
  assert b.girth(adjacency)==8
  old=next(a for a in six['records'] if (a['name'],a['sector'])==(rec['name'],rec['sector']))
  assert old['logical_weight6']==0 and old['distance_lower_bound']==8
  assert {e.shift(w) for w in rows}==set(rows) and {e.shift(w) for w in stab}==set(stab)
  assert len(low_basis(stab))==meta['rank_hz']==121
  for run in rec['searches']:
   assert not run['budget_exhausted']
   if run['witness']:
    word=b.rowmask(run['witness']);assert len(set(run['witness']))==run['weight_limit']==rec['distance']
    assert not any(b.syndrome(rows,word)) and not member(word,low_basis(stab))
   else:assert run['search_completed_without_witness']
  bound=rec['distance']-2
  assert bound in (8,10)
  proc=subprocess.run([str(exe)],input=e.input_data(rows,stab,bound,100000000),capture_output=True,text=True,check=True)
  outcome=json.loads(proc.stdout)
  assert not outcome['budget_exhausted'] and not outcome['witness']
  assert outcome['seed4']==meta['four_variable_absorbing_sets']
  records.append({'name':rec['name'],'sector':rec['sector'],'excluded_through':bound,**outcome})
  print(rec['name'],rec['sector'],'distance',rec['distance'],'independent exclusion through',bound,outcome,flush=True)
(S/'exact-distance-validation.json').write_text(json.dumps({'status':'independent_cycle_seeded_exclusion_passed','records':records},indent=2)+'\n')
# Positive controls exercise both independent solvers on known logical errors.
controls=[]
old_designs=json.loads((S/'benchmark-confirmation.json').read_text())['designs']
with tempfile.TemporaryDirectory(prefix='cyclic-distance-positive-') as temp:
 anchor=Path(temp)/'anchor';seeded=Path(temp)/'seeded'
 subprocess.run(['c++','-std=c++17','-O2',str(S/'exact_distance.cpp'),'-o',str(anchor)],check=True)
 subprocess.run(['c++','-std=c++17','-O2',str(S/'distance_cycle_validation.cpp'),'-o',str(seeded)],check=True)
 for name,cap,expected in [('baseline',6,6),('previous_best',10,10)]:
  meta=old_designs[name];hx,zm,_=b.construction(meta['B'],14);rows=list(map(b.rowmask,hx))
  for method,exe in [('translation_anchored',anchor),('cycle_seeded',seeded)]:
   result=json.loads(subprocess.run([str(exe)],input=e.input_data(rows,zm,cap,100000000),capture_output=True,text=True,check=True).stdout)
   word=b.rowmask(result['witness'])
   assert len(set(result['witness']))==expected and not result['budget_exhausted']
   assert not any(b.syndrome(rows,word)) and not member(word,low_basis(zm))
   controls.append({'code':name,'method':method,'weight_limit':cap,'witness':result['witness']})
(S/'exact-distance-positive-controls.json').write_text(json.dumps(controls,indent=2)+'\n')
print('PASS: four positive controls recover known weight-six and weight-ten logical operators.')
print('PASS: all six sector distances checked by explicit logical witnesses, prior complete weight-six census, translation-anchored search and independent exhaustive cycle-seeded exclusions.')
