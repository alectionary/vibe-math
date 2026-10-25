"""Integrate the primary texts actually screened in this research block.

Bookkeeping only: this does not certify current resolution or mathematical claims.
Run once; reruns refuse to duplicate the recorded extension.
"""
from pathlib import Path
import copy, hashlib, json

R = Path(__file__).resolve().parents[2]
W = Path(__file__).resolve().parent
LEDGER = 'literature/distance-preservation-source-screening.json'
DATE = '2026-10-24'
EXT = 'distance-preservation-sources-2026-10-24'
def read(p): return json.loads((R/p).read_text())
def write(p, x): (R/p).write_text(json.dumps(x, indent=2, ensure_ascii=False)+'\n')
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()

papers = [
 dict(id='F86', arxiv='2607.28795v1', title='High-rate qLDPC processors',
      authors=['Aditya Bhardwaj','Muzhou Ma','Nadine Meister','Robbie King','Dolev Bluvstein','John Preskill','Madelyn Cain','Qian Xu','Hsin-Yuan Huang'],
      version='arXiv:2607.28795v1, 30 July 2026; internal manuscript date 24 August 2026',
      source_index_id='BhardwajEtAl2026Processors',
      comparison='Appendix G, Theorem 8 and Lemmas 5–6 give an upper bound under full binary row rank. Remark 12 shows the rank premise cannot generally be dropped. This is not the lower bound needed for equality in F25; fully populated monomial 3x4 bases are rank deficient at augmentation.',
      targets=[
       ('surgery-cost','Reduce the spacetime cost of mitten-code surgery gadgets.','Section VIII',936,936),
       ('structured-decoding','Develop faster and more effective decoders exploiting mitten-code structure.','Section VIII',936,936),
       ('superconducting-routing','Improve superconducting on-chip routing for mitten-code syndrome extraction and logical operations.','Section VIII',936,936),
       ('atom-movement','Improve atom-array movement and syndrome-extraction strategies, including moving data, GHZ ancillas or different transport.','Section VIII and Appendix J',936,936),
       ('experimental-processors','Demonstrate high-rate qLDPC processors experimentally using the proposed small-block codes.','Section VIII',936,936),
       ('teraquop-certification','Assess and certify teraquop-scale processing capacity for higher-distance mitten codes.','Section VIII',932,932),
       ('beam-decoder-comparison','Compare the telescoping and beam-search decoders on the same detector error models.','Appendix I.B',7696,7696),
       ('atom-loss','Determine achievable qLDPC performance with loss-aware decoding under realistic atom loss.','Appendix I.C',7997,7997)]),
 dict(id='F87', arxiv='2603.22532v2', title='Distance-Finding Algorithms for Quantum Codes and Circuits',
      authors=['Mark Webster','Abraham Jacob','Oscar Higgott'],
      version='arXiv:2603.22532v2, 14 August 2026; first submitted 23 March 2026',
      source_index_id='WebsterJacobHiggott2026Distance',
      comparison='Exact connected-cluster, MIP, SAT and Brouwer–Zimmermann methods versus heuristic upper-bound methods. Supports method selection and evidence labels; does not give F25 base constraints or certify our inputs.',
      targets=[
       ('qdistevol-refinement','Refine QDistEvol and implement it in C using asymptotically optimal Gaussian elimination.','Section 6',8747,8747),
       ('faster-bposd','Develop a faster BP-OSD implementation and assess its competitiveness with random information-set distance searches.','Section 6',8749,8749)]),
 dict(id='F88', arxiv='2605.16523v1', title='End-to-End Formalization of Quantum Error Correction',
      authors=['Mattias Ehatamm','Yi Lee','Xiaodi Wu','Runzhou Tao'],
      version='arXiv:2605.16523v1, 15 May 2026',
      source_index_id='EhatammEtAl2026LeanQEC',
      comparison='Verified CSS-to-SAT translation and concrete BB/GB distance certificates, with binary-symplectic/stabilizer bridge. The public README and paper were inspected; the repository was not built or axiom-audited here. No exact F25 LP-distance preservation theorem was identified in these inspected materials.',
      targets=[
       ('solver-scaling','Extend distance-certificate scaling through decomposition and solvers specialized to linear codes.','Section 6.3',7360,7375),
       ('non-css','Extend the verified distance framework to general non-CSS stabilizer codes.','Section 6.3',7376,7388),
       ('subsystem','Extend the formalization to subsystem codes and the broader stabilizer formalism.','Section 6.3',7376,7388),
       ('verified-row-reduction','Implement verified row reduction for kernel-basis computation in the Lean-QEC preprocessing pipeline.','Section 6.3',7388,7392),
       ('circuit-integration','Connect the QEC layer to verified circuit compilers such as SQIR.','Section 6.3',7393,7397),
       ('gate-calculus','Develop a richer verified gate-level quantum-circuit calculus.','Section 3',1065,1071)]),
 dict(id='F89', arxiv='2607.28621v1', title='Lifting Lifted Product Codes',
      authors=['Yuta Hirasaki','Jong Yeon Lee'],
      version='arXiv:2607.28621v1, 30 July 2026; internal manuscript date 24 August 2026',
      source_index_id='HirasakiLee2026Lifting',
      comparison='Section II and Corollary 6 describe compatible group-extension lifts and chain/cochain transfer. For odd lift index, d_lift<=t*d_base; the reverse inequality stated there additionally assumes unchanged logical dimension. This does not settle our classical-distance versus quantum-distance equality question. Our candidate family has growing logical dimension.',
      discovery='https://x.com/hira920/status/2083186108079153284',
      targets=[
       ('inherited-logicals','Describe inherited and newly created logical degrees of freedom under lifts, including even-index lifts.','Section VI',8483,8489),
       ('gadget-distance','Determine how inherited logical-operation gadgets preserve distance under lifting.','Section VI',8490,8518),
       ('operation-transfer','Determine when transversal gates, homomorphic CNOTs and measurements, or code switching transfer to lifts.','Section VI',8490,8518),
       ('thermodynamic-branches','Find geometric and homological conditions selecting lift branches with common thermodynamic behavior.','Section V remark and Section VI',8420,8467),
       ('decoder-transfer','Determine whether useful decoders transfer from a base LP code to its lifts.','Section VI',8536,8543),
       ('hardware-transfer','Determine whether hardware-efficient implementations transfer from base codes to lifts.','Section VI',8536,8543),
       ('other-code-families','Extend the lifting construction to other high-rate group-algebra codes and quantum Tanner codes.','Section VI',8544,8560),
       ('general-nontransversal-surgery','Develop systematic nontransversal surgery constructions for general qLDPC codes without an underlying lifted structure.','Section IV',6874,6879)])]

