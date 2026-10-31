"""Additional independent cap/warm-start and maximum-defect tiny controls."""
from pathlib import Path
from fractions import Fraction as Q
import json,gzip,time
import exact_matroid_push_relabel as producer
from two_basis_structure_push_relabel_controls import ROOT,sha,check,all_subset_test

def main():
 start=time.monotonic();original=ROOT/'two-basis-results/two-basis-push-relabel-tiny.json.gz';receipt=ROOT/'two-basis-results/two-basis-push-relabel-tiny-independent.json';r=json.loads(receipt.read_text());assert r['status']=='PASS_EXHAUSTIVE_TINY_PUSH_RELABEL_ENDPOINTS' and r['bank_sha256']==sha(original) and r['producer_sha256']==sha(ROOT/'exact_matroid_push_relabel.py');bank=json.loads(gzip.decompress(original.read_bytes()));maxcontrols=0
 for record in bank['records']:
  out=record['result']
  if out['status']!='EXACT_RANK_VIOLATION':continue
  U=record['case']['vectors'];q=list(map(Q,record['case']['target']));gap=Q(out['violated_rank']['exact_violation']);bad=all_subset_test(U,q);assert gap==max(v for S,v in bad);D=int(out['denominator']);x=[Q(int(v),D) for v in out['achieved_numerators']];assert gap==sum(max(Q(0),a-b) for a,b in zip(q,x));maxcontrols+=1
 U=[1,2,3];q=[Q(2,3)]*3;results=[]
 for label,kw,reason in [('time',dict(seconds=1e-300),'TIME_LIMIT'),('step',dict(maximum_steps=1),'STEP_LIMIT'),('active',dict(maximum_bases=1),'ACTIVE_BASIS_LIMIT')]:
  out=producer.solve(U,q,verify_invariants=True,**kw);assert out['status']=='BOUNDED_PUSH_RELABEL_INCONCLUSIVE' and out['stop_reason']==reason;check(U,q,out,True);results.append(dict(label=label,result=out))
 initial=[([0,1],Q(1,6)),([0,1],Q(1,3)),([1,2],Q(1,2))];q=[Q(2,5),Q(4,5),Q(4,5)];out=producer.solve(U,q,initial=initial,verify_invariants=True);check(U,q,out);assert out['status']=='EXACT_BASE_MIXTURE' and int(out['denominator'])==30;results.append(dict(label='duplicate_warm_bases_lcm30',result=out))
 p=ROOT/'two-basis-results/two-basis-push-relabel-tiny-supplement.json';assert not p.exists();d=dict(status='PASS_PUSH_RELABEL_CAP_AND_WARM_START_SUPPLEMENT',producer_sha256=sha(ROOT/'exact_matroid_push_relabel.py'),consumer_sha256=sha(__file__),endpoint_consumer_sha256=sha(ROOT/'two_basis_structure_push_relabel_controls.py'),parent_receipt_sha256=sha(receipt),saved_rank_cuts_with_exact_maximum_defect_checked=maxcontrols,cap_exit_controls=3,warm_duplicate_basis_control=True,results=results,elapsed_seconds=time.monotonic()-start,scope='Finite supplementary tests. Maximum-defect equality is checked exhaustively on saved tiny endpoints only; no new global termination claim or physical C16 result.');p.write_text(json.dumps(d,indent=2)+'\n');print({k:v for k,v in d.items() if k!='results'},flush=True)
if __name__=='__main__':main()
