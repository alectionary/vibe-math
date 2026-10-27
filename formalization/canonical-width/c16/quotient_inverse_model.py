#!/usr/bin/env python3
"""Small cyclic quotient models; no unrestricted full-frame descent is assumed."""
import argparse,hashlib,json,subprocess,time
from pathlib import Path
from subgroup_frame import encode

def fold(v,j):
 out=0
 for b in range(8):
  for h in range(16):
   if v>>(16*b+h)&1:out^=1<<(j*b+h%j)
 return out

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--period',type=int,choices=[1,2,4,8],required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=int,default=30);args=ap.parse_args();root=Path(__file__).parent;j=args.period;target=8*j
 X=sorted({fold(int(v,16),j) for v in (root/'pools/xcoords.txt').read_text().split()});Z=sorted({fold(int(v,16),j) for v in (root/'pools/zcoords.txt').read_text().split()});assert len(X)==len(Z) and 0 not in X and 0 not in Z
 patterns=[[(x&z).bit_count()%2 for z in Z] for x in X];clauses,top=encode(patterns,target,coverage=True);cnf=args.output.with_suffix('.cnf');proof=args.output.with_suffix('.drat');log=args.output.with_suffix('.log')
 cnf.write_text(f'p cnf {top} {len(clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in clauses));r={'status':'RUNNING','period':j,'binary_dimension':target,'pool_sizes':[len(X),len(Z)],'variables':top,'clauses':len(clauses),'CNF_SHA256':hashlib.sha256(cnf.read_bytes()).hexdigest(),'source_question_answered':False,'scope':'projected cyclic quotient only; a generic full-frame descent implication is false'};args.output.write_text(json.dumps(r,indent=2)+'\n');start=time.monotonic()
 with log.open('w') as out:
  try:proc=subprocess.run(['/private/tmp/c16-kissat/build/kissat',f'--time={args.seconds}',str(cnf),str(proof)],stdout=out,timeout=args.seconds+5);code=proc.returncode
  except subprocess.TimeoutExpired:code=-15
 text=log.read_text();r.update(seconds=time.monotonic()-start,returncode=code)
 if 's SATISFIABLE' in text:
  model={int(s) for line in text.splitlines() if line.startswith('v ') for s in line[2:].split() if int(s)>0};I=[i for i in range(len(X)) if i+1 in model];J=[k for k in range(len(Z)) if len(X)+k+1 in model];pairs=[]
  for i in I:
   partners=[k for k in J if patterns[i][k]];assert len(partners)==1;pairs.append([X[i],Z[partners[0]]])
  assert len(pairs)==target and all((x&z).bit_count()%2==(a==b) for a,(x,_) in enumerate(pairs) for b,(_,z) in enumerate(pairs));r.update(status='QUOTIENT_FRAME_CHECKED',pairs=pairs)
 elif 's UNSATISFIABLE' in text:
  r['status']='QUOTIENT_UNSAT_PENDING_CHECK';args.output.write_text(json.dumps(r,indent=2)+'\n')
  try:
   checked=subprocess.run(['/private/tmp/c16-drat-trim/drat-trim',str(cnf),str(proof)],capture_output=True,text=True,timeout=60);args.output.with_suffix('.checked.log').write_text(checked.stdout+checked.stderr)
   if checked.returncode==0 and 's VERIFIED' in checked.stdout:r['status']='QUOTIENT_UNSAT_CHECKED'
  except subprocess.TimeoutExpired:r['proof_check']='TIME_LIMIT'
  r['proof_SHA256']=hashlib.sha256(proof.read_bytes()).hexdigest()
 else:r['status']='UNKNOWN'
 args.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({k:v for k,v in r.items() if k!='pairs'}),flush=True)

if __name__=='__main__':main()
