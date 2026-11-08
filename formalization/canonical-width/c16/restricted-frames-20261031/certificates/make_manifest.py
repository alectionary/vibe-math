#!/usr/bin/env python3
"""Write MANIFEST.json: SHA-256 and size of every instance, certificate and pool file used."""
import hashlib, json
from pathlib import Path
here = Path(__file__).resolve().parent; c16 = here.parents[1]
files = sorted(p for p in here.iterdir() if p.suffix in ('.inst', '.gz'))
files += [c16 / 'pools/xcoords.txt', c16 / 'pools/zcoords.txt',
          c16 / 'independent-check/inputs/planted1-xcoords.txt', c16 / 'independent-check/inputs/planted1-zcoords.txt']
man = {str(p.relative_to(c16)): {'sha256': hashlib.sha256(p.read_bytes()).hexdigest(), 'bytes': p.stat().st_size}
       for p in files}
(here / 'MANIFEST.json').write_text(json.dumps(man, indent=1) + '\n')
print(len(man), 'files')
