#!/usr/bin/env python3
"""CNF backend for the same exact selection conditions, using PySAT/Glucose4."""
import argparse,collections,json,os,pathlib,threading,time
from pysat.card import CardEnc,EncType
from pysat.formula import IDPool
from pysat.solvers import Solver
from solve import read,check,tau

def run(pools,kind,seconds,output):
    started=time.monotonic();deadline=started+seconds
    x,z=read(pools);n=len(x)
    g=[[(v&w).bit_count()&1 for w in z] for v in x]
    if pools=='real':assert sum(map(sum,g))==99808
    ids=IDPool();cnf=[]
    if kind in ('A','quarter'):
        k=8 if kind=='A' else 4
        s=[ids.id(('x',i//16,i%k)) for i in range(n)]
        t=[ids.id(('z',i//16,i%k)) for i in range(n)]
        target=128//(16//k)
    elif kind in ('B','C'):
        s=[ids.id(('s',i)) for i in range(n)]
        t=[s[i if kind=='B' else tau(i)] for i in range(n)]
        target=128
    else:raise ValueError(kind)
    primary=set(s+t)
    def cardinality(lits,bound,equal=False,guard=None):
        f=(CardEnc.equals if equal else CardEnc.atmost)(lits=lits,bound=bound,vpool=ids,encoding=EncType.seqcounter)
        cnf.extend(([-guard]+c if guard is not None else c) for c in f.clauses)
    sets=set()
    for variables in (s,t):
        unique=tuple(sorted(set(variables)))
        if unique not in sets:cardinality(list(unique),target,True);sets.add(unique)
    seen=set();implications=0
    for variables,opposite,transpose in [(s,t,False),(t,s,True)]:
        for i,sel in enumerate(variables):
            neighbors=collections.Counter(opposite[j] for j in range(n) if (g[j][i] if transpose else g[i][j]))
            once=tuple(sorted(v for v,multiplicity in neighbors.items() if multiplicity==1))
            repeated=tuple(sorted(v for v,multiplicity in neighbors.items() if multiplicity>1))
            key=(sel,once,repeated)
            if key in seen:continue
            seen.add(key);implications+=1
            cnf.extend([[-sel,-v] for v in repeated])
            cnf.append([-sel]+list(once))
            if len(once)>1:cardinality(list(once),1,guard=sel)
    hint=None
    for direction in (1,-1):
        chosen=[]
        for i in sorted(range(n),key=lambda i:(direction*(x[i].bit_count()+z[i].bit_count()),i)):
            if g[i][i] and all(not g[i][j] and not g[j][i] for j in chosen):chosen.append(i)
        selected=set(chosen)
        closed=kind=='B' or {tau(i,4 if kind=='quarter' else 8) for i in selected}==selected
        if len(chosen)==128 and closed:
            assignment={}
            for variables in (s,t):
                for i,v in enumerate(variables):
                    value=i in selected
                    assert v not in assignment or assignment[v]==value
                    assignment[v]=value
            hint=[v if assignment[v] else -v for v in sorted(primary)]
            break
    build=time.monotonic()-started;frame=None;stats={};answer=None;hint_answer=None
    with Solver(name='g4',bootstrap_with=cnf,use_timer=True) as solver:
        timer=threading.Timer(max(.001,deadline-time.monotonic()),solver.interrupt);timer.start()
        try:
            if hint is not None:
                hint_answer=solver.solve_limited(assumptions=hint,expect_interrupt=True)
                if hint_answer:answer=True
            if answer is None and time.monotonic()<deadline:
                answer=solver.solve_limited(expect_interrupt=True)
            if answer:
                model=set(v for v in solver.get_model() if v>0)
                si=[i for i,v in enumerate(s) if v in model];tj=[j for j,v in enumerate(t) if v in model]
                frame=[(i,j) for i in si for j in tj if g[i][j]]
            stats=solver.accum_stats()
        finally:timer.cancel();timer.join()
    if frame is not None:check(x,z,frame,kind,128)
    result={'pools':pools,'class':kind,'status':'INCOMPLETE' if answer is None else 'COMPLETE','frames_found':int(frame is not None),'frame':frame,'seconds':time.monotonic()-started,'notes':'CNF existence decision, not total count; UNKNOWN remains INCOMPLETE.','details':{'solver':'PySAT Glucose4','variables':ids.top,'clauses':len(cnf),'distinct_guarded_degree_constraints':implications,'build_seconds':build,'hint_answer':hint_answer,'solver_stats':stats}}
    output=pathlib.Path(output);output.parent.mkdir(parents=True,exist_ok=True);output.write_text(json.dumps(result,indent=2)+'\n')
    output.with_suffix('.log').write_text(json.dumps(result['details'],indent=2)+'\n')
    print(json.dumps(result),flush=True)
    return result

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--pools',choices=['real','planted1'],required=True);p.add_argument('--class',dest='kind',choices=['A','B','C','quarter'],required=True);p.add_argument('--seconds',type=float,default=7200);p.add_argument('--output',required=True);a=p.parse_args()
    if hasattr(os,'sched_getaffinity'):os.sched_setaffinity(0,sorted(os.sched_getaffinity(0))[:2])
    run(a.pools,a.kind,a.seconds,a.output)
