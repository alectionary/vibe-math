"""Independent all-domain price and source-row cancellation acceptance.

Does not import the new pricing producer or its algebra helper. Reconstructs
the source combination directly, and bounds every physical price with the
earlier independent signed-prefix rank consumer. No optimization is run.
"""
from fractions import Fraction as Q
from pathlib import Path
import argparse,copy,json,time
from verify_shared_master_common import guard,resolve,sha,read,bindings,expected_rows,link_index,value
from verify_shared_master_preparation import context
from verify_two_sided_full_basis_oracle import check_sector,columns as physical_owner_columns
from read_soplex_exact_output_v2 import read_named_rational
LOW=(0,1,2,4,8,3,5,9,6,10,12)

def add_scaled(out,terms,scale):
 for j,v in terms.items():
  q=out.get(j,Q(0))+scale*v
  if q:out[j]=q
  else:out.pop(j,None)

def saved_checks(p,expected):
 assert p['status']=='EXACT_SHARED_MASTER_FULL_DOMAIN_PRICING_REQUIRES_REPLAY'
 assert p['zero_tau_pins'] is False and p['all32_domains_priced'] is True
 assert p['artificial_errors_evaluated_at_source_zero'] is True
 assert p['finite_residual_coefficients']==p['tau_residual']==[]
 assert p['high_moment_pattern_correction']==['0']*16
 assert p['parent_variable_count']==22513 and p['parent_rows_checked']==98863
 assert p['archive_columns_checked']==expected['nB'] and p['error_stationarity_checks']==46080
 assert {j:Q(v) for j,v in p['owner_feature_coefficients']}==expected['G']
 assert len(p['owner_feature_coefficients'])==len(expected['G'])
 assert Q(p['source_target_constant'])==expected['objective']
 assert p['low_owner_map']==expected['fmap']
 assert list(map(Q,p['low_moment_targets']))==expected['q']
 assert list(map(Q,p['feasible_pattern_law']))==expected['law']
 assert list(map(Q,p['pattern_costs']))==expected['costs']
 assert Q(p['constant_minorant_gap'])==expected['objective']+min(expected['costs'])
 assert Q(p['saved_law_cost_gap'])==expected['objective']+sum(c*w for c,w in zip(expected['costs'],expected['law']))
 assert [r['mask'] for r in p['pattern_records']]==list(range(16))
 for record in p['pattern_records']:
  m=record['mask'];assert set(record['sectors'])=={'X','Z'}
  for s in 'XZ':
   r=record['sectors'][s];b=expected['blocks'][s,m]
   assert Q(r['constant'])==b['gamma'] and list(map(Q,r['weights']))==b['c']
   assert Q(r['minimum'])==b['minimum']
   assert r['selected_indices']==b['selected']
   assert record['oracle_support'][s+'_selected']==b['selected']
   assert Q(record['oracle_support'][s+'_support']['value'])==b['gamma']-b['minimum']
 want={(s,m):b for (s,m),b in expected['blocks'].items() if b['minimum']<0}
 actual={}
 for r in p['negative_column_prices']:
  key=r['side'],r['mask'];assert key not in actual;actual[key]=r
 assert set(actual)==set(want)
 for key,b in want.items():
  assert Q(actual[key]['minimum'])==b['minimum'] and actual[key]['indices']==b['selected']

