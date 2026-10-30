"""Render attributed Table3 crop from externally obtained original Paper I PDF."""
import argparse,hashlib,json,subprocess,tempfile
from pathlib import Path
from PIL import Image
p=argparse.ArgumentParser();p.add_argument('source_pdf');a=p.parse_args()
root=Path('formalization/moss-score-reliability');source=Path(a.source_pdf)
expected='0d4aa07b8fef0df14b47a43412a3356d652afed80e371a4be2712c417a5ad458'
actual=hashlib.sha256(source.read_bytes()).hexdigest()
assert actual==expected,'Wrong source edition; obtain hash-pinned author thesis Paper I'
with tempfile.TemporaryDirectory() as td:
 out=Path(td)/'page'
 subprocess.run(['pdftoppm','-f','18','-l','18','-r','600','-singlefile','-png',str(source),str(out)],check=True)
 image=Image.open(str(out)+'.png')
 box=(66,108,546,282)
 image.crop(tuple(round(v*600/72) for v in box)).save(root/'source-evidence/table_3.png',dpi=(600,600))
record=dict(source_sha256=actual,source_pdf_page=18,printed_page=19,dpi=600,box_pdf_points=box,
 source_url='https://github.com/JonasMoss/phd-thesis/blob/c539b0bc4ab1424352ab93f5aaae5150f02fa9e3/papers/paperI.pdf',
 crop_sha256=hashlib.sha256((root/'source-evidence/table_3.png').read_bytes()).hexdigest())
(root/'source-evidence/crop.json').write_text(json.dumps(record,indent=2)+'\n')
