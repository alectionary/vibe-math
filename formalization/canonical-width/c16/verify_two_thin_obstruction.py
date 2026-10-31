#!/usr/bin/env python3
"""Exact independent source checks for the two-by-two thin-family obstruction.

The general dimension/annihilator implication is written in the research note.
This consumer verifies all source-specific hypotheses in epsilon coordinates.
"""
from pathlib import Path
from itertools import product,combinations
import argparse,json
from verify_inverse_lift import eps,vp,mp,pm,parts,rank,outer,shifts,vshifts,vres,res,cyclic,F,MASK


def star(a):
 aa,bb=cyclic(a);out=[0,0]
 for h in range(16):out[0]|=((aa>>h)&1)<<((-h)%16);out[1]|=((bb>>h)&1)<<((-h)%16)
 return eps(out)
def sdot(a,b):return pm(a[0],star(b[0]))^pm(a[1],star(b[1]))
def line(a,b):return pm(a[0],b[1])==pm(a[1],b[0])
def classes(V):
 groups=[]
 for i,v in enumerate(V):
  match=next((g for g in groups if line(v,V[g[0]])),None)
  if match is None:groups.append([i])
  else:match.append(i)
 return groups

def tracecov(v):
 out=0
 for i,s in enumerate(parts(v)):
  a,b=cyclic(s);out|=(b<<(32*i))|((a^b)<<(32*i+16))
 return out

def tbits(v):return sum((a<<(32*i))|(b<<(32*i+16)) for i,(a,b) in enumerate(map(cyclic,parts(v))))
def report(source):
 q=source['dictionary'];A=list(map(vp,q['X_left_dictionary']));B=list(map(vp,q['X_right_factors']));C=list(map(vp,q['Z_left_factors']));D=list(map(vp,q['Z_right_dictionary']));assert rank(v for a in A for v in vshifts(a))==rank(v for d in D for v in vshifts(d))==64;assert rank(v for b in B for v in vshifts(b))==rank(v for c in C for v in vshifts(c))==61
 ac=classes(A);dc=classes(D);fatA=[g for g in ac if len(g)>=2];fatD=[g for g in dc if len(g)>=2];assert fatA==fatD==[[0,1,2],[3,5]]
 forcedB=sorted({i for i,b in enumerate(B) if any(sdot(b,D[g[0]])==0 for g in fatD)});forcedC=sorted({j for j,c in enumerate(C) if any(sdot(A[g[0]],c)==0 for g in fatA)});assert forcedB==forcedC==[3,4]
 # No thin family may be assigned a hidden second line: all five are distinct.
 assert len(classes(B))==len(classes(C))==5
 sx={mp(v) for v in source['tensor']['X_tensor_coordinates']};sz={mp(v) for v in source['tensor']['Z_tensor_coordinates']};generatedX={v for a,b in product(A,B) for v in shifts(outer(a,b))};generatedZ={v for c,d in product(C,D) for v in shifts(outer(c,d))};assert sx==generatedX and sz==generatedZ and len(sx)==len(sz)==720
 cells=[]
 for br,dt in [(3,[0,1,2]),(4,[3,5])]:
  X=sorted({v for a in [A[i] for i in [3,5]] for v in shifts(outer(a,B[br]))});Z=sorted({v for d in [D[i] for i in dt] for v in shifts(outer(C[4],d))});assert len(X)==32 and rank(X)==32
  xt=list(map(tbits,X));zc=list(map(tracecov,Z));col=[sum(((x&z).bit_count()%2)<<i for i,x in enumerate(xt)) for z in zc];units=[v for v in col if v.bit_count()==1];assert len(units)==len(set(units))==16;assert rank(col)==32
  cells.append({'X_thin_family':br,'Z_thin_family':4,'X_thick_types':[3,5],'Z_thick_types':dt,'X_points':len(X),'Z_points':len(Z),'X_rank':32,'pairing_rank':32,'unit_columns':len(units),'unit_rows_covered':len(set(units)),'column_weight_histogram':{str(k):sum(v.bit_count()==k for v in col) for k in sorted({v.bit_count() for v in col})}})
 # An asymmetric X basis in the excluded regime, with only one critical monomial.
 # This checks that the proof does not rely on invariant bases or a high monomial count.
 chosen=[]
 for br in [3,4]:
  for a in [A[1],A[2],A[3],A[5]]:chosen.extend(shifts(outer(a,B[br])))
 old=outer(A[1],B[4]);new=outer(A[0],B[4]);assert old in chosen and new not in chosen;chosen[chosen.index(old)]=new;assert len(set(chosen))==128 and rank(chosen)==128 and set(chosen)<=sx
 def phase4(v):
  for _ in range(4):v=sum((s^((s<<2)&MASK))<<(32*i) for i,s in enumerate(parts(v)))
  return v
 assert {phase4(v) for v in chosen}!=set(chosen)
 critical=set(shifts(outer(A[0],B[4])));assert len(set(chosen)&critical)==1
 return {'status':'PASS','source_C16_answered':False,'source_restricted_question_answered':'No full source frame uses at most two thin families in both sectors.','thin_module_ranks':[61,61],'thick_module_ranks':[64,64],'thick_projective_classes_X':ac,'thick_projective_classes_Z':dc,'one_sector_two_thin_forcing':{'X_thin_if_two':[3,4],'Z_thin_if_two':[3,4]},'source_pools_checked':[720,720],'cells':cells,'asymmetric_low_monomial_X_basis_control':{'rank':128,'T4_invariant':False,'critical_seed4_X_monomials':1},'remaining_scope':'Two thin families in just one sector, or three-to-five families, are not excluded by this argument.'}

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--source',type=Path,default=Path(__file__).parent/'inversion-results/normal-form.json');ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();r=report(json.loads(a.source.read_text()));a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r),flush=True)
if __name__=='__main__':main()
