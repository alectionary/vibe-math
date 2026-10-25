"""Integrate the checked bounded result without marking the source problem solved."""
from pathlib import Path
import json
W=Path(__file__).resolve().parent;R=W.parents[1];D=R/'literature';P=R/'planning'
def read(p):return json.loads(p.read_text())
def write(p,x):p.write_text(json.dumps(x,indent=2,ensure_ascii=False)+'\n')
def upsert(xs,x,key='id'):
 for n,v in enumerate(xs):
  if v[key]==x[key]:xs[n]=x;return
 xs.append(x)
if __name__=='__main__':
 v=read(W/'verification.json');assert all(x['exit_code']==0 and not x['unexpected_axiom_or_error'] for x in v['records'])
 structural_records=[read(W/p) for p in ['auxiliary-verification.json','auxiliary-fixed-columns-verification.json']]
 assert all(x['status']=='PASS' for x in structural_records)
 target='L-F25-distance-preservation';base='formalization/distance-preservation/'
 rows=read(D/'open-problems.json');q=next(x for x in rows if x['id']==target)
 assert q['current_resolution_status']=='not_independently_established'
 progress={'title':'Infinite mixed-logical counterfamily to the proposed girth/RCPC criterion',
 'checked_on':'2026-10-24','evidence':'general_lean_proof_and_independent_finite_verification',
 'contribution':'For fixed E=[[0,0,0,0],[0,1,5,3],[0,2,10,7]] and every positive L divisible by11, the source LP construction has no4/6 classical cycles, no RCPC, but dQ<=11<12<=dC<=20. The fixed graph is connected with girth8 and transpose distance2L. General E(a,b) templates have source logical weight<=11; projection of parameters to(1,5) modulo11 preserves the lower bound and exclusions. Actual coefficient matrices, both sectors and full stabilizer spans are bridged. This refutes our proposed criterion; the source sufficient-condition question remains open in this project. Canonical completion delta0.',
 'report':base+'RESEARCH-NOTE.txt','verification':base+'verification.json','search_implementation_audit':base+'search-repair.json',
 'lean_sources':[base+x for x in ['SourceWordBridge.lean','ParametricProjection.lean','ClassicalUpper20.lean','FinalAudit.lean']]}
 progress['supporting_structural_evidence']=[base+p for p in ['LowWeightChecks.lean','PermutationFixedColumns.lean','auxiliary-verification.json','auxiliary-fixed-columns-verification.json','pattern-certificate-verification.json']]
 q['research_progress']=[x for x in q.get('research_progress',[]) if x['title']!=progress['title']]+[progress]
 q['lean_discovery_note']='The full source sufficient-condition problem remains unassessed/unestablished. A separate source-matched Lean counterfamily refutes our diagnostic girth/RCPC sufficient criterion; see research_progress. This is not a full-target completion or a global unresolvedness claim.'
 q['research_source_index']='literature/research-source-index.json'
 remaining={'id':'RQ-F25-exclude-mixed-patterns','title':'Prove or refute the strengthened condition excluding three-column partial row pairing and lighter transpose codes.','status':'Open after a corrected frozen104-base diagnostic and separate finite/structural follow-ups; no general sufficient-condition theorem or discovery-time estimate assigned.'}
 next_task={'id':'RQ-F25-truncated-distance-12','title':'For normalized fully populated source3x4 cyclic bases satisfying the strengthened entry tests and dTranspose>=dC, prove or refute dQ>=min(dC,12).','status':'Preferred bounded follow-up: classify mixed logical supports through11, with both actual source sectors and the full stabilizer quotient. Generic lemmas and finite diagnostics do not establish this universal bound.'}
 q['remaining_project_questions']=[x for x in q.get('remaining_project_questions',[]) if x['id'] not in [remaining['id'],next_task['id'],'RQ-F25-weight7-RCPC-converse']]+[remaining,next_task]
 write(D/'open-problems.json',rows)
 plan=read(P/'current-difficulty-estimates.json');p=next(x for x in plan if x['target_id']==target)
 p['basis']='Full source-condition difficulty is still unassessed. The four-hour bounded investigation refuted our first proposed criterion with source-matched Lean proofs and independent finite checks; this does not complete the original design problem.'
 p['gate']='The strengthened condition has been stated and boundedly tested, but no general proof is established. No numeric effort tier or discovery-time prediction is inferred for the full design question.'
 p['first_milestone']='Completed: source-matched infinite counterfamilies, corrected frozen104-base and L13 finite searches, plus generic Lean low-weight check geometry and a cyclic fixed-column obstruction. A restricted144-pattern catalog is independently checked but its full source/support bridge is missing. Preferred next follow-up: prove or refute the truncated bound dQ>=min(dC,12) under the strengthened entry tests. SourceSectionV-B already claims the stabilizer-weight exclusion, so the weight7 work is a source-claim verification task, not a new open mathematical result. ExactL13 quantum14 certification remains a deferred finite option. See search-repair.json for the repaired search and unchanged replay outcomes.'
 p['research_obstacle']='High classical girth, RCPC absence and no lighter transpose code do not exclude mixed-block logical representatives modulo the full stabilizer span.'
 for path in [base+'RESEARCH-NOTE.txt',base+'verification.json']:
  if path not in p['background_evidence']:p['background_evidence'].append(path)
 p['bounded_research_result']=progress
 # Keep full-target planning estimates/statuses unassessed and completion false.
 assert not p['completed'] and p['research_status']=='planning_not_yet_assessed'
 write(P/'current-difficulty-estimates.json',plan)
 rec=read(D/'research-reconciliation.json')
 block={'id':'distance-preservation-four-hour-2026-10-24','checked_on':'2026-10-24','kind':'authorized_new_problem_investigation',
 'canonical_target_id':target,'canonical_completion_delta':0,'canonical_entry_delta':0,'eligible_target_delta':0,'complete_canonical_lean_target_delta':0,
 'conclusion':'Our girth/RCPC sufficient criterion is refuted by an infinite source-matched family; the broader source question remains open in this project.',
 'report':base+'RESEARCH-NOTE.txt','verification':base+'verification.json','proof_artifact':base+'FinalAudit.lean',
 'literature_screen':'literature/distance-preservation-source-screening.json',
 'indexing_extensions':['distance-preservation-sources-2026-10-24','distance-preservation-classical-source-2026-10-24'],
 'indexing_scope':'Separate indexing extensions add24 non-denominator directions and5 fully screened papers; no precise eligible target or canonical completion is added.'}
 block['supporting_structural_results']={'generic_lean_proofs':[base+'LowWeightChecks.lean',base+'PermutationFixedColumns.lean'],'verification':[base+'auxiliary-verification.json',base+'auxiliary-fixed-columns-verification.json'],'restricted_finite_catalog':base+'pattern-certificate-verification.json','scope':'Generic zero-or-two check-degree theorem below weight12 and a cyclic fixed-column obstruction. No full weight7 logical classification or new canonical completion.'}
 upsert(rec.setdefault('research_blocks',[]),block)
 done={'id':'RQ-F25-girth-RCPC-criterion','origin':'project_derived_followup','diagnostic_role':'our_proposed_sufficient_criterion','source_authors_asked_this_exact_question':False,'eligible_for_coverage':False,
 'parent_target_id':target,'title':'Do classical girth>=8 and RCPC absence imply source LP quantum/classical distance equality for normalized3x4 monomial bases?',
 'status':'refuted_by_infinite_lean_counterfamily','report':base+'RESEARCH-NOTE.txt','verification':base+'verification.json',
 'scope':'Our proposed sufficient criterion, also false with no lighter transpose code; not the full source sufficient-condition target.'}
 upsert(rec.setdefault('project_derived_followups',[]),done)
 follow={'id':remaining['id'],'origin':'project_derived_followup','source_authors_asked_this_exact_question':False,'eligible_for_coverage':False,
 'parent_target_id':target,'title':remaining['title'],'status':'open_after_bounded_fresh_diagnostic','report':base+'RESEARCH-NOTE.txt',
 'scope':'The repaired104-base campaign reproduces no witness within min(dC-1,11);75 cases remain capped below the required range. The separate corrected L13 C++ exclusion through13 has no Lean lower-bound certificate. Original negative outputs are superseded; see search-repair.json.',
 'computational_evidence':[base+'fresh-corrected-summary.json',base+'intermediate-corrected.json',base+'search-repair.json'],
 'next_proposed_target_id':next_task['id'],
 'deferred_finite_certificate':{'L':13,'E':[[0,0,0,0],[0,1,11,3],[0,8,12,6]],'classical_distance':14,'verified_quantum_upper':14,'quantum_lower_lean_status':'not_certified','evidence':base+'independent-intermediate.json'}}
 upsert(rec['project_derived_followups'],follow)
 truncated={'id':next_task['id'],'origin':'project_derived_followup','source_authors_asked_this_exact_question':False,'eligible_for_coverage':False,
 'parent_target_id':target,'related_target_ids':['L-P34-logical-partitions'], 'title':next_task['title'],'status':'open_truncated_lower_bound_with_partial_generic_lean_and_finite_evidence',
 'report':base+'STRUCTURAL-ROUTE.txt','scope':'Our proposed bounded lower-condition task. Assumes normalized3x4 cyclic base, classical girth>=8, no fullRCPC, no three-column partial row pairing, and dTranspose>=dC. All source supports belowmin(dC,12), both sectors and the entire stabilizer span must be controlled. The weight7 exclusion is already asserted by SourceSectionV-B and is treated as a supporting claim audit.',
 'evidence':[base+p for p in ['auxiliary-verification.json','auxiliary-fixed-columns-verification.json','pattern-certificate-verification.json']]}
 upsert(rec['project_derived_followups'],truncated)
 weight7={'id':'RQ-F25-weight7-RCPC-converse','origin':'project_derived_followup','source_authors_asked_this_exact_question':False,'eligible_for_coverage':False,'parent_target_id':target,
 'title':'Audit and formalize the source recipe’s claimed exclusion of stabilizer-weight7 logicals in the normalized3x4 girth8 case.',
 'status':'source_claim_verification_followup_not_new_open_math','report':base+'STRUCTURAL-ROUTE.txt',
 'scope':'Theorem2 states the forward RCPC implication; SectionV-B and the conclusion assert the broader recipe guarantee. The partial generic proofs and restricted144-pattern catalog support checking that claimed result. Do not present the weight7 exclusion as a newly discovered open problem.'}
 upsert(rec['project_derived_followups'],weight7)
 related=next(x for x in rows if x['id']=='L-P34-logical-partitions')
 linked={'title':'Generic low-weight check geometry and restricted permutation-pattern analysis','checked_on':'2026-10-24','evidence':'general_lean_proofs_and_exact_finite_pattern_identities','report':base+'STRUCTURAL-ROUTE.txt','verification':base+'verification.json','lean_sources':[base+'LowWeightChecks.lean',base+'PermutationFixedColumns.lean'],'contribution':'Supports the existing graph/partition direction with generic zero-or-two check geometry below weight12 and a checked cyclic fixed-column obstruction. The full source logical-pattern classification is not completed in this artifact; the stabilizer-weight exclusion is already claimed inSourceSectionV-B. No canonical completion is added.'}
 related['research_progress']=[x for x in related.get('research_progress',[]) if x['title']!=linked['title']]+[linked]
 write(D/'open-problems.json',rows)
 if related['id'] not in rec['updated_target_ids']:rec['updated_target_ids'].append(related['id'])
 if target not in rec['updated_target_ids']:rec['updated_target_ids'].append(target)
 write(D/'research-reconciliation.json',rec)
 index=read(D/'research-source-index.json');src=next(x for x in index['sources'] if x['id']=='RDV2025')
 src['distance_preservation_review']={'checked_on':'2026-10-24','locator':'Equation9, Definitions2–5 and SectionVI',
 'report':base+'RESEARCH-NOTE.txt','verification':base+'verification.json','comparison':'Source motivates sufficient conditions. The checked counterfamily refutes our own girth/RCPC criterion, not an author-stated conjecture or the source general design problem.'}
 src['distance_preservation_review']['unresolved_leads']=[{'title':x['title'],'url':x['url'],'outcome':x.get('screen_outcome',x.get('access','See bounded audit'))} for x in read(W/'prior-art.json')['leads_not_full_text_screened'] if 'title' in x and 'url' in x]
 p34=next(x for x in index['sources'] if x['id']=='P34')
 p34['distance_preservation_connection']={'report':base+'STRUCTURAL-ROUTE.txt','existing_direction_id':'L-P34-logical-partitions','comparison':'Source already supplies graph isomorphism/connectivity and asks how partition constraints translate to graph properties. The weight7 recipe is a source-claim verification task. The proposed truncated lower bound through11 is a project-derived restricted step toward the source distance-preservation problem.'}
 write(D/'research-source-index.json',index)
 print(json.dumps({'status':'PASS','canonical_completion_delta':0,'entry_delta_in_this_research_block':0,'separate_indexing_directions':24,'separate_new_full_texts':5}))
