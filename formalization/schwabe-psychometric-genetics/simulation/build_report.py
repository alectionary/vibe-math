"""Build manuscript tables/ledgers from saved evidence; no scientific model refits."""
import csv,json,pathlib,collections,re
root=pathlib.Path('.')
def tex(x):
 s=str(x);links={}
 def replace_file(m):
  name=m.group(0);candidates=[pathlib.Path(name)] if pathlib.Path(name).exists() else list(pathlib.Path('.').rglob(name)) if '/' not in name else []
  if len(candidates)!=1:return name
  key='ZZFILE'+str(len(links))+'ZZ';links[key]=r'\artifact{'+candidates[0].as_posix()+'}';return key
 s=re.sub(r'[A-Za-z0-9_./-]+\.(?:csv|json|R|py|pdf|png|txt)(?![A-Za-z])',replace_file,s)
 for a,b in [('\\',r'\textbackslash{}'),('&',r'\&'),('%',r'\%'),('$',r'\$'),('#',r'\#'),('_',r'\_')]:s=s.replace(a,b)
 s=s.replace('×',r'$\times$').replace('−','-')
 for key,value in links.items():s=s.replace(key,value)
 return s
def table(filename,header,rows,widths):
 text=[r'\begin{longtable}{'+''.join('p{'+w+'}'for w in widths)+'}',r'\toprule',' & '.join(header)+r'\\\midrule\endhead']
 text+=[' & '.join(tex(v)for v in row)+r'\\'for row in rows];text+=[r'\bottomrule\end{longtable}'];pathlib.Path('paper/'+filename).write_text('\n'.join(text))
coverage=list(csv.DictReader(open('coverage.csv')))
table('coverage.tex',['Claim and source locator','Current evidence and remaining work'],[(r['id']+'; '+r['kind']+'; '+r['locator']+'. '+r['claim'],r['status']+'. '+r['result']+' Next: '+r['next_action']+' Evidence: '+r['attempt_evidence'])for r in coverage],['2.65in','3.75in'])
comp=json.load(open('provenance/compliance.json'));table('compliance.tex',['Requirement/status','Evidence and justification'],[(r['requirement']+' / '+r['status'],r['evidence']+' '+r.get('justification',''))for r in comp],['1.8in','4.6in'])
avail=json.load(open('provenance/availability.json'));table('availability.tex',['Place/date','Result'],[(r['place']+' / '+r['date_utc'],r['result'])for r in avail],['1.8in','4.6in'])
summary=json.load(open('outputs/summary.json'));conditions=list(csv.DictReader(open('outputs/condition-summary.csv')))
contrasts=list(csv.DictReader(open('outputs/signed-contrasts.csv')));comparisons=list(csv.DictReader(open('outputs/source-comparisons.csv')))
representative=[r for r in comparisons if r['figure']=='6.3'and r['q']=='2'and r['missing']=='0.02'and r['parameter']=='A'and r['method']=='full']
var=next(r for r in representative if r['metric']=='se');path=next(r for r in representative if r['metric']=='path_se')
macros={'Trials':summary['trial_fits'],'MinRep':summary['min_replicates'],'MaxRep':summary['max_replicates'],'VarianceOutside':summary['source_SE_variance_outside'],'PathOutside':summary['source_SE_path_outside'],'PositiveBands':summary['published_grid_simultaneously_positive_variance_SE_contrasts'],'SourceAse':f"{float(var['source']):.5f}",'OursAse':f"{float(var['ours']):.5f}",'PathAse':f"{float(path['ours']):.5f}",'CostDays':f"{json.load(open('outputs/resource-projection.json'))['projected_single_worker_days_for_N8000_condition_sampling_only']:.0f}"}
pathlib.Path('paper/results.tex').write_text('\n'.join('\\newcommand{\\'+k+'}{'+str(v)+'}'for k,v in macros.items()))
reversal=[r for r in contrasts if r['metric']=='se'and r['same_point_sign']=='False'];table('reversals.tex',['Condition','Source / ours contrast','Interpretation'],[(f"{r['mechanism']}, q={r['q']}, missing={r['missing']}, {r['parameter']}",f"{float(r['source_deletion_minus_full']):.6f} / {float(r['contrast_delete_minus_full']):.6f}",'Point reversal only; source uncertainty unknown; ours '+r['band_status'])for r in reversal]or[('All conditions','No point reversal','Both metrics and low-missingness readings retained in signed-contrasts.csv.')],['2in','1.8in','2.5in'])
# Every numerical condition remains in CSV evidence; table is a labelled example, never substituted for grid coverage.
table('comparison.tex',['Claim','Published','Ours','Precision','Numerical','Scope'],[
('Ch6 MCAR,q2,low missing; A variance SE',f"{float(var['source']):.5f}",f"{float(var['ours']):.5f}",'Figure-derived','Not judged','Limited'),
('Same condition, path SE','Metric not stated',f"{float(path['ours']):.5f}",'Figure-derived','Not comparable','Limited'),
('Ch2 floor beta1: sum / IRT','1.05 / .03','1.095 / -.105','.01 in source','Not comparable','Limited; one dataset'),
('Ch2 ceiling beta1, sums','-1.08','-.857','.01 in source','Not comparable','Limited; one dataset'),
('Ch2 symmetric beta1, sums','.03','.100','.01 in source','Not comparable','Limited; one dataset'),
('Ch3 AxE one-SD ratio','1.63','1.6316','.01','match','Limited'),
('Ch3 AxC one-SD ratio','1.85','1.8489','.01','match','Limited'),
('Ch3--6 empirical fitted results','Original tables','Not estimated','Table-specific','No verdict','Unavailable')],['1.7in','.8in','.8in','.75in','.8in','1in'])
