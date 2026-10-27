#!/usr/bin/env python3
"""Bounded period-two scalar-unit relaxation, preserving projective pool lines."""
from pathlib import Path
import argparse,json,subprocess,time
from quotient_inverse_model import fold
from subgroup_frame import encode

def omega(v):
 out=0
 for i in range(4):
  a=v>>(4*i)&3;b=v>>(4*i+2)&3;out|=b<<(4*i);out|=(a^b)<<(4*i+2)
 return out

def eps(v):return v^sum((((v>>(2*i)&1)<<1)|((v>>(2*i+1))&1))<<(2*i) for i in range(8))
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--seconds',type=int,default=120);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();root=Path(__file__).parent
 pools={s:sorted({fold(int(v,16),2) for v in (root/f'pools/{s}coords.txt').read_text().split()}) for s in ['x','z']};original={s:set(v) for s,v in pools.items()}
 for s,V in pools.items():pools[s]=sorted(set(V)|{v^eps(omega(v)) for v in V})
 X,Z=pools['x'],pools['z'];clauses,top=encode([[(x&z).bit_count()%2 for z in Z] for x in X],16,True);cnf=a.output.with_suffix('.cnf');proof=a.output.with_suffix('.drat');log=a.output.with_suffix('.log');cnf.write_text(f'p cnf {top} {len(clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in clauses));r={'status':'RUNNING','X':X,'Z':Z,'pool_sizes':[len(X),len(Z)],'original_pool_sizes':[90,90],'source_C16_answered':False,'scope':'Period-two source pool enlarged by nilpotent scalar units1+epsilon*omega, retaining the exact projective lines and residue sets','variables':top,'clauses':len(clauses)};a.output.write_text(json.dumps(r,indent=2)+'\n')
 with log.open('w') as out:
  try:proc=subprocess.run(['/private/tmp/c16-kissat/build/kissat',f'--time={a.seconds}',str(cnf),str(proof)],stdout=out,timeout=a.seconds+5);code=proc.returncode
  except subprocess.TimeoutExpired:code=-15
 text=log.read_text();r['solver_returncode']=code
 if 's SATISFIABLE' in text:
  model={int(v) for line in text.splitlines() if line.startswith('v ') for v in line[2:].split() if int(v)>0};I=[i for i in range(len(X)) if i+1 in model];J=[j for j in range(len(Z)) if len(X)+j+1 in model];pairs=[]
  for i in I:
   jj=[j for j in J if (X[i]&Z[j]).bit_count()%2];assert len(jj)==1;pairs.append([X[i],Z[jj[0]]])
  assert len(pairs)==16 and all((x&z).bit_count()%2==(i==j) for i,(x,_) in enumerate(pairs) for j,(_,z) in enumerate(pairs));r.update(status='ENLARGED_QUOTIENT_FRAME_CHECKED',pairs=pairs,original_pool_pair_count=sum(x in original['x'] and z in original['z'] for x,z in pairs))
 elif 's UNSATISFIABLE' in text:
  r['status']='ENLARGED_QUOTIENT_UNSAT_UNCHECKED';p=subprocess.run(['/private/tmp/c16-drat-trim/drat-trim',str(cnf),str(proof)],capture_output=True,text=True,timeout=60);a.output.with_suffix('.checked.log').write_text(p.stdout+p.stderr)
  if p.returncode==0 and 's VERIFIED' in p.stdout:r['status']='ENLARGED_QUOTIENT_UNSAT_CHECKED'
 else:r['status']='UNKNOWN'
 a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({k:v for k,v in r.items() if k not in ['X','Z','pairs']}),flush=True)
if __name__=='__main__':main()
