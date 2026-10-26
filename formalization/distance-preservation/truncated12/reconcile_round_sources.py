"""One-time source/question harvesting for the issue1 study; no resolution inference."""
from pathlib import Path
import copy,hashlib,json
R=Path(__file__).resolve().parents[3]
DATE='2026-10-25'
EXT='truncated-distance12-sources-2026-10-25'
LEDGER='literature/truncated-distance12-source-screening.json'
def load(n):return json.loads((R/n).read_text())
def save(n,d):(R/n).write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

if __name__=='__main__':
    rec=load('literature/research-reconciliation.json')
    assert not any(e['id']==EXT for e in rec['indexing_extensions']),'Already integrated'
    claims=load('literature/open-problems.json');plans=load('planning/current-difficulty-estimates.json')
    papers=load('literature/followups.json');manifest=load('literature/downstream-source-manifest.json')
    coverage=load('literature/downstream-paper-coverage.json');index=load('literature/research-source-index.json')
    baseline={'canonical_entries':len(claims),'eligible_targets':sum(x['eligible_for_coverage'] for x in claims),'paper_records':len(coverage),'full_text_screens':sum(x['coverage_status'].endswith('full_text_screened') for x in coverage),'verified_complete_lean_targets':5}
    assert not any(x['id']=='F91' for x in papers)
    raw=R/'local-extraction/literature/truncated12/Lee2026Frames.html'
    text=raw.with_suffix('.txt');digest=sha(raw)
    url='https://arxiv.org/html/2610.06820v1'
    title='Designing Group-Valued Codes with Full Regular Low-Weight Bases'
    version='arXiv:2610.06820v1, 5 October 2026'
    comparison='Full regularity and canonical-frame width concern complete logical bases, not the minimum distance lower bound in our strengthened 3x4 monomial LP target. Full-row-rank augmentation criteria do not apply to the all-one rank-one augmentation of our fully populated 3x4 base. Appendix A.4 supplies a related exhaustive-support-search completeness argument; its code-specific execution records do not certify our inputs.'
    targets=[
      ('c16-unrestricted-width','Determine whether the unrestricted canonical frame width of the fixed LP code C16,9 is 16 or 18.','Section IV.4 and Appendix C.3, Proposition9; construction equation50',585,586,True),
      ('c20-unrestricted-width','Determine the unrestricted canonical frame width of the fixed LP code C20,10.','Section IV.4 and Appendix C.3, Proposition9; construction equation49',575,585,True),
      ('pp1024-joint-parameters','Does the specified 1024-qubit PP family contain a code simultaneously attaining d=24, check weight w=10 and unrestricted frame width f=25?','Section VI; PP construction in Section V and Appendix D.2',726,726,True),
      ('nonabelian-common-action','Extend the non-Abelian constructions to full regular canonical frames with one physical group action preserving both CSS sectors.','Section VI',729,733,False),
      ('rate-distance-frame-design','Optimize distance and canonical frame width as the matrix dimensions and encoding rate vary.','Section VI',721,724,False),
      ('measurement-interfaces','Develop distance-preserving logical-measurement interfaces for the translated frames and assess their ancilla and circuit costs.','Section VI',737,737,False),
    ]
    ids=[]
    for slug,t,loc,first,last,eligible in targets:
        tid='L-F91-'+slug;ids.append(tid)
        occurrence={'source_id':'F91','locator':loc,'extracted_text_lines':[first,last],'url':url,'source_sha256':digest,'relation':'explicit_open_math_target' if eligible else 'explicit_broad_research_direction','version':version}
        c={'id':tid,'origin':'article_inventory_extension','title':t,'kind':'specific_question' if eligible else 'research_direction','written_math_status':'precise_math_in_source' if eligible else 'research_direction','eligible_for_coverage':eligible,'eligibility_note':'Fixed source-defined construction and exact invariant/existence question; retain all construction and frame conventions.' if eligible else 'Broad design or implementation direction without a complete bounded theorem; excluded from the target denominator.','occurrences':[occurrence],'related_target_ids':[],'status_as_of_source':'open_as_stated_in_source','proof_assistant_statement_status':'not_assessed_in_this_extension','lean_statement_status':'not_assessed_in_this_extension','lean_proof_status':'not_assessed_in_this_extension','current_resolution_status':'not_independently_established','search_family':'truncated_distance12_source_questions','added_on':DATE,'lean_discovery_note':'Full-document question harvesting only; no current-resolution, exact-target Lean discovery or difficulty assessment.'}
        claims.append(c)
        p=copy.deepcopy(plans[-1]);p.update(target_id=tid,title=t,eligible_for_coverage=eligible,current_resolution_status=c['current_resolution_status'],lean_statement_status=c['lean_statement_status'],lean_proof_status=c['lean_proof_status'],assessment_date=DATE,source_occurrences=[occurrence],basis='New primary full-document question screen; resolution and effort unassessed.',background_evidence=[LEDGER],gate='Verify current status and exact source construction before estimating effort.',family=c['search_family'],research_status='planning_not_yet_assessed',completed=False,rationale='A source-stated open target is not a present-resolution or difficulty assessment.',first_milestone='Verify the fixed source model, current resolution and formalization coverage.',research_obstacle=None,statement_setup=None,proof_transfer_given_correct_complete_proof=None)
        for key in ['selection_review','progress_note','progress_artifact','proof_branches']:p.pop(key,None)
        plans.append(p)
    papers.append({'id':'F91','title':title,'authors':['Jong Yeon Lee'],'url':url,'year':2026,'publication_status':'inspected_preprint','date_or_version':version,'relationship':'Issue1 truncated-distance study: primary comparison and mandatory question harvesting.','source_screening':LEDGER,'category':'truncated_distance12_source_screen','evidence':'Primary HTML full-document question screen and matched-context review.','limit':comparison,'source_index_id':'Lee2026Frames','dissertation_ids':['2025-Morris']})
    manifest.append({'paper_id':'F91','status':'retrieved','url':url,'sha256':digest,'local_file':str(raw.relative_to(R)),'extracted_text_file':str(text.relative_to(R)),'extracted_text_sha256':sha(text),'hash_scope':'Original version-stamped arXiv HTML bytes','retrieved_on':DATE})
    coverage.append({'paper_id':'F91','title':title,'url':url,'coverage_status':'full_text_screened','note':version+'; full-document lexical question screen and all matched-context review; not a proof-correctness audit.','recorded_target_ids':ids,'target_count':len(ids),'review_result':'Three fixed mathematical targets and three broad directions harvested; introduction design question already addressed by the paper is not duplicated as open.'})
    index['sources'].append({'id':'Lee2026Frames','title':title,'authors':['Jong Yeon Lee'],'date_or_version':version,'url':url,'access':'full_text','locator':'Sections IV.4, VI and Appendices A.4/C.3','relationship':'Issue1 primary comparison and question harvesting.','comparison_limit':comparison,'record_kind':'academic_source','bibliography_id':'F91','checked_on':DATE,'related_target_ids':['L-F25-distance-preservation'],'provenance_ledger':LEDGER,'question_screening':{'status':'full_text_screened','screen_date':DATE,'target_count':len(ids),'audit':LEDGER,'target_ids':ids}})
    index['checked_on']=DATE
    extension={'id':EXT,'checked_on':DATE,'summary':'One new primary paper screened; three fixed mathematical questions and three broad directions harvested. No canonical target completion.','baseline':baseline,'added_target_ids':ids,'added_paper_ids':['F91'],'added_entries':6,'added_eligible_targets':3,'new_paper_records':1,'full_text_screens_added':1,'completed_targets_added':0,'incomplete_paper_records_added':0,'report':LEDGER}
    rec['indexing_extensions'].append(extension);rec['central_source_records']=len(index['sources'])
    ledger={'checked_on':DATE,'canonical_target_id':'L-F25-distance-preservation','bounded_followup_id':'RQ-F25-truncated-distance-12','screens':[{'paper_id':'F25','url':'https://arxiv.org/html/2503.07567v1','source_sha256':sha(raw.parent/'RDV2025.html'),'status':'rechecked_existing_full_text_screen','target_ids':['L-F25-distance-preservation','L-F25-general-protographs','L-F25-hardware-entries'],'additional_targets':0,'comparison':'Equation9 and Sections V-B/VI rechecked. The source asks for full equality; the truncated bound and strengthened tests are our derived follow-up.'},{'paper_id':'F91','url':url,'source_sha256':digest,'text_sha256':sha(text),'text_lines':len(text.read_text().splitlines()),'status':'full_text_screened','method':'Lexical screen of all text for questions, conjectures, future directions and unresolved statements; introductions, discussion and all matched contexts inspected; later same-text statements checked.','target_ids':ids,'comparison':comparison,'correctness_audit':False}],'cohort_delta':extension,'limits':'Question harvesting is separate from current-resolution and Lean audits. Other search-result excerpts are discovery leads only.'}
    save(LEDGER,ledger)
    for name,value in [('literature/open-problems.json',claims),('planning/current-difficulty-estimates.json',plans),('literature/followups.json',papers),('literature/downstream-source-manifest.json',manifest),('literature/downstream-paper-coverage.json',coverage),('literature/research-source-index.json',index),('literature/research-reconciliation.json',rec)]:save(name,value)
    summary=load('planning/current-difficulty-summary.json')
    for k in ['entries','gated_entries','unassessed_added_entries']:summary[k]+=6
    for k in ['eligible_targets','eligible_gated_entries']:summary[k]+=3
    for k in ['statement_tiers','conditional_proof_tiers']:summary[k]['hold']+=3
    summary['checked_on']=DATE;save('planning/current-difficulty-summary.json',summary)
    print({'entries':len(claims),'eligible':sum(x['eligible_for_coverage'] for x in claims),'papers':len(coverage),'new_lean_completions':0})
