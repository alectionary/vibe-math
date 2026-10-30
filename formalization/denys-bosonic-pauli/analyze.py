"""Compare saved results; deterministic bounds, never rounding claims or p-values."""
from pathlib import Path
import json,sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
ROOT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT.parents[1]/'.agents/skills/replication-paper/scripts'))
from contrast_checks import contrast,validate_inventory,validate_contrast_coverage
read=lambda p:json.loads((ROOT/p).read_text())
s=read('source-evidence/source_values.json')['selected_rows'];p=read('outputs/primary.json')
names={'equal':'equal_phase','imaginary':'imaginary_phase','extended':'extended_pauli'}
rows=[]
for r in p:
 t=next(x for x in s if x['code']==names[r['case']] and abs(x['alpha']-r['alpha'])<1e-12)
 lo,hi=1-r['fidelity_upper'],1-r['fidelity_lower']
 rows.append(dict(case=r['case'],alpha=r['alpha'],source=t['infidelity'],ours=r['infidelity'],ours_minus_source=r['infidelity']-t['infidelity'],source_extraction_low=t['extraction_low'],source_extraction_high=t['extraction_high'],ours_numerical_low=lo,ours_numerical_high=hi,inside_extraction_envelope=t['extraction_low']<=r['infidelity']<=t['extraction_high'],numerical='withheld',precision='No per-point printed precision',scope='limited',reason='Figure reconstruction; original solver/data unavailable.'))
contrasts=[]
declared_alphas=[.1+2.4*k/49 for k in [8,17,29,39]]
expected=[(name,f'{alpha:.15g}') for alpha in declared_alphas for name in ['phase_gain','group_penalty','equal_vs_dual_rail','imaginary_vs_dual_rail','extended_vs_dual_rail']]
assert len(rows)==12 and {(r['case'],r['alpha']) for r in rows}=={(c,a) for c in names for a in declared_alphas}
for alpha in sorted(set(r['alpha'] for r in rows)):
 d={r['case']:r for r in rows if r['alpha']==alpha}
 for name,left,right,definition in [('phase_gain','equal','imaginary','equal minus imaginary infidelity; positive favors imaginary phase'),('group_penalty','extended','imaginary','extended minus imaginary infidelity; positive disfavors enlargement')]+[(c+'_vs_dual_rail',c,None,'code minus dual-rail infidelity; positive disfavors code') for c in names]:
  a=d[left];b=d[right] if right else dict(source=.0075,ours=.0075,source_extraction_low=.0075,source_extraction_high=.0075,ours_numerical_low=.0075,ours_numerical_high=.0075)
  src=a['source']-b['source'];our=a['ours']-b['ours'];condition=f'{alpha:.15g}'
  contrasts.append(dict(analysis=name,condition=condition,role='headline' if right else 'supporting',claim=name,kind='contrast',source_contrast=src,ours_contrast=our,source_extraction_interval=[a['source_extraction_low']-b['source_extraction_high'],a['source_extraction_high']-b['source_extraction_low']],ours_numerical_interval=[a['ours_numerical_low']-b['ours_numerical_high'],a['ours_numerical_high']-b['ours_numerical_low']],numerical='withheld',scope='limited',uncertainty_decision='Deterministic extraction and floating-point optimization only; original solver uncertainty unknown',**contrast(src,our,definition)))
errors=validate_inventory(contrasts)+validate_contrast_coverage(contrasts,expected)
assert not errors,errors
(ROOT/'outputs/comparison.json').write_text(json.dumps(rows,indent=2)+'\n')
(ROOT/'outputs/contrasts.json').write_text(json.dumps(contrasts,indent=2)+'\n')
(ROOT/'outputs/coverage.json').write_text(json.dumps(dict(expected_conditions=expected,actual_count=len(contrasts),errors=errors,families=[dict(name='source values',size=12),dict(name='headline contrasts',size=8),dict(name='supporting contrasts',size=12)],alpha=None,correction='not applicable: deterministic calculations, no sampling inference'),indent=2)+'\n')
with (ROOT/'paper/comparison_rows.tex').open('w') as f:
 for r in rows:
  label={'equal':'Equal','imaginary':'Imaginary','extended':'Extended'}[r['case']]
  f.write(f"{r['alpha']:.3f} / {label} & {r['source']:.9f} & {r['ours']:.9f} & {r['ours_minus_source']:+.2e} & {'inside' if r['inside_extraction_envelope'] else 'outside'} \\\\\n")
with (ROOT/'paper/contrast_rows.tex').open('w') as f:
 for r in contrasts:
  if r['role']=='headline':f.write(f"{float(r['condition']):.3f} / {'Phase gain' if r['analysis']=='phase_gain' else 'Group penalty'} & {r['source_contrast']:+.7f} & {r['ours_contrast']:+.7f} & {'Yes' if not r['point_reversal'] else 'No'} \\\\\n")
for name in ['comparison', 'contrast']:
 q=ROOT/'paper'/f'{name}_rows.tex';q.write_text(q.read_text()+'\\bottomrule\n')
plt.rcParams.update({'font.size':10,'pdf.fonttype':42,'ps.fonttype':42})
fig,ax=plt.subplots(figsize=(6.8,3.1))
for case,color in [('equal','tab:blue'),('imaginary','tab:orange'),('extended','tab:green')]:
 rr=[r for r in rows if r['case']==case]
 ax.plot([r['alpha'] for r in rr],[r['ours'] for r in rr],'-o',color=color,label=case.capitalize()+' (ours)',ms=4)
 ax.plot([r['alpha'] for r in rr],[r['source'] for r in rr],'x',color='black',ms=6)
ax.axhline(.0075,color='gray',ls=':',label='Dual rail')
ax.set(yscale='log',xlabel=r'Seed amplitude $\alpha$',ylabel='Entanglement infidelity')
ax.legend(ncol=2,fontsize=8);fig.tight_layout();fig.savefig(ROOT/'paper/selected_performance.pdf',metadata={'CreationDate':None})
print(json.dumps(dict(inside=sum(r['inside_extraction_envelope'] for r in rows),total=len(rows),reversals=sum(r['point_reversal'] for r in contrasts),errors=errors)))
