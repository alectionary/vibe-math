#!/usr/bin/env python3
"""Exact source full-frame model with no edge variables.

Every selected vertex has exactly one selected neighbor. With at least128 X
owners, the resulting matching has size128 by ambient rank. A conditional
matching propagator supplies all missing at-most-one constraints on demand.
"""
from pathlib import Path
import argparse,gzip,hashlib,json,subprocess,sys,time,collections
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

def binary_count(inputs,cnf,top):
    """Balanced exact addition. Each gate is a complete Boolean equivalence."""
    n=top;gates=[]
    def gate(kind,args):
        nonlocal n
        n+=1;out=n;gates.append([kind,args,out])
        from itertools import product
        for values in product((False,True),repeat=len(args)):
            result=(sum(values)%2==1) if kind=='xor' else sum(values)>=2 if kind=='majority' else all(values)
            # Forbid exactly the input assignment with an incorrect output.
            cnf.append([(-v if b else v) for v,b in zip(args,values)]+[out if result else -out])
        return out
    numbers=[[v] for v in inputs]
    while len(numbers)>1:
        new=[]
        for k in range(0,len(numbers),2):
            if k+1==len(numbers):new.append(numbers[k]);continue
            a,b=numbers[k:k+2];bits=[];carry=None
            for j in range(max(len(a),len(b))):
                args=([a[j]] if j<len(a) else [])+([b[j]] if j<len(b) else [])+([carry] if carry else [])
                if len(args)==1:bits.append(args[0]);carry=None
                else:bits.append(gate('xor',args));carry=gate('and' if len(args)==2 else 'majority',args)
            if carry:bits.append(carry)
            new.append(bits)
        numbers=new
    return numbers[0],n,gates

