"""Recalculate reporting from preserved counts: three explicit comparison families."""
import csv,json,math
from pathlib import Path
from decimal import Decimal,ROUND_HALF_UP
from statistics import NormalDist
ROOT=Path(__file__).resolve().parents[1]
def display_verdict(source,ours,places=5):
 unit=Decimal(1).scaleb(-places);s=Decimal(str(source)).quantize(unit,rounding=ROUND_HALF_UP);o=Decimal(str(ours))
 if o.quantize(unit,rounding=ROUND_HALF_UP)==s:return 'match'
 return 'close' if abs(o-s)<=unit else 'mismatch'
def source_row(family,code,p,ours,se,source,bound,n):
 delta=ours-source;z=NormalDist().inv_cdf(1-.05/(2*n));a=2*se+bound;b=z*se+bound
 return dict(family=family,family_size=n,code=code,p=p,source=source,ours=ours,difference_ours_minus_source=delta,our_se=se,extraction_bound=bound,source_mc_uncertainty='unknown',two_se_halfwidth=a,adjusted_halfwidth=b,adjusted_z=z,two_se_endpoints=[delta-a,delta+a],adjusted_endpoints=[delta-b,delta+b],two_se_status='inside' if abs(delta)<=a else 'outside',adjusted_status='inside' if abs(delta)<=b else 'outside',numerical=display_verdict(source,ours),numerical_criterion='display-rounding-5dp-one-unit',precision='5 display decimals; not source measurement precision',scope='limited',exploratory_002=abs(delta)<=.02)
def build():
 source=list(csv.DictReader((ROOT/'source/figure_7_14a_vector_values.csv').read_text().splitlines()));counts=json.loads((ROOT/'revision2/confirmation.json').read_text());rows=[];contrasts=[]
 for p in sorted({r['p'] for r in counts}):
  rates={};published={};variances={}
  for code,series in [('b1','bolza'),('q2','honeycomb_4copies')]:
   pairs=[r for r in counts if r['p']==p and r['family']==code];assert len(pairs)==2
   rates[code]=sum((r['failures']/r['shots'] if code=='b1' else 1-(1-r['failures']/r['shots'])**4) for r in pairs)/2
   variances[code]=sum((r['failures']/r['shots'])*(1-r['failures']/r['shots'])/r['shots']*(1 if code=='b1' else (4*(1-r['failures']/r['shots'])**3)**2) for r in pairs)/4
   s=min((r for r in source if r['series']==series),key=lambda r:abs(float(r['physical_error_rate'])-p));published[code]=float(s['logical_block_error_rate']);bound=max(published[code]-float(s['ler_lower']),float(s['ler_upper'])-published[code])
   rows.append(source_row('confirmation_source',code,p,rates[code],math.sqrt(variances[code]),published[code],bound,10))
  effect=rates['b1']-rates['q2'];original=published['b1']-published['q2'];se=math.sqrt(sum(variances.values()));half=NormalDist().inv_cdf(1-.05/10)*se
  contrasts.append(dict(family='reconstructed_contrasts',family_size=5,p=p,definition='Bolza minus four planar copies; positive means higher failure risk for Bolza',source_point_contrast=original,ours_contrast=effect,reversal=original*effect<0,our_se=se,adjusted_halfwidth=half,adjusted_endpoints=[effect-half,effect+half],our_direction='positive' if effect-half>0 else 'negative' if effect+half<0 else 'not separated',source_direction_inference='withheld: original Monte Carlo uncertainty unknown'))
 baseline=[]
 for r in csv.DictReader((ROOT/'results/figure_comparison.csv').read_text().splitlines()):baseline.append(source_row('baseline_source',r['series'],float(r['p']),float(r['ours']),float(r['se']),float(r['source_figure']),float(r['extraction_bound']),32))
 baseline_contrasts=[]
 for p in sorted({r['p'] for r in baseline}):
  pair={r['code']:r for r in baseline if r['p']==p};b,q=pair['bolza'],pair['honeycomb_4copies'];original=b['source']-q['source'];ours=b['ours']-q['ours']
  baseline_contrasts.append(dict(p=p,definition='Bolza minus four planar copies; positive means higher Bolza failure risk',source_point_contrast=original,ours_contrast=ours,reversal=original*ours<0,inference='point estimates only; no additional simultaneous contrast family claimed; source MC unknown'))
 return dict(baseline_contrasts=baseline_contrasts,alpha=.05,approximation='normal/delta method for high-count first-size curves; source MC missing; extraction bounds added conservatively, not Gaussian',families={'baseline_source':32,'confirmation_source':10,'reconstructed_contrasts':5},baseline=baseline,confirmation=rows,contrasts=contrasts)
def table(rows):
 lines=[r'\small\begin{longtable}{llrrrrlll}',r'\toprule Code & $p$ & Source & Ours & $\Delta$ & Band & Status & Display & Scope\\\midrule\endhead']
 for r in rows:
  code='Bolza' if r['code'] in ('b1','bolza') else 'Planar'
  lines.append(f"{code} & {r['p']:.5f} & {r['source']:.5f} & {r['ours']:.5f} & {r['difference_ours_minus_source']:+.5f} & {r['adjusted_halfwidth']:.5f} & {r['adjusted_status']} & {r['numerical']} & limited"+r'\\')
 lines.append(r'\bottomrule\end{longtable}\normalsize')
 return '\n'.join(lines)+'\n'
if __name__=='__main__':
 d=build();(ROOT/'revision3/comparison_decisions.json').write_text(json.dumps(d,indent=2)+'\n')
 for label in ['baseline','confirmation']:(ROOT/f'paper/{label}_decisions.tex').write_text(table(d[label]))
 print(json.dumps(dict(confirmation_adjusted_outside=sum(r['adjusted_status']=='outside' for r in d['confirmation']),baseline_adjusted_outside=sum(r['adjusted_status']=='outside' for r in d['baseline']),reversals=[r['p'] for r in d['contrasts'] if r['reversal']],all_our_contrasts_positive=all(r['adjusted_endpoints'][0]>0 for r in d['contrasts']),low_noise=d['confirmation'][:2]),indent=2))
