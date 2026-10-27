"""Audit general proof closure, exact question scope and symmetric-CSS publication."""
from pathlib import Path
from datetime import date
import hashlib,json,re,subprocess,sys,zipfile
R=Path(__file__).resolve().parents[1];A=R/'formalization/gallager-b-absorbing/symmetric';D=R/'literature'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
v=json.loads((A/'verification.json').read_text());assert v['theorem_count']==76 and v['lean_returncode']==0
assert v['external_imports']==['Std'] and v['canonical_completion_delta']==0
assert v['research_import_closure']==['OddSupport.lean','Question.lean','Consumers.lean','Audit.lean']
assert v['build_log_sha256']==sha(A/'lean-build.log')
assert v['certificate_sha256']==sha(A/'certificate.json') and v['verifier_sha256']==sha(A/'verify.py')
assert v['verification_inputs_sha256']==sha(A/'verification-inputs.json')
log=(A/'lean-build.log').read_text();assert not re.search(r'sorryAx|_native|Lean.ofReduceBool|Lean.trustCompiler|error[:(]',log)
for file,h in v['source_sha256'].items():
 p=A/file;assert sha(p)==h
 s=p.read_text();assert not re.search(r'\b(sorry|admit|axiom|native_decide|bv_decide)\b',s)
 assert all(x in ['Std','OddSupport','Question','Consumers'] for x in re.findall(r'^import (\S+)',s,re.M))
for name,d in v['declarations'].items():
 assert (A/d['source']).read_text().splitlines()[d['line']-1].startswith('theorem '+name.split('.')[-1])
 assert set(d['axioms'])<={'propext','Classical.choice','Quot.sound'} and "'"+name+"'" in log
subprocess.run([sys.executable,str(A/'verify.py'),'--check'],check=True,capture_output=True)
c=json.loads((A/'certificate.json').read_text());assert not c['even_support_construction_search_performed']
assert c['summary']['families']==9 and c['summary']['odd_zero_syndrome_cases']==13
q=(A/'Question.lean').read_text()
for n in ['FullQuestion','EvenFullQuestion','OneStepQuestion']:assert 'def '+n+' : Prop' in q
assert 'theorem full_question_iff_even' in q and 'theorem benchmark_implies_full' in q
screen=json.loads((D/'symmetric-css-source-screening.json').read_text());assert screen['cohort_delta']==dict(entries=7,eligible_targets=0,paper_records=2,full_text_screens=2,verified_complete_lean_targets=0)
rows=json.loads((D/'open-problems.json').read_text());by={r['id']:r for r in rows}
rec=json.loads((D/'research-reconciliation.json').read_text())
ext=next(e for e in rec['indexing_extensions'] if e['id']=='symmetric-css-sources-2026-10-26')
later=rec['indexing_extensions'][rec['indexing_extensions'].index(ext)+1:]
assert len(rows)==screen['baseline']['canonical_entries']+7+sum(e['added_entries'] for e in later)
assert sum(r['eligible_for_coverage'] for r in rows)==150
assert sum(r['eligible_for_coverage'] and r['lean_proof_status']=='verified_complete_lean_proof' for r in rows)==6
assert by['L-P09-all-absorbing']['verified_artifact']['immutable_commit']=='2717b0ab2b59c2ccb71f0e369a9f21d80490c191'
for p in screen['screens']:
 assert p['status']=='full_text_screened' and p['target_count']==len(p['recorded_target_ids'])
 for f,h in [('source_local_file','source_sha256'),('extracted_text_file','extracted_text_sha256')]:
  if (R/p[f]).exists():assert sha(R/p[f])==p[h]
 for ident in p['recorded_target_ids']:
  r=by[ident];assert not r['eligible_for_coverage']
  assert r['current_resolution_status']=='not_independently_established' and r['lean_proof_status']=='not_assessed_in_this_extension'
  assert r['occurrences'][0]['source_sha256']==p['source_sha256']
  lo,hi=r['occurrences'][0]['extracted_text_lines'];assert 0<lo<=hi<=p['extracted_lines']
chronology=json.loads((A/'paper/chronology.json').read_text())
for row in chronology:
 if row['date_precision']=='day':assert row['elapsed_days']==(date.fromisoformat(row['manuscript_date'])-date.fromisoformat(row['event_date'])).days
 else:assert row['date_precision']=='year' and re.fullmatch(r'\d{4}',row['event_date']) and row['elapsed_days'] is None
assert {r['citation_key'] for r in chronology}>={'blt','hhpw','mpk','redundancy','dhingra','simplex','connected','this'}
assert sum(r['event_kind']=='repository_manuscript_date' for r in chronology)==2
sup=(A/'paper/supplement.tex').read_text();main=(A/'paper/main.tex').read_text()
assert '\\author{}' in main and '\\input{supplement.tex}' in main
for module in ['OddSupport','Question','Consumers']:
 assert len((A/'paper'/(module+'-listing.txt')).read_text().splitlines())==len((A/(module+'.lean')).read_text().splitlines())
 # Complete listings are bundled even when the PDF prints only selected declarations.
