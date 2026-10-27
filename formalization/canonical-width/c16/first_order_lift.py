#!/usr/bin/env python3
"""Construct/control rank-one first-order lifts with the source residue dictionaries.

The fibres here permit all thick-factor first-order coefficients subject to the
source thin-factor congruences. They are a stated relaxation of the90-point
period-two source pool, not the original finite pool.
"""
import argparse,json,random,time
from pathlib import Path
from itertools import product
from pool_inverse_structure import epsilon_word
from dual_basis_cuts import rank_pivots,dual_basis


def fm(a,b):
 out=0
 for i in range(2):
  for j in range(2):
   if a>>i&1 and b>>j&1:out^=1<<(i+j)
 return out^7 if out&4 else out

def sm(a,b):return fm(a&3,b&3)|(fm(a&3,b>>2)^fm(a>>2,b&3))<<2

def sw(v):
 a,b=v;a=epsilon_word(a)&3;b=epsilon_word(b)&3
 return (a&1)|((b&1)<<1)|((a>>1)<<2)|((b>>1)<<3)

def aug(v):return sum(((v>>(4*i))&3)<<(2*i) for i in range(4))
def jet(v):return sum(((v>>(4*i+2))&3)<<(2*i) for i in range(4))
def combine(a,b):return sum((((a>>(2*i))&3)|(((b>>(2*i))&3)<<2))<<(4*i) for i in range(4))
def source_matrix(v):return sum(sw(s)<<(4*i) for i,s in enumerate(v))
def trdot(a,b):return sum((fm(a>>(2*i)&3,b>>(2*i)&3)>>1)&1 for i in range(4))%2
def dual(A):
 d=dual_basis(A,8)
 if d is None:return None
 # H maps trace-covector to standard binary covector: (c,d)->(d,c+d).
 return [sum((((v>>(2*i)&1)^((v>>(2*i+1))&1))|((v>>(2*i)&1)<<1))<<(2*i) for i in range(4)) for v in d]
def J(v):return sum(((v>>(2*(3-i)))&3)<<(2*i) for i in range(4))
def outer(a,b):return sum(fm(a>>(2*i)&3,b>>(2*j)&3)<<(2*(2*j+i)) for i in range(2) for j in range(2))
def determinant(v):
 w=[v>>(4*i)&15 for i in range(4)];return sm(w[0],w[3])^sm(w[1],w[2])
def beta(x,z):
 a,b=aug(x),jet(x);c,d=aug(z),jet(z);return trdot(a,c)^trdot(a,d)^trdot(b,c)
def linear(cols,v):
 out=0
 while v:b=v&-v;v^=b;out^=cols[b.bit_length()-1]
 return out

def inverse(cols,n):
 rows=[sum(((v>>i)&1)<<j for j,v in enumerate(cols)) for i in range(n)];D=dual_basis(rows,n);assert D is not None;return D

def affine_equations(values,n):
 values=set(values);base=min(values);diff=[v^base for v in values];p=rank_pivots(diff,n);assert len(values)==1<<len(p)
 from dual_basis_cuts import nullspace
 return [(w,(w&base).bit_count()%2) for w in nullspace(diff,n)]

def solve_linear(equations,n):
 piv={}
 for row,rhs in equations:
  while row:
   k=row.bit_length()-1
   if k not in piv:piv[k]=(row,rhs);break
   u,b=piv[k];row^=u;rhs^=b
  if not row and rhs:return None
 v=0
 for k in sorted(piv):
  row,rhs=piv[k]
  if ((row&v).bit_count()%2)^rhs:v|=1<<k
 assert all((row&v).bit_count()%2==rhs for row,rhs in equations);return v

