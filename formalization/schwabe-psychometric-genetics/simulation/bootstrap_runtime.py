"""Relocate downloaded Debian R/JAGS packages without system writes.
Prerequisite: acquire the exact .deb files in provenance/runtime-packages.json
from Debian's public package service. This script does not bypass network rules.
"""
import argparse,hashlib,json,pathlib,subprocess
p=argparse.ArgumentParser();p.add_argument('archives');p.add_argument('destination');a=p.parse_args();dest=pathlib.Path(a.destination).resolve();dest.mkdir(parents=True,exist_ok=True)
manifest=json.loads(pathlib.Path('provenance/runtime-packages.json').read_text())
for row in manifest:
 archive=pathlib.Path(a.archives)/row['filename'];assert hashlib.sha256(archive.read_bytes()).hexdigest()==row['sha256'],archive
 subprocess.run(['dpkg-deb','-x',str(archive),str(dest)],check=True)
rhome=dest/'usr/lib/R'
for f in (rhome/'etc').iterdir():
 if f.is_symlink():
  source=dest/'etc/R'/f.name
  if source.exists():data=source.read_bytes();f.unlink();f.write_bytes(data)
(rhome/'etc/Renviron').write_bytes((dest/'etc/R/Renviron.ucf').read_bytes())
bin=dest/'bin';bin.mkdir(exist_ok=True)
launcher=f'''#!/bin/bash
export R_HOME={str(rhome)!r}
export R_LIBS_SITE={str(dest/'usr/lib/R/site-library')!r}
export R_SHARE_DIR={str(dest/'usr/share/R/share')!r}
export R_INCLUDE_DIR={str(dest/'usr/share/R/include')!r}
export R_DOC_DIR={str(dest/'usr/share/doc/R')!r}
export LD_LIBRARY_PATH={str(dest/'usr/lib/x86_64-linux-gnu')!r}:{str(rhome/'lib')!r}${{LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}}
export JAGS_MODULE_PATH={str(dest/'usr/lib/x86_64-linux-gnu/JAGS/modules-4')!r}
if [ "$1" = --vanilla ]; then shift; fi
if [ "$1" = -e ]; then exec "$R_HOME/bin/exec/R" --vanilla --slave "$@"; fi
script="$1"
shift
exec "$R_HOME/bin/exec/R" --vanilla --slave --file="$script" --args "$@"
'''
f=bin/'Rscript';f.write_text(launcher);f.chmod(0o755)
print(f)
