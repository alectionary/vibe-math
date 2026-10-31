"""One-time, explicit source/question-accounting delta for the eight-hour block."""
from pathlib import Path
import hashlib, json

ROOT=Path(__file__).resolve().parents[3]
C16=Path('formalization/canonical-width/c16')
L=C16/'two-basis-results/literature'
DAY='2026-10-30'
def read(p):return json.loads((ROOT/p).read_text())
def write(p,d):(ROOT/p).write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n')
def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()

def main():
    papers=read('literature/followups.json');coverage=read('literature/downstream-paper-coverage.json')
    manifest=read('literature/downstream-source-manifest.json');index=read('literature/research-source-index.json')
    targets=read('literature/open-problems.json');planning=read('planning/current-difficulty-estimates.json')
    reconciliation=read('literature/research-reconciliation.json')
    assert len(targets)==424 and len(coverage)==205 and len(index['sources'])==133
    assert not any(p['id'] in ['F174','F175','F176','F177'] for p in papers)
    rows=[
      ('F174','Simple push-relabel algorithms for matroids and submodular flows',
       ['András Frank','Zoltán Miklós'],2012,'https://andrasfrank.web.elte.hu/cikkek/FrankJ62.PDF',
       'Author manuscript dated 11 January 2012; Japan Journal of Industrial and Applied Mathematics29(3),419–439; DOI10.1007/s13160-012-0076-y',
       'frank-miklos-2012','frank-miklos-2012-fulltext-screen.json',
       'All15pages read. Section3 supplies the exact rational basis-mixture push–relabel method. The question in Section6.2 is answered by the paper itself; no unresolved question or future direction was found.'),
      ('F175','A New Strategy for Push-Relabel Algorithm Framework for Matroid Optimization',
       ['Emanuel Florentin Olariu'],2013,'https://publications.info.uaic.ro/files/tr/tr13-01.pdf',
       'Technical report TR13-01, June2013,6PDFpages',
       'olariu-2013','olariu-2013-fulltext-screen.json',
       'All6pages read. One historical direction asks to adapt the lowest-level/BFS strategy to submodular flow. The later primary TR13-02 explicitly supplies that adaptation, so this passage is not added as an unresolved inventory target.'),
      ('F176','A simple push-relabel algorithm for sub-modular flows',
       ['Cristian Frasinaru','Emanuel F. Olariu'],2013,'https://publications.info.uaic.ro/files/tr/tr13-02.pdf',
       'Technical report TR13-02, October2013,7PDFpages',
       'frasinaru-olariu-2013-tr13-02','tr13-02-fulltext-screen.json',
       'All7pages read. Sections4–5 address the earlier TR13-01 adaptation direction. Section6 contains two linked broad directions concerning smallest tight sets and an O(n²m) feasibility method. Their present-day status and Lean discovery remain unassessed.'),
      ('F177','A Lowest Level Rule Push-Relabel Algorithm for Submodular Flows and Matroid Optimization',
       ['Emanuel F. Olariu','Cristian Frasinaru'],2014,'https://doi.org/10.1109/SYNASC.2014.21',
       'SYNASC2014,97–102; Crossref conference publication date September2014; IEEE document7034671',
       None,'olariu-direction-followup-resolution.json',
       'Institutional author bibliography and DOI registrar metadata inspected. Proceedings full text was not acquired or question-screened; the earlier primary TR13-02 supplies the resolution evidence actually used.')]
    newids=['L-F176-avoid-smallest-tight-sets','L-F176-simpler-submodular-flow']
    for pid,title,authors,year,url,version,stem,screen,note in rows:
        ledger=str(L/screen);full=stem is not None;own=newids if pid=='F176' else []
        papers.append(dict(id=pid,title=title,authors=authors,year=year,url=url,dissertation_ids=[],seed_dissertation_ids=[],
            record_kind='article_or_preprint',category='c16_exact_matroid_membership_methods',checked_on=DAY,
            evidence=note,limit='No C16 source answer or implemented asymptotic runtime bound follows. Printed algorithm details and scope are audited separately.',
            source_screening=ledger,temporal_relation='established_predecessor',date_or_version=version,
            retrieval_status='full_text_retrieved' if full else 'metadata_only_full_text_unverified'))
        coverage.append(dict(paper_id=pid,title=title,url=url,coverage_status='full_text_screened' if full else 'metadata_or_selected_passages_only',
            note=note,recorded_target_ids=own,target_count=len(own) if full else None,
            review_result='questions_recorded' if own else 'full_text_no_additional_unresolved_targets' if full else 'full_text_pending_unassessed',
            source_screening=ledger))
        if full:
            pdf=L/(stem+'.pdf');text=L/(stem+'.txt')
            assert (ROOT/pdf).exists() and (ROOT/text).exists()
            manifest.append(dict(paper_id=pid,requested_url=url,resolved_url=url,status='retrieved',content_type='application/pdf',
                sha256=sha(pdf),local_file=str(pdf),text_file=str(text),text_sha256=sha(text),
                text_characters=len((ROOT/text).read_text()),extraction_method='pypdf plus complete primary web extraction and rendered-page checks where formulas were ambiguous',
                retrieved_on=DAY,checked_on=DAY,access_note=note))
        else:
            manifest.append(dict(paper_id=pid,requested_url=url,resolved_url=url,status='metadata_only',content_type=None,
                sha256=None,local_file=None,text_characters=None,extraction_method=None,retrieved_on=None,checked_on=DAY,access_note=note))
        index['sources'].append(dict(id=pid,title=title,authors=authors,date_or_version=version,url=url,
            record_kind='academic_source',bibliography_id=pid,access='full_text_screened' if full else 'metadata_or_selected_passages_only',
            locator=note,relationship='Exact matroid-membership method and its later strategy variants; methodological comparison for the C16 conditional-rank problem.',
            comparison_limit='Only named source versions were read. No C16 theorem, full two-basis membership or practical operation bound is inferred from the cited algorithm.',
            related_target_ids=['L-F91-c16-unrestricted-width',*own],provenance_ledger=ledger,
            question_screening=dict(status='full_text_screened' if full else 'not_assessed',target_ids=own,ledger=ledger),checked_on=DAY))
    source_sha=sha(L/'frasinaru-olariu-2013-tr13-02.pdf')
    titles=['Avoid explicitly computing smallest tight sets in a submodular-flow feasibility algorithm.',
            'Develop a simpler O(n²m) submodular-flow feasibility algorithm, at least for specified network classes.']
    for identifier,title in zip(newids,titles):
        occurrence=dict(source_id='F176',locator='Section6 Conclusions, printedp6/PDFp7',pdf_pages=[7],
            url=rows[2][4],source_sha256=source_sha,version=rows[2][5],relation='explicit_research_direction',extracted_text_lines=[263,274])
        gate='Specify the network class, submodular oracle model, tight-set computation and the meaning of the complexity comparison; check later resolution before selecting a proof target.'
        target=dict(id=identifier,origin='article_inventory_extension',title=title,kind='research_direction',
            written_math_status='research_direction_or_formulation_gate',eligible_for_coverage=False,
            eligibility_note='Broad historical algorithmic direction without a fixed theorem/oracle model; excluded from the precise-target denominator.',
            occurrences=[occurrence],related_target_ids=[j for j in newids if j!=identifier],status_as_of_source='open_or_proposed_in_source',
            proof_assistant_statement_status='not_assessed_in_this_extension',lean_statement_status='not_assessed_in_this_extension',
            lean_proof_status='not_assessed_in_this_extension',current_resolution_status='not_independently_established',added_on=DAY,
            search_family='c16_exact_matroid_membership_methods',source_screening=str(L/'tr13-02-fulltext-screen.json'),
            formalization_suitability=dict(assessment='not_assessed',objects_and_gate=gate))
        targets.append(target)
        planning.append(dict(target_id=identifier,title=title,eligible_for_coverage=False,current_resolution_status=target['current_resolution_status'],
            lean_statement_status=target['lean_statement_status'],lean_proof_status=target['lean_proof_status'],assessment_date=DAY,
            confidence='low',discovery_time_estimate=None,source_occurrences=target['occurrences'],
            basis='Dated full-text author-direction extraction only; present-day resolution and Lean-discovery searches not assessed.',
            background_evidence=[target['source_screening']],gate=gate,completed=False,research_status='planning_not_yet_assessed',
            family='c16_exact_matroid_membership_methods',rationale='Source accounting only; active research remains on the existing C16 width target.',
            first_milestone=gate,research_obstacle=None,statement_setup=None,proof_transfer_given_correct_complete_proof=None))
    delta=dict(id='c16-push-relabel-source-screening-20261030',checked_on=DAY,
        baseline=dict(canonical_entries=424,eligible_targets=160,paper_records=205,full_text_screens=165,verified_complete_lean_targets=6),
        added_target_ids=newids,added_paper_ids=[r[0] for r in rows],added_entries=2,added_eligible_targets=0,
        new_paper_records=4,full_text_screens_added=3,incomplete_paper_records_added=1,completed_targets_added=0,
        report=str(L/'canonical-source-accounting.json'),
        summary='Three full primary texts screened and one later proceedings metadata record. Two broad TR13-02 directions are inventoried without current-resolution or Lean claims. TR13-01 adaptation is addressed in TR13-02 and is not added as an open target. Frank–Miklós Section6.2 question is answered within its own paper.')
    reconciliation['indexing_extensions'].append(delta);reconciliation['central_source_records']=len(index['sources']);index['checked_on']=DAY
    accounting=dict(status='CANONICAL_SOURCE_QUESTION_ACCOUNTING_RECONCILED',source_C16_answered=False,delta=delta,
        excluded_resolved_passages=[dict(source_id='F174',locator='Section6.2',reason='Question answered within the same paper by reduction.',ledger=str(L/'frank-miklos-2012-fulltext-screen.json')),
            dict(source_id='F175',locator='Conclusion',reason='Lowest-level/BFS submodular-flow adaptation addressed by later primary TR13-02.',ledger=str(L/'olariu-direction-followup-resolution.json'))],
        final_cohort=dict(canonical_entries=426,eligible_targets=160,paper_records=209,full_text_screens=168,verified_complete_lean_targets=6,central_source_records=137),
        limits='No new mathematical resolution or Lean completion. New directions are unassessed; F177 full text is unverified. Historical immutable acquisition manifests retain their original pending-screen fields; later full-text-screen receipts provide the completed reading status.')
    write(L/'canonical-source-accounting.json',accounting)
    for path,data in [('literature/followups.json',papers),('literature/downstream-paper-coverage.json',coverage),
        ('literature/downstream-source-manifest.json',manifest),('literature/research-source-index.json',index),
        ('literature/open-problems.json',targets),('planning/current-difficulty-estimates.json',planning),
        ('literature/research-reconciliation.json',reconciliation)]:write(path,data)
    summary=read('planning/current-difficulty-summary.json');summary['checked_on']=DAY
    for k in ['entries','gated_entries','unassessed_added_entries']:summary[k]+=2
    write('planning/current-difficulty-summary.json',summary)
    print(accounting['final_cohort'])
if __name__=='__main__':main()
