#!/usr/bin/env python3
"""Independent binary and literal-polynomial consumer of the tensor certificate."""
import argparse
from itertools import combinations
import hashlib,json,math
from pathlib import Path

P=16;MASK=65535

def rank(rows):
 piv={}
 for v in rows:
  while v:
   p=(v&-v).bit_length()-1
   if p not in piv:piv[p]=v;break
   v^=piv[p]
 return len(piv)

def conv(a,b):
 answer=0
 for i in range(16):
  if a>>i&1:
   for j in range(16):
    if b>>j&1:answer^=1<<((i+j)%16)
 return answer

def product(x,y):
 a,b=x;c,d=y
 return (conv(a,c)^conv(b,d),conv(a,d)^conv(b,c)^conv(b,d))
def plus(x,y):return tuple(a^b for a,b in zip(x,y))
def phase(x,h):return tuple(sum(((v>>i)&1)<<((i+h)%16) for i in range(16)) for v in x)
def packed(v):return sum(w<<(16*i) for i,w in enumerate(w for s in v for w in s))
def unpacked(v):return [(v>>(32*i)&MASK,v>>(32*i+16)&MASK) for i in range(4)]
def simple(left,right):return [product(left[0],right[0]),product(left[1],right[0]),product(left[0],right[1]),product(left[1],right[1])]
def columns(A):
 return [sum(phase((A[i][b],0),h)[0]<<(16*i) for i in range(8)) for b in range(8) for h in range(16)]
def linear(cols,v):
 out=0
 for i,c in enumerate(cols):
  if v>>i&1:out^=c
 return out

def jet(v,j):
 return sum(sum((sum((w>>h&1)*math.comb(h,k) for h in range(k,16))%2)<<k for k in range(j))<<(j*i) for i,w in enumerate(w for s in v for w in s))

