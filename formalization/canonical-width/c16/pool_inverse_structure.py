#!/usr/bin/env python3
"""Exact cyclic-ring coordinates for the pool subspace arrangement.

No basis is assumed invariant: these are fixed ambient coordinate changes.
"""
import argparse
from itertools import combinations
import json
from pathlib import Path

P=16;MASK=(1<<P)-1

def add(a,b):return a^b

def mul(a,b):
 out=0
 while b:
  bit=b&-b;b^=bit;h=bit.bit_length()-1;out^=((a<<h)|(a>>(P-h)))&MASK
 return out

def parity(a):return a.bit_count()%2

def inverse(a):
 assert parity(a)==1
 result=1
 for _ in range(15):result=mul(result,a)
 assert mul(a,result)==1;return result

def ident(n):return [[int(i==j) for j in range(n)] for i in range(n)]
def matmul(A,B):return [[xor(mul(A[i][k],B[k][j]) for k in range(len(B))) for j in range(len(B[0]))] for i in range(len(A))]
def matvec(A,v):return [xor(mul(a,b) for a,b in zip(row,v)) for row in A]
def xor(values):
 out=0
 for v in values:out^=v
 return out

def matinv(A):
 n=len(A);M=[r.copy()+s for r,s in zip(A,ident(n))]
 for j in range(n):
  pivot=next(i for i in range(j,n) if parity(M[i][j]));M[j],M[pivot]=M[pivot],M[j];c=inverse(M[j][j]);M[j]=[mul(c,v) for v in M[j]]
  for i in range(n):
   if i!=j and M[i][j]:
    c=M[i][j];M[i]=[a^mul(c,b) for a,b in zip(M[i],M[j])]
 B=[r[n:] for r in M];assert matmul(A,B)==matmul(B,A)==ident(n);return B

def transpose(A):return list(map(list,zip(*A)))
def words(v):return [(v>>(P*b))&MASK for b in range(8)]
def pack(v):return sum(w<<(P*b) for b,w in enumerate(v))

def rank_binary(values):
 piv={}
 for v in values:
  while v:
   k=v.bit_length()-1
   if k not in piv:piv[k]=v;break
   v^=piv[k]
 return len(piv)

def independent_roots(ids,roots,n):
 selected=[];values=[]
 for a in ids:
  v=sum(parity(w)<<b for b,w in enumerate(roots[a]))
  if rank_binary(values+[v])>len(values):selected.append(a);values.append(v)
  if len(selected)==n:return selected
 raise AssertionError('Insufficient augmentation rank')

def ring_span_solve(matrices,target):
 # Solve sum s_i M_i=target, s_i in R, by literal binary linear algebra.
 piv={};count=P*len(matrices)
 for i,M in enumerate(matrices):
  for h in range(P):
   v=pack_flat([[mul(1<<h,w) for w in row] for row in M]);tag=1<<(P*i+h)
   while v:
    k=v.bit_length()-1
    if k not in piv:piv[k]=(v,tag);break
    u,t=piv[k];v^=u;tag^=t
 v=pack_flat(target);tag=0
 while v:
  k=v.bit_length()-1
  if k not in piv:return None
  u,t=piv[k];v^=u;tag^=t
 return [(tag>>(P*i))&MASK for i in range(len(matrices))]

def pack_flat(M):return sum(w<<(P*i) for i,w in enumerate(v for row in M for v in row))

