#!/usr/bin/env python3
"""One-sided inverse-pool membership via binary functional lower-cover cuts.

For |B|=dim(V), B and its dual lie in X,Z iff every nonzero w meets B
at least once, and at least twice when w is not in Z. The oracle computes
nullspace vectors or the unique dual basis; it never assumes cyclic symmetry.
"""
from pathlib import Path
import argparse,json,time,sys,subprocess
from pysat.solvers import Solver
from pysat.card import CardEnc,EncType
from quotient_inverse_model import fold


def rank_pivots(rows,n):
 piv={}
 for a,v in enumerate(rows):
  tag=1<<a
  while v:
   p=v.bit_length()-1
   if p not in piv:piv[p]=(v,tag);break
   u,t=piv[p];v^=u;tag^=t
 return piv

def nullspace(rows,n):
 piv=rank_pivots(rows,n);out=[]
 for j in range(n):
  if j in piv:continue
  v=1<<j
  for p in sorted(piv):
   if (piv[p][0]&v).bit_count()%2:v^=1<<p
  assert all((v&r).bit_count()%2==0 for r in rows);out.append(v)
 return out

def dual_basis(rows,n):
 assert len(rows)==n
 piv=rank_pivots(rows,n)
 if len(piv)!=n:return None
 # Solve rows dot z=e_i using the same fixed binary Gauss-Jordan convention.
 A=[v|(1<<(n+i)) for i,v in enumerate(rows)]
 for j in range(n):
  k=next(k for k in range(j,n) if A[k]>>j&1);A[j],A[k]=A[k],A[j]
  for k in range(n):
   if k!=j and A[k]>>j&1:A[k]^=A[j]
 inverse_rows=[a>>n for a in A]
 dual=[sum(((v>>i)&1)<<j for j,v in enumerate(inverse_rows)) for i in range(n)]
 assert all((x&z).bit_count()%2==(i==j) for i,x in enumerate(rows) for j,z in enumerate(dual));return dual

class CoverCNF:
 def __init__(self,variables):self.top=variables;self.clauses=[]
 def fresh(self):self.top+=1;return self.top
 def at_least(self,lits,k):
  if k==1:self.clauses.append(list(lits));return
  assert k==2
  if len(lits)<2:self.clauses.append([]);return
  # Full prefix threshold equivalences. Constants are simplified at the first step.
  p=lits[0];q=None
  for x in lits[1:]:
   pp=self.fresh();self.clauses.extend([[-p,pp],[-x,pp],[p,x,-pp]])
   qq=self.fresh()
   if q is None:self.clauses.extend([[-qq,p],[-qq,x],[-p,-x,qq]])
   else:self.clauses.extend([[-q,qq],[-p,-x,qq],[-qq,q,p],[-qq,q,x]])
   p,q=pp,qq
  self.clauses.append([q])

def oracle(B,Z,n):
 dual=dual_basis(B,n)
 if dual is None:return [(w,1 if w in Z else 2) for w in nullspace(B,n)],None
 return [(w,2) for w in dual if w not in Z],dual

def run(X,Z,n,seconds,out,initial_weight=0,complete=False):
 start=time.monotonic();Z=set(Z);cnf=CoverCNF(len(X));card=CardEnc.equals(list(range(1,len(X)+1)),bound=n,top_id=cnf.top,encoding=EncType.seqcounter);cnf.top=card.nv;cnf.clauses.extend(card.clauses);cuts=[];seen=set();history=[]
 def add(w,k):
  if w in seen:return
  seen.add(w);lits=[i+1 for i,x in enumerate(X) if (x&w).bit_count()%2];before=len(cnf.clauses);cnf.at_least(lits,k);cuts.append({'w':w,'minimum':k,'support_size':len(lits)})
  if solver is not None:
   for c in cnf.clauses[before:]:solver.add_clause(c)
 solver=None
 if complete or initial_weight:
  assert n<=16
  for w in range(1,1<<n):
   size=sum((x&w).bit_count()%2 for x in X)
   if complete or size<=initial_weight:add(w,1 if w in Z else 2)
 for w in Z:add(w,1)
 status='UNKNOWN';witness=None
 # Incremental SAT; parent owns wall timeout and sends termination only to this child.
 with Solver(name='cadical195',bootstrap_with=cnf.clauses) as solver:
  while time.monotonic()-start<seconds:
   sat=solver.solve()
   if not sat:status='UNSAT_UNCHECKED';break
   model={v for v in solver.get_model() if v>0};B=[x for i,x in enumerate(X) if i+1 in model];assert len(B)==n
   missing,dual=oracle(B,Z,n)
   if not missing:status='FRAME_CHECKED';witness=list(zip(B,dual));break
   for w,k in missing:add(w,k)
   history.append({'iteration':len(history)+1,'cuts':len(cuts),'rank':len(rank_pivots(B,n)),'bad_duals':len(missing),'seconds':time.monotonic()-start})
   if len(history)%10==0:print(json.dumps(history[-1]),flush=True)
   checkpoint={'status':'RUNNING','n':n,'X_size':len(X),'Z_size':len(Z),'cuts':cuts,'history':history,'source_C16_answered':False};out.write_text(json.dumps(checkpoint,indent=2)+'\n')
 solver=None
 result={'status':status,'n':n,'X_size':len(X),'Z_size':len(Z),'cuts':cuts,'history':history,'seconds':time.monotonic()-start,'source_C16_answered':False,'pairs':witness};out.write_text(json.dumps(result,indent=2)+'\n');out.with_suffix('.cnf').write_text(f'p cnf {cnf.top} {len(cnf.clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in cnf.clauses));print(json.dumps({k:v for k,v in result.items() if k not in ['cuts','history','pairs']}),flush=True)

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--period',type=int,choices=[1,2,4,16],required=True);ap.add_argument('--seconds',type=float,default=60);ap.add_argument('--initial-weight',type=int,default=0);ap.add_argument('--complete',action='store_true');ap.add_argument('--output',type=Path,required=True);ap.add_argument('--child',action='store_true');args=ap.parse_args()
 if not args.child:
  proc=subprocess.Popen([sys.executable,str(Path(__file__).resolve()),*sys.argv[1:],'--child'])
  try:proc.wait(timeout=args.seconds+20)
  except subprocess.TimeoutExpired:
   proc.terminate()
   try:proc.wait(timeout=2)
   except subprocess.TimeoutExpired:proc.kill();proc.wait()
   if args.output.exists():r=json.loads(args.output.read_text())
   else:r={}
   r.update(status='PROCESS_TIME_LIMIT',source_C16_answered=False);args.output.write_text(json.dumps(r,indent=2)+'\n');return
  if proc.returncode:raise SystemExit(proc.returncode)
  return
 root=Path(__file__).parent;j=args.period
 pools={s:sorted({fold(int(v,16),j) for v in (root/f'pools/{s}coords.txt').read_text().split()}) if j<16 else [int(v,16) for v in (root/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']}
 run(pools['x'],pools['z'],8*j,args.seconds,args.output,args.initial_weight,args.complete)
if __name__=='__main__':main()
