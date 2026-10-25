"""Add local manuscript links without modifying frozen investigation artifacts."""
from pathlib import Path
import json

P=Path(__file__).resolve().parent
R=P.parents[2]
base='formalization/distance-preservation/paper/'
artifact={'pdf':base+'main.pdf','tex':base+'main.tex',
          'proof_guide':base+'PROOF-GUIDE.html','report_audit':base+'report-audit.json',
          'source_archive':base+'distance-preservation-source.zip',
          'status':'local_review_artifact_not_published','manuscript_date':'2026-10-25'}
def read(p):return json.loads(p.read_text())
def write(p,x):p.write_text(json.dumps(x,indent=2,ensure_ascii=False)+'\n')

qpath=R/'literature/open-problems.json';rows=read(qpath)
q=next(x for x in rows if x['id']=='L-F25-distance-preservation')
assert q['current_resolution_status']=='not_independently_established'
for x in q['research_progress']:
    if x['title']=='Infinite mixed-logical counterfamily to the proposed girth/RCPC criterion':
        x['manuscript']=artifact
write(qpath,rows)
ppath=R/'planning/current-difficulty-estimates.json';plan=read(ppath)
q=next(x for x in plan if x['target_id']=='L-F25-distance-preservation')
assert not q['completed'] and q['research_status']=='planning_not_yet_assessed'
q['bounded_research_result']['manuscript']=artifact
write(ppath,plan)
rpath=R/'literature/research-reconciliation.json';rec=read(rpath)
q=next(x for x in rec['research_blocks'] if x['id']=='distance-preservation-four-hour-2026-10-24')
assert q['canonical_completion_delta']==0
q['manuscript']=artifact
write(rpath,rec)
spath=R/'literature/research-source-index.json';index=read(spath)
q=next(x for x in index['sources'] if x['id']=='RDV2025')
q['distance_preservation_review']['manuscript']=artifact
q=next(x for x in index['sources'] if x['id']=='BhardwajEtAl2026Processors')
q['report_preparation_version_check']={
    'checked_on':'2026-10-25','record':base+'report-source-checks.json',
    'finding':'Abstract history lists v2 dated2October2026. Paper comparison is explicitly to inspectedv1; later full-text/version comparison remains unassessed.',
    'new_full_texts':0,'canonical_target_delta':0}
write(spath,index)
print(json.dumps({'status':'PASS','entry_delta':0,'eligible_delta':0,'completion_delta':0,'new_full_texts':0}))
