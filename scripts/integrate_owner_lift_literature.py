"""Dated owner-lift source accounting; acquisition and integration are separate gates.

Author-owned HTML/text stay in ignored local-extraction/. No solver or GitHub writes.
"""
from pathlib import Path
from html.parser import HTMLParser
from datetime import datetime, timezone
import argparse, hashlib, json, os, subprocess, sys, urllib.request

ROOT = Path(__file__).resolve().parents[1]
REPORT = Path('literature/owner-lift-20261030')
LOCAL = Path('local-extraction/owner-lift-20261030')
DAY = '2026-10-30'
SOURCES = [
    ('F178', 'A Discrete Convex Min-Max Formula for Box-TDI Polyhedra',
     ['András Frank', 'Kazuo Murota'], 2021, 'https://arxiv.org/html/2007.03507v3',
     'arXiv:2007.03507v3, 27 January 2021; DOI10.1287/moor.2021.1160', True),
    ('F179', 'Matroid bases with cardinality constraints on the intersection',
     ['Stefan Lendl', 'Britta Peis', 'Veerle Timmermans'], 2022,
     'https://pmc.ncbi.nlm.nih.gov/articles/PMC9237001/',
     'Publisher full text, online29 March2021, issue2022; Mathematical Programming194,661–684; DOI10.1007/s10107-021-01642-1', True),
    ('F180', 'Decreasing Minimization on Base-Polyhedra: Relation Between Discrete and Continuous Cases',
     ['András Frank', 'Kazuo Murota'], 2022, 'https://arxiv.org/html/2202.06561v2',
     'arXiv:2202.06561v2, 12 April2022', False),
    ('F181', 'A Generalized-Polymatroid Approach to Disjoint Common Independent Sets in Two Matroids',
     ['Kenjiro Takazawa', 'Yu Yokoi'], 2019, 'https://arxiv.org/html/1805.05528v3',
     'arXiv:1805.05528v3, 28 January2019', False),
]

def read(p):
    return json.loads((ROOT / p).read_text())

def write(p, value):
    path = ROOT / p
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False) + '\n')

def sha(p):
    return hashlib.sha256((ROOT / p).read_bytes()).hexdigest()

class Text(HTMLParser):
    def __init__(self):
        super().__init__()
        self.parts = []; self.skip = 0
    def handle_starttag(self, tag, attrs):
        if tag in ('script', 'style'): self.skip += 1
        if tag in ('p', 'div', 'section', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'li', 'tr'): self.parts.append('\n')
    def handle_endtag(self, tag):
        if tag in ('script', 'style'): self.skip -= 1
        if tag in ('p', 'div', 'section', 'li', 'tr'): self.parts.append('\n')
    def handle_data(self, data):
        if not self.skip: self.parts.append(data)
    def result(self):
        return '\n'.join(' '.join(line.split()) for line in ''.join(self.parts).splitlines() if line.strip()) + '\n'

