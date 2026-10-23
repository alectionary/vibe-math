"""Exact distances of the three existing cyclic benchmark comparison codes."""
from pathlib import Path
import hashlib,json,subprocess,tempfile
import benchmark_decoding as b
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]

def input_data(rows,stabilizers,weight,limit=20000000):
 cols=[sum(((w>>v)&1)<<c for c,w in enumerate(rows)) for v in range(252)]
 data=[f'252 126 126 {weight} {limit}']+[f'{c&((1<<64)-1)} {c>>64}' for c in cols]
 data+=[' '.join(str((w>>(64*j))&((1<<64)-1)) for j in range(4)) for w in stabilizers]
 return '\n'.join(data)+'\n'

def shift(word):
 return sum(1<<(14*(v//14)+(v%14+1)%14) for v in range(252) if word>>v&1)

def run():
 old=json.loads((HERE/'benchmark-confirmation.json').read_text());records=[]
 with tempfile.TemporaryDirectory(prefix='cyclic-exact-distance-') as temp:
  exe=Path(temp)/'search'
  subprocess.run(['c++','-std=c++17','-O2',str(HERE/'exact_distance.cpp'),'-o',str(exe)],check=True)
  for name,meta in old['designs'].items():
   if name=='baseline':continue
   hx,zm,checked=b.construction(meta['B'],14);xm=list(map(b.rowmask,hx));assert checked==meta
   for sector,rows,stab in [('z',xm,zm),('x',zm,xm)]:
    assert {shift(w) for w in rows}==set(rows) and {shift(w) for w in stab}==set(stab)
    searches=[];distance=None
    for weight in (8,10,12):
     proc=subprocess.run([str(exe)],input=input_data(rows,stab,weight),capture_output=True,text=True,check=True)
     result=json.loads(proc.stdout);result['weight_limit']=weight
     assert not result['budget_exhausted']
     if result['witness']:
      word=b.rowmask(result['witness'])
      assert len(set(result['witness']))==weight
      assert not any(b.syndrome(rows,word)) and not b.in_span(word,b.basis(stab))
      distance=weight
     else:assert result['search_completed_without_witness']
     searches.append(result)
     if distance:break
    assert distance==(12 if name=='minimum_2' else 10)
    records.append({'name':name,'sector':sector,'parameters':meta,'distance':distance,'searches':searches})
    print(name,sector,distance,[s['nodes'] for s in searches],flush=True)
 paths=[Path(__file__),HERE/'exact_distance.cpp',HERE/'benchmark-confirmation.json',HERE/'logical-six-results.json',HERE.parent/'DISTANCE-MATCHED-PROTOCOL.md']
 out={'status':'translation_anchored_exact_finite_distance_search','records':records,
      'new_codes':0,'new_noise_samples':0,'sha256':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}}
 (HERE/'exact-distance-results.json').write_text(json.dumps(out,indent=2)+'\n')

if __name__=='__main__':run()
