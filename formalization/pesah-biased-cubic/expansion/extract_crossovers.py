"""Extract factual visible polyline vertices from Figs3.4,3.5,3.7,3.8.

Respect PDF clipping. Axis ticks set x calibration; y-axis is .01..1 as
verified from frame and tick spacing (zero curves can lie just outside frame).
"""
import sys,json,pathlib,hashlib
import fitz,numpy as np
path=pathlib.Path(sys.argv[1]);doc=fitz.open(path);records=[]
colors=[(.122,.467,.706),(1.,.498,.055),(.173,.627,.173),(.839,.153,.157)]
for pageno,code,axis in [(49,'cubic','Z'),(51,'cubic','X'),(54,'rhombic','Z'),(55,'rhombic','X')]:
 page=doc[pageno-1];words=page.get_text('words');clips={};curves=[]
 for d in page.get_drawings(extended=True):
  level=d.get('level',0);clips={k:v for k,v in clips.items() if k<level}
  if d['type']=='clip':clips[level]=d['scissor'];continue
  color=tuple(round(x,3) for x in d.get('color',()) or ())
  if color not in colors or d['type']!='s' or len(d['items'])<10 or not all(i[0]=='l' for i in d['items']):continue
  frame=clips[max(clips)];assert frame.width>100 and frame.height>100
  ticks=[]
  for w in words:
   center=(w[0]+w[2])/2
   if frame.x0-5<center<frame.x1+5 and frame.y1<w[1]<frame.y1+12:
    try:ticks.append((center,float(w[4])))
    except ValueError:pass
  assert len(ticks)>=3,(pageno,frame,ticks)
  slope,intercept=np.polyfit([x[0] for x in ticks],[x[1] for x in ticks],1)
  assert max(abs(slope*x+intercept-y) for x,y in ticks)<1e-4
  points=[d['items'][0][1]]+[i[2] for i in d['items']]
  visible=[]
  for point in points:
   if frame.x0-1e-3<=point.x<=frame.x1+1e-3:
    visible.append(dict(p=round(float(slope*point.x+intercept),5),failure=round(float(1-.99*(point.y-frame.y0)/frame.height),6),within_vertical_clip=bool(frame.y0<=point.y<=frame.y1)))
  curves.append(dict(code=code,axis=axis,L=[4,6,8,10][colors.index(color)],frame=list(frame),points=visible))
 assert len(curves)==24,(pageno,len(curves))
 xs=sorted(r['frame'][0] for r in curves);ys=sorted(r['frame'][1] for r in curves);xcenters=[float(np.mean(xs[i:i+8])) for i in [0,8,16]];ycut=float(np.mean(ys))
 for c in curves:
  c.update(page=pageno,deformed=c['frame'][1]>ycut,sector=['total','point','loop'][int(np.argmin([abs(c['frame'][0]-x) for x in xcenters]))]);records.append(c)
out=dict(source_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),curves=records,extraction_bound_failure=.005,extraction_bound_p=.0001,limits='Factual PDF vector coordinates, not original trial data. Only points inside horizontal plot range retained; vertical clipping flags preserved. Error bars not interpreted as counts or known standard errors. Extraction bounds are conservative calibration allowances, not original uncertainty.')
pathlib.Path(sys.argv[2]).write_text(json.dumps(out,indent=2)+'\n');print(len(records),'curves',sum(len(r['points']) for r in records),'points')