def analyze(root):
 X=[int(v,16) for v in (root/'pools/xcoords.txt').read_text().split()];Z=[int(v,16) for v in (root/'pools/zcoords.txt').read_text().split()];source=json.loads((root/'physical-pool-source.json').read_text());groups=[[] for _ in range(5)];roots=[words(X[16*a]) for a in range(45)]
 for a,support in enumerate(source['Z_orbit_representatives']):
  columns={(q//32)%5 for q in support};assert len(columns)==1;groups[next(iter(columns))].append(a)
 chosen=independent_roots(groups[0],roots,4)+independent_roots(groups[3],roots,4);U=transpose([roots[a] for a in chosen]);Ui=matinv(U);coordinates=[matvec(Ui,v) for v in roots]
 for a in groups[0]:assert not any(coordinates[a][4:])
 for a in groups[3]:assert not any(coordinates[a][:4])
 graphs={}
 for c in [1,2,4]:
  selected=independent_roots(groups[c],coordinates,4);A=transpose([coordinates[a][:4] for a in selected]);B=transpose([coordinates[a][4:] for a in selected]);L=matmul(B,matinv(A));assert all(matvec(L,coordinates[a][:4])==coordinates[a][4:] for a in groups[c]);graphs[c]=L
 normalizer=matinv(graphs[4]);J={c:matmul(normalizer,L) for c,L in graphs.items()};I=ident(4)
 assert J[4]==I
 commutator=[[a^b for a,b in zip(r,s)] for r,s in zip(matmul(J[1],J[2]),matmul(J[2],J[1]))]
 result={'status':'EXACT_SUBSPACE_COORDINATES','groups':groups,'ambient_module_basis_orbits':chosen,'U':U,'U_inverse':Ui,'normalized_graphs':J,'graph_commutator_zero':not any(v for r in commutator for v in r),'J1_square_span_I_J1':ring_span_solve([I,J[1]],matmul(J[1],J[1])),'J2_span_I_J1':ring_span_solve([I,J[1]],J[2]),'root_coordinates':coordinates,'B_normalizer':normalizer}
 return result


def ring_valuation(a):
 # Multiplicity of t+1, including16 for zero.
 for j in range(16):
  if sum(((a>>h)&1)*int((h&j)==j) for h in range(16))%2:return j
 return 16


def smul(x,y):
 a,b=x;c,d=y;bd=mul(b,d)
 return (mul(a,c)^bd,mul(a,d)^mul(b,c)^bd)

def sadd(x,y):return tuple(a^b for a,b in zip(x,y))
def star(a):return sum(((a>>h)&1)<<((-h)%16) for h in range(16))
def adjoint(A):return [[star(v) for v in row] for row in transpose(A)]

def tensor_analysis(root,data):
 I=ident(4);J=data['normalized_graphs'][1];a,b=data['J1_square_span_I_J1'];assert parity(a)==parity(b)==1;bi=inverse(b);d=1^mul(a,mul(bi,bi));assert not parity(d)
 c=0;power=d
 for _ in range(4):c^=power;power=mul(power,power)
 assert mul(c,c)^c==d
 theta=[[mul(bi,J[i][j])^(c if i==j else 0) for j in range(4)] for i in range(4)]
 assert [[u^v^w for u,v,w in zip(r,s,t)] for r,s,t in zip(matmul(theta,theta),theta,I)]==[[0]*4 for _ in range(4)]
 chosen=[];values=[]
 for e in I:
  candidates=[e,matvec(theta,e)];aug=[sum(parity(w)<<b for b,w in enumerate(v)) for v in candidates]
  if rank_binary(values+aug)==len(values)+2:chosen+=candidates;values+=aug
  if len(chosen)==4:break
 assert len(chosen)==4;F=transpose(chosen);Fi=matinv(F)
 expected=[[0,1,0,0],[1,1,0,0],[0,0,0,1],[0,0,1,1]]
 assert matmul(matmul(Fi,theta),F)==expected
 normal=data['B_normalizer'];C=[[0]*8 for _ in range(8)]
 for i in range(4):
  for j in range(4):C[i][j]=Fi[i][j];C[i+4][j+4]=matmul(Fi,normal)[i][j]
 C=matmul(C,data['U_inverse']);Ci=matinv(C);Zmap=adjoint(Ci)
 X=[words(int(v,16)) for v in (root/'pools/xcoords.txt').read_text().split()];Z=[words(int(v,16)) for v in (root/'pools/zcoords.txt').read_text().split()]
 SX=[[tuple(matvec(C,v)[j:j+2]) for j in [0,2,4,6]] for v in X]
 # Translate coefficient dot product to the F4 trace product: (u,v) ->(u+v,u).
 SZ=[]
 for v in Z:
  w=matvec(Zmap,v);SZ.append([(w[j]^w[j+1],w[j]) for j in [0,2,4,6]])
 def determinant(v):return sadd(smul(v[0],v[3]),smul(v[1],v[2]))
 dx=[determinant(v) for v in SX];dz=[determinant(v) for v in SZ]
 scalars={}
 for k,L in data['normalized_graphs'].items():
  v=ring_span_solve([I,theta],L);assert v is not None;scalars[k]=v
 result={'status':'EXACT_F4_CYCLIC_COORDINATES','theta':theta,'theta_relation':'theta^2+theta+I=0','field_basis_matrix':F,'binary_ring_coordinate_change':C,'dual_coordinate_change':Zmap,'graph_slopes':scalars,'slope_difference_valuation':min(ring_valuation(v) for v in sadd(scalars[1],scalars[2])),'X_determinant_nonzero':sum(v!=(0,0) for v in dx),'Z_determinant_nonzero':sum(v!=(0,0) for v in dz),'X_tensor_coordinates':SX,'Z_tensor_coordinates':SZ,'X_nonzero_determinant_examples':[(i,v) for i,v in enumerate(dx) if v!=(0,0)][:5],'Z_nonzero_determinant_examples':[(i,v) for i,v in enumerate(dz) if v!=(0,0)][:5]}
 return result


def sunit(x):return bool(parity(x[0]) or parity(x[1]))
def sinverse(x):
 a,b=x;norm=mul(a,a)^mul(a,b)^mul(b,b);inv=inverse(norm);out=(mul(a^b,inv),mul(b,inv));assert smul(x,out)==(1,0);return out

def projective(v):
 a,b=v
 if sunit(a):return ((1,0),smul(b,sinverse(a)))
 assert sunit(b);return (smul(a,sinverse(b)),(1,0))

def factor_analysis(data,groups):
 X=data['X_tensor_coordinates'];Z=data['Z_tensor_coordinates'];records=[]
 for c,ids in enumerate(groups):
  xr=[X[16*a] for a in ids];zr=[Z[16*a] for a in ids]
  left=[projective((v[0],v[1])) if any(v[k]!=(0,0) for k in [0,1]) else projective((v[2],v[3])) for v in xr]
  zleft=[projective((v[0],v[1])) if sunit(v[0]) or sunit(v[1]) else projective((v[2],v[3])) for v in zr]
  zright=[projective((v[0],v[2])) if sunit(v[0]) or sunit(v[2]) else projective((v[1],v[3])) for v in zr]
  assert len(set(zleft))==1
  records.append({'group':c,'Z_fixed_left_line':zleft[0],'X_left_lines':left,'Z_right_lines':zright,'distinct_X_left_lines':len(set(left)),'distinct_Z_right_lines':len(set(zright))})
 return records


def rotate_s(x,h):return tuple(mul(1<<h,v) for v in x)
def canon_s(x):return min(rotate_s(x,h) for h in range(16))
def factor_scalar(v):
 p=projective(v)
 return p,(v[0] if p[0]==(1,0) else v[1])

def cartesian_analysis(data,groups):
 X=data['X_tensor_coordinates'];Z=data['Z_tensor_coordinates'];report={}
 for side in ['X','Z']:
  dictionaries=[]
  for ids in groups:
   table={}
   for a in ids:
    v=(X if side=='X' else Z)[16*a]
    if side=='X':u=(v[0],v[1]) if sunit(v[0]) or sunit(v[1]) else (v[2],v[3])
    else:u=(v[0],v[2]) if sunit(v[0]) or sunit(v[2]) else (v[1],v[3])
    line,s=factor_scalar(u);table.setdefault(line,set()).add(canon_s(s))
   dictionaries.append(table)
  assert all(set(d)==set(dictionaries[0]) for d in dictionaries)
  fixed=next(iter(dictionaries[0]));reference=next(iter(dictionaries[0][fixed]));scales=[]
  for table in dictionaries:
   possible=[]
   for value in table[fixed]:
    scale=smul(value,sinverse(reference));predicted={line:{canon_s(smul(scale,v)) for v in values} for line,values in dictionaries[0].items()}
    if predicted==table:possible.append(scale)
   scales.append(possible)
  report[side]={'group_scalar_equivalences':scales,'line_multiplicities':[[len(v) for v in d.values()] for d in dictionaries]}
 return report


def rank_one(left,right):
 return [smul(left[0],right[0]),smul(left[1],right[0]),smul(left[0],right[1]),smul(left[1],right[1])]

def tensor_dictionaries(data,groups):
 factors=factor_analysis(data,groups);cartesian=cartesian_analysis(data,groups);X=data['X_tensor_coordinates'];Z=data['Z_tensor_coordinates']
 left=[];right=[]
 for a in groups[0]:
  v=X[16*a];left.append([v[0],v[1]])
  w=Z[16*a];right.append([w[0],w[2]])
 X_fixed=[];Z_fixed=[]
 for c in range(5):
  assert len(cartesian['X']['group_scalar_equivalences'][c])==len(cartesian['Z']['group_scalar_equivalences'][c])==1
  sx=cartesian['X']['group_scalar_equivalences'][c][0];sz=cartesian['Z']['group_scalar_equivalences'][c][0]
  bx=[(1,0),(0,0)] if c==0 else [(0,0),(1,0)] if c==3 else [(1,0),tuple(data['graph_slopes'][c])]
  az=factors[c]['Z_fixed_left_line'];X_fixed.append([smul(sx,v) for v in bx]);Z_fixed.append([smul(sz,v) for v in az])
 def generate(side):
  out=[]
  for a in range(9):
   for c in range(5):
    for h in range(16):
     out.append(rank_one([rotate_s(v,h) for v in left[a]],X_fixed[c]) if side=='X' else rank_one(Z_fixed[c],[rotate_s(v,h) for v in right[a]]))
  return out
 for side,actual in [('X',X),('Z',Z)]:
  predicted=generate(side);freeze=lambda v:tuple(map(tuple,v));assert len(set(map(freeze,predicted)))==720 and set(map(freeze,predicted))==set(map(freeze,actual))
 # Irreducible scalar multiplication, transported to the original binary coordinates.
 theta8=[[int(i//2==j//2 and (i%2,j%2) in [(0,1),(1,0),(1,1)]) for j in range(8)] for i in range(8)]
 C=data['binary_ring_coordinate_change'];Omega=matmul(matmul(matinv(C),theta8),C)
 assert [[u^v^w for u,v,w in zip(r,s,t)] for r,s,t in zip(matmul(Omega,Omega),Omega,ident(8))]==[[0]*8 for _ in range(8)]
 return {'X_left_dictionary':left,'X_right_factors':X_fixed,'Z_left_factors':Z_fixed,'Z_right_dictionary':right,'Omega_original_coordinates':Omega,'complete_cartesian_pool_equality':True}


def epsilon_word(v):
 answer=0
 for h in range(16):
  if v>>h&1:
   k=h
   while True:
    answer^=1<<k
    if not k:break
    k=(k-1)&h
 return answer

def jet_pack(v,j):return sum((epsilon_word(w)&((1<<j)-1))<<(j*i) for i,w in enumerate(w for s in v for w in s))
def svec_pack(v):return sum(w<<(16*i) for i,w in enumerate(w for s in v for w in s))
def rvec(v):return [w for s in v for w in s]

def nullspace(rows,n):
 piv={}
 for v in rows:
  while v:
   k=v.bit_length()-1
   if k not in piv:piv[k]=v;break
   v^=piv[k]
 result=[]
 for k in range(n):
  if k in piv:continue
  v=1<<k
  for j in sorted(piv):
   if (piv[j]&v).bit_count()%2:v^=1<<j
  assert all((r&v).bit_count()%2==0 for r in rows);result.append(v)
 return result

def thin_factor(factors):
 j=3;columns=[]
 for i in range(4):
  for h in range(j):columns.append(sum((((epsilon_word(rvec(v)[i])<<h)&7))<<(3*k) for k,v in enumerate(factors)))
 rows=[sum(((v>>p)&1)<<k for k,v in enumerate(columns)) for p in range(15)];kernel=nullspace(rows,12);assert len(kernel)==3
 generator=next(v for v in kernel if any(v>>(3*i)&1 for i in range(4)))
 ell=[epsilon_word((generator>>(3*i))&7) for i in range(4)]
 q=[(ell[0]^ell[1],ell[0]),(ell[2]^ell[3],ell[2])]
 assert any(sunit(v) for v in q)
 for b in factors:
  trace=sadd(smul(q[0],b[0]),smul(q[1],b[1]))[1];assert epsilon_word(trace)&7==0
 span=[svec_pack([rotate_s(v,h) for v in b]) for b in factors for h in range(16)]
 rank=rank_binary(span);assert rank==61
 profiles=[rank_binary([jet_pack([rotate_s(v,h) for v in b],k) for b in factors for h in range(16)]) for k in range(1,17)]
 assert profiles==[4*k-min(k,3) for k in range(1,17)]
 return {'rank':rank,'quotient_dimension':3,'trace_functional_q':q,'module_normal_form':'R^3 direct_sum epsilon^3 R','jet_ranks':profiles}

def type_span_analysis(d):
 records={};thin={side:thin_factor(d['X_right_factors'] if side=='X' else d['Z_left_factors']) for side in ['X','Z']}
 for side in ['X','Z']:
  U=d['X_left_dictionary'] if side=='X' else d['Z_right_dictionary'];B=d['X_right_factors'] if side=='X' else d['Z_left_factors'];W=[];L=[];M=[];E=[];aug=[]
  for u in U:
   l=[[rotate_s(v,h) for v in u] for h in range(16)];m=l+[[smul((0,1),v) for v in row] for row in l]
   L.append(list(map(svec_pack,l)));M.append(list(map(svec_pack,m)));E.append([svec_pack([smul((15,0),v) for v in row]) for row in m]);aug.append(jet_pack(u,1))
   W.append([svec_pack(rank_one(u,[rotate_s(v,h) for v in b])) for b in B for h in range(16)])
  profile=[]
  for mask in range(512):
   ids=[a for a in range(9) if mask>>a&1];actual=rank_binary(v for a in ids for v in W[a]);predicted=rank_binary(v for a in ids for v in M[a])+rank_binary(v for a in ids for v in L[a]+E[a]);assert actual==predicted,(side,mask,actual,predicted)
   modrank=rank_binary(aug[a] for a in ids);assert (actual==128)==(modrank==4)
   profile.append(actual)
  records[side]={'type_rank_profile':profile,'augmentation_type_vectors':aug,'minimum_types_for_full_span':min(mask.bit_count() for mask,r in enumerate(profile) if r==128),'three_type_maximum':max(r for mask,r in enumerate(profile) if mask.bit_count()==3),'four_type_spanning_subsets':sum(r==128 and mask.bit_count()==4 for mask,r in enumerate(profile))}
 return {'thin_factors':thin,'type_spans':records,'subsets_independently_checked':1024,'source_question_answered':False}


def exchange_normal_form(tensor):
 # E exchanges physical sectors in the original logical coordinates.
 C=tensor['binary_ring_coordinate_change'];D=tensor['dual_coordinate_change'];perm=[0,1,4,5,2,3,6,7]
 E=[[int(j==perm[i]) for j in range(8)] for i in range(8)];H=[[0]*8 for _ in range(8)]
 for i in range(4):H[2*i][2*i]=H[2*i][2*i+1]=H[2*i+1][2*i]=1
 L=matmul(matmul(matmul(H,D),E),matinv(C))
 V=[[tuple(L[i][2*j] for i in [2*k,2*k+1]) for k in range(4)] for j in range(4)]
 assert all(tuple(L[i][2*j+1] for i in [2*k,2*k+1])==smul((0,1),V[j][k]) for k in range(4) for j in range(4))
 v00,v10,v01,v11=V
 i,j,value=next((i,j,v00[2*j+i]) for i in range(2) for j in range(2) if sunit(v00[2*j+i]))
 p0=[v00[2*j+k] for k in range(2)];r0=[smul(v00[2*k+i],sinverse(value)) for k in range(2)]
 i0=next(i for i in range(2) if sunit(p0[i]));j0=next(j for j in range(2) if sunit(r0[j]))
 r1=[smul(v10[2*k+i0],sinverse(p0[i0])) for k in range(2)];p1=[smul(v01[2*j0+k],sinverse(r0[j0])) for k in range(2)]
 assert [rank_one(p0,r0),rank_one(p0,r1),rank_one(p1,r0),rank_one(p1,r1)]==V
 assert sunit(sadd(smul(p0[0],p1[1]),smul(p0[1],p1[0])))
 assert sunit(sadd(smul(r0[0],r1[1]),smul(r0[1],r1[0])))
 return {'R_matrix':L,'S_linear':True,'form':'P M^T Q','P_columns':[p0,p1],'Q_rows':[r0,r1],'P_Q_invertible':True}


def main():
    import hashlib
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();root=Path(__file__).parent
    arrangement=analyze(root);tensor=tensor_analysis(root,arrangement);dictionary=tensor_dictionaries(tensor,arrangement['groups']);spans=type_span_analysis(dictionary)
    result={'status':'EXACT_POOL_TENSOR_NORMAL_FORM','canonical_question_answered':False,'ring':'R=F2[t]/(t^16-1), S=F4 tensor R','arrangement':arrangement,'tensor':tensor,'dictionary':dictionary,'span_constraints':spans,'sector_exchange':exchange_normal_form(tensor),'source_hashes':{side:hashlib.sha256((root/f'pools/{side}coords.txt').read_bytes()).hexdigest() for side in ['x','z']}}
    args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({'status':result['status'],'X_pool_rank_one':tensor['X_determinant_nonzero']==0,'Z_pool_rank_one':tensor['Z_determinant_nonzero']==0,'complete_cartesian_equality':dictionary['complete_cartesian_pool_equality'],'minimum_dictionary_types':4,'three_type_rank_bound':125,'canonical_question_answered':False}))

if __name__=='__main__':main()
