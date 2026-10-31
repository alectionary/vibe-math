#!/usr/bin/env python3
"""Independent validity-only consumer for full-support Boolean integer forms.

No producer/compiler imports. Exact Boolean expansion plus a complete degree-two
32-action orbit check replaces exponential enumeration at support size1440.
"""
from pathlib import Path
from collections import Counter
from itertools import product
from copy import deepcopy
import argparse,hashlib,json,time,random
import numpy as np

ROOT=Path(__file__).resolve().parent
N=1440
OWNER=36495
PASS='PASS_DENSE_INTEGER_FORM_SOURCE_VALIDITY'

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(Path(p).read_text())

def coordinate(a,b):
 assert type(a)is int and type(b)is int and 0<=a<N and 0<=b<N
 sa,oa,ta=a//720,(a%720)//16,a%16
 sb,ob,tb=b//720,(b%720)//16,b%16
 h=(tb-ta)%16
 if h>8:h,oa,ob=16-h,ob,oa
 if h in (0,8) and oa>ob:oa,ob=ob,oa
 if sa==sb and h==0 and oa==ob:return oa
 return 45+(18225 if sa!=sb else 0)+2025*h+45*oa+ob

def representative(column):
 assert type(column)is int and 0<=column<OWNER
 if column<45:return 16*column,16*column
 family,rem=divmod(column-45,18225);h,rem=divmod(rem,2025);i,j=divmod(rem,45)
 return 16*i,720*family+16*j+h

def parameters(cut):
 e,w,c=cut['events'],cut['weights'],cut['constant']
 assert isinstance(e,list) and isinstance(w,list)
 assert 1<=len(e)<=N and len(w)==len(e) and len(set(e))==len(e)
 assert all(type(a)is int and 0<=a<N for a in e)
 assert all(type(v)is int for v in w) and type(c)is int
 return e,w,c

