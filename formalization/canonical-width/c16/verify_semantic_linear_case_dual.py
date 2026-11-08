#!/usr/bin/env python3
"""Exact semantic Farkas consumer and numeric-row correspondence diagnostic.

Only rebuilt source-valid integer rows enter the exact contradiction check.
Floating canonical rows, solver status and dual values never establish proof.
"""
from pathlib import Path
from collections import Counter,defaultdict,deque
from itertools import product
import argparse,ast,hashlib,json,math,time
import numpy as np
from scipy.sparse import load_npz,save_npz
from semantic_linear_case_rows import ROOT,build,read,sha,options

def digest_matrix(M,b):
 d=hashlib.sha256();d.update(str(M.shape).encode());d.update(np.asarray(M.indptr,dtype='<i8').tobytes());d.update(np.asarray(M.indices,dtype='<i8').tobytes());d.update(np.asarray(M.data,dtype='<i8').tobytes());d.update(np.asarray(b,dtype='<i8').tobytes());return d.hexdigest()

def semantic_digest(model):
 payload=dict(equalities=digest_matrix(model['E'],model['e']),inequalities=digest_matrix(model['A'],model['b']),names_sha256=hashlib.sha256(json.dumps(model['names'],separators=(',',':')).encode()).hexdigest(),case=model['case'],source_hashes=model['source_hashes'])
 return hashlib.sha256(json.dumps(payload,sort_keys=True,separators=(',',':')).encode()).hexdigest(),payload

def closure(path,found):
 path=Path(path).resolve()
 if path in found:return
 found.add(path)
 for node in ast.walk(ast.parse(path.read_text())):
  modules=[node.module]if isinstance(node,ast.ImportFrom)else[a.name for a in node.names]if isinstance(node,ast.Import)else[]
  for name in modules:
   p=ROOT/((name or '').split('.')[0]+'.py')
   if p.exists():closure(p,found)

