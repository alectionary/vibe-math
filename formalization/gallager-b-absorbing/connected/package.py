"""Create the deterministic connected-example source archive and byte manifest."""
from pathlib import Path
import argparse,datetime,hashlib,json,re,zipfile
R=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('--proof-commit',required=True);a=p.parse_args()
assert re.fullmatch('[0-9a-f]{40}',a.proof_commit)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
review=json.loads((R/'paper/render-review.json').read_text())
assert review['pdf_sha256']==sha(R/'paper/main.pdf')
assert review['pages_reviewed']==list(range(1,review['page_count']+1))
files=sorted(p for p in R.rglob('*') if p.is_file() and '__pycache__' not in p.parts and p.name not in ['research-source.zip','publication-manifest.json'] and p.suffix not in ['.olean','.aux','.out'])
archive=R/'research-source.zip'
with zipfile.ZipFile(archive,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as z:
 for p in files:
  info=zipfile.ZipInfo('connected-gallager/'+str(p.relative_to(R)),date_time=(2026,10,26,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED
  z.writestr(info,p.read_bytes())
now=datetime.datetime.now(datetime.timezone.utc)
start=datetime.datetime(2026,10,26,14,43,45,tzinfo=datetime.timezone.utc)
manifest=dict(schema=1,canonical_id='L-P09-all-absorbing',project_derived_followup='RQ-P09-connected-coupled',completed_canonical_target_delta=0,proof_commit=a.proof_commit,manuscript_date='2026-10-26',issue_url='https://github.com/alectionary/vibe-math/issues/2',publication_destination='alectionary/vibe-math master',paper='paper/main.pdf',paper_pages=review['page_count'],visual_review=review,candidate_known_by_utc='2026-10-26T14:55:50Z',candidate_elapsed_seconds_upper_bound=725,clean_proof_checked_utc=json.loads((R/'verification.json').read_text())['checked_utc'],investigation_start_utc=start.isoformat(),deadline_utc='2026-10-26T18:43:45Z',packaged_utc=now.isoformat(),elapsed_seconds_to_package=(now-start).total_seconds(),time_budget_seconds=14400,budget_note='Resume continues the original four-hour block. Candidate discovery, clean proof completion and publication timestamps are separate in investigation/verification/remote records.',files={str(p.relative_to(R)):sha(p) for p in files},archive_sha256=sha(archive))
(R/'publication-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
with zipfile.ZipFile(archive) as z:
 assert len(z.namelist())==len(files)
 for p in files:assert z.read('connected-gallager/'+str(p.relative_to(R)))==p.read_bytes()
print('Bundled',len(files),'files; archive SHA256',sha(archive))
