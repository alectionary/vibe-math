#!/usr/bin/env python3
"""Exact small obstruction to averaging coefficient certificates in char2."""
from pathlib import Path
import argparse,json
def add(*terms):
 out=set()
 for f in terms:out.symmetric_difference_update(f)
 return out
def multiply(f,g):
 out=set()
 for x,y in f:
  for u,v in g:out.symmetric_difference_update({(x+u,y+v)})
 return out
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();one={(0,0)};x={(1,0)};f1={(1,1),(1,0),(0,0)};f2={(1,1),(0,1),(0,0)};gx={(2,0),(1,0)};gy={(0,2),(0,1)};assert {(b,a) for a,b in f1}==f2 and {(b,a) for a,b in gx}==gy;assert add(multiply(add(x,one),f1),multiply(x,f2),gx)==one
 def value(f,a,b):return sum(a**u*b**v for u,v in f)%2
 assert not any(all(value(f,a,b)==0 for f in [f1,f2,gx,gy]) for a in [0,1] for b in [0,1])
 # At(0,0), f1=f2=1 and gx=gy=0. Equivariant coefficient pairs
 # have equal constants, so every such combination evaluates to0, never1.
 assert [value(f,0,0) for f in [f1,f2,gx,gy]]==[1,1,0,0]
 out={'status':'PASS','source_C16_answered':False,'field_characteristic':2,'symmetry_group_order':2,'Boolean_assignments_checked':4,'explicit_certificate':'1=(x+1)(xy+x+1)+x(xy+y+1)+(x^2+x)','polynomial_identity_expanded_exactly':True,'equivariant_certificate_obstruction':'At the origin the swapped f1/f2 coefficients have equal constants and cancel in characteristic2; the Boolean generators vanish. Hence a fully equivariant coefficient certificate cannot equal1, at any degree.','transfer_limit':'NulLA symmetry averaging requires an invertible group order. The order16 source symmetry cannot justify coefficient averaging overF2. Real convex-moment averaging and choosing combinatorial orbit representatives are different valid operations.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print('PASS characteristic/symmetry guard')
if __name__=='__main__':main()
