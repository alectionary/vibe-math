#!/usr/bin/env python3
"""Independent finite induced-matching search; no repository code dependencies."""
import argparse, collections, functools, hashlib, json, os, pathlib, sys, time
# Bound both solver workers and numerical library threads.
for name in ('OMP_NUM_THREADS','OPENBLAS_NUM_THREADS','MKL_NUM_THREADS'):
    os.environ[name]='1'
if not __debug__:
    raise RuntimeError("Optimized Python disables validation; run without -O or PYTHONOPTIMIZE.")
from ortools.sat.python import cp_model
BASE=pathlib.Path(__file__).resolve().parents[2]

def tau(i,k=8): return i//16*16+(i%16+k)%16

def read(pools):
    prefix=BASE/'pools' if pools=='real' else BASE/'independent-check'/'inputs'
    stem='' if pools=='real' else 'planted1-'
    arrays=[]
    for side in ('x','z'):
        vals=[int(s,16) for s in (prefix/(stem+side+'coords.txt')).read_text().splitlines()]
        assert all(0<=v<1<<128 for v in vals)
        arrays.append(vals)
    assert len(arrays[0])==len(arrays[1]) and len(arrays[0])%16==0
    return arrays

def check(x,z,frame,kind,size):
    assert len(frame)==size
    s=[i for i,j in frame];t=[j for i,j in frame]
    assert len(set(s))==len(set(t))==size
    assert all(0<=i<len(x) for i in s) and all(0<=j<len(z) for j in t)
    for a,(i,j) in enumerate(frame):
        for b,(k,l) in enumerate(frame):
            assert ((x[i]&z[l]).bit_count()&1)==int(a==b)
    if kind in ('A','quarter'):
        k=8 if kind=='A' else 4
        assert {tau(i,k) for i in s}==set(s) and {tau(j,k) for j in t}==set(t)
    if kind=='B': assert set(s)==set(t)
    if kind=='C': assert {tau(i) for i in s}==set(t)
    if kind.startswith('blocks'):
        mask=((1<<32)-1)<<(0 if kind=='blocks01' else 32)
        assert all(not x[i]&~mask for i in s) and all(not z[j]&~mask for j in t)
    print(f'CHECK PASS: |S| = |T| = {size}; distinct indices; permutation matrix; class {kind}',file=sys.stderr,flush=True)

def block_count(x,z,kind,deadline):
    mask=((1<<32)-1)<<(0 if kind=='blocks01' else 32)
    xs=[i for i,v in enumerate(x) if not v&~mask];zs=[j for j,v in enumerate(z) if not v&~mask]
    edges=[(i,j) for i in xs for j in zs if (x[i]&z[j]).bit_count()&1]
    adj=collections.defaultdict(set)
    for i,j in edges: adj[('x',i)].add(('z',j));adj[('z',j)].add(('x',i))
    unseen=set(adj);components=[]
    while unseen:
        todo=[min(unseen)];component=set()
        while todo:
            v=todo.pop()
            if v in component: continue
            component.add(v);unseen.discard(v);todo.extend(adj[v]-component)
        components.append([(i,j) for i,j in edges if ('x',i) in component])
    total=[1]; witness={0:[]}; stats=[]
    for es in components:
        conflicts=[]
        for i,j in es:
            conflicts.append(sum(1<<b for b,(k,l) in enumerate(es) if i==k or j==l or (x[i]&z[l]).bit_count()%2 or (x[k]&z[j]).bit_count()%2))
        @functools.lru_cache(None)
        def rec(bits):
            if time.monotonic()>deadline: raise TimeoutError
            if not bits: return (1,)
            bit=bits&-bits;a=bit.bit_length()-1
            no=rec(bits^bit);yes=rec(bits&~conflicts[a]);out=list(no)+[0]*max(0,len(yes)+1-len(no))
            for k,n in enumerate(yes):out[k+1]+=n
            return tuple(out)
        poly=rec((1<<len(es))-1)
        def get(bits,k):
            if k==0:return []
            bit=bits&-bits;a=bit.bit_length()-1;rest=bits&~conflicts[a];p=rec(rest)
            if k-1<len(p) and p[k-1]: return [es[a]]+get(rest,k-1)
            return get(bits^bit,k)
        local={k:get((1<<len(es))-1,k) for k,n in enumerate(poly) if n}
        new=[0]*(len(total)+len(poly)-1);nw={}
        for a,n in enumerate(total):
            for b,m in enumerate(poly):
                new[a+b]+=n*m
                if n and m:nw.setdefault(a+b,witness[a]+local[b])
        total,witness=new,nw
        stats.append({'edges':len(es),'counts':poly})
    n=total[32] if len(total)>32 else 0
    return n,witness.get(32),{'components':stats,'count_polynomial':total,'eligible_x':len(xs),'eligible_z':len(zs)}

def gf2_rank(vectors):
    pivots={}
    for v in vectors:
        while v:
            bit=v.bit_length()-1
            if bit not in pivots:
                pivots[bit]=v
                break
            v^=pivots[bit]
    return len(pivots)

