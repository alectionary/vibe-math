"""Consolidate successful fresh builds and all-declaration axiom output."""
from pathlib import Path
import re,json,hashlib,datetime,shutil
P=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 decl=json.loads((P/'authored-declarations.json').read_text());records=[]
 for p in sorted(P.glob('*.lean')):
  if p.stem=='AuditAll':continue
  r=json.loads((P/'.recheck/records'/(p.stem+'.json')).read_text())
  assert r['exit_code']==0 and r['source_sha256']==sha(p) and r['unchanged_during_check']
  assert r['object_sha256']==sha(P/'.recheck/lib'/(p.stem+'.olean'))
  assert r['log_sha256']==sha(P/'.recheck/logs'/(p.stem+'.log'))
  records.append(r)
 a=json.loads((P/'.recheck/records/AuditAll.json').read_text());assert a['source_sha256']==sha(P/'AuditAll.lean')
 body=(P/'.recheck/logs/AuditAll.log').read_text()
 found=dict(re.findall(r"'([^']+)' (?:depends on axioms:\s*(\[[^\]]*\])|does not depend on any axioms)",body,re.S))
 
 for row in decl['declarations']:assert row['source_sha256']==sha(P/(row['module']+'.lean'))
 expected={r['name'] for r in decl['declarations']};assert expected<=found.keys(),sorted(expected-found.keys())
 ax=set()
 for name,value in found.items():
  names={x.strip() for x in value.strip('[]').split(',') if x.strip()};assert names<={'propext','Classical.choice','Quot.sound'},(name,names);ax|=names
 report=dict(passed=True,all_named_authored_declarations_audited=True,module_count=len(records),declaration_count=len(expected),allowed_axioms=sorted(ax),audit_source_sha256=sha(P/'AuditAll.lean'),audit_log_sha256=sha(P/'.recheck/logs/AuditAll.log'),declarations_sha256=sha(P/'authored-declarations.json'))
 (P/'axiom-audit.json').write_text(json.dumps(report,indent=2)+'\n')
 phases=sorted((P/'.recheck').glob('*-fresh-recheck.json'),key=lambda p:p.stat().st_mtime)
 assert phases
 prior=json.loads(phases[-1].read_text())
 out=dict(fresh_new_module_check=True,new_modules=records,prior_checked_sources=prior['prior_checked_sources'],prior_manifest_sha256=prior['prior_manifest_sha256'],prior_objects=prior['prior_objects'],toolchain=prior['toolchain'],mathlib_revision=prior['mathlib_revision'],all_declaration_audit=report,finished_utc=datetime.datetime.now(datetime.timezone.utc).isoformat())
 (P/'fresh-recheck.json').write_text(json.dumps(out,indent=2)+'\n')
 for r in records+[a]:
  dst=P/'fresh-logs'/(r['module']+'.log');dst.parent.mkdir(exist_ok=True);shutil.copyfile(P/'.recheck/logs'/(r['module']+'.log'),dst)
 cov=json.loads((P/'proof-coverage.json').read_text());cov['status']='every_manuscript_proof_has_checked_Lean_version';cov['all_declaration_audit']=report
 modules={r['module'] for r in records}
 for c in cov['proofs']:
  for f in c.get('files',[]):assert Path(f).stem in modules
  for name in c.get('lean',[]):assert name in expected,name
 (P/'proof-coverage.json').write_text(json.dumps(cov,indent=2)+'\n')
 print('PASS:',len(records),'freshly checked modules;',len(expected),'authored declarations axiom-audited.')
if __name__=='__main__':main()
