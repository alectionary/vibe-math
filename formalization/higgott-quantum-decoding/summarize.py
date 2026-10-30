import csv,json,math
from pathlib import Path
import numpy as np
from scipy.stats import norm
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
ROOT=Path(__file__).parent
rows=[json.loads(p.read_text()) for p in (ROOT/'results').glob('*_n100000.json')]
def group(family,p,s=48):
    found=[r for r in rows if r['family']==family and abs(r['p']-p)<p*1e-5 and r['subrounds']==s]
    assert len(found)==2,(family,p,s,len(found))
    rates=np.array([r['failures']/r['shots'] for r in found]);variances=np.array([v*(1-v)/r['shots'] for v,r in zip(rates,found)])
    controls=np.array([r['no_correction_exact'] for r in found])
    if family[0]!='b':
        variances*=16*(1-rates)**6;rates=1-(1-rates)**4;controls=1-(1-controls)**4
    return dict(rate=float(rates.mean()),se=float(np.sqrt(sum(variances))/2),no_correction=float(controls.mean()),shots=sum(r['shots'] for r in found))

def main():
    z=float(norm.ppf(1-.05/(2*32)));sources=list(csv.DictReader((ROOT/'source'/'figure_7_14a_vector_values.csv').open()));comparisons=[]
    for r in sources:
        p=float(r['physical_error_rate']);g=group('b1' if r['series']=='bolza' else 'q2',p)
        ref=float(r['logical_block_error_rate']);extract=max(float(r['ler_upper'])-ref,ref-float(r['ler_lower']))
        comparisons.append(dict(series=r['series'],p=p,source_figure=ref,ours=g['rate'],se=g['se'],two_se_band=2*g['se'],bonferroni_band=z*g['se'],extraction_bound=extract,difference=g['rate']-ref,
            conditional_exceedance=abs(g['rate']-ref)>z*g['se']+extract,exploratory_002_margin=abs(g['rate']-ref)<=.02,scope='limited'))
    with (ROOT/'results'/'figure_comparison.csv').open('w') as f:
        w=csv.DictWriter(f,fieldnames=list(comparisons[0]));w.writeheader();w.writerows(comparisons)
    secondary=[]
    for s in [48,96]:
        for p in [.001,.002,.005,.01,.02]:
            for family in ['b1','b2','p2','p3','p4','q2','q3','q4']:
                # The primary grid contains .001, but .002 etc are distinct requested points.
                try:g=group(family,p,s)
                except AssertionError:continue
                secondary.append(dict(family=family,p=p,subrounds=s,**g))
    (ROOT/'results'/'aggregated_rates.json').write_text(json.dumps(secondary,indent=2)+'\n')
    differences=[]
    for i in range(16):
        p=10**(-3+i/10);a=group('b1',p);b=group('q2',p)
        differences.append({'p':p,'difference':a['rate']-b['rate'],'simultaneous_halfwidth':z*math.hypot(a['se'],b['se'])})
    summary={'conditions':len(rows),'shots':sum(r['shots'] for r in rows),'bonferroni_z':z,'comparison_count':len(comparisons),
        'conditional_exceedances':sum(r['conditional_exceedance'] for r in comparisons),'max_figure_gap':max(abs(r['difference']) for r in comparisons),
        'cells_outside_002_margin':sum(not r['exploratory_002_margin'] for r in comparisons),'code_differences':differences,
        'max_code_gap':max(abs(r['difference']) for r in differences),'max_code_gap_plus_halfwidth':max(abs(r['difference'])+r['simultaneous_halfwidth'] for r in differences),
        'headline_p001':{f:group(f,.001) for f in ['b1','q2','p2','b2','q3','q4']}}
    (ROOT/'results'/'summary.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(summary,indent=2))
    (ROOT/'paper').mkdir(exist_ok=True)
    fig,axes=plt.subplots(1,2,figsize=(10,4))
    for series,family,color in [('bolza','b1','firebrick'),('honeycomb_4copies','q2','navy')]:
        rr=[r for r in comparisons if r['series']==series];x=[r['p'] for r in rr]
        axes[0].plot(x,[r['source_figure'] for r in rr],'o',mfc='none',color=color,label=f'{"Bolza" if series=="bolza" else "Four planar copies"}: source figure')
        axes[0].plot(x,[r['ours'] for r in rr],'-',color=color,label=f'{"Bolza" if series=="bolza" else "Four planar copies"}: reconstruction')
        axes[1].errorbar(x,[r['difference'] for r in rr],yerr=[r['bonferroni_band'] for r in rr],fmt='.-',color=color,label=series)
    axes[0].set(xscale='log',yscale='log',xlabel='Physical error probability',ylabel='Four-qubit block failure probability')
    axes[0].legend(fontsize=7);axes[1].set(xscale='log',xlabel='Physical error probability',ylabel='Reconstruction minus source figure')
    axes[1].axhline(0,color='grey',lw=.6);axes[1].axhline(.02,color='grey',ls=':');axes[1].axhline(-.02,color='grey',ls=':')
    for ax in axes:ax.grid(alpha=.15)
    fig.tight_layout();fig.savefig(ROOT/'paper'/'figure_7_14a_replication.pdf');fig.savefig(ROOT/'paper'/'figure_7_14a_replication.png',dpi=180)

if __name__=='__main__':main()
