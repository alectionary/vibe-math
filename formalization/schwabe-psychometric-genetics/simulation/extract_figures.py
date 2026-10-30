"""Extract original vector curves from locally held thesis; retain coordinates/audit."""
import fitz,numpy as np,csv,json,sys
pdf=fitz.open(sys.argv[1]);rows=[];audit=[]
for page_no,fig,mechanism,measure,region in [(93,'6.3','MCAR','se',(340,450)),(94,'6.4','MAR','se',(70,160)),(94,'6.5','MAR','estimate',(370,450)),(95,'6.6','MNAR','se',(350,450))]:
 page=pdf[page_no+8];polys=[]
 for i,d in enumerate(page.get_drawings()):
  if len(d['items'])==3 and all(x[0]=='l' for x in d['items']) and d['rect'].width>60 and region[0]<d['rect'].y0<region[1]:polys.append((i,d))
 xs=sorted(set(round(d['rect'].x0,1) for _,d in polys));assert len(xs)==3
 for panel,(x,parameter) in enumerate(zip(xs,['A','C','h2' if measure=='estimate' else 'E'])):
  curves=[(i,d)for i,d in polys if abs(d['rect'].x0-x)<.2];assert len(curves)==6
  ticks=[]
  for w in page.get_text('words'):
   if x-20<w[0]<x-3 and region[0]-10<w[1]<region[1]+10:
    try:v=float(w[4])
    except ValueError:continue
    if 0<v<1:ticks.append(((w[1]+w[3])/2,v))
  assert len(ticks)>=2,(fig,parameter,ticks)
  y,v=np.array(ticks).T;slope,intercept=np.polyfit(y,v,1);res=max(abs(slope*y+intercept-v));assert res<.00002,(fig,parameter,res)
  # Source drawing order is 10%,6%,low for both solid and dashed curves.
  # Low is called 2% in captions/design but 3% on plot: retained as 'low'.
  for (i,d),missing in zip(curves,['.10','.06','low','.10','.06','low']):
   method='full' if d['dashes']!='[] 0' else 'deletion';points=[d['items'][0][1]]+[item[2]for item in d['items']]
   for q,pt in zip(range(2,6),points):rows.append(dict(figure=fig,page=page_no,mechanism=mechanism,measure=measure,parameter=parameter,q=q,missing=missing,method=method,value=float(slope*pt.y+intercept),extraction_bound=abs(slope)*.25,x=pt.x,y=pt.y,drawing=i))
  audit.append(dict(figure=fig,parameter=parameter,ticks=ticks,slope=slope,intercept=intercept,max_tick_residual=res,bound='0.25 PDF point conservatively allowed for axis/line placement; not original Monte Carlo uncertainty'))
with open('outputs/source-figure-values.csv','w') as f:w=csv.DictWriter(f,fieldnames=rows[0]);w.writeheader();w.writerows(rows)
open('provenance/figure-extraction.json','w').write(json.dumps(audit,indent=2))
