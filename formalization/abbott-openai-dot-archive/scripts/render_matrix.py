#!/usr/bin/env python3
"""Regenerate 600 dpi source evidence for Table 3.2 and its scale instruction."""
from pathlib import Path
import subprocess, argparse
from PIL import Image
ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser();p.add_argument('--pdf',type=Path,default=Path('/tmp/abbott-unl.pdf'));a=p.parse_args()
out=ROOT/'outputs/matrix_crops';out.mkdir(parents=True,exist_ok=True)
for page,label in [(108,'table94'),(109,'table95'),(254,'scale240'),(140,'factorability126')]:
    subprocess.run(['pdftoppm','-f',str(page),'-l',str(page),'-r','600','-png','-singlefile',str(a.pdf),str(out/label)],check=True)
# Pixel rectangles are relative to the unscaled 600 dpi Poppler render.
crops={
 'table94':{'row10_label':(580,2570,1550,2790),'table94_data':(550,1300,6100,4200)},
 'table95':{'row27_sd':(560,1890,1270,2080),'table95_left':(570,1120,3350,3370),'table95_right':(3300,1120,6050,3370),'table95_note':(560,3450,6100,3860)},
 'scale240':{'fluency_scale':(550,550,4700,1850)},
 'factorability126':{'factorability_claim':(550,1050,4600,3250)},
}
for label,spec in crops.items():
    im=Image.open(out/(label+'.png'))
    for name,box in spec.items():im.crop(box).save(out/(name+'.png'))
