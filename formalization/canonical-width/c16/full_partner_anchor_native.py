"""Optional exact integer native batches; frozen Python oracle is the fallback.

NativeAnchorBatch(masks,anchor=80,orbit=32,library=...) prepares both states.
.branches lists feasible(mask,selected) rows, in mask order, False thenTrue.
.support_feasible(weights[n,720]) returns(values[n],bases[n,128]).
.price(coefficients1512) additionally constructs weights and branch constants
in C++ and returns a dict(values,full_values,bases), indexed by .branches.
Values are int64 when safe; overflow/rational inputs fall back to exact Python
object arrays. Bases are uint16 and retain the Python zero+owner ordering.
"""
from pathlib import Path
from fractions import Fraction
from numbers import Integral
import ctypes
import numpy as np
from full_partner_anchor_basis_oracle import FullPartnerAnchorBasisOracle
from full_partner_projection_features import candidate_weights,mask_score
ROOT=Path(__file__).resolve().parent
STATUS=['ANCHORED_FULL_PARTNER_BASIS_DOMAIN','EXCLUDED_DEPENDENT_SELECTED_X','EXCLUDED_DEFICIENT_ZERO_POOL','EXCLUDED_EMPTY_REQUIRED_OWNER','EXCLUDED_SELECTED_MULTIBIT_ANCHOR','EXCLUDED_SELECTED_ZERO_VECTOR','EXCLUDED_ANCHOR_DEFICIENT_ZERO_POOL','EXCLUDED_ANCHOR_EMPTY_OWNER_BIN']

def pointer(a,ctype):return a.ctypes.data_as(ctypes.POINTER(ctype))
def exact_array(values,shape):
 a=np.asarray(values);assert a.shape==shape
 if a.dtype.kind in 'iu':
  if a.size==0 or (int(a.min())>=-(1<<63) and int(a.max())<(1<<63)):return np.ascontiguousarray(a,dtype=np.int64),a
  return None,a.astype(object)
 if a.dtype.kind!='O':raise TypeError('exact integers or Fractions required')
 if not all(isinstance(x,(Integral,Fraction)) for x in a.flat):raise TypeError('exact integers or Fractions required')
 if all(isinstance(x,Integral) and -(1<<63)<=int(x)<(1<<63) for x in a.flat):return np.ascontiguousarray(a,dtype=np.int64),a
 return None,a

