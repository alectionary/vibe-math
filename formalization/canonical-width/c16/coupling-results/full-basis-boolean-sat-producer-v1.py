#!/usr/bin/env python3
"""Bounded matched compact-source pilot with explicit full-selection flags."""
from pathlib import Path
import argparse,collections,gzip,hashlib,json,os,subprocess,sys,time
from pysat.card import CardEnc,EncType
from global_four_signature import setup
from full_basis_boolean_gate import read,polynomial
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
class Circuit:
 def __init__(self,top):self.top=top;self.clauses=[];self.gates=[]
 def gate(self,kind,a,b):
  if kind in ('xor','or'):
   if not a:return b
   if not b:return a
  if kind=='and' and (not a or not b):return 0
  self.top+=1;y=self.top
  if kind=='xor':rows=[[-a,-b,-y],[a,b,-y],[a,-b,y],[-a,b,y]]
  elif kind=='and':rows=[[-a,-b,y],[a,-y],[b,-y]]
  elif kind=='or':rows=[[a,b,-y],[-a,y],[-b,y]]
  else:raise ValueError(kind)
  self.clauses+=rows;self.gates.append([kind,a,b,y]);return y
 def weighted_atmost(self,terms,bound):
  assert bound>=0 and all(w>0 and lit for lit,w in terms)
  words=[[lit if w>>b&1 else 0 for b in range(w.bit_length())] for lit,w in terms]
  while len(words)>1:
   nxt=[]
   for i in range(0,len(words),2):
    if i+1==len(words):nxt.append(words[i]);continue
    a,b=words[i:i+2];carry=0;out=[]
    for k in range(max(len(a),len(b))):
     x=a[k] if k<len(a) else 0;y=b[k] if k<len(b) else 0;xy=self.gate('xor',x,y);out.append(self.gate('xor',xy,carry));carry=self.gate('or',self.gate('and',x,y),self.gate('and',xy,carry))
    if carry:out.append(carry)
    nxt.append(out)
   words=nxt
  bits=words[0] if words else []
  for b,s in enumerate(bits):
   if bound>>b&1 or not s:continue
   clause=[-s];taut=False
   for k in range(b+1,len(bits)):
    if not bits[k]:
     if bound>>k&1:taut=True;break
    else:clause.append(-bits[k] if bound>>k&1 else bits[k])
   if not taut:self.clauses.append(clause)
  return bits

def compile_cut(c,bound,P,Q,top):
 const,L,M=polynomial(c);circuit=Circuit(top);lookup={512+t:P[t] for t in range(16)}|{720+j:Q[j] for j in range(720)};terms=[];products=[]
 for i,v in L.items():terms.append((lookup[i],v))
 for (i,j),v in M.items():
  y=circuit.gate('and',lookup[i],lookup[j]);products.append([i,j,y]);terms.append((y,v))
 rhs=bound-const;positive=[]
 for var,w in terms:
  if w<0:rhs-=w;positive.append((-var,-w))
  else:positive.append((var,w))
 bits=circuit.weighted_atmost(positive,rhs)
 return circuit,dict(constant=const,linear_terms=[[i,v] for i,v in L.items()],quadratic_terms=[[i,j,v] for (i,j),v in M.items()],products=products,positive_terms=positive,positive_bound=rhs,sum_bits=bits)

