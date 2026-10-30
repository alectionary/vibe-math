"""Independent exhaustive tiny endpoint controls for exact push/relabel.

Uses low-pivot rank and every ground-set subset, not producer status or circuit
code. Also checks every returned physical basis, integer weight, and marginal.
No large physical instance or global runtime theorem is tested here.
"""
from pathlib import Path
from fractions import Fraction as Q
from itertools import product,combinations
from collections import Counter
import argparse,copy,gzip,hashlib,json,time
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def rank(U):
 piv={}
 for v in U:
  while v:
   k=(v&-v).bit_length()-1
   if k in piv:v^=piv[k]
   else:piv[k]=v;break
 return len(piv)
def all_bases(U):
 r=rank(U)
 return [list(B) for B in combinations(range(len(U)),r) if rank(U[j] for j in B)==r]
def all_subset_test(U,q):
 assert min(q,default=0)>=0 and sum(q)==rank(U);bad=[]
 for mask in range(1<<len(U)):
  S=[j for j in range(len(U)) if mask>>j&1];gap=sum(q[j] for j in S)-rank(U[j] for j in S)
  if gap>0:bad.append((S,gap))
 return bad

def check(U,q,result,allow_inconclusive=False):
 n=len(U);r=rank(U);assert len(q)==n and sum(q)==r and min(q,default=0)>=0;D=int(result['denominator']);assert D>0 and result['ground_size']==n and result['rank']==r;assert all((v*D).denominator==1 for v in q);gi=[int(v*D) for v in q];assert list(map(int,result['target_numerators']))==gi
 x=[0]*n;mass=0;seen=set()
 for b in result['bases']:
  B=b['indices'];w=int(b['weight_numerator']);assert w>0 and B==sorted(set(B)) and len(B)==r and all(type(j)is int and 0<=j<n for j in B) and rank(U[j] for j in B)==r;assert tuple(B) not in seen;seen.add(tuple(B));mass+=w
  for j in B:x[j]+=w
 assert mass==D and list(map(int,result['achieved_numerators']))==x;assert all(0<=v<=D for v in x) and sum(x)==r*D
 bad=all_subset_test(U,q);status=result['status']
 if status=='EXACT_BASE_MIXTURE':assert not bad and x==gi and result['violated_rank'] is None
 elif status=='EXACT_RANK_VIOLATION':
  c=result['violated_rank'];S=c['indices'];assert S==sorted(set(S)) and all(type(j)is int and 0<=j<n for j in S);rr=rank(U[j] for j in S);gap=sum(q[j] for j in S)-rr;assert rr==c['rank'] and gap==Q(c['exact_violation']) and gap>0 and bad
 else:assert status=='BOUNDED_PUSH_RELABEL_INCONCLUSIVE' and allow_inconclusive
 return dict(status=status,subsets_checked=1<<n,bases_checked=len(seen),expected_feasible=not bad)

