"""Update this round's progress without changing canonical completion statuses."""
from pathlib import Path
import json
R=Path(__file__).resolve().parents[3];BASE='formalization/distance-preservation/truncated12'
ROUND='truncated-distance12-four-hour-2026-10-25'
def load(p):return json.loads((R/p).read_text())
def save(p,x):(R/p).write_text(json.dumps(x,indent=2,ensure_ascii=False)+'\n')
if __name__=='__main__':
 v=load(BASE+'/verification.json')
 complete_nine=v['modules'].get('ThroughNine',{}).get('status')=='PASS'
 extra=' A complete intermediate Lean theorem proves the actual Pauli bound min(D,10) under both classical lower-bound predicates and the exact normalized girth/entry tests.' if complete_nine else ''
 note=dict(round_id=ROUND,title='Truncated-bound written argument, actual-source classification and partial formalization',checked_on='2026-10-25',round_status=v['round_status'],evidence='written_argument_exact_integer_replay_general_lean_structural_bridges_partial_closed_case_replay',contribution='For the strengthened normalized 3x4 criterion, a certificate-assisted written argument gives dQ>=min(dC,12). Lean checks the actual-source mixed count-profile classification through weight11, induced K2,3 equality case, singleton support/label reduction, normalization, full-span, actual matching-row, constant-row cancellation and interpreted obstruction bridges. Independent integer replay checks all183312 pattern certificates. The complete min(D,12) source-level distance theorem is not assembled; no qualifying counterexample and no canonical source completion is claimed.'+extra,report=BASE+'/RESEARCH-NOTE.txt',verification=BASE+'/verification.json',lean_sources=[BASE+'/'+n+'.lean' for n in ['SourceProfiles','ExceptionalGraph','SupportSingletons','FiniteLabels','Normalization','GaugeWeight','SpanCoefficients','KernelCatalog','TorsionClassical','GeneralSymmetry','PauliBridge','MatchingRows','RowCancellation','ConstantRows','TargetObstructions','PatternRealizations']],completed_intermediate_source_bounds=v['completed_intermediate_source_bounds'],remaining_formal_gaps=v['remaining_formal_gaps'],kernel_case_counts={w:dict(admitted=x['admitted_patterns'],expected=x['expected_patterns']) for w,x in v['kernel_cases'].items()},canonical_completion_delta=0)
 for n in ['SourceSeven','ThroughNine','ClassicalTransport','EntryTestTransport']:
  if v['modules'].get(n,{}).get('status')=='PASS':note['lean_sources'].append(BASE+'/'+n+'.lean')
 rows=load('literature/open-problems.json');parent=next(x for x in rows if x['id']=='L-F25-distance-preservation')
 parent['research_progress']=[x for x in parent['research_progress'] if x.get('round_id')!=ROUND]+[note]
 for q in parent['remaining_project_questions']:
  if q['id']=='RQ-F25-truncated-distance-12':q['status']='A certificate-assisted written argument is recorded, and actual-source count classification is checked in Lean in the October25 round. The current exact remaining gaps and any completed intermediate bound are in truncated12/verification.json. The source equality question is not marked solved.'
 save('literature/open-problems.json',rows)
 plans=load('planning/current-difficulty-estimates.json');p=next(x for x in plans if x['target_id']==parent['id'])
 p['current_round']=note
 if BASE+'/verification.json' not in p['background_evidence']:p['background_evidence'].append(BASE+'/verification.json')
 p['first_milestone']=note['contribution']+' Remaining formal work: '+' '.join(v['remaining_formal_gaps'])+' No canonical completion or discovery-time estimate inferred.'
 save('planning/current-difficulty-estimates.json',plans)
 rec=load('literature/research-reconciliation.json')
 block=dict(id=ROUND,checked_on='2026-10-25',kind='authorized_bounded_followup_investigation',canonical_target_id=parent['id'],bounded_followup_id='RQ-F25-truncated-distance-12',canonical_completion_delta=0,canonical_entry_delta=0,eligible_target_delta=0,complete_canonical_lean_target_delta=0,conclusion=note['contribution'],report=note['report'],verification=note['verification'],proof_artifact=BASE+('/ThroughNine.lean' if complete_nine else '/SourceProfiles.lean'),literature_screen='literature/truncated-distance12-source-screening.json',indexing_extensions=['truncated-distance12-sources-2026-10-25','truncated-distance12-postlemma-sources-2026-10-25'],indexing_scope='Separate extensions add19 entries, four eligible targets and four full-text paper screens. New resolution/Lean/difficulty audits remain unassessed. Canonical complete Lean count stays five.',round_status=v['round_status'])
 rec['research_blocks']=[x for x in rec['research_blocks'] if x['id']!=ROUND]+[block];save('literature/research-reconciliation.json',rec)
 print({'round':v['round_status'],'canonical_completion_delta':0})