def verify(data,root):
 actual={s:[int(v,16) for v in (root/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']}
 for s in ['x','z']:assert hashlib.sha256((root/f'pools/{s}coords.txt').read_bytes()).hexdigest()==data['source_hashes'][s]
 C=columns(data['tensor']['binary_ring_coordinate_change']);D=columns(data['tensor']['dual_coordinate_change']);assert rank(C)==rank(D)==128
 assert all((c&d).bit_count()%2==(i==j) for i,c in enumerate(C) for j,d in enumerate(D))
 SX=[unpacked(linear(C,v)) for v in actual['x']];SZ=[]
 for v in actual['z']:
  z=unpacked(linear(D,v));SZ.append([(a^b,a) for a,b in z])
 freeze=lambda v:tuple(map(tuple,v))
 assert list(map(freeze,SX))==list(map(freeze,data['tensor']['X_tensor_coordinates']))
 assert list(map(freeze,SZ))==list(map(freeze,data['tensor']['Z_tensor_coordinates']))
 for v in SX+SZ:
  assert plus(product(v[0],v[3]),product(v[1],v[2]))==(0,0)
  assert any(a.bit_count()%2 or b.bit_count()%2 for a,b in v)
 # Check the trace convention on every coefficient basis pair.
 for i in range(32):
  x=(1<<i,0) if i<16 else (0,1<<(i-16))
  for j in range(32):
   z=(1<<j,0) if j<16 else (0,1<<(j-16));zs=tuple(sum(((w>>h)&1)<<((-h)%16) for h in range(16)) for w in z)
   val=product(x,zs)[1]&1;expected=((x[0]&z[1]).bit_count()+(x[1]&(z[0]^z[1])).bit_count())%2;assert val==expected
 # This binary replay covers all720x720 logical pairings.
 sxpacked=list(map(packed,SX));szcov=[packed([(b,a^b) for a,b in v]) for v in SZ]
 assert all((x&z).bit_count()%2==(xx&zz).bit_count()%2 for x,xx in zip(actual['x'],sxpacked) for z,zz in zip(actual['z'],szcov))
 dictionary=data['dictionary'];maps={};normal={}
 for side in ['X','Z']:
  source=SX if side=='X' else SZ;lookup={freeze(v):i for i,v in enumerate(source)};assert len(lookup)==720;seen=set();mapping=[]
  for a in range(9):
   for c in range(5):
    for h in range(16):
     v=simple([phase(v,h) for v in dictionary['X_left_dictionary'][a]],dictionary['X_right_factors'][c]) if side=='X' else simple(dictionary['Z_left_factors'][c],[phase(v,h) for v in dictionary['Z_right_dictionary'][a]])
     key=freeze(v);assert key in lookup and key not in seen;seen.add(key);mapping.append((lookup[key],a,c,h))
  assert len(seen)==720;maps[side]=mapping
 # Independent thin-module and type-rank checks.
 for side in ['X','Z']:
  U=dictionary['X_left_dictionary'] if side=='X' else dictionary['Z_right_dictionary'];B=dictionary['X_right_factors'] if side=='X' else dictionary['Z_left_factors'];q=data['span_constraints']['thin_factors'][side]['trace_functional_q']
  assert any(a.bit_count()%2 or b.bit_count()%2 for a,b in q)
  for b in B:
   tr=plus(product(q[0],b[0]),product(q[1],b[1]))[1];assert jet([(0,tr)],3)>>3==0
  assert rank(packed([phase(v,h) for v in b]) for b in B for h in range(16))==61
  W=[];L=[];M=[];E=[]
  for u in U:
   l=[[phase(v,h) for v in u] for h in range(16)];m=l+[[product((0,1),v) for v in row] for row in l];L.append(list(map(packed,l)));M.append(list(map(packed,m)));E.append([packed([product((15,0),v) for v in row]) for row in m]);W.append([packed(simple(u,[phase(v,h) for v in b])) for b in B for h in range(16)])
  observed=[]
  for subset in range(512):
   ids=[i for i in range(9) if subset>>i&1];r=rank(v for i in ids for v in W[i]);assert r==rank(v for i in ids for v in M[i])+rank(v for i in ids for v in L[i]+E[i]);assert (r==128)==(rank(jet(U[i],1) for i in ids)==4);observed.append(r)
  assert observed==data['span_constraints']['type_spans'][side]['type_rank_profile'];normal[side]=observed
 # Positive partial-frame control: map its independently stored physical supports.
 from audit_pools import exchange
 from verify_partial_frame import mask,shift
 source=json.loads((root/'physical-pool-source.json').read_text());zp=[shift(mask(v),h) for v in source['Z_orbit_representatives'] for h in range(16)];xp=[exchange(v) for v in zp];xi={v:i for i,v in enumerate(xp)};zi={v:i for i,v in enumerate(zp)};counts={'X':[0]*9,'Z':[0]*9};types={s:{i:a for i,a,c,h in maps[s]} for s in maps}
 for pair in json.loads((root/'partial-frame-88.json').read_text())['pairs']:
  counts['X'][types['X'][xi[mask(pair['X'])]]]+=1;counts['Z'][types['Z'][zi[mask(pair['Z'])]]]+=1
 for side in ['X','Z']:
  for subset in range(512):assert sum(n for i,n in enumerate(counts[side]) if subset>>i&1)<=normal[side][subset]
 # The field operator gives the inverse identity K^2+K+I=0 in every full basis.
 O=columns(dictionary['Omega_original_coordinates']);assert all(linear(O,linear(O,1<<i))^linear(O,1<<i)^(1<<i)==0 for i in range(128))
 for i in range(128):assert sum(((O[j]>>i)&1)*((O[i]>>j)&1) for j in range(128) if i!=j)%2==1
 return {'status':'PASS','exact_coordinate_basis_checks':16384,'pool_determinants_checked':1440,'full_pool_pairings_checked':518400,'complete_cartesian_pool_equality':True,'type_subsets_checked':1024,'partial88_rank_constraints':'PASS','field_operator_inverse_identity':'PASS','source_question_answered':False}

if __name__=='__main__':
 ap=argparse.ArgumentParser();ap.add_argument('certificate',type=Path);ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();result=verify(json.loads(args.certificate.read_text()),Path(__file__).parent);args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))
