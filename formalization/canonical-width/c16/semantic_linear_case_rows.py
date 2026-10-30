#!/usr/bin/env python3
"""Exact named-row reconstruction for the zero-margin C16 linear case model.

No CVXPY or floating canonical A is imported by build(). Existing source-bank
consumers provide integer rows. This is a semantic subset/equality compiler;
source and auxiliary profile variables all have justified bounds0..1.
"""
from pathlib import Path
from collections import Counter
import gzip,json,hashlib
import numpy as np
from scipy.sparse import coo_matrix
from certify_profile_moment_point import layout,equalities
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);b=p.read_bytes();return json.loads(gzip.decompress(b)if p.suffix=='.gz'else b)
def options(command):
 out={};i=3
 while i<len(command):
  k=command[i];assert k.startswith('--');i+=1;j=i
  while j<len(command)and not command[j].startswith('--'):j+=1
  out[k]=command[i:j];i=j
 return out

def integer(v):
 assert not isinstance(v,(bool,np.bool_))
 n=int(v);assert n==v
 return n

class Rows:
 def __init__(self,n):self.n=n;self.ii=[];self.jj=[];self.vv=[];self.rhs=[];self.families=[];self.divisors=[]
 def add(self,family,terms,rhs=0,divisor=1):
  c=Counter()
  for j,v in terms:c[int(j)]+=integer(v)
  k=len(self.rhs)
  for j,v in sorted(c.items()):
   if v:assert 0<=j<self.n and -(1<<63)<v<(1<<63);self.ii.append(k);self.jj.append(j);self.vv.append(v)
  self.rhs.append(integer(rhs));self.families.append(family);self.divisors.append(integer(divisor));assert divisor>0
 def matrix(self):return coo_matrix((np.array(self.vv,dtype=np.int64),(self.ii,self.jj)),shape=(len(self.rhs),self.n)).tocsr()

