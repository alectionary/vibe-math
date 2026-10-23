"""Finite weight-six logical audit for the unchanged cyclic paper benchmark."""
from pathlib import Path
import hashlib,json,subprocess,tempfile
import benchmark_decoding as b
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]


def run():
 source=json.loads((HERE/'benchmark-confirmation.json').read_text());results=[]
 with tempfile.TemporaryDirectory(prefix='cyclic-logical-six-') as temp:
  binary=Path(temp)/'census'
  subprocess.run(['c++','-std=c++17','-O2',str(HERE/'logical_six.cpp'),'-o',str(binary)],check=True)
  for name,meta in source['designs'].items():
   hx,hz,checked=b.construction(meta['B'],meta['r']);assert checked==meta
   xm=list(map(b.rowmask,hx));zm=hz;n=meta['n']
   for sector,checks,stabilizers in [('z',xm,zm),('x',zm,xm)]:
    cols=[sum(((row>>v)&1)<<c for c,row in enumerate(checks)) for v in range(n)]
    degrees=[b.popcount(c) for c in cols];assert set(degrees)=={3}
    data=[f'{n} {len(checks)} {len(stabilizers)}']
    data.extend(f'{c&((1<<64)-1)} {c>>64}' for c in cols)
    data.extend(' '.join(str((row>>(64*j))&((1<<64)-1)) for j in range(4)) for row in stabilizers)
    proc=subprocess.run([str(binary)],input='\n'.join(data)+'\n',capture_output=True,text=True,check=True)
    result=json.loads(proc.stdout)
    sb=b.basis(stabilizers)
    for item in result['supports']:
     word=b.rowmask(item['support'])
     assert not any(b.syndrome(checks,word))
     assert item['logical']==(not b.in_span(word,sb))
    result.update({'name':name,'sector':sector,'parameters':meta,'odd_column_degree':3,
                   'distance':6 if result['logical_weight6'] else None,
                   'distance_lower_bound':6 if result['logical_weight6'] else 8})
    results.append(result);print(name,sector,'logical6',result['logical_weight6'],'stabilizer6',result['stabilizer_weight6'],'distance',result['distance'],'lowerbound',result['distance_lower_bound'],flush=True)
 paths=[Path(__file__),HERE/'logical_six.cpp',HERE/'benchmark-confirmation.json',HERE/'benchmark_decoding.py',HERE.parent/'LOW-WEIGHT-PROTOCOL.md']
 result={'status':'exhaustive_weight_six_logical_census_not_Lean_proof','scope':'four existing cyclic LP benchmark codes, both sectors; no new noise or decoder',
         'new_codes':0,'new_noise_samples':0,'records':results,
         'sha256':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}}
 (HERE/'logical-six-results.json').write_text(json.dumps(result,indent=2)+'\n')


if __name__=='__main__':run()