def build(X,Z,A,dimension=128,anchor=None,seeds=(),phase_profiles=None):
    nx,nz=len(X),len(Z);owner=lambda s,i:i+1+(nx if s else 0)
    columns=[sum(((A[i]>>j)&1)<<i for i in range(nx)) for j in range(nz)]
    rows=[]
    # Conditional degree >=1, for both sectors.
    for side,pairings in enumerate([A,columns]):
        for i,mask in enumerate(pairings):rows.append([-owner(side,i)]+[owner(1-side,j) for j in range((nz,nx)[side]) if mask>>j&1])
    if anchor:
        ax,az=anchor;assert A[ax]>>az&1;rows.extend([[owner(0,ax)],[owner(1,az)]])
        for i in range(nx):
            if i!=ax and A[i]>>az&1:rows.append([-owner(0,i)])
        for j in range(nz):
            if j!=az and A[ax]>>j&1:rows.append([-owner(1,j)])
    inputs=list(range(1,nx+1));bits,n,gates=binary_count(inputs,rows,nx+nz)
    # All accepted models have at most dimension matches by Gram rank.
    # For power-of-two dimension, this one count bit implies >=dimension.
    assert dimension and dimension&(dimension-1)==0
    rows.append([bits[dimension.bit_length()-1]])
    # Both selected pools are full bases, hence detect every nonzero source vector.
    for mask in A:rows.append([owner(1,j) for j in range(nz) if mask>>j&1])
    for mask in columns:rows.append([owner(0,i) for i in range(nx) if mask>>i&1])
    extra=set()
    for path in seeds:
        for cut in json.loads(path.read_text())['cuts']:
            for h in range(16):
                if cut['kind']=='joint_forced_propagation':
                    p=[[16*(i//16)+(i%16+h)%16 for i in cut[key]] for key in ['required_X','required_Z']];patterns=[p,p[::-1]]
                else:
                    ids=[16*(i//16)+(i%16+h)%16 for i in cut['indices']];patterns=[[ids,[]],[[],ids]]
                for p in patterns:extra.add(tuple(sorted(-owner(s,i) for s,ids in enumerate(p) for i in ids)))
    if phase_profiles:
        data=json.loads(gzip.decompress(phase_profiles.read_bytes()));assert data.get('conditioned_on_anchor') is None and data.get('conditioned_on_X_index') is None
        for r in data['records']:
            assert r['complete']
            for c in r['minimal_bad_certificates']:
                ids=[16*r['orbit']+h for h in range(16) if c['mask']>>h&1]
                for side in [0,1]:extra.add(tuple(-owner(side,i) for i in ids))
    rows += [list(c) for c in sorted(extra)]
    return rows,n,{'adder_gates':len(gates),'sum_bits':bits,'seed_and_phase_clauses':len(extra),'count_assertion':'bit log2(dimension) set; matching rank bounds the full sum above by dimension'}

def export(a):
    X,Z,A=physical();rows,n,details=build(X,Z,A,anchor=a.anchor,seeds=a.seed_cuts,phase_profiles=a.phase_profiles)
    raw=(f'p cnf {n} {len(rows)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in rows)).encode();a.output.with_suffix('.cnf.gz').write_bytes(gzip.compress(raw,mtime=0))
    d={'status':'FROZEN_EXACT_DIRECT_OWNER_MODEL_REQUIRES_REPLAY','source_C16_answered':False,'full_source_model':True,'projection_model':False,'dimension':128,'anchor':a.anchor,'variables':n,'clauses':len(rows),'edge_variables':0,'owner_variables':1440,'input_file':a.output.with_suffix('.cnf.gz').name,'input_sha256':hashlib.sha256(raw).hexdigest(),'native_matching_required':True,'details':details,'seed_dependencies':[{'c16_path':str(p.resolve().relative_to(ROOT)),'sha256':sha(p)} for p in a.seed_cuts],'phase_profiles_c16_path':str(a.phase_profiles.resolve().relative_to(ROOT)) if a.phase_profiles else None,'phase_profiles_sha256':sha(a.phase_profiles) if a.phase_profiles else None}
    a.output.write_text(json.dumps(d,indent=2)+'\n');print('OWNER MODEL',n,len(rows),details,flush=True)

def solve(a):
    from pysat.formula import CNF
    from pysat.solvers import Solver
    from owner_frame_oracle import OwnerFrameOracle
    X,Z,A=physical();meta=json.loads(a.instance.read_text());raw=gzip.decompress((a.instance.parent/meta['input_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==meta['input_sha256'];cnf=CNF(from_string=raw.decode());start=time.monotonic()
    d={'status':'RUNNING','answer':None,'source_C16_answered':False,'full_source_model':True,'anchor':meta['anchor'],'instance_c16_path':str(a.instance.resolve().relative_to(ROOT)),'input_sha256':meta['input_sha256'],'native_library_sha256':sha(a.native_library),'span_enabled':a.variant=='span','outer_wall_seconds':a.seconds,'span_clause_limit':a.clause_limit}
    def progress(stats):
        d.update(oracle_statistics=stats,elapsed_solve_seconds=time.monotonic()-start);tmp=a.output.with_suffix('.checkpoint.tmp');tmp.write_text(json.dumps(d,indent=2)+'\n');tmp.replace(a.output)
    oracle=OwnerFrameOracle(X,Z,a.native_library,a.output.with_suffix('.lemmas.jsonl'),progress=progress,limit=a.clause_limit,span_enabled=a.variant=='span');progress(oracle.stats.copy())
    with Solver(name='cadical195',bootstrap_with=cnf.clauses) as solver:
        solver.connect_propagator(oracle)
        for v in range(1,1441):solver.observe(v)
        answer=solver.solve();d.update(answer=answer,status='SAT_REQUIRES_PHYSICAL_REPLAY' if answer else 'UNSAT_REQUIRES_FRESH_PROOF_AND_THEORY_REPLAY',solver_statistics=solver.accum_stats());progress(oracle.stats.copy())
        if answer:
            model=solver.get_model();truth=set(model);assert all(any(v in truth for v in c) for c in cnf.clauses);xi=[i for i in range(720) if i+1 in truth];zj=[j for j in range(720) if j+721 in truth];assert len(xi)==len(zj)==128;pairs=[]
            for i in xi:
                partners=[j for j in zj if A[i]>>j&1];assert len(partners)==1;pairs.append([i,partners[0]])
            assert len({j for i,j in pairs})==128
            for k,(i,j) in enumerate(pairs):
                for l,(ii,jj) in enumerate(pairs):assert bool(A[i]>>jj&1)==(k==l)
            d.update(pool_pairs=pairs,model=model)
    oracle.close();a.output.write_text(json.dumps(d,indent=2)+'\n');print('OWNER END',d['status'],flush=True)

def main():
    p=argparse.ArgumentParser();p.add_argument('--mode',choices=['export','solve'],required=True);p.add_argument('--anchor',type=int,nargs=2);p.add_argument('--seed-cuts',type=Path,nargs='*',default=[]);p.add_argument('--phase-profiles',type=Path);p.add_argument('--instance',type=Path);p.add_argument('--native-library',type=Path);p.add_argument('--variant',choices=['matching','span'],default='span');p.add_argument('--clause-limit',type=int,default=100000);p.add_argument('--seconds',type=float,default=900);p.add_argument('--output',type=Path,required=True);p.add_argument('--child',action='store_true');a=p.parse_args()
    if a.mode=='export':export(a);return
    if a.child:solve(a);return
    start=time.monotonic();child=subprocess.Popen([sys.executable,str(Path(__file__).resolve()),*sys.argv[1:],'--child']);expired=False
    try:child.wait(timeout=a.seconds)
    except subprocess.TimeoutExpired:expired=True;child.terminate();child.wait(timeout=10)
    d=json.loads(a.output.read_text()) if a.output.exists() else {'status':'ERROR_BEFORE_CHECKPOINT'}
    if expired:d.update(status='UNKNOWN_OUTER_WALL_LIMIT',answer=None)
    d.update(child_returncode=child.returncode,outer_wall_expired=expired,total_wall_seconds=time.monotonic()-start)
    lp=a.output.with_suffix('.lemmas.jsonl')
    if lp.exists():d.update(lemma_file=lp.name,lemma_file_sha256=sha(lp))
    a.output.write_text(json.dumps(d,indent=2)+'\n');print('OWNER PARENT',d['status'],flush=True)
if __name__=='__main__':main()
