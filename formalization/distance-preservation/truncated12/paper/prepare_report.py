"""Package the report with its exact admitted sources and verification evidence."""
from pathlib import Path
import datetime,hashlib,json,re,zipfile
P=Path(__file__).resolve().parent;R=P.parent;ROOT=R.parents[2]
ARCHIVE='truncated-distance-source.zip'
def sha(data):return hashlib.sha256(data).hexdigest()
def main():
 v=json.loads((R/'verification.json').read_text());assert v['main_source_distance_theorem_completed'] and not v['remaining_formal_gaps']
 audit=json.loads((P/'declaration-audit.json').read_text());assert audit['status']=='PASS' and audit['source_sha256']==sha((P/'ReportAudit.lean').read_bytes()) and audit['log_sha256']==sha((P/'ReportAudit.log').read_bytes())
 coverage=json.loads((P/'proof-coverage.json').read_text())
 portable=dict(status='source_snapshot',manuscript_date='2026-10-25',proof_commit=coverage['proof_commit'],research_imports=269,finite_cases=183312,complete_listings=len(coverage['listings']),pdf_sha256=sha((P/'main.pdf').read_bytes()),audited_declarations=audit['audited_declarations'],axioms=audit['axioms'])
 (P/'archive-metadata.json').write_text(json.dumps(portable,indent=2)+'\n')
 files={}
 def add(p):
  if p.is_file():files[str(p.relative_to(ROOT))]=p.read_bytes()
 paths={p.stem:p for base in [R.parent,R,R/'catalog-chunks'] for p in base.glob('*.lean')}
 for n,x in v['modules'].items():
  if x['status']!='PASS':continue
  source=paths[n];assert sha(source.read_bytes())==x['source_sha256'];add(source)
  record=R/x['record'];log=record.with_suffix('.log');assert sha(log.read_bytes())==x['log_sha256'];add(record);add(log)
 for pattern in ['*.py','*.json','*.gz','*.txt','*.md']:
  for p in R.glob(pattern):
   if not p.name.startswith('reconcile_'):add(p)
 for p in P.rglob('*'):
  if p.suffix in {'.tex','.py','.txt','.json','.html','.pdf','.lean','.log'} and p.name not in {'report-audit.json','standalone-check.json','SHA256SUMS.txt'} and '__pycache__' not in p.parts:add(p)
 ledger=ROOT/'literature/truncated-distance12-source-screening.json';add(ledger)
 files['lean-toolchain']=b'leanprover/lean4:v4.36.0-rc1\n'
 sums=''.join(sha(data)+'  '+name+'\n' for name,data in sorted(files.items()));(P/'SHA256SUMS.txt').write_text(sums)
 files['SHA256SUMS.txt']=sums.encode()
 with zipfile.ZipFile(P/ARCHIVE,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as z:
  for name,data in sorted(files.items()):
   info=zipfile.ZipInfo(name,date_time=(2026,10,25,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED;info.external_attr=0o100644<<16;z.writestr(info,data)
 coverage=json.loads((P/'proof-coverage.json').read_text())
 record=dict(status='packaged_pending_final_validation',built_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),manuscript_date='2026-10-25',proof_commit=coverage['proof_commit'],main_theorem='TruncatedDistance.source_distance_bound_twelve',main_bound='dQ >= min(dC,12)',research_imports=269,finite_cases=183312,complete_listings=len(coverage['listings']),listed_lines=sum(x['last_line']-x['line']+1 for x in coverage['listings']),audited_declarations=audit['audited_declarations'],axioms=audit['axioms'],pdf_sha256=sha((P/'main.pdf').read_bytes()),archive_sha256=sha((P/ARCHIVE).read_bytes()),archive_members=len(files),sha256_manifest_sha256=sha(sums.encode()),compiler='Tectonic 0.17.0',canonical_completion_delta=0,new_paper_records=0,new_target_entries=0)
 (P/'report-audit.json').write_text(json.dumps(record,indent=2)+'\n');print(json.dumps(record,indent=2))
if __name__=='__main__':main()
