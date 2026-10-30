"""Recover factual curve coordinates from original vector PDF, not source data.

Calibration uses rendered axis ticks. Figure-derived precision is not original
measurement precision. Five finite-bias segments and the infinity endpoint are
kept distinct; source methods/plot x-coordinate discrepancy is preserved.
"""
import json,sys,pathlib,hashlib
import fitz
source=pathlib.Path(sys.argv[1]);doc=fitz.open(source);records=[]
for page_no,code in [(52,'cubic'),(56,'rhombic')]:
 page=doc[page_no-1];draw=page.get_drawings()
 # Plot bounding vertical spines are black single vertical segments >100pt.
 spines=[d for d in draw if d['color']==(0.,0.,0.) and len(d['items'])==1 and d['items'][0][0]=='l' and abs(d['rect'].width)<1e-4 and d['rect'].height>100]
 assert len(spines)==2
 top=spines[0]['rect'].y0;bottom=spines[0]['rect'].y1
 curves=[d for d in draw if d['color'] and d['type']=='s' and len(d['items'])==5 and all(x[0]=='l' for x in d['items'])]
 assert len(curves)==4
 for d in curves:
  points=[d['items'][0][1]]+[x[2] for x in d['items']];x0,x1=points[0].x,points[1].x
  axis=('X' if code=='cubic' else 'Z') if d['color'][0]>.5 else ('Z' if code=='cubic' else 'X');deformed=d['dashes']=='[] 0'
  extra=[e for e in draw if e['color']==d['color'] and e['type']=='s' and len(e['items'])==1 and e['items'][0][0]=='l' and abs(e['items'][0][1].x-points[-1].x)<1e-4 and abs(e['items'][0][1].y-points[-1].y)<1e-4];assert len(extra)==1
  for j,point in enumerate(points+[extra[0]['items'][0][2]]):
   eta=.5*2**((point.x-x0)/(x1-x0)) if j<6 else None
   value=.5*(bottom-point.y)/(bottom-top)
   records.append(dict(code=code,axis=axis,deformed=deformed,bias_from_vector=eta,bias_label='inf' if j==6 else ('0.5' if j==0 else str(round(eta))),threshold=value,page=page_no,pdf_point=list(point),extraction_bound_probability=.001,note='Conservative 0.1 percentage-point extraction allowance, not Monte Carlo error or original rounding precision.'))
result=dict(source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),records=records,method='PyMuPDF vector polyline vertices; linear y calibration 0 to .5 and logarithmic x calibration .5 to1. Manual rendered-page legend/axis review required.',discrepancies=['Third finite bias is approximately 3 by plotted logarithmic coordinate, whereas Section3.3 says5. Retain both as explicit alternatives.','Figure3.6 cubic Z undeformed infinity label .210 differs from Table3.1 .217.','Figure3.9 depolarizing deformed label .016 differs from Table3.2 .017.'])
pathlib.Path(sys.argv[2]).write_text(json.dumps(result,indent=2)+'\n')
for r in records:print(r['code'],r['axis'],r['deformed'],r['bias_label'],round(r['threshold']*100,3))
