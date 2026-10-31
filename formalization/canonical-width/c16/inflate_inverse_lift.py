#!/usr/bin/env python3
"""Inflate a relaxed R2 product frame to R16 and the exact source thin modules.

This constructs explicitly enlarged dictionaries. It does not construct a frame
in the original720-point pools. Each claim is checked before output.
"""
from pathlib import Path
import argparse,json
from itertools import product
from pool_inverse_structure import smul,sadd,sinverse,sunit,mul,star,epsilon_word,rank_one,rotate_s,rank_binary
from first_order_lift import aug,jet,combine

ZERO=(0,0);ONE=(1,0)
def addm(A,B):return [[sadd(a,b) for a,b in zip(r,s)] for r,s in zip(A,B)]
def mm(A,B):
 out=[[ZERO for _ in B[0]] for _ in A]
 for i,j,k in product(range(len(A)),range(len(B[0])),range(len(B))):out[i][j]=sadd(out[i][j],smul(A[i][k],B[k][j]))
 return out

def transpose(A):return list(map(list,zip(*A)))
def adjoint(A):return [[tuple(star(w) for w in s) for s in row] for row in transpose(A)]
def inv(A):
 a,b=A[0];c,d=A[1];di=sinverse(sadd(smul(a,d),smul(b,c)));out=[[smul(d,di),smul(b,di)],[smul(c,di),smul(a,di)]];assert mm(A,out)==[[ONE,ZERO],[ZERO,ONE]];return out

def rowcol(q,v):return sadd(smul(q[0],v[0]),smul(q[1],v[1]))
def asmat(v):return [[v[0],v[2]],[v[1],v[3]]]
def asvec(M):return [M[0][0],M[1][0],M[0][1],M[1][1]]
def flat(v):return sum(w<<(16*i) for i,w in enumerate(w for s in v for w in s))
def residue(v):return sum((w.bit_count()%2)<<i for i,w in enumerate(w for s in v for w in s))
def thin(q,v):return epsilon_word(rowcol(q,v)[1])&7==0

def flattener(q):
 qb=[tuple(w.bit_count()%2 for w in s) for s in q];k=next(i for i in range(2) if sunit(q[i]));v=[ZERO,ZERO];v[k]=sinverse(q[k]);R=[[ONE,ZERO],[ZERO,ONE]]
 for i,j in product(range(2),repeat=2):R[i][j]=sadd(R[i][j],smul(v[i],sadd(qb[j],q[j])))
 assert [rowcol(q,[R[i][j] for i in range(2)]) for j in range(2)]==qb;assert all(residue([R[i][j]])==(1 if i==j else 0) for i,j in product(range(2),repeat=2));inv(R);return R

def embed(v):
 a,b=aug(v),jet(v);eta=1|(1<<8);out=[]
 for i in range(4):
  aa=a>>(2*i)&3;bb=b>>(2*i)&3;out.append(((aa&1)^((bb&1)*eta),((aa>>1)&1)^(((bb>>1)&1)*eta)))
 return out

def factor(v,q,Abar,Bbar):
 M=asmat(v);i,j=next((i,j) for i,j in product(range(2),repeat=2) if sunit(M[i][j]));a=[M[k][j] for k in range(2)];b=[smul(M[i][k],sinverse(M[i][j])) for k in range(2)];assert rank_one(a,b)==v
 for u,vv in product(range(8),repeat=2):
  s=(epsilon_word(u),epsilon_word(vv))
  if not sunit(s):continue
  bb=[smul(s,w) for w in b];aa=[smul(sinverse(s),w) for w in a]
  if residue(aa) in Abar and residue(bb) in Bbar and thin(q,bb):return aa,bb
 raise AssertionError('No correctly normalized thin factor')

