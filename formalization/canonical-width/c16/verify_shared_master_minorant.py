"""Independent exact16-atom minorant and pin-free owner-row acceptance.

Does not import the new pricing/projection producers or their algebra helper.
Uses exact LP token/primal/dual checks, then independently clears denominators
and evaluates the final inequality at the physical owner point.
"""
from pathlib import Path
from fractions import Fraction as Q
from math import gcd,lcm
from functools import reduce
import argparse,copy,json,time
from verify_shared_master_common import guard,resolve,sha,read,bindings,parse_lp,check_primal,exact_dual
from verify_two_sided_full_basis_oracle import point_owner,columns as physical_owner_columns
from read_soplex_exact_output_v2 import read_named_rational
LOW=(0,1,2,4,8,3,5,9,6,10,12)

def normalize(row):
 denominator=lcm(*(v.denominator for v in row.values())) if row else 1
 integers={j:int(v*denominator) for j,v in row.items() if v}
 divisor=reduce(gcd,(abs(v) for v in integers.values()),0) or 1
 integers={j:v//divisor for j,v in integers.items()}
 return integers,Q(denominator,divisor)

def validate_saved(candidate,e):
 assert candidate['status']=='EXACT_SHARED_MASTER_PROJECTED_OWNER_ROW_REQUIRES_REPLAY'
 for name in ['minorant_coefficients','minorant_pattern_values','pattern_costs','minimizing_pattern_law','low_moment_targets']:
  assert list(map(Q,candidate[name]))==e[name],name
 assert candidate['low_owner_map']==e['fmap'] and candidate['dual_sign']==e['dual_sign']
 for name in ['exact_minimum_pattern_cost','source_target_constant','exact_projected_gap','constant_minorant_gap','positive_normalization_scale','integer_exact_violation']:
  assert Q(candidate[name])==e[name],name
 assert len(candidate['rational_owner_feature_coefficients'])==len(e['row'])
 assert {j:Q(v) for j,v in candidate['rational_owner_feature_coefficients']}==e['row']
 expected_indices=sorted(j-1 for j in e['integer_row'] if j)
 assert candidate['owner_indices']==expected_indices
 assert candidate['owner_coefficients']==[e['integer_row'][j+1] for j in expected_indices]
 assert all(type(v)is int for v in candidate['owner_indices']+candidate['owner_coefficients']+[candidate['rhs']])
 assert candidate['rhs']==-e['integer_row'].get(0,0)
 bound=max([abs(candidate['rhs']),*[abs(v) for v in candidate['owner_coefficients']]])
 assert candidate['maximum_integer_coefficient_bits']==bound.bit_length()
 assert candidate['fits_signed_int64']==(bound<=2**63-1)
 assert candidate['candidate_separates_point']==(e['exact_projected_gap']>0)
 assert candidate['zero_tau_pins'] is False and candidate['source_C16_answered'] is False

def main():
 guard();ap=argparse.ArgumentParser();ap.add_argument('--certificate',required=True);ap.add_argument('--output',required=True)
 a=ap.parse_args();start=time.monotonic();out=resolve(a.output);assert not out.exists();d=read(a.certificate)
 for key in ['minorant_manifest','primal','dual','solver_frozen','pricing','pricing_receipt','point']:
  assert sha(d[key])==d[key+'_sha256'],key
 bindings(d['source_hashes']);p=read(d['pricing']);pr=read(d['pricing_receipt']);m=read(d['minorant_manifest']);frozen=read(d['solver_frozen'])
 assert pr['status']=='PASS_EXACT_SHARED_MASTER_FULL_DOMAIN_PRICING' and pr['pricing_sha256']==d['pricing_sha256']
 assert pr['consumer_sha256']==sha('verify_shared_master_projection.py')
 bindings(pr['source_hashes']);bindings(pr['dependencies'])
 assert d['point_sha256']==p['point_sha256']==m['point_sha256']
 assert resolve(d['point'])==resolve(p['point'])
 assert m['status']=='EXACT_SHARED_MASTER_PATTERN_COST_LP_REQUIRES_REPLAY'
 assert m['variable_count']==16 and m['row_count']==27 and m['low_masks']==list(LOW)
 assert m['pricing_sha256']==d['pricing_sha256'] and m['pricing_receipt_sha256']==d['pricing_receipt_sha256']
 assert sha(m['lp'])==m['lp_sha256'];bindings(m['source_hashes'])
 assert frozen['input_manifest_sha256']==d['minorant_manifest_sha256'] and frozen['input_lp_sha256']==m['lp_sha256']
 assert '-X='+str(resolve(d['primal'])) in frozen['command'] and '-Y='+str(resolve(d['dual'])) in frozen['command']
 costs=list(map(Q,p['pattern_costs']));q=list(map(Q,p['low_moment_targets']))
 assert len(costs)==16 and len(q)==11 and q[0]==1
 assert costs==list(map(Q,m['pattern_costs'])) and q==list(map(Q,m['low_moment_targets']))
 supplied=list(map(Q,m['explicit_feasible_law']))
 assert supplied==list(map(Q,p['feasible_pattern_law'])) and len(supplied)==16 and min(supplied)>=0
 assert all(sum(supplied[k] for k in range(16) if k&h==h)==q[i] for i,h in enumerate(LOW))
 rows=[('f'+str(i),({i:Q(-1)},{k:Q(1) for k in range(16) if k&h==h}),'=') for i,h in enumerate(LOW)]
 rows += [('n'+str(k),({},{k:Q(-1)}),'<=') for k in range(16)]
 cost={k:c for k,c in enumerate(costs) if c};text=parse_lp(m['lp'],rows,q,16,cost)
 rawx=read_named_rational(resolve(d['primal']),['x'+str(k) for k in range(16)])
 law=[rawx['x'+str(k)] for k in range(16)]
 objective,nrows,slack=check_primal(rows,q,law,cost);assert nrows==27
 rawdual=read_named_rational(resolve(d['dual']),[r[0] for r in rows],'dual')
 sign,dual,dualobjective=exact_dual(rows,q,16,cost,rawdual,objective)
 coefficients=[dual['f'+str(i)] for i in range(11)]
 values=[sum((coefficients[i] for i,h in enumerate(LOW) if k&h==h),Q(0)) for k in range(16)]
 assert all(b<=c for b,c in zip(values,costs))
 assert sum(c*v for c,v in zip(coefficients,q))==objective==dualobjective
 feature=[Q(1),*point_owner(resolve(d['point']))]
 fmap=[0 if j is None else j+1 for j in physical_owner_columns([80,512],[186,433])[:11]]
 assert fmap==p['low_owner_map'] and [feature[j] for j in fmap]==q
 G={j:Q(v) for j,v in p['owner_feature_coefficients']}
 gvalue=sum(v*feature[j] for j,v in G.items());assert gvalue==Q(p['source_target_constant'])==Q(pr['exact_restricted_objective'])
 row=dict(G)
 for j,v in zip(fmap,coefficients):
  row[j]=row.get(j,Q(0))+v
  if not row[j]:row.pop(j,None)
 gap=gvalue+objective;assert sum(v*feature[j] for j,v in row.items())==gap
 assert objective>=min(costs),'Moment-aware minorant must dominate the constant minimum'
 integer_row,scale=normalize(row);assert scale>0
 integer_gap=sum(v*feature[j] for j,v in integer_row.items());assert integer_gap==scale*gap
 expected=dict(minorant_coefficients=coefficients,minorant_pattern_values=values,pattern_costs=costs,minimizing_pattern_law=law,
  low_moment_targets=q,fmap=fmap,dual_sign=sign,exact_minimum_pattern_cost=objective,source_target_constant=gvalue,
  exact_projected_gap=gap,constant_minorant_gap=gvalue+min(costs),positive_normalization_scale=scale,
  integer_exact_violation=integer_gap,row=row,integer_row=integer_row)
 validate_saved(d,expected);rejected=[]
 for label in ['minorant_coefficient','owner_rhs','owner_scale','target_gap','false_separation','moment_factor']:
  bad=copy.deepcopy(d)
  if label=='minorant_coefficient':bad['minorant_coefficients'][0]=str(Q(bad['minorant_coefficients'][0])+1)
  elif label=='owner_rhs':bad['rhs']+=1
  elif label=='owner_scale':bad['positive_normalization_scale']=str(Q(bad['positive_normalization_scale'])*2)
  elif label=='target_gap':bad['exact_projected_gap']=str(Q(bad['exact_projected_gap'])+1)
  elif label=='false_separation':bad['candidate_separates_point']=not bad['candidate_separates_point']
  else:bad['low_owner_map'][1]+=1
  try:validate_saved(bad,expected)
  except (AssertionError,IndexError,KeyError):rejected.append(label)
  else:raise AssertionError(('Accepted projection mutation',label))
 result=dict(status='PASS_EXACT_PIN_FREE_SHARED_MASTER_OWNER_PROJECTION',certificate_sha256=sha(a.certificate),consumer_sha256=sha(Path(__file__).name),
  pricing_sha256=d['pricing_sha256'],pricing_receipt_sha256=d['pricing_receipt_sha256'],minorant_manifest_sha256=d['minorant_manifest_sha256'],
  point_sha256=d['point_sha256'],lp_rows_checked=27,exact_primal_dual_objectives_equal=True,minorant_patterns_checked=16,
  all32_domains_priced_by_bound_receipt=True,finite_parent_variables_cancelled=22513,source_target_constant=str(gvalue),
  exact_minimum_pattern_cost=str(objective),constant_minorant_gap=str(gvalue+min(costs)),exact_projected_gap=str(gap),
  exact_minorant_improvement=str(objective-min(costs)),owner_nonzero_coefficients=len(integer_row)-(0 in integer_row),
  maximum_integer_coefficient_bits=d['maximum_integer_coefficient_bits'],fits_signed_int64=d['fits_signed_int64'],
  valid_pin_free_necessary_row=True,separates_current_point=gap>0,zero_tau_pins=False,full_source_frame=False,source_C16_answered=False,
  rejected_mutants=rejected,source_hashes=d['source_hashes'],dependencies={p:sha(p) for p in ['verify_shared_master_projection.py','verify_shared_master_common.py','verify_two_sided_full_basis_oracle.py','read_soplex_exact_output_v2.py']},
  elapsed_seconds=time.monotonic()-start,nice=19,threads=1,
  scope='Pin-free owner inequality and exact target evaluation. Only a positive gap rejects this fractional target; no full source-case exclusion follows.')
 out.write_text(json.dumps(result,indent=2)+'\n')
 print(json.dumps({k:v for k,v in result.items() if k not in ['source_hashes','dependencies']},indent=2))
if __name__=='__main__':main()