def build(frozen_path,dense_banks=(),dense_replays=()):
 frozen=read(frozen_path);assert frozen['mode']=='necessary_zero_margin'
 assert all(v==0 for v in frozen['effective_margins'].values())
 sources=dict(frozen['input_and_source_hashes'])
 assert all(sha(ROOT/p)==h for p,h in sources.items())
 command=frozen['command'];assert command[2]=='export_linear_case_model.py';a=options(command);paths=lambda key:list(map(Path,a[key]))
 assert '--certificate-margin'not in a
 for flag in ['--psd-interior-epsilon','--boolean-margin','--projected-margin']:assert a[flag]and float(a[flag][0])==0
 assert not a.get('--conditional-capacity') and not a.get('--conditional-nogoods'),'Unsupported optional family must be explicitly added, never silently dropped.'
 hull=read(a['--hulls'][0]);assert hull['period']==16 and hull['mode']=='rank'
 assert [r['orbit']for r in hull['records']]==list(range(45))
 names,index,m=layout(hull);n=len(names)
 owner=[index['p',i]for i in range(45)]+[m(s,h,i,j)for s in 'ST'for h in range(9)for i in range(45)for j in range(45)]
 weighted=[read(p)for p in a.get('--conditional-linear-cuts',[])];zeros=set()
 for report in weighted:
  assert report['status']=='PASS'
  for r in report['cuts']:
   assert all(integer(c)==c for c in r['coefficients'])and integer(r['bound'])==r['bound']
   if r['bound']==0 and all(c>=0 for c in r['coefficients']):
    for h,c in enumerate(r['coefficients']):
     if c:
      i,j=r['anchor_orbit'],r['orbit'];s='S'if r['sector']=='X'else'T'
      if h>8:h,i,j=16-h,j,i
      zeros.add((s,h,i,j))
 E,erhs=equalities(hull,index,m,sorted(zeros));R=Rows(n)
 # Attribute nonnegativity precedes explicit constraints in numerical discovery;
 # order here is semantic, and exact duals refer to this versioned ordering.
 for key,j in index.items():
  if key[0]=='w':R.add('profile_nonnegative',[(j,-1)])
 for i in range(45):R.add('marginal_lower',[(index['p',i],-1)])
 for i in range(45):R.add('marginal_upper',[(index['p',i],1)],1)
 for h in range(9):
  for s in 'ST':
   for kind in range(4):
    for j in range(45):
     for i in range(45):
      x,pi,pj=m(s,h,i,j),index['p',i],index['p',j]
      terms=[(x,-1)]if kind==0 else [(x,1),(pi if kind==1 else pj,-1)]if kind in(1,2)else[(x,-1),(pi,1),(pj,1)]
      R.add('Boolean_pair_'+str(kind),terms,int(kind==3))
 if a.get('--capacity-cuts'):
  cap=read(a['--capacity-cuts'][0]);assert cap['status']=='PASS'and cap['orbits_checked']==45
  assert all(cap.get(k)is None for k in ['conditioned_on_anchor','conditioned_on_X_index','conditioned_on_X_absent'])
  assert [r['orbit']for r in cap['records']]==list(range(45))
  caps=[min(integer(r['full_frame_count_upper_bound']),11 if r['orbit']==12 else 16)for r in cap['records']]
  for s in 'ST':
   for j in range(45):
    for i in range(45):R.add('unconditional_capacity',[(m(s,h,i,j),1)for h in range(16)]+[(index['p',i],-caps[j])])
 if a.get('--conditional-matrix'):
  d=read(a['--conditional-matrix'][0]);assert d['status']=='PASS'and d.get('selected_quotient_sector','X')=='X';M=d['capacity_matrix'];assert len(M)==45 and all(len(r)==45 for r in M)
  for j in range(45):
   for i in range(45):R.add('selected_same_capacity',[(m('S',h,i,j),1)for h in range(16)]+[(index['p',i],-integer(M[i][j]))])
 X,Z=[[int(v,16)for v in (ROOT/f'pools/{s}coords.txt').read_text().split()]for s in ['x','z']]
 if a.get('--conditional-cross-matrix'):
  d=read(a['--conditional-cross-matrix'][0]);assert d['status']=='PASS'and d['selected_quotient_sector']=='Z';M=d['capacity_matrix'];assert len(M)==45 and all(len(r)==45 for r in M)
  for j in range(45):
   for i in range(45):R.add('selected_cross_zero_capacity',[(m('T',h,i,j),1)for h in range(16)if not (X[16*i]&Z[16*j+h]).bit_count()%2]+[(index['p',i],-integer(M[i][j]))])
 for report in weighted:
  for r in report['cuts']:
   i,j,s=r['anchor_orbit'],r['orbit'],'S'if r['sector']=='X'else'T'
   R.add('conditional_weighted_phase',[(m(s,h,i,j),c)for h,c in enumerate(r['coefficients'])]+[(index['p',i],-r['bound'])])
 def append(family,M,b=0,normalized=False):
  assert M.shape[1]in(18270,36495)
  for k in range(M.shape[0]):
   start,end=M.indptr[k:k+2];cols=M.indices[start:end];vals=M.data[start:end];rhs=integer(b if isinstance(b,int)else b[k])
   divisor=max([1,abs(rhs),*[abs(integer(v))for v in vals]])if normalized else 1
   R.add(family,[(owner[int(j)],integer(v))for j,v in zip(cols,vals)],rhs,divisor)
 from canonical_forbidden_moment_matrix import matrix as forbidden
 append('forbidden_profile',forbidden(paths('--forbidden-patterns'))[0])
 from verify_algebraic_model import physical
 from physical_owner_moment_matrix import matrix as ownership
 xx,zz,A=physical();assert xx==X and zz==Z;append('physical_owner',ownership(A)[0])
 rank_bank=read(ROOT/'moment-resumption-results/physical-rank-moment-bank.json');active=read(a['--active-cuts'][0]);assert active['status']=='VALID_ROW_SUBSET_SELECTED'
 assert all(sha(ROOT/p)==h for p,h in active['source_hashes'].items())
 from physical_circuit_moment_matrix import matrix as circuits
 C=circuits(rank_bank['physical_circuits'])[0];ids=active['active_indices']['circuit'];assert ids==sorted(set(ids))and all(0<=i<C.shape[0]for i in ids)
 if ids:append('selected_physical_circuit',C[ids])
 from physical_legacy_linear_moments import build as legacy
 L,b,*_=legacy(rank_bank['mapping']);ids=active['active_indices']['legacy'];assert ids==sorted(set(ids))and all(0<=i<L.shape[0]for i in ids)
 if ids:append('selected_legacy',L[ids],[b[i]for i in ids])
 from conditional_matroid_moment_matrix import matrix as matroid
 append('conditional_matroid',matroid(paths('--matroid-cuts'),paths('--matroid-replays'))[0])
 from complete_boolean_triples import matrix as triangles
 M,b,_=triangles(paths('--boolean-cuts'));append('selected_Boolean_triples',M,b)
 from projected_profile_moment_matrix import matrix as projected
 M,b,_=projected(paths('--projected-cuts'),paths('--projected-replays'));append('projected_profiles',M,b)
 from accepted_integer_coupling_rows import matrix as basis
 M,b,_=basis(paths('--basis-cuts'),paths('--basis-replays'));append('accepted_basis_and_integer',M,b,True)
 bridge=read(a['--case-bridge'][0]);replay=read(a['--case-replay'][0]);assert bridge['status']=='PASS_SELECTED_PAIR_MOMENT_BRIDGE'
 assert all(sha(ROOT/p)==h for p,h in bridge['source_hashes'].items())
 assert replay['status']=='PASS'and replay['bridge_sha256']==sha(a['--case-bridge'][0])and replay['consumer_sha256']==sha(ROOT/'verify_cover_case_moment_bridge.py')
 case=list(map(int,a['--case']));i,j,h=case;x,z=16*i,16*j+h;assert (X[x]&Z[z]).bit_count()&1
 images={(16*i+t,16*j+(h+t)%16)for t in range(16)}|{(16*j+(h+t)%16,16*i+t)for t in range(16)};orbit=len(images);assert orbit in(16,32)
 record=next(r for r in bridge['records']if r['case']==case);assert record['edge_orbit_size']==orbit
 R.add('selected_source_case_floor',[(m('T',h,i,j),-orbit)],-1,orbit)
 if dense_banks:
  from verify_dense_integer_forms import matrix as dense
  M,b,_=dense(dense_banks,dense_replays);append('dense_Boolean_integer',M,b)
  for p in [*dense_banks,*dense_replays]:sources[str(p)]=sha(p)
 assert all(sha(ROOT/p)==h for p,h in sources.items())
 return dict(E=E,e=erhs,A=R.matrix(),b=np.array(R.rhs,dtype=np.int64),families=R.families,divisors=R.divisors,names=names,owner_to_semantic=np.array(owner,dtype=np.int64),source_hashes=sources,case=case,case_orbit=orbit,all_variables_box=[0,1],scope='Exact necessary rows for the selected source case, with auxiliary independent profile weights. No PSD constraints are asserted here.')