def main():
 ap=argparse.ArgumentParser();ap.add_argument('first_order_certificate',type=Path);ap.add_argument('--source-certificate',type=Path,default=Path(__file__).parent/'inversion-results/normal-form.json');ap.add_argument('--identity-flatteners',action='store_true');ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();d=json.loads(args.source_certificate.read_text());f=json.loads(args.first_order_certificate.read_text());assert f['status']=='COUNTEREXAMPLE_CHECKED';dic=d['dictionary'];qB=d['span_constraints']['thin_factors']['X']['trace_functional_q'];qC=d['span_constraints']['thin_factors']['Z']['trace_functional_q'];RB=flattener(qB);RC=flattener(qC);
 if args.identity_flatteners:RB=RC=[[ONE,ZERO],[ZERO,ONE]]
 P=transpose(d['sector_exchange']['P_columns']);Q=d['sector_exchange']['Q_rows'];Pi=inv(P);Qi=inv(Q);qCP=[rowcol(qC,c) for c in transpose(P)];alpha=smul(qCP[1],sinverse(qB[1]));assert sunit(alpha)
 assert all(not(epsilon_word(w)&7) for a,b in zip(qCP,qB) for w in sadd(a,smul(alpha,b)))
 TX=inv(adjoint(RC));TZ=transpose(inv(adjoint(RB)));baseX=[asvec(mm(mm(TX,asmat(embed(v))),transpose(RB))) for v in f['witness']['X_frame']];baseZ=[asvec(mm(mm(RC,asmat(embed(v))),TZ)) for v in f['witness']['Z_frame']]
 def exchange(v):return asvec(mm(mm(P,transpose(asmat(v))),Q))
 def exchange_inv(v):return asvec(transpose(mm(mm(Pi,asmat(v)),Qi)))
 A=[list(map(tuple,v)) for v in dic['X_left_dictionary']];B=[list(map(tuple,v)) for v in dic['X_right_factors']];Abar={residue(v) for v in A};Bbar={residue(v) for v in B}
 for v in baseX+[exchange_inv(z) for z in baseZ]:
  a,b=factor(v,qB,Abar,Bbar)
  if a not in A:A.append(a)
  if b not in B:B.append(b)
 assert all(thin(qB,b) for b in B)
 C=[[smul(sinverse(alpha),x) for x in [rowcol(row,b) for row in P]] for b in B];DD=[[smul(alpha,x) for x in [rowcol(row,a) for row in transpose(Q)]] for a in A];assert all(thin(qC,c) for c in C)
 assert {residue(c) for c in C}=={residue(c) for c in dic['Z_left_factors']};assert {residue(a) for a in DD}=={residue(a) for a in dic['Z_right_dictionary']}
 X=[tuple(rotate_s(v,h) for v in row) for row in baseX for h in range(8)];Z=[tuple(rotate_s(v,h) for v in row) for row in baseZ for h in range(8)];assert len(set(X))==len(set(Z))==128
 xpacked=list(map(flat,X));zpacked=[flat([(b,a^b) for a,b in z]) for z in Z];assert all((x&z).bit_count()%2==(i==j) for i,x in enumerate(xpacked) for j,z in enumerate(zpacked))
 poolX={tuple(rotate_s(v,h) for v in rank_one(a,b)) for a,b in product(A,B) for h in range(16)};poolZ={tuple(exchange(v)) for v in poolX};assert set(X)<=poolX and set(Z)<=poolZ
 sourceX={tuple(map(tuple,v)) for v in d['tensor']['X_tensor_coordinates']};sourceZ={tuple(map(tuple,v)) for v in d['tensor']['Z_tensor_coordinates']};assert sourceX<=poolX and sourceZ<=poolZ
 assert {residue(v) for v in poolX}=={residue(v) for v in sourceX};assert {residue(v) for v in poolZ}=={residue(v) for v in sourceZ}
 r={'status':'ENLARGED_POOL_128_FRAME_CHECKED','source_C16_answered':False,'source_exact_720_pool_replaced':True,'scope':'Explicit Cartesian enlarged dictionaries over the original R16 with original source residue pools, exact transpose exchange, and both exact three-jet thin modules. The fixed nine-by-five dictionaries are enlarged.','dictionary_sizes':[len(A),len(B)],'pool_sizes':[len(poolX),len(poolZ)],'source_pool_contained':True,'source_residue_sets_equal':True,'qB':qB,'qC':qC,'alpha':alpha,'qCP_mod_epsilon3_equals_alpha_qB':True,'identity_flatteners':args.identity_flatteners,'R_B':RB,'R_C':RC,'X_thick_factors':A,'X_thin_factors':B,'Z_thin_factors':C,'Z_thick_factors':DD,'X_frame':X,'Z_frame':Z,'frame_source_membership_counts':[sum(x in sourceX for x in X),sum(z in sourceZ for z in Z)],'original_source_pairs_retained':sum(x in sourceX and z in sourceZ for x,z in zip(X,Z)),'first_order_source':str(args.first_order_certificate),'complete_source_pool_contained_sizes':[len(sourceX),len(sourceZ)],'thin_module_ranks':[rank_binary(flat([rotate_s(v,h) for v in b]) for b in B for h in range(16)),rank_binary(flat([rotate_s(v,h) for v in c]) for c in C for h in range(16))]};args.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({k:r[k] for k in ['status','source_C16_answered','dictionary_sizes','pool_sizes','frame_source_membership_counts','original_source_pairs_retained','thin_module_ranks']}))
if __name__=='__main__':main()
