"""Create a deterministic complete artifact bundle and publication hash manifest."""
from pathlib import Path
import json,hashlib,zipfile,datetime
R=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
files=sorted(p for p in R.rglob('*') if p.is_file() and '__pycache__' not in p.parts and p.name not in ['research-source.zip','publication-manifest.json'] and p.suffix not in ['.olean','.aux','.out'])
archive=R/'research-source.zip'
with zipfile.ZipFile(archive,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as z:
 for p in files:
  info=zipfile.ZipInfo('gallager-b-absorbing/'+str(p.relative_to(R)),date_time=(2026,10,26,0,0,0))
  info.compress_type=zipfile.ZIP_DEFLATED
  z.writestr(info,p.read_bytes())
manifest=dict(schema=1,canonical_id='L-P09-all-absorbing',proof_commit='2717b0ab2b59c2ccb71f0e369a9f21d80490c191',manuscript_revision_date='2026-10-26',issue_url='https://github.com/alectionary/vibe-math/issues/2',publication_destination='alectionary/vibe-math master',paper='paper/main.pdf',paper_pages=11,visual_review='All11 rendered pages inspected; no overlap, missing symbols or clipped content.',original_time_budget='six hours from2026-10-26T06:22:37Z; delivery window missed',resumption='User explicitly requested resume; remaining verification and publication completed under that instruction.',files={str(p.relative_to(R)):sha(p) for p in files},archive_sha256=sha(archive))
(R/'publication-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
with zipfile.ZipFile(archive) as z:
 assert len(z.namelist())==len(files)
 for p in files:assert z.read('gallager-b-absorbing/'+str(p.relative_to(R)))==p.read_bytes()
print('Bundled',len(files),'files. Archive SHA256:',sha(archive))
