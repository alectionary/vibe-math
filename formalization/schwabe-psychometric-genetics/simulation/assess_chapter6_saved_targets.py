"""Additive descriptive audit of26 targets. No fitting or inferential tests."""
import csv,json,hashlib,datetime
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def read(p):return list(csv.DictReader((ROOT/p).open()))
def dump(p,x):(ROOT/p).write_text(json.dumps(x,indent=2,allow_nan=False)+'\n')
def key(r):return (r['mechanism'],int(r['q']),float(r['missing']),r['method'],r['parameter'])
def f(r,k):return float(r[k])
inputs=['coverage-v3.csv','handoff/evidence-packet.json','production/chapter6-v1/terminal-analysis/condition-summary.csv','production/chapter6-v1/terminal-analysis/signed-SE-contrasts.csv','source-local/schwabe.txt']
before={p:sha(p) for p in inputs}
cs=read(inputs[2]);lookup={key(r):r for r in cs};paired=read(inputs[3]);packet={r['id']:r for r in json.load((ROOT/inputs[1]).open())['claims']};targets=[r['claim_id'] for r in read(inputs[0]) if r['reconciliation_rule']=='ch6_nonquantified_target_not_closed'];assert len(targets)==26
for r in cs:assert int(r['estimate_n'])==1000
primary=[.02,.06,.1];allmissing=[.02,.03,.06,.1]
def selected(mech,par,method=None):return [r for r in cs if r['mechanism']==mech and r['parameter']==par and (method is None or r['method']==method)]
def snapshot(r):return {k:r[k] for k in ['mechanism','q','missing','method','parameter']}|{k:f(r,k) for k in ['generating_truth','estimate_mean','estimate_mcse','bias','rmse','se_mean','se_mcse']}|{'n':int(r['estimate_n']),'design_scope':'sensitivity' if float(r['missing'])==.03 else 'primary'}
results=[]
for i in targets:
 c=packet[i];v={'id':i,'source_statement':c['statement'],'source_locator':c['source_locator'],'frozen_scientific_status':c['status'],'scientific_status_changed':False,'work_now':'attempted-incomplete','descriptive_analysis_complete':True,'inference':'No new confidence intervals, p-values, equivalence margins or statistical success criteria. Existing paired intervals are explicitly identified where reused.','evidence':{},'outstanding_scope':'','next_action':''}
 if '.SE-trend.' in i:
  mech,par=i.split('.')[-2:];cells=selected(mech,par);contrasts=[]
  for method in ['full','deletion']:
   for missing in allmissing:
    for q in [2,3,4]:
     lo=lookup[(mech,q,missing,method,par)];hi=lookup[(mech,q+1,missing,method,par)];contrasts.append({'method':method,'missing':missing,'q_from':q,'q_to':q+1,'signed_SE_next_q_minus_previous':f(hi,'se_mean')-f(lo,'se_mean'),'scope':'sensitivity' if missing==.03 else 'primary'})
  summary={}
  for method in ['full','deletion']:
   vals=[f(r,'se_mean') for r in cells if r['method']==method and float(r['missing']) in primary];ds=[x['signed_SE_next_q_minus_previous'] for x in contrasts if x['method']==method and x['scope']=='primary'];summary[method]={'primary_SE_min':min(vals),'primary_SE_max':max(vals),'primary_SE_range':max(vals)-min(vals),'primary_adjacent_positive':sum(d>0 for d in ds),'primary_adjacent_total':len(ds)}
  extremes=[]
  for missing in allmissing:
   diffs={p:f(lookup[(mech,5,missing,'deletion',p)],'se_mean')-f(lookup[(mech,2,missing,'deletion',p)],'se_mean') for p in ['A','C','E']};extremes.append({'missing':missing,'signed_deletion_SE_q5_minus_q2':diffs,'E_increase_minus_A_increase':diffs['E']-diffs['A'],'E_increase_minus_C_increase':diffs['E']-diffs['C']})
  v['evidence']={'cells':[snapshot(r) for r in cells],'adjacent_q_contrasts':contrasts,'summary':summary,'component_increase_comparisons':extremes};v['outstanding_scope']='Complete grid descriptive trend assessment is now performed. Relatively constant/slight has no source numerical equivalence criterion; ranges and signed trends do not establish constancy or a negligibility margin. Source SE implementation and2%/3%ambiguity remain.';v['next_action']='Root adjudicate directional descriptive trend separately from unresolved relative-constancy wording; no further fits needed to obtain these point contrasts.'
 elif i=='C6-3.C-versus-A':
  vals=[]
  for missing in allmissing:
   for q in range(2,6):
    A=lookup[('MAR',q,missing,'deletion','A')];C=lookup[('MAR',q,missing,'deletion','C')];a=f(A,'bias');cc=f(C,'bias');vals.append({'q':q,'missing':missing,'scope':'sensitivity' if missing==.03 else 'primary','A_bias':a,'C_bias':cc,'signed_C_bias_minus_A_bias':cc-a,'absolute_C_bias_minus_absolute_A_bias':abs(cc)-abs(a),'relative_absolute_C_bias_minus_relative_absolute_A_bias':abs(cc)/.3-abs(a)/.5})
  v['evidence']={'signed_comparisons':vals,'primary_absolute_C_exceeds_A':sum(x['absolute_C_bias_minus_absolute_A_bias']>0 for x in vals if x['scope']=='primary'),'primary_cells':12};v['outstanding_scope']='Descriptive absolute and truth-relative bias comparisons now computed across every grid cell. New uncertainty for this cross-parameter contrast was not computed; standalone source scientific conclusion remains for root adjudication.';v['next_action']='Review signed absolute and relative comparisons; any later inferential C-versus-A family requires an explicitly declared exploratory analysis with covariance-aware uncertainty.'
 elif '.recovery.' in i or i=='C6-5.beta-recovery':
  if i=='C6-5.beta-recovery':cells=[r for r in cs if r['parameter'].startswith('beta')]
  else:mech,par=i.split('.')[-2:];cells=selected(mech,par)
  diffs=[]
  for r in cells:
   if r['method']!='full':continue
   k=key(r);d=lookup[k[:3]+('deletion',k[4])];diffs.append({'mechanism':k[0],'q':k[1],'missing':k[2],'parameter':k[4],'scope':'sensitivity' if k[2]==.03 else 'primary','signed_deletion_minus_full_estimate':f(d,'estimate_mean')-f(r,'estimate_mean')})
  v['evidence']={'cells':[snapshot(r) for r in cells],'method_contrasts':diffs,'primary_bias_range':[min(f(r,'bias') for r in cells if float(r['missing']) in primary),max(f(r,'bias') for r in cells if float(r['missing']) in primary)],'primary_max_absolute_bias':max(abs(f(r,'bias')) for r in cells if float(r['missing']) in primary)};v['outstanding_scope']='Every available signed bias, RMSE, MCSE and between-method point contrast is now assessed. Close to truth/similar is not an equivalence claim without a justified margin; no zero-not-excluded argument establishes recovery.';v['next_action']='Root review descriptive recovery patterns with units and all conditions; retain unresolved adequacy/equivalence interpretation rather than invent a tolerance.'
 elif i=='C6-5.MNAR.E10':
  cells=[r for r in selected('MNAR','E','full') if float(r['missing'])==.1];vals=[]
  for r in cells:
   mean=f(r,'estimate_mean');vals.append(snapshot(r)|{'distance_to_021_minus_distance_to_020':abs(mean-.21)-abs(mean-.20),'point_nearer_021':abs(mean-.21)<abs(mean-.20)})
  v['evidence']={'cells':vals,'point_nearer_021_count':sum(x['point_nearer_021'] for x in vals),'total':4};v['outstanding_scope']='Literal point-distance comparison now complete. Source gives no per-q numeric outputs or uncertainty; negligible bias is not resolved by this distance calculation.';v['next_action']='Report all four values and distance signs rather than select favorable q; root assess literal source wording with original-procedure uncertainty.'
 else:
  mech=i.rsplit('.',1)[-1] if i.startswith('C6.power-inference.') else None
  rel=[r for r in paired if r['metric']=='se' and float(r['missing']) in primary and (mech is None or r['mechanism']==mech)]
  if i=='C6.recommendation':rel=[r for r in rel if int(r['q'])>2 and float(r['missing'])>.03]
  v['evidence']={'related_precision_contrasts':rel,'related_existing_adjusted_positive':sum(r['adjusted_status']=='positive' for r in rel),'contrast_count':len(rel),'not_a_power_trial':True}
  if i=='C6.zyg-structure':
   v['work_now']='pending';v['descriptive_analysis_complete']=False;v['outstanding_scope']='Existing production uses equal MZ/DZ covariate covariance structures. No unequal-structure sensitivity design or direct power experiment has been executed. Related precision contrasts cannot address the asserted extension.';v['next_action']='Specify bounded unequal-structure designs and a clearly labeled target-specific power or precision assessment; no source benchmark power fractions are supplied.'
  elif i=='C6.recommendation':
   v['outstanding_scope']='All relevant observed precision contrasts for q>2 and missingness>.03 have now been tabulated, but this does not establish a universal policy threshold, a power advantage, robustness to missingness assumptions, or an empirical application outcome.';v['next_action']='Root separate recommendation rationale supported by these precision patterns from unresolved threshold optimality and practical/model-assumption limits.'
  else:
   v['work_now']='pending';v['descriptive_analysis_complete']=False;v['outstanding_scope']='Precision evidence is now explicitly separated from power. No rejection-rate experiment, alternative/test definition or source power fractions exist in the saved outputs; direct power target remains unrun.';v['next_action']='Clarify source scientific interpretation and specify a bounded exploratory power design with nonzero alternatives, tests and error control before any execution. Do not convert SE ordering into measured power.'
 results.append(v)
assert len(results)==26
assert before=={p:sha(p) for p in inputs}
out={'document_kind':'additive_saved_grid_scientific_assessment','created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'inputs_sha256':before,'script_sha256':sha('simulation/assess_chapter6_saved_targets.py'),'scope':'All26v3targets; no fitting, resampling or new statistical tests. Frozen packet and v3 unchanged. Root scientific adjudication pending.','analysis_policy':'All primary conditions retained; .03sensitivity kept separate. Descriptive differences of means/ranges only; existing fixed-family paired intervals reused for precision context. No new confidence intervals or significance claims.','claims':results}
dump('outputs/chapter6-saved-target-assessment.json',out)
print(json.dumps({'targets':len(results),'work_now':{k:sum(x['work_now']==k for x in results) for k in ['attempted-incomplete','pending']},'descriptive_complete':sum(x['descriptive_analysis_complete'] for x in results)},indent=2))
