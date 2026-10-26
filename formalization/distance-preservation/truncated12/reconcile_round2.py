"""Reconcile the second block separately, preserving the first block's findings."""
from pathlib import Path
import json
R=Path(__file__).resolve().parents[3]
BASE='formalization/distance-preservation/truncated12'
ROUND='truncated-distance12-four-hour-round2-2026-10-25'
def load(p):return json.loads((R/p).read_text())
def save(p,x):(R/p).write_text(json.dumps(x,indent=2,ensure_ascii=False)+'\n')
if __name__=='__main__':
 v=load(BASE+'/verification.json')
 done=v['main_source_distance_theorem_completed']
 admitted=[n for n in ['Coverage11','CatalogExclusion11','SupportPairs','PairMatching','TenGeometry','TenIndex','TenRealization','TenEncoding','K23Numbering','K23Colors','K23MissingRows','K23LeafMatches','ElevenGeometry','ElevenIndex','ElevenRealization','ElevenEncoding','SourceEleven','GroupTransport','ProfileTransport','CountCanonical','SourceTen','TwelveConditional','Coverage10','ThroughEleven','DistanceMinima','DistanceTwelve','CriterionScope'] if v['modules'].get(n,{}).get('status')=='PASS']
 conclusion=('The bounded strengthened criterion now has a general Lean Pauli bound min(D,12), with actual source supports, both full stabilizer spans, all finite certificates and source distance minima.' if done else 'Second authorized block develops actual weight-ten/eleven source support encodings and quantified finite coverage toward min(D,12); the exact main theorem remains incomplete. The previous complete min(D,10) theorem is preserved.')
 conclusion+=' Current exact admission and remaining obligations are in the verification manifest. The broader source sufficient-condition question for dQ=dC is not marked solved; no canonical completion is credited.'
 note=dict(evidence='general_lean_complete_bounded_source_distance_theorem' if done else 'general_lean_source_geometry_and_partial_closed_catalog_replay',round_id=ROUND,title='Second bounded distance-12 formalization block',checked_on='2026-10-25',round_status=v['round_status'],contribution=conclusion,report=BASE+'/ROUND2.txt',verification=BASE+'/verification.json',lean_sources=[BASE+'/'+n+'.lean' for n in admitted],kernel_case_counts={w:dict(admitted=x['admitted_patterns'],expected=x['expected_patterns']) for w,x in v['kernel_cases'].items()},completed_intermediate_source_bounds=v['completed_intermediate_source_bounds'],remaining_formal_gaps=v['remaining_formal_gaps'],canonical_completion_delta=0)
 rows=load('literature/open-problems.json');parent=next(x for x in rows if x['id']=='L-F25-distance-preservation')
 for old in parent['research_progress']:
  if old.get('round_id')=='truncated-distance12-four-hour-2026-10-25':old['verification']=BASE+'/round1-verification.json'
 parent['research_progress']=[x for x in parent['research_progress'] if x.get('round_id')!=ROUND]+[note]
 for q in parent['remaining_project_questions']:
  if q['id']=='RQ-F25-truncated-distance-12':q['status']=('Completed bounded min(D,12) follow-up in general Lean; the broader source equality question remains open.' if done else 'Second four-hour formalization block active; completed source bridges and remaining catalog/main-theorem coverage are recorded in truncated12/verification.json.')
 save('literature/open-problems.json',rows)
 plans=load('planning/current-difficulty-estimates.json');p=next(x for x in plans if x['target_id']==parent['id']);p['current_round']=note;p['first_milestone']=conclusion+' '+' '.join(v['remaining_formal_gaps']);save('planning/current-difficulty-estimates.json',plans)
 rec=load('literature/research-reconciliation.json')
 for old in rec['research_blocks']:
  if old.get('id')=='truncated-distance12-four-hour-2026-10-25':old['verification']=BASE+'/round1-verification.json'
 block=dict(id=ROUND,checked_on='2026-10-25',kind='authorized_bounded_followup_continuation',canonical_target_id=parent['id'],bounded_followup_id='RQ-F25-truncated-distance-12',canonical_completion_delta=0,canonical_entry_delta=0,eligible_target_delta=0,complete_canonical_lean_target_delta=0,conclusion=conclusion,report=note['report'],verification=note['verification'],proof_artifact=BASE+('/DistanceTwelve.lean' if done else '/TenEncoding.lean'),literature_screen='literature/truncated-distance12-source-screening.json',indexing_scope='No additional paper/question cohort in this continuation; prior harvested questions and all unresolved audits are preserved. Canonical complete Lean target count remains five.',round_status=v['round_status'])
 rec['research_blocks']=[x for x in rec['research_blocks'] if x['id']!=ROUND]+[block];save('literature/research-reconciliation.json',rec)
 print({'round':v['round_status'],'main_source_twelve_completed':done,'canonical_completion_delta':0,'admitted_new_modules':len(admitted)})
