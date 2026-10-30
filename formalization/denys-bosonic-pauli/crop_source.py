"""Render limited research-evidence excerpts at 600 dpi using pdftoppm."""
import subprocess,sys,json,hashlib
from pathlib import Path
pdf=Path(sys.argv[1]);out=Path(sys.argv[2]);out.mkdir(exist_ok=True,parents=True)
# Rectangles in original PDF points: x,y,width,height.
crops=[('figure_3_2',150,(125,60,340,220)),('pauli_states_eq_3_57_61',149,(55,150,485,285)),('pure_loss_eq_3_64',151,(55,60,485,200)),('group_construction_eq_3_2',140,(55,55,485,300)),('bosonic_representation_eq_3_10',142,(55,95,485,175))]
records=[]
for name,page,rect in crops:
 coords=[round(v*600/72) for v in rect]
 cmd=['pdftoppm','-f',str(page),'-l',str(page),'-singlefile','-r','600','-png','-x',str(coords[0]),'-y',str(coords[1]),'-W',str(coords[2]),'-H',str(coords[3]),str(pdf),str(out/name)]
 subprocess.run(cmd,check=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 f=out/(name+'.png');records.append(dict(filename=f.name,pdf_page=page,rect_pdf_points=rect,dpi=600,sha256=hashlib.sha256(f.read_bytes()).hexdigest(),command=cmd))
(out/'crop_manifest.json').write_text(json.dumps(dict(source_sha256=hashlib.sha256(pdf.read_bytes()).hexdigest(),crops=records),indent=2)+'\n')