def normalize_row(indices,coeffs,rhs):
 vals=[int(v)for v in coeffs];b=int(rhs);g=math.gcd(*[abs(v)for v in [*vals,b]])or 1
 sign=next((1 if v>0 else-1 for v in [*vals,b]if v),1)
 return (tuple(zip(map(int,indices),(sign*v//g for v in vals))),sign*b//g),sign*g

def correspondence(model,prefix):
 prefix=Path(prefix);report=read(str(prefix)+'.json');data=np.load(str(prefix)+'.linear-data.npz');numeric=load_npz(str(prefix)+'.linear-A.npz').tocsr();numeric.sum_duplicates();numeric.eliminate_zeros();numeric.sort_indices();rhs=data['rhs'];owner=data['owner_to_canonical'];n=len(model['names']);zc=model['E'].shape[0]
 assert report['status']=='EXPORTED_NUMERIC_LINEAR_NECESSARY_CASE_MODEL'
 assert report['zero_artificial_margins']and report['case_condition']['case']==model['case']
 assert numeric.shape==(zc+model['A'].shape[0],n) and report['equalities']==zc
 # Build a candidate bijection, then certify it against EVERY exact equality.
 # Moment map is independently given by the explicit owner indexing. Profile
 # columns occupy the remaining slots, in source-record order; no warm-value
 # match is used as a substitute for checking the actual equations.
 to_can=np.full(n,-1,dtype=np.int64)
 for s,c in zip(model['owner_to_semantic'],owner):
  assert to_can[s]in(-1,c);to_can[s]=c
 unknown=np.flatnonzero(to_can<0);free=sorted(set(range(n))-set(map(int,owner)))
 assert all(model['names'][i][0]=='w'for i in unknown)and len(unknown)==len(free)
 to_can[unknown]=free;assert sorted(to_can.tolist())==list(range(n))
 to_sem=np.empty(n,dtype=np.int64);to_sem[to_can]=np.arange(n)
 NE=numeric[:zc].copy();assert np.array_equal(NE.data,np.rint(NE.data))and np.array_equal(rhs[:zc],np.rint(rhs[:zc]))
 NE.indices=to_sem[NE.indices];NE.sort_indices()
 lookup=defaultdict(deque)
 for i in range(zc):
  l,r=model['E'].indptr[i:i+2];key,factor=normalize_row(model['E'].indices[l:r],model['E'].data[l:r],model['e'][i]);lookup[key].append((i,factor))
 eqmap=[];eqnum=[];eqden=[]
 for i in range(zc):
  l,r=NE.indptr[i:i+2];key,factor=normalize_row(NE.indices[l:r],NE.data[l:r],rhs[i]);assert lookup[key],('semantic equality mismatch',i)
  j,other=lookup[key].popleft();eqmap.append(j);g=math.gcd(abs(factor),abs(other));eqnum.append(factor//g);eqden.append(other//g)
 assert not any(lookup.values())
 # Inequality ordering is checked coefficient-by-coefficient after mapping.
 # Divisors are the positive numerical normalizations of exact named rows.
 S=model['A'].copy();S.indices=to_can[S.indices];S.sort_indices();C=numeric[zc:]
 inv=np.array([1/float(v)for v in model['divisors']]);expected=S.astype(float).multiply(inv[:,None]).tocsr();expected.sort_indices()
 delta=(C-expected).tocsr();delta.eliminate_zeros();err=float(max(abs(delta.data),default=0));berr=float(max(abs(rhs[zc:]-model['b']*inv),default=0))
 assert err<=2e-12 and berr<=2e-12,('numeric row correspondence mismatch',err,berr)
 # Every unnormalized integer family must match bit-for-bit. Numerical
 # normalized rows remain guidance only; their source rows were built exactly.
 ordinary=np.array(model['divisors'])==1;D=(C[ordinary]-S[ordinary]).tocsr();D.eliminate_zeros();assert D.nnz==0 and np.array_equal(rhs[zc:][ordinary],model['b'][ordinary])
 return dict(semantic_to_canonical=to_can,canonical_to_semantic=to_sem,equality_to_semantic=np.array(eqmap,dtype=np.int64),equality_scale_numerator=np.array(eqnum,dtype=np.int64),equality_scale_denominator=np.array(eqden,dtype=np.int64),inequality_to_semantic=np.arange(model['A'].shape[0],dtype=np.int64),inequality_divisor=np.array(model['divisors'],dtype=np.int64)),dict(status='PASS_COMPLETE_NUMERIC_ROW_CORRESPONDENCE',variables=n,profile_variables=len(unknown),moment_variables=n-len(unknown),equalities_exact=zc,inequalities=model['A'].shape[0],unnormalized_rows_bit_identical=int(sum(ordinary)),max_normalized_coefficient_error=err,max_normalized_rhs_error=berr,numeric_data_sha256=sha(str(prefix)+'.linear-data.npz'),numeric_matrix_sha256=sha(str(prefix)+'.linear-A.npz'),scope='This matches discovery coordinates to exact semantic rows. Floating normalized matrix entries remain excluded from exact certificate arithmetic.')

def nat(v):
 if type(v)is int:return v
 assert type(v)is str and str(int(v))==v
 return int(v)

def combine(model,certificate,expected_digest):
 assert certificate['schema']=='c16-semantic-linear-farkas-v1'
 assert certificate['semantic_digest']==expected_digest and certificate['case']==model['case']
 D=nat(certificate['denominator']);assert D>0
 coeff=[0]*len(model['names']);right=0;used={}
 for name,M,b,nonnegative in [('equality_terms',model['E'],model['e'],False),('inequality_terms',model['A'],model['b'],True)]:
  seen=set();terms=certificate[name];assert isinstance(terms,list)
  for term in terms:
   assert isinstance(term,list)and len(term)==2;j,w=term
   assert type(j)is int and 0<=j<M.shape[0]and j not in seen;seen.add(j);w=nat(w)
   assert not nonnegative or w>=0
   l,r=M.indptr[j:j+2]
   for k,v in zip(M.indices[l:r],M.data[l:r]):coeff[int(k)]+=w*int(v)
   right+=w*int(b[j])
  used[name]=len(terms)
 lower=sum(min(v,0)for v in coeff);gap=lower-right
 assert gap>0,('No strict exact contradiction',gap)
 return dict(status='PASS_EXACT_SELECTED_CASE_LINEAR_CONTRADICTION',denominator=str(D),combined_rhs_numerator=str(right),box_residual_lower_numerator=str(lower),strict_gap_numerator=str(gap),residual_nonzero_coordinates=sum(v!=0 for v in coeff),multipliers=used,source_C16_answered=False,selected_source_case_excluded=True,case=model['case'],scope='Exact contradiction for this selected-pair necessary model only. It does not by itself exclude the other cover cases or solve C16.')

def controls():
 # Residual correction equals the exact minimum over the whole unit box.
 total=0
 for c in product([-2,-1,0,1,2],repeat=4):
  assert sum(min(v,0)for v in c)==min(sum(a*b for a,b in zip(c,x))for x in product([0,1],repeat=4));total+=1
 from scipy.sparse import csr_matrix
 toy=dict(names=[('x',)],E=csr_matrix((0,1),dtype=np.int64),e=np.array([],dtype=np.int64),A=csr_matrix([[-2]],dtype=np.int64),b=np.array([-3],dtype=np.int64),case=[0,0,0])
 cert=dict(schema='c16-semantic-linear-farkas-v1',semantic_digest='toy',case=[0,0,0],denominator='7',equality_terms=[],inequality_terms=[[0,'1']])
 assert combine(toy,cert,'toy')['strict_gap_numerator']=='1'
 bad=0
 for patch in [dict(semantic_digest='wrong'),dict(denominator='0'),dict(inequality_terms=[[0,'-1']]),dict(inequality_terms=[[0,'0']]),dict(inequality_terms=[[0,'1'],[0,'1']]),dict(inequality_terms=[[1,'1']]),dict(denominator=1.0),dict(case=[1,0,0])]:
  try:combine(toy,{**cert,**patch},'toy')
  except (AssertionError,TypeError,ValueError):bad+=1
  else:raise AssertionError('invalid dual accepted')
 return dict(exhaustive_box_residual_controls=total,nonzero_residual_exact_contradiction_checked=True,corrupt_duals_rejected=bad)

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--frozen',type=Path,required=True);ap.add_argument('--numeric-prefix',type=Path);ap.add_argument('--dense-banks',type=Path,nargs='*',default=[]);ap.add_argument('--dense-replays',type=Path,nargs='*',default=[]);ap.add_argument('--certificate',type=Path);ap.add_argument('--write-prefix',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();model=build(a.frozen,a.dense_banks,a.dense_replays);digest,details=semantic_digest(model)
 import_paths=set();closure(Path(__file__),import_paths);hashes={str(p.relative_to(ROOT)):sha(p)for p in sorted(import_paths)}
 correspondence_report=None
 if a.numeric_prefix:
  assert not a.dense_banks,'Base canonical correspondence is separate from added dense rows.'
  mapping,correspondence_report=correspondence(model,a.numeric_prefix)
  if a.write_prefix:
   p=Path(str(a.write_prefix)+'.numeric-row-map.npz');assert not p.exists();np.savez_compressed(p,**mapping);correspondence_report['map_path']=str(p);correspondence_report['map_sha256']=sha(p)
 exports={}
 if a.write_prefix:
  for suffix,M in [('.equalities.npz',model['E']),('.inequalities.npz',model['A'])]:
   p=Path(str(a.write_prefix)+suffix);assert not p.exists();save_npz(p,M);exports[str(p)]=sha(p)
  p=Path(str(a.write_prefix)+'.rhs.npz');assert not p.exists();np.savez_compressed(p,equality_rhs=model['e'],inequality_rhs=model['b'],owner_to_semantic=model['owner_to_semantic']);exports[str(p)]=sha(p)
 exact=combine(model,read(a.certificate),digest)if a.certificate else None
 out=dict(status=exact['status']if exact else'PASS_EXACT_SEMANTIC_CASE_MODEL_CONSTRUCTION',source_C16_answered=False,selected_source_case_excluded=bool(exact),frozen_sha256=sha(a.frozen),consumer_sha256=sha(__file__),semantic_compiler_sha256=sha(ROOT/'semantic_linear_case_rows.py'),semantic_digest=digest,semantic_digest_components=details,source_hashes=model['source_hashes'],consumer_import_hashes=hashes,variables=len(model['names']),equalities=model['E'].shape[0],inequalities=model['A'].shape[0],inequality_families=dict(Counter(model['families'])),all_variables_box=[0,1],box_justification='p and S/T are Boolean moments. Each profile variable is nonnegative and its orbit distribution sums to1, so every profile variable is also<=1.',case=model['case'],true_case_floor='1/'+str(model['case_orbit']),numeric_correspondence=correspondence_report,control_results=controls(),exports=exports,exact_certificate=exact,certificate_sha256=sha(a.certificate)if a.certificate else None,seconds=time.monotonic()-start,scope=model['scope'],numeric_solver_run=False)
 assert all(sha(ROOT/p)==h for p,h in model['source_hashes'].items())and all(sha(ROOT/p)==h for p,h in hashes.items())
 a.output.write_text(json.dumps(out,indent=2,sort_keys=True)+'\n');print(a.output,sha(a.output),out['status'],out['seconds'])
if __name__=='__main__':main()
