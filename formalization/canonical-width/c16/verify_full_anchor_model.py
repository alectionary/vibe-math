#!/usr/bin/env python3
"""Independent physical regeneration of the exact full-anchor XNF input."""
from pathlib import Path
import argparse,collections,gzip,hashlib,json,time
from itertools import combinations
from verify_algebraic_model import physical
from verify_signature_cover import independent_cnf,rank
ROOT=Path(__file__).resolve().parent
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--metadata',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();d=json.loads(a.metadata.read_text());X,Z,A=physical();assert rank(X)==rank(Z)==128;ax,az=d['anchor'];assert A[ax]>>az&1
 eq=[(int(u,16),int(v,16)) for u,v in d['equation_uv_hex']];par=lambda u,v:(u&v).bit_count()%2;t=sum((par(u,v)^par(X[ax],v)*par(u,Z[az]))<<k for k,(u,v) in enumerate(eq));assert t==int(d['free_target_hex'],16)
 sx=[sum(par(x,v)<<k for k,(u,v) in enumerate(eq)) for x in X];sz=[sum(par(u,z)<<k for k,(u,v) in enumerate(eq)) for z in Z];E=[]
 for i in range(720):
  for j in range(720):
   if i!=ax and j!=az and not A[i]>>az&1 and not A[ax]>>j&1 and A[i]>>j&1:E.append((i,j,sx[i]&sz[j],0))
 cnf,n,_,_=independent_cnf(A,[0],E,False,nbits=0);L=collections.defaultdict(list);R=collections.defaultdict(list)
 for k,(i,j,_,_) in enumerate(E,1):L[i].append(k);R[j].append(k)
 ownX={i:len(E)+k+1 for k,i in enumerate(sorted(L))};ownZ={j:len(E)+len(L)+k+1 for k,j in enumerate(sorted(R))}
 for i in sorted(L):cnf.append([-ownX[i]]+L[i])
 for j in sorted(R):cnf.append([-ownZ[j]]+R[j])
 if d.get('basis_coverage',False):
  for i,row in enumerate(A):
   if not row>>az&1:cnf.append([ownZ[j] for j in sorted(ownZ) if row>>j&1])
  for j in range(720):
   if not A[ax]>>j&1:cnf.append([ownX[i] for i in sorted(ownX) if A[i]>>j&1])
 if d.get('profile_cuts_c16_path'):
  file=ROOT/d['profile_cuts_c16_path'];payload=file.read_bytes();cuts=json.loads(gzip.decompress(payload) if file.suffix=='.gz' else payload)
  if cuts.get('conditioned_on_anchor') is not None:assert cuts['conditioned_on_anchor']==d['anchor']
  for r in cuts['records']:
   for cut in r['minimal_bad_certificates']:
    selected={16*r['orbit']+h for h in range(16) if cut['mask']>>h&1}
    for owners,fixed in [(ownX,ax),(ownZ,az)]:
     remaining=selected-{fixed}
     if remaining<=owners.keys():cnf.append([-owners[i] for i in sorted(remaining)])
 if d.get('critical_cap') is not None:
  assert d['critical_cap']==11
  critical=[i for i,x in enumerate(X) if x.bit_count()==1 and (x>>64)&65535];assert critical==list(range(192,208))
  for selected in combinations(critical,12):
   for owners,fixed in [(ownX,ax),(ownZ,az)]:
    remaining=set(selected)-{fixed}
    if remaining<=owners.keys():cnf.append([-owners[i] for i in sorted(remaining)])
 # Independent Tseitin templates for z iff a OR (b AND x).
 previous={0:True};counter_rows=0
 for count,x in enumerate(ownX.values(),1):
  current={0:True}
  for k in range(1,min(count,127)+1):
   aa=previous.get(k,False);bb=previous[k-1];n+=1;z=n;current[k]=z
   templates=[[(aa,False),(z,True)],[(bb,False),(x,False),(z,True)],[(z,False),(aa,True),(bb,True)],[(z,False),(aa,True),(x,True)]]
   for literals in templates:
    if any(type(v)is bool and v==positive for v,positive in literals):continue
    cnf.append([v if positive else -v for v,positive in literals if type(v)is not bool]);counter_rows+=1
  previous=current
 cnf.append([previous[127]]);assert n==d['variables'] and len(cnf)==d['clauses'];lines=[' '.join(map(str,c))+' 0' for c in cnf]
 for k in range(len(eq)):
  vs=[v for v,e in enumerate(E,1) if e[2]>>k&1]
  if vs:lines.append(('' if t>>k&1 else '-')+'+'.join(map(str,vs))+' 0')
  elif t>>k&1:lines.append('0')
 raw=(f'p xnf {n} {len(lines)}\n'+'\n'.join(lines)+'\n').encode();saved=gzip.decompress((a.metadata.parent/d['input_file']).read_bytes());assert raw==saved and hashlib.sha256(raw).hexdigest()==d['input_sha256'];assert len(E)==d['free_edges'];assert sum(not e[2] for e in E)==d['zero_signature_edges']
 out={'status':'PASS','source_C16_answered':False,'physical_pairings_rebuilt':518400,'anchor':d['anchor'],'free_edges':len(E),'zero_signature_edges_retained':sum(not e[2] for e in E),'variables':n,'clauses':len(cnf),'native_parities':len(eq),'basis_coverage':d.get('basis_coverage',False),'input_sha256':d['input_sha256'],'counter_equivalence_rows':counter_rows,'elapsed_seconds':time.monotonic()-start,'scope':'Independent physical regeneration of original full-frame anchor XNF. Establishes model binding only; no satisfiability conclusion.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out)
if __name__=='__main__':main()
