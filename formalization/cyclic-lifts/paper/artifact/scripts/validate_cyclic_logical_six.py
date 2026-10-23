"""Independent anchored census, opposite-pivot row spaces and motif certificates."""
from pathlib import Path
from collections import Counter
from itertools import combinations
import hashlib,json,subprocess,sys,tempfile
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent.parent;P=R/'formalization/cyclic-lifts';S=P/'search'
sys.path.insert(0,str(S))
import benchmark_decoding as b

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
  pivot=w&-w
  if pivot not in basis:return False
  w^=basis[pivot]
 return True

def shift(w):
 return sum(1<<(14*(v//14)+(v%14+1)%14) for v in range(252) if w>>v&1)

def motif(rows,support):
 induced=[[v for v in support if row>>v&1] for row in rows]
 used=[ns for ns in induced if ns]
 assert len(used)==9 and all(len(ns)==2 for ns in used)
 adj={frozenset(ns) for ns in used}
 assert len(adj)==9
 # Sorted supports have three variables in each source block family.
 assert len([v for v in support if v<126])==3
 assert adj=={frozenset([v,w]) for v in support[:3] for w in support[3:]}

x=json.loads((S/'logical-six-results.json').read_text())
for name,sha in x['sha256'].items():assert hashlib.sha256((R/name).read_bytes()).hexdigest()==sha,name
assert len(x['records'])==8 and x['new_codes']==x['new_noise_samples']==0
checks=0
with tempfile.TemporaryDirectory(prefix='cyclic-six-independent-') as temp:
 binary=Path(temp)/'anchor'
 subprocess.run(['c++','-std=c++17','-O2',str(S/'logical_six_anchor.cpp'),'-o',str(binary)],check=True)
 for rec in x['records']:
  hx,zm,meta=b.construction(rec['parameters']['B'],14);xm=list(map(b.rowmask,hx))
  rows,stabs=(xm,zm) if rec['sector']=='z' else (zm,xm)
  assert {shift(w) for w in rows}==set(rows) and {shift(w) for w in stabs}==set(stabs)
  cols=[sum(((w>>v)&1)<<c for c,w in enumerate(rows)) for v in range(252)]
  assert len(set(cols))==252 and all(b.popcount(c)==3 for c in cols)
  pairsynd=[cols[a]^cols[c] for a,c in combinations(range(252),2)]
  assert 0 not in pairsynd and len(set(pairsynd))==31626==rec['pair_syndromes']
  data=['252']+[f'{c&((1<<64)-1)} {c>>64}' for c in cols]
  out=subprocess.run([str(binary)],input='\n'.join(data)+'\n',capture_output=True,text=True,check=True)
  anchored=json.loads(out.stdout)
  assert anchored==[item['support'] for item in rec['supports']]
  basis=low_basis(stabs);counts=Counter()
  for item in rec['supports']:
   word=b.rowmask(item['support']);assert not any(b.syndrome(rows,word))
   assert item['logical']==(not member(word,basis))
   counts[item['logical']]+=1;motif(rows,item['support'])
  assert counts[True]==rec['logical_weight6'] and counts[False]==rec['stabilizer_weight6']==126
  assert rec['triples']==2635500
  assert rec['distance']==(6 if rec['name']=='baseline' else None)
  assert rec['distance_lower_bound']==(6 if rec['name']=='baseline' else 8)
  checks+=1
c=json.loads((S/'logical-six-certificate.json').read_text())
hx,zm,meta=b.construction(c['baseline_B'],14)
assert c['hx_rows']==hx and c['hz_rows']==[[v for v in range(252) if w>>v&1] for w in zm]
logical=b.rowmask(c['logical_support']);dual=b.rowmask(c['dual_support'])
assert all(b.popcount(w&dual)%2==0 for w in zm) and b.popcount(logical&dual)%2==1
assert c['stabilizer_support']==c['hz_rows'][0]
print(f'PASS: {checks} sectors; independent anchored 2+3+1 census agrees with full 3+3 census; opposite-pivot stabilizer membership, translation closure, all K3,3 motifs and sparse dual witness checked.')