def acquire():
    assert not (ROOT / REPORT / 'acquisition.json').exists(), 'Immutable acquisition already exists'
    records = []; attempts = []
    for pid, title, authors, year, url, version, full in SOURCES:
        request = urllib.request.Request(url, headers={'User-Agent': 'Research source preservation; Python urllib'})
        started = datetime.now(timezone.utc).isoformat()
        with urllib.request.urlopen(request, timeout=45) as response:
            data = response.read(); resolved = response.url; headers = dict(response.headers.items()); status = response.status
        html = LOCAL / (pid + '.html'); txt = LOCAL / (pid + '.txt')
        (ROOT / LOCAL).mkdir(parents=True, exist_ok=True)
        (ROOT / html).write_bytes(data)
        parser = Text(); parser.feed(data.decode('utf-8')); text = parser.result()
        if not (len(text) > 15000 and 'References' in text and title[:25] in text):
            rejected = LOCAL / (pid + '.rejected.html'); (ROOT / rejected).write_bytes(data)
            attempts.append(dict(paper_id=pid, requested_url=url, resolved_url=resolved,
                http_status=status, status='REJECTED_NOT_FULL_TEXT', local_file=str(rejected),
                sha256=sha(rejected), text_characters=len(text), retrieved_at_utc=started))
            write(REPORT / 'retrieval-attempts.json', attempts)
            assert pid == 'F179', (pid, len(text))
            fallback = 'https://www.ebi.ac.uk/europepmc/webservices/rest/PMC9237001/fullTextXML'
            with urllib.request.urlopen(fallback, timeout=45) as response:
                data=response.read(); resolved=response.url; headers=dict(response.headers.items()); status=response.status
            html = LOCAL / (pid + '.xml'); (ROOT / html).write_bytes(data)
            parser=Text(); parser.feed(data.decode('utf-8')); text=parser.result()
            assert len(text)>15000 and 'References' in text and title[:25] in text, (pid,len(text))
        (ROOT / txt).write_text(text)
        records.append(dict(paper_id=pid, requested_url=url, resolved_url=resolved, status='retrieved',
            http_status=status, response_headers=headers, retrieved_at_utc=started,
            content_type='application/xml' if html.suffix=='.xml' else 'text/html', sha256=sha(html), local_file=str(html), text_file=str(txt),
            text_sha256=sha(txt), text_characters=len(text), text_lines=len(text.splitlines()),
            extraction_method='stdlib HTMLParser, script/style removed; MathML/TeX retained in original HTML',
            full_text_question_screen=full, copyright_scope='Author-owned full text remains in ignored local-extraction; metadata and short paraphrase screens are versioned'))
        print(pid, len(data), len(text), flush=True)
    write(REPORT / 'acquisition.json', dict(status='PRIMARY_HTML_XML_ACQUIRED', acquired_on=DAY,
        source_records=records, priority=os.getpriority(os.PRIO_PROCESS, 0),
        limits='Acquisition of a full text is not a full-text question screen. Only F178/F179 were completely screened.'))

