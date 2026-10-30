"""Independent literal endpoints for versioned cached/early push-relabel.

Replay the frozen 2,374-case cohort with invariant checks enabled. Positive
rank cuts need only be literal violations; maximality is deliberately omitted.
The cache algebra is separately checked by physical XOR reconstruction.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
from itertools import combinations
import argparse,copy,gzip,hashlib,importlib.util,json,time
from two_basis_structure_push_relabel_controls import ROOT,sha,check,all_bases,rank

def load(path):
 spec=importlib.util.spec_from_file_location('versioned_solver_under_review',path);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m

def xor_vectors(U,mask):
 v=0
 for i,u in enumerate(U):
  if mask>>i&1:v^=u
 return v

def coordinate_rows(U,B):
 # Independent low-pivot construction, deliberately unlike producer high rows.
 rows={}
 for i in B:
  v=U[i];c=1<<i
  while v:
   p=(v&-v).bit_length()-1
   if p not in rows:rows[p]=(v,c);break
   v^=rows[p][0];c^=rows[p][1]
  assert v
 return rows

def expression(rows,v):
 out=0
 for p in sorted(rows):
  if v>>p&1:v^=rows[p][0];out^=rows[p][1]
 assert v==0
 return out

def cache_controls(producer):
 assert hasattr(producer,'exchange_cached_rows');exchanges=row_checks=ground_checks=0
 fixtures=[[0,1,1,2,2,3],[1,2,4,7],list(range(1,8)),[1,1,2,4,3,5,6,7]]
 for U in fixtures:
  for B in all_bases(U):
   old=coordinate_rows(U,B)
   for s in set(range(len(U)))-set(B):
    a=expression(old,U[s]);assert xor_vectors(U,a)==U[s]
    for t in B:
     if not a>>t&1:continue
     new=producer.exchange_cached_rows(old,a,t,s);BB=set(B)-{t}|{s};assert rank(U[i] for i in BB)==len(B)
     assert set(new)==set(old) and all(new[k][0]==old[k][0] for k in old)
     for value,c in new.values():
      assert not c>>t&1 and all(not c>>j&1 for j in set(range(len(U)))-BB);assert xor_vectors(U,c)==value;row_checks+=1
     for j,v in enumerate(U):
      c=expression(new,v);assert xor_vectors(U,c)==v and not c>>t&1;ground_checks+=1
     exchanges+=1
 return dict(exchanges=exchanges,physical_row_identities=row_checks,ground_coordinate_identities=ground_checks)

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--producer',required=True,type=Path);ap.add_argument('--output-prefix',required=True,type=Path);a=ap.parse_args();path=a.producer.resolve();assert path.parent==ROOT and path.name.startswith('exact_matroid_push_relabel_');bp=Path(str(a.output_prefix)+'.json.gz');rp=Path(str(a.output_prefix)+'-independent.json');assert not bp.exists() and not rp.exists();start=time.monotonic();ph=sha(path);producer=load(path);original=ROOT/'two-basis-results/two-basis-push-relabel-tiny.json.gz';original_receipt=ROOT/'two-basis-results/two-basis-push-relabel-tiny-independent.json';prior=json.loads(original_receipt.read_text());assert prior['status']=='PASS_EXHAUSTIVE_TINY_PUSH_RELABEL_ENDPOINTS' and prior['bank_sha256']==sha(original);cohort=json.loads(gzip.decompress(original.read_bytes()))['records'];assert len(cohort)==2374;algebra=cache_controls(producer);records=[];outcomes=Counter();subsets=bases=steps=0;mixture=cut=None
 for old in cohort:
  c=old['case'];U=c['vectors'];q=list(map(Q,c['target']));initial=None if c['initial'] is None else [(B,Q(w)) for B,w in c['initial']];kw=dict(seconds=2,maximum_steps=100000,maximum_bases=1000,verify_invariants=True,initial=initial)
  if old.get('allow_inconclusive'):kw['maximum_steps']=1
  r=producer.solve(U,q,**kw);checked=check(U,q,r,old.get('allow_inconclusive',False));records.append(dict(case=c,result=r,allow_inconclusive=old.get('allow_inconclusive',False)));outcomes[r['status']]+=1;subsets+=checked['subsets_checked'];bases+=checked['bases_checked'];steps+=r['steps']
  if r['status']=='EXACT_BASE_MIXTURE' and rank(U)>=2 and mixture is None:mixture=records[-1]
  if r['status']=='EXACT_RANK_VIOLATION' and cut is None:cut=records[-1]
  if len(records)%500==0:print('REPLAYED',len(records),'seconds',time.monotonic()-start,flush=True)
 assert mixture and cut;mutants=[]
 for label in ['negative-weight','wrong-achieved','wrong-denominator','dependent-basis']:
  r=copy.deepcopy(mixture);o=r['result']
  if label=='negative-weight':o['bases'][0]['weight_numerator']='-1'
  elif label=='wrong-achieved':o['achieved_numerators'][0]=str(int(o['achieved_numerators'][0])+1)
  elif label=='wrong-denominator':o['denominator']=str(int(o['denominator'])+1)
  else:o['bases'][0]['indices'][1]=o['bases'][0]['indices'][0]
  mutants.append((label,r))
 for label in ['wrong-cut-rank','wrong-cut-gap','empty-cut']:
  r=copy.deepcopy(cut);o=r['result']['violated_rank']
  if label=='wrong-cut-rank':o['rank']+=1
  elif label=='wrong-cut-gap':o['exact_violation']='0'
  else:o['indices']=[]
  mutants.append((label,r))
 rejected=[]
 for label,r in mutants:
  try:check(r['case']['vectors'],list(map(Q,r['case']['target'])),r['result'])
  except (AssertionError,ValueError):rejected.append(label)
  else:raise AssertionError('corrupt endpoint accepted')
 invalid=[]
 for label,U,q,kw in [('negative-target',[1,2],[Q(-1),Q(3)],{}),('wrong-total',[1,2],[Q(1),Q(0)],{}),('negative-vector',[-1],[Q(0)],{}),('dependent-initial',[1,1,2],[Q(1,2),Q(1,2),Q(1)],{'initial':[([0,1],Q(1))]}),('negative-initial-weight',[1,2,3],[Q(2,3)]*3,{'initial':[([0,1],Q(-1)),([1,2],Q(2))]})]:
  try:producer.solve(U,q,verify_invariants=True,**kw)
  except (AssertionError,ValueError):invalid.append(label)
  else:raise AssertionError('invalid input accepted')
 supplements=[];U=[1,2,3];q=[Q(2,3)]*3
 for label,kw,reason in [('time',dict(seconds=1e-300),'TIME_LIMIT'),('step',dict(maximum_steps=1),'STEP_LIMIT'),('active',dict(maximum_bases=1),'ACTIVE_BASIS_LIMIT')]:
  r=producer.solve(U,q,verify_invariants=True,**kw);assert r['status']=='BOUNDED_PUSH_RELABEL_INCONCLUSIVE' and r['stop_reason']==reason;check(U,q,r,True);supplements.append(dict(label=label,result=r))
 q=[Q(2,5),Q(4,5),Q(4,5)];r=producer.solve(U,q,initial=[([0,1],Q(1,6)),([0,1],Q(1,3)),([1,2],Q(1,2))],verify_invariants=True);check(U,q,r);assert r['status']=='EXACT_BASE_MIXTURE' and int(r['denominator'])==30;supplements.append(dict(label='duplicate_warm_basis_lcm30',result=r));assert sha(path)==ph
 bank=dict(status='FROZEN_VERSIONED_PUSH_RELABEL_TINY_ENDPOINTS',producer=str(path.relative_to(ROOT)),producer_sha256=ph,consumer_sha256=sha(__file__),parent_bank_sha256=sha(original),records=records,supplements=supplements);bp.write_bytes(gzip.compress((json.dumps(bank,indent=2)+'\n').encode(),mtime=0));out=dict(status='PASS_EXACT_VERSIONED_PUSH_RELABEL_TINY_ENDPOINTS',producer=str(path.relative_to(ROOT)),producer_sha256=ph,consumer_sha256=sha(__file__),endpoint_checker_sha256=sha(ROOT/'two_basis_structure_push_relabel_controls.py'),parent_bank_sha256=sha(original),parent_receipt_sha256=sha(original_receipt),bank_sha256=sha(bp),cases=len(records),outcomes=dict(outcomes),exhaustive_subset_checks=subsets,physical_basis_records_checked=bases,total_steps=steps,maximum_case_steps=max(z['result']['steps'] for z in records),cache_algebra_controls=algebra,corrupt_certificates_rejected=rejected,invalid_inputs_rejected=invalid,cap_exit_controls=3,duplicate_warm_basis_lcm=30,maximum_defect_required=False,source_C16_answered=False,elapsed_seconds=time.monotonic()-start,scope='Finite exhaustive tiny endpoint checks plus independent cache algebra, with producer invariants enabled. Any positive literal rank gap suffices; maximum-defect optimality is neither required nor claimed. No physical large-instance or global termination claim.');rp.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2),flush=True)
if __name__=='__main__':main()
