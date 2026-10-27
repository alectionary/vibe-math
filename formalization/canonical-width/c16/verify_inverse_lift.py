#!/usr/bin/env python3
"""Independent epsilon-polynomial consumer of enlarged-pool counterexamples.

Uses truncated ordinary polynomial convolution over a literal F4 table, rather
than the generator's cyclic bit rotations in the t basis. No generator imported.
"""
from pathlib import Path
import argparse,json,math,hashlib
from itertools import product

F=[[0,0,0,0],[0,1,2,3],[0,2,3,1],[0,3,1,2]];MASK=(1<<32)-1

def eps(s):
 a,b=s;out=0
 for k in range(16):
  ac=sum((a>>h&1)*(math.comb(h,k)%2) for h in range(k,16))%2;bc=sum((b>>h&1)*(math.comb(h,k)%2) for h in range(k,16))%2;out|=(ac|(bc<<1))<<(2*k)
 return out

def cyclic(s):
 out=[0,0]
 for k in range(16):
  for h in range(k,16):
   if math.comb(h,k)%2:
    v=s>>(2*h)&3;out[0]^=(v&1)<<k;out[1]^=(v>>1)<<k
 return tuple(out)
def pm(a,b):
 out=0
 for i in range(16):
  ai=a>>(2*i)&3
  if ai:
   for j in range(16-i):out^=F[ai][b>>(2*j)&3]<<(2*(i+j))
 return out

def mp(v):return sum(eps(s)<<(32*i) for i,s in enumerate(v))
def parts(v):return [(v>>(32*i))&MASK for i in range(4)]
def vp(v):return [eps(s) for s in v]
def rank(rows):
 piv={}
 for v in rows:
  while v:
   b=(v&-v).bit_length()-1
   if b not in piv:piv[b]=v;break
   v^=piv[b]
 return len(piv)
def phase(v):return sum((s^((s<<2)&MASK))<<(32*i) for i,s in enumerate(parts(v)))
def phase_vec(v):return [s^((s<<2)&MASK) for s in v]
def shifts(v):
 for _ in range(16):yield v;v=phase(v)
def vshifts(v):
 for _ in range(16):yield sum(s<<(32*i) for i,s in enumerate(v));v=phase_vec(v)
def res(v):return sum((s&3)<<(2*i) for i,s in enumerate(parts(v)))
def vres(v):return sum((s&3)<<(2*i) for i,s in enumerate(v))
def outer(a,b):return sum(pm(a[i],b[j])<<(32*(2*j+i)) for i,j in product(range(2),repeat=2))
def betat(x,z):
 xx=[cyclic(s) for s in parts(x)];zz=[cyclic(s) for s in parts(z)]
 return sum((F[(a>>h&1)|((b>>h&1)<<1)][(c>>h&1)|((d>>h&1)<<1)]>>1)&1 for (a,b),(c,d) in zip(xx,zz) for h in range(16))%2
def mm(A,B):return [[pm(A[i][0],B[0][j])^pm(A[i][1],B[1][j]) for j in range(2)] for i in range(2)]
def mat(v):s=parts(v);return [[s[0],s[2]],[s[1],s[3]]]
def pack(M):return M[0][0]|(M[1][0]<<32)|(M[0][1]<<64)|(M[1][1]<<96)
def transpose(A):return list(map(list,zip(*A)))
def apply(cols,v):
 out=0
 while v:b=v&-v;v^=b;out^=cols[b.bit_length()-1]
 return out

