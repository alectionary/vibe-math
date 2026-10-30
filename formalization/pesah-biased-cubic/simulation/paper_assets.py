"""Render manuscript values, tables and plots from saved results."""
import json,pathlib,math,re
from statistics import NormalDist
import os,tempfile
os.environ.setdefault('MPLCONFIGDIR',tempfile.mkdtemp(prefix='pesah-mpl-'))
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
ROOT=pathlib.Path(__file__).resolve().parents[1];P=ROOT/'paper'
def esc(s):
 return ''.join({'&':r'\&','%':r'\%','$':r'\$','#':r'\#','_':r'\_','{':r'\{','}':r'\}','~':r'\textasciitilde{}','^':r'\textasciicircum{}','\\':r'\textbackslash{}'}.get(c,c) for c in str(s))
def table_md(name,widths):
 rows=[]
 for line in (ROOT/(name+'.md')).read_text().splitlines():
  if line.startswith('|') and not line.startswith('|---'):rows.append([x.strip() for x in line.strip('|').split('|')])
 # Exact cell text copied; Markdown backticks only mark literal identifiers.
 body='\\begin{longtable}{'+''.join('p{'+w+'\\linewidth}' for w in widths)+'}\n\\toprule\n'
 for i,row in enumerate(rows):
  body+=' & '.join(re.sub(r'([a-f0-9]{40})',lambda m:r'\nolinkurl{'+m[1]+'}',esc(x.replace('`',''))) for x in row)+r'\\'+'\n'
  if i==0:body+='\\midrule\\endhead\n'
 body+='\\bottomrule\n\\end{longtable}\n';(P/(name+'-table.tex')).write_text(body)
