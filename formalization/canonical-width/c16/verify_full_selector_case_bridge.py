#!/usr/bin/env python3
"""Independent physical two-sided threshold kernel and reused exactPB bridge."""
from pathlib import Path
import argparse,gzip,hashlib,json,time
from pysat.card import CardEnc,EncType
from pysat.solvers import Solver
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def cnf(p):
 raw=gzip.decompress(Path(p).read_bytes());lines=raw.decode().splitlines();_,_,n,m=lines[0].split();rows=[list(map(int,l.split()))[:-1] for l in lines[1:]];assert len(rows)==int(m);return int(n),rows,hashlib.sha256(raw).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--directory',type=Path,required=True);a=ap.parse_args();D=a.directory;out=D/'bridge-controls.json';assert not out.exists();t=time.monotonic();f=read(D/'frozen.json.gz');assert all(sha(ROOT/p)==h for p,h in f['source_hashes'].items());assert all(sha(ROOT/p)==h for p,h in f['input_hashes'].items());X,Z,A=physical();assert len(X)==len(Z)==720 and dimension(X)==dimension(Z)==128 and all(X) and all(Z)
 B=[sum(((x&Z[i]).bit_count()%2)<<j for j,x in enumerate(X)) for i in range(720)];assert B==A
 n,baseline,bsha=cnf(D/'baseline.cnf.gz');nn,aug,asha=cnf(D/'small64.cnf.gz');assert bsha==f['baseline_raw_sha256'] and asha==f['augmented_raw_sha256'];assert aug[:len(baseline)]==baseline
 top=1440;cache={};rows=[];nodes=[]
 def count(mask,base):
  nonlocal top
  ids=[i for i in range(720) if mask>>i&1];assert ids
  if len(ids)==1:return base+ids[0]+1,0
  if (base,mask) in cache:return cache[base,mask]
  step=1<<((ids[0]^ids[-1]).bit_length()-1);boundary=ids[-1]//step*step;left=sum(1<<i for i in ids if i<boundary);right=mask^left;assert left and right
  a,a2=count(left,base);b,b2=count(right,base);top+=1;one=top;top+=1;two=top;clauses=[[-a,one],[-b,one],[-one,a,b],[-a,-b,two]]
  if a2:clauses.append([-a2,two])
  if b2:clauses.append([-b2,two])
  optional=[x for x in [a2,b2] if x];clauses += [[-two,*optional,a],[-two,*optional,b]];rows.extend(clauses);nodes.append((a,a2,b,b2,one,two,clauses));cache[base,mask]=(one,two);return one,two
 roots=[]
 for i in range(720):
  z1,z2=count(A[i],720);x1,x2=count(B[i],0);rows.extend([[z1],[x1]]);rows.append([-i-1,-z2]) if z2 else None;rows.append([-721-i,-x2]) if x2 else None;roots.append([z1,z2,x1,x2])
 assert roots==f['kernel_roots'] and top==f['kernel_top'] and len(rows)==f['kernel_clauses'] and baseline[:len(rows)]==rows
 # Exhaustivelocalcountersemantics for every distinct syntactic childshape.
 shapes={bool(a2),bool(b2)} if False else {(bool(a2),bool(b2)) for a,a2,b,b2,o,t,c in nodes};truthchecks=0
 for hasA,hasB in shapes:
  for ca in range(3 if hasA else 2):
   for cb in range(3 if hasB else 2):
    av,a2v,bv,b2v=ca>0,ca>1,cb>0,cb>1
    for ov in [False,True]:
     for tv in [False,True]:
      satisfied=(not av or ov) and (not bv or ov) and (not ov or av or bv) and (not av or not bv or tv) and (not hasA or not a2v or tv) and (not hasB or not b2v or tv) and (not tv or (hasA and a2v) or (hasB and b2v) or av) and (not tv or (hasA and a2v) or (hasB and b2v) or bv)
      assert satisfied==(ov==(ca+cb>=1) and tv==(ca+cb>=2));truthchecks+=1
 offset=len(rows);cardchecks=[]
 for r in f['cardinality_encoders']:
  assert r['top_before']==top;ids=list(range(r['base']+1,r['base']+721));enc=CardEnc.equals(ids,128,top_id=top,encoding=EncType.kmtotalizer);top=enc.nv;assert top==r['top_after'] and len(enc.clauses)==r['clauses'] and baseline[offset:offset+len(enc.clauses)]==enc.clauses;offset+=len(enc.clauses)
  with Solver(name='cadical195',bootstrap_with=enc.clauses) as s:
   for k in [0,1,127,128,129,719,720]:
    ans=s.solve(assumptions=[v if i<k else -v for i,v in enumerate(ids)]);assert ans==(k==128);cardchecks.append([r['base'],k,ans])
 units=[[513],[1233]]+[[-i-1] for i in range(720) if i!=512 and (X[i]&Z[512]).bit_count()%2]+[[-721-j] for j in range(720) if j!=512 and (X[512]&Z[j]).bit_count()%2];assert baseline[offset:]==units==f['fixed_anchor_units'] and top==n
 ref=ROOT/f['PB_reference_directory'];rf=read(ref/'frozen.json.gz');receipt=read(ref/'bridge-controls.json');assert receipt['status']=='PASS_NEW_BOOLEAN_CNF_BRIDGE_CONTROLS' and receipt['frozen_sha256']==sha(ref/'frozen.json.gz') and receipt['consumer_sha256']==sha(ROOT/'verify_full_basis_boolean_cnf.py');assert rf['coefficients']==f['coefficients'] and rf['bound']==f['bound']==0
 rn,rbase,rh=cnf(ref/'baseline.cnf.gz');rnn,raug,rah=cnf(ref/'small64.cnf.gz');assert rh==receipt['baseline_raw_sha256'] and rah==receipt['augmented_raw_sha256'];mapping=dict(zip(rf['fullP_variables'],f['fullP_variables']))|dict(zip(rf['fullQ_variables'],f['fullQ_variables']));mapping.update({v:n+v-rn for v in range(rn+1,rnn+1)})
 mapped=[[mapping[abs(v)]*(1 if v>0 else -1) for v in row] for row in raug[len(rbase):]];assert mapped==aug[len(baseline):] and nn-n==rnn-rn
 outdata={'status':'PASS_NEW_BOOLEAN_CNF_BRIDGE_CONTROLS','source_C16_answered':False,'model_kind':'EXACT_FULL128_BY128_PHYSICAL_SELECTOR','frozen_sha256':sha(D/'frozen.json.gz'),'consumer_sha256':sha(__file__),'baseline_raw_sha256':bsha,'augmented_raw_sha256':asha,'physical_pairing_entries_rebuilt':720*720,'shared_threshold_nodes_rebuilt':len(cache),'threshold_truth_table_controls':truthchecks,'kernel_clauses_rebuilt':len(rows),'cardinality_controls':cardchecks,'fixed_anchor_units_rebuilt':len(units),'PB_clauses_exactly_relabelled_from_accepted_control':len(mapped),'PB_reference_control_sha256':sha(ref/'bridge-controls.json'),'baseline_prefix_identical':True,'seconds':time.monotonic()-t,'source_equivalence':'Two128selector sets with selectedrowandcolumndegree1 producea128x128permutationpairingmatrix andthusphysicaldualbases. AtrueSATmodel stillrequiresliteralpairreplay; UNSATrequiresproofreplay.'};out.write_text(json.dumps(outdata,indent=2)+'\n');print(json.dumps(outdata),flush=True)
if __name__=='__main__':main()