def verify(d,source):
 assert d['source_exact_720_pool_replaced'] is True and d['source_C16_answered'] is False
 dic=source['dictionary'];A=list(map(vp,d['X_thick_factors']));B=list(map(vp,d['X_thin_factors']));C=list(map(vp,d['Z_thin_factors']));D=list(map(vp,d['Z_thick_factors']));qB=vp(source['span_constraints']['thin_factors']['X']['trace_functional_q']);qC=vp(source['span_constraints']['thin_factors']['Z']['trace_functional_q']);alpha=eps(d['alpha']);P=transpose(list(map(vp,source['sector_exchange']['P_columns'])));Q=list(map(vp,source['sector_exchange']['Q_rows']));tiny=2|(2<<2)|(2<<4)
 assert d['qB']==source['span_constraints']['thin_factors']['X']['trace_functional_q'] and d['qC']==source['span_constraints']['thin_factors']['Z']['trace_functional_q']
 assert all((a[0]&3) or (a[1]&3) for a in A+B+C+D)
 assert all(not((pm(qB[0],b[0])^pm(qB[1],b[1]))&tiny) for b in B)
 assert all(not((pm(qC[0],c[0])^pm(qC[1],c[1]))&tiny) for c in C)
 r=[pm(qC[0],P[0][j])^pm(qC[1],P[1][j]) for j in range(2)]
 assert all(((r[i]^pm(alpha,qB[i]))&63)==0 for i in range(2))
 for i,b in enumerate(B):
  pb=[pm(P[k][0],b[0])^pm(P[k][1],b[1]) for k in range(2)];assert [pm(alpha,x) for x in C[i]]==pb
 for i,a in enumerate(A):assert D[i]==[pm(alpha,pm(Q[0][j],a[0])^pm(Q[1][j],a[1])) for j in range(2)]
 poolX={w for a,b in product(A,B) for w in shifts(outer(a,b))};poolZ={w for c,a in product(C,D) for w in shifts(outer(c,a))};assert len(poolX)==len(poolZ)==d['pool_sizes'][0]
 for v in poolX|poolZ:
  assert res(v)!=0 and sum((x^((x<<16)&MASK))<<(32*i) for i,x in enumerate(parts(v)))!=v
 # Exact physical-sector exchange on all128 binary coefficient basis vectors.
 L=[]
 for k in range(128):L.append(pack(mm(mm(P,transpose(mat(1<<k))),Q)))
 assert {apply(L,v) for v in poolX}==poolZ
 sx={mp(v) for v in source['tensor']['X_tensor_coordinates']};sz={mp(v) for v in source['tensor']['Z_tensor_coordinates']};assert sx<=poolX and sz<=poolZ and len(sx)==len(sz)==720
 assert {res(v) for v in poolX}=={res(v) for v in sx} and {res(v) for v in poolZ}=={res(v) for v in sz}
 assert len({res(v) for v in sx})==len({res(v) for v in sz})==32
 # Bind the reduced obstruction to the original quotient CNF coordinates.
 root=Path(__file__).parent;trans=source['tensor']
 def oldaug(v):return sum(((v>>(16*i)&65535).bit_count()%2)<<i for i in range(8))
 def cmap(M,v):return sum((sum((x.bit_count()%2)*((v>>j)&1) for j,x in enumerate(row))%2)<<i for i,row in enumerate(M))
 for side,table in [('x',trans['binary_ring_coordinate_change']),('z',trans['dual_coordinate_change'])]:
  raw=(root/f'pools/{side}coords.txt').read_bytes();assert hashlib.sha256(raw).hexdigest()==source['source_hashes'][side];orig=[int(v,16) for v in raw.decode().split()];points=source['tensor'][side.upper()+'_tensor_coordinates']
  for v,point in zip(orig,points):
   w=cmap(table,oldaug(v))
   if side=='z':w=sum((((w>>(2*i)&1)^((w>>(2*i+1))&1))|((w>>(2*i)&1)<<1))<<(2*i) for i in range(4))
   assert w==res(mp(point))
 assert {vres(v) for v in A}=={vres(vp(v)) for v in dic['X_left_dictionary']};assert {vres(v) for v in B}=={vres(vp(v)) for v in dic['X_right_factors']};assert {vres(v) for v in C}=={vres(vp(v)) for v in dic['Z_left_factors']};assert {vres(v) for v in D}=={vres(vp(v)) for v in dic['Z_right_dictionary']}
 X=list(map(mp,d['X_frame']));Z=list(map(mp,d['Z_frame']));assert len(set(X))==len(set(Z))==128 and set(X)<=poolX and set(Z)<=poolZ
 for v in X+Z:
  a,b,c,e=parts(v);assert pm(a,e)^pm(b,c)==0
 # Convert once to t coefficients, then check the literal trace products.
 xt=[[(a>>h&1)|((b>>h&1)<<1) for a,b in map(cyclic,parts(x)) for h in range(16)] for x in X];zt=[[(a>>h&1)|((b>>h&1)<<1) for a,b in map(cyclic,parts(z)) for h in range(16)] for z in Z]
 assert all(sum((F[a][b]>>1)&1 for a,b in zip(x,z))%2==(i==j) for i,x in enumerate(xt) for j,z in enumerate(zt))
 ranks=[rank(w for v in B for w in vshifts(v)),rank(w for v in C for w in vshifts(v))];assert ranks==[61,61]==d['thin_module_ranks']
 members=[sum(x in sx for x in X),sum(z in sz for z in Z)];assert members==d['frame_source_membership_counts'];pairs=sum(x in sx and z in sz for x,z in zip(X,Z));assert pairs==d['original_source_pairs_retained']
 return {'status':'PASS','ambient_binary_dimension':128,'dictionary_sizes':[len(A),len(B)],'enlarged_pool_sizes':[len(poolX),len(poolZ)],'original720_pools_contained':True,'exact_source_residue_sets':[32,32],'Cartesian_transpose_exchange_checked':True,'primitive_free_cyclic_pool_points':len(poolX)+len(poolZ),'frame_determinants':256,'literal_trace_Gram_pairings':16384,'thin_module_ranks':ranks,'frame_original_pool_memberships':members,'original_pool_pairs':pairs,'source_C16_answered':False}

def main():
 ap=argparse.ArgumentParser();ap.add_argument('certificate',type=Path);ap.add_argument('--source',type=Path,default=Path(__file__).parent/'inversion-results/normal-form.json');ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();r=verify(json.loads(a.certificate.read_text()),json.loads(a.source.read_text()));a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r),flush=True)
if __name__=='__main__':main()