def rank_cuts(model,variables,vectors):
    # Selected vectors in a permutation pairing are linearly independent.
    supports=[sum(1<<b for b in range(8) if (v>>(16*b))&65535) for v in vectors]
    seen=set();count=0
    for blocks in range(256):
        eligible=tuple(i for i,support in enumerate(supports) if support&~blocks==0)
        if eligible in seen:continue
        seen.add(eligible)
        rank=gf2_rank(vectors[i] for i in eligible)
        if len(eligible)>rank:
            model.add(sum(variables[i] for i in eligible)<=rank)
            count+=1
    return count

def search(x,z,kind,deadline,log):
    n=len(x);g=[[(v&w).bit_count()&1 for w in z] for v in x]
    m=cp_model.CpModel();s=[m.new_bool_var(f'x{i}') for i in range(n)];t=[m.new_bool_var(f'z{i}') for i in range(n)]
    m.add(sum(s)==128);m.add(sum(t)==128)
    cuts=rank_cuts(m,s,x)+rank_cuts(m,t,z)
    for i in range(n):m.add(sum(t[j] for j in range(n) if g[i][j])==1).only_enforce_if(s[i])
    for j in range(n):m.add(sum(s[i] for i in range(n) if g[i][j])==1).only_enforce_if(t[j])
    if kind in ('A','quarter'):
        k=8 if kind=='A' else 4
        for i in range(n):m.add(s[i]==s[tau(i,k)]);m.add(t[i]==t[tau(i,k)])
    elif kind in ('B','C'):
        for i in range(n):m.add(s[i]==t[i if kind=='B' else tau(i)])
    else: raise ValueError(kind)
    # Generic feasible-start heuristic. Neither expected answers nor index ranges
    # appear here. Hints do not constrain the exhaustive fallback model.
    hinted=False
    for direction in (1,-1):
        chosen=[]
        for i in sorted(range(n),key=lambda i:(direction*(x[i].bit_count()+z[i].bit_count()),i)):
            if g[i][i] and all(not g[i][j] and not g[j][i] for j in chosen):chosen.append(i)
        selected=set(chosen)
        closed=(kind=='B' or {tau(i,4 if kind=='quarter' else 8) for i in selected}==selected)
        if len(chosen)==128 and closed:
            for i in range(n):m.add_hint(s[i],int(i in selected));m.add_hint(t[i],int(i in selected))
            hinted=True
            break
    solver=cp_model.CpSolver();solver.parameters.num_search_workers=2
    solver.parameters.max_time_in_seconds=max(.001,deadline-time.monotonic())
    solver.parameters.random_seed=0;solver.parameters.log_search_progress=True;solver.parameters.log_to_stdout=False
    with open(log,'w') as f:
        def logging(line):f.write(line+'\n');f.flush()
        solver.log_callback=logging
        status=solver.solve(m)
        f.write(solver.response_stats()+'\n')
    frame=None
    if status in (cp_model.FEASIBLE,cp_model.OPTIMAL):
        si=[i for i in range(n) if solver.value(s[i])];tj=[j for j in range(n) if solver.value(t[j])]
        frame=[(i,j) for i in si for j in tj if g[i][j]]
    complete=status in (cp_model.FEASIBLE,cp_model.OPTIMAL,cp_model.INFEASIBLE)
    if status==cp_model.MODEL_INVALID:raise RuntimeError(solver.response_stats())
    return complete,frame,{'rank_cuts':cuts,'complete_greedy_hint':hinted,'solver_status':solver.status_name(status),'response_stats':solver.response_stats(),'pairing_ones':sum(map(sum,g))}

def run(pools,kind,seconds,output):
    started=time.monotonic();x,z=read(pools);deadline=started+seconds
    if pools=='real': assert sum((v&w).bit_count()&1 for v in x for w in z)==99808
    output=pathlib.Path(output);output.parent.mkdir(parents=True,exist_ok=True)
    if kind.startswith('blocks'):
        try:n,frame,details=block_count(x,z,kind,deadline);complete=True
        except TimeoutError:n,frame,details,complete=0,None,{'reason':'counting deadline'},False
    else:
        complete,frame,details=search(x,z,kind,deadline,output.with_suffix('.log'));n=int(frame is not None)
    if frame is not None:check(x,z,frame,kind,32 if kind.startswith('blocks') else 128)
    result={'pools':pools,'class':kind,'status':'COMPLETE' if complete else 'INCOMPLETE','frames_found':n,'frame':frame,'seconds':time.monotonic()-started,'notes':'Exact count' if kind.startswith('blocks') and complete else 'Existence decision; frames_found is witnesses returned, not a total count.','details':details}
    output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)
    return result

if __name__=='__main__':
    a=argparse.ArgumentParser();a.add_argument('--pools',choices=['real','planted1'],required=True);a.add_argument('--class',dest='kind',choices=['A','B','C','quarter','blocks01','blocks23'],required=True);a.add_argument('--seconds',type=float,default=7200);a.add_argument('--output',required=True)
    p=a.parse_args();run(p.pools,p.kind,p.seconds,p.output)
