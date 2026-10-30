"""Install the recorded gate-only Debian R packages into a fresh separate library.
Does not alter the production R runtime, launcher, manifest or system installation.
"""
import argparse,hashlib,json,pathlib,shutil,subprocess,tempfile,urllib.request
p=argparse.ArgumentParser();p.add_argument('--library',default='/workspace/slot3-posterior-library');p.add_argument('--cache',default='/tmp/slot3-posterior-debs');a=p.parse_args()
library=pathlib.Path(a.library);cache=pathlib.Path(a.cache)
if library.exists()and any(library.iterdir()):raise RuntimeError('Use a fresh gate-only library; refusing to overwrite packages')
library.mkdir(parents=True,exist_ok=True);cache.mkdir(parents=True,exist_ok=True)
records=json.load(open('provenance/posterior-runtime-packages.json'))
for r in records:
 archive=cache/r['archive_filename']
 if not archive.exists():archive.write_bytes(urllib.request.urlopen(r['url'],timeout=60).read())
 if hashlib.sha256(archive.read_bytes()).hexdigest()!=r['archive_sha256']:raise ValueError('Archive checksum mismatch '+str(archive))
 with tempfile.TemporaryDirectory(prefix='posterior-extract-')as tmp:
  subprocess.run(['dpkg-deb','-x',str(archive),tmp],check=True)
  for package in (pathlib.Path(tmp)/'usr/lib/R/site-library').iterdir():shutil.copytree(package,library/package.name,symlinks=True)
print(json.dumps({'library':str(library),'verified_archives':len(records),'production_runtime_changed':False}))
