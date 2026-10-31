#!/usr/bin/env python3
"""Exact original full-frame anchor model, plus redundant inverse identities.

All compatible original edges retained, including zero-signature edges. Owner
flags are equivalent to edge presence, and a prefix threshold counter forces at
least127 free X owners. Biorthogonality in the127-dimensional anchor quotient
bounds the matching size above by127. SAT is thus a physical128-frame candidate.
"""
from pathlib import Path
import argparse,collections,gc,gzip,hashlib,json,resource,subprocess,tempfile,time
import psutil
from itertools import combinations
from signature_cover import logical_data,encode
from adaptive_matrix_identities import parity
ROOT=Path(__file__).resolve().parent

def at_least_network(literals,bound,top):
 # Saturated prefix threshold z[i,k] iff the first i inputs contain >=k ones.
 # z <-> a OR (b AND x), where a=previous[k], b=previous[k-1].
 cnf=[];n=top;previous={0:True}
 def clause(terms):
  out=[]
  for value,negative in terms:
   if isinstance(value,bool):
    if value!=negative:return
   else:out.append(-value if negative else value)
  cnf.append(out)
 for i,x in enumerate(literals,1):
  current={0:True}
  for k in range(1,min(i,bound)+1):
   a=previous.get(k,False);b=previous[k-1];n+=1;z=n;current[k]=z
   clause([(a,True),(z,False)])
   clause([(b,True),(x,True),(z,False)])
   clause([(z,True),(a,False),(b,False)])
   clause([(z,True),(a,False),(x,False)])
  previous=current
 cnf.append([previous[bound]]);return cnf,n

