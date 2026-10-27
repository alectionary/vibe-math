#!/usr/bin/env python3
"""Rectangular full-frame CNF with faithful short-circuit and cyclic cuts."""
from pathlib import Path
from itertools import combinations
from collections import defaultdict
import argparse,json,subprocess,time,hashlib
from pysat.card import CardEnc,EncType
from frame_sat import SharedCounters
from add_frame_symmetry import lex_clauses
from dual_basis_cuts import rank_pivots

def rectangular_encode(patterns,target,coverage=True):
 m=len(patterns);n=len(patterns[0]);counter=SharedCounters(m+n);clauses=counter.clauses
 rows=[sum(bool(v)<<j for j,v in enumerate(row)) for row in patterns];cols=[sum(bool(patterns[i][j])<<i for i in range(m)) for j in range(n)]
 for base,other,masks in [(0,m,rows),(m,0,cols)]:
  for i,mask in enumerate(masks):
   if not mask:
    clauses.append([] if coverage else [-base-i-1]);continue
   one,two=counter.count(mask,other);clauses.append([-base-i-1,one])
   if two:clauses.append([-base-i-1,-two])
   if coverage:clauses.append([other+j+1 for j in range(mask.bit_length()) if mask>>j&1])
 top=counter.top
 for base,size in [(0,m),(m,n)]:
  enc=CardEnc.equals([base+i+1 for i in range(size)],target,top_id=top,encoding=EncType.kmtotalizer);clauses.extend(enc.clauses);top=enc.nv
 return clauses,top

def circuits(V,maximum):
 ids={v:i for i,v in enumerate(V)};pairs=defaultdict(list);out=set()
 def save(row):
  row=tuple(sorted(row))
  if len(set(row))!=len(row) or len(row)>maximum:return
  if len(rank_pivots([V[i] for i in row],128))==len(row)-1:out.add(row)
 for i,j in combinations(range(len(V)),2):
  w=V[i]^V[j];pairs[w].append((i,j))
  if w in ids:save((i,j,ids[w]))
 for entries in pairs.values():
  for a,b in combinations(entries,2):save(a+b)
 if maximum>=5:
  triples=defaultdict(list)
  for t in combinations(range(len(V)),3):
   w=V[t[0]]^V[t[1]]^V[t[2]]
   for p in pairs.get(w,[]):save(t+p)
   if maximum>=6:triples[w].append(t)
  if maximum>=6:
   for entries in triples.values():
    for a,b in combinations(entries,2):save(a+b)
 return sorted(out)

def cyclic(v,period,blocks):
 out=0;mask=(1<<period)-1
 for b in range(blocks):
  w=v>>(period*b)&mask;out|=(((w<<1)|(w>>(period-1)))&mask)<<(period*b)
 return out

def build(d,maximum=4,period=None):
 X,Z=d['X'],d['Z'];target=d['dimension'];patterns=[[(x&z).bit_count()%2 for z in Z] for x in X];clauses,top=rectangular_encode(patterns,target);stats={}
 if maximum:
  for V,base,name in [(X,0,'X'),(Z,len(X),'Z')]:
   cs=circuits(V,maximum);clauses.extend([-(base+i+1) for i in c] for c in cs);stats[name+'_circuits']=len(cs)
 if period:
  blocks=target//period;lookupX={v:i for i,v in enumerate(X)};lookupZ={v:i for i,v in enumerate(Z)};right=[]
  for V,lookup,base in [(X,lookupX,0),(Z,lookupZ,len(X))]:right.extend(base+lookup[cyclic(v,period,blocks)]+1 for v in V)
  # Every group orbit has a lex-minimum primary assignment; one generator cut is valid.
  cs,top=lex_clauses(list(range(1,len(X)+len(Z)+1)),right,top);clauses.extend(cs);stats['cyclic_generator_lex']=True
 return clauses,top,stats

def main():
 ap=argparse.ArgumentParser();ap.add_argument('input',type=Path);ap.add_argument('--circuits',type=int,choices=[0,4,5,6],default=4);ap.add_argument('--period',type=int);ap.add_argument('--seconds',type=int,default=600);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--proof',action='store_true');args=ap.parse_args();d=json.loads(args.input.read_text());start=time.monotonic();clauses,top,stats=build(d,args.circuits,args.period);cnf=args.output.with_suffix('.cnf');log=args.output.with_suffix('.log');proof=args.output.with_suffix('.drat');cnf.write_text(f'p cnf {top} {len(clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in clauses));r={'status':'RUNNING','scope':d.get('scope','Input finite pool only'),'dimension':d['dimension'],'pool_sizes':[len(d['X']),len(d['Z'])],'variables':top,'clauses':len(clauses),'circuit_maximum':args.circuits,'period_symmetry':args.period,'build_seconds':time.monotonic()-start,'statistics':stats,'CNF_SHA256':hashlib.sha256(cnf.read_bytes()).hexdigest(),'source_C16_answered':False};args.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r),flush=True)
 with log.open('w') as out:
  try:proc=subprocess.run(['/private/tmp/c16-kissat/build/kissat',f'--time={args.seconds}',str(cnf),*([str(proof)] if args.proof else [])],stdout=out,timeout=args.seconds+10);code=proc.returncode
  except subprocess.TimeoutExpired:code=-15
 text=log.read_text();r['returncode']=code
 if 's SATISFIABLE' in text:
  model={int(v) for line in text.splitlines() if line.startswith('v ') for v in line[2:].split() if int(v)>0};X,Z=d['X'],d['Z'];I=[i for i in range(len(X)) if i+1 in model];J=[j for j in range(len(Z)) if len(X)+j+1 in model];pairs=[]
  for i in I:
   mate=[j for j in J if (X[i]&Z[j]).bit_count()%2];assert len(mate)==1;pairs.append([X[i],Z[mate[0]]])
  assert len(pairs)==d['dimension'] and all((x&z).bit_count()%2==(i==j) for i,(x,_) in enumerate(pairs) for j,(_,z) in enumerate(pairs));r.update(status='FINITE_FRAME_CHECKED',pairs=pairs)
 elif 's UNSATISFIABLE' in text:
  r['status']='UNSAT_UNCHECKED'
  if args.proof:
   try:
    p=subprocess.run(['/private/tmp/c16-drat-trim/drat-trim',str(cnf),str(proof)],capture_output=True,text=True,timeout=120);args.output.with_suffix('.checked.log').write_text(p.stdout+p.stderr)
    if p.returncode==0 and 's VERIFIED' in p.stdout:r['status']='UNSAT_CHECKED'
   except subprocess.TimeoutExpired:r['proof_replay']='TIME_LIMIT'
 else:r['status']='UNKNOWN'
 r['total_seconds']=time.monotonic()-start;args.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({k:v for k,v in r.items() if k!='pairs'}),flush=True)
if __name__=='__main__':main()
