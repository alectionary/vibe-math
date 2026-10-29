#!/usr/bin/env python3
"""Freeze a full source-anchor model with owner variables first, then run trials."""
from pathlib import Path
import argparse,gzip,hashlib,json,subprocess,sys,time
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def export(base,output,seeds):
    d=json.loads(base.read_text());assert d['all_source_edges_retained'] and not d['equation_uv_hex'];raw=gzip.decompress((base.parent/d['input_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==d['input_sha256'];lines=raw.decode().splitlines();header=lines.pop(0).split();assert header[:2]==['p','xnf'];oldn=int(header[2]);rows=[list(map(int,line.split()))[:-1] for line in lines];assert len(rows)==int(header[3]);X,Z,A=physical();ax,az=d['anchor'];E=[(i,j) for i in range(720) for j in range(720) if i!=ax and j!=az and not A[i]>>az&1 and not A[ax]>>j&1 and A[i]>>j&1];m=len(E);assert m==d['free_edges'];left=sorted({i for i,j in E});right=sorted({j for i,j in E});owners={m+k+1:i+1 for k,i in enumerate(left)};owners.update({m+len(left)+k+1:721+j for k,j in enumerate(right)});end=m+len(left)+len(right);mapping=[0]*(oldn+1)
    for v in range(1,oldn+1):mapping[v]=1440+v if v<=m else (owners[v] if v<=end else 1440+m+v-end)
    for row in rows:
        for k,lit in enumerate(row):row[k]=mapping[abs(lit)]*(1 if lit>0 else -1)
    for side,available,fixed in [(0,set(left),ax),(1,set(right),az)]:
        for i in range(720):
            if i not in available:rows.append([(1 if i==fixed else -1)*(i+1+720*side)])
    seedrows=set();sources=[]
    for p in seeds:
        data=json.loads(p.read_text());sources.append({'c16_path':str(p.resolve().relative_to(ROOT)),'sha256':sha(p)})
        for cut in data['cuts']:
            assert cut['kind'] in ['forced_propagation','z_zero','joint_forced_propagation']
            for h in range(16):
                if cut['kind']=='joint_forced_propagation':
                    pattern=[[16*(i//16)+(i%16+h)%16 for i in cut[key]] for key in ['required_X','required_Z']];patterns=[pattern,pattern[::-1]]
                else:
                    ids=[16*(i//16)+(i%16+h)%16 for i in cut['indices']];patterns=[[ids,[]],[[],ids]]
                for pattern in patterns:seedrows.add(tuple(sorted(-(i+1+720*side) for side,ids in enumerate(pattern) for i in ids)))
    rows += [list(c) for c in sorted(seedrows)];n=1440+m+oldn-end;cnf=(f'p cnf {n} {len(rows)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in rows)).encode();ip=output.with_suffix('.cnf.gz');ip.write_bytes(gzip.compress(cnf,mtime=0));meta={'status':'FROZEN_FULL_SOURCE_ANCHOR_REQUIRES_REPLAY','source_C16_answered':False,'anchor':d['anchor'],'base_metadata_c16_path':str(base.resolve().relative_to(ROOT)),'base_metadata_sha256':sha(base),'base_XNF_sha256':d['input_sha256'],'old_variables':oldn,'variables':n,'clauses':len(rows),'free_edges':m,'owner_variables':'X_i=i+1; Z_j=j+721; fixed anchor owners true; absent free owners false','source_full_frame_size':128,'projection_model':False,'input_file':ip.name,'input_sha256':hashlib.sha256(cnf).hexdigest(),'source_cut_dependencies':sources,'seed_clauses':len(seedrows)};output.write_text(json.dumps(meta,indent=2)+'\n');print('FROZEN FULL',n,len(rows),'clauses',len(seedrows),'seed clauses',flush=True)

def solve(a):
    from pysat.formula import CNF
    from pysat.solvers import Solver
    meta=json.loads(a.instance.read_text());raw=gzip.decompress((a.instance.parent/meta['input_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==meta['input_sha256'];formula=CNF(from_string=raw.decode());X,Z,A=physical();start=time.monotonic();result={'status':'RUNNING','source_C16_answered':False,'variant':a.variant,'instance_c16_path':str(a.instance.resolve().relative_to(ROOT)),'instance_sha256':sha(a.instance),'input_sha256':meta['input_sha256'],'anchor':meta['anchor'],'variables':meta['variables'],'clauses':meta['clauses'],'outer_wall_seconds':a.seconds,'answer':None};a.output.write_text(json.dumps(result,indent=2)+'\n');oracle=None
    def progress(stats):
        result['oracle_statistics']=stats;result['elapsed_solve_seconds']=time.monotonic()-start;temp=a.output.with_suffix('.checkpoint.tmp');temp.write_text(json.dumps(result,indent=2)+'\n');temp.replace(a.output)
    with Solver(name='cadical195',bootstrap_with=formula.clauses) as solver:
        del formula
        if a.variant=='conditional-span':
            from conditional_span_oracle import ConditionalSpanOracle
            assert a.native_library;result['native_library_sha256']=sha(a.native_library);oracle=ConditionalSpanOracle(X,Z,a.native_library,a.output.with_suffix('.lemmas.jsonl'),progress=progress,limit=a.clause_limit);solver.connect_propagator(oracle)
            for v in range(1,1441):solver.observe(v)
        answer=solver.solve();result['answer']=answer;result['status']='SAT_FULL_FRAME_REQUIRES_PHYSICAL_REPLAY' if answer else 'UNSAT_REQUIRES_FRESH_PROOF_AND_SOURCE_REPLAY';result['elapsed_solve_seconds']=time.monotonic()-start;result['solver_statistics']=solver.accum_stats()
        if oracle:result['oracle_statistics']=oracle.stats.copy();oracle.close()
        if answer:
            model=solver.get_model();chosen=set(model);assert all(any(v in chosen for v in row) for row in CNF(from_string=raw.decode()).clauses);ax,az=meta['anchor'];E=[(i,j) for i in range(720) for j in range(720) if i!=ax and j!=az and not A[i]>>az&1 and not A[ax]>>j&1 and A[i]>>j&1];pairs=[(ax,az)]+[e for k,e in enumerate(E,1) if 1440+k in chosen];assert len(pairs)==128
            for k,(i,j) in enumerate(pairs):
                assert A[i]>>j&1
                for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
            result['pool_pairs']=pairs;result['model']=model
    a.output.write_text(json.dumps(result,indent=2)+'\n');print('FULL FRAME TRIAL',a.variant,result['status'],flush=True)

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--mode',choices=['export','solve'],required=True);ap.add_argument('--base',type=Path);ap.add_argument('--instance',type=Path);ap.add_argument('--seed-cuts',type=Path,nargs='*',default=[]);ap.add_argument('--variant',choices=['baseline','conditional-span'],default='conditional-span');ap.add_argument('--native-library',type=Path);ap.add_argument('--seconds',type=float,default=900);ap.add_argument('--clause-limit',type=int,default=20000);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--child',action='store_true');a=ap.parse_args()
    if a.mode=='export':assert a.base;export(a.base,a.output,a.seed_cuts);return
    assert a.instance
    if a.child:solve(a);return
    start=time.monotonic();child=subprocess.Popen([sys.executable,str(Path(__file__).resolve()),*sys.argv[1:],'--child']);expired=False
    try:child.wait(timeout=a.seconds)
    except subprocess.TimeoutExpired:expired=True;child.terminate();child.wait(timeout=10)
    d=json.loads(a.output.read_text()) if a.output.exists() else {'status':'ERROR_BEFORE_CHECKPOINT'}
    if expired:d.update(status='UNKNOWN_OUTER_WALL_LIMIT',answer=None)
    d.update(child_returncode=child.returncode,outer_wall_expired=expired,total_wall_seconds=time.monotonic()-start)
    lp=a.output.with_suffix('.lemmas.jsonl')
    if lp.exists():d['lemma_file']=lp.name;d['lemma_file_sha256']=sha(lp)
    a.output.write_text(json.dumps(d,indent=2)+'\n');print('FULL PARENT',a.variant,d['status'],flush=True)
if __name__=='__main__':main()
