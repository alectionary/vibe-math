#!/usr/bin/env python3
"""Read-only provenance/scope audit; does not rerun scientific solvers/screens."""
from pathlib import Path
from fractions import Fraction
import hashlib,json,datetime,math
from verify_physical_integer_forms import compile_row, point_data
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(Path(p).read_text())
def flags(command):
 out={};i=3
 while i<len(command):
  k=command[i];assert k.startswith('--');i+=1;j=i
  while j<len(command) and not command[j].startswith('--'):j+=1
  out[k]=command[i:j];i=j
 return out

def main():
 output=Path('two-basis-results/affine-refinement-20-22-independent-review.json');assert not output.exists()
 checked={}
 def bind(p):
  p=Path(p);checked[str(p)]=sha(p);return read(p)
 def sources(d,key):
  for p,h in d[key].items():assert sha(p)==h,(p,h,sha(p));checked[p]=h
 cohort=bind('two-basis-results/affine-integer-template-coverage.json')
 assert cohort['status']=='PASS_EXACT_AFFINE_TEMPLATE_PARAMETER_COVERAGE'
 ts=cohort['canonical_templates'];assert len(ts)==275 and [t['template_id']for t in ts]==list(range(275))
 controls=0
 for t in ts:
  k,q,c=t['arity'],t['negative_weights'],t['constant'];threshold=q-c
  assert 3<=k<=12 and t['weights']==[1]*(k-q)+[-1]*q
  assert 1<=threshold<=k-2
  assert (threshold,q)<= (k-1-threshold,k-q)
  for p in range(k-q+1):
   for n in range(q+1):
    L=c+p-n;assert L*(L-1)==(1-L)*(-L);controls+=1
 scans=[]
 for number in [19,20,21]:
  prefix=f'two-basis-results/affine-template-point{number}'
  summary=bind(prefix+'-summary.json');frozen=bind(prefix+'-frozen.json')
  assert summary['frozen_sha256']==sha(prefix+'-frozen.json');sources(frozen,'source_hashes')
  assert summary['templates_completed']==275==len(summary['stages'])
  assert [s['template_id']for s in summary['stages']]==list(range(275))
  raw=[]
  for i,(s,t) in enumerate(zip(summary['stages'],ts)):
   p=prefix+f'-template{i:03d}.json';v=bind(p)
   assert s['returncode']==0 and s['artifact_sha256']==sha(p)
   assert s['restarts']==v['restarts']==100
   for row in v['cuts']:
    assert row['weights']==t['weights'] and row['constant']==t['constant']
   raw.extend(dict(x,template_id=i)for x in v['cuts'])
  candidates=bind(prefix+'-all-candidates.json');assert candidates['cuts']==raw
  selected=bind(prefix+'-selected-candidates.json');assert selected['all_candidates_sha256']==sha(prefix+'-all-candidates.json')
  bank=bind(prefix+'-bank.json');receipt=bind(prefix+'-independent.json');sources(bank,'source_hashes')
  point=f'coupling-results/two-basis-integer-witness{number}-rational.json.gz'
  owner,_=point_data(Path(point),32);checked[point]=sha(point)
  assert bank['point_sha256']==receipt['point_sha256']==sha(point)
  assert summary['bank_sha256']==receipt['bank_sha256']==sha(prefix+'-bank.json')
  assert summary['receipt_sha256']==sha(prefix+'-independent.json')
  assert receipt['status']=='PASS' and receipt['consumer_sha256']==sha('verify_physical_integer_forms.py')
  assert receipt['source_hashes']==bank['source_hashes']
  assert summary['accepted_rows']==receipt['cuts_checked']==len(bank['cuts'])
  normalized=set();gaps=[]
  for row in bank['cuts']:
   r,b=compile_row(row);gap=sum(v*owner[j]for j,v in r.items())-b
   assert gap==Fraction(row['exact_violation'])>0
   gcd=math.gcd(*[abs(v)for v in [*r.values(),b]])
   key=(tuple((j,v//gcd)for j,v in r.items()),b//gcd);assert key not in normalized;normalized.add(key);gaps.append(str(gap))
  symbolic=bind(prefix+'-symbolic.json')
  assert symbolic['status']=='PASS_SYMBOLIC_PHYSICAL_INTEGER_FORM_REVIEW'
  assert symbolic['bank_sha256']==sha(prefix+'-bank.json') and symbolic['receipt_sha256']==sha(prefix+'-independent.json')
  assert symbolic['point_sha256']==sha(point) and symbolic['reviewer_sha256']==sha('review_higher_integer_form_rows.py')
  assert symbolic['cuts_checked']==symbolic['symbolic32_action_polynomials_checked']==len(bank['cuts'])
  assert not summary['integration_row_cap_applied'] and not summary['complete_event_placement_search']
  scans.append(dict(point=number,templates=275,restarts=27500,raw_rows=len(raw),accepted_rows=len(bank['cuts']),exact_gaps=gaps,source_sha256=sha(prefix+'-summary.json')))
 refinement=bind('two-basis-results/affine-refinement-20-22-summary.json');frozen=bind('two-basis-results/affine-refinement-20-22-frozen.json');sources(frozen,'source_hashes')
 assert refinement['frozen_sha256']==sha('two-basis-results/affine-refinement-20-22-frozen.json')
 assert refinement['stop_reason']=='TWO_SUCCESSOR_LIMIT'
 points=[];oldflags=None
 for number,record in zip([20,21,22],refinement['records']):
  prefix=f'coupling-results/two-basis-integer-witness{number}'
  summary=bind(prefix+'-checks-summary.json');frozen=bind(prefix+'-checks-frozen.json');trial=bind(prefix+'-frozen.json')
  assert summary['status']==record['checks']=='PASS_LISTED_RELAXATION'
  assert record['summary_sha256']==sha(prefix+'-checks-summary.json') and summary['frozen_sha256']==sha(prefix+'-checks-frozen.json')
  assert len(summary['stages'])==7 and all(summary['sources_unchanged'].values())
  sources(frozen,'input_and_source_hashes');sources(trial,'input_and_source_hashes')
  for stage,cmd in zip(summary['stages'],frozen['commands']):
   p=prefix+'-'+stage['stage']+'.json';d=bind(p)
   assert stage['returncode']==0 and stage['status']==d['status']=='PASS'
   assert stage['receipt_sha256']==sha(p) and cmd[-2:]==['--output',p]
  current=flags(trial['command'])
  if oldflags is not None:
   p=f'two-basis-results/affine-template-point{number-1}'
   expected=dict(oldflags);expected.update({'--basis-cuts':oldflags['--basis-cuts']+[p+'-bank.json'],'--basis-replays':oldflags['--basis-replays']+[p+'-independent.json'],'--warm-point':[f'coupling-results/two-basis-integer-witness{number-1}.npz'],'--output':[prefix+'.json'],'--seconds':['180']})
   assert current==expected
  oldflags=current
  basis=read(prefix+'-basis-exact.json')
  points.append(dict(point=number,point_sha256=sha(prefix+'-rational.json.gz'),stages_checked=7,basis_and_integer_rows=basis['rows_checked'],checks_summary_sha256=sha(prefix+'-checks-summary.json')))
 out=dict(status='PASS_REFINEMENT_PROVENANCE_AND_PARAMETER_SCOPE_REVIEW',source_C16_answered=False,utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),reviewer_sha256=sha(__file__),cohort_classes=275,compressed_reflection_controls=controls,scouts=scans,points=points,bound_files=checked,boundary=['Exact accepted inequalities follow from integer L and the independently checked physical 32-action polynomial identity. Discovery floating scores are not proof.','The parameter quotient covers only distinct-event signed-unit forms of arity3..12, modulo event permutations, L to1-L, and range-trivial tails. It is not all integer weights, facets or event placements.','Point22 was accepted after the two-successor limit and was not subjected to another275-template scout in this trajectory. No scout closure is claimed.','All preserved seven-stage receipts and their frozen source bindings were checked; expensive scientific stages were not rerun by this read-only audit.','Effective model flags use the last occurrence, matching argparse and the acceptance wrapper. Duplicate command occurrences were not mistaken for extra constraints.','The C++ equal-weight normalization covers these +/-1 templates; arbitrary large integer coefficients remain subject to the separately recorded overflow/dedup limitations.'],scope='Accepted finite relaxation endpoints and accepted finite row banks; no source frame, source-case exclusion or complete separation.')
 output.write_text(json.dumps(out,indent=2,sort_keys=True)+'\n');print(output,sha(output),len(checked))
if __name__=='__main__':main()
