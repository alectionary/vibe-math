"""Generate complete source/ours threshold tables without replacing original fits."""
import json,pathlib
from analyze_families import R
P=R.parent/'paper'
data=json.loads((R/'threshold-comparisons.json').read_text());rows=data['rows'];get=lambda n,q:next(r for r in rows if r['family']==n and r['quantity']==q)
lines=[r'\begin{tabular}{llrrrrrr}',r'\toprule Code/decoder & Noise & \multicolumn{2}{c}{Source (\%)} & \multicolumn{2}{c}{Ours (\%)} & \multicolumn{2}{c}{$D-U$ (pp)}\\',r' & & U & D & U & D & Source & Ours\\\midrule']
lines += [r'Cubic BP & X & 2.9 & 7.4 & 2.388 & 7.570 & +4.5 & +5.182\\',r'Cubic BP & Z & 21.7 & $>36$ & 21.908 & unresolved & $>14.3$ & unresolved\\']
for name,label,noise in [('cubic-depolarizing','Cubic BP','Dep.'),('sweep-X','Cubic Sweep','X'),('sweep-Z','Cubic Sweep','Z'),('sweep-depolarizing','Cubic Sweep','Dep.'),('rhombic-X-pure','Rhombic BP','X'),('rhombic-Z-pure','Rhombic BP','Z'),('rhombic-depolarizing','Rhombic BP','Dep.')]:
 a,b,c=[get(name,q) for q in ['U','D','D-U']];lines.append(f"{label} & {noise} & {100*a['source']:.1f} & {100*b['source']:.1f} & {100*a['ours']:.3f} & {100*b['ours']:.3f} & {100*c['source']:+.1f} & {100*c['ours']:+.3f}"+r'\\')
lines.append(r'\bottomrule\end{tabular}');(P/'expanded-endpoints.tex').write_text('\n'.join(lines)+'\n')
lines=[r'\begin{longtable}{llrrrrr}',r'\toprule Code/axis & $\eta$ & \multicolumn{2}{c}{Source (\%)} & \multicolumn{2}{c}{Ours (\%)} & $D-U$: source/ours (pp)\\',r' & & U & D & U & D & \\\midrule\endhead']
for code in ['cubic','rhombic']:
 for axis in ['X','Z']:
  for eta in [1,3,10,30,100]:
   n=f'{code}-{axis}-eta{eta}';a,b,c=[get(n,q) for q in ['U','D','D-U']];lines.append(f"{code.title()} {axis} & {eta} & {100*a['source']:.2f} & {100*b['source']:.2f} & {100*a['ours']:.2f} & {100*b['ours']:.2f} & {100*c['source']:+.2f}/{100*c['ours']:+.2f}"+r'\\')
lines.append(r'\bottomrule\end{longtable}');(P/'expanded-bias.tex').write_text('\n'.join(lines)+'\n')
lines=[r'\begin{longtable}{llrrl}',r'\toprule Family & Arm & Ours $-$ source (pp) & Conditional band (pp) & Rounding\\\midrule\endhead']
for row in rows:
 if '-eta' in row['family'] or row['quantity']=='D-U':continue
 band=row['conditional_band']['adjusted_endpoints'];name=row['family'].replace('depolarizing','dep.').replace('-pure','').replace('-',' ')
 lines.append(f"{name} & {row['quantity']} & {100*row['deviation_ours_minus_source']:+.3f} & [{100*band[0]:+.2f}, {100*band[1]:+.2f}] & {row['numerical']}"+r'\\')
lines.append(r'\bottomrule\end{longtable}');(P/'expanded-deviations.tex').write_text('\n'.join(lines)+'\n')
