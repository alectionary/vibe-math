"""Read vector drawing coordinates only; no research source execution."""
import fitz,numpy as np,csv,json,hashlib,pathlib,math,argparse
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--thesis',type=pathlib.Path,required=True,help='Downloaded UCL thesis PDF')
parser.add_argument('--panel',type=pathlib.Path,required=True,help='figures/bolza_l1_vs_planar_honeycomb_em3.pdf from arXiv v1 source')
parser.add_argument('--archive',type=pathlib.Path,required=True,help='Original arXiv 2308.03750v1 source archive')
parser.add_argument('--output-dir',type=pathlib.Path,required=True,help='Directory for regenerated CSV and metadata')
args=parser.parse_args()
for path,expected in [(args.thesis,'3b5106e86960fc3516727b2eef22107f901dd77654bf709cf2cda3f855b236bb'),(args.panel,'ad14c209bb03f0ee678d3c97b765d1c76de43832824c7f4a6cba15b53570479a'),(args.archive,'5b3431de3cfe4e24667590742e4af3c221bdcba3c2cef03670513d5935ae6e30')]:
 if hashlib.sha256(path.read_bytes()).hexdigest()!=expected:
  parser.error(f'Source SHA256 mismatch: {path}; refusing to silently use a different version')
P=args.output_dir
P.mkdir(parents=True,exist_ok=True)
src=fitz.open(args.panel)[0];th=fitz.open(args.thesis)[177]
def marks(p,sel=lambda r:True):
 d={}
 for name,color in [('honeycomb_4copies',(0.1,0.1,1.)),('bolza',(0.9,0.,0.))]:
  a=[]
  for x in p.get_drawings():
   if x['fill'] and len(x['items'])==8 and max(abs(u-v) for u,v in zip(x['fill'],color))<1e-6 and sel(x['rect']):
    r=x['rect'];a.append([(r.x0+r.x1)/2,(r.y0+r.y1)/2])
  d[name]=np.array(a[:16])
 return d
s=marks(src); t=marks(th,lambda r:r.x1<315 and r.y0<230)
a=np.concatenate(list(s.values()));b=np.concatenate(list(t.values()));M=np.linalg.lstsq(np.c_[a,np.ones(len(a))],b,rcond=None)[0];res=np.max(np.abs(np.c_[a,np.ones(len(a))]@M-b))
x0=85.50460052490234;x1=301.94097900390625;y1=12.301422119140625;y02=206.93423461914062
yscale=(y02-y1)/math.log10(5);delta=.05
rows=[]
for name,a in s.items():
 for i,(x,y) in enumerate(a):
  px=10**(-3+(x-x0)/(x1-x0));py=10**((y1-y)/yscale)
  rows.append(dict(series=name,index=i,physical_error_rate=px,logical_block_error_rate=py,figure_x_points=x,figure_y_points=y,p_lower=px*10**(-delta/(x1-x0)),p_upper=px*10**(delta/(x1-x0)),ler_lower=py*10**(-delta/yscale),ler_upper=py*10**(delta/yscale)))
with (P/'figure_7_14a_vector_points.csv').open('w') as f:
 w=csv.DictWriter(f,fieldnames=rows[0].keys());w.writeheader();w.writerows(rows)
meta=dict(method='Vector circle bounding-box centers; first16 markers percolor; legend markers excluded by drawingorder. Log-log axis inversion.',figure_source='https://arxiv.org/src/2308.03750v1',record='https://arxiv.org/abs/2308.03750v1',source_archive_sha256=hashlib.sha256(args.archive.read_bytes()).hexdigest(),panel_sha256=hashlib.sha256(args.panel.read_bytes()).hexdigest(),x_axis_anchors_pdf_points=[x0,x1],x_axis_anchor_values=[.001,.01],y_axis_anchors_pdf_points=[y1,y02],y_axis_anchor_values=[1.,.2],coordinate_uncertainty_points=delta,uncertainty_note='Conservative extraction uncertainty only, not source MonteCarlo uncertainty; original counts not available.',thesis_panel_affine_transform=M.tolist(),maximum_marker_alignment_residual_thesis_points=float(res),point_count=len(rows))
(P/'vector_extraction_metadata.json').write_text(json.dumps(meta,indent=2));print(json.dumps(meta,indent=2));print([(r['series'],round(r['physical_error_rate'],6),round(r['logical_block_error_rate'],6)) for r in rows[:3]+rows[16:19]])