def cases():
 fixtures=[[],[0],[0,0],[1],[1,1],[0,1,1],[1,2],[1,2,3],[1,1,2],[1,2,3,4],[1,2,4,7],[1,2,3,4,5],list(range(1,8)),[0,1,1,2,2,3],[1,1,2,4,3,5,6,7],[0,*range(1,8)],[2,4,6],[1,2,4]]
 for k,U in enumerate(fixtures):
  r=rank(U)
  for D in ([2,3] if len(U)<=5 else [2]):
   for counts in product(range(D+1),repeat=len(U)):
    if sum(counts)!=D*r:continue
    q=[Q(c,D) for c in counts];yield dict(name=f'grid{k}-D{D}-'+','.join(map(str,counts)),vectors=U,target=list(map(str,q)),initial=None)
 # Non-dyadic and very large denominators, exact near-boundary violations.
 for D in [5,7,11,97,(1<<100)+267]:
  for name,U,q in [
   ('parallel-near-cut',[1,1,2],[Q(1,2),Q(1,2)+Q(1,D),1-Q(1,D)]),
   ('parallel-near-feasible',[1,1,2],[Q(1,D),1-Q(1,D),Q(1)]),
   ('triangle-feasible',[1,2,3],[1-Q(1,D),1-Q(1,D),Q(2,D)]),
   ('loop-near-cut',[0,1,2],[Q(1,D),1-Q(1,D),Q(1)]),
   ('overone-cut',[1,2,3],[1+Q(1,D),1-Q(1,D),Q(0)])]:
   yield dict(name=f'{name}-D{D}',vectors=U,target=list(map(str,q)),initial=None)
 # Existing tiny-pool fixtures, with nontrivial rational starting mixtures.
 for k,U in enumerate([[1,2,3],[1,2,4,7],list(range(1,8)),[0,1,1,2,2,3],[1,1,2,4,3,5,6,7]]):
  BB=all_bases(U);weights=[Q(i+1,sum(range(1,len(BB)+1))) for i in range(len(BB))];q=[sum(w for B,w in zip(BB,weights) if j in B) for j in range(len(U))]
  for initial in [[(BB[-1],Q(1))],[(BB[0],Q(2,7)),(BB[-1],Q(5,7))]]:
   yield dict(name=f'nontrivial-initial{k}-{len(initial)}',vectors=U,target=list(map(str,q)),initial=[[B,str(w)] for B,w in initial])

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output-prefix',type=Path,required=True);ap.add_argument('--replay-bank',type=Path);a=ap.parse_args();rp=Path(str(a.output_prefix)+'-independent.json');assert not rp.exists();start=time.monotonic();counts=Counter();subsets=bases=steps=0;allrecords=[];errors=[];mixture=cut=None
 if a.replay_bank:
  bank=json.loads(gzip.decompress(a.replay_bank.read_bytes()));assert bank['producer_sha256']==sha(ROOT/'exact_matroid_push_relabel.py');records=bank['records']
 else:
  import exact_matroid_push_relabel as producer
  records=[]
  for case in cases():
   U=case['vectors'];q=list(map(Q,case['target']));initial=None if case['initial'] is None else [(B,Q(w)) for B,w in case['initial']]
   try:result=producer.solve(U,q,seconds=2,maximum_steps=100000,maximum_bases=1000,verify_invariants=True,initial=initial)
   except Exception as error:errors.append(dict(case=case,error=repr(error)));break
   records.append(dict(case=case,result=result))
   if len(records)%250==0:print('SOLVED',len(records),'elapsed',time.monotonic()-start,flush=True)
  # Deliberately truncated but valid intermediate state.
  U=[1,2,3];q=[Q(2,3)]*3;result=producer.solve(U,q,maximum_steps=1,verify_invariants=True);assert result['status']=='BOUNDED_PUSH_RELABEL_INCONCLUSIVE';records.append(dict(case=dict(name='forced-step-limit',vectors=U,target=list(map(str,q)),initial=None),result=result,allow_inconclusive=True))
  invalid=[]
  for label,U,q,kw in [('negative-target',[1,2],[Q(-1),Q(3)],{}),('wrong-total',[1,2],[Q(1),Q(0)],{}),('negative-vector',[-1],[Q(0)],{}),('dependent-initial',[1,1,2],[Q(1,2),Q(1,2),Q(1)],{'initial':[([0,1],Q(1))]}),('negative-initial-weight',[1,2,3],[Q(2,3)]*3,{'initial':[([0,1],Q(-1)),([1,2],Q(2))]})]:
   try:producer.solve(U,q,verify_invariants=True,**kw)
   except (AssertionError,ValueError):invalid.append(label)
   else:errors.append(dict(invalid_input_accepted=label))
  bp=Path(str(a.output_prefix)+'.json.gz');assert not bp.exists();bank=dict(status='FROZEN_TINY_PUSH_RELABEL_ENDPOINTS',producer_sha256=sha(ROOT/'exact_matroid_push_relabel.py'),harness_sha256=sha(__file__),records=records,producer_exceptions=errors,invalid_inputs_rejected=invalid);bp.write_bytes(gzip.compress((json.dumps(bank,indent=2)+'\n').encode(),mtime=0));a.replay_bank=bp
 for record in records:
  case,result=record['case'],record['result'];U=case['vectors'];q=list(map(Q,case['target']));z=check(U,q,result,record.get('allow_inconclusive',False));counts[z['status']]+=1;subsets+=z['subsets_checked'];bases+=z['bases_checked'];steps+=result['steps'];allrecords.append(z)
  if result['status']=='EXACT_BASE_MIXTURE' and rank(U)>=2 and mixture is None:mixture=record
  if result['status']=='EXACT_RANK_VIOLATION' and cut is None:cut=record
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
  else:errors.append(dict(corrupt_certificate_accepted=label))
 out=dict(status='PASS_EXHAUSTIVE_TINY_PUSH_RELABEL_ENDPOINTS' if not errors else 'TINY_PUSH_RELABEL_FAILURE',producer_sha256=sha(ROOT/'exact_matroid_push_relabel.py'),consumer_sha256=sha(__file__),bank_sha256=sha(a.replay_bank),cases=len(records),outcomes=dict(counts),exhaustive_subset_checks=subsets,physical_basis_records_checked=bases,total_steps=steps,maximum_case_steps=max(r['result']['steps'] for r in records),maximum_case_active_bases=max(r['result']['maximum_active_bases'] for r in records),corrupt_certificates_rejected=rejected,invalid_inputs_rejected=bank.get('invalid_inputs_rejected',[]),errors=errors,elapsed_seconds=time.monotonic()-start,source_C16_answered=False,scope='Finite tiny endpoint agreement with exhaustive subset ranks, all basis/mass/marginal checks, and producer invariants enabled. Not a global termination proof or physical C16 membership.');rp.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2),flush=True);assert not errors
if __name__=='__main__':main()
