#!/usr/bin/env python3
"""Phase-specific memory profile of a frozen anchored projected-equation model."""
from pathlib import Path
import argparse,gc,hashlib,json,resource,time
import psutil
from signature_cover import logical_data,encode
from adaptive_matrix_identities import parity
ROOT=Path(__file__).resolve().parent

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--block',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=300);ap.add_argument('--gauss',type=int,default=1);a=ap.parse_args();start=time.monotonic();phases=[];proc=psutil.Process()
 def mark(name,**kwargs):
  r={'phase':name,'elapsed_seconds':time.monotonic()-start,'resident_bytes':proc.memory_info().rss,'peak_resident_bytes':resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,**kwargs};phases.append(r);a.output.write_text(json.dumps({'status':'RUNNING','phases':phases},indent=2)+'\n');print(json.dumps(r),flush=True)
 mark('imports');import pycryptosat;mark('native_solver_import')
 A,_,_=logical_data();X,Z=[[int(s,16) for s in (ROOT/f'pools/{side}coords.txt').read_text().split()] for side in ['x','z']];b=json.loads(a.block.read_text());prior=json.loads((ROOT/'residual-identity-results/adaptive-anchor-compact.json').read_text());U=list(map(lambda s:int(s,16),b['auxiliary_U_hex']));V=list(map(lambda s:int(s,16),b['auxiliary_V_hex']));equations=[(int(e['u_hex'],16),int(e['v_hex'],16)) for e in prior['equations']]+[(u,v) for u in U for v in V];mark('physical_coordinates_and_equations',equations=len(equations))
 target=sum((parity(u,v)^parity(X[48],v)*parity(u,Z[48]))<<k for k,(u,v) in enumerate(equations));sx=[sum(parity(x,v)<<k for k,(u,v) in enumerate(equations)) for x in X];sz=[sum(parity(u,z)<<k for k,(u,v) in enumerate(equations)) for z in Z]
 E=[(i,j,sx[i]&sz[j],0) for i in range(720) if i!=48 and not A[i]>>48&1 for j in range(720) if j!=48 and not A[48]>>j&1 and A[i]>>j&1 and sx[i]&sz[j]];mark('source_edges',edges=len(E))
 cnf,n,_,events=encode(A,[0],E,with_xor=False);mark('python_clause_encoding',variables=n,clauses=len(cnf));clause_count=len(cnf);solver=pycryptosat.Solver(threads=1,options={'minmatrixrows':'0','maxmatrixrows':'5000','autodisablegauss':'0' if a.gauss else '1'})
 for c in cnf:solver.add_clause(c)
 mark('native_clauses_loaded_python_clauses_retained');del cnf;gc.collect();mark('python_clause_objects_released')
 for k in range(len(equations)):solver.add_xor_clause([v for v,s in events if s>>k&1],bool(target>>k&1))
 mark('native_parities_loaded');built=time.monotonic();sat,model=solver.solve(time_limit=a.seconds);mark('solve_returned',answer=sat);pairs=[]
 if sat:
  pairs=[(48,48)]+[e[:2] for k,e in enumerate(E,1) if model[k]]
  for k,(i,j) in enumerate(pairs):
   assert A[i]>>j&1
   for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
  for u,v in equations:assert sum(parity(X[i],v)*parity(u,Z[j]) for i,j in pairs)%2==parity(u,v)
 result={'status':'COMPLETE_PROFILE','source_C16_answered':False,'anchor':[48,48],'equations':len(equations),'free_edges':len(E),'variables':n,'clauses':clause_count,'native_GJE_requested':bool(a.gauss),'solve_allowance_seconds':a.seconds,'answer':sat,'partial_matching':pairs,'partial_size':len(pairs),'phases':phases,'construction_seconds':built-start,'solve_seconds':time.monotonic()-built,'elapsed_seconds':time.monotonic()-start,'source_block':str(a.block),'source_block_sha256':hashlib.sha256(a.block.read_bytes()).hexdigest(),'scope':'Same unrestricted-source anchor and projected necessities as frozen block. A partial SAT witness is not a full frame. UNSAT without an independent proof is discovery only. Peak resident values are process cumulative high water, current resident values are phase snapshots.'};a.output.write_text(json.dumps(result,indent=2)+'\n');print('PROFILE FINISHED',sat,'partial',len(pairs),flush=True)
if __name__=='__main__':main()
