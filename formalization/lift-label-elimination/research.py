"""Exact voltage constraints for two fixed cubic10_3bases. Standard library only."""
from pathlib import Path
import itertools,json,collections,hashlib,random
P=Path(__file__).resolve().parent
BASES={
'star':[{0,1,2},{0,3,4},{1,3,5},{2,4,5},{0,6,7},{1,6,8},{2,6,9},{3,7,8},{4,7,9},{5,8,9}],
'triangle':[{3,4,5},{1,2,5},{0,2,4},{0,1,3},{0,6,7},{1,6,8},{2,6,9},{3,7,8},{4,7,9},{5,8,9}]}
def pasches(base):
 return [s for s in itertools.combinations(range(len(base)),4) if all(sum(c in base[v] for v in s)%2==0 for c in range(10))]
def edges(base):return [(v,c) for v,cs in enumerate(base) for c in sorted(cs)]
def cycle_rows(base,s):
 es=edges(base);ind={e:i for i,e in enumerate(es)}
 def d(u,v):
  common=base[u]&base[v];assert len(common)==1;c=next(iter(common));row=[0]*len(es);row[ind[u,c]]=1;row[ind[v,c]]=-1;return row
 a,b,c,dv=s
 def triangle(u,v,w):return [x+y-z for x,y,z in zip(d(u,v),d(v,w),d(u,w))]
 return [triangle(a,b,c),triangle(a,b,dv),triangle(a,c,dv)]
def tree_chords(base):
 es=edges(base);parent=list(range(20))
 def root(x):
  while parent[x]!=x:x=parent[x]
  return x
 tree=[];chords=[]
 for i,(v,c) in enumerate(es):
  a,b=root(v),root(10+c)
  if a!=b:parent[a]=b;tree.append(i)
  else:chords.append(i)
 assert len(tree)==19 and len(chords)==11
 return tree,chords
def unit_reduce(matrix,ncols):
 """Elementary unimodular operations with exact replay certificate U A V=diag(I,0)."""
 a=[r[:] for r in matrix];m=len(a);ops=[];k=0
 while k<min(m,ncols):
  hit=next(((i,j) for i in range(k,m) for j in range(k,ncols) if abs(a[i][j])==1),None)
  if hit is None:
   assert not any(a[i][j] for i in range(k,m) for j in range(k,ncols)),a
   break
  i,j=hit
  if i!=k:a[i],a[k]=a[k],a[i];ops.append(['rs',i,k])
  if j!=k:
   for row in a:row[j],row[k]=row[k],row[j]
   ops.append(['cs',j,k])
  if a[k][k]==-1:a[k]=[-x for x in a[k]];ops.append(['rn',k])
  for i in range(m):
   if i!=k and a[i][k]:
    q=a[i][k];a[i]=[x-q*y for x,y in zip(a[i],a[k])];ops.append(['ra',i,k,-q])
  for j in range(ncols):
   if j!=k and a[k][j]:
    q=a[k][j]
    for row in a:row[j]-=q*row[k]
    ops.append(['ca',j,k,-q])
  k+=1
 assert all(a[i][j]==int(i==j and i<k) for i in range(m) for j in range(ncols))
 return dict(rank=k,unit_invariant_factors=[1]*k,operations=ops)
def lift(base,z,N,quantum=False):
 es=edges(base);idx={e:i for i,e in enumerate(es)}
 cols=[{c*N+(t+z[idx[v,c]])%N for c in base[v]} for v in range(10) for t in range(N)]
 if quantum:cols += [{c*N+(t-e)%N for e in [0,1,3]} for c in range(10) for t in range(N)]
 assert all(len(c)==3 for c in cols)
 assert all(len(c&d)<=1 for c,d in itertools.combinations(cols,2))
 return cols
def count(cols):
 masks=[sum(1<<c for c in s) for s in cols];assert len(set(masks))==len(masks)
 pairs=collections.Counter(masks[u]^masks[v] for u,v in itertools.combinations(range(len(cols)),2))
 collisions=sum(n*(n-1)//2 for n in pairs.values());assert collisions%3==0;return collisions//3
def balanced(rows,z,N):return all(sum(x*y for x,y in zip(r,z))%N==0 for r in rows)
def main():
 result=[];rng=random.Random(20261024)
 for name,base in BASES.items():
  supports=pasches(base);rows=[cycle_rows(base,s) for s in supports];tree,chords=tree_chords(base)
  certs=[]
  for mask in range(1<<len(rows)):
   matrix=[r for i,rs in enumerate(rows) if mask>>i&1 for r in rs]
   reduced=[[r[j] for j in chords] for r in matrix]
   full=unit_reduce(matrix,30);gauge=unit_reduce(reduced,11);assert full['rank']==gauge['rank']
   k=mask.bit_count();expected=3*k if k<=3 else 11;assert full['rank']==expected
   certs.append(dict(mask=mask,selected=k,matrix=matrix,gauge_matrix=reduced,full_certificate=full,gauge_certificate=gauge))
  histograms=[]
  for N in [1,2,3]:
   hist=collections.Counter()
   for a in itertools.product(range(N),repeat=11):
    z=[0]*30
    for j,x in zip(chords,a):z[j]=x
    j=sum(balanced(rs,z,N) for rs in rows);hist[j]+=1
   if name=='star':expected={0:N**11-N**8,1:N**8}
   else:expected={0:N**11-5*N**8+10*N**5-10*N**2+4,1:5*(N**8-4*N**5+6*N**2-3),2:10*(N**5-3*N**2+2),3:10*(N**2-1),4:0,5:1}
   assert all(hist[k]==v for k,v in expected.items()),(N,hist,expected)
   histograms.append(dict(N=N,gauge_assignments=N**11,balanced_count_histogram=dict(sorted(hist.items()))))
  samples=[]
  for N in [1,2,3,4,7,8,9,12]:
   for i in range(8):
    z=[rng.randrange(N) for _ in range(30)];j=sum(balanced(rs,z,N) for rs in rows);actual=count(lift(base,z,N));assert actual==N*j
    sample=dict(N=N,labels=z,balanced_base_pasches=j,actual_count40=actual)
    if N==7:
     qc=count(lift(base,z,N,True));assert qc==70+7*j;sample['actual_QC_count40']=qc
    samples.append(sample)
  witness=next(s for s in samples if s['N']==7 and s['balanced_base_pasches']==0)
  result.append(dict(name=name,base=[sorted(s) for s in base],base_supports=[list(s) for s in supports],edges=edges(base),tree_edges=tree,chord_edges=chords,cycle_rows=rows,intersection_certificates=certs,exhaustive_gauge_histograms=histograms,seeded_consumers=samples,eliminating_N7_labels=witness['labels']))
 out=dict(evidence='written_general_proof_and_exact_finite_certificates',seed=20261024,scope='All N>=1 formulas justified by integer unimodular certificates, with finite exhaustive N1/2/3 gauge tests and128seeded direct lift consumers. Random consumers are not exhaustive.',bases=result,script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest())
 (P/'results.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(bases=[dict(name=x['name'],pasches=len(x['base_supports']),histograms=x['exhaustive_gauge_histograms']) for x in result])),flush=True)
if __name__=='__main__':main()
