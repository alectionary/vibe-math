#!/usr/bin/env python3
"""Exact k-pair model plus hereditary necessary constraints of full source frames.

SAT is a physical partial frame. UNSAT for k<=128 rules out every full frame,
after replay of source cut validity, the projection bridge and a fresh proof.
No full-basis positive clause or signature-normalization clause is imported.
"""
from pathlib import Path
import argparse,gzip,hashlib,json,subprocess,sys,time
from owner_frame_model import binary_count,build as full_build
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def build(X,Z,A,k,source_extras=()):
    nx,nz=len(X),len(Z);owner=lambda s,i:1+i+(nx if s else 0);col=[sum(((A[i]>>j)&1)<<i for i in range(nx)) for j in range(nz)];rows=[];n=nx+nz
    for side,masks in enumerate([A,col]):
        for i,m in enumerate(masks):rows.append([-owner(side,i)]+[owner(1-side,j) for j in range((nz,nx)[side]) if m>>j&1])
    gates=0
    for side,size in [(0,nx),(1,nz)]:
        bits,n,gg=binary_count([owner(side,i) for i in range(size)],rows,n);gates+=len(gg);assert k<(1<<len(bits))
        for bit,v in enumerate(bits):rows.append([v if k>>bit&1 else -v])
    slots=0;partner_clauses=0
    for i,mask in enumerate(A):
        neighbors=[j for j in range(nz) if mask>>j&1];width=(len(neighbors)-1).bit_length() if neighbors else 0;variables=list(range(n+1,n+1+width));n+=width;slots+=width
        for code,j in enumerate(neighbors):
            for bit,v in enumerate(variables):rows.append([-owner(0,i),-owner(1,j),v if code>>bit&1 else -v]);partner_clauses+=1
    rows.extend(source_extras)
    return rows,n,{'adder_gates':gates,'partner_label_variables':slots,'partner_clauses':partner_clauses,'source_negative_clauses':len(source_extras),'exact_count_in_each_sector':k}
def export(a):
    X,Z,A=physical();allrows,_,d=full_build(X,Z,A,seeds=a.seed_cuts,phase_profiles=a.phase_profiles);count=d['seed_and_phase_clauses'];extras=allrows[-count:] if count else [];assert all(all(v<0 for v in c) for c in extras);rows,n,details=build(X,Z,A,a.pairs,extras);raw=(f'p cnf {n} {len(rows)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in rows)).encode();a.output.with_suffix('.cnf.gz').write_bytes(gzip.compress(raw,mtime=0))
    meta={'status':'FROZEN_HEREDITARY_PROJECTION_MODEL_REQUIRES_REPLAY','source_C16_answered':False,'source_full_frame_size':128,'selected_pairs':a.pairs,'partial_frame_model':True,'full_frame_projection_necessary':True,'positive_full_basis_constraints_imported':False,'variables':n,'clauses':len(rows),'input_file':a.output.with_suffix('.cnf.gz').name,'input_sha256':hashlib.sha256(raw).hexdigest(),'details':details,'seed_dependencies':[{'c16_path':str(p.resolve().relative_to(ROOT)),'sha256':sha(p)} for p in a.seed_cuts],'phase_profiles_c16_path':str(a.phase_profiles.resolve().relative_to(ROOT)) if a.phase_profiles else None,'phase_profiles_sha256':sha(a.phase_profiles) if a.phase_profiles else None,'acceptance':'SAT gives a physically replayed partial matching only; UNSAT plus independent model/source/proof replay excludes a128-pair source frame because deleting128-k pairs preserves every imported all-negative clause.'};a.output.write_text(json.dumps(meta,indent=2)+'\n');print('PROJECTED FRAME MODEL',a.pairs,n,len(rows),details,flush=True)
def solve(a):
    from pysat.formula import CNF
    from pysat.solvers import Solver
    meta=json.loads(a.instance.read_text());raw=gzip.decompress((a.instance.parent/meta['input_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==meta['input_sha256'];cnf=CNF(from_string=raw.decode());X,Z,A=physical();start=time.monotonic();d={'status':'RUNNING','source_C16_answered':False,'selected_pairs':meta['selected_pairs'],'input_sha256':meta['input_sha256'],'instance_c16_path':str(a.instance.resolve().relative_to(ROOT)),'answer':None,'solver':a.solver,'outer_wall_seconds':a.seconds};a.output.write_text(json.dumps(d,indent=2)+'\n')
    with Solver(name=a.solver,bootstrap_with=cnf.clauses) as solver:
        answer=solver.solve();d.update(answer=answer,status='SAT_PARTIAL_FRAME_REQUIRES_PHYSICAL_REPLAY' if answer else 'UNSAT_REQUIRES_FRESH_PROOF_AND_SOURCE_REPLAY',solve_seconds=time.monotonic()-start,solver_statistics=solver.accum_stats())
        if answer:
            model=solver.get_model();truth=set(model);assert all(any(v in truth for v in c) for c in cnf.clauses);xi=[i for i in range(720) if i+1 in truth];zj=[j for j in range(720) if j+721 in truth];assert len(xi)==len(zj)==meta['selected_pairs'];pairs=[]
            for i in xi:
                partners=[j for j in zj if A[i]>>j&1];assert len(partners)==1;pairs.append([i,partners[0]])
            assert len({j for i,j in pairs})==len(pairs)
            for h,(i,j) in enumerate(pairs):
                for t,(ii,jj) in enumerate(pairs):assert bool(A[i]>>jj&1)==(h==t)
            d.update(pool_pairs=pairs,model=model)
    a.output.write_text(json.dumps(d,indent=2)+'\n');print('PROJECTION END',d['status'],flush=True)
def main():
    p=argparse.ArgumentParser();p.add_argument('--mode',choices=['export','solve'],required=True);p.add_argument('--pairs',type=int,default=96);p.add_argument('--seed-cuts',type=Path,nargs='*',default=[]);p.add_argument('--phase-profiles',type=Path);p.add_argument('--instance',type=Path);p.add_argument('--solver',default='cadical195');p.add_argument('--seconds',type=float,default=900);p.add_argument('--output',type=Path,required=True);p.add_argument('--child',action='store_true');a=p.parse_args();assert 1<=a.pairs<=128
    if a.mode=='export':export(a);return
    if a.child:solve(a);return
    start=time.monotonic();child=subprocess.Popen([sys.executable,str(Path(__file__).resolve()),*sys.argv[1:],'--child']);expired=False
    try:child.wait(timeout=a.seconds)
    except subprocess.TimeoutExpired:expired=True;child.terminate();child.wait(timeout=10)
    d=json.loads(a.output.read_text()) if a.output.exists() else {'status':'ERROR_BEFORE_CHECKPOINT'}
    if expired:d.update(status='UNKNOWN_OUTER_WALL_LIMIT',answer=None)
    d.update(child_returncode=child.returncode,outer_wall_expired=expired,total_wall_seconds=time.monotonic()-start);a.output.write_text(json.dumps(d,indent=2)+'\n');print('PROJECTION PARENT',d['status'],flush=True)
if __name__=='__main__':main()
