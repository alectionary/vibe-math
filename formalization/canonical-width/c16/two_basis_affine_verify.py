"""Independent physical replay of complete affine component certificates.

No import of the component producer. Low-pivot coordinate reconstruction,
fundamental-circuit/component completeness, exact integer rank sandwich, and
literal small-matroid controls establish the stated affine hull only.
"""
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations
import argparse,copy,hashlib,json,time
from verify_two_sided_full_basis_oracle import physical_source,domains,rank,target
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def coordinates(B):
 piv={}
 for i,x in enumerate(B):
  c=1<<i
  while x:
   p=(x&-x).bit_length()-1
   if p in piv:x^=piv[p][0];c^=piv[p][1]
   else:piv[p]=(x,c);break
  assert x
 def solve(x):
  c=0
  while x:
   p=(x&-x).bit_length()-1;assert p in piv
   y,z=piv[p];x^=y;c^=z
  return c
 return solve

def unionfind(items):
 p={j:j for j in items}
 def find(j):
  while p[j]!=j:p[j]=p[p[j]];j=p[j]
  return j
 def join(a,b):
  a,b=find(a),find(b)
  if a==b:return False
  p[a]=b;return True
 return find,join

def verify_record(U,V,d,r):
 B=r['base_indices'];assert len(B)==len(set(B))==128 and all(0<=j<len(U) for j in B) and rank(U[j] for j in B)==128
 assert set(d['forced'])<=set(B) and not set(d['absent'])&set(B)
 sig=[d['signatures'][j] for j in B];assert all(len(s)<=1 for s in sig) and all(sig.count((j,))==1 for j in d['opposite'])
 F=d['zero_forced'];Z=r['zero_basis'];assert len(Z)==len(set(Z))==d['zero_required'] and Z[:len(F)]==F and r['forced_zero_indices']==F and set(Z)<=set(B) and all(not d['signatures'][j] for j in Z)
 C=Z[len(F):];coord=coordinates([U[j] for j in Z]);cc={j:coord(U[j])>>len(F) for j in d['zero_free']};loops=sorted(j for j,c in cc.items() if c==0);assert r['zero_loops']==loops
 find,join=unionfind(j for j in d['zero_free'] if j not in loops)
 for b,e in r['zero_forest_edges']:
  assert b in C and e in cc and e not in C and cc[e]>>(C.index(b))&1
  assert join(b,e),'forest has cycle'
 # Every fundamental circuit must be internal to the claimed forest component.
 count=0
 for e,c in cc.items():
  if not c or e in C:continue
  for k,b in enumerate(C):
   if c>>k&1:assert find(b)==find(e);count+=1
 assert r['fundamental_edges']==count
 groups={}
 for j,c in cc.items():
  if c:groups.setdefault(find(j),[]).append(j)
 actual=sorted([dict(indices=sorted(g),rank=sum(j in C for j in g)) for g in groups.values()],key=lambda g:g['indices'][0]);assert actual==r['zero_components']
 assert len(r['zero_forest_edges'])==sum(len(g['indices'])-1 for g in actual)
 assert r['owner_bins']==d['bins'];owners=[]
 for choices in d['bins']:
  b=set(B)&set(choices);assert len(b)==1;b=next(iter(b));owners.extend([b,j] for j in choices if j!=b)
 assert owners==r['owner_star_edges'];assert r['affine_dimension']==len(r['zero_forest_edges'])+len(owners)
 return r['zero_forest_edges']+owners

def bitrank(vectors):
 piv={}
 for v in vectors:
  while v:
   i=(v&-v).bit_length()-1
   if i in piv:v^=piv[i]
   else:piv[i]=v;break
 return len(piv)

def check_span(r,records,all_edges,lam,b):
 patterns=r['patterns'];assert sorted(set(patterns))==patterns
 rows=[];bits=[]
 for m in patterns:
  blocks=[0]+[i+1 for i in range(4) if m>>i&1]
  for old,new in all_edges[m]:
   row={720*i+new:1 for i in blocks}|{720*i+old:-1 for i in blocks};rows.append(row);bits.append(sum(1<<j for j in row))
 assert r['generator_count']==len(rows);ranklow=bitrank(bits);assert r['GF2_rank_lower_bound']==ranklow
 nulls=[{int(j):Q(c) for j,c in a['coefficients'].items()} for a in r['annihilator_tests']];assert len(nulls)==r['nullity'];free=r['free_indices'];assert len(free)==len(nulls)
 for k,(v,a) in enumerate(zip(nulls,r['annihilator_tests'])):
  assert all(v.get(j,0)==int(h==k) for h,j in enumerate(free))
  assert all(sum(c*v.get(j,0) for j,c in row.items())==0 for row in rows)
  h=[sum(v.get(720*i+j,0) for i in [0]+[z+1 for z in range(4) if m>>z&1] for j in record['base_indices']) for m,record in enumerate(records)]
  left=sum(c*b[j] for j,c in v.items());right=sum(x*y for x,y in zip(lam,h));assert list(map(Q,a['pattern_base_values']))==h and Q(a['target_value'])==left and Q(a['lambda_base_value'])==right and Q(a['residual'])==left-right
 assert ranklow==3600-len(nulls)==r['rank'];assert r['target_residual_count']==sum(Q(a['residual'])!=0 for a in r['annihilator_tests'])
 return dict(rank=ranklow,nullity=len(nulls),target_residual_count=r['target_residual_count'],generators=len(rows),null_indicators_partition_coordinates=all(set(v.values())=={Q(1)} for v in nulls) and sorted(j for v in nulls for j in v)==list(range(3600)))

