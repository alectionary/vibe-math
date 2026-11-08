#!/usr/bin/env python3
"""Attempt exact rational equality recovery and interval PSD verification.

A passing certificate concerns only the degree-two relaxation, never a frame.
"""
import argparse
import json
from pathlib import Path
import time
import numpy as np
from scipy.sparse import load_npz
from scipy.linalg import qr,solve_triangular
from flint import fmpq,fmpq_mat,arb,arb_mat,ctx


def recover(prefix):
 A=load_npz(str(prefix)+'.equalities.npz');v=np.load(str(prefix)+'.canonical.npz');x=v['x'];b=v['b'];assert np.array_equal(A.data,np.rint(A.data)) and np.array_equal(b,np.rint(b));Ai=A.astype(np.int64).tocsr()
 G=(A@A.T).toarray();_,R,rows=qr(G,pivoting=True);rank=sum(abs(np.diag(R))>1e-7);rows=rows[:rank]
 rng=np.random.default_rng(20261027);cols=np.unique(np.r_[np.arange(90),rng.choice(A.shape[1],min(5000,A.shape[1]),replace=False)])
 _,R,pivot=qr(A[rows,:][:,cols].toarray(),pivoting=True,mode='economic');assert abs(R[rank-1,rank-1])>1e-8;cols=cols[pivot[:rank]]
 D=1<<40;n=np.rint(x*D).astype(np.int64);res=np.rint(b*D).astype(np.int64)-Ai@n;M=Ai[rows,:][:,cols].toarray();delta=fmpq_mat(M.tolist()).solve(fmpq_mat([[int(t)] for t in res[rows]]));values=[fmpq(int(t),D) for t in n]
 for k,c in enumerate(cols):values[c]+=delta[k,0]/D
 for i in range(A.shape[0]):
  row=Ai[i:i+1,:];assert sum(int(a)*values[j] for a,j in zip(row.data,row.indices))==int(b[i])
 metadata=json.loads(Path(str(prefix)+'.canonical.json').read_text());offsets=metadata['offsets'];shapes=metadata['shapes'];named={name:identifier for identifier,name in metadata['variables'].items()}
 def extract(name):
  identifier=named[name];offset=offsets[identifier];shape=shapes[identifier];length=int(np.prod(shape));return values[offset:offset+length]
 p=extract('first');C={}
 for h in range(9):
  flat=extract('C0' if h==0 else 'Chalf' if h==8 else f'C{h}')
  if h in [0,8]:
   matrix=[[fmpq(0) for j in range(90)] for i in range(90)];k=0
   for i in range(90):
    for j in range(i,90):matrix[i][j]=matrix[j][i]=flat[k];k+=1
  else:matrix=[[flat[i+90*j] for j in range(90)] for i in range(90)]
  C[h]=matrix
 for h in range(9,16):C[h]=list(map(list,zip(*C[16-h])))
 return p,C,{'canonical_equalities':A.shape[0],'independent_equalities':int(rank),'canonical_variables':len(values)}


def exact_linear(patterns,p,C):
 assert all(0<=v<=1 for v in p);assert sum(p[:45])*16==sum(p[45:])*16==128
 assert p[12]*16<=11 and p[57]*16<=11
 for i in range(90):
  assert C[0][i][i]==p[i]
  for sector in [0,45]:assert sum(C[h][i][j] for h in range(16) for j in range(sector,sector+45))==128*p[i]
 for h in range(16):
  for i in range(90):
   for j in range(90):
    value=C[h][i][j];assert 0<=value<=min(p[i],p[j]) and value>=p[i]+p[j]-1,(h,i,j,str(value));assert value==C[(-h)%16][j][i]
 flow=[[sum(C[h][a][45+b] for h in range(16) if patterns[a][b]>>h&1) for b in range(45)] for a in range(45)]
 assert all(sum(flow[a])==p[a] for a in range(45));assert all(sum(flow[a][b] for a in range(45))==p[45+b] for b in range(45))


def interval_pd(B):
 n=B.nrows();F=np.array([[float(B[i,j].mid()) for j in range(n)] for i in range(n)]);L=np.linalg.cholesky((F+F.T)/2);R=solve_triangular(L,np.eye(n),lower=True);D=1<<45
 preconditioner=arb_mat([[arb(fmpq(round(float(v)*D),D)) for v in row] for row in R]);Q=preconditioner*B*preconditioner.transpose();margins=[]
 for i in range(n):
  slack=Q[i,i]-sum(abs(Q[i,j]) for j in range(n) if i!=j);assert slack>0,(i,str(slack));margins.append(str(slack))
 return {'dimension':n,'strict_diagonal_dominance':True,'minimum_slack_lower_approximation':min(float(arb(v).lower()) for v in margins)}


def main():
 ap=argparse.ArgumentParser();ap.add_argument('prefix',type=Path);ap.add_argument('--mapping',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();start=time.monotonic();p,C,report=recover(args.prefix);patterns=json.loads(args.mapping.read_text())['patterns'];exact_linear(patterns,p,C);print('EXACT_LINEAR_PASS',flush=True)
 data={'p':list(map(str,p)),'C':{str(h):[[str(v) for v in row] for row in C[h]] for h in range(9)}};args.output.with_suffix('.rational.json').write_text(json.dumps(data)+'\n')
 ctx.prec=256;keep=[i for i in range(91) if i not in [45,90]]
 G=[[fmpq(1) if i==j==0 else 4*p[j-1] if i==0 else 4*p[i-1] if j==0 else sum(C[h][i-1][j-1] for h in range(16)) for j in range(91)] for i in range(91)]
 blocks=[interval_pd(arb_mat([[arb(G[i][j]) for j in keep] for i in keep]))]
 for k in range(1,9):
  real=[[arb(C[0][i][j]+(-1)**k*C[8][i][j]) for j in range(90)] for i in range(90)];imag=[[arb(0) for j in range(90)] for i in range(90)]
  for h in range(1,8):
   angle=arb.pi()*fmpq(k*h,8);cos=arb((-1)**h) if k==8 else angle.cos();sin=arb(0) if k==8 else angle.sin()
   for i in range(90):
    for j in range(90):real[i][j]+=cos*arb(C[h][i][j]+C[h][j][i]);imag[i][j]+=sin*arb(C[h][i][j]-C[h][j][i])
  block=real if k==8 else [real[i]+[-v for v in imag[i]] for i in range(90)]+[imag[i]+real[i] for i in range(90)]
  blocks.append(interval_pd(arb_mat(block)));print('PSD_FREQUENCY',k,flush=True)
 report.update(status='EXACT_RELAXATION_POINT_CERTIFIED',scope='degree-two necessary relaxation only; not a physical frame',precision_bits=ctx.prec,PSD_blocks=blocks,seconds=time.monotonic()-start)
 args.output.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))

if __name__=='__main__':main()
