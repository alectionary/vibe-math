"""Bounded exhaustive OSD check against brute-force column-span solutions."""
import pathlib,sys,json,itertools,time,resource
import numpy as np
R=pathlib.Path(__file__).resolve().parent;sys.path.insert(0,str(R.parent/'simulation'));sys.path.insert(0,str(R.parent/'expansion'))
from engine import osd as primary
from native_osd import osd as native
from validate import historical
_,ref=historical(pathlib.Path('/tmp/bn3d-2021'))
resource.setrlimit(resource.RLIMIT_AS,(2*1024**3,2*1024**3));resource.setrlimit(resource.RLIMIT_CPU,(300,310))
start=time.perf_counter();matrices=cases=inconsistent=0;pilot='--pilot' in sys.argv
for m in range(1,3 if pilot else 4):
 for n in range(1,4):
  vectors=np.array(list(itertools.product([0,1],repeat=n)),np.uint8)
  for raw in itertools.product([0,1],repeat=m*n):
   H=np.array(raw,np.uint8).reshape(m,n);matrices+=1;syndromes=(H@vectors.T%2).T;image={tuple(s) for s in syndromes}
   probabilities=[]
   for order in itertools.permutations(range(n)):
    p=np.empty(n);p[list(order)]=np.linspace(.8,.2,n);probabilities.append(p)
   probabilities.append(np.full(n,.5))
   for p in probabilities:
    order=np.argsort(-p);span={0};selected=[]
    for col in order:
     word=sum(int(H[row,col])<<row for row in range(m))
     if word not in span:selected.append(int(col));span|={x^word for x in list(span)}
    unused=[i for i in range(n) if i not in selected]
    for key in image:
     s=np.array(key,np.uint8);candidates=[v for v,sy in zip(vectors,syndromes) if np.array_equal(sy,s) and not np.any(v[unused])];assert len(candidates)==1;expected=candidates[0]
     answers=[primary(H,s,p),native(H,s,p),ref['osd_decoder'](H.astype(int),s.astype(int),p).astype(np.uint8)]
     assert all(np.array_equal(c,expected) for c in answers);cases+=1
   bad=next((s for s in itertools.product([0,1],repeat=m) if s not in image),None)
   if bad is not None:
    inconsistent+=1
    try:native(H,np.array(bad,np.uint8),np.full(n,.5))
    except AssertionError:pass
    else:raise AssertionError('Native solver did not reject inconsistent syndrome')
    # The source/Python solver has no consistency guard: never claim its guarantee for these inputs.
    for solve in [primary,ref['osd_decoder']]:assert np.any(H@solve(H,np.array(bad,np.uint8),np.full(n,.5))%2!=bad)
  print(m,n,matrices,cases,flush=True)
out=dict(matrices=matrices,consistent_order_syndrome_cases=cases,implementations_per_case=3,all_bruteforce_corrections_match=True,inconsistent_matrix_examples=inconsistent,native_rejects_inconsistent=True,source_and_primary_do_not_guard_inconsistent=True,seconds=time.perf_counter()-start,maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,scope='All binary matrices of shapes1..3 by1..3 in full run, every consistent syndrome, every strict column ordering plus tied priors. Brute force spans/enumerated solutions independent of Gaussian elimination; shared inputs and NumPy sort ordering. Historical source executed externally, not vendored. Does not prove BP convergence or decoding optimality.')
(R/('osd-exhaustive-pilot.json' if pilot else 'osd-exhaustive-validation.json')).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
