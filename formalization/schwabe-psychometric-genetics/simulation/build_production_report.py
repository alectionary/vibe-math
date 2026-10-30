"""Build separate LaTeX artifacts from a frozen guarded-analysis directory; no fits.
CLI: python3 simulation/build_production_report.py --analysis-dir DIR --output-dir paper
Use a temporary output directory for fixtures. Existing generated files are refused.
"""
import argparse, csv, hashlib, json, math, pathlib

FILES = ('summary.json', 'condition-summary.csv', 'signed-SE-contrasts.csv',
         'source-comparisons.csv', 'signed-bias-contrasts.csv', 'provenance.json')

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def number(x):
    if x is None or x == '':
        return 'NA'
    value = float(x)
    if not math.isfinite(value):
        raise ValueError('Nonfinite report number')
    return format(value, '.10g')

def escape(x):
    return ''.join({'&':r'\&', '%':r'\%', '_':r'\_', '#':r'\#', '$':r'\$',
                    '{':r'\{', '}':r'\}', '\\':r'\textbackslash{}'}.get(c,c) for c in str(x))

def table(headers, rows, widths):
    return '\n'.join([r'\begin{longtable}{'+''.join('p{'+x+'}' for x in widths)+'}',
        r'\toprule', ' & '.join(headers)+r'\\\midrule\endhead']+
        [' & '.join(escape(v) for v in row)+r'\\' for row in rows]+
        [r'\bottomrule\end{longtable}', ''])