class NativeAnchorBatch:
 def __init__(self,masks=None,anchor=80,orbit=32,library=None,x_pool=None,z_pool=None,dimension=128,selected_sets=None):
  assert (x_pool is None)==(z_pool is None);self.dimension=dimension;assert 1<=dimension<=128
  if x_pool is None:x_pool,z_pool=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
  self.X=tuple(map(int,x_pool));self.Z=tuple(map(int,z_pool));assert 0<len(self.Z)<65536 and all(0<=v<1<<dimension for v in self.X+self.Z)
  self.anchor=int(anchor);self.orbit=orbit;assert 0<=self.anchor<len(self.Z)
  self.masks=None if masks is None else tuple(map(int,masks))
  if selected_sets is None:
   assert self.masks is not None and 0<=orbit and 16*orbit+16<=len(self.X) and all(0<=m<65536 for m in self.masks)
   selected_sets=[[16*orbit+h for h in range(16) if m>>h&1] for m in self.masks]
  else:assert masks is None
  self.selected_sets=[tuple(sorted(set(map(int,P)))) for P in selected_sets];assert self.selected_sets and all(len(P)<=128 and all(0<=i<len(self.X) for i in P) for P in self.selected_sets)
  self.context=None;self.lib=None;self.python=None;self.last_backend=None;self.native_error=None;N=len(self.selected_sets)
  path=Path(library) if library is not None else Path('/private/tmp/c16-anchor-native.dylib')
  if path.exists():
   try:
    lib=ctypes.CDLL(str(path));u=ctypes.c_uint64;i=ctypes.c_int;l=ctypes.c_int64;v=ctypes.c_void_p;p=lambda t:ctypes.POINTER(t)
    lib.c16_anchor_create.argtypes=[p(u),p(u),i,p(u),p(u),i,i,p(i),p(i),i,i];lib.c16_anchor_create.restype=v
    lib.c16_anchor_destroy.argtypes=[v];lib.c16_anchor_status.argtypes=[v,p(i)]
    lib.c16_anchor_feasible_batch.argtypes=[v,p(i),i,p(l),p(l),p(i)];lib.c16_anchor_feasible_batch.restype=i
    lib.c16_anchor_price.argtypes=[v,p(ctypes.c_uint16),i,p(l),p(i),p(l),p(l),p(i)];lib.c16_anchor_price.restype=i
    arrays=[np.array([a&((1<<64)-1) for a in pool],dtype=np.uint64) for pool in (self.X,self.Z)];high=[np.array([a>>64 for a in pool],dtype=np.uint64) for pool in (self.X,self.Z)]
    offsets=np.array([0,*np.cumsum([len(P) for P in self.selected_sets])],dtype=np.int32);indices=np.array([i for P in self.selected_sets for i in P],dtype=np.int32)
    self.context=lib.c16_anchor_create(pointer(arrays[0],u),pointer(high[0],u),len(self.X),pointer(arrays[1],u),pointer(high[1],u),len(self.Z),dimension,pointer(offsets,i),pointer(indices,i),N,self.anchor)
    if not self.context:raise RuntimeError('native preparation rejected')
    self.lib=lib;self.status=np.zeros(2*N,dtype=np.int32);lib.c16_anchor_status(self.context,pointer(self.status,i))
   except (OSError,AttributeError,RuntimeError) as e:self.native_error=str(e);self.context=None;self.lib=None
  if self.context is None:
   oracle=self._python();self.status=np.array([STATUS.index(oracle.prepare_selected(P,self.anchor,s)['status']) for P in self.selected_sets for s in (False,True)],dtype=np.int32)
  self.feasible_indices=np.flatnonzero(self.status==0).astype(np.int32)
  self.branches=[((self.masks[q//2] if self.masks is not None else self.selected_sets[q//2]),bool(q%2)) for q in self.feasible_indices]
 def _python(self):
  if self.python is None:self.python=FullPartnerAnchorBasisOracle(self.X,self.Z,self.dimension)
  return self.python
 def close(self):
  if self.context:self.lib.c16_anchor_destroy(self.context);self.context=None
 def __del__(self):
  if getattr(self,'context',None):self.close()
 def _python_support(self,w):
  oracle=self._python();values=[];bases=[]
  for q,row in zip(self.feasible_indices,w):
   d=oracle.prepare_selected(self.selected_sets[q//2],self.anchor,bool(q%2));r=oracle.support(d,row);values.append(r['value']);bases.append(r['selected_Z_indices'])
  self.last_backend='python_exact_fallback';return np.array(values,dtype=object),np.array(bases,dtype=np.uint16).reshape(len(values),self.dimension)
 def support_feasible(self,weights):
  n=len(self.feasible_indices);a,w=exact_array(weights,(n,len(self.Z)))
  if self.context is not None and a is not None:
   values=np.empty(n,dtype=np.int64);bases=np.empty((n,self.dimension),dtype=np.int32);error=self.lib.c16_anchor_feasible_batch(self.context,pointer(self.feasible_indices,ctypes.c_int),n,pointer(a,ctypes.c_int64),pointer(values,ctypes.c_int64),pointer(bases,ctypes.c_int))
   if error==0:self.last_backend='native_int64';return values,bases.astype(np.uint16)
   if error!=-2:raise RuntimeError('native support error '+str(error))
  return self._python_support(w)
 def price(self,coefficients):
  assert self.masks is not None and len(self.X)==len(self.Z)==720
  a,c=exact_array(coefficients,(1512,));N=len(self.masks)
  if self.context is not None and a is not None:
   statuses=np.empty(2*N,dtype=np.int32);values=np.empty(2*N,dtype=np.int64);full=np.empty(2*N,dtype=np.int64);bases=np.empty((2*N,self.dimension),dtype=np.int32);masks=np.array(self.masks,dtype=np.uint16)
   error=self.lib.c16_anchor_price(self.context,pointer(masks,ctypes.c_uint16),self.orbit,pointer(a,ctypes.c_int64),pointer(statuses,ctypes.c_int),pointer(values,ctypes.c_int64),pointer(full,ctypes.c_int64),pointer(bases,ctypes.c_int))
   if error==0:
    assert np.array_equal(statuses,self.status);q=self.feasible_indices;self.last_backend='native_int64';return dict(values=values[q],full_values=full[q],bases=bases[q].astype(np.uint16),backend=self.last_backend)
   if error!=-2:raise RuntimeError('native price error '+str(error))
  # Convert numpy integer scalars before fallback arithmetic: numpy may wrap
  # intermediate scalar sums even though the Python oracle itself is exact.
  c=[v if isinstance(v,Fraction) else int(v) for v in c]
  oracle=self._python();values=[];full=[];bases=[]
  for q in self.feasible_indices:
   mask=self.masks[q//2];state=int(q%2);w=[x+state*c[792+j] for j,x in enumerate(candidate_weights(mask,c[:775]))];r=oracle.support(oracle.prepare_selected(self.selected_sets[q//2],self.anchor,bool(state)),w);constant=mask_score(mask,c[:775])+state*(c[775]+sum(c[776+t] for t in range(16) if mask>>t&1));values.append(r['value']);full.append(r['value']+constant);bases.append(r['selected_Z_indices'])
  self.last_backend='python_exact_fallback';return dict(values=np.array(values,dtype=object),full_values=np.array(full,dtype=object),bases=np.array(bases,dtype=np.uint16).reshape(len(values),self.dimension),backend=self.last_backend)
