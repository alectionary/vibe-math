"""Literal physical owner/contraction fixtures for the generalized consumer."""
from pathlib import Path
from fractions import Fraction as Q
from math import lcm
import copy,json,time
from two_basis_structure_verify_physical_push_v2 import ROOT,sha,read,endpoint_check
from verify_two_sided_full_basis_oracle import physical_source

def main():
 started=time.monotonic();fp=ROOT/'two-basis-results/two-basis-push-relabel-Z-mask0-dyadic50.frozen.json';f=read(fp);X,Z,_=physical_source();results=[];negative=[]
 for m in [3,5,12]:
  p=next(p for p in f['prepared_positive_patterns'] if p['mask']==m);F,E,B=p['forced_zero_indices'],p['physical_zero_ground_indices'],p['initial_local_basis'];q=list(map(Q,p['conditional_zero_target']));D=lcm(*(v.denominator for v in q));localcounts=[D if i in B else 0 for i in range(len(E))];zero=F+[E[i] for i in B];cdfs=[];breaks={Q(0),Q(1)}
  for owner in p['owner_bins']:
   acc=Q(0);cdf=[]
   for j,prob in zip(owner['indices'],owner['conditional_probabilities']):
    prob=Q(prob)
    if prob:acc+=prob;cdf.append((acc,j));breaks.add(acc)
   assert acc==1;cdfs.append(cdf)
  br=sorted(breaks);law=[]
  for a,b in zip(br,br[1:]):
   mid=(a+b)/2;owners=[next(j for end,j in cdf if end>mid) for cdf in cdfs];law.append((sorted(zero+owners),b-a))
  fullD=lcm(*(w.denominator for S,w in law));physical=[dict(selected_indices=S,weight_numerator=str(int(w*fullD))) for S,w in law];raw=[Q(0)]*720;l=Q(p['lambda_mass'])
  for S,w in law:
   for j in S:raw[j]+=l*w
  wanted=list(map(Q,p['raw_sector_target']));err=[a-b for a,b in zip(wanted,raw)];r=dict(status='BOUNDED_PUSH_RELABEL_INCONCLUSIVE',ground_size=len(E),rank=p['contracted_rank'],denominator=str(D),target_numerators=[str(int(v*D)) for v in q],achieved_numerators=list(map(str,localcounts)),bases=[dict(indices=B,weight_numerator=str(D))],maximum_active_bases=1,violated_rank=None);d=dict(solver_endpoint=r,physical_basis_records=physical,full_basis_denominator=str(fullD),lift_component_support_sizes=[1]+[len(c) for c in cdfs],physical_rank_cut=None,raw_achieved_allocations=list(map(str,raw)),exact_raw_L1_residual=str(sum(map(abs,err))),exact_raw_max_residual=str(max(map(abs,err))),exact_local_membership_candidate=False,all_patterns_membership_proved=False,two_sector_membership_proved=False,source_C16_answered=False);ff=dict(f,selected_mask=m);checked=endpoint_check(d,ff,Z,f['prepared_positive_patterns']);results.append(dict(mask=m,forced_zero_count=len(F),required_owner_bins=len(cdfs),physical_bases=checked['physical_basis_count'],valid_state=True))
  bad=copy.deepcopy(d);bad['physical_basis_records'][0]['selected_indices'].pop()
  try:endpoint_check(bad,ff,Z,f['prepared_positive_patterns'])
  except AssertionError:negative.append(f'mask{m}_incomplete_full_basis')
  else:raise AssertionError('corrupt full basis accepted')
 out=dict(status='PASS_LITERAL_PHYSICAL_OWNER_AND_CONTRACTION_CONTROLS',consumer_sha256=sha(ROOT/'two_basis_structure_verify_physical_push_v2.py'),harness_sha256=sha(__file__),prepared_domains_sha256=sha(fp),fixtures=results,corruptions_rejected=negative,elapsed_seconds=time.monotonic()-started,scope='Constructed physical intermediate mixtures with one zero basis, coupled independently by exact CDF breakpoints. Verifies generalized endpoint consumer; no algorithm run or target membership asserted.');p=ROOT/'two-basis-results/two-basis-physical-lift-consumer-controls.json';assert not p.exists();p.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
