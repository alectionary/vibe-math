"""Exact finite P34 experiments. Python checks are not Lean certificates."""
from collections import Counter, deque
from itertools import combinations, product
from pathlib import Path
import hashlib,json

def base_data(B,r):
 m,n=len(B),len(B[0]);checks=list(product(range(m),range(n)))
 variables=[('l',k,j) for k in range(n) for j in range(n)]+[('r',i,l) for i in range(m) for l in range(m)]
 def support(v,c):return v[2]==c[1] if v[0]=='l' else v[1]==c[0]
 def label(v,c):return (B[c[0]][v[1]] if v[0]=='l' else -B[v[2]][c[1]])%r
 return checks,variables,support,label

def voltage_graph(B,r):
 C,V,E,s=base_data(B,r);adj={('c',*c,a):set() for c in C for a in range(r)}
 adj.update({(*v,a):set() for v in V for a in range(r)})
 for c in C:
  for v in V:
   if E(v,c):
    for a in range(r):
     x=(*v,a);y=('c',*c,(a+s(v,c))%r);adj[x].add(y);adj[y].add(x)
 return adj

def matrix_graph(B,r):
 # Independent entry expansion of [B tensor I_n | I_m tensor B*].
 m,n=len(B),len(B[0]);adj={('c',i,j,a):set() for i in range(m) for j in range(n) for a in range(r)}
 adj.update({('l',k,j,b):set() for k in range(n) for j in range(n) for b in range(r)})
 adj.update({('r',i,l,b):set() for i in range(m) for l in range(m) for b in range(r)})
 for i,j,a in product(range(m),range(n),range(r)):
  for k,b in product(range(n),range(r)):
   if a==(b+B[i][k])%r:
    x=('c',i,j,a);y=('l',k,j,b);adj[x].add(y);adj[y].add(x)
  for l,b in product(range(m),range(r)):
   if a==(b-B[l][j])%r:
    x=('c',i,j,a);y=('r',i,l,b);adj[x].add(y);adj[y].add(x)
 return adj

def girth(adj):
 best=len(adj)+1
 for root in adj:
  dist={root:0};parent={root:None};q=deque([root])
  while q:
   u=q.popleft()
   for v in adj[u]:
    if v not in dist:dist[v]=dist[u]+1;parent[v]=u;q.append(v)
    elif parent[u]!=v:best=min(best,dist[u]+dist[v]+1)
 return best if best<=len(adj) else None

def direct_counts(adj):
 C=[c for c in adj if c[0]=='c']
 four=sum(len(adj[a]&adj[b])*(len(adj[a]&adj[b])-1)//2 for a,b in combinations(C,2))
 six=0
 for a,b,c in combinations(C,3):
  x=adj[a]&adj[b];y=adj[b]&adj[c];z=adj[c]&adj[a];t=len(x&y&z)
  six+=len(x)*len(y)*len(z)-t*(len(x)+len(y)+len(z))+2*t
 return four,six

def voltage_six_count(B,r):
 C,V,E,s=base_data(B,r);cv={c:[v for v in V if E(v,c)] for c in C};vc={v:[c for c in C if E(v,c)] for v in V};rooted=0
 for c0 in C:
  for v0 in cv[c0]:
   a0=(-s(v0,c0))%r
   for c1 in vc[v0]:
    b1=(a0+s(v0,c1))%r
    for v1 in cv[c1]:
     a1=(b1-s(v1,c1))%r
     for c2 in vc[v1]:
      b2=(a1+s(v1,c2))%r
      for v2 in cv[c2]:
       if not E(v2,c0):continue
       a2=(b2-s(v2,c2))%r
       if (a2+s(v2,c0))%r:continue
       nodes=[('c',*c0,0),(*v0,a0),('c',*c1,b1),(*v1,a1),('c',*c2,b2),(*v2,a2)]
       if len(set(nodes))==6:rooted+=1
 assert rooted*r%6==0
 return rooted*r//6

def scan():
 cases=[]
 for r in range(1,13):
  for a in range(r):cases.append(('2x2',r,[[0,0],[0,a]]))
 for r in range(2,5):
  for a,b,c,d in product(range(r),repeat=4):cases.append(('3x3',r,[[0,0,0],[0,a,b],[0,c,d]]))
 cases.append(('3x3-witness',7,[[0,0,0],[0,1,2],[0,3,6]]))
 records=[]
 for family,r,B in cases:
  adj=voltage_graph(B,r);assert adj==matrix_graph(B,r)
  four,six=direct_counts(adj);vsix=voltage_six_count(B,r);assert six==vsix
  m,n=len(B),len(B[0]);bad=sum((B[i][j]-B[i][k]+B[l][k]-B[l][j])%r==0 for i,l in combinations(range(m),2) for j,k in combinations(range(n),2))
  assert (four>0)==(bad>0)
  g=girth(adj)
  if family=='2x2':assert g==(4 if B[1][1]==0 else 8)
  records.append({'family':family,'lift_size':r,'B':B,'vertices':len(adj),'edges':sum(map(len,adj.values()))//2,'four_cycles':four,'six_cycles':six,'girth':g,'zero_base_rectangles':bad})
 return {'scope':'All normalized 2x2 bases for r=1..12; all normalized 3x3 bases for r=2..4, plus one explicit 3x3 candidate at r=7. Positive finite evidence only, not a proof in arbitrary dimensions.','case_count':len(records),'matrix_graph_comparisons':'all equal','six_cycle_methods':'direct check-triple count equals projected voltage-walk enumeration with distinct lifted vertices','girth_histogram':dict(Counter(str(c['girth']) for c in records)),'cases':records}

if __name__=='__main__':
 out=Path(__file__).with_name('results.json');result=scan();out.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k!='cases'},indent=2))
