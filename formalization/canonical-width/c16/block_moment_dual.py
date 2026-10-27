#!/usr/bin/env python3
"""Exact residual-corrected Farkas consumer for a source block moment SDP.

No stationarity is assumed: known0..1 variable bounds absorb its exact residual.
The dual moment matrix is rational block-circulant and interval-verified PSD.
"""
from pathlib import Path
from collections import defaultdict
from itertools import product
import argparse,json
from flint import fmpq,arb,arb_mat,ctx
from verify_inverse_lift import vp,outer,parts,cyclic,F

def layout(N,P):
 p=list(range(N));C={};count=N
 for h in range(P//2+1):
  M=[[None]*N for _ in range(N)]
  if h in [0,P//2]:
   for i in range(N):
    for j in range(i,N):M[i][j]=M[j][i]=count;count+=1
  else:
   for j in range(N):
    for i in range(N):M[i][j]=count;count+=1
  C[h]=M
 for h in range(P//2+1,P):C[h]=list(map(list,zip(*C[P-h])))
 return p,C,count

def row(terms,rhs,kind):
 d=defaultdict(int)
 for j,v in terms:d[j]+=v
 coeff=tuple(sorted((j,v) for j,v in d.items() if v));rhs=int(rhs)
 if kind=='eq' and coeff and coeff[0][1]<0:coeff=tuple((j,-v) for j,v in coeff);rhs=-rhs
 return coeff,rhs

def source_constraints(patterns,P,target):
 m=len(patterns);n=len(patterns[0]);N=m+n;p,C,V=layout(N,P);eq=set();ineq=set()
 def save(terms,rhs=0,kind='eq'):(eq if kind=='eq' else ineq).add(row(terms,rhs,kind))
 for i in range(N):
  save([(C[0][i][i],1),(p[i],-1)])
  for lo,hi in [(0,m),(m,N)]:save([(C[h][i][j],1) for h in range(P) for j in range(lo,hi)]+[(p[i],-target)])
  save([(p[i],-1)],0,'ineq');save([(p[i],1)],1,'ineq')
 for lo,hi in [(0,m),(m,N)]:save([(p[i],P) for i in range(lo,hi)],target)
 for a in range(m):save([(C[h][a][m+b],1) for b in range(n) for h in range(P) if patterns[a][b]>>h&1]+[(p[a],-1)])
 for b in range(n):save([(C[h][a][m+b],1) for a in range(m) for h in range(P) if patterns[a][b]>>h&1]+[(p[m+b],-1)])
 for h in range(P//2+1):
  for i,j in product(range(N),repeat=2):
   c=C[h][i][j];save([(c,-1)],0,'ineq');save([(c,1),(p[i],-1)],0,'ineq');save([(c,1),(p[j],-1)],0,'ineq');save([(c,-1),(p[i],1),(p[j],1)],1,'ineq')
 return eq,ineq,(p,C,V)

def patterns_from_source(source,block):
 assert block in [3,4];q=source['dictionary'];A=list(map(vp,q['X_left_dictionary']));B=list(map(vp,q['X_right_factors']));C=list(map(vp,q['Z_left_factors']));D=list(map(vp,q['Z_right_dictionary']));types=[3,5] if block==4 else [0,1,2];X=[outer(a,B[block]) for a in A];Z=[outer(c,D[j]) for c in C for j in types];P=16;m=max(len(X),len(Z));patterns=[[0]*m for _ in range(m)]
 def tword(v):return [(a>>h&1)|((b>>h&1)<<1) for a,b in map(cyclic,parts(v)) for h in range(16)]
 xt=list(map(tword,X))
 for b,z in enumerate(Z):
  for h in range(16):
   zz=tword(z)
   for a,x in enumerate(xt):patterns[a][b]|=(sum((F[u][v]>>1)&1 for u,v in zip(x,zz))%2)<<h
   z=sum((s^((s<<2)&((1<<32)-1)))<<(32*i) for i,s in enumerate(parts(z)))
 return patterns

def verify(data,source,psd=True,rational_psd=None):
 assert data['period']==16
 return verify_patterns(data,patterns_from_source(source,data['block']),psd=psd,rational_psd=rational_psd)

def verify_patterns(data,patterns,psd=True,extra_inequalities=(),rational_psd=None):
 P=data['period'];target=data['target'];assert patterns==data['patterns'];eq,ineq,(p,C,V)=source_constraints(patterns,P,target);ineq.update(extra_inequalities);N=len(p);den=data['denominator'];assert type(den) is int and den>0;D={int(h):M for h,M in data['D'].items()};u=data['mean'];y00=data['constant'];assert len(u)==N and type(y00) is int and all(type(v) is int for v in u)
 assert all(type(v) is int for M in D.values() for r in M for v in r)
 for h in range(P//2+1,P):D[h]=list(map(list,zip(*D[P-h])))
 assert all(D[h][i][j]==D[(-h)%P][j][i] for h in range(P) for i,j in product(range(N),repeat=2))
 r=[0]*V;b=y00
 for term in data['linear_terms']:
  kind=term['kind'];assert kind in ['eq','ineq'];key=(tuple(map(tuple,term['coeff'])),term['rhs']);mult=term['multiplier'];assert type(mult) is int;assert key in (eq if kind=='eq' else ineq)
  if kind=='ineq':assert mult>=0
  for j,v in key[0]:r[j]+=v*mult
  b+=key[1]*mult
 for i in range(N):r[p[i]]-=2*P*u[i]
 for h in range(P):
  for i,j in product(range(N),repeat=2):r[C[h][i][j]]-=P*D[h][i][j]
 lower=sum(min(0,v) for v in r);gap=b-lower;assert gap<0,(b,lower,gap)
 blocks=[]
 if psd and rational_psd is not None:
  from rational_cyclic_psd import verify as verify_rational_psd
  blocks=verify_rational_psd(data,rational_psd)['PSD_blocks']
 elif psd:
  from certify_moment_point import interval_pd
  ctx.prec=256;G=[[arb(fmpq(y00,den)) if i==j==0 else arb(fmpq(4*u[j-1],den)) if i==0 else arb(fmpq(4*u[i-1],den)) if j==0 else arb(fmpq(sum(D[h][i-1][j-1] for h in range(P)),den)) for j in range(N+1)] for i in range(N+1)];blocks.append(interval_pd(arb_mat(G)))
  for k in range(1,P//2+1):
   real=[[arb(0) for _ in range(N)] for _ in range(N)];imag=[[arb(0) for _ in range(N)] for _ in range(N)]
   for h in range(P):
    angle=arb.pi()*fmpq(k*h,8);c=angle.cos();s=angle.sin()
    for i,j in product(range(N),repeat=2):real[i][j]+=c*arb(fmpq(D[h][i][j],den));imag[i][j]+=s*arb(fmpq(D[h][i][j],den))
   M=real if k==P//2 else [real[i]+[-v for v in imag[i]] for i in range(N)]+[imag[i]+real[i] for i in range(N)];blocks.append(interval_pd(arb_mat(M)))
 return {'status':'PASS','evidence':'exact source inequalities, exact integer residual correction using0..1 bounds, and '+('integer rational PSD' if rational_psd is not None else '256-bit interval PSD'),'block':data.get('block'),'excluded_target_pairs':target,'moment_variables':V,'linear_terms':len(data['linear_terms']),'common_denominator':den,'b_dot_y_numerator':b,'box_residual_lower_numerator':lower,'strict_contradiction_gap_numerator':gap,'strict_contradiction_gap':str(fmpq(gap,den)),'PSD_blocks':blocks,'source_C16_answered':False}

def main():
 ap=argparse.ArgumentParser();ap.add_argument('certificate',type=Path);ap.add_argument('--source',type=Path,default=Path(__file__).parent/'inversion-results/normal-form.json');ap.add_argument('--rational-psd',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();from rational_cyclic_psd import read;r=verify(json.loads(a.certificate.read_text()),json.loads(a.source.read_text()),rational_psd=read(a.rational_psd) if a.rational_psd else None);a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r),flush=True)
if __name__=='__main__':main()
