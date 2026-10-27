#!/usr/bin/env python3
"""Consume a frozen rational point, using physical-pool Gram entries directly.

No optimization solver or canonicalization metadata is used. Fourier blocks are
formed by the full16-term sum, independently of the generator's paired formula.
"""
import argparse
import json
from pathlib import Path
import time
import numpy as np
from flint import fmpq,arb,arb_mat,ctx
from certify_moment_point import interval_pd


def verify(data,root):
 p=list(map(fmpq,data['p']));C={int(h):[[fmpq(v) for v in row] for row in matrix] for h,matrix in data['C'].items()};assert len(p)==90
 for h in range(9,16):C[h]=list(map(list,zip(*C[16-h])))
 assert all(len(C[h])==90 and all(len(row)==90 for row in C[h]) for h in range(16))
 for a in range(90):
  assert 0<=p[a]<=1 and C[0][a][a]==p[a]
  for h in range(16):
   for b in range(90):
    v=C[h][a][b];assert max(fmpq(0),p[a]+p[b]-1)<=v<=min(p[a],p[b]);assert v==C[(-h)%16][b][a]
  for sector in [0,45]:assert sum(C[h][a][b] for b in range(sector,sector+45) for h in range(16))==128*p[a]
 assert sum(p[:45])==sum(p[45:])==8;assert p[12]<=fmpq(11,16) and p[57]<=fmpq(11,16)
 pools=[[int(v,16) for v in (root/f'pools/{side}coords.txt').read_text().split()] for side in ['x','z']];degree_checks=0
 for side in [0,1]:
  for i,v in enumerate(pools[side]):
   a,u=divmod(i,16);total=fmpq(0)
   for j,w in enumerate(pools[1-side]):
    if (v&w).bit_count()%2:
     b,t=divmod(j,16);total+=C[(t-u)%16][a][45+b] if side==0 else C[(u-t)%16][b][45+a]
   assert total==p[45*side+a];degree_checks+=1
 # Cardinality identities give null vectors(-32,1_X,0_Z) and(-32,0_X,1_Z).
 # Deleting one coordinate from each sector leaves a principal block whose PSD
 # is equivalent to PSD of the augmented zero-frequency matrix.
 keep=[i for i in range(91) if i not in [45,90]];G=[[fmpq(1) if i==j==0 else 4*p[j-1] if i==0 else 4*p[i-1] if j==0 else sum(C[h][i-1][j-1] for h in range(16)) for j in range(91)] for i in range(91)]
 for sector in [0,45]:
  null=[fmpq(-32)]+[fmpq(int(sector<=j<sector+45)) for j in range(90)]
  assert all(sum(G[i][j]*null[j] for j in range(91))==0 for i in range(91))
 ctx.prec=256;checks=[interval_pd(arb_mat([[arb(G[i][j]) for j in keep] for i in keep]))]
 for k in range(1,9):
  real=[[arb(0) for j in range(90)] for i in range(90)];imag=[[arb(0) for j in range(90)] for i in range(90)]
  for h in range(16):
   c=(arb.pi()*fmpq(k*h,8)).cos();s=(arb.pi()*fmpq(k*h,8)).sin()
   for i in range(90):
    for j in range(90):real[i][j]+=c*arb(C[h][i][j]);imag[i][j]+=s*arb(C[h][i][j])
  block=real if k==8 else [real[i]+[-v for v in imag[i]] for i in range(90)]+[imag[i]+real[i] for i in range(90)]
  checks.append(interval_pd(arb_mat(block)))
 return {'status':'PASS','evidence':'exact rational necessary constraints and256-bit interval PSD checks','physical_pool_conditional_degree_checks':degree_checks,'PSD_blocks':checks,'frame_existence_established':False}


def main():
 ap=argparse.ArgumentParser();ap.add_argument('certificate',type=Path);ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();start=time.monotonic();data=json.loads(args.certificate.read_text());result=verify(data,Path(__file__).parent);result['seconds']=time.monotonic()-start;args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))

if __name__=='__main__':main()