def compile_row(cut):
 e,w,c=parameters(cut);out=Counter()
 for i,(a,u) in enumerate(zip(e,w)):
  out[(a%720)//16]-=c*u+u*(u-1)//2
  for j in range(i):out[coordinate(e[j],a)]-=w[j]*u
 return dict(sorted((j,v)for j,v in out.items()if v)),c*(c-1)//2

def check_cut(cut):
 row,rhs=compile_row(cut)
 cols,vals=cut['owner_indices'],cut['owner_coefficients']
 assert isinstance(cols,list) and isinstance(vals,list) and len(cols)==len(vals)
 assert all(type(j)is int and 0<=j<OWNER for j in cols)
 assert cols==sorted(set(cols)) and all(type(v)is int and v!=0 for v in vals)
 assert type(cut['rhs'])is int
 assert list(row)==cols and list(row.values())==vals and rhs==cut['rhs']
 return row,rhs

def action(events,swap,shift):
 a=np.asarray(events,dtype=np.int64)
 return ((a//720+swap)%2)*720+((a%720)//16)*16+(a%16+shift)%16

def orbit_keys(a,b):
 a=np.asarray(a,dtype=np.int64);b=np.asarray(b,dtype=np.int64)
 out=np.full(a.shape,N*N,dtype=np.int64)
 for swap in (0,1):
  for shift in range(16):
   x,y=action(a,swap,shift),action(b,swap,shift)
   out=np.minimum(out,np.minimum(x,y)*N+np.maximum(x,y))
 return out

def mapping_controls():
 # All unordered pairs WITH diagonals: 1440*1441/2=1,037,520.
 a,b=np.triu_indices(N)
 columns=np.fromiter((coordinate(int(x),int(y))for x,y in zip(a,b)),dtype=np.int64,count=len(a))
 ra,rb=np.array([representative(j)for j in range(OWNER)],dtype=np.int64).T
 actual=orbit_keys(a,b);expected=orbit_keys(ra,rb)[columns]
 assert np.array_equal(actual,expected)
 # A finite group acts transitively on each orbit with equal stabilizer size.
 # Equal orbit keys therefore give equal full32-action monomial averages,
 # including multiplicities, not merely one matching transformed monomial.
 diagonal=(a==b);assert np.array_equal(columns[diagonal],np.arange(N)//16%45)
 return dict(unordered_monomials_checked=len(a),diagonals_checked=int(diagonal.sum()),distinct_pairs_checked=int((~diagonal).sum()),actions_per_monomial=32,canonical_orbit_labels_sha256=hashlib.sha256(actual.tobytes()).hexdigest(),mapping_sha256=hashlib.sha256(columns.tobytes()).hexdigest(),proof='Uniform finite-group orbit sums have equal stabilizer multiplicities. Equality of exact32-action orbit keys proves each physical monomial has the compiled representative average. Diagonals use I_a^2=I_a.')

def formal_binomial(weights,c):
 # Distributively multiply two affine polynomials, reducing Boolean squares.
 L={():c,**{(i,):v for i,v in enumerate(weights)}};out=Counter()
 for a,u in L.items():
  for b,v in L.items():out[tuple(sorted(set(a+b)))]+=u*v
 for a,u in L.items():out[a]-=u
 assert all(v%2==0 for v in out.values())
 return {a:v//2 for a,v in out.items()if v}

def tiny_controls():
 checks=polys=0
 for k in range(1,5):
  for weights in product([-2,-1,0,1,2],repeat=k):
   for c in [-2,-1,0,1,2]:
    p=formal_binomial(weights,c)
    expected={():c*(c-1)//2}
    expected.update({(i,):c*w+w*(w-1)//2 for i,w in enumerate(weights)})
    expected.update({(j,i):weights[j]*weights[i]for i in range(k)for j in range(i)})
    assert p=={a:v for a,v in expected.items()if v};polys+=1
    for bits in product([0,1],repeat=k):
     L=c+sum(w*b for w,b in zip(weights,bits));v=sum(coef*all(bits[i]for i in monomial)for monomial,coef in p.items())
     assert v==L*(L-1)//2>=0;checks+=1
 # A coefficient beyond machine range must remain exact in validity replay.
 huge=dict(events=[0,719,720,1439],weights=[1<<91,-(1<<87),3,-5],constant=1<<80)
 row,rhs=compile_row(huge);assert max(map(abs,[*row.values(),rhs]))>2**63
 return dict(exhaustive_integer_polynomials=polys,Boolean_assignments=checks,weights=[-2,-1,0,1,2],constants=[-2,-1,0,1,2],maximum_exhaustive_arity=4,arbitrary_precision_large_input_checked=True)

def literal_owner(bits):
 ra,rb=np.array([representative(j)for j in range(OWNER)],dtype=np.int64).T
 out=np.zeros(OWNER,dtype=np.int64)
 for swap in (0,1):
  for shift in range(16):out+=bits[action(ra,swap,shift)]*bits[action(rb,swap,shift)]
 return out

def literal_controls(cuts):
 rng=random.Random(202610301720)
 control=[dict(events=[0],weights=[-3],constant=2),dict(events=[0,719,720,1439],weights=[1<<91,-(1<<87),3,-5],constant=1<<80),dict(events=list(range(N)),weights=[(i*17)%11-5 for i in range(N)],constant=-3)]
 allcuts=control+cuts;rows=[compile_row(c)for c in allcuts];checks=0
 for probability in [0,1,.17,.5]:
  bits=np.array([int(rng.random()<probability)for _ in range(N)],dtype=np.int64)
  owner=literal_owner(bits)
  for c,(row,rhs)in zip(allcuts,rows):
   e,w,k=parameters(c);score=0
   for swap in (0,1):
    for shift in range(16):
     L=k+sum(v*int(bits[j])for v,j in zip(w,action(e,swap,shift)))
     score-=L*(L-1)//2
   assert sum(v*int(owner[j])for j,v in row.items())-32*rhs==score
   checks+=1
 return dict(assignments=4,polynomials=len(allcuts),full32_action_polynomial_checks=checks,full_support_and_large_integer_controls=True)

def corrupt_controls():
 base=dict(events=[0,17,733],weights=[2,-1,3],constant=2)
 row,rhs=compile_row(base);base.update(owner_indices=list(row),owner_coefficients=list(row.values()),rhs=rhs)
 mutations=[{'events':[0,0,733]},{'events':[-1,17,733]},{'events':[0,17,1440]},{'events':[],'weights':[]},{'weights':[1,2]},{'weights':[2.,-1,3]},{'constant':2.},{'constant':True},{'events':[False,17,733]},{'rhs':rhs+1},{'owner_indices':list(row)[::-1]},{'owner_coefficients':[v+1 for v in row.values()]},{'owner_coefficients':[float(v)for v in row.values()]},{'owner_indices':[True]+list(row)[1:]}]
 for patch in mutations:
  try:check_cut({**deepcopy(base),**patch})
  except (AssertionError,TypeError,ValueError):pass
  else:raise AssertionError(('corrupt input accepted',patch))
 return len(mutations)

def source_binding():
 receipt='moment-resumption-results/symmetry-bridge-independent.json';d=read(ROOT/receipt)
 assert d['status']=='PASS' and d['source_pool_ranks']==[128,128]
 assert d['consumer_sha256']==sha(ROOT/'verify_moment_symmetry_bridge.py')
 assert d['sector_pairing_comparisons']==d['phase_pairing_comparisons']==720*720
 for p,h in d['pool_sha256'].items():assert sha(ROOT/p)==h
 source=read(ROOT/'physical-pool-source.json');assert source['P']==16 and source['k']==128
 paths=[receipt,'verify_moment_symmetry_bridge.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']
 return {p:sha(ROOT/p)for p in paths}

def guard_sources(hashes):
 assert isinstance(hashes,dict)
 for p,h in hashes.items():assert sha(ROOT/p)==h,('changed source',p)

def matrix(banks,replays):
 from scipy.sparse import csr_matrix
 assert len(banks)==len(replays)
 ii=[];jj=[];vv=[];rhs=[];meta=[]
 for bp,rp in zip(banks,replays):
  bank=read(bp);receipt=read(rp)
  assert bank['status']=='DENSE_INTEGER_FORM_NUMERICAL_SCOUT'
  assert receipt['status']==PASS and receipt['validity_only'] is True
  assert receipt['bank_sha256']==sha(bp) and receipt['consumer_sha256']==sha(__file__)
  assert receipt['cuts_checked']==len(bank['cuts'])
  assert receipt['source_hashes']==bank.get('source_hashes',{})
  guard_sources(receipt['source_hashes']);guard_sources(receipt['verification_sources'])
  for k,cut in enumerate(bank['cuts']):
   row,b=check_cut(cut)
   assert all(-(1<<63)<=v<(1<<63)for v in [*row.values(),b]),'int64 matrix overflow'
   for j,v in row.items():ii.append(len(rhs));jj.append(j);vv.append(v)
   rhs.append(b);meta.append(dict(family='dense_physical_integer_form',bank_sha256=sha(bp),replay_sha256=sha(rp),cut_index=k,validity_only=True))
 return csr_matrix((np.array(vv,dtype=np.int64),(ii,jj)),shape=(len(rhs),OWNER)),np.array(rhs,dtype=np.int64),meta

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic()
 bindings=source_binding();bank=read(a.bank)if a.bank else None
 cuts=[] if bank is None else bank['cuts']
 if bank is not None:
  assert bank['status']=='DENSE_INTEGER_FORM_NUMERICAL_SCOUT' and isinstance(cuts,list)
  guard_sources(bank.get('source_hashes',{}))
 compiled=[check_cut(c)for c in cuts]
 mapping=mapping_controls();tiny=tiny_controls();literal=literal_controls(cuts);corrupt=corrupt_controls()
 out=dict(status=PASS if bank else 'PASS_DENSE_INTEGER_FORM_CONTROLS',source_C16_answered=False,source_anchor_excluded=False,validity_only=True,exact_target_separation_claimed=False,bank_sha256=sha(a.bank)if bank else None,consumer_sha256=sha(__file__),source_hashes=bank.get('source_hashes',{})if bank else {},verification_sources=bindings,cuts_checked=len(cuts),results=[dict(owner_nonzeros=len(row),rhs=str(rhs),matrix_int64_safe=all(-(1<<63)<=v<(1<<63)for v in [*row.values(),rhs]))for row,rhs in compiled],complete_monomial_mapping=mapping,exhaustive_tiny_controls=tiny,literal32_controls=literal,corrupt_inputs_rejected=corrupt,seconds=time.monotonic()-start,proof=['Every source selector is Boolean, so L=c+sum w_e I_e is integer and L(L-1)/2>=0.','Boolean reduction gives constant c(c-1)/2, diagonal coefficient c*w+w(w-1)/2, and distinct-pair coefficient w_a*w_b. The stored <= row is the negative nonconstant part.','The independently guarded physical symmetry group has32 actions. The complete monomial-orbit check proves that averaging each expanded term yields exactly the stored p/S/T owner coordinate.','No factor32 multiplies the averaged row. For a literal selector vector the sum of32 negative binomial evaluations equals row dot unnormalized-owner-sum minus32*RHS.'],scope='Universal full-support Boolean integer-form source validity only. Numeric scout gaps are not accepted as exact separation. No LP infeasibility, semantic dual, source-case exclusion or source frame is certified.')
 a.output.write_text(json.dumps(out,indent=2,sort_keys=True)+'\n');print(a.output,sha(a.output),out['status'],out['seconds'])
if __name__=='__main__':main()