def build(data,joint=True):
 dic=data['dictionary'];A=sorted(set(sum(((sw(s)&3)<<(2*i)) for i,s in enumerate(v)) for v in dic['X_left_dictionary']));B=sorted(set(sum(((sw(s)&3)<<(2*i)) for i,s in enumerate(v)) for v in dic['X_right_factors']));C=sorted(set(sum(((sw(s)&3)<<(2*i)) for i,s in enumerate(v)) for v in dic['Z_left_factors']));D=sorted(set(sum(((sw(s)&3)<<(2*i)) for i,s in enumerate(v)) for v in dic['Z_right_dictionary']))
 def fibre(U,V,q,leftthin):
  out={};q=[sw(v) for v in q]
  for a,b in product(U,V):
   key=outer(a,b);vals=set()
   for da,db in product(range(16),repeat=2):
    thin=b if not leftthin else a;dt=db if not leftthin else da
    value=sm(q[0],(thin&3)|((dt&3)<<2))^sm(q[1],(thin>>2)|((dt>>2)<<2))
    if (value>>1&1) or (value>>3&1):continue
    vals.add(outer(da,b)^outer(a,db))
   if key in out:assert out[key]==vals
   out[key]=vals
  return out
 FX=fibre(A,B,data['span_constraints']['thin_factors']['X']['trace_functional_q'],False);FZ=fibre(C,D,data['span_constraints']['thin_factors']['Z']['trace_functional_q'],True)
 P=[[sw(v) for v in c] for c in data['sector_exchange']['P_columns']];Q=[[sw(v) for v in c] for c in data['sector_exchange']['Q_rows']]
 def exchange(v):
  w=[v>>(4*i)&15 for i in range(4)];o=[0]*4
  for r,c,a,b in product(range(2),repeat=4):o[2*c+r]^=sm(sm(P[a][r],w[2*a+b]),Q[b][c])
  return sum(v<<(4*i) for i,v in enumerate(o))
 L=[exchange(1<<i) for i in range(16)];Li=inverse(L,16)
 if joint:
  FX={a:{b for b in vs if jet(exchange(combine(a,b))) in FZ[aug(exchange(combine(a,b)))]} for a,vs in FX.items()}
  FZ={a:{b for b in vs if jet(linear(Li,combine(a,b))) in FX[aug(linear(Li,combine(a,b)))]} for a,vs in FZ.items()}
 for side,F in [('X',FX),('Z',FZ)]:
  for a,vs in F.items():assert vs;affine_equations(vs,8)
  for row in data['tensor'][side+'_tensor_coordinates']:
   v=source_matrix(row);assert jet(v) in F[aug(v)]
 return FX,FZ,L,Li

def build_exact_thin(data):
 FX,FZ,L,Li=build(data,True);dic=data['dictionary']
 def vector_coeff(v,high):return sum(((sw(s)>>(2 if high else 0))&3)<<(2*i) for i,s in enumerate(v))
 A=sorted(set(vector_coeff(v,False) for v in dic['X_left_dictionary']));D=sorted(set(vector_coeff(v,False) for v in dic['Z_right_dictionary']));XX={};ZZ={}
 for a,b in product(A,dic['X_right_factors']):
  b0=vector_coeff(b,False);b1=vector_coeff(b,True);key=outer(a,b0);XX.setdefault(key,set()).update(outer(da,b0)^outer(a,b1) for da in range(16))
 for c,d in product(dic['Z_left_factors'],D):
  c0=vector_coeff(c,False);c1=vector_coeff(c,True);key=outer(c0,d);ZZ.setdefault(key,set()).update(outer(c1,d)^outer(c0,dd) for dd in range(16))
 assert set(XX)==set(FX) and set(ZZ)==set(FZ)
 assert all(vs<=FX[a] for a,vs in XX.items()) and all(vs<=FZ[a] for a,vs in ZZ.items())
 assert {linear(L,combine(a,b)) for a,vs in XX.items() for b in vs}=={combine(a,b) for a,vs in ZZ.items() for b in vs}
 for F in [XX,ZZ]:
  for a,vs in F.items():affine_equations(vs,8)
 return XX,ZZ,L,Li