def main():
 guard();ap=argparse.ArgumentParser();ap.add_argument('--pricing',required=True);ap.add_argument('--output',required=True)
 a=ap.parse_args();start=time.monotonic();out=resolve(a.output);assert not out.exists();p=read(a.pricing)
 for key in ['manifest','preparation','endpoint','primal','dual','point']:assert sha(p[key])==p[key+'_sha256']
 bindings(p['source_hashes']);endpoint=read(p['endpoint'])
 assert endpoint['status']=='PASS_EXACT_RESTRICTED_SHARED_MASTER_PHASE_ONE_OPTIMUM'
 assert endpoint['consumer_sha256']==sha('verify_shared_master_endpoint.py')
 assert endpoint['manifest_sha256']==p['manifest_sha256'] and endpoint['preparation_receipt_sha256']==p['preparation_sha256']
 assert endpoint['primal_sha256']==p['primal_sha256'] and endpoint['dual_sha256']==p['dual_sha256']
 data,L,semantic=context(p['manifest'],p['preparation'],check_columns=False)
 assert p['point_sha256']==endpoint['point_sha256']==data['manifest']['point_sha256']
 assert resolve(p['point'])==resolve(data['manifest']['point'])
 M,f=data['M'],data['f'];N=L['variable_count'];rows=list(expected_rows(data,L))
 raw=read_named_rational(resolve(p['dual']),[r[0] for r in rows],'dual')
 sign=endpoint['dual_sign'];assert sign in (-1,1) and p['dual_sign']==sign
 dual={name:sign*v for name,v in raw.items()}
 assert {k:v for k,v in dual.items() if v}=={k:Q(v) for k,v in endpoint['normalized_dual_row_weights']}
 primal_map=read_named_rational(resolve(p['primal']),['x'+str(j) for j in range(N)])
 primal=[primal_map['x'+str(j)] for j in range(N)]
 assert primal[:22513]==list(map(Q,endpoint['full_parameters']))
 G,V={},{};parent_count=0
 for name,e,rel in data['parent_rows']:
  pi=dual[name]
  if rel=='<=':assert pi<=0
  add_scaled(G,e[0],-pi);add_scaled(V,e[1],-pi);parent_count+=1
 blocks={}
 for m in range(16):
  for s in 'XZ':
   mass_pi=dual[f'sm_mass_{s}_{m}'];lam=M['lambda_expressions'][m]
   add_scaled(G,lam[0],mass_pi);add_scaled(V,lam[1],mass_pi);costs=[]
   for j,e in enumerate(M['sectors'][s]['allocations'][m]):
    pi=dual[f'sm_link_{s}_{m}_{j}'];add_scaled(G,e[0],pi);add_scaled(V,e[1],pi);costs.append(-pi)
    q=link_index(s,m,j);plus=dual['sm_nonneg_'+str(L['plus_start']+q)];minus=dual['sm_nonneg_'+str(L['minus_start']+q)]
    assert plus<=0 and minus<=0 and pi-plus==1 and -pi-minus==1 and -1<=pi<=1
   blocks[s,m]=dict(gamma=-mass_pi,c=costs)
 assert parent_count==98863 and not V,'Uncancelled finite variable in general source combination'
 objective=sum(primal[L['plus_start']:]);assert objective==Q(endpoint['exact_objective'])
 assert sum(v*f[j] for j,v in G.items())==objective
 for k,col in enumerate(L['columns']):
  b=blocks[col['side'],col['mask']];pi=dual['sm_nonneg_'+str(22513+k)]
  assert pi<=0 and b['gamma']+sum(b['c'][j] for j in col['indices'])==-pi
 assert len(p['pattern_records'])==16;prefixes=0;missing=[]
 for record in p['pattern_records']:
  m=record['mask'];assert type(m)is int and 0<=m<16
  for s in 'XZ':
   b=blocks[s,m];chosen=record['sectors'][s]['selected_indices']
   upper,n=check_sector(data[s],128,data['domains'][m][s],[-v for v in b['c']],chosen)
   minimum=b['gamma']-upper;prefixes+=n;b.update(minimum=minimum,selected=chosen)
   assert minimum==b['gamma']+sum(b['c'][j] for j in chosen)
   if minimum<0:
    assert all(tuple(sorted(chosen))!=tuple(sorted(L['columns'][k]['indices'])) for k in L['blocks'][s,m])
    missing.append((s,m))
 costs=[blocks['X',m]['minimum']+blocks['Z',m]['minimum'] for m in range(16)]
 physical_map=physical_owner_columns([80,512],[186,433])[:11]
 fmap=[0 if j is None else j+1 for j in physical_map]
 assert M['source_feature_to_owner_target'][:11]==fmap and len(set(fmap))==11
 q=[f[j] for j in fmap];law=[value(e,f,primal) for e in M['lambda_expressions']]
 assert law==list(map(Q,endpoint['lambda_masses'])) and min(law)>=0 and sum(law)==1
 assert all(sum(law[m] for m in range(16) if m&h==h)==q[i] for i,h in enumerate(LOW))
 expected=dict(G=G,objective=objective,blocks=blocks,costs=costs,fmap=fmap,q=q,law=law,nB=L['nB'])
 saved_checks(p,expected);rejected=[]
 for label in ['owner_coefficient','full_price','missing_pattern','wrong_owner_map','hidden_tau_residual','wrong_gap']:
  bad=copy.deepcopy(p)
  if label=='owner_coefficient':
   if bad['owner_feature_coefficients']:bad['owner_feature_coefficients'][0][1]=str(Q(bad['owner_feature_coefficients'][0][1])+1)
   else:bad['owner_feature_coefficients']=[[0,'1']]
  elif label=='full_price':bad['pattern_records'][0]['sectors']['X']['minimum']=str(Q(bad['pattern_records'][0]['sectors']['X']['minimum'])+1)
  elif label=='missing_pattern':bad['pattern_records'].pop()
  elif label=='wrong_owner_map':bad['low_owner_map'][1]+=1
  elif label=='hidden_tau_residual':bad['tau_residual']=[[7,'1']]
  else:bad['constant_minorant_gap']=str(Q(bad['constant_minorant_gap'])+1)
  try:saved_checks(bad,expected)
  except (AssertionError,KeyError,IndexError):rejected.append(label)
  else:raise AssertionError(('Accepted mutated pricing',label))
 result=dict(status='PASS_EXACT_SHARED_MASTER_FULL_DOMAIN_PRICING',pricing_sha256=sha(a.pricing),
  consumer_sha256=sha(Path(__file__).name),manifest_sha256=p['manifest_sha256'],endpoint_sha256=p['endpoint_sha256'],
  source_hashes=p['source_hashes'],dependencies={name:sha(name) for name in ['verify_shared_master_common.py','verify_shared_master_preparation.py','verify_shared_master_endpoint.py','verify_two_sided_full_basis_oracle.py','read_soplex_exact_output_v2.py']},
  source_rows_checked=98863,finite_variables_cancelled=22513,archive_column_stationarity=L['nB'],error_stationarity=46080,
  full_domains_priced=32,physical_full_basis_minimizers=32,independent_signed_prefix_ranks=prefixes,
  negative_full_prices=len(missing),missing_column_domains=[list(v) for v in missing],exact_restricted_objective=str(objective),
  constant_minorant_gap=str(objective+min(costs)),saved_law_cost_gap=str(objective+sum(c*w for c,w in zip(costs,law))),
  rejected_mutants=rejected,zero_tau_pins=False,full_basis_membership_claimed=False,new_separating_owner_row_accepted=False,
  source_C16_answered=False,scope='Exact general source combination and all32 physical prices; projection minorant still requires independent acceptance.',
  elapsed_seconds=time.monotonic()-start,nice=19,threads=1)
 out.write_text(json.dumps(result,indent=2)+'\n')
 print(json.dumps({k:v for k,v in result.items() if k not in ['source_hashes','dependencies']},indent=2))
if __name__=='__main__':main()