def save_cnf(path,clauses,top):
 raw=(f'p cnf {top} {len(clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in clauses)).encode();path.write_bytes(gzip.compress(raw,compresslevel=3,mtime=0));return hashlib.sha256(raw).hexdigest()

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output-dir',type=Path,required=True);a=ap.parse_args();out=a.output_dir;assert not out.exists();out.mkdir();start=time.monotonic()
 bankpath=ROOT/'coupling-results/native775-witness9-gauge-rounded.json.gz';receiptpath=ROOT/'coupling-results/native775-witness9-gauge-rounded-independent.json';bank=read(bankpath);receipt=read(receiptpath);assert receipt['status']=='PASS' and receipt['bank_sha256']==sha(bankpath);cut=bank['cuts'][0];assert len(cut['coefficients'])==775 and cut['upper_bound']==0
 profilepath=ROOT/'algebraic-results/orbit-rank-profiles.json.gz'
 A,C,E,anchor,R,target,base,top,owners,events=setup('global',True,profilepath,True,None,(512,512));assert anchor==(512,512)
 original_top=top;original_clauses=len(base);edge={(i,j):k for k,(i,j,s,_) in enumerate(E,1)}
 P=list(range(top+1,top+17));top+=16;Q=list(range(top+1,top+721));top+=720;links=[]
 for i,v in owners[0].items():
  if 512<=i<528:links.append([-v,P[i-512]])
 for j,v in owners[1].items():links.append([-v,Q[j]])
 links+=[[P[0]],[Q[512]]]
 for i,v in owners[0].items():
  for j in range(720):
   if A[i]>>j&1:links.append([-v,Q[j]*-1]+([edge[i,j]] if (i,j) in edge else []))
 for t,p in enumerate(P):
  for j,v in owners[1].items():
   if A[512+t]>>j&1:links.append([-p,-v]+([edge[512+t,j]] if (512+t,j) in edge else []))
 # The fixed anchor is outside thefree-edgeowner map.
 for j in range(720):
  if j!=512 and A[512]>>j&1:links.append([-Q[j]])
 for t,p in enumerate(P):
  if t and A[512+t]>>512&1:links.append([-p])
 full_count=CardEnc.equals(Q,128,top_id=top,encoding=EncType.kmtotalizer);count_top0=top;top=full_count.nv
 degree=[];degree_records=[]
 for t,p in enumerate(P):
  adjacent=[Q[j] for j in range(720) if A[512+t]>>j&1];oldtop=top;enc=CardEnc.equals(adjacent,1,top_id=top,encoding=EncType.seqcounter);top=enc.nv;rows=[[-p,*r] for r in enc.clauses];degree+=rows;degree_records.append(dict(phase=t,adjacent=adjacent,top_before=oldtop,top_after=top,clause_count=len(rows)))
 profile=next(r for r in read(profilepath)['records'] if r['orbit']==32);profile_rows=[[-P[t] for t in range(16) if c['mask']>>t&1] for c in profile['minimal_bad_certificates']]
 baseline=base+links+full_count.clauses+degree+profile_rows;baseline_top=top
 circuit,translation=compile_cut(cut['coefficients'],cut['upper_bound'],P,Q,top);augmented=baseline+circuit.clauses
 bsha=save_cnf(out/'baseline.cnf.gz',baseline,baseline_top);asha=save_cnf(out/'small64.cnf.gz',augmented,circuit.top)
 metadata={'status':'FROZEN_BEFORE_BRIDGE_CONTROLS_AND_SOURCE_TRIALS','source_C16_answered':False,'anchor':[512,512],'case':[32,32,0],'fullP_variables':P,'fullQ_variables':Q,'old_partial_owner_maps':[{str(k):v for k,v in o.items()} for o in owners],'edges':[[i,j] for i,j,s,k in E],'base_top':original_top,'base_clauses':original_clauses,'base_generator':'global_four_signature.setup(global,signature_independent=True,profiles,projection_count=True,fixed_anchor=(512,512))','partial_semantics':'Oldowners denote retained partialsignaturematching endpoints; fullflags are independent existential complete selections. Owner->full only.','bound':cut['upper_bound'],'coefficients':cut['coefficients'],'cut_index':0,'bank_sha256':sha(bankpath),'bank_receipt_sha256':sha(receiptpath),'baseline_top':baseline_top,'augmented_top':circuit.top,'baseline_clauses':len(baseline),'augmented_clauses':len(augmented),'baseline_raw_sha256':bsha,'augmented_raw_sha256':asha,'completion_links':links,'full_count_encoder':{'kind':'kmtotalizer','top_before':count_top0,'top_after':full_count.nv,'clauses':len(full_count.clauses),'target':128},'conditional_degree_encoders':degree_records,'profile_masks':[c['mask'] for c in profile['minimal_bad_certificates']],'translation':translation,'gates':circuit.gates,'source_hashes':{p.name:sha(p) for p in ROOT.glob('*.py')},'input_hashes':{str(p.relative_to(ROOT)):sha(p) for p in [bankpath,receiptpath,profilepath,ROOT/'physical-pool-source.json',ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt']},'trial_seconds_each':20,'setup_seconds':time.monotonic()-start}
 (out/'frozen.json.gz').write_bytes(gzip.compress((json.dumps(metadata)+'\n').encode(),mtime=0));print(json.dumps({k:v for k,v in metadata.items() if k in ['baseline_top','augmented_top','baseline_clauses','augmented_clauses','setup_seconds']}),flush=True)
if __name__=='__main__':main()
