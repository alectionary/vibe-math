"""Complete affine generators of fixed-pattern sector basis polytopes.

Discovery producer. Physical independent consumer required for acceptance.
One contracted zero-matroid base and fundamental-circuit forest generate its
entire real affine span; every free owner bin contributes a star of exchanges.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
import argparse,hashlib,json,time
from two_sided_full_basis_oracle import TwoSidedFullBasisOracle
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def representation_basis(vectors):
 piv={}
 for k,v in enumerate(vectors):
  c=1<<k
  while v:
   p=v.bit_length()-1
   if p in piv:v^=piv[p][0];c^=piv[p][1]
   else:piv[p]=(v,c);break
  assert v,'dependent representation basis'
 def rep(v):
  c=0
  while v:
   p=v.bit_length()-1
   assert p in piv,'outside zero span'
   w,z=piv[p];v^=w;c^=z
  return c
 return rep

def components(U,d,support):
 F=d['forced_zero_indices'];B=support['zero_basis_indices'];assert B[:len(F)]==F
 C=B[len(F):];rep=representation_basis([U[j] for j in B]);par={j:j for j in d['zero_free_indices']};forest=[];loops=[];all_edges=0
 def find(j):
  while par[j]!=j:par[j]=par[par[j]];j=par[j]
  return j
 for e in d['zero_free_indices']:
  c=rep(U[e])>>len(F)
  if not c:loops.append(e);continue
  if e in C:continue
  while c:
   k=(c&-c).bit_length()-1;c&=c-1;b=C[k];all_edges+=1
   x,y=find(e),find(b)
   if x!=y:par[x]=y;forest.append([b,e])
 groups={}
 for e in d['zero_free_indices']:
  if e not in loops:groups.setdefault(find(e),[]).append(e)
 groups=[dict(indices=sorted(g),rank=sum(j in C for j in g)) for g in groups.values()];groups.sort(key=lambda g:g['indices'][0])
 assert len(forest)==sum(len(g['indices'])-1 for g in groups)
 owners=[];owner_edges=[]
 for b,chosen in zip(d['owner_bins'],support['owner_indices']):
  a=b['candidate_indices'];assert chosen in a;owners.append(list(a));owner_edges.extend([chosen,e] for e in a if e!=chosen)
 return dict(base_indices=support['selected_indices'],zero_basis=B,forced_zero_indices=F,zero_components=groups,zero_loops=loops,zero_forest_edges=forest,owner_bins=owners,owner_star_edges=owner_edges,fundamental_edges=all_edges,affine_dimension=len(forest)+len(owner_edges))

def edge_rows(records,patterns,n=720):
 for m in sorted(patterns,key=lambda m:(m.bit_count(),m)):
  r=records[m];blocks=[0]+[i+1 for i in range(4) if m>>i&1]
  for b,e in r['zero_forest_edges']+r['owner_star_edges']:
   yield {n*i+e:Q(1) for i in blocks}|{n*i+b:Q(-1) for i in blocks}

def gf2rank(rows):
 piv={}
 for r in rows:
  v=sum(1<<j for j,c in r.items() if int(c)%2)
  while v:
   p=v.bit_length()-1
   if p in piv:v^=piv[p]
   else:piv[p]=v;break
 return len(piv)

def sparse_exact(rows,n,cap=40):
 started=time.monotonic();piv={};maxwidth=0
 for k,r in enumerate(rows):
  r=dict(r)
  while r:
   p=max(r)
   if p not in piv:
    a=r[p];r={j:v/a for j,v in r.items()};piv[p]=r;maxwidth=max(maxwidth,len(r));break
   a=r[p]
   for j,v in piv[p].items():
    x=r.get(j,Q(0))-a*v
    if x:r[j]=x
    elif j in r:del r[j]
  if time.monotonic()-started>cap:raise TimeoutError(f'exact affine elimination exceeded {cap}s at row{k}, rank{len(piv)}')
 free=[j for j in range(n) if j not in piv];null=[]
 for f in free:
  v={f:Q(1)}
  for p in sorted(piv):
   z=-sum(a*v.get(j,Q(0)) for j,a in piv[p].items() if j!=p)
   if z:v[p]=z
  null.append(v)
 return dict(rank=len(piv),nullity=len(free),free_indices=free,nullspace=null,max_pivot_width=maxwidth,elapsed_seconds=time.monotonic()-started)

def sector_target(point,xx,zz,side):
 from verify_full_partner_projection import point_data
 from verify_two_sided_anchor_count import columns
 owner,_=point_data(point,32);full=[Q(1) if j is None else owner[j] for j in columns(xx,zz)];s=int(side=='Z')
 ids=[11+720*s+j for j in range(720)]+[1451+1440*k+720*s+j for k in range(4) for j in range(720)]
 return [full[j] for j in ids]

def null_tests(nulls,records,patterns,lam,target):
 out=[]
 for v in nulls:
  h=[]
  for m,r in enumerate(records):
   blocks=[0]+[i+1 for i in range(4) if m>>i&1]
   h.append(sum(v.get(720*i+j,Q(0)) for i in blocks for j in r['base_indices']))
  left=sum(c*target[j] for j,c in v.items());right=sum(l*h0 for l,h0 in zip(lam,h));out.append(dict(coefficients={str(j):str(c) for j,c in v.items()},pattern_base_values=list(map(str,h)),target_value=str(left),lambda_base_value=str(right),residual=str(left-right)))
 return out

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--lambda-seed',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();seed=json.loads(a.lambda_seed.read_text());xx,zz=seed['X_anchors'],seed['Z_anchors'];lam=list(map(Q,seed['lambda_masses']));assert len(lam)==16 and min(lam)>=0 and sum(lam)==1 and seed['point_sha256']==sha(a.point)
 O=TwoSidedFullBasisOracle();D=O.prepare(xx,zz);assert all(d['status']=='FULL_TWO_SIDED_BASIS_DOMAIN' for d in D);S=[O.support_pattern(d,[0]*1440) for d in D];result=dict(status='COMPLETE_PHYSICAL_AFFINE_GENERATORS_CANDIDATE',X_anchors=xx,Z_anchors=zz,point_sha256=sha(a.point),lambda_seed_sha256=sha(a.lambda_seed),lambda_masses=list(map(str,lam)),source_hashes={p:sha(ROOT/p) for p in ['two_sided_full_basis_oracle.py','pools/xcoords.txt','pools/zcoords.txt','physical-pool-source.json']},producer_sha256=sha(__file__),sectors={},scope='Affine hull only; not inequalities, rank-polytope membership, or source feasibility.')
 for side,U in [('X',O.X),('Z',O.Z)]:
  records=[components(U,d[side],s[side+'_support']) for d,s in zip(D,S)];target=sector_target(a.point,xx,zz,side);reports={}
  for label,patterns in [('all_patterns',list(range(16))),('positive_lambda_patterns',[m for m,l in enumerate(lam) if l])]:
   rows=list(edge_rows(records,patterns));low=gf2rank(rows);report=dict(patterns=patterns,generator_count=len(rows),GF2_rank_lower_bound=low)
   try:
    exact=sparse_exact(rows,3600);null=exact.pop('nullspace');checks=null_tests(null,records,patterns,lam,target);report.update(exact,annihilator_tests=checks,target_residual_count=sum(Q(r['residual'])!=0 for r in checks));assert all(sum(c*v.get(j,0) for j,c in row.items())==0 for v in null for row in rows);assert low<=report['rank']
   except TimeoutError as e:report['exact_elimination_timeout']=str(e)
   reports[label]=report;print(side,label,{k:v for k,v in report.items() if k!='annihilator_tests'},flush=True)
  result['sectors'][side]=dict(patterns=records,spans=reports)
 a.output.write_text(json.dumps(result,indent=2)+'\n')
if __name__=='__main__':main()
