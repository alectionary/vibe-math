"""Join frozen terminal Chapter6 analysis to source claims without adjudicating success.
No trial exports, model dispatch, manuscript edits, or scientific-status defaults.
"""
import argparse,csv,hashlib,importlib.util,json,math,pathlib,re,tempfile
from datetime import datetime,timedelta
ROOT=pathlib.Path(__file__).resolve().parents[1]
FILES=('summary.json','condition-summary.csv','signed-SE-contrasts.csv','source-comparisons.csv','signed-bias-contrasts.csv','provenance.json')
ANALYZER_SHA='fc26fcd51aac29358b2865db209fd16b1421841fe72bccd9b356d651d34ae518'
SPEC_SHA='ec7aa73921f52679df57abdc29a5e5906ffbd78a306a7d2ddebe2b2bb8df356f'
BUILDER_SHA='6cc15c120e618700b7bc0c64cd5e041b1a6224709a031accc165131c848694b5'

def sha(path):return hashlib.sha256(pathlib.Path(path).read_bytes()).hexdigest()
def snapshot(directory):return {n:sha(pathlib.Path(directory)/n) for n in FILES}
def snapshot_sha(hashes):return hashlib.sha256(json.dumps(hashes,sort_keys=True,separators=(',',':')).encode()).hexdigest()
def read_csv(path):
 with pathlib.Path(path).open() as f:return list(csv.DictReader(f))
def value(x):
 if x is None or x=='':return None
 x=float(x)
 if not math.isfinite(x):raise ValueError('Nonfinite mapped number')
 return x

def equal(a,b,label):
 if a is None or b is None or not math.isclose(float(a),float(b),rel_tol=1e-13,abs_tol=1e-14):raise ValueError('Source/analysis mismatch: '+label)

