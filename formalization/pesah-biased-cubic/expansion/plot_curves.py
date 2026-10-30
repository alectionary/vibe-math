"""All source curve families, source/fresh distinguished without hidden panels."""
import json
import matplotlib
matplotlib.use('Agg')
matplotlib.rcParams['pdf.fonttype']=42
import matplotlib.pyplot as plt
from analyze_families import R,combine
out=R.parent/'paper/figures';src=json.loads((R/'source-crossovers.json').read_text())['curves'];colors={4:'#0072B2',6:'#D55E00',8:'#009E73',10:'#CC79A7'}
for code in ['cubic','rhombic']:
 for axis in ['X','Z']:
  data=json.loads((R/f'{code}-{axis}-broad.json').read_text());assert data['complete'];rows=combine(data['rows']);fig,axes=plt.subplots(3,2,figsize=(9,9),sharey=True,constrained_layout=True)
  for i,sector in enumerate(['total','point','loop']):
   for j,d in enumerate([False,True]):
    ax=axes[i,j]
    for L,color in colors.items():
     c=next(c for c in src if (c['code'],c['axis'],c['sector'],c['deformed'],c['L'])==(code,axis,sector,d,L));rr=sorted([r for r in rows if r['L']==L and r['deformed']==d],key=lambda r:r['p']);field=dict(total='failures',point='point_failures',loop='loop_failures')[sector]
     ax.plot([p['p'] for p in c['points']],[max(0,p['failure']) for p in c['points']],color=color,ls='--',lw=1,alpha=.8)
     ax.plot([r['p'] for r in rr],[r[field]/r['shots'] for r in rr],color=color,ls='-',lw=.65,marker='.',ms=2,label=f'L={L}')
    ax.set_ylim(-.02,1.02);ax.grid(alpha=.15);ax.set_title(f'{"Deformed" if d else "Undeformed"}: {sector}');ax.set_xlabel('Physical error probability p');ax.set_ylabel('Failure probability')
  axes[0,0].legend(ncol=2,fontsize=8);fig.suptitle(f'{code.title()}, pure {axis}: solid fresh; dashed source')
  fig.savefig(out/f'expanded-{code}-{axis}-curves.pdf');plt.close(fig)
