#!/usr/bin/env python3
"""Exact signed full-opposite-basis support with one fixed opposite event.

An independent selected X set W splits every admissible full Z basis into a
basis of the zero-evaluation pool and one vector from each unit-evaluation bin.
Selecting a multibit-evaluation anchor is impossible. A selected zero anchor
is contracted into the zero matroid; a selected unit anchor fixes its bin.
Absence deletes the anchor from its zero pool or unit bin. These operations
are sufficient as well as necessary for this one-sided basis condition.
Greedy always completes the FULL remaining rank, including negative weights.
The remaining dual X completion is not required, as in the unconditioned API.
"""
from pathlib import Path
from fractions import Fraction
from numbers import Integral
from collections import Counter
import argparse,hashlib,json,time
from full_partner_basis_oracle import FullPartnerBasisOracle,add_vector,rank
from full_partner_projection_features import candidate_weights
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
class FullPartnerAnchorBasisOracle:
 def __init__(self,x_pool=None,z_pool=None,dimension=128,root=ROOT):
  self.base=FullPartnerBasisOracle(x_pool,z_pool,dimension,root);self.X=self.base.X;self.Z=self.base.Z;self.dimension=dimension;self.domains={}
 def prepare(self,orbit,mask,anchor_Z_index,anchor_selected,extra_X_indices=()):
  assert 0<=mask<65536 and 16*orbit+16<=len(self.X)
  return self.prepare_selected([16*orbit+h for h in range(16) if mask>>h&1]+list(extra_X_indices),anchor_Z_index,anchor_selected)
 def prepare_selected(self,selected_X_indices,anchor_Z_index,anchor_selected):
  selected=tuple(sorted(set(map(int,selected_X_indices))));a=int(anchor_Z_index);assert 0<=a<len(self.Z) and type(anchor_selected) is bool
  key=selected,a,anchor_selected
  if key in self.domains:return self.domains[key]
  parent=self.base.prepare_selected(selected);d=dict(parent,anchor_Z_index=a,anchor_selected=anchor_selected,fixed_zero_indices=())
  self.domains[key]=d
  if parent['status']!='FULL_PARTNER_BASIS_DOMAIN':return d
  signature=sum(((self.X[i]&self.Z[a]).bit_count()%2)<<h for h,i in enumerate(selected));d['anchor_signature']=signature
  zeros=list(parent['zero_indices']);bins=list(parent['owner_bins'])
  if anchor_selected:
   if signature and signature&(signature-1):d['status']='EXCLUDED_SELECTED_MULTIBIT_ANCHOR';return d
   if signature==0:
    if not self.Z[a]:d['status']='EXCLUDED_SELECTED_ZERO_VECTOR';return d
    d['fixed_zero_indices']=(a,);zeros.remove(a)
   else:bins[signature.bit_length()-1]=(a,)
  else:
   zeros=[j for j in zeros if j!=a];bins=[tuple(j for j in b if j!=a) for b in bins]
  d.update(zero_indices=tuple(zeros),owner_bins=tuple(bins));zero_rank=rank(self.Z[j] for j in [*d['fixed_zero_indices'],*zeros]);d['zero_rank']=zero_rank
  if zero_rank!=d['zero_basis_required']:d['status']='EXCLUDED_ANCHOR_DEFICIENT_ZERO_POOL'
  elif any(not b for b in bins):d['status']='EXCLUDED_ANCHOR_EMPTY_OWNER_BIN'
  else:d['status']='ANCHORED_FULL_PARTNER_BASIS_DOMAIN'
  return d
 def support(self,domain,weights):
  assert len(weights)==len(self.Z);w=[]
  for value in weights:
   if isinstance(value,Integral):w.append(int(value))
   elif isinstance(value,Fraction):w.append(value)
   else:raise TypeError('exact integer/Fraction weights required')
  if domain['status']!='ANCHORED_FULL_PARTNER_BASIS_DOMAIN':return dict(status=domain['status'],value=None,selected_Z_indices=())
  piv={};zero=list(domain['fixed_zero_indices'])
  for j in zero:assert add_vector(piv,self.Z[j])
  for j in sorted(domain['zero_indices'],key=lambda j:(-w[j],j)):
   if len(zero)==domain['zero_basis_required']:break
   if add_vector(piv,self.Z[j]):zero.append(j)
  assert len(zero)==domain['zero_basis_required']
  owners=[max(b,key=lambda j:(w[j],-j)) for b in domain['owner_bins']];chosen=zero+owners
  assert len(chosen)==len(set(chosen))==self.dimension
  assert (domain['anchor_Z_index'] in chosen)==domain['anchor_selected']
  return dict(status='EXACT_ANCHORED_FULL_PARTNER_BASIS_SUPPORT',value=Fraction(sum(w[j] for j in chosen)),selected_Z_indices=tuple(chosen),zero_basis_indices=tuple(zero),owner_indices=tuple(owners))

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists() and not a.output.with_suffix('.frozen.json').exists();start=time.monotonic()
 p=ROOT/'coupling-results/full-partner-projection-wolfe-strengthen-witness2.json';parent=json.loads(p.read_text());c=parent['cuts'][0]['coefficients'];allowed=sorted({((mask<<h)|(mask>>(16-h)))&65535 for mask in parent['representatives'] for h in range(16)});assert len(allowed)==4597
 selected_masks=sorted(set(allowed[::max(1,len(allowed)//128)])|{0,1,265,293,1049,1059})
 queries=sorted({(80,m) for m in selected_masks}|{(anchor,m) for anchor in (272,288,304,368,589,416,512) for m in (0,1,265,293)})
 dependencies=['full_partner_basis_oracle.py','full_partner_projection_features.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']
 frozen=dict(status='FROZEN_BEFORE_ANCHOR_BASIS_PILOT',orbit=32,queries=[list(q) for q in queries],weight_names=['zero','negative','wolfe_with_anchor_extension'],coefficients=c,full_allowed_mask_count=4597,full_fixed_anchor_branch_count=9194,
             source_hashes={str(q.resolve().relative_to(ROOT)):sha(q) for q in [p,Path(__file__),*(ROOT/n for n in dependencies)]},scope='Fixed-phase anchor requires all4597 masks for a full support cut. This finite cohort is a diagnostic, not such a cut.')
 fp=a.output.with_suffix('.frozen.json');fp.write_text(json.dumps(frozen,indent=2)+'\n');oracle=FullPartnerAnchorBasisOracle();records=[];status=Counter();preparation=support_time=0.;support_queries=0
 for anchor,mask in queries:
  weights=[('zero',[0]*720),('negative',[-1-j%13 for j in range(720)])]
  ordinary=candidate_weights(mask,c)
  for state in (False,True):
   t=time.monotonic();domain=oracle.prepare(32,mask,anchor,state);preparation+=time.monotonic()-t;status[domain['status']]+=1
   rows=[]
   for name,w in [*weights,('wolfe_with_anchor_extension',[v+(int(state)*((7*j+3)%19-9)) for j,v in enumerate(ordinary)])]:
    t=time.monotonic();r=oracle.support(domain,w);support_time+=time.monotonic()-t;support_queries+=1;r['value']=None if r['value'] is None else str(r['value']);rows.append(dict(weight=name,**r))
   records.append(dict(anchor=anchor,mask=mask,selected=state,domain_status=domain['status'],anchor_signature=domain.get('anchor_signature'),supports=rows))
 out=dict(status='EXACT_ANCHOR_SUPPORT_CANDIDATES',source_C16_answered=False,frozen_sha256=sha(fp),records=records,domain_status_counts=dict(status),support_queries=support_queries,preparation_seconds=preparation,support_seconds=support_time,total_seconds=time.monotonic()-start,
          estimated_full9194_domain_preparation_seconds=preparation/len(records)*9194,estimated_full9194_single_weight_support_seconds=support_time/support_queries*9194,
          timing_scope='Single-process pilot extrapolation only; source-excluded branches are included. A fixed-anchor projection requires all4597 masks×2 branches, not291 representatives.')
 a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='records'})
if __name__=='__main__':main()
