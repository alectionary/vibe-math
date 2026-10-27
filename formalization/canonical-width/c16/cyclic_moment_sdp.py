#!/usr/bin/env python3
"""Translation-invariant degree-two necessary moment model for a full frame.

This is a numerical relaxation, not an exact certificate. Its moment matrix is
block diagonalized under simultaneous cyclic translation. Boolean first/second
moments, exact sector cardinalities and conditional selected degree-one are
retained. Satisfiability of this relaxation does not construct a frame.
"""
import argparse
from datetime import datetime,timezone
import json
import math
from pathlib import Path
import subprocess
import sys
import time
import numpy as np
import cvxpy as cp


def model(patterns,P,target,cap=None,maximize_margin=False,shape_inputs=None,fixed_margin=0):
    m=len(patterns);N=2*m;assert P%2==0
    p=cp.Variable(N,name='first');C={0:cp.Variable((N,N),symmetric=True,name='C0'),P//2:cp.Variable((N,N),symmetric=True,name='Chalf')}
    for h in range(1,P//2):C[h]=cp.Variable((N,N),name=f'C{h}');C[P-h]=C[h].T
    B0=sum(C[h] for h in range(P));mean=math.sqrt(P)*p
    constraints=[p>=0,p<=1,cp.diag(C[0])==p,P*cp.sum(p[:m])==target,P*cp.sum(p[m:])==target,cp.sum(B0[:,:m],axis=1)==target*p,cp.sum(B0[:,m:],axis=1)==target*p]
    ones=np.ones((1,N));rows=cp.reshape(p,(N,1),order='C')@ones;cols=rows.T
    for h in range(P//2+1):constraints.extend([C[h]>=0,C[h]<=rows,C[h]<=cols,C[h]>=rows+cols-1])
    G0=cp.bmat([[np.ones((1,1)),cp.reshape(mean,(1,N),order='C')],[cp.reshape(mean,(N,1),order='C'),B0]])
    margin=cp.Variable(name='margin') if maximize_margin else fixed_margin
    if fixed_margin and not maximize_margin:
        # Keep the full scaling while allowing the two forced null directions.
        U=np.zeros((N+1,2));U[0,:]=-target/math.sqrt(P);U[1:m+1,0]=1;U[m+1:,1]=1
        projection=np.eye(N+1)-U@np.linalg.inv(U.T@U)@U.T
        constraints.append(G0-margin*projection>>0)
    elif maximize_margin:
        constraints.extend([margin>=0,margin<=1])
        # Exact cardinality identities already force two null vectors. Remove
        # one coordinate in each sector before asking for a strict PSD margin.
        keep=[i for i in range(N+1) if i not in [m,N]]
        constraints.append(G0[np.ix_(keep,keep)]-margin*np.eye(N-1)>>0)
    else:constraints.append(G0>>0)
    frequency=[]
    for k in range(1,P//2+1):
        real=C[0]+((-1)**k)*C[P//2];imag=0*C[0]
        for h in range(1,P//2):
            c=(-1)**h if k==P//2 else math.cos(2*math.pi*k*h/P);s=0 if k==P//2 else math.sin(2*math.pi*k*h/P)
            real=real+c*(C[h]+C[h].T);imag=imag+s*(C[h]-C[h].T)
        block=real if k==P//2 else cp.bmat([[real,-imag],[imag,real]])
        constraints.append(block-margin*np.eye(block.shape[0])>>0);frequency.append(block)
    anti=[np.array([[patterns[a][b]>>h&1 for b in range(m)] for a in range(m)],dtype=float) for h in range(P)]
    cross=sum(cp.multiply(anti[h],C[h][:m,m:]) for h in range(P))
    constraints.extend([cp.sum(cross,axis=1)==p[:m],cp.sum(cross,axis=0)==p[m:]])
    if cap is not None:constraints.extend([P*p[12]<=cap,P*p[m+12]<=cap])
    if shape_inputs is not None:
        from scipy.sparse import csr_array
        from collections import defaultdict
        # Keep numerical SDP libraries separate from OR-Tools' bundled HiGHS.
        def canonical(f):
            return min(((f<<h)|(f>>(16-h)))&65535 for h in range(16))
        assert P==16 and m==45
        masks=list(map(int,(shape_inputs/'masks.txt').read_text().split()));profiles={r['pattern']:r for r in json.loads((shape_inputs/'profiles.json').read_text())};S=len(masks)
        distribution=cp.Variable((N,S),nonneg=True,name='shape_distribution');weights=np.array([v.bit_count()/P for v in masks])
        constraints.extend([cp.sum(distribution,axis=1)==1,distribution@weights==p])
        for h in range(1,P//2+1):
            autocorrelation=np.array([(v&(((v<<h)|(v>>(P-h)))&65535)).bit_count()/P for v in masks])
            constraints.append(distribution@autocorrelation==cp.diag(C[h]))
        for a in range(m):
            normal=[canonical(f) for f in patterns[a]];zero=csr_array(np.array([profiles[f]['zero'] for f in normal],dtype=float));owners=csr_array(np.array([profiles[f]['owners'] for f in normal],dtype=float))
            ex=P*cross[a,:];ez=P*cross[:,a]
            constraints.extend([ex<=owners@distribution[a,:],P*p[m:]-ex<=zero@distribution[a,:],ez<=owners@distribution[m+a,:],P*p[:m]-ez<=zero@distribution[m+a,:]])
            groups=defaultdict(list)
            for b,f in enumerate(normal):groups[f].append(b)
            for f,bins in groups.items():
                if len(bins)<2 or f.bit_count()<=1:continue
                own=np.array(profiles[f]['owners'],dtype=float)
                constraints.extend([cp.sum(ex[bins])<=own@distribution[a,:],cp.sum(ez[bins])<=own@distribution[m+a,:]])
    return cp.Problem(cp.Maximize(margin) if maximize_margin else cp.Minimize(0),constraints),p,C


def verify_moments(patterns,P,target,p,C,cap=None):
    m=len(patterns);N=2*m;errors={}
    B0=sum(C[h] for h in range(P));errors['diagonal']=float(np.max(abs(np.diag(C[0])-p)));errors['cardinality']=max(abs(P*sum(p[:m])-target),abs(P*sum(p[m:])-target))
    errors['cardinality_products']=float(max(np.max(abs(B0[:,:m].sum(axis=1)-target*p)),np.max(abs(B0[:,m:].sum(axis=1)-target*p))))
    cross=np.zeros((m,m))
    for a in range(m):
        for b in range(m):cross[a,b]=sum(C[h][a,m+b] for h in range(P) if patterns[a][b]>>h&1)
    errors['selected_degrees']=float(max(np.max(abs(cross.sum(axis=1)-p[:m])),np.max(abs(cross.sum(axis=0)-p[m:]))))
    errors['pair_bounds']=float(max(0,max(-np.min(v) for v in C.values()),max(np.max(v-p[:,None]) for v in C.values()),max(np.max(v-p[None,:]) for v in C.values()),max(np.max(p[:,None]+p[None,:]-1-v) for v in C.values())))
    errors['transpose']=float(max(np.max(abs(C[h].T-C[(-h)%P])) for h in range(P)))
    if cap is not None:errors['monomial_cap']=float(max(0,P*p[12]-cap,P*p[m+12]-cap))
    G=np.block([[np.ones((1,1)),math.sqrt(P)*p[None,:]],[math.sqrt(P)*p[:,None],B0]])
    eigen=[float(np.linalg.eigvalsh((G+G.T)/2)[0])]
    for k in range(1,P//2+1):
        B=sum(np.exp(2j*np.pi*k*h/P)*C[h] for h in range(P));assert np.max(abs(B-B.conj().T))<1e-7
        eigen.append(float(np.linalg.eigvalsh((B+B.conj().T)/2)[0]))
    return {'linear_max_error':float(max(errors.values())),'errors':errors,'minimum_frequency_eigenvalues':eigen,'PSD_min_eigenvalue':min(eigen),'evidence':'floating-point residual check; no exact certificate'}


def moments_from_masks(masks,P):
    N=len(masks);p=np.array([v.bit_count()/P for v in masks]);C={}
    for h in range(P):
        C[h]=np.array([[sum(((a>>u)&1)*((b>>((u+h)%P))&1) for u in range(P))/P for b in masks] for a in masks])
    return p,C


def verify_shape_marginals(patterns,p,C,distribution,folder):
    """Replay the shape inequalities without CVXPY expressions."""
    masks=list(map(int,(folder/'masks.txt').read_text().split()))
    profiles={r['pattern']:r for r in json.loads((folder/'profiles.json').read_text())}
    canonical=lambda f:min(((f<<h)|(f>>(16-h)))&65535 for h in range(16))
    errors=[max(0,float(-distribution.min())),float(np.max(abs(distribution.sum(axis=1)-1))),float(np.max(abs(distribution@np.array([v.bit_count()/16 for v in masks])-p)))]
    for h in range(1,9):
        autocorrelation=np.array([sum(((v>>i)&1)*((v>>((i+h)%16))&1) for i in range(16))/16 for v in masks])
        errors.append(float(np.max(abs(distribution@autocorrelation-np.diag(C[h])))))
    flow=np.array([[16*sum(C[h][a,45+b] for h in range(16) if patterns[a][b]>>h&1) for b in range(45)] for a in range(45)])
    for side in range(2):
        for a in range(45):
            groups={}
            for b in range(45):
                f=canonical(patterns[a][b]);groups.setdefault(f,[]).append(b)
                e=flow[a,b] if side==0 else flow[b,a];mass=distribution[45*side+a]
                errors.extend([e-float(mass@profiles[f]['owners']),16*p[45*(1-side)+b]-e-float(mass@profiles[f]['zero'])])
            for f,bins in groups.items():
                if len(bins)>1 and f.bit_count()>1:
                    e=sum(flow[a,b] if side==0 else flow[b,a] for b in bins)
                    errors.append(e-float(distribution[45*side+a]@profiles[f]['owners']))
    return {'maximum_residual':max(0,max(errors)),'evidence':'independent floating-point replay, not an exact certificate'}


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--mapping',type=Path);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=300);ap.add_argument('--iterations',type=int,default=3000);ap.add_argument('--control',choices=['positive','negative']);ap.add_argument('--maximize-margin',action='store_true');ap.add_argument('--shape-inputs',type=Path);ap.add_argument('--fixed-margin',type=float,default=0);ap.add_argument('--eps',type=float,default=1e-5);ap.add_argument('--canonical-dump',action='store_true');ap.add_argument('--indirect',action='store_true');ap.add_argument('--child',action='store_true',help=argparse.SUPPRESS);args=ap.parse_args()
    if not args.child:
        child=subprocess.Popen([sys.executable,str(Path(__file__).resolve())]+sys.argv[1:]+['--child']);expired=False
        try:child.wait(timeout=args.seconds+10)
        except subprocess.TimeoutExpired:
            expired=True;child.terminate()
            try:child.wait(timeout=3)
            except subprocess.TimeoutExpired:child.kill();child.wait()
        d=json.loads(args.output.read_text()) if args.output.exists() else {}
        if d.get('status') in [None,'RUNNING']:d['status']='PROCESS_TIME_LIMIT' if expired else 'ERROR'
        d.update(child_returncode=child.returncode,outer_limit_seconds=args.seconds);args.output.write_text(json.dumps(d,indent=2)+'\n');return
    P=16;cap=11;target=128
    if args.control=='positive':P=4;cap=None;target=4;patterns=[[int(a==b) for b in range(3)] for a in range(3)]
    elif args.control=='negative':P=2;cap=None;target=2;patterns=[[3,3],[3,3]]
    else:patterns=json.loads(args.mapping.read_text())['patterns']
    start=time.monotonic();result={'status':'RUNNING','scope':'necessary degree-two cyclic moment SDP','physical_frame':False,'P':P,'orbit_types':len(patterns),'target_pairs':target,'control':args.control,'solver':'SCS','iterations_limit':args.iterations};args.output.write_text(json.dumps(result,indent=2)+'\n')
    problem,p,C=model(patterns,P,target,cap,args.maximize_margin,args.shape_inputs,args.fixed_margin)
    if args.control=='positive':
        known_p,known_C=moments_from_masks([15,0,0,15,0,0],4);check=verify_moments(patterns,P,target,known_p,known_C);assert check['linear_max_error']<1e-12 and check['PSD_min_eigenvalue']>-1e-10;result['explicit_positive_moment_check']=check
    # Compilation can dominate the shape model; include it in the wall budget.
    problem.get_problem_data(cp.SCS)
    result['model_seconds']=time.monotonic()-start;args.output.write_text(json.dumps(result,indent=2)+'\n');print('MODEL_BUILT',json.dumps(result),flush=True)
    problem.solve(solver='SCS',use_indirect=args.indirect,eps=args.eps,max_iters=args.iterations,time_limit_secs=max(1,args.seconds-result['model_seconds']-5),verbose=True)
    result.update(status=str(problem.status),total_seconds=time.monotonic()-start,solver_seconds=problem.solver_stats.solve_time,solver_iterations=problem.solver_stats.num_iters,maximize_margin=args.maximize_margin,objective=problem.value)
    if p.value is not None:
        values={h:np.asarray(C[h].value) for h in range(P)};result['independent_numeric_check']=verify_moments(patterns,P,target,np.asarray(p.value),values,cap)
        extra={v.name():v.value for v in problem.variables() if v.name()=='shape_distribution'}
        if extra:result['independent_shape_check']=verify_shape_marginals(patterns,np.asarray(p.value),values,extra['shape_distribution'],args.shape_inputs)
        np.savez_compressed(args.output.with_suffix('.moments.npz'),first=p.value,**{f'C{h}':v for h,v in values.items()},**extra)
        if args.canonical_dump:
            from scipy.sparse import save_npz
            data,chain,inverses=problem.get_problem_data(cp.SCS)
            count=data['dims'].zero
            save_npz(args.output.with_suffix('.equalities.npz'),data['A'][:count,:])
            np.savez_compressed(args.output.with_suffix('.canonical.npz'),x=problem.solver_stats.extra_stats['x'],b=data['b'][:count])
            stuffing=next(v for v in inverses if hasattr(v,'var_offsets') and all(w.id in v.var_offsets for w in p.variables()))
            # The final matrix-stuffing inverse uses the reduced symmetric variables.
            stuffing=[v for v in inverses if hasattr(v,'var_offsets')][-1]
            metadata={'offsets':stuffing.var_offsets,'shapes':stuffing.var_shapes,'variables':{str(v.id):v.name() for v in problem.variables()},'equalities':count}
            args.output.with_suffix('.canonical.json').write_text(json.dumps(metadata,indent=2)+'\n')
    result['shape_marginals']=args.shape_inputs is not None
    args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)


if __name__=='__main__':main()