assert main.index('\\section{Reference chronology and source roles}')<main.index('\\appendix')
assert '\\cite{eczoo}' in main and '\\bibitem{eczoo}' in main
for row in chronology:
 assert row['event_date'] in main
 if row['elapsed_days'] is not None:assert '& '+str(row['elapsed_days'])+r'\\' in main
excerpts=json.loads((A/'paper/excerpts.json').read_text())
assert len({(e['module'],e['declaration']) for e in excerpts})==len(excerpts)
for e in excerpts:
 lines=(A/e['module']).read_text().splitlines();lo,hi=e['firstline'],e['lastline']
 assert re.match(r'(?:abbrev|def|inductive|structure|theorem) '+re.escape(e['declaration'])+r'\b',lines[lo-1])
 next_decl=next((i for i in range(lo,len(lines)) if re.match(r'(?:abbrev|def|inductive|structure|theorem|end) ',lines[i])),len(lines))
 while next_decl>lo and (not lines[next_decl-1].strip() or lines[next_decl-1].startswith('--')):next_decl-=1
 assert hi==next_decl,(e['declaration'],'excerpt must include the complete declaration')
 assert f'firstline={lo},lastline={hi}' in sup
assert {'cannot_correct_identity_and_odd_support','no_universal_supported_recovery','equal_spans_even_stabilizers','odd_zero_b_logical'}<={e['declaration'] for e in excerpts}
for line in sup.splitlines():
 if line.startswith('\\noindent\\texttt{'):
  name=line.split('{')[1].split('}')[0].replace('\\_','_');decl=next(d for n,d in v['declarations'].items() if n.endswith('.'+name));assert '#L'+str(decl['line']) in line
manifest=json.loads((A/'publication-manifest.json').read_text());assert manifest['completed_canonical_target_delta']==0
assert not manifest['even_support_construction_search_performed'] and manifest['time_budget_seconds'] is None
assert manifest['editorial_repair']['research_skill_sha256']==sha(R/'.agents/skills/open-question-research/SKILL.md')
assert manifest['proof_commit'] in sup and manifest['visual_review']['pdf_sha256']==sha(A/'paper/main.pdf')
assert manifest['archive_sha256']==sha(A/'research-source.zip')
assert manifest['visual_review']['pages_reviewed']==list(range(1,manifest['paper_pages']+1))
for name,h in manifest['files'].items():assert sha(A/name)==h,name
with zipfile.ZipFile(A/'research-source.zip') as z:
 for name,h in manifest['files'].items():assert hashlib.sha256(z.read('symmetric-css/'+name)).hexdigest()==h
assert not any(t in (A/'paper/main.log').read_text() for t in ['Missing character:','Overfull \\hbox','undefined references','LaTeX Error:'])
assert (A/'source-screening.json').read_bytes()==(D/'symmetric-css-source-screening.json').read_bytes()
assert (A/'editorial-source-screening.json').read_bytes()==(D/'symmetric-css-editorial-source-screening.json').read_bytes()
follow=json.loads((D/'symmetric-css-editorial-source-screening.json').read_text())
assert follow['cohort_delta']==dict(entries=3,eligible_targets=0,paper_records=1,full_text_screens=1,verified_complete_lean_targets=0)
for paper in follow['screens']:
 assert paper['target_count']==len(paper['recorded_target_ids'])==3
 for name,key in [('source_local_file','source_sha256'),('extracted_text_file','extracted_text_sha256')]:
  if (R/paper[name]).exists():assert sha(R/paper[name])==paper[key]
 for ident in paper['recorded_target_ids']:
  assert not by[ident]['eligible_for_coverage'] and by[ident]['lean_proof_status']=='not_assessed_in_this_extension'
  assert by[ident]['occurrences'][0]['source_sha256']==paper['source_sha256']
assert follow['reused_sources'][0]['paper_id']=='P10' and follow['reused_sources'][0]['target_count'] is None
audit=json.loads((A/'paper/reader-audit.json').read_text())
assert audit['pdf_sha256']==sha(A/'paper/main.pdf')
assert audit['chronology_page']==6 and audit['proof_dependency_page']==8
assert {r['status'] for r in audit['requirements']}<={'met','partial','access-limited','not applicable'}
assert all(r['evidence'] for r in audit['requirements'])
print('PASS:76 general/interface/consumer theorems;9 fixed families;exact unresolved full/benchmark interfaces;10 harvested directions across both screens;13 dated milestones;complete focused excerpts;PDF/archive hashes;no even-support search.')
