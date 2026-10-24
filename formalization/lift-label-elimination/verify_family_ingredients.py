"""Independent finite ingredients of the written family proof; no generator imports."""
from pathlib import Path
import json,itertools,collections
P=Path(__file__).resolve().parent
def mul(a,b):
 out=set()
 for x in a:
  for y in b:
   z=x+y
   if z in out:out.remove(z)
   else:out.add(z)
 return out
def main():
 d=json.loads((P/'family-results.json').read_text());B=[set(s) for s in d['B7_base']];assert B==[{(v-e)%7 for e in [0,1,3]} for v in range(7)]
 es=list(map(tuple,d['carry_edges']));carry=d['integer_carry_labels'];idx={p:i for i,p in enumerate(es)}
 for (v,c),z in zip(es,carry):assert any(v-e==c+7*z for e in [0,1,3])
 supports=[]
 for s in itertools.combinations(range(7),4):
  deg=collections.Counter(c for v in s for c in B[v])
  if all(n==2 for n in deg.values()):supports.append(s)
 assert list(map(list,supports))==[r['support'] for r in d['B7_Pasch_cycle_residuals']]
 for s,record in zip(supports,d['B7_Pasch_cycle_residuals']):
  out=[]
  for tri in [(s[0],s[1],s[2]),(s[0],s[1],s[3]),(s[0],s[2],s[3])]:
   total=0
   for u,v in zip(tri,tri[1:]+tri[:1]):
    c,=B[u]&B[v];total+=carry[idx[u,c]]-carry[idx[v,c]]
   out.append(total)
  assert out==record['cycle_residuals'] and 1 in out
 b={0,1,3};bp={0,2,3};assert mul(mul({0,1},b),bp)=={0,7}
 star=[{0,1,2},{0,3,4},{1,3,5},{2,4,5},{0,6,7},{1,6,8},{2,6,9},{3,7,8},{4,7,9},{5,8,9}]
 ker=[]
 for s in itertools.chain.from_iterable(itertools.combinations(range(10),k) for k in range(11)):
  if all(sum(c in star[v] for v in s)%2==0 for c in range(10)):ker.append(s)
 assert len(ker)==8 and tuple(d['base_weight_six_dependency']) in ker
 assert not {0,4}&set(d['base_weight_six_dependency'])
 out=dict(passed=True,evidence='independent_finite_ingredient_verification_not_a_formal_general_rank_proof',Fano_complete_Pasches=7,all_have_integer_unit_residual=True,polynomial_factorization_checked=True,base_kernel_supports=ker,base_kernel_card=8,base_binary_rank_from_rank_nullity=7)
 (P/'family-ingredient-verification.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