def integrate():
    acquisition=read(REPORT/'acquisition.json'); raw={r['paper_id']:r for r in acquisition['source_records']}
    papers=read('literature/followups.json'); coverage=read('literature/downstream-paper-coverage.json')
    manifest=read('literature/downstream-source-manifest.json'); index=read('literature/research-source-index.json')
    targets=read('literature/open-problems.json'); planning=read('planning/current-difficulty-estimates.json')
    rec=read('literature/research-reconciliation.json'); exclusions=read('literature/downstream-exclusions.json')
    assert (len(targets),len(coverage),len(index['sources']))==(426,209,137)
    assert not {r[0] for r in SOURCES}&{p['id'] for p in papers}
    for r in raw.values():
        assert sha(r['local_file'])==r['sha256'] and sha(r['text_file'])==r['text_sha256']
    old_note=Path('formalization/canonical-width/c16/two-basis-results/owner-lift-remote-literature-screen.md')
    old_queue=old_note.with_name('owner-lift-remote-literature-queue.json')
    specs=[
      ('L-F178-m2-square-strong-polynomial','F178',True,
       'Find a strongly polynomial algorithm minimizing the ordinary sum of squares over a nonempty M2-convex set.',
       'Section1.2 final paragraph, following Theorems1.2–1.3', [394,409],
       'The source fixes the objective and the integral intersection of two base-polyhedra. Before implementation, make the supermodular evaluation-oracle and arithmetic model explicit; check later resolution and Lean evidence.'),
      ('L-F178-box-tdi-algorithms','F178',False,
       'Develop strongly polynomial combinatorial algorithms from discrete box-TDI min-max formulas.',
       'Introduction and Section5.3 final discussion', [159,164],
       'Choose a polyhedral subclass, objective and oracle/input model; the paper supplies a general algorithm-development program rather than one fixed theorem.'),
      ('L-F178-inverse-optimization-algorithms','F178',False,
       'Develop efficient or strongly polynomial inverse-optimization algorithms using the box-TDI framework.',
       'Section6 introduction and Remark6.5', [2030,2050],
       'Fix an inverse problem and representation, including bounded cost vectors, deviation from a box or linear deviation costs; audit prior algorithms before selecting a claim.'),
      ('L-F179-polymatroid-norm-constraints','F179',False,
       'Determine tractability of two-polymatroid-base cost minimization with an arbitrary-norm distance bound, especially the Euclidean norm.',
       'Section5, discussion following Theorem4', [298,300],
       'Specify the norm representation, submodular evaluation oracle, numerical data and exact-versus-approximate output. Preserve the Euclidean subcase and conjectured convex-optimization approach within this single question.')]
    ids=[s[0] for s in specs]
    notes={
      'F178':'Complete v3 HTML screened: abstract, introduction, Sections2–6, appendix and references. Three linked entries: one specific M2 algorithm question and two broad algorithm directions. Weighted M-convex quadratic minimization is recorded as later known solvable in F180 Remark4.4, not a new open target.',
      'F179':'Complete publisher text screened: introduction, Sections2–6, both appendices and references. One norm-generalization direction, including its Euclidean subcase. The recoverable-robust strongly-polynomial question is answered in this paper. Direct PMC acquisition failed; Europe PMC full-text XML was retained.',
      'F180':'Targeted reading of Remark4.4 and its cited context only. Later primary evidence says weighted discrete quadratic minimization over an integral base-polyhedron is known strongly polynomial. Complete HTML acquired, but complete question screening remains unassessed.',
      'F181':'Targeted reading of generalized-polymatroid/paramodularity and two-polyhedron intersection hypotheses only. Complete HTML acquired, but complete question screening remains unassessed; no zero-question conclusion or source-frame implication.'}
    screens=[]
    for pid,title,authors,year,url,version,full in SOURCES:
        own=[s[0] for s in specs if s[1]==pid]; ledger=str(REPORT/(pid+'-screen.json'))
        record=dict(paper_id=pid,title=title,version=version,url=url,checked_on=DAY,
            status='FULL_TEXT_QUESTION_SCREEN_COMPLETED' if full else 'TARGETED_PASSAGES_ONLY_FULL_SCREEN_PENDING',
            source_sha256=raw[pid]['sha256'],text_sha256=raw[pid]['text_sha256'],
            source_file=raw[pid]['local_file'],text_file=raw[pid]['text_file'],
            recorded_target_ids=own,target_count=len(own) if full else None,summary=notes[pid],
            prior_screen_note=str(old_note),prior_screen_sha256=sha(old_note),
            prior_screen_queue=str(old_queue),prior_screen_queue_sha256=sha(old_queue),
            scope='Version-specific explicit-question harvest; no guarantee of every implicit research opportunity and no correctness audit of the whole paper.')
        if full:
            sections=([('Abstract/introduction/Section1.1','Definitions and main results; broad algorithm aspiration.'),
              ('Section1.2','M2 algorithm question retained; weighted M-convex historical question linked to later known-solvability evidence.'),
              ('Section2','Box-TDI hypotheses and operations; no additional explicit outstanding target.'),
              ('Section3','General min-max results and proofs; no additional explicit outstanding target.'),
              ('Section4','Special polyhedra and dual construction conditional on an optimum; no new primal algorithm claim.'),
              ('Section5','Broad algorithm direction repeated; concrete-conjugate examples are covered in the appendix.'),
              ('Section6','Inverse-optimization algorithm direction retained; Remark6.4 extension is explained within the paper.'),
              ('Appendix/references','Concrete conjugate formulas supplied; references checked for source roles, not recursively fully screened.')]
              if pid=='F178' else [('Abstract/introduction','Historical recoverable-robust question answered by this paper.'),
              ('Section2','Cardinality inequalities reduced to matroid intersection.'),('Sections3–4','Algorithm and penalized variant; results presented as proved.'),
              ('Section5','Norm-bound question retained once, including Euclidean subcase and proposed convex approach.'),
              ('Section6','Three-or-more-matroid complexity results, no extra outstanding target recorded.'),
              ('AppendicesA–B/references','Independent matching reduction and omitted proof read; no additional explicit target; bibliography not recursively screened.')])
            record['section_by_section_screen']=[dict(section=a,outcome=b) for a,b in sections]
        write(ledger,record); screens.append(record)
        papers.append(dict(id=pid,title=title,authors=authors,year=year,url=url,dissertation_ids=[],seed_dissertation_ids=[],
            record_kind='article_or_preprint',category='c16_owner_lift_discrete_convex_methods',checked_on=DAY,
            evidence=notes[pid],limit='No C16 frame, cross-pattern integrality, runtime transfer or Lean completion follows.',
            source_screening=ledger,temporal_relation='established_predecessor',date_or_version=version,retrieval_status='full_text_retrieved'))
        coverage.append(dict(paper_id=pid,title=title,url=url,
            coverage_status='full_text_screened' if full else 'metadata_or_selected_passages_only',
            note=notes[pid],recorded_target_ids=own,target_count=len(own) if full else None,
            review_result='questions_recorded' if full else 'full_text_pending_unassessed',source_screening=ledger))
        m={k:raw[pid][k] for k in ('paper_id','requested_url','resolved_url','status','content_type','sha256','local_file','text_file','text_sha256','text_characters','extraction_method')}
        m.update(retrieved_on=DAY,checked_on=DAY,access_note=notes[pid]);manifest.append(m)
        index['sources'].append(dict(id=pid,title=title,authors=authors,date_or_version=version,url=url,
            record_kind='academic_source',bibliography_id=pid,
            access='full_text_screened' if full else 'metadata_or_selected_passages_only',locator=notes[pid],
            relationship='Primary methodological context for conditional owner lifts, with dated open-question and resolution evidence kept distinct.',
            comparison_limit='Two-base structure does not imply the extra cross-pattern system is box-TDI, integral, or a source frame.',
            related_target_ids=['L-F91-c16-unrestricted-width',*own],provenance_ledger=ledger,
            question_screening=dict(status='full_text_screened' if full else 'not_assessed',target_ids=own,ledger=ledger),checked_on=DAY))
    for identifier,pid,eligible,title,locator,lines,gate in specs:
        src=next(r for r in SOURCES if r[0]==pid)
        occ=dict(source_id=pid,locator=locator,url=src[4],source_sha256=raw[pid]['sha256'],version=src[5],
            relation='explicit_open_algorithm_question' if eligible else 'explicit_research_direction',extracted_text_lines=lines)
        target=dict(id=identifier,origin='article_inventory_extension',title=title,
            kind='question' if eligible else 'research_direction',
            written_math_status='precise_math_in_source' if eligible else 'research_direction_or_formulation_gate',
            eligible_for_coverage=eligible,eligibility_note=('Fixed square-sum objective and M2-convex domain identify a specific algorithmic task; present-day resolution and formalization remain unassessed.' if eligible else 'Broad algorithm/formulation program; excluded from precise-target denominator until its oracle, data and output model is fixed.'),
            occurrences=[occ],related_target_ids=[s[0] for s in specs if s[1]==pid and s[0]!=identifier],
            status_as_of_source='open_or_proposed_in_source',current_resolution_status='not_independently_established',
            proof_assistant_statement_status='not_assessed_in_this_extension',lean_statement_status='not_assessed_in_this_extension',
            lean_proof_status='not_assessed_in_this_extension',added_on=DAY,search_family='c16_owner_lift_discrete_convex_methods',
            source_screening=str(REPORT/(pid+'-screen.json')),screening_note='Source-open only. Bounded primary-source resolution searches did not establish a current resolution; this is not evidence that the problem remains open.',
            formalization_suitability=dict(assessment='not_assessed',objects_and_gate=gate))
        targets.append(target)
        planning.append(dict(target_id=identifier,title=title,eligible_for_coverage=eligible,current_resolution_status=target['current_resolution_status'],
            lean_statement_status=target['lean_statement_status'],lean_proof_status=target['lean_proof_status'],assessment_date=DAY,
            confidence='low',discovery_time_estimate=None,source_occurrences=[occ],
            basis='Dated full-text source-question accounting; no current-resolution, Lean-discovery or effort assessment claimed.',
            background_evidence=[target['source_screening']],gate=gate,completed=False,research_status='planning_not_yet_assessed',
            family='c16_owner_lift_discrete_convex_methods',rationale='Source accounting only; active research remains on C16.',
            first_milestone=gate,research_obstacle=None,statement_setup=None,proof_transfer_given_correct_complete_proof=None))
    resolved=[dict(paper_id='F178',locator='Section1.2 weighted M-convex square-sum question',
        reason='Later primary F180 Remark4.4 explicitly reports this weighted discrete quadratic problem as known strongly polynomial; retained as known-solvable follow-up, not a current open inventory addition.',
        evidence_source_id='F180',evidence_locator='Remark4.4',evidence_extracted_text_lines=[1814,1830],evidence_source_sha256=raw['F180']['sha256']),
      dict(paper_id='F178',locator='Section5.3 concrete-conjugate examples and Remark6.4',reason='The appendix supplies the concrete conjugates; Remark6.4 explains the multi-input extension. Neither is harvested as an unresolved question.'),
      dict(paper_id='F179',locator='Abstract/introduction and Section2',reason='The historical strongly polynomial recoverable-robust matroid question is answered in this paper; not added as currently open.')]
    exclusions.extend(resolved)
    delta=dict(id='c16-owner-lift-source-screening-20261030',checked_on=DAY,
        baseline=dict(canonical_entries=426,eligible_targets=160,paper_records=209,full_text_screens=168,verified_complete_lean_targets=6),
        added_target_ids=ids,added_paper_ids=[r[0] for r in SOURCES],added_entries=4,added_eligible_targets=1,
        new_paper_records=4,full_text_screens_added=2,incomplete_paper_records_added=2,completed_targets_added=0,
        report=str(REPORT/'ACCOUNTING.md'),summary='Two complete primary screens add one specific M2 square-minimization algorithm question and three broad directions. Two targeted-only follow-ups have null question counts. Weighted M-convex square minimization is known solvable according to later primary evidence; no new resolution or Lean completion is claimed.')
    rec['indexing_extensions'].append(delta); rec['central_source_records']=len(index['sources']); index['checked_on']=DAY
    accounting=dict(status='CANONICAL_OWNER_LIFT_SOURCE_QUESTION_ACCOUNTING_RECONCILED',delta=delta,
        duplicate_checks=dict(local_indexes=['followups.json','open-problems.json','research-source-index.json'],result='No preexisting source IDs/titles/identifiers found',github_fetch_manifest_search='Read-only exact identifier issue searches returned no existing manifests; no GitHub writes'),
        paper_screens=[dict(paper_id=s['paper_id'],status=s['status'],target_count=s['target_count']) for s in screens],
        excluded_or_resolved_passages=resolved,final_cohort=dict(canonical_entries=430,eligible_targets=161,paper_records=213,full_text_screens=170,central_source_records=141,verified_complete_lean_targets=6),
        source_C16_answered=False,limits='Prior read-only screen ledgers remain immutable. Full texts remain local; targeted acquisition does not upgrade screening. Current resolution of added targets and all Lean/difficulty searches remain unassessed.')
    write(REPORT/'accounting.json',accounting)
    for path,data in [('literature/followups.json',papers),('literature/downstream-paper-coverage.json',coverage),
        ('literature/downstream-source-manifest.json',manifest),('literature/research-source-index.json',index),
        ('literature/open-problems.json',targets),('planning/current-difficulty-estimates.json',planning),
        ('literature/research-reconciliation.json',rec),('literature/downstream-exclusions.json',exclusions)]:write(path,data)
    summary=read('planning/current-difficulty-summary.json'); summary['checked_on']=DAY
    for k in ['entries','gated_entries','unassessed_added_entries']: summary[k]+=4
    for k in ['eligible_targets','eligible_gated_entries']: summary[k]+=1
    for k in ['statement_tiers','conditional_proof_tiers']: summary[k]['hold']+=1
    write('planning/current-difficulty-summary.json',summary)
    print(json.dumps(accounting['final_cohort']))