def find(data,trials,seed,seconds,joint=True,exact_thin=False):
 FX,FZ,L,Li=build_exact_thin(data) if exact_thin else build(data,joint);X=set(FX);Z=set(FZ);S=sorted(a for a in X if J(a) in Z);rng=random.Random(seed);start=time.monotonic();found=None;matching_count=0
 print(json.dumps({'joint':joint,'source_residue_sizes':[len(X),len(Z)],'relaxed_sizes':[sum(map(len,FX.values())),sum(map(len,FZ.values()))],'intersection_rank':len(rank_pivots(S,8)),'X_fibre_sizes':{str(a):len(v) for a,v in FX.items()}}),flush=True)
 for trial in range(trials):
  if time.monotonic()-start>seconds:break
  rng.shuffle(S);A=[]
  for v in S:
   if len(rank_pivots(A+[v],8))>len(A):A.append(v)
   if len(A)==8:break
  if len(A)!=8:break
  DA=dual(A);Cbase=[J(v) for v in A];DCbase=[J(v) for v in DA];directionsX={a:{u^min(FX[a]) for u in FX[a]} for a in A};directionsZ={c:{u^min(FZ[c]) for u in FZ[c]} for c in Cbase}
  graph=[[j for j,c in enumerate(Cbase) if DCbase[j] in directionsX[A[i]] and DA[i] in directionsZ[c]] for i in range(8)]
  order=sorted(range(8),key=lambda i:len(graph[i]));permutation=[None]*8
  def match(k,used):
   if k==8:return True
   i=order[k]
   for j in graph[i]:
    if not used>>j&1:
     permutation[i]=j
     if match(k+1,used|(1<<j)):return True
   return False
  if not match(0,0):continue
  matching_count+=1;C=[Cbase[j] for j in permutation];DC=[DCbase[j] for j in permutation]
  def d_from_b(word):
   BB=[word>>(8*i)&255 for i in range(8)];out=[]
   for j,c in enumerate(C):
    v=0
    for i in range(8):
     if (i==j)^trdot(A[i],c)^trdot(BB[i],c):v^=DA[i]
    out.append(v)
   return out
  constant=d_from_b(0);columns=[[a^b for a,b in zip(d_from_b(1<<k),constant)] for k in range(64)];eq=[]
  for i,a in enumerate(A):eq.extend((w<<(8*i),rhs) for w,rhs in affine_equations(FX[a],8))
  for i,c in enumerate(C):
   for w,rhs in affine_equations(FZ[c],8):eq.append((sum(((w&col[i]).bit_count()%2)<<k for k,col in enumerate(columns)),rhs^((w&constant[i]).bit_count()%2)))
  sol=solve_linear(eq,64)
  if sol is None:continue
  BB=[sol>>(8*i)&255 for i in range(8)];DD=d_from_b(sol);XX=[combine(a,b) for a,b in zip(A,BB)]+[combine(a,b^dc) for a,b,dc in zip(A,BB,DC)];ZZ=[combine(c,d) for c,d in zip(C,DD)]+[combine(c,d^da) for c,d,da in zip(C,DD,DA)]
  assert all(not determinant(v) for v in XX+ZZ);assert all(beta(x,z)==(i==j) for i,x in enumerate(XX) for j,z in enumerate(ZZ));assert all(jet(v) in FX[aug(v)] for v in XX);assert all(jet(v) in FZ[aug(v)] for v in ZZ)
  found={'X_frame':XX,'Z_frame':ZZ,'A':A,'C':C,'B0':BB,'D0':DD,'C_binary_trace_dual':DC,'A_binary_trace_dual':DA,'permutation':permutation,'linear_equations':eq,'solution':sol};break
 return {'status':'COUNTEREXAMPLE_CHECKED' if found else 'NO_EXAMPLE_IN_BOUNDED_FAMILY','joint_thin_exchange_fibres':joint,'exact_five_thin_factors':exact_thin,'attempted_trials':trial+1,'matching_cases':matching_count,'seconds':time.monotonic()-start,'seed':seed,'source_C16_answered':False,'source_period_two_exact_pool_answered':False,'scope':'Relaxed first-order fibres with exact source residue sets, rank-one points and thin-factor congruences; exact90-point pool not retained','X_fibres':{str(a):sorted(vs) for a,vs in FX.items()},'Z_fibres':{str(a):sorted(vs) for a,vs in FZ.items()},'exchange_columns':L,'exchange_inverse_columns':Li,'witness':found}

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,default=Path(__file__).parent/'inversion-results/normal-form.json');ap.add_argument('--trials',type=int,default=10000);ap.add_argument('--seconds',type=float,default=30);ap.add_argument('--seed',type=int,default=20261027);ap.add_argument('--no-joint',action='store_true');ap.add_argument('--exact-thin',action='store_true');ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();r=find(json.loads(a.certificate.read_text()),a.trials,a.seed,a.seconds,not a.no_joint,a.exact_thin);a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({k:v for k,v in r.items() if k not in ['X_fibres','Z_fibres','exchange_columns','exchange_inverse_columns','witness']}),flush=True)
if __name__=='__main__':main()