def tiny_controls():
 # Parallel classes, a 3-circuit, disconnected direct sums, loops from contraction.
 cohorts=[([1,1,2,2],[]),([1,2,3,4,4],[]),([1,2,3,4,5,6,7],[0]),([1,1,2,3],[0]),([1,2],[0,1]),([0,1,2,3],[])]
 summary=[]
 for U,F in cohorts:
  rr=rank(U);assert rank(U[j] for j in F)==len(F);bases=[list(B) for B in combinations(range(len(U)),rr) if set(F)<=set(B) and rank(U[j] for j in B)==rr];B=F+[j for j in bases[0] if j not in F];C=B[len(F):];coord=coordinates([U[j] for j in B]);free=[j for j in range(len(U)) if j not in F];cc={j:coord(U[j])>>len(F) for j in free};active=[j for j in free if cc[j]];find,join=unionfind(active);edges=[]
  for e in active:
   if e not in C:
    for k,b in enumerate(C):
     if cc[e]>>k&1:
      edges.append((b,e));join(b,e)
      assert rank(U[j] for j in [x for x in B if x!=b]+[e])==rr
  groups={}
  for j in active:groups.setdefault(find(j),[]).append(j)
  for T in bases:
   assert all(j not in T for j,c in cc.items() if not c)
   assert all(len(set(T)&set(g))==len(set(C)&set(g)) for g in groups.values())
  diffs=[]
  base=set(B)
  # In characteristic two this gives a rank lower bound; connected component
  # equalities give matching rational upper bound.
  for T in bases:diffs.append(sum(1<<j for j in base.symmetric_difference(T)))
  edge_rank=bitrank([(1<<b)|(1<<e) for b,e in edges]);expected=sum(len(g)-1 for g in groups.values());assert edge_rank==expected==bitrank(diffs)
  summary.append(dict(pool=U,forced=F,bases=len(bases),affine_dimension=expected,components=len(groups)))
 return summary

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--lambda-seed',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();started=time.monotonic();d=json.loads(a.certificate.read_text());assert d['status']=='COMPLETE_PHYSICAL_AFFINE_GENERATORS_CANDIDATE' and d['point_sha256']==sha(a.point) and d['lambda_seed_sha256']==sha(a.lambda_seed);assert all(sha(ROOT/p)==h for p,h in d['source_hashes'].items());assert d['producer_sha256']==sha(ROOT/'two_basis_affine_components.py');seed=json.loads(a.lambda_seed.read_text());lam=list(map(Q,d['lambda_masses']));assert lam==list(map(Q,seed['lambda_masses']));assert min(lam)>=0 and sum(lam)==1;xx,zz=d['X_anchors'],d['Z_anchors'];assert [xx,zz]==[seed['X_anchors'],seed['Z_anchors']];X,Z,physical=physical_source();DD=domains(X,Z,xx,zz);assert all(r['feasible'] for r in DD);fulltarget=target(a.point,xx,zz);report={};neg=[]
 for side,U,V in [('X',X,Z),('Z',Z,X)]:
  s=int(side=='Z');records=d['sectors'][side]['patterns'];assert len(records)==16;edges=[verify_record(U,V,dom[side],r) for dom,r in zip(DD,records)];b=[fulltarget[11+720*s+j] for j in range(720)]+[fulltarget[1451+1440*k+720*s+j] for k in range(4) for j in range(720)];report[side]={}
  for label,r in d['sectors'][side]['spans'].items():
   assert r['patterns']==(list(range(16)) if label=='all_patterns' else [m for m,l in enumerate(lam) if l]);report[side][label]=check_span(r,records,edges,lam,b)
  # Localized corruptions exercise physical and algebraic acceptance boundaries.
  bad=copy.deepcopy(records[0]);bad['zero_components'][0]['rank']+=1
  try:verify_record(U,V,DD[0][side],bad)
  except AssertionError:neg.append(side+'_wrong_component_rank')
  else:raise AssertionError('bad rank accepted')
  bad=copy.deepcopy(d['sectors'][side]['spans']['all_patterns']);v=bad['annihilator_tests'][0]['coefficients'];j=next(iter(v));v[j]=str(Q(v[j])+1)
  try:check_span(bad,records,edges,lam,b)
  except AssertionError:neg.append(side+'_wrong_annihilator')
  else:raise AssertionError('bad annihilator accepted')
 out=dict(status='PASS_EXACT_COMPLETE_SECTOR_AFFINE_SPANS',certificate_sha256=sha(a.certificate),point_sha256=sha(a.point),lambda_seed_sha256=sha(a.lambda_seed),consumer_sha256=sha(__file__),source_hashes=d['source_hashes'],consumer_dependencies={p:sha(ROOT/p) for p in ['verify_two_sided_full_basis_oracle.py','verify_algebraic_model.py']},sectors=report,physical=physical,tiny_controls=tiny_controls(),negative_controls_rejected=neg,elapsed_seconds=time.monotonic()-started,scope='Complete real affine spans for the declared conditional full-basis sector relaxation. No inequalities or target membership proved; no source case excluded.');a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out['sectors'],indent=2),flush=True)
if __name__=='__main__':main()