if __name__ == '__main__':
 rec=read('literature/research-reconciliation.json')
 if any(x['id']==EXT for x in rec['indexing_extensions']):
  raise SystemExit('Source extension already integrated; edit its records explicitly instead of duplicating it.')
 claims=read('literature/open-problems.json'); plans=read('planning/current-difficulty-estimates.json')
 follows=read('literature/followups.json'); manifest=read('literature/downstream-source-manifest.json')
 coverage=read('literature/downstream-paper-coverage.json'); index=read('literature/research-source-index.json')
 ids=[]; screens=[]
 for p in papers:
  pid=p['id']; url='https://arxiv.org/html/'+p['arxiv']; raw=W/'sources'/(p['arxiv']+'.html'); txt=W/'sources'/(p['arxiv']+'.txt')
  assert raw.stat().st_size>100000 and len(txt.read_text().splitlines())>1000
  assert not any(x['id']==pid for x in follows)
  digest=sha(raw); targetids=[]
  for slug,title,locator,first,last in p['targets']:
   tid=f'L-{pid}-{slug}';ids.append(tid);targetids.append(tid)
   occurrence=dict(source_id=pid,locator=locator,extracted_text_lines=[first,last],url=url,
                   source_sha256=digest,relation='explicit_broad_research_or_engineering_direction',version=p['version'])
   x=dict(id=tid,origin='article_inventory_extension',title=title,kind='research_direction',
     written_math_status='research_direction',eligible_for_coverage=False,
     eligibility_note='Source-stated broad research/engineering direction; no complete fixed theorem or controlled experiment is specified. Excluded from the mathematical target denominator.',
     occurrences=[occurrence],related_target_ids=[],status_as_of_source='open_as_stated_in_source',
     proof_assistant_statement_status='not_assessed_in_this_extension',lean_statement_status='not_assessed_in_this_extension',
     lean_proof_status='not_assessed_in_this_extension',current_resolution_status='not_independently_established',
     search_family='distance_preservation_source_questions',added_on=DATE,
     lean_discovery_note='Full-text question harvesting only; current-resolution and exact-target Lean searches remain unassessed.')
   claims.append(x)
   template=copy.deepcopy(plans[-1]);template.update(target_id=tid,title=title,eligible_for_coverage=False,
    current_resolution_status=x['current_resolution_status'],lean_statement_status=x['lean_statement_status'],
    lean_proof_status=x['lean_proof_status'],assessment_date=DATE,source_occurrences=[occurrence],
    basis='New primary full-document target screen; current resolution, Lean discovery and effort unassessed.',
    background_evidence=[LEDGER],gate='Verify current status and freeze the complete mathematical or experimental interface before estimating effort.',
    family='distance_preservation_source_questions',research_status='planning_not_yet_assessed',completed=False,
    rationale='A historical research direction is not a current-resolution or difficulty assessment.',
    first_milestone='Verify current mathematical status and exact hypotheses.',research_obstacle=None,
    statement_setup=None,proof_transfer_given_correct_complete_proof=None)
   for key in ['selection_review','progress_note','progress_artifact','proof_branches']:template.pop(key,None)
   plans.append(template)
  if pid=='F86':
   claims[-5]['occurrences'].append(dict(claims[-5]['occurrences'][0],locator='Appendix J, syndrome-extraction timing model',extracted_text_lines=[8489,8490]))
   plans[-5]['source_occurrences']=copy.deepcopy(claims[-5]['occurrences'])
  if pid=='F89':
   claims[-5]['occurrences'].append(dict(claims[-5]['occurrences'][0],locator='Section VI, third direction',extracted_text_lines=[8519,8535]))
   plans[-5]['source_occurrences']=copy.deepcopy(claims[-5]['occurrences'])
  follows.append(dict(id=pid,title=p['title'],authors=p['authors'],url=url,year=2026,
    publication_status='inspected_preprint',date_or_version=p['version'],relationship='Distance-preservation investigation: primary comparison and question harvesting',
    source_screening=LEDGER,category='distance_preservation_source_screen',evidence='Primary HTML full-document question screen',
    limit=p['comparison'],source_index_id=p['source_index_id'],dissertation_ids=['2025-Morris']))
  manifest.append(dict(paper_id=pid,status='retrieved',url=url,sha256=digest,
    local_file=str(raw.relative_to(R)),extracted_text_file=str(txt.relative_to(R)),extracted_text_sha256=sha(txt),
    hash_scope='Original version-stamped arXiv HTML bytes',retrieved_on=DATE))
  coverage.append(dict(paper_id=pid,title=p['title'],url=url,coverage_status='full_text_screened',
    note=p['version']+'; full-document lexical target screen plus introduction/conclusion and matched-context review',
    recorded_target_ids=targetids,target_count=len(targetids),review_result='explicit_broad_directions_harvested'))
  index['sources'].append(dict(id=p['source_index_id'],title=p['title'],authors=p['authors'],date_or_version=p['version'],url=url,
    access='full_text',locator='Full-document target screen; relevant result comparison in source ledger',relationship='Distance-preservation investigation',
    comparison_limit=p['comparison'],record_kind='academic_source',bibliography_id=pid,checked_on=DATE,
    related_target_ids=['L-F25-distance-preservation'],provenance_ledger=LEDGER,
    question_screening=dict(status='full_text_screened',screen_date=DATE,target_count=len(targetids),audit=LEDGER,target_ids=targetids)))
  screens.append(dict(paper_id=pid,title=p['title'],version=p['version'],url=url,source_sha256=digest,
    text_sha256=sha(txt),text_lines=len(txt.read_text().splitlines()),status='full_text_screened',
    method='Searched all text for conjecture/question/unknown/future/remaining/direction terms; reviewed introduction, conclusion, relevant theorem proofs and all candidate contexts; checked later same-text resolution.',
    result='Broad directions extracted; no additional numbered conjecture identified.',target_ids=targetids,
    comparison=p['comparison'],discovery_source=p.get('discovery','Primary literature/code audit')))
 extension=dict(id=EXT,checked_on=DATE,summary='Four accessible primary papers screened during the F25 investigation; 24 broad directions harvested. No new eligible mathematical target or canonical completion.',
   baseline=dict(canonical_entries=295,eligible_targets=144,paper_records=119,full_text_screens=108,verified_complete_lean_targets=5),
   added_target_ids=ids,added_paper_ids=[p['id'] for p in papers],added_entries=len(ids),added_eligible_targets=0,
   new_paper_records=len(papers),full_text_screens_added=len(papers),completed_targets_added=0,incomplete_paper_records_added=0,report=LEDGER)
 rec['indexing_extensions'].append(extension);rec['central_source_records']=len(index['sources'])
 ledger=dict(checked_on=DATE,canonical_target_id='L-F25-distance-preservation',screens=screens,
   cohort_delta=extension,limits='These full-document question screens are not current-resolution searches for the newly harvested broad directions. Search-result-only leads are separately recorded in the prior-art ledger and do not count as screened papers.')
 write(LEDGER,ledger)
 for path,data in [('literature/open-problems.json',claims),('planning/current-difficulty-estimates.json',plans),
   ('literature/followups.json',follows),('literature/downstream-source-manifest.json',manifest),
   ('literature/downstream-paper-coverage.json',coverage),('literature/research-source-index.json',index),
   ('literature/research-reconciliation.json',rec)]:write(path,data)
 summary=read('planning/current-difficulty-summary.json')
 for key in ['entries','gated_entries','unassessed_added_entries']:summary[key]+=len(ids)
 write('planning/current-difficulty-summary.json',summary)
 print(dict(entries=len(claims),eligible=sum(x['eligible_for_coverage'] for x in claims),papers=len(coverage),new_directions=len(ids)))
