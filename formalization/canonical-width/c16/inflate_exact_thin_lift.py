#!/usr/bin/env python3
"""Lift a relaxed frame while retaining the five exact source thin-factor orbits.

Only thick dictionaries are enlarged. Optional target choices expose which
finite scalar rays, beyond projective lines, obstruct the original source.
"""
from pathlib import Path
from itertools import product
import argparse,json
from inflate_inverse_lift import *
from first_order_lift import sw

def embed_factor(v):
 out=[];eta=1|(1<<8)
 for s in v:
  w=sw(s);out.append(((w&1)^((w>>2&1)*eta),(w>>1&1)^((w>>3&1)*eta)))
 return out

def fixed_factor(v,B,Abar):
 M=asmat(v)
 for b in B:
  j=next(j for j in range(2) if sunit(b[j]));a=[smul(M[i][j],sinverse(b[j])) for i in range(2)]
  if rank_one(a,b)==v and residue(a) in Abar:return a
 raise AssertionError('No exact thin factor')

def main():
 ap=argparse.ArgumentParser();ap.add_argument('first_order_certificate',type=Path);ap.add_argument('--source-certificate',type=Path,default=Path(__file__).parent/'inversion-results/normal-form.json');ap.add_argument('--target-C',default='3,4');ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();d=json.loads(args.source_certificate.read_text());f=json.loads(args.first_order_certificate.read_text());assert f.get('exact_five_thin_factors');dic=d['dictionary'];P=transpose(dic0:=d['sector_exchange']['P_columns']);Q=d['sector_exchange']['Q_rows'];Pi=inv(P);Qi=inv(Q);B=[list(map(tuple,v)) for v in dic['X_right_factors']];Corig=[list(map(tuple,v)) for v in dic['Z_left_factors']];Abar={residue(v) for v in dic['X_left_dictionary']};SX={residue(v) for v in d['tensor']['X_tensor_coordinates']};SZ={residue(v) for v in d['tensor']['Z_tensor_coordinates']};targetC=list(map(int,args.target_C.split(',')));assert len(targetC)==2
 def cols(vs):return transpose(vs)
 BX=cols([embed_factor(B[i]) for i in [3,4]]);CZ=cols([embed_factor(Corig[i]) for i in [0,4]]);ex=[asmat(embed(v)) for v in f['witness']['X_frame']];ez=[asmat(embed(v)) for v in f['witness']['Z_frame']];found=None
 for scalars in product([(1,0),(0,1),(1,1)],repeat=4):
  p,q,u,v=scalars;RB=mm(cols([[smul(p,s) for s in B[3]],[smul(q,s) for s in B[4]]]),inv(BX));RC=mm(cols([[smul(u,s) for s in Corig[targetC[0]]],[smul(v,s) for s in Corig[targetC[1]]]]),inv(CZ));TX=inv(adjoint(RC));TZ=transpose(inv(adjoint(RB)));baseX=[asvec(mm(mm(TX,x),transpose(RB))) for x in ex];baseZ=[asvec(mm(mm(RC,z),TZ)) for z in ez]
  if all(residue(x) in SX for x in baseX) and all(residue(z) in SZ for z in baseZ):found=(RB,RC,baseX,baseZ,scalars);break
 if found is None:
  args.output.write_text(json.dumps({'status':'NO_SOURCE_RESIDUE_SCALE_CHOICE','target_C':targetC,'source_C16_answered':False})+'\n');print('NO_SOURCE_RESIDUE_SCALE_CHOICE');return
 RB,RC,baseX,baseZ,scalars=found
 def exchange(v):return asvec(mm(mm(P,transpose(asmat(v))),Q))
 def exchange_inv(v):return asvec(transpose(mm(mm(Pi,asmat(v)),Qi)))
 A=[list(map(tuple,v)) for v in dic['X_left_dictionary']]
 for x in baseX+[exchange_inv(z) for z in baseZ]:
  a=fixed_factor(x,B,Abar)
  if not any(all(rotate_s(v,h)==w for v,w in zip(old,a)) for old in A for h in range(16)):A.append(a)
 phase_pairs=[];gammas=[]
 for b in B:
  pb=[rowcol(row,b) for row in P];hit=None
  for j,c in enumerate(Corig):
   k=next(k for k in range(2) if sunit(c[k]));gamma=smul(pb[k],sinverse(c[k]))
   if all(smul(gamma,y)==x for x,y in zip(pb,c)):hit=(j,gamma);break
  assert hit;gammas.append(hit[1]);phase_pairs.append([hit[0],None])
 alpha=gammas[0]
 for pair,gamma in zip(phase_pairs,gammas):
  ratio=smul(gamma,sinverse(alpha));assert ratio[1]==0 and ratio[0].bit_count()==1;pair[1]=ratio[0].bit_length()-1
 C=[[smul(sinverse(alpha),x) for x in [rowcol(row,b) for row in P]] for b in B];D=[[smul(alpha,x) for x in [rowcol(row,a) for row in transpose(Q)]] for a in A];qB=d['span_constraints']['thin_factors']['X']['trace_functional_q'];qC=d['span_constraints']['thin_factors']['Z']['trace_functional_q'];qCP=[rowcol(qC,c) for c in transpose(P)];beta=smul(qCP[1],sinverse(qB[1]));real_multiplier=smul(beta,sinverse(alpha));assert not(epsilon_word(real_multiplier[1])&7)
 assert all(thin(qB,b) for b in B) and all(thin(qC,c) for c in C)
 X=[tuple(rotate_s(s,h) for s in row) for row in baseX for h in range(8)];Z=[tuple(rotate_s(s,h) for s in row) for row in baseZ for h in range(8)];xp=list(map(flat,X));zc=[flat([(b,a^b) for a,b in z]) for z in Z];assert all((x&z).bit_count()%2==(i==j) for i,x in enumerate(xp) for j,z in enumerate(zc));poolX={tuple(rotate_s(s,h) for s in rank_one(a,b)) for a,b in product(A,B) for h in range(16)};poolZ={tuple(exchange(v)) for v in poolX};assert set(X)<=poolX and set(Z)<=poolZ;sx={tuple(map(tuple,v)) for v in d['tensor']['X_tensor_coordinates']};sz={tuple(map(tuple,v)) for v in d['tensor']['Z_tensor_coordinates']};assert sx<=poolX and sz<=poolZ
 def line_equal(a,b):return sadd(smul(a[0],b[1]),smul(a[1],b[0]))==(0,0)
 newlines=[a for a in A if not any(line_equal(a,old) for old in dic['X_left_dictionary'])]
 r={'status':'EXACT_THIN_ENLARGED_POOL_128_FRAME_CHECKED','source_C16_answered':False,'source_exact_720_pool_replaced':True,'scope':'Exact source five thin-factor orbits retained in each sector. Thick dictionaries enlarged. Same residue pools and exact transpose exchange.','source_thin_factor_orbits_retained':True,'target_C':targetC,'chosen_field_scales':scalars,'new_thick_projective_factors':len(newlines),'dictionary_sizes':[len(A),5],'pool_sizes':[len(poolX),len(poolZ)],'source_pool_contained':True,'source_residue_sets_equal':True,'qB':qB,'qC':qC,'alpha':alpha,'beta':beta,'real_multiplier':real_multiplier,'R_B':RB,'R_C':RC,'X_thick_factors':A,'X_thin_factors':B,'Z_thin_factors':C,'Z_thick_factors':D,'source_C_thin_phase_permutation':phase_pairs,'X_frame':X,'Z_frame':Z,'frame_source_membership_counts':[sum(x in sx for x in X),sum(z in sz for z in Z)],'original_source_pairs_retained':sum(x in sx and z in sz for x,z in zip(X,Z)),'thin_module_ranks':[61,61]};args.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({k:r[k] for k in ['status','target_C','new_thick_projective_factors','dictionary_sizes','pool_sizes','frame_source_membership_counts','original_source_pairs_retained']}))
if __name__=='__main__':main()
