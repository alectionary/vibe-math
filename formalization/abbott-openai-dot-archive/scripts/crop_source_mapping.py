#!/usr/bin/env python3
"""Render source item-selection evidence at 600 dpi; no image alteration beyond crop.

Usage: python scripts/crop_source_mapping.py --pdf /tmp/abbott-unl.pdf
This checks source ink only. Inferring variable IDs from question order remains uncertain.
"""
import argparse, hashlib, json, subprocess, tempfile, sys
import PIL
from pathlib import Path
from PIL import Image
ROOT=Path(__file__).resolve().parents[1]
EXPECTED='a3c381d6f6295e917806834364b7f55fc35684b3db53174a53c3564feab4d70a'
# Coordinates in PDF points, origin top left. Pages are 612x792 points.
SPECS=[('table_3_3_selection',115,(90,70,550,720)),
       ('appendix_j_h1_selection',267,(80,64,552,388)),
       ('appendix_d_domain_field_order',255,(90,387,550,697)),
       ('appendix_l_coding_sheets',283,(140,116,500,667))]
def main():
 p=argparse.ArgumentParser();p.add_argument('--pdf',type=Path,required=True);a=p.parse_args()
 assert hashlib.sha256(a.pdf.read_bytes()).hexdigest()==EXPECTED,'Unexpected PDF version'
 out=ROOT/'outputs/source_crops';out.mkdir(parents=True,exist_ok=True)
 records=[]
 with tempfile.TemporaryDirectory() as t:
  for name,page,box in SPECS:
   prefix=Path(t)/name
   r=subprocess.run(['pdftoppm','-f',str(page),'-l',str(page),'-png','-r','600','-singlefile',str(a.pdf),str(prefix)],capture_output=True,text=True)
   if r.returncode:raise RuntimeError(r.stderr)
   with Image.open(str(prefix)+'.png') as im:
    pixels=tuple(round(v*600/72) for v in box)
    crop=im.crop(pixels);dest=out/(name+'.png');crop.save(dest)
   records.append({'name':name,'pdf_page':page,'printed_page':page-14,'box_points':box,'dpi':600,'output':str(dest.relative_to(ROOT)),'sha256':hashlib.sha256(dest.read_bytes()).hexdigest()})
 (out/'manifest.json').write_text(json.dumps({'pdf_sha256':EXPECTED,'python':sys.version,'Pillow':PIL.__version__,'pdftoppm':subprocess.run(['pdftoppm','-v'],capture_output=True,text=True).stderr.splitlines()[0],'crops':records},indent=2)+'\n')
 print('Rendered',len(records),'source evidence crops at 600 dpi')
if __name__=='__main__':main()