def main():
 d=json.loads((ROOT/'results/analysis.json').read_text());primary=json.loads((ROOT/'results/primary.json').read_text());extra=json.loads((ROOT/'results/iterations100.json').read_text());baseline_diag=json.loads((ROOT/'results/diagnostic10.json').read_text());stable=json.loads((ROOT/'results/stable-ties.json').read_text());c=d['comparisons'];z=NormalDist().inv_cdf(1-.05/6)
 macros={'OpeningVerdict':'We partly replicated','ThreshU':f'{100*c[0]["ours"]:.3f}','ThreshD':f'{100*c[1]["ours"]:.3f}','Advantage':f'{100*c[2]["ours"]:.3f}','VerdictU':{'mismatch':'no match'}.get(c[0]['numerical'],c[0]['numerical']),'VerdictD':{'mismatch':'no match'}.get(c[1]['numerical'],c[1]['numerical']),'DeltaInterval':f'[{100*(c[2]["ours"]-z*c[2]["se"]):.3f}, {100*(c[2]["ours"]+z*c[2]["se"]):.3f}]','BootstrapStatus':f'All {d["bootstrap"]["arm_fits"]} arm fits converged; {d["bootstrap"]["boundaries"]} touched a parameter bound.','GeneratorStatus':f'{sum(x["bonferroni_significant"] for x in d["generator_comparisons"])} of 32 cell differences exceeded the Bonferroni-adjusted normal band.','InvalidStatus':f'The primary run recorded {sum(x["invalid"] for x in primary["rows"])} uncorrected-syndrome trials out of {sum(x["shots"] for x in primary["rows"]):,}. All attempted trials remain in the denominators.','RunSeconds':f'{primary["elapsed_seconds"]:.1f}','RunMemory':f'{primary["maxrss_kib"]/1024:.1f}'}
 revpath=ROOT/'reproduction-revision.txt';rev=revpath.read_text().strip() if revpath.exists() else __import__('subprocess').check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip()
 macros['ReproductionRevision']=r'\href{https://github.com/alectionary/vibe-math/tree/'+rev+r'/formalization/pesah-biased-cubic}{\nolinkurl{'+rev+'}}'
 (P/'numbers.tex').write_text('\n'.join('\\newcommand{\\'+k+'}{'+v+'}' for k,v in macros.items())+'\n')
 text=r'''\begin{center}
\begin{tabular}{p{.21\linewidth}rrrrp{.13\linewidth}}
\toprule Quantity & Published & Ours & Deviation & SE & Numerical\\\midrule
'''
 for x,label in zip(c,['Undeformed','Deformed','Difference']):text+=f'{label} & {100*x["source"]:.1f} & {100*x["ours"]:.3f} & {100*x["deviation"]:+.3f} & {100*x["se"]:.3f} & {x["numerical"]}'+r'\\'+'\n'
 text+=r'''\bottomrule\end{tabular}
\end{center}
All entries are percentage points; deviation is ours minus source. Scope is limited for all rows because the production configuration and fit selection are not identified. SE is our conditional bootstrap standard error, not a source SE.
\begin{center}\begin{tabular}{lrrll}
\toprule Quantity & Two-SE band & Adjusted band & Two-SE status & Adjusted status\\\midrule
'''
 for x,label in zip(c,['Undeformed','Deformed','Difference']):
  b=x['band'];text+=f'{label} & {100*b["two_se_halfwidth"]:.3f} & {100*b["adjusted_halfwidth"]:.3f} & {b["two_se_status"]} & {b["adjusted_status"]}'+r'\\'+'\n'
 text+=r'\bottomrule\end{tabular}\end{center}'+'\nBands are half-widths for the deviation, in pp, conditional on unknown source sampling uncertainty; the rounding bound is included. They are neither numerical-rounding verdicts nor equivalence margins.\n';(P/'comparison-table.tex').write_text(text)
 text=r'''\begin{center}\begin{tabular}{lrrr}
\toprule Fit choice & Undeformed (\%) & Deformed (\%) & Difference (pp)\\\midrule
'''
 values=[('Primary least squares',c[0]['ours'],c[1]['ours'])]
 for key,label in [('binomial','Binomial likelihood'),('drop_high_p','Exclude highest p'),('drop_low_p','Exclude lowest p'),('drop_L4','Exclude L=4'),('drop_L10','Exclude L=10')]: values.append((label,d['sensitivity']['False'][key]['threshold'],d['sensitivity']['True'][key]['threshold']))
 for gen in ('numpy','stdlib'):values.append((gen+' generator only',d['sensitivity']['False']['generators'][gen]['threshold'],d['sensitivity']['True']['generators'][gen]['threshold']))
 for label,u,v in values:text+=f'{label} & {100*u:.3f} & {100*v:.3f} & {100*(v-u):+.3f}'+r'\\'+'\n'
 text+=r'\bottomrule\end{tabular}\end{center}'+'\n'+r'''\begin{center}\begin{tabular}{llrrr}
\toprule L & Arm / p & 10 iterations & 100 iterations & Stable ties\\\midrule
'''
 for L in (4,6):
  for deform in (False,True):
   p=.08 if deform else .03
   a=[r for r in baseline_diag['rows'] if r['L']==L and r['deformed']==deform];b=[r for r in extra['rows'] if r['L']==L and r['deformed']==deform];st=[r for r in stable['rows'] if r['L']==L and r['deformed']==deform]
   u=sum(r['failures'] for r in a)/sum(r['shots'] for r in a);v=sum(r['failures'] for r in b)/sum(r['shots'] for r in b)
   text+=f'{L} & '+('Deformed' if deform else 'Undeformed')+f' / {p} & {u:.3f} & {v:.3f} & {sum(r['failures'] for r in st)/sum(r['shots'] for r in st):.3f}'+r'\\'+'\n'
 text+=r'\bottomrule\end{tabular}\end{center}'+'\nIteration entries are logical-failure probabilities, with 500 trials per entry. The three diagnostic columns share error seeds, but differ from main-grid seeds. Stable ties uses ten iterations with stable reliability sorting. These are exploratory finite-point checks, not threshold estimates or significance claims.\n';(P/'sensitivity-table.tex').write_text(text)
 plt.rcParams.update({'font.size':10,'pdf.fonttype':42,'ps.fonttype':42})
 fig,axes=plt.subplots(1,2,figsize=(6.7,2.65))
 for deform,ax in zip((False,True),axes):
  for L,color in zip((4,6,8,10),['#3264a3','#da8b15','#2c8a62','#ae4872']):
   points=[r for r in d['data'] if r['L']==L and r['deformed']==deform];p=np.array([r['p'] for r in points]);y=np.array([r['failures']/r['shots'] for r in points]);n=np.array([r['shots'] for r in points]);ax.errorbar(p*100,y,yerr=2*np.sqrt(y*(1-y)/n),label=f'L={L}',marker='o',markersize=3,linewidth=1,color=color,capsize=2)
  ax.axvline(7.4 if deform else 2.9,color='#555555',linestyle='--',linewidth=.8,label='Published threshold');ax.set_title('Deformed' if deform else 'Undeformed');ax.set_xlabel('Physical X-error probability (%)');ax.set_ylim(0,1);ax.grid(alpha=.15)
 axes[0].set_ylabel('Logical failure probability');axes[1].legend(fontsize=7,loc='upper left');fig.tight_layout();fig.savefig(P/'figures/crossovers.pdf');plt.close(fig)
 table_md('availability',['.21','.12','.59']);table_md('compliance',['.23','.70'])
if __name__=='__main__':main()
