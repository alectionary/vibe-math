"""Independent result consumers and cross-language certificate checks (stdlib)."""
from pathlib import Path
import json,itertools,math,hashlib
from verify_certificates import replay
P=Path(__file__).resolve().parent
def main():
 d=json.loads((P/'results.json').read_text());rows=[json.loads(s) for s in (P/'exhaustive-results.jsonl').read_text().splitlines()]
 for row in rows:
  name='star' if row['base_pasches']==1 else 'triangle';N=row['N'];h=row.get('hist',row.get('histogram'))
  expected=[N**11-N**8,N**8,0,0,0,0] if name=='star' else [N**11-5*N**8+10*N**5-10*N**2+4,5*(N**8-4*N**5+6*N**2-3),10*(N**5-3*N**2+2),10*(N**2-1),0,1]
  assert h==expected,(row,expected)
 joint=json.loads((P/'joint-star.json').read_text());a=joint['matrix'];c=joint['certificate'];assert c['rank']==6
 assert replay(a,c['operations'],30)==[[int(i==j) for j in range(30)] for i in range(6)]
 # Rebuild the dual incidence triangle equations independently in original-edge order.
 b=d['bases'][0];base=list(map(set,b['base']));es=list(map(tuple,b['edges']));dual=[{v for v in range(10) if c in base[v]} for c in range(10)];s=(6,7,8,9);dr=[]
 for tri in [(s[0],s[1],s[2]),(s[0],s[1],s[3]),(s[0],s[2],s[3])]:
  r=[0]*30
  for c,e in zip(tri,tri[1:]+tri[:1]):
   v,=dual[c]&dual[e];r[es.index((v,c))]-=1;r[es.index((v,e))]+=1
  dr.append(r)
 assert a==b['cycle_rows'][0]+dr
 q=json.loads((P/'quantum-witness.json').read_text());cpp=json.loads((P/'quantum-independent.json').read_text());assert cpp['passed'] and cpp['quadruples_per_graph']==math.comb(280,4)
 r=q['records'][-1]
 for field in ['variables','rank_X','rank_Z','logical_qubits','N40_X','N40_Z']:assert r[field]==cpp[field]
 assert cpp['distance']==6 and cpp['augmented_Z_rank']==r['rank_Z']+1
 assert cpp['logical_support']==r['weight_six_logicals'][0]['support']
 out=dict(passed=True,certificate_families=34,cpp_gauge_cases=6,cpp_gauge_assignments=2*sum(N**11 for N in [2,3,4]),joint_star_rank=6,quantum_independent=True,quadruples_per_graph=math.comb(280,4),code_parameters=[280,18,6],sha256={f:hashlib.sha256((P/f).read_bytes()).hexdigest() for f in ['results.json','joint-star.json','quantum-witness.json','quantum-independent.json','exhaustive-results.jsonl','verify_quantum.cpp','exhaustive.cpp']})
 (P/'result-validation.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
if __name__=='__main__':main()
