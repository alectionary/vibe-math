"""Independent replay of integer certificates and formula coefficients. No dependencies."""
from pathlib import Path
import json,itertools,collections
P=Path(__file__).resolve().parent
def replay(a,ops,n):
 a=[r[:] for r in a]
 for op in ops:
  t,*p=op
  if t=='rs':i,j=p;a[i],a[j]=a[j],a[i]
  elif t=='cs':
   i,j=p
   for r in a:r[i],r[j]=r[j],r[i]
  elif t=='rn':i,=p;a[i]=[-x for x in a[i]]
  elif t=='ra':i,j,k=p;assert i!=j;a[i]=[x+k*y for x,y in zip(a[i],a[j])]
  elif t=='ca':
   i,j,k=p;assert i!=j
   for r in a:r[i]+=k*r[j]
  else:raise AssertionError(op)
 return a
def main():
 d=json.loads((P/'results.json').read_text());records=[]
 for b in d['bases']:
  base=list(map(set,b['base']));edges=list(map(tuple,b['edges']));assert len(set(edges))==30
  assert all(len(c)==3 for c in base)
  assert all(len(c&d)<=1 for c,d in itertools.combinations(base,2))
  assert all(sum(c in s for s in base)==3 for c in range(10))
  tree=b['tree_edges'];chords=b['chord_edges']
  assert len(tree)==19 and len(chords)==11 and sorted(tree+chords)==list(range(30))
  adj=[set() for _ in range(20)]
  for j in tree:
   v,c=edges[j];adj[v].add(10+c);adj[10+c].add(v)
  reached={0};todo=[0]
  while todo:
   for v in adj[todo.pop()]:
    if v not in reached:reached.add(v);todo.append(v)
  assert len(reached)==20 # connected19edges on20vertices is a spanning tree
  idx={p:i for i,p in enumerate(edges)};supports=[]
  for s in itertools.combinations(range(10),4):
   counts=collections.Counter(c for v in s for c in base[v])
   if set(counts.values())=={2}:supports.append(s)
  assert list(map(list,supports))==b['base_supports']
  rebuilt=[]
  for s in supports:
   rows=[]
   for tri in [(s[0],s[1],s[2]),(s[0],s[1],s[3]),(s[0],s[2],s[3])]:
    row=[0]*30
    for u,v in zip(tri,tri[1:]+tri[:1]):
     c,=base[u]&base[v];row[idx[u,c]]+=1;row[idx[v,c]]-=1
    rows.append(row)
   rebuilt.append(rows)
  assert rebuilt==b['cycle_rows']
  polynomial=collections.Counter();rank_by_size=collections.defaultdict(set)
  for c in b['intersection_certificates']:
   matrix=[r for i,rows in enumerate(rebuilt) if c['mask']>>i&1 for r in rows];assert matrix==c['matrix']
   for field,n,a in [('full_certificate',30,matrix),('gauge_certificate',11,[[r[j] for j in b['chord_edges']] for r in matrix])]:
    cert=c[field];reduced=replay(a,cert['operations'],n);rank=cert['rank']
    assert reduced==[[int(i==j and i<rank) for j in range(n)] for i in range(len(a))]
    assert cert['unit_invariant_factors']==[1]*rank
   rank=c['full_certificate']['rank'];rank_by_size[c['selected']].add(rank);polynomial[30-rank]+=(-1)**c['selected']
  expected={30:1,27:-1} if b['name']=='star' else {30:1,27:-5,24:10,21:-10,19:4}
  assert {p:c for p,c in polynomial.items() if c}==expected
  records.append(dict(name=b['name'],base_pasches=len(supports),intersection_certificates_replayed=len(b['intersection_certificates']),all_reduced_invariant_factors_one=True,ranks_by_selected_size={str(k):sorted(v) for k,v in rank_by_size.items()},eliminating_label_polynomial={str(k):v for k,v in expected.items()}))
 out=dict(all_passed=True,evidence='independent_exact_integer_certificate_replay',no_field_or_prime_assumption=True,records=records)
 (P/'certificate-verification.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2),flush=True)
if __name__=='__main__':main()
