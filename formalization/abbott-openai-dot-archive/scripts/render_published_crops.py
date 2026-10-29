#!/usr/bin/env python3
"""Recreate 600-dpi evidence crops from the unmodified Abbott PDF.
No OCR or retouching. Coordinates are points from top-left of PDF pages.
"""
from pathlib import Path
import argparse, hashlib, json, platform, subprocess, tempfile
from PIL import Image
import PIL
ROOT=Path(__file__).resolve().parents[1]
EXPECTED='a3c381d6f6295e917806834364b7f55fc35684b3db53174a53c3564feab4d70a'
CROPS=[
 (109,(67,414,728,463),'correlation-cutoffs-p95'),
 (124,(100,426,550,591),'composite-formula-p110'),
 (139,(100,120,550,232),'nonresponse-percentages-p125'),
 (143,(100,258,550,312),'unrefined-inputs-p129'),
 (144,(100,258,550,394),'refinement-sb-p130'),
 (145,(100,92,550,255),'general-sb-p131'),
 (145,(100,264,550,340),'cfi-prose-p131'),
 (146,(104,126,528,658),'composite-diagram-p132'),
 (148,(100,341,550,449),'external-fit-p134'),
 (265,(101,450,451,700),'power-output-p251'),
 (266,(101,91,451,458),'power-output-p252'),
]

def main():
 p=argparse.ArgumentParser();p.add_argument('--pdf',type=Path,default=Path('/tmp/abbott-unl.pdf'));args=p.parse_args()
 digest=hashlib.sha256(args.pdf.read_bytes()).hexdigest()
 if digest!=EXPECTED:raise SystemExit(f'Source hash mismatch: {digest}')
 out=ROOT/'outputs/crops';out.mkdir(parents=True,exist_ok=True)
 records=[]
 with tempfile.TemporaryDirectory(prefix='abbott-published-crops-') as tmp:
  for page in sorted(set(c[0] for c in CROPS)):
   prefix=Path(tmp)/f'pdf-{page}'
   cmd=['pdftoppm','-f',str(page),'-l',str(page),'-singlefile','-r','600','-png',str(args.pdf),str(prefix)]
   proc=subprocess.run(cmd,capture_output=True,text=True,check=True)
   with Image.open(prefix.with_suffix('.png')) as im:
    for pg,box,name in CROPS:
     if pg!=page:continue
     pixels=tuple(round(x*600/72) for x in box)
     target=out/(name+'.png');im.crop(pixels).save(target)
     records.append(dict(file=str(target.relative_to(ROOT)),pdf_page=page,printed_page=page-14,dpi=600,bbox_pdf_points=box,bbox_pixels=pixels,sha256=hashlib.sha256(target.read_bytes()).hexdigest()))
 version=subprocess.run(['pdftoppm','-v'],capture_output=True,text=True).stderr.strip().splitlines()[0]
 (out/'published-crops-manifest.json').write_text(json.dumps(dict(source_sha256=digest,python=platform.python_version(),pillow=PIL.__version__,renderer=version,crops=records),indent=2)+'\n')
 print(f'Wrote {len(records)} crops and manifest to {out}')
if __name__=='__main__':main()