def map_results(spec_path,analysis,expected_snapshot,terminal_record=None,fixture=False):
 analysis=pathlib.Path(analysis).resolve();spec_path=pathlib.Path(spec_path).resolve()
 hashes=snapshot(analysis)
 if snapshot_sha(hashes)!=expected_snapshot:raise ValueError('Analysis snapshot hash mismatch')
 provenance=json.loads((analysis/'provenance.json').read_text())
 analyzer_hashes=[v for k,v in provenance.get('files',{}).items() if pathlib.Path(k).name=='analyze_production.py']
 if analyzer_hashes!=[ANALYZER_SHA] or sha(ROOT/'simulation/analyze_production.py')!=ANALYZER_SHA:raise ValueError('Reviewed analyzer identity missing or changed')
 if not fixture:
  if sha(spec_path)!=SPEC_SHA:raise ValueError('Reviewed source specification identity changed')
  if terminal_record is None:raise ValueError('Explicit terminal record required; never read a live run')
  terminal=json.loads(pathlib.Path(terminal_record).read_text())
  observed=terminal.get('observed_utc')
  try:
   if not isinstance(observed,str) or 'T' not in observed:raise ValueError('ISO UTC string required')
   timestamp=datetime.fromisoformat(observed.replace('Z','+00:00'))
   if timestamp.tzinfo is None or timestamp.utcoffset()!=timedelta(0):raise ValueError('UTC timezone required')
  except (ValueError,TypeError):raise ValueError('Terminal observed_utc must be an explicit ISO UTC timestamp')
  if terminal.get('state') not in ('completed','wall_time_cap','operational_failure','stopped') or type(terminal.get('active_processes')) is not int or terminal['active_processes']!=0 or terminal.get('analysis_snapshot_sha256')!=expected_snapshot:
   raise ValueError('Terminal evidence missing, active, or mismatched')
  summary=json.loads((analysis/'summary.json').read_text())
  if terminal['state']=='completed' and summary.get('complete_attempted_grid') is not True:raise ValueError('Completed terminal state requires complete attempted grid')
 else:terminal={'scope':'SYNTHETIC/PRESERVED BASELINE FIXTURE ONLY; not terminal production'}
 # Reuse the independently reviewed read-only scientific-table integrity checks;
 # generated tables exist only in an automatically removed temporary directory.
 bp=ROOT/'simulation/build_production_report.py'
 if sha(bp)!=BUILDER_SHA:raise ValueError('Reviewed validator-builder identity changed')
 module=importlib.util.spec_from_file_location('reviewed_builder',bp);builder=importlib.util.module_from_spec(module);module.loader.exec_module(builder)
 with tempfile.TemporaryDirectory(prefix='schwabe-map-validation-') as td:builder.build(analysis,pathlib.Path(td)/'tables')
 spec=json.loads(spec_path.read_text());allclaims={r['id']:r for r in spec['claims']}
 if len(allclaims)!=len(spec['claims']):raise ValueError('Duplicate source ID')
 claims=[r for r in spec['claims'] if any(x.startswith('C6') for x in r['legacy_ids'])]
 if len(claims)!=408:raise ValueError('Expected audited408 Chapter6 claim IDs; review mapping for changed inventory')
 tables={n:read_csv(analysis/n) for n in FILES[1:5]}
 def key(r,extra):return (r['mechanism'],int(r['q']),float(r['missing']))+tuple(r[x] for x in extra)
 compare={key(r,('method','parameter','metric')):r for r in tables['source-comparisons.csv']}
 contrast={key(r,('parameter','metric')):r for r in tables['signed-SE-contrasts.csv']}
 bias={key(r,('method','parameter')):r for r in tables['signed-bias-contrasts.csv']}
 def joined(filename,row,field,kind):
  keys={k:row[k] for k in ('mechanism','q','missing','method','parameter','metric') if k in row}
  return {'table':filename,'row_key':keys,'value_field':field,'computed_value':value(row[field]) if field else None,'kind':kind,'unavailable_reason':('No guard-valid estimates for this mapped quantity; failures and requested denominators retained' if field and row[field]=='' else None),'row':row,'row_scope':'Shared guarded simulation evidence, not an independent claim-specific replication'}
 records=[];figkeys=set();precisionkeys=set();biaskeys=set()
 for c in claims:
  ident=c['id'];rec={'claim_id':ident,'published':c['published'],'conditions':c['conditions'],
   'source_locator':c['source_locator'],'parent_claim_ids':c.get('parent_claim_ids',[]),
   'component_claim_ids':c.get('component_claim_ids',[]),'component_contrast_refs':c.get('component_contrast_refs',[]),
   'computed_value':None,'mappings':[],'contrasts':[],'missing_reason':None,
   'adjudication_required':True}
  fig=re.fullmatch(r'C6-[234]\.fig(6\.[3456])\.q([2-5])\.missing(0\.02|0\.06|0\.1)\.(A|C|E|h2)\.(full|deletion)',ident)
  precision=re.fullmatch(r'C6-[24]\.precision\.(MCAR|MAR|MNAR)\.(A|C|E)',ident)
  mar=re.fullmatch(r'C6-3\.MAR-bias\.(A|C|h2)',ident)
  if fig:
   figure,q,missing,param,method=fig.groups();mech={'6.3':'MCAR','6.4':'MAR','6.5':'MAR','6.6':'MNAR'}[figure]
   metric='estimate' if figure=='6.5' else 'se';k=(mech,int(q),float(missing),method,param,metric)
   cond=c['conditions']
   if any(cond[f]!=v for f,v in [('mechanism',mech),('q',int(q)),('missing_fraction_as_methods',float(missing)),('method',method),('parameter',param),('N_pairs',1000),('replications',1000)]):raise ValueError('Wrong source figure conditions: '+ident)
   units='SE of variance component in squared phenotype units' if metric=='se' else 'heritability proportion' if param=='h2' else 'phenotype variance units'
   if c['published']['units']!=units:raise ValueError('Wrong published figure units')
   row=compare[k]
   if row['figure']!=figure:raise ValueError('Wrong source figure')
   equal(c['published']['value'],row['source'],ident);figkeys.add(k)
   rec['computed_value']=value(row['ours'])
   if rec['computed_value'] is None:rec['missing_reason']='No guard-valid estimates in this analysis snapshot; see full requested/completed/invalid/failure denominators.'
   rec['mappings'].append(joined('source-comparisons.csv',row,'ours','same printed source estimand; source procedure uncertainty retained'))
   if metric=='se':
    rec['exploratory_path_SE']=joined('source-comparisons.csv',compare[k[:-1]+('path_se',)],'ours','EXPLORATORY DIFFERENT ESTIMAND; not substituted for variance SE')
  elif precision or ident=='H6.precision-grid':
   if len(c['contrasts'])!=(12 if precision else 108):raise ValueError('Incomplete precision source grid')
   if precision and any(c['conditions'].get(k)!=v for k,v in [('mechanism',precision.group(1)),('q_grid',[2,3,4,5]),('missing_grid',[.02,.06,.1]),('N_pairs',1000),('replications_per_cell',1000)]):raise ValueError('Wrong precision parent design')
   localkeys=set()
   for i,sc in enumerate(c['contrasts']):
    match=re.fullmatch(r'Mean SE of (A|C|E) variance under deletion minus full information, (MCAR|MAR|MNAR),q=([2-5]),missing=(0\.02|0\.06|0\.1)',sc['definition'])
    if not match:raise ValueError('Unknown precision definition: '+ident)
    param,mech,q,missing=match.groups();k=(mech,int(q),float(missing),param,'se')
    if k in localkeys:raise ValueError('Duplicate precision source grid cell')
    localkeys.add(k)
    if precision and (mech,param)!=precision.groups():raise ValueError('Precision source ID/contrast mismatch')
    if sc.get('conditions')!={'mechanism':mech,'q':int(q),'missing_fraction':float(missing)}:raise ValueError('Precision source conditions mismatch')
    if sc['units']!='SE of variance component in squared phenotype units' or sc['published']['units']!=sc['units'] or sc['positive_means']!='Full information has smaller variance-component SE.':raise ValueError('Wrong precision units/direction')
    row=contrast[k];equal(sc['published']['value'],row['source_deletion_minus_full'],ident)
    equal(sc['tolerance']['value'],row['source_contrast_extraction_bound'],ident+' bound')
    rec['contrasts'].append({'contrast_index':i,'source':sc,**joined('signed-SE-contrasts.csv',row,'contrast_delete_minus_full','signed variance-SE deletion minus full'),
      'exploratory_path_SE':joined('signed-SE-contrasts.csv',contrast[k[:-1]+('path_se',)],'contrast_delete_minus_full','EXPLORATORY DIFFERENT ESTIMAND')})
    if precision:precisionkeys.add(k)
   rec['missing_reason']='No single scientific scalar across grid; all constituent signed contrasts retained without averaging.'
  elif mar:
   if len(c['contrasts'])!=24:raise ValueError('Incomplete MAR source bias grid')
   if any(c['conditions'].get(k)!=v for k,v in [('q_grid',[2,3,4,5]),('missing_grid',[.02,.06,.1]),('N_pairs',1000),('replications_per_cell',1000)]):raise ValueError('Wrong MAR parent design')
   localkeys=set();param=mar.group(1)
   for i,sc in enumerate(c['contrasts']):
    match=re.fullmatch(r'Mean estimate of(A|C|h2) minus generating\1,method=(full|deletion),MAR,q=([2-5]),missing=(0\.02|0\.06|0\.1)',sc['definition'])
    if not match:raise ValueError('Unknown MAR bias definition')
    p,method,q,missing=match.groups()
    if p!=param:raise ValueError('MAR source parameter mismatch')
    units='heritability proportion' if param=='h2' else 'phenotype variance units'
    if sc['units']!=units or sc['published']['units']!=units or sc['positive_means']!='Upward bias relative to the fixed generating value.':raise ValueError('Wrong MAR units/direction')
    if 'conditions' in sc and sc['conditions']!={'mechanism':'MAR','q':int(q),'missing_fraction':float(missing),'method':method}:raise ValueError('Wrong MAR per-contrast conditions')
    k=('MAR',int(q),float(missing),method,param);row=bias[k]
    if k in localkeys:raise ValueError('Duplicate MAR source bias cell')
    localkeys.add(k)
    equal(sc['published']['value'],row['source_bias_estimate_minus_truth'],ident)
    equal(c['conditions']['truth'],row['generating_truth'],ident+' generating truth')
    equal(sc['tolerance']['value'],row['source_extraction_bound'],ident+' bound')
    biaskeys.add(k);rec['contrasts'].append({'contrast_index':i,'source':sc,**joined('signed-bias-contrasts.csv',row,'ours_bias_estimate_minus_truth','signed estimate minus residual ACE generating truth')})
   rec['missing_reason']='No single scientific scalar across grid; all24 method-specific bias cells retained.'
  elif ident.startswith('C6-6.') or ident in ('H6.covariate-nondetection','C6.Bayes-ML'):
   rec['missing_reason']='Original empirical raw inputs unavailable to this simulation mapper; simulation results cannot replace empirical counts, coefficients, intervals or Bayesian/ML agreement.'
  elif 'power-inference' in ident or ident in ('H6.power-assertion','C6.zyg-structure'):
   rec['missing_reason']='No quantified source rejection-rate experiment, unique test/alternative or comparable power estimand; variance SE is not power.'
  else:
   selected=[];reason='Separate analytical/software evidence or scientific adjudication required; no matching terminal simulation scalar.'
   recovery=re.fullmatch(r'C6-5\.recovery\.(MCAR|MAR|MNAR)\.(A|C|E|h2)',ident)
   trend=re.fullmatch(r'C6-[24]\.SE-trend\.(MCAR|MAR|MNAR)\.(A|C|E)',ident)
   if recovery or trend:
    mech,param=(recovery or trend).groups();selected=[r for r in tables['condition-summary.csv'] if r['mechanism']==mech and r['parameter']==param]
    reason='Complete descriptive grid available; source provides no numerical recovery/constancy criterion. No tolerance, trend test, power or success is inferred.'
   elif ident=='C6-5.beta-recovery':
    selected=[r for r in tables['condition-summary.csv'] if r['parameter'].startswith('beta')]
    reason='All regression-coefficient cells retained descriptively; source coefficients and close-to-truth tolerance were not tabulated. No invented recovery criterion.'
   elif ident=='C6-5.MNAR.E10':
    selected=[r for r in tables['condition-summary.csv'] if r['mechanism']=='MNAR' and r['parameter']=='E' and r['method']=='full' and float(r['missing'])==.1]
    reason='Four q-specific means/biases available; source prose .21 has no per-q scalar. No averaging or fabricated one-to-one match.'
   elif ident=='C6-3.C-versus-A':
    selected=[r for r in tables['condition-summary.csv'] if r['mechanism']=='MAR' and r['method']=='deletion' and r['parameter'] in ('A','C')]
    reason='All paired-condition A/C bias summaries retained; comparative severity has no predeclared inferential contrast here.'
   elif ident=='C6.recommendation':
    rec['linked_evidence_claim_ids']=['H6.precision-grid','C6-3.MAR-bias.A','C6-3.MAR-bias.C','C6-3.MAR-bias.h2']
    reason='Practical recommendation requires scientific synthesis of whole grids and assumptions; no universal threshold or automatic success assigned.'
   for r in selected:
    row=joined('condition-summary.csv',r,'se_mean' if trend else 'estimate_mean','descriptive grid only; no scientific verdict')
    row['missingness_role']='3% sensitivity' if float(r['missing'])==.03 else 'primary source design'
    rec['mappings'].append(row)
   rec['missing_reason']=reason
  # Every uncomputed source contrast remains explicit, including raw-data and power gaps.
  if not rec['contrasts']:
   rec['contrasts']=[{'contrast_index':i,'source':sc,'computed_value':None,'missing_reason':rec['missing_reason'] or 'Absolute figure quantity is not a signed scientific contrast'} for i,sc in enumerate(c['contrasts'])]
  records.append(rec)
 expected_fig={k for k in compare if k[-1]!='path_se'}
 expected_precision={k for k in contrast if k[-1]=='se' and k[2]!=.03}
 if figkeys!=expected_fig or len(figkeys)!=288:raise ValueError('Incomplete/duplicate source figure mapping')
 if precisionkeys!=expected_precision or len(precisionkeys)!=108:raise ValueError('Incomplete precision mapping')
 if biaskeys!=set(bias) or len(biaskeys)!=72:raise ValueError('Incomplete MAR bias mapping')
 if snapshot(analysis)!=hashes:raise ValueError('Analysis changed during mapping')
 return {'schema_version':1,'document_kind':'chapter6_evidence_join_not_adjudication',
  'fixture_only':fixture,'specification':{'path':str(spec_path),'sha256':sha(spec_path)},
  'analysis_directory':str(analysis),'analysis_file_sha256':hashes,'analysis_snapshot_sha256':expected_snapshot,
  'terminal_record':terminal,'analyzer_sha256':ANALYZER_SHA,'reviewed_specification_sha256':SPEC_SHA,'builder_validation_sha256':BUILDER_SHA,'mapper_sha256':sha(__file__),
  'inventory':{'source_claim_ids':len(records),'source_figure_points':len(figkeys),'unique_primary_variance_SE_contrasts':len(precisionkeys),'unique_MAR_bias_contrasts':len(biaskeys)},
  'claims':records,'missing_scalar_ids':[{'id':r['claim_id'],'reason':r['missing_reason']} for r in records if r['missing_reason']],
  'sensitivity_SE_contrasts':[joined('signed-SE-contrasts.csv',r,'contrast_delete_minus_full','3% sensitivity separate from2% primary') for r in tables['signed-SE-contrasts.csv'] if float(r['missing'])==.03],
  'limitations':['No scientific success/status is assigned. Root adjudication remains required.',
   'Shared rows may support parent and child claims; they are not independent observations or a success-count denominator.',
   'Guard-invalid/failed/pending denominators and all uncertainty fields stay in source rows.',
   'Variance/path SEs differ in estimand. Original source Monte Carlo uncertainty and procedure remain unknown; geometric bands are not equivalence.',
   'Untabulated recovery and power cannot receive invented criteria or inferred successful reproduction.']}

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--spec',required=True);p.add_argument('--analysis-dir',required=True);p.add_argument('--analysis-snapshot-sha256',required=True);p.add_argument('--terminal-record');p.add_argument('--fixture',action='store_true');p.add_argument('--output',required=True);a=p.parse_args()
 out=pathlib.Path(a.output)
 if out.exists():raise ValueError('Refusing to overwrite result mapping')
 result=map_results(a.spec,a.analysis_dir,a.analysis_snapshot_sha256,a.terminal_record,a.fixture)
 out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(result,indent=2,allow_nan=False)+'\n')
 print(json.dumps({'output':str(out),'sha256':sha(out),'inventory':result['inventory'],'fixture_only':a.fixture}))
if __name__=='__main__':main()