def validate():
    logdir=ROOT/REPORT/'checks';logdir.mkdir(parents=True,exist_ok=True)
    # Preserve the first failed supplemental run before refreshing generated reports.
    if (logdir/'validate_difficulty.py.log').exists() and not (ROOT/REPORT/'attempt-v1').exists():
        (ROOT/REPORT/'attempt-v1').mkdir()
        for p in logdir.glob('*.log'):
            (ROOT/REPORT/'attempt-v1'/p.name).write_bytes(p.read_bytes())
    commands=['build_literature_report.py','build_research_reconciliation.py','build_open_problem_report.py',
        'build_current_difficulty_report.py','validate_literature.py','validate_open_problems.py',
        'validate_current_difficulty.py','validate_research_question_screening.py','validate_difficulty.py']
    results=[]
    for name in commands:
        p=subprocess.run([sys.executable,'-B',str(ROOT/'scripts'/name)],cwd=ROOT,capture_output=True,text=True)
        log=REPORT/'checks'/(name+'.log');(ROOT/log).write_text(p.stdout+p.stderr)
        results.append(dict(script='scripts/'+name,source_sha256=sha('scripts/'+name),exit_code=p.returncode,
            log=str(log),log_sha256=sha(log)))
        print(name,p.returncode,flush=True)
    # This generator retains a stale prose count from its historical template.
    report=ROOT/'literature/README.md';text=report.read_text()
    text=text.replace('covers all 187 inventory entries, including six additions explicitly awaiting assessment',
        'covers all 430 inventory entries, with new source-question additions explicitly awaiting assessment')
    report.write_text(text)
    by={r['id']:r for r in read('literature/open-problems.json')}
    coverage={r['paper_id']:r for r in read('literature/downstream-paper-coverage.json')}
    manifest={r['paper_id']:r for r in read('literature/downstream-source-manifest.json')}
    source_records=read('literature/research-source-index.json')['sources'];index={r['id']:r for r in source_records}
    acc=read(REPORT/'accounting.json'); delta=acc['delta']
    assert sum(by[i]['eligible_for_coverage'] for i in delta['added_target_ids'])==1
    assert all(by[i]['current_resolution_status']=='not_independently_established' for i in delta['added_target_ids'])
    assert all(by[i]['lean_proof_status']=='not_assessed_in_this_extension' for i in delta['added_target_ids'])
    assert len(by)==430 and sum(x['eligible_for_coverage'] for x in by.values())==161
    assert len(coverage)==213 and len(source_records)==141
    assert sum(r['coverage_status'].endswith('full_text_screened') for r in coverage.values())==170
    assert sum(r['lean_proof_status']=='verified_complete_lean_proof' and r['eligible_for_coverage'] for r in by.values())==6
    for pid,*_ in SOURCES:
        r=manifest[pid]; assert sha(r['local_file'])==r['sha256'] and sha(r['text_file'])==r['text_sha256']
        assert coverage[pid]['target_count']==({'F178':3,'F179':1}.get(pid))
        for row in by.values():
            for occurrence in row['occurrences']:
                if occurrence['source_id']==pid:
                    a,b=occurrence['extracted_text_lines'];assert 1<=a<=b<=len((ROOT/r['text_file']).read_text().splitlines())
                    assert occurrence['source_sha256']==r['sha256']
    head=lambda p:json.loads(subprocess.check_output(['git','show','HEAD:'+p],cwd=ROOT,text=True))
    old_sources=head('literature/research-source-index.json')['sources']
    old_by={r['id']:r for r in head('literature/open-problems.json')}
    old_plan=head('planning/difficulty-estimates.json')
    mismatches=[r['claim_id'] for r in old_plan if r['related_target_ids']!=old_by[r['claim_id']]['related_target_ids']]
    assert mismatches and all(by[i]['related_target_ids']==old_by[i]['related_target_ids'] for i in mismatches)
    assert len(old_sources)==137 and len({r['id'] for r in old_sources})==136
    assert source_records[:137]==old_sources
    preexisting=dict(historical_difficulty_related_id_mismatches=mismatches,
        supplemental_validator='scripts/validate_difficulty.py',supplemental_exit_code=results[-1]['exit_code'],
        duplicate_source_id='OkadaKasai2026',source_records_before=137,distinct_source_ids_before=136,
        source_records_after=141,distinct_source_ids_after=140,
        provenance='Compared with current HEAD; all preexisting source rows and affected canonical relationship lists are unchanged.',
        initial_own_assertion_failure='The first supplemental controller asserted source ID uniqueness by collapsing to a dictionary; corrected to distinguish record count from preexisting duplicate ID. No ledger data changed to hide the duplicate.')
    write(REPORT/'preexisting-gaps.json',preexisting)
    files=['literature/followups.json','literature/downstream-paper-coverage.json','literature/downstream-source-manifest.json',
        'literature/research-source-index.json','literature/open-problems.json','literature/research-reconciliation.json',
        'literature/downstream-exclusions.json','planning/current-difficulty-estimates.json','planning/current-difficulty-summary.json',
        'literature/README.md','literature/summary.json','literature/RESEARCH-SOURCES.md','literature/RESEARCH-RECONCILIATION.md',
        'literature/OPEN-PROBLEMS.md','literature/open-problems.html','literature/open-problem-summary.json',
        'planning/CURRENT-DIFFICULTY.md','planning/current-difficulty.html','scripts/integrate_owner_lift_literature.py']
    files += [str(p.relative_to(ROOT)) for p in (ROOT/REPORT).glob('*') if p.is_file() and p.name not in ('validation.json','inventory.json')]
    write(REPORT/'inventory.json',dict(status='SOURCE_ACCOUNTING_INVENTORY',files={p:sha(p) for p in sorted(files)},
        author_owned_sources_local_only={r['local_file']:r['sha256'] for r in manifest.values() if r['paper_id'] in index and r['paper_id'] in [s[0] for s in SOURCES]}))
    receipt=dict(status='PASS_OWNER_LIFT_SOURCE_ACCOUNTING' if all(r['exit_code']==0 for r in results[:-1]) else 'VALIDATION_FAILURE_PRESERVED',
        priority=os.getpriority(os.PRIO_PROCESS,0),thread_environment={k:os.environ[k] for k in ('OMP_NUM_THREADS','OPENBLAS_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS')},
        scripts=results,source_specific_checks='Four source hashes/text hashes, exact delta, occurrence lines, null-versus-zero counts, unassessed statuses, known-resolution exclusions and six preserved Lean completions checked.',
        supplemental_preexisting_failures=preexisting,
        final_cohort=acc['final_cohort'],inventory_sha256=sha(REPORT/'inventory.json'),
        omitted='No theorem/Lean rebuild, new solver, current-resolution proof, C16 claim change, publication or GitHub write.',
        provenance='Raw HTML/XML/text are ignored local files; portable metadata hashes remain committed-source candidates.')
    write(REPORT/'validation.json',receipt)
    assert receipt['status']=='PASS_OWNER_LIFT_SOURCE_ACCOUNTING'

if __name__ == '__main__':
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19, 'Research process must run at nice19'
    for key in ('OMP_NUM_THREADS', 'OPENBLAS_NUM_THREADS', 'MKL_NUM_THREADS', 'VECLIB_MAXIMUM_THREADS'):
        os.environ[key] = '1'
    parser = argparse.ArgumentParser(); parser.add_argument('action', choices=['acquire', 'integrate','validate'])
    args = parser.parse_args()
    {'acquire': acquire, 'integrate': integrate, 'validate':validate}[args.action]()