def build(analysis, out):
    analysis, out = pathlib.Path(analysis).resolve(), pathlib.Path(out).resolve()
    if analysis == out:
        raise ValueError('Output must be separate from analysis')
    hashes = {name:sha(analysis/name) for name in FILES}
    summary = json.loads((analysis/'summary.json').read_text())
    provenance = json.loads((analysis/'provenance.json').read_text())
    def read(name):
        with (analysis/name).open() as f:
            return list(csv.DictReader(f))
    conditions, contrasts, comparisons, biases = [read(n) for n in FILES[1:5]]
    if tuple(map(len,(conditions,contrasts,comparisons,biases))) != (720,288,504,72):
        raise ValueError('Incomplete frozen-analysis inventory')
    # Validate exact keys before selecting examples or counting reversals.
    grid=[(mech,q,miss) for mech in ('MCAR','MAR','MNAR')
          for q in range(2,6) for miss in (.02,.03,.06,.1)]
    methods=('full','deletion')
    def canonical(r, extra):
        return (r['mechanism'],int(r['q']),float(r['missing']))+tuple(r[k] for k in extra)
    def inventory(rows, extra, expected):
        keys=[canonical(r,extra) for r in rows]
        if len(set(keys))!=len(keys) or set(keys)!=expected:
            raise ValueError('Duplicate or noncanonical inventory: '+str(extra))
    inventory(conditions,('method','parameter'),
        {c+(m,param) for c in grid for m in methods for param in
         ['A','C','E','h2']+['beta'+str(i) for i in range(1,c[1]+1)]})
    inventory(contrasts,('parameter','metric'),
        {c+(param,metric) for c in grid for param in ('A','C','E') for metric in ('se','path_se')})
    source_se={c+(m,param,metric) for c in grid if c[2]!=.03 for m in methods
               for param in ('A','C','E') for metric in ('se','path_se')}
    source_est={c+(m,param,'estimate') for c in grid if c[0]=='MAR' and c[2]!=.03
                for m in methods for param in ('A','C','h2')}
    inventory(comparisons,('method','parameter','metric'),source_se|source_est)
    inventory(biases,('method','parameter'),{k[:-1] for k in source_est})
    for rows,expected in [(contrasts,lambda r:36 if float(r['missing'])==.03 else 108),
                          (comparisons,lambda r:72 if r['metric']=='estimate' else 216),
                          (biases,lambda r:72)]:
        for r in rows:
            if int(r['family_size'])!=expected(r) or float(r['alpha'])!=.05:
                raise ValueError('Incorrect uncertainty family')
    def numeric(r,key):
        if r[key]=='': return None
        value=float(r[key])
        if not math.isfinite(value): raise ValueError('Nonfinite table value')
        return value
    def flag(r,key):
        if r[key] not in ('True','False',''): raise ValueError('Invalid flag')
        return {'True':True,'False':False,'':None}[r[key]]
    for rows,ours,source in [(contrasts,'contrast_delete_minus_full','source_deletion_minus_full'),
                              (biases,'ours_bias_estimate_minus_truth','source_bias_estimate_minus_truth')]:
        for r in rows:
            a,b=numeric(r,ours),numeric(r,source)
            reversal=a*b<0 if a is not None and b is not None else None
            if flag(r,'point_sign_reversal')!=reversal:
                raise ValueError('Reversal flag inconsistent with signed values')
    for r in contrasts:
        lo,hi=numeric(r,'adjusted_low'),numeric(r,'adjusted_high')
        status='positive' if lo is not None and lo>0 else 'negative' if hi is not None and hi<0 else 'not separated' if lo is not None else 'not estimable'
        if r['adjusted_status']!=status: raise ValueError('Adjusted status mismatch')
    for r in comparisons:
        delta,half=numeric(r,'ours_minus_source'),numeric(r,'conditional_halfwidth')
        status='inside' if half is not None and delta is not None and abs(delta)<=half else 'outside' if half is not None else 'not estimable'
        if r['conditional_status']!=status: raise ValueError('Source status mismatch')
    crosschecks={
      'source_variance_SE_outside':sum(r['metric']=='se' and r['conditional_status']=='outside' for r in comparisons),
      'source_path_SE_outside':sum(r['metric']=='path_se' and r['conditional_status']=='outside' for r in comparisons),
      'primary_variance_SE_positive_points':sum(r['metric']=='se' and float(r['missing'])!=.03 and numeric(r,'contrast_delete_minus_full') is not None and numeric(r,'contrast_delete_minus_full')>0 for r in contrasts),
      'primary_variance_SE_adjusted_positive':sum(r['metric']=='se' and float(r['missing'])!=.03 and r['adjusted_status']=='positive' for r in contrasts),
      'MAR_bias_point_reversals':sum(flag(r,'point_sign_reversal') is True for r in biases),
      'MAR_bias_reversals_with_adjusted_ours_excluding_zero':sum(flag(r,'point_sign_reversal') is True and numeric(r,'adjusted_low') is not None and (numeric(r,'adjusted_low')>0 or numeric(r,'adjusted_high')<0) for r in biases)}
    if any(summary[k]!=v for k,v in crosschecks.items()):
        raise ValueError('Summary contrast/outside/reversal count mismatch')
    def one(rows, **keys):
        found=[r for r in rows if all(str(r[k])==str(v) for k,v in keys.items())]
        if len(found)!=1: raise ValueError('Nonunique representative cell: '+str(keys))
        return found[0]
    var=one(comparisons,mechanism='MCAR',q=2,missing=.02,method='full',parameter='A',metric='se')
    path=one(comparisons,mechanism='MCAR',q=2,missing=.02,method='full',parameter='A',metric='path_se')
    h=one(comparisons,mechanism='MAR',q=5,missing=.1,method='deletion',parameter='h2',metric='estimate')
    hb=one(biases,mechanism='MAR',q=5,missing=.1,method='deletion',parameter='h2')
    cells={}
    denoms=('target','requested','completed','guard_valid','guard_invalid','process_failed','in_flight_or_uncheckpointed','not_yet_requested')
    for r in conditions:
        key=tuple(r[k] for k in ('mechanism','q','missing','method'))
        values=tuple(int(r[k]) for k in denoms)
        target,requested,completed,valid,invalid,failed,pending,unrequested=values
        if min(values)<0 or target!=1000 or completed!=valid+invalid or requested!=completed+failed+pending or target!=requested+unrequested:
            raise ValueError('Invalid denominator arithmetic')
        if key in cells and cells[key]!=values: raise ValueError('Inconsistent parameter denominators')
        cells[key]=values
    if len(cells)!=96: raise ValueError('Missing condition-method cells')
    for field, summary_key in [('target','target_method_fits'),('requested','requested_method_fits'),('completed','completed_method_fits'),('guard_valid','guard_valid_method_fits'),('guard_invalid','guard_invalid_method_fits'),('process_failed','process_failed_method_slots'),('in_flight_or_uncheckpointed','in_flight_or_uncheckpointed_method_slots'),('not_yet_requested','not_yet_requested_method_slots')]:
        if sum(v[denoms.index(field)] for v in cells.values()) != summary[summary_key]:
            raise ValueError('Summary/denominator mismatch: '+field)
    for r in comparisons+biases:
        key=tuple(r[k] for k in ('mechanism','q','missing','method'))
        if tuple(int(r[k]) for k in denoms)!=cells[key]:
            raise ValueError('Comparison/bias denominator mismatch')
    for r in contrasts:
        key=tuple(r[k] for k in ('mechanism','q','missing'))
        full,dele=(cells[key+(m,)] for m in methods)
        vals=[int(r[k]) for k in ('target_pairs','requested_pairs','valid_pairs','excluded_or_pending_pairs','not_yet_requested_pairs','full_valid','deletion_valid')]
        target,requested,valid,excluded,unrequested,fv,dv=vals
        if min(vals)<0 or target!=1000 or requested!=full[1] or requested!=dele[1] or valid+excluded!=requested or requested+unrequested!=target or fv!=full[3] or dv!=dele[3] or valid>min(fv,dv):
            raise ValueError('Invalid paired denominator arithmetic')
    if summary['complete_attempted_grid']!=(summary['completed_method_fits']==96000) or summary['all_fits_guard_valid']!=(summary['guard_valid_method_fits']==96000):
        raise ValueError('Grid completion flag mismatch')
    if min(summary['guarded_baseline_replay_datasets'],summary['new_completed_datasets'])<0 or 2*(summary['guarded_baseline_replay_datasets']+summary['new_completed_datasets'])!=summary['completed_method_fits']:
        raise ValueError('Replay/new dataset denominator mismatch')
    mapping={'TargetFits':'target_method_fits','RequestedFits':'requested_method_fits','CompletedFits':'completed_method_fits',
      'ValidFits':'guard_valid_method_fits','InvalidFits':'guard_invalid_method_fits','FailedSlots':'process_failed_method_slots',
      'PendingSlots':'in_flight_or_uncheckpointed_method_slots','NotRequestedSlots':'not_yet_requested_method_slots',
      'BaselineReplayDatasets':'guarded_baseline_replay_datasets','NewDatasets':'new_completed_datasets',
      'VarianceOutside':'source_variance_SE_outside','PathOutside':'source_path_SE_outside',
      'PositivePoints':'primary_variance_SE_positive_points','PositiveBands':'primary_variance_SE_adjusted_positive',
      'BiasReversals':'MAR_bias_point_reversals','AdjustedBiasReversals':'MAR_bias_reversals_with_adjusted_ours_excluding_zero'}
    macros={k:str(summary[v]) for k,v in mapping.items()}
    macros.update(TargetRep='1000', ConditionMethods='96', ParameterGroups='720', PrimaryContrastCount='108', SensitivityContrastCount='36', SourceComparisons='504', BiasCells='72')
    for field, label in [('requested','Requested'),('completed','Completed'),('guard_valid','Valid')]:
        vals=[v[denoms.index(field)] for v in cells.values()]
        macros[label+'MinRep'], macros[label+'MaxRep']=str(min(vals)),str(max(vals))
    for row, prefix, fields in [(var,'Avariance',('source','ours','mcse','source_extraction_bound','two_se_low','two_se_high','conditional_adjusted_low','conditional_adjusted_high')),
             (path,'Apath',('ours','mcse','conditional_adjusted_low','conditional_adjusted_high')),
             (h,'Hestimate',('source','ours','ours_minus_source','mcse','source_extraction_bound','two_se_low','two_se_high','conditional_adjusted_low','conditional_adjusted_high')),
             (hb,'Hbias',('generating_truth','source_bias_estimate_minus_truth','ours_bias_estimate_minus_truth','mcse','two_se_low','two_se_high','adjusted_low','adjusted_high'))]:
        for field in fields: macros[prefix+''.join(x.capitalize() for x in field.split('_'))]=number(row[field])
    def band(r,lo,hi): return '['+number(r[lo])+', '+number(r[hi])+']'
    representative=[]
    for label,r in [('MCAR q2 .02 full A variance SE',var),('MCAR q2 .02 full A path SE (exploratory)',path),('MAR q5 .10 deletion residual heritability',h)]:
        representative.append((label,number(r['source']),number(r['ours']),number(r['ours_minus_source']),band(r,'two_se_low','two_se_high'),band(r,'conditional_adjusted_low','conditional_adjusted_high')))
    reversals=[]
    for r in contrasts:
        if r['point_sign_reversal']=='True':
            reversals.append(('SE '+r['metric']+' '+r['mechanism']+' q'+r['q']+' m'+r['missing']+' '+r['parameter'],number(r['source_deletion_minus_full']),number(r['contrast_delete_minus_full']),band(r,'adjusted_low','adjusted_high'),r['source_sign_robust_to_extraction']))
    for r in biases:
        if r['point_sign_reversal']=='True':
            reversals.append(('Bias MAR q'+r['q']+' m'+r['missing']+' '+r['method']+' '+r['parameter'],number(r['source_bias_estimate_minus_truth']),number(r['ours_bias_estimate_minus_truth']),band(r,'adjusted_low','adjusted_high'),r['source_sign_robust_to_extraction']))
    caveat = ('% Conditional valid-fit summaries only; all denominators retained.\n'
              '% Two-SE and adjusted source bands describe ours-minus-source plus extraction bounds.\n'
              '% Unknown original Monte Carlo uncertainty is omitted; no complete two-sample or rounding verdict.\n'
              '% Path SE is exploratory and not the printed variance-SE estimand.\n'
              '% Bias bands describe ours-minus-truth; point reversals alone are not significant reversals.\n')
    generated={
      'production-results.tex':caveat+'\n'.join('\\newcommand{\\Prod'+k+'}{'+v+'}' for k,v in macros.items())+'\n',
      'production-comparison.tex':caveat+table(['Condition/metric','Source','Ours','Difference','Two-SE band','Adjusted band'],representative,['1.6in','.65in','.65in','.65in','1.1in','1.1in']),
      'production-reversals.tex':caveat+table(['Signed contrast','Source','Ours','Adjusted ours band','Source sign exceeds extraction bound'],reversals or [('No point reversals','--','--','--','--')],['2in','.7in','.7in','1.4in','1in']),
      'production-notes.tex':('All summaries condition on guard-valid fits; denominators include invalid, failed and pending fits. Source-comparison bands are ours-minus-source, with source extraction bounds added. Unknown original Monte Carlo uncertainty is not included: these are not complete two-sample intervals or rounding verdicts. Path SE is an exploratory different estimand from the printed variance SE. Bias intervals describe ours-minus-truth, using residual heritability truth 0.5. Point-sign reversals alone do not establish significant reversals. Adjusted Bonferroni families contain 108 primary and 36 sensitivity SE contrasts separately for each metric, 72 bias contrasts, 216 source comparisons separately for each SE metric, and 72 source-estimate comparisons. Minimum/maximum repetition macros count method fits per condition, not seed-index ranges. The 2 percent primary and 3 percent sensitivity readings remain separate. Whole-dissertation replication remains incomplete.\n'),
      'production-bias-example.tex':table(['MAR q5 .10 deletion h2','Source bias','Ours bias','Two-SE ours band','Adjusted ours band'],[('Truth '+number(hb['generating_truth']),number(hb['source_bias_estimate_minus_truth']),number(hb['ours_bias_estimate_minus_truth']),band(hb,'two_se_low','two_se_high'),band(hb,'adjusted_low','adjusted_high'))],['1.2in','.8in','.8in','1.4in','1.4in']),
      'production-denominators.tex':table(['Condition/method','Requested','Completed','Valid','Invalid','Failed','Pending','Unrequested'],[( '/'.join(k),)+v[1:] for k,v in sorted(cells.items())],['1.5in','.6in','.6in','.5in','.5in','.5in','.6in','.7in'])}
    manifest_name='production-build-provenance.json'
    for name in (*generated,manifest_name):
        if (out/name).exists(): raise ValueError('Refusing to overwrite '+str(out/name))
    out.mkdir(parents=True,exist_ok=True)
    for name,value in generated.items(): (out/name).write_text(value)
    manifest={'analysis_directory':str(analysis),'input_sha256':hashes,'analysis_provenance':provenance,
      'builder_sha256':sha(pathlib.Path(__file__)),'command':['python3','simulation/build_production_report.py','--analysis-dir',str(analysis),'--output-dir',str(out)],
      'representative_input_rows':{'variance':var,'path':path,'heritability':h,'heritability_bias':hb},
      'numeric_macros':macros,'format':'10 significant digits; exact input bytes retained and hashed; display precision is not source precision',
      'output_sha256':{n:sha(out/n) for n in generated},'complete_attempted_grid':summary['complete_attempted_grid'],
      'scope':'Generated tables only; no new fits, convergence or whole-dissertation success certified'}
    (out/manifest_name).write_text(json.dumps(manifest,indent=2)+'\n')
    return manifest

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--analysis-dir',required=True);p.add_argument('--output-dir',default='paper')
    args=p.parse_args();build(args.analysis_dir,args.output_dir)
