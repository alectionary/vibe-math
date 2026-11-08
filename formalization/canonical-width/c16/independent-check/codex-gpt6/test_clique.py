#!/usr/bin/env python3
"""Compare coloring search against subset enumeration on generated small graphs."""
import itertools,json,os,pathlib,random,subprocess,tempfile
if not __debug__:
    raise RuntimeError("Run validation without -O or PYTHONOPTIMIZE.")
HERE=pathlib.Path(__file__).resolve().parent
if hasattr(os,'sched_getaffinity'):os.sched_setaffinity(0,sorted(os.sched_getaffinity(0))[:2])
rng=random.Random(0)
matrices=[[''.join(entries[:2]),''.join(entries[2:])] for entries in itertools.product('012',repeat=4)]
matrices += [[''.join(rng.choice('012') for _ in range(4)) for _ in range(4)] for _ in range(100)]
calls=0
with tempfile.TemporaryDirectory(dir=HERE) as temp:
    file=pathlib.Path(temp)/'matrix.txt'
    for h in matrices:
        edges=[(a,b) for a,row in enumerate(h) for b,c in enumerate(row) if c=='1']
        def valid(es):return all(h[a][d]=='0' and h[c][b]=='0' for (a,b),(c,d) in itertools.combinations(es,2))
        best=0
        for size in range(len(edges),0,-1):
            if any(valid(es) for es in itertools.combinations(edges,size)):
                best=size;break
        file.write_text(str(len(h))+'\n'+'\n'.join(h)+'\n')
        for target in sorted({max(1,best),best+1}):
            r=json.loads(subprocess.check_output([str(HERE/'orbit_clique'),str(file),str(target),'10'],text=True))
            assert r['status']=='COMPLETE' and r['found']==(best>=target),(h,target,best,r)
            if r['found']:
                es=[tuple(e) for e in r['orbit_pairs']]
                assert len(es)==target and len(set(es))==target and all(e in edges for e in es) and valid(es)
            calls+=1
result={'status':'PASS','matrices':len(matrices),'solver_comparisons':calls,'oracle':'explicit subset enumeration','fixtures':'newly generated 2x2 exhaustive ternary matrices and deterministic random 4x4 matrices; no external inputs'}
(HERE/'clique-unit-tests.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))
