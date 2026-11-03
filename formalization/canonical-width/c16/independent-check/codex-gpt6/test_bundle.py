#!/usr/bin/env python3
import itertools,json,os,pathlib,random,subprocess,tempfile
if not __debug__:
    raise RuntimeError("Run validation without -O or PYTHONOPTIMIZE.")
HERE=pathlib.Path(__file__).resolve().parent
if hasattr(os,'sched_getaffinity'):os.sched_setaffinity(0,sorted(os.sched_getaffinity(0))[:2])
matrices=[]
for bits in itertools.product('01',repeat=10):
    h=[['0']*4 for _ in range(4)];it=iter(bits)
    for a in range(4):
        for b in range(a,4):h[a][b]=h[b][a]=next(it)
    matrices.append([''.join(row) for row in h])
calls=0
with tempfile.TemporaryDirectory(dir=HERE) as temp:
    file=pathlib.Path(temp)/'matrix.txt'
    for h in matrices:
        bundles=[(a,a) for a in range(4) if h[a][a]=='1']+[(a,b) for a in range(4) for b in range(a) if h[a][a]==h[b][b]=='0' and h[a][b]=='1']
        def valid(es):return all(all(h[u][v]=='0' for u in x for v in y) for x,y in itertools.combinations(es,2))
        def weight(es):return sum(1 if a==b else 2 for a,b in es)
        best=max([0]+[weight(es) for size in range(1,len(bundles)+1) for es in itertools.combinations(bundles,size) if valid(es)])
        file.write_text('4\n'+'\n'.join(h)+'\n')
        for target in sorted({max(1,best),best+1}):
            r=json.loads(subprocess.check_output([str(HERE/'bundle_clique'),str(file),str(target),'10'],text=True))
            assert r['status']=='COMPLETE' and r['found']==(best>=target),(h,target,best,r)
            if r['found']:
                es=[tuple(e) for e in r['bundles']]
                assert len(set(es))==len(es) and all(e in bundles for e in es) and valid(es) and weight(es)>=target
            calls+=1
result={'status':'PASS','matrices':len(matrices),'solver_comparisons':calls,'oracle':'explicit subset enumeration','fixtures':'all symmetric 4x4 binary matrices generated locally'}
(HERE/'bundle-unit-tests.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))
