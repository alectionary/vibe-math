#!/usr/bin/env python3
"""Freeze hashes and package runnable private artifacts, excluding QA rasters."""
from pathlib import Path
import hashlib,json,subprocess,sys,zipfile
ROOT=Path(__file__).resolve().parents[1]
def main():
 subprocess.run([sys.executable,str(ROOT/'scripts/make_manifest.py')],check=True)
 archive=ROOT.parent/'abbott-replication-bundle.zip'
 with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as z:
  for p in sorted(ROOT.rglob('*')):
   if not p.is_file() or '__pycache__' in p.parts or p.suffix=='.pyc' or 'report_render' in p.parts or 'report_qa' in p.parts:continue
   z.write(p,Path(ROOT.name)/p.relative_to(ROOT))
 with zipfile.ZipFile(archive) as z:
  assert z.testzip() is None
  manifest=json.loads(z.read(ROOT.name+'/outputs/file_manifest.json'))
  for row in manifest['files']:
   data=z.read(ROOT.name+'/'+row['path']);assert len(data)==row['bytes'];assert hashlib.sha256(data).hexdigest()==row['sha256']
  count=len(z.namelist())
 pdf=ROOT/'report/abbott_replication.pdf'
 receipt={'zip_path':str(archive),'zip_bytes':archive.stat().st_size,'zip_sha256':hashlib.sha256(archive.read_bytes()).hexdigest(),'zip_file_count':count,'pdf_path':str(pdf),'pdf_bytes':pdf.stat().st_size,'pdf_sha256':hashlib.sha256(pdf.read_bytes()).hexdigest(),'manifest_verified':True,'zip_crc_verified':True}
 (ROOT.parent/'abbott-replication-delivery.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps(receipt,indent=2))
if __name__=='__main__':main()
