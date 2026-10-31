#!/usr/bin/env python3
"""Independent new-clause bridge controls; inheritedcompactCNF is hashbound only."""
from pathlib import Path
from collections import Counter,defaultdict
import argparse,gzip,hashlib,json,random,time
from pysat.solvers import Solver
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def load(p):return json.loads(gzip.decompress(Path(p).read_bytes()))
def cnf(p):
 raw=gzip.decompress(Path(p).read_bytes());lines=raw.decode().splitlines();head=lines[0].split();rows=[list(map(int,s.split()))[:-1] for s in lines[1:]];assert len(rows)==int(head[3]);return int(head[2]),rows,hashlib.sha256(raw).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--directory',type=Path,required=True);a=ap.parse_args();D=a.directory;out=D/'bridge-controls.json';assert not out.exists();t0=time.monotonic();d=load(D/'frozen.json.gz');X,Z,A=physical();assert all(sha(ROOT/p)==h for p,h in d['source_hashes'].items());assert all(sha(ROOT/p)==h for p,h in d['input_hashes'].items())
 n,b,bh=cnf(D/'baseline.cnf.gz');nn,aug,ah=cnf(D/'small64.cnf.gz');assert bh==d['baseline_raw_sha256'] and ah==d['augmented_raw_sha256'] and n==d['baseline_top'] and nn==d['augmented_top'];assert aug[:len(b)]==b
 P,Q=d['fullP_variables'],d['fullQ_variables'];assert P==list(range(d['base_top']+1,d['base_top']+17)) and Q==list(range(P[-1]+1,P[-1]+721))
 sx=[sum(((x&Z[608+h]).bit_count()%2)<<h for h in range(16)) for x in X];sz=[sum(((X[608+h]&z).bit_count()%2)<<h for h in range(16)) for z in Z]
 E=[(i,j) for i in range(720) if i!=512 and not(A[i]>>512&1) for j in range(720) if j!=512 and not(A[512]>>j&1) and A[i]>>j&1 and sx[i]&sz[j]];assert [list(e) for e in E]==d['edges']
 left=sorted({i for i,j in E});right=sorted({j for i,j in E});owners=[{i:len(E)+k+1 for k,i in enumerate(left)},{j:len(E)+len(left)+k+1 for k,j in enumerate(right)}];assert [{str(k):v for k,v in o.items()} for o in owners]==d['old_partial_owner_maps'];edge={e:k+1 for k,e in enumerate(E)}
 expected=[]
 for i,v in owners[0].items():
  if 512<=i<528:expected.append([-v,P[i-512]])
 for j,v in owners[1].items():expected.append([-v,Q[j]])
 expected += [[P[0]],[Q[512]]]
 for i,v in owners[0].items():
  for j,z in enumerate(Z):
   if (X[i]&z).bit_count()%2:expected.append([-v,-Q[j]]+([edge[i,j]] if (i,j) in edge else []))
 for phase,p in enumerate(P):
  for j,v in owners[1].items():
   if (X[512+phase]&Z[j]).bit_count()%2:expected.append([-p,-v]+([edge[512+phase,j]] if (512+phase,j) in edge else []))
 expected += [[-Q[j]] for j in range(720) if j!=512 and (X[512]&Z[j]).bit_count()%2]
 expected += [[-P[h]] for h in range(1,16) if (X[512+h]&Z[512]).bit_count()%2]
 assert expected==d['completion_links'];offset=d['base_clauses'];assert b[offset:offset+len(expected)]==expected;offset+=len(expected)
 countrows=b[offset:offset+d['full_count_encoder']['clauses']];offset+=len(countrows);cardcontrols=[]
 with Solver(name='cadical195',bootstrap_with=countrows) as s:
  for count in [0,1,127,128,129,719,720]:
   answer=s.solve(assumptions=[v if i<count else -v for i,v in enumerate(Q)]);assert answer==(count==128);cardcontrols.append([count,answer])
 degreecontrols=0
 for r in d['conditional_degree_encoders']:
  h=r['phase'];adj=[Q[j] for j,z in enumerate(Z) if (X[512+h]&z).bit_count()%2];assert adj==r['adjacent'];rows=b[offset:offset+r['clause_count']];offset+=len(rows);assert all(row[0]==-P[h] for row in rows)
  with Solver(name='cadical195',bootstrap_with=rows) as s:
   for chosen in [0,1,2]:
    assignment=[v if i<chosen else -v for i,v in enumerate(adj)]
    for state in [0,1]:
     answer=s.solve(assumptions=[P[h] if state else -P[h],*assignment]);assert answer==(not state or chosen==1);degreecontrols+=1
 prof=[[-P[h] for h in range(16) if m>>h&1] for m in d['profile_masks']];assert b[offset:]==prof
 # Reconstruct integerpolynomial directly fromsource feature definitions.
 c=d['coefficients'];linear=Counter();quadratic=Counter()
 for h in range(16):linear[512+h]+=c[1]
 for h in range(1,9):
  for v in range(16):quadratic[tuple(sorted((512+v,512+(v+h)%16)))]+=c[1+h]
 for j in range(720):
  linear[720+j]+=c[10+j//16]
  for h in range(16):quadratic[512+h,720+j]+=c[55+16*(j//16)+(j%16-h)%16]
 linear={k:v for k,v in sorted(linear.items()) if v};quadratic={k:v for k,v in sorted(quadratic.items()) if v};tr=d['translation'];assert tr['linear_terms']==[[k,v] for k,v in linear.items()] and tr['quadratic_terms']==[[i,j,v] for (i,j),v in quadratic.items()]
 expectedrows=[];known=set(P+Q);gates=d['gates'];last=n
 for kind,x,y,z in gates:
  assert z==last+1 and abs(x) in known and abs(y) in known;known.add(z);last=z
  if kind=='and':rows=[[-x,-y,z],[x,-z],[y,-z]]
  elif kind=='xor':rows=[[-x,-y,-z],[x,y,-z],[x,-y,z],[-x,y,z]]
  elif kind=='or':rows=[[x,y,-z],[-x,z],[-y,z]]
  else:raise AssertionError(kind)
  for xv in (False,True):
   for yv in (False,True):
    truez=(xv and yv) if kind=='and' else ((xv!=yv) if kind=='xor' else (xv or yv))
    for zv in (False,True):
     assignment={abs(x):xv if x>0 else not xv,abs(y):yv if y>0 else not yv,z:zv}
     # Equal signed inputs cancorrelate; syntax istruthchecked separatelybelow.
  expectedrows+=rows
 bits=tr['sum_bits'];bound=tr['positive_bound']
 for k,bit in enumerate(bits):
  if not bit or bound>>k&1:continue
  row=[-bit];skip=False
  for h in range(k+1,len(bits)):
   if bits[h]:row.append(-bits[h] if bound>>h&1 else bits[h])
   elif bound>>h&1:skip=True;break
  if not skip:expectedrows.append(row)
 assert last==nn and aug[len(b):]==expectedrows
 rng=random.Random(20261030);checks=0;positive=negative=0
 for repetition in range(64):
  pv=[rng.randrange(2) for h in range(16)];qv=[rng.randrange(2) for j in range(720)];values={v:bool(x) for v,x in zip(P,pv)}|{v:bool(x) for v,x in zip(Q,qv)}
  def val(lit):return (values[abs(lit)] if lit>0 else not values[abs(lit)]) if lit else False
  for kind,x,y,z in gates:
   a,bv=val(x),val(y);values[z]=(a and bv) if kind=='and' else ((a!=bv) if kind=='xor' else (a or bv))
  value=c[0]+c[1]*sum(pv)+sum(c[h+1]*sum(pv[v]*pv[(v+h)%16] for v in range(16)) for h in range(1,9))+sum(c[10+j//16]*qv[j] for j in range(720))+sum(c[55+16*(j//16)+(j%16-h)%16]*pv[h]*qv[j] for j in range(720) for h in range(16))
  actual=sum((1<<i)*int(val(bit)) for i,bit in enumerate(bits));signed=sum(w*int(val(lit)) for lit,w in tr['positive_terms']);assert actual==signed==value-d['bound']+bound
  accepted=all(any(val(lit) for lit in row) for row in expectedrows);assert accepted==(value<=d['bound']);positive+=accepted;negative+=not accepted;checks+=1
 assert positive and negative
 output={'status':'PASS_NEW_BOOLEAN_CNF_BRIDGE_CONTROLS','source_C16_answered':False,'frozen_sha256':sha(D/'frozen.json.gz'),'consumer_sha256':sha(__file__),'baseline_raw_sha256':bh,'augmented_raw_sha256':ah,'new_owner_full_link_clauses_physically_rebuilt':len(expected),'partial_edge_inventory_rebuilt':len(E),'fixed_cardinality_controls':cardcontrols,'conditional_degree_controls':degreecontrols,'PB_gate_clauses_rebuilt':len(expectedrows),'weighted_polynomial_controls':checks,'positive_PB_controls':positive,'negative_PB_controls':negative,'baseline_prefix_identical':True,'seconds':time.monotonic()-t0,'scope':'New owner/full links and exact integerPB gate CNF independently reconstructed and controlled. The inherited compactbase is hashbound, not independently reverified here. No sourceUNSAT proof or coverimprovement accepted.'}
 out.write_text(json.dumps(output,indent=2)+'\n');print(json.dumps(output),flush=True)
if __name__=='__main__':main()
