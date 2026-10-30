#!/usr/bin/env python3
"""Six fixed witnesses: literal subset minima and physical source-sum replay."""
from pathlib import Path
from itertools import combinations
from collections import Counter
import gzip, hashlib, json, subprocess, sys, time
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from verify_algebraic_model import physical
from minimize_four_witness import minimize
from verify_sparse_quotient import SparseQuotientConsumer
from verify_word_subspace_rank import dimension

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def shift(ids,h):return tuple(sorted(16*(i//16)+(i%16+h)%16 for i in ids))
def walk(d,path=''):
 if isinstance(d,dict):
  yield path,d
  for key,v in d.items():
   if key=='signature_circuits':continue
   if isinstance(v,(dict,list)):yield from walk(v,path+'/'+key)
 elif isinstance(d,list):
  for i,v in enumerate(d):
   if isinstance(v,(dict,list)):yield from walk(v,path+'/'+str(i))

def main():
 start=time.monotonic();X,Z,A=physical()
 assert A==[sum(((X[i]&Z[j]).bit_count()%2)<<i for i in range(720)) for j in range(720)]
 for i,row in enumerate(A):
  assert sum((((row>>(16*j)&65535)<<1 | (row>>(16*j)&65535)>>15)&65535)<<(16*j) for j in range(45))==A[16*(i//16)+(i%16+1)%16]
 parent=ROOT/'coupling-results/word-subspace-hard-union-demands-independent.json';discovery=ROOT/'coupling-results/word-subspace-minimized-discovery.json'
 planes=load(parent)['candidate_word_demand_analyses'];proposed=load(discovery)['records']
 records=[];consumer=SparseQuotientConsumer(X,Z);cache={};allsmaller=0
 for number,(plane,word) in enumerate((p,w) for p in planes for w in p['words']):
  row=proposed[number]['certificate'];J=plane['mandatory_opposite'];D=word['detector_indices'];w=int(word['witness_hex'],16);U,V=(X,Z) if plane['side']==0 else (Z,X)
  original=dict(row,mandatory_opposite=J,clause=[-j-1-(720 if plane['side']==0 else 0) for j in J]);got,diag=minimize(U,V,original)
  assert got==row and diag==proposed[number]['diagnostics'];consumer.check(row)
  masks=[(i,sum(((u&V[j]).bit_count()%2)<<k for k,j in enumerate(J))) for i,u in enumerate(U) if (u&w).bit_count()%2]
  feasible=[];smaller=0
  for mask in range(1<<len(J)):
   actual=[i for i,blocked in masks if not mask&blocked]
   if actual==D:feasible.append(mask)
   if mask.bit_count()<len(row['mandatory_opposite']):assert actual!=D;smaller+=1
  best=min(feasible,key=lambda m:(m.bit_count(),m));assert [j for k,j in enumerate(J) if best>>k&1]==row['mandatory_opposite'];allsmaller+=smaller
  # Independent physical source-sum proof: no quotient elimination. Generate
  # the literal span of the minimized mandatory vectors and literal source
  # pair sums; test w+ell and w+ell+v directly against those sums.
  core=row['mandatory_opposite'];L={0}
  for j in core:L|={ell^V[j] for ell in list(L)}
  assert len(L)==1<<len(core) and dimension(V[j] for j in core)==len(core)
  key=plane['side']
  if key not in cache:
   values=[0,*V];cache[key]=(set(values),{a^b for i,a in enumerate(values) for b in values[i:]})
  singles,pairs=cache[key];assert w not in L
  assert all(w^ell not in singles for ell in L)
  assert all(w^ell not in pairs for ell in L)
  assert all(w^ell^v not in pairs for ell in L for v in singles)
  records.append(dict(plane=plane['domain_index'],word=proposed[number]['word'],certificate=row,diagnostics=diag,
      literal_all_subsets_tested=1<<len(J),literal_smaller_subsets_rejected=smaller,all_support_preserving_subsets=len(feasible),
      exact_word_demand_lower_bound=4,literal_mandatory_span_size=len(L),physical_pair_sum_count=len(pairs),
      old_bank_subsumers=[]))
 # Inventory every saved JSON source-bank schema, including banks outside the
 # global run. A wider conservative scan also lists restricted-domain hits.
 names=subprocess.check_output(['rg','-l','"cuts"\\s*:|"mandatory_opposite"\\s*:|"physical_circuits"\\s*:','--glob','*.json'],cwd=ROOT,text=True).splitlines()
 names=[n for n in names if not n.startswith('coupling-results/') and 'negative-controls/' not in n]
 names+=['algebraic-results/small-conditional-original.json.gz','algebraic-results/orbit-rank-profiles.json.gz']
 kinds={'universal_sparse_quotient','universal_sparse_quotient_four','universal_short_word','z_zero','forced_propagation','domain_forced_propagation','sparse_quotient_obstruction','conditional_no_short_word','detecting_capacity_obstruction'}
 inventory=[];candidate_sets={};excluded=Counter()
 for name in sorted(set(names)):
  p=ROOT/name;data=load(p);count=0
  for locator,cut in walk(data):
   ids=None;kind=cut.get('kind')
   if kind in kinds:
    ids=cut.get('indices',cut.get('mandatory_opposite'))
   elif 'anchor_X_index' in cut and 'other_X_indices' in cut:
    ids=[cut['anchor_X_index'],*cut['other_X_indices']];kind='initial_rank'
   if ids is None:continue
   if not isinstance(ids,list) or not ids or any(type(i)!=int or not 0<=i<720 for i in ids):continue
   # Keep all source candidate sets conservatively. Mixed-sector sets cannot
   # be contained in the pure opposite-sector cores and are never projected.
   ids=tuple(sorted(set(ids)));count+=1
   candidate_sets.setdefault(ids,[]).append(dict(path=name,locator=locator,kind=kind))
  if 'physical_circuits' in data:
   for k,ids in enumerate(data['physical_circuits']):candidate_sets.setdefault(tuple(sorted(ids)),[]).append(dict(path=name,locator='/physical_circuits/'+str(k),kind='physical_circuit'));count+=1
  if name=='algebraic-results/orbit-rank-profiles.json.gz':
   for a,r in enumerate(data['records']):
    for b,c in enumerate(r['minimal_bad_certificates']):
     ids=tuple(16*r['orbit']+h for h in range(16) if c['mask']>>h&1)
     candidate_sets.setdefault(ids,[]).append(dict(path=name,locator=f'/records/{a}/minimal_bad_certificates/{b}',kind='orbit_rank'));count+=1
  inventory.append(dict(path=name,sha256=sha(p),source_candidate_records=count,signature_circuits_excluded=len(data.get('signature_circuits',[]))))
 # Examine all cyclic shifts and sector transfers. A full physical pairing
 # symmetry proof above licenses this for source-valid same-sector banks.
 hits=0
 for ids,origins in candidate_sets.items():
  if len(ids)>10:continue
  for h in range(16):
   shifted=shift(ids,h);S=set(shifted)
   for r in records:
    if S<=set(r['certificate']['mandatory_opposite']):
     r['old_bank_subsumers'].append(dict(indices=list(shifted),cyclic_shift=h,origins=origins));hits+=1
 for r in records:
  r['old_bank_subsumers'].sort(key=lambda x:(len(x['indices']),x['indices'],x['cyclic_shift']))
 out=dict(status='PASS',source_C16_answered=False,source_hashes={str(p.relative_to(ROOT)):sha(p) for p in [parent,discovery,ROOT/'minimize_four_witness.py',ROOT/'verify_sparse_quotient.py',ROOT/'verify_algebraic_model.py',ROOT/'physical-pool-source.json',ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt']},
          replay_sha256=sha(Path(__file__)),records=records,bank_inventory=inventory,distinct_candidate_sets=len(candidate_sets),literal_smaller_subsets_rejected=allsmaller,
          no_saved_candidate_subsumer_records=[i for i,r in enumerate(records) if not r['old_bank_subsumers']],
          signature_circuits_used=False,elapsed_seconds=time.monotonic()-start,
          scope='Exact minimum subsets for these fixed physical witnesses preserving their full detecting supports. Literal physical source sums exclude up to three terms after minimization. Saved source-bank candidate schemas and all16 rotations are screened; signature circuits are excluded. Restricted-domain hits, if any, require separate unrestricted physical replay before being counted as source subsumers. No shortest-clause or source-case completeness claim.')
 path=ROOT/'coupling-results/word-subspace-minimized-independent.json';assert not path.exists();path.write_text(json.dumps(out,indent=2)+'\n')
 print({k:v for k,v in out.items() if k not in ['records','bank_inventory','source_hashes']})
 for i,r in enumerate(records):print(i,r['certificate']['mandatory_opposite'],'subsumers',len(r['old_bank_subsumers']), 'first',r['old_bank_subsumers'][:1])
if __name__=='__main__':main()
