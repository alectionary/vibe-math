"""Extract Fig 3.2 marker centers. Run: python extract_source.py THESIS.pdf OUTDIR.
No simulation outputs are read. Geometry indices refer to pinned thesis bytes.
"""
import fitz, hashlib, json, sys, itertools
from pathlib import Path
pdf=Path(sys.argv[1]);out=Path(sys.argv[2]);out.mkdir(exist_ok=True,parents=True)
doc=fitz.open(pdf);paths=doc[149].get_drawings()
# Printed axis labels independently inspected in rendered p150.
x0=paths[2]['items'][0][1].x;x25=paths[27]['items'][0][1].x
y3=paths[33]['items'][0][1].y;y2=paths[39]['items'][0][1].y
rows=[];missing={};residuals=[]
for name,start,stop in [('equal_phase',88,138),('imaginary_phase',139,185),('extended_pauli',186,236)]:
 seen=[]
 for j in range(start,stop):
  d=paths[j];assert len(d['items'])==2
  a,b=d['items'][0][1:];v,w=d['items'][1][1:]
  assert abs(a.y-b.y)<1e-6 and abs(v.x-w.x)<1e-6
  x=(a.x+b.x)/2;y=a.y
  observed_alpha=2.5*(x-x0)/(x25-x0)
  index=round((observed_alpha-.1)/2.4*49);seen.append(index)
  exact_alpha=.1+2.4*index/49
  residuals.append(abs(x-(x0+exact_alpha/2.5*(x25-x0))))
  value=10**(-3+(y3-y)/(y3-y2))
  # Deliberately conservative ±0.05 PDF-point extraction perturbation on
  # ordinate and both independently read tick coordinates. NOT source solver error.
  values=[10**(-3+(z3-z)/(z3-z2)) for z,z3,z2 in itertools.product([y-.05,y+.05],[y3-.05,y3+.05],[y2-.05,y2+.05])]
  rows.append(dict(code=name,source_grid_index=index,alpha=exact_alpha,observed_alpha=observed_alpha,infidelity=value,extraction_low=min(values),extraction_high=max(values),pdf_x=x,pdf_y=y,path_index=j))
 missing[name]=sorted(set(range(50))-set(seen))
selected=[r for r in rows if r['source_grid_index'] in [8,17,29,39]]
record=dict(source_sha256=hashlib.sha256(pdf.read_bytes()).hexdigest(),pdf_page_one_based=150,figure='3.2',gamma=.01,axis=dict(x0=x0,x25=x25,y_log10_minus3=y3,y_log10_minus2=y2),uncertainty='Deterministic extraction envelope from ±0.05 PDF points independently on marker y and the two logarithmic tick coordinates. Not statistical, not source optimization uncertainty, not original measurement precision.',max_grid_alignment_error_pdf_points=max(residuals),missing_source_indices=missing,rows=rows,selected_rows=selected)
(out/'source_values.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps({k:v for k,v in record.items() if k!='rows'},indent=2))
