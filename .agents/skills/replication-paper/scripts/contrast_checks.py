"""Keep effect direction, numerical agreement, scope and uncertainty distinct.

These checks do not choose scientific headlines, margins, or valid sampling
models; a reviewer must justify them. Existing checks.numerical_verdict retains
its printed-number rounding semantics.
"""
from math import isfinite,sqrt
from statistics import NormalDist

def contrast(source,ours,definition,source_uncertainty_known=False):
 if not definition.strip():raise ValueError('signed scientific contrast definition required')
 if not all(isfinite(x) for x in (source,ours)):raise ValueError('finite contrasts required')
 sign=lambda x:'positive' if x>0 else 'negative' if x<0 else 'zero'
 return dict(definition=definition,source_point_direction=sign(source),our_point_direction=sign(ours),point_reversal=source*ours<0,source_ranking_inference='not established by point estimates' if source_uncertainty_known else 'withheld: source uncertainty unknown')

def source_band(difference,our_se,extraction_bound,family_size,source_se=None,alpha=.05):
 values=[difference,our_se,extraction_bound]+([] if source_se is None else [source_se])
 if not all(isfinite(x) for x in values) or our_se<0 or extraction_bound<0 or (source_se is not None and source_se<0):raise ValueError('finite nonnegative uncertainty required')
 if isinstance(family_size,bool) or not isinstance(family_size,int) or family_size<1 or not 0<alpha<1:raise ValueError('positive family size and valid alpha required')
 se=sqrt(our_se**2+(source_se or 0)**2);z=NormalDist().inv_cdf(1-alpha/(2*family_size));b=z*se+extraction_bound;a=2*se+extraction_bound
 return dict(family_size=family_size,z=z,two_se_halfwidth=a,adjusted_halfwidth=b,two_se_status='inside' if abs(difference)<=a else 'outside',adjusted_status='inside' if abs(difference)<=b else 'outside',adjusted_endpoints=[difference-b,difference+b],conditional=source_se is None,source_uncertainty='unknown' if source_se is None else 'supplied',not_equivalence=True)

def validate_inventory(rows):
 errors=[]
 if not any(r.get('role')=='headline' for r in rows):errors.append('headline inventory required')
 for i,r in enumerate(rows):
  if r.get('role') not in ('headline','supporting'):errors.append(f'{i}: role must be headline or supporting')
  if not r.get('claim'):errors.append(f'{i}: scientific claim required')
  if r.get('kind')=='contrast':
   try:
    c=contrast(r['source_contrast'],r['ours_contrast'],r['definition'])
    if r.get('source_point_direction')!=c['source_point_direction'] or r.get('our_point_direction')!=c['our_point_direction']:errors.append(f'{i}: ambiguous or incorrect effect direction')
    if r.get('point_reversal') is not c['point_reversal']:errors.append(f'{i}: reversal not reported correctly')
   except (KeyError,ValueError,TypeError):errors.append(f'{i}: incomplete signed contrast')
  elif r.get('kind') not in ('resource','parameter'):errors.append(f'{i}: quantity kind required')
  if r.get('numerical') not in ('match','close','mismatch','withheld'):errors.append(f'{i}: separate numerical verdict required')
  if r.get('scope') not in ('exact','limited','unavailable'):errors.append(f'{i}: separate scope required')
  if r.get('numerical')=='close' and r.get('numerical_criterion')!='rounding_one_unit':errors.append(f'{i}: close must use rounding_one_unit; name statistical/margin decisions separately')
  if 'uncertainty_decision' not in r:errors.append(f'{i}: separate uncertainty decision required')
 return errors

def validate_contrast_coverage(records,expected_conditions):
 """Compare declared (analysis,condition) keys; expected scope needs human review."""
 keys=[(r['analysis'],r['condition']) for r in records];expected=set(expected_conditions);actual=set(keys);errors=[]
 if len(keys)!=len(actual):errors.append('duplicate contrast conditions')
 if expected-actual:errors.append('missing declared contrast conditions')
 if actual-expected:errors.append('undeclared contrast conditions')
 return errors
