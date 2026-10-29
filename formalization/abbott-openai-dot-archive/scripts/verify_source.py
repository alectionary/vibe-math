#!/usr/bin/env python3
"""Verify the canonical PDF and optionally recreate page text. No network access."""
import argparse,hashlib,json,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
SHA='a3c381d6f6295e917806834364b7f55fc35684b3db53174a53c3564feab4d70a'
def main():
 p=argparse.ArgumentParser();p.add_argument('--pdf',type=Path,default=Path('/tmp/abbott-unl.pdf'));p.add_argument('--extract',action='store_true');a=p.parse_args()
 assert a.pdf.is_file(),f'Supply official PDF with --pdf: {a.pdf}'
 data=a.pdf.read_bytes();assert len(data)==7626437;assert hashlib.sha256(data).hexdigest()==SHA,'PDF hash differs: review version before replacing source'
 info=subprocess.run(['pdfinfo',str(a.pdf)],check=True,capture_output=True,text=True).stdout
 assert 'Pages:           283' in info,info
 if a.extract:
  target=ROOT/'sources/dissertation.txt';subprocess.run(['pdftotext','-layout',str(a.pdf),str(target)],check=True)
  pages=target.read_text().split('\f');assert len(pages)==284 and not pages[-1].strip()
  for i,text in enumerate(pages[:-1],1):(ROOT/f'sources/pages/pdf-{i:03d}.txt').write_text(text)
 print(json.dumps({'verified':True,'sha256':SHA,'bytes':len(data),'pages':283,'extraction_regenerated':a.extract},indent=2))
if __name__=='__main__':main()
