"""Independent FCC edge/tetrahedron reconstruction of source rhombic checks."""
import pathlib,sys,json,itertools,time,resource,collections
import numpy as np
R=pathlib.Path(__file__).resolve().parent;sys.path.insert(0,str(R.parent/'expansion'))
from geometry import rhombic
resource.setrlimit(resource.RLIMIT_AS,(2*1024**3,2*1024**3));resource.setrlimit(resource.RLIMIT_CPU,(300,310))
rows=[];start=time.perf_counter();sizes=[4] if '--pilot' in sys.argv else [2,4,6,8,10]
for L in sizes:
 t=time.perf_counter();sites=list(itertools.product(range(L),repeat=3));black=[v for v in sites if sum(v)%2];index={v:i for i,v in enumerate(black)};N=L**3;E=3*N
 def q(a,v):return a*N+np.ravel_multi_index(tuple(t%L for t in v),(L,)*3)
 def ends(a,v,wrap=True):
  other=[b for b in range(3) if b!=a];out=[]
  for shifts in itertools.product([0,1],repeat=2):
   w=list(v)
   for b,s in zip(other,shifts):w[b]-=s
   if sum(w)%2:out.append(tuple(t%L for t in w) if wrap else tuple(w))
  assert len(out)==2;return out
 endpoints={q(a,v):ends(a,v) for a in range(3) for v in sites};V=np.zeros((len(black),E),np.uint8)
 for key,vs in endpoints.items():
  for v in vs:V[index[v],key]^=1
 faces=[]
 for v in sites:
  local=[]
  for a in range(3):
   for back in [0,1]:
    w=list(v);w[a]-=back;local.append(q(a,w))
  corners=set(x for edge in local for x in endpoints[edge]);assert len(corners)==4
  for tri in itertools.combinations(sorted(corners),3):
   edges=[e for e in local if set(endpoints[e])<=set(tri)];assert len(edges)==3
   row=np.zeros(E,np.uint8);row[edges]=1;faces.append(row)
 F=np.array(faces);sourceV,sourceF,_,_=rhombic(L);assert np.array_equal(V,sourceV)
 assert collections.Counter(row.tobytes() for row in F)==collections.Counter(row.tobytes() for row in sourceF)
 cycles=0
 for normal in range(3):
  used=set()
  for a in [b for b in range(3) if b!=normal]:
   transverse=[b for b in range(3) if b!=normal]
   for uv in itertools.product(range(L),repeat=2):
    displacement=np.zeros(3,int)
    for t0 in range(L):
     v=[0,0,0];v[normal]=t0
     for b,s in zip(transverse,uv):v[b]=s
     key=q(a,v);assert key not in used;used.add(key);b,c=ends(a,v,False)
     if b[normal]>c[normal]:b,c=c,b
     displacement+=np.array(c)-np.array(b)
    expected=np.zeros(3,int);expected[normal]=L;assert np.array_equal(displacement,expected);cycles+=1
  assert len(used)==2*N
 rows.append(dict(L=L,FCC_vertices=len(black),edges=E,tetrahedral_triangles=len(F),cube_incidence_exact=True,triangle_multiset_exact=True,disjoint_winding_cycles=cycles,seconds=time.perf_counter()-t))
out=dict(rows=rows,seconds=time.perf_counter()-start,maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,errors=[],scope='Independent black-cube endpoint/FCC tetrahedron implementation versus source-geometry matrices. Winding and support counts checked at listed even sizes; general cellulation/topological proof is written separately. Shared coordinate/periodic convention; not an independent numerical decoder.')
name='rhombic-cellulation-pilot.json' if '--pilot' in sys.argv else 'rhombic-cellulation-validation.json';(R/name).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