def build(block,anchor=(48,48),parities=True,basis_coverage=False,profile_cuts=None,critical_cap=None):
 A,_,_=logical_data();X,Z=[[int(s,16) for s in (ROOT/f'pools/{side}coords.txt').read_text().split()] for side in ['x','z']];a,b=anchor;assert A[a]>>b&1
 eq=[]
 if parities:
  data=json.loads(block.read_text());prior=json.loads((ROOT/'residual-identity-results/adaptive-anchor-compact.json').read_text());eq=[(int(e['u_hex'],16),int(e['v_hex'],16)) for e in prior['equations']]+[(int(u,16),int(v,16)) for u in data['auxiliary_U_hex'] for v in data['auxiliary_V_hex']]
 target=sum((parity(u,v)^parity(X[a],v)*parity(u,Z[b]))<<k for k,(u,v) in enumerate(eq));sx=[sum(parity(x,v)<<k for k,(u,v) in enumerate(eq)) for x in X];sz=[sum(parity(u,z)<<k for k,(u,v) in enumerate(eq)) for z in Z]
 E=[(i,j,sx[i]&sz[j],0) for i in range(720) if i!=a and not A[i]>>b&1 for j in range(720) if j!=b and not A[a]>>j&1 and A[i]>>j&1];cnf,n,_,events=encode(A,[0],E,with_xor=False);left=collections.defaultdict(list);right=collections.defaultdict(list)
 for k,(i,j,_,_) in enumerate(E,1):left[i].append(k);right[j].append(k)
 pv={i:len(E)+k+1 for k,i in enumerate(sorted(left))};qv={j:len(E)+len(left)+k+1 for k,j in enumerate(sorted(right))}
 for i in sorted(left):cnf.append([-pv[i]]+left[i])
 for j in sorted(right):cnf.append([-qv[j]]+right[j])
 if basis_coverage:
  # A full dual basis cannot annihilate a nonzero source vector. Rows already
  # paired to the fixed anchor need no residual coverage clause.
  for i in range(720):
   if not A[i]>>b&1:cnf.append([qv[j] for j in sorted(qv) if A[i]>>j&1])
  for j in range(720):
   if not A[a]>>j&1:cnf.append([pv[i] for i in sorted(pv) if A[i]>>j&1])
 if profile_cuts:
  raw=profile_cuts.read_bytes();data=json.loads(gzip.decompress(raw) if profile_cuts.suffix=='.gz' else raw)
  assert data.get('conditioned_on_X_absent') is None and data.get('conditioned_on_X_index') is None and data.get('selected_quotient_sector','X')=='X'
  if data.get('conditioned_on_anchor') is not None:assert data['conditioned_on_anchor']==list(anchor)
  for record in data['records']:
   assert record['complete'];orbit=record['orbit']
   for cut in record['minimal_bad_certificates']:
    ids=[16*orbit+h for h in range(16) if cut['mask']>>h&1]
    for owners,fixed in [(pv,a),(qv,b)]:
     if any(i!=fixed and i not in owners for i in ids):continue
     cnf.append([-owners[i] for i in ids if i!=fixed])
 if critical_cap is not None:
  assert critical_cap==11
  ids=[i for i,x in enumerate(X) if x.bit_count()==1 and (x>>64)&65535];assert ids==list(range(192,208))
  for subset in combinations(ids,12):
   for owners,fixed in [(pv,a),(qv,b)]:
    if any(i!=fixed and i not in owners for i in subset):continue
    cnf.append([-owners[i] for i in subset if i!=fixed])
 counter,n=at_least_network(list(pv.values()),127,n);cnf+=counter
 return A,X,Z,E,cnf,n,events,target,eq,pv,qv

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--block',type=Path,default=ROOT/'theory-loop-results/block-16.json');ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=600);ap.add_argument('--mode',choices=['cms','export'],default='cms');ap.add_argument('--no-parities',action='store_true');ap.add_argument('--basis-coverage',action='store_true');ap.add_argument('--anchor',type=int,nargs=2,default=[48,48]);ap.add_argument('--profile-cuts',type=Path);ap.add_argument('--critical-cap',type=int,choices=[11]);a=ap.parse_args();start=time.monotonic();proc=psutil.Process();phases=[]
 def mark(name,**kw):
  d={'phase':name,'elapsed_seconds':time.monotonic()-start,'resident_bytes':proc.memory_info().rss,'peak_resident_bytes':resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,**kw};phases.append(d);a.output.write_text(json.dumps({'status':'RUNNING','phases':phases},indent=2)+'\n');print(json.dumps(d),flush=True)
 mark('start');A,X,Z,E,cnf,n,events,t,eq,pv,qv=build(a.block,anchor=a.anchor,parities=not a.no_parities,basis_coverage=a.basis_coverage,profile_cuts=a.profile_cuts,critical_cap=a.critical_cap);mark('encoded',free_edges=len(E),variables=n,clauses=len(cnf),equations=len(eq),X_owners=len(pv),Z_owners=len(qv));count=len(cnf);result={'source_C16_answered':False,'anchor':a.anchor,'basis_coverage':a.basis_coverage,'profile_cuts_file':a.profile_cuts.name if a.profile_cuts else None,'profile_cuts_c16_path':str(a.profile_cuts.resolve().relative_to(ROOT)) if a.profile_cuts else None,'critical_cap':a.critical_cap,'all_source_edges_retained':True,'zero_signature_edges':sum(not e[2] for e in E),'free_edges':len(E),'variables':n,'clauses':count,'equations':len(eq),'equation_uv_hex':[[hex(u),hex(v)] for u,v in eq],'free_target_hex':hex(t),'free_owner_lower_bound':127,'source_rank_upper_bound':127,'counter':'saturated prefix threshold recurrence with full Boolean equivalence','signature_compression':False,'answer':None,'partial_frame_allowed':False,'source_block':str(a.block),'phases':phases}
 if a.mode=='export':
  lines=[' '.join(map(str,c))+' 0' for c in cnf]
  for k in range(len(eq)):
   vs=[v for v,s in events if s>>k&1]
   if vs:lines.append(('' if t>>k&1 else '-')+'+'.join(map(str,vs))+' 0')
   elif t>>k&1:lines.append('0')
  raw=(f'p xnf {n} {len(lines)}\n'+'\n'.join(lines)+'\n').encode();p=a.output.with_suffix('.xnf.gz');p.write_bytes(gzip.compress(raw,mtime=0));result.update(status='EXPORTED_EXACT_FULL_ANCHOR',input_file=p.name,input_sha256=hashlib.sha256(raw).hexdigest());mark('exported',bytes=len(raw))
 else:
  import pycryptosat
  s=pycryptosat.Solver(threads=1,options={'minmatrixrows':'0','maxmatrixrows':'5000','autodisablegauss':'0'})
  for c in cnf:s.add_clause(c)
  del cnf;gc.collect();mark('native_CNF_loaded')
  for k in range(len(eq)):s.add_xor_clause([v for v,sig in events if sig>>k&1],bool(t>>k&1))
  mark('native_XOR_loaded');ans,model=s.solve(time_limit=a.seconds);result.update(status='DISCOVERY_REQUIRES_INDEPENDENT_REPLAY',answer=ans);mark('solve_returned',answer=ans)
  if ans:
   pairs=[tuple(a.anchor)]+[e[:2] for k,e in enumerate(E,1) if model[k]];assert len(pairs)==128
   for k,(i,j) in enumerate(pairs):
    assert A[i]>>j&1
    for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
   assert all(sum(parity(X[i],v)*parity(u,Z[j]) for i,j in pairs)%2==parity(u,v) for u,v in eq);result['full_frame_pool_pairs']=pairs
 result['phases']=phases;result['elapsed_seconds']=time.monotonic()-start;a.output.write_text(json.dumps(result,indent=2)+'\n');print('EXACT FULL ANCHOR',result['status'],result.get('answer'),flush=True)
if __name__=='__main__':main()
