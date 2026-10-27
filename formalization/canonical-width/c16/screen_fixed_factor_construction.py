import sys,json
from pathlib import Path
from collections import Counter
from itertools import combinations

from pool_inverse_structure import *
import argparse
ap=argparse.ArgumentParser();ap.add_argument('certificate',type=Path);ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();d=json.loads(args.certificate.read_text())['dictionary'];A=d['X_left_dictionary'];B=d['X_right_factors'];C=d['Z_left_factors'];D=d['Z_right_dictionary']
def sstar(x):return tuple(star(v) for v in x)
def sdot(u,v):return sadd(smul(u[0],sstar(v[0])),smul(u[1],sstar(v[1])))
def phi(x):return x[1]&1
F=[[sdot(u,v) for v in C] for u in A];print('F zero positions',[[j for j,v in enumerate(row) if v==(0,0)] for row in F]);cases=[]
for i,j in combinations(range(9),2):
 for k,l in combinations(range(5),2):
  for k,l in [(k,l),(l,k)]:
   if F[i][l]==F[j][k]==(0,0) and sunit(F[i][k]) and sunit(F[j][l]):cases.append([i,j,k,l,F[i][k],F[j][l]])
print('controlled left dual factor cases',len(cases));scalars={tuple(p) for row in cases for p in row[-2:]};print('distinct diagonal scalars',len(scalars))
reports=[]
for p in sorted(scalars):
 X=[[rotate_s(v,h) for v in u] for u in B for h in range(16)];Z=[[rotate_s(v,h) for v in u] for u in D for h in range(16)]
 rows=[sum(phi(smul(p,sdot(x,z)))<<j for j,z in enumerate(Z)) for x in X];columns=[sum(((row>>j)&1)<<i for i,row in enumerate(rows)) for j in range(144)]
 report={'scalar':p,'rank':rank_binary(rows),'X_degree_histogram':dict(Counter(v.bit_count() for v in rows)),'Z_degree_histogram':dict(Counter(v.bit_count() for v in columns))};reports.append(report)
print(reports)
args.output.write_text(json.dumps({'left_cases':cases,'factor_graphs':reports},indent=2)+'\n')
